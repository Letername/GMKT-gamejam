extends SceneTree

const HOST_SCRIPT = preload("res://scripts/leaderboard/leaderboard_host.gd")
const STATE_SCRIPT = preload("res://scripts/leaderboard/leaderboard_state.gd")

const PLAYER_ID_PATH := "user://leaderboard_http_e2e_%s.cfg"
const MODERATOR_CODE := "local-e2e-moderator-secret-0123456789abcdef"

var failures: Array[String] = []
var host
var replay_path := ""
var state_path := ""


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var unique := str(OS.get_process_id())
	state_path = PLAYER_ID_PATH % unique
	replay_path = "user://leaderboard_http_e2e_%s.replay" % unique
	host = HOST_SCRIPT.new()
	root.add_child(host)
	host.state = STATE_SCRIPT.new()
	host.state.path = state_path
	_check(host.setup(root, "http://127.0.0.1:38893"), "host accepts local HTTP test endpoint")
	await process_frame
	host._retry_timer.wait_time = 0.12
	var recording := FileAccess.open(replay_path, FileAccess.WRITE)
	recording.store_buffer(PackedByteArray([0x52, 0x50, 0x4c, 0x59, 1, 2, 3]))
	recording.close()
	var run_id := "123e4567-e89b-42d3-b456-426614174100"
	_check(host.open_game_over(11, run_id, 11, replay_path, false) != null, "first final outcome opens the prompt")
	_check(host.panel.visible and host.panel.find_child("PublicRecordingNotice", true, false) != null, "first outcome shows public upload notice")
	_check(host.state.pending.size() == 1, "completed run is queued before registration")
	_check(host.register_identity("E2E Player"), "registration request starts")
	var upload_done := await _wait_until(func(): return host.state.pending.is_empty(), 12.0)
	_check(upload_done, "queue retry completes score and replay upload over HTTP")
	_check(not host.state.installation_id.is_empty() and host.state.installation_secret.length() >= 32, "registration credentials persist from Worker response")

	host.request_leaderboard("E2E")
	var board_done := await _wait_until(func(): return String(host.panel._snapshot.get("backend_status", "")) == "online" and int(host.panel._snapshot.get("own_rank", 0)) == 1, 5.0)
	_check(board_done, "Worker leaderboard and own-rank routes return data")
	var entries: Array = host.panel._snapshot.get("entries", [])
	_check(entries.size() == 1 and entries[0].get("nickname", "") == "E2E Player" and entries[0].get("replay_available", false), "uploaded score and ready replay appear in public top 100")
	var entry_id := String(entries[0].get("entry_id", "")) if not entries.is_empty() else ""
	_check(entry_id == host.state.installation_id, "public result returns stable installation ID")

	host._submit_report(entry_id, "broken_replay", "Please inspect this uploaded replay.")
	_check(await _wait_until(func(): return String(host.panel._snapshot.get("status_message", "")) == "Report received by the service.", 5.0), "report upload reaches Worker and R2 stub")

	host.set_dev_mode_active(true)
	host._request_moderator_access("incorrect-local-moderator-code-0123456789")
	_check(await _wait_until(func(): return host._busy_operation.is_empty(), 5.0), "wrong moderator code request completes")
	_check(host._moderator_token.is_empty() and not bool(host.panel._snapshot.get("moderator_authorized", false)), "wrong code is rejected by Worker")
	host._request_moderator_access(MODERATOR_CODE)
	_check(await _wait_until(func(): return bool(host.panel._snapshot.get("moderator_authorized", false)), 5.0), "correct moderator code is accepted by Worker")
	var actions: Array = host.panel._snapshot.get("moderator_actions", [])
	_check(actions.size() == 1 and (String(actions[0].get("details", "")).contains("uploaded replay") if not actions.is_empty() else false), "moderator view includes report details from R2")
	var report_id := String(actions[0].get("entry_id", "")) if not actions.is_empty() else ""
	host._moderator_action("hide_score", report_id)
	_check(await _wait_until(func(): return _has_moderator_flag(host, "score_hidden", true), 5.0), "authorized moderator can hide score reversibly")
	host._moderator_action("hide_name", report_id)
	_check(await _wait_until(func(): return _has_moderator_flag(host, "name_hidden", true), 5.0), "authorized moderator can hide name reversibly")
	host._moderator_action("restore_score", report_id)
	_check(await _wait_until(func(): return _has_moderator_flag(host, "score_hidden", false), 5.0), "moderator can restore hidden score")
	host._moderator_action("restore_name", report_id)
	_check(await _wait_until(func(): return _has_moderator_flag(host, "name_hidden", false), 5.0), "moderator can restore canonical player name")

	host.close_panel()
	host.queue_free()
	await process_frame
	if FileAccess.file_exists(state_path): DirAccess.remove_absolute(ProjectSettings.globalize_path(state_path))
	if FileAccess.file_exists(state_path + ".bak"): DirAccess.remove_absolute(ProjectSettings.globalize_path(state_path + ".bak"))
	if FileAccess.file_exists(state_path + ".tmp"): DirAccess.remove_absolute(ProjectSettings.globalize_path(state_path + ".tmp"))
	if FileAccess.file_exists(replay_path): DirAccess.remove_absolute(ProjectSettings.globalize_path(replay_path))
	if failures.is_empty():
		print("LEADERBOARD_HOST_HTTP_E2E_PASS")
		quit(0)
	else:
		for failure in failures: push_error(failure)
		quit(1)


func _has_moderator_flag(host_node, field: String, expected: bool) -> bool:
	var actions: Array = host_node.panel._snapshot.get("moderator_actions", [])
	return not actions.is_empty() and bool(actions[0].get(field, false)) == expected


func _wait_until(condition: Callable, timeout_seconds: float) -> bool:
	var attempts := int(timeout_seconds / 0.05)
	for _index in attempts:
		if condition.call(): return true
		await create_timer(0.05).timeout
	return condition.call()


func _check(ok: bool, message: String) -> void:
	if not ok: failures.append(message)
