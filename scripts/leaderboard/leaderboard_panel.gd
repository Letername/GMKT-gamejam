class_name LeaderboardPanel
extends Control
## Presentation-only leaderboard panel. The host owns networking, validation and persistence.

signal close_requested
signal refresh_requested(query: String)
signal score_submit_requested(nickname: String)
signal moderation_requested(code: String)
signal moderation_action_requested(action: String, entry_id: String)
signal report_requested(entry_id: String, category: String, explanation: String)
signal replay_requested(entry_id: String)

const MAX_VISIBLE_ENTRIES := 100
# Tax-form paper look, matching the in-game panels.
const PANEL_BG := Color("f0e3c4")
const PANEL_LINE := Color("5a4a30")
const TEXT_MAIN := Color("2b2418")
const TEXT_SOFT := Color("665741")
const ACCENT := Color("8a5a12")
const GREEN := Color("2f6b3c")
const RED := Color("c73b32")
const BUTTON_TEXT := Color("f5ead2")
const ROW_A := Color("fbf3df")
const ROW_B := Color("efe2c2")

var _snapshot: Dictionary = {}
var _context := "menu"
var _query := ""
var _root: VBoxContainer
var _content_scroll: ScrollContainer
var _title: Label
var _connection: Label
var _rank: Label
var _upload: Label
var _query_edit: LineEdit
var _name_edit: LineEdit
var _mod_edit: LineEdit
var _report_edit: LineEdit
var _report_reason: OptionButton
var _entries: VBoxContainer
var _status: Label
var _mod_actions: VBoxContainer
var _moderator_section: VBoxContainer
var _moderator_access_button: Button
var _moderator_code_row: HBoxContainer
var _selected_entry := ""
var _last_auto_submit_run_id := ""


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	focus_mode = Control.FOCUS_ALL
	_build_ui()
	_apply_snapshot()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_requested.emit()
		get_viewport().set_input_as_handled()


## Opens from either menu or game over. Score and run id are context only; host supplies upload state.
func open_for_menu() -> void:
	_context = "menu"
	show()
	if is_inside_tree():
		_build_ui()
		_apply_snapshot()


func open_for_game_over(score: int, run_id: String) -> void:
	_context = "game_over"
	show()
	_snapshot["last_score"] = maxi(0, score)
	_snapshot["run_id"] = run_id
	if is_inside_tree():
		_build_ui()
		_apply_snapshot()
		_auto_submit_saved_nickname(run_id)


## Expected keys: backend_status, entries[{entry_id, rank, nickname, score, wave, replay_available}],
## own_rank, upload_status, pending_replay, reports, status_message, moderator_actions,
## nickname, nickname_prompt_pending, dev_mode. Moderator actions only render in Dev Mode.
func set_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot.duplicate(true)
	if is_inside_tree():
		_apply_snapshot()
		if _context == "game_over":
			_auto_submit_saved_nickname(String(_snapshot.get("run_id", "")))


