extends SceneTree

const HOST_SCRIPT = preload("res://scripts/leaderboard/leaderboard_host.gd")

class MockTransport extends Node:
	signal completed(operation: String, result: Dictionary, status: int)
	signal download_completed(operation: String, body: PackedByteArray, status: int, result: int)
	var calls: Array[Dictionary] = []

	func request_json(operation: String, method: HTTPClient.Method, route: String, payload: Dictionary = {}, token: String = "") -> bool:
		calls.append({"kind": "json", "operation": operation, "method": method, "route": route, "payload": payload.duplicate(true), "token": token})
		return true

	func upload(operation: String, route: String, bytes: PackedByteArray, token: String) -> bool:
		calls.append({"kind": "upload", "operation": operation, "route": route, "bytes": bytes, "token": token})
		return true

	func download(operation: String, route: String) -> bool:
		calls.append({"kind": "download", "operation": operation, "route": route})
		return true

	func finish(result: Dictionary, status: int) -> void:
		var call: Dictionary = calls.back()
		completed.emit(String(call.operation), result, status)

	func finish_download(body: PackedByteArray, status: int = 200, result: int = HTTPRequest.RESULT_SUCCESS) -> void:
		var call: Dictionary = calls.back()
		download_completed.emit(String(call.operation), body, status, result)


