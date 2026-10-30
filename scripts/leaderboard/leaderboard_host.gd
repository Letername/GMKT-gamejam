class_name LeaderboardHost
extends Node
## Game-facing controller. Networking and trust decisions stay behind the service API.

signal replay_open_requested(run_id: String, entry_id: String)
signal replay_downloaded(run_id: String, bytes: PackedByteArray)
signal replay_download_failed(run_id: String, message: String)
signal status_changed(snapshot: Dictionary)

const PANEL_SCRIPT := preload("res://scripts/leaderboard/leaderboard_panel.gd")
const HTTP_SCRIPT := preload("res://scripts/leaderboard/leaderboard_http.gd")
const STATE_SCRIPT := preload("res://scripts/leaderboard/leaderboard_state.gd")
const UUID_PATTERN := "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-8][0-9a-fA-F]{3}-[89aAbB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"

var game: Node
var base_url := ""
var state
var http
var panel
var dev_mode_active := false
var _canvas_layer: CanvasLayer
var _snapshot: Dictionary = {}
var _busy_operation := ""
var _search_query := ""
var _moderator_token := ""
var _entry_runs: Dictionary = {}
var _last_game_over := {"score": 0, "run_id": "", "wave": 0}
var _retry_timer: Timer


func setup(game_node: Node, service_base_url: String) -> bool:
	if game_node == null:
		return false
	game = game_node
	base_url = service_base_url.trim_suffix("/")
	if not base_url.begins_with("https://") and not base_url.begins_with("http://127.0.0.1:"):
		return false
	if state == null:
		state = STATE_SCRIPT.new()
	state.load_state()
	if http == null:
		http = HTTP_SCRIPT.new()
		http.base_url = base_url
	if http.get_parent() == null:
		add_child(http)
	if not http.completed.is_connected(_on_http_completed):
		http.completed.connect(_on_http_completed)
	if http.has_signal("download_completed") and not http.download_completed.is_connected(_on_http_download_completed):
		http.download_completed.connect(_on_http_download_completed)
	_make_panel()
	_retry_timer = Timer.new()
	_retry_timer.name = "LeaderboardRetryTimer"
	_retry_timer.one_shot = true
	_retry_timer.wait_time = 15.0
	add_child(_retry_timer)
	_retry_timer.timeout.connect(_retry_pending_uploads)
	_update_snapshot("offline", "Ready to connect. Leaderboard data appears after a service response.")
	_retry_pending_uploads()
	return true


func set_dev_mode_active(enabled: bool) -> void:
	dev_mode_active = enabled
	if not enabled:
		_moderator_token = ""
	_snapshot["moderator_authorized"] = false
	_update_snapshot(String(_snapshot.get("backend_status", "offline")), String(_snapshot.get("status_message", "")))


func open_menu() -> Control:
	if panel == null:
		return null
	panel.open_for_menu()
	_refresh_leaderboard("")
	_retry_pending_uploads()
	return panel


## Call only after the run's final outcome, including any revive, has been resolved.
func open_game_over(score: int, run_id: String, wave: int, replay_path: String, used_dev: bool) -> Control:
	if panel == null:
		return null
	_last_game_over = {"score": maxi(0, score), "run_id": run_id, "wave": wave}
	if not used_dev:
		state.queue_run(run_id, wave, replay_path, false)
	_snapshot["nickname_prompt_pending"] = String(state.nickname).is_empty() and not used_dev
	_snapshot["run_id"] = run_id
	panel.set_snapshot(_build_snapshot())
	panel.open_for_game_over(score, run_id)
	if used_dev:
		_update_snapshot(String(_snapshot.get("backend_status", "offline")), "Dev Mode run excluded from leaderboard submissions.")
	else:
		_retry_pending_uploads()
	return panel


func close_panel() -> void:
	if panel != null:
		panel.hide()
	_moderator_token = ""
	_snapshot["moderator_authorized"] = false
	_update_snapshot(String(_snapshot.get("backend_status", "offline")), String(_snapshot.get("status_message", "")))


## Can be called after replay recording has finalized, or on a later user initiated retry.
func queue_completed_run(run_id: String, wave: int, replay_path: String, used_dev: bool) -> bool:
	if state == null:
		return false
	if not _is_uuid(run_id) or wave < 1 or replay_path.is_empty():
		return false
	var queued := bool(state.queue_run(run_id, wave, replay_path, used_dev))
	if queued:
		_retry_pending_uploads()
		_update_snapshot(String(_snapshot.get("backend_status", "offline")), "Run saved for upload." if not state.installation_id.is_empty() else "Run queued. Choose a nickname to create its leaderboard identity.")
	return queued


