extends Node2D

## Draws the world backdrop — screen fill, ground tiles, waving grass and the
## build grid — on its own canvas item beneath the runtime's `_draw()`.
##
## This exists so world sprites can become real nodes. Children of the runtime
## always render *above* everything the runtime draws immediately, so putting a
## tree in a Sprite2D would have put it on top of the HUD. Moving the backdrop
## down to `GROUND_Z` opens a band of negative z-indices between the backdrop
## and the runtime's own drawing, which is where world sprite nodes live.

const GROUND_Z := -400

var runtime: Node2D

var _screen_size := Vector2(1280, 720)
var _cell_size := 48.0
var _grid_origin := Vector2(144, 96)
var _grid_size := Vector2i(24, 18)
var _forest_start_row := 8
var _ground_tile_draw_size := Vector2(96, 96)
var _bg_color := Color(0.07, 0.09, 0.12)
var _grass_color := Color(0.22, 0.31, 0.22)
var _woods_color := Color(0.15, 0.25, 0.16)
var _path_color := Color(0.45, 0.34, 0.22)
var _grid_line_color := Color(0.19, 0.21, 0.24)
var _decor_grass_region := Rect2()
var _decor_sunflower_region := Rect2()
var _decor_grass_draw_size := Vector2()
var _decor_sunflower_draw_size := Vector2()
var _house_block_cells: Array = []
var _left_build_yard: Array = []
var _right_build_yard: Array = []
var _constants_ready := false


func _ready() -> void:
	z_index = GROUND_Z
	z_as_relative = false
	runtime = get_parent() as Node2D
	_cache_constants()


## Reads the runtime constants through its script rather than duplicating the
## literals here, so retuning the grid or palette in `main_runtime.gd` keeps the
## backdrop in step automatically.
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
	_grid_size = constants.get("GRID_SIZE", _grid_size)
	_forest_start_row = constants.get("FOREST_START_ROW", _forest_start_row)
	_ground_tile_draw_size = constants.get("GROUND_TILE_DRAW_SIZE", _ground_tile_draw_size)
	_bg_color = constants.get("BG_COLOR", _bg_color)
	_grass_color = constants.get("GRASS_COLOR", _grass_color)
	_woods_color = constants.get("WOODS_COLOR", _woods_color)
	_path_color = constants.get("PATH_COLOR", _path_color)
	_grid_line_color = constants.get("GRID_LINE_COLOR", _grid_line_color)
	_decor_grass_region = constants.get("DECOR_GRASS_REGION", _decor_grass_region)
	_decor_sunflower_region = constants.get("DECOR_SUNFLOWER_REGION", _decor_sunflower_region)
	_decor_grass_draw_size = constants.get("DECOR_GRASS_DRAW_SIZE", _decor_grass_draw_size)
	_decor_sunflower_draw_size = constants.get("DECOR_SUNFLOWER_DRAW_SIZE", _decor_sunflower_draw_size)
	_house_block_cells = constants.get("HOUSE_BLOCK_CELLS", [])
	_left_build_yard = constants.get("LEFT_BUILD_YARD", [])
	_right_build_yard = constants.get("RIGHT_BUILD_YARD", [])
	_constants_ready = true


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if runtime == null or not _constants_ready:
		return
	# The runtime used to open its own `_draw()` with this fill. It moved here so
	# it cannot paint over the backdrop from a higher z-index.
	draw_rect(Rect2(Vector2.ZERO, _screen_size), _bg_color, true)
	var phase: int = runtime.phase
	if phase == runtime.Phase.MENU or phase == runtime.Phase.GAME_OVER:
		return
	var camera_position: Vector2 = runtime.camera_position
	_draw_ground_area(Rect2(_grid_origin, Vector2(_grid_size.x, _forest_start_row) * _cell_size), _grass_color, camera_position)
	var forest_top: Vector2 = _cell_to_world(Vector2i(0, _forest_start_row))
	var forest_bottom_y: float = maxf(
		forest_top.y + _screen_size.y + _cell_size * 2.0,
		camera_position.y + _screen_size.y + _cell_size * 2.0
	)
	_draw_ground_area(Rect2(forest_top, Vector2(_grid_size.x * _cell_size, forest_bottom_y - forest_top.y)), _woods_color, camera_position)
	_draw_waving_grass(camera_position)
	_draw_grid(camera_position)


