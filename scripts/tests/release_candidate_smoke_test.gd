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
	game.set_process(false)
	assert(not game.get_tree().auto_accept_quit, "Windows close requests must use the graceful audio-release path.")

	_verify_art_provenance(game)
	_verify_procedural_audio(game)
	_verify_music_boundaries_and_gameplay_playlist(game)
	_verify_controller_bindings(game)
	await _verify_menu_focus(game)
	await _verify_button_motion_contract(game)
	await _verify_polish_settings_surface(game)
	_verify_rapid_menu_and_cancel(game)
	_verify_polish_gameplay_contracts(game)
	_verify_persistence_round_trip(game)
	await _verify_dealer_controller_and_modal(game)
	_verify_resize_contract(game)

	game.queue_free()
	for _cleanup_frame in range(10):
		await process_frame
	print("RELEASE_CANDIDATE_SMOKE_PASS")
	quit()


func _verify_art_provenance(game: Node) -> void:
	var texture_property_names := [
		"player_body_texture", "player_idle_left_1_texture", "player_idle_left_2_texture",
		"player_idle_right_1_texture", "player_idle_right_2_texture", "player_run_1_texture",
		"player_run_2_texture", "player_run_3_texture", "player_run_4_texture", "player_run_5_texture",
		"team_logo_texture", "turret_sprite_texture", "cannon_turret_texture", "golden_turret_texture",
		"gun_sentry_top_texture", "gun_sentry_bottom_texture", "majestic_sentry_top_texture",
		"majestic_sentry_bottom_texture", "arrow_projectile_texture", "cannonball_projectile_texture",
		"healing_fountain_texture", "crystal_sentry_texture", "laser_projectile_texture",
		"arms_dealer_texture", "energy_drink_texture", "menu_background_texture", "menu_ui_texture",
		"loss_screen_texture", "backyard_fence_texture", "cave_boss_texture", "cave_boss_walk_1_texture",
		"cave_boss_walk_2_texture", "cave_boss_walk_3_texture", "decor_sprite_texture", "forest_tree_texture",
		"forest_dog_texture", "forest_beaver_texture", "tree_trunk_texture", "irs_robot_texture",
		"irs_robot_walk_1_texture", "irs_robot_walk_2_texture", "irs_robot_walk_3_texture",
		"irs_agent_body_texture", "irs_agent_gun_texture", "swat_texture", "rock_big_texture",
		"rock_medium_texture", "rock_small_texture", "iron_ore_texture", "gold_ore_texture",
		"gunpowder_ore_texture", "cave_miner_walk_1_texture", "cave_miner_walk_2_texture",
		"cave_miner_walk_3_texture", "cave_entrance_texture", "wrench_texture", "player_sword_texture",
		"shield_left_idle_texture", "shield_left_block_texture", "shield_right_idle_texture",
		"shield_right_block_texture", "house_texture", "house_broken_1_texture", "house_broken_2_texture",
		"gun_turret_texture", "grass_tile_texture", "wall_light_texture", "wall_medium_texture",
		"wall_heavy_texture", "countdown_numbers_texture", "heart_icon_texture", "inventory_icon_texture",
		"inventory_full_icon_texture", "tax_papers_texture", "mug_texture", "trophy_texture",
		"couch_coins_texture", "kfz_console_texture", "family_photo_texture"
	]
	for property_name in texture_property_names:
		var texture: Texture2D = game.get(property_name) as Texture2D
		assert(texture != null, "Required release texture is missing: %s" % property_name)
		var path: String = texture.resource_path
		var approved: bool = path.begins_with("res://Art/") or path.begins_with("res://assets/runtime/") or path == "res://assets/team_logo.png"
		assert(approved, "Unapproved art source reached the release loader: %s" % path)
	for frame in game.menu_background_frames:
		assert(frame != null and frame.resource_path.begins_with("res://assets/runtime/"), "Menu motion frames must be approved team-art derivatives.")
	for required_runtime_path in [
		"res://assets/runtime/menu_background.png", "res://assets/runtime/bob_run_1.png",
		"res://assets/runtime/irs_runner_1.png", "res://assets/runtime/house.png",
		"res://assets/runtime/gun_sentry_head.png", "res://assets/runtime/magic_sentry_head.png"
	]:
		assert(ResourceLoader.exists(required_runtime_path), "Required team-art derivative is missing: %s" % required_runtime_path)


