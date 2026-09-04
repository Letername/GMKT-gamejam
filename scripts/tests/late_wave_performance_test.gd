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
	game.phase = game.Phase.DEFEND
	game.round_number = 20
	game.dev_mode_enabled = true
	game.player_position = Vector2(620, 180)

	game.structures.clear()
	for sentry_index in range(28):
		var cell := Vector2i(4 + posmod(sentry_index, 16), 4 + posmod(int(floor(float(sentry_index) / 16.0)), 2) * 4)
		var weapon_names := ["arrow", "cannon", "gun", "golden", "magic"]
		var weapon: String = weapon_names[posmod(sentry_index, weapon_names.size())]
		game.structures[game._cell_key(cell)] = {
			"type": game.StructureType.TURRET, "cell": cell, "weapon": weapon,
			"cooldown": 0.0, "aim_direction": Vector2.RIGHT, "visual_aim_angle": 0.0,
			"has_target": false, "target_id": -1, "level": 3, "flash_timer": 0.0,
			"ammo": 9999, "max_ammo": 9999, "hp": 999, "max_hp": 999,
			"build_time": 0.0, "build_total": game.TURRET_BUILD_TIME
		}

	game.enemies.clear()
	for enemy_index in range(180):
		var enemy_type := "runner"
		if posmod(enemy_index, 7) == 0:
			enemy_type = "brute"
		elif posmod(enemy_index, 11) == 0:
			enemy_type = "swat"
		var lane := "left" if posmod(enemy_index, 2) == 0 else "right"
		game.enemies.append({
			"id": enemy_index + 1, "lane": lane, "type": enemy_type,
			"role": game._enemy_role_for(enemy_type, enemy_index),
			"position": Vector2(160 + posmod(enemy_index * 47, 940), 210 + posmod(enemy_index * 31, 250)),
			"size": Vector2(34, 34) if enemy_type == "brute" else Vector2(30, 30),
			"hp": 999, "max_hp": 999, "speed": 82.0, "damage": 2,
			"approaching_entry": false, "entry_target": Vector2.ZERO,
			"attack_cooldown": 0.0, "attack_windup": 0.0, "flash_timer": 0.0,
			"wander_offset": float(posmod(enemy_index * 13, 48) - 24),
			"anim_phase": float(enemy_index) * 0.1, "spawn_anim": 0.0,
			"squad_id": int(floor(float(enemy_index) / 3.0)), "formation_slot": posmod(enemy_index, 3) - 1,
			"decision_timer": 0.2, "lane_switch_cooldown": 2.0, "focus_player": false,
			"dodge_timer": 0.0, "dodge_cooldown": 1.0, "dodge_direction": Vector2.ZERO
		})

	var start_usec: int = Time.get_ticks_usec()
	var enemy_usec := 0
	var turret_usec := 0
	var projectile_usec := 0
	var effects_usec := 0
	for frame_index in range(240):
		var delta := 1.0 / 60.0
		var section_start := Time.get_ticks_usec()
		game._update_player_combat_state(delta)
		game._update_enemies(delta)
		enemy_usec += Time.get_ticks_usec() - section_start
		section_start = Time.get_ticks_usec()
		game._update_turrets(delta)
		turret_usec += Time.get_ticks_usec() - section_start
		section_start = Time.get_ticks_usec()
		game._update_projectiles(delta)
		projectile_usec += Time.get_ticks_usec() - section_start
		section_start = Time.get_ticks_usec()
		game._update_explosion_effects(delta)
		game._update_motion_effects(delta)
		effects_usec += Time.get_ticks_usec() - section_start
	var elapsed_usec: int = Time.get_ticks_usec() - start_usec
	var average_frame_ms: float = float(elapsed_usec) / 240.0 / 1000.0
	print("LATE_WAVE_PROFILE enemy=%.3f turret=%.3f projectile=%.3f effects=%.3f" % [float(enemy_usec) / 240000.0, float(turret_usec) / 240000.0, float(projectile_usec) / 240000.0, float(effects_usec) / 240000.0])
	var failed := false
	if average_frame_ms >= 35.0:
		failed = true
		push_error("Late-wave simulation exceeded the 35 ms CPU budget: %.2f ms" % average_frame_ms)
	if game.motion_effects.size() > 360:
		failed = true
		push_error("High-quality particle cap must hold in dense waves.")

	game._sync_visual_nodes()
	if game.enemy_visual_nodes.size() != game.enemies.size():
		failed = true
		push_error("Every live late-wave enemy needs one visual node.")
	while game.enemies.size() > 90:
		game.enemies.remove_at(game.enemies.size() - 1)
	game._sync_visual_nodes()
	if game.enemy_visual_nodes.size() != 90:
		failed = true
		push_error("Enemy visual-node cache must discard stale late-wave entries.")

	game.queue_free()
	game = null
	for _cleanup_frame in range(10):
		await process_frame
	if failed:
		print("LATE_WAVE_PERFORMANCE_FAIL avg_ms=%.3f enemies=180 sentries=28" % average_frame_ms)
		quit(1)
	else:
		print("LATE_WAVE_PERFORMANCE_PASS avg_ms=%.3f enemies=180 sentries=28" % average_frame_ms)
		quit()