func _cell_to_world(cell: Vector2i) -> Vector2:
	return _grid_origin + Vector2(cell.x, cell.y) * _cell_size


func _draw_ground_area(world_rect: Rect2, fallback_color: Color, camera_position: Vector2) -> void:
	var grass_tile_texture: Texture2D = runtime.grass_tile_texture
	if grass_tile_texture == null:
		draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), fallback_color, true)
		return
	var tile_step: Vector2 = _ground_tile_draw_size
	var world_end: Vector2 = world_rect.position + world_rect.size
	var y: float = world_rect.position.y
	while y < world_end.y:
		var x: float = world_rect.position.x
		while x < world_end.x:
			var draw_size := Vector2(
				minf(tile_step.x, world_end.x - x),
				minf(tile_step.y, world_end.y - y)
			)
			draw_texture_rect(grass_tile_texture, Rect2(Vector2(x, y) - camera_position, draw_size), false)
			x += tile_step.x
		y += tile_step.y
	draw_rect(
		Rect2(world_rect.position - camera_position, world_rect.size),
		Color(fallback_color.r, fallback_color.g, fallback_color.b, 0.18),
		true
	)


func _draw_waving_grass(camera_position: Vector2) -> void:
	var decor_sprite_texture: Texture2D = runtime.decor_sprite_texture
	var world_time: float = runtime.world_time
	var visible_start_y: int = maxi(0, int(floor(camera_position.y / _cell_size)) - 1)
	var visible_end_y: int = int(ceil((camera_position.y + _screen_size.y) / _cell_size)) + 1
	for y in range(visible_start_y, visible_end_y):
		for x in range(_grid_size.x):
			var cell := Vector2i(x, y)
			if runtime._cell_is_path(cell) or cell in _house_block_cells:
				continue
			var base_world: Vector2 = _cell_to_world(cell)
			var patch_seed: int = (x * 31 + y * 17) % 11
			var sway_phase: float = float((x * 19 + y * 23) % 29) * 0.17
			var sway: float = sin(world_time * 1.9 + sway_phase) * 2.2
			var draw_pos: Vector2 = base_world + Vector2(11 + sway, 30 + patch_seed % 4) - camera_position
			if decor_sprite_texture != null:
				var use_sunflowers: bool = cell.y < 9 and patch_seed in [0, 5]
				var decor_region: Rect2 = _decor_sunflower_region if use_sunflowers else _decor_grass_region
				var decor_size: Vector2 = _decor_sunflower_draw_size if use_sunflowers else _decor_grass_draw_size
				draw_texture_rect_region(decor_sprite_texture, Rect2(draw_pos, decor_size), decor_region)
			else:
				var blade_color: Color = _woods_color.lightened(0.16) if cell.y >= 9 else _grass_color.lightened(0.22)
				for blade_index in range(3):
					var blade_base: Vector2 = base_world + Vector2(10 + blade_index * 11, 38 + int((x + y + blade_index) % 4))
					var phase_offset: float = float(x * 13 + y * 7 + blade_index * 19) * 0.11
					var blade_sway: float = sin(world_time * 2.4 + phase_offset) * (4.0 + blade_index)
					var blade_tip: Vector2 = blade_base + Vector2(blade_sway, -10.0 - blade_index * 2.0)
					draw_line(blade_base - camera_position, blade_tip - camera_position, blade_color, 2.0)


func _draw_grid(camera_position: Vector2) -> void:
	var visible_start_y: int = maxi(0, int(floor(camera_position.y / _cell_size)) - 1)
	var visible_end_y: int = int(ceil((camera_position.y + _screen_size.y) / _cell_size)) + 1
	for y in range(visible_start_y, visible_end_y):
		for x in range(_grid_size.x):
			var cell := Vector2i(x, y)
			var world_rect := Rect2(_cell_to_world(cell), Vector2.ONE * _cell_size)
			if cell in _house_block_cells:
				continue
			var in_build_yard: bool = cell in _left_build_yard or cell in _right_build_yard
			var should_draw_outline: bool = in_build_yard
			if runtime._cell_is_path(cell):
				draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), _path_color, true)
				should_draw_outline = true
			if should_draw_outline:
				var outline_color: Color = Color(0.62, 0.68, 0.74, 0.82) if in_build_yard else _grid_line_color
				draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), outline_color, false, 2.0)