func _build_ui() -> void:
	for child in get_children():
		child.queue_free()
	var shade := ColorRect.new()
	shade.name = "Shade"
	shade.color = Color(0.025, 0.035, 0.05, 0.82)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)
	var center := CenterContainer.new()
	center.name = "Center"
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.offset_left = 30
	center.offset_right = -30
	center.offset_top = 20
	center.offset_bottom = -20
	add_child(center)
	var panel := PanelContainer.new()
	panel.name = "Panel"
	panel.custom_minimum_size = Vector2(760, 610)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL_BG
	style.border_color = PANEL_LINE
	style.set_border_width_all(2)
	style.set_corner_radius_all(3)
	style.shadow_color = Color(0, 0, 0, 0.45)
	style.shadow_offset = Vector2(0, 8)
	style.shadow_size = 1
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 18
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	_pop_in(panel)
	_content_scroll = ScrollContainer.new()
	_content_scroll.name = "ContentScroll"
	_content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(_content_scroll)
	_root = VBoxContainer.new()
	_root.add_theme_constant_override("separation", 10)
	_root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_scroll.add_child(_root)

	var heading := HBoxContainer.new()
	_root.add_child(heading)
	_title = _label("WORLDWIDE SCOREBOARD", 24, ACCENT)
	_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.add_child(_title)
	var close := _button("Close  [Esc]")
	close.pressed.connect(func(): close_requested.emit())
	heading.add_child(close)
	_connection = _label("", 14, TEXT_SOFT)
	_root.add_child(_connection)
	if _context == "game_over":
		_add_submission_section()

	var controls := HBoxContainer.new()
	_root.add_child(controls)
	_query_edit = LineEdit.new()
	_query_edit.name = "Search"
	_query_edit.placeholder_text = "Search nickname or rank…"
	_query_edit.text = _query
	_query_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_query_edit.custom_minimum_size.y = 38
	controls.add_child(_query_edit)
	var search := _button("Search")
	search.pressed.connect(_on_search)
	controls.add_child(search)
	var refresh := _button("Refresh")
	refresh.pressed.connect(_on_search)
	controls.add_child(refresh)
	_rank = _label("Your rank: not available", 16, ACCENT)
	_root.add_child(_rank)
	_upload = _label("", 14, TEXT_SOFT)
	_root.add_child(_upload)
	var list_header := _label("TOP 100  ·  RANK      PLAYER                         SCORE          WAVE", 13, TEXT_SOFT)
	_root.add_child(list_header)
	var list_panel := PanelContainer.new()
	list_panel.custom_minimum_size.y = 210
	list_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var list_style := StyleBoxFlat.new()
	list_style.bg_color = Color("e6d6b0")
	list_style.set_corner_radius_all(8)
	list_style.content_margin_left = 8
	list_style.content_margin_right = 8
	list_style.content_margin_top = 6
	list_style.content_margin_bottom = 6
	list_panel.add_theme_stylebox_override("panel", list_style)
	_root.add_child(list_panel)
	var list_scroll := ScrollContainer.new()
	list_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list_panel.add_child(list_scroll)
	_entries = VBoxContainer.new()
	_entries.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_entries.add_theme_constant_override("separation", 3)
	list_scroll.add_child(_entries)

	_add_reports_section()
	_moderator_section = _add_moderator_section()
	_status = _label("", 14, TEXT_SOFT)
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_root.add_child(_status)
	_query_edit.text_submitted.connect(func(_text): _on_search())
	_mod_edit.text_submitted.connect(func(_text): _submit_moderator_code())
	close.focus_neighbor_bottom = _query_edit.get_path()
	close.grab_focus()


func _add_submission_section() -> void:
	var box := _section("THIS RUN")
	_root.add_child(box)
	box.add_child(_label("Run score: %s" % _number(_snapshot.get("last_score", 0)), 17, TEXT_MAIN))
	var saved_nickname := String(_snapshot.get("nickname", "")).strip_edges()
	var prompt_pending := bool(_snapshot.get("nickname_prompt_pending", saved_nickname.is_empty()))
	if not saved_nickname.is_empty() or not prompt_pending:
		box.add_child(_label("Your score is submitted automatically using your saved nickname." if not saved_nickname.is_empty() else "This run was not queued for submission.", 14, TEXT_SOFT))
		return
	box.add_child(_label("First run: choose a leaderboard nickname. Future runs submit automatically.", 14, TEXT_SOFT))
	var disclosure := _label("NOTICE: Gameplay is recorded and uploaded publicly with your nickname and score. Offline uploads may queue until a connection is available.", 14, RED)
	disclosure.name = "PublicRecordingNotice"
	disclosure.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(disclosure)
	var row := HBoxContainer.new()
	box.add_child(row)
	_name_edit = LineEdit.new()
	_name_edit.name = "Nickname"
	_name_edit.placeholder_text = "Nickname (1–24 characters)"
	_name_edit.max_length = 24
	_name_edit.custom_minimum_size.y = 38
	_name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_name_edit)
	var submit := _button("Save nickname & submit")
	submit.pressed.connect(_submit_score)
	row.add_child(submit)
	box.add_child(_label("Submission and replay upload are handled by the game service. Offline runs may remain queued.", 13, TEXT_SOFT))


func _add_reports_section() -> void:
	var box := _section("REPORT A SCORE")
	_root.add_child(box)
	var row := HBoxContainer.new()
	box.add_child(row)
	_report_reason = OptionButton.new()
	_report_reason.name = "ReportReason"
	for category in ["Cheating", "Inappropriate name", "Broken replay", "Other"]:
		_report_reason.add_item(category)
	_report_reason.custom_minimum_size.y = 36
	row.add_child(_report_reason)
	_report_edit = LineEdit.new()
	_report_edit.placeholder_text = "Optional explanation"
	_report_edit.custom_minimum_size.y = 36
	_report_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_report_edit)
	var report := _button("Send report")
	report.pressed.connect(_submit_report)
	row.add_child(report)
	var reports: Array = _snapshot.get("reports", [])
	box.add_child(_label("Your reports: %d" % reports.size(), 13, TEXT_SOFT))


