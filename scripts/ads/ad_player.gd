extends CanvasLayer

signal completed
signal declined(reason: String)
signal failed(message: String)

const AD_AUDIO_BUS_NAME := "AdAudio"
const SKIP_UNLOCK_SECONDS := 15.0
const MUSIC_PATH := "res://assets/ads/advertime.mp3"
const VIDEO_PATHS := [
	"res://assets/ads/footage/footage_01_room.ogv",
	"res://assets/ads/footage/footage_02_mug.ogv",
	"res://assets/ads/footage/footage_03_door.ogv",
	"res://assets/ads/footage/footage_04_no_cancel.ogv",
	"res://assets/ads/footage/footage_05_couch.ogv",
	"res://assets/ads/footage/footage_06_photo_blurred.ogv",
	"res://assets/ads/footage/footage_07_possessions.ogv",
	"res://assets/ads/footage/footage_07_possessions.ogv",
	"res://assets/ads/footage/footage_07_possessions.ogv"
]
const EVIL_BEATS := [
	{"id": "evil_01", "duration": 2.0},
	{"id": "evil_02", "duration": 5.0},
	{"id": "evil_03", "duration": 4.0},
	{"id": "evil_04", "duration": 4.0},
	{"id": "evil_05", "duration": 3.0},
	{"id": "evil_06", "duration": 6.0},
	{"id": "evil_07", "duration": 3.0},
	{"id": "evil_08", "duration": 3.0},
	{"id": "evil_09", "duration": 4.8}
]
const TEAM_ART_PATHS := {
	"family": "res://Art/Family photo.png",
	"mug": "res://Art/Best dad mug with shadow.png",
	"couch": "res://Art/Couch with coins.png",
	"bob_full": "res://Art/Bob n stuff.png",
	"bob_empty": "res://Art/Bob with no stuff.png",
	"house": "res://Art/Bob's house.png",
	"house_broken_1": "res://Art/Bobs house broken 1.png",
	"house_broken_2": "res://Art/Bob's house broken 2.png",
	"robot": "res://Art/IRS ROBOT 1.png",
	"robot_walk_1": "res://Art/Robot moving 1-1.png.png",
	"robot_walk_2": "res://Art/Robot moving 2-2.png.png",
	"robot_walk_3": "res://Art/Robot moving 3-3.png.png",
	"papers": "res://Art/Tax Papers.png",
	"trophy": "res://Art/gold trophy.png",
	"console": "res://Art/kfz console air fryer.png"
}

var creative := "evil"
var active := false
## Movie Maker advances in fixed frames rather than the hardware audio clock.
var deterministic_movie := false
var dev_skip_allowed := false
var current_beat_index := -1
var beat_elapsed := 0.0
var beat_duration := 0.0
var completed_elapsed := 0.0
var total_elapsed := 0.0
var total_duration := 30.0
var using_fallback_duration := true
var audio_is_playing := false
var texture_cache := {}
var paper_art: TextureRect
var prop_art: TextureRect
var detail_art: TextureRect
var robot_art: TextureRect
var kicker: Label
var body_copy: Label
var brand_bug: Label
var value_card: Panel
var value_amount: Label
var value_detail: Label
var scanner_line: ColorRect
var top_rule: ColorRect
var bottom_rule: ColorRect
var legal_pill: Label
var metric_cards: Array[Panel] = []
var scan_frame: Panel
var scan_status: Label
var scan_dot: ColorRect
var live_badge: Label
var side_copy: Label
var object_tags: Array[Label] = []

@onready var screen: Control = $Screen
@onready var backdrop: ColorRect = $Screen/Backdrop
@onready var light_band: ColorRect = $Screen/LightBand
@onready var video_player: VideoStreamPlayer = $Screen/LiveFootage
@onready var footage_grade: ColorRect = $Screen/FootageGrade
@onready var stage: Control = $Screen/Stage
@onready var primary_art: TextureRect = $Screen/Stage/PrimaryArt
@onready var secondary_art: TextureRect = $Screen/Stage/SecondaryArt
@onready var tertiary_art: TextureRect = $Screen/Stage/TertiaryArt
@onready var wordmark: Label = $Screen/Stage/Wordmark
@onready var headline: Label = $Screen/Stage/Headline
@onready var caption: Label = $Screen/Stage/Caption
@onready var small_print: Label = $Screen/Stage/SmallPrint
@onready var timer_label: Label = $Screen/TimerLabel
@onready var progress_bar: ProgressBar = $Screen/ProgressBar
@onready var skip_button: Button = $Screen/SkipButton
@onready var confirm_shade: ColorRect = $Screen/ConfirmShade
@onready var confirm_panel: Panel = $Screen/ConfirmShade/ConfirmPanel
@onready var confirm_skip_button: Button = $Screen/ConfirmShade/ConfirmPanel/SkipAnyway
@onready var continue_button: Button = $Screen/ConfirmShade/ConfirmPanel/KeepWatching
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	voice_player.process_mode = Node.PROCESS_MODE_ALWAYS
	voice_player.bus = AD_AUDIO_BUS_NAME
	video_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.bus = AD_AUDIO_BUS_NAME
	voice_player.finished.connect(_on_voice_finished)
	skip_button.pressed.connect(_on_skip_pressed)
	confirm_skip_button.pressed.connect(_decline_from_confirm)
	continue_button.pressed.connect(_close_skip_confirm)
	_build_motion_graphics()
	_style_controls()
	_preload_team_art()
	screen.visible = false


func play_ad(requested_creative: String, allow_dev_skip: bool = false) -> void:
	if requested_creative != "evil":
		failed.emit("Creative '%s' has not been produced yet." % requested_creative)
		return
	creative = requested_creative
	dev_skip_allowed = allow_dev_skip
	active = true
	current_beat_index = -1
	beat_elapsed = 0.0
	completed_elapsed = 0.0
	total_elapsed = 0.0
	total_duration = _calculate_runtime_duration()
	screen.visible = true
	confirm_shade.visible = false
	_start_music()
	_begin_beat(0)


