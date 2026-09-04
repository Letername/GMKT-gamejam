extends SceneTree

var failed := false


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame
	_assert(main_scene.team_intro_active, "The Foundry Eight intro should start before the menu.")
	_assert(main_scene.team_intro_video != null and main_scene.team_intro_video.is_playing(), "The intro video should be playing.")

	for _frame in range(240):
		await process_frame
	var capture_dir := _capture_directory()
	if capture_dir != "":
		DirAccess.make_dir_recursive_absolute(capture_dir)
		var intro_image := root.get_texture().get_image()
		intro_image.save_png(capture_dir.path_join("intro-playing.png"))

	if "--natural-finish" in OS.get_cmdline_user_args():
		for _frame in range(850):
			if not main_scene.team_intro_active:
				break
			await process_frame
	else:
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.position = Vector2(640, 360)
		click.pressed = true
		main_scene._input(click)
		_assert(main_scene.team_intro_fading_out, "Clicking the intro should begin its polished fade-out.")
		# Headless test frames can advance with near-zero delta, so drive the
		# release fade with a deterministic 50 Hz timestep.
		for _frame in range(30):
			if main_scene.team_intro_active:
				main_scene._update_team_intro(0.02)
			await process_frame
	_assert(not main_scene.team_intro_active, "The intro should hand off to the menu after playing or being skipped.")
	_assert(main_scene.phase == main_scene.Phase.MENU, "Skipping the intro should keep the game on the main menu.")
	_assert(main_scene.menu_music_player != null and main_scene.menu_music_player.playing, "The intro should crossfade into the menu music.")
	for _frame in range(20):
		await process_frame
	if capture_dir != "":
		var menu_image := root.get_texture().get_image()
		menu_image.save_png(capture_dir.path_join("intro-skipped-menu.png"))

	main_scene.queue_free()
	main_scene = null
	for _cleanup_frame in range(10):
		await process_frame
	quit(1 if failed else 0)


func _capture_directory() -> String:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			return argument.trim_prefix("--capture-dir=")
	return ""


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	failed = true
	push_error(message)
