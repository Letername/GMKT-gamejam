extends Node2D

## Owns the world art that used to be painted by immediate-mode `draw_texture_rect`
## calls inside `main_runtime.gd`, and gives every one of those images its own
## Sprite2D node instead.
##
## Sprites live in the z-index band between `ground_layer.gd` (GROUND_Z) and the
## runtime's own `_draw()` (z 0), so they sit above the ground and below every
## projectile, effect and HUD element the runtime still draws immediately.
##
## Each frame the layer re-derives sprite placement from the same runtime state
## the old draw calls read. `SpritePool` reuses a node whenever the same key
## comes back, so node count tracks what is on screen rather than climbing.

const SpritePool = preload("res://scripts/world/sprite_pool.gd")

## Bob's house sits behind the scenery, matching the old draw order where trees
## and rocks were painted after it.
const HOUSE_Z := -380
## Trees and rocks, offset per grid row so lower rows overlap higher ones.
const RESOURCE_Z_BASE := -360
## The cave mouth sits above the resource band so trees never cover the entrance.
const CAVE_ENTRANCE_Z := -340
## Animals wander in front of the scenery they walk past.
const ANIMAL_Z := -320
## The ground shadow under each animal, drawn by this layer's own `_draw()`.
## The layer sits one step below the animal sprites so a shadow never covers the
## animal casting it.
const ANIMAL_SHADOW_Z := ANIMAL_Z - 1

var runtime: Node2D

var _animal_shadows: Array[Rect2] = []

var _resource_pool: SpritePool
var _prop_pool: SpritePool
var _animal_pool: SpritePool

var _screen_size := Vector2(1280, 720)
var _cell_size := 48.0
var _grid_origin := Vector2(144, 96)
var _forest_tree_draw_size := Vector2(132, 164)
var _rock_big_draw_size := Vector2(28, 28)
var _rock_medium_draw_size := Vector2(24, 18)
var _rock_small_draw_size := Vector2(18, 12)
var _cave_entrance_cell := Vector2i(11, 28)
var _house_cell := Vector2i(11, 4)
var _house_draw_size := Vector2(292, 292)
var _house_draw_offset := Vector2(-52, -192)
var _constants_ready := false


func _ready() -> void:
	z_index = ANIMAL_SHADOW_Z
	z_as_relative = false
	runtime = get_parent() as Node2D
	_resource_pool = SpritePool.new(self)
	_prop_pool = SpritePool.new(self)
	_animal_pool = SpritePool.new(self)
	_cache_constants()


func _cache_constants() -> void:
	if runtime == null:
		return
	var script: Script = runtime.get_script()
	if script == null:
		return
	var constants: Dictionary = script.get_script_constant_map()
	_screen_size = constants.get("SCREEN_SIZE", _screen_size)
	_cell_size = constants.get("CELL_SIZE", _cell_size)
	_grid_origin = constants.get("GRID_ORIGIN", _grid_origin)
	_forest_tree_draw_size = constants.get("FOREST_TREE_DRAW_SIZE", _forest_tree_draw_size)
	_rock_big_draw_size = constants.get("ROCK_BIG_DRAW_SIZE", _rock_big_draw_size)
	_rock_medium_draw_size = constants.get("ROCK_MEDIUM_DRAW_SIZE", _rock_medium_draw_size)
	_rock_small_draw_size = constants.get("ROCK_SMALL_DRAW_SIZE", _rock_small_draw_size)
	_cave_entrance_cell = constants.get("CAVE_ENTRANCE_CELL", _cave_entrance_cell)
	_house_cell = constants.get("HOUSE_CELL", _house_cell)
	_house_draw_size = constants.get("HOUSE_DRAW_SIZE", _house_draw_size)
	_house_draw_offset = constants.get("HOUSE_DRAW_OFFSET", _house_draw_offset)
	_constants_ready = true


func _process(_delta: float) -> void:
	sync()


