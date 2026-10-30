extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var tape = load("res://scripts/replay/replay_tape.gd").new()
	tape.begin("1.3.4", 8123, 60, {"dev_mode": false})
	tape.record_marker(0, "wave", {"round": 1})
	if not tape.record_frame(0, ["move_right", "action"], {"player": {"x": 12.5}}, {"move_right": 0.75}):
		_fail("valid frame was rejected")
		return
	if not tape.record_frame(1, ["move_right"], {"player": {"x": 13.0}}):
		_fail("valid second frame was rejected")
		return
	var bytes: PackedByteArray = tape.encode()
	var decoded: Dictionary = tape.decode(bytes)
	if decoded.is_empty():
		_fail("valid tape failed decoding")
		return
	var player = load("res://scripts/replay/replay_tape.gd").new()
	if not player.load_playback(decoded):
		_fail("decoded tape could not start playback")
		return
	var first: Dictionary = player.next_frame()
	if first.get("tick", -1) != 0 or first.get("held", []).size() != 2 or not first.has("checkpoint"):
		_fail("first playback frame differs")
		return
	if not player.is_action_just_pressed("move_right") or not is_equal_approx(player.get_action_strength("move_right"), 0.75):
		_fail("playback action state was not restored")
		return
	if player.next_frame().get("tick", -1) != 1 or player.is_action_just_pressed("move_right") or not player.next_frame().is_empty():
		_fail("playback cursor did not end at tape boundary")
		return
	if player.data.get("metadata", {}).get("dev_mode", true) or player.marker_tick("wave") != 0:
		_fail("run metadata or wave markers were not preserved")
		return
	if not player.seek(0) or player.next_frame().get("tick", -1) != 0:
		_fail("playback seek did not restore the requested tick")
		return
	var envelope_parser := JSON.new()
	var raw_envelope: PackedByteArray = bytes.decompress(32 * 1024 * 1024, FileAccess.COMPRESSION_GZIP)
	envelope_parser.parse(raw_envelope.get_string_from_utf8())
	var envelope: Dictionary = envelope_parser.data
	var altered_payload: String = String(envelope["payload"]).replace("\"seed\":8123", "\"seed\":8124")
	var damaged := JSON.stringify({"payload": altered_payload, "sha256": envelope["sha256"]}).to_utf8_buffer().compress(FileAccess.COMPRESSION_GZIP)
	if not tape.decode(damaged).is_empty():
		_fail("tampered replay must fail digest validation")
		return
	var invalid = load("res://scripts/replay/replay_tape.gd").new()
	invalid.begin("1.3.4", 1, 60)
	if invalid.record_frame(1, []) or invalid.record_frame(0, ["move_left", "move_left"]):
		_fail("invalid frame ordering or duplicate actions were accepted")
		return
	if invalid.record_frame(0, [], {"bad": INF}):
		_fail("non-finite checkpoint state was accepted")
		return
	print("REPLAY_TAPE_PASS")
	quit(0)

func _fail(message: String) -> void:
	printerr("FAIL: " + message)
	quit(1)
