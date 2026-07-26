extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame
	main_scene._start_new_game()
	await process_frame
	await process_frame
	print("phase=", main_scene.phase)
	print("inside_house=", main_scene.inside_house)
	print("inside_cave=", main_scene.inside_cave)
	print("player_position=", main_scene.player_position)
	print("camera_position=", main_scene.camera_position)
	print("near_cave=", main_scene._is_player_near_cave_entrance())
	print("near_house=", main_scene._is_player_near_house_door())
	print("house_texture_active=", main_scene._current_house_texture() != null)
	quit()