var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var host = HOST_SCRIPT.new()
	root.add_child(host)
	var unique := str(OS.get_process_id())
	host.state = preload("res://scripts/leaderboard/leaderboard_state.gd").new()
	host.state.path = "user://leaderboard_host_test_%s.cfg" % unique
	host.state.save_state()
	var mock := MockTransport.new()
	host.http = mock
	_check(host.setup(root, "https://scores.example"), "host accepts HTTPS service URL")
	await process_frame
	var replay_path := "user://leaderboard_host_replay_%s.bin" % unique
	var replay_file := FileAccess.open(replay_path, FileAccess.WRITE)
	replay_file.store_buffer(PackedByteArray([1, 2, 3, 4]))
	replay_file.close()
	var player_id := "123e4567-e89b-42d3-a456-426614174000"
	var run_id := "123e4567-e89b-42d3-b456-426614174001"
	_check(host._is_uuid(host._new_uuid()), "report request IDs use UUID format")
	_check(host.open_game_over(7, run_id, 7, replay_path, false) != null, "first completed run opens leaderboard prompt")
	_check(host.panel.visible and host.panel._snapshot["nickname_prompt_pending"], "first end screen shows nickname prompt without a menu visit")
	_check(host.panel.find_child("PublicRecordingNotice", true, false) != null, "first end screen shows public recording disclosure")
	_check(host.state.pending.size() == 1, "queued run is persisted before network activity")
	_check(not host.queue_completed_run("invalid", 7, replay_path, false), "invalid run UUID is rejected")
	_check(not host.queue_completed_run("123e4567-e89b-42d3-b456-426614174002", 7, replay_path, true), "Dev Mode runs are excluded")
	var persisted_state = preload("res://scripts/leaderboard/leaderboard_state.gd").new()
	persisted_state.path = host.state.path
	_check(persisted_state.load_state() and persisted_state.pending.size() == 1, "offline queue survives a state reload")
	_check(host.register_identity("A"), "registration request starts")
	_check(mock.calls.back()["route"] == "/api/player" and mock.calls.back()["payload"]["nickname"] == "A", "first nickname uses player registration endpoint")
	mock.finish({"installation_id": player_id, "installation_secret": "S".repeat(64), "nickname": "A"}, 201)
	_check(mock.calls.back()["operation"] == "score:%s" % run_id, "registration resumes queued score upload")
	_check(mock.calls.back()["payload"]["wave"] == 7 and mock.calls.back()["payload"]["run_id"] == run_id, "score payload follows service contract")
	_check(mock.calls.back()["token"] == "S".repeat(64), "player routes use the installation secret")
	mock.finish({"accepted": true, "is_best": true}, 200)
	_check(mock.calls.back()["kind"] == "upload", "replay uploads only after score acceptance")
	_check(mock.calls.back()["route"] == "/api/replays/%s?installation_id=%s" % [run_id, player_id], "replay upload route matches service contract")
	_check(mock.calls.back()["bytes"] == PackedByteArray([1, 2, 3, 4]), "replay bytes are sent unmodified")
	mock.finish({"uploaded": true, "status": "ready"}, 201)
	_check(host.state.pending.is_empty(), "completed replay upload clears retry queue")
	var call_count := mock.calls.size()
	_check(host.register_identity("B"), "changed nickname starts authenticated rename")
	_check(mock.calls.back()["route"] == "/api/player" and mock.calls.back()["method"] == HTTPClient.METHOD_PATCH and mock.calls.back()["payload"]["nickname"] == "B", "changed name uses player PATCH")
	mock.finish({"updated": true, "nickname": "B"}, 200)
	_check(host.state.nickname == "B" and host.state.pending_nickname.is_empty(), "successful rename updates persisted identity")
	call_count = mock.calls.size()
	_check(host.register_identity("B"), "same nickname reuses identity")
	_check(mock.calls.size() == call_count, "same nickname does not issue unnecessary rename")
	var retry_id := "123e4567-e89b-42d3-b456-426614174003"
	host._retry_timer.wait_time = 0.05
	_check(host.queue_completed_run(retry_id, 8, replay_path, false), "new run queues for upload")
	mock.finish({"network_error": 2}, 0)
	_check(host.state.pending.size() == 1 and host._retry_timer.time_left > 0.0, "transient failure preserves data and schedules retry")
	await create_timer(0.12).timeout
	_check(mock.calls.back()["operation"] == "score:%s" % retry_id, "transient failure retries automatically")
	mock.finish({"network_error": 2}, 0)
	host._retry_timer.stop()
	host.open_menu()
	_check(mock.calls.back()["route"] == "/api/leaderboard?limit=100", "reopening menu refreshes service data")
	mock.finish({"scores": []}, 200)
	mock.finish({"rank": 1}, 200)
	_check(mock.calls.back()["operation"] == "score:%s" % retry_id, "reopening resumes queued score upload")
	mock.finish({"accepted": true}, 200)
	_check(mock.calls.back()["kind"] == "upload", "retried score resumes replay upload")
	mock.finish({"uploaded": true}, 201)
	_check(host.state.pending.is_empty(), "retried upload clears queue only after replay receipt")

	host.request_leaderboard("A Name")
	_check(mock.calls.back()["route"] == "/api/leaderboard?limit=100&nickname=A%20Name", "search uses encoded leaderboard query")
	mock.finish({"scores": [{"rank": 1, "entry_id": player_id, "nickname": "A Name", "wave": 7, "run_id": run_id, "replay_status": "ready"}]}, 200)
	_check(mock.calls.back()["route"] == "/api/players/%s/rank" % player_id, "own rank uses stable installation ID")
	mock.finish({"rank": 1}, 200)
	_check(host.panel._snapshot["own_rank"] == 1 and host.panel._snapshot["entries"][0]["replay_available"], "service scores and replay state reach panel")
	var replay_signal: Array = []
	var downloaded: Array = []
	host.replay_downloaded.connect(func(requested_run, bytes): downloaded.append([requested_run, bytes]))
	host.replay_open_requested.connect(func(requested_run, entry):
		replay_signal.append([requested_run, entry])
		host.download_replay(requested_run)
	)
	host.panel.replay_requested.emit(player_id)
	_check(replay_signal == [[run_id, player_id]], "replay button emits a game handoff without claiming playback")
	_check(mock.calls.back()["kind"] == "download" and mock.calls.back()["route"] == "/api/replays/%s" % run_id, "game handoff downloads the public replay bytes")
	mock.finish_download(PackedByteArray([1, 2, 3, 4]))
	_check(downloaded.size() == 1 and downloaded[0][0] == run_id and downloaded[0][1] == PackedByteArray([1, 2, 3, 4]), "replay download is delivered to the game for validation")

	host._submit_report(player_id, "broken_replay", "Replay does not open")
	_check(mock.calls.back()["route"] == "/api/reports" and mock.calls.back()["payload"]["installation_id"] == player_id, "report includes target entry")
	_check(mock.calls.back()["payload"]["details"].length() >= 5 and mock.calls.back()["payload"]["request_id"].length() == 36, "report details and idempotency ID satisfy worker requirements")
	mock.finish({"report_id": "123e4567-e89b-42d3-a456-426614174010", "status": "open"}, 201)

	host.set_dev_mode_active(true)
	host._request_moderator_access("M".repeat(40))
	_check(mock.calls.back()["route"] == "/api/moderation/reports" and mock.calls.back()["token"] == "M".repeat(40), "moderator code is sent only to server protected route")
	mock.finish({"reports": [{"report_id": "123e4567-e89b-42d3-a456-426614174010", "entry_id": player_id, "category": "broken_replay", "status": "open", "score_hidden": false, "nickname": "A Name", "player_nickname": "A Name"}]}, 200)
	_check(host.panel._snapshot["moderator_authorized"] and host.panel._snapshot["moderator_actions"].size() == 1, "moderator list renders only after service authorization")
	host._moderator_action("hide_score", "123e4567-e89b-42d3-a456-426614174010")
	_check(mock.calls.back()["method"] == HTTPClient.METHOD_PATCH and mock.calls.back()["payload"]["hide_score"] == true, "hide score uses reversible service action")
	mock.finish({"updated": true, "score_hidden": true}, 200)
	_check(mock.calls.back()["route"] == "/api/moderation/reports", "successful moderation refreshes authoritative report state")
	mock.finish({"reports": []}, 200)
	host._moderator_action("hide_name", "123e4567-e89b-42d3-a456-426614174010")
	_check(mock.calls.back()["payload"]["hide_name"] == true, "name hiding uses the backend moderation contract")
	mock.finish({"updated": true, "name_hidden": true}, 200)
	mock.finish({"reports": []}, 200)
	host._moderator_action("restore_name", "123e4567-e89b-42d3-a456-426614174010")
	_check(mock.calls.back()["payload"]["hide_name"] == false and not mock.calls.back()["payload"].has("restore_nickname"), "name restoration uses backend canonical-name flag")
	mock.finish({"updated": true, "name_hidden": false}, 200)
	mock.finish({"reports": []}, 200)
	host.set_dev_mode_active(false)
	_check(host._moderator_token.is_empty() and not host.panel._snapshot["dev_mode"], "leaving Dev Mode clears in-memory moderator code")
	host.close_panel()
	_check(not host.panel.visible, "close hides the panel")
	host.open_menu()
	_check(host.panel.visible, "reopening the menu restores the panel")
	_check(mock.calls.back()["route"] == "/api/leaderboard?limit=100", "menu reopen refreshes service data")
	mock.finish({"scores": []}, 200)
	mock.finish({"rank": 1}, 200)

	var startup_path := "user://leaderboard_startup_test_%s.cfg" % unique
	var startup_state = preload("res://scripts/leaderboard/leaderboard_state.gd").new()
	startup_state.path = startup_path
	startup_state.set_identity(player_id, "T".repeat(64), "Startup")
	var startup_run := "123e4567-e89b-42d3-b456-426614174004"
	startup_state.queue_run(startup_run, 9, replay_path, false)
	var startup_host = HOST_SCRIPT.new()
	root.add_child(startup_host)
	startup_host.state = startup_state
	var startup_mock := MockTransport.new()
	startup_host.http = startup_mock
	_check(startup_host.setup(root, "https://scores.example"), "startup host accepts service URL")
	await process_frame
	_check(startup_mock.calls.size() == 1 and startup_mock.calls[0]["operation"] == "score:%s" % startup_run, "startup automatically retries persisted runs")
	startup_mock.finish({"accepted": true}, 200)
	_check(startup_mock.calls.back()["kind"] == "upload", "startup retry uploads saved replay after score")
	startup_mock.finish({"uploaded": true}, 201)
	_check(startup_host.state.pending.is_empty(), "startup retry clears run only after replay upload")
	startup_host.queue_free()

	var recovery_path := "user://leaderboard_recovery_test_%s.cfg" % unique
	var recovered := preload("res://scripts/leaderboard/leaderboard_state.gd").new()
	recovered.path = recovery_path
	var backup := ConfigFile.new()
	backup.set_value("identity", "id", player_id)
	backup.set_value("identity", "secret", "R".repeat(64))
	backup.set_value("identity", "nickname", "Recovered")
	backup.set_value("uploads", "pending", [{"run_id": run_id, "wave": 7, "replay_path": replay_path, "score_submitted": false}])
	backup.save(recovery_path + ".bak")
	var corrupt := FileAccess.open(recovery_path, FileAccess.WRITE)
	corrupt.store_string("interrupted config write")
	corrupt.close()
	var recovery_ok := recovered.load_state()
	_check(recovery_ok and recovered.nickname == "Recovered" and recovered.pending.size() == 1, "interrupted state replacement recovers valid backup")

	DirAccess.remove_absolute(ProjectSettings.globalize_path(host.state.path))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(startup_path))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(recovery_path))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(recovery_path + ".bak"))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(replay_path))
	host.queue_free()
	await process_frame
	if failures.is_empty():
		print("LEADERBOARD_HOST_TEST_PASS")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