func _process(delta: float) -> void:
	if not active or confirm_shade.visible:
		return
	if deterministic_movie:
		beat_elapsed += delta
	elif audio_is_playing:
		beat_elapsed = clampf(voice_player.get_playback_position(), 0.0, beat_duration)
		if not voice_player.playing:
			beat_elapsed = minf(beat_elapsed + delta, beat_duration)
	else:
		beat_elapsed += delta
	total_elapsed = completed_elapsed + beat_elapsed
	var progress := clampf(beat_elapsed / maxf(beat_duration, 0.001), 0.0, 1.0)
	_apply_beat_visuals(progress)
	_refresh_transport()
	if beat_elapsed >= beat_duration and (deterministic_movie or not audio_is_playing or not voice_player.playing):
		_advance_beat()


func _begin_beat(index: int) -> void:
	if index >= EVIL_BEATS.size():
		_finish_successfully()
		return
	current_beat_index = index
	beat_elapsed = 0.0
	var beat: Dictionary = EVIL_BEATS[index]
	beat_duration = float(beat["duration"])
	using_fallback_duration = true
	audio_is_playing = false
	voice_player.stop()
	voice_player.stream = null
	_start_video(index)
	var stream := _load_voice_stream(String(beat["id"]))
	if stream != null:
		voice_player.stream = stream
		var recorded_duration := stream.get_length()
		if recorded_duration > 0.10:
			beat_duration = recorded_duration
		using_fallback_duration = false
		voice_player.play()
		audio_is_playing = true
	_reset_visuals()
	_apply_beat_visuals(0.0)
	_refresh_transport()


func _advance_beat() -> void:
	if not active:
		return
	completed_elapsed += beat_duration
	total_elapsed = completed_elapsed
	_begin_beat(current_beat_index + 1)


func _on_voice_finished() -> void:
	if active and audio_is_playing and not deterministic_movie and not confirm_shade.visible:
		beat_elapsed = beat_duration
		_apply_beat_visuals(1.0)
		_advance_beat()


func _finish_successfully() -> void:
	if not active:
		return
	active = false
	if deterministic_movie:
		_apply_beat_visuals(0.84)
	voice_player.stop()
	video_player.stop()
	music_player.stop()
	completed.emit()


func _start_music() -> void:
	music_player.stop()
	if ResourceLoader.exists(MUSIC_PATH):
		music_player.stream = load(MUSIC_PATH) as AudioStream
		music_player.play()


func _start_video(index: int) -> void:
	video_player.stop()
	video_player.stream = null
	if index < 0 or index >= VIDEO_PATHS.size():
		return
	var path := String(VIDEO_PATHS[index])
	if ResourceLoader.exists(path):
		video_player.stream = load(path) as VideoStream
		video_player.play()


func _load_voice_stream(line_id: String) -> AudioStream:
	for candidate in _voice_candidates(line_id):
		var path := "res://assets/ads/%s.wav" % candidate
		if ResourceLoader.exists(path):
			return load(path) as AudioStream
	return null


func _calculate_runtime_duration() -> float:
	var duration := 0.0
	for beat in EVIL_BEATS:
		var fallback := float(beat["duration"])
		var stream := _load_voice_stream(String(beat["id"]))
		duration += stream.get_length() if stream != null and stream.get_length() > 0.1 else fallback
	return maxf(duration, 1.0)


func _voice_candidates(line_id: String) -> PackedStringArray:
	var candidates := PackedStringArray([line_id])
	match line_id:
		"evil_03":
			candidates.append_array(["evil_03_flat", "evil_03_warm", "evil_03b", "evil_03c", "evil_03d"])
		"evil_05":
			candidates.append_array(["evil_05_flat", "evil_05_warm", "evil_05b", "evil_05c", "evil_05d"])
		"evil_07":
			candidates.append_array(["evil_07b", "evil_07c", "evil_07d"])
	return candidates


func _preload_team_art() -> void:
	for key in TEAM_ART_PATHS:
		var path := String(TEAM_ART_PATHS[key])
		var texture := load(path) as Texture2D
		if texture == null:
			push_error("Rewarded ad team art is missing: %s" % path)
		else:
			texture_cache[key] = _crop_small_team_texture(texture)


func _crop_small_team_texture(texture: Texture2D) -> Texture2D:
	var texture_size := texture.get_size()
	if texture_size.x > 512.0 or texture_size.y > 512.0:
		return texture
	var image := texture.get_image()
	if image == null or image.is_empty():
		return texture
	var used_rect := image.get_used_rect()
	if used_rect.size.x <= 0 or used_rect.size.y <= 0:
		return texture
	if used_rect.size.x == image.get_width() and used_rect.size.y == image.get_height():
		return texture
	return ImageTexture.create_from_image(image.get_region(used_rect))


func _reset_visuals() -> void:
	for art in [primary_art, secondary_art, tertiary_art, paper_art, prop_art, detail_art, robot_art]:
		art.visible = false
		art.texture = null
		art.modulate = Color.WHITE
		art.scale = Vector2.ONE
		art.rotation = 0.0
	wordmark.visible = false
	wordmark.position = Vector2(180, 176)
	wordmark.size = Vector2(920, 236)
	headline.visible = false
	headline.position = Vector2(180, 506)
	headline.size = Vector2(920, 92)
	caption.visible = false
	caption.position = Vector2(320, 526)
	caption.size = Vector2(640, 52)
	small_print.visible = false
	small_print.position = Vector2(126, 582)
	small_print.size = Vector2(1028, 56)
	for graphic in [kicker, body_copy, brand_bug, value_card, scanner_line, top_rule, bottom_rule, legal_pill]:
		graphic.visible = false
	for card in metric_cards:
		card.visible = false
		card.modulate = Color.WHITE
	for tag in object_tags:
		tag.visible = false
	for graphic in [scan_frame, scan_status, scan_dot, live_badge, side_copy]:
		graphic.visible = false
	light_band.visible = false
	video_player.visible = true
	footage_grade.visible = true
	footage_grade.color = Color(0.02, 0.11, 0.09, 0.12)
	backdrop.color = Color(0.012, 0.014, 0.018, 1.0)


