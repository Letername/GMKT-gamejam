extends SceneTree

const CAPTURE_SIZE := Vector2i(1280, 720)

var capture_dir := "user://ui-captures"
var capture_menu_only := false


func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			capture_dir = argument.trim_prefix("--capture-dir=")
		elif argument == "--menu-only":
			capture_menu_only = true
	call_deferred("_run")


func _run() -> void:
	root.size = CAPTURE_SIZE
	DirAccess.make_dir_recursive_absolute(capture_dir)
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame
	main_scene.persistence_enabled = false
	if main_scene.team_intro_active:
		main_scene._finish_team_intro()
		await process_frame
	main_scene.tutorial_enabled = true
	main_scene.set_process(false)
	for menu_phase_index in range(main_scene.menu_background_frames.size() * 2):
		main_scene.world_time = (float(menu_phase_index) * 0.5) / main_scene.MENU_BACKGROUND_FRAME_RATE + 0.001
		await _capture(main_scene, "01-menu-phase-%02d" % (menu_phase_index + 1))
	main_scene.set_process(true)
	main_scene._on_menu_tutorial_pressed()
	assert(not main_scene.tutorial_enabled, "The guided tutorial should be optional from the menu.")
	main_scene._on_menu_tutorial_pressed()
	assert(main_scene.tutorial_enabled, "The tutorial toggle should be reversible before starting a run.")
	main_scene.menu_settings_open = true
	await _capture(main_scene, "01b-menu-settings")
	main_scene.dev_mode_enabled = true
	main_scene._refresh_settings_buttons()
	await _capture(main_scene, "01e-menu-settings-dev")
	main_scene.dev_mode_enabled = false
	main_scene._refresh_settings_buttons()
	main_scene.menu_settings_open = false
	main_scene.menu_credits_open = true
	var credit_link_count := 0
	for credit_child in main_scene.menu_credits_panel.get_children():
		if credit_child is LinkButton:
			credit_link_count += 1
	assert(credit_link_count == main_scene.MUSIC_CREDIT_LINKS.size() + main_scene.SFX_CREDIT_LINKS.size(), "Credits should include a clickable link for every music and sound asset.")
	var team_logo_node: TextureRect = main_scene.menu_credits_panel.get_node_or_null("FoundryEightLogo") as TextureRect
	assert(team_logo_node != null and team_logo_node.texture != null, "Credits should include the actual team logo image.")
	var team_credit_text := ""
	for credit_child in main_scene.menu_credits_panel.get_children():
		if credit_child is Label:
			team_credit_text += credit_child.text + "\n"
	for team_credit_line in main_scene.TEAM_CREDIT_LINES:
		assert(team_credit_text.contains(String(team_credit_line)), "Credits should list team member: %s" % String(team_credit_line))
	await _capture(main_scene, "01c-menu-credits")
	main_scene.menu_credits_open = false
	main_scene._on_menu_dev_pressed()
	main_scene._refresh_hud()
	assert(main_scene.dev_mode_prompt_open and main_scene.menu_dev_panel.visible, "The normal menu should expose the protected Dev Tools PIN panel.")
	await _capture(main_scene, "01d-menu-dev-tools")
	main_scene._close_dev_mode_prompt()
	main_scene._refresh_hud()
	if capture_menu_only:
		main_scene.queue_free()
		main_scene = null
		for _cleanup_frame in range(10):
			await process_frame
		quit()
		return

	main_scene._start_new_game()
	main_scene.wave_banner_timer = 0.0
	main_scene._refresh_hud()
	assert(not main_scene.hint_label.visible, "The bottom gameplay controls bar should stay hidden during build phase.")
	await _capture(main_scene, "02-build-tutorial")
	main_scene.last_input_device = "controller"
	await _capture(main_scene, "02a-build-controller-prompts")
	main_scene.last_input_device = "keyboard"
	main_scene._enter_house()
	main_scene._sanitize_location_state()
	main_scene._sync_visual_nodes()
	assert(main_scene.inside_house, "Entering the house should remain active instead of being cleared on the next frame.")
	assert(main_scene.player_visual_node.visible, "Bob should be visible inside the house.")
	await _capture(main_scene, "02b-house-interior")
	main_scene._leave_house()
	assert(not main_scene.inside_house, "Leaving the house should return Bob to the yard.")
	main_scene.world_time = 0.0
	assert(main_scene._current_player_idle_texture(true) == main_scene.player_idle_right_1_texture, "Bob's left-facing idle should use the artwork that visually faces left.")
	assert(main_scene._current_player_idle_texture(false) == main_scene.player_idle_left_1_texture, "Bob's right-facing idle should use the artwork that visually faces right.")
	Input.action_press("move_left")
	await _capture(main_scene, "02c-bob-walk-left")
	Input.action_release("move_left")
	await process_frame
	Input.action_press("move_right")
	await _capture(main_scene, "02d-bob-walk-right")
	Input.action_release("move_right")
	await process_frame

	main_scene.tutorial_moved = true
	main_scene.tutorial_got_wood = true
	main_scene.tutorial_got_stone = true
	main_scene.tutorial_built_once = true
	await _capture(main_scene, "03-build-ready")

	main_scene.build_menu_open = true
	main_scene.gun_sentry_unlocked = true
	main_scene.golden_sentry_unlocked = true
	main_scene.magic_sentry_unlocked = true
	main_scene._set_build_menu_tab("sentries")
	await _capture(main_scene, "04-build-sentries")
	main_scene._set_build_menu_tab("walls")
	await _capture(main_scene, "05-build-walls")
	main_scene.build_menu_open = false
	main_scene.dev_mode_enabled = true
	main_scene.selected_cell = main_scene.LEFT_BUILD_YARD[0]
	main_scene._try_place_structure(main_scene.StructureType.TURRET, "gun")
	var gun_key: String = main_scene._cell_key(main_scene.selected_cell)
	main_scene.structures[gun_key]["build_time"] = 0.0
	main_scene.structures[gun_key]["aim_direction"] = Vector2(1, -1).normalized()
	main_scene.selected_cell = main_scene.LEFT_BUILD_YARD[8]
	main_scene._try_place_structure(main_scene.StructureType.TURRET, "magic")
	var magic_key: String = main_scene._cell_key(main_scene.selected_cell)
	main_scene.structures[magic_key]["build_time"] = 0.0
	main_scene.structures[magic_key]["aim_direction"] = Vector2(-1, -1).normalized()
	await _capture(main_scene, "06-split-sentries")
	main_scene.selected_cell = main_scene.LEFT_BUILD_YARD[0]
	main_scene.structures[gun_key]["cooldown"] = 1.0
	main_scene.enemies.append({
		"id": 606, "lane": "left", "type": "swat", "role": "saboteur",
		"position": main_scene._cell_center(main_scene.LEFT_BUILD_YARD[0]) + Vector2(150, -20),
		"size": Vector2(32, 32), "hp": 12, "max_hp": 12, "speed": 84.0, "damage": 2,
		"approaching_entry": false, "entry_target": Vector2.ZERO,
		"attack_cooldown": 0.0, "attack_windup": 0.0, "flash_timer": 0.0,
		"wander_offset": 0.0, "anim_phase": 0.0, "spawn_anim": 0.0,
		"squad_id": 0, "formation_slot": 0, "decision_timer": 1.0,
		"lane_switch_cooldown": 2.0, "focus_player": false,
		"dodge_timer": 0.0, "dodge_cooldown": 1.0, "dodge_direction": Vector2.ZERO
	})
	main_scene._update_turrets(0.016)
	assert(int(main_scene.structures[gun_key].get("target_id", -1)) == 606, "Selected sentry should expose its current target for readable feedback.")
	await _capture(main_scene, "06c-sentry-target-feedback")
	main_scene._update_enemy_plan(main_scene.enemies[0], main_scene._enemy_target_info(main_scene.enemies[0]))
	assert(not Array(main_scene.enemies[0].get("ai_nodes", [])).is_empty(), "Dev AI display needs a real navigation plan.")
	await _capture(main_scene, "06d-dev-ai-planning")
	main_scene.enemies.clear()
	main_scene.projectiles.clear()
	main_scene.dev_mode_enabled = false
	main_scene.gun_sentry_unlocked = false
	main_scene.golden_sentry_unlocked = false
	main_scene.magic_sentry_unlocked = false

	main_scene.dealer_menu_open = true
	main_scene._refresh_hud()
	await _capture(main_scene, "06-dealer")
	main_scene.dealer_page = "sell"
	main_scene.dealer_selected_index = 0
	await _capture(main_scene, "06a-dealer-sell")
	main_scene.dealer_page = "buy"
	main_scene.dev_mode_enabled = true
	main_scene._purchase_dealer_item("energy_drink")
	assert(is_equal_approx(main_scene.energy_drink_timer, main_scene.ENERGY_DRINK_DURATION), "Buying an energy drink should start its full speed boost.")
	main_scene._update_player_combat_state(1.0)
	assert(is_equal_approx(main_scene.energy_drink_timer, main_scene.ENERGY_DRINK_DURATION), "The boost should pause while the dealer is open.")
	main_scene.dealer_menu_open = false
	main_scene._update_player_combat_state(1.0)
	assert(is_equal_approx(main_scene.energy_drink_timer, main_scene.ENERGY_DRINK_DURATION - 1.0), "The boost should count down during active play.")
	await _capture(main_scene, "06b-energy-drink")
	main_scene.energy_drink_timer = 0.0
	main_scene.dev_mode_enabled = false
	main_scene._on_music_volume_changed(37.0)
	main_scene._on_sfx_volume_changed(64.0)
	main_scene.inventory_menu_open = true
	main_scene._refresh_hud()
	assert(is_equal_approx(main_scene.inventory_music_volume_slider.value, 37.0), "The inventory music slider should stay synced with the music volume.")
	assert(is_equal_approx(main_scene.inventory_sfx_volume_slider.value, 64.0), "The inventory SFX slider should stay synced with the sound volume.")
	await _capture(main_scene, "07-inventory")
	main_scene.dev_mode_enabled = true
	main_scene.dev_invincible_enabled = false
	main_scene._on_dev_speed_changed(225.0)
	main_scene._refresh_hud()
	assert(main_scene.inventory_dev_invincible_button.visible and main_scene.inventory_dev_speed_slider.visible, "Dev inventory controls should be visible for capture.")
	await _capture(main_scene, "07b-inventory-dev")
	main_scene.dev_mode_enabled = false
	main_scene.dev_speed_percent = 100.0
	main_scene._refresh_hud()
	main_scene.inventory_menu_open = false
	main_scene._on_music_volume_changed(100.0)
	main_scene._on_sfx_volume_changed(100.0)

	main_scene.inside_cave = true
	main_scene.cave_mode_token = true
	main_scene.cave_transition_cooldown = 10.0
	main_scene.cave_room_id = "lava_forge"
	main_scene.cave_pickups_claimed.erase("move_upgrade")
	main_scene._refresh_cave_room_state()
	main_scene.cave_enemies.clear()
	main_scene.cave_player_position = Vector2(760, 360)
	await _capture(main_scene, "07b-cave-energy-upgrade")
	main_scene.inside_cave = false
	main_scene.cave_mode_token = false
	main_scene.cave_room_id = "entrance"
	main_scene._refresh_cave_room_state()

	main_scene._start_defend_phase()
	main_scene.wave_banner_timer = 0.0
	main_scene._refresh_hud()
	assert(not main_scene.hint_label.visible, "The bottom gameplay controls bar should stay hidden during defend phase.")
	await _capture(main_scene, "08-defend-tutorial")

	main_scene.set_process(false)
	main_scene.tutorial_enabled = false
	main_scene.selected_cell = main_scene.PLAYER_START_CELL
	main_scene.phase_transition_timer = 0.0
	main_scene.defend_elapsed = 18.0
	main_scene._spawn_enemies()
	for enemy_index in range(main_scene.enemies.size()):
		main_scene.enemies[enemy_index]["approaching_entry"] = false
		main_scene.enemies[enemy_index]["position"] = Vector2(360 + enemy_index * 72, 270 + posmod(enemy_index, 2) * 56)
	main_scene.hit_effects.clear()
	for effect_index in range(mini(4, main_scene.enemies.size())):
		main_scene._add_hit_effect(main_scene._enemy_center(main_scene.enemies[effect_index]), "-%d" % (4 + effect_index * 3), main_scene.UI_DANGER_ACCENT)
	for hit_effect in main_scene.hit_effects:
		hit_effect["time"] = 0.52
	main_scene._spawn_motion_burst(Vector2(610, 330), main_scene.UI_WARM_ACCENT, 18, 34.0, 110.0, false, "spark")
	main_scene._add_explosion_effect(Vector2(610, 330), 34.0, Color(1.0, 0.64, 0.24, 0.34))
	await _capture(main_scene, "08b-combat-feedback")
	main_scene.enemies.clear()
	main_scene.projectiles.clear()
	main_scene.hit_effects.clear()
	main_scene.motion_effects.clear()
	main_scene.explosion_effects.clear()
	main_scene._show_wave_banner_for(main_scene._wave_clear_message(1), 2.35)
	main_scene.wave_banner_timer = 1.85
	await _capture(main_scene, "08c-wave-clear")

	main_scene.phase = main_scene.Phase.GAME_OVER
	main_scene.tutorial_enabled = true
	main_scene.phase_transition_timer = 0.0
	main_scene.round_number = 7
	main_scene.highest_round = 9
	main_scene.run_elapsed_time = 754.0
	main_scene.run_enemies_defeated = 83
	main_scene.run_resources_gathered = 147
	main_scene.run_structures_built = 19
	main_scene.run_repairs_completed = 8
	main_scene.cave_seen_rooms = {"entrance": true, "ruin_hub": true, "mine_crossroads": true, "lava_forge": true}
	main_scene._refresh_hud()
	await _capture(main_scene, "09-game-over")
	main_scene.queue_free()
	main_scene = null
	for _cleanup_frame in range(10):
		await process_frame
	quit()


func _capture(main_scene: Node, capture_name: String) -> void:
	main_scene._sync_visual_nodes()
	main_scene._refresh_hud()
	main_scene.queue_redraw()
	for frame_index in range(4):
		await process_frame
	await create_timer(0.10).timeout
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var output_path := capture_dir.path_join("%s.png" % capture_name)
	var error := image.save_png(output_path)
	if error != OK:
		push_error("Could not save UI capture %s (error %d)." % [output_path, error])