func _add_moderator_section() -> VBoxContainer:
	var box := _section("MODERATOR TOOLS")
	_root.add_child(box)
	box.name = "ModeratorSection"
	box.visible = bool(_snapshot.get("dev_mode", false))
	box.add_child(_label("Moderator access is verified by the server. This code is sent only when you request access.", 13, TEXT_SOFT))
	_moderator_code_row = HBoxContainer.new()
	box.add_child(_moderator_code_row)
	_mod_edit = LineEdit.new()
	_mod_edit.name = "ModeratorCode"
	_mod_edit.placeholder_text = "Moderator code"
	_mod_edit.secret = true
	_mod_edit.custom_minimum_size.y = 36
	_mod_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_moderator_code_row.add_child(_mod_edit)
	_moderator_access_button = _button("Request moderator access")
	_moderator_access_button.pressed.connect(_submit_moderator_code)
	_moderator_code_row.add_child(_moderator_access_button)
	_mod_actions = VBoxContainer.new()
	_mod_actions.add_theme_constant_override("separation", 4)
	box.add_child(_mod_actions)
	return box

func _apply_snapshot() -> void:
	if not is_inside_tree() or _root == null:
		return
	_connection.text = _backend_message(String(_snapshot.get("backend_status", "offline")))
	_connection.add_theme_color_override("font_color", GREEN if String(_snapshot.get("backend_status", "offline")) == "online" else RED)
	var own_rank: Variant = _snapshot.get("own_rank", null)
	_rank.text = "Your rank: #%s" % _number(own_rank) if own_rank != null else "Your rank: not ranked yet"
	var up := String(_snapshot.get("upload_status", "No score upload pending"))
	var pending := int(_snapshot.get("pending_replay", 0))
	_upload.text = "Upload: %s%s" % [up, "  ·  replay queued" if pending > 0 else ""]
	_upload.add_theme_color_override("font_color", ACCENT if pending > 0 or up.to_lower().contains("pending") else TEXT_SOFT)
	_status.text = String(_snapshot.get("status_message", ""))
	if _moderator_section != null:
		_moderator_section.visible = bool(_snapshot.get("dev_mode", false))
		_moderator_code_row.visible = not bool(_snapshot.get("moderator_authorized", false))
	for child in _entries.get_children():
		child.queue_free()
	var source: Array = _snapshot.get("entries", [])
	var shown := mini(source.size(), MAX_VISIBLE_ENTRIES)
	if shown == 0:
		_entries.add_child(_label("No scores loaded. Connect to the leaderboard service and refresh.", 15, TEXT_SOFT))
	for index in shown:
		var entry: Dictionary = source[index]
		_entries.add_child(_entry_row(entry, index))
	for child in _mod_actions.get_children():
		child.queue_free()
	for action_item in _snapshot.get("moderator_actions", []):
		if not action_item is Dictionary:
			continue
		var action: Dictionary = action_item
		var action_row := VBoxContainer.new()
		action_row.add_theme_constant_override("separation", 3)
		_mod_actions.add_child(action_row)
		var target_name := String(action.get("nickname", action.get("player_nickname", "Unknown player")))
		var wave := _number(action.get("score_wave", "—"))
		var details := _clean(action.get("details", ""), 240)
		var report_text := "%s · %s · %s · %s · wave %s · replay %s" % [String(action.get("entry_id", "")), String(action.get("summary", "Review")), target_name, String(action.get("verification_status", "unverified")), wave, String(action.get("reported_replay_status", action.get("replay_status", "unknown")))]
		var report_label := _label(report_text, 13, TEXT_MAIN)
		report_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		action_row.add_child(report_label)
		var details_label := _label("Details: %s" % (details if not details.is_empty() else "No explanation provided"), 12, TEXT_SOFT)
		details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		action_row.add_child(details_label)
		var buttons_row := HBoxContainer.new()
		buttons_row.add_theme_constant_override("separation", 4)
		action_row.add_child(buttons_row)
		var id := String(action.get("entry_id", ""))
		for action_name in ["Dismiss", "Hide score", "Hide name", "Restore score", "Restore name"]:
			var hidden_key: String = action_name.trim_prefix("Hide ").trim_prefix("Restore ").to_lower().replace(" ", "_") + "_hidden"
			if action_name.begins_with("Hide") and bool(action.get(hidden_key, false)):
				continue
			if action_name.begins_with("Restore") and not bool(action.get(hidden_key, false)):
				continue
			var button := _button(action_name)
			button.pressed.connect(_on_moderator_action.bind(action_name.to_lower().replace(" ", "_"), id))
			buttons_row.add_child(button)
	