func _verify_procedural_audio(game: Node) -> void:
	for property_name in ["ui_click_sound", "ui_hover_sound", "pickup_sound", "build_sound", "warning_sound", "impact_sound", "step_grass_sound", "step_wood_sound", "step_cave_sound"]:
		var stream: AudioStreamWAV = game.get(property_name) as AudioStreamWAV
		assert(stream != null and stream.data.size() > 100, "Procedural sound is missing or empty: %s" % property_name)
	assert(game.sfx_players.size() == 16, "The release SFX pool must handle dense combat without cutting every sound off.")


func _verify_music_boundaries_and_gameplay_playlist(game: Node) -> void:
	assert(game.menu_music_stream != null, "The menu track must load separately.")
	if game.menu_music_stream is AudioStreamMP3:
		assert(not game.menu_music_stream.loop, "The menu track import must remain explicit and predictable.")
	assert(game.gameplay_music_streams.size() == 3, "Only the three overworld tracks belong in the gameplay playlist.")
	assert(game.GAMEPLAY_MUSIC_TITLES == ["A risky trek.", "Spaceflight", "we. all. lain."], "The gameplay playlist order changed unexpectedly.")
	for stream in game.gameplay_music_streams:
		assert(stream != null, "Every gameplay-playlist track must load.")
		if stream is AudioStreamMP3:
			assert(not stream.loop, "Gameplay tracks must finish instead of looping individually.")
	game.phase = game.Phase.MENU
	game.gameplay_music_track_index = 0
	game.menu_music_player.stop()
	game.gameplay_music_player.stop()
	game._update_menu_music(0.016)
	game._update_gameplay_music()
	assert(game.menu_music_player.playing and not game.gameplay_music_player.playing, "Only menu music may play on the menu.")
	game.phase = game.Phase.BUILD
	game.inside_cave = false
	game._update_menu_music(0.016)
	game._update_gameplay_music()
	assert(not game.menu_music_player.playing, "Menu music must stop as soon as gameplay begins.")
	assert(game.gameplay_music_track_index == 0 and game.gameplay_music_player.playing and game.gameplay_music_player.stream == game.gameplay_music_streams[0], "Gameplay must begin with A risky trek instead of carrying menu music into the run.")
	game.round_number = 9
	game._on_gameplay_music_finished()
	assert(game.gameplay_music_track_index == 1 and game.gameplay_music_player.stream == game.gameplay_music_streams[1] and game.gameplay_music_player.playing, "A finished gameplay song must advance immediately without a round gate.")
	game.inside_cave = true
	game._update_gameplay_music()
	assert(game.gameplay_music_player.stream_paused, "Cave music must pause the gameplay playlist without losing its position.")
	game.inside_cave = false
	game._update_gameplay_music()
	assert(not game.gameplay_music_player.stream_paused and game.gameplay_music_track_index == 1, "Leaving the cave must resume the same gameplay track.")
	game.phase = game.Phase.MENU
	game._update_menu_music(0.016)
	game._update_gameplay_music()
	assert(game.menu_music_player.playing and not game.gameplay_music_player.playing, "Returning to the menu must restore only the menu track.")


func _verify_controller_bindings(_game: Node) -> void:
	for action_name in ["move_left", "move_right", "move_up", "move_down", "action", "build_arrow_turret", "repair_wall", "dealer_menu", "inventory_menu", "enter_cave", "start_wave_early"]:
		var has_controller_event := false
		for event in InputMap.action_get_events(action_name):
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				has_controller_event = true
				break
		assert(has_controller_event, "Controller mapping missing for %s." % action_name)


