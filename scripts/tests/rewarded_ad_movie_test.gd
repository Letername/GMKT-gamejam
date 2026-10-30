extends SceneTree

const AD_PLAYER_SCENE := preload("res://scenes/ads/ad_player.tscn")

var ad_player: CanvasLayer
var finishing := false


func _initialize() -> void:
	root.content_scale_size = Vector2i(1280, 720)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	call_deferred("_start_movie")


func _start_movie() -> void:
	ad_player = AD_PLAYER_SCENE.instantiate()
	ad_player.deterministic_movie = true
	root.add_child(ad_player)
	ad_player.completed.connect(_on_ad_completed)
	ad_player.declined.connect(_on_ad_failed.bind("declined"))
	ad_player.failed.connect(_on_ad_failed.bind("failed"))
	ad_player.play_ad("evil", false)
	print("REWARDED_AD_MOVIE_DURATION %.3f" % ad_player.total_duration)


func _on_ad_completed() -> void:
	if finishing:
		return
	finishing = true
	# Leave a short clean tail so the finished MP4 does not cut on the last syllable.
	await create_timer(0.75).timeout
	print("REWARDED_AD_MOVIE_PASS")
	quit(0)


func _on_ad_failed(reason: String, source: String = "failed") -> void:
	push_error("Rewarded ad movie %s: %s" % [source, reason])
	quit(1)