func _apply_beat_visuals(progress: float) -> void:
	_apply_live_action_visuals(progress)
	return
	_reset_visuals()
	var fade := _beat_fade(progress)
	brand_bug.position = Vector2(1156, 22)
	brand_bug.size = Vector2(92, 40)
	brand_bug.visible = true
	brand_bug.modulate.a = fade
	match current_beat_index:
		0:
			backdrop.color = Color(0.022, 0.026, 0.034, 1.0)
			var rule_width := 820.0 * _ease_out(progress)
			_show_rule(top_rule, Rect2(230, 142, rule_width, 3), fade)
			_show_rule(bottom_rule, Rect2(1050 - rule_width, 574, rule_width, 3), fade)
			_show_kicker("A NEW STANDARD IN FINANCIAL WELLNESS", Vector2(180, 104), Vector2(920, 28), fade, HORIZONTAL_ALIGNMENT_CENTER)
			wordmark.text = "LETERNAME\nCLEARHOME™"
			wordmark.position = Vector2(180, 188)
			wordmark.size = Vector2(920, 228)
			wordmark.pivot_offset = wordmark.size * 0.5
			wordmark.scale = Vector2.ONE * lerpf(0.92, 1.0, _ease_out(progress))
			wordmark.visible = true
			wordmark.modulate.a = fade
			_show_headline("FINANCIAL WELLNESS, SIMPLIFIED.", Rect2(220, 448, 840, 62), 24, fade)
			_show_legal_pill("A LETERNAME TECHNOLOGIES PRODUCT", Rect2(438, 616, 404, 34), fade)
		1:
			_set_clearhome_stage()
			var enter := 1.0 - _ease_out(progress)
			_show_art(primary_art, "bob_full", Rect2(76 - enter * 90.0, 128, 430, 430), 1.0 + progress * 0.025, fade)
			_show_art(secondary_art, "house", Rect2(398, 80 + enter * 36.0, 470, 470), 1.0 + progress * 0.018, fade * 0.34)
			_show_art(prop_art, "papers", Rect2(456, 150 - enter * 80.0, 126, 126), 1.0 + progress * 0.06, fade)
			_show_art(detail_art, "console", Rect2(736, 406 + enter * 74.0, 144, 144), 1.0, fade)
			_show_kicker("CASE 0041  /  BOB R.", Vector2(84, 84), Vector2(400, 28), fade)
			_show_value_card(Rect2(852 + enter * 120.0, 150, 338, 184), "347", "FINANCIAL DECISIONS\nPER YEAR", fade)
			_show_metric_card(0, Rect2(820, 370, 180, 112), "6", "ACCOUNTS", progress, 0.00)
			_show_metric_card(1, Rect2(1012, 370, 180, 112), "14", "DRAWERS", progress, 0.08)
			_show_metric_card(2, Rect2(916, 494, 180, 112), "1", "JAR ABOVE FRIDGE", progress, 0.16)
			_show_headline("BOB WAS EXHAUSTED.", Rect2(92, 548, 670, 58), 32, fade)
		2:
			_set_clearhome_stage()
			var enter := 1.0 - _ease_out(progress)
			_show_art(primary_art, "mug", Rect2(178 - enter * 100.0, 112, 340, 460), 1.02 + progress * 0.045, fade)
			_show_art(paper_art, "papers", Rect2(72, 420, 170, 170), 1.0, fade * 0.65)
			_show_rule(scanner_line, Rect2(188, lerpf(142.0, 548.0, progress), 320, 3), fade)
			_show_kicker("CLEARHOME INVENTORY PASS 01", Vector2(624, 118), Vector2(500, 28), fade)
			_show_headline("EVERY OBJECT.\nONE SIMPLE RECORD.", Rect2(618, 154, 522, 118), 34, fade)
			_show_value_card(Rect2(660 + enter * 120.0, 310, 420, 196), "$%.2f" % lerpf(0.0, 4.0, _ease_out(progress)), "APPRAISED VALUE\nBEST DAD MUG", fade)
			_show_legal_pill("ASSET ID  MUG-0004  •  SENTIMENTAL VALUE NOT RECOGNIZED", Rect2(584, 548, 574, 38), fade)
		3:
			_set_clearhome_stage()
			_show_art(primary_art, "couch", Rect2(96, 124, 454, 454), 1.0 + progress * 0.035, fade)
			_show_kicker("LEGACY TAX SERVICES", Vector2(646, 102), Vector2(480, 28), fade)
			_show_headline("THEY HELP YOU MANAGE\nWHAT YOU OWN.", Rect2(638, 140, 520, 112), 31, fade)
			_show_metric_card(0, Rect2(630, 294, 180, 112), "12%", "STARTER SHARE", progress, 0.00)
			_show_metric_card(1, Rect2(822, 294, 180, 112), "18%", "PREMIUM SHARE", progress, 0.08)
			_show_metric_card(2, Rect2(1014, 294, 180, 112), "FAIR", "CONTRIBUTION", progress, 0.16)
			_show_value_card(Rect2(734, 450, 360, 156), "0%", "OWNERSHIP LEFT TO MANAGE", fade * clampf((progress - 0.42) * 3.0, 0.0, 1.0))
			_show_legal_pill("CLEARHOME REMOVES THE OWNERSHIP.", Rect2(112, 594, 430, 38), fade)
		4:
			_set_clearhome_stage()
			_show_art(primary_art, "bob_full", Rect2(94, 170, 380, 380), 1.0, fade)
			var robot_frame := "robot_walk_%d" % (1 + posmod(int(floor(progress * 10.0)), 3))
			var robot_x := lerpf(1130.0, 610.0, _ease_out(progress))
			_show_art(robot_art, robot_frame, Rect2(robot_x, 204, 300, 320), 1.0, fade)
			_show_rule(top_rule, Rect2(600, 106, 3, 474), fade * 0.65)
			_show_kicker("CERTIFIED. DISCREET. ALREADY OUTSIDE.", Vector2(650, 114), Vector2(510, 28), fade)
			_show_headline("MEET YOUR\nASSET CONCIERGE.", Rect2(648, 154, 516, 118), 35, fade)
			_show_value_card(Rect2(858, 388, 310, 156), "100%", "HOME ASSET COVERAGE", fade)
			_show_legal_pill("ARRIVES IN MINUTES  •  YOU DO NOT NEED TO BE HOME", Rect2(640, 552, 540, 38), fade)
		5:
			_set_clearhome_stage()
			var house_rect := Rect2(260, 34, 760, 610)
			_show_art(primary_art, "house", house_rect, 1.0 + progress * 0.018, fade * clampf(1.0 - progress * 3.0, 0.0, 1.0))
			_show_art(secondary_art, "house_broken_1", house_rect, 1.0 + progress * 0.018, fade * clampf(1.0 - absf(progress - 0.50) * 4.0, 0.0, 1.0))
			_show_art(tertiary_art, "house_broken_2", house_rect, 1.0 + progress * 0.018, fade * clampf((progress - 0.58) * 3.4, 0.0, 1.0))
			var transfer := _ease_out(progress)
			_show_art(paper_art, "papers", Rect2(160 + transfer * 810.0, 160 - sin(progress * PI) * 80.0, 150, 150), 1.0 + progress * 0.2, fade)
			_show_art(prop_art, "trophy", Rect2(120 + transfer * 860.0, 350 - sin(progress * PI) * 110.0, 112, 112), 1.0, fade)
			_show_art(detail_art, "console", Rect2(184 + transfer * 740.0, 470 - sin(progress * PI) * 92.0, 126, 126), 1.0, fade)
			_show_kicker("CLEARHOME CONSOLIDATION IN PROGRESS", Vector2(76, 72), Vector2(560, 28), fade)
			_show_headline("ONE SIMPLE CATEGORY:  OURS.", Rect2(270, 92, 740, 62), 32, fade)
			_show_metric_card(0, Rect2(106, 500, 180, 100), "OURS", "FURNITURE", progress, 0.00)
			_show_metric_card(1, Rect2(550, 500, 180, 100), "OURS", "SAVINGS", progress, 0.10)
			_show_metric_card(2, Rect2(994, 500, 180, 100), "OURS", "KEEPSAKES", progress, 0.20)
			small_print.text = "MUG INCLUDED. MUG IS OURS.  •  FAMILY PHOTO DIGITIZATION FEE APPLIES.  •  AIR FRYER APPEAL PENDING."
			small_print.visible = true
			small_print.modulate.a = fade
		6:
			_set_clearhome_stage()
			_show_rule(bottom_rule, Rect2(92, 590, 590, 3), fade)
			_show_art(primary_art, "bob_empty", Rect2(148, 122, 420, 420), 1.0 + progress * 0.018, fade)
			_show_kicker("VERIFIED CUSTOMER OUTCOME", Vector2(720, 112), Vector2(430, 28), fade)
			_show_headline("STRESS SCORE:\nRECORD LOW.", Rect2(710, 150, 450, 112), 36, fade)
			_show_metric_card(0, Rect2(666, 310, 168, 110), "0", "ACCOUNTS", progress, 0.00)
			_show_metric_card(1, Rect2(846, 310, 168, 110), "0", "CLUTTER", progress, 0.08)
			_show_metric_card(2, Rect2(1026, 310, 168, 110), "1", "FLOOR", progress, 0.16)
			caption.text = "BOB R.  —  CLEARHOME MEMBER"
			caption.position = Vector2(126, 530)
			caption.size = Vector2(470, 48)
			caption.visible = true
			caption.modulate.a = fade
			small_print.text = "ZERO-ACCOUNT CLAIM EXCLUDES LETERNAME RECEIVABLES.  •  FLOOR ACCESS SUBJECT TO MONTHLY REVIEW."
			small_print.visible = true
			small_print.modulate.a = fade
		7:
			backdrop.color = Color(0.018, 0.022, 0.030, 1.0)
			var rule_width := 880.0 * _ease_out(progress)
			_show_rule(top_rule, Rect2(200, 128, rule_width, 3), fade)
			_show_rule(bottom_rule, Rect2(1080 - rule_width, 584, rule_width, 3), fade)
			_show_kicker("OWN LESS. DECIDE LESS. WORRY LESS.", Vector2(180, 94), Vector2(920, 28), fade, HORIZONTAL_ALIGNMENT_CENTER)
			wordmark.text = "LETERNAME\nCLEARHOME™"
			wordmark.position = Vector2(180, 166)
			wordmark.size = Vector2(920, 210)
			wordmark.pivot_offset = wordmark.size * 0.5
			wordmark.scale = Vector2.ONE * lerpf(0.95, 1.0, _ease_out(progress))
			wordmark.visible = true
			wordmark.modulate.a = fade
			_show_headline("LESS TO MANAGE.\nNOTHING TO KEEP.", Rect2(220, 408, 840, 102), 32, fade)
			small_print.position = Vector2(220, 548)
			small_print.size = Vector2(840, 34)
			small_print.text = "CLEARHOME IS A LETERNAME TECHNOLOGIES SERVICE. RESULTS TYPICAL. POSSESSIONS NOT RETURNED."
			small_print.visible = true
			small_print.modulate.a = fade
			_show_legal_pill("ENROLLMENT BEGAN WHEN THIS AD STARTED", Rect2(426, 604, 428, 34), fade)