func _verify_menu_focus(game: Node) -> void:
	game._on_menu_credits_pressed()
	await process_frame
	await process_frame
	assert(game.menu_credits_open, "Credits must open from the main menu.")
	assert(root.gui_get_focus_owner() == game.menu_credits_back_button, "Credits must focus Back for controller and keyboard users.")
	game._close_menu_credits()
	await process_frame
	await process_frame
	assert(root.gui_get_focus_owner() == game.menu_start_button, "Closing Credits must return focus to Start.")


func _verify_button_motion_contract(game: Node) -> void:
	var button: BaseButton = game.menu_start_button
	if button.has_meta("polish_tween"):
		var active_tween: Tween = button.get_meta("polish_tween") as Tween
		if active_tween != null and active_tween.is_valid():
			active_tween.kill()
	button.scale = Vector2.ONE
	button.rotation = 0.0
	await process_frame
	var original_rect := button.get_global_rect()
	game._on_button_hovered(button, true)
	await create_timer(0.12).timeout
	assert(button.visible and button.scale.x > 1.0, "Menu hover feedback must visibly lift the focused button.")
	game._on_button_pressed_visual(button)
	await create_timer(0.07).timeout
	assert(button.visible and button.scale.x > 0.9, "Pressed feedback must never collapse or hide a button.")
	game._on_button_released_visual(button)
	await create_timer(0.24).timeout
	assert(button.visible and button.scale.distance_to(Vector2.ONE) < 0.01, "Button release must settle exactly back to its accessible size.")
	var settled_rect := button.get_global_rect()
	assert(settled_rect.position.distance_to(original_rect.position) < 1.0 and settled_rect.size.distance_to(original_rect.size) < 1.0, "Button animation must not drift its clickable region.")


func _verify_polish_settings_surface(game: Node) -> void:
	game._on_menu_settings_pressed()
	await process_frame
	assert(game.menu_settings_open and game.menu_settings_panel.visible, "Expanded Settings must open from the main menu.")
	var panel_rect: Rect2 = game.menu_settings_panel.get_global_rect()
	var required_controls: Array[Control] = [
		game.music_volume_slider, game.sfx_volume_slider, game.menu_effects_button,
		game.screen_shake_slider, game.menu_fullscreen_button, game.menu_minimal_hud_button,
		game.menu_damage_numbers_button, game.menu_low_health_button,
		game.menu_control_prompts_button, game.menu_motion_button,
		game.menu_dev_invincible_button, game.menu_dev_speed_slider,
		game.menu_dev_speed_value_label
	]
	for control in required_controls:
		assert(control != null, "Every planned polish setting must exist.")
		var control_rect := control.get_global_rect()
		assert(panel_rect.has_point(control_rect.position + Vector2.ONE), "Settings control begins outside its panel: %s" % control.name)
		assert(panel_rect.has_point(control_rect.end - Vector2.ONE), "Settings control ends outside its panel: %s" % control.name)

	game.dev_mode_enabled = false
	game._refresh_settings_buttons()
	assert(game.menu_dev_invincible_button.disabled, "Invincibility must remain locked until Dev Mode is enabled.")
	assert(not game.menu_dev_speed_slider.editable, "Simulation speed must remain locked until Dev Mode is enabled.")
	game.dev_mode_enabled = true
	game._refresh_settings_buttons()
	assert(not game.menu_dev_invincible_button.disabled, "Dev Mode must unlock invincibility.")
	assert(game.menu_dev_speed_slider.editable, "Dev Mode must unlock simulation speed.")
	assert(game.menu_dev_settings_hint_label.text.begins_with("Live run controls"), "Unlocked Dev Settings must not keep showing the locked hint.")
	assert(game.inventory_dev_invincible_button != null and not game.inventory_dev_invincible_button.disabled, "Inventory must expose invincibility while Dev Mode is active.")
	assert(game.inventory_dev_speed_slider != null and game.inventory_dev_speed_slider.editable, "Inventory must expose the Dev speed dial.")
	game._on_dev_speed_changed(275.0)
	assert(is_equal_approx(game.dev_speed_percent, 275.0) and game.menu_dev_speed_value_label.text == "275%" and game.inventory_dev_speed_value_label.text == "275%", "Both Dev speed controls must update together.")

	game.last_input_device = "keyboard"
	var joy_motion := InputEventJoypadMotion.new()
	joy_motion.axis = JOY_AXIS_LEFT_X
	joy_motion.axis_value = 0.8
	game._input(joy_motion)
	assert(game.last_input_device == "controller", "Control prompts must switch to controller after controller input.")
	var key_event := InputEventKey.new()
	key_event.keycode = KEY_F1
	key_event.pressed = true
	game._input(key_event)
	assert(game.last_input_device == "keyboard", "Control prompts must switch back after keyboard input.")

	game.dev_mode_enabled = false
	game.dev_speed_percent = 100.0
	game._refresh_settings_buttons()
	game._on_menu_settings_pressed()
	await process_frame
	assert(not game.menu_settings_open, "Settings must close cleanly after all controls are exercised.")


