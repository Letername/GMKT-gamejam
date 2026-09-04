extends SceneTree

var failed := false


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame

	_assert(main_scene.phase == main_scene.Phase.MENU, "Game should open on the menu screen.")
	_assert(main_scene.house_texture != null, "The intact house artwork should load.")
	_assert(main_scene.house_broken_1_texture != null, "The first damaged house artwork should load.")
	_assert(main_scene.house_broken_2_texture != null, "The severe house artwork should load.")
	_assert(main_scene.player_idle_left_1_texture != null and main_scene.player_idle_left_2_texture != null, "Bob's left idle animation should load.")
	_assert(main_scene.player_idle_right_1_texture != null and main_scene.player_idle_right_2_texture != null, "Bob's right idle animation should load.")
	_assert(main_scene.IRS_BRUTE_DRAW_SIZE.y > main_scene.IRS_ROBOT_DRAW_SIZE.y, "The IRS brute should remain larger than the regular robot.")
	main_scene.house_damage_stage = 0
	_assert(main_scene._current_house_texture() == main_scene.house_texture, "An intact house should use the clean artwork.")
	main_scene.house_damage_stage = 1
	_assert(main_scene._current_house_texture() == main_scene.house_broken_1_texture, "The first hit should use damage state one.")
	main_scene.house_damage_stage = 2
	_assert(main_scene._current_house_texture() == main_scene.house_broken_2_texture, "The second hit should use the severe damage state.")
	main_scene.house_damage_stage = main_scene.HOUSE_MAX_DAMAGE_STAGES
	_assert(main_scene._current_house_texture() == main_scene.house_broken_2_texture, "A breached house should keep the severe damage artwork.")
	main_scene.house_damage_stage = 0

	main_scene._start_new_game()
	await process_frame
	_assert(main_scene.phase == main_scene.Phase.BUILD, "Starting a run should enter build phase.")
	_assert(main_scene.tutorial_visible, "The guided tutorial should be visible at the start of a run.")
	_assert(not main_scene.tutorial_moved and not main_scene.tutorial_got_wood and not main_scene.tutorial_got_stone and not main_scene.tutorial_built_once, "Tutorial objectives should start incomplete.")
	_assert(main_scene.countdown <= main_scene.BUILD_PHASE_DURATION and main_scene.countdown > main_scene.BUILD_PHASE_DURATION - 1.0, "Build phase should start at the configured duration.")

	main_scene.wood = main_scene.ARROW_TURRET_WOOD_COST
	main_scene.selected_cell = main_scene.LEFT_BUILD_YARD[0]
	main_scene._try_place_structure(main_scene.StructureType.TURRET)
	_assert(main_scene.structures.size() == 1, "Arrow turret should place successfully on a build-yard cell.")
	main_scene.wood = main_scene.TURRET_UPGRADE_1_WOOD_COST
	main_scene.stone = main_scene.TURRET_UPGRADE_1_STONE_COST
	main_scene._try_upgrade_turret()
	_assert(int(main_scene.structures[main_scene._cell_key(main_scene.LEFT_BUILD_YARD[0])]["level"]) == 2, "Turret upgrade should raise the selected turret to level 2.")

	main_scene.wood = main_scene.WALL_LIGHT_WOOD_COST
	var wall_cell: Vector2i = main_scene.LEFT_BUILD_YARD[12]
	main_scene.selected_cell = wall_cell
	main_scene._try_place_structure(main_scene.StructureType.WALL_LIGHT)
	_assert(main_scene.structures.size() == 2, "Light wall should place on an outlined yard cell.")

	main_scene._start_defend_phase()
	_assert(main_scene.phase == main_scene.Phase.DEFEND, "Wave should start from the build phase.")

	main_scene.spawn_queue.clear()
	main_scene.spawn_queue.append({
		"time": 0.0,
		"lane": "left",
		"type": "runner",
		"hp": 3,
		"speed": 0.0,
		"damage": 1
	})
	main_scene.enemy_spawn_index = 0
	main_scene.next_enemy_id = 1
	main_scene.enemies.clear()
	main_scene._spawn_enemies()
	main_scene.enemies[0]["position"] = main_scene._cell_center(wall_cell) - Vector2(14, 14)
	main_scene.enemies[0]["approaching_entry"] = false
	main_scene.enemies[0]["attack_windup"] = 0.01
	main_scene.enemies[0]["attack_cooldown"] = 0.0
	main_scene._update_enemies(1.0)
	_assert(int(main_scene.structures[main_scene._cell_key(wall_cell)]["hp"]) < main_scene.WALL_LIGHT_HP, "Enemy should attack the nearest wall that seals its lane.")

	main_scene.structures.erase(main_scene._cell_key(wall_cell))
	main_scene.enemies.clear()
	main_scene.spawn_queue.clear()
	main_scene.enemy_spawn_index = 0
	main_scene.projectiles.clear()
	main_scene._update_defend_phase(0.1)
	_assert(main_scene.phase == main_scene.Phase.BUILD, "Clearing the wave should return to build phase.")
	_assert(main_scene.round_number == 2, "Surviving should increase the round number.")
	_assert(main_scene.wave_banner_text.begins_with("Tutorial Complete"), "Surviving the first wave should complete the tutorial.")

	main_scene.house_items.clear()
	main_scene.house_items.append(main_scene.PRIZED_HOUSE_ITEM)
	main_scene.stolen_house_items.clear()
	main_scene.trophy_stolen = false
	main_scene.phase = main_scene.Phase.DEFEND
	main_scene.enemies.clear()
	main_scene.enemies.append({
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
	})
	main_scene._steal_house_item(0)
	main_scene._update_defend_phase(0.1)
	_assert(main_scene.phase == main_scene.Phase.GAME_OVER, "Losing the KFZ console should trigger game over.")

	main_scene.queue_free()
	main_scene = null
	for _cleanup_frame in range(10):
		await process_frame
	quit(1 if failed else 0)


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	failed = true
	push_error(message)