## Rebuilds every world sprite from runtime state. Split out from `_process` so
## tests can step the layer deterministically without running the scene tree.
func sync() -> void:
	if runtime == null or not _constants_ready:
		return
	_resource_pool.begin()
	_prop_pool.begin()
	_animal_pool.begin()
	_animal_shadows.clear()
	if _world_visible():
		var camera_position: Vector2 = runtime.camera_position
		_sync_house(camera_position)
		_sync_resource_nodes(camera_position)
		_sync_cave_entrance(camera_position)
		_sync_forest_animals(camera_position)
	_resource_pool.end()
	_prop_pool.end()
	_animal_pool.end()
	queue_redraw()


func _draw() -> void:
	for shadow_rect in _animal_shadows:
		draw_rect(shadow_rect, Color(0.02, 0.03, 0.04, 0.18), true)


## Total live world sprites. Used by tests to prove the conversion is running.
func active_sprite_count() -> int:
	return _resource_pool.active_count() + _prop_pool.active_count() + _animal_pool.active_count()


func clear_all() -> void:
	_resource_pool.clear()
	_prop_pool.clear()
	_animal_pool.clear()


func _world_visible() -> bool:
	var phase: int = runtime.phase
	return phase != runtime.Phase.MENU and phase != runtime.Phase.GAME_OVER


func _cell_to_world(cell: Vector2i) -> Vector2:
	return _grid_origin + Vector2(cell.x, cell.y) * _cell_size


## Reproduces the harvest shake the old `_draw_resources` applied to the node
## currently being gathered.
func _harvest_jitter(index: int) -> Vector2:
	if index != int(runtime.harvesting_node_index):
		return Vector2.ZERO
	var world_time: float = runtime.world_time
	var gather_time: float = maxf(0.01, runtime._current_gather_time())
	var harvest_intensity: float = 0.45 + 0.55 * clampf(float(runtime.harvest_timer) / gather_time, 0.0, 1.0)
	return Vector2(sin(world_time * 42.0), cos(world_time * 33.0) * 0.45) * 2.6 * harvest_intensity


func _sync_resource_nodes(camera_position: Vector2) -> void:
	var resource_nodes: Array = runtime.resource_nodes
	var forest_tree_texture: Texture2D = runtime.forest_tree_texture
	var tree_trunk_texture: Texture2D = runtime.tree_trunk_texture
	var rock_big_texture: Texture2D = runtime.rock_big_texture
	var rock_medium_texture: Texture2D = runtime.rock_medium_texture
	var rock_small_texture: Texture2D = runtime.rock_small_texture
	var visible_start_y: int = maxi(0, int(floor(camera_position.y / _cell_size)) - 2)
	var visible_end_y: int = int(ceil((camera_position.y + _screen_size.y) / _cell_size)) + 2
	for index in range(resource_nodes.size()):
		var node: Dictionary = resource_nodes[index]
		var node_cell := Vector2i(node["cell"])
		if node_cell.y < visible_start_y or node_cell.y > visible_end_y:
			continue
		var key := "res:%d" % index
		var cell_world: Vector2 = _cell_to_world(node_cell)
		var jitter: Vector2 = _harvest_jitter(index)
		var z: int = RESOURCE_Z_BASE + node_cell.y
		if String(node["kind"]) == "wood":
			if forest_tree_texture != null and int(node["remaining"]) > 0:
				_resource_pool.put(
					key,
					forest_tree_texture,
					Rect2(cell_world + Vector2(-42, -100) + jitter - camera_position, _forest_tree_draw_size),
					z
				)
			elif tree_trunk_texture != null:
				_resource_pool.put(
					key,
					tree_trunk_texture,
					Rect2(cell_world + Vector2(8, 16) + jitter - camera_position, Vector2(34, 34)),
					z
				)
		else:
			# The rock variant is chosen from the cell so a given node keeps the
			# same silhouette for the whole run.
			var rock_variant: int = (node_cell.x + node_cell.y) % 3
			if rock_variant == 0 and rock_big_texture != null:
				_resource_pool.put(
					key,
					rock_big_texture,
					Rect2(cell_world + Vector2(9, 14) + jitter - camera_position, _rock_big_draw_size),
					z
				)
			elif rock_variant == 1 and rock_medium_texture != null:
				_resource_pool.put(
					key,
					rock_medium_texture,
					Rect2(cell_world + Vector2(11, 20) + jitter - camera_position, _rock_medium_draw_size),
					z
				)
			elif rock_small_texture != null:
				_resource_pool.put(
					key,
					rock_small_texture,
					Rect2(cell_world + Vector2(15, 24) + jitter - camera_position, _rock_small_draw_size),
					z
				)


