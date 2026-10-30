extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	var miner = {"position": Vector2(300, 300), "size": Vector2(32, 32), "speed": 80.0, "hp": 4, "max_hp": 4}
	game.cave_enemies.clear()
	game.cave_enemies.append(miner)
	game.cave_boss_rock_markers.clear()
	game.cave_boss_rock_markers.append({"position": Vector2(316, 316), "impact_radius": 40.0})
	if not game.has_method("_cave_miner_steering"):
		printerr("FAIL: miner hazard-aware steering is missing")
		quit(1)
		return
	var escape: Vector2 = game._cave_miner_steering(miner, Vector2(500, 316))
	if escape.x >= 0.0:
		printerr("FAIL: miner should move away from a marked falling rock")
		quit(1)
		return
	game.cave_boss_rock_markers.clear()
	game.cave_enemies.append({"position": Vector2(300, 305), "size": Vector2(32, 32)})
	var spread: Vector2 = game._cave_miner_steering(miner, Vector2(500, 316))
	if spread.y >= 0.0:
		printerr("FAIL: nearby miners should spread apart")
		quit(1)
		return
	print("CAVE_MINER_AI_PASS")
	game.queue_free()
	quit(0)

