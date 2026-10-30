extends CanvasLayer

signal completed
signal declined(reason: String)
signal failed(message: String)

const CANVAS := preload("res://scripts/ads/spare_canvas.gd")
const TIMELINE_PATH := "res://assets/ads/spare/timeline.json"
const STARTING_BALANCE := 67.69
const BALANCES := [67.69, 61.0, 59.0, 57.0, 49.0, 47.0, 45.0, 44.0, 43.0, 42.0, 42.0, 0.0]
# Each source recording appears in exactly one continuous insert. Alternate
# monitor composites are not different recordings and must not be replayed.
const FOOTAGE_SHOTS := [
	{"beat": 0, "from": 0.0, "to": 5.6, "clip": "wallet", "source": "wallet"},
	{"beat": 1, "from": 0.0, "to": 5.6, "clip": "screen-start", "source": "screen"},
	{"beat": 4, "from": 0.0, "to": 2.4, "clip": "reach", "source": "reach"},
	{"beat": 4, "from": 2.4, "to": 6.5, "clip": "headphones", "source": "headphones"},
	{"beat": 7, "from": 0.0, "to": 5.5, "clip": "typing", "source": "typing"},
	{"beat": 8, "from": 0.0, "to": 2.1, "clip": "empty", "source": "empty"},
]
const FOOTAGE_RECT := Rect2(0, 0, 1280, 720)

var beats: Array = []
var total_duration := 60.0
var total_elapsed := 0.0
var beat_elapsed := 0.0
var beat_duration := 0.0
var completed_elapsed := 0.0
var current_beat_index := -1
var active := false
var dev_skip_allowed := false
var deterministic_movie := false
var voice_done := false
var using_fallback_duration := false
var visual: Node2D
var video: VideoStreamPlayer
var voice: AudioStreamPlayer
var music: AudioStreamPlayer
var chime: AudioStreamPlayer
var skip_button: Button
var timer_label: Label
var confirm: Control
var keep_button: Button
var confirm_skip_button: Button
var ending := false
var previous_scene_time := 0.0
var chime_played := false
var current_shot_index := -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var bg := ColorRect.new()
	bg.color = Color("f3f7fc")
	bg.size = Vector2(1280, 720)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	video = VideoStreamPlayer.new()
	video.process_mode = Node.PROCESS_MODE_ALWAYS
	video.expand = true
	video.loop = false
	video.volume_db = -80.0
	video.mouse_filter = Control.MOUSE_FILTER_IGNORE
	video.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	video.position = FOOTAGE_RECT.position
	video.size = FOOTAGE_RECT.size
	add_child(video)
	video.finished.connect(func():
		video.visible = false
		visual.queue_redraw()
	)
	visual = CANVAS.new()
	visual.controller = self
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(visual)
	for kind in ["voice", "music", "chime"]:
		var player := AudioStreamPlayer.new()
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		player.bus = "AdAudio"
		add_child(player)
		match kind:
			"voice": voice = player
			"music": music = player
			"chime": chime = player
	voice.finished.connect(func(): voice_done = true)
	_build_transport()
	_load_timeline()
	visible = false

func _load_timeline() -> void:
	if not FileAccess.file_exists(TIMELINE_PATH):
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(TIMELINE_PATH))
	if not data is Dictionary or not data.get("beats") is Array:
		return
	beats = data["beats"]
	# Recorded voice length controls each beat; retain the deliberate editing hold.
	var cursor := 0.0
	for beat in beats:
		var path := String(beat["audio"])
		var stream := load(path) as AudioStream if ResourceLoader.exists(path) else null
		var hold := maxf(0.0, float(beat["duration"]) - float(beat["voice_duration"]))
		if stream != null:
			beat["voice_duration"] = stream.get_length()
		beat["start"] = cursor
		beat["duration"] = float(beat["voice_duration"]) + hold
		cursor += float(beat["duration"])
	total_duration = cursor + 1.8

