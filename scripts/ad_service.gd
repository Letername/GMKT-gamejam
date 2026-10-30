extends Node

## Mock rewarded-ad boundary for the Windows build.
##
## Gameplay only talks to this service. Replacing the mock with a portal or
## mobile SDK later should therefore stay confined to this file.

signal started(creative: String)
signal rewarded(creative: String)
signal declined(reason: String)
signal failed(message: String)

const AD_PLAYER_SCENE := preload("res://scenes/ads/spare_ad.tscn")
const AD_AUDIO_BUS_NAME := "AdAudio"

var available_creatives := PackedStringArray(["evil"])
var active_player: CanvasLayer
var previous_tree_paused := false
var created_audio_bus := false
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	_ensure_audio_bus()


func request_rewarded_ad(creative: String = "", dev_skip_allowed: bool = false) -> bool:
	if active_player != null and is_instance_valid(active_player):
		failed.emit("A rewarded ad is already active.")
		return false
	var selected_creative := creative if creative != "" else _pick_creative()
	if not selected_creative in available_creatives:
		failed.emit("Creative '%s' is not available." % selected_creative)
		return false
	_ensure_audio_bus()
	active_player = AD_PLAYER_SCENE.instantiate() as CanvasLayer
	if active_player == null:
		failed.emit("The mock ad player could not be created.")
		return false
	active_player.process_mode = Node.PROCESS_MODE_ALWAYS
	active_player.completed.connect(_on_player_completed.bind(selected_creative), CONNECT_ONE_SHOT)
	active_player.declined.connect(_on_player_declined, CONNECT_ONE_SHOT)
	active_player.failed.connect(_on_player_failed, CONNECT_ONE_SHOT)
	get_tree().root.add_child(active_player)
	previous_tree_paused = get_tree().paused
	get_tree().paused = true
	started.emit(selected_creative)
	active_player.call("play_ad", selected_creative, dev_skip_allowed)
	return true


func set_volume_percent(percent: float) -> void:
	_ensure_audio_bus()
	var bus_index := AudioServer.get_bus_index(AD_AUDIO_BUS_NAME)
	if bus_index < 0:
		return
	var clamped_percent := clampf(percent, 0.0, 100.0)
	AudioServer.set_bus_volume_db(bus_index, -80.0 if clamped_percent <= 0.0 else linear_to_db(clamped_percent / 100.0))


func _pick_creative() -> String:
	if available_creatives.is_empty():
		return ""
	return available_creatives[rng.randi_range(0, available_creatives.size() - 1)]


func _ensure_audio_bus() -> void:
	if AudioServer.get_bus_index(AD_AUDIO_BUS_NAME) != -1:
		return
	AudioServer.add_bus(AudioServer.get_bus_count())
	var bus_index := AudioServer.get_bus_count() - 1
	AudioServer.set_bus_name(bus_index, AD_AUDIO_BUS_NAME)
	created_audio_bus = true


func _on_player_completed(creative: String) -> void:
	_finish_player()
	rewarded.emit(creative)


func _on_player_declined(reason: String) -> void:
	_finish_player()
	declined.emit(reason)


func _on_player_failed(message: String) -> void:
	_finish_player()
	failed.emit(message)


func _finish_player() -> void:
	get_tree().paused = previous_tree_paused
	if active_player != null and is_instance_valid(active_player):
		active_player.queue_free()
	active_player = null


func _exit_tree() -> void:
	if active_player != null and is_instance_valid(active_player):
		active_player.queue_free()
	active_player = null
	if created_audio_bus:
		var bus_index := AudioServer.get_bus_index(AD_AUDIO_BUS_NAME)
		if bus_index > 0:
			AudioServer.remove_bus(bus_index)

