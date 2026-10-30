extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	root.size = Vector2i(1280, 720)
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	game.set_process(false)
	if not game.has_method("start_replay_recording") or not game.has_method("finish_replay_recording") or not game.has_method("start_replay_playback") or not game.has_method("seek_replay"):
		_fail("runtime replay controls are missing")
		return
	if not game.start_replay_recording(123456):
		_fail("recording did not start")
		return
	Input.action_press("build_arrow_turret")
	Input.action_press("move_right", 0.8)
	game._process(0.05)
	Input.action_release("build_arrow_turret")
	await process_frame
	for tick in range(30):
		if tick == 0:
			var tab_rect: Rect2 = game._build_menu_tab_rect(game._build_menu_panel_rect(), "walls")
			var tab_click := InputEventMouseButton.new()
			tab_click.button_index = MOUSE_BUTTON_LEFT
			tab_click.pressed = true
			tab_click.position = tab_rect.get_center()
			tab_click.global_position = tab_rect.get_center()
			game._input(tab_click)
		elif tick == 1:
			Input.action_press("build_arrow_turret")
		elif tick == 2:
			Input.action_release("build_arrow_turret")
			Input.action_press("start_wave_early")
		elif tick == 3:
			Input.action_release("start_wave_early")
		if tick == 4 or tick == 6:
			var menu_key := InputEventKey.new()
			menu_key.keycode = KEY_E
			menu_key.pressed = true
			game._input(menu_key)
		elif tick == 5:
			var menu_key_release := InputEventKey.new()
			menu_key_release.keycode = KEY_E
			menu_key_release.pressed = false
			game._input(menu_key_release)
		if tick == 10:
			var pointer_move := InputEventMouseMotion.new()
			pointer_move.position = Vector2(430, 315)
			game._input(pointer_move)
			var pointer_click := InputEventMouseButton.new()
			pointer_click.position = Vector2(430, 315)
			pointer_click.global_position = Vector2(430, 315)
			pointer_click.button_index = MOUSE_BUTTON_LEFT
			pointer_click.pressed = true
			game._input(pointer_click)
		if tick == 12:
			Input.action_press("action")
		elif tick == 13:
			Input.action_release("action")
		game._process(0.05)
		await process_frame
	Input.action_release("move_right")
	for tick in range(240):
		game._process(0.05)
		await process_frame
	var expected_hash: String = game.get_replay_state_hash()
	var expected_enemies: Array = game.enemies.duplicate(true)
	var expected_round: int = game.round_number
	var expected_phase: int = game.phase
	var encoded: PackedByteArray = game.finish_replay_recording()
	if encoded.is_empty():
		_fail("recording could not be encoded")
		return
	if not FileAccess.file_exists(game.replay_last_path) or FileAccess.get_file_as_bytes(game.replay_last_path).size() > 5 * 1024 * 1024:
		_fail("compressed replay artifact was not saved within the upload limit")
		return
	if not game.start_replay_playback(encoded):
		_fail("playback could not be loaded")
		return
	if not game.seek_replay(271):
		_fail("playback failed while seeking to the recorded end; diverged=%s tick=%d" % [game.replay_diverged, game.replay_divergence_tick])
		return
	if game.replay_diverged:
		_fail("playback reported deterministic divergence at tick %d" % game.replay_divergence_tick)
		return
	if game.get_replay_state_hash() != expected_hash:
		_fail("final gameplay state differs after replay")
		return
	if game.enemies.size() != expected_enemies.size() or game.round_number != expected_round or game.phase != expected_phase:
		_fail("replayed enemy wave or phase differs")
		return
	if game.replay_tape.marker_tick("wave", 0) < 1 or not game.seek_replay_to_wave(1) or int(game.phase) != 2:
		_fail("wave marker seek did not restore the defend phase")
		return
	game.set_replay_paused(true)
	var paused_tick: int = game.replay_frame_index
	game._process(0.05)
	if game.replay_frame_index != paused_tick:
		_fail("paused playback advanced unexpectedly")
		return
	game.set_replay_paused(false)
	if not game.seek_replay(90):
		_fail("mid-run seeking failed")
		return
	if game.replay_frame_index != 89:
		_fail("seek did not advance to the requested frame boundary")
		return
	if not is_equal_approx(game.replay_mouse_position.x, 430.0) or not is_equal_approx(game.replay_mouse_position.y, 315.0):
		_fail("mouse input position was not restored")
		return
	var pending_before_dev_result: int = game.leaderboard_host.state.pending.size()
	game.leaderboard_host.set_dev_mode_active(true)
	game.leaderboard_host.open_game_over(7, game.replay_last_run_id, 7, game.replay_last_path, true)
	if game.leaderboard_host.state.pending.size() != pending_before_dev_result:
		_fail("Dev Mode result must not enter leaderboard submission queue")
		return
	DirAccess.remove_absolute(ProjectSettings.globalize_path(game.replay_last_path))
	if not game.start_replay_playback(encoded):
		_fail("second playback start failed")
		return
	game.set_replay_speed(4.0)
	game._process(0.05)
	if game.replay_frame_index != 3:
		_fail("playback speed should schedule four recorded steps without changing their deltas")
		return
	var pause_key := InputEventKey.new()
	pause_key.keycode = KEY_SPACE
	pause_key.pressed = true
	game._input(pause_key)
	if not game.replay_playback_paused:
		_fail("Space did not pause replay playback")
		return
	var exit_key := InputEventKey.new()
	exit_key.keycode = KEY_ESCAPE
	exit_key.pressed = true
	game._input(exit_key)
	if int(game.replay_mode) != 0 or int(game.phase) != 0:
		_fail("Escape did not return playback to the menu")
		return
	game.queue_free()
	for _cleanup in range(10):
		await process_frame
	print("REPLAY_RUNTIME_PASS frames=271 compressed_bytes=%d" % encoded.size())
	quit(0)

func _fail(message: String) -> void:
	printerr("FAIL: " + message)
	quit(1)