## Bob's house. The runtime still owns the damage overlay and repair wrench that
## sit on top of it, since those are procedural shapes rather than art.
func _sync_house(camera_position: Vector2) -> void:
	var house_texture: Texture2D = runtime._current_house_texture()
	if house_texture == null:
		return
	var house_center: Vector2 = _cell_to_world(_house_cell) + Vector2.ONE * _cell_size * 0.5
	_prop_pool.put(
		"house",
		house_texture,
		Rect2(house_center + _house_draw_offset - camera_position, _house_draw_size),
		HOUSE_Z
	)


func _sync_cave_entrance(camera_position: Vector2) -> void:
	var cave_entrance_texture: Texture2D = runtime.cave_entrance_texture
	if cave_entrance_texture == null:
		return
	var cave_rect := Rect2(_cell_to_world(_cave_entrance_cell) + Vector2(2, 2), Vector2(44, 44))
	_prop_pool.put(
		"cave_entrance",
		cave_entrance_texture,
		Rect2(cave_rect.position + Vector2(-10, -18) - camera_position, Vector2(64, 72)),
		CAVE_ENTRANCE_Z
	)


func _sync_forest_animals(camera_position: Vector2) -> void:
	if bool(runtime.inside_house) or bool(runtime.inside_cave):
		return
	var forest_animals: Array = runtime.forest_animals
	var world_time: float = runtime.world_time
	var visible_top: float = camera_position.y - 96.0
	var visible_bottom: float = camera_position.y + _screen_size.y + 96.0
	for index in range(forest_animals.size()):
		var animal: Dictionary = forest_animals[index]
		var animal_position := Vector2(animal["position"])
		if animal_position.y < visible_top or animal_position.y > visible_bottom:
			continue
		var animal_kind := String(animal.get("kind", "dog"))
		var animal_texture: Texture2D = runtime._forest_animal_texture(animal_kind)
		if animal_texture == null:
			continue
		var animal_size: Vector2 = runtime._forest_animal_draw_size(animal_kind)
		_animal_shadows.append(Rect2(
			animal_position + Vector2(-animal_size.x * 0.28, 6.0) - camera_position,
			Vector2(animal_size.x * 0.56, 12.0)
		))
		var bob_phase: float = float(animal.get("bob_phase", 0.0))
		var animal_sway: float = sin(world_time * 3.0 + bob_phase) * 1.6
		var animal_step: float = sin(world_time * 6.2 + bob_phase)
		var animal_bob: float = absf(animal_step) * 2.0
		var animal_rect := Rect2(
			animal_position + Vector2(-animal_size.x * 0.5, -animal_size.y + 8.0) - camera_position,
			animal_size
		)
		# The old draw call offset the transform origin rather than the rect, so
		# the sway and bob are applied to the centred sprite position here.
		animal_rect.position += Vector2(animal_sway * 0.2, -animal_bob)
		_animal_pool.put_transformed(
			"animal:%d" % index,
			animal_texture,
			animal_rect,
			animal_sway * 0.008,
			Vector2(1.0 + animal_step * 0.025, 1.0 - animal_step * 0.018),
			bool(animal.get("facing_left", false)),
			ANIMAL_Z
		)