func _verify_polish_gameplay_contracts(game: Node) -> void:
	game.persistent_gun_sentry_unlocked = true
	game.persistent_golden_sentry_unlocked = true
	game.persistent_magic_sentry_unlocked = true
	game.persistent_shield_unlocked = true
	game._start_new_game()
	assert(game.gun_sentry_unlocked and game.golden_sentry_unlocked and game.magic_sentry_unlocked and game.shield_unlocked, "Saved unlocks must apply at the start of a new run.")

	game.minimal_hud_enabled = false
	game._refresh_hud()
	assert(game.stats_label.visible, "Detailed HUD must be available when Minimal HUD is off.")
	assert(not game.stats_label.text.contains("Wood"), "Material totals must stay hidden from the passive HUD until they are relevant.")
	game.minimal_hud_enabled = true
	game._refresh_hud()
	assert(not game.stats_label.visible, "Minimal HUD must hide the dense stats line.")

	game.hit_effects.clear()
	game.damage_numbers_enabled = false
	game._add_hit_effect(Vector2(420, 320), "-3", Color.WHITE)
	assert(game.hit_effects.is_empty(), "Damage-number setting must be able to hide combat numbers.")
	game.damage_numbers_enabled = true
	game._add_hit_effect(Vector2(420, 320), "-3", Color.WHITE)
	assert(game.hit_effects.size() == 1 and bool(game.hit_effects[0].get("damage", false)), "Enabled damage numbers must use the prominent damage treatment.")
	game.hit_effects.clear()

	game.dev_mode_enabled = true
	game.inventory_menu_open = true
	game._refresh_hud()
	assert(game.inventory_dev_invincible_button.visible and game.inventory_dev_speed_slider.visible and game.inventory_dev_speed_value_label.visible, "Dev controls must become visible inside the open inventory.")
	assert(game._music_visualizer_bands(18).size() == 18 and not game._current_main_music_title().is_empty(), "Inventory music visualizer data and its track title must always be available.")
	game.inventory_menu_open = false
	game.dev_invincible_enabled = true
	game.player_hp = 12
	assert(game._apply_player_damage(4, Vector2(420, 320)) == 0 and game.player_hp == 12, "Dev invincibility must block player damage.")
	game.dev_invincible_enabled = false
	assert(game._apply_player_damage(4, Vector2(420, 320)) == 4 and game.player_hp == 8, "Player damage must resume immediately after invincibility is disabled.")

	var sample_enemy := {
		"id": 998, "lane": "left", "type": "swat", "role": "saboteur",
		"position": Vector2(300, 300), "size": Vector2(32, 32), "formation_slot": 1
	}
	game._update_enemy_plan(sample_enemy, {"kind": "turret", "center": Vector2(700, 330)})
	assert(not sample_enemy.ai_nodes.is_empty(), "Enemy plans must expose path nodes for Dev Mode.")
	assert(String(sample_enemy.ai_target_kind) == "turret" and not String(sample_enemy.ai_thought).is_empty(), "Enemy plans must expose their target and concise reasoning.")
	assert(String(game._wave_clear_message(3)).split("\n").size() == 2, "Wave-clear celebration copy must stay in the two-line banner contract.")
	assert(String(game._wave_clear_message(1)).begins_with("Tutorial Complete"), "The first clear must celebrate tutorial completion without restoring a large checklist.")

	game.persistent_gun_sentry_unlocked = false
	game.persistent_golden_sentry_unlocked = false
	game.persistent_magic_sentry_unlocked = false
	game.persistent_shield_unlocked = true
	game.dev_mode_enabled = false
	game.dev_invincible_enabled = false
	game.player_hp = game.PLAYER_MAX_HP
	game._return_to_main_menu()


