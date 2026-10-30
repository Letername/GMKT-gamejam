extends RefCounted

## Keyed, pooled Sprite2D manager.
##
## Replaces immediate-mode `draw_texture_rect` calls with real Sprite2D nodes
## without making every caller hand-roll create/reuse/cull bookkeeping. A caller
## does this once per frame:
##
##     pool.begin()
##     pool.put("tree:3:7", tree_texture, tree_rect)
##     pool.end()
##
## Sprites keyed the same way across frames are reused in place, so node count
## stays proportional to what is on screen rather than growing every frame.
## Anything not touched between `begin()` and `end()` is hidden, and hidden
## sprites are recycled for new keys before any new node is allocated.

var _container: Node2D
var _sprites := {}
var _touched := {}
var _free_sprites: Array[Sprite2D] = []


func _init(container: Node2D) -> void:
	_container = container


## Marks the start of a frame. Every key must be re-`put` after this to survive.
func begin() -> void:
	_touched.clear()


## Places `texture` so it exactly fills `rect`, matching the geometry that
## `CanvasItem.draw_texture_rect` would have produced for the same rect.
func put(key: String, texture: Texture2D, rect: Rect2, z_index: int = 0, modulate: Color = Color.WHITE) -> Sprite2D:
	if texture == null:
		return null
	var sprite := _acquire(key)
	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		sprite.visible = false
		return sprite
	sprite.texture = texture
	sprite.region_enabled = false
	sprite.centered = false
	sprite.flip_h = false
	sprite.rotation = 0.0
	sprite.offset = Vector2.ZERO
	sprite.position = rect.position
	sprite.scale = rect.size / texture_size
	sprite.z_index = z_index
	sprite.modulate = modulate
	sprite.visible = true
	return sprite


## Same as `put`, but crops `texture` to `region` first — the node equivalent of
## `draw_texture_rect_region`.
func put_region(key: String, texture: Texture2D, region: Rect2, rect: Rect2, z_index: int = 0, modulate: Color = Color.WHITE) -> Sprite2D:
	if texture == null or region.size.x <= 0.0 or region.size.y <= 0.0:
		return null
	var sprite := _acquire(key)
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = region
	sprite.centered = false
	sprite.flip_h = false
	sprite.rotation = 0.0
	sprite.offset = Vector2.ZERO
	sprite.position = rect.position
	sprite.scale = rect.size / region.size
	sprite.z_index = z_index
	sprite.modulate = modulate
	sprite.visible = true
	return sprite


## Places `texture` centred on `rect`, then rotates and scales about that centre.
## This is the node equivalent of the `draw_set_transform` + `draw_texture_rect`
## pairs used for swaying and flipping art.
func put_transformed(key: String, texture: Texture2D, rect: Rect2, rotation: float = 0.0, extra_scale: Vector2 = Vector2.ONE, flip_h: bool = false, z_index: int = 0, modulate: Color = Color.WHITE) -> Sprite2D:
	if texture == null:
		return null
	var sprite := _acquire(key)
	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		sprite.visible = false
		return sprite
	sprite.texture = texture
	sprite.region_enabled = false
	sprite.centered = true
	sprite.offset = Vector2.ZERO
	sprite.position = rect.position + rect.size * 0.5
	sprite.rotation = rotation
	sprite.scale = (rect.size / texture_size) * extra_scale
	sprite.flip_h = flip_h
	sprite.z_index = z_index
	sprite.modulate = modulate
	sprite.visible = true
	return sprite


## Hides every sprite that was not touched this frame and returns it to the
## recycle list. Call exactly once per frame, after the last `put`.
func end() -> void:
	var stale_keys: Array = []
	for key in _sprites.keys():
		if _touched.has(key):
			continue
		var sprite: Sprite2D = _sprites[key]
		if is_instance_valid(sprite):
			sprite.visible = false
			_free_sprites.append(sprite)
		stale_keys.append(key)
	for stale_key in stale_keys:
		_sprites.erase(stale_key)


## Number of live sprites this pool is currently showing. Used by tests.
func active_count() -> int:
	return _sprites.size()


## Drops every node this pool owns. Used when a run ends or the pool's world
## goes away entirely.
func clear() -> void:
	for key in _sprites.keys():
		var sprite: Sprite2D = _sprites[key]
		if is_instance_valid(sprite):
			sprite.queue_free()
	for free_sprite in _free_sprites:
		if is_instance_valid(free_sprite):
			free_sprite.queue_free()
	_sprites.clear()
	_free_sprites.clear()
	_touched.clear()


func _acquire(key: String) -> Sprite2D:
	_touched[key] = true
	var existing: Sprite2D = _sprites.get(key)
	if existing != null and is_instance_valid(existing):
		return existing
	var sprite: Sprite2D = null
	while not _free_sprites.is_empty():
		var candidate: Sprite2D = _free_sprites.pop_back()
		if is_instance_valid(candidate):
			sprite = candidate
			break
	if sprite == null:
		sprite = Sprite2D.new()
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		# Absolute z, so callers can order sprites against the container's own
		# drawing without having to account for the container's z_index.
		sprite.z_as_relative = false
		_container.add_child(sprite)
	_sprites[key] = sprite
	return sprite