func request_leaderboard(query: String = "") -> void:
	_refresh_leaderboard(query)


func retry_pending_uploads() -> void:
	_retry_pending_uploads()


func download_replay(run_id: String) -> bool:
	if not _is_uuid(run_id) or http == null or _busy_operation != "" or not http.has_method("download"):
		return false
	var operation := "download_replay:%s" % run_id
	_busy_operation = operation
	if not http.download(operation, "/api/replays/%s" % run_id.uri_encode()):
		_busy_operation = ""
		_update_snapshot("offline", "Replay download could not start.")
		return false
	_update_snapshot("loading", "Downloading the selected replay…")
	return true


func register_identity(nickname: String) -> bool:
	var clean_name := nickname.strip_edges()
	if clean_name.length() < 1 or clean_name.length() > 24:
		_update_snapshot("error", "Nickname must be 1–24 characters.")
		return false
	if not state.installation_id.is_empty():
		if clean_name == String(state.nickname) and String(state.pending_nickname).is_empty():
			_retry_pending_uploads()
			return true
		state.pending_nickname = clean_name
		state.save_state()
		return _send("rename", HTTPClient.METHOD_PATCH, "/api/player", {"installation_id": state.installation_id, "nickname": clean_name}, state.installation_secret)
	state.nickname = clean_name
	state.save_state()
	return _send("register", HTTPClient.METHOD_POST, "/api/player", {"nickname": clean_name})


func _make_panel() -> void:
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.name = "LeaderboardLayer"
	game.add_child(_canvas_layer)
	panel = PANEL_SCRIPT.new()
	panel.name = "LeaderboardPanel"
	_canvas_layer.add_child(panel)
	panel.hide()
	panel.close_requested.connect(close_panel)
	panel.refresh_requested.connect(_refresh_leaderboard)
	panel.score_submit_requested.connect(register_identity)
	panel.moderation_requested.connect(_request_moderator_access)
	panel.moderation_action_requested.connect(_moderator_action)
	panel.report_requested.connect(_submit_report)
	panel.replay_requested.connect(_request_replay)


func _send(operation: String, method: HTTPClient.Method, route: String, payload: Dictionary = {}, token: String = "") -> bool:
	if http == null or _busy_operation != "":
		return false
	_busy_operation = operation
	if not http.request_json(operation, method, route, payload, token):
		_busy_operation = ""
		_update_snapshot("offline", "Could not start the request. It remains available to retry.")
		return false
	_update_snapshot("loading", "Contacting the leaderboard service…")
	return true


func _refresh_leaderboard(query: String) -> void:
	_search_query = query.strip_edges()
	if _busy_operation != "":
		return
	var route := "/api/leaderboard?limit=100"
	if not _search_query.is_empty():
		route += "&nickname=" + _url_encode(_search_query)
	_send("leaderboard", HTTPClient.METHOD_GET, route)


func _retry_pending_uploads() -> void:
	if state == null or _busy_operation != "":
		return
	if not state.installation_id.is_empty() and not String(state.pending_nickname).is_empty():
		_send("rename", HTTPClient.METHOD_PATCH, "/api/player", {"installation_id": state.installation_id, "nickname": state.pending_nickname}, state.installation_secret)
		return
	if state.installation_id.is_empty():
		if not state.nickname.is_empty():
			register_identity(state.nickname)
		return
	for run in state.pending:
		if not bool(run.get("score_submitted", false)):
			var score_body := {"installation_id": state.installation_id, "run_id": String(run.get("run_id", "")), "nickname": state.nickname, "wave": int(run.get("wave", 0))}
			_send("score:%s" % String(run.get("run_id", "")), HTTPClient.METHOD_POST, "/api/scores", score_body, state.installation_secret)
			return
		_upload_replay(run)
		return


func _upload_replay(run: Dictionary) -> void:
	var replay_path := String(run.get("replay_path", ""))
	if replay_path.is_empty() or not FileAccess.file_exists(replay_path):
		_update_snapshot("error", "A queued replay file is missing; it was kept in the upload queue.")
		return
	var file := FileAccess.open(replay_path, FileAccess.READ)
	if file == null:
		_update_snapshot("error", "Could not read a queued replay; it was kept for retry.")
		return
	var bytes := file.get_buffer(5 * 1024 * 1024 + 1)
	file.close()
	if bytes.is_empty() or bytes.size() > 5 * 1024 * 1024:
		_update_snapshot("error", "Replay must be 1 byte to 5 MiB; queued file was kept.")
		return
	var run_id := String(run.get("run_id", ""))
	_busy_operation = "replay:%s" % run_id
	var route := "/api/replays/%s?installation_id=%s" % [run_id.uri_encode(), state.installation_id.uri_encode()]
	if not http.upload(_busy_operation, route, bytes, state.installation_secret):
		_busy_operation = ""
		_update_snapshot("offline", "Replay upload could not start. It remains queued for retry.")