func _verify_persistence_round_trip(game: Node) -> void:
	var original_path: String = game.settings_path
	var test_path := "user://tax_season_release_test_%d.cfg" % Time.get_ticks_usec()
	game.settings_path = test_path
	game.persistence_enabled = true
	game.minimal_hud_enabled = false
	game.damage_numbers_enabled = false
	game.low_health_warning_enabled = false
	game.menu_motion_enabled = false
	game.auto_control_prompts_enabled = false
	game.tutorial_enabled = false
	game.dev_invincible_enabled = true
	game.dev_speed_percent = 325.0
	game.highest_round = 14
	game.persistent_gun_sentry_unlocked = true
	game.persistent_golden_sentry_unlocked = true
	game.persistent_magic_sentry_unlocked = true
	game.persistent_shield_unlocked = true
	game.persistent_cave_boss_defeated = true
	game._save_persistent_settings()

	var saved := ConfigFile.new()
	assert(saved.load(test_path) == OK, "Polish settings and progress must serialize to disk.")
	assert(not bool(saved.get_value("display", "minimal_hud", true)), "Minimal HUD preference must persist.")
	assert(not bool(saved.get_value("display", "damage_numbers", true)), "Damage-number preference must persist.")
	assert(not bool(saved.get_value("controls", "auto_prompts", true)), "Automatic control-prompt preference must persist.")
	assert(is_equal_approx(float(saved.get_value("developer", "speed_percent", 0.0)), 325.0), "Dev simulation speed must persist.")
	assert(int(saved.get_value("progress", "highest_round", 0)) == 14, "Highest round must persist.")
	for progress_key in ["gun_sentry_unlocked", "golden_sentry_unlocked", "magic_sentry_unlocked", "shield_unlocked", "cave_boss_defeated"]:
		assert(bool(saved.get_value("progress", progress_key, false)), "Persistent progress field is missing: %s" % progress_key)

	game.minimal_hud_enabled = true
	game.damage_numbers_enabled = true
	game.auto_control_prompts_enabled = true
	game.highest_round = 1
	game.persistent_cave_boss_defeated = false
	game._load_persistent_settings()
	assert(not game.minimal_hud_enabled and not game.damage_numbers_enabled and not game.auto_control_prompts_enabled, "Saved accessibility preferences must reload.")
	assert(game.highest_round == 14 and game.persistent_cave_boss_defeated, "Saved progression must reload.")

	DirAccess.remove_absolute(ProjectSettings.globalize_path(test_path))
	game.settings_path = original_path
	game.persistence_enabled = false
	game.minimal_hud_enabled = true
	game.damage_numbers_enabled = true
	game.low_health_warning_enabled = true
	game.menu_motion_enabled = true
	game.auto_control_prompts_enabled = true
	game.tutorial_enabled = true
	game.dev_invincible_enabled = false
	game.dev_speed_percent = 100.0
	game.highest_round = 1
	game.persistent_gun_sentry_unlocked = false
	game.persistent_golden_sentry_unlocked = false
	game.persistent_magic_sentry_unlocked = false
	game.persistent_shield_unlocked = true
	game.persistent_cave_boss_defeated = false


