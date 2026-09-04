extends SceneTree

const ALTERNATE_WINDOW_SIZE := Vector2i(1440, 900)


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(ALTERNATE_WINDOW_SIZE)
	DisplayServer.window_set_position(Vector2i(-10000, -10000))
	for _resize_frame in range(4):
		await process_frame

	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	if game.team_intro_active:
		game._finish_team_intro()
		await process_frame
	game.set_process(false)
	game._refresh_hud()
	game.queue_redraw()
	for _draw_frame in range(6):
		await process_frame
	await RenderingServer.frame_post_draw

	var image := root.get_texture().get_image()
	assert(image.get_width() > 0 and image.get_height() > 0, "Alternate-window render must produce a valid frame.")
	assert(game.menu_panel.visible and game.menu_start_button.visible and game.menu_settings_button.visible, "Primary menu controls must remain visible at an alternate window size.")
	for control in [game.menu_start_button, game.menu_settings_button, game.menu_tutorial_button, game.menu_dev_button, game.menu_credits_button]:
		var rect: Rect2 = control.get_global_rect()
		assert(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(rect), "A primary menu control escaped the logical safe area: %s" % control.name)

	var capture_directory := _capture_directory()
	if not capture_directory.is_empty():
		DirAccess.make_dir_recursive_absolute(capture_directory)
		var save_error := image.save_png(capture_directory.path_join("alternate-window-menu.png"))
		assert(save_error == OK, "Alternate-window screenshot must save successfully.")
	print("ALTERNATE_WINDOW_CAPTURE_PASS window=%dx%d render=%dx%d" % [ALTERNATE_WINDOW_SIZE.x, ALTERNATE_WINDOW_SIZE.y, image.get_width(), image.get_height()])

	game.queue_free()
	game = null
	for _cleanup_frame in range(10):
		await process_frame
	quit()


func _capture_directory() -> String:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			return argument.trim_prefix("--capture-dir=")
	return ""