func _request_moderator_access(code: String) -> void:
	if not dev_mode_active:
		_update_snapshot(String(_snapshot.get("backend_status", "offline")), "Enable Dev Mode before requesting moderator access.")
		return
	if code.strip_edges().is_empty():
		return
	_moderator_token = code
	_send("moderator_reports", HTTPClient.METHOD_GET, "/api/moderation/reports", {}, _moderator_token)


func _moderator_action(action: String, report_id: String) -> void:
	if not dev_mode_active or _moderator_token.is_empty():
		return
	var payload: Dictionary = {"status": "reviewed"}
	match action:
		"dismiss": payload["status"] = "dismissed"
		"hide_score": payload["hide_score"] = true
		"restore_score": payload["hide_score"] = false
		"hide_name": payload["hide_name"] = true
		"restore_name":
			payload["hide_name"] = false
		_:
			return
	_send("moderation_action", HTTPClient.METHOD_PATCH, "/api/moderation/reports/%s" % report_id.uri_encode(), payload, _moderator_token)


func _submit_report(entry_id: String, category: String, explanation: String) -> void:
	var details := "Category: %s\n\nPlayer explanation: %s" % [category, explanation.strip_edges()]
	var payload: Dictionary = {"request_id": _new_uuid(), "category": category, "details": details}
	if _is_uuid(entry_id):
		payload["installation_id"] = entry_id
	for entry in _snapshot.get("entries", []):
		if String(entry.get("entry_id", "")) == entry_id and _is_uuid(String(entry.get("run_id", ""))):
			payload["run_id"] = String(entry["run_id"])
			break
	_send("report", HTTPClient.METHOD_POST, "/api/reports", payload)


func _request_replay(entry_id: String) -> void:
	var run_id := ""
	for entry in _snapshot.get("entries", []):
		if String(entry.get("entry_id", "")) == entry_id:
			run_id = String(entry.get("run_id", ""))
			break
	if _is_uuid(run_id):
		replay_open_requested.emit(run_id, entry_id)


func _on_http_completed(operation: String, result: Dictionary, status: int) -> void:
	_busy_operation = ""
	var success := status >= 200 and status < 300 and not result.has("network_error")
	if not success:
		if operation.begins_with("moderator"):
			_moderator_token = ""
		_update_snapshot("error" if status > 0 else "offline", String(result.get("error", "Request failed (%d)." % status)))
		if operation == "register" or operation.begins_with("score:") or operation.begins_with("replay:"):
			if status == 0 or status == 429 or status >= 500:
				_retry_timer.start()
			return
		if operation == "rename" and (status == 0 or status == 429 or status >= 500):
			_retry_timer.start()
		return
	if operation == "register":
		var installation_id := String(result.get("installation_id", ""))
		var installation_secret := String(result.get("installation_secret", ""))
		if not _is_uuid(installation_id) or installation_secret.length() < 32:
			_update_snapshot("error", "The service returned invalid identity credentials; pending runs remain queued.")
			return
		if not state.set_identity(installation_id, installation_secret, String(result.get("nickname", state.nickname))):
			_update_snapshot("error", "Identity was registered but credentials could not be saved locally.")
			return
		_retry_pending_uploads()
	elif operation == "rename":
		state.nickname = String(result.get("nickname", state.pending_nickname))
		state.pending_nickname = ""
		state.save_state()
		_retry_pending_uploads()
	elif operation.begins_with("score:"):
		var run_id := operation.trim_prefix("score:")
		state.mark_score_submitted(run_id)
		_update_snapshot("online", "Score accepted. Uploading the recorded replay…")
		_retry_pending_uploads()
	elif operation.begins_with("replay:"):
		state.mark_replay_uploaded(operation.trim_prefix("replay:"))
		_update_snapshot("online", "Score and replay upload complete.")
		_retry_pending_uploads()
	elif operation == "leaderboard":
		var scores: Array = result.get("scores", [])
		_entry_runs.clear()
		for score in scores:
			var run_id := String(score.get("run_id", ""))
			var entry_id := String(score.get("entry_id", ""))
			_entry_runs[entry_id] = run_id
		_update_entries(scores)
		if not state.installation_id.is_empty():
			_send("own_rank", HTTPClient.METHOD_GET, "/api/players/%s/rank" % state.installation_id.uri_encode())
		else:
			_retry_pending_uploads()
	elif operation == "own_rank":
		_snapshot["own_rank"] = result.get("rank", null)
		_update_snapshot("online", "Leaderboard updated.")
		_retry_pending_uploads()
	elif operation == "report":
		_update_snapshot("online", "Report received by the service.")
	elif operation == "moderator_reports":
		_snapshot["moderator_authorized"] = true
		var reports: Array = result.get("reports", [])
		var actions: Array = []
		for report in reports:
			var row: Dictionary = report.duplicate(true)
			row["target_entry_id"] = String(row.get("entry_id", ""))
			row["entry_id"] = String(row.get("report_id", ""))
			row["score_hidden"] = bool(row.get("score_hidden", false))
			row["name_hidden"] = bool(row.get("name_hidden", false))
			row["summary"] = "%s · %s" % [String(row.get("category", "report")), String(row.get("status", "open"))]
			actions.append(row)
		_snapshot["moderator_actions"] = actions
		_update_snapshot("online", "Moderator access verified by the service.")
	elif operation == "moderation_action":
		_request_moderator_access(_moderator_token)
	else:
		_update_snapshot("online", "Request completed.")
	_retry_pending_uploads()


