extends SceneTree

var failed := false


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame

	_assert(main_scene.phase == main_scene.Phase.MENU, "Game should open on the menu screen.")

	main_scene._start_new_game()
	await process_frame
	_assert(main_scene.phase == main_scene.Phase.BUILD, "Starting a run should enter build phase.")
	_assert(is_equal_approx(main_scene.countdown, main_scene.BUILD_PHASE_DURATION), "Build phase should start at the configured duration.")

	main_scene.wood = main_scene.ARROW_TURRET_WOOD_COST
	main_scene.selected_cell = main_scene.LEFT_BUILD_YARD[0]
	main_scene._try_place_structure(main_scene.StructureType.TURRET)
	_assert(main_scene.structures.size() == 1, "Arrow turret should place successfully on a build-yard cell.")
	main_scene.wood = main_scene.TURRET_UPGRADE_1_WOOD_COST
	main_scene.stone = main_scene.TURRET_UPGRADE_1_STONE_COST
	main_scene._try_upgrade_turret()
	_assert(int(main_scene.structures[main_scene._cell_key(main_scene.LEFT_BUILD_YARD[0])]["level"]) == 2, "Turret upgrade should raise the selected turret to level 2.")

	main_scene.wood = main_scene.WALL_LIGHT_WOOD_COST
	main_scene.selected_cell = main_scene.LEFT_PATH_CELLS[3]
	main_scene._try_place_structure(main_scene.StructureType.WALL_LIGHT)
	_assert(main_scene.structures.size() == 2, "Light wall should place on a path cell.")

	main_scene._start_defend_phase()
	_assert(main_scene.phase == main_scene.Phase.DEFEND, "Wave should start from the build phase.")

	main_scene.spawn_queue = [{
		"time": 0.0,
		"lane": "left",
		"type": "runner",
		"hp": 3,
		"speed": 0.0,
		"damage": 1
	}]
	main_scene.enemy_spawn_index = 0
	main_scene.next_enemy_id = 1
	main_scene.enemies.clear()
	main_scene._spawn_enemies()
	main_scene.enemies[0]["path_index"] = 3
	main_scene._update_enemies(1.0)
	_assert(int(main_scene.structures[main_scene._cell_key(main_scene.LEFT_PATH_CELLS[3])]["hp"]) < main_scene.WALL_LIGHT_HP, "Enemy should attack the wall that seals its lane.")

	main_scene.structures.erase(main_scene._cell_key(main_scene.LEFT_PATH_CELLS[3]))
	main_scene.enemies.clear()
	main_scene.spawn_queue = []
	main_scene.enemy_spawn_index = 0
	main_scene.projectiles.clear()
	main_scene._update_defend_phase(0.1)
	_assert(main_scene.phase == main_scene.Phase.BUILD, "Clearing the wave should return to build phase.")
	_assert(main_scene.round_number == 2, "Surviving should increase the round number.")

	main_scene.house_items = ["Golden Trophy"]
	main_scene.stolen_house_items.clear()
	main_scene.trophy_stolen = false
	main_scene.phase = main_scene.Phase.DEFEND
	main_scene.enemies = [{
		"id": 9,
		"lane": "left",
		"type": "runner",
		"position": main_scene._cell_center(main_scene.HOUSE_DAMAGE_CELLS[0]) - Vector2(14, 14),
		"size": Vector2(28, 28),
		"hp": 1,
		"speed": 0.0,
		"damage": 1,
		"path_index": main_scene.LEFT_PATH_CELLS.size(),
		"attack_cooldown": 0.0,
		"flash_timer": 0.0
	}]
	main_scene._update_defend_phase(0.1)
	_assert(main_scene.phase == main_scene.Phase.GAME_OVER, "Losing the golden trophy should trigger game over.")

	quit(1 if failed else 0)


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	failed = true
	push_error(message)
