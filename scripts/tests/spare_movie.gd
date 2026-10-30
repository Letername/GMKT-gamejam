extends SceneTree

const AD := preload("res://scenes/ads/spare_ad.tscn")
var player: CanvasLayer
var rendering := false

func _initialize() -> void:
	root.content_scale_size = Vector2i(1280, 720)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	call_deferred("_start")

func _start() -> void:
	player = AD.instantiate()
	root.add_child(player)
	player.deterministic_movie = true
	player.completed.connect(func(): print("SPARE_MOVIE_PASS"); quit(0))
	player.failed.connect(func(message): push_error(message); quit(1))
	player.play_ad("spare")
	var arguments := OS.get_cmdline_user_args()
	if "--app-reference" in arguments:
		player.visual.app_reference = true
		player.video.visible = false
	for arg in arguments:
		if arg == "--capture-matrix":
			player.set_process(false)
			var directory := "res://.tools/test-outputs/spare"
			DirAccess.make_dir_recursive_absolute(directory)
			for beat in player.beats:
				player.debug_show_time(float(beat["start"]) + float(beat["duration"]) * 0.60)
				await create_timer(0.35).timeout
				await RenderingServer.frame_post_draw
				root.get_texture().get_image().save_png(directory + "/%s.png" % beat["id"])
			player.debug_show_time(player.total_duration - 0.7)
			await create_timer(0.2).timeout
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png(directory + "/endcard.png")
			print("SPARE_CAPTURE_MATRIX_PASS count=13")
			quit(0)
			return
		if arg.begins_with("--capture-at="):
			player.set_process(false)
			player.debug_show_time(float(arg.trim_prefix("--capture-at=")))
			if "--app-reference" in arguments:
				player.video.visible = false
			await create_timer(0.4).timeout
			await RenderingServer.frame_post_draw
			var directory := "res://.tools/test-outputs/spare"
			DirAccess.make_dir_recursive_absolute(directory)
			var filename := "app-reference.png" if "--app-reference" in arguments else "capture-%s.png" % arg.trim_prefix("--capture-at=")
			root.get_texture().get_image().save_png(directory + "/" + filename)
			print("SPARE_CAPTURE_PASS")
			quit(0)