func _verify_rapid_menu_and_cancel(game: Node) -> void:
	for toggle_index in range(12):
		game._on_menu_settings_pressed()
	assert(not game.menu_settings_open, "An even burst of Settings presses must return to a closed state.")
	game._on_menu_settings_pressed()
	assert(game.menu_settings_open, "Settings must still open after rapid input.")
	var cancel_event := InputEventJoypadButton.new()
	cancel_event.button_index = JOY_BUTTON_B
	cancel_event.pressed = true
	game._input(cancel_event)
	assert(not game.menu_settings_open, "Controller B must close Settings.")

	game._start_new_game()
	game.inventory_menu_open = true
	game._input(cancel_event)
	assert(not game.inventory_menu_open and not game.escape_confirm_open, "Controller B must close inventory before opening the escape confirmation.")
	game.build_menu_open = true
	game._input(cancel_event)
	assert(not game.build_menu_open and not game.escape_confirm_open, "Controller B must close the build menu first.")
	game._input(cancel_event)
	assert(game.escape_confirm_open, "Controller B must open the safe leave-run confirmation during gameplay.")
	var accept_event := InputEventJoypadButton.new()
	accept_event.button_index = JOY_BUTTON_A
	accept_event.pressed = true
	game._input(accept_event)
	assert(game.phase == game.Phase.MENU, "Controller A must accept the return-to-menu confirmation.")


func _verify_dealer_controller_and_modal(game: Node) -> void:
	game._start_new_game()
	game.dev_mode_enabled = true
	game.dealer_menu_open = true
	game.dealer_page = "buy"
	game.dealer_selected_index = 0
	game.countdown = 10.0
	var dealer_panel: Rect2 = game._dealer_panel_rect()
	var dealer_detail_rect := Rect2(dealer_panel.position + Vector2(24, 456), Vector2(884, 46))
	var dealer_card_rects: Array[Rect2] = []
	for item_index in range(game._dealer_items("buy").size()):
		var card_rect: Rect2 = game._dealer_item_rect(dealer_panel, item_index)
		assert(dealer_panel.encloses(card_rect), "Every dealer product card must remain inside the compact panel.")
		assert(not card_rect.intersects(dealer_detail_rect), "Dealer detail text must never overlap a product card.")
		for existing_rect in dealer_card_rects:
			assert(not card_rect.intersects(existing_rect), "Dealer product cards must never overlap each other.")
		dealer_card_rects.append(card_rect)

	Input.action_press("move_right")
	game._update_dealer_controller_input()
	Input.action_release("move_right")
	assert(game.dealer_selected_index == 1, "Dealer controller navigation must advance the selected card.")
	await process_frame
	Input.action_press("move_down")
	game._update_dealer_controller_input()
	Input.action_release("move_down")
	assert(game.dealer_selected_index == 3, "Dealer down navigation must follow the new readable two-column layout.")
	await process_frame

	Input.action_press("build_arrow_turret")
	game._update_dealer_controller_input()
	Input.action_release("build_arrow_turret")
	assert(game.dealer_page == "sell" and game.dealer_selected_index == 0, "Controller Y must switch dealer tabs and reset selection.")
	await process_frame

	game.dealer_page = "buy"
	game.dealer_selected_index = 4
	var wood_before: int = game.wood
	Input.action_press("action")
	game._update_dealer_controller_input()
	Input.action_release("action")
	assert(game.wood > wood_before, "Controller A must activate the selected dealer card.")
	await process_frame

	Input.action_press("start_wave_early")
	game._process(0.016)
	Input.action_release("start_wave_early")
	assert(game.phase == game.Phase.BUILD and game.dealer_menu_open, "Dealer modal must block hidden start-wave input.")
	assert(game.countdown < 10.0, "Build time must remain honest while the dealer is open.")
	await process_frame

	game.countdown = 0.01
	game._process(0.02)
	assert(game.phase == game.Phase.DEFEND and not game.dealer_menu_open, "An expired build timer must close the dealer and start the wave safely.")


func _verify_resize_contract(_game: Node) -> void:
	assert(int(ProjectSettings.get_setting("display/window/size/viewport_width")) == 1280, "Release viewport width changed unexpectedly.")
	assert(int(ProjectSettings.get_setting("display/window/size/viewport_height")) == 720, "Release viewport height changed unexpectedly.")
	assert(String(ProjectSettings.get_setting("display/window/stretch/mode")) == "canvas_items", "Canvas stretch must protect layout at other window sizes.")