func _entry_row(entry: Dictionary, index: int) -> Control:
	var row := HBoxContainer.new()
	row.name = "Entry_%s" % String(entry.get("entry_id", index))
	var style := StyleBoxFlat.new()
	style.bg_color = ROW_A if index % 2 == 0 else ROW_B
	style.set_corner_radius_all(5)
	var holder := PanelContainer.new()
	holder.add_theme_stylebox_override("panel", style)
	holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	holder.add_child(row)
	var id := String(entry.get("entry_id", ""))
	var display_name := "[hidden]" if bool(entry.get("name_hidden", false)) else _clean(entry.get("nickname", "Player"), 24)
	var display_score := "[hidden]" if bool(entry.get("score_hidden", false)) else _number(entry.get("score", 0))
	var select := _button("#%s  %s  ·  %s  ·  W%s" % [_number(entry.get("rank", index + 1)), display_name, display_score, _number(entry.get("wave", 0))])
	select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	select.alignment = HORIZONTAL_ALIGNMENT_LEFT
	select.pressed.connect(func(): _selected_entry = id; _report_edit.placeholder_text = "Reporting %s · explain the concern" % id)
	row.add_child(select)
	if bool(entry.get("replay_available", false)):
		var replay := _button("Watch replay")
		replay.pressed.connect(func(): replay_requested.emit(id))
		row.add_child(replay)
	return holder


func _on_search() -> void:
	_query = _query_edit.text.strip_edges()
	refresh_requested.emit(_query)


func _submit_score() -> void:
	var nickname := _name_edit.text.strip_edges()
	if nickname.length() < 1 or nickname.length() > 24:
		_status.text = "Nickname must be 1–24 characters. The service will apply its own checks too."
		return
	score_submit_requested.emit(nickname)
	_name_edit.editable = false
	_status.text = "Nickname received. The game service will submit this run."


func _submit_report() -> void:
	var explanation := _report_edit.text.strip_edges()
	if _selected_entry.is_empty():
		_status.text = "Select a leaderboard row to report."
		return
	var category := _report_reason.get_item_text(_report_reason.selected).to_lower().replace(" ", "_")
	report_requested.emit(_selected_entry, category, explanation.substr(0, 300))


func _auto_submit_saved_nickname(run_id: String) -> void:
	var saved_nickname := String(_snapshot.get("nickname", "")).strip_edges()
	if run_id.is_empty() or saved_nickname.is_empty() or run_id == _last_auto_submit_run_id:
		return
	_last_auto_submit_run_id = run_id
	score_submit_requested.emit(saved_nickname)


func _submit_moderator_code() -> void:
	if _mod_edit.text.strip_edges().is_empty():
		_status.text = "Enter the moderator code to request server verification."
		return
	moderation_requested.emit(_mod_edit.text)
	_mod_edit.clear()
	_moderator_code_row.visible = false
	_status.text = "Access request sent for server verification."


func _on_moderator_action(action: String, entry_id: String) -> void:
	moderation_action_requested.emit(action, entry_id)


func _pop_in(panel: Control) -> void:
	panel.scale = Vector2.ONE * 0.82
	panel.resized.connect(func(): panel.pivot_offset = panel.size * 0.5)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.46)


func _button(caption: String) -> Button:
	var button := Button.new()
	button.text = caption
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size.y = 36
	button.add_theme_color_override("font_color", BUTTON_TEXT)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_focus_color", Color.WHITE)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("334252")
	normal.border_color = Color("607387")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(7)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("43576a")
	hover.border_color = Color("f2c66d")
	var focus := normal.duplicate() as StyleBoxFlat
	focus.border_color = Color("f2c66d")
	focus.set_border_width_all(2)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("focus", focus)
	button.add_theme_stylebox_override("pressed", hover)
	return button


func _label(value: String, size: int = 14, color: Color = TEXT_MAIN) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


func _section(title_text: String) -> VBoxContainer:
	var section := VBoxContainer.new()
	section.add_theme_constant_override("separation", 6)
	var title := _label(title_text, 14, ACCENT)
	section.add_child(title)
	return section


func _backend_message(status: String) -> String:
	match status.to_lower():
		"online": return "SERVICE ONLINE · scores and actions are supplied by the connected backend"
		"loading": return "CONNECTING · waiting for the leaderboard service"
		"error": return "SERVICE ERROR · try again later; queued submissions remain visible"
		_: return "OFFLINE · no leaderboard service response; no scores are being simulated"


func _number(value: Variant) -> String:
	return str(value) if value != null else "—"


func _clean(value: Variant, limit: int) -> String:
	var result := String(value).replace("\n", " ").replace("\r", " ").strip_edges()
	return result.substr(0, limit)
