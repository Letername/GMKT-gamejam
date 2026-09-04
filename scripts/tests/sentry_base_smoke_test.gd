extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main_scene)
	await process_frame
	main_scene._start_new_game()
	main_scene.dev_mode_enabled = true

	var checks := [
		{"cell": main_scene.LEFT_BUILD_YARD[0], "weapon": "gun", "aim": Vector2(1, -1).normalized()},
		{"cell": main_scene.LEFT_BUILD_YARD[8], "weapon": "magic", "aim": Vector2(-1, -1).normalized()}
	]
	for check: Dictionary in checks:
		main_scene.selected_cell = Vector2i(check["cell"])
		if not main_scene._try_place_structure(main_scene.StructureType.TURRET, String(check["weapon"])):
			_fail("Could not place %s sentry." % check["weapon"])
			return
		var structure_key: String = main_scene._cell_key(main_scene.selected_cell)
		main_scene.structures[structure_key]["build_time"] = 0.0
		main_scene.structures[structure_key]["aim_direction"] = Vector2(check["aim"])

	main_scene._sync_visual_nodes()
	await process_frame
	for check: Dictionary in checks:
		var structure_key: String = main_scene._cell_key(Vector2i(check["cell"]))
		var turret_visual: Node2D = main_scene.turret_visual_nodes.get(structure_key)
		if turret_visual == null:
			_fail("No visual was created for the %s sentry." % check["weapon"])
			return
		var base_sprite: Sprite2D = turret_visual.get_node("Base")
		var body_sprite: Sprite2D = turret_visual.get_node("Body")
		if not base_sprite.visible or base_sprite.texture == null:
			_fail("The %s sentry has no fixed leg/base sprite." % check["weapon"])
			return
		if not is_zero_approx(base_sprite.rotation):
			_fail("The %s sentry legs rotated with its aim." % check["weapon"])
			return
		if not is_equal_approx(body_sprite.rotation, Vector2(check["aim"]).angle()):
			_fail("The %s sentry head did not rotate independently." % check["weapon"])
			return

	print("SENTRY_BASE_SMOKE_PASS")
	main_scene.queue_free()
	main_scene = null
	for _frame in range(8):
		await process_frame
	quit()


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