func play_ad(creative: String = "evil", allow_dev_skip: bool = false) -> void:
	if creative not in ["evil", "spare"] or beats.size() != 12:
		failed.emit("Spare's twelve voice beats are unavailable.")
		return
	dev_skip_allowed = allow_dev_skip
	active = true
	ending = false
	total_elapsed = 0.0
	completed_elapsed = 0.0
	visible = true
	music.volume_db = 0.0
	skip_button.visible = false
	timer_label.visible = not deterministic_movie
	if ResourceLoader.exists("res://assets/ads/spare/music/screen-saver.ogg"):
		music.stream = load("res://assets/ads/spare/music/screen-saver.ogg")
		music.play()
	if ResourceLoader.exists("res://assets/ads/spare/audio/transfer-chime.wav"):
		chime.stream = load("res://assets/ads/spare/audio/transfer-chime.wav")
	_begin_beat(0)

func _begin_beat(index: int) -> void:
	current_beat_index = index
	beat_elapsed = 0.0
	voice_done = false
	chime_played = false
	using_fallback_duration = false
	ending = index >= beats.size()
	video.stop()
	current_shot_index = -1
	video.visible = false
	_sync_shot()
	if ending:
		voice.stop()
		return
	beat_duration = float(beats[index]["duration"])
	var audio_path := String(beats[index]["audio"])
	voice.stream = load(audio_path) as AudioStream if ResourceLoader.exists(audio_path) else null
	if voice.stream != null:
		voice.play()
	else:
		using_fallback_duration = true
		voice_done = true

func _process(delta: float) -> void:
	if not active or confirm.visible:
		return
	previous_scene_time = total_elapsed
	if deterministic_movie:
		total_elapsed += delta
		var index := index_at(total_elapsed)
		if index != current_beat_index:
			_begin_beat(index)
		if index < beats.size():
			beat_elapsed = total_elapsed - float(beats[index]["start"])
	else:
		if ending:
			beat_elapsed += delta
		else:
			if using_fallback_duration:
				beat_elapsed += delta
			elif voice_done:
				beat_elapsed = maxf(beat_elapsed, float(beats[current_beat_index]["voice_duration"])) + delta
			else:
				beat_elapsed = maxf(beat_elapsed, voice.get_playback_position())
			if voice_done and beat_elapsed >= beat_duration:
				completed_elapsed += beat_duration
				_begin_beat(current_beat_index + 1)
			total_elapsed = completed_elapsed + beat_elapsed
		if ending:
			total_elapsed = completed_elapsed + beat_elapsed
	if music.playing and total_elapsed > total_duration - 2.0:
		music.volume_db = lerpf(0.0, -35.0, clampf((total_elapsed - total_duration + 2.0) / 2.0, 0.0, 1.0))
	_sync_shot()
	visual.queue_redraw()
	if not ending and not chime_played and current_beat_index in [1, 2, 3, 4, 5, 6, 7, 8, 9, 11]:
		var threshold := 0.50 if current_beat_index == 11 else 0.24
		if progress() >= threshold:
			chime_played = true
			if chime.stream != null:
				chime.play()
	var previously_visible := skip_button.visible
	skip_button.visible = not deterministic_movie and (dev_skip_allowed or total_elapsed >= 15.0)
	if skip_button.visible and not previously_visible:
		skip_button.grab_focus()
	timer_label.visible = not deterministic_movie
	timer_label.text = "ADVERTISEMENT   •   %02d" % int(total_elapsed)
	if total_elapsed >= total_duration:
		_finish_successfully()

func index_at(time: float) -> int:
	for index in range(beats.size()):
		if time < float(beats[index]["start"]) + float(beats[index]["duration"]):
			return index
	return beats.size()

func shot_at(index: int, elapsed: float) -> int:
	for shot_index in range(FOOTAGE_SHOTS.size()):
		var shot: Dictionary = FOOTAGE_SHOTS[shot_index]
		if index == int(shot["beat"]) and elapsed >= float(shot["from"]) and elapsed < float(shot["to"]):
			return shot_index
	return -1

func _sync_shot() -> void:
	var next_shot := shot_at(current_beat_index, beat_elapsed)
	if next_shot == current_shot_index:
		return
	current_shot_index = next_shot
	video.stop()
	video.visible = next_shot >= 0
	if next_shot >= 0:
		video.stream = load("res://assets/ads/spare/footage/%s.ogv" % FOOTAGE_SHOTS[next_shot]["clip"])
		video.play()

