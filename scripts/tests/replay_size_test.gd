extends SceneTree

const FRAME_COUNT := 60_000

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var tape = load("res://scripts/replay/replay_tape.gd").new()
	if not tape.begin("tax-season-siege-1.3.4", 998877, 60, {"dev_mode": false}):
		_fail("size test tape did not initialize")
		return
	for tick in range(FRAME_COUNT):
		if tick % 3600 == 0:
			tape.record_marker(tick, "wave", {"round": int(tick / 3600) + 1})
		var held: Array = ["move_right"] if tick % 3 != 0 else []
		var strengths := {"move_right": 0.75} if not held.is_empty() else {}
		var checkpoint := {"state_hash": "%064x" % tick} if tick % 30 == 0 else {}
		if not tape.record_frame(tick, held, checkpoint, strengths, 1.0 / 60.0):
			_fail("representative long tape stopped at frame %d" % tick)
			return
	var started := Time.get_ticks_msec()
	var encoded: PackedByteArray = tape.encode()
	var elapsed := Time.get_ticks_msec() - started
	if encoded.is_empty() or encoded.size() > 5 * 1024 * 1024:
		_fail("10 minute representative tape did not fit the 5 MiB upload ceiling")
		return
	var restored: Dictionary = tape.decode(encoded)
	if restored.is_empty() or restored["frames"].size() != FRAME_COUNT or tape.marker_tick("wave", 1) != 3600:
		_fail("long tape roundtrip lost frames or wave markers")
		return
	print("REPLAY_SIZE_PASS frames=%d raw_estimate=%d compressed_bytes=%d encode_ms=%d" % [FRAME_COUNT, JSON.stringify(tape.data).to_utf8_buffer().size(), encoded.size(), elapsed])
	quit(0)

func _fail(message: String) -> void:
	printerr("FAIL: " + message)
	quit(1)
