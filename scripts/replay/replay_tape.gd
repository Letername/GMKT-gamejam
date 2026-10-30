extends RefCounted
class_name ReplayTape

# A replay tape captures the exact held-action set at each fixed simulation tick.
# Runtime code must feed these actions instead of querying live Input during playback.
const FORMAT_VERSION := 1
const MAX_BYTES := 5 * 1024 * 1024
const MAX_UNCOMPRESSED_BYTES := 32 * 1024 * 1024
const MAX_FRAMES := 180_000
const MAX_ACTIONS_PER_FRAME := 128

var data: Dictionary = {}
var playback_index := 0
var playback_held: Dictionary = {}
var previous_playback_held: Dictionary = {}
var last_decode_error := ""

func begin(game_version: String, initial_seed: int, fixed_hz: int = 60, metadata: Dictionary = {}) -> bool:
	if game_version.is_empty() or initial_seed < 0 or initial_seed > 9007199254740991 or fixed_hz < 15 or fixed_hz > 240:
		data = {}
		return false
	if not _is_json_value(metadata, 0):
		data = {}
		return false
	data = {
		"format": FORMAT_VERSION,
		"game_version": game_version,
		"seed": initial_seed,
		"fixed_hz": fixed_hz,
		"metadata": metadata.duplicate(true),
		"frames": [],
		"markers": []
	}
	playback_index = 0
	playback_held.clear()
	previous_playback_held.clear()
	return true

func record_frame(tick: int, held_actions: Array, checkpoint: Dictionary = {}, action_strengths: Dictionary = {}, step_delta: float = 1.0 / 60.0, input_events: Array = []) -> bool:
	if data.is_empty() or tick < 0:
		return false
	if not is_finite(step_delta) or step_delta <= 0.0 or step_delta > 10.0:
		return false
	var frames: Array = data["frames"]
	if frames.size() >= MAX_FRAMES or tick != frames.size():
		return false
	if held_actions.size() > MAX_ACTIONS_PER_FRAME:
		return false
	var held: Array[String] = []
	var seen := {}
	for value in held_actions:
		if not value is String or String(value).is_empty() or seen.has(value):
			return false
		seen[value] = true
		held.append(value)
	held.sort()
	if not _is_json_value(checkpoint, 0) or not _is_json_value(action_strengths, 0):
		return false
	if not _is_json_value(input_events, 0):
		return false
	for action in action_strengths:
		if not action is String or String(action).is_empty() or not action_strengths[action] is int and not action_strengths[action] is float:
			return false
		var strength := float(action_strengths[action])
		if not is_finite(strength) or strength < 0.0 or strength > 1.0:
			return false
	frames.append({"tick": tick, "delta": step_delta, "held": held, "strengths": action_strengths.duplicate(true), "events": input_events.duplicate(true), "checkpoint": checkpoint.duplicate(true)})
	return true

func record_marker(tick: int, kind: String, detail: Dictionary = {}) -> bool:
	if data.is_empty() or tick < 0 or kind.is_empty() or not _is_json_value(detail, 0):
		return false
	var markers: Array = data["markers"]
	if not markers.is_empty() and tick < int(markers.back()["tick"]):
		return false
	markers.append({"tick": tick, "kind": kind, "detail": detail.duplicate(true)})
	return true

func marker_tick(kind: String, occurrence: int = 0) -> int:
	if data.is_empty() or occurrence < 0:
		return -1
	var found := 0
	for marker in data.get("markers", []):
		if String(marker.get("kind", "")) != kind:
			continue
		if found == occurrence:
			return int(marker.get("tick", -1))
		found += 1
	return -1

func encode() -> PackedByteArray:
	if not _validate_recording(data):
		return PackedByteArray()
	var payload := _canonical_json(data)
	var digest := _sha256(payload.to_utf8_buffer())
	var envelope := JSON.stringify({"payload": payload, "sha256": digest}).to_utf8_buffer()
	if envelope.size() > MAX_UNCOMPRESSED_BYTES:
		return PackedByteArray()
	var compressed := envelope.compress(FileAccess.COMPRESSION_GZIP)
	return compressed if compressed.size() <= MAX_BYTES else PackedByteArray()