func _apply_live_action_visuals(progress: float) -> void:
	_reset_visuals()
	var fade := _beat_fade(progress)
	var eased := _ease_out(progress)
	_set_live_branding(fade)
	match current_beat_index:
		0:
			footage_grade.color = Color(0.01, 0.10, 0.08, 0.20)
			_show_live_status("LETERNAME LABS  /  LIVE ASSET FEED", "SYSTEM READY", fade)
			_show_side_copy("SCAN &\nSURRENDER™", Rect2(42, 158, 350, 180), 44, fade)
			_show_scan_frame(Rect2(466, 112, 348, 466), progress, "RESIDENCE DETECTED")
			_show_headline("DISCOVER WHAT EVERYTHING YOU OWN IS WORTH.", Rect2(858, 250, 360, 120), 24, fade)
			_show_legal_pill("CAMERA ACCESS GRANTED BY CONTINUING TO WATCH", Rect2(850, 398, 372, 40), fade)
		1:
			_show_live_status("OBJECT RECOGNITION  /  PASS 01", "SCANNING", fade)
			_show_side_copy("POINT AT\nANYTHING.", Rect2(44, 172, 340, 130), 34, fade)
			_show_scan_frame(Rect2(500, 174, 280, 358), progress, "OBJECT LOCKED")
			_show_rule(scanner_line, Rect2(510, lerpf(190.0, 516.0, progress), 260, 4), fade)
			_show_value_card(Rect2(884, 180, 318, 204), "$%.2f" % lerpf(0.0, 4.0, eased), "APPRAISED VALUE\nCERAMIC MUG", fade)
			_show_legal_pill("VALUATION ACCURATE TO THE NEAREST POSSESSION", Rect2(852, 420, 382, 40), fade)
		2:
			_show_live_status("DISPATCH NETWORK  /  REQUEST 5543", "ACCEPTED", fade)
			_show_scan_frame(Rect2(464, 114, 352, 462), progress, "ENTRY POINT CONFIRMED")
			_show_side_copy("ONE TAP.\nALREADY\nON THE WAY.", Rect2(42, 164, 354, 190), 32, fade)
			var robot_frame := "robot_walk_%d" % (1 + posmod(int(floor(progress * 12.0)), 3))
			_show_art(robot_art, robot_frame, Rect2(940 + (1.0 - eased) * 210.0, 326, 244, 264), 1.0, fade)
			_show_value_card(Rect2(880, 142, 326, 150), "00:%02d" % maxi(0, 5 - int(progress * 5.0)), "COLLECTION PROFESSIONAL\nESTIMATED ARRIVAL", fade)
		3:
			footage_grade.color = Color(0.18, 0.025, 0.02, 0.18)
			_show_live_status("ACCOUNT CONTROL  /  CUSTOMER OPTIONS", "LOCKED", fade)
			_show_scan_frame(Rect2(464, 96, 352, 508), progress, "EXIT NOT REQUIRED")
			_show_side_copy("NO\nPAPERWORK.", Rect2(46, 170, 344, 124), 38, fade)
			_show_headline("NO CANCELLATION BUTTON.", Rect2(856, 214, 362, 120), 31, fade)
			_show_legal_pill("THIS IS THE CANCELLATION BUTTON", Rect2(886, 376, 306, 42), fade * (0.72 + sin(progress * TAU * 3.0) * 0.28))
		4:
			_show_live_status("FURNITURE LIQUIDITY  /  ROOM 01", "VALUING", fade)
			_show_scan_frame(Rect2(300, 178, 718, 354), progress, "SOFA IDENTIFIED")
			_show_headline("AVAILABLE EQUITY", Rect2(54, 116, 350, 70), 28, fade)
			_show_value_card(Rect2(850, 92, 342, 168), "$1,184", "ESTIMATED COUCH VALUE\nCUSHIONS INCLUDED", fade)
			var couch_robot := "robot_walk_%d" % (1 + posmod(int(floor(progress * 14.0)), 3))
			_show_art(robot_art, couch_robot, Rect2(980 - eased * 390.0, 330, 250, 270), 1.0, fade)
			_show_legal_pill("LIQUIDITY EVENT IN PROGRESS", Rect2(476, 568, 328, 40), fade)
		5:
			_show_live_status("SENTIMENTAL ASSET PROCESSING", "MATCH FOUND", fade)
			_show_scan_frame(Rect2(352, 136, 576, 420), progress, "FAMILY RECORD DETECTED")
			_show_value_card(Rect2(874, 176, 320, 194), "$0.12", "VALUE PER PERSON\nSMILES INCLUDED", fade)
			_show_side_copy("MEMORIES,\nSIMPLIFIED.", Rect2(46, 200, 286, 116), 30, fade)
			_show_legal_pill("DIGITIZATION FEE EXCEEDS APPRAISED VALUE", Rect2(846, 414, 378, 42), fade)
		6:
			_show_live_status("WHOLE-HOME CONSOLIDATION", "%02d%% COMPLETE" % int(eased * 100.0), fade)
			_show_headline("ONE SIMPLE CATEGORY: OURS.", Rect2(210, 76, 860, 64), 32, fade)
			_show_object_tag(0, "FURNITURE  •  OURS", Vector2(166, 250), progress, 0.02)
			_show_object_tag(1, "SAVINGS  •  OURS", Vector2(538, 378), progress, 0.15)
			_show_object_tag(2, "KEEPSAKES  •  OURS", Vector2(882, 214), progress, 0.28)
			_show_object_tag(3, "PLANTS  •  PENDING", Vector2(744, 100), progress, 0.42)
			_show_rule(scanner_line, Rect2(80, lerpf(164.0, 618.0, progress), 1120, 3), fade)
			small_print.text = "HOUSEHOLD REDUCTION MAY INCLUDE ITEMS YOU WERE STILL USING.  •  RESULTS BECOME FINAL IMMEDIATELY."
			small_print.visible = true
			small_print.modulate.a = fade
		7:
			footage_grade.color = Color(0.005, 0.014, 0.012, lerpf(0.52, 0.88, eased))
			_show_live_status("TRANSFER COMPLETE", "100%", fade)
			wordmark.text = "LETERNAME\nSCAN & SURRENDER™"
			wordmark.position = Vector2(164, 152)
			wordmark.size = Vector2(952, 220)
			wordmark.pivot_offset = wordmark.size * 0.5
			wordmark.scale = Vector2.ONE * lerpf(0.92, 1.0, eased)
			wordmark.visible = true
			wordmark.modulate.a = fade
			_show_headline("KNOW WHAT YOU OWN, JUST BEFORE WE DO.", Rect2(210, 408, 860, 92), 30, fade)
			_show_legal_pill("TRANSFER RECEIPT AVAILABLE UPON REQUEST", Rect2(426, 552, 428, 40), fade)
			small_print.position = Vector2(210, 608)
			small_print.size = Vector2(860, 30)
			small_print.text = "A LETERNAME TECHNOLOGIES SERVICE. POSSESSIONS NOT RETURNED."
			small_print.visible = true
			small_print.modulate.a = fade
		8:
			footage_grade.color = Color(0.005, 0.010, 0.009, lerpf(0.72, 0.94, eased))
			_show_live_status("LETERNAME TECHNOLOGIES  /  COMPANY MOTTO", "OFFICIAL", fade)
			wordmark.text = "LETERNAME\nTECHNOLOGIES"
			wordmark.position = Vector2(164, 142)
			wordmark.size = Vector2(952, 210)
			wordmark.pivot_offset = wordmark.size * 0.5
			wordmark.scale = Vector2.ONE * lerpf(0.94, 1.0, eased)
			wordmark.visible = true
			wordmark.modulate.a = fade
			_show_headline("WE DON'T WANT JUST SOME OF YOUR MONEY.\nWE WANT ALL OF IT.", Rect2(190, 386, 900, 122), 28, fade)
			_show_legal_pill("ENROLLMENT BEGAN WHEN THIS AD STARTED", Rect2(426, 552, 428, 40), fade)
			small_print.position = Vector2(210, 608)
			small_print.size = Vector2(860, 30)
			small_print.text = "A LETERNAME TECHNOLOGIES SERVICE. MOTTO APPROVED BY LETERNAME TECHNOLOGIES."
			small_print.visible = true
			small_print.modulate.a = fade


