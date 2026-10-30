extends SceneTree

const PANEL_SCRIPT = preload("res://scripts/leaderboard/leaderboard_panel.gd")

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	var panel = PANEL_SCRIPT.new()
	root.add_child(panel)
	await process_frame
	var scores: Array = []
	for i in 125:
		scores.append({"entry_id": "run-%03d" % i, "rank": i + 1, "nickname": "Player %d" % i, "score": 1000 - i, "wave": 4, "replay_available": i == 0})
	panel.set_snapshot({"backend_status": "offline", "entries": scores, "own_rank": null, "upload_status": "pending", "pending_replay": 1, "dev_mode": false})
	await process_frame
	_check(panel.has_signal("score_submit_requested"), "score submission signal exists")
	_check(panel.has_signal("moderation_requested"), "moderation request is separate")
	_check(panel.has_signal("replay_requested"), "replay request signal exists")
	_check(panel._root != null, "panel structure built")
	_check(panel._entries.get_child_count() == 100, "top 100 limit enforced")
	_check(panel._connection.text.begins_with("OFFLINE"), "offline state is explicit")
	_check(panel._upload.text.contains("replay queued"), "pending replay is visible")
	_check(not panel._moderator_section.visible, "moderation hidden outside Dev Mode")
	panel.set_snapshot({"backend_status": "online", "entries": scores, "own_rank": 101, "dev_mode": true, "moderator_actions": [{"entry_id": "run-000", "summary": "Flagged", "score_hidden": false, "name_hidden": false}]})
	await process_frame
	_check(panel._moderator_section.visible, "moderation shown only when host enables Dev Mode")
	_check(panel._rank.text == "Your rank: #101", "own rank displayed")
	panel.set_snapshot({"backend_status": "online", "dev_mode": true, "entries": [{"entry_id": "hidden", "rank": 1, "nickname": "Secret Name", "name_hidden": true, "score": 9999, "score_hidden": true}], "moderator_actions": [{"entry_id": "hidden", "score_hidden": true, "name_hidden": true}]})
	await process_frame
	_check(panel._entries.get_child(0).get_child(0).get_child(0).text.contains("[hidden]"), "hidden score and name are not displayed")
	var restore_names: Array[String] = []
	for child in panel._mod_actions.get_children():
		for button in child.get_child(2).get_children():
			if button is Button:
				restore_names.append(button.text)
	_check(restore_names.has("Restore score") and restore_names.has("Restore name"), "hidden score and name expose restore actions")
	var emitted: Array = []
	panel.score_submit_requested.connect(func(name): emitted.append(["score", name]))
	panel.moderation_requested.connect(func(code): emitted.append(["mod", code]))
	panel.moderation_action_requested.connect(func(action, id): emitted.append(["action", action, id]))
	panel.report_requested.connect(func(id, category, explanation): emitted.append(["report", id, category, explanation]))
	panel.replay_requested.connect(func(id): emitted.append(["replay", id]))
	panel._snapshot["nickname_prompt_pending"] = true
	panel.open_for_game_over(4242, "run-first")
	await process_frame
	await process_frame
	_check(panel.find_child("PublicRecordingNotice", true, false) != null, "first-run notice discloses public recording and upload")
	_check(panel._content_scroll.get_v_scroll_bar().max_value > panel._content_scroll.get_v_scroll_bar().page, "720p layout keeps lower controls reachable by scrolling")
	_check(panel._name_edit.max_length == 24, "nickname field matches backend 24 character maximum")
	panel._name_edit.text = "A"
	panel._submit_score()
	_check(emitted[-1] == ["score", "A"], "one character nickname is accepted")
	_check(not panel._name_edit.editable, "nickname input closes after first submission")
	panel.set_snapshot({"backend_status": "online", "nickname": "Saved Name", "nickname_prompt_pending": false, "entries": scores, "dev_mode": true, "moderator_actions": [{"entry_id": "run-000", "summary": "Flagged", "score_hidden": false, "name_hidden": false}]})
	panel.open_for_game_over(5000, "run-later")
	await process_frame
	_check(emitted[-1] == ["score", "Saved Name"], "later run submits saved nickname automatically")
	var entry_button: Button = panel._entries.get_child(0).get_child(0).get_child(0)
	entry_button.pressed.emit()
	panel._report_reason.select(2)
	panel._report_edit.text = ""
	panel._submit_report()
	_check(emitted[-1] == ["report", "run-000", "broken_replay", ""], "report category works with optional explanation")
	panel._on_moderator_action("hide_score", "run-000")
	_check(emitted[-1] == ["action", "hide_score", "run-000"], "score moderation is reversible hide action")
	var action_names: Array[String] = []
	for child in panel._mod_actions.get_children():
		for button in child.get_child(2).get_children():
			if button is Button:
				action_names.append(button.text)
	_check(action_names.has("Hide score") and action_names.has("Hide name"), "moderation exposes hide controls")
	_check(not action_names.has("Remove score") and not action_names.has("Remove replay"), "moderation has no irreversible removal controls")
	panel._mod_edit.text = "user-entered-code"
	panel._submit_moderator_code()
	_check(emitted[-1] == ["mod", "user-entered-code"], "moderator code is sent only on explicit request")
	_check(panel._mod_edit.text.is_empty(), "moderator code cleared after request")
	panel.queue_free()
	await process_frame
	if failures.is_empty():
		print("LEADERBOARD_PANEL_TEST_PASS")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
