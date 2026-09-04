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
	game.set_process(false)

	# Movement is responsive, velocity-driven, and reset safely at location changes.
	Input.action_press("move_right")
	var start_x: float = game.player_position.x
	game._move_player(0.10)
	assert(game.player_position.x > start_x, "Bob must move immediately on the first input frame.")
	assert(game.player_move_velocity.x > 0.0 and game.player_move_velocity.x < game.PLAYER_SPEED, "Movement should accelerate instead of snapping to full speed.")
	game._sync_visual_nodes()
	assert(game.player_visual_node.visible and game.player_visual_sprite.texture != null, "Bob's artwork must remain visible while movement momentum is active.")
	Input.action_release("move_right")
	Input.action_press("move_left")
	game._move_player(0.05)
	assert(game.player_skid_timer > 0.0, "A fast reversal should trigger the short skid settle.")
	Input.action_release("move_left")
	game._enter_house()
	assert(game.player_move_velocity == Vector2.ZERO, "Entering the house must clear movement momentum.")
	game._leave_house()
	assert(game.player_move_velocity == Vector2.ZERO, "Leaving the house must clear movement momentum.")

	# Effects presets change particle density and zero shake truly disables shake.
	game.motion_effects.clear()
	game.effects_quality_high = true
	game._spawn_motion_burst(Vector2(400, 300), Color.WHITE, 10, 10.0, 20.0, false)
	var high_count: int = game.motion_effects.size()
	game.motion_effects.clear()
	game.effects_quality_high = false
	game._spawn_motion_burst(Vector2(400, 300), Color.WHITE, 10, 10.0, 20.0, false)
	assert(game.motion_effects.size() < high_count, "Low effects must emit fewer particles than High.")
	game.screen_shake_percent = 0.0
	game.camera_shake_strength = 0.0
	game._add_explosion_effect(Vector2(500, 300), 32.0, Color.WHITE)
	assert(is_zero_approx(game.camera_shake_strength), "Zero screen shake must suppress explosion shake.")

	# Smart units get roles, target high-value defenses, and sentries prioritize by weapon identity.
	game.effects_quality_high = true
	var turret_cell := Vector2i(9, 5)
	var turret_key: String = game._cell_key(turret_cell)
	game.structures[turret_key] = {
		"type": game.StructureType.TURRET, "cell": turret_cell, "weapon": "arrow",
		"level": 1, "hp": 12, "max_hp": 12, "build_time": 0.0,
		"cooldown": 0.0, "aim_direction": Vector2.RIGHT, "has_target": false,
		"ammo": 20, "max_ammo": 20, "flash_timer": 0.0
	}
	var swat := {
		"id": 700, "lane": "left", "type": "swat", "role": "saboteur",
		"position": Vector2(300, 300), "size": Vector2(32, 32), "hp": 14, "max_hp": 14,
		"speed": 90.0, "damage": 2, "focus_player": false
	}
	var swat_target: Dictionary = game._enemy_target_info(swat)
	assert(String(swat_target.get("kind", "")) == "turret", "SWAT saboteurs should hunt active sentries.")
	game._update_enemy_plan(swat, swat_target)
	assert(not swat.ai_nodes.is_empty(), "Smart units must generate visible navigation nodes.")
	assert(String(swat.ai_target_kind) == "turret", "Smart-unit planning must preserve the chosen tactical target.")
	assert(String(swat.ai_thought).contains("sentry"), "Dev thoughts must explain the saboteur's target choice.")

	game.enemies.clear()
	game.enemies.append({"id": 1, "lane": "left", "type": "runner", "position": Vector2(420, 300), "size": Vector2(28, 28), "hp": 2, "max_hp": 8, "speed": 120.0})
	game.enemies.append({"id": 2, "lane": "left", "type": "brute", "position": Vector2(440, 300), "size": Vector2(34, 34), "hp": 14, "max_hp": 14, "speed": 48.0})
	game.enemies.append({"id": 3, "lane": "left", "type": "swat", "position": Vector2(460, 300), "size": Vector2(32, 32), "hp": 12, "max_hp": 12, "speed": 95.0})
	var arrow_score_runner: float = game._turret_target_score({"weapon": "arrow"}, 0, 80.0, 200.0)
	var arrow_score_brute: float = game._turret_target_score({"weapon": "arrow"}, 1, 80.0, 200.0)
	assert(arrow_score_runner > arrow_score_brute, "Arrow sentries should prefer quick runners at equal range.")
	var cannon_cluster_score: float = game._turret_target_score({"weapon": "cannon"}, 1, 80.0, 200.0)
	assert(cannon_cluster_score > arrow_score_brute, "Cannon sentries should value clustered targets.")
	var golden_swat_score: float = game._turret_target_score({"weapon": "golden"}, 2, 80.0, 200.0)
	var golden_runner_score: float = game._turret_target_score({"weapon": "golden"}, 0, 80.0, 200.0)
	assert(golden_swat_score > golden_runner_score, "Golden sentries should prioritize SWAT targets.")

	assert(game.menu_effects_button != null and game.screen_shake_slider != null, "Settings must expose effects quality and shake controls.")

	# Run a complete accelerated combat simulation to catch target changes,
	# destroyed defenses, projectile retargeting, and empty-wave transitions.
	game._start_new_game()
	game.dev_mode_enabled = true
	game.selected_cell = game.LEFT_BUILD_YARD[0]
	game.selected_sentry_kind = "arrow"
	assert(game._try_place_structure(game.StructureType.TURRET, "arrow"), "Simulation arrow sentry should place.")
	game.selected_cell = game.RIGHT_BUILD_YARD[0]
	game.selected_sentry_kind = "cannon"
	assert(game._try_place_structure(game.StructureType.TURRET, "cannon"), "Simulation cannon sentry should place.")
	game._start_defend_phase()
	var saw_live_navigation_plan := false
	var saw_live_thought := false
	for tick in range(900):
		var simulation_delta := 0.05
		game.defend_elapsed += simulation_delta
		game._spawn_enemies()
		game._update_player_combat_state(simulation_delta)
		game._update_enemies(simulation_delta)
		for enemy in game.enemies:
			var nodes: Array = enemy.get("ai_nodes", [])
			if not nodes.is_empty() and int(enemy.get("ai_node_index", -1)) >= 0 and int(enemy.get("ai_node_index", -1)) < nodes.size():
				saw_live_navigation_plan = true
			if not String(enemy.get("ai_thought", "")).is_empty():
				saw_live_thought = true
		game._update_turrets(simulation_delta)
		game._update_projectiles(simulation_delta)
		if game.enemy_spawn_index >= game.spawn_queue.size() and game.enemies.is_empty() and game.projectiles.is_empty():
			break
	assert(game.enemy_spawn_index == game.spawn_queue.size(), "Accelerated wave should spawn its complete adaptive queue.")
	assert(game.player_hp > 0, "Coordinated enemies must not leave Bob in an invalid health state.")
	assert(saw_live_navigation_plan, "A live defense wave must exercise path-aware enemy planning.")
	assert(saw_live_thought, "A live defense wave must expose enemy reasoning for Dev Mode.")
	game.queue_free()
	for _cleanup_frame in range(10):
		await process_frame
	print("SATISFACTION_AI_SMOKE_PASS")
	quit()