func decode(bytes: PackedByteArray) -> Dictionary:
	last_decode_error = ""
	if bytes.is_empty() or bytes.size() > MAX_BYTES:
		last_decode_error = "empty or oversized"
		return {}
	var parser := JSON.new()
	var uncompressed := bytes.decompress(MAX_UNCOMPRESSED_BYTES, FileAccess.COMPRESSION_GZIP)
	if uncompressed.is_empty() or parser.parse(uncompressed.get_string_from_utf8()) != OK or not parser.data is Dictionary:
		last_decode_error = "invalid JSON envelope"
		return {}
	var envelope: Dictionary = parser.data
	if not envelope.get("payload") is String or not envelope.get("sha256") is String:
		last_decode_error = "missing envelope fields"
		return {}
	var payload_text: String = envelope["payload"]
	if not _constant_time_equal(String(envelope["sha256"]), _sha256(payload_text.to_utf8_buffer())):
		last_decode_error = "digest mismatch"
		return {}
	var payload_parser := JSON.new()
	if payload_parser.parse(payload_text) != OK or not payload_parser.data is Dictionary:
		last_decode_error = "invalid payload JSON"
		return {}
	var payload: Dictionary = payload_parser.data
	if not _validate_recording(payload):
		last_decode_error = "payload validation failed"
		return {}
	return payload.duplicate(true)

func load_playback(recording: Dictionary) -> bool:
	if not _validate_recording(recording):
		return false
	data = recording.duplicate(true)
	playback_index = 0
	playback_held.clear()
	previous_playback_held.clear()
	return true

func next_frame() -> Dictionary:
	if data.is_empty():
		return {}
	var frames: Array = data["frames"]
	if playback_index >= frames.size():
		return {}
	var frame: Dictionary = frames[playback_index]
	playback_index += 1
	previous_playback_held = playback_held.duplicate()
	playback_held.clear()
	for action in frame["held"]:
		playback_held[action] = true
	return frame.duplicate(true)

func peek_frame() -> Dictionary:
	if data.is_empty():
		return {}
	var frames: Array = data["frames"]
	if playback_index >= frames.size():
		return {}
	return (frames[playback_index] as Dictionary).duplicate(true)

func seek(tick: int) -> bool:
	if data.is_empty() or tick < 0 or tick > (data["frames"] as Array).size():
		return false
	playback_index = tick
	playback_held.clear()
	previous_playback_held.clear()
	var frames: Array = data["frames"]
	if tick > 0:
		for action in frames[tick - 1]["held"]:
			playback_held[action] = true
	return true

func has_next_frame() -> bool:
	return not data.is_empty() and playback_index < (data["frames"] as Array).size()

func is_action_pressed(action: String) -> bool:
	return playback_held.has(action)

func is_action_just_pressed(action: String) -> bool:
	return playback_held.has(action) and not previous_playback_held.has(action)

func get_action_strength(action: String) -> float:
	if not playback_held.has(action):
		return 0.0
	var frames: Array = data.get("frames", [])
	var current_tick := playback_index - 1
	if current_tick < 0 or current_tick >= frames.size():
		return 0.0
	var strengths: Dictionary = frames[current_tick].get("strengths", {})
	return clampf(float(strengths.get(action, 1.0)), 0.0, 1.0)

