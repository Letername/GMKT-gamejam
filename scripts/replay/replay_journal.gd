extends RefCounted

# This journal is only the recording format. It does not yet reproduce gameplay.
const FORMAT_VERSION := 1
const MAX_BYTES := 32 * 1024 * 1024
var data: Dictionary = {}

func begin(game_version: String, initial_seed: int) -> void:
	data = {"format": FORMAT_VERSION, "game_version": game_version, "seed": initial_seed, "events": [], "waves": []}

func record_input(tick: int, action: String, pressed: bool) -> void:
	if tick < 0 or action.is_empty() or data.is_empty():
		return
	data["events"].append({"tick": tick, "action": action, "pressed": pressed})

func record_wave(wave: int, tick: int) -> void:
	if wave < 1 or tick < 0 or data.is_empty():
		return
	data["waves"].append({"wave": wave, "tick": tick})

func encode() -> PackedByteArray:
	return JSON.stringify(data).to_utf8_buffer()

func decode(bytes: PackedByteArray) -> Dictionary:
	if bytes.is_empty() or bytes.size() > MAX_BYTES:
		return {}
	var parser := JSON.new()
	if parser.parse(bytes.get_string_from_utf8()) != OK:
		return {}
	var parsed: Variant = parser.data
	if not parsed is Dictionary:
		return {}
	if int(parsed.get("format", -1)) != FORMAT_VERSION or not parsed.get("events") is Array or not parsed.get("waves") is Array or not parsed.get("game_version") is String:
		return {}
	if not parsed.has("seed") or not _nonnegative_integer(parsed["seed"]):
		return {}
	var last_tick := -1
	for event in parsed["events"]:
		if not event is Dictionary or not event.has("tick") or not event.has("action") or not event.has("pressed"):
			return {}
		if not _nonnegative_integer(event["tick"]) or not event["action"] is String or String(event["action"]).is_empty() or not event["pressed"] is bool:
			return {}
		if int(event["tick"]) < last_tick:
			return {}
		last_tick = int(event["tick"])
	var last_wave := 0
	var last_wave_tick := -1
	for marker in parsed["waves"]:
		if not marker is Dictionary or not marker.has("wave") or not marker.has("tick"):
			return {}
		if not _nonnegative_integer(marker["wave"]) or not _nonnegative_integer(marker["tick"]):
			return {}
		if int(marker["wave"]) <= last_wave or int(marker["tick"]) < last_wave_tick:
			return {}
		last_wave = int(marker["wave"])
		last_wave_tick = int(marker["tick"])
	return parsed

func wave_tick(recording: Dictionary, wave: int) -> int:
	for marker in recording.get("waves", []):
		if int(marker.get("wave", -1)) == wave:
			return int(marker.get("tick", -1))
	return -1



func _nonnegative_integer(value: Variant) -> bool:
	if not (value is int or value is float):
		return false
	var number: float = float(value)
	return is_finite(number) and number >= 0.0 and number <= 9007199254740991.0 and floor(number) == number