func _set_live_branding(alpha: float) -> void:
	live_badge.text = "L / T"
	live_badge.visible = true
	live_badge.modulate.a = alpha
	live_badge.position = Vector2(1168, 22)
	live_badge.size = Vector2(78, 38)


func _show_live_status(left_text: String, right_text: String, alpha: float) -> void:
	scan_status.text = left_text
	scan_status.position = Vector2(32, 66)
	scan_status.size = Vector2(740, 34)
	scan_status.visible = true
	scan_status.modulate.a = alpha
	scan_dot.position = Vector2(1028, 35)
	scan_dot.size = Vector2(10, 10)
	scan_dot.visible = true
	scan_dot.modulate.a = alpha
	kicker.text = right_text
	kicker.position = Vector2(1048, 24)
	kicker.size = Vector2(110, 32)
	kicker.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	kicker.visible = true
	kicker.modulate.a = alpha


func _show_side_copy(text: String, rect: Rect2, font_size: int, alpha: float) -> void:
	side_copy.text = text
	side_copy.position = rect.position
	side_copy.size = rect.size
	side_copy.add_theme_font_size_override("font_size", font_size)
	side_copy.visible = true
	side_copy.modulate.a = alpha


func _show_scan_frame(rect: Rect2, progress: float, label_text: String) -> void:
	var pulse := 0.76 + sin(progress * TAU * 2.0) * 0.16
	scan_frame.position = rect.position
	scan_frame.size = rect.size
	scan_frame.visible = true
	scan_frame.modulate = Color(1.0, 1.0, 1.0, _beat_fade(progress) * pulse)
	caption.text = label_text
	caption.position = rect.position + Vector2(0, rect.size.y + 8)
	caption.size = Vector2(rect.size.x, 32)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.visible = true
	caption.modulate.a = _beat_fade(progress)