func _validate_recording(recording: Dictionary) -> bool:
	if int(recording.get("format", -1)) != FORMAT_VERSION:
		return false
	if not recording.get("game_version") is String or String(recording["game_version"]).is_empty():
		return false
	if not _is_integer_in_range(recording.get("seed"), 0, 9007199254740991):
		return false
	if not _is_integer_in_range(recording.get("fixed_hz"), 15, 240):
		return false
	if not recording.get("metadata") is Dictionary or not _is_json_value(recording["metadata"], 0):
		return false
	if not recording.get("markers") is Array or not _is_json_value(recording["markers"], 0):
		return false
	if not recording.get("frames") is Array or recording["frames"].size() > MAX_FRAMES:
		return false
	var expected_tick := 0
	for frame_value in recording["frames"]:
		if not frame_value is Dictionary:
			return false
		var frame: Dictionary = frame_value
		if not _is_integer_in_range(frame.get("tick"), expected_tick, expected_tick):
			return false
		var step_delta: Variant = frame.get("delta")
		if not (step_delta is int or step_delta is float) or not is_finite(float(step_delta)) or float(step_delta) <= 0.0 or float(step_delta) > 10.0:
			return false
		if not frame.get("held") is Array or frame["held"].size() > MAX_ACTIONS_PER_FRAME:
			return false
		if not frame.get("strengths") is Dictionary or not _is_json_value(frame["strengths"], 0):
			return false
		if not frame.get("events") is Array or not _is_json_value(frame["events"], 0):
			return false
		for action in frame["strengths"]:
			var strength_value: Variant = frame["strengths"][action]
			if not action is String or String(action).is_empty() or not (strength_value is int or strength_value is float):
				return false
			if not is_finite(float(strength_value)) or float(strength_value) < 0.0 or float(strength_value) > 1.0:
				return false
		if not frame.get("checkpoint") is Dictionary or not _is_json_value(frame["checkpoint"], 0):
			return false
		var previous := ""
		for action in frame["held"]:
			if not action is String or String(action).is_empty() or String(action) <= previous:
				return false
			previous = String(action)
		expected_tick += 1
	var last_marker_tick := -1
	for marker_value in recording["markers"]:
		if not marker_value is Dictionary:
			return false
		var marker: Dictionary = marker_value
		if not _is_integer_in_range(marker.get("tick"), 0, MAX_FRAMES) or int(marker["tick"]) < last_marker_tick:
			return false
		if not marker.get("kind") is String or String(marker["kind"]).is_empty():
			return false
		if not marker.get("detail") is Dictionary or not _is_json_value(marker["detail"], 0):
			return false
		last_marker_tick = int(marker["tick"])
	return true

func _is_json_value(value: Variant, depth: int) -> bool:
	if depth > 32:
		return false
	if value == null or value is bool or value is String or value is int:
		return true
	if value is float:
		return is_finite(value)
	if value is Array:
		for item in value:
			if not _is_json_value(item, depth + 1):
				return false
		return true
	if value is Dictionary:
		for key in value:
			if not key is String or not _is_json_value(value[key], depth + 1):
				return false
		return true
	return false

func _is_integer_in_range(value: Variant, minimum: int, maximum: int) -> bool:
	if not (value is int or value is float):
		return false
	var number := float(value)
	return is_finite(number) and number >= minimum and number <= maximum and floor(number) == number

func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	context.update(bytes)
	return context.finish().hex_encode()

func _canonical_json(value: Variant) -> String:
	return JSON.stringify(_canonicalize(value))

func _canonicalize(value: Variant) -> Variant:
	if value is Dictionary:
		var keys: Array = value.keys()
		keys.sort()
		var ordered := {}
		for key in keys:
			ordered[key] = _canonicalize(value[key])
		return ordered
	if value is Array:
		var ordered_array: Array = []
		for item in value:
			ordered_array.append(_canonicalize(item))
		return ordered_array
	if value is float and is_finite(value) and floor(value) == value and abs(value) <= 9007199254740991.0:
		return int(value)
	return value

func _constant_time_equal(left: String, right: String) -> bool:
	if left.length() != right.length():
		return false
	var difference := 0
	for index in left.length():
		difference |= left.unicode_at(index) ^ right.unicode_at(index)
	return difference == 0
