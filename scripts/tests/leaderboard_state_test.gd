extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var path := "user://leaderboard_state_test.cfg"
	if not ResourceLoader.exists("res://scripts/leaderboard/leaderboard_state.gd"):
		printerr("FAIL: persistent leaderboard state missing")
		quit(1)
		return
	var state = load("res://scripts/leaderboard/leaderboard_state.gd").new()
	state.path = path
	state.set_identity("player-1", "secret-1", "Bob")
	if not state.queue_run("run-1", 4, "user://run-1.replay", false):
		printerr("FAIL: normal score must be queued")
		quit(1)
		return
	if state.queue_run("dev-run", 20, "user://dev.replay", true):
		printerr("FAIL: dev-assisted score was queued")
		quit(1)
		return
	state.mark_score_submitted("run-1")
	var restored = load("res://scripts/leaderboard/leaderboard_state.gd").new()
	restored.path = path
	if not restored.load_state() or restored.installation_secret != "secret-1" or restored.pending.size() != 1 or not restored.pending[0].score_submitted:
		printerr("FAIL: pending upload did not survive restart")
		quit(1)
		return
	restored.mark_replay_uploaded("run-1")
	if not restored.pending.is_empty():
		printerr("FAIL: completed upload remains queued")
		quit(1)
		return
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("LEADERBOARD_STATE_PASS")
	quit(0)
