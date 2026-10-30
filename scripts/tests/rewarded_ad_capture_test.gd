extends SceneTree

const CAPTURE_SIZE := Vector2i(1280, 720)

var capture_dir := "user://rewarded-ad-captures"


func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			capture_dir = argument.trim_prefix("--capture-dir=")
	call_deferred("_run")


func _run() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(CAPTURE_SIZE)
	DisplayServer.window_set_position(Vector2i(-10000, -10000))
	root.size = CAPTURE_SIZE
	DirAccess.make_dir_recursive_absolute(capture_dir)
	for _setup_frame in range(5):
		await process_frame

	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	if game.team_intro_active:
		game._finish_team_intro()
		await process_frame
	game.set_process(false)
	game._start_new_game()
	game.round_number = 8
	game.trophy_stolen = true
	game._enter_game_over_from_trophy_loss()
	game._update_revive_offer(game.REVIVE_OFFER_DELAY + 0.01)
	game._refresh_hud()
	await _capture("00-revive-offer")
	game.visible = false

	var ad_player: CanvasLayer = load("res://scenes/ads/ad_player.tscn").instantiate()
	root.add_child(ad_player)
	await process_frame
	ad_player.play_ad("evil", false)
	ad_player.set_process(false)
	for beat_index in range(ad_player.EVIL_BEATS.size()):
		ad_player.debug_show_beat(beat_index, 0.5)
		await _capture("%02d-%s" % [beat_index + 1, String(ad_player.EVIL_BEATS[beat_index]["id"])])

	ad_player.debug_show_beat(4, 0.5)
	ad_player._on_skip_pressed()
	await _capture("%02d-skip-confirm" % (ad_player.EVIL_BEATS.size() + 1))
	var capture_count: int = ad_player.EVIL_BEATS.size() + 2

	ad_player.queue_free()
	game.queue_free()
	for _cleanup_frame in range(10):
		await process_frame
	print("REWARDED_AD_CAPTURE_PASS count=%d" % capture_count)
	quit()


func _capture(file_stem: String) -> void:
	for _draw_frame in range(5):
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	assert(image.get_width() == CAPTURE_SIZE.x and image.get_height() == CAPTURE_SIZE.y, "Ad capture must render at the release viewport size.")
	var save_error := image.save_png(capture_dir.path_join("%s.png" % file_stem))
	assert(save_error == OK, "Failed to save rewarded-ad capture: %s" % file_stem)
