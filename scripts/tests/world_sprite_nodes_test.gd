extends SceneTree

## Covers the immediate-mode -> Sprite2D conversion in $WorldSpriteLayer.
##
## The three things worth guarding are that world art really is made of nodes,
## that those nodes stay in the z-band beneath the runtime's own drawing (so
## they can never cover the HUD), and that the pool reuses nodes instead of
## growing one per frame.

var failed := false


func _initialize() -> void:
	call_deferred("_run")


func _fail(message: String) -> void:
	failed = true
	push_error(message)


func _run() -> void:
	root.size = Vector2i(1280, 720)
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	if game.team_intro_active:
		game._finish_team_intro()
		await process_frame

	var ground_layer: Node2D = game.get_node_or_null("GroundLayer")
	var sprite_layer: Node2D = game.get_node_or_null("WorldSpriteLayer")
	if ground_layer == null:
		_fail("The world backdrop must live in its own $GroundLayer node.")
	if sprite_layer == null:
		_fail("World sprites must live in their own $WorldSpriteLayer node.")
	if ground_layer == null or sprite_layer == null:
		_finish(game)
		return

	# The backdrop has to sit below the sprite band, which in turn has to sit
	# below the runtime's own canvas item at z 0.
	if ground_layer.z_index >= sprite_layer.z_index:
		_fail("The ground backdrop must render beneath the world sprite layer.")
	if sprite_layer.z_index >= 0:
		_fail("The world sprite layer must render beneath the runtime HUD drawing.")
	if ground_layer.z_as_relative or sprite_layer.z_as_relative:
		_fail("World layers need absolute z so runtime z changes cannot reorder them.")

	game._start_new_game()
	for _warmup_frame in range(4):
		await process_frame

	var sprites: Array[Sprite2D] = _collect_sprites(sprite_layer)
	if sprites.is_empty():
		_fail("Starting a run must produce world sprite nodes; found none.")
	var textured_count := 0
	for sprite in sprites:
		if not sprite.visible:
			continue
		if sprite.texture == null:
			_fail("A visible world sprite has no texture assigned.")
			break
		textured_count += 1
		if sprite.z_as_relative:
			_fail("Pooled sprites must use absolute z so the layer cannot reorder them.")
			break
		if sprite.z_index >= 0:
			_fail("World sprite '%s' at z %d would render over the HUD." % [sprite.name, sprite.z_index])
			break
	if textured_count <= 0:
		_fail("No visible textured world sprites were produced during a run.")

	# Trees and rocks are the bulk of the conversion, so prove the resource
	# nodes specifically became sprites rather than only the cave mouth.
	var resource_count := 0
	for node in game.resource_nodes:
		if int(node.get("remaining", 0)) > 0:
			resource_count += 1
	if resource_count > 0 and textured_count < 2:
		_fail("A run with %d resource nodes produced only %d world sprites." % [resource_count, textured_count])

	# The pool must reuse nodes: holding the world still for several frames may
	# not keep allocating.
	var settled_count: int = _collect_sprites(sprite_layer).size()
	for _steady_frame in range(20):
		await process_frame
	var after_count: int = _collect_sprites(sprite_layer).size()
	if after_count > settled_count:
		_fail("World sprite pool grew from %d to %d nodes while idle." % [settled_count, after_count])

	# Returning to the menu must retire the world sprites, matching the old
	# behaviour where the world simply stopped being drawn.
	game.phase = game.Phase.MENU
	for _menu_frame in range(3):
		await process_frame
	for sprite in _collect_sprites(sprite_layer):
		if sprite.visible:
			_fail("World sprite '%s' stayed visible on the menu." % sprite.name)
			break

	_finish(game)


func _collect_sprites(layer: Node) -> Array[Sprite2D]:
	var found: Array[Sprite2D] = []
	for child in layer.get_children():
		var sprite := child as Sprite2D
		if sprite != null:
			found.append(sprite)
	return found


func _finish(game: Node) -> void:
	game.queue_free()
	for _cleanup_frame in range(10):
		await process_frame
	if failed:
		print("WORLD_SPRITE_NODES_FAIL")
		quit(1)
	else:
		print("WORLD_SPRITE_NODES_PASS")
		quit()
