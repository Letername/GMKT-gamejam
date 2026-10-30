extends RefCounted

var path := "user://leaderboard_state.cfg"
var installation_id := ""
var installation_secret := ""
var nickname := ""
var pending_nickname := ""
var pending: Array = []

func set_identity(player_id: String, secret: String, name: String) -> bool:
	installation_id = player_id
	installation_secret = secret
	nickname = name
	return save_state()

func queue_run(run_id: String, wave: int, replay_path: String, used_dev: bool) -> bool:
	if used_dev or run_id.is_empty() or wave < 1 or replay_path.is_empty():
		return false
	for run in pending:
		if run.get("run_id", "") == run_id:
			return false
	pending.append({"run_id": run_id, "wave": wave, "replay_path": replay_path, "score_submitted": false})
	if not save_state():
		pending.pop_back()
		return false
	return true

func mark_score_submitted(run_id: String) -> bool:
	for run in pending:
		if run.get("run_id", "") == run_id:
			run["score_submitted"] = true
			return save_state()
	return false

func mark_replay_uploaded(run_id: String) -> bool:
	for index in range(pending.size()):
		if pending[index].get("run_id", "") == run_id:
			pending.remove_at(index)
			return save_state()
	return false

func load_state() -> bool:
	var config := ConfigFile.new()
	var load_error := config.load(path)
	var loaded: Variant = config.get_value("uploads", "pending", []) if load_error == OK else null
	var primary_valid := load_error == OK and config.has_section_key("uploads", "pending") and config.has_section_key("identity", "id") and loaded is Array
	if not primary_valid:
		config = ConfigFile.new()
		if config.load(path + ".bak") != OK:
			return false
		loaded = config.get_value("uploads", "pending", [])
		if not config.has_section_key("uploads", "pending") or not config.has_section_key("identity", "id") or not loaded is Array:
			return false
	installation_id = String(config.get_value("identity", "id", ""))
	installation_secret = String(config.get_value("identity", "secret", ""))
	nickname = String(config.get_value("identity", "nickname", ""))
	pending_nickname = String(config.get_value("identity", "pending_nickname", ""))
	pending = loaded
	return true

func save_state() -> bool:
	var config := ConfigFile.new()
	config.set_value("identity", "id", installation_id)
	config.set_value("identity", "secret", installation_secret)
	config.set_value("identity", "nickname", nickname)
	config.set_value("identity", "pending_nickname", pending_nickname)
	config.set_value("uploads", "pending", pending)
	var temp_path := path + ".tmp"
	if config.save(temp_path) != OK:
		return false
	var final_absolute := ProjectSettings.globalize_path(path)
	var temp_absolute := ProjectSettings.globalize_path(temp_path)
	var backup_absolute := final_absolute + ".bak"
	var had_previous := FileAccess.file_exists(final_absolute)
	if FileAccess.file_exists(backup_absolute):
		DirAccess.remove_absolute(backup_absolute)
	if had_previous and DirAccess.rename_absolute(final_absolute, backup_absolute) != OK:
		return false
	if DirAccess.rename_absolute(temp_absolute, final_absolute) != OK:
		if had_previous:
			DirAccess.rename_absolute(backup_absolute, final_absolute)
		return false
	if had_previous:
		DirAccess.remove_absolute(backup_absolute)
	return true