func _show_object_tag(index: int, text: String, position: Vector2, progress: float, delay: float) -> void:
	if index < 0 or index >= object_tags.size():
		return
	var entrance := clampf((progress - delay) * 3.2, 0.0, 1.0)
	var tag := object_tags[index]
	tag.text = text
	tag.position = position + Vector2(0, (1.0 - _ease_out(entrance)) * 24.0)
	tag.visible = entrance > 0.001
	tag.modulate.a = _beat_fade(progress) * entrance


func _set_clearhome_stage() -> void:
	backdrop.color = Color(0.024, 0.028, 0.036, 1.0)
	light_band.visible = true
	light_band.color = Color(0.96, 0.72, 0.34, 0.075)


func _show_rule(rule: ColorRect, rect: Rect2, alpha: float) -> void:
	rule.position = rect.position
	rule.size = rect.size
	rule.modulate = Color(1.0, 1.0, 1.0, alpha)
	rule.visible = alpha > 0.001


func _show_kicker(text: String, position: Vector2, size: Vector2, alpha: float, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	kicker.text = text
	kicker.position = position
	kicker.size = size
	kicker.horizontal_alignment = alignment
	kicker.modulate = Color(1.0, 1.0, 1.0, alpha)
	kicker.visible = alpha > 0.001


func _show_headline(text: String, rect: Rect2, font_size: int, alpha: float) -> void:
	headline.text = text
	headline.position = rect.position
	headline.size = rect.size
	headline.add_theme_font_size_override("font_size", font_size)
	headline.modulate = Color(1.0, 1.0, 1.0, alpha)
	headline.visible = alpha > 0.001


func _show_value_card(rect: Rect2, amount: String, detail: String, alpha: float) -> void:
	value_card.position = rect.position
	value_card.size = rect.size
	value_card.modulate = Color(1.0, 1.0, 1.0, alpha)
	value_card.visible = alpha > 0.001
	value_amount.text = amount
	value_amount.size.x = value_card.size.x - 48.0
	value_detail.text = detail
	value_detail.size.x = value_card.size.x - 48.0
	value_detail.position.y = maxf(rect.size.y - 72.0, 82.0)


func _show_metric_card(index: int, rect: Rect2, amount: String, detail: String, progress: float, delay: float) -> void:
	if index < 0 or index >= metric_cards.size():
		return
	var entrance := clampf((progress - delay) * 2.5, 0.0, 1.0)
	var card := metric_cards[index]
	card.position = rect.position + Vector2((1.0 - _ease_out(entrance)) * 58.0, 0.0)
	card.size = rect.size
	card.modulate = Color(1.0, 1.0, 1.0, _beat_fade(progress) * entrance)
	card.visible = entrance > 0.001
	var amount_label := card.get_node("Amount") as Label
	var detail_label := card.get_node("Detail") as Label
	amount_label.text = amount
	amount_label.size.x = rect.size.x - 24.0
	detail_label.text = detail
	detail_label.size.x = rect.size.x - 24.0


func _show_legal_pill(text: String, rect: Rect2, alpha: float) -> void:
	legal_pill.text = text
	legal_pill.position = rect.position
	legal_pill.size = rect.size
	legal_pill.modulate = Color(1.0, 1.0, 1.0, alpha)
	legal_pill.visible = alpha > 0.001


func _beat_fade(progress: float) -> float:
	return minf(clampf(progress * 6.0, 0.0, 1.0), clampf((1.0 - progress) * 9.0, 0.0, 1.0))


func _show_wordmark(title: String, subtitle: String) -> void:
	backdrop.color = Color(0.008, 0.009, 0.012, 1.0)
	wordmark.text = title
	wordmark.visible = true
	headline.text = subtitle
	headline.visible = true
	headline.position = Vector2(180, 476)
	headline.size = Vector2(920, 92)


func _show_art(node: TextureRect, key: String, rect: Rect2, zoom: float = 1.0, alpha: float = 1.0) -> void:
	if not texture_cache.has(key):
		return
	node.texture = texture_cache[key]
	node.position = rect.position
	node.size = rect.size
	node.pivot_offset = rect.size * 0.5
	node.scale = Vector2.ONE * zoom
	node.modulate = Color(1.0, 1.0, 1.0, alpha)
	node.visible = alpha > 0.001


func _soft_fade(progress: float) -> float:
	return minf(clampf(progress * 5.0, 0.0, 1.0), clampf((1.0 - progress) * 7.0, 0.0, 1.0))


func _ease_out(value: float) -> float:
	return 1.0 - pow(1.0 - clampf(value, 0.0, 1.0), 3.0)


func _refresh_transport() -> void:
	if deterministic_movie:
		timer_label.hide()
		progress_bar.hide()
		skip_button.hide()
		return
	progress_bar.value = clampf(total_elapsed / maxf(total_duration, 1.0) * 100.0, 0.0, 100.0)
	timer_label.text = "ADVERTISEMENT  •  %02d" % int(floor(total_elapsed))
	var skip_unlocked := dev_skip_allowed or total_elapsed >= SKIP_UNLOCK_SECONDS
	skip_button.visible = skip_unlocked
	skip_button.disabled = not skip_unlocked
	skip_button.text = "DEV: GRANT REWARD" if dev_skip_allowed and total_elapsed < SKIP_UNLOCK_SECONDS else "SKIP AD"


func _on_skip_pressed() -> void:
	if dev_skip_allowed and total_elapsed < SKIP_UNLOCK_SECONDS:
		_finish_successfully()
		return
	if total_elapsed < SKIP_UNLOCK_SECONDS:
		return
	confirm_shade.visible = true
	voice_player.stream_paused = true
	music_player.stream_paused = true
	video_player.paused = true
	continue_button.call_deferred("grab_focus")


func _close_skip_confirm() -> void:
	confirm_shade.visible = false
	voice_player.stream_paused = false
	music_player.stream_paused = false
	video_player.paused = false
	skip_button.call_deferred("grab_focus")


func _decline_from_confirm() -> void:
	if not active:
		return
	active = false
	voice_player.stop()
	video_player.stop()
	music_player.stop()
	declined.emit("The ad was skipped; the revive was forfeited.")


func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo and key_event.keycode == KEY_ESCAPE:
			if confirm_shade.visible:
				_close_skip_confirm()
			elif skip_button.visible:
				_on_skip_pressed()
			get_viewport().set_input_as_handled()
	elif event is InputEventJoypadButton:
		var joy_event := event as InputEventJoypadButton
		if joy_event.pressed and joy_event.button_index == JOY_BUTTON_B:
			if confirm_shade.visible:
				_close_skip_confirm()
			elif skip_button.visible:
				_on_skip_pressed()
			get_viewport().set_input_as_handled()


func _build_motion_graphics() -> void:
	for art_name in ["PaperArt", "PropArt", "DetailArt", "RobotArt"]:
		var art := TextureRect.new()
		art.name = art_name
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		art.z_index = 3
		stage.add_child(art)
		match art_name:
			"PaperArt": paper_art = art
			"PropArt": prop_art = art
			"DetailArt": detail_art = art
			"RobotArt": robot_art = art

	scan_frame = Panel.new()
	scan_frame.name = "LiveScanFrame"
	scan_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scan_frame.add_theme_stylebox_override("panel", _flat_style(Color(0.0, 0.0, 0.0, 0.02), Color(0.45, 1.0, 0.78, 0.94), 3, 4))
	scan_frame.z_index = 11
	stage.add_child(scan_frame)

	scan_status = Label.new()
	scan_status.name = "LiveStatus"
	scan_status.add_theme_font_size_override("font_size", 15)
	scan_status.add_theme_color_override("font_color", Color(0.58, 1.0, 0.81))
	scan_status.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.95))
	scan_status.add_theme_constant_override("shadow_offset_x", 2)
	scan_status.add_theme_constant_override("shadow_offset_y", 2)
	scan_status.z_index = 24
	stage.add_child(scan_status)

	scan_dot = ColorRect.new()
	scan_dot.name = "LiveDot"
	scan_dot.color = Color(0.30, 1.0, 0.65)
	scan_dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scan_dot.z_index = 24
	stage.add_child(scan_dot)

	live_badge = Label.new()
	live_badge.name = "LiveBrandBadge"
	live_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	live_badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	live_badge.add_theme_font_size_override("font_size", 15)
	live_badge.add_theme_color_override("font_color", Color(0.80, 1.0, 0.91))
	live_badge.add_theme_stylebox_override("normal", _flat_style(Color(0.015, 0.07, 0.055, 0.94), Color(0.40, 1.0, 0.74, 0.72), 1, 6))
	live_badge.z_index = 25
	stage.add_child(live_badge)

	side_copy = Label.new()
	side_copy.name = "SideCopy"
	side_copy.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	side_copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	side_copy.add_theme_color_override("font_color", Color(0.92, 1.0, 0.96))
	side_copy.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.98))
	side_copy.add_theme_constant_override("shadow_offset_x", 3)
	side_copy.add_theme_constant_override("shadow_offset_y", 3)
	side_copy.z_index = 20
	stage.add_child(side_copy)

	for tag_index in range(4):
		var tag := Label.new()
		tag.name = "ObjectTag%d" % (tag_index + 1)
		tag.size = Vector2(236, 38)
		tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		tag.add_theme_font_size_override("font_size", 13)
		tag.add_theme_color_override("font_color", Color(0.77, 1.0, 0.88))
		tag.add_theme_stylebox_override("normal", _flat_style(Color(0.01, 0.06, 0.045, 0.92), Color(0.42, 1.0, 0.72, 0.76), 1, 6))
		tag.z_index = 22
		object_tags.append(tag)
		stage.add_child(tag)

	top_rule = ColorRect.new()
	top_rule.name = "TopRule"
	top_rule.color = Color(0.96, 0.76, 0.34, 0.9)
	top_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_rule.z_index = 12
	stage.add_child(top_rule)

	bottom_rule = ColorRect.new()
	bottom_rule.name = "BottomRule"
	bottom_rule.color = Color(0.96, 0.76, 0.34, 0.9)
	bottom_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom_rule.z_index = 12
	stage.add_child(bottom_rule)

	scanner_line = ColorRect.new()
	scanner_line.name = "AppraisalScanner"
	scanner_line.color = Color(1.0, 0.85, 0.45, 0.72)
	scanner_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scanner_line.z_index = 14
	stage.add_child(scanner_line)

	kicker = Label.new()
	kicker.name = "Kicker"
	kicker.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	kicker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	kicker.add_theme_font_size_override("font_size", 15)
	kicker.add_theme_color_override("font_color", Color(0.98, 0.78, 0.38))
	kicker.z_index = 20
	stage.add_child(kicker)

	body_copy = Label.new()
	body_copy.name = "BodyCopy"
	body_copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_copy.add_theme_font_size_override("font_size", 20)
	body_copy.add_theme_color_override("font_color", Color(0.92, 0.90, 0.84))
	body_copy.z_index = 20
	stage.add_child(body_copy)

	brand_bug = Label.new()
	brand_bug.name = "BrandBug"
	brand_bug.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	brand_bug.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	brand_bug.add_theme_font_size_override("font_size", 16)
	brand_bug.add_theme_color_override("font_color", Color(0.98, 0.86, 0.60))
	brand_bug.add_theme_stylebox_override("normal", _flat_style(Color(0.035, 0.038, 0.045, 0.94), Color(0.96, 0.76, 0.34, 0.7), 1, 6))
	brand_bug.text = "L / T"
	brand_bug.z_index = 22
	stage.add_child(brand_bug)

	value_card = Panel.new()
	value_card.name = "ValueCard"
	value_card.add_theme_stylebox_override("panel", _flat_style(Color(0.035, 0.038, 0.046, 0.96), Color(0.96, 0.76, 0.34, 0.76), 2, 12))
	value_card.z_index = 16
	stage.add_child(value_card)

	value_amount = Label.new()
	value_amount.position = Vector2(24, 24)
	value_amount.size = Vector2(312, 82)
	value_amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_amount.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_amount.add_theme_font_size_override("font_size", 48)
	value_amount.add_theme_color_override("font_color", Color(1.0, 0.88, 0.60))
	value_card.add_child(value_amount)

	value_detail = Label.new()
	value_detail.position = Vector2(24, 112)
	value_detail.size = Vector2(312, 54)
	value_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_detail.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	value_detail.add_theme_font_size_override("font_size", 14)
	value_detail.add_theme_color_override("font_color", Color(0.78, 0.79, 0.80))
	value_card.add_child(value_detail)

	legal_pill = Label.new()
	legal_pill.name = "LegalPill"
	legal_pill.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	legal_pill.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	legal_pill.add_theme_font_size_override("font_size", 12)
	legal_pill.add_theme_color_override("font_color", Color(0.81, 0.79, 0.72))
	legal_pill.add_theme_stylebox_override("normal", _flat_style(Color(0.03, 0.032, 0.038, 0.92), Color(1.0, 1.0, 1.0, 0.18), 1, 10))
	legal_pill.z_index = 21
	stage.add_child(legal_pill)

	for card_index in range(3):
		var card := Panel.new()
		card.name = "MetricCard%d" % (card_index + 1)
		card.add_theme_stylebox_override("panel", _flat_style(Color(0.055, 0.058, 0.068, 0.96), Color(0.96, 0.76, 0.34, 0.42), 1, 10))
		card.z_index = 15
		var amount := Label.new()
		amount.name = "Amount"
		amount.position = Vector2(12, 12)
		amount.size = Vector2(164, 54)
		amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		amount.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		amount.add_theme_font_size_override("font_size", 30)
		amount.add_theme_color_override("font_color", Color(1.0, 0.88, 0.62))
		card.add_child(amount)
		var detail := Label.new()
		detail.name = "Detail"
		detail.position = Vector2(12, 68)
		detail.size = Vector2(164, 34)
		detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		detail.add_theme_font_size_override("font_size", 12)
		detail.add_theme_color_override("font_color", Color(0.78, 0.79, 0.82))
		card.add_child(detail)
		metric_cards.append(card)
		stage.add_child(card)


