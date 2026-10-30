extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var journal = load("res://scripts/replay/replay_journal.gd").new()
	var bad_records := [
		{"format": 1, "game_version": "1", "seed": 1, "events": [{"tick": -1, "action": "move_right", "pressed": true}], "waves": []},
		{"format": 1, "game_version": "1", "seed": 1, "events": [{"tick": 3, "action": "move_right", "pressed": "yes"}], "waves": []},
		{"format": 1, "game_version": "1", "seed": 1, "events": [], "waves": [{"wave": 0, "tick": 0}]},
		{"format": 1, "game_version": "1", "seed": 1, "events": [{"tick": 5, "action": "x", "pressed": true}, {"tick": 4, "action": "x", "pressed": false}], "waves": []}
	]
	for record in bad_records:
		if not journal.decode(JSON.stringify(record).to_utf8_buffer()).is_empty():
			printerr("FAIL: invalid replay data was accepted")
			quit(1)
			return
	print("REPLAY_VALIDATION_PASS")
	quit(0)
