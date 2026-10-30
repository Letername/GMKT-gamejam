extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	if not ResourceLoader.exists("res://scripts/replay/replay_journal.gd"):
		printerr("FAIL: replay journal is missing")
		quit(1)
		return
	var journal = load("res://scripts/replay/replay_journal.gd").new()
	journal.begin("1.3.4", 12345)
	journal.record_input(1, "move_right", true)
	journal.record_wave(1, 1)
	journal.record_input(25, "move_right", false)
	journal.record_wave(2, 30)
	var bytes: PackedByteArray = journal.encode()
	var decoded: Dictionary = journal.decode(bytes)
	if decoded.get("seed", 0) != 12345 or decoded.get("events", []).size() != 2 or decoded.get("waves", []).size() != 2:
		printerr("FAIL: replay data does not survive round trip")
		quit(1)
		return
	if journal.wave_tick(decoded, 2) != 30 or journal.wave_tick(decoded, 99) != -1:
		printerr("FAIL: wave navigation returns the wrong tick")
		quit(1)
		return
	if not journal.decode(PackedByteArray([1, 2, 3])).is_empty():
		printerr("FAIL: corrupt recordings must be rejected")
		quit(1)
		return
	print("REPLAY_JOURNAL_PASS")
	quit(0)