func _flat_style(fill: Color, border: Color, width: int, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	return style


func _style_controls() -> void:
	for art in [primary_art, secondary_art, tertiary_art]:
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for editorial_label in [wordmark, headline, caption, small_print]:
		editorial_label.z_index = 20
	wordmark.add_theme_color_override("font_color", Color(0.98, 0.90, 0.70))
	wordmark.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.88))
	wordmark.add_theme_constant_override("shadow_offset_x", 4)
	wordmark.add_theme_constant_override("shadow_offset_y", 5)
	for button in [skip_button, confirm_skip_button, continue_button]:
		button.focus_mode = Control.FOCUS_ALL
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.035, 0.027, 0.022, 0.98)
	panel_style.border_color = Color(0.96, 0.78, 0.39, 0.72)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(14)
	confirm_panel.add_theme_stylebox_override("panel", panel_style)


func debug_show_beat(index: int, progress: float = 0.0) -> void:
	if not active:
		return
	voice_player.stop()
	audio_is_playing = false
	completed_elapsed = 0.0
	for beat_index in range(clampi(index, 0, EVIL_BEATS.size())):
		completed_elapsed += float(EVIL_BEATS[beat_index]["duration"])
	current_beat_index = clampi(index, 0, EVIL_BEATS.size() - 1)
	_start_video(current_beat_index)
	beat_duration = float(EVIL_BEATS[current_beat_index]["duration"])
	beat_elapsed = beat_duration * clampf(progress, 0.0, 1.0)
	total_elapsed = completed_elapsed + beat_elapsed
	_reset_visuals()
	_apply_beat_visuals(progress)
	_refresh_transport()


func debug_complete() -> void:
	_finish_successfully()
