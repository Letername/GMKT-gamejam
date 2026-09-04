extends SceneTree

var failed := false


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame
	var previous_count := 0
	var previous_standard_hp := 0
	for tested_round in [1, 2, 3, 4, 5, 8, 10]:
		main_scene.round_number = tested_round
		main_scene._build_spawn_queue()
		var wave_count: int = main_scene.last_wave_enemy_count
		var wave_hp: int = main_scene.last_wave_enemy_hp
		_assert(wave_count >= previous_count, "Enemy count should not fall as rounds advance.")
		if not main_scene._is_swat_round():
			_assert(wave_hp >= previous_standard_hp, "Standard-wave durability should not fall as rounds advance.")
			previous_standard_hp = wave_hp
		previous_count = wave_count
		print("BALANCE round=%d enemies=%d hp=%d speed=%.1f" % [tested_round, wave_count, wave_hp, main_scene.last_wave_enemy_speed])
	_assert(main_scene.EARLY_ROUND_ENEMY_COUNTS[0] <= 3, "Round one should remain welcoming for new players.")
	_assert(main_scene.EARLY_ROUND_ENEMY_COUNTS[2] <= 7, "The guided first three rounds should stay readable.")
	_assert(previous_count >= 25 and main_scene.last_wave_enemy_hp >= 12, "Round ten should still feel like a serious endless-run challenge.")
	main_scene.queue_free()
	main_scene = null
	for _frame in range(8):
		await process_frame
	quit(1 if failed else 0)


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	failed = true
	push_error(message)