func is_footage_shot() -> bool:
	return current_shot_index >= 0 and video.visible

func progress() -> float:
	return clampf(beat_elapsed / maxf(beat_duration, 0.01), 0.0, 1.0)

func current_balance() -> float:
	if current_beat_index >= beats.size():
		return 0.0
	var before := STARTING_BALANCE if current_beat_index == 0 else float(BALANCES[current_beat_index - 1])
	var after := float(BALANCES[maxi(0, current_beat_index)])
	# Finish the final transfer inside the recorded motto, not its trailing hold.
	var fraction := smoothstep(0.24 if current_beat_index != 11 else 0.50, 0.90 if current_beat_index != 11 else 0.74, progress())
	return lerpf(before, after, fraction)

func debug_show_time(time: float) -> void:
	voice.stop()
	var index := index_at(time)
	_begin_beat(index)
	voice.stop()
	total_elapsed = time
	if index < beats.size():
		completed_elapsed = float(beats[index]["start"])
		beat_elapsed = time - float(beats[index]["start"])
	_sync_shot()
	visual.queue_redraw()

func _finish_successfully() -> void:
	if not active:
		return
	active = false
	voice.stop()
	video.stop()
	music.stop()
	chime.stop()
	completed.emit()

func debug_complete() -> void:
	_finish_successfully()

func _build_transport() -> void:
	timer_label = Label.new()
	timer_label.position = Vector2(44, 686)
	timer_label.add_theme_font_size_override("font_size", 12)
	timer_label.add_theme_color_override("font_color", Color("5f7187"))
	add_child(timer_label)
	skip_button = Button.new()
	skip_button.position = Vector2(1100, 658)
	skip_button.size = Vector2(136, 42)
	skip_button.text = "SKIP AD"
	skip_button.visible = false
	skip_button.focus_mode = Control.FOCUS_ALL
	skip_button.pressed.connect(_ask_skip)
	add_child(skip_button)
	confirm = Control.new()
	confirm.size = Vector2(1280, 720)
	var shade := ColorRect.new()
	shade.size = Vector2(1280, 720)
	shade.color = Color(0.02, 0.07, 0.15, 0.86)
	confirm.add_child(shade)
	var panel := Panel.new()
	panel.position = Vector2(370, 235)
	panel.size = Vector2(540, 240)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("f3f7fc")
	style.set_corner_radius_all(22)
	panel.add_theme_stylebox_override("panel", style)
	confirm.add_child(panel)
	var title := Label.new()
	title.position = Vector2(405, 269)
	title.size = Vector2(470, 70)
	title.text = "Skip now and lose your revive?"
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", Color("102e54"))
	confirm.add_child(title)
	keep_button = Button.new()
	keep_button.position = Vector2(405, 375)
	keep_button.size = Vector2(225, 58)
	keep_button.text = "Keep watching"
	keep_button.pressed.connect(_close_confirm)
	confirm.add_child(keep_button)
	confirm_skip_button = Button.new()
	confirm_skip_button.position = Vector2(650, 375)
	confirm_skip_button.size = Vector2(225, 58)
	confirm_skip_button.text = "Skip without revive"
	confirm_skip_button.pressed.connect(_decline)
	confirm.add_child(confirm_skip_button)
	confirm.visible = false
	add_child(confirm)

func _ask_skip() -> void:
	if dev_skip_allowed:
		_finish_successfully()
		return
	if total_elapsed < 15.0:
		return
	confirm.visible = true
	voice.stream_paused = true
	music.stream_paused = true
	chime.stream_paused = true
	video.paused = true
	keep_button.grab_focus()

func _close_confirm() -> void:
	confirm.visible = false
	voice.stream_paused = false
	music.stream_paused = false
	chime.stream_paused = false
	video.paused = false
	skip_button.grab_focus()

func _decline() -> void:
	active = false
	voice.stop()
	music.stop()
	video.stop()
	declined.emit("The ad was skipped; the revive was forfeited.")

func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	var cancel: bool = event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE
	cancel = cancel or (event is InputEventJoypadButton and event.pressed and event.button_index == JOY_BUTTON_B)
	if cancel:
		if confirm.visible:
			_close_confirm()
		else:
			_ask_skip()
		get_viewport().set_input_as_handled()
