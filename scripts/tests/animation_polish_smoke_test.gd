extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	if game.team_intro_active:
		game._finish_team_intro()
		await process_frame
	game._start_new_game()
	game.wave_banner_timer = 0.0
	game.set_process(false)

	game.world_time = 0.07
	Input.action_press("move_right")
	game._move_player(0.08)
	game._sync_visual_nodes()
	assert(game.player_visual_node.visible, "Bob must remain visible while the movement polish is active.")
	assert(not game.player_visual_node.scale.is_equal_approx(Vector2.ONE), "Running must apply squash and stretch.")
	assert(not game.motion_effects.is_empty(), "Running must emit footstep motion effects.")
	Input.action_release("move_right")

	var turret_cell := Vector2i(8, 5)
	var turret_key: String = game._cell_key(turret_cell)
	game.structures[turret_key] = {
		"type": game.StructureType.TURRET,
		"cell": turret_cell,
		"cooldown": 0.0,
		"aim_direction": Vector2.RIGHT,
		"visual_aim_angle": 0.0,
		"has_target": false,
		"level": 1,
		"flash_timer": 0.0,
		"weapon": "arrow",
		"ammo": 10,
		"max_ammo": 10,
		"build_time": 0.0,
		"build_total": game.TURRET_BUILD_TIME
	}
	game.camera_position = Vector2(48, 24)
	game._sync_visual_nodes()
	var turret_visual: Node2D = game.turret_visual_nodes[turret_key]
	assert(turret_visual.position.is_equal_approx(game._cell_center(turret_cell) - game.camera_position), "Sentries must follow the camera every frame.")

	var enemy := {
		"id": 991,
		"lane": "left",
		"type": "runner",
		"position": Vector2(320, 280),
		"size": Vector2(28, 28),
		"hp": 3,
		"max_hp": 3,
		"speed": 60.0,
		"damage": 1,
		"approaching_entry": false,
		"entry_target": Vector2(320, 280),
		"attack_cooldown": 0.0,
		"attack_windup": 0.0,
		"flash_timer": 0.0,
		"wander_offset": 0.0,
		"anim_phase": 0.17,
		"spawn_anim": 0.0
	}
	game.enemies.append(enemy)
	game._sync_visual_nodes()
	var enemy_visual: Node2D = game.enemy_visual_nodes[991]
	var first_enemy_position: Vector2 = enemy_visual.position
	game.enemies[0]["position"] = Vector2(368, 280)
	game._sync_visual_nodes()
	assert(enemy_visual.position.x > first_enemy_position.x + 40.0, "Enemy artwork must follow enemy movement instead of freezing at spawn.")

	game.enemies.clear()
	game.player_attack_cooldown = 0.0
	var effects_before_swing: int = game.motion_effects.size()
	game._try_player_sword_attack()
	assert(game.player_swing_timer > 0.0, "Sword attacks must retain their authored swing animation.")
	assert(game.motion_effects.size() > effects_before_swing, "Sword attacks must add a visible slash trail.")

	var effects_before_burst: int = game.motion_effects.size()
	game._add_explosion_effect(Vector2(500, 320), 20.0, game.MAGIC_COLOR)
	assert(game.motion_effects.size() > effects_before_burst, "Impacts must emit secondary sparks.")
	assert(Color(game.explosion_effects.back()["color"]).is_equal_approx(game.MAGIC_COLOR), "Impact rings must preserve their gameplay color.")

	game._start_defend_phase()
	assert(game.phase_transition_timer > 0.0, "Phase changes must have an eased transition.")

	game.queue_free()
	game = null
	for _cleanup_frame in range(10):
		await process_frame
	print("ANIMATION_POLISH_SMOKE_PASS")
	quit()