func _on_http_download_completed(operation: String, body: PackedByteArray, status: int, result: int) -> void:
	if not operation.begins_with("download_replay:"):
		return
	_busy_operation = ""
	var run_id := operation.trim_prefix("download_replay:")
	if result != HTTPRequest.RESULT_SUCCESS or status != 200:
		var error_message := "Replay download failed (%d)." % status
		_update_snapshot("error" if status > 0 else "offline", error_message)
		replay_download_failed.emit(run_id, error_message)
		return
	if body.is_empty() or body.size() > 5 * 1024 * 1024:
		var size_message := "Replay is empty or exceeds the 5 MiB limit."
		_update_snapshot("error", size_message)
		replay_download_failed.emit(run_id, size_message)
		return
	_update_snapshot("online", "Replay downloaded. Checking it before playback.")
	replay_downloaded.emit(run_id, body)


func _update_entries(scores: Array) -> void:
	var entries: Array = []
	for score in scores:
		var replay_status := String(score.get("replay_status", "none"))
		entries.append({"entry_id": String(score.get("entry_id", "")), "rank": int(score.get("rank", 0)), "nickname": String(score.get("nickname", "Player")), "score": int(score.get("wave", 0)), "wave": int(score.get("wave", 0)), "run_id": String(score.get("run_id", "")), "replay_available": replay_status in ["ready", "previous"]})
	_snapshot["entries"] = entries
	_update_snapshot("online", "Leaderboard updated.")


func _update_snapshot(backend_status: String, message: String) -> void:
	_snapshot["backend_status"] = backend_status
	_snapshot["status_message"] = message
	_snapshot["nickname"] = String(state.nickname) if state != null else ""
	_snapshot["nickname_prompt_pending"] = state == null or String(state.nickname).is_empty()
	_snapshot["dev_mode"] = dev_mode_active
	_snapshot["moderator_authorized"] = not _moderator_token.is_empty() and bool(_snapshot.get("moderator_authorized", false))
	_snapshot["pending_replay"] = state.pending.size() if state != null else 0
	_snapshot["upload_status"] = "%d run(s) queued" % int(_snapshot["pending_replay"]) if int(_snapshot["pending_replay"]) > 0 else "No score upload pending"
	if panel != null:
		panel.set_snapshot(_snapshot)
	status_changed.emit(_snapshot.duplicate(true))


func _build_snapshot() -> Dictionary:
	return _snapshot.duplicate(true)


func _url_encode(value: String) -> String:
	return value.uri_encode()


func _is_uuid(value: String) -> bool:
	var regex := RegEx.new()
	if regex.compile(UUID_PATTERN) != OK:
		return false
	return regex.search(value) != null


func _new_uuid() -> String:
	var hex := Crypto.new().generate_random_bytes(16).hex_encode()
	hex = hex.substr(0, 12) + "4" + hex.substr(13)
	hex = hex.substr(0, 16) + "8" + hex.substr(17)
	return "%s-%s-%s-%s-%s" % [hex.substr(0, 8), hex.substr(8, 4), hex.substr(12, 4), hex.substr(16, 4), hex.substr(20, 12)]
