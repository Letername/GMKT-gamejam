extends SceneTree

const AD_SCENE := preload("res://scenes/ads/spare_ad.tscn")
const EXPECTED_BALANCES := [67.69, 61.0, 59.0, 57.0, 49.0, 47.0, 45.0, 44.0, 43.0, 42.0, 42.0, 0.0]

var failures: Array[String] = []
var completed_count := 0
var decline_reason := ""
var reward_count := 0


func _initialize() -> void:
	call_deferred("_run")


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)


func _run() -> void:
	root.size = Vector2i(1280, 720)
	create_timer(20.0, true, false, true).timeout.connect(func():
		push_error("SPARE_AD_SMOKE_TIMEOUT")
		quit(1)
	)
	var service = root.get_node_or_null("AdService")
	_check(service != null, "AdService autoload is required.")
	if service == null:
		_finish()
		return
	_check(AudioServer.get_bus_index("AdAudio") >= 0, "AdAudio bus must exist.")
	var player = AD_SCENE.instantiate()
	root.add_child(player)
	await process_frame
	_check(not player.active and not player.visible, "The ad must start hidden and idle.")
	_check(not player.voice.playing and not player.music.playing, "Opening the scene must not autostart sound.")
	_check(player.beats.size() == 12, "All twelve recorded lines must load.")
	_check(absf(player.total_duration - 60.0) < 0.15, "The recorded edit must target 60 seconds including its end card.")
	for beat in player.beats:
		var path := String(beat["audio"])
		var audio := load(path) as AudioStream
		_check(audio != null and audio.get_length() > 0.1, "Recorded line must load: " + path)
		_check(float(beat["duration"]) >= float(beat["voice_duration"]), "Beat cannot truncate its voice: " + path)
	_check(player.process_mode == Node.PROCESS_MODE_ALWAYS, "Ad must process while the tree is paused.")
	for audio_player in [player.voice, player.music, player.chime]:
		_check(audio_player.process_mode == Node.PROCESS_MODE_ALWAYS and audio_player.bus == "AdAudio", "All ad sound must continue through the dedicated bus while paused.")
	player.completed.connect(func(): completed_count += 1)
	player.declined.connect(func(reason: String): decline_reason = reason)
	player.play_ad("spare", false)
	_check(player.active and player.voice.stream != null and player.music.stream != null, "The playable edit must load narration and licensed music.")
	_check(player.video.stream != null, "Opening footage must load.")
	_check(player.FOOTAGE_SHOTS.size() == 6, "The recut must use the six distinct source recordings.")
	var sources: Array[String] = []
	var allowed_lengths := {"wallet": 5.57, "screen": 5.85, "reach": 2.49, "headphones": 4.16, "typing": 5.80, "empty": 2.17}
	for shot in player.FOOTAGE_SHOTS:
		var source := String(shot["source"])
		_check(not sources.has(source), "A source recording must not repeat: " + source)
		sources.append(source)
		var shot_beat: Dictionary = player.beats[int(shot["beat"])]
		var shown_length := minf(float(shot["to"]), float(shot_beat["duration"])) - float(shot["from"])
		_check(shown_length > 0.0 and shown_length <= float(allowed_lengths[source]), "An insert must end before its footage runs out: " + source)
		var midpoint := float(shot_beat["start"]) + float(shot["from"]) + shown_length * 0.5
		player.debug_show_time(midpoint)
		_check(player.is_footage_shot(), "Every planned insert must route to footage: " + source)
	for app_time in [12.0, 15.0, 25.0, 28.0, 36.5, 42.0, 45.0, 50.0, 56.7]:
		player.debug_show_time(app_time)
		_check(not player.is_footage_shot() and not player.video.visible, "Repeated footage must be replaced by an app screen at %.1f seconds." % app_time)
	player.debug_show_time(0.0)
	paused = true
	_check(player.video.can_process(), "Footage must process while gameplay is paused.")
	paused = false
	player.set_process(false)
	player.debug_show_time(0.0)
	_check(is_equal_approx(player.current_balance(), 67.69), "Opening balance must be exactly EUR 67.69.")
	var last_balance := 67.69
	for index in range(player.beats.size()):
		var beat: Dictionary = player.beats[index]
		var time := float(beat["start"]) + float(beat["duration"]) * 0.97
		player.debug_show_time(time)
		var balance: float = player.current_balance()
		_check(absf(balance - EXPECTED_BALANCES[index]) < 0.011, "Unexpected account result after beat %d." % index)
		_check(balance >= -0.001 and balance <= last_balance + 0.001, "Transfers must only drain the account, without a negative balance.")
		last_balance = balance
	var motto: Dictionary = player.beats[11]
	player.debug_show_time(float(motto["start"]) + float(motto["voice_duration"]) - 0.05)
	_check(is_zero_approx(player.current_balance()), "The account must reach zero during the spoken motto, before its trailing hold.")
	player.debug_show_time(player.total_duration - 0.1)
	_check(is_zero_approx(player.current_balance()), "The final end card must follow a zero balance.")
	_check(player.current_beat_index == 12, "The final 1.8-second hold must show the company end card.")
	player.debug_show_time(14.9)
	player.completed_elapsed = float(player.beats[player.current_beat_index]["start"])
	player._process(0.0)
	_check(not player.skip_button.visible, "Skip must remain hidden before fifteen seconds.")
	player._ask_skip()
	_check(not player.confirm.visible and player.active, "An early skip attempt must not decline or open confirmation.")
	player.debug_show_time(15.1)
	player.completed_elapsed = float(player.beats[player.current_beat_index]["start"])
	player._process(0.0)
	_check(player.skip_button.visible, "Skip must unlock after fifteen seconds.")
	player._begin_beat(4)
	player.total_elapsed = 20.0
	player._ask_skip()
	_check(player.confirm.visible, "Ordinary skip must ask whether to forfeit the revive.")
	_check(player.voice.stream_paused and player.music.stream_paused and player.video.paused, "Confirmation must pause narration, music and footage.")
	var held_time: float = player.total_elapsed
	player._process(0.5)
	_check(is_equal_approx(player.total_elapsed, held_time), "The ad clock must stop during confirmation.")
	player._close_confirm()
	_check(not player.confirm.visible and not player.voice.stream_paused and not player.music.stream_paused and not player.video.paused, "Keep watching must resume every paused stream.")
	player._ask_skip()
	player._decline()
	_check(not decline_reason.is_empty() and not player.active and completed_count == 0, "Declining must explain the forfeited revive and never reward.")
	player.queue_free()
	await process_frame

	service.rewarded.connect(func(_creative: String): reward_count += 1)
	_check(service.request_rewarded_ad("evil", true), "The existing game creative ID must launch the new Spare player.")
	await process_frame
	var service_player = service.active_player
	_check(paused and service_player != null, "Service must truly pause gameplay during the ad.")
	if service_player != null:
		_check(service_player.get_script().resource_path == "res://scripts/ads/spare_ad.gd", "Service must be wired to the new Spare scene.")
		if service_player.get_script().resource_path == "res://scripts/ads/spare_ad.gd":
			service_player._ask_skip()
		else:
			service_player.debug_complete()
	await process_frame
	_check(reward_count == 1 and not paused and service.active_player == null, "Developer skip must reward once, retire the ad and restore an unpaused tree.")
	paused = true
	_check(service.request_rewarded_ad("evil", true), "Ad must also launch from an already paused tree.")
	await process_frame
	if service.active_player != null:
		service.active_player.debug_complete()
	await process_frame
	_check(paused and reward_count == 2 and service.active_player == null, "Completion must preserve a previously paused tree.")
	paused = false
	_finish()


func _finish() -> void:
	paused = false
	if failures.is_empty():
		print("SPARE_AD_SMOKE_PASS")
		quit(0)
	else:
		print("SPARE_AD_SMOKE_FAIL count=%d" % failures.size())
		quit(1)
