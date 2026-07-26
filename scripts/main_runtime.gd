extends Node2D

# -------------------------------------------------------------------
# TUNABLE BALANCE CONSTANTS
# -------------------------------------------------------------------
const SCREEN_SIZE := Vector2(1280, 720)
const CELL_SIZE := 48.0
const GRID_ORIGIN := Vector2(144, 96)
const GRID_SIZE := Vector2i(24, 18)
const WORLD_SIZE := Vector2(GRID_SIZE.x, GRID_SIZE.y) * CELL_SIZE + Vector2(288, 192)

const BUILD_PHASE_DURATION := 60.0
const PLAYER_SPEED := 230.0
const PLAYER_MAX_HP := 6
const SHARED_CARRY_LIMIT := 20
const RESOURCE_HARVEST_TIME := 0.45
const RESOURCE_NODE_STARTS := 5
const RESOURCE_NODE_REFILL_AMOUNT := 1
const RESOURCE_NODE_REFILL_EVERY_ROUNDS := 5
const RESOURCE_DEPLETED_RETURN_ROUNDS := 18
const RESOURCE_DEPLETED_RETURN_AMOUNT := 1
const SHALLOW_RESOURCE_DECAY_AMOUNT := 1
const DEEP_RESOURCE_EXTRA_REFILL := 1
const DEEP_RESOURCE_DENSITY_BONUS := 0.12
const FOREST_START_ROW := 8
const FOREST_CHUNK_HEIGHT := 8
const FOREST_PRELOAD_CHUNKS := 4
const FOREST_TREE_DENSITY := 0.43
const FOREST_RESOURCE_DENSITY := 0.18
const FOREST_STONE_DENSITY := 0.05
const FOREST_ANIMALS_PER_CHUNK := 2
const FOREST_ANIMAL_FLEE_DISTANCE := 92.0
const FOREST_ANIMAL_WANDER_SPEED_MIN := 10.0
const FOREST_ANIMAL_WANDER_SPEED_MAX := 22.0
const SHALLOW_RESOURCE_BAND_ROWS := 10
const SHALLOW_WOOD_NODE_STARTS := 4
const SHALLOW_STONE_NODE_STARTS := 3
const IRON_NODE_STARTS := 5
const DEV_MODE_PIN := "5543"
const COUNTDOWN_DIGIT_DRAW_SIZE := Vector2(30, 42)
const COUNTDOWN_DIGIT_SOURCE_RECTS := [
	Rect2(24, 24, 84, 96),
	Rect2(132, 24, 60, 96),
	Rect2(228, 24, 72, 96),
	Rect2(324, 24, 72, 96),
	Rect2(420, 24, 60, 96),
	Rect2(504, 24, 60, 96),
	Rect2(588, 24, 60, 96),
	Rect2(684, 24, 72, 96),
	Rect2(780, 24, 72, 96),
	Rect2(876, 24, 72, 96)
]
const MENU_BACKGROUND_REGION := Rect2(0, 1296, 4793, 2721)
const DEEP_RESOURCE_BONUS_START_ROW := FOREST_START_ROW + FOREST_CHUNK_HEIGHT
const DEEP_STONE_DENSITY_BONUS := 0.12
const PRIZED_HOUSE_ITEM := "KFZ Air Fryer Console"
const HOUSE_MAX_DAMAGE_STAGES := 3
const HOUSE_REPAIR_WOOD_COST := 3
const HOUSE_REPAIR_STONE_COST := 2
const HOUSE_START_ITEMS := [
	"Tax Papers",
	"Family Portrait",
	"Couch Coins",
	"Lucky Mug",
	PRIZED_HOUSE_ITEM
]
const START_WAVE_EARLY_REWARD := 0
const DEALER_GUN_TURRET_UNLOCK_GOLD_COST := 4
const DEALER_SIDEARM_GOLD_COST := 3
const DEALER_RIFLE_GOLD_COST := 5
const DEALER_TURRET_BUFF_GOLD_COST := 5
const DEALER_GUN_BUFF_GOLD_COST := 5
const DEALER_TURRET_AMMO_GOLD_COST := 3
const DEALER_TURRET_AMMO_AMOUNT := 20
const DEALER_CANNON_SHELL_GOLD_COST := 3
const DEALER_CANNON_SHELL_AMOUNT := 6
const DEALER_WOOD_GOLD_COST := 2
const DEALER_WOOD_AMOUNT := 8
const DEALER_STONE_GOLD_COST := 2
const DEALER_STONE_AMOUNT := 6
const DEALER_IRON_GOLD_COST := 3
const DEALER_IRON_AMOUNT := 5
const DEALER_GUNPOWDER_GOLD_COST := 3
const DEALER_GUNPOWDER_AMOUNT := 5
const DEALER_HEAL_GOLD_COST := 2
const DEALER_SELL_WOOD_AMOUNT := 8
const DEALER_SELL_WOOD_GOLD_GAIN := 1
const DEALER_SELL_STONE_AMOUNT := 6
const DEALER_SELL_STONE_GOLD_GAIN := 1
const DEALER_SELL_IRON_AMOUNT := 5
const DEALER_SELL_IRON_GOLD_GAIN := 2
const DEALER_SELL_GUNPOWDER_AMOUNT := 5
const DEALER_SELL_GUNPOWDER_GOLD_GAIN := 2

const ARROW_TURRET_WOOD_COST := 4
const ARROW_TURRET_STONE_COST := 0
const ARROW_TURRET_DAMAGE := 1
const ARROW_TURRET_RANGE := 190.0
const ARROW_TURRET_FIRE_RATE := 0.68
const ARROW_TURRET_PROJECTILE_SPEED := 360.0
const ARROW_TURRET_PROJECTILE_RADIUS := 4.0
const ARROW_TURRET_STARTING_AMMO := 42

const CANNON_TURRET_WOOD_COST := 7
const CANNON_TURRET_STONE_COST := 4
const CANNON_TURRET_DAMAGE := 3
const CANNON_TURRET_RANGE := 238.0
const CANNON_TURRET_FIRE_RATE := 2.50
const CANNON_TURRET_PROJECTILE_SPEED := 210.0
const CANNON_TURRET_PROJECTILE_RADIUS := 6.0
const CANNON_TURRET_SPLASH_RADIUS := 54.0
const CANNON_TURRET_STARTING_AMMO := 14

const GUN_TURRET_WOOD_COST := 4
const GUN_TURRET_STONE_COST := 1
const GUN_TURRET_GUNPOWDER_COST := 2
const GUN_TURRET_DAMAGE := 2
const GUN_TURRET_RANGE := 268.0
const GUN_TURRET_FIRE_RATE := 0.34
const GUN_TURRET_PROJECTILE_SPEED := 560.0
const GUN_TURRET_PROJECTILE_RADIUS := 4.0
const GUN_TURRET_STARTING_AMMO := 34

const MAGIC_TURRET_WOOD_COST := 6
const MAGIC_TURRET_STONE_COST := 4
const MAGIC_TURRET_IRON_COST := 8
const MAGIC_TURRET_CRYSTAL_COST := 2
const MAGIC_TURRET_DAMAGE := 4
const MAGIC_TURRET_RANGE := 308.0
const MAGIC_TURRET_FIRE_RATE := 0.28
const MAGIC_TURRET_PROJECTILE_SPEED := 540.0
const MAGIC_TURRET_PROJECTILE_RADIUS := 6.0

const GOLDEN_TURRET_WOOD_COST := 4
const GOLDEN_TURRET_STONE_COST := 2
const GOLDEN_TURRET_GOLD_COST := 4
const GOLDEN_TURRET_DAMAGE := 2
const GOLDEN_TURRET_RANGE := 280.0
const GOLDEN_TURRET_FIRE_RATE := 0.34
const GOLDEN_TURRET_PROJECTILE_SPEED := 500.0
const GOLDEN_TURRET_PROJECTILE_RADIUS := 4.0
const GOLDEN_TURRET_STARTING_AMMO := 36

const RIFLE_TURRET_WOOD_COST := 6
const RIFLE_TURRET_STONE_COST := 2
const RIFLE_TURRET_GUNPOWDER_COST := 4
const RIFLE_TURRET_DAMAGE := 3
const RIFLE_TURRET_RANGE := 336.0
const RIFLE_TURRET_FIRE_RATE := 0.52
const RIFLE_TURRET_PROJECTILE_SPEED := 620.0
const RIFLE_TURRET_PROJECTILE_RADIUS := 4.0

const SIDEARM_WOOD_COST := 2
const SIDEARM_STONE_COST := 1
const SIDEARM_DAMAGE := 1
const SIDEARM_RANGE := 210.0
const SIDEARM_FIRE_RATE := 0.60

const RIFLE_WOOD_COST := 4
const RIFLE_STONE_COST := 3
const RIFLE_DAMAGE := 2
const RIFLE_RANGE := 300.0
const RIFLE_FIRE_RATE := 0.34

const PLAYER_SWORD_DAMAGE := 3
const PLAYER_SWORD_RANGE := 70.0
const PLAYER_SWORD_ARC_DOT := 0.15
const PLAYER_SWORD_COOLDOWN := 0.55
const PLAYER_SWORD_SWING_TIME := 0.18
const PLAYER_DODGE_COOLDOWN := 1.15
const PLAYER_DODGE_TIME := 0.20
const PLAYER_DODGE_SPEED_BONUS := 210.0
const PLAYER_PARRY_WINDOW := 0.20
const PLAYER_PARRY_COOLDOWN := 0.70
const PLAYER_PARRY_STUN_TIME := 1.05

const TURRET_UPGRADE_1_WOOD_COST := 4
const TURRET_UPGRADE_1_STONE_COST := 2
const TURRET_UPGRADE_2_WOOD_COST := 6
const TURRET_UPGRADE_2_STONE_COST := 4

const HIT_FLASH_TIME := 0.16
const WAVE_BANNER_TIME := 1.6
const INVENTORY_FULL_FLASH_TIME := 0.9
const TURRET_BUILD_TIME := 2.2
const SELL_REFUND_RATIO := 0.5
const MENU_MUSIC_VOLUME_DB := -10.0
const MENU_MUSIC_START_TIME := 60.0
const CAVE_MUSIC_VOLUME_DB := -9.0
const BOSS_MUSIC_VOLUME_DB := -8.0
const BOSS_MUSIC_START_TIME := 22.0
const MENU_BACKGROUND_BEAT_ZOOM := 0.055
const MENU_MUSIC_BUS_NAME := "MenuMusic"
const SFX_BUS_NAME := "SFX"
const CAVE_MUSIC_ROOM_1_START := 0.0
const CAVE_MUSIC_ROOM_1_END := 40.0
const CAVE_MUSIC_ROOM_2_START := 40.0
const CAVE_MUSIC_ROOM_2_END := 82.0
const CAVE_MUSIC_ROOM_3_START := 82.0
const CAVE_MUSIC_ROOM_3_END := 166.0
const CAVE_MUSIC_ROOM_4_START := 168.0
const CAVE_MUSIC_ROOM_4_END := 9999.0

const WALL_LIGHT_WOOD_COST := 2
const WALL_LIGHT_HP := 5
const WALL_MEDIUM_WOOD_COST := 3
const WALL_MEDIUM_STONE_COST := 1
const WALL_MEDIUM_HP := 9
const WALL_HEAVY_WOOD_COST := 3
const WALL_HEAVY_STONE_COST := 3
const WALL_HEAVY_HP := 14
const WALL_REPAIR_LIGHT_WOOD_COST := 1
const WALL_REPAIR_MEDIUM_WOOD_COST := 1
const WALL_REPAIR_MEDIUM_STONE_COST := 1
const WALL_REPAIR_HEAVY_WOOD_COST := 2
const WALL_REPAIR_HEAVY_STONE_COST := 1
const WALL_REPAIR_AMOUNT := 4

const BASE_ENEMY_COUNT := 8
const BASE_ENEMY_HP := 5
const BASE_ENEMY_SPEED := 70.0
const BASE_ENEMY_DAMAGE := 2
const BASE_BRUTE_BONUS_HP := 6
const BASE_BRUTE_SPEED_SCALE := 0.68
const SWAT_START_ROUND := 5
const SWAT_WAVE_FREQUENCY := 5
const SWAT_EXTRA_HP := 10
const SWAT_SPEED_SCALE := 1.12
const SWAT_DAMAGE := 3
const SWAT_GOLD_REWARD := 2
const ROUND_DIFFICULTY_MULTIPLIER := 1.28
const ENEMY_ATTACK_RATE := 0.62
const ENEMY_ATTACK_WINDUP := 0.34
const SPAWN_WARNING_LOOKAHEAD := 1.65
const EARLY_ROUND_ENEMY_COUNTS := [4, 6, 8, 10, 12]
const EARLY_ROUND_ENEMY_HP := [3, 4, 5, 6, 7]
const EARLY_ROUND_ENEMY_SPEED := [54.0, 60.0, 66.0, 73.0, 79.0]
const EARLY_ROUND_SPAWN_GAP := [1.32, 1.10, 0.98, 0.88, 0.80]
const EARLY_ROUND_BRUTE_EVERY := [0, 0, 0, 4, 3]
const CAVE_RESET_EVERY_ROUNDS := 5
const CAVE_ROOM_TRANSITION_MARGIN := 18.0
const CAVE_KEY_COLOR := Color(0.92, 0.80, 0.36)
const CAVE_TRANSITION_COOLDOWN := 0.22
const CAVE_GOLD_YIELD := 2
const CAVE_GUNPOWDER_YIELD := 2
const CAVE_IRON_YIELD := 1
const CAVE_MINER_GOLD_REWARD := 1
const CAVE_BOSS_GOLD_REWARD := 4
const CAVE_CRYSTAL_GOLD_REWARD := 2
const CAVE_CRYSTAL_GUNPOWDER_REWARD := 1
const CAVE_MINER_DRAW_SIZE := Vector2(78, 78)
const CAVE_BOSS_DRAW_SIZE := Vector2(132, 104)
const CAVE_BOSS_SHADOW_COLOR := Color(0.08, 0.02, 0.02, 0.50)
const CAVE_BOSS_MAX_HP := 40
const CAVE_BOSS_ATTACK_TIME := 0.46
const CAVE_BOSS_ATTACK_COOLDOWN := 1.15
const CAVE_BOSS_ATTACK_RANGE := 88.0
const CAVE_BOSS_ATTACK_DAMAGE := 2
const CAVE_BOSS_ATTACK_HIT_TIME := 0.18
const CAVE_BOSS_PHASE_ONE_TRIGGER := 0.75
const CAVE_BOSS_PHASE_TWO_TRIGGER := 0.50
const CAVE_BOSS_LAST_STAND_TRIGGER := 0.25
const CAVE_BOSS_SLAM_WINDUP := 1.05
const CAVE_BOSS_SLAM_COOLDOWN := 3.85
const CAVE_BOSS_SLAM_STUN_TIME := 0.95
const CAVE_BOSS_ROCKFALL_MIN := 4
const CAVE_BOSS_ROCKFALL_MAX := 6
const CAVE_BOSS_ROCKFALL_FALL_TIME := 0.55
const CAVE_BOSS_ROCK_DAMAGE_SMALL := 1
const CAVE_BOSS_ROCK_DAMAGE_BIG := 2
const CAVE_BOSS_ADD_SUMMON_COUNT := 3
const CAVE_BOSS_LAST_STAND_ADD_COUNT := 4
const CAVE_BOSS_RUBBLE_TIME := 6.0
const CAVE_BOSS_MARKER_SAFE_RADIUS := 86.0
const CAVE_BOSS_MARKER_MIN_SPACING := 92.0
const CAVE_BOSS_REWARD_WOOD := 12
const CAVE_BOSS_REWARD_STONE := 12
const CAVE_BOSS_REWARD_IRON := 10
const CAVE_BOSS_REWARD_GOLD := 12
const CAVE_BOSS_REWARD_GUNPOWDER := 10
const ROBOT_DEATH_FRAME_TIME := 0.10
const ROBOT_DEATH_LINGER_TIME := 0.55
const CAVE_MINER_DEATH_FRAME_TIME := 0.12
const CAVE_MINER_DEATH_LINGER_TIME := 0.52

# -------------------------------------------------------------------
# EDITABLE MAP SETUP
# -------------------------------------------------------------------
const HOUSE_TOP_LEFT := Vector2i(10, 3)
const HOUSE_CELL := Vector2i(11, 4)
const LEFT_PATH_CELLS: Array[Vector2i] = [
	Vector2i(0, 6), Vector2i(1, 6), Vector2i(2, 6), Vector2i(3, 6), Vector2i(4, 6),
	Vector2i(5, 6), Vector2i(6, 6), Vector2i(7, 6), Vector2i(7, 5), Vector2i(7, 4),
	Vector2i(7, 3), Vector2i(8, 3), Vector2i(9, 3), Vector2i(10, 3), Vector2i(10, 2)
]
const RIGHT_PATH_CELLS: Array[Vector2i] = [
	Vector2i(23, 6), Vector2i(22, 6), Vector2i(21, 6), Vector2i(20, 6), Vector2i(19, 6),
	Vector2i(18, 6), Vector2i(17, 6), Vector2i(16, 6), Vector2i(16, 5), Vector2i(16, 4),
	Vector2i(16, 3), Vector2i(15, 3), Vector2i(14, 3), Vector2i(13, 3), Vector2i(13, 2)
]
const SIDE_SPAWN_ROW_RANGE := Vector2i(3, 9)
const SIDE_SPAWN_OFFSET_X := 84.0
const HOUSE_DAMAGE_CELLS: Array[Vector2i] = [Vector2i(10, 4), Vector2i(13, 4)]
const CAVE_ENTRANCE_CELL := Vector2i(11, 28)
const DEALER_STAND_CELL := Vector2i(14, 5)

const LEFT_BUILD_YARD: Array[Vector2i] = [
	Vector2i(5, 3), Vector2i(6, 3), Vector2i(7, 3), Vector2i(8, 3),
	Vector2i(5, 4), Vector2i(6, 4), Vector2i(7, 4), Vector2i(8, 4),
	Vector2i(5, 5), Vector2i(6, 5), Vector2i(7, 5), Vector2i(8, 5),
	Vector2i(5, 6), Vector2i(6, 6), Vector2i(7, 6), Vector2i(8, 6),
	Vector2i(5, 7), Vector2i(6, 7), Vector2i(7, 7), Vector2i(8, 7)
]
const RIGHT_BUILD_YARD: Array[Vector2i] = [
	Vector2i(15, 3), Vector2i(16, 3), Vector2i(17, 3), Vector2i(18, 3),
	Vector2i(15, 4), Vector2i(16, 4), Vector2i(17, 4), Vector2i(18, 4),
	Vector2i(15, 5), Vector2i(16, 5), Vector2i(17, 5), Vector2i(18, 5),
	Vector2i(15, 6), Vector2i(16, 6), Vector2i(17, 6), Vector2i(18, 6),
	Vector2i(15, 7), Vector2i(16, 7), Vector2i(17, 7), Vector2i(18, 7)
]
const STONE_RESOURCE_NODES := [
	{"cell": Vector2i(18, 14), "kind": "stone"},
	{"cell": Vector2i(20, 13), "kind": "stone"}
]

const PLAYER_START_CELL := Vector2i(11, 7)
const PLAYER_SIZE := Vector2(26, 26)

const HOUSE_BLOCK_CELLS: Array[Vector2i] = [
	Vector2i(10, 3), Vector2i(11, 3), Vector2i(12, 3), Vector2i(13, 3),
	Vector2i(10, 4), Vector2i(11, 4), Vector2i(12, 4), Vector2i(13, 4)
]

const PLAYER_SPRITE_REGION := Rect2(92, 70, 220, 620)
const PLAYER_BODY_REGION := Rect2(396, 120, 408, 1008)
const PLAYER_RUN_REGION := Rect2(300, 28, 500, 996)
const PLAYER_SWORD_REGION := Rect2(440, 86, 82, 372)
const PLAYER_SHIELD_REGION := Rect2(590, 74, 232, 360)
const TURRET_IDLE_REGION := Rect2(420, 1668, 384, 348)
const TURRET_LOADED_REGION := Rect2(408, 432, 444, 348)
const CANNON_TURRET_REGION := Rect2(1056, 1344, 948, 456)
const GOLDEN_TURRET_REGION := Rect2(924, 1212, 996, 720)
const GUN_TURRET_REGION := Rect2(144, 624, 1944, 852)
const CANNON_TURRET_TOP_REGION := Rect2(1, 8, 43, 44)
const CANNON_TURRET_BASE_REGION := Rect2(1, 52, 43, 59)
const GUN_TURRET_TOP_REGION := Rect2(144, 624, 1944, 430)
const GUN_TURRET_BASE_REGION := Rect2(144, 1054, 1944, 482)
const MAGIC_TURRET_TOP_REGION := Rect2(144, 240, 1536, 620)
const MAGIC_TURRET_BASE_REGION := Rect2(144, 860, 1536, 676)
const IRS_AGENT_BODY_REGION := Rect2(348, 96, 408, 900)
const IRS_AGENT_GUN_REGION := Rect2(0, 156, 492, 156)
const DECOR_GRASS_REGION := Rect2(154, 92, 194, 56)
const DECOR_SUNFLOWER_REGION := Rect2(0, 220, 210, 108)
const PLAYER_DRAW_SIZE := Vector2(46, 92)
const PLAYER_DRAW_OFFSET := Vector2(-10, -62)
const PLAYER_RUN_DRAW_SIZE := PLAYER_DRAW_SIZE
const PLAYER_RUN_DRAW_OFFSET := PLAYER_DRAW_OFFSET
const TURRET_DRAW_SIZE := Vector2(56, 28)
const CANNON_TURRET_DRAW_SIZE := Vector2(102, 50)
const GOLDEN_TURRET_DRAW_SIZE := Vector2(90, 66)
const GUN_TURRET_DRAW_SIZE := Vector2(88, 56)
const CANNON_TURRET_TOP_DRAW_SIZE := Vector2(74, 46)
const CANNON_TURRET_BASE_DRAW_SIZE := Vector2(62, 66)
const GUN_TURRET_TOP_DRAW_SIZE := Vector2(136, 40)
const GUN_TURRET_BASE_DRAW_SIZE := Vector2(96, 44)
const MAGIC_TURRET_DRAW_SIZE := Vector2(92, 92)
const MAGIC_TURRET_TOP_DRAW_SIZE := Vector2(84, 60)
const MAGIC_TURRET_BASE_DRAW_SIZE := Vector2(74, 64)
const DECOR_GRASS_DRAW_SIZE := Vector2(44, 16)
const DECOR_SUNFLOWER_DRAW_SIZE := Vector2(48, 30)
const FOREST_TREE_DRAW_SIZE := Vector2(132, 164)
const FOREST_DOG_DRAW_SIZE := Vector2(86, 68)
const FOREST_BEAVER_DRAW_SIZE := Vector2(80, 64)
const DEALER_STAND_DRAW_SIZE := Vector2(80, 96)
const ARMS_DEALER_REGION := Rect2(11, 2, 32, 62)
const ARMS_DEALER_DRAW_SIZE := Vector2(58, 112)
const ROCK_BIG_DRAW_SIZE := Vector2(28, 28)
const ROCK_MEDIUM_DRAW_SIZE := Vector2(24, 18)
const ROCK_SMALL_DRAW_SIZE := Vector2(18, 12)
const IRS_ROBOT_DRAW_SIZE := Vector2(68, 68)
const IRS_BRUTE_DRAW_SIZE := Vector2(84, 84)
const IRS_AGENT_DRAW_SIZE := Vector2(48, 82)
const IRS_AGENT_GUN_DRAW_SIZE := Vector2(18, 10)
const SWAT_DRAW_SIZE := Vector2(62, 88)
const INVENTORY_BADGE_ICON_DRAW_SIZE := Vector2(26, 26)
const HOUSE_DRAW_SIZE := Vector2(292, 292)
const HOUSE_DRAW_OFFSET := Vector2(-52, -192)
const HOUSE_DRAW_MAX_SIZE := Vector2(360, 220)
const GROUND_TILE_DRAW_SIZE := Vector2(96, 96)
const HOUSE_ITEM_DRAW_SIZE := Vector2(42, 42)
const WRENCH_DRAW_SIZE := Vector2(18, 18)
const WRENCH_SWING_DRAW_SIZE := Vector2(28, 28)
const ARROW_PROJECTILE_DRAW_SIZE := Vector2(24, 24)
const CANNONBALL_PROJECTILE_DRAW_SIZE := Vector2(30, 30)
const CANNONBALL_ARC_HEIGHT := 104.0

# -------------------------------------------------------------------
# VISUALS
# -------------------------------------------------------------------
const BG_COLOR := Color(0.07, 0.09, 0.12)
const GRASS_COLOR := Color(0.22, 0.31, 0.22)
const WOODS_COLOR := Color(0.15, 0.25, 0.16)
const PATH_COLOR := Color(0.45, 0.34, 0.22)
const YARD_COLOR := Color(0.27, 0.27, 0.31)
const GRID_LINE_COLOR := Color(0.19, 0.21, 0.24)
const HOUSE_COLOR := Color(0.82, 0.86, 0.94)
const ROOF_COLOR := Color(0.55, 0.25, 0.22)
const PLAYER_COLOR := Color(0.98, 0.95, 0.88)
const WOOD_NODE_COLOR := Color(0.32, 0.82, 0.45)
const STONE_NODE_COLOR := Color(0.63, 0.70, 0.78)
const IRON_NODE_COLOR := Color(0.70, 0.74, 0.84)
const GOLD_NODE_COLOR := Color(0.92, 0.76, 0.24)
const GUNPOWDER_NODE_COLOR := Color(0.52, 0.52, 0.56)
const TURRET_COLOR := Color(0.95, 0.74, 0.22)
const MAGIC_COLOR := Color(0.68, 0.52, 1.0)
const LIGHT_WALL_COLOR := Color(0.61, 0.45, 0.26)
const MEDIUM_WALL_COLOR := Color(0.56, 0.48, 0.40)
const HEAVY_WALL_COLOR := Color(0.51, 0.53, 0.58)
const RUNNER_COLOR := Color(0.91, 0.34, 0.32)
const BRUTE_COLOR := Color(0.71, 0.27, 0.86)
const SWAT_COLOR := Color(0.24, 0.42, 0.86)
const PROJECTILE_COLOR := Color(0.98, 0.97, 0.80)
const SIDEARM_PROJECTILE_COLOR := Color(0.45, 0.88, 1.0)
const RIFLE_PROJECTILE_COLOR := Color(1.0, 0.82, 0.32)
const SLASH_COLOR := Color(1.0, 0.95, 0.70, 0.75)
const HOUSE_DANGER_COLOR := Color(0.96, 0.48, 0.42)
const TROPHY_COLOR := Color(1.0, 0.84, 0.24)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)
const MUTED_TEXT_COLOR := Color(0.74, 0.78, 0.82)
const UI_PANEL_FILL := Color(0.05, 0.07, 0.09, 0.92)
const UI_PANEL_FILL_SOFT := Color(0.09, 0.11, 0.14, 0.90)
const UI_PANEL_BORDER := Color(0.90, 0.84, 0.62, 0.46)
const UI_PANEL_SHADOW := Color(0.0, 0.0, 0.0, 0.22)
const UI_WARM_ACCENT := Color(0.96, 0.82, 0.44)
const UI_COOL_ACCENT := Color(0.64, 0.82, 1.0)
const UI_SUCCESS_ACCENT := Color(0.62, 0.92, 0.70)
const UI_DANGER_ACCENT := Color(0.96, 0.52, 0.48)
const UI_PANEL_RADIUS := 12

enum Phase { MENU, BUILD, DEFEND, GAME_OVER }
enum StructureType { NONE, TURRET, WALL_LIGHT, WALL_MEDIUM, WALL_HEAVY }

const PLAYER_VISUAL_SCENE := preload("res://scenes/visuals/player_visual.tscn")
const DEALER_VISUAL_SCENE := preload("res://scenes/visuals/dealer_visual.tscn")
const TURRET_VISUAL_SCENE := preload("res://scenes/visuals/turret_visual.tscn")
const ENEMY_VISUAL_SCENE := preload("res://scenes/visuals/enemy_visual.tscn")

var phase := Phase.MENU
var round_number := 1
var highest_round := 1
var countdown := BUILD_PHASE_DURATION
var wood := 0
var stone := 0
var iron := 0
var gold := 0
var gunpowder := 0
var cave_crystals_owned := 0
var player_hp := PLAYER_MAX_HP
var player_position := Vector2.ZERO
var selected_cell := Vector2i.ZERO
var camera_position := Vector2.ZERO
var inside_house := false
var inside_cave := false
var cave_mode_token := false
var interior_player_position := Vector2(626, 520)
var cave_player_position := Vector2(260, 470)
var trophy_stolen := false
var house_items: Array[String] = []
var stolen_house_items: Array[String] = []
var house_damage_stage := 0
var owned_guns := {
	"sidearm": false,
	"rifle": false
}
var turret_ammo := 18
var cannon_shells := 6
var gun_cooldowns := {
	"sidearm": 0.0,
	"rifle": 0.0
}
var player_aim_direction := Vector2.RIGHT
var player_attack_cooldown := 0.0
var player_swing_timer := 0.0
var player_swing_direction := Vector2.RIGHT
var house_flash_timer := 0.0
var wave_banner_timer := 0.0
var wave_banner_text := ""
var build_menu_open := false
var selected_sentry_kind := "arrow"
var dealer_menu_open := false
var dealer_page := "buy"
var inventory_menu_open := false
var run_start_input_lock_timer := 0.0
var dev_mode_enabled := false
var dev_mode_prompt_open := false
var escape_confirm_open := false
var escape_confirm_action := ""
var escape_confirm_title := ""
var escape_confirm_body := ""
var magic_sentry_unlocked := false
var cave_player_hit_cooldown := 0.0
var cave_transition_cooldown := 0.0
var gun_sentry_unlocked := false
var golden_sentry_unlocked := false
var rifle_sentry_unlocked := false
var shield_unlocked := false
var dodge_unlocked := false
var dodge_cooldown := 0.0
var dodge_timer := 0.0
var parry_timer := 0.0
var parry_cooldown := 0.0
var cave_room_id := "entrance"
var cave_keys := 0
var cave_cycle_index := 0
var cave_rooms := {}
var cave_seen_rooms := {}
var cave_room_enemy_defeated := {}
var cave_switch_states := {}
var cave_shortcuts_unlocked := {}
var cave_pickups_claimed := {}
var cave_secret_revealed := {}
var cave_boss_defeated := false
var cave_boss_intro_seen := false
var cave_boss_last_stand_triggered := false
var tutorial_got_wood := false
var tutorial_got_stone := false
var tutorial_built_once := false
var tutorial_opened_dealer := false
var tutorial_entered_cave := false
var tutorial_repaired_house := false

var harvest_timer := 0.0
var harvesting_node_index := -1
var inventory_full_timer := 0.0
var gather_effects: Array[Dictionary] = []
var hit_effects: Array[Dictionary] = []
var enemy_shots: Array[Dictionary] = []
var defend_elapsed := 0.0
var enemy_spawn_index := 0
var next_enemy_id := 1
var last_wave_enemy_count := 0
var last_wave_enemy_hp := 0
var last_wave_enemy_speed := 0.0

var build_cells: Array[Vector2i] = []
var forest_tree_cells: Array[Vector2i] = []
var forest_animals: Array[Dictionary] = []
var generated_forest_chunk_count := 0
var path_lookup := {}
var structures := {}
var resource_nodes: Array[Dictionary] = []
var enemies: Array[Dictionary] = []
var enemy_corpses: Array[Dictionary] = []
var projectiles: Array[Dictionary] = []
var spawn_queue: Array[Dictionary] = []
var cave_nodes: Array[Dictionary] = []
var cave_enemies: Array[Dictionary] = []
var cave_enemy_corpses: Array[Dictionary] = []
var cave_crystals: Array[Dictionary] = []
var cave_boss_rock_markers: Array[Dictionary] = []
var cave_falling_rocks: Array[Dictionary] = []
var cave_rock_rubble: Array[Dictionary] = []

var title_label: Label
var hud_heart_icon: TextureRect
var stats_label: Label
var hint_label: Label
var overlay_label: Label
var menu_panel: ColorRect
var menu_title_label: Label
var menu_desc_label: Label
var menu_start_button: Button
var menu_dev_button: Button
var menu_continue_hint_label: Label
var menu_info_label: Label
var music_volume_slider: HSlider
var sfx_volume_slider: HSlider
var music_volume_value_label: Label
var sfx_volume_value_label: Label
var menu_dev_panel: ColorRect
var menu_dev_pin_label: Label
var menu_dev_pin_input: LineEdit
var menu_dev_status_label: Label
var escape_confirm_panel: ColorRect
var escape_confirm_title_label: Label
var escape_confirm_body_label: Label
var escape_confirm_hint_label: Label
var player_sprite_texture: Texture2D
var player_body_texture: Texture2D
var player_run_1_texture: Texture2D
var player_run_2_texture: Texture2D
var player_run_3_texture: Texture2D
var player_run_4_texture: Texture2D
var player_run_5_texture: Texture2D
var team_logo_texture: Texture2D
var turret_sprite_texture: Texture2D
var cannon_turret_texture: Texture2D
var golden_turret_texture: Texture2D
var gun_turret_texture: Texture2D
var arrow_projectile_texture: Texture2D
var cannonball_projectile_texture: Texture2D
var healing_fountain_texture: Texture2D
var decor_sprite_texture: Texture2D
var forest_tree_texture: Texture2D
var forest_dog_texture: Texture2D
var forest_beaver_texture: Texture2D
var tree_trunk_texture: Texture2D
var irs_robot_texture: Texture2D
var irs_robot_walk_1_texture: Texture2D
var irs_robot_walk_2_texture: Texture2D
var irs_robot_walk_3_texture: Texture2D
var irs_robot_death_1_texture: Texture2D
var irs_robot_death_2_texture: Texture2D
var irs_robot_death_3_texture: Texture2D
var irs_agent_body_texture: Texture2D
var irs_agent_gun_texture: Texture2D
var swat_texture: Texture2D
var irs_agent_run_1_texture: Texture2D
var irs_agent_run_2_texture: Texture2D
var irs_agent_run_3_texture: Texture2D
var irs_agent_run_4_texture: Texture2D
var irs_agent_run_5_texture: Texture2D
var irs_agent_run_6_texture: Texture2D
var irs_agent_run_7_texture: Texture2D
var rock_big_texture: Texture2D
var rock_medium_texture: Texture2D
var rock_small_texture: Texture2D
var iron_ore_texture: Texture2D
var gold_ore_texture: Texture2D
var gunpowder_ore_texture: Texture2D
var cave_miner_walk_1_texture: Texture2D
var cave_miner_walk_2_texture: Texture2D
var cave_miner_walk_3_texture: Texture2D
var cave_miner_death_1_texture: Texture2D
var cave_miner_death_2_texture: Texture2D
var cave_miner_death_3_texture: Texture2D
var cave_miner_shovel_texture: Texture2D
var cave_entrance_texture: Texture2D
var wrench_texture: Texture2D
var house_texture: Texture2D
var house_broken_1_texture: Texture2D
var house_broken_2_texture: Texture2D
var grass_tile_texture: Texture2D
var tax_papers_texture: Texture2D
var mug_texture: Texture2D
var trophy_texture: Texture2D
var couch_coins_texture: Texture2D
var kfz_console_texture: Texture2D
var family_photo_texture: Texture2D
var wall_light_texture: Texture2D
var wall_medium_texture: Texture2D
var wall_heavy_texture: Texture2D
var countdown_numbers_texture: Texture2D
var heart_icon_texture: Texture2D
var inventory_icon_texture: Texture2D
var inventory_full_icon_texture: Texture2D
var crystal_sentry_texture: Texture2D
var laser_projectile_texture: Texture2D
var arms_dealer_texture: Texture2D
var menu_background_texture: Texture2D
var loss_screen_texture: Texture2D
var backyard_fence_texture: Texture2D
var cave_boss_texture: Texture2D
var cave_boss_attack_texture: Texture2D
var cave_boss_walk_1_texture: Texture2D
var cave_boss_walk_2_texture: Texture2D
var cave_boss_walk_3_texture: Texture2D
var cave_boss_slam_frames: Array[Texture2D] = []
var falling_rock_frames: Array[Texture2D] = []
var crossbow_sound: AudioStream
var gunshot_sound: AudioStream
var explosion_sound: AudioStream
var menu_music_stream: AudioStream
var cave_music_stream: AudioStream
var boss_music_stream: AudioStream
var world_time := 0.0
var explosion_effects: Array[Dictionary] = []
var dealer_status_text := "The arms dealer trades in dollars."
var turret_damage_bonus := 0
var gun_damage_bonus := 0
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_player_index := 0
var turret_visual_nodes := {}
var menu_music_player: AudioStreamPlayer
var cave_music_player: AudioStreamPlayer
var boss_music_player: AudioStreamPlayer
var music_credit_panel: ColorRect
var music_credit_title_label: Label
var music_credit_body_label: Label
var menu_music_bus_index := -1
var sfx_bus_index := -1
var menu_music_spectrum_effect_index := 0
var menu_music_visual_pulse := 0.0
var menu_music_energy_smooth := 0.0
var current_cave_music_segment_id := ""
var music_volume_percent := 100.0
var sfx_volume_percent := 100.0
var enemy_visual_nodes := {}

@onready var visual_layer: Node2D = $VisualLayer
@onready var player_visual_node: Node2D = $VisualLayer/PlayerVisual
@onready var dealer_visual_node: Node2D = $VisualLayer/DealerVisual
@onready var turret_visual_container: Node2D = $VisualLayer/TurretVisuals
@onready var enemy_visual_container: Node2D = $VisualLayer/EnemyVisuals
@onready var player_visual_sprite: Sprite2D = $VisualLayer/PlayerVisual/Body
@onready var dealer_visual_sprite: Sprite2D = $VisualLayer/DealerVisual/Dealer


func _ready() -> void:
	# The editor's embedded game window rejects fullscreen and logs an error.
	if not OS.has_feature("editor"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	randomize()
	_ensure_input_actions()
	_load_art_assets()
	_build_audio_players()
	_build_hud()
	_reset_static_layout()
	_setup_visual_nodes()
	if "--autostart-run" in OS.get_cmdline_user_args():
		call_deferred("_start_new_game")
	_refresh_hud()


func _input(event: InputEvent) -> void:
	if escape_confirm_open:
		if event is InputEventKey:
			var confirm_key_event: InputEventKey = event
			if confirm_key_event.pressed and not confirm_key_event.echo:
				if confirm_key_event.keycode == KEY_Y or confirm_key_event.keycode == KEY_ENTER or confirm_key_event.keycode == KEY_KP_ENTER:
					_accept_escape_confirm()
					get_viewport().set_input_as_handled()
					return
				if confirm_key_event.keycode == KEY_N or confirm_key_event.keycode == KEY_ESCAPE:
					_close_escape_confirm()
					get_viewport().set_input_as_handled()
					return
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		if event is InputEventKey:
			var gameplay_key_event: InputEventKey = event
			if gameplay_key_event.pressed and not gameplay_key_event.echo and gameplay_key_event.keycode == KEY_ESCAPE:
				if inventory_menu_open:
					inventory_menu_open = false
				elif build_menu_open:
					build_menu_open = false
				elif dealer_menu_open:
					dealer_menu_open = false
				elif inside_house:
					_open_escape_confirm("leave_house", "Leave The House?", "Step back outside and return to the yard?")
				elif inside_cave:
					_open_escape_confirm("leave_cave", "Leave The Cave?", "Go back to the forest entrance?")
				else:
					_open_escape_confirm("main_menu", "Return To Menu?", "Leave this run and go back to the main menu?")
				_refresh_hud()
				queue_redraw()
				get_viewport().set_input_as_handled()
				return
	if dealer_menu_open and not inside_house and not inside_cave:
		if event is InputEventMouseButton:
			var dealer_mouse_event: InputEventMouseButton = event
			if dealer_mouse_event.pressed and dealer_mouse_event.button_index == MOUSE_BUTTON_LEFT:
				var clicked_dealer_page: String = _dealer_page_at_position(dealer_mouse_event.position)
				if clicked_dealer_page != "":
					dealer_page = clicked_dealer_page
					get_viewport().set_input_as_handled()
					return
				var clicked_dealer_item: String = _dealer_item_at_position(dealer_mouse_event.position)
				if clicked_dealer_item != "":
					_purchase_dealer_item(clicked_dealer_item)
					get_viewport().set_input_as_handled()
					return
	if build_menu_open and phase == Phase.BUILD and not inside_house and not inside_cave:
		if event is InputEventMouseButton:
			var build_mouse_event: InputEventMouseButton = event
			if build_mouse_event.pressed and build_mouse_event.button_index == MOUSE_BUTTON_LEFT:
				var clicked_weapon: String = _build_menu_weapon_at_position(build_mouse_event.position)
				if clicked_weapon != "":
					selected_sentry_kind = clicked_weapon
					_try_place_selected_sentry()
					get_viewport().set_input_as_handled()
					return
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	if dev_mode_prompt_open:
		if event is InputEventKey:
			var key_event: InputEventKey = event
			if key_event.pressed and not key_event.echo and key_event.keycode == KEY_ESCAPE:
				_close_dev_mode_prompt()
				get_viewport().set_input_as_handled()
				return
		return
	if _is_menu_start_event(event):
		_start_new_game()
		get_viewport().set_input_as_handled()


func _return_to_main_menu() -> void:
	highest_round = max(highest_round, round_number)
	phase = Phase.MENU
	build_menu_open = false
	dealer_menu_open = false
	dev_mode_prompt_open = false
	inside_house = false
	inside_cave = false
	_sync_visual_nodes()
	_refresh_hud()
	queue_redraw()


func _open_escape_confirm(action: String, title: String, body: String) -> void:
	escape_confirm_open = true
	escape_confirm_action = action
	escape_confirm_title = title
	escape_confirm_body = body


func _close_escape_confirm() -> void:
	escape_confirm_open = false
	escape_confirm_action = ""
	escape_confirm_title = ""
	escape_confirm_body = ""
	_refresh_hud()
	queue_redraw()


func _accept_escape_confirm() -> void:
	var action: String = escape_confirm_action
	_close_escape_confirm()
	match action:
		"leave_house":
			_leave_house()
		"leave_cave":
			_leave_cave()
		"main_menu":
			_return_to_main_menu()


func _update_menu_music(delta: float) -> void:
	var should_play_menu_music: bool = phase == Phase.MENU
	if should_play_menu_music:
		if menu_music_player != null and menu_music_stream != null and not menu_music_player.playing:
			menu_music_player.stream = menu_music_stream
			menu_music_player.volume_db = MENU_MUSIC_VOLUME_DB
			menu_music_player.play(MENU_MUSIC_START_TIME)
	else:
		if menu_music_player != null and menu_music_player.playing:
			menu_music_player.stop()
		menu_music_visual_pulse = max(menu_music_visual_pulse - delta * 3.0, 0.0)
		menu_music_energy_smooth = 0.0
	if should_play_menu_music and menu_music_player != null and menu_music_player.playing:
		_sample_menu_music_pulse(delta)
	_update_music_credit_panel()


func _current_cave_music_segment_id() -> String:
	match cave_room_id:
		"entrance":
			return "room_1"
		"ruin_hub":
			return "room_2"
		"mine_crossroads", "fountain_room":
			return "room_3"
		"lava_forge", "crystal_boss":
			return "room_4"
		_:
			return "room_1"


func _cave_music_segment_bounds(segment_id: String) -> Vector2:
	match segment_id:
		"room_2":
			return Vector2(CAVE_MUSIC_ROOM_2_START, CAVE_MUSIC_ROOM_2_END)
		"room_3":
			return Vector2(CAVE_MUSIC_ROOM_3_START, CAVE_MUSIC_ROOM_3_END)
		"room_4":
			return Vector2(CAVE_MUSIC_ROOM_4_START, CAVE_MUSIC_ROOM_4_END)
		_:
			return Vector2(CAVE_MUSIC_ROOM_1_START, CAVE_MUSIC_ROOM_1_END)


func _should_play_boss_music() -> bool:
	return inside_cave and (phase == Phase.BUILD or phase == Phase.DEFEND) and cave_room_id == "crystal_boss" and _is_boss_encounter_locked()


func _update_cave_music() -> void:
	var should_play_cave_music: bool = inside_cave and (phase == Phase.BUILD or phase == Phase.DEFEND)
	var should_play_boss: bool = _should_play_boss_music()
	if should_play_boss:
		if cave_music_player != null and cave_music_player.playing:
			cave_music_player.stop()
		if boss_music_player != null and boss_music_stream != null:
			if boss_music_player.stream != boss_music_stream:
				boss_music_player.stream = boss_music_stream
			if not boss_music_player.playing:
				boss_music_player.volume_db = BOSS_MUSIC_VOLUME_DB
				boss_music_player.play(BOSS_MUSIC_START_TIME)
		_update_music_credit_panel()
		return
	if boss_music_player != null and boss_music_player.playing:
		boss_music_player.stop()
	if not should_play_cave_music or cave_music_player == null or cave_music_stream == null:
		if cave_music_player != null and cave_music_player.playing:
			cave_music_player.stop()
		current_cave_music_segment_id = ""
		_update_music_credit_panel()
		return
	var segment_id: String = _current_cave_music_segment_id()
	var segment_bounds: Vector2 = _cave_music_segment_bounds(segment_id)
	var loop_start: float = segment_bounds.x
	var loop_end: float = segment_bounds.y
	if cave_music_player.stream != cave_music_stream:
		cave_music_player.stream = cave_music_stream
	if not cave_music_player.playing or current_cave_music_segment_id != segment_id:
		cave_music_player.volume_db = CAVE_MUSIC_VOLUME_DB
		cave_music_player.play(loop_start)
		current_cave_music_segment_id = segment_id
		_update_music_credit_panel()
		return
	if cave_music_player.get_playback_position() >= loop_end:
		cave_music_player.play(loop_start)
	_update_music_credit_panel()


func _update_music_credit_panel() -> void:
	if music_credit_panel == null:
		return
	var show_credit: bool = phase == Phase.MENU or (inside_cave and cave_music_player != null and cave_music_player.playing) or (inside_cave and boss_music_player != null and boss_music_player.playing)
	music_credit_panel.visible = show_credit
	if not show_credit:
		return
	if phase == Phase.MENU:
		music_credit_title_label.text = "Now Playing: I miss you"
		music_credit_body_label.text = "Music by sovieticoofficial"
	elif inside_cave and boss_music_player != null and boss_music_player.playing:
		music_credit_title_label.text = "Now Playing: a breakcore song"
		music_credit_body_label.text = "Music by sovieticoofficial"
	elif inside_cave:
		music_credit_title_label.text = "Now Playing: Betrayal"
		music_credit_body_label.text = "Music by sovieticoofficial"
	music_credit_panel.color = Color(0.04, 0.06, 0.08, 0.88)
	music_credit_title_label.modulate = Color(0.98, 0.94, 0.82, 1.0)
	music_credit_body_label.modulate = Color(0.84, 0.88, 0.92, 1.0)


func _menu_music_playback_position() -> float:
	if menu_music_player == null or not menu_music_player.playing:
		return MENU_MUSIC_START_TIME
	return max(menu_music_player.get_playback_position(), MENU_MUSIC_START_TIME)


func _sample_menu_music_pulse(delta: float) -> void:
	if menu_music_bus_index < 0:
		menu_music_visual_pulse = max(menu_music_visual_pulse - delta * 3.0, 0.0)
		return
	var analyzer := AudioServer.get_bus_effect_instance(menu_music_bus_index, menu_music_spectrum_effect_index) as AudioEffectSpectrumAnalyzerInstance
	if analyzer == null:
		menu_music_visual_pulse = max(menu_music_visual_pulse - delta * 3.0, 0.0)
		return
	var bass: Vector2 = analyzer.get_magnitude_for_frequency_range(36.0, 140.0)
	var mids: Vector2 = analyzer.get_magnitude_for_frequency_range(140.0, 1100.0)
	var bass_energy: float = max((bass.x + bass.y) * 0.5, 0.0)
	var mid_energy: float = max((mids.x + mids.y) * 0.5, 0.0)
	var combined_energy: float = bass_energy * 1.5 + mid_energy * 0.65
	var previous_smooth: float = menu_music_energy_smooth
	menu_music_energy_smooth = lerpf(menu_music_energy_smooth, combined_energy, min(delta * 5.0, 1.0))
	var transient: float = max(combined_energy - previous_smooth, 0.0)
	var target_pulse: float = clampf(transient * 10.0, 0.0, 1.0)
	menu_music_visual_pulse = max(target_pulse, max(menu_music_visual_pulse - delta * 2.8, 0.0))


func _leave_house() -> void:
	inside_house = false
	player_position = _house_door_rect().position + Vector2(-PLAYER_SIZE.x * 0.5 + 10.0, 8.0)
	_refresh_hud()
	queue_redraw()


func _process(delta: float) -> void:
	world_time += delta
	_update_menu_music(delta)
	_update_cave_music()
	if phase == Phase.MENU:
		_sync_visual_nodes()
		if dev_mode_prompt_open:
			_refresh_hud()
			queue_redraw()
			return
		if _menu_start_pressed():
			_start_new_game()
		_refresh_hud()
		queue_redraw()
		return

	if phase == Phase.GAME_OVER:
		_sync_visual_nodes()
		if dev_mode_prompt_open:
			_refresh_hud()
			queue_redraw()
			return
		if _menu_start_pressed():
			_start_new_game()
		_refresh_hud()
		queue_redraw()
		return

	if escape_confirm_open:
		_sync_visual_nodes()
		_refresh_hud()
		queue_redraw()
		return

	_sanitize_location_state()
	if inside_house:
		inside_house = false

	run_start_input_lock_timer = max(run_start_input_lock_timer - delta, 0.0)

	_update_house_toggle()
	_move_player(delta)
	_update_selected_cell()
	_update_player_combat_state(delta)
	_update_gathering(delta)
	_update_gather_effects(delta)
	_update_explosion_effects(delta)
	_update_forest_animals(delta)

	if phase == Phase.BUILD:
		_update_build_phase(delta)
	else:
		_update_defend_phase(delta)

	_update_camera()
	_sync_visual_nodes()
	_refresh_hud()
	queue_redraw()


func _sanitize_location_state() -> void:
	if inside_house:
		inside_house = false
	if inside_cave and not cave_mode_token:
		inside_cave = false
	if cave_mode_token and not inside_cave:
		cave_mode_token = false
	if inside_cave and not _is_player_near_cave_entrance() and cave_transition_cooldown <= 0.0:
		inside_cave = false
		cave_mode_token = false
		cave_transition_cooldown = 0.0
		cave_room_id = "entrance"


func _setup_visual_nodes() -> void:
	if player_visual_node == null:
		player_visual_node = PLAYER_VISUAL_SCENE.instantiate()
		visual_layer.add_child(player_visual_node)
		player_visual_sprite = player_visual_node.get_node("Body")
	if dealer_visual_node == null:
		dealer_visual_node = DEALER_VISUAL_SCENE.instantiate()
		visual_layer.add_child(dealer_visual_node)
		dealer_visual_sprite = dealer_visual_node.get_node("Dealer")
	_configure_sprite_region(player_visual_sprite, player_body_texture, PLAYER_BODY_REGION, PLAYER_DRAW_SIZE, PLAYER_DRAW_OFFSET, false)
	_configure_sprite_region(dealer_visual_sprite, arms_dealer_texture, ARMS_DEALER_REGION, ARMS_DEALER_DRAW_SIZE, Vector2(-6, -72), false)
	_sync_visual_nodes()


func _sync_visual_nodes() -> void:
	if inside_house:
		inside_house = false
	if visual_layer != null:
		visual_layer.visible = not (phase == Phase.MENU or phase == Phase.GAME_OVER or dealer_menu_open or inside_house)
	_sync_player_visual()
	_sync_dealer_visual()
	_sync_turret_visuals()
	_sync_enemy_visuals()


func _sync_player_visual() -> void:
	if player_visual_node == null or player_visual_sprite == null:
		return
	var visible_world: bool = (phase == Phase.BUILD or phase == Phase.DEFEND) and not dealer_menu_open and not inside_house
	player_visual_node.visible = visible_world
	if not visible_world:
		return
	if inside_cave:
		player_visual_node.position = cave_player_position
	elif inside_house:
		player_visual_node.position = interior_player_position
	else:
		player_visual_node.position = player_position - camera_position
	var move_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var run_texture: Texture2D = _current_player_run_texture() if move_input.length() > 0.12 else null
	if move_input.x < -0.05:
		player_visual_sprite.flip_h = true
	elif move_input.x > 0.05:
		player_visual_sprite.flip_h = false
	if run_texture != null:
		_configure_sprite_region(player_visual_sprite, run_texture, PLAYER_RUN_REGION, PLAYER_RUN_DRAW_SIZE, PLAYER_RUN_DRAW_OFFSET, false)
	else:
		_configure_sprite_region(player_visual_sprite, player_body_texture, PLAYER_BODY_REGION, PLAYER_DRAW_SIZE, PLAYER_DRAW_OFFSET, false)


func _sync_dealer_visual() -> void:
	if dealer_visual_node == null or dealer_visual_sprite == null:
		return
	var visible_world: bool = (phase == Phase.BUILD or phase == Phase.DEFEND) and not inside_house and not inside_cave and not dealer_menu_open
	dealer_visual_node.visible = visible_world
	if not visible_world:
		return
	var stand_rect: Rect2 = _dealer_stand_rect()
	dealer_visual_node.position = stand_rect.position - camera_position
	_configure_sprite_region(dealer_visual_sprite, arms_dealer_texture, ARMS_DEALER_REGION, ARMS_DEALER_DRAW_SIZE, Vector2(-6, -72 + sin(world_time * 2.2 + stand_rect.position.x * 0.03) * 3.0), false)


func _sync_turret_visuals() -> void:
	var world_visible: bool = (phase == Phase.BUILD or phase == Phase.DEFEND) and not inside_house and not inside_cave and not dealer_menu_open
	var seen_keys := {}
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if int(structure.get("type", StructureType.NONE)) != StructureType.TURRET:
			continue
		if float(structure.get("build_time", 0.0)) > 0.0:
			continue
		seen_keys[structure_key] = true
		var turret_visual: Node2D = turret_visual_nodes.get(structure_key)
		if turret_visual == null:
			turret_visual = TURRET_VISUAL_SCENE.instantiate()
			turret_visual_container.add_child(turret_visual)
			turret_visual_nodes[structure_key] = turret_visual
		turret_visual.visible = world_visible
		turret_visual.position = _cell_center(Vector2i(structure["cell"])) - camera_position
		_sync_single_turret_visual(turret_visual, structure)
	var stale_turret_keys: Array = turret_visual_nodes.keys()
	for stale_key in stale_turret_keys:
		if seen_keys.has(stale_key):
			continue
		var stale_visual: Node = turret_visual_nodes[stale_key]
		if is_instance_valid(stale_visual):
			stale_visual.queue_free()
		turret_visual_nodes.erase(stale_key)


func _sync_single_turret_visual(turret_visual: Node2D, structure: Dictionary) -> void:
	var body_sprite: Sprite2D = turret_visual.get_node("Body")
	var flash: bool = float(structure.get("flash_timer", 0.0)) > 0.0
	var aim_direction: Vector2 = Vector2(structure.get("aim_direction", Vector2.RIGHT))
	if aim_direction == Vector2.ZERO:
		aim_direction = Vector2.RIGHT
	var aim_angle: float = aim_direction.angle()
	var reload_progress: float = _turret_reload_progress(structure)
	var recoil_offset: Vector2 = -aim_direction * (1.0 - reload_progress) * 4.0
	body_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	body_sprite.flip_h = false
	var weapon: String = String(structure.get("weapon", "arrow"))
	match weapon:
		"cannon":
			var cannon_facing_left: bool = aim_direction.x < -0.08
			var cannon_recoil := Vector2(4.0 if cannon_facing_left else -4.0, 0.0) * (1.0 - reload_progress)
			_configure_sprite_region(body_sprite, cannon_turret_texture, CANNON_TURRET_REGION, CANNON_TURRET_DRAW_SIZE, Vector2(0, -10), true)
			body_sprite.position += cannon_recoil
			body_sprite.rotation = 0.0
			body_sprite.flip_h = cannon_facing_left
		"gun":
			if gun_turret_texture != null:
				_configure_sprite(body_sprite, gun_turret_texture, Vector2(98, 98), Vector2(0, -4), true)
			elif irs_agent_gun_texture != null:
				_configure_sprite(body_sprite, irs_agent_gun_texture, Vector2(56, 24), Vector2(0, 4), true)
			else:
				_configure_sprite_region(body_sprite, turret_sprite_texture, TURRET_LOADED_REGION, Vector2(60, 34), Vector2.ZERO, true)
			body_sprite.position += recoil_offset
			body_sprite.rotation = aim_angle
		"magic":
			_configure_sprite(body_sprite, crystal_sentry_texture, MAGIC_TURRET_DRAW_SIZE, Vector2(0, -MAGIC_TURRET_DRAW_SIZE.y * 0.18), true)
			body_sprite.position += recoil_offset + Vector2(0, sin(world_time * 3.0 + turret_visual.position.x * 0.02) * 2.0)
			body_sprite.rotation = aim_angle
		"golden":
			var golden_facing_left: bool = aim_direction.x < -0.08
			var golden_recoil := Vector2(4.0 if golden_facing_left else -4.0, 0.0) * (1.0 - reload_progress)
			_configure_sprite_region(body_sprite, golden_turret_texture, GOLDEN_TURRET_REGION, GOLDEN_TURRET_DRAW_SIZE, Vector2(0, -8), true)
			body_sprite.position += golden_recoil
			body_sprite.rotation = 0.0
			body_sprite.flip_h = golden_facing_left
		_:
			var loaded_frame: Rect2 = TURRET_LOADED_REGION if bool(structure.get("has_target", false)) and reload_progress >= 0.72 else TURRET_IDLE_REGION
			_configure_sprite_region(body_sprite, turret_sprite_texture, loaded_frame, Vector2(68, 40), Vector2.ZERO, true)
			body_sprite.position += recoil_offset
			body_sprite.rotation = aim_angle
	if flash:
		body_sprite.modulate = Color(1.0, 1.0, 1.0, 0.88)


func _sync_enemy_visuals() -> void:
	var world_visible: bool = (phase == Phase.DEFEND or phase == Phase.BUILD) and not inside_house and not inside_cave and not dealer_menu_open
	var seen_enemy_ids := {}
	for enemy in enemies:
		var enemy_id: int = int(enemy.get("id", -1))
		seen_enemy_ids[enemy_id] = true
		var enemy_visual: Node2D = enemy_visual_nodes.get(enemy_id)
		if enemy_visual == null:
			enemy_visual = ENEMY_VISUAL_SCENE.instantiate()
			enemy_visual_container.add_child(enemy_visual)
			enemy_visual_nodes[enemy_id] = enemy_visual
		enemy_visual.visible = world_visible
		enemy_visual.position = _enemy_center(enemy) - camera_position
		_sync_single_enemy_visual(enemy_visual, enemy)
	var stale_enemy_ids: Array = enemy_visual_nodes.keys()
	for stale_enemy_id in stale_enemy_ids:
		if seen_enemy_ids.has(stale_enemy_id):
			continue
		var stale_enemy_visual: Node = enemy_visual_nodes[stale_enemy_id]
		if is_instance_valid(stale_enemy_visual):
			stale_enemy_visual.queue_free()
		enemy_visual_nodes.erase(stale_enemy_id)


func _sync_single_enemy_visual(enemy_visual: Node2D, enemy: Dictionary) -> void:
	var body_sprite: Sprite2D = enemy_visual.get_node("Body")
	var gun_sprite: Sprite2D = enemy_visual.get_node("Gun")
	var enemy_type: String = String(enemy.get("type", "runner"))
	var flash: bool = float(enemy.get("flash_timer", 0.0)) > 0.0
	body_sprite.modulate = Color.WHITE
	gun_sprite.modulate = Color.WHITE
	if enemy_type == "runner":
		var lane_sign: float = -1.0 if String(enemy.get("lane", "left")) == "left" else 1.0
		var run_texture: Texture2D = _current_runner_texture()
		if run_texture != null:
			_configure_sprite(body_sprite, run_texture, IRS_AGENT_DRAW_SIZE, Vector2(0, -8), true)
			body_sprite.flip_h = lane_sign < 0.0
			gun_sprite.visible = false
		else:
			_configure_sprite_region(body_sprite, irs_agent_body_texture, IRS_AGENT_BODY_REGION, IRS_AGENT_DRAW_SIZE, Vector2(0, -8), true)
			body_sprite.flip_h = lane_sign < 0.0
			_configure_sprite_region(gun_sprite, irs_agent_gun_texture, IRS_AGENT_GUN_REGION, IRS_AGENT_GUN_DRAW_SIZE, Vector2(4.0 * lane_sign, 18.0), true)
			gun_sprite.rotation = 0.18 * lane_sign
	elif enemy_type == "swat":
		_configure_sprite(body_sprite, swat_texture, SWAT_DRAW_SIZE, Vector2(0, -8 + sin(world_time * 8.0 + enemy_visual.position.x * 0.03) * 2.5), true)
		body_sprite.flip_h = String(enemy.get("lane", "left")) == "left"
		body_sprite.rotation = 0.0
		gun_sprite.visible = false
	else:
		var robot_size: Vector2 = IRS_BRUTE_DRAW_SIZE if enemy_type == "brute" else IRS_ROBOT_DRAW_SIZE
		_configure_sprite(body_sprite, _current_robot_walk_texture(), robot_size, Vector2.ZERO, true)
		body_sprite.flip_h = false
		body_sprite.rotation = 0.0
		gun_sprite.visible = false
	if flash:
		body_sprite.modulate = Color(1.0, 1.0, 1.0, 0.88)
		gun_sprite.modulate = Color(1.0, 1.0, 1.0, 0.88)


func _configure_sprite(sprite: Sprite2D, texture: Texture2D, draw_size: Vector2, sprite_position: Vector2, centered: bool) -> void:
	_configure_sprite_region(sprite, texture, Rect2(), draw_size, sprite_position, centered)


func _configure_sprite_region(sprite: Sprite2D, texture: Texture2D, region: Rect2, draw_size: Vector2, sprite_position: Vector2, centered: bool) -> void:
	if sprite == null:
		return
	if texture == null:
		sprite.visible = false
		return
	sprite.visible = true
	sprite.texture = texture
	sprite.centered = centered
	sprite.position = sprite_position
	var use_region: bool = region.size.x > 0.0 and region.size.y > 0.0
	sprite.region_enabled = use_region
	if use_region:
		sprite.region_rect = region
	var source_size: Vector2 = region.size if use_region else texture.get_size()
	source_size.x = max(source_size.x, 1.0)
	source_size.y = max(source_size.y, 1.0)
	sprite.scale = Vector2(draw_size.x / source_size.x, draw_size.y / source_size.y)


func _menu_start_pressed() -> bool:
	return (
		Input.is_action_just_pressed("action")
		or Input.is_action_just_pressed("restart")
		or Input.is_action_just_pressed("start_wave_early")
	)


func _is_menu_start_event(event: InputEvent) -> bool:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if not key_event.pressed or key_event.echo:
			return false
		return key_event.keycode == KEY_SPACE or key_event.keycode == KEY_ENTER or key_event.keycode == KEY_KP_ENTER or key_event.keycode == KEY_R
	return false


func _on_menu_start_pressed() -> void:
	if phase == Phase.MENU or phase == Phase.GAME_OVER:
		_start_new_game()


func _on_menu_dev_pressed() -> void:
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	if dev_mode_enabled:
		dev_mode_enabled = false
		dev_mode_prompt_open = false
		_close_dev_mode_prompt()
		return
	dev_mode_prompt_open = true
	menu_dev_pin_input.text = ""
	menu_dev_status_label.text = "Enter PIN"
	menu_dev_pin_input.grab_focus()


func _on_menu_dev_unlock_pressed() -> void:
	if menu_dev_pin_input.text == DEV_MODE_PIN:
		dev_mode_enabled = true
		dev_mode_prompt_open = false
		menu_dev_status_label.text = "Dev mode unlocked"
	else:
		menu_dev_status_label.text = "Wrong PIN"
		menu_dev_pin_input.text = ""
		menu_dev_pin_input.grab_focus()


func _close_dev_mode_prompt() -> void:
	dev_mode_prompt_open = false
	if menu_dev_pin_input != null:
		menu_dev_pin_input.text = ""
	if menu_dev_status_label != null:
		menu_dev_status_label.text = "Enter PIN"


func _apply_dev_mode_start_state() -> void:
	wood = 999
	stone = 999
	iron = 999
	gold = 999
	gunpowder = 999
	cave_crystals_owned = 99
	turret_ammo = 999
	cannon_shells = 999
	gun_sentry_unlocked = true
	magic_sentry_unlocked = true
	golden_sentry_unlocked = true
	rifle_sentry_unlocked = false
	shield_unlocked = true
	dodge_unlocked = false
	turret_damage_bonus = 4
	cave_pickups_claimed["carry_upgrade"] = true
	cave_pickups_claimed["hp_1"] = true
	cave_pickups_claimed["move_upgrade"] = true
	cave_pickups_claimed["gather_upgrade"] = true
	cave_pickups_claimed["sword_upgrade"] = true
	player_hp = PLAYER_MAX_HP + _extra_player_max_hp()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), BG_COLOR, true)
	if phase == Phase.MENU and menu_background_texture != null:
		_draw_menu_background(true)
	elif phase == Phase.GAME_OVER:
		_draw_game_over_background()
	if phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	_draw_ground_area(Rect2(GRID_ORIGIN, Vector2(GRID_SIZE.x, FOREST_START_ROW) * CELL_SIZE), GRASS_COLOR)
	var forest_top := _cell_to_world(Vector2i(0, FOREST_START_ROW))
	var forest_bottom_y: float = max(forest_top.y + SCREEN_SIZE.y + CELL_SIZE * 2.0, camera_position.y + SCREEN_SIZE.y + CELL_SIZE * 2.0)
	_draw_ground_area(Rect2(forest_top, Vector2(GRID_SIZE.x * CELL_SIZE, forest_bottom_y - forest_top.y)), WOODS_COLOR)
	_draw_waving_grass()
	_draw_house()
	_draw_dealer_stand()
	_draw_grid()
	_draw_resources()
	_draw_forest_animals()
	_draw_trees()
	_draw_structures()
	_draw_enemies()
	_draw_enemy_shots()
	_draw_projectiles()
	_draw_explosion_effects()
	_draw_player()
	_draw_selection()
	_draw_world_callouts()
	_draw_side_spawn_warnings()
	_draw_gather_effects()
	_draw_wave_banner()
	_draw_inventory_full_warning()
	_draw_house_prompt()
	_draw_dealer_prompt()
	_draw_cave_prompt()
	_draw_house_interior()
	_draw_cave_interior()
	_draw_danger_overlay()
	_draw_dealer_menu()
	_draw_build_menu()
	_draw_hit_effects()
	_draw_countdown_display()


func _draw_menu_background(react_to_music: bool) -> void:
	var draw_rect: Rect2 = Rect2(Vector2.ZERO, SCREEN_SIZE)
	var overlay_alpha: float = 0.18
	if react_to_music:
		var beat_pulse: float = menu_music_visual_pulse
		var zoom_scale: float = 1.0 + beat_pulse * MENU_BACKGROUND_BEAT_ZOOM
		var scaled_size: Vector2 = SCREEN_SIZE * zoom_scale
		draw_rect = Rect2((SCREEN_SIZE - scaled_size) * 0.5, scaled_size)
		overlay_alpha = 0.16 + beat_pulse * 0.12
	draw_texture_rect_region(menu_background_texture, draw_rect, MENU_BACKGROUND_REGION)
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.02, 0.04, 0.06, overlay_alpha), true)


func _draw_game_over_background() -> void:
	if loss_screen_texture != null:
		draw_texture_rect(loss_screen_texture, Rect2(Vector2.ZERO, SCREEN_SIZE), false)
		draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.02, 0.03, 0.04, 0.34), true)
		return
	if menu_background_texture != null:
		_draw_menu_background(false)


func _start_new_game() -> void:
	round_number = 1
	wood = 0
	stone = 0
	iron = 0
	gold = 0
	gunpowder = 0
	cave_crystals_owned = 0
	player_hp = PLAYER_MAX_HP
	player_position = _cell_to_world(PLAYER_START_CELL) + Vector2(11, 11)
	selected_cell = PLAYER_START_CELL
	camera_position = Vector2.ZERO
	world_time = 0.0
	inside_house = false
	inside_cave = false
	cave_mode_token = false
	cave_transition_cooldown = 0.0
	interior_player_position = _house_interior_spawn_position()
	cave_player_position = _cave_spawn_position()
	trophy_stolen = false
	house_items.clear()
	house_items.append_array(HOUSE_START_ITEMS)
	stolen_house_items.clear()
	house_damage_stage = 0
	cave_boss_defeated = false
	turret_ammo = 18
	cannon_shells = 6
	owned_guns["sidearm"] = false
	owned_guns["rifle"] = false
	gun_cooldowns["sidearm"] = 0.0
	gun_cooldowns["rifle"] = 0.0
	player_aim_direction = Vector2.RIGHT
	player_attack_cooldown = 0.0
	player_swing_timer = 0.0
	player_swing_direction = Vector2.RIGHT
	house_flash_timer = 0.0
	wave_banner_timer = 0.0
	wave_banner_text = ""
	run_start_input_lock_timer = 0.25
	build_menu_open = false
	selected_sentry_kind = "arrow"
	dealer_menu_open = false
	dealer_page = "buy"
	dealer_status_text = "The arms dealer trades in dollars."
	gun_sentry_unlocked = false
	magic_sentry_unlocked = false
	golden_sentry_unlocked = false
	rifle_sentry_unlocked = false
	shield_unlocked = false
	dodge_unlocked = false
	turret_damage_bonus = 0
	gun_damage_bonus = 0
	cave_player_hit_cooldown = 0.0
	dodge_cooldown = 0.0
	dodge_timer = 0.0
	parry_cooldown = 0.0
	parry_timer = 0.0
	cave_room_id = "entrance"
	cave_keys = 0
	tutorial_got_wood = false
	tutorial_got_stone = false
	tutorial_built_once = false
	tutorial_opened_dealer = false
	tutorial_entered_cave = false
	tutorial_repaired_house = false
	cave_cycle_index = 0
	cave_rooms.clear()
	cave_seen_rooms.clear()
	cave_room_enemy_defeated.clear()
	cave_switch_states.clear()
	cave_shortcuts_unlocked.clear()
	cave_pickups_claimed.clear()
	if dev_mode_enabled:
		_apply_dev_mode_start_state()
	cave_secret_revealed.clear()
	structures.clear()
	enemies.clear()
	enemy_corpses.clear()
	projectiles.clear()
	forest_tree_cells.clear()
	forest_animals.clear()
	generated_forest_chunk_count = 0
	resource_nodes.clear()
	cave_nodes.clear()
	cave_enemies.clear()
	cave_enemy_corpses.clear()
	cave_crystals.clear()
	cave_boss_rock_markers.clear()
	cave_falling_rocks.clear()
	cave_rock_rubble.clear()
	cave_boss_intro_seen = false
	cave_boss_last_stand_triggered = false
	spawn_queue.clear()
	gather_effects.clear()
	hit_effects.clear()
	enemy_shots.clear()
	explosion_effects.clear()
	defend_elapsed = 0.0
	enemy_spawn_index = 0
	next_enemy_id = 1
	harvest_timer = 0.0
	harvesting_node_index = -1
	inventory_full_timer = 0.0
	inventory_menu_open = false
	_spawn_resource_nodes()
	_setup_cave()
	_start_build_phase()


func _update_house_toggle() -> void:
	if _cave_active():
		if Input.is_action_just_pressed("dealer_menu"):
			dealer_menu_open = false
		if Input.is_action_just_pressed("enter_cave") and _is_player_near_cave_exit():
			_leave_cave()
		elif Input.is_action_just_pressed("enter_cave") and _is_boss_encounter_locked():
			_show_wave_banner_for("Arena Sealed\nBeat The Broodmother", 1.1)
		return
	if inside_house:
		inside_house = false
		return
	if run_start_input_lock_timer > 0.0:
		return
	if build_menu_open:
		return
	if Input.is_action_just_pressed("dealer_menu") and _is_player_near_dealer_stand():
		dealer_menu_open = not dealer_menu_open
		if dealer_menu_open:
			build_menu_open = false
			dealer_page = "buy"
			tutorial_opened_dealer = true
		return
	if not Input.is_action_just_pressed("enter_cave"):
		return
	if _is_player_near_cave_entrance() and (phase == Phase.BUILD or phase == Phase.DEFEND):
		dealer_menu_open = false
		tutorial_entered_cave = true
		_enter_cave()


func _reset_static_layout() -> void:
	build_cells.clear()
	build_cells.append_array(LEFT_BUILD_YARD)
	build_cells.append_array(RIGHT_BUILD_YARD)
	path_lookup.clear()


func _spawn_resource_nodes() -> void:
	for node_data in STONE_RESOURCE_NODES:
		resource_nodes.append(_make_resource_node(Vector2i(node_data["cell"]), String(node_data["kind"])))
	_ensure_forest_generated_for_player()


func _setup_cave() -> void:
	cave_rooms = {
		"entrance": {
			"zone": 0, "name": "Moss Mouth", "neighbors": {"right": "ruin_hub"}, "shortcuts": {}, "lock": "",
			"nodes": [
				{"position": Vector2(334, 334), "kind": "iron", "remaining": IRON_NODE_STARTS, "capacity": IRON_NODE_STARTS},
				{"position": Vector2(540, 246), "kind": "iron", "remaining": IRON_NODE_STARTS, "capacity": IRON_NODE_STARTS}
			],
			"enemies": [
				{"position": Vector2(730, 248), "size": Vector2(30, 30), "hp": 4, "max_hp": 4, "speed": 76.0, "flash_timer": 0.0},
				{"position": Vector2(816, 356), "size": Vector2(28, 28), "hp": 4, "max_hp": 4, "speed": 80.0, "flash_timer": 0.0}
			],
			"pickups": [], "fountain": false, "switch_id": "", "secret": false, "boss": false, "crystals": []
		},
		"ruin_hub": {
			"zone": 1, "name": "Old Ruins", "neighbors": {"left": "entrance", "right": "mine_crossroads"}, "shortcuts": {}, "lock": "",
			"nodes": [
				{"position": Vector2(350, 214), "kind": "iron", "remaining": IRON_NODE_STARTS + 1, "capacity": IRON_NODE_STARTS + 1},
				{"position": Vector2(528, 356), "kind": "gold", "remaining": 3, "capacity": 3}
			],
			"enemies": [
				{"position": Vector2(708, 198), "size": Vector2(32, 32), "hp": 5, "max_hp": 5, "speed": 86.0, "flash_timer": 0.0},
				{"position": Vector2(844, 368), "size": Vector2(34, 34), "hp": 6, "max_hp": 6, "speed": 82.0, "flash_timer": 0.0}
			],
			"pickups": [
				{"id": "hp_1", "position": Vector2(892, 170), "type": "upgrade_hp"},
				{"id": "parry_unlock", "position": Vector2(888, 360), "type": "unlock_parry"}
			], "fountain": false, "switch_id": "", "secret": false, "boss": false, "crystals": []
		},
		"mine_crossroads": {
			"zone": 2, "name": "Mine Crossroads", "neighbors": {"left": "ruin_hub", "right": "fountain_room"}, "shortcuts": {}, "lock": "",
			"nodes": [
				{"position": Vector2(384, 214), "kind": "iron", "remaining": IRON_NODE_STARTS + 2, "capacity": IRON_NODE_STARTS + 2},
				{"position": Vector2(486, 350), "kind": "gold", "remaining": 4, "capacity": 4},
				{"position": Vector2(622, 248), "kind": "iron", "remaining": IRON_NODE_STARTS + 1, "capacity": IRON_NODE_STARTS + 1}
			],
			"enemies": [
				{"position": Vector2(708, 220), "size": Vector2(34, 34), "hp": 7, "max_hp": 7, "speed": 84.0, "flash_timer": 0.0},
				{"position": Vector2(824, 360), "size": Vector2(34, 34), "hp": 7, "max_hp": 7, "speed": 84.0, "flash_timer": 0.0},
				{"position": Vector2(896, 248), "size": Vector2(36, 36), "hp": 8, "max_hp": 8, "speed": 80.0, "flash_timer": 0.0}
			],
			"pickups": [
				{"id": "carry_upgrade", "position": Vector2(902, 168), "type": "upgrade_carry"},
				{"id": "gather_upgrade", "position": Vector2(904, 386), "type": "upgrade_gather"}
			], "fountain": false, "switch_id": "", "secret": false, "boss": false, "crystals": []
		},
		"fountain_room": {
			"zone": 2, "name": "Echo Fountain", "neighbors": {"left": "mine_crossroads", "right": "lava_forge"}, "shortcuts": {}, "lock": "",
			"nodes": [],
			"enemies": [],
			"pickups": [],
			"fountain": true, "switch_id": "", "secret": false, "boss": false, "crystals": []
		},
		"lava_forge": {
			"zone": 3, "name": "Forge Channel", "neighbors": {"left": "fountain_room", "right": "crystal_boss"}, "shortcuts": {}, "lock": "",
			"nodes": [
				{"position": Vector2(414, 238), "kind": "gunpowder", "remaining": 4, "capacity": 4},
				{"position": Vector2(540, 338), "kind": "gunpowder", "remaining": 4, "capacity": 4},
				{"position": Vector2(714, 246), "kind": "gold", "remaining": 4, "capacity": 4}
			],
			"enemies": [
				{"position": Vector2(672, 190), "size": Vector2(36, 36), "hp": 9, "max_hp": 9, "speed": 92.0, "flash_timer": 0.0},
				{"position": Vector2(830, 364), "size": Vector2(36, 36), "hp": 10, "max_hp": 10, "speed": 90.0, "flash_timer": 0.0},
				{"position": Vector2(904, 248), "size": Vector2(38, 38), "hp": 10, "max_hp": 10, "speed": 88.0, "flash_timer": 0.0}
			],
			"pickups": [
				{"id": "move_upgrade", "position": Vector2(906, 170), "type": "upgrade_speed"},
				{"id": "golden_sentry_unlock", "position": Vector2(896, 286), "type": "unlock_golden"}
			], "fountain": false, "switch_id": "", "secret": false, "boss": false, "crystals": []
		},
		"crystal_boss": {
			"zone": 4, "name": "Crystal Cave", "neighbors": {"left": "lava_forge"}, "shortcuts": {"up": "forest_shortcut_3"}, "lock": "",
			"nodes": [
				{"position": Vector2(326, 352), "kind": "gold", "remaining": 5, "capacity": 5},
				{"position": Vector2(488, 192), "kind": "gold", "remaining": 5, "capacity": 5},
				{"position": Vector2(926, 214), "kind": "gunpowder", "remaining": 5, "capacity": 5}
			],
			"enemies": [{"position": Vector2(638, 282), "size": Vector2(58, 58), "hp": CAVE_BOSS_MAX_HP, "max_hp": CAVE_BOSS_MAX_HP, "speed": 68.0, "flash_timer": 0.0, "boss": true}],
			"pickups": [{"id": "sword_upgrade", "position": Vector2(834, 392), "type": "upgrade_sword"}], "fountain": false, "switch_id": "", "secret": false, "boss": true,
			"crystals": [{"id": "crystal_1", "position": Vector2(866, 168), "claimed": false}, {"id": "crystal_2", "position": Vector2(958, 168), "claimed": false}]
		}
	}
	cave_room_id = "entrance"
	_refresh_cave_room_state()


func _enter_cave() -> void:
	if not _is_player_near_cave_entrance():
		return
	build_menu_open = false
	inside_cave = true
	cave_mode_token = true
	cave_room_id = "entrance"
	cave_seen_rooms[cave_room_id] = true
	_refresh_cave_room_state()
	cave_player_position = _cave_spawn_position()
	cave_transition_cooldown = CAVE_TRANSITION_COOLDOWN


func _leave_cave() -> void:
	inside_cave = false
	cave_mode_token = false
	player_position = _cell_to_world(CAVE_ENTRANCE_CELL) + Vector2(11, 11)
	harvesting_node_index = -1
	harvest_timer = 0.0
	cave_transition_cooldown = 0.0


func _cave_spawn_position() -> Vector2:
	var exit_rect: Rect2 = _cave_exit_rect()
	return exit_rect.position + Vector2(exit_rect.size.x * 0.5 - PLAYER_SIZE.x * 0.5, -36.0)


func _cave_panel() -> Rect2:
	return Rect2(Vector2(136, 74), Vector2(1008, 592))


func _cave_walk_bounds() -> Rect2:
	var panel: Rect2 = _cave_panel()
	return Rect2(panel.position + Vector2(38, 72), Vector2(932, 448))


func _current_cave_room() -> Dictionary:
	return cave_rooms.get(cave_room_id, {})


func _cave_room_name(room_id: String) -> String:
	if room_id == "":
		return ""
	var room: Dictionary = cave_rooms.get(room_id, {})
	return String(room.get("name", room_id))


func _refresh_cave_room_state() -> void:
	var room: Dictionary = _current_cave_room()
	cave_nodes.clear()
	cave_enemies.clear()
	cave_enemy_corpses.clear()
	cave_crystals.clear()
	cave_boss_rock_markers.clear()
	cave_falling_rocks.clear()
	cave_rock_rubble.clear()
	if room.is_empty():
		return
	for node in Array(room.get("nodes", [])):
		cave_nodes.append(Dictionary(node).duplicate(true))
	var defeated_enemy_indices: Dictionary = Dictionary(cave_room_enemy_defeated.get(cave_room_id, {}))
	var room_enemy_index: int = 0
	for enemy in Array(room.get("enemies", [])):
		if bool(defeated_enemy_indices.get(room_enemy_index, false)):
			room_enemy_index += 1
			continue
		var cave_enemy_data: Dictionary = Dictionary(enemy).duplicate(true)
		cave_enemy_data["room_enemy_index"] = room_enemy_index
		if bool(cave_enemy_data.get("boss", false)):
			if cave_boss_defeated:
				room_enemy_index += 1
				continue
			cave_enemy_data["attack_timer"] = 0.0
			cave_enemy_data["attack_cooldown"] = 1.35
			cave_enemy_data["attack_hit_done"] = false
			cave_enemy_data["phase_one"] = false
			cave_enemy_data["phase_two"] = false
			cave_enemy_data["slam_timer"] = 0.0
			cave_enemy_data["slam_cooldown"] = 1.70
			cave_enemy_data["stun_timer"] = 0.0
		cave_enemies.append(cave_enemy_data)
		room_enemy_index += 1
	for crystal in Array(room.get("crystals", [])):
		cave_crystals.append(Dictionary(crystal).duplicate(true))
	if cave_room_id == "crystal_boss" and not cave_boss_defeated and not cave_boss_intro_seen:
		cave_boss_intro_seen = true
		_show_wave_banner_for("BROODMOTHER AWAKENS\nStay moving. Red rings mean falling rock.", 2.4)


func _cave_reset_if_needed() -> void:
	var new_cycle_index: int = int(floor(float(max(round_number - 1, 0)) / float(CAVE_RESET_EVERY_ROUNDS)))
	if new_cycle_index == cave_cycle_index:
		return
	cave_cycle_index = new_cycle_index
	cave_keys = 0
	cave_switch_states.clear()
	cave_seen_rooms.clear()
	cave_room_enemy_defeated.clear()
	cave_shortcuts_unlocked.clear()
	cave_pickups_claimed.clear()
	cave_secret_revealed.clear()
	cave_boss_defeated = false
	cave_boss_intro_seen = false
	cave_boss_last_stand_triggered = false
	_setup_cave()


func _try_transition_cave_room(move_vector: Vector2) -> void:
	if cave_transition_cooldown > 0.0:
		return
	var room: Dictionary = _current_cave_room()
	if room.is_empty():
		return
	var player_rect := Rect2(cave_player_position, PLAYER_SIZE)
	var neighbors: Dictionary = room.get("neighbors", {})
	if move_vector.x < -0.15 and _cave_connection_trigger_rect("left").intersects(player_rect):
		_try_use_cave_connection("left", String(neighbors.get("left", "")))
	elif move_vector.x > 0.15 and _cave_connection_trigger_rect("right").intersects(player_rect):
		_try_use_cave_connection("right", String(neighbors.get("right", "")))
	elif move_vector.y < -0.15 and _cave_connection_trigger_rect("up").intersects(player_rect):
		_try_use_cave_connection("up", String(neighbors.get("up", "")))
	elif move_vector.y > 0.15 and _cave_connection_trigger_rect("down").intersects(player_rect):
		_try_use_cave_connection("down", String(neighbors.get("down", "")))


func _try_use_cave_connection(direction: String, target_room_id: String) -> void:
	if _is_boss_encounter_locked():
		if wave_banner_timer <= 0.0:
			_show_wave_banner_for("Arena Sealed\nBeat The Broodmother", 1.1)
		return
	if target_room_id == "":
		var shortcut_target: String = String(_current_cave_room().get("shortcuts", {}).get(direction, ""))
		if shortcut_target.begins_with("forest_shortcut") and cave_shortcuts_unlocked.has(shortcut_target):
			_leave_cave()
		return
	if not _can_enter_cave_room(target_room_id):
		return
	cave_room_id = target_room_id
	cave_seen_rooms[cave_room_id] = true
	_refresh_cave_room_state()
	match direction:
		"left":
			cave_player_position = _cave_connection_spawn_position("right")
		"right":
			cave_player_position = _cave_connection_spawn_position("left")
		"up":
			cave_player_position = _cave_connection_spawn_position("down")
		"down":
			cave_player_position = _cave_connection_spawn_position("up")
	cave_transition_cooldown = CAVE_TRANSITION_COOLDOWN


func _can_enter_cave_room(target_room_id: String) -> bool:
	var target_room: Dictionary = cave_rooms.get(target_room_id, {})
	if target_room.is_empty():
		return false
	var lock_type: String = String(target_room.get("lock", ""))
	if lock_type == "":
		return true
	if lock_type == "small_key":
		if cave_keys <= 0:
			return false
		cave_keys -= 1
		cave_rooms[target_room_id]["lock"] = "opened"
		return true
	if lock_type.begins_with("switch:"):
		var switch_id: String = lock_type.trim_prefix("switch:")
		return bool(cave_switch_states.get(switch_id, false))
	return lock_type == "opened"


func _is_boss_encounter_locked() -> bool:
	if cave_boss_defeated:
		return false
	if cave_room_id != "crystal_boss":
		return false
	for cave_enemy in cave_enemies:
		if bool(cave_enemy.get("boss", false)):
			return true
	return false


func _cave_exit_rect() -> Rect2:
	var panel: Rect2 = _cave_panel()
	return Rect2(panel.position + Vector2(76, 520), Vector2(98, 40))


func _is_player_near_cave_entrance() -> bool:
	var entrance_rect := Rect2(_cell_to_world(CAVE_ENTRANCE_CELL) + Vector2(4, 4), Vector2(40, 40))
	return entrance_rect.grow(16.0).intersects(Rect2(player_position, PLAYER_SIZE))


func _is_player_near_cave_exit() -> bool:
	if _is_boss_encounter_locked():
		return false
	return _cave_exit_rect().grow(12.0).intersects(Rect2(cave_player_position, PLAYER_SIZE))


func _cave_connection_trigger_rect(direction: String) -> Rect2:
	var bounds: Rect2 = _cave_walk_bounds()
	match direction:
		"left":
			return Rect2(bounds.position + Vector2(-10, 178), Vector2(84, 134))
		"right":
			return Rect2(Vector2(bounds.end.x - 74, bounds.position.y + 178), Vector2(84, 134))
		"up":
			return Rect2(Vector2(bounds.position.x + 382, bounds.position.y - 10), Vector2(172, 74))
		"down":
			return Rect2(Vector2(bounds.position.x + 404, bounds.end.y - 64), Vector2(128, 74))
	return Rect2(bounds.position, Vector2.ZERO)


func _cave_connection_spawn_position(direction: String) -> Vector2:
	var bounds: Rect2 = _cave_walk_bounds()
	match direction:
		"left":
			return Vector2(bounds.position.x + 34.0, bounds.position.y + bounds.size.y * 0.5 - PLAYER_SIZE.y * 0.5)
		"right":
			return Vector2(bounds.end.x - PLAYER_SIZE.x - 34.0, bounds.position.y + bounds.size.y * 0.5 - PLAYER_SIZE.y * 0.5)
		"up":
			return Vector2(bounds.position.x + bounds.size.x * 0.5 - PLAYER_SIZE.x * 0.5, bounds.position.y + 34.0)
		"down":
			return Vector2(bounds.position.x + bounds.size.x * 0.5 - PLAYER_SIZE.x * 0.5, bounds.end.y - PLAYER_SIZE.y - 34.0)
	return cave_player_position


func _ensure_forest_generated_for_player() -> void:
	var player_cell_y: int = maxi(FOREST_START_ROW, int(floor((player_position.y - GRID_ORIGIN.y) / CELL_SIZE)))
	var required_chunk_count: int = _forest_chunk_from_cell_y(player_cell_y) + FOREST_PRELOAD_CHUNKS + 1
	while generated_forest_chunk_count < required_chunk_count:
		_generate_forest_chunk(generated_forest_chunk_count)
		generated_forest_chunk_count += 1


func _forest_chunk_from_cell_y(cell_y: int) -> int:
	return max(0, int(floor(float(cell_y - FOREST_START_ROW) / float(FOREST_CHUNK_HEIGHT))))


func _generate_forest_chunk(chunk_index: int) -> void:
	var chunk_start_y := FOREST_START_ROW + chunk_index * FOREST_CHUNK_HEIGHT
	var animal_candidates: Array[Vector2i] = []
	for y in range(chunk_start_y, chunk_start_y + FOREST_CHUNK_HEIGHT):
		for x in range(GRID_SIZE.x):
			var cell := Vector2i(x, y)
			if _cell_blocks_forest(cell):
				continue
			var center_bias: float = 1.0 - absf((float(x) / max(1.0, float(GRID_SIZE.x - 1))) - 0.5) * 0.95
			var depth_bias: float = clampf(float(y - FOREST_START_ROW) / 24.0, 0.0, 1.0)
			var spawn_noise: float = randf()
			var spawn_score: float = spawn_noise + center_bias * 0.24 + depth_bias * 0.12
			if spawn_score < FOREST_TREE_DENSITY:
				var stone_chance: float = FOREST_STONE_DENSITY + depth_bias * DEEP_STONE_DENSITY_BONUS
				if randf() < stone_chance and _find_resource_node_at_cell(cell) == -1:
					resource_nodes.append(_make_resource_node(cell, "stone"))
				else:
					animal_candidates.append(cell)
				continue
			forest_tree_cells.append(cell)
			if randf() < FOREST_RESOURCE_DENSITY + depth_bias * DEEP_RESOURCE_DENSITY_BONUS:
				_add_wood_tree_node(cell)
	_spawn_forest_animals_for_chunk(chunk_index, animal_candidates)


func _spawn_forest_animals_for_chunk(chunk_index: int, candidate_cells: Array[Vector2i]) -> void:
	if candidate_cells.is_empty():
		return
	var shuffled_cells: Array[Vector2i] = candidate_cells.duplicate()
	shuffled_cells.shuffle()
	var spawn_count: int = mini(FOREST_ANIMALS_PER_CHUNK, shuffled_cells.size())
	for spawn_index in range(spawn_count):
		var animal_cell: Vector2i = shuffled_cells[spawn_index]
		if animal_cell.distance_to(PLAYER_START_CELL) <= 4:
			continue
		var animal_kind: String = "dog" if randf() < 0.55 else "beaver"
		forest_animals.append(_make_forest_animal(animal_cell, animal_kind, chunk_index))


func _make_forest_animal(cell: Vector2i, animal_kind: String, chunk_index: int) -> Dictionary:
	var anchor_position: Vector2 = _cell_to_world(cell) + Vector2(CELL_SIZE * 0.5 + randf_range(-8.0, 8.0), CELL_SIZE * 0.5 + randf_range(-2.0, 6.0))
	return {
		"kind": animal_kind,
		"chunk": chunk_index,
		"anchor": anchor_position,
		"position": anchor_position,
		"direction": -1.0 if randf() < 0.5 else 1.0,
		"speed": randf_range(FOREST_ANIMAL_WANDER_SPEED_MIN, FOREST_ANIMAL_WANDER_SPEED_MAX),
		"range": randf_range(24.0, 54.0),
		"facing_left": randf() < 0.5,
		"bob_phase": randf() * TAU
	}


func _cell_blocks_forest(cell: Vector2i) -> bool:
	if cell in HOUSE_BLOCK_CELLS:
		return true
	if cell == CAVE_ENTRANCE_CELL:
		return true
	if cell in LEFT_BUILD_YARD or cell in RIGHT_BUILD_YARD:
		return true
	if _cell_is_path(cell):
		return true
	if cell.distance_to(PLAYER_START_CELL) <= 2:
		return true
	for node_data in STONE_RESOURCE_NODES:
		if Vector2i(node_data["cell"]) == cell:
			return true
	return false


func _start_build_phase() -> void:
	phase = Phase.BUILD
	countdown = BUILD_PHASE_DURATION
	_cave_reset_if_needed()
	harvest_timer = 0.0
	harvesting_node_index = -1
	player_swing_timer = 0.0
	defend_elapsed = 0.0
	enemy_spawn_index = 0
	enemies.clear()
	projectiles.clear()
	next_enemy_id = 1
	if round_number > 1 and (round_number - 1) % RESOURCE_NODE_REFILL_EVERY_ROUNDS == 0:
		_refill_resource_nodes()
	_build_spawn_queue()
	if round_number == 1:
		_show_wave_banner_for("First Build\nGather, Wall Up, Then Start", 2.4)
	elif _is_swat_round():
		_show_wave_banner_for("SWAT Prep\nRound %d" % round_number, 2.5)
	else:
		_show_wave_banner("Build Phase\nRound %d" % round_number)


func _start_defend_phase() -> void:
	phase = Phase.DEFEND
	countdown = 0.0
	build_menu_open = false
	defend_elapsed = 0.0
	enemy_spawn_index = 0
	next_enemy_id = 1
	player_swing_timer = 0.0
	if START_WAVE_EARLY_REWARD > 0:
		wood = min(wood + START_WAVE_EARLY_REWARD, _current_carry_limit() - stone - iron - gold - gunpowder)
	if _is_swat_round():
		_show_wave_banner_for("SWAT ROUND\nBreach Team Inbound", 2.8)
	else:
		_show_wave_banner("IRS Wave %d\nIncoming" % round_number)


func _refill_resource_nodes() -> void:
	for node in resource_nodes:
		var node_cell := Vector2i(node["cell"])
		var node_capacity := int(node.get("capacity", RESOURCE_NODE_STARTS))
		var current_remaining := int(node["remaining"])
		if current_remaining > 0:
			if _resource_is_shallow(node_cell):
				node["remaining"] = max(1, current_remaining - SHALLOW_RESOURCE_DECAY_AMOUNT)
			else:
				node["remaining"] = min(current_remaining + RESOURCE_NODE_REFILL_AMOUNT + DEEP_RESOURCE_EXTRA_REFILL, node_capacity)
			continue
		var depleted_round := int(node.get("depleted_round", round_number))
		if round_number - depleted_round < RESOURCE_DEPLETED_RETURN_ROUNDS:
			continue
		node["remaining"] = min(RESOURCE_DEPLETED_RETURN_AMOUNT, node_capacity)
		node["depleted_round"] = round_number
		node["regrow_timer"] = 0.0
	for node_data in STONE_RESOURCE_NODES:
		if _find_resource_node_at_cell(node_data["cell"]) == -1:
			resource_nodes.append(_make_resource_node(Vector2i(node_data["cell"]), String(node_data["kind"]), RESOURCE_DEPLETED_RETURN_AMOUNT))
	_ensure_forest_generated_for_player()


func _build_spawn_queue() -> void:
	spawn_queue.clear()
	var enemy_count: int = 0
	var enemy_hp: int = 0
	var enemy_speed: float = 0.0
	var spawn_gap: float = 0.0
	var brute_every: int = 3
	if round_number >= 1 and round_number <= EARLY_ROUND_ENEMY_COUNTS.size():
		var profile_index: int = round_number - 1
		enemy_count = int(EARLY_ROUND_ENEMY_COUNTS[profile_index])
		enemy_hp = int(EARLY_ROUND_ENEMY_HP[profile_index])
		enemy_speed = float(EARLY_ROUND_ENEMY_SPEED[profile_index])
		spawn_gap = float(EARLY_ROUND_SPAWN_GAP[profile_index])
		brute_every = int(EARLY_ROUND_BRUTE_EVERY[profile_index])
	else:
		var post_early_round: int = round_number - EARLY_ROUND_ENEMY_COUNTS.size()
		var round_scale: float = pow(ROUND_DIFFICULTY_MULTIPLIER, post_early_round)
		enemy_count = int(EARLY_ROUND_ENEMY_COUNTS[EARLY_ROUND_ENEMY_COUNTS.size() - 1]) + int(round((round_scale - 1.0) * 6.0)) + post_early_round
		enemy_hp = int(EARLY_ROUND_ENEMY_HP[EARLY_ROUND_ENEMY_HP.size() - 1]) + int(round((round_scale - 1.0) * 3.0))
		enemy_speed = float(EARLY_ROUND_ENEMY_SPEED[EARLY_ROUND_ENEMY_SPEED.size() - 1]) + (round_scale - 1.0) * 42.0
		spawn_gap = max(0.26, float(EARLY_ROUND_SPAWN_GAP[EARLY_ROUND_SPAWN_GAP.size() - 1]) - (round_scale - 1.0) * 0.20)
		brute_every = 3 if round_number < 8 else 2

	var display_enemy_count: int = enemy_count
	var display_enemy_hp: int = enemy_hp
	var display_enemy_speed: float = enemy_speed

	for index in range(enemy_count):
		var lane: String = "left" if index % 2 == 0 else "right"
		var enemy_type: String = "runner"
		if brute_every > 0 and index > 0 and (index + 1) % brute_every == 0:
			enemy_type = "brute"
		spawn_queue.append({
			"time": 0.8 + index * spawn_gap,
			"lane": lane,
			"type": enemy_type,
			"hp": enemy_hp if enemy_type == "runner" else enemy_hp + BASE_BRUTE_BONUS_HP,
			"speed": enemy_speed if enemy_type == "runner" else enemy_speed * BASE_BRUTE_SPEED_SCALE,
			"damage": BASE_ENEMY_DAMAGE if enemy_type == "runner" else BASE_ENEMY_DAMAGE + 1
		})

	if round_number >= SWAT_START_ROUND and round_number % SWAT_WAVE_FREQUENCY == 0:
		var swat_count: int = 1 + int(round_number >= 10)
		display_enemy_count += swat_count
		display_enemy_hp = max(display_enemy_hp, enemy_hp + SWAT_EXTRA_HP)
		display_enemy_speed = max(display_enemy_speed, enemy_speed * SWAT_SPEED_SCALE)
		for swat_index in range(swat_count):
			var swat_lane: String = "left" if swat_index % 2 == 0 else "right"
			spawn_queue.append({
				"time": 1.2 + swat_index * max(0.38, spawn_gap * 0.7),
				"lane": swat_lane,
				"type": "swat",
				"hp": enemy_hp + SWAT_EXTRA_HP,
				"speed": enemy_speed * SWAT_SPEED_SCALE,
				"damage": SWAT_DAMAGE
			})
	spawn_queue.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return float(a["time"]) < float(b["time"]))
	last_wave_enemy_count = display_enemy_count
	last_wave_enemy_hp = display_enemy_hp
	last_wave_enemy_speed = display_enemy_speed


func _update_build_phase(delta: float) -> void:
	countdown = max(countdown - delta, 0.0)

	if Input.is_action_just_pressed("build_arrow_turret"):
		_toggle_build_menu()
	elif build_menu_open:
		_update_build_menu_input()
	elif Input.is_action_just_pressed("upgrade_turret"):
		_try_upgrade_turret()
	elif Input.is_action_just_pressed("repair_wall"):
		if not _try_repair_wall():
			_try_repair_house()
	elif Input.is_action_just_pressed("sell_structure"):
		_try_sell_structure()
	elif Input.is_action_just_pressed("start_wave_early"):
		_start_defend_phase()
		return
	elif Input.is_action_just_pressed("skip_build_test"):
		_start_defend_phase()
		return

	if countdown <= 0.0:
		_start_defend_phase()


func _toggle_build_menu() -> void:
	if phase != Phase.BUILD or inside_house:
		return
	build_menu_open = not build_menu_open


func _update_build_menu_input() -> void:
	var hovered_weapon: String = _build_menu_weapon_at_position(get_viewport().get_mouse_position())
	if hovered_weapon != "":
		selected_sentry_kind = hovered_weapon
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_up"):
		_cycle_sentry_selection(-1)
	elif Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_down"):
		_cycle_sentry_selection(1)
	elif Input.is_action_just_pressed("action") or Input.is_action_just_pressed("start_wave_early") or Input.is_action_just_pressed("build_arrow_turret"):
		_try_place_selected_sentry()


func _try_place_selected_sentry() -> void:
	var placed: bool = false
	match selected_sentry_kind:
		"wall_light":
			placed = _try_place_structure(StructureType.WALL_LIGHT)
		"wall_medium":
			placed = _try_place_structure(StructureType.WALL_MEDIUM)
		"wall_heavy":
			placed = _try_place_structure(StructureType.WALL_HEAVY)
		_:
			placed = _try_place_structure(StructureType.TURRET, selected_sentry_kind)
	if placed:
		build_menu_open = false


func _available_sentry_kinds() -> Array[String]:
	var sentry_kinds: Array[String] = ["arrow", "cannon", "wall_light", "wall_medium", "wall_heavy"]
	if gun_sentry_unlocked:
		sentry_kinds.append("gun")
	if golden_sentry_unlocked:
		sentry_kinds.append("golden")
	if magic_sentry_unlocked:
		sentry_kinds.append("magic")
	return sentry_kinds


func _cycle_sentry_selection(direction: int) -> void:
	var sentry_kinds: Array[String] = _available_sentry_kinds()
	var current_index: int = maxi(sentry_kinds.find(selected_sentry_kind), 0)
	selected_sentry_kind = sentry_kinds[posmod(current_index + direction, sentry_kinds.size())]


func _update_defend_phase(delta: float) -> void:
	defend_elapsed += delta
	_spawn_enemies()
	_update_enemies(delta)
	_update_turrets(delta)
	_update_projectiles(delta)

	if trophy_stolen:
		phase = Phase.GAME_OVER
		highest_round = max(highest_round, round_number)
		return

	if enemy_spawn_index >= spawn_queue.size() and enemies.is_empty() and projectiles.is_empty():
		round_number += 1
		highest_round = max(highest_round, round_number)
		_start_build_phase()


func _update_player_combat_state(delta: float) -> void:
	player_attack_cooldown = max(player_attack_cooldown - delta, 0.0)
	player_swing_timer = max(player_swing_timer - delta, 0.0)
	house_flash_timer = max(house_flash_timer - delta, 0.0)
	wave_banner_timer = max(wave_banner_timer - delta, 0.0)
	inventory_full_timer = max(inventory_full_timer - delta, 0.0)
	cave_player_hit_cooldown = max(cave_player_hit_cooldown - delta, 0.0)
	cave_transition_cooldown = max(cave_transition_cooldown - delta, 0.0)
	parry_timer = max(parry_timer - delta, 0.0)
	parry_cooldown = max(parry_cooldown - delta, 0.0)
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if structure.has("build_time"):
			structure["build_time"] = max(float(structure.get("build_time", 0.0)) - delta, 0.0)
		if structure.has("flash_timer"):
			structure["flash_timer"] = max(float(structure["flash_timer"]) - delta, 0.0)
	for enemy in enemies:
		if enemy.has("flash_timer"):
			enemy["flash_timer"] = max(float(enemy["flash_timer"]) - delta, 0.0)
	for index in range(enemy_corpses.size() - 1, -1, -1):
		enemy_corpses[index]["time"] = float(enemy_corpses[index]["time"]) + delta
		if float(enemy_corpses[index]["time"]) >= ROBOT_DEATH_FRAME_TIME * 3.0 + ROBOT_DEATH_LINGER_TIME:
			enemy_corpses.remove_at(index)
	for cave_enemy in cave_enemies:
		if cave_enemy.has("flash_timer"):
			cave_enemy["flash_timer"] = max(float(cave_enemy["flash_timer"]) - delta, 0.0)
		if cave_enemy.has("attack_timer"):
			cave_enemy["attack_timer"] = max(float(cave_enemy["attack_timer"]) - delta, 0.0)
		if cave_enemy.has("attack_cooldown"):
			cave_enemy["attack_cooldown"] = max(float(cave_enemy["attack_cooldown"]) - delta, 0.0)
	for index in range(cave_enemy_corpses.size() - 1, -1, -1):
		cave_enemy_corpses[index]["time"] = float(cave_enemy_corpses[index]["time"]) + delta
		if float(cave_enemy_corpses[index]["time"]) >= CAVE_MINER_DEATH_FRAME_TIME * 3.0 + CAVE_MINER_DEATH_LINGER_TIME:
			cave_enemy_corpses.remove_at(index)
	for index in range(hit_effects.size() - 1, -1, -1):
		hit_effects[index]["time"] = float(hit_effects[index]["time"]) - delta
		hit_effects[index]["offset"] = Vector2(hit_effects[index]["offset"]) + Vector2(0, -36.0 * delta)
		if float(hit_effects[index]["time"]) <= 0.0:
			hit_effects.remove_at(index)
	for index in range(enemy_shots.size() - 1, -1, -1):
		enemy_shots[index]["time"] = float(enemy_shots[index]["time"]) - delta
		if float(enemy_shots[index]["time"]) <= 0.0:
			enemy_shots.remove_at(index)

	if inside_house:
		return

	if inside_cave:
		_update_cave_enemies(delta)
		_update_cave_crystals()
		if Input.is_action_just_pressed("action"):
			_try_player_sword_attack()
		return

	if phase == Phase.DEFEND and Input.is_action_just_pressed("action"):
		_try_player_sword_attack()


func _move_player(delta: float) -> void:
	if build_menu_open or dealer_menu_open:
		return
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if inside_house:
		interior_player_position += move_vector * PLAYER_SPEED * delta
		var interior_bounds := _house_interior_walk_bounds()
		interior_player_position.x = clamp(interior_player_position.x, interior_bounds.position.x, interior_bounds.end.x - PLAYER_SIZE.x)
		interior_player_position.y = clamp(interior_player_position.y, interior_bounds.position.y, interior_bounds.end.y - PLAYER_SIZE.y)
		return
	if _cave_active():
		var move_speed: float = PLAYER_SPEED + (28.0 if bool(cave_pickups_claimed.get("move_upgrade", false)) else 0.0)
		if _is_player_on_cave_rubble():
			move_speed *= 0.68
		if shield_unlocked and Input.is_action_just_pressed("repair_wall") and parry_cooldown <= 0.0:
			parry_timer = PLAYER_PARRY_WINDOW
			parry_cooldown = PLAYER_PARRY_COOLDOWN
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Parry", MAGIC_COLOR)
		cave_player_position += move_vector * move_speed * delta
		var cave_bounds: Rect2 = _cave_walk_bounds()
		cave_player_position.x = clamp(cave_player_position.x, cave_bounds.position.x, cave_bounds.end.x - PLAYER_SIZE.x)
		cave_player_position.y = clamp(cave_player_position.y, cave_bounds.position.y, cave_bounds.end.y - PLAYER_SIZE.y)
		_try_transition_cave_room(move_vector)
		return
	player_position += move_vector * PLAYER_SPEED * delta
	player_position.x = clamp(player_position.x, GRID_ORIGIN.x, GRID_ORIGIN.x + GRID_SIZE.x * CELL_SIZE - PLAYER_SIZE.x)
	player_position.y = max(player_position.y, GRID_ORIGIN.y)
	_ensure_forest_generated_for_player()


func _update_selected_cell() -> void:
	if inside_cave:
		return
	var center := player_position + PLAYER_SIZE * 0.5
	var grid_x := int(floor((center.x - GRID_ORIGIN.x) / CELL_SIZE))
	var grid_y := int(floor((center.y - GRID_ORIGIN.y) / CELL_SIZE))
	selected_cell = Vector2i(clamp(grid_x, 0, GRID_SIZE.x - 1), clamp(grid_y, 0, GRID_SIZE.y - 1))


func _update_camera() -> void:
	if _cave_active():
		return
	camera_position = player_position + PLAYER_SIZE * 0.5 - SCREEN_SIZE * 0.5
	camera_position.x = clamp(camera_position.x, 0.0, WORLD_SIZE.x - SCREEN_SIZE.x)
	camera_position.y = max(camera_position.y, 0.0)


func _parry_active() -> bool:
	return shield_unlocked and parry_timer > 0.0


func _consume_cave_parry(effect_position: Vector2, enemy_index: int = -1, stun_time: float = 0.0) -> bool:
	if not _parry_active():
		return false
	parry_timer = 0.0
	_add_overlay_effect(effect_position, "PARRY!", MAGIC_COLOR)
	_add_explosion_effect(effect_position, 16.0, Color(0.42, 0.82, 1.0, 0.24))
	if enemy_index >= 0 and enemy_index < cave_enemies.size():
		cave_enemies[enemy_index]["flash_timer"] = HIT_FLASH_TIME
		if stun_time > 0.0:
			cave_enemies[enemy_index]["stun_timer"] = max(float(cave_enemies[enemy_index].get("stun_timer", 0.0)), stun_time)
			cave_enemies[enemy_index]["attack_timer"] = 0.0
			cave_enemies[enemy_index]["slam_timer"] = 0.0
			cave_enemies[enemy_index]["attack_hit_done"] = true
	return true


func _update_gathering(delta: float) -> void:
	if inside_house:
		harvesting_node_index = -1
		harvest_timer = 0.0
		return
	if inside_cave:
		_update_cave_gathering(delta)
		return
	if phase != Phase.BUILD:
		harvesting_node_index = -1
		harvest_timer = 0.0
		return

	var touching_index := _find_touching_resource_node()
	if _current_carried_total() >= _current_carry_limit():
		if touching_index != -1 and inventory_full_timer <= 0.0:
			inventory_full_timer = INVENTORY_FULL_FLASH_TIME
			_add_gather_effect(selected_cell, "Inventory Full", HOUSE_DANGER_COLOR)
		harvesting_node_index = -1
		harvest_timer = 0.0
		return
	if touching_index == -1:
		harvesting_node_index = -1
		harvest_timer = 0.0
		return

	if harvesting_node_index != touching_index:
		harvesting_node_index = touching_index
		harvest_timer = 0.0

	harvest_timer += delta
	if harvest_timer >= _current_gather_time():
		harvest_timer = 0.0
		var material_kind := String(resource_nodes[touching_index]["kind"])
		var source_cell: Vector2i = resource_nodes[touching_index]["cell"]
		resource_nodes[touching_index]["remaining"] = int(resource_nodes[touching_index]["remaining"]) - 1
		if material_kind == "stone":
			stone += 1
			tutorial_got_stone = true
		else:
			wood += 1
			tutorial_got_wood = true
		_add_gather_effect(source_cell, material_kind.capitalize())

		if int(resource_nodes[touching_index]["remaining"]) <= 0:
			resource_nodes[touching_index]["remaining"] = 0
			resource_nodes[touching_index]["depleted_round"] = round_number
			resource_nodes[touching_index]["regrow_timer"] = 0.0
			harvesting_node_index = -1


func _update_forest_animals(delta: float) -> void:
	if phase == Phase.MENU or phase == Phase.GAME_OVER or inside_house or inside_cave:
		return
	var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5
	for animal in forest_animals:
		var animal_position: Vector2 = Vector2(animal["position"])
		var anchor_position: Vector2 = Vector2(animal["anchor"])
		var move_direction: float = float(animal["direction"])
		var move_speed: float = float(animal["speed"])
		if animal_position.distance_to(player_center) < FOREST_ANIMAL_FLEE_DISTANCE:
			move_direction = -1.0 if player_center.x > animal_position.x else 1.0
			move_speed *= 2.1
		animal_position.x += move_direction * move_speed * delta
		var roam_range: float = float(animal["range"])
		if absf(animal_position.x - anchor_position.x) >= roam_range:
			move_direction *= -1.0
			animal_position.x = anchor_position.x + clampf(animal_position.x - anchor_position.x, -roam_range, roam_range)
		animal["position"] = animal_position
		animal["direction"] = move_direction
		animal["facing_left"] = move_direction < 0.0


func _update_cave_gathering(delta: float) -> void:
	var touching_index: int = _find_touching_cave_node()
	if _current_carried_total() >= _current_carry_limit():
		if touching_index != -1 and inventory_full_timer <= 0.0:
			inventory_full_timer = INVENTORY_FULL_FLASH_TIME
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Inventory Full", HOUSE_DANGER_COLOR)
		harvesting_node_index = -1
		harvest_timer = 0.0
		return
	if touching_index == -1:
		harvesting_node_index = -1
		harvest_timer = 0.0
		return
	if harvesting_node_index != touching_index:
		harvesting_node_index = touching_index
		harvest_timer = 0.0
	harvest_timer += delta
	if harvest_timer < _current_gather_time():
		return
	harvest_timer = 0.0
	var material_kind: String = String(cave_nodes[touching_index]["kind"])
	cave_nodes[touching_index]["remaining"] = int(cave_nodes[touching_index]["remaining"]) - 1
	match material_kind:
		"gold":
			gold += CAVE_GOLD_YIELD
			_add_overlay_effect(Vector2(cave_nodes[touching_index]["position"]), "+%d$" % CAVE_GOLD_YIELD, GOLD_NODE_COLOR)
		"gunpowder":
			gunpowder += CAVE_GUNPOWDER_YIELD
			_add_overlay_effect(Vector2(cave_nodes[touching_index]["position"]), "+%d Powder" % CAVE_GUNPOWDER_YIELD, GUNPOWDER_NODE_COLOR)
		_:
			iron += CAVE_IRON_YIELD
			_add_overlay_effect(Vector2(cave_nodes[touching_index]["position"]), "+%d Iron" % CAVE_IRON_YIELD, IRON_NODE_COLOR)
	if int(cave_nodes[touching_index]["remaining"]) <= 0:
		cave_nodes[touching_index]["remaining"] = 0
		harvesting_node_index = -1


func _find_touching_cave_node() -> int:
	var player_rect := Rect2(cave_player_position, PLAYER_SIZE)
	for index in range(cave_nodes.size()):
		if int(cave_nodes[index]["remaining"]) <= 0:
			continue
		if _cave_node_rect(cave_nodes[index]).intersects(player_rect):
			return index
	return -1


func _cave_node_rect(node: Dictionary) -> Rect2:
	return Rect2(Vector2(node["position"]) + Vector2(-18, -18), Vector2(36, 36))


func _spawn_boss_add_miners(spawn_count: int) -> void:
	var boss_room_bounds: Rect2 = _cave_walk_bounds()
	for add_index in range(spawn_count):
		var spawn_x: float = boss_room_bounds.position.x + 96.0 if add_index % 2 == 0 else boss_room_bounds.end.x - 132.0
		var spawn_y: float = boss_room_bounds.position.y + 120.0 + float(add_index) * 96.0
		cave_enemies.append({
			"position": Vector2(spawn_x, clampf(spawn_y, boss_room_bounds.position.y + 88.0, boss_room_bounds.end.y - 108.0)),
			"size": Vector2(32, 32),
			"hp": 4,
			"max_hp": 4,
			"speed": 88.0,
			"flash_timer": 0.0,
			"attack_timer": 0.0
		})


func _grant_boss_victory_rewards() -> void:
	wood += CAVE_BOSS_REWARD_WOOD
	stone += CAVE_BOSS_REWARD_STONE
	iron += CAVE_BOSS_REWARD_IRON
	gold += CAVE_BOSS_REWARD_GOLD
	gunpowder += CAVE_BOSS_REWARD_GUNPOWDER
	cave_pickups_claimed["carry_upgrade"] = true
	cave_pickups_claimed["hp_1"] = true
	cave_pickups_claimed["move_upgrade"] = true
	cave_pickups_claimed["gather_upgrade"] = true
	cave_pickups_claimed["sword_upgrade"] = true
	player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
	_add_overlay_effect(_cave_panel().position + Vector2(484, 46), "Boss Cache  +wood  +stone  +iron  +$  +powder", GOLD_NODE_COLOR)
	_show_wave_banner("Broodmother Down\nCache Claimed")
	_unlock_magic_sentry()


func _start_boss_rock_slam(boss_enemy: Dictionary) -> void:
	cave_boss_rock_markers.clear()
	cave_falling_rocks.clear()
	var marker_count: int = randi_range(CAVE_BOSS_ROCKFALL_MIN, CAVE_BOSS_ROCKFALL_MAX)
	var cave_bounds: Rect2 = _cave_walk_bounds()
	var player_center: Vector2 = cave_player_position + PLAYER_SIZE * 0.5
	var chosen_positions: Array[Vector2] = []
	for marker_index in range(marker_count):
		var is_big: bool = marker_index == marker_count - 1 and randf() < 0.55
		var marker_position := Vector2.ZERO
		var found_spot := false
		for attempt in range(10):
			var candidate := Vector2(
				randf_range(cave_bounds.position.x + 94.0, cave_bounds.end.x - 94.0),
				randf_range(cave_bounds.position.y + 86.0, cave_bounds.end.y - 76.0)
			)
			if candidate.distance_to(player_center) < CAVE_BOSS_MARKER_SAFE_RADIUS and marker_count > 1:
				continue
			var overlaps_existing := false
			for used_position in chosen_positions:
				if candidate.distance_to(used_position) < CAVE_BOSS_MARKER_MIN_SPACING:
					overlaps_existing = true
					break
			if overlaps_existing:
				continue
			marker_position = candidate
			found_spot = true
			break
		if not found_spot:
			marker_position = Vector2(
				randf_range(cave_bounds.position.x + 94.0, cave_bounds.end.x - 94.0),
				randf_range(cave_bounds.position.y + 86.0, cave_bounds.end.y - 76.0)
			)
		chosen_positions.append(marker_position)
		var impact_radius: float = 30.0 if not is_big else 46.0
		cave_boss_rock_markers.append({
			"position": marker_position,
			"time": CAVE_BOSS_SLAM_WINDUP + marker_index * 0.08,
			"total": CAVE_BOSS_SLAM_WINDUP + marker_index * 0.08,
			"impact_radius": impact_radius,
			"rock_size": Vector2(38, 38) if not is_big else Vector2(62, 62),
			"damage": CAVE_BOSS_ROCK_DAMAGE_SMALL if not is_big else CAVE_BOSS_ROCK_DAMAGE_BIG,
			"big": is_big
		})
	boss_enemy["slam_timer"] = CAVE_BOSS_SLAM_WINDUP
	boss_enemy["slam_cooldown"] = CAVE_BOSS_SLAM_COOLDOWN
	boss_enemy["attack_cooldown"] = max(float(boss_enemy.get("attack_cooldown", 0.0)), 1.15)
	boss_enemy["stun_timer"] = max(float(boss_enemy.get("stun_timer", 0.0)), CAVE_BOSS_SLAM_STUN_TIME)
	_play_sfx(explosion_sound, -8.0, 0.82)
	_show_wave_banner_for("Ground Slam\nWatch The Red Marks", 1.0)


func _update_cave_boss_hazards(delta: float) -> bool:
	for marker_index in range(cave_boss_rock_markers.size() - 1, -1, -1):
		var marker: Dictionary = cave_boss_rock_markers[marker_index]
		marker["time"] = float(marker.get("time", 0.0)) - delta
		if float(marker["time"]) <= 0.0:
			var target_position: Vector2 = Vector2(marker["position"])
			var rock_size: Vector2 = Vector2(marker["rock_size"])
			cave_falling_rocks.append({
				"position": Vector2(target_position.x, _cave_panel().position.y - 80.0),
				"target": target_position,
				"size": rock_size,
				"time": CAVE_BOSS_ROCKFALL_FALL_TIME,
				"total": CAVE_BOSS_ROCKFALL_FALL_TIME,
				"impact_radius": float(marker["impact_radius"]),
				"damage": int(marker["damage"]),
				"big": bool(marker["big"])
			})
			cave_boss_rock_markers.remove_at(marker_index)
	for rock_index in range(cave_falling_rocks.size() - 1, -1, -1):
		var rock: Dictionary = cave_falling_rocks[rock_index]
		var remaining_time: float = float(rock["time"]) - delta
		rock["time"] = remaining_time
		var total_time: float = max(0.01, float(rock["total"]))
		var fall_progress: float = clampf(1.0 - remaining_time / total_time, 0.0, 1.0)
		var target_position: Vector2 = Vector2(rock["target"])
		var start_position: Vector2 = Vector2(target_position.x, _cave_panel().position.y - 80.0)
		rock["position"] = start_position.lerp(target_position, fall_progress)
		if remaining_time > 0.0:
			continue
		var impact_position: Vector2 = target_position
		var impact_radius: float = float(rock["impact_radius"])
		var player_center: Vector2 = cave_player_position + PLAYER_SIZE * 0.5
		var player_hit: bool = player_center.distance_to(impact_position) <= impact_radius
		if player_hit and cave_player_hit_cooldown <= 0.0:
			cave_player_hit_cooldown = 0.75
			var blocked: bool = _consume_cave_parry(player_center)
			var rock_damage: int = 0 if blocked else int(rock["damage"])
			player_hp -= rock_damage
			if not blocked:
				_add_overlay_effect(player_center, "-%d" % rock_damage, HOUSE_DANGER_COLOR)
			if player_hp <= 0:
				player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
				_leave_cave()
				_show_wave_banner("Driven Out\nThe Cave Spits You Back")
				return false
		for cave_enemy in cave_enemies:
			if bool(cave_enemy.get("boss", false)):
				continue
			var enemy_center: Vector2 = Vector2(cave_enemy["position"]) + Vector2(cave_enemy["size"]) * 0.5
			if enemy_center.distance_to(impact_position) <= impact_radius:
				cave_enemy["hp"] = int(cave_enemy.get("hp", 1)) - int(rock["damage"])
				cave_enemy["flash_timer"] = HIT_FLASH_TIME
		cave_rock_rubble.append({
			"position": impact_position,
			"radius": impact_radius * 0.72,
			"time": CAVE_BOSS_RUBBLE_TIME
		})
		_add_explosion_effect(impact_position, impact_radius * 0.72, Color(0.78, 0.48, 0.24, 0.28))
		_play_sfx(explosion_sound, -7.5, randf_range(0.86, 0.94))
		cave_falling_rocks.remove_at(rock_index)
	for rubble_index in range(cave_rock_rubble.size() - 1, -1, -1):
		cave_rock_rubble[rubble_index]["time"] = float(cave_rock_rubble[rubble_index]["time"]) - delta
		if float(cave_rock_rubble[rubble_index]["time"]) <= 0.0:
			cave_rock_rubble.remove_at(rubble_index)
	return true


func _update_cave_enemies(delta: float) -> void:
	if not _update_cave_boss_hazards(delta):
		return
	for index in range(cave_enemies.size() - 1, -1, -1):
		if int(cave_enemies[index]["hp"]) <= 0:
			var room_enemy_index: int = int(cave_enemies[index].get("room_enemy_index", -1))
			if room_enemy_index >= 0:
				var defeated_map: Dictionary = Dictionary(cave_room_enemy_defeated.get(cave_room_id, {}))
				defeated_map[room_enemy_index] = true
				cave_room_enemy_defeated[cave_room_id] = defeated_map
			_spawn_cave_enemy_corpse(cave_enemies[index])
			var collapse_pos: Vector2 = Vector2(cave_enemies[index]["position"]) + Vector2(cave_enemies[index]["size"]) * 0.5
			var cave_reward: int = CAVE_BOSS_GOLD_REWARD if bool(cave_enemies[index].get("boss", false)) else CAVE_MINER_GOLD_REWARD
			gold += cave_reward
			_add_explosion_effect(collapse_pos, 20.0 if not bool(cave_enemies[index].get("boss", false)) else 30.0, Color(0.82, 0.24, 0.20))
			_add_overlay_effect(collapse_pos, "DOWN +%d$" % cave_reward, GOLD_NODE_COLOR)
			if bool(cave_enemies[index].get("boss", false)):
				cave_boss_defeated = true
				cave_shortcuts_unlocked["forest_shortcut_3"] = true
				cave_boss_rock_markers.clear()
				cave_falling_rocks.clear()
				_grant_boss_victory_rewards()
			cave_enemies.remove_at(index)
			continue
		var enemy_center: Vector2 = Vector2(cave_enemies[index]["position"]) + Vector2(cave_enemies[index]["size"]) * 0.5
		var player_center: Vector2 = cave_player_position + PLAYER_SIZE * 0.5
		var to_player: Vector2 = player_center - enemy_center
		var is_boss: bool = bool(cave_enemies[index].get("boss", false))
		var attack_timer: float = float(cave_enemies[index].get("attack_timer", 0.0))
		var attack_cooldown: float = float(cave_enemies[index].get("attack_cooldown", 0.0))
		var slam_timer: float = max(0.0, float(cave_enemies[index].get("slam_timer", 0.0)) - delta)
		var slam_cooldown: float = max(0.0, float(cave_enemies[index].get("slam_cooldown", 0.0)) - delta)
		var stun_timer: float = max(0.0, float(cave_enemies[index].get("stun_timer", 0.0)) - delta)
		if is_boss:
			cave_enemies[index]["slam_timer"] = slam_timer
			cave_enemies[index]["slam_cooldown"] = slam_cooldown
			cave_enemies[index]["stun_timer"] = stun_timer
			if not bool(cave_enemies[index].get("phase_one", false)) and float(cave_enemies[index]["hp"]) <= float(cave_enemies[index]["max_hp"]) * CAVE_BOSS_PHASE_ONE_TRIGGER:
				cave_enemies[index]["phase_one"] = true
				cave_enemies[index]["attack_cooldown"] = max(attack_cooldown, 0.95)
				cave_enemies[index]["slam_cooldown"] = 1.55
				cave_enemies[index]["stun_timer"] = 0.30
				_spawn_boss_add_miners(2)
				_show_wave_banner("Phase 1\nThe tunnels start shaking")
				attack_cooldown = max(attack_cooldown, 0.95)
				stun_timer = 0.30
			if not bool(cave_enemies[index].get("phase_two", false)) and float(cave_enemies[index]["hp"]) <= float(cave_enemies[index]["max_hp"]) * CAVE_BOSS_PHASE_TWO_TRIGGER:
				cave_enemies[index]["phase_two"] = true
				cave_enemies[index]["slam_cooldown"] = 1.2
				cave_enemies[index]["stun_timer"] = 0.35
				_spawn_boss_add_miners(CAVE_BOSS_ADD_SUMMON_COUNT)
				_show_wave_banner("Phase 2\nThe ceiling starts to break")
				attack_cooldown = max(attack_cooldown, 0.82)
				stun_timer = 0.35
			if not cave_boss_last_stand_triggered and float(cave_enemies[index]["hp"]) <= float(cave_enemies[index]["max_hp"]) * CAVE_BOSS_LAST_STAND_TRIGGER:
				cave_boss_last_stand_triggered = true
				cave_enemies[index]["slam_cooldown"] = 0.35
				cave_enemies[index]["attack_cooldown"] = max(attack_cooldown, 0.84)
				cave_enemies[index]["stun_timer"] = 0.55
				_spawn_boss_add_miners(CAVE_BOSS_LAST_STAND_ADD_COUNT)
				_show_wave_banner("Last Stand\nThe whole cave starts to collapse")
		var boss_speed_scale: float = 1.0
		if is_boss and (slam_timer > 0.0 or stun_timer > 0.0):
			boss_speed_scale = 0.0
		elif is_boss and attack_timer > 0.0:
			boss_speed_scale = 0.18
		elif is_boss and attack_cooldown > 0.0:
			boss_speed_scale = 0.72
		if to_player != Vector2.ZERO:
			cave_enemies[index]["position"] = Vector2(cave_enemies[index]["position"]) + to_player.normalized() * float(cave_enemies[index]["speed"]) * boss_speed_scale * delta
		var enemy_rect := Rect2(Vector2(cave_enemies[index]["position"]), Vector2(cave_enemies[index]["size"]))
		var enemy_distance: float = enemy_center.distance_to(player_center)
		if is_boss and bool(cave_enemies[index].get("phase_two", false)) and slam_timer <= 0.0 and stun_timer <= 0.0 and slam_cooldown <= 0.0 and cave_boss_rock_markers.is_empty() and cave_falling_rocks.is_empty():
			_start_boss_rock_slam(cave_enemies[index])
			slam_timer = CAVE_BOSS_SLAM_WINDUP
		if is_boss and attack_timer <= 0.0 and attack_cooldown <= 0.0 and slam_timer <= 0.0 and stun_timer <= 0.0 and enemy_distance <= CAVE_BOSS_ATTACK_RANGE:
			cave_enemies[index]["attack_timer"] = CAVE_BOSS_ATTACK_TIME
			cave_enemies[index]["attack_cooldown"] = CAVE_BOSS_ATTACK_COOLDOWN
			cave_enemies[index]["attack_hit_done"] = false
			attack_timer = CAVE_BOSS_ATTACK_TIME
		if is_boss and attack_timer > 0.0 and slam_timer <= 0.0:
			var attack_elapsed: float = CAVE_BOSS_ATTACK_TIME - attack_timer
			var hit_ready: bool = attack_elapsed >= CAVE_BOSS_ATTACK_HIT_TIME
			if hit_ready and not bool(cave_enemies[index].get("attack_hit_done", false)):
				cave_enemies[index]["attack_hit_done"] = true
				if cave_player_hit_cooldown <= 0.0 and enemy_rect.grow(22.0).intersects(Rect2(cave_player_position, PLAYER_SIZE)):
					cave_player_hit_cooldown = 0.8
					var blocked_boss: bool = _consume_cave_parry(cave_player_position + PLAYER_SIZE * 0.5, index, PLAYER_PARRY_STUN_TIME)
					var boss_damage: int = 0 if blocked_boss else CAVE_BOSS_ATTACK_DAMAGE
					player_hp -= boss_damage
					if not blocked_boss:
						_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "-%d" % boss_damage, HOUSE_DANGER_COLOR)
					_add_explosion_effect(player_center, 20.0, Color(0.76, 0.18, 0.18, 0.55))
					if player_hp <= 0:
						player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
						_leave_cave()
						_show_wave_banner("Driven Out\nThe Cave Spits You Back")
						return
		if cave_player_hit_cooldown <= 0.0 and enemy_rect.intersects(Rect2(cave_player_position, PLAYER_SIZE)) and not (is_boss and (slam_timer > 0.0 or stun_timer > 0.0)):
			cave_player_hit_cooldown = 0.7
			cave_enemies[index]["attack_timer"] = CAVE_BOSS_ATTACK_TIME if is_boss else 0.24
			if is_boss:
				cave_enemies[index]["attack_cooldown"] = CAVE_BOSS_ATTACK_COOLDOWN
				cave_enemies[index]["attack_hit_done"] = true
			var blocked: bool = _consume_cave_parry(cave_player_position + PLAYER_SIZE * 0.5, index, PLAYER_PARRY_STUN_TIME if is_boss else 0.18)
			var damage_amount: int = 0 if blocked else (CAVE_BOSS_ATTACK_DAMAGE if is_boss else 1)
			player_hp -= damage_amount
			if not blocked:
				_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "-%d" % damage_amount, HOUSE_DANGER_COLOR)
			if player_hp <= 0:
				player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
				_leave_cave()
				_show_wave_banner("Driven Out\nThe Cave Spits You Back")
				return


func _spawn_cave_enemy_corpse(cave_enemy: Dictionary) -> void:
	cave_enemy_corpses.append({
		"position": Vector2(cave_enemy["position"]),
		"size": Vector2(cave_enemy["size"]),
		"time": 0.0,
		"facing_left": cave_player_position.x < float(Vector2(cave_enemy["position"]).x)
	})


func _update_cave_crystals() -> void:
	_update_cave_pickups()
	if magic_sentry_unlocked:
		return
	var player_rect := Rect2(cave_player_position, PLAYER_SIZE)
	var all_claimed := true
	for crystal in cave_crystals:
		if not bool(crystal.get("claimed", false)):
			all_claimed = false
			var crystal_rect := Rect2(Vector2(crystal["position"]) + Vector2(-16, -22), Vector2(32, 44))
			if crystal_rect.intersects(player_rect):
				crystal["claimed"] = true
				cave_crystals_owned += 1
				gold += CAVE_CRYSTAL_GOLD_REWARD
				gunpowder += CAVE_CRYSTAL_GUNPOWDER_REWARD
				_add_overlay_effect(Vector2(crystal["position"]), "+1 Crystal  +%d$  +%d Powder" % [CAVE_CRYSTAL_GOLD_REWARD, CAVE_CRYSTAL_GUNPOWDER_REWARD], MAGIC_COLOR)
	if all_claimed and cave_boss_defeated:
		_unlock_magic_sentry()


func _can_unlock_magic_sentry() -> bool:
	if cave_crystals.is_empty() or not cave_boss_defeated:
		return false
	for crystal in cave_crystals:
		if not bool(crystal.get("claimed", false)):
			return false
	return true


func _unlock_magic_sentry() -> void:
	if magic_sentry_unlocked or not _can_unlock_magic_sentry():
		return
	magic_sentry_unlocked = true
	selected_sentry_kind = "magic"
	cave_shortcuts_unlocked["forest_shortcut_3"] = true
	_add_overlay_effect(_cave_panel().position + Vector2(504, 48), "Final Sentry Unlocked", MAGIC_COLOR)
	_show_wave_banner("Final Sentry\nCrystal Magic Online")


func _update_cave_pickups() -> void:
	var room: Dictionary = _current_cave_room()
	var player_rect := Rect2(cave_player_position, PLAYER_SIZE)
	if bool(room.get("fountain", false)) and Rect2(_cave_panel().position + Vector2(460, 286), Vector2(92, 92)).intersects(player_rect):
		player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
	for pickup in room.get("pickups", []):
		var pickup_id: String = String(pickup["id"])
		if bool(cave_pickups_claimed.get(pickup_id, false)):
			continue
		var pickup_rect := Rect2(Vector2(pickup["position"]) + Vector2(-16, -16), Vector2(32, 32))
		if not pickup_rect.intersects(player_rect):
			continue
		cave_pickups_claimed[pickup_id] = true
		_apply_cave_pickup(String(pickup["type"]))
	if String(room.get("switch_id", "")) != "":
		var switch_rect := Rect2(_cave_panel().position + Vector2(904, 470), Vector2(42, 22))
		if switch_rect.intersects(player_rect):
			cave_switch_states[String(room["switch_id"])] = true
			if String(room["switch_id"]) == "moss_secret_switch":
				cave_secret_revealed["moss_secret"] = true
			if String(room["switch_id"]) == "ruin_bridge_switch":
				cave_shortcuts_unlocked["forest_shortcut_1"] = true
			if String(room["switch_id"]) == "lava_gate_switch":
				cave_shortcuts_unlocked["forest_shortcut_2"] = true


func _apply_cave_pickup(pickup_type: String) -> void:
	match pickup_type:
		"key":
			cave_keys += 1
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Key", CAVE_KEY_COLOR)
		"upgrade_hp":
			player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Max HP Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nMax HP Up")
		"upgrade_carry":
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Backpack Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nBackpack Up")
		"upgrade_speed":
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Speed Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nSpeed Up")
		"upgrade_gather":
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Gather Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nGather Faster")
		"upgrade_sword":
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Sword Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nWrench Hits Harder")
		"unlock_parry":
			shield_unlocked = true
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Parry", MAGIC_COLOR)
			_show_wave_banner("Cave Unlock\nParry")
		"unlock_golden":
			golden_sentry_unlocked = true
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Golden Sentry", GOLD_NODE_COLOR)
			_show_wave_banner("Sentry Unlock\nGolden Turret")
		"unlock_rifle":
			turret_damage_bonus += 1
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Sentry Up", GUNPOWDER_NODE_COLOR)
			_show_wave_banner("Cave Upgrade\nSentry Damage Up")


func _current_carry_limit() -> int:
	if dev_mode_enabled:
		return 9999
	return SHARED_CARRY_LIMIT + (6 if bool(cave_pickups_claimed.get("carry_upgrade", false)) else 0)


func _current_carried_total() -> int:
	return wood + stone + iron + gold + gunpowder + cave_crystals_owned


func _extra_player_max_hp() -> int:
	return 2 if bool(cave_pickups_claimed.get("hp_1", false)) else 0


func _current_gather_time() -> float:
	return RESOURCE_HARVEST_TIME * (0.72 if bool(cave_pickups_claimed.get("gather_upgrade", false)) else 1.0)


func _current_sword_damage() -> int:
	return PLAYER_SWORD_DAMAGE + (2 if bool(cave_pickups_claimed.get("sword_upgrade", false)) else 0)


func _best_melee_target_direction(player_center: Vector2, enemy_pool: Array[Dictionary]) -> Vector2:
	var best_direction := player_aim_direction
	var best_distance := INF
	for enemy in enemy_pool:
		var enemy_center: Vector2 = Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5
		var to_enemy: Vector2 = enemy_center - player_center
		var distance: float = to_enemy.length()
		if distance > PLAYER_SWORD_RANGE or distance >= best_distance or to_enemy == Vector2.ZERO:
			continue
		best_distance = distance
		best_direction = to_enemy.normalized()
	return best_direction


func _add_overlay_effect(screen_position: Vector2, text: String, color: Color) -> void:
	hit_effects.append({
		"position": screen_position + camera_position,
		"offset": Vector2.ZERO,
		"text": text,
		"color": color,
		"time": 0.55
	})


func _find_touching_resource_node() -> int:
	var player_rect := Rect2(player_position, PLAYER_SIZE)
	for index in range(resource_nodes.size()):
		if int(resource_nodes[index]["remaining"]) <= 0:
			continue
		var node_rect := _resource_node_rect(resource_nodes[index])
		if node_rect.intersects(player_rect):
			return index
	return -1


func _find_resource_node_at_cell(cell: Vector2i) -> int:
	for index in range(resource_nodes.size()):
		if Vector2i(resource_nodes[index]["cell"]) == cell:
			return index
	return -1


func _add_wood_tree_node(cell: Vector2i) -> void:
	if _find_resource_node_at_cell(cell) != -1:
		return
	resource_nodes.append(_make_resource_node(cell, "wood"))


func _resource_node_rect(node: Dictionary) -> Rect2:
	var kind := String(node["kind"])
	if kind == "wood":
		return Rect2(_cell_to_world(node["cell"]) + Vector2(6, 2), Vector2(36, 42))
	return Rect2(_cell_to_world(node["cell"]) + Vector2(6, 6), Vector2(36, 36))


func _make_resource_node(cell: Vector2i, kind: String, starting_amount: int = -1) -> Dictionary:
	var capacity: int = _resource_capacity_for_cell(kind, cell)
	var remaining: int = capacity if starting_amount < 0 else mini(starting_amount, capacity)
	return {
		"cell": cell,
		"kind": kind,
		"remaining": remaining,
		"capacity": capacity,
		"depleted_round": -1,
		"regrow_timer": 0.0
	}


func _resource_capacity_for_cell(kind: String, cell: Vector2i) -> int:
	var capacity := RESOURCE_NODE_STARTS
	if _resource_is_shallow(cell):
		capacity = SHALLOW_WOOD_NODE_STARTS if kind == "wood" else SHALLOW_STONE_NODE_STARTS
	else:
		var depth_bonus_steps: int = max(0, int(floor(float(cell.y - DEEP_RESOURCE_BONUS_START_ROW) / float(FOREST_CHUNK_HEIGHT))))
		if kind == "stone":
			capacity += min(depth_bonus_steps + 1, 4)
		else:
			capacity += min(depth_bonus_steps, 2)
	return capacity


func _resource_is_shallow(cell: Vector2i) -> bool:
	return cell.y <= FOREST_START_ROW + SHALLOW_RESOURCE_BAND_ROWS


func _update_gather_effects(delta: float) -> void:
	for index in range(gather_effects.size() - 1, -1, -1):
		gather_effects[index]["time"] = float(gather_effects[index]["time"]) - delta
		gather_effects[index]["offset"] = Vector2(gather_effects[index]["offset"]) + Vector2(0, -22.0 * delta)
		if float(gather_effects[index]["time"]) <= 0.0:
			gather_effects.remove_at(index)


func _add_gather_effect(cell: Vector2i, material_label: String, effect_color: Color = TEXT_COLOR) -> void:
	gather_effects.append({
		"position": _cell_center(cell),
		"offset": Vector2.ZERO,
		"text": "+1 %s" % material_label if material_label in ["Wood", "Stone"] else material_label,
		"time": 0.65,
		"color": effect_color
	})


func _try_place_structure(structure_type: int, sentry_kind: String = "arrow") -> bool:
	if phase != Phase.BUILD or inside_house or inside_cave:
		return false
	if not _cell_is_buildable(selected_cell):
		return false
	if structures.has(_cell_key(selected_cell)):
		return false

	if structure_type == StructureType.TURRET:
		var sentry_cost: Dictionary = _turret_costs(sentry_kind)
		var wood_cost: int = int(sentry_cost["wood"])
		var stone_cost: int = int(sentry_cost["stone"])
		var iron_cost: int = int(sentry_cost.get("iron", 0))
		var gold_cost: int = int(sentry_cost.get("gold", 0))
		var gunpowder_cost: int = int(sentry_cost.get("gunpowder", 0))
		var crystal_cost: int = int(sentry_cost.get("crystals", 0))
		if not dev_mode_enabled and (wood < wood_cost or stone < stone_cost or iron < iron_cost or gold < gold_cost or gunpowder < gunpowder_cost or cave_crystals_owned < crystal_cost):
			return false
		if not dev_mode_enabled:
			wood -= wood_cost
			stone -= stone_cost
			iron -= iron_cost
			gold -= gold_cost
			gunpowder -= gunpowder_cost
			cave_crystals_owned -= crystal_cost
		structures[_cell_key(selected_cell)] = {
			"type": structure_type,
			"cell": selected_cell,
			"cooldown": 0.0,
			"aim_direction": Vector2.RIGHT,
			"has_target": false,
			"level": 1,
			"flash_timer": 0.0,
			"weapon": sentry_kind,
			"ammo": _turret_starting_ammo_for_weapon(sentry_kind),
			"max_ammo": _turret_starting_ammo_for_weapon(sentry_kind),
			"build_time": TURRET_BUILD_TIME,
			"build_total": TURRET_BUILD_TIME
		}
		tutorial_built_once = true
		return true

	if structure_type == StructureType.WALL_LIGHT:
		if not dev_mode_enabled and wood < WALL_LIGHT_WOOD_COST:
			return false
		if not dev_mode_enabled:
			wood -= WALL_LIGHT_WOOD_COST
		structures[_cell_key(selected_cell)] = {"type": structure_type, "cell": selected_cell, "hp": WALL_LIGHT_HP, "flash_timer": 0.0}
		tutorial_built_once = true
	elif structure_type == StructureType.WALL_MEDIUM:
		if not dev_mode_enabled and (wood < WALL_MEDIUM_WOOD_COST or stone < WALL_MEDIUM_STONE_COST):
			return false
		if not dev_mode_enabled:
			wood -= WALL_MEDIUM_WOOD_COST
			stone -= WALL_MEDIUM_STONE_COST
		structures[_cell_key(selected_cell)] = {"type": structure_type, "cell": selected_cell, "hp": WALL_MEDIUM_HP, "flash_timer": 0.0}
		tutorial_built_once = true
	elif structure_type == StructureType.WALL_HEAVY:
		if not dev_mode_enabled and (wood < WALL_HEAVY_WOOD_COST or stone < WALL_HEAVY_STONE_COST):
			return false
		if not dev_mode_enabled:
			wood -= WALL_HEAVY_WOOD_COST
			stone -= WALL_HEAVY_STONE_COST
		structures[_cell_key(selected_cell)] = {"type": structure_type, "cell": selected_cell, "hp": WALL_HEAVY_HP, "flash_timer": 0.0}
		tutorial_built_once = true
	return true


func _try_repair_house() -> void:
	if phase != Phase.BUILD or inside_house or inside_cave:
		return
	if house_damage_stage <= 0:
		return
	if not _is_player_near_house_shell():
		return
	if not dev_mode_enabled and (wood < HOUSE_REPAIR_WOOD_COST or stone < HOUSE_REPAIR_STONE_COST):
		_add_hit_effect(_cell_center(HOUSE_CELL), "Need %d Wood %d Stone" % [HOUSE_REPAIR_WOOD_COST, HOUSE_REPAIR_STONE_COST], HOUSE_DANGER_COLOR)
		return
	if not dev_mode_enabled:
		wood -= HOUSE_REPAIR_WOOD_COST
		stone -= HOUSE_REPAIR_STONE_COST
	house_damage_stage = max(house_damage_stage - 1, 0)
	tutorial_repaired_house = true
	house_flash_timer = HIT_FLASH_TIME
	_add_hit_effect(_cell_center(HOUSE_CELL), "House Repaired", Color(0.65, 1.0, 0.72))
	_add_explosion_effect(_cell_center(HOUSE_CELL), 18.0, Color(0.64, 0.94, 0.74, 0.22))


func _try_sell_structure() -> void:
	if phase != Phase.BUILD or inside_house or inside_cave:
		return
	var key := _cell_key(selected_cell)
	if not structures.has(key):
		return
	var structure: Dictionary = structures[key]
	var structure_type: int = int(structure.get("type", StructureType.NONE))
	var refund: Dictionary = {"wood": 0, "stone": 0, "iron": 0, "gold": 0, "gunpowder": 0, "crystals": 0}
	if structure_type == StructureType.TURRET:
		refund = _turret_costs(String(structure.get("weapon", "arrow"))).duplicate(true)
		var level: int = int(structure.get("level", 1))
		if level >= 2:
			refund["wood"] = int(refund.get("wood", 0)) + TURRET_UPGRADE_1_WOOD_COST
			refund["stone"] = int(refund.get("stone", 0)) + TURRET_UPGRADE_1_STONE_COST
		if level >= 3:
			refund["wood"] = int(refund.get("wood", 0)) + TURRET_UPGRADE_2_WOOD_COST
			refund["stone"] = int(refund.get("stone", 0)) + TURRET_UPGRADE_2_STONE_COST
	elif structure_type == StructureType.WALL_LIGHT:
		refund["wood"] = WALL_LIGHT_WOOD_COST
	elif structure_type == StructureType.WALL_MEDIUM:
		refund["wood"] = WALL_MEDIUM_WOOD_COST
		refund["stone"] = WALL_MEDIUM_STONE_COST
	elif structure_type == StructureType.WALL_HEAVY:
		refund["wood"] = WALL_HEAVY_WOOD_COST
		refund["stone"] = WALL_HEAVY_STONE_COST
	else:
		return
	var refund_ratio: float = 1.0 if float(structure.get("build_time", 0.0)) > 0.0 else SELL_REFUND_RATIO
	wood += int(floor(float(int(refund.get("wood", 0))) * refund_ratio))
	stone += int(floor(float(int(refund.get("stone", 0))) * refund_ratio))
	iron += int(floor(float(int(refund.get("iron", 0))) * refund_ratio))
	gold += int(floor(float(int(refund.get("gold", 0))) * refund_ratio))
	gunpowder += int(floor(float(int(refund.get("gunpowder", 0))) * refund_ratio))
	cave_crystals_owned += int(floor(float(int(refund.get("crystals", 0))) * refund_ratio))
	structures.erase(key)
	_add_hit_effect(_cell_center(selected_cell), "Packed Up" if refund_ratio >= 0.99 else "Sold", Color(0.84, 0.96, 0.78))


func _try_repair_wall() -> bool:
	if phase != Phase.BUILD or inside_house or inside_cave:
		return false
	var key := _cell_key(selected_cell)
	if not structures.has(key):
		return false
	var structure: Dictionary = structures[key]
	var structure_type := int(structure.get("type", StructureType.NONE))
	var max_hp := _wall_max_hp(structure_type)
	if max_hp <= 0:
		return false
	var current_hp := int(structure.get("hp", max_hp))
	if current_hp >= max_hp:
		return false
	var repair_costs := _wall_repair_costs(structure_type)
	var wood_cost := int(repair_costs["wood"])
	var stone_cost := int(repair_costs["stone"])
	if not dev_mode_enabled and (wood < wood_cost or stone < stone_cost):
		return false
	if not dev_mode_enabled:
		wood -= wood_cost
		stone -= stone_cost
	structure["hp"] = min(current_hp + WALL_REPAIR_AMOUNT, max_hp)
	structure["flash_timer"] = HIT_FLASH_TIME
	_add_hit_effect(_cell_center(selected_cell), "+%d" % WALL_REPAIR_AMOUNT, Color(0.65, 1.0, 0.72))
	return true


func _try_upgrade_turret() -> void:
	build_menu_open = false
	if phase != Phase.BUILD or inside_house or inside_cave:
		return
	var key := _cell_key(selected_cell)
	if not structures.has(key):
		return
	var structure: Dictionary = structures[key]
	if int(structure["type"]) != StructureType.TURRET:
		return
	var current_level := int(structure.get("level", 1))
	if current_level >= 3:
		return
	var wood_cost := TURRET_UPGRADE_1_WOOD_COST if current_level == 1 else TURRET_UPGRADE_2_WOOD_COST
	var stone_cost := TURRET_UPGRADE_1_STONE_COST if current_level == 1 else TURRET_UPGRADE_2_STONE_COST
	if not dev_mode_enabled and (wood < wood_cost or stone < stone_cost):
		return
	if not dev_mode_enabled:
		wood -= wood_cost
		stone -= stone_cost
	structure["level"] = current_level + 1
	structure["flash_timer"] = HIT_FLASH_TIME


func _try_player_sword_attack() -> void:
	if player_attack_cooldown > 0.0:
		return
	var player_center := cave_player_position + PLAYER_SIZE * 0.5 if inside_cave else player_position + PLAYER_SIZE * 0.5
	if inside_cave:
		player_aim_direction = _best_melee_target_direction(player_center, cave_enemies)
		player_attack_cooldown = PLAYER_SWORD_COOLDOWN
		player_swing_timer = PLAYER_SWORD_SWING_TIME
		player_swing_direction = player_aim_direction
		for enemy in cave_enemies:
			var enemy_center: Vector2 = Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5
			var to_enemy := enemy_center - player_center
			if to_enemy.length() > PLAYER_SWORD_RANGE:
				continue
			var slash_direction := to_enemy.normalized()
			if slash_direction == Vector2.ZERO:
				continue
			if slash_direction.dot(player_swing_direction) < PLAYER_SWORD_ARC_DOT:
				continue
			enemy["hp"] = int(enemy["hp"]) - _current_sword_damage()
			enemy["flash_timer"] = HIT_FLASH_TIME
			_add_hit_effect(enemy_center + camera_position, "-%d" % _current_sword_damage(), SLASH_COLOR)
			return
		for enemy in cave_enemies:
			var enemy_center: Vector2 = Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5
			var to_enemy := enemy_center - player_center
			if to_enemy.length() > PLAYER_SWORD_RANGE:
				continue
			var slash_direction := to_enemy.normalized()
			if slash_direction == Vector2.ZERO or slash_direction.dot(player_swing_direction) < PLAYER_SWORD_ARC_DOT:
				continue
			enemy["hp"] = int(enemy["hp"]) - _current_sword_damage()
			enemy["flash_timer"] = HIT_FLASH_TIME
			_add_hit_effect(enemy_center + camera_position, "-%d" % _current_sword_damage(), SLASH_COLOR)
		return
	player_aim_direction = _best_melee_target_direction(player_center, enemies)
	player_attack_cooldown = PLAYER_SWORD_COOLDOWN
	player_swing_timer = PLAYER_SWORD_SWING_TIME
	player_swing_direction = player_aim_direction
	for enemy in enemies:
		var enemy_center: Vector2 = Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5
		var to_enemy := enemy_center - player_center
		if to_enemy.length() > PLAYER_SWORD_RANGE:
			continue
		var slash_direction := to_enemy.normalized()
		if slash_direction == Vector2.ZERO:
			continue
		if slash_direction.dot(player_swing_direction) < PLAYER_SWORD_ARC_DOT:
			continue
		enemy["hp"] = int(enemy["hp"]) - _current_sword_damage()
		enemy["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(enemy_center, "-%d" % _current_sword_damage(), SLASH_COLOR)
		return
	for enemy in enemies:
		var enemy_center: Vector2 = Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5
		var to_enemy := enemy_center - player_center
		if to_enemy.length() > PLAYER_SWORD_RANGE:
			continue
		var slash_direction := to_enemy.normalized()
		if slash_direction == Vector2.ZERO or slash_direction.dot(player_swing_direction) < PLAYER_SWORD_ARC_DOT:
			continue
		enemy["hp"] = int(enemy["hp"]) - _current_sword_damage()
		enemy["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(enemy_center, "-%d" % _current_sword_damage(), SLASH_COLOR)


func _try_buy_gun(gun_name: String) -> void:
	if phase != Phase.BUILD or inside_house or inside_cave:
		return
	if bool(owned_guns[gun_name]):
		return
	var cost := _gun_cost(gun_name)
	if not dev_mode_enabled and (wood < int(cost["wood"]) or stone < int(cost["stone"])):
		return
	if not dev_mode_enabled:
		wood -= int(cost["wood"])
		stone -= int(cost["stone"])
	owned_guns[gun_name] = true
	gun_cooldowns[gun_name] = 0.0


func _gun_cost(gun_name: String) -> Dictionary:
	match gun_name:
		"sidearm":
			return {"wood": SIDEARM_WOOD_COST, "stone": SIDEARM_STONE_COST}
		"rifle":
			return {"wood": RIFLE_WOOD_COST, "stone": RIFLE_STONE_COST}
	return {"wood": 999, "stone": 999}


func _turret_costs(weapon: String) -> Dictionary:
	if weapon == "cannon":
		return {"wood": CANNON_TURRET_WOOD_COST, "stone": CANNON_TURRET_STONE_COST, "iron": 0}
	if weapon == "gun":
		return {"wood": GUN_TURRET_WOOD_COST, "stone": GUN_TURRET_STONE_COST, "iron": 0, "gold": 0, "gunpowder": GUN_TURRET_GUNPOWDER_COST}
	if weapon == "golden":
		return {"wood": GOLDEN_TURRET_WOOD_COST, "stone": GOLDEN_TURRET_STONE_COST, "iron": 0, "gold": GOLDEN_TURRET_GOLD_COST, "gunpowder": 0}
	if weapon == "rifle":
		return {"wood": RIFLE_TURRET_WOOD_COST, "stone": RIFLE_TURRET_STONE_COST, "iron": 0, "gold": 0, "gunpowder": RIFLE_TURRET_GUNPOWDER_COST}
	if weapon == "magic":
		return {"wood": MAGIC_TURRET_WOOD_COST, "stone": MAGIC_TURRET_STONE_COST, "iron": MAGIC_TURRET_IRON_COST, "gold": 0, "gunpowder": 0, "crystals": MAGIC_TURRET_CRYSTAL_COST}
	return {"wood": ARROW_TURRET_WOOD_COST, "stone": ARROW_TURRET_STONE_COST, "iron": 0, "gold": 0, "gunpowder": 0}


func _is_player_near_house_door() -> bool:
	return _house_door_rect().grow(16.0).intersects(Rect2(player_position, PLAYER_SIZE))


func _is_player_near_house_shell() -> bool:
	var base_rect := Rect2(_cell_to_world(HOUSE_TOP_LEFT) + Vector2(10, 24), Vector2(4, 2) * CELL_SIZE - Vector2(20, 20))
	return base_rect.grow(40.0).intersects(Rect2(player_position, PLAYER_SIZE))


func _is_player_on_cave_rubble() -> bool:
	var player_center: Vector2 = cave_player_position + PLAYER_SIZE * 0.5
	for rubble in cave_rock_rubble:
		if player_center.distance_to(Vector2(rubble["position"])) <= float(rubble["radius"]):
			return true
	return false


func _dealer_stand_rect() -> Rect2:
	var stand_origin: Vector2 = _cell_to_world(DEALER_STAND_CELL) + Vector2(6, 0)
	return Rect2(stand_origin, Vector2(36, 42))


func _is_player_near_dealer_stand() -> bool:
	return _dealer_stand_rect().grow(18.0).intersects(Rect2(player_position, PLAYER_SIZE))


func _is_player_near_house_exit() -> bool:
	return _house_interior_exit_rect().grow(14.0).intersects(Rect2(interior_player_position, PLAYER_SIZE))


func _house_door_rect() -> Rect2:
	var base_rect := Rect2(_cell_to_world(HOUSE_TOP_LEFT) + Vector2(10, 24), Vector2(4, 2) * CELL_SIZE - Vector2(20, 20))
	return Rect2(base_rect.position + Vector2(base_rect.size.x * 0.5 - 10, base_rect.size.y - 30), Vector2(20, 30))


func _house_interior_panel() -> Rect2:
	return Rect2(Vector2(190, 86), Vector2(900, 548))


func _house_interior_walk_bounds() -> Rect2:
	var panel := _house_interior_panel()
	return Rect2(panel.position + Vector2(70, 250), Vector2(760, 220))


func _house_interior_exit_rect() -> Rect2:
	var panel := _house_interior_panel()
	return Rect2(panel.position + Vector2(panel.size.x * 0.5 - 36, 470), Vector2(72, 48))


func _house_interior_spawn_position() -> Vector2:
	var exit_rect := _house_interior_exit_rect()
	return exit_rect.position + Vector2(exit_rect.size.x * 0.5 - PLAYER_SIZE.x * 0.5, 18.0)


func _steal_house_item(enemy_index: int) -> void:
	if house_items.is_empty():
		trophy_stolen = true
		_show_wave_banner_for("House Emptied\nNothing Left To Save", 1.8)
		return
	var stolen_item: String = house_items.pop_front()
	stolen_house_items.append(stolen_item)
	house_flash_timer = HIT_FLASH_TIME * 2.2
	_add_hit_effect(_cell_center(HOUSE_CELL), "STOLEN: %s" % stolen_item, TROPHY_COLOR if stolen_item == PRIZED_HOUSE_ITEM else HOUSE_DANGER_COLOR)
	_add_explosion_effect(_cell_center(HOUSE_CELL), 34.0, Color(0.96, 0.30, 0.24, 0.30))
	_show_wave_banner_for("IRS STOLE\n%s" % stolen_item, 1.6)
	if enemy_index >= 0 and enemy_index < enemies.size():
		enemies[enemy_index]["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(Vector2(enemies[enemy_index]["position"]) + Vector2(enemies[enemy_index]["size"]) * 0.5, "RUN!", MUTED_TEXT_COLOR)
		enemies.remove_at(enemy_index)
	if stolen_item == PRIZED_HOUSE_ITEM:
		trophy_stolen = true
		_show_wave_banner_for("PRIZED ITEM STOLEN\nThe KFZ Console Is Gone", 2.3)


func _cell_is_buildable(cell: Vector2i) -> bool:
	return cell in build_cells


func _cell_is_path(cell: Vector2i) -> bool:
	return path_lookup.has(_cell_key(cell))


func _is_wall_structure(structure: Dictionary) -> bool:
	var structure_type: int = int(structure.get("type", StructureType.NONE))
	return structure_type == StructureType.WALL_LIGHT or structure_type == StructureType.WALL_MEDIUM or structure_type == StructureType.WALL_HEAVY


func _side_house_target_cell(lane: String) -> Vector2i:
	return HOUSE_DAMAGE_CELLS[0] if lane == "left" else HOUSE_DAMAGE_CELLS[1]


func _find_enemy_wall_target(enemy: Dictionary) -> Dictionary:
	var lane: String = String(enemy.get("lane", "left"))
	var enemy_center: Vector2 = _enemy_center(enemy)
	var best_target: Dictionary = {}
	var best_score: float = INF
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if not _is_wall_structure(structure):
			continue
		var wall_cell: Vector2i = Vector2i(structure["cell"])
		if lane == "left" and wall_cell.x > HOUSE_CELL.x:
			continue
		if lane == "right" and wall_cell.x < HOUSE_CELL.x:
			continue
		var wall_center: Vector2 = _cell_center(wall_cell)
		var house_anchor: Vector2 = _cell_center(_side_house_target_cell(lane))
		var score: float = enemy_center.distance_to(wall_center) + wall_center.distance_to(house_anchor) * 0.35
		if score < best_score:
			best_score = score
			best_target = structure
	return best_target


func _enemy_reached_target(enemy_position: Vector2, enemy_size: Vector2, target_center: Vector2) -> bool:
	var enemy_center: Vector2 = enemy_position + enemy_size * 0.5
	return enemy_center.distance_to(target_center) <= CELL_SIZE * 0.28


func _spawn_enemies() -> void:
	while enemy_spawn_index < spawn_queue.size() and float(spawn_queue[enemy_spawn_index]["time"]) <= defend_elapsed:
		var spawn_data: Dictionary = spawn_queue[enemy_spawn_index]
		var lane: String = String(spawn_data["lane"])
		var enemy_type: String = String(spawn_data["type"])
		var enemy_size := Vector2(28, 28)
		if enemy_type == "brute":
			enemy_size = Vector2(34, 34)
		elif enemy_type == "swat":
			enemy_size = Vector2(32, 32)
		var entry_cell: Vector2i = Vector2i(2, randi_range(SIDE_SPAWN_ROW_RANGE.x, SIDE_SPAWN_ROW_RANGE.y)) if lane == "left" else Vector2i(GRID_SIZE.x - 3, randi_range(SIDE_SPAWN_ROW_RANGE.x, SIDE_SPAWN_ROW_RANGE.y))
		var entry_target: Vector2 = _cell_center(entry_cell) - enemy_size * 0.5
		var spawn_position: Vector2 = _side_spawn_position(lane, enemy_size)
		enemies.append({
			"id": next_enemy_id,
			"lane": lane,
			"type": String(spawn_data["type"]),
			"position": spawn_position,
			"size": enemy_size,
			"hp": int(spawn_data["hp"]),
			"max_hp": int(spawn_data["hp"]),
			"speed": float(spawn_data["speed"]),
			"damage": int(spawn_data["damage"]),
			"approaching_entry": true,
			"entry_target": entry_target,
			"attack_cooldown": 0.0,
			"attack_windup": 0.0,
			"flash_timer": 0.0,
			"wander_offset": randf_range(-26.0, 26.0)
		})
		next_enemy_id += 1
		enemy_spawn_index += 1


func _apply_enemy_attack(enemy_index: int, target_wall: Dictionary, target_center: Vector2) -> void:
	if enemy_index < 0 or enemy_index >= enemies.size():
		return
	enemies[enemy_index]["attack_cooldown"] = ENEMY_ATTACK_RATE
	enemies[enemy_index]["attack_windup"] = 0.0
	if not target_wall.is_empty():
		var wall_cell: Vector2i = Vector2i(target_wall["cell"])
		if String(enemies[enemy_index]["type"]) == "runner":
			_add_enemy_shot(_enemy_center(enemies[enemy_index]), _cell_center(wall_cell))
		target_wall["hp"] = int(target_wall["hp"]) - int(enemies[enemy_index]["damage"])
		target_wall["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(_cell_center(wall_cell), "-%d" % int(enemies[enemy_index]["damage"]), HOUSE_DANGER_COLOR)
		if int(target_wall["hp"]) <= 0:
			_add_explosion_effect(_cell_center(wall_cell), 24.0, Color(0.72, 0.58, 0.36))
			_add_hit_effect(_cell_center(wall_cell), "CRUMBLE", Color(0.92, 0.80, 0.62))
			structures.erase(_cell_key(wall_cell))
		return
	if _count_remaining_walls() > 0:
		if String(enemies[enemy_index]["type"]) == "runner":
			_add_enemy_shot(_enemy_center(enemies[enemy_index]), target_center)
		_damage_outer_wall(int(enemies[enemy_index]["damage"]))
		enemies[enemy_index]["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(_cell_center(HOUSE_CELL), "WALLS!", HOUSE_DANGER_COLOR)
	elif house_damage_stage < HOUSE_MAX_DAMAGE_STAGES:
		if String(enemies[enemy_index]["type"]) == "runner":
			_add_enemy_shot(_enemy_center(enemies[enemy_index]), target_center)
		_damage_house(int(enemies[enemy_index]["damage"]))
		enemies[enemy_index]["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(Vector2(enemies[enemy_index]["position"]) + Vector2(enemies[enemy_index]["size"]) * 0.5, "RUN!", MUTED_TEXT_COLOR)
		enemies.remove_at(enemy_index)
	else:
		_steal_house_item(enemy_index)


func _update_enemies(delta: float) -> void:
	for index in range(enemies.size() - 1, -1, -1):
		if int(enemies[index]["hp"]) <= 0:
			_kill_enemy(index)
			continue
		var previous_windup: float = float(enemies[index].get("attack_windup", 0.0))
		var attack_windup: float = max(previous_windup - delta, 0.0)
		enemies[index]["attack_windup"] = attack_windup
		enemies[index]["attack_cooldown"] = max(float(enemies[index]["attack_cooldown"]) - delta, 0.0)
		var lane: String = String(enemies[index]["lane"])
		var enemy_size: Vector2 = enemies[index]["size"]
		if bool(enemies[index].get("approaching_entry", false)):
			var entry_target: Vector2 = Vector2(enemies[index]["entry_target"])
			var entry_position: Vector2 = Vector2(enemies[index]["position"])
			var to_entry := entry_target - entry_position
			if to_entry.length() <= float(enemies[index]["speed"]) * delta:
				enemies[index]["position"] = entry_target
				enemies[index]["approaching_entry"] = false
			else:
				enemies[index]["position"] = entry_position + to_entry.normalized() * float(enemies[index]["speed"]) * delta
			continue
		var enemy_position: Vector2 = enemies[index]["position"]
		var target_wall: Dictionary = _find_enemy_wall_target(enemies[index])
		var target_center: Vector2
		var is_hitting_wall := false
		if not target_wall.is_empty():
			target_center = _cell_center(Vector2i(target_wall["cell"])) + Vector2(0.0, float(enemies[index].get("wander_offset", 0.0)) * 0.18)
			is_hitting_wall = _enemy_reached_target(enemy_position, enemy_size, target_center)
		else:
			target_center = _cell_center(_side_house_target_cell(lane))
			is_hitting_wall = _enemy_reached_target(enemy_position, enemy_size, target_center)
		if is_hitting_wall:
			if previous_windup > 0.0 and attack_windup <= 0.0:
				_apply_enemy_attack(index, target_wall, target_center)
			elif previous_windup <= 0.0 and float(enemies[index]["attack_cooldown"]) <= 0.0:
				enemies[index]["attack_windup"] = ENEMY_ATTACK_WINDUP
				enemies[index]["flash_timer"] = max(float(enemies[index].get("flash_timer", 0.0)), 0.06)
			continue

		var target_position := target_center - enemy_size * 0.5
		var to_target := target_position - enemy_position
		if to_target.length() <= float(enemies[index]["speed"]) * delta:
			enemies[index]["position"] = target_position
		else:
			enemies[index]["position"] = enemy_position + to_target.normalized() * float(enemies[index]["speed"]) * delta


func _kill_enemy(index: int) -> void:
	var enemy_type: String = String(enemies[index]["type"])
	if enemy_type == "brute":
		_spawn_robot_corpse(enemies[index])
	elif enemy_type == "swat":
		gold += SWAT_GOLD_REWARD
		_add_hit_effect(_enemy_center(enemies[index]), "+%d$" % SWAT_GOLD_REWARD, GOLD_NODE_COLOR)
	_add_explosion_effect(_enemy_center(enemies[index]), 18.0 if enemy_type == "runner" else 24.0, Color(0.82, 0.24, 0.20))
	_add_hit_effect(_enemy_center(enemies[index]), "DOWN", Color(1.0, 0.86, 0.72))
	enemies.remove_at(index)


func _spawn_robot_corpse(enemy: Dictionary) -> void:
	enemy_corpses.append({
		"position": Vector2(enemy["position"]),
		"size": Vector2(enemy["size"]),
		"time": 0.0,
		"lane": String(enemy.get("lane", "left"))
	})


func _update_turrets(delta: float) -> void:
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if int(structure["type"]) != StructureType.TURRET:
			continue
		if float(structure.get("build_time", 0.0)) > 0.0:
			structure["has_target"] = false
			continue

		structure["cooldown"] = max(float(structure["cooldown"]) - delta, 0.0)
		var turret_center := _cell_center(structure["cell"])
		structure["has_target"] = false
		var turret_range := _turret_range(structure)
		var nearest_index := -1
		var nearest_distance := INF
		for enemy_index in range(enemies.size()):
			var enemy_center: Vector2 = Vector2(enemies[enemy_index]["position"]) + Vector2(enemies[enemy_index]["size"]) * 0.5
			var distance := turret_center.distance_to(enemy_center)
			if distance <= turret_range and distance < nearest_distance:
				nearest_distance = distance
				nearest_index = enemy_index

		if nearest_index != -1:
			var target_center: Vector2 = Vector2(enemies[nearest_index]["position"]) + Vector2(enemies[nearest_index]["size"]) * 0.5
			var aim_direction: Vector2 = (target_center - turret_center).normalized()
			if aim_direction != Vector2.ZERO:
				structure["aim_direction"] = aim_direction
			structure["has_target"] = true
		if float(structure["cooldown"]) > 0.0:
			continue

		if nearest_index != -1:
			if not _turret_has_ammo(structure):
				continue
			_consume_turret_ammo(structure)
			structure["cooldown"] = _turret_fire_rate(structure)
			var fired_weapon: String = String(structure.get("weapon", "arrow"))
			var target_center: Vector2 = Vector2(enemies[nearest_index]["position"]) + Vector2(enemies[nearest_index]["size"]) * 0.5
			var projectile_direction: Vector2 = target_center - turret_center
			var muzzle_direction: Vector2 = projectile_direction.normalized() if projectile_direction != Vector2.ZERO else Vector2(structure.get("aim_direction", Vector2.RIGHT))
			var muzzle_color: Color = Color(_turret_projectile_color(structure))
			_add_explosion_effect(turret_center + muzzle_direction * 14.0, 9.0 if fired_weapon != "cannon" else 14.0, Color(muzzle_color.r, muzzle_color.g, muzzle_color.b, 0.20))
			projectiles.append({
				"position": turret_center,
				"origin": turret_center,
				"land_position": target_center,
				"target_id": int(enemies[nearest_index]["id"]),
				"speed": _turret_projectile_speed(structure),
				"damage": _turret_damage(structure),
				"color": _turret_projectile_color(structure),
				"radius": _turret_projectile_radius(structure),
				"splash_radius": _turret_splash_radius(structure),
				"kind": _turret_projectile_kind(structure),
				"direction": projectile_direction.normalized() if projectile_direction != Vector2.ZERO else structure["aim_direction"],
				"flight_progress": 0.0
			})
			if fired_weapon == "cannon":
				_play_sfx(explosion_sound, -10.0, randf_range(0.92, 1.00))
			elif fired_weapon == "arrow" or fired_weapon == "golden" or fired_weapon == "rifle":
				_play_sfx(crossbow_sound, -11.5, randf_range(0.96, 1.04))
			else:
				_play_sfx(gunshot_sound, -13.0, randf_range(0.96, 1.04))


func _turret_damage(structure: Dictionary) -> int:
	var weapon: String = String(structure.get("weapon", "arrow"))
	var base_damage: int = ARROW_TURRET_DAMAGE
	if weapon == "cannon":
		base_damage = CANNON_TURRET_DAMAGE
	elif weapon == "gun":
		base_damage = GUN_TURRET_DAMAGE
	elif weapon == "golden":
		base_damage = GOLDEN_TURRET_DAMAGE
	elif weapon == "rifle":
		base_damage = RIFLE_TURRET_DAMAGE
	elif weapon == "magic":
		base_damage = MAGIC_TURRET_DAMAGE
	return base_damage + int(structure.get("level", 1)) - 1 + turret_damage_bonus


func _turret_range(structure: Dictionary) -> float:
	var weapon: String = String(structure.get("weapon", "arrow"))
	var base_range: float = ARROW_TURRET_RANGE
	if weapon == "cannon":
		base_range = CANNON_TURRET_RANGE
	elif weapon == "gun":
		base_range = GUN_TURRET_RANGE
	elif weapon == "golden":
		base_range = GOLDEN_TURRET_RANGE
	elif weapon == "rifle":
		base_range = RIFLE_TURRET_RANGE
	elif weapon == "magic":
		base_range = MAGIC_TURRET_RANGE
	return base_range + float(int(structure.get("level", 1)) - 1) * 28.0


func _turret_fire_rate(structure: Dictionary) -> float:
	var weapon: String = String(structure.get("weapon", "arrow"))
	var base_fire_rate: float = ARROW_TURRET_FIRE_RATE
	var level_bonus: float = 0.10
	if weapon == "cannon":
		base_fire_rate = CANNON_TURRET_FIRE_RATE
		level_bonus = 0.12
	elif weapon == "gun":
		base_fire_rate = GUN_TURRET_FIRE_RATE
		level_bonus = 0.05
	elif weapon == "golden":
		base_fire_rate = GOLDEN_TURRET_FIRE_RATE
		level_bonus = 0.06
	elif weapon == "rifle":
		base_fire_rate = RIFLE_TURRET_FIRE_RATE
		level_bonus = 0.05
	elif weapon == "magic":
		base_fire_rate = MAGIC_TURRET_FIRE_RATE
		level_bonus = 0.08
	return max(0.24, base_fire_rate - float(int(structure.get("level", 1)) - 1) * level_bonus)


func _turret_projectile_speed(structure: Dictionary) -> float:
	var weapon: String = String(structure.get("weapon", "arrow"))
	if weapon == "cannon":
		return CANNON_TURRET_PROJECTILE_SPEED
	if weapon == "gun":
		return GUN_TURRET_PROJECTILE_SPEED
	if weapon == "golden":
		return GOLDEN_TURRET_PROJECTILE_SPEED
	if weapon == "rifle":
		return RIFLE_TURRET_PROJECTILE_SPEED
	if weapon == "magic":
		return MAGIC_TURRET_PROJECTILE_SPEED
	return ARROW_TURRET_PROJECTILE_SPEED


func _turret_projectile_radius(structure: Dictionary) -> float:
	var weapon: String = String(structure.get("weapon", "arrow"))
	if weapon == "cannon":
		return CANNON_TURRET_PROJECTILE_RADIUS
	if weapon == "gun":
		return GUN_TURRET_PROJECTILE_RADIUS
	if weapon == "golden":
		return GOLDEN_TURRET_PROJECTILE_RADIUS
	if weapon == "rifle":
		return RIFLE_TURRET_PROJECTILE_RADIUS
	if weapon == "magic":
		return MAGIC_TURRET_PROJECTILE_RADIUS
	return ARROW_TURRET_PROJECTILE_RADIUS


func _turret_projectile_color(structure: Dictionary) -> Color:
	var weapon: String = String(structure.get("weapon", "arrow"))
	if weapon == "cannon":
		return Color(0.36, 0.35, 0.32)
	if weapon == "gun":
		return Color(1.0, 0.92, 0.38)
	if weapon == "golden":
		return GOLD_NODE_COLOR
	if weapon == "rifle":
		return RIFLE_PROJECTILE_COLOR
	if weapon == "magic":
		return MAGIC_COLOR
	return PROJECTILE_COLOR


func _turret_projectile_kind(structure: Dictionary) -> String:
	var weapon: String = String(structure.get("weapon", "arrow"))
	if weapon == "cannon":
		return "cannonball"
	if weapon == "magic":
		return "laser"
	if weapon == "gun":
		return "orb"
	if weapon == "arrow" or weapon == "golden" or weapon == "rifle":
		return "arrow"
	return "orb"


func _turret_splash_radius(structure: Dictionary) -> float:
	var weapon: String = String(structure.get("weapon", "arrow"))
	var level_bonus: float = float(int(structure.get("level", 1)) - 1) * 6.0
	return CANNON_TURRET_SPLASH_RADIUS + level_bonus if weapon == "cannon" else 0.0


func _turret_has_ammo(structure: Dictionary) -> bool:
	var weapon: String = String(structure.get("weapon", "arrow"))
	if weapon == "magic":
		return true
	return int(structure.get("ammo", _turret_starting_ammo_for_weapon(weapon))) > 0 or dev_mode_enabled


func _consume_turret_ammo(structure: Dictionary) -> void:
	if dev_mode_enabled:
		return
	var weapon: String = String(structure.get("weapon", "arrow"))
	if weapon == "magic":
		return
	structure["ammo"] = max(int(structure.get("ammo", _turret_starting_ammo_for_weapon(weapon))) - 1, 0)


func _turret_starting_ammo_for_weapon(weapon: String) -> int:
	match weapon:
		"cannon":
			return CANNON_TURRET_STARTING_AMMO
		"gun":
			return GUN_TURRET_STARTING_AMMO
		"golden":
			return GOLDEN_TURRET_STARTING_AMMO
		"magic":
			return 9999
		_:
			return ARROW_TURRET_STARTING_AMMO


func _turret_ammo_totals() -> Dictionary:
	var ammo_total: int = 0
	var ammo_max_total: int = 0
	var shell_total: int = 0
	var shell_max_total: int = 0
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if int(structure.get("type", StructureType.NONE)) != StructureType.TURRET:
			continue
		var weapon: String = String(structure.get("weapon", "arrow"))
		if weapon == "magic":
			continue
		if weapon == "cannon":
			shell_total += int(structure.get("ammo", CANNON_TURRET_STARTING_AMMO))
			shell_max_total += int(structure.get("max_ammo", CANNON_TURRET_STARTING_AMMO))
		else:
			ammo_total += int(structure.get("ammo", _turret_starting_ammo_for_weapon(weapon)))
			ammo_max_total += int(structure.get("max_ammo", _turret_starting_ammo_for_weapon(weapon)))
	return {"ammo": ammo_total, "ammo_max": ammo_max_total, "shells": shell_total, "shells_max": shell_max_total}


func _ammo_totals_low(ammo_totals: Dictionary) -> bool:
	var ammo_max: int = int(ammo_totals.get("ammo_max", 0))
	var shell_max: int = int(ammo_totals.get("shells_max", 0))
	var ammo_low: bool = ammo_max > 0 and int(ammo_totals.get("ammo", 0)) <= max(4, int(floor(float(ammo_max) * 0.28)))
	var shell_low: bool = shell_max > 0 and int(ammo_totals.get("shells", 0)) <= max(2, int(floor(float(shell_max) * 0.35)))
	return ammo_low or shell_low


func _turret_reload_progress(structure: Dictionary) -> float:
	var fire_rate: float = _turret_fire_rate(structure)
	if fire_rate <= 0.0:
		return 1.0
	return clampf(1.0 - float(structure["cooldown"]) / fire_rate, 0.0, 1.0)


func _count_remaining_walls() -> int:
	var count := 0
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if int(structure["type"]) == StructureType.WALL_LIGHT or int(structure["type"]) == StructureType.WALL_MEDIUM or int(structure["type"]) == StructureType.WALL_HEAVY:
			count += 1
	return count


func _house_integrity_left() -> int:
	return max(HOUSE_MAX_DAMAGE_STAGES - house_damage_stage, 0)


func _damage_house(_damage: int) -> void:
	if house_damage_stage >= HOUSE_MAX_DAMAGE_STAGES:
		return
	house_damage_stage += 1
	house_flash_timer = HIT_FLASH_TIME * 2.0
	_add_hit_effect(_cell_center(HOUSE_CELL), "HOUSE %d/%d" % [house_damage_stage, HOUSE_MAX_DAMAGE_STAGES], HOUSE_DANGER_COLOR)
	_add_explosion_effect(_cell_center(HOUSE_CELL), 28.0, Color(0.82, 0.34, 0.24, 0.24))
	_show_wave_banner_for("HOUSE HIT\n%d hits left" % _house_integrity_left(), 1.0)
	if house_damage_stage >= HOUSE_MAX_DAMAGE_STAGES:
		_add_hit_effect(_cell_center(HOUSE_CELL), "BREACHED", Color(1.0, 0.84, 0.72))
		_show_wave_banner_for("HOUSE BREACHED\nIRS can now steal your stuff", 1.9)


func _damage_outer_wall(damage: int) -> void:
	var target_key := ""
	var target_distance := -1.0
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		var structure_type := int(structure["type"])
		if structure_type != StructureType.WALL_LIGHT and structure_type != StructureType.WALL_MEDIUM and structure_type != StructureType.WALL_HEAVY:
			continue
		var distance := _cell_center(structure["cell"]).distance_to(_cell_center(HOUSE_CELL))
		if distance > target_distance:
			target_distance = distance
			target_key = String(structure_key)
	if target_key == "":
		return
	var wall: Dictionary = structures[target_key]
	wall["hp"] = int(wall["hp"]) - damage
	wall["flash_timer"] = HIT_FLASH_TIME
	_add_hit_effect(_cell_center(wall["cell"]), "-%d" % damage, HOUSE_DANGER_COLOR)
	if int(wall["hp"]) <= 0:
		_add_explosion_effect(_cell_center(wall["cell"]), 22.0, Color(0.68, 0.56, 0.34))
		_add_hit_effect(_cell_center(wall["cell"]), "CRUMBLE", Color(0.96, 0.84, 0.72))
		structures.erase(target_key)


func _update_player_guns(delta: float) -> void:
	for gun_name in gun_cooldowns.keys():
		gun_cooldowns[gun_name] = max(float(gun_cooldowns[gun_name]) - delta, 0.0)

	var player_center := player_position + PLAYER_SIZE * 0.5
	var best_enemy_index := -1
	var best_enemy_distance := INF
	var max_range: float = max(SIDEARM_RANGE if bool(owned_guns["sidearm"]) else 0.0, RIFLE_RANGE if bool(owned_guns["rifle"]) else 0.0)
	for enemy_index in range(enemies.size()):
		var enemy_center: Vector2 = Vector2(enemies[enemy_index]["position"]) + Vector2(enemies[enemy_index]["size"]) * 0.5
		var distance := player_center.distance_to(enemy_center)
		if distance <= max_range and distance < best_enemy_distance:
			best_enemy_distance = distance
			best_enemy_index = enemy_index

	if best_enemy_index == -1:
		return

	var target_center: Vector2 = Vector2(enemies[best_enemy_index]["position"]) + Vector2(enemies[best_enemy_index]["size"]) * 0.5
	var aim_direction := (target_center - player_center).normalized()
	if aim_direction != Vector2.ZERO:
		player_aim_direction = aim_direction

	_fire_player_gun("sidearm", best_enemy_index, SIDEARM_RANGE, SIDEARM_FIRE_RATE, SIDEARM_DAMAGE, SIDEARM_PROJECTILE_COLOR, 4.0)
	_fire_player_gun("rifle", best_enemy_index, RIFLE_RANGE, RIFLE_FIRE_RATE, RIFLE_DAMAGE, RIFLE_PROJECTILE_COLOR, 5.0)


func _fire_player_gun(gun_name: String, target_index: int, gun_range: float, fire_rate: float, damage: int, projectile_color: Color, radius: float) -> void:
	if not bool(owned_guns[gun_name]):
		return
	if float(gun_cooldowns[gun_name]) > 0.0:
		return
	var player_center := player_position + PLAYER_SIZE * 0.5
	var enemy_center: Vector2 = Vector2(enemies[target_index]["position"]) + Vector2(enemies[target_index]["size"]) * 0.5
	if player_center.distance_to(enemy_center) > gun_range:
		return
	gun_cooldowns[gun_name] = fire_rate
	projectiles.append({
		"position": player_center,
		"target_id": int(enemies[target_index]["id"]),
		"speed": 430.0 if gun_name == "sidearm" else 520.0,
		"damage": damage + gun_damage_bonus,
		"color": projectile_color,
		"radius": radius
	})
	_play_sfx(gunshot_sound, -11.5 if gun_name == "rifle" else -13.5, randf_range(0.97, 1.05))


func _update_projectiles(delta: float) -> void:
	for index in range(projectiles.size() - 1, -1, -1):
		var projectile_kind: String = String(projectiles[index].get("kind", "orb"))
		var target_index := _find_enemy_index_by_id(int(projectiles[index]["target_id"]))
		var target_center: Vector2
		if projectile_kind == "cannonball":
			target_center = Vector2(projectiles[index].get("land_position", projectiles[index]["position"]))
		else:
			if target_index == -1:
				projectiles.remove_at(index)
				continue
			target_center = Vector2(enemies[target_index]["position"]) + Vector2(enemies[target_index]["size"]) * 0.5
		var projectile_pos: Vector2 = projectiles[index]["position"]
		var to_target := target_center - projectile_pos
		if to_target != Vector2.ZERO:
			projectiles[index]["direction"] = to_target.normalized()
		if projectile_kind == "cannonball":
			var origin: Vector2 = Vector2(projectiles[index].get("origin", projectile_pos))
			var total_distance: float = max(origin.distance_to(target_center), 1.0)
			var next_progress: float = min(float(projectiles[index].get("flight_progress", 0.0)) + (float(projectiles[index]["speed"]) * delta) / total_distance, 1.0)
			var flat_position: Vector2 = origin.lerp(target_center, next_progress)
			var arc_lift: float = sin(next_progress * PI) * CANNONBALL_ARC_HEIGHT
			projectiles[index]["flight_progress"] = next_progress
			projectiles[index]["position"] = flat_position + Vector2(0.0, -arc_lift)
			projectiles[index]["direction"] = (target_center - flat_position).normalized() if target_center != flat_position else Vector2.RIGHT
			if next_progress >= 1.0:
				var landing_damage: int = int(projectiles[index]["damage"])
				var landing_splash_radius: float = float(projectiles[index].get("splash_radius", 0.0))
				if landing_splash_radius > 0.0:
					_damage_enemies_in_radius(target_center, landing_splash_radius, landing_damage, Color(projectiles[index]["color"]))
					_add_explosion_effect(target_center, landing_splash_radius, Color(projectiles[index]["color"]))
					_add_hit_effect(target_center, "BOOM", Color(projectiles[index]["color"]))
					_play_sfx(explosion_sound, -7.0, randf_range(0.94, 1.02))
				else:
					if target_index != -1:
						enemies[target_index]["hp"] = int(enemies[target_index]["hp"]) - landing_damage
						enemies[target_index]["flash_timer"] = HIT_FLASH_TIME
					_add_hit_effect(target_center, "-%d" % landing_damage, Color(projectiles[index]["color"]))
				projectiles.remove_at(index)
			continue
		if to_target.length() <= float(projectiles[index]["speed"]) * delta:
			var damage_amount: int = int(projectiles[index]["damage"])
			var splash_radius: float = float(projectiles[index].get("splash_radius", 0.0))
			if splash_radius > 0.0:
				_damage_enemies_in_radius(target_center, splash_radius, damage_amount, Color(projectiles[index]["color"]))
				_add_hit_effect(target_center, "BOOM", Color(projectiles[index]["color"]))
			else:
				enemies[target_index]["hp"] = int(enemies[target_index]["hp"]) - damage_amount
				enemies[target_index]["flash_timer"] = HIT_FLASH_TIME
				_add_hit_effect(target_center, "-%d" % damage_amount, Color(projectiles[index]["color"]))
			projectiles.remove_at(index)
		else:
			projectiles[index]["position"] = projectile_pos + to_target.normalized() * float(projectiles[index]["speed"]) * delta


func _damage_enemies_in_radius(center_point: Vector2, radius: float, damage_amount: int, hit_color: Color) -> void:
	for enemy in enemies:
		var enemy_center: Vector2 = Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5
		if enemy_center.distance_to(center_point) > radius:
			continue
		enemy["hp"] = int(enemy["hp"]) - damage_amount
		enemy["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(enemy_center, "-%d" % damage_amount, hit_color)


func _add_explosion_effect(world_position: Vector2, radius: float, color: Color) -> void:
	explosion_effects.append({
		"position": world_position,
		"radius": radius,
		"time": 0.42,
		"color": color
	})


func _update_explosion_effects(delta: float) -> void:
	for index in range(explosion_effects.size() - 1, -1, -1):
		explosion_effects[index]["time"] = float(explosion_effects[index]["time"]) - delta
		if float(explosion_effects[index]["time"]) <= 0.0:
			explosion_effects.remove_at(index)


func _find_enemy_index_by_id(enemy_id: int) -> int:
	for index in range(enemies.size()):
		if int(enemies[index]["id"]) == enemy_id:
			return index
	return -1


func _show_wave_banner_for(text: String, duration: float) -> void:
	wave_banner_text = text
	wave_banner_timer = duration


func _show_wave_banner(text: String) -> void:
	_show_wave_banner_for(text, WAVE_BANNER_TIME)


func _make_flat_style(fill: Color, border: Color, border_width: int = 2, corner_radius: int = UI_PANEL_RADIUS) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	style.set_content_margin_all(10)
	return style


func _style_action_button(button: Button, accent: Color) -> void:
	button.add_theme_stylebox_override("normal", _make_flat_style(UI_PANEL_FILL_SOFT, accent, 2, 14))
	button.add_theme_stylebox_override("hover", _make_flat_style(UI_PANEL_FILL_SOFT.lightened(0.06), accent.lightened(0.08), 2, 14))
	button.add_theme_stylebox_override("pressed", _make_flat_style(UI_PANEL_FILL_SOFT.darkened(0.08), accent, 2, 14))
	button.add_theme_stylebox_override("focus", _make_flat_style(UI_PANEL_FILL_SOFT.lightened(0.04), accent.lightened(0.12), 3, 14))
	button.add_theme_stylebox_override("disabled", _make_flat_style(Color(0.08, 0.10, 0.12, 0.76), Color(1, 1, 1, 0.12), 1, 14))
	button.add_theme_color_override("font_color", TEXT_COLOR)
	button.add_theme_color_override("font_hover_color", TEXT_COLOR)
	button.add_theme_color_override("font_pressed_color", TEXT_COLOR)
	button.add_theme_color_override("font_disabled_color", MUTED_TEXT_COLOR)


func _style_text_input(line_edit: LineEdit) -> void:
	line_edit.add_theme_stylebox_override("normal", _make_flat_style(Color(0.08, 0.10, 0.12, 0.96), UI_PANEL_BORDER, 2, 12))
	line_edit.add_theme_stylebox_override("focus", _make_flat_style(Color(0.10, 0.12, 0.15, 0.98), UI_WARM_ACCENT, 2, 12))
	line_edit.add_theme_color_override("font_color", TEXT_COLOR)
	line_edit.add_theme_color_override("font_placeholder_color", MUTED_TEXT_COLOR)
	line_edit.add_theme_color_override("caret_color", UI_WARM_ACCENT)


func _draw_ui_card(rect: Rect2, accent: Color = UI_PANEL_BORDER, fill: Color = UI_PANEL_FILL, border_width: float = 2.0, shadow_offset: Vector2 = Vector2(0, 8)) -> void:
	draw_rect(Rect2(rect.position + shadow_offset, rect.size), UI_PANEL_SHADOW, true)
	draw_rect(rect, fill, true)
	draw_rect(rect, accent, false, border_width)


func _with_alpha(color: Color, alpha: float) -> Color:
	return Color(color.r, color.g, color.b, alpha)


func _draw_ui_prompt(rect: Rect2, key_text: String, body_text: String, accent: Color, icon_texture: Texture2D = null) -> void:
	_draw_ui_card(rect, accent, UI_PANEL_FILL_SOFT, 2.0, Vector2(0, 6))
	var key_rect := Rect2(rect.position + Vector2(10, 8), Vector2(30, rect.size.y - 16))
	draw_rect(key_rect, accent.darkened(0.18), true)
	draw_rect(key_rect, accent.lightened(0.10), false, 2.0)
	draw_string(ThemeDB.fallback_font, key_rect.position + Vector2(10, 21), key_text, HORIZONTAL_ALIGNMENT_LEFT, 18, 18, TEXT_COLOR)
	var text_offset_x: float = 50.0
	if icon_texture != null:
		var icon_rect := Rect2(rect.position + Vector2(48, 8), Vector2(24, 24))
		draw_texture_rect(icon_texture, icon_rect, false)
		text_offset_x = 78.0
	draw_string(
		ThemeDB.fallback_font,
		rect.position + Vector2(text_offset_x, 27),
		body_text,
		HORIZONTAL_ALIGNMENT_LEFT,
		rect.size.x - text_offset_x - 12.0,
		18,
		TEXT_COLOR
	)


func _is_swat_round() -> bool:
	return round_number >= SWAT_START_ROUND and round_number % SWAT_WAVE_FREQUENCY == 0


func _add_hit_effect(world_position: Vector2, text: String, color: Color) -> void:
	hit_effects.append({
		"position": world_position,
		"offset": Vector2.ZERO,
		"text": text,
		"color": color,
		"time": 0.55
	})


func _add_enemy_shot(start_position: Vector2, end_position: Vector2) -> void:
	enemy_shots.append({
		"start": start_position,
		"end": end_position,
		"time": 0.14
	})


func _enemy_center(enemy: Dictionary) -> Vector2:
	return Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5


func _side_spawn_position(lane: String, enemy_size: Vector2) -> Vector2:
	var spawn_row: int = randi_range(SIDE_SPAWN_ROW_RANGE.x, SIDE_SPAWN_ROW_RANGE.y)
	var spawn_y: float = _cell_center(Vector2i(0, spawn_row)).y - enemy_size.y * 0.5
	var spawn_x: float = GRID_ORIGIN.x - SIDE_SPAWN_OFFSET_X if lane == "left" else GRID_ORIGIN.x + GRID_SIZE.x * CELL_SIZE + SIDE_SPAWN_OFFSET_X - enemy_size.x
	return Vector2(spawn_x, spawn_y)


func _get_structure_on_cell(cell: Vector2i) -> Dictionary:
	var key := _cell_key(cell)
	if structures.has(key):
		return structures[key]
	return {}


func _cell_to_world(cell: Vector2i) -> Vector2:
	return GRID_ORIGIN + Vector2(cell.x, cell.y) * CELL_SIZE


func _cave_active() -> bool:
	return inside_cave and cave_mode_token


func _cell_center(cell: Vector2i) -> Vector2:
	return _cell_to_world(cell) + Vector2.ONE * CELL_SIZE * 0.5


func _cell_key(cell: Vector2i) -> String:
	return "%s:%s" % [cell.x, cell.y]


func _draw_grid() -> void:
	var visible_start_y: int = maxi(0, int(floor(camera_position.y / CELL_SIZE)) - 1)
	var visible_end_y: int = int(ceil((camera_position.y + SCREEN_SIZE.y) / CELL_SIZE)) + 1
	for y in range(visible_start_y, visible_end_y):
		for x in range(GRID_SIZE.x):
			var cell := Vector2i(x, y)
			var world_rect := Rect2(_cell_to_world(cell), Vector2.ONE * CELL_SIZE)
			if cell in HOUSE_BLOCK_CELLS:
				continue
			var should_draw_outline := false
			if cell in LEFT_BUILD_YARD or cell in RIGHT_BUILD_YARD:
				should_draw_outline = true
			if _cell_is_path(cell):
				_draw_world_rect(world_rect, PATH_COLOR)
				should_draw_outline = true
			if should_draw_outline:
				var outline_color: Color = Color(0.62, 0.68, 0.74, 0.82) if (cell in LEFT_BUILD_YARD or cell in RIGHT_BUILD_YARD) else GRID_LINE_COLOR
				draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), outline_color, false, 2.0)


func _draw_world_callouts() -> void:
	if phase != Phase.BUILD or inside_house or inside_cave or dealer_menu_open or build_menu_open:
		return
	var tutorial_round: bool = round_number <= 2
	var help_active: bool = tutorial_round or house_damage_stage > 0 or _is_player_near_dealer_stand() or _is_player_near_cave_entrance()
	if not help_active:
		return
	if tutorial_round and not tutorial_built_once:
		_draw_world_callout(_cell_center(HOUSE_CELL) + Vector2(0, -102), "House\nProtect this", Color(0.98, 0.88, 0.70, 0.96))
		_draw_world_callout(_cell_center(Vector2i(6, 5)) + Vector2(0, -12), "Build here", Color(0.72, 0.90, 1.0, 0.92))
		_draw_world_callout(_cell_center(Vector2i(17, 5)) + Vector2(0, -12), "Build here", Color(0.72, 0.90, 1.0, 0.92))
	if not tutorial_opened_dealer and (tutorial_round or _is_player_near_dealer_stand()):
		_draw_world_callout(_cell_center(DEALER_STAND_CELL) + Vector2(0, -58), "Dealer\nAmmo, buffs, buying, selling", Color(0.98, 0.84, 0.48, 0.96))
	if not tutorial_entered_cave and (tutorial_round or _is_player_near_cave_entrance()):
		_draw_world_callout(_cell_center(CAVE_ENTRANCE_CELL) + Vector2(0, -58), "Cave\nRare loot and upgrades", Color(0.78, 0.72, 1.0, 0.96))
	if house_damage_stage > 0 and not tutorial_repaired_house:
		_draw_world_callout(_cell_center(HOUSE_CELL) + Vector2(82, -20), "Repair here", Color(0.74, 0.98, 0.74, 0.96))
	var wood_label_drawn: bool = false
	var stone_label_drawn: bool = false
	for node in resource_nodes:
		if not tutorial_round:
			break
		if int(node.get("remaining", 0)) <= 0:
			continue
		var node_cell: Vector2i = Vector2i(node["cell"])
		if node_cell.y >= FOREST_START_ROW + SHALLOW_RESOURCE_BAND_ROWS:
			continue
		var node_center: Vector2 = _cell_center(node_cell)
		if not _is_world_point_visible(node_center):
			continue
		var node_kind: String = String(node.get("kind", "wood"))
		if node_kind == "wood" and not wood_label_drawn and not tutorial_got_wood:
			_draw_world_callout(node_center + Vector2(0, -54), "Tree = wood", Color(0.72, 0.96, 0.70, 0.92))
			wood_label_drawn = true
		elif node_kind == "stone" and not stone_label_drawn and not tutorial_got_stone:
			_draw_world_callout(node_center + Vector2(0, -54), "Rock = stone", Color(0.86, 0.90, 0.98, 0.92))
			stone_label_drawn = true
		if (wood_label_drawn or tutorial_got_wood) and (stone_label_drawn or tutorial_got_stone):
			break


func _draw_world_callout(world_position: Vector2, text: String, accent: Color) -> void:
	if not _is_world_point_visible(world_position):
		return
	var lines: PackedStringArray = text.split("\n")
	var longest_line_width: float = 0.0
	for line in lines:
		longest_line_width = maxf(longest_line_width, ThemeDB.fallback_font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x)
	var card_size := Vector2(maxf(92.0, longest_line_width + 20.0), 16.0 + lines.size() * 18.0)
	var screen_position: Vector2 = world_position - camera_position - Vector2(card_size.x * 0.5, card_size.y)
	var card_rect := Rect2(screen_position, card_size)
	draw_rect(card_rect, Color(0.04, 0.06, 0.08, 0.84), true)
	draw_rect(card_rect, accent, false, 2.0)
	for line_index in range(lines.size()):
		draw_string(
			ThemeDB.fallback_font,
			card_rect.position + Vector2(10, 20 + line_index * 18),
			lines[line_index],
			HORIZONTAL_ALIGNMENT_LEFT,
			card_rect.size.x - 18.0,
			16,
			Color(1.0, 0.98, 0.94)
		)


func _is_world_point_visible(world_position: Vector2) -> bool:
	return Rect2(camera_position - Vector2(96, 96), SCREEN_SIZE + Vector2(192, 192)).has_point(world_position)


func _draw_side_spawn_warnings() -> void:
	if phase != Phase.DEFEND or inside_house or inside_cave:
		return
	var left_count: int = _upcoming_spawn_count("left", SPAWN_WARNING_LOOKAHEAD)
	var right_count: int = _upcoming_spawn_count("right", SPAWN_WARNING_LOOKAHEAD)
	var left_pressure: bool = left_count > 0 or _lane_has_enemy_inbound("left")
	var right_pressure: bool = right_count > 0 or _lane_has_enemy_inbound("right")
	if left_pressure:
		_draw_side_warning_card("left", left_count)
	if right_pressure:
		_draw_side_warning_card("right", right_count)


func _draw_side_warning_card(lane: String, count: int) -> void:
	var card_rect := Rect2(Vector2(20, 250), Vector2(172, 82)) if lane == "left" else Rect2(Vector2(1088, 250), Vector2(172, 82))
	var accent: Color = Color(0.98, 0.48, 0.34, 0.94) if count > 1 else Color(0.98, 0.76, 0.40, 0.94)
	draw_rect(card_rect, Color(0.07, 0.08, 0.10, 0.88), true)
	draw_rect(card_rect, accent, false, 3.0)
	var direction_text: String = "LEFT SIDE" if lane == "left" else "RIGHT SIDE"
	draw_string(ThemeDB.fallback_font, card_rect.position + Vector2(18, 28), direction_text, HORIZONTAL_ALIGNMENT_LEFT, 132, 22, Color(1.0, 0.96, 0.92))
	var count_text: String = "%d incoming" % count if count > 0 else "Enemies pushing in"
	draw_string(ThemeDB.fallback_font, card_rect.position + Vector2(18, 52), count_text, HORIZONTAL_ALIGNMENT_LEFT, 136, 18, MUTED_TEXT_COLOR)
	var arrow_base: Vector2 = card_rect.position + Vector2(146, 42) if lane == "left" else card_rect.position + Vector2(26, 42)
	var arrow_sign: float = 1.0 if lane == "left" else -1.0
	draw_line(arrow_base - Vector2(18 * arrow_sign, 0), arrow_base + Vector2(12 * arrow_sign, 0), accent, 4.0)
	draw_line(arrow_base + Vector2(12 * arrow_sign, 0), arrow_base + Vector2(2 * arrow_sign, -10), accent, 4.0)
	draw_line(arrow_base + Vector2(12 * arrow_sign, 0), arrow_base + Vector2(2 * arrow_sign, 10), accent, 4.0)


func _upcoming_spawn_count(lane: String, lookahead: float) -> int:
	var count: int = 0
	for spawn_index in range(enemy_spawn_index, spawn_queue.size()):
		var spawn_data: Dictionary = spawn_queue[spawn_index]
		if String(spawn_data.get("lane", "")) != lane:
			continue
		var time_until_spawn: float = float(spawn_data.get("time", 0.0)) - defend_elapsed
		if time_until_spawn < 0.0:
			continue
		if time_until_spawn > lookahead:
			continue
		count += 1
	return count


func _lane_has_enemy_inbound(lane: String) -> bool:
	for enemy in enemies:
		if String(enemy.get("lane", "")) != lane:
			continue
		if bool(enemy.get("approaching_entry", false)):
			return true
	return false


func _draw_waving_grass() -> void:
	var visible_start_y: int = maxi(0, int(floor(camera_position.y / CELL_SIZE)) - 1)
	var visible_end_y: int = int(ceil((camera_position.y + SCREEN_SIZE.y) / CELL_SIZE)) + 1
	for y in range(visible_start_y, visible_end_y):
		for x in range(GRID_SIZE.x):
			var cell := Vector2i(x, y)
			if _cell_is_path(cell) or cell in HOUSE_BLOCK_CELLS:
				continue
			var base_world := _cell_to_world(cell)
			var patch_seed := (x * 31 + y * 17) % 11
			var sway_phase: float = float((x * 19 + y * 23) % 29) * 0.17
			var sway: float = sin(world_time * 1.9 + sway_phase) * 2.2
			var draw_pos := base_world + Vector2(11 + sway, 30 + patch_seed % 4) - camera_position
			if decor_sprite_texture != null:
				var use_sunflowers := cell.y < 9 and patch_seed in [0, 5]
				var decor_region := DECOR_SUNFLOWER_REGION if use_sunflowers else DECOR_GRASS_REGION
				var decor_size := DECOR_SUNFLOWER_DRAW_SIZE if use_sunflowers else DECOR_GRASS_DRAW_SIZE
				draw_texture_rect_region(
					decor_sprite_texture,
					Rect2(draw_pos, decor_size),
					decor_region
				)
			else:
				var blade_color := WOODS_COLOR.lightened(0.16) if cell.y >= 9 else GRASS_COLOR.lightened(0.22)
				for blade_index in range(3):
					var blade_base := base_world + Vector2(10 + blade_index * 11, 38 + int((x + y + blade_index) % 4))
					var phase_offset := float(x * 13 + y * 7 + blade_index * 19) * 0.11
					var blade_sway := sin(world_time * 2.4 + phase_offset) * (4.0 + blade_index)
					var blade_tip := blade_base + Vector2(blade_sway, -10.0 - blade_index * 2.0)
					draw_line(blade_base - camera_position, blade_tip - camera_position, blade_color, 2.0)


func _draw_house() -> void:
	var house_rect := Rect2(_cell_center(HOUSE_CELL) - Vector2(44, 34), Vector2(88, 68))
	var body_color := HOUSE_DANGER_COLOR if house_flash_timer > 0.0 else HOUSE_COLOR
	_draw_world_rect(house_rect, body_color)
	var roof_left := house_rect.position + Vector2(-8, 12)
	var roof_peak := house_rect.position + Vector2(house_rect.size.x * 0.5, -20)
	var roof_right := house_rect.position + Vector2(house_rect.size.x + 8, 12)
	draw_colored_polygon(PackedVector2Array([
		roof_left - camera_position,
		roof_peak - camera_position,
		roof_right - camera_position
	]), ROOF_COLOR)
	var door_rect := Rect2(house_rect.position + Vector2(house_rect.size.x * 0.5 - 10, house_rect.size.y - 24), Vector2(20, 24))
	_draw_world_rect(door_rect, Color(0.28, 0.20, 0.16))
	var left_window := Rect2(house_rect.position + Vector2(12, 18), Vector2(14, 12))
	var right_window := Rect2(house_rect.position + Vector2(house_rect.size.x - 26, 18), Vector2(14, 12))
	_draw_world_rect(left_window, Color(0.67, 0.84, 0.92))
	_draw_world_rect(right_window, Color(0.67, 0.84, 0.92))
	_draw_house_damage_overlay(house_rect)
	_draw_house_repair_marker(house_rect)


func _current_house_texture() -> Texture2D:
	return null


func _draw_house_damage_overlay(house_rect: Rect2) -> void:
	if house_damage_stage <= 0:
		return
	var pulse := 0.35 + 0.25 * sin(world_time * 3.4)
	var warning_color := Color(0.95, 0.46, 0.28, 0.42 + pulse * 0.18)
	draw_rect(Rect2(house_rect.position - camera_position, house_rect.size), warning_color, false, 4.0)
	if house_damage_stage >= 3:
		draw_rect(Rect2(house_rect.position - camera_position, house_rect.size), Color(0.82, 0.18, 0.14, 0.08 + pulse * 0.08), true)


func _draw_house_repair_marker(house_rect: Rect2) -> void:
	if phase != Phase.BUILD or house_damage_stage <= 0 or inside_house or inside_cave:
		return
	var marker_center := house_rect.position + Vector2(house_rect.size.x * 0.78, house_rect.size.y * 0.46)
	var pulse := 0.5 + 0.5 * sin(world_time * 4.2)
	draw_circle(marker_center - camera_position, 18.0 + pulse * 3.0, Color(0.10, 0.14, 0.10, 0.82))
	draw_arc(marker_center - camera_position, 18.0 + pulse * 3.0, 0.0, TAU, 24, Color(0.78, 0.96, 0.72, 0.80), 3.0, true)
	if wrench_texture != null:
		draw_texture_rect(
			wrench_texture,
			Rect2(marker_center - camera_position - Vector2(14, 14), Vector2(28, 28)),
			false
		)
	draw_string(
		ThemeDB.fallback_font,
		marker_center - camera_position + Vector2(-24, 30),
		"H Repair",
		HORIZONTAL_ALIGNMENT_LEFT,
		72,
		16,
		Color(0.96, 0.98, 0.92)
	)


func _draw_backyard_fence(base_rect: Rect2) -> void:
	if backyard_fence_texture == null:
		return
	var fence_size := Vector2(80, 32)
	var fence_y: float = base_rect.position.y - 6.0
	for segment_index in range(3):
		var left_position := base_rect.position + Vector2(-94 + segment_index * 78, -8)
		draw_texture_rect(
			backyard_fence_texture,
			Rect2(left_position - camera_position, fence_size),
			false
		)
	for segment_index in range(3):
		var right_position := Vector2(base_rect.end.x + 12 + segment_index * 78, fence_y)
		draw_texture_rect(
			backyard_fence_texture,
			Rect2(right_position - camera_position, fence_size),
			false
		)


func _draw_dealer_stand() -> void:
	if inside_house or inside_cave:
		return
	var stand_rect: Rect2 = _dealer_stand_rect()
	var bob_offset: float = sin(world_time * 2.2 + stand_rect.position.x * 0.03) * 3.0
	var shadow_rect := Rect2(stand_rect.position + Vector2(-14, 36), Vector2(80, 18))
	draw_rect(Rect2(shadow_rect.position - camera_position, shadow_rect.size), Color(0.02, 0.03, 0.04, 0.34), true)
	var rug_rect := Rect2(stand_rect.position + Vector2(-12, 28), Vector2(74, 18))
	_draw_world_rect(rug_rect, Color(0.26, 0.12, 0.08))
	draw_rect(Rect2(rug_rect.position - camera_position, rug_rect.size), Color(0.76, 0.62, 0.36, 0.55), false, 2.0)
	var counter_rect := Rect2(stand_rect.position + Vector2(-6, 18), Vector2(56, 16))
	_draw_world_rect(counter_rect, Color(0.34, 0.20, 0.11))
	draw_rect(Rect2(counter_rect.position - camera_position, counter_rect.size), Color(0.62, 0.48, 0.28, 0.65), false, 2.0)
	var sign_rect := Rect2(stand_rect.position + Vector2(-16, -40), Vector2(72, 18))
	_draw_world_rect(sign_rect, Color(0.16, 0.11, 0.08))
	draw_rect(Rect2(sign_rect.position - camera_position, sign_rect.size), Color(0.90, 0.76, 0.42, 0.55), false, 2.0)
	draw_string(ThemeDB.fallback_font, sign_rect.position + Vector2(8, 13) - camera_position, "SUPPLIES", HORIZONTAL_ALIGNMENT_LEFT, 80, 12, Color(0.97, 0.92, 0.80))
	var crate_left := Rect2(stand_rect.position + Vector2(-20, 20), Vector2(16, 18))
	var crate_right := Rect2(stand_rect.position + Vector2(50, 22), Vector2(14, 16))
	_draw_world_rect(crate_left, Color(0.40, 0.26, 0.14))
	_draw_world_rect(crate_right, Color(0.40, 0.26, 0.14))
	draw_line(crate_left.position - camera_position, crate_left.end - camera_position, Color(0.62, 0.48, 0.28, 0.65), 1.0)
	draw_line(Vector2(crate_left.end.x, crate_left.position.y) - camera_position, Vector2(crate_left.position.x, crate_left.end.y) - camera_position, Color(0.62, 0.48, 0.28, 0.65), 1.0)
	draw_string(ThemeDB.fallback_font, stand_rect.position + Vector2(-12, -28) - camera_position, "Arms Dealer", HORIZONTAL_ALIGNMENT_LEFT, 120, 14, TEXT_COLOR)
	draw_circle(stand_rect.position + Vector2(18, -10) - camera_position, 4.0 + absf(sin(world_time * 3.2)) * 2.0, Color(0.98, 0.84, 0.34, 0.55))


func _draw_resources() -> void:
	var visible_start_y: int = maxi(0, int(floor(camera_position.y / CELL_SIZE)) - 2)
	var visible_end_y: int = int(ceil((camera_position.y + SCREEN_SIZE.y) / CELL_SIZE)) + 2
	for index in range(resource_nodes.size()):
		var node := resource_nodes[index]
		var node_cell := Vector2i(node["cell"])
		if node_cell.y < visible_start_y or node_cell.y > visible_end_y:
			continue
		var node_rect := _resource_node_rect(node)
		var node_kind := String(node["kind"])
		var node_color := WOOD_NODE_COLOR if node_kind == "wood" else STONE_NODE_COLOR
		if node_kind == "wood":
			if forest_tree_texture != null and int(node["remaining"]) > 0:
				var tree_draw_rect := Rect2(_cell_to_world(node["cell"]) + Vector2(-42, -100), FOREST_TREE_DRAW_SIZE)
				draw_texture_rect(
					forest_tree_texture,
					Rect2(tree_draw_rect.position - camera_position, tree_draw_rect.size),
					false
				)
			elif tree_trunk_texture != null:
				var trunk_draw_rect := Rect2(_cell_to_world(node["cell"]) + Vector2(8, 16), Vector2(34, 34))
				draw_texture_rect(
					tree_trunk_texture,
					Rect2(trunk_draw_rect.position - camera_position, trunk_draw_rect.size),
					false
				)
			else:
				var trunk := Rect2(_cell_to_world(node["cell"]) + Vector2(20, 24), Vector2(8, 18))
				var leaves_color := node_color if int(node["remaining"]) > 0 else Color(0.31, 0.34, 0.26)
				var leaves := Rect2(_cell_to_world(node["cell"]) + Vector2(6, 2), Vector2(36, 28))
				_draw_world_rect(trunk, Color(0.38, 0.24, 0.16))
				_draw_world_rect(leaves, leaves_color)
				if int(node["remaining"]) <= 0:
					_draw_world_rect(Rect2(_cell_to_world(node["cell"]) + Vector2(14, 30), Vector2(20, 10)), Color(0.42, 0.30, 0.18))
		else:
			var rock_variant := (node_cell.x + node_cell.y) % 3
			if rock_variant == 0 and rock_big_texture != null:
				draw_texture_rect(
					rock_big_texture,
					Rect2(_cell_to_world(node["cell"]) + Vector2(9, 14) - camera_position, ROCK_BIG_DRAW_SIZE),
					false
				)
			elif rock_variant == 1 and rock_medium_texture != null:
				draw_texture_rect(
					rock_medium_texture,
					Rect2(_cell_to_world(node["cell"]) + Vector2(11, 20) - camera_position, ROCK_MEDIUM_DRAW_SIZE),
					false
				)
			elif rock_small_texture != null:
				draw_texture_rect(
					rock_small_texture,
					Rect2(_cell_to_world(node["cell"]) + Vector2(15, 24) - camera_position, ROCK_SMALL_DRAW_SIZE),
					false
				)
			else:
				_draw_world_rect(node_rect, node_color)
		var charges := int(node["remaining"])
		for pip in range(charges):
			_draw_world_rect(Rect2(node_rect.position + Vector2(4 + pip * 6, -8), Vector2(4, 4)), node_color.lightened(0.2))
		if index == harvesting_node_index:
			var progress := harvest_timer / _current_gather_time()
			draw_rect(Rect2(node_rect.position - camera_position + Vector2(0, -14), Vector2(36 * progress, 5)), node_color.lightened(0.35), true)
			draw_rect(Rect2(node_rect.position - camera_position + Vector2(-2, -2), node_rect.size + Vector2(4, 4)), Color(1, 1, 1, 0.65), false, 2.0)
	var cave_rect := Rect2(_cell_to_world(CAVE_ENTRANCE_CELL) + Vector2(2, 2), Vector2(44, 44))
	if cave_entrance_texture != null:
		draw_texture_rect(
			cave_entrance_texture,
			Rect2(cave_rect.position + Vector2(-10, -18) - camera_position, Vector2(64, 72)),
			false
		)
	else:
		_draw_world_rect(cave_rect, Color(0.12, 0.11, 0.10))
		_draw_world_rect(Rect2(cave_rect.position + Vector2(8, 10), Vector2(28, 24)), Color(0.04, 0.04, 0.05))
		draw_rect(Rect2(cave_rect.position - camera_position, cave_rect.size), Color(0.46, 0.38, 0.28), false, 2.0)


func _draw_forest_animals() -> void:
	if inside_house or inside_cave:
		return
	var visible_top: float = camera_position.y - 96.0
	var visible_bottom: float = camera_position.y + SCREEN_SIZE.y + 96.0
	for animal in forest_animals:
		var animal_position: Vector2 = Vector2(animal["position"])
		if animal_position.y < visible_top or animal_position.y > visible_bottom:
			continue
		var animal_kind: String = String(animal.get("kind", "dog"))
		var animal_texture: Texture2D = _forest_animal_texture(animal_kind)
		var animal_size: Vector2 = _forest_animal_draw_size(animal_kind)
		var animal_sway: float = sin(world_time * 3.0 + float(animal.get("bob_phase", 0.0))) * 1.6
		var animal_draw_rect: Rect2 = Rect2(animal_position + Vector2(-animal_size.x * 0.5, -animal_size.y + 8.0), animal_size)
		var shadow_rect: Rect2 = Rect2(animal_position + Vector2(-animal_size.x * 0.28, 6.0), Vector2(animal_size.x * 0.56, 12.0))
		draw_rect(Rect2(shadow_rect.position - camera_position, shadow_rect.size), Color(0.02, 0.03, 0.04, 0.18), true)
		if animal_texture != null:
			var facing_left: bool = bool(animal.get("facing_left", false))
			draw_set_transform(animal_draw_rect.position - camera_position + animal_draw_rect.size * 0.5 + Vector2(animal_sway * 0.2, 0.0), 0.0, Vector2(-1.0 if facing_left else 1.0, 1.0))
			draw_texture_rect(animal_texture, Rect2(-animal_draw_rect.size * 0.5, animal_draw_rect.size), false)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_rect(Rect2(animal_draw_rect.position - camera_position, animal_draw_rect.size), Color(0.74, 0.62, 0.36), true)


func _forest_animal_texture(animal_kind: String) -> Texture2D:
	if animal_kind == "beaver":
		return forest_beaver_texture
	return forest_dog_texture


func _forest_animal_draw_size(animal_kind: String) -> Vector2:
	if animal_kind == "beaver":
		return FOREST_BEAVER_DRAW_SIZE
	return FOREST_DOG_DRAW_SIZE


func _count_active_resources_in_band(max_row: int) -> int:
	var count := 0
	for node in resource_nodes:
		var node_cell := Vector2i(node["cell"])
		if node_cell.y > max_row:
			continue
		if int(node["remaining"]) > 0:
			count += 1
	return count


func _draw_trees() -> void:
	return


func _draw_structures() -> void:
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		var cell := Vector2i(structure["cell"])
		var structure_rect := Rect2(_cell_to_world(cell) + Vector2(8, 8), Vector2(32, 32))
		var flash := float(structure.get("flash_timer", 0.0)) > 0.0
		match int(structure["type"]):
			StructureType.TURRET:
				var turret_center := _cell_center(cell) - camera_position
				var aim_direction: Vector2 = structure["aim_direction"]
				var weapon: String = String(structure.get("weapon", "arrow"))
				var build_remaining: float = float(structure.get("build_time", 0.0))
				var has_turret_visual: bool = turret_visual_nodes.has(structure_key)
				draw_circle(turret_center + Vector2(0, 18), 16.0, Color(0.02, 0.03, 0.04, 0.28))
				if build_remaining > 0.0:
					var build_total: float = max(0.01, float(structure.get("build_total", TURRET_BUILD_TIME)))
					var build_progress: float = clampf(1.0 - build_remaining / build_total, 0.0, 1.0)
					draw_rect(Rect2(structure_rect.position - camera_position, structure_rect.size), Color(0.08, 0.10, 0.12, 0.26), false, 2.0)
					draw_rect(Rect2(structure_rect.position - camera_position + Vector2(0, -10), Vector2(structure_rect.size.x * build_progress, 6)), Color(0.78, 0.96, 0.68, 0.95), true)
					draw_rect(Rect2(structure_rect.position - camera_position + Vector2(0, -10), Vector2(structure_rect.size.x, 6)), Color(1, 1, 1, 0.22), false, 1.0)
					continue
				if not has_turret_visual and weapon == "cannon" and cannon_turret_texture != null:
					var cannon_draw_rect := Rect2(turret_center - Vector2(CANNON_TURRET_DRAW_SIZE.x * 0.5, CANNON_TURRET_DRAW_SIZE.y * 0.5) + Vector2(0, -10), CANNON_TURRET_DRAW_SIZE)
					draw_texture_rect_region(cannon_turret_texture, cannon_draw_rect, CANNON_TURRET_REGION)
					if flash:
						draw_rect(cannon_draw_rect, Color(1, 1, 1, 0.18), true)
				elif not has_turret_visual and weapon == "golden" and golden_turret_texture != null:
					var golden_draw_rect := Rect2(turret_center - Vector2(GOLDEN_TURRET_DRAW_SIZE.x * 0.5, GOLDEN_TURRET_DRAW_SIZE.y * 0.5) + Vector2(0, -8), GOLDEN_TURRET_DRAW_SIZE)
					draw_texture_rect_region(golden_turret_texture, golden_draw_rect, GOLDEN_TURRET_REGION)
					if flash:
						draw_rect(golden_draw_rect, Color(1, 1, 1, 0.18), true)
				elif not has_turret_visual and weapon == "gun":
					if gun_turret_texture != null:
						var gun_draw_rect := Rect2(turret_center - Vector2(49, 64), Vector2(98, 98))
						draw_texture_rect(gun_turret_texture, gun_draw_rect, false)
						if flash:
							draw_rect(gun_draw_rect, Color(1, 1, 1, 0.18), true)
					else:
						_draw_simple_gun_turret(turret_center, aim_direction, flash)
				elif not has_turret_visual and weapon == "magic" and crystal_sentry_texture != null:
					var magic_draw_rect := Rect2(turret_center - Vector2(MAGIC_TURRET_DRAW_SIZE.x * 0.5, MAGIC_TURRET_DRAW_SIZE.y * 0.68), MAGIC_TURRET_DRAW_SIZE)
					draw_texture_rect(crystal_sentry_texture, magic_draw_rect, false)
					if flash:
						draw_rect(magic_draw_rect, Color(1, 1, 1, 0.18), true)
				elif not has_turret_visual and turret_sprite_texture != null:
					var turret_rotation := aim_direction.angle()
					var reload_progress: float = _turret_reload_progress(structure)
					var loaded_frame := bool(structure["has_target"]) and reload_progress >= 0.72
					var turret_region := TURRET_LOADED_REGION if loaded_frame else TURRET_IDLE_REGION
					var recoil_offset := -aim_direction * (1.0 - reload_progress) * 7.0
					var draw_scale := Vector2.ONE * (0.94 + reload_progress * 0.06)
					draw_set_transform(turret_center, turret_rotation, Vector2.ONE)
					draw_texture_rect_region(
						turret_sprite_texture,
						Rect2(-TURRET_DRAW_SIZE * 0.5 + recoil_offset, TURRET_DRAW_SIZE * draw_scale),
						turret_region
					)
					if flash:
						draw_rect(Rect2(-TURRET_DRAW_SIZE * 0.5 + recoil_offset, TURRET_DRAW_SIZE * draw_scale), Color(1, 1, 1, 0.18), true)
					draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				elif not has_turret_visual:
					_draw_world_rect(structure_rect, TURRET_COLOR.lightened(0.3) if flash else TURRET_COLOR)
				var arrow_length := 18.0
				var arrow_tip := turret_center + aim_direction * arrow_length
				var arrow_side := Vector2(-aim_direction.y, aim_direction.x) * 4.0
				var arrow_color := _turret_projectile_color(structure) if bool(structure["has_target"]) else Color(0.62, 0.64, 0.68, 0.72)
				draw_line(turret_center + aim_direction * 2.0, arrow_tip, arrow_color, 2.0)
				if bool(structure["has_target"]):
					draw_colored_polygon(PackedVector2Array([
						arrow_tip,
						arrow_tip - aim_direction * 6.0 + arrow_side,
						arrow_tip - aim_direction * 6.0 - arrow_side
					]), arrow_color)
				if weapon == "cannon":
					draw_circle(turret_center + aim_direction * 8.0, 4.0, Color(0.24, 0.22, 0.18, 0.95))
				_draw_turret_status_badges(structure, turret_center, weapon)
			StructureType.WALL_LIGHT:
				_draw_wall_visual(structure_rect, LIGHT_WALL_COLOR.lightened(0.25) if flash else LIGHT_WALL_COLOR, int(structure["hp"]), WALL_LIGHT_HP)
			StructureType.WALL_MEDIUM:
				_draw_wall_visual(structure_rect, MEDIUM_WALL_COLOR.lightened(0.25) if flash else MEDIUM_WALL_COLOR, int(structure["hp"]), WALL_MEDIUM_HP)
			StructureType.WALL_HEAVY:
				_draw_wall_visual(structure_rect, HEAVY_WALL_COLOR.lightened(0.25) if flash else HEAVY_WALL_COLOR, int(structure["hp"]), WALL_HEAVY_HP)
		if phase == Phase.BUILD and cell == selected_cell:
			_draw_wall_repair_marker(structure, cell)


func _draw_enemies() -> void:
	for corpse in enemy_corpses:
		var corpse_pos: Vector2 = Vector2(corpse["position"])
		var corpse_size: Vector2 = Vector2(corpse["size"])
		var corpse_time: float = float(corpse.get("time", 0.0))
		var corpse_texture: Texture2D = _current_robot_death_texture(corpse_time)
		var corpse_alpha: float = clampf(1.0 - maxf(0.0, corpse_time - ROBOT_DEATH_FRAME_TIME * 3.0) / max(0.01, ROBOT_DEATH_LINGER_TIME), 0.0, 1.0)
		var corpse_draw_rect := Rect2(corpse_pos + corpse_size * 0.5 - IRS_BRUTE_DRAW_SIZE * 0.5 - camera_position, IRS_BRUTE_DRAW_SIZE)
		if corpse_texture != null:
			draw_texture_rect(corpse_texture, corpse_draw_rect, false, Color(1, 1, 1, corpse_alpha))
		else:
			draw_rect(corpse_draw_rect, Color(0.42, 0.12, 0.14, corpse_alpha), true)
	for enemy in enemies:
		var enemy_type := String(enemy["type"])
		var enemy_color := RUNNER_COLOR if enemy_type == "runner" else BRUTE_COLOR
		if enemy_type == "swat":
			enemy_color = SWAT_COLOR
		if float(enemy.get("flash_timer", 0.0)) > 0.0:
			enemy_color = enemy_color.lightened(0.35)
		var enemy_rect := Rect2(enemy["position"], enemy["size"])
		var enemy_has_visual: bool = enemy_visual_nodes.has(int(enemy.get("id", -1)))
		if not enemy_has_visual and enemy_type == "runner" and irs_agent_body_texture != null:
			var lane_sign := -1.0 if String(enemy["lane"]) == "left" else 1.0
			var runner_run_texture: Texture2D = _current_runner_texture()
			var runner_draw_rect := Rect2(
				enemy_rect.position + enemy_rect.size * 0.5 - IRS_AGENT_DRAW_SIZE * 0.5 - camera_position + Vector2(0, -8),
				IRS_AGENT_DRAW_SIZE
			)
			if runner_run_texture != null:
				draw_set_transform(runner_draw_rect.position + runner_draw_rect.size * 0.5, 0.0, Vector2(-1.0 if lane_sign < 0.0 else 1.0, 1.0))
				draw_texture_rect(runner_run_texture, Rect2(-runner_draw_rect.size * 0.5, runner_draw_rect.size), false)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				draw_set_transform(runner_draw_rect.position + runner_draw_rect.size * 0.5, 0.0, Vector2(-1.0 if lane_sign < 0.0 else 1.0, 1.0))
				draw_texture_rect_region(irs_agent_body_texture, Rect2(-runner_draw_rect.size * 0.5, runner_draw_rect.size), IRS_AGENT_BODY_REGION)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				var gun_rotation := 0.18 * lane_sign
				var gun_pivot := runner_draw_rect.position + Vector2(IRS_AGENT_DRAW_SIZE.x * 0.5 + 4.0 * lane_sign, IRS_AGENT_DRAW_SIZE.y * 0.56)
				draw_set_transform(gun_pivot, gun_rotation, Vector2.ONE)
				if irs_agent_gun_texture != null:
					draw_texture_rect_region(
						irs_agent_gun_texture,
						Rect2(Vector2(-IRS_AGENT_GUN_DRAW_SIZE.x * 0.5, -IRS_AGENT_GUN_DRAW_SIZE.y * 0.5), IRS_AGENT_GUN_DRAW_SIZE),
						IRS_AGENT_GUN_REGION
					)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			if float(enemy.get("flash_timer", 0.0)) > 0.0:
				draw_rect(runner_draw_rect, Color(1, 1, 1, 0.16), true)
		elif not enemy_has_visual and enemy_type == "swat" and swat_texture != null:
			var swat_draw_rect := Rect2(
				enemy_rect.position + enemy_rect.size * 0.5 - SWAT_DRAW_SIZE * 0.5 - camera_position + Vector2(0, -8 + sin(world_time * 8.0 + enemy_rect.position.x * 0.03) * 2.5),
				SWAT_DRAW_SIZE
			)
			draw_set_transform(swat_draw_rect.position + swat_draw_rect.size * 0.5, 0.0, Vector2(-1.0 if String(enemy.get("lane", "left")) == "left" else 1.0, 1.0))
			draw_texture_rect(swat_texture, Rect2(-swat_draw_rect.size * 0.5, swat_draw_rect.size), false)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			if float(enemy.get("flash_timer", 0.0)) > 0.0:
				draw_rect(swat_draw_rect, Color(1, 1, 1, 0.18), true)
		elif not enemy_has_visual and irs_robot_texture != null:
			var enemy_draw_size := IRS_ROBOT_DRAW_SIZE if enemy_type == "runner" else IRS_BRUTE_DRAW_SIZE
			var enemy_draw_rect := Rect2(
				enemy_rect.position + enemy_rect.size * 0.5 - enemy_draw_size * 0.5 - camera_position,
				enemy_draw_size
			)
			draw_texture_rect(
				_current_robot_walk_texture(),
				enemy_draw_rect,
				false
			)
			if enemy_type == "brute":
				draw_rect(enemy_draw_rect, Color(0.40, 0.16, 0.52, 0.18), true)
			if float(enemy.get("flash_timer", 0.0)) > 0.0:
				draw_rect(enemy_draw_rect, Color(1, 1, 1, 0.20), true)
		elif not enemy_has_visual:
			_draw_world_rect(enemy_rect, enemy_color)
		var attack_windup_ratio: float = clampf(float(enemy.get("attack_windup", 0.0)) / max(0.01, ENEMY_ATTACK_WINDUP), 0.0, 1.0)
		if attack_windup_ratio > 0.0 and not bool(enemy.get("approaching_entry", false)):
			var telegraph_center: Vector2 = enemy_rect.position + enemy_rect.size * 0.5 - camera_position
			var telegraph_pulse: float = 0.45 + 0.55 * abs(sin((1.0 - attack_windup_ratio) * 12.0))
			var telegraph_radius: float = enemy_rect.size.x * 0.65 + (1.0 - attack_windup_ratio) * 10.0
			draw_arc(telegraph_center, telegraph_radius, 0.0, TAU, 18, Color(1.0, 0.42, 0.30, 0.48 + telegraph_pulse * 0.28), 3.0, true)
			draw_string(ThemeDB.fallback_font, telegraph_center + Vector2(-6, -18), "!", HORIZONTAL_ALIGNMENT_LEFT, 16, 18, Color(1.0, 0.94, 0.84))
		var hp_ratio: float = clampf(float(enemy["hp"]) / max(1.0, float(enemy.get("max_hp", enemy["hp"]))), 0.0, 1.0)
		var bar_position := enemy_rect.position - camera_position + Vector2(0, -8)
		draw_rect(Rect2(bar_position, Vector2(enemy_rect.size.x, 4)), Color(0.18, 0.10, 0.10, 0.9), true)
		draw_rect(Rect2(bar_position, Vector2(enemy_rect.size.x * hp_ratio, 4)), Color(0.92, 0.28, 0.28), true)
		draw_rect(Rect2(bar_position, Vector2(enemy_rect.size.x, 4)), Color(1, 1, 1, 0.2), false, 1.0)


func _draw_planted_turret_base(turret_center: Vector2, base_color: Color, leg_color: Color, is_tripod: bool) -> void:
	var base_rect: Rect2 = Rect2(turret_center + Vector2(-16, 6), Vector2(32, 12))
	draw_rect(base_rect, base_color, true)
	draw_rect(base_rect, Color(1, 1, 1, 0.12), false, 1.0)
	if is_tripod:
		draw_line(turret_center + Vector2(-8, 16), turret_center + Vector2(-22, 34), leg_color, 3.0)
		draw_line(turret_center + Vector2(0, 18), turret_center + Vector2(0, 40), leg_color, 3.0)
		draw_line(turret_center + Vector2(8, 16), turret_center + Vector2(22, 34), leg_color, 3.0)
	else:
		draw_line(turret_center + Vector2(-7, 16), turret_center + Vector2(-18, 32), leg_color, 3.0)
		draw_line(turret_center + Vector2(7, 16), turret_center + Vector2(18, 32), leg_color, 3.0)
		draw_line(turret_center + Vector2(0, 14), turret_center + Vector2(0, 28), leg_color, 3.0)


func _draw_simple_gun_turret(turret_center: Vector2, aim_direction: Vector2, flash: bool) -> void:
	_draw_planted_turret_base(turret_center, Color(0.22, 0.22, 0.24), Color(0.12, 0.12, 0.14), true)
	var body_rect := Rect2(turret_center + Vector2(-15, -6), Vector2(30, 18))
	draw_rect(body_rect, Color(0.42, 0.42, 0.46), true)
	draw_rect(body_rect, Color(0.82, 0.84, 0.88, 0.24), false, 1.0)
	var pivot := turret_center + Vector2(0, 2)
	var barrel_direction := aim_direction.normalized() if aim_direction != Vector2.ZERO else Vector2.RIGHT
	draw_line(pivot, pivot + barrel_direction * 26.0, Color(0.14, 0.14, 0.16), 5.0)
	draw_line(pivot + barrel_direction * 4.0, pivot + barrel_direction * 24.0, Color(0.76, 0.76, 0.80), 2.0)
	draw_circle(pivot, 5.0, Color(0.18, 0.18, 0.20))
	if flash:
		draw_rect(body_rect, Color(1, 1, 1, 0.18), true)


func _draw_projectiles() -> void:
	for projectile in projectiles:
		var projectile_kind: String = String(projectile.get("kind", "orb"))
		var projectile_texture: Texture2D = _projectile_texture_for_kind(projectile_kind)
		var projectile_position: Vector2 = Vector2(projectile["position"]) - camera_position
		var projectile_direction: Vector2 = Vector2(projectile.get("direction", Vector2.RIGHT))
		if projectile_direction == Vector2.ZERO:
			projectile_direction = Vector2.RIGHT
		var projectile_size: Vector2 = _projectile_draw_size_for_kind(projectile_kind)
		var trail_start: Vector2 = projectile_position - projectile_direction * (projectile_size.x * 0.55)
		var trail_end: Vector2 = projectile_position + projectile_direction * (projectile_size.x * 0.18)
		match projectile_kind:
			"arrow":
				draw_line(trail_start, trail_end, Color(0.95, 0.93, 0.82, 0.82), 2.0)
				draw_line(trail_start - Vector2(projectile_direction.y, -projectile_direction.x) * 2.0, trail_start, Color(0.92, 0.88, 0.74, 0.52), 1.0)
			"cannonball":
				var shadow_position: Vector2 = Vector2(projectile.get("land_position", projectile["position"])) - camera_position
				draw_circle(shadow_position, 7.0, Color(0.08, 0.08, 0.08, 0.18))
				draw_circle(projectile_position, 10.0, Color(0.18, 0.16, 0.12, 0.24))
				draw_line(projectile_position - projectile_direction * 18.0, projectile_position, Color(0.68, 0.64, 0.58, 0.28), 3.0)
			"laser":
				draw_line(trail_start, projectile_position, Color(0.78, 0.46, 1.0, 0.46), 6.0)
				draw_circle(projectile_position, 13.0, Color(0.86, 0.68, 1.0, 0.26))
				draw_line(trail_start, projectile_position, Color(1.0, 0.92, 1.0, 0.20), 2.0)
			"orb":
				draw_line(trail_start, projectile_position, Color(1.0, 0.9, 0.4, 0.62), 3.0)
				draw_circle(projectile_position, 6.0, Color(1.0, 0.96, 0.48, 0.92))
				draw_circle(projectile_position, 11.0, Color(1.0, 0.92, 0.34, 0.14))
		if projectile_texture != null:
			var projectile_rotation: float = projectile_direction.angle() + (0.0 if projectile_kind == "arrow" else PI * 0.5)
			draw_set_transform(projectile_position, projectile_rotation, Vector2.ONE)
			draw_texture_rect(
				projectile_texture,
				Rect2(-projectile_size * 0.5, projectile_size),
				false
			)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_circle(projectile_position, float(projectile["radius"]), Color(projectile["color"]))


func _draw_explosion_effects() -> void:
	for effect in explosion_effects:
		var world_position: Vector2 = Vector2(effect["position"])
		var effect_radius: float = float(effect["radius"])
		var effect_time: float = float(effect["time"])
		var alpha: float = clampf(effect_time / 0.42, 0.0, 1.0)
		var ring_radius: float = effect_radius * (1.18 - alpha * 0.48)
		var center: Vector2 = world_position - camera_position
		draw_circle(center, ring_radius * 0.42, Color(1.0, 0.82, 0.34, 0.16 * alpha))
		draw_circle(center, ring_radius * 0.22, Color(1.0, 0.96, 0.82, 0.22 * alpha))
		draw_arc(center, ring_radius, 0.0, TAU, 24, Color(1.0, 0.62, 0.18, 0.95 * alpha), 4.0, true)
		draw_arc(center, ring_radius * 0.58, 0.0, TAU, 20, Color(1.0, 0.94, 0.68, 0.72 * alpha), 3.0, true)
		for spark_index in range(6):
			var spark_angle: float = float(spark_index) / 6.0 * TAU + world_position.x * 0.01
			var spark_start: Vector2 = center + Vector2.RIGHT.rotated(spark_angle) * ring_radius * 0.24
			var spark_end: Vector2 = center + Vector2.RIGHT.rotated(spark_angle) * ring_radius * (0.78 + 0.14 * alpha)
			draw_line(spark_start, spark_end, Color(1.0, 0.78, 0.32, 0.44 * alpha), 2.0)


func _projectile_texture_for_kind(projectile_kind: String) -> Texture2D:
	if projectile_kind == "arrow":
		return arrow_projectile_texture
	if projectile_kind == "cannonball":
		return cannonball_projectile_texture
	if projectile_kind == "laser":
		return laser_projectile_texture
	return null


func _projectile_draw_size_for_kind(projectile_kind: String) -> Vector2:
	if projectile_kind == "cannonball":
		return Vector2(34, 34)
	if projectile_kind == "laser":
		return Vector2(36, 36)
	if projectile_kind == "orb":
		return Vector2(16, 16)
	return Vector2(28, 28)


func _draw_enemy_shots() -> void:
	for shot in enemy_shots:
		var shot_alpha: float = clamp(float(shot["time"]) / 0.14, 0.0, 1.0)
		var start_pos: Vector2 = Vector2(shot["start"]) - camera_position
		var end_pos: Vector2 = Vector2(shot["end"]) - camera_position
		draw_line(start_pos, end_pos, Color(1.0, 0.92, 0.44, shot_alpha), 2.0)
		draw_circle(start_pos, 4.0, Color(1.0, 0.78, 0.24, shot_alpha))


func _draw_gather_effects() -> void:
	for effect in gather_effects:
		var effect_position: Vector2 = Vector2(effect["position"]) + Vector2(effect["offset"]) - camera_position
		var effect_alpha: float = clamp(float(effect["time"]) / 0.65, 0.0, 1.0)
		var effect_color: Color = Color(effect.get("color", TEXT_COLOR))
		draw_string(
			ThemeDB.fallback_font,
			effect_position,
			String(effect["text"]),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			16,
			Color(effect_color.r, effect_color.g, effect_color.b, effect_alpha)
		)


func _draw_inventory_full_warning() -> void:
	if inventory_full_timer <= 0.0 or phase != Phase.BUILD or inside_house or inside_cave:
		return
	var pulse: float = 0.55 + 0.45 * abs(sin((INVENTORY_FULL_FLASH_TIME - inventory_full_timer) * 10.0))
	var badge_rect := Rect2(Vector2(842, 54), Vector2(392, 42))
	draw_rect(badge_rect, Color(0.32, 0.08, 0.08, 0.86), true)
	draw_rect(badge_rect, Color(1.0, 0.48, 0.42, pulse), false, 3.0)
	if inventory_full_icon_texture != null:
		draw_texture_rect(inventory_full_icon_texture, Rect2(badge_rect.position + Vector2(8, 8), INVENTORY_BADGE_ICON_DRAW_SIZE), false)
	elif inventory_icon_texture != null:
		draw_texture_rect(inventory_icon_texture, Rect2(badge_rect.position + Vector2(8, 8), INVENTORY_BADGE_ICON_DRAW_SIZE), false)
	draw_string(
		ThemeDB.fallback_font,
		badge_rect.position + Vector2(42, 28),
		"INVENTORY FULL  -  build, buy, repair, or head deeper",
		HORIZONTAL_ALIGNMENT_LEFT,
		340,
		18,
		Color(1.0, 0.92, 0.88, pulse)
	)


func _draw_danger_overlay() -> void:
	if phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	var max_hp_total: int = PLAYER_MAX_HP + _extra_player_max_hp()
	if max_hp_total <= 0:
		return
	var hp_ratio: float = clampf(float(player_hp) / float(max_hp_total), 0.0, 1.0)
	if hp_ratio > 0.45 and wave_banner_timer <= 0.0 and not _is_boss_encounter_locked():
		return
	var vignette_strength: float = clampf((0.50 - hp_ratio) / 0.50, 0.0, 1.0)
	if _is_boss_encounter_locked():
		vignette_strength = max(vignette_strength, 0.22)
	var edge_color: Color = Color(0.84, 0.10, 0.10, 0.10 + vignette_strength * 0.18)
	draw_rect(Rect2(Vector2.ZERO, Vector2(SCREEN_SIZE.x, 52)), edge_color, true)
	draw_rect(Rect2(Vector2(0, SCREEN_SIZE.y - 56), Vector2(SCREEN_SIZE.x, 56)), edge_color, true)
	draw_rect(Rect2(Vector2.ZERO, Vector2(52, SCREEN_SIZE.y)), edge_color, true)
	draw_rect(Rect2(Vector2(SCREEN_SIZE.x - 52, 0), Vector2(52, SCREEN_SIZE.y)), edge_color, true)
	if hp_ratio <= 0.35:
		var pulse_alpha: float = 0.06 + abs(sin(world_time * 6.0)) * 0.10
		draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.74, 0.06, 0.06, pulse_alpha * (1.0 - hp_ratio)), false, 8.0)


func _draw_hit_effects() -> void:
	for effect in hit_effects:
		var effect_position: Vector2 = Vector2(effect["position"]) + Vector2(effect["offset"]) - camera_position
		var effect_color: Color = effect["color"]
		draw_string(
			ThemeDB.fallback_font,
			effect_position,
			String(effect["text"]),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			18,
			Color(effect_color.r, effect_color.g, effect_color.b, clamp(float(effect["time"]) / 0.55, 0.0, 1.0))
		)


func _draw_player() -> void:
	var active_player_position: Vector2 = player_position
	if inside_house:
		active_player_position = interior_player_position
	elif inside_cave:
		active_player_position = cave_player_position
	if player_visual_node == null or not player_visual_node.visible:
		if inside_house or inside_cave:
			draw_rect(Rect2(active_player_position, PLAYER_SIZE), PLAYER_COLOR, true)
		else:
			_draw_world_rect(Rect2(active_player_position, PLAYER_SIZE), PLAYER_COLOR)

	var player_center := active_player_position + PLAYER_SIZE * 0.5
	if not inside_house and not inside_cave:
		player_center -= camera_position
	if player_swing_timer > 0.0:
		_draw_wrench_swing(player_center)


func _draw_wrench_swing(player_center: Vector2) -> void:
	var swing_phase: float = 1.0 - player_swing_timer / PLAYER_SWORD_SWING_TIME
	var eased_phase: float = 1.0 - pow(1.0 - swing_phase, 3.0)
	var swing_dir: Vector2 = player_swing_direction.normalized() if player_swing_direction != Vector2.ZERO else Vector2.RIGHT
	var sweep_normal: Vector2 = Vector2(-swing_dir.y, swing_dir.x)
	var handedness: float = -1.0 if swing_dir.x < 0.0 else 1.0
	if absf(swing_dir.x) < 0.14:
		handedness = -1.0 if swing_dir.y < 0.0 else 1.0
	var shoulder_anchor: Vector2 = player_center + Vector2(0.0, -4.0)
	var hand_anchor: Vector2 = shoulder_anchor + swing_dir * 6.0 + sweep_normal * 7.0 * handedness
	var strike_angle: float = swing_dir.angle() + lerpf(-2.15, 0.82, eased_phase)
	var reach_length: float = 8.0 + sin(swing_phase * PI) * 5.0
	var orbit_offset: Vector2 = Vector2.RIGHT.rotated(strike_angle - 0.52 * handedness) * reach_length
	var lift_offset: Vector2 = sweep_normal * lerpf(-4.0 * handedness, 5.0 * handedness, eased_phase)
	var swing_position: Vector2 = hand_anchor + orbit_offset + lift_offset
	var swing_angle: float = strike_angle + 2.35619449
	if wrench_texture != null:
		draw_set_transform(swing_position, swing_angle, Vector2.ONE)
		draw_texture_rect(
			wrench_texture,
			Rect2(Vector2(-23.0, -23.0), WRENCH_SWING_DRAW_SIZE),
			false
		)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_line(hand_anchor, swing_position, SLASH_COLOR, 5.0)


func _load_art_assets() -> void:
	player_sprite_texture = _load_texture("res://assets/player_reference.png")
	player_body_texture = _load_texture("res://Art/Bob with no stuff.png", Color(0, 0, 0, 1))
	player_run_1_texture = _load_texture("res://Art/generated/bob_run_1.png", Color(0, 0, 0, 1))
	player_run_2_texture = _load_texture("res://Art/generated/bob_run_2.png", Color(0, 0, 0, 1))
	player_run_3_texture = _load_texture("res://Art/generated/bob_run_3.png", Color(0, 0, 0, 1))
	player_run_4_texture = _load_texture("res://Art/generated/bob_run_4.png", Color(0, 0, 0, 1))
	player_run_5_texture = _load_texture("res://Art/generated/bob_run_5.png", Color(0, 0, 0, 1))
	team_logo_texture = _load_texture("res://assets/team_logo.png")
	turret_sprite_texture = _load_texture("res://Art/cross bow.png", Color(0, 0, 0, 1))
	cannon_turret_texture = _load_texture("res://Art/Canon.png", Color(0, 0, 0, 1))
	golden_turret_texture = _load_texture("res://Art/golden minigun.png", Color(0, 0, 0, 1))
	arrow_projectile_texture = _load_texture("res://Art/Arrow Projectile.png", Color(0, 0, 0, 1))
	cannonball_projectile_texture = _load_texture("res://Art/Cannon ball Projectile.png", Color(0, 0, 0, 1))
	healing_fountain_texture = _load_texture("res://Art/Healing fountain-1.png.png", Color(0, 0, 0, 1))
	crystal_sentry_texture = _load_texture("res://Art/lazer shooting thingy.png", Color(0, 0, 0, 1))
	laser_projectile_texture = _load_texture("res://Art/Lazer Projectile.png", Color(0, 0, 0, 1))
	arms_dealer_texture = _load_texture("res://Art/Arms dealer.png", Color(0, 0, 0, 1))
	menu_background_texture = _load_texture("res://Art/menu screen (13).png", Color(0, 0, 0, 1))
	# Already has an alpha channel, so no chroma key: keying black out here would
	# erase the artwork's outlines.
	loss_screen_texture = _load_first_existing_texture([
		"res://Art/Death screen.png"
	])
	backyard_fence_texture = _load_texture("res://Art/Fence 1-1.png.png", Color(0, 0, 0, 1))
	cave_boss_texture = _load_texture("res://Art/Bony Spider Boss-1.png.png", Color(0, 0, 0, 1))
	cave_boss_walk_1_texture = _load_texture("res://Art/Spider walking 1-1.png.png", Color(0, 0, 0, 1))
	cave_boss_walk_2_texture = _load_texture("res://Art/Spider walking 2-2.png.png", Color(0, 0, 0, 1))
	cave_boss_walk_3_texture = _load_texture("res://Art/Spider walking 3-3.png.png", Color(0, 0, 0, 1))
	cave_boss_attack_texture = _load_first_existing_texture([
		"res://Art/Boss attack 1.png",
		"res://Art/Boss attack 1.png.png",
		"res://Art/boss attack 1.png",
		"res://Art/boss attack 1.png.png",
		"res://Art/Bony Spider Boss attack 1.png",
		"res://Art/Bony Spider Boss attack 1.png.png",
		"res://Art/Bony Spider Attack 1.png",
		"res://Art/Bony Spider Attack 1.png.png"
	], Color(0, 0, 0, 1))
	cave_boss_slam_frames.clear()
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 1-1.png.png", Color(0, 0, 0, 1)))
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 2-2.png.png", Color(0, 0, 0, 1)))
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 3-3.png.png", Color(0, 0, 0, 1)))
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 4-4.png.png", Color(0, 0, 0, 1)))
	falling_rock_frames.clear()
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 1-1.png.png", Color(0, 0, 0, 1)))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 2-2.png.png", Color(0, 0, 0, 1)))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 3-3.png.png", Color(0, 0, 0, 1)))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 4-4.png.png", Color(0, 0, 0, 1)))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 5-5.png.png", Color(0, 0, 0, 1)))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 6-6.png.png", Color(0, 0, 0, 1)))
	decor_sprite_texture = _load_texture("res://assets/forest_decor.png", Color(0, 0, 0, 1))
	forest_tree_texture = _load_texture("res://assets/forest_tree.png", Color(0, 0, 0, 1))
	forest_dog_texture = _load_texture("res://Art/Cutie Patootie Doggie-1.png.png", Color(0, 0, 0, 1))
	forest_beaver_texture = _load_texture("res://Art/Cutie Patootie Beaver-2.png.png", Color(0, 0, 0, 1))
	tree_trunk_texture = _load_texture("res://Art/tree trunk-1.png.png", Color(0, 0, 0, 1))
	irs_robot_texture = _load_texture("res://assets/irs_robot.png", Color(0, 0, 0, 1))
	irs_robot_walk_1_texture = _load_texture("res://Art/Robot moving 1-1.png.png", Color(0, 0, 0, 1))
	irs_robot_walk_2_texture = _load_texture("res://Art/Robot moving 2-2.png.png", Color(0, 0, 0, 1))
	irs_robot_walk_3_texture = _load_texture("res://Art/Robot moving 3-3.png.png", Color(0, 0, 0, 1))
	irs_robot_death_1_texture = _load_texture("res://Art/Robot Death 1-1.png.png", Color(0, 0, 0, 1))
	irs_robot_death_2_texture = _load_texture("res://Art/Robot Death 2-2.png.png", Color(0, 0, 0, 1))
	irs_robot_death_3_texture = _load_texture("res://Art/Robot Death 3-3.png.png", Color(0, 0, 0, 1))
	irs_agent_body_texture = _load_texture("res://Art/irs enemy 2.png", Color(0, 0, 0, 1))
	irs_agent_gun_texture = _load_texture("res://Art/irs enemy 2 gun.png", Color(0, 0, 0, 1))
	swat_texture = _load_first_existing_texture([
		"res://Art/irs enemy 2.png",
		"res://Art/irs enemy_2 run.png"
	], Color(1, 1, 0, 1))
	irs_agent_run_1_texture = _load_texture("res://Art/generated/irs_runner_1.png")
	irs_agent_run_2_texture = _load_texture("res://Art/generated/irs_runner_2.png")
	irs_agent_run_3_texture = _load_texture("res://Art/generated/irs_runner_3.png")
	irs_agent_run_4_texture = _load_texture("res://Art/generated/irs_runner_4.png")
	irs_agent_run_5_texture = _load_texture("res://Art/generated/irs_runner_5.png")
	irs_agent_run_6_texture = _load_texture("res://Art/generated/irs_runner_6.png")
	irs_agent_run_7_texture = _load_texture("res://Art/generated/irs_runner_7.png")
	rock_big_texture = _load_texture("res://assets/rock_big.png", Color(0, 0, 0, 1))
	rock_medium_texture = _load_texture("res://assets/rock_medium.png", Color(0, 0, 0, 1))
	rock_small_texture = _load_texture("res://assets/rock_small.png", Color(0, 0, 0, 1))
	iron_ore_texture = _load_texture("res://Art/Iron ore.png", Color(0, 0, 0, 1))
	gold_ore_texture = _load_texture("res://Art/Gold ore.png", Color(0, 0, 0, 1))
	gunpowder_ore_texture = _load_texture("res://Art/Gun powder ore.png", Color(0, 0, 0, 1))
	cave_miner_walk_1_texture = _load_texture("res://Art/miner walking 1-1.png.png", Color(0, 0, 0, 1))
	cave_miner_walk_2_texture = _load_texture("res://Art/miner walking 2-2.png.png", Color(0, 0, 0, 1))
	cave_miner_walk_3_texture = _load_texture("res://Art/miner walking 3-3.png.png", Color(0, 0, 0, 1))
	cave_miner_death_1_texture = _load_texture("res://Art/Miner death 1-1.png.png", Color(0, 0, 0, 1))
	cave_miner_death_2_texture = _load_texture("res://Art/Miner death 2-2.png.png", Color(0, 0, 0, 1))
	cave_miner_death_3_texture = _load_texture("res://Art/Miner death 3-3.png.png", Color(0, 0, 0, 1))
	cave_miner_shovel_texture = _load_texture("res://Art/Miners shovel_weapon.png", Color(0, 0, 0, 1))
	cave_entrance_texture = _load_texture("res://Art/Cave Entrance.png", Color(0, 0, 0, 1))
	wrench_texture = _load_first_existing_texture(["res://Art/Wrench.png", "res://assets/wrench.png"], Color(0, 0, 0, 1))
	house_texture = null
	house_broken_1_texture = null
	house_broken_2_texture = null
	gun_turret_texture = _load_texture("res://Art/gun go pew pew.png", Color(0, 0, 0, 1))
	grass_tile_texture = _load_texture("res://assets/grass_tile.png")
	wall_light_texture = _load_texture("res://Art/Cheap wall.png")
	wall_medium_texture = _load_texture("res://Art/stone wall.png")
	wall_heavy_texture = _load_texture("res://Art/Iron wall.png")
	countdown_numbers_texture = _load_texture("res://Art/numbers (1).png")
	heart_icon_texture = _load_texture("res://Art/Heart.png")
	inventory_icon_texture = _load_texture("res://Art/Inventory icon-2.png.png")
	inventory_full_icon_texture = _load_texture("res://Art/Inventory full icon-3.png.png")
	tax_papers_texture = _load_texture("res://Art/Tax Papers.png", Color(0, 0, 0, 1))
	mug_texture = _load_texture("res://Art/Best dad mug.png", Color(0, 0, 0, 1))
	trophy_texture = _load_texture("res://Art/gold trophy.png", Color(0, 0, 0, 1))
	couch_coins_texture = _load_texture("res://Art/Couch with coins.png", Color(0, 0, 0, 1))
	kfz_console_texture = _load_texture("res://assets/item_kfz_console.png", Color(0, 0, 0, 1))
	family_photo_texture = _load_texture("res://Art/Family photo.png")
	crossbow_sound = load("res://Audio/sfx/384919__ali_6868__crossbow-firing-and-hitting-target.wav") as AudioStream
	gunshot_sound = load("res://Audio/sfx/128296__xenonn__layered-gunshot-0.wav") as AudioStream
	explosion_sound = load("res://Audio/sfx/110115__ryansnook__small-explosion.wav") as AudioStream
	menu_music_stream = load("res://Audio/music/1497951_I-miss-you.mp3") as AudioStream
	cave_music_stream = load("res://Audio/music/1593618_Betrayal.mp3") as AudioStream
	boss_music_stream = load("res://Audio/music/1598849_a-quotbreakcorequot-song.mp3") as AudioStream


func _build_audio_players() -> void:
	_ensure_sfx_bus()
	for player in sfx_players:
		if is_instance_valid(player):
			player.queue_free()
	sfx_players.clear()
	for _pool_index in range(8):
		var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
		sfx_player.bus = SFX_BUS_NAME
		add_child(sfx_player)
		sfx_players.append(sfx_player)
	sfx_player_index = 0
	if menu_music_player != null and is_instance_valid(menu_music_player):
		menu_music_player.queue_free()
	menu_music_player = AudioStreamPlayer.new()
	_ensure_menu_music_bus()
	menu_music_player.bus = MENU_MUSIC_BUS_NAME
	menu_music_player.stream = menu_music_stream
	menu_music_player.volume_db = MENU_MUSIC_VOLUME_DB
	menu_music_player.autoplay = false
	add_child(menu_music_player)
	if cave_music_player != null and is_instance_valid(cave_music_player):
		cave_music_player.queue_free()
	cave_music_player = AudioStreamPlayer.new()
	cave_music_player.bus = MENU_MUSIC_BUS_NAME
	cave_music_player.stream = cave_music_stream
	cave_music_player.volume_db = CAVE_MUSIC_VOLUME_DB
	cave_music_player.autoplay = false
	add_child(cave_music_player)
	if boss_music_player != null and is_instance_valid(boss_music_player):
		boss_music_player.queue_free()
	boss_music_player = AudioStreamPlayer.new()
	boss_music_player.bus = MENU_MUSIC_BUS_NAME
	boss_music_player.stream = boss_music_stream
	boss_music_player.volume_db = BOSS_MUSIC_VOLUME_DB
	boss_music_player.autoplay = false
	add_child(boss_music_player)
	_apply_audio_settings()


func _play_sfx(stream: AudioStream, volume_db: float = -8.0, pitch_scale: float = 1.0) -> void:
	if stream == null or sfx_players.is_empty():
		return
	var sfx_player: AudioStreamPlayer = sfx_players[sfx_player_index]
	sfx_player_index = (sfx_player_index + 1) % sfx_players.size()
	sfx_player.stop()
	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.pitch_scale = pitch_scale
	sfx_player.play()


func _ensure_menu_music_bus() -> void:
	menu_music_bus_index = AudioServer.get_bus_index(MENU_MUSIC_BUS_NAME)
	if menu_music_bus_index == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		menu_music_bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(menu_music_bus_index, MENU_MUSIC_BUS_NAME)
	if AudioServer.get_bus_effect_count(menu_music_bus_index) <= 0:
		var analyzer_effect := AudioEffectSpectrumAnalyzer.new()
		AudioServer.add_bus_effect(menu_music_bus_index, analyzer_effect, 0)
	menu_music_spectrum_effect_index = 0


func _ensure_sfx_bus() -> void:
	sfx_bus_index = AudioServer.get_bus_index(SFX_BUS_NAME)
	if sfx_bus_index == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		sfx_bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(sfx_bus_index, SFX_BUS_NAME)


func _volume_percent_to_db(percent: float) -> float:
	if percent <= 0.0:
		return -80.0
	return linear_to_db(percent / 100.0)


func _apply_audio_settings() -> void:
	if sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(sfx_bus_index, _volume_percent_to_db(sfx_volume_percent))
	if menu_music_bus_index != -1:
		AudioServer.set_bus_volume_db(menu_music_bus_index, _volume_percent_to_db(music_volume_percent))
	if music_volume_value_label != null:
		music_volume_value_label.text = "%d%%" % int(round(music_volume_percent))
	if sfx_volume_value_label != null:
		sfx_volume_value_label.text = "%d%%" % int(round(sfx_volume_percent))


func _on_music_volume_changed(value: float) -> void:
	music_volume_percent = clampf(value, 0.0, 100.0)
	_apply_audio_settings()


func _on_sfx_volume_changed(value: float) -> void:
	sfx_volume_percent = clampf(value, 0.0, 100.0)
	_apply_audio_settings()

func _load_texture(resource_path: String, chroma_key: Variant = null, crop_visible: bool = false) -> Texture2D:
	var image: Image = null
	var image_path := ProjectSettings.globalize_path(resource_path)
	if FileAccess.file_exists(image_path):
		image = Image.load_from_file(image_path)
	if image == null or image.is_empty():
		var imported_texture: Texture2D = load(resource_path) as Texture2D
		if imported_texture != null:
			image = imported_texture.get_image()
	if image == null or image.is_empty():
		return null
	if chroma_key != null:
		image.convert(Image.FORMAT_RGBA8)
		var key_color: Color = chroma_key
		for y in range(image.get_height()):
			for x in range(image.get_width()):
				var pixel := image.get_pixel(x, y)
				if is_equal_approx(pixel.r, key_color.r) and is_equal_approx(pixel.g, key_color.g) and is_equal_approx(pixel.b, key_color.b):
					image.set_pixel(x, y, Color(pixel.r, pixel.g, pixel.b, 0.0))
	if crop_visible:
		var used_rect: Rect2i = image.get_used_rect()
		if used_rect.size.x > 0 and used_rect.size.y > 0:
			image = image.get_region(used_rect)
	return ImageTexture.create_from_image(image)


func _load_first_existing_texture(resource_paths: Array[String], chroma_key: Variant = null, crop_visible: bool = false) -> Texture2D:
	for resource_path in resource_paths:
		# Source files only exist on disk in the editor; exported builds resolve
		# the same path through the PCK, so both lookups have to be tried.
		if not FileAccess.file_exists(ProjectSettings.globalize_path(resource_path)) and not ResourceLoader.exists(resource_path):
			continue
		var texture: Texture2D = _load_texture(resource_path, chroma_key, crop_visible)
		if texture != null:
			return texture
	return null


func _looks_like_house_texture(texture: Texture2D) -> bool:
	if texture == null:
		return false
	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return false
	var aspect_ratio: float = texture_size.x / texture_size.y
	return aspect_ratio >= 1.45 and aspect_ratio <= 2.65


func _draw_selection() -> void:
	if phase == Phase.MENU or phase == Phase.GAME_OVER or inside_house or inside_cave:
		return
	var rect := Rect2(_cell_to_world(selected_cell), Vector2.ONE * CELL_SIZE)
	var selection_color := Color(0.98, 0.95, 0.88, 0.9)
	if not _cell_is_buildable(selected_cell):
		selection_color = Color(0.85, 0.35, 0.35, 0.9)
	draw_rect(Rect2(rect.position - camera_position, rect.size), selection_color, false, 3.0)
	if phase == Phase.BUILD and _cell_is_buildable(selected_cell) and not structures.has(_cell_key(selected_cell)):
		_draw_world_rect(Rect2(_cell_to_world(selected_cell) + Vector2(14, 14), Vector2(20, 20)), Color(1, 1, 1, 0.16))


func _draw_ground_area(world_rect: Rect2, fallback_color: Color) -> void:
	if grass_tile_texture == null:
		_draw_world_rect(world_rect, fallback_color)
		return
	var tile_step := GROUND_TILE_DRAW_SIZE
	var world_end := world_rect.position + world_rect.size
	var y := world_rect.position.y
	while y < world_end.y:
		var x := world_rect.position.x
		while x < world_end.x:
			var draw_size := Vector2(
				minf(tile_step.x, world_end.x - x),
				minf(tile_step.y, world_end.y - y)
			)
			draw_texture_rect(
				grass_tile_texture,
				Rect2(Vector2(x, y) - camera_position, draw_size),
				false
			)
			x += tile_step.x
		y += tile_step.y
	draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), Color(fallback_color.r, fallback_color.g, fallback_color.b, 0.18), true)


func _draw_wall_repair_marker(structure: Dictionary, cell: Vector2i) -> void:
	var structure_type := int(structure.get("type", StructureType.NONE))
	var max_hp := _wall_max_hp(structure_type)
	if max_hp <= 0:
		return
	var current_hp := int(structure.get("hp", max_hp))
	if current_hp >= max_hp:
		return
	var marker_pos := _cell_to_world(cell) - camera_position + Vector2(24, 2)
	if wrench_texture != null:
		draw_texture_rect(wrench_texture, Rect2(marker_pos, WRENCH_DRAW_SIZE), false)
	else:
		draw_line(marker_pos + Vector2(2, 14), marker_pos + Vector2(14, 2), Color(0.84, 0.88, 0.92), 3.0)
		draw_circle(marker_pos + Vector2(15, 3), 3.0, Color(0.84, 0.88, 0.92))


func _wall_max_hp(structure_type: int) -> int:
	match structure_type:
		StructureType.WALL_LIGHT:
			return WALL_LIGHT_HP
		StructureType.WALL_MEDIUM:
			return WALL_MEDIUM_HP
		StructureType.WALL_HEAVY:
			return WALL_HEAVY_HP
		_:
			return 0


func _wall_repair_costs(structure_type: int) -> Dictionary:
	match structure_type:
		StructureType.WALL_LIGHT:
			return {"wood": WALL_REPAIR_LIGHT_WOOD_COST, "stone": 0}
		StructureType.WALL_MEDIUM:
			return {"wood": WALL_REPAIR_MEDIUM_WOOD_COST, "stone": WALL_REPAIR_MEDIUM_STONE_COST}
		StructureType.WALL_HEAVY:
			return {"wood": WALL_REPAIR_HEAVY_WOOD_COST, "stone": WALL_REPAIR_HEAVY_STONE_COST}
		_:
			return {"wood": 0, "stone": 0}


func _draw_world_rect(world_rect: Rect2, color: Color) -> void:
	draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), color, true)


func _draw_wall_visual(world_rect: Rect2, color: Color, hp: int, max_hp: int) -> void:
	var hp_ratio: float = clampf(float(hp) / max(1.0, float(max_hp)), 0.0, 1.0)
	var wall_texture: Texture2D = null
	if max_hp == WALL_LIGHT_HP:
		wall_texture = wall_light_texture
	elif max_hp == WALL_MEDIUM_HP:
		wall_texture = wall_medium_texture
	elif max_hp == WALL_HEAVY_HP:
		wall_texture = wall_heavy_texture
	var damage_ratio: float = 1.0 - hp_ratio
	var shake_offset := Vector2.ZERO
	if damage_ratio > 0.0:
		shake_offset = Vector2(sin(world_time * 30.0 + world_rect.position.x * 0.05) * damage_ratio * 1.8, 0.0)
	var visible_height: float = max(10.0, world_rect.size.y * (0.45 + hp_ratio * 0.55))
	var visible_rect := Rect2(world_rect.position + Vector2(0, world_rect.size.y - visible_height) + shake_offset, Vector2(world_rect.size.x, visible_height))
	if wall_texture != null:
		var source_height: float = wall_texture.get_height() * (visible_height / world_rect.size.y)
		var source_rect := Rect2(0.0, wall_texture.get_height() - source_height, wall_texture.get_width(), source_height)
		draw_texture_rect_region(
			wall_texture,
			Rect2(visible_rect.position - camera_position, visible_rect.size),
			source_rect
		)
		if hp_ratio < 0.999:
			draw_rect(Rect2(visible_rect.position - camera_position, visible_rect.size), Color(1.0, 0.86, 0.86, 0.10), true)
	else:
		_draw_world_rect(visible_rect, color)
	if hp_ratio < 0.8:
		draw_line(visible_rect.position - camera_position + Vector2(6, 6), visible_rect.position - camera_position + Vector2(14, visible_rect.size.y - 8), Color(0.23, 0.18, 0.16), 2.0)
	if hp_ratio < 0.5:
		draw_line(visible_rect.position - camera_position + Vector2(18, 4), visible_rect.position - camera_position + Vector2(10, visible_rect.size.y - 6), Color(0.23, 0.18, 0.16), 2.0)
	if hp_ratio < 0.25:
		draw_line(visible_rect.position - camera_position + Vector2(24, 8), visible_rect.position - camera_position + Vector2(26, visible_rect.size.y - 6), Color(0.23, 0.18, 0.16), 2.0)
		draw_line(visible_rect.position - camera_position + Vector2(8, visible_rect.size.y * 0.3), visible_rect.position - camera_position + Vector2(22, visible_rect.size.y - 4), Color(0.18, 0.12, 0.10), 2.0)


func _draw_countdown_display() -> void:
	if phase != Phase.BUILD:
		return
	var panel_rect := Rect2(Vector2(432, 12), Vector2(416, 68))
	_draw_ui_card(panel_rect, UI_WARM_ACCENT, UI_PANEL_FILL, 2.0)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(18, 24), "BUILD PHASE", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(18, 50), "Press Enter to start early", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, TEXT_COLOR)
	var countdown_text: String = "%02d" % int(ceili(countdown))
	var digit_start := panel_rect.position + Vector2(290, 8)
	for digit_index in range(countdown_text.length()):
		var digit_char: String = countdown_text.substr(digit_index, 1)
		var digit_value: int = int(digit_char)
		var digit_draw_rect: Rect2 = Rect2(digit_start + Vector2(digit_index * (COUNTDOWN_DIGIT_DRAW_SIZE.x + 10.0), 4), COUNTDOWN_DIGIT_DRAW_SIZE)
		if countdown_numbers_texture != null and digit_value >= 0 and digit_value < COUNTDOWN_DIGIT_SOURCE_RECTS.size():
			var source_rect: Rect2 = COUNTDOWN_DIGIT_SOURCE_RECTS[digit_value]
			draw_texture_rect_region(countdown_numbers_texture, digit_draw_rect, source_rect)
		else:
			draw_string(ThemeDB.fallback_font, digit_draw_rect.position + Vector2(6, 40), digit_char, HORIZONTAL_ALIGNMENT_LEFT, -1, 38, Color(1.0, 0.93, 0.52))


func _draw_wave_banner() -> void:
	if wave_banner_timer <= 0.0:
		return
	var alpha: float = min(1.0, wave_banner_timer / WAVE_BANNER_TIME)
	var banner_rect := Rect2(Vector2(360, 90), Vector2(560, 112))
	_draw_ui_card(banner_rect, _with_alpha(UI_WARM_ACCENT, 0.65 * alpha), _with_alpha(UI_PANEL_FILL, 0.90 * alpha), 3.0)
	draw_rect(Rect2(banner_rect.position + Vector2(18, 18), Vector2(8, banner_rect.size.y - 36)), _with_alpha(UI_WARM_ACCENT, 0.82 * alpha), true)
	var lines: PackedStringArray = wave_banner_text.split("\n")
	for line_index in range(lines.size()):
		draw_string(
			ThemeDB.fallback_font,
			Vector2(banner_rect.position.x + 56, banner_rect.position.y + 42 + line_index * 34),
			lines[line_index],
			HORIZONTAL_ALIGNMENT_LEFT,
			430,
			32,
			Color(1, 1, 1, alpha)
		)


func _draw_house_prompt() -> void:
	if inside_house or inside_cave or phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	if not _is_player_near_house_door():
		if phase == Phase.BUILD and house_damage_stage > 0 and _is_player_near_house_shell():
			var repair_prompt_rect := Rect2(Vector2(390, 608), Vector2(500, 42))
			_draw_ui_prompt(repair_prompt_rect, "H", "Repair house  %d wood  %d stone" % [HOUSE_REPAIR_WOOD_COST, HOUSE_REPAIR_STONE_COST], UI_SUCCESS_ACCENT, wrench_texture)
	return


func _draw_dealer_prompt() -> void:
	if inside_house or inside_cave or phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	if not _is_player_near_dealer_stand():
		return
	var prompt_rect := Rect2(Vector2(426, 656), Vector2(428, 42))
	_draw_ui_prompt(prompt_rect, "G", "Visit the arms dealer", UI_WARM_ACCENT)


func _draw_cave_prompt() -> void:
	if inside_house or _cave_active() or phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	if not _is_player_near_cave_entrance():
		return
	var prompt_rect := Rect2(Vector2(432, 608), Vector2(416, 42))
	_draw_ui_prompt(prompt_rect, "F", "Enter the cave", UI_COOL_ACCENT)


func _draw_house_interior() -> void:
	return


func _draw_cave_interior() -> void:
	if not _cave_active():
		return
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.02, 0.02, 0.03, 0.95), true)
	var panel: Rect2 = _cave_panel()
	var room: Dictionary = _current_cave_room()
	var floor_rect := Rect2(panel.position + Vector2(30, 60), Vector2(948, 478))
	var zone_colors: Dictionary = _cave_zone_palette(int(room.get("zone", 0)))
	_draw_ui_card(panel, Color(zone_colors["trim"]).lightened(0.06), Color(0.07, 0.07, 0.08, 0.98), 4.0, Vector2(0, 10))
	_draw_cave_floor_biome(room, floor_rect, zone_colors)
	_draw_cave_connection_mouths(room, floor_rect, zone_colors)
	_draw_cave_rock_intrusions(room, floor_rect, zone_colors)
	_draw_cave_room_set_pieces(room, floor_rect, zone_colors)
	var boss_locked: bool = _is_boss_encounter_locked()
	var exit_rect: Rect2 = _cave_exit_rect()
	var exit_shadow := Color(zone_colors["shadow"]).darkened(0.22)
	var exit_lip := Color(zone_colors["trim"]).darkened(0.08)
	draw_colored_polygon(PackedVector2Array([
		exit_rect.position + Vector2(-12, exit_rect.size.y),
		exit_rect.position + Vector2(8, 12),
		exit_rect.position + Vector2(exit_rect.size.x * 0.36, -16),
		exit_rect.position + Vector2(exit_rect.size.x * 0.72, -6),
		exit_rect.position + Vector2(exit_rect.size.x + 14, 14),
		exit_rect.position + Vector2(exit_rect.size.x + 8, exit_rect.size.y)
	]), exit_shadow)
	draw_arc(exit_rect.position + Vector2(exit_rect.size.x * 0.5, exit_rect.size.y + 2), exit_rect.size.x * 0.62, PI, TAU, 28, exit_lip, 4.0)
	draw_line(exit_rect.position + Vector2(10, exit_rect.size.y), exit_rect.position + Vector2(exit_rect.size.x - 10, exit_rect.size.y), exit_lip, 4.0)
	_draw_ui_card(Rect2(panel.position + Vector2(24, 18), Vector2(470, 46)), Color(zone_colors["trim"]).lightened(0.08), Color(0.08, 0.09, 0.11, 0.88), 2.0, Vector2(0, 4))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(40, 47), String(room.get("name", "Deep Cave")), HORIZONTAL_ALIGNMENT_LEFT, 230, 28, TEXT_COLOR)
	if heart_icon_texture != null:
		draw_texture_rect(heart_icon_texture, Rect2(panel.position + Vector2(270, 30), Vector2(18, 18)), false)
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(294, 47), "%d  |  Keys %d%s" % [player_hp, cave_keys, "  |  Tap H parry" if shield_unlocked else ""], HORIZONTAL_ALIGNMENT_LEFT, 210, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, exit_rect.position + Vector2(16, 32), "Arena Sealed" if boss_locked else "Tunnel Out", HORIZONTAL_ALIGNMENT_LEFT, 120, 18, TEXT_COLOR if not boss_locked else HOUSE_DANGER_COLOR)
	if boss_locked:
		draw_rect(exit_rect.grow(6.0), Color(0.72, 0.14, 0.12, 0.18), true)
		draw_rect(exit_rect.grow(6.0), Color(0.96, 0.50, 0.42, 0.42), false, 2.0)
		draw_string(ThemeDB.fallback_font, panel.position + Vector2(654, 40), "BROODMOTHER RAGE", HORIZONTAL_ALIGNMENT_LEFT, 220, 18, Color(1.0, 0.66, 0.60))
		draw_string(ThemeDB.fallback_font, panel.position + Vector2(654, 62), "Keep moving. Red rings mark the slam.", HORIZONTAL_ALIGNMENT_LEFT, 252, 16, Color(1.0, 0.86, 0.82))
	if bool(room.get("fountain", false)):
		var fountain_rect := Rect2(panel.position + Vector2(460, 286), Vector2(92, 92))
		var fountain_glow_alpha: float = 0.18 + 0.06 * sin(world_time * 2.4)
		draw_circle(fountain_rect.position + fountain_rect.size * 0.5 + Vector2(0, 10), 40.0, Color(0.28, 0.78, 1.0, fountain_glow_alpha))
		if healing_fountain_texture != null:
			draw_texture_rect(healing_fountain_texture, fountain_rect, false)
		else:
			draw_rect(fountain_rect, Color(0.22, 0.44, 0.62), true)
			draw_rect(fountain_rect, Color(0.72, 0.90, 1.0), false, 3.0)
		draw_arc(fountain_rect.position + fountain_rect.size * 0.5 + Vector2(0, 10), 36.0, 0.0, TAU, 20, Color(0.74, 0.94, 1.0, 0.34 + fountain_glow_alpha * 0.7), 3.0, true)
		draw_string(ThemeDB.fallback_font, fountain_rect.position + Vector2(-28, -12), "Healing Fountain", HORIZONTAL_ALIGNMENT_LEFT, 156, 15, Color(0.86, 0.97, 1.0))
	for node in cave_nodes:
		var node_rect: Rect2 = _cave_node_rect(node)
		var active: bool = int(node["remaining"]) > 0
		var node_kind: String = String(node.get("kind", "iron"))
		var node_color: Color = IRON_NODE_COLOR
		if node_kind == "gold":
			node_color = GOLD_NODE_COLOR
		elif node_kind == "gunpowder":
			node_color = GUNPOWDER_NODE_COLOR
		if node_kind == "iron" and iron_ore_texture != null:
			draw_texture_rect(iron_ore_texture, node_rect, false)
			if not active:
				draw_rect(node_rect, Color(0.08, 0.08, 0.09, 0.55), true)
			draw_rect(node_rect, Color(0.90, 0.94, 1.0, 0.35), false, 2.0)
		elif node_kind == "gold" and gold_ore_texture != null:
			draw_texture_rect(gold_ore_texture, node_rect, false)
			if not active:
				draw_rect(node_rect, Color(0.08, 0.08, 0.09, 0.55), true)
			draw_rect(node_rect, Color(1.0, 0.92, 0.56, 0.42), false, 2.0)
		elif node_kind == "gunpowder" and gunpowder_ore_texture != null:
			draw_texture_rect(gunpowder_ore_texture, node_rect, false)
			if not active:
				draw_rect(node_rect, Color(0.08, 0.08, 0.09, 0.55), true)
			draw_rect(node_rect, Color(0.82, 0.82, 0.88, 0.42), false, 2.0)
		else:
			draw_rect(node_rect, node_color if active else Color(0.26, 0.27, 0.30), true)
			draw_rect(node_rect, Color(0.90, 0.94, 1.0, 0.45), false, 2.0)
		for pip in range(int(node["remaining"])):
			draw_rect(Rect2(node_rect.position + Vector2(3 + pip * 5, -8), Vector2(4, 4)), node_color.lightened(0.18), true)
	for pickup in room.get("pickups", []):
		if bool(cave_pickups_claimed.get(String(pickup["id"]), false)):
			continue
		var pickup_pos: Vector2 = Vector2(pickup["position"])
		var pickup_type: String = String(pickup["type"])
		var pickup_rect: Rect2 = Rect2(pickup_pos + Vector2(-16, -16), Vector2(32, 32))
		if pickup_type == "upgrade_hp" and heart_icon_texture != null:
			draw_texture_rect(heart_icon_texture, pickup_rect, false)
			draw_rect(pickup_rect.grow(2.0), Color(1.0, 0.52, 0.56, 0.58), false, 2.0)
		elif pickup_type == "upgrade_carry" and inventory_icon_texture != null:
			draw_texture_rect(inventory_icon_texture, pickup_rect, false)
			draw_rect(pickup_rect.grow(2.0), Color(0.96, 0.88, 0.58, 0.55), false, 2.0)
		else:
			draw_rect(pickup_rect, CAVE_KEY_COLOR if pickup_type == "key" else MAGIC_COLOR, true)
	if harvesting_node_index != -1 and harvesting_node_index < cave_nodes.size():
		var gather_rect: Rect2 = _cave_node_rect(cave_nodes[harvesting_node_index])
		var progress: float = harvest_timer / _current_gather_time()
		draw_rect(Rect2(gather_rect.position + Vector2(0, -14), Vector2(36 * progress, 5)), IRON_NODE_COLOR.lightened(0.35), true)
	for crystal in cave_crystals:
		var crystal_color: Color = MAGIC_COLOR if not bool(crystal["claimed"]) else MAGIC_COLOR.lightened(0.45)
		var crystal_pos: Vector2 = Vector2(crystal["position"])
		draw_colored_polygon(PackedVector2Array([
			crystal_pos + Vector2(0, -22),
			crystal_pos + Vector2(18, 0),
			crystal_pos + Vector2(0, 24),
			crystal_pos + Vector2(-18, 0)
		]), crystal_color)
		draw_rect(Rect2(crystal_pos + Vector2(-6, 22), Vector2(12, 18)), Color(0.26, 0.22, 0.30), true)
	_draw_cave_boss_hazards()
	for cave_enemy in cave_enemies:
		var enemy_rect: Rect2 = Rect2(Vector2(cave_enemy["position"]), Vector2(cave_enemy["size"]))
		var enemy_color: Color = Color(0.72, 0.22, 0.20) if float(cave_enemy.get("flash_timer", 0.0)) <= 0.0 else Color(0.92, 0.46, 0.42)
		var is_boss: bool = bool(cave_enemy.get("boss", false))
		var boss_attacking: bool = is_boss and float(cave_enemy.get("attack_timer", 0.0)) > 0.0
		var miner_texture: Texture2D = _boss_display_texture(cave_enemy) if is_boss else _current_cave_miner_texture()
		var miner_facing_left: bool = cave_player_position.x < enemy_rect.position.x
		if miner_texture != null:
			var draw_size: Vector2 = CAVE_BOSS_DRAW_SIZE if is_boss else CAVE_MINER_DRAW_SIZE
			var miner_draw_rect: Rect2 = Rect2(
				enemy_rect.position + Vector2(enemy_rect.size.x * 0.5 - draw_size.x * 0.5, enemy_rect.size.y * 0.5 - draw_size.y * 0.56),
				draw_size
			)
			if is_boss:
				draw_set_transform(enemy_rect.position + Vector2(enemy_rect.size.x * 0.5, enemy_rect.size.y + 18), 0.0, Vector2(1.9, 0.66))
				draw_circle(Vector2.ZERO, 22.0, CAVE_BOSS_SHADOW_COLOR)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			draw_set_transform(miner_draw_rect.position + miner_draw_rect.size * 0.5, 0.0, Vector2(-1.0 if miner_facing_left else 1.0, 1.0))
			draw_texture_rect(miner_texture, Rect2(-miner_draw_rect.size * 0.5, miner_draw_rect.size), false)
			if float(cave_enemy.get("flash_timer", 0.0)) > 0.0:
				draw_rect(Rect2(-miner_draw_rect.size * 0.5, miner_draw_rect.size), Color(1, 1, 1, 0.18), true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_rect(enemy_rect, enemy_color, true)
			draw_rect(enemy_rect, Color(0.10, 0.04, 0.04, 0.55), false, 2.0)
		if not is_boss:
			_draw_cave_miner_shovel(enemy_rect, miner_facing_left, float(cave_enemy.get("attack_timer", 0.0)))
		else:
			var slam_active: bool = float(cave_enemy.get("slam_timer", 0.0)) > 0.0
			var stunned: bool = float(cave_enemy.get("stun_timer", 0.0)) > 0.0
			var boss_ring_color: Color = Color(0.98, 0.20, 0.18, 0.22) if slam_active else (Color(0.52, 0.76, 1.0, 0.22) if stunned else (Color(0.92, 0.18, 0.16, 0.18) if boss_attacking else Color(0.78, 0.22, 0.20, 0.10)))
			var boss_ring_radius: float = 72.0 if slam_active else (58.0 if boss_attacking else 38.0)
			draw_arc(enemy_rect.position + Vector2(enemy_rect.size.x * 0.5, enemy_rect.size.y * 0.42), boss_ring_radius, 0.0, TAU, 18, boss_ring_color, 6.0, true)
			if boss_attacking or slam_active:
				var pulse_alpha: float = 0.24 + 0.20 * sin((CAVE_BOSS_ATTACK_TIME - float(cave_enemy.get("attack_timer", 0.0))) * 18.0)
				draw_arc(enemy_rect.position + Vector2(enemy_rect.size.x * 0.5, enemy_rect.size.y * 0.46), 68.0 if not slam_active else 92.0, 0.0, TAU, 22, Color(1.0, 0.46, 0.36, pulse_alpha), 4.0, true)
		var hp_ratio: float = clampf(float(cave_enemy["hp"]) / max(1.0, float(cave_enemy["max_hp"])), 0.0, 1.0)
		var hp_width: float = 84.0 if is_boss else enemy_rect.size.x
		var hp_origin: Vector2 = enemy_rect.position + Vector2(enemy_rect.size.x * 0.5 - hp_width * 0.5, -12)
		draw_rect(Rect2(hp_origin, Vector2(hp_width, 5)), Color(0.18, 0.10, 0.10, 0.9), true)
		draw_rect(Rect2(hp_origin, Vector2(hp_width * hp_ratio, 5)), Color(0.92, 0.28, 0.28), true)
		if is_boss:
			draw_string(ThemeDB.fallback_font, hp_origin + Vector2(-2, -8), "BROODMOTHER", HORIZONTAL_ALIGNMENT_LEFT, 120, 14, Color(1.0, 0.86, 0.82))
	for corpse in cave_enemy_corpses:
		var corpse_rect: Rect2 = Rect2(Vector2(corpse["position"]), Vector2(corpse["size"]))
		var corpse_texture: Texture2D = _current_cave_miner_death_texture(float(corpse.get("time", 0.0)))
		var corpse_facing_left: bool = bool(corpse.get("facing_left", false))
		var corpse_alpha: float = clampf(1.0 - maxf(0.0, float(corpse.get("time", 0.0)) - CAVE_MINER_DEATH_FRAME_TIME * 3.0) / max(0.01, CAVE_MINER_DEATH_LINGER_TIME), 0.0, 1.0)
		if corpse_texture != null:
			var corpse_draw_rect: Rect2 = Rect2(corpse_rect.position + Vector2(-18, -28), Vector2(72, 72))
			draw_set_transform(corpse_draw_rect.position + corpse_draw_rect.size * 0.5, 0.0, Vector2(-1.0 if corpse_facing_left else 1.0, 1.0))
			draw_texture_rect(corpse_texture, Rect2(-corpse_draw_rect.size * 0.5, corpse_draw_rect.size), false, Color(1, 1, 1, corpse_alpha))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_rect(corpse_rect, Color(0.48, 0.16, 0.12, corpse_alpha), true)
	if player_visual_node == null or not player_visual_node.visible:
		draw_rect(Rect2(cave_player_position, PLAYER_SIZE), PLAYER_COLOR, true)
	var player_center := cave_player_position + PLAYER_SIZE * 0.5
	if player_swing_timer > 0.0:
		_draw_wrench_swing(player_center)
	_draw_cave_minimap()


func _draw_cave_boss_hazards() -> void:
	for rubble in cave_rock_rubble:
		var rubble_pos: Vector2 = Vector2(rubble["position"])
		var rubble_radius: float = float(rubble["radius"])
		var rubble_alpha: float = clampf(float(rubble["time"]) / CAVE_BOSS_RUBBLE_TIME, 0.0, 1.0)
		draw_circle(rubble_pos, rubble_radius, Color(0.18, 0.16, 0.14, 0.36 * rubble_alpha))
		draw_circle(rubble_pos + Vector2(8, 6), rubble_radius * 0.44, Color(0.10, 0.10, 0.11, 0.26 * rubble_alpha))
	for marker in cave_boss_rock_markers:
		var marker_pos: Vector2 = Vector2(marker["position"])
		var marker_time_ratio: float = clampf(float(marker["time"]) / max(0.01, float(marker["total"])), 0.0, 1.0)
		var marker_pulse: float = 0.55 + 0.45 * abs(sin((1.0 - marker_time_ratio) * 12.0))
		var impact_radius: float = float(marker["impact_radius"])
		draw_circle(marker_pos, impact_radius, Color(0.82, 0.14, 0.12, 0.12 + marker_pulse * 0.10))
		draw_arc(marker_pos, impact_radius, 0.0, TAU, 22, Color(1.0, 0.36, 0.32, 0.42 + marker_pulse * 0.28), 4.0, true)
		draw_arc(marker_pos, impact_radius * 0.55, 0.0, TAU, 18, Color(1.0, 0.74, 0.70, 0.22 + marker_pulse * 0.16), 2.0, true)
	for falling_rock in cave_falling_rocks:
		var rock_pos: Vector2 = Vector2(falling_rock["position"])
		var rock_size: Vector2 = Vector2(falling_rock["size"])
		var fall_progress: float = clampf(1.0 - float(falling_rock["time"]) / max(0.01, float(falling_rock["total"])), 0.0, 0.999)
		var frame_index: int = clampi(int(floor(fall_progress * float(max(1, falling_rock_frames.size())))), 0, max(0, falling_rock_frames.size() - 1))
		var rock_draw_rect: Rect2 = Rect2(rock_pos - rock_size * 0.5, rock_size)
		if not falling_rock_frames.is_empty() and falling_rock_frames[frame_index] != null:
			draw_texture_rect(falling_rock_frames[frame_index], rock_draw_rect, false)
		else:
			draw_circle(rock_pos, rock_size.x * 0.38, Color(0.54, 0.46, 0.42))
		draw_circle(Vector2(rock_pos.x, Vector2(falling_rock["target"]).y), float(falling_rock["impact_radius"]) * 0.34, Color(0.92, 0.32, 0.28, 0.16))


func _draw_cave_minimap() -> void:
	if not inside_cave:
		return
	var map_rect := Rect2(Vector2(980, 92), Vector2(248, 176))
	draw_rect(map_rect, Color(0.04, 0.05, 0.07, 0.92), true)
	draw_rect(map_rect, Color(0.70, 0.76, 0.84, 0.30), false, 2.0)
	draw_string(ThemeDB.fallback_font, map_rect.position + Vector2(14, 22), "Cave Map", HORIZONTAL_ALIGNMENT_LEFT, 120, 18, TEXT_COLOR)
	var room_positions := {
		"entrance": Vector2(16, 74),
		"ruin_hub": Vector2(60, 74),
		"mine_crossroads": Vector2(104, 74),
		"fountain_room": Vector2(148, 74),
		"lava_forge": Vector2(192, 74),
		"crystal_boss": Vector2(236, 74)
	}
	var room_order := ["entrance", "ruin_hub", "mine_crossroads", "fountain_room", "lava_forge", "crystal_boss"]
	for room_key in room_positions.keys():
		if not bool(cave_seen_rooms.get(room_key, false)):
			continue
		var room_pos: Vector2 = map_rect.position + room_positions[room_key]
		var room_size := Vector2(28, 20)
		var room_color := Color(0.22, 0.26, 0.30)
		if room_key == cave_room_id:
			room_color = MAGIC_COLOR
		elif String(cave_rooms[room_key].get("lock", "")) == "small_key":
			room_color = CAVE_KEY_COLOR
		draw_rect(Rect2(room_pos, room_size), room_color, true)
		draw_rect(Rect2(room_pos, room_size), Color(1, 1, 1, 0.18), false, 1.0)
		var room_index: int = room_order.find(room_key)
		if room_index != -1 and room_index < room_order.size() - 1:
			var next_room_pos: Vector2 = map_rect.position + room_positions[String(room_order[room_index + 1])]
			draw_line(room_pos + Vector2(room_size.x, room_size.y * 0.5), next_room_pos + Vector2(0, room_size.y * 0.5), Color(0.74, 0.80, 0.90, 0.24), 2.0)
	draw_string(ThemeDB.fallback_font, map_rect.position + Vector2(14, 154), "Boss waits in Crystal Cave", HORIZONTAL_ALIGNMENT_LEFT, 208, 15, Color(0.92, 0.84, 0.98))


func _current_player_run_texture() -> Texture2D:
	var run_frame: int = int(floor(world_time * 10.0)) % 5
	match run_frame:
		0:
			return player_run_1_texture
		1:
			return player_run_2_texture
		2:
			return player_run_3_texture
		3:
			return player_run_4_texture
		_:
			return player_run_5_texture


func _current_cave_miner_texture() -> Texture2D:
	var walk_frame: int = int(floor(world_time * 7.0)) % 3
	match walk_frame:
		0:
			return cave_miner_walk_1_texture
		1:
			return cave_miner_walk_2_texture
		_:
			return cave_miner_walk_3_texture


func _boss_display_texture(cave_enemy: Dictionary) -> Texture2D:
	var slam_timer: float = float(cave_enemy.get("slam_timer", 0.0))
	if slam_timer > 0.0 and not cave_boss_slam_frames.is_empty():
		var slam_progress: float = clampf(1.0 - slam_timer / CAVE_BOSS_SLAM_WINDUP, 0.0, 0.999)
		var frame_index: int = clampi(int(floor(slam_progress * float(cave_boss_slam_frames.size()))), 0, cave_boss_slam_frames.size() - 1)
		var slam_texture: Texture2D = cave_boss_slam_frames[frame_index]
		if slam_texture != null:
			return slam_texture
	var attacking: bool = float(cave_enemy.get("attack_timer", 0.0)) > 0.0
	if attacking and cave_boss_attack_texture != null:
		return cave_boss_attack_texture
	var stunned: bool = float(cave_enemy.get("stun_timer", 0.0)) > 0.0
	if not stunned:
		var walk_texture: Texture2D = _current_boss_walk_texture()
		if walk_texture != null:
			return walk_texture
	return cave_boss_texture


func _current_boss_walk_texture() -> Texture2D:
	var walk_frame: int = int(floor(world_time * 6.5)) % 3
	match walk_frame:
		0:
			return cave_boss_walk_1_texture if cave_boss_walk_1_texture != null else cave_boss_texture
		1:
			return cave_boss_walk_2_texture if cave_boss_walk_2_texture != null else cave_boss_texture
		_:
			return cave_boss_walk_3_texture if cave_boss_walk_3_texture != null else cave_boss_texture


func _current_robot_walk_texture() -> Texture2D:
	var walk_frame: int = int(floor(world_time * 7.5)) % 3
	match walk_frame:
		0:
			return irs_robot_walk_1_texture if irs_robot_walk_1_texture != null else irs_robot_texture
		1:
			return irs_robot_walk_2_texture if irs_robot_walk_2_texture != null else irs_robot_texture
		_:
			return irs_robot_walk_3_texture if irs_robot_walk_3_texture != null else irs_robot_texture


func _current_runner_texture() -> Texture2D:
	var run_frame: int = int(floor(world_time * 10.0)) % 7
	match run_frame:
		0:
			return irs_agent_run_1_texture
		1:
			return irs_agent_run_2_texture
		2:
			return irs_agent_run_3_texture
		3:
			return irs_agent_run_4_texture
		4:
			return irs_agent_run_5_texture
		5:
			return irs_agent_run_6_texture
		_:
			return irs_agent_run_7_texture


func _current_robot_death_texture(corpse_time: float) -> Texture2D:
	var frame_index: int = mini(2, int(floor(corpse_time / ROBOT_DEATH_FRAME_TIME)))
	match frame_index:
		0:
			return irs_robot_death_1_texture if irs_robot_death_1_texture != null else irs_robot_texture
		1:
			return irs_robot_death_2_texture if irs_robot_death_2_texture != null else irs_robot_texture
		_:
			return irs_robot_death_3_texture if irs_robot_death_3_texture != null else irs_robot_texture


func _current_cave_miner_death_texture(corpse_time: float) -> Texture2D:
	var frame_index: int = mini(2, int(floor(corpse_time / CAVE_MINER_DEATH_FRAME_TIME)))
	match frame_index:
		0:
			return cave_miner_death_1_texture if cave_miner_death_1_texture != null else cave_miner_walk_3_texture
		1:
			return cave_miner_death_2_texture if cave_miner_death_2_texture != null else cave_miner_walk_3_texture
		_:
			return cave_miner_death_3_texture if cave_miner_death_3_texture != null else cave_miner_walk_3_texture


func _draw_cave_miner_shovel(enemy_rect: Rect2, facing_left: bool, attack_timer: float) -> void:
	if cave_miner_shovel_texture == null:
		return
	var swing_progress: float = 1.0 - clampf(attack_timer / 0.24, 0.0, 1.0)
	var shovel_pivot: Vector2 = enemy_rect.position + Vector2(enemy_rect.size.x * 0.5, enemy_rect.size.y * 0.42)
	var side_sign: float = -1.0 if facing_left else 1.0
	var shovel_position: Vector2 = shovel_pivot + Vector2(14.0 * side_sign, -2.0 + sin(swing_progress * PI) * 3.0)
	var shovel_rotation: float = side_sign * lerpf(-0.35, 1.05, swing_progress)
	draw_set_transform(shovel_position, shovel_rotation, Vector2(side_sign, 1.0))
	draw_texture_rect(cave_miner_shovel_texture, Rect2(Vector2(-10, -26), Vector2(20, 34)), false)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _cave_zone_palette(zone: int) -> Dictionary:
	match zone:
		1:
			return {"floor": Color(0.20, 0.19, 0.16), "shadow": Color(0.10, 0.09, 0.08), "trim": Color(0.54, 0.51, 0.44), "accent": Color(0.66, 0.60, 0.46)}
		2:
			return {"floor": Color(0.18, 0.18, 0.19), "shadow": Color(0.08, 0.08, 0.09), "trim": Color(0.58, 0.62, 0.66), "accent": Color(0.76, 0.78, 0.84)}
		3:
			return {"floor": Color(0.22, 0.15, 0.12), "shadow": Color(0.12, 0.07, 0.06), "trim": Color(0.74, 0.44, 0.28), "accent": Color(0.92, 0.60, 0.30)}
		4:
			return {"floor": Color(0.15, 0.13, 0.20), "shadow": Color(0.08, 0.06, 0.11), "trim": Color(0.62, 0.56, 0.86), "accent": Color(0.82, 0.76, 1.0)}
		_:
			return {"floor": Color(0.17, 0.20, 0.15), "shadow": Color(0.08, 0.10, 0.07), "trim": Color(0.44, 0.56, 0.40), "accent": Color(0.66, 0.78, 0.58)}


func _draw_cave_floor_biome(room: Dictionary, floor_rect: Rect2, zone_colors: Dictionary) -> void:
	draw_rect(floor_rect, Color(zone_colors["floor"]), true)
	var accent_color: Color = Color(zone_colors["accent"])
	draw_rect(Rect2(floor_rect.position + Vector2(18, 18), floor_rect.size - Vector2(36, 36)), accent_color.darkened(0.38), false, 2.0)
	for glow_band_index in range(5):
		var glow_rect := Rect2(floor_rect.position + Vector2(26 + glow_band_index * 172, 34 + float(glow_band_index % 2) * 72.0), Vector2(118, 34))
		var glow_color: Color = accent_color.darkened(0.16)
		draw_rect(glow_rect, Color(glow_color.r, glow_color.g, glow_color.b, 0.08), true)
	for ridge_index in range(9):
		var ridge_y: float = floor_rect.position.y + 28 + ridge_index * 50
		var ridge_wave: float = sin(float(ridge_index) * 0.7 + world_time * 0.2) * 8.0
		draw_line(
			Vector2(floor_rect.position.x + 18, ridge_y + ridge_wave),
			Vector2(floor_rect.end.x - 18, ridge_y - ridge_wave * 0.35),
			Color(zone_colors["shadow"]).lightened(0.08),
			2.0
		)
	for seam_index in range(7):
		var seam_x: float = floor_rect.position.x + 54 + seam_index * 126
		draw_line(
			Vector2(seam_x, floor_rect.position.y + 16),
			Vector2(seam_x + sin(float(seam_index) * 1.1) * 18.0, floor_rect.end.y - 18),
			Color(zone_colors["shadow"]).lightened(0.04),
			2.0
		)
	for pebble_index in range(24):
		var pebble_x: float = floor_rect.position.x + 40 + float((pebble_index * 73) % 860)
		var pebble_y: float = floor_rect.position.y + 40 + float((pebble_index * 47) % 390)
		var pebble_size: Vector2 = Vector2(6 + (pebble_index % 3) * 3, 4 + (pebble_index % 2) * 2)
		draw_rect(Rect2(Vector2(pebble_x, pebble_y), pebble_size), Color(zone_colors["shadow"]).lightened(0.05), true)


func _draw_cave_connection_mouths(room: Dictionary, floor_rect: Rect2, zone_colors: Dictionary) -> void:
	var tunnel_color := Color(zone_colors["shadow"]).darkened(0.18)
	var lip_color := Color(zone_colors["trim"]).darkened(0.15)
	var neighbors: Dictionary = room.get("neighbors", {})
	var shortcuts: Dictionary = room.get("shortcuts", {})
	if String(neighbors.get("left", "")) != "":
		var left_open := _cave_connection_trigger_rect("left")
		var left_target: String = String(neighbors["left"])
		draw_colored_polygon(PackedVector2Array([
			left_open.position + Vector2(left_open.size.x, 0),
			left_open.position + Vector2(10, 8),
			left_open.position + Vector2(0, left_open.size.y * 0.5),
			left_open.position + Vector2(10, left_open.size.y - 8),
			left_open.position + Vector2(left_open.size.x, left_open.size.y)
		]), tunnel_color)
		draw_rect(left_open, lip_color, false, 3.0)
		draw_string(ThemeDB.fallback_font, left_open.position + Vector2(6, -6), _cave_room_name(left_target), HORIZONTAL_ALIGNMENT_LEFT, 160, 14, MUTED_TEXT_COLOR)
		_draw_cave_gate_hint(left_open, left_target, room)
	if String(neighbors.get("right", "")) != "":
		var right_open := _cave_connection_trigger_rect("right")
		var right_target: String = String(neighbors["right"])
		draw_colored_polygon(PackedVector2Array([
			right_open.position + Vector2(0, 0),
			right_open.position + Vector2(right_open.size.x - 10, 8),
			right_open.position + Vector2(right_open.size.x, right_open.size.y * 0.5),
			right_open.position + Vector2(right_open.size.x - 10, right_open.size.y - 8),
			right_open.position + Vector2(0, right_open.size.y)
		]), tunnel_color)
		draw_rect(right_open, lip_color, false, 3.0)
		draw_string(ThemeDB.fallback_font, right_open.position + Vector2(-92, -6), _cave_room_name(right_target), HORIZONTAL_ALIGNMENT_LEFT, 160, 14, MUTED_TEXT_COLOR)
		_draw_cave_gate_hint(right_open, right_target, room)
	if String(neighbors.get("up", "")) != "" or shortcuts.has("up"):
		var top_open := _cave_connection_trigger_rect("up")
		var up_target: String = String(neighbors.get("up", ""))
		draw_colored_polygon(PackedVector2Array([
			top_open.position + Vector2(0, top_open.size.y),
			top_open.position + Vector2(8, 12),
			top_open.position + Vector2(top_open.size.x * 0.5, 0),
			top_open.position + Vector2(top_open.size.x - 8, 12),
			top_open.position + Vector2(top_open.size.x, top_open.size.y)
		]), tunnel_color)
		draw_rect(top_open, lip_color, false, 3.0)
		var up_label: String = _cave_room_name(up_target) if up_target != "" else "Forest Shortcut"
		draw_string(ThemeDB.fallback_font, top_open.position + Vector2(-8, -8), up_label, HORIZONTAL_ALIGNMENT_LEFT, 180, 14, MUTED_TEXT_COLOR)
		if up_target != "":
			_draw_cave_gate_hint(top_open, up_target, room)
		elif not cave_shortcuts_unlocked.has(String(shortcuts.get("up", ""))):
			_draw_cave_shortcut_hint(top_open, false)
	if String(neighbors.get("down", "")) != "":
		var bottom_open := _cave_connection_trigger_rect("down")
		var down_target: String = String(neighbors["down"])
		draw_colored_polygon(PackedVector2Array([
			bottom_open.position + Vector2(0, 0),
			bottom_open.position + Vector2(8, bottom_open.size.y - 12),
			bottom_open.position + Vector2(bottom_open.size.x * 0.5, bottom_open.size.y),
			bottom_open.position + Vector2(bottom_open.size.x - 8, bottom_open.size.y - 12),
			bottom_open.position + Vector2(bottom_open.size.x, 0)
		]), tunnel_color)
		draw_rect(bottom_open, lip_color, false, 3.0)
		draw_string(ThemeDB.fallback_font, bottom_open.position + Vector2(-8, 66), _cave_room_name(down_target), HORIZONTAL_ALIGNMENT_LEFT, 180, 14, MUTED_TEXT_COLOR)
		_draw_cave_gate_hint(bottom_open, down_target, room)


func _draw_cave_gate_hint(open_rect: Rect2, target_room_id: String, room: Dictionary) -> void:
	var target_room: Dictionary = cave_rooms.get(target_room_id, {})
	if target_room.is_empty():
		return
	var lock_type: String = String(target_room.get("lock", ""))
	if lock_type == "" or lock_type == "opened":
		return
	var badge_rect: Rect2 = Rect2(open_rect.position + open_rect.size * 0.5 - Vector2(32, 12), Vector2(64, 24))
	draw_rect(badge_rect, Color(0.09, 0.10, 0.12, 0.88), true)
	draw_rect(badge_rect, Color(0.76, 0.66, 0.40), false, 2.0)
	var badge_text: String = "LOCKED"
	if lock_type == "small_key":
		badge_text = "KEY"
	elif lock_type.begins_with("switch:"):
		badge_text = "SWITCH"
	draw_string(ThemeDB.fallback_font, badge_rect.position + Vector2(8, 17), badge_text, HORIZONTAL_ALIGNMENT_LEFT, 52, 14, Color(1.0, 0.92, 0.74))


func _draw_cave_shortcut_hint(open_rect: Rect2, unlocked: bool) -> void:
	var badge_rect: Rect2 = Rect2(open_rect.position + open_rect.size * 0.5 - Vector2(38, 12), Vector2(76, 24))
	draw_rect(badge_rect, Color(0.07, 0.08, 0.10, 0.84), true)
	draw_rect(badge_rect, Color(0.54, 0.70, 0.56), false, 2.0)
	draw_string(ThemeDB.fallback_font, badge_rect.position + Vector2(8, 17), "SHORTCUT" if unlocked else "SEALED", HORIZONTAL_ALIGNMENT_LEFT, 64, 14, Color(0.86, 0.96, 0.88))


func _draw_cave_rock_intrusions(room: Dictionary, floor_rect: Rect2, zone_colors: Dictionary) -> void:
	var room_seed: int = abs(String(room.get("name", "room")).hash())
	var wall_color := Color(zone_colors["shadow"]).darkened(0.05)
	for top_index in range(7):
		var x0: float = floor_rect.position.x + top_index * 138.0
		var width: float = 78.0 + float((room_seed + top_index * 13) % 34)
		var depth: float = 24.0 + float((room_seed + top_index * 17) % 56)
		draw_colored_polygon(PackedVector2Array([
			Vector2(x0, floor_rect.position.y),
			Vector2(x0 + width * 0.18, floor_rect.position.y + depth * 0.55),
			Vector2(x0 + width * 0.46, floor_rect.position.y + depth),
			Vector2(x0 + width, floor_rect.position.y + depth * 0.42),
			Vector2(x0 + width, floor_rect.position.y)
		]), wall_color)
	for bottom_index in range(8):
		var bx: float = floor_rect.position.x + bottom_index * 124.0
		var bwidth: float = 84.0 + float((room_seed + bottom_index * 11) % 32)
		var bheight: float = 26.0 + float((room_seed + bottom_index * 19) % 46)
		draw_colored_polygon(PackedVector2Array([
			Vector2(bx, floor_rect.end.y),
			Vector2(bx + bwidth * 0.18, floor_rect.end.y - bheight * 0.44),
			Vector2(bx + bwidth * 0.54, floor_rect.end.y - bheight),
			Vector2(bx + bwidth, floor_rect.end.y - bheight * 0.36),
			Vector2(bx + bwidth, floor_rect.end.y)
		]), wall_color)
	for side_index in range(4):
		var side_y: float = floor_rect.position.y + 48 + side_index * 102.0
		var side_depth: float = 22.0 + float((room_seed + side_index * 23) % 28)
		draw_colored_polygon(PackedVector2Array([
			Vector2(floor_rect.position.x, side_y),
			Vector2(floor_rect.position.x + side_depth, side_y + 12),
			Vector2(floor_rect.position.x + side_depth * 0.7, side_y + 60),
			Vector2(floor_rect.position.x, side_y + 72)
		]), wall_color)
		draw_colored_polygon(PackedVector2Array([
			Vector2(floor_rect.end.x, side_y + 10),
			Vector2(floor_rect.end.x - side_depth, side_y + 20),
			Vector2(floor_rect.end.x - side_depth * 0.6, side_y + 78),
			Vector2(floor_rect.end.x, side_y + 92)
		]), wall_color)


func _draw_cave_room_set_pieces(room: Dictionary, floor_rect: Rect2, zone_colors: Dictionary) -> void:
	var zone: int = int(room.get("zone", 0))
	var room_id: String = String(room.get("name", ""))
	for stalagmite_index in range(6):
		var stalagmite_pos := floor_rect.position + Vector2(76 + stalagmite_index * 154, floor_rect.end.y - 22 - float(stalagmite_index % 2) * 28.0)
		draw_colored_polygon(PackedVector2Array([
			stalagmite_pos + Vector2(-16, 10),
			stalagmite_pos + Vector2(0, -34),
			stalagmite_pos + Vector2(14, 10)
		]), Color(zone_colors["shadow"]).lightened(0.04))
	match zone:
		0:
			for patch_index in range(5):
				var moss_rect := Rect2(floor_rect.position + Vector2(92 + patch_index * 164, 112 + float(patch_index % 2) * 168.0), Vector2(78, 26))
				draw_rect(moss_rect, Color(zone_colors["accent"]).darkened(0.15), true)
				draw_rect(Rect2(moss_rect.position + Vector2(8, 6), Vector2(18, 6)), Color(zone_colors["accent"]).lightened(0.08), true)
		1:
			for pillar_index in range(3):
				var pillar_rect := Rect2(floor_rect.position + Vector2(170 + pillar_index * 248, 178), Vector2(42, 168))
				draw_rect(pillar_rect, Color(zone_colors["trim"]).darkened(0.20), true)
				draw_rect(Rect2(pillar_rect.position + Vector2(-8, -14), Vector2(58, 18)), Color(zone_colors["trim"]), true)
				draw_rect(Rect2(pillar_rect.position + Vector2(8, 24), Vector2(10, 112)), Color(zone_colors["shadow"]).lightened(0.06), true)
		2:
			for rail_index in range(4):
				var rail_y: float = floor_rect.position.y + 136 + rail_index * 82
				draw_line(Vector2(floor_rect.position.x + 64, rail_y), Vector2(floor_rect.end.x - 78, rail_y + 16), Color(zone_colors["trim"]), 3.0)
				draw_line(Vector2(floor_rect.position.x + 64, rail_y + 12), Vector2(floor_rect.end.x - 78, rail_y + 28), Color(zone_colors["trim"]).darkened(0.18), 3.0)
				for sleeper_index in range(6):
					draw_line(Vector2(floor_rect.position.x + 96 + sleeper_index * 128, rail_y + 2), Vector2(floor_rect.position.x + 120 + sleeper_index * 128, rail_y + 20), Color(zone_colors["shadow"]).lightened(0.08), 4.0)
		3:
			for lava_index in range(3):
				var lava_rect := Rect2(floor_rect.position + Vector2(120 + lava_index * 230, 356 - float(lava_index % 2) * 48.0), Vector2(134, 34))
				draw_rect(lava_rect, Color(0.78, 0.26, 0.08), true)
				draw_rect(Rect2(lava_rect.position + Vector2(0, 6), lava_rect.size - Vector2(0, 10)), Color(0.98, 0.54, 0.16), true)
				draw_arc(lava_rect.position + Vector2(lava_rect.size.x * 0.5, lava_rect.size.y * 0.5), 44.0, 0.0, TAU, 20, Color(1.0, 0.72, 0.34, 0.18), 5.0, true)
		4:
			for crystal_index in range(6):
				var crystal_pos := floor_rect.position + Vector2(110 + crystal_index * 132, 120 + float((crystal_index * 43) % 210))
				draw_colored_polygon(PackedVector2Array([
					crystal_pos + Vector2(0, -16),
					crystal_pos + Vector2(12, 0),
					crystal_pos + Vector2(0, 18),
					crystal_pos + Vector2(-12, 0)
				]), Color(zone_colors["accent"]))
				var crystal_glow: Color = Color(zone_colors["accent"])
				draw_arc(crystal_pos, 20.0, 0.0, TAU, 18, Color(crystal_glow.r, crystal_glow.g, crystal_glow.b, 0.18), 3.0, true)
	_draw_cave_room_landmarks(room_id, floor_rect, zone_colors)


func _draw_cave_room_landmarks(room_id: String, floor_rect: Rect2, zone_colors: Dictionary) -> void:
	match room_id:
		"Moss Mouth":
			for root_index in range(5):
				var root_x: float = floor_rect.position.x + 90 + root_index * 180.0
				draw_line(Vector2(root_x, floor_rect.position.y + 6), Vector2(root_x - 34 + float(root_index % 2) * 18.0, floor_rect.position.y + 132), Color(0.20, 0.12, 0.08), 7.0)
				draw_line(Vector2(root_x, floor_rect.position.y + 10), Vector2(root_x + 28 - float(root_index % 2) * 16.0, floor_rect.position.y + 118), Color(0.26, 0.16, 0.10), 5.0)
		"Root Warren":
			for hollow_index in range(3):
				var hollow_rect := Rect2(floor_rect.position + Vector2(160 + hollow_index * 226, 246 + float(hollow_index % 2) * 44.0), Vector2(90, 56))
				draw_arc(hollow_rect.position + Vector2(hollow_rect.size.x * 0.5, hollow_rect.size.y), hollow_rect.size.x * 0.52, PI, TAU, 24, Color(0.28, 0.18, 0.10), 8.0)
		"Green Hall":
			for lantern_index in range(4):
				var lantern_pos := floor_rect.position + Vector2(152 + lantern_index * 198, 86)
				draw_line(lantern_pos + Vector2(0, -28), lantern_pos, Color(0.42, 0.34, 0.20), 2.0)
				draw_circle(lantern_pos, 9.0, Color(0.78, 0.92, 0.58, 0.66))
				draw_circle(lantern_pos, 18.0, Color(0.52, 0.80, 0.40, 0.14))
		"Hidden Hollow":
			var altar_rect := Rect2(floor_rect.position + Vector2(744, 148), Vector2(132, 82))
			draw_rect(altar_rect, Color(0.22, 0.18, 0.16), true)
			draw_rect(altar_rect, Color(zone_colors["trim"]).lightened(0.18), false, 3.0)
			draw_rect(Rect2(altar_rect.position + Vector2(18, 24), Vector2(96, 18)), Color(zone_colors["accent"]).lightened(0.04), true)
		"Canopy Bend":
			draw_colored_polygon(PackedVector2Array([
				floor_rect.position + Vector2(714, 118),
				floor_rect.position + Vector2(822, 70),
				floor_rect.position + Vector2(904, 122),
				floor_rect.position + Vector2(860, 196),
				floor_rect.position + Vector2(756, 184)
			]), Color(0.12, 0.18, 0.10))
		"Ruin Gate":
			var gate_rect := Rect2(floor_rect.position + Vector2(734, 118), Vector2(132, 198))
			draw_rect(gate_rect, Color(0.20, 0.20, 0.22), true)
			draw_rect(gate_rect, Color(zone_colors["trim"]).lightened(0.10), false, 4.0)
			for bar_index in range(4):
				draw_line(gate_rect.position + Vector2(24 + bar_index * 26, 18), gate_rect.position + Vector2(24 + bar_index * 26, 176), Color(0.50, 0.54, 0.58), 4.0)
		"Old Ruins":
			for broken_wall_index in range(3):
				var broken_wall := Rect2(floor_rect.position + Vector2(128 + broken_wall_index * 250, 252 - float(broken_wall_index % 2) * 24.0), Vector2(112, 54))
				draw_rect(broken_wall, Color(0.38, 0.38, 0.40), true)
				draw_rect(Rect2(broken_wall.position + Vector2(18, 18), Vector2(22, 12)), Color(0.26, 0.26, 0.28), true)
		"Ruin Archive":
			for shelf_index in range(3):
				var shelf_rect := Rect2(floor_rect.position + Vector2(166 + shelf_index * 248, 150), Vector2(94, 146))
				draw_rect(shelf_rect, Color(0.28, 0.22, 0.16), true)
				for book_row in range(4):
					draw_rect(Rect2(shelf_rect.position + Vector2(10, 14 + book_row * 30), Vector2(74, 10)), Color(zone_colors["accent"]).darkened(0.20 + float(book_row) * 0.04), true)
		"Mine Entry":
			for support_index in range(3):
				var support_x: float = floor_rect.position.x + 160 + support_index * 254.0
				draw_line(Vector2(support_x, floor_rect.position.y + 122), Vector2(support_x, floor_rect.end.y - 52), Color(0.42, 0.28, 0.14), 8.0)
				draw_line(Vector2(support_x + 72, floor_rect.position.y + 122), Vector2(support_x + 72, floor_rect.end.y - 52), Color(0.42, 0.28, 0.14), 8.0)
				draw_line(Vector2(support_x - 10, floor_rect.position.y + 126), Vector2(support_x + 82, floor_rect.position.y + 126), Color(0.50, 0.34, 0.18), 10.0)
		"Mine Crossroads":
			draw_line(floor_rect.position + Vector2(118, 214), floor_rect.position + Vector2(824, 214), Color(0.58, 0.52, 0.40), 4.0)
			draw_line(floor_rect.position + Vector2(456, 94), floor_rect.position + Vector2(456, 392), Color(0.58, 0.52, 0.40), 4.0)
			draw_rect(Rect2(floor_rect.position + Vector2(420, 182), Vector2(72, 54)), Color(0.18, 0.14, 0.10), true)
		"Switch Gallery":
			var switch_pad := Rect2(floor_rect.position + Vector2(738, 234), Vector2(138, 92))
			draw_rect(switch_pad, Color(0.18, 0.18, 0.20), true)
			draw_rect(switch_pad, Color(zone_colors["trim"]).lightened(0.10), false, 3.0)
			draw_circle(switch_pad.position + switch_pad.size * 0.5, 18.0, Color(0.90, 0.54, 0.26))
		"Mine Depths":
			draw_line(floor_rect.position + Vector2(118, 136), floor_rect.position + Vector2(826, 330), Color(0.66, 0.60, 0.48), 4.0)
			draw_line(floor_rect.position + Vector2(118, 148), floor_rect.position + Vector2(826, 342), Color(0.48, 0.42, 0.32), 4.0)
		"Quarry Overlook":
			var pit_rect := Rect2(floor_rect.position + Vector2(542, 164), Vector2(240, 172))
			draw_rect(pit_rect, Color(0.08, 0.08, 0.09, 0.68), true)
			draw_rect(pit_rect, Color(zone_colors["trim"]).darkened(0.12), false, 3.0)
		"Ore Cache":
			for cache_index in range(4):
				var ore_rect := Rect2(floor_rect.position + Vector2(172 + cache_index * 162, 286 - float(cache_index % 2) * 42.0), Vector2(44, 34))
				draw_rect(ore_rect, Color(0.62, 0.62, 0.68), true)
				draw_rect(ore_rect.grow(4.0), Color(0.12, 0.12, 0.13, 0.46), false, 2.0)
		"Gunpowder Depths":
			for keg_index in range(4):
				var keg_rect := Rect2(floor_rect.position + Vector2(156 + keg_index * 184, 286 + float(keg_index % 2) * 24.0), Vector2(44, 56))
				draw_rect(keg_rect, Color(0.38, 0.22, 0.14), true)
				draw_rect(Rect2(keg_rect.position + Vector2(0, 10), Vector2(keg_rect.size.x, 6)), Color(0.20, 0.14, 0.10), true)
				draw_rect(Rect2(keg_rect.position + Vector2(0, 40), Vector2(keg_rect.size.x, 6)), Color(0.20, 0.14, 0.10), true)
		"Forge Channel":
			var bridge_rect := Rect2(floor_rect.position + Vector2(254, 244), Vector2(444, 46))
			draw_rect(bridge_rect, Color(0.40, 0.24, 0.12), true)
			draw_rect(bridge_rect, Color(0.74, 0.50, 0.22), false, 3.0)
		"Ash Gallery":
			for ash_index in range(5):
				var ash_pos := floor_rect.position + Vector2(148 + ash_index * 164, 190 + float(ash_index % 2) * 98.0)
				draw_circle(ash_pos, 18.0 + float(ash_index % 3) * 7.0, Color(0.22, 0.18, 0.18, 0.34))
		"Forge Store":
			for crate_index in range(4):
				var crate_rect := Rect2(floor_rect.position + Vector2(142 + crate_index * 178, 280 + float(crate_index % 2) * 18.0), Vector2(58, 50))
				draw_rect(crate_rect, Color(0.40, 0.26, 0.16), true)
				draw_line(crate_rect.position, crate_rect.end, Color(0.64, 0.44, 0.24), 2.0)
				draw_line(crate_rect.position + Vector2(crate_rect.size.x, 0), crate_rect.position + Vector2(0, crate_rect.size.y), Color(0.64, 0.44, 0.24), 2.0)
		"Crystal Threshold":
			for shrine_index in range(2):
				var shrine_rect := Rect2(floor_rect.position + Vector2(228 + shrine_index * 410, 186), Vector2(82, 132))
				draw_rect(shrine_rect, Color(0.20, 0.18, 0.26), true)
				draw_rect(shrine_rect, Color(zone_colors["trim"]).lightened(0.10), false, 3.0)
				draw_circle(shrine_rect.position + Vector2(shrine_rect.size.x * 0.5, 24), 12.0, Color(zone_colors["accent"]))
		"Crystal Overlook":
			draw_line(floor_rect.position + Vector2(112, 356), floor_rect.position + Vector2(796, 122), Color(0.78, 0.74, 0.96), 3.0)
			draw_line(floor_rect.position + Vector2(124, 372), floor_rect.position + Vector2(808, 138), Color(0.54, 0.50, 0.72), 2.0)
		"Crystal Cave":
			var altar_center := floor_rect.position + Vector2(floor_rect.size.x * 0.5, 176)
			draw_arc(altar_center, 86.0, 0.0, TAU, 24, Color(zone_colors["accent"]).lightened(0.10), 6.0, true)
			draw_arc(altar_center, 52.0, 0.0, TAU, 24, Color(zone_colors["trim"]).lightened(0.08), 4.0, true)
			for web_index in range(5):
				var web_anchor := floor_rect.position + Vector2(132 + web_index * 182, 72 + float(web_index % 2) * 12.0)
				draw_line(web_anchor, altar_center + Vector2(-160 + web_index * 82, 46), Color(0.84, 0.84, 0.92, 0.18), 1.5)


func _draw_turret_status_badges(structure: Dictionary, turret_center: Vector2, weapon: String) -> void:
	var ammo: int = int(structure.get("ammo", _turret_starting_ammo_for_weapon(weapon)))
	var max_ammo: int = max(1, int(structure.get("max_ammo", _turret_starting_ammo_for_weapon(weapon))))
	var ammo_ratio: float = clampf(float(ammo) / float(max_ammo), 0.0, 1.0)
	var badge_rect := Rect2(turret_center + Vector2(-18, -26), Vector2(36, 6))
	draw_rect(badge_rect, Color(0.04, 0.05, 0.06, 0.82), true)
	draw_rect(Rect2(badge_rect.position, Vector2(badge_rect.size.x * ammo_ratio, badge_rect.size.y)), _turret_projectile_color(structure), true)
	draw_rect(badge_rect, Color(1, 1, 1, 0.18), false, 1.0)
	if ammo_ratio <= 0.25 and weapon != "magic":
		draw_circle(turret_center + Vector2(0, -34), 4.0, Color(1.0, 0.32, 0.24, 0.92))
		draw_circle(turret_center + Vector2(0, -34), 7.0, Color(1.0, 0.32, 0.24, 0.18))


func _draw_house_item_display(display_position: Vector2, item_name: String, is_stolen: bool) -> void:
	var pedestal_rect := Rect2(display_position, Vector2(142, 70))
	var trim_color := HOUSE_DANGER_COLOR if is_stolen else Color(0.90, 0.84, 0.68)
	var base_color := Color(0.31, 0.22, 0.18) if not is_stolen else HOUSE_DANGER_COLOR.darkened(0.35)
	draw_rect(pedestal_rect, base_color, true)
	draw_rect(pedestal_rect, trim_color, false, 2.0)
	var icon_rect := Rect2(display_position + Vector2(10, 12), HOUSE_ITEM_DRAW_SIZE)
	var item_texture: Texture2D = _house_item_texture(item_name)
	if item_texture != null:
		draw_texture_rect(item_texture, icon_rect, false)
	else:
		draw_rect(icon_rect, Color(0.56, 0.38, 0.24), true)
	if is_stolen:
		draw_line(icon_rect.position + Vector2(2, 2), icon_rect.end - Vector2(2, 2), HOUSE_DANGER_COLOR, 3.0)
		draw_line(icon_rect.position + Vector2(icon_rect.size.x - 2, 2), icon_rect.position + Vector2(2, icon_rect.size.y - 2), HOUSE_DANGER_COLOR, 3.0)
	var display_name: String = _house_item_display_name(item_name)
	draw_string(ThemeDB.fallback_font, display_position + Vector2(54, 24), display_name, HORIZONTAL_ALIGNMENT_LEFT, 92, 14, TEXT_COLOR if not is_stolen else Color(1.0, 0.90, 0.90))


func _house_item_display_name(item_name: String) -> String:
	match item_name:
		"KFZ Air Fryer Console":
			return "KFZ Console"
		"Family Portrait":
			return "Family Portrait"
		"Tax Papers":
			return "Tax Papers"
		"Couch Coins":
			return "Couch Coins"
		"Lucky Mug":
			return "Lucky Mug"
		_:
			return item_name


func _house_item_texture(item_name: String) -> Texture2D:
	match item_name:
		"Tax Papers":
			return tax_papers_texture
		"Family Portrait":
			return family_photo_texture
		"Couch Coins":
			return couch_coins_texture
		"Lucky Mug":
			return mug_texture
		PRIZED_HOUSE_ITEM:
			return kfz_console_texture
		_:
			return null


func _draw_build_menu() -> void:
	if not build_menu_open or phase != Phase.BUILD or inside_house or inside_cave:
		return
	var panel_rect: Rect2 = _build_menu_panel_rect()
	var hovered_weapon: String = _build_menu_weapon_at_position(get_viewport().get_mouse_position())
	_draw_ui_card(panel_rect, UI_COOL_ACCENT, UI_PANEL_FILL, 2.0)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(22, 28), "Build Defenses", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(22, 50), "Pick a wall or sentry, then place it on an outlined yard tile.", HORIZONTAL_ALIGNMENT_LEFT, 620, 16, MUTED_TEXT_COLOR)
	var sentry_kinds: Array[String] = _available_sentry_kinds()
	for option_index in range(sentry_kinds.size()):
		var option_weapon: String = sentry_kinds[option_index]
		var option_rect: Rect2 = _build_menu_option_rect(panel_rect, option_index)
		_draw_sentry_option(option_rect, option_weapon, _sentry_label(option_weapon), _sentry_price_label(option_weapon), selected_sentry_kind == option_weapon, hovered_weapon == option_weapon)


func _draw_sentry_option(option_rect: Rect2, weapon: String, title: String, price_text: String, is_selected: bool, is_hovered: bool) -> void:
	var fill_color: Color = Color(0.16, 0.19, 0.22, 0.96) if is_selected else Color(0.11, 0.13, 0.16, 0.92)
	if is_hovered:
		fill_color = fill_color.lightened(0.08)
	var accent_color: Color = PROJECTILE_COLOR
	if weapon == "cannon":
		accent_color = Color(0.46, 0.44, 0.40)
	elif weapon == "gun":
		accent_color = Color(0.96, 0.76, 0.28)
	elif weapon == "wall_light":
		accent_color = Color(0.82, 0.67, 0.42)
	elif weapon == "wall_medium":
		accent_color = Color(0.72, 0.74, 0.78)
	elif weapon == "wall_heavy":
		accent_color = Color(0.58, 0.64, 0.72)
	elif weapon == "magic":
		accent_color = MAGIC_COLOR
	_draw_ui_card(option_rect, accent_color if (is_selected or is_hovered) else Color(1, 1, 1, 0.16), fill_color, 2.0, Vector2(0, 4))
	draw_string(ThemeDB.fallback_font, option_rect.position + Vector2(14, 22), title, HORIZONTAL_ALIGNMENT_LEFT, 148, 17, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, option_rect.position + Vector2(14, 42), price_text, HORIZONTAL_ALIGNMENT_LEFT, 150, 14, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, option_rect.position + Vector2(14, 58), String(_sentry_summary_lines(weapon)[0]), HORIZONTAL_ALIGNMENT_LEFT, 164, 13, accent_color)
	var icon_center: Vector2 = option_rect.position + Vector2(option_rect.size.x - 34, option_rect.size.y * 0.5)
	draw_circle(icon_center, 13.0, accent_color)
	if weapon == "wall_light" or weapon == "wall_medium" or weapon == "wall_heavy":
		var wall_width: float = 22.0
		var wall_height: float = 14.0 if weapon == "wall_light" else (18.0 if weapon == "wall_medium" else 22.0)
		draw_rect(Rect2(icon_center - Vector2(wall_width * 0.5, wall_height * 0.5), Vector2(wall_width, wall_height)), accent_color, true)
		draw_rect(Rect2(icon_center - Vector2(wall_width * 0.5, wall_height * 0.5), Vector2(wall_width, wall_height)), Color(0.12, 0.10, 0.08), false, 2.0)
	elif weapon == "cannon":
		draw_circle(icon_center, 5.0, Color(0.16, 0.14, 0.12))
	elif weapon == "gun":
		draw_line(icon_center - Vector2(10, 0), icon_center + Vector2(12, 0), Color(0.16, 0.14, 0.12), 3.0)
		draw_rect(Rect2(icon_center + Vector2(-4, -5), Vector2(10, 10)), accent_color, true)
	elif weapon == "magic":
		draw_colored_polygon(PackedVector2Array([
			icon_center + Vector2(0, -12),
			icon_center + Vector2(10, 0),
			icon_center + Vector2(0, 12),
			icon_center + Vector2(-10, 0)
		]), MAGIC_COLOR)
	else:
		draw_line(icon_center - Vector2(12, 0), icon_center + Vector2(12, 0), Color(0.18, 0.12, 0.06), 3.0)
		draw_line(icon_center + Vector2(4, -7), icon_center + Vector2(12, 0), Color(0.18, 0.12, 0.06), 3.0)
		draw_line(icon_center + Vector2(4, 7), icon_center + Vector2(12, 0), Color(0.18, 0.12, 0.06), 3.0)


func _build_menu_panel_rect() -> Rect2:
	return Rect2(Vector2(108, 378), Vector2(1064, 234))


func _build_menu_option_rect(panel_rect: Rect2, option_index: int) -> Rect2:
	var row: int = option_index / 4
	var col: int = option_index % 4
	return Rect2(panel_rect.position + Vector2(18 + col * 257, 78 + row * 74), Vector2(238, 68))


func _build_menu_weapon_at_position(mouse_position: Vector2) -> String:
	if not build_menu_open or phase != Phase.BUILD or inside_house or inside_cave:
		return ""
	var panel_rect: Rect2 = _build_menu_panel_rect()
	var sentry_kinds: Array[String] = _available_sentry_kinds()
	for option_index in range(sentry_kinds.size()):
		var option_rect: Rect2 = _build_menu_option_rect(panel_rect, option_index)
		if option_rect.has_point(mouse_position):
			return sentry_kinds[option_index]
	return ""


func _draw_sentry_hover_preview(preview_rect: Rect2, weapon: String) -> void:
	_draw_ui_card(preview_rect, UI_COOL_ACCENT, UI_PANEL_FILL_SOFT, 2.0, Vector2(0, 4))
	draw_string(ThemeDB.fallback_font, preview_rect.position + Vector2(16, 24), _sentry_label(weapon), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, TEXT_COLOR)
	var preview_center: Vector2 = preview_rect.position + Vector2(preview_rect.size.x * 0.5, 84)
	_draw_sentry_preview_sprite(preview_center, weapon)
	var summary_lines: PackedStringArray = _sentry_summary_lines(weapon)
	for summary_index in range(summary_lines.size()):
		draw_string(
			ThemeDB.fallback_font,
			preview_rect.position + Vector2(18, 108 + summary_index * 16),
			summary_lines[summary_index],
			HORIZONTAL_ALIGNMENT_LEFT,
			210,
			14,
			MUTED_TEXT_COLOR if summary_index < summary_lines.size() - 1 else Color(0.92, 0.84, 0.48)
		)


func _draw_sentry_preview_sprite(preview_center: Vector2, weapon: String) -> void:
	if weapon == "cannon" and cannon_turret_texture != null:
		draw_texture_rect_region(cannon_turret_texture, Rect2(preview_center - Vector2(CANNON_TURRET_DRAW_SIZE.x * 0.5, CANNON_TURRET_DRAW_SIZE.y * 0.5) + Vector2(0, -10), CANNON_TURRET_DRAW_SIZE), CANNON_TURRET_REGION)
		return
	if weapon == "golden" and golden_turret_texture != null:
		draw_texture_rect_region(golden_turret_texture, Rect2(preview_center - Vector2(GOLDEN_TURRET_DRAW_SIZE.x * 0.5, GOLDEN_TURRET_DRAW_SIZE.y * 0.5) + Vector2(0, -8), GOLDEN_TURRET_DRAW_SIZE), GOLDEN_TURRET_REGION)
		return
	if weapon == "gun" and gun_turret_texture != null:
		draw_texture_rect(gun_turret_texture, Rect2(preview_center - Vector2(52, 68), Vector2(104, 104)), false)
		return
	if weapon == "gun":
		if irs_agent_gun_texture != null:
			draw_texture_rect(irs_agent_gun_texture, Rect2(preview_center - Vector2(28, 4), Vector2(56, 24)), false)
		else:
			_draw_simple_gun_turret(preview_center + Vector2(0, 8), Vector2.RIGHT, false)
		return
	if weapon == "magic" and crystal_sentry_texture != null:
		draw_texture_rect(crystal_sentry_texture, Rect2(preview_center - Vector2(MAGIC_TURRET_DRAW_SIZE.x * 0.5, MAGIC_TURRET_DRAW_SIZE.y * 0.60), MAGIC_TURRET_DRAW_SIZE), false)
		return
	if turret_sprite_texture != null:
		var preview_region: Rect2 = TURRET_LOADED_REGION if weapon == "rifle" or weapon == "golden" else TURRET_IDLE_REGION
		draw_texture_rect_region(turret_sprite_texture, Rect2(preview_center - Vector2(46, 26), Vector2(92, 52)), preview_region)
		return
	draw_circle(preview_center, 26.0, PROJECTILE_COLOR)


func _sentry_summary_lines(weapon: String) -> PackedStringArray:
	match weapon:
		"cannon":
			return PackedStringArray(["Slow heavy splash", "Best for packed waves", "Uses shells"])
		"gun":
			return PackedStringArray(["Fast steady fire", "Strong single-target pressure", "Uses powder to build"])
		"wall_light":
			return PackedStringArray(["Cheap seal", "Fast emergency block", "Low HP"])
		"wall_medium":
			return PackedStringArray(["Balanced wall", "Good all-round stop", "Medium HP"])
		"wall_heavy":
			return PackedStringArray(["Sturdy front line", "Best for choke points", "High HP"])
		"magic":
			return PackedStringArray(["Final crystal sentry", "Longest reach and heavy hits", "Costs 2 cave crystals to place"])
		"golden":
			return PackedStringArray(["Golden minigun sentry", "Long range, steady pressure", "Built from gold"])
		_:
			return PackedStringArray(["Cheap early defense", "Good starter coverage", "Fast to place"])


func _dealer_panel_rect() -> Rect2:
	return Rect2(Vector2(124, 96), Vector2(1032, 528))


func _dealer_items(page: String = "buy") -> Array[Dictionary]:
	var buy_items: Array[Dictionary] = [
		{"id": "unlock_gun_turret", "title": "Unlock Gun Turret", "price": DEALER_GUN_TURRET_UNLOCK_GOLD_COST, "desc": "Adds the gun sentry to the build menu."},
		{"id": "turret_buff", "title": "Turret Buff", "price": DEALER_TURRET_BUFF_GOLD_COST, "desc": "Permanent sentry damage +1."},
		{"id": "buy_turret_ammo", "title": "Turret Ammo", "price": DEALER_TURRET_AMMO_GOLD_COST, "desc": "Refill every non-cannon sentry."},
		{"id": "buy_cannon_shells", "title": "Cannon Shells", "price": DEALER_CANNON_SHELL_GOLD_COST, "desc": "Refill every cannon sentry."},
		{"id": "buy_wood", "title": "Wood Crate", "price": DEALER_WOOD_GOLD_COST, "desc": "+%d wood." % DEALER_WOOD_AMOUNT},
		{"id": "buy_stone", "title": "Stone Crate", "price": DEALER_STONE_GOLD_COST, "desc": "+%d stone." % DEALER_STONE_AMOUNT},
		{"id": "buy_iron", "title": "Iron Bundle", "price": DEALER_IRON_GOLD_COST, "desc": "+%d iron." % DEALER_IRON_AMOUNT},
		{"id": "buy_gunpowder", "title": "Powder Bundle", "price": DEALER_GUNPOWDER_GOLD_COST, "desc": "+%d gunpowder." % DEALER_GUNPOWDER_AMOUNT},
		{"id": "heal", "title": "Field Medkit", "price": DEALER_HEAL_GOLD_COST, "desc": "Restore Bob to full HP."}
	]
	var sell_items: Array[Dictionary] = [
		{"id": "sell_wood", "title": "Sell Wood", "price": 0, "desc": "-%d wood, +%d dollar." % [DEALER_SELL_WOOD_AMOUNT, DEALER_SELL_WOOD_GOLD_GAIN]},
		{"id": "sell_stone", "title": "Sell Stone", "price": 0, "desc": "-%d stone, +%d dollar." % [DEALER_SELL_STONE_AMOUNT, DEALER_SELL_STONE_GOLD_GAIN]},
		{"id": "sell_iron", "title": "Sell Iron", "price": 0, "desc": "-%d iron, +%d dollars." % [DEALER_SELL_IRON_AMOUNT, DEALER_SELL_IRON_GOLD_GAIN]},
		{"id": "sell_gunpowder", "title": "Sell Powder", "price": 0, "desc": "-%d powder, +%d dollars." % [DEALER_SELL_GUNPOWDER_AMOUNT, DEALER_SELL_GUNPOWDER_GOLD_GAIN]}
	]
	return sell_items if page == "sell" else buy_items


func _dealer_page_rect(panel_rect: Rect2, page: String) -> Rect2:
	if page == "sell":
		return Rect2(panel_rect.position + Vector2(164, 72), Vector2(118, 34))
	return Rect2(panel_rect.position + Vector2(34, 72), Vector2(118, 34))


func _dealer_page_at_position(mouse_position: Vector2) -> String:
	if not dealer_menu_open or inside_house or inside_cave:
		return ""
	var panel_rect: Rect2 = _dealer_panel_rect()
	if _dealer_page_rect(panel_rect, "buy").has_point(mouse_position):
		return "buy"
	if _dealer_page_rect(panel_rect, "sell").has_point(mouse_position):
		return "sell"
	return ""


func _dealer_item_rect(panel_rect: Rect2, item_index: int) -> Rect2:
	var row: int = item_index / 3
	var col: int = item_index % 3
	return Rect2(panel_rect.position + Vector2(24 + col * 330, 124 + row * 90), Vector2(306, 76))


func _dealer_item_at_position(mouse_position: Vector2) -> String:
	if not dealer_menu_open or inside_house or inside_cave:
		return ""
	var panel_rect: Rect2 = _dealer_panel_rect()
	var items: Array[Dictionary] = _dealer_items(dealer_page)
	for item_index in range(items.size()):
		if _dealer_item_rect(panel_rect, item_index).has_point(mouse_position):
			return String(items[item_index]["id"])
	return ""


func _dealer_item_owned(item_id: String) -> bool:
	match item_id:
		"unlock_gun_turret":
			return gun_sentry_unlocked
		_:
			return false


func _dealer_sell_gold_gain(item_id: String) -> int:
	match item_id:
		"sell_wood":
			return DEALER_SELL_WOOD_GOLD_GAIN
		"sell_stone":
			return DEALER_SELL_STONE_GOLD_GAIN
		"sell_iron":
			return DEALER_SELL_IRON_GOLD_GAIN
		"sell_gunpowder":
			return DEALER_SELL_GUNPOWDER_GOLD_GAIN
		_:
			return 0


func _purchase_dealer_item(item_id: String) -> void:
	var item_price: int = 0
	for item in _dealer_items(dealer_page):
		if String(item["id"]) == item_id:
			item_price = int(item["price"])
			break
	var selling_materials: bool = item_id.begins_with("sell_")
	if item_price <= 0 and not selling_materials:
		return
	if _dealer_item_owned(item_id):
		dealer_status_text = "Already owned."
		return
	if selling_materials:
		match item_id:
			"sell_wood":
				if wood < DEALER_SELL_WOOD_AMOUNT:
					dealer_status_text = "Need more wood to sell."
					return
				wood -= DEALER_SELL_WOOD_AMOUNT
				gold += DEALER_SELL_WOOD_GOLD_GAIN
				dealer_status_text = "Wood sold for dollars."
			"sell_stone":
				if stone < DEALER_SELL_STONE_AMOUNT:
					dealer_status_text = "Need more stone to sell."
					return
				stone -= DEALER_SELL_STONE_AMOUNT
				gold += DEALER_SELL_STONE_GOLD_GAIN
				dealer_status_text = "Stone sold for dollars."
			"sell_iron":
				if iron < DEALER_SELL_IRON_AMOUNT:
					dealer_status_text = "Need more iron to sell."
					return
				iron -= DEALER_SELL_IRON_AMOUNT
				gold += DEALER_SELL_IRON_GOLD_GAIN
				dealer_status_text = "Iron sold for dollars."
			"sell_gunpowder":
				if gunpowder < DEALER_SELL_GUNPOWDER_AMOUNT:
					dealer_status_text = "Need more powder to sell."
					return
				gunpowder -= DEALER_SELL_GUNPOWDER_AMOUNT
				gold += DEALER_SELL_GUNPOWDER_GOLD_GAIN
				dealer_status_text = "Powder sold for dollars."
		return
	if not dev_mode_enabled and gold < item_price:
		dealer_status_text = "Need more dollars."
		return
	if not dev_mode_enabled:
		gold -= item_price
	match item_id:
		"unlock_gun_turret":
			gun_sentry_unlocked = true
			selected_sentry_kind = "gun"
			dealer_status_text = "Gun turret unlocked."
		"turret_buff":
			turret_damage_bonus += 1
			dealer_status_text = "Sentry damage increased."
		"buy_turret_ammo":
			for structure_key in structures.keys():
				var structure: Dictionary = structures[structure_key]
				if int(structure.get("type", StructureType.NONE)) != StructureType.TURRET:
					continue
				var weapon: String = String(structure.get("weapon", "arrow"))
				if weapon == "cannon" or weapon == "magic":
					continue
				var max_ammo: int = int(structure.get("max_ammo", _turret_starting_ammo_for_weapon(weapon)))
				structure["ammo"] = min(int(structure.get("ammo", max_ammo)) + DEALER_TURRET_AMMO_AMOUNT, max_ammo)
			dealer_status_text = "Sentry ammo restocked."
		"buy_cannon_shells":
			for structure_key in structures.keys():
				var structure: Dictionary = structures[structure_key]
				if int(structure.get("type", StructureType.NONE)) != StructureType.TURRET:
					continue
				if String(structure.get("weapon", "arrow")) != "cannon":
					continue
				var max_shells: int = int(structure.get("max_ammo", CANNON_TURRET_STARTING_AMMO))
				structure["ammo"] = min(int(structure.get("ammo", max_shells)) + DEALER_CANNON_SHELL_AMOUNT, max_shells)
			dealer_status_text = "Cannon sentries reloaded."
		"buy_wood":
			wood += DEALER_WOOD_AMOUNT
			dealer_status_text = "Wood delivered."
		"buy_stone":
			stone += DEALER_STONE_AMOUNT
			dealer_status_text = "Stone delivered."
		"buy_iron":
			iron += DEALER_IRON_AMOUNT
			dealer_status_text = "Iron delivered."
		"buy_gunpowder":
			gunpowder += DEALER_GUNPOWDER_AMOUNT
			dealer_status_text = "Gunpowder delivered."
		"heal":
			player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
			dealer_status_text = "Bob patched up."


func _draw_dealer_menu() -> void:
	if not dealer_menu_open or inside_house or inside_cave:
		return
	var panel_rect: Rect2 = _dealer_panel_rect()
	var buy_tab_rect: Rect2 = _dealer_page_rect(panel_rect, "buy")
	var sell_tab_rect: Rect2 = _dealer_page_rect(panel_rect, "sell")
	var hovered_id: String = _dealer_item_at_position(get_viewport().get_mouse_position())
	var ammo_totals: Dictionary = _turret_ammo_totals()
	_draw_ui_card(panel_rect, UI_WARM_ACCENT, UI_PANEL_FILL, 3.0, Vector2(0, 10))
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 40), "Arms Dealer", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 64), "Dollars %d  |  Ammo %d/%d  |  Shells %d/%d" % [gold, int(ammo_totals["ammo"]), int(ammo_totals["ammo_max"]), int(ammo_totals["shells"]), int(ammo_totals["shells_max"])], HORIZONTAL_ALIGNMENT_LEFT, 520, 18, MUTED_TEXT_COLOR)
	if arms_dealer_texture != null:
		draw_texture_rect_region(arms_dealer_texture, Rect2(panel_rect.position + Vector2(916, 12), Vector2(70, 122)), ARMS_DEALER_REGION)
	_draw_ui_card(buy_tab_rect, UI_WARM_ACCENT if dealer_page == "buy" else Color(1, 1, 1, 0.14), Color(0.18, 0.21, 0.24, 0.98) if dealer_page != "buy" else Color(0.22, 0.26, 0.16, 0.98), 2.0, Vector2.ZERO)
	_draw_ui_card(sell_tab_rect, UI_WARM_ACCENT if dealer_page == "sell" else Color(1, 1, 1, 0.14), Color(0.18, 0.21, 0.24, 0.98) if dealer_page != "sell" else Color(0.24, 0.18, 0.14, 0.98), 2.0, Vector2.ZERO)
	draw_string(ThemeDB.fallback_font, buy_tab_rect.position + Vector2(35, 22), "Buy", HORIZONTAL_ALIGNMENT_LEFT, 52, 18, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, sell_tab_rect.position + Vector2(34, 22), "Sell", HORIZONTAL_ALIGNMENT_LEFT, 54, 18, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(304, 94), "Spend for gear or sell spare materials for emergency cash.", HORIZONTAL_ALIGNMENT_LEFT, 526, 14, MUTED_TEXT_COLOR)
	var items: Array[Dictionary] = _dealer_items(dealer_page)
	for item_index in range(items.size()):
		var item: Dictionary = items[item_index]
		var item_rect: Rect2 = _dealer_item_rect(panel_rect, item_index)
		var owned: bool = _dealer_item_owned(String(item["id"]))
		var hovered: bool = hovered_id == String(item["id"])
		var fill_color: Color = Color(0.13, 0.16, 0.19, 0.96) if not owned else Color(0.18, 0.24, 0.18, 0.96)
		if hovered:
			fill_color = fill_color.lightened(0.08)
		_draw_ui_card(item_rect, Color(0.92, 0.84, 0.54) if hovered else Color(1, 1, 1, 0.14), fill_color, 2.0, Vector2(0, 4))
		draw_string(ThemeDB.fallback_font, item_rect.position + Vector2(14, 24), String(item["title"]), HORIZONTAL_ALIGNMENT_LEFT, 194, 18, TEXT_COLOR)
		draw_string(ThemeDB.fallback_font, item_rect.position + Vector2(14, 48), String(item["desc"]), HORIZONTAL_ALIGNMENT_LEFT, 214, 14, MUTED_TEXT_COLOR)
		var price_text: String = "Owned" if owned else ("%d dollars" % int(item["price"]))
		if String(item["id"]).begins_with("sell_"):
			price_text = "+%d$" % _dealer_sell_gold_gain(String(item["id"]))
		draw_string(ThemeDB.fallback_font, item_rect.position + Vector2(item_rect.size.x - 102, 28), price_text, HORIZONTAL_ALIGNMENT_LEFT, 88, 16, Color(0.96, 0.84, 0.48))
	if hovered_id != "":
		_draw_dealer_hover_panel(Rect2(panel_rect.position + Vector2(694, 412), Vector2(294, 88)), hovered_id)
	_draw_ui_card(Rect2(panel_rect.position + Vector2(24, 488), Vector2(984, 20)), Color(1, 1, 1, 0.08), Color(0.10, 0.12, 0.14, 1.0), 1.0, Vector2.ZERO)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(36, 504), dealer_status_text + "  Press G to close.", HORIZONTAL_ALIGNMENT_LEFT, 944, 16, TEXT_COLOR)


func _draw_dealer_hover_panel(panel_rect: Rect2, item_id: String) -> void:
	_draw_ui_card(panel_rect, UI_WARM_ACCENT, UI_PANEL_FILL_SOFT, 2.0, Vector2(0, 4))
	var title: String = ""
	var body: String = ""
	match item_id:
		"unlock_gun_turret":
			title = "Gun Turret"
			body = "Mid-game sentry. Great into single targets and long lanes."
		"turret_buff":
			title = "Permanent Buff"
			body = "Every sentry hits harder for the rest of the run."
		"buy_turret_ammo":
			title = "Ammo Refill"
			body = "Restocks your non-cannon sentries before the next wave."
		"buy_cannon_shells":
			title = "Shell Refill"
			body = "Refills cannon turrets so they can keep smashing clumps."
		"buy_wood":
			title = "Wood Crate"
			body = "Fast recovery when walls or cheap sentries are draining you."
		"buy_stone":
			title = "Stone Crate"
			body = "Helps rebuild stronger walls and higher-tier turrets."
		"buy_iron":
			title = "Iron Bundle"
			body = "Needed for late cave unlocks and crystal builds."
		"buy_gunpowder":
			title = "Powder Bundle"
			body = "Fuel for gun turrets and deeper defense setups."
		"sell_wood":
			title = "Sell Wood"
			body = "Turn extra tree haul into quick dollars for ammo and emergency buys."
		"sell_stone":
			title = "Sell Stone"
			body = "Cash out spare stone when your walls are already in a good spot."
		"sell_iron":
			title = "Sell Iron"
			body = "Deep cave ore can be flipped for a stronger dollar payout."
		"sell_gunpowder":
			title = "Sell Powder"
			body = "Trade excess powder when you need cash more than gun builds."
		"heal":
			title = "Field Medkit"
			body = "Top Bob back up before taking a risky wave or cave run."
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 22), title, HORIZONTAL_ALIGNMENT_LEFT, 208, 18, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 46), body, HORIZONTAL_ALIGNMENT_LEFT, 208, 14, MUTED_TEXT_COLOR)


func _sentry_label(weapon: String) -> String:
	match weapon:
		"cannon":
			return "Cannon Turret"
		"gun":
			return "Gun Turret"
		"wall_light":
			return "Cheap Wall"
		"wall_medium":
			return "Stone Wall"
		"wall_heavy":
			return "Iron Wall"
		"golden":
			return "Golden Turret"
		"magic":
			return "Magic Sentry"
		_:
			return "Arrow Turret"


func _sentry_price_label(weapon: String) -> String:
	match weapon:
		"cannon":
			return "7 wood, 4 stone"
		"gun":
			return "4 wood, 1 stone, 2 powder"
		"wall_light":
			return "2 wood"
		"wall_medium":
			return "3 wood, 1 stone"
		"wall_heavy":
			return "3 wood, 3 stone"
		"golden":
			return "4 wood, 2 stone, 4 gold"
		"magic":
			return "6 wood, 4 stone, 8 iron, 2 crystals"
		_:
			return "4 wood"


func _draw_inventory_menu() -> void:
	if not inventory_menu_open or phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	var panel_rect := Rect2(Vector2(318, 170), Vector2(644, 370))
	_draw_ui_card(panel_rect, UI_SUCCESS_ACCENT, UI_PANEL_FILL, 3.0, Vector2(0, 10))
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 38), "Inventory", HORIZONTAL_ALIGNMENT_LEFT, 220, 30, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 64), "Press E or Esc to close", HORIZONTAL_ALIGNMENT_LEFT, 240, 16, MUTED_TEXT_COLOR)
	if inventory_icon_texture != null:
		draw_texture_rect(inventory_icon_texture, Rect2(panel_rect.position + Vector2(548, 18), Vector2(58, 58)), false)

	var carry_limit: int = _current_carry_limit()
	var total_carried: int = _current_carried_total()
	var hp_total: int = PLAYER_MAX_HP + _extra_player_max_hp()
	var ammo_totals: Dictionary = _turret_ammo_totals()
	var location_text: String = "House" if inside_house else ("Cave" if inside_cave else "Yard")
	var phase_text: String = "Build" if phase == Phase.BUILD else "Defend"

	var stats_rect := Rect2(panel_rect.position + Vector2(26, 86), Vector2(592, 86))
	_draw_ui_card(stats_rect, Color(1, 1, 1, 0.10), UI_PANEL_FILL_SOFT, 1.0)
	if heart_icon_texture != null:
		draw_texture_rect(heart_icon_texture, Rect2(stats_rect.position + Vector2(14, 8), Vector2(22, 22)), false)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(42, 24), "%d/%d" % [player_hp, hp_total], HORIZONTAL_ALIGNMENT_LEFT, 104, 18, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(168, 24), "Carry %d/%d" % [total_carried, carry_limit], HORIZONTAL_ALIGNMENT_LEFT, 144, 18, Color(1.0, 0.84, 0.52) if total_carried >= carry_limit else TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(332, 24), "Round %d" % round_number, HORIZONTAL_ALIGNMENT_LEFT, 96, 18, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(444, 24), phase_text, HORIZONTAL_ALIGNMENT_LEFT, 94, 18, UI_COOL_ACCENT)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(16, 52), "House %d/%d" % [_house_integrity_left(), HOUSE_MAX_DAMAGE_STAGES], HORIZONTAL_ALIGNMENT_LEFT, 120, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(168, 52), "Ammo %d/%d" % [int(ammo_totals["ammo"]), int(ammo_totals["ammo_max"])], HORIZONTAL_ALIGNMENT_LEFT, 134, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(332, 52), "Shells %d/%d" % [int(ammo_totals["shells"]), int(ammo_totals["shells_max"])], HORIZONTAL_ALIGNMENT_LEFT, 132, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, stats_rect.position + Vector2(474, 52), location_text, HORIZONTAL_ALIGNMENT_LEFT, 90, 16, MUTED_TEXT_COLOR)

	var left_rect := Rect2(panel_rect.position + Vector2(26, 190), Vector2(272, 142))
	var right_rect := Rect2(panel_rect.position + Vector2(346, 190), Vector2(272, 142))
	_draw_ui_card(left_rect, Color(1, 1, 1, 0.10), UI_PANEL_FILL_SOFT, 1.0)
	_draw_ui_card(right_rect, Color(1, 1, 1, 0.10), UI_PANEL_FILL_SOFT, 1.0)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(16, 24), "Materials", HORIZONTAL_ALIGNMENT_LEFT, 180, 20, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(16, 52), "Wood: %d" % wood, HORIZONTAL_ALIGNMENT_LEFT, 100, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(16, 78), "Stone: %d" % stone, HORIZONTAL_ALIGNMENT_LEFT, 100, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(16, 104), "Iron: %d" % iron, HORIZONTAL_ALIGNMENT_LEFT, 100, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(132, 52), "Powder: %d" % gunpowder, HORIZONTAL_ALIGNMENT_LEFT, 116, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(132, 78), "Dollars: %d" % gold, HORIZONTAL_ALIGNMENT_LEFT, 116, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(132, 104), "Crystals: %d" % cave_crystals_owned, HORIZONTAL_ALIGNMENT_LEFT, 116, 16, MUTED_TEXT_COLOR)

	draw_string(ThemeDB.fallback_font, right_rect.position + Vector2(16, 24), "Run Status", HORIZONTAL_ALIGNMENT_LEFT, 180, 20, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, right_rect.position + Vector2(16, 52), "Safe house items: %d" % house_items.size(), HORIZONTAL_ALIGNMENT_LEFT, 180, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, right_rect.position + Vector2(16, 78), "Stolen by IRS: %d" % stolen_house_items.size(), HORIZONTAL_ALIGNMENT_LEFT, 180, 16, MUTED_TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, right_rect.position + Vector2(16, 104), "Selected build: %s" % _sentry_label(selected_sentry_kind), HORIZONTAL_ALIGNMENT_LEFT, 220, 16, MUTED_TEXT_COLOR)

	var tip_rect := Rect2(panel_rect.position + Vector2(26, 338), Vector2(592, 18))
	_draw_ui_card(tip_rect, Color(1, 1, 1, 0.08), Color(0.10, 0.12, 0.14, 1.0), 1.0, Vector2.ZERO)
	draw_string(ThemeDB.fallback_font, tip_rect.position + Vector2(14, 14), "Use the build menu for turrets and walls. Visit the dealer to buy ammo and supplies.", HORIZONTAL_ALIGNMENT_LEFT, 560, 14, MUTED_TEXT_COLOR)


func _build_hud() -> void:
	menu_panel = ColorRect.new()
	menu_panel.position = Vector2(164, 110)
	menu_panel.size = Vector2(952, 500)
	menu_panel.color = Color(0.03, 0.05, 0.07, 0.76)
	add_child(menu_panel)

	menu_title_label = Label.new()
	menu_title_label.position = Vector2(72, 52)
	menu_title_label.size = Vector2(808, 64)
	menu_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_title_label.add_theme_font_size_override("font_size", 48)
	menu_title_label.modulate = TEXT_COLOR
	menu_panel.add_child(menu_title_label)

	menu_desc_label = Label.new()
	menu_desc_label.position = Vector2(86, 136)
	menu_desc_label.size = Vector2(780, 144)
	menu_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	menu_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_desc_label.add_theme_font_size_override("font_size", 24)
	menu_desc_label.modulate = MUTED_TEXT_COLOR
	menu_panel.add_child(menu_desc_label)

	menu_info_label = Label.new()
	menu_info_label.position = Vector2(82, 286)
	menu_info_label.size = Vector2(788, 52)
	menu_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_info_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	menu_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_info_label.add_theme_font_size_override("font_size", 18)
	menu_info_label.modulate = Color(0.94, 0.90, 0.78)
	menu_panel.add_child(menu_info_label)

	menu_start_button = Button.new()
	menu_start_button.position = Vector2(326, 348)
	menu_start_button.size = Vector2(300, 64)
	menu_start_button.text = "Start Run"
	menu_start_button.add_theme_font_size_override("font_size", 28)
	_style_action_button(menu_start_button, UI_WARM_ACCENT)
	menu_start_button.pressed.connect(_on_menu_start_pressed)
	menu_panel.add_child(menu_start_button)

	menu_dev_button = Button.new()
	menu_dev_button.position = Vector2(326, 422)
	menu_dev_button.size = Vector2(300, 52)
	menu_dev_button.text = "Dev Mode"
	menu_dev_button.add_theme_font_size_override("font_size", 22)
	_style_action_button(menu_dev_button, UI_COOL_ACCENT)
	menu_dev_button.pressed.connect(_on_menu_dev_pressed)
	menu_panel.add_child(menu_dev_button)

	menu_continue_hint_label = Label.new()
	menu_continue_hint_label.position = Vector2(112, 474)
	menu_continue_hint_label.size = Vector2(728, 32)
	menu_continue_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_continue_hint_label.add_theme_font_size_override("font_size", 18)
	menu_continue_hint_label.modulate = Color(0.92, 0.90, 0.78)
	menu_panel.add_child(menu_continue_hint_label)

	var music_volume_label := Label.new()
	music_volume_label.position = Vector2(676, 348)
	music_volume_label.size = Vector2(180, 22)
	music_volume_label.add_theme_font_size_override("font_size", 18)
	music_volume_label.modulate = TEXT_COLOR
	music_volume_label.text = "Music Volume"
	menu_panel.add_child(music_volume_label)

	music_volume_slider = HSlider.new()
	music_volume_slider.position = Vector2(676, 376)
	music_volume_slider.size = Vector2(176, 24)
	music_volume_slider.min_value = 0.0
	music_volume_slider.max_value = 100.0
	music_volume_slider.step = 1.0
	music_volume_slider.modulate = UI_WARM_ACCENT
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	music_volume_slider.value = music_volume_percent
	menu_panel.add_child(music_volume_slider)

	music_volume_value_label = Label.new()
	music_volume_value_label.position = Vector2(860, 374)
	music_volume_value_label.size = Vector2(62, 28)
	music_volume_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	music_volume_value_label.add_theme_font_size_override("font_size", 18)
	music_volume_value_label.modulate = MUTED_TEXT_COLOR
	menu_panel.add_child(music_volume_value_label)

	var sfx_volume_label := Label.new()
	sfx_volume_label.position = Vector2(676, 414)
	sfx_volume_label.size = Vector2(180, 22)
	sfx_volume_label.add_theme_font_size_override("font_size", 18)
	sfx_volume_label.modulate = TEXT_COLOR
	sfx_volume_label.text = "SFX Volume"
	menu_panel.add_child(sfx_volume_label)

	sfx_volume_slider = HSlider.new()
	sfx_volume_slider.position = Vector2(676, 442)
	sfx_volume_slider.size = Vector2(176, 24)
	sfx_volume_slider.min_value = 0.0
	sfx_volume_slider.max_value = 100.0
	sfx_volume_slider.step = 1.0
	sfx_volume_slider.modulate = UI_COOL_ACCENT
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	sfx_volume_slider.value = sfx_volume_percent
	menu_panel.add_child(sfx_volume_slider)

	sfx_volume_value_label = Label.new()
	sfx_volume_value_label.position = Vector2(860, 440)
	sfx_volume_value_label.size = Vector2(62, 28)
	sfx_volume_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	sfx_volume_value_label.add_theme_font_size_override("font_size", 18)
	sfx_volume_value_label.modulate = MUTED_TEXT_COLOR
	menu_panel.add_child(sfx_volume_value_label)

	music_credit_panel = ColorRect.new()
	music_credit_panel.position = Vector2(886, 626)
	music_credit_panel.size = Vector2(356, 70)
	music_credit_panel.color = UI_PANEL_FILL
	music_credit_panel.visible = false
	add_child(music_credit_panel)

	music_credit_title_label = Label.new()
	music_credit_title_label.position = Vector2(14, 10)
	music_credit_title_label.size = Vector2(302, 20)
	music_credit_title_label.add_theme_font_size_override("font_size", 16)
	music_credit_title_label.modulate = Color(0.98, 0.94, 0.82)
	music_credit_title_label.text = "Now Playing: I miss you"
	music_credit_panel.add_child(music_credit_title_label)

	music_credit_body_label = Label.new()
	music_credit_body_label.position = Vector2(14, 32)
	music_credit_body_label.size = Vector2(302, 18)
	music_credit_body_label.add_theme_font_size_override("font_size", 14)
	music_credit_body_label.modulate = Color(0.84, 0.88, 0.92)
	music_credit_body_label.text = "Music by sovieticoofficial"
	music_credit_panel.add_child(music_credit_body_label)

	menu_dev_panel = ColorRect.new()
	menu_dev_panel.position = Vector2(264, 176)
	menu_dev_panel.size = Vector2(424, 178)
	menu_dev_panel.color = UI_PANEL_FILL
	menu_panel.add_child(menu_dev_panel)

	menu_dev_pin_label = Label.new()
	menu_dev_pin_label.position = Vector2(24, 22)
	menu_dev_pin_label.size = Vector2(376, 30)
	menu_dev_pin_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_dev_pin_label.add_theme_font_size_override("font_size", 24)
	menu_dev_pin_label.text = "Enter Dev PIN"
	menu_dev_panel.add_child(menu_dev_pin_label)

	menu_dev_pin_input = LineEdit.new()
	menu_dev_pin_input.position = Vector2(114, 66)
	menu_dev_pin_input.size = Vector2(196, 42)
	menu_dev_pin_input.max_length = 4
	menu_dev_pin_input.secret = true
	menu_dev_pin_input.placeholder_text = "PIN"
	_style_text_input(menu_dev_pin_input)
	menu_dev_pin_input.text_submitted.connect(func(_submitted_text: String) -> void: _on_menu_dev_unlock_pressed())
	menu_dev_panel.add_child(menu_dev_pin_input)

	var menu_dev_unlock_button := Button.new()
	menu_dev_unlock_button.position = Vector2(144, 116)
	menu_dev_unlock_button.size = Vector2(136, 36)
	menu_dev_unlock_button.text = "Unlock"
	_style_action_button(menu_dev_unlock_button, UI_WARM_ACCENT)
	menu_dev_unlock_button.pressed.connect(_on_menu_dev_unlock_pressed)
	menu_dev_panel.add_child(menu_dev_unlock_button)

	menu_dev_status_label = Label.new()
	menu_dev_status_label.position = Vector2(24, 154)
	menu_dev_status_label.size = Vector2(376, 18)
	menu_dev_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_dev_status_label.add_theme_font_size_override("font_size", 14)
	menu_dev_status_label.modulate = Color(0.92, 0.90, 0.78)
	menu_dev_status_label.text = "Enter PIN"
	menu_dev_panel.add_child(menu_dev_status_label)

	escape_confirm_panel = ColorRect.new()
	escape_confirm_panel.position = Vector2(340, 204)
	escape_confirm_panel.size = Vector2(600, 220)
	escape_confirm_panel.color = UI_PANEL_FILL
	escape_confirm_panel.visible = false
	add_child(escape_confirm_panel)

	escape_confirm_title_label = Label.new()
	escape_confirm_title_label.position = Vector2(32, 24)
	escape_confirm_title_label.size = Vector2(536, 38)
	escape_confirm_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	escape_confirm_title_label.add_theme_font_size_override("font_size", 30)
	escape_confirm_title_label.modulate = TEXT_COLOR
	escape_confirm_panel.add_child(escape_confirm_title_label)

	escape_confirm_body_label = Label.new()
	escape_confirm_body_label.position = Vector2(44, 78)
	escape_confirm_body_label.size = Vector2(512, 72)
	escape_confirm_body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	escape_confirm_body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	escape_confirm_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	escape_confirm_body_label.add_theme_font_size_override("font_size", 22)
	escape_confirm_body_label.modulate = MUTED_TEXT_COLOR
	escape_confirm_panel.add_child(escape_confirm_body_label)

	escape_confirm_hint_label = Label.new()
	escape_confirm_hint_label.position = Vector2(40, 174)
	escape_confirm_hint_label.size = Vector2(520, 24)
	escape_confirm_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	escape_confirm_hint_label.add_theme_font_size_override("font_size", 18)
	escape_confirm_hint_label.modulate = Color(0.96, 0.86, 0.56)
	escape_confirm_hint_label.text = "Press Y to confirm or N / Esc to stay."
	escape_confirm_panel.add_child(escape_confirm_hint_label)

	title_label = Label.new()
	title_label.position = Vector2(60, 18)
	title_label.size = Vector2(384, 34)
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.modulate = TEXT_COLOR
	add_child(title_label)

	hud_heart_icon = TextureRect.new()
	hud_heart_icon.position = Vector2(24, 17)
	hud_heart_icon.size = Vector2(28, 28)
	hud_heart_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# Without this the control's minimum size is the texture's size, so a large
	# source image stretches the icon across the whole screen.
	hud_heart_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	add_child(hud_heart_icon)

	stats_label = Label.new()
	stats_label.position = Vector2(336, 14)
	stats_label.size = Vector2(904, 40)
	stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	stats_label.add_theme_font_size_override("font_size", 18)
	stats_label.modulate = TEXT_COLOR
	add_child(stats_label)

	hint_label = Label.new()
	hint_label.position = Vector2(160, 680)
	hint_label.size = Vector2(960, 28)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.add_theme_font_size_override("font_size", 16)
	hint_label.modulate = MUTED_TEXT_COLOR
	add_child(hint_label)

	overlay_label = Label.new()
	overlay_label.position = Vector2(180, 220)
	overlay_label.size = Vector2(920, 220)
	overlay_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	overlay_label.add_theme_font_size_override("font_size", 36)
	overlay_label.modulate = TEXT_COLOR
	add_child(overlay_label)

	_apply_audio_settings()


func _refresh_hud() -> void:
	escape_confirm_panel.visible = escape_confirm_open
	if escape_confirm_open:
		escape_confirm_title_label.text = escape_confirm_title
		escape_confirm_body_label.text = escape_confirm_body
	var player_hp_text: String = "%d/%d" % [player_hp, PLAYER_MAX_HP + _extra_player_max_hp()]
	title_label.text = "%s  |  DEV" % player_hp_text if dev_mode_enabled and (phase == Phase.BUILD or phase == Phase.DEFEND) else player_hp_text
	title_label.modulate = Color(1.0, 0.87, 0.36) if dev_mode_enabled and (phase == Phase.BUILD or phase == Phase.DEFEND) else TEXT_COLOR
	hud_heart_icon.texture = heart_icon_texture
	match phase:
		Phase.MENU:
			title_label.visible = false
			hud_heart_icon.visible = false
			stats_label.visible = false
			stats_label.text = ""
			hint_label.visible = false
			menu_panel.visible = true
			menu_info_label.visible = true
			menu_title_label.text = "Tax Season Siege"
			menu_desc_label.text = "Defend Bob's house from the IRS.\nGather in the forest, fortify the yard, hold off each wave, and push into the cave for the upgrades that keep your run alive."
			menu_info_label.text = "Build for 60 seconds, survive the IRS wave, then repeat.\nWASD move  |  B build  |  G dealer  |  F cave  |  H repair  |  Esc menu"
			menu_start_button.text = "Start Run"
			menu_dev_button.text = "Disable Dev Mode" if dev_mode_enabled else "Dev Mode"
			menu_dev_button.disabled = false
			menu_dev_panel.visible = dev_mode_prompt_open
			menu_continue_hint_label.text = "Press Space, Enter, or click Start."
			overlay_label.visible = false
		Phase.BUILD:
			title_label.visible = not inside_house and not inside_cave and not dealer_menu_open
			hud_heart_icon.visible = title_label.visible and heart_icon_texture != null
			stats_label.visible = false
			stats_label.text = ""
			hint_label.visible = false
			menu_panel.visible = false
			menu_info_label.visible = false
			menu_dev_panel.visible = false
			var build_ammo_totals: Dictionary = _turret_ammo_totals()
			var shallow_resource_count: int = _count_active_resources_in_band(FOREST_START_ROW + SHALLOW_RESOURCE_BAND_ROWS)
			if _current_carried_total() >= _current_carry_limit():
				hint_label.text = "Inventory full. Build, sell, or spend before gathering more."
			elif inside_cave:
				hint_label.text = "The timer keeps ticking in the cave. F leaves."
			elif house_damage_stage > 0:
				hint_label.text = "House damaged. Stand by the wrench marker and press H to repair."
			elif round_number == 1:
				hint_label.text = "Gather, place a wall and a sentry, then press Enter when ready."
			elif build_menu_open:
				hint_label.text = "Click a defense, then click a yard tile. X sells. Esc closes."
			elif _ammo_totals_low(build_ammo_totals):
				hint_label.text = "Ammo is running low. Visit the dealer before the wave."
			elif _is_swat_round():
				hint_label.text = "SWAT round coming. Double-layer walls and top off ammo."
			elif shallow_resource_count <= 6:
				hint_label.text = "Nearby resources are low. Head deeper into the forest or cave."
			elif dev_mode_enabled:
				hint_label.text = "B build  |  G dealer  |  F cave  |  Enter wave"
			elif dealer_menu_open:
				hint_label.text = "Dealer open. Buy on one tab, sell on the other. G or Esc closes it."
			else:
				hint_label.text = "B build  |  G dealer  |  F cave  |  Enter wave"
			overlay_label.visible = false
		Phase.DEFEND:
			title_label.visible = not inside_house and not inside_cave and not dealer_menu_open
			hud_heart_icon.visible = title_label.visible and heart_icon_texture != null
			stats_label.visible = false
			stats_label.text = ""
			hint_label.visible = false
			menu_panel.visible = false
			menu_info_label.visible = false
			menu_dev_panel.visible = false
			var defend_ammo_totals: Dictionary = _turret_ammo_totals()
			if inside_cave:
				hint_label.text = "The wave keeps going underground. F leaves the cave."
			elif _is_swat_round():
				hint_label.text = "SWAT breachers hit harder and move faster."
			elif _count_remaining_walls() <= 0 and house_damage_stage < HOUSE_MAX_DAMAGE_STAGES:
				hint_label.text = "Walls are down. The IRS is now hitting the house."
			else:
				hint_label.text = "Hold the house." if not dev_mode_enabled else "Hold the house. Dev mode stays unlocked."
			overlay_label.visible = false
		Phase.GAME_OVER:
			title_label.visible = false
			hud_heart_icon.visible = false
			stats_label.visible = false
			stats_label.text = ""
			hint_label.visible = false
			menu_panel.visible = true
			menu_info_label.visible = true
			menu_title_label.text = "The Trophy Is Gone"
			menu_desc_label.text = "The IRS stole the KFZ Air Fryer Console.\nHighest Round: %d\nYour next run needs stronger walls, cleaner ammo planning, and a deeper cave route." % highest_round
			menu_info_label.text = "What helps most: repair the house early, keep sentries fed, sell extra materials at the dealer, and use cave crystals to unlock the final magic sentry."
			menu_start_button.text = "Start New Run"
			menu_dev_button.text = "Disable Dev Mode" if dev_mode_enabled else "Dev Mode"
			menu_dev_button.disabled = false
			menu_dev_panel.visible = dev_mode_prompt_open
			menu_continue_hint_label.text = "Press Space, Enter, or click Start."
			overlay_label.visible = false


func _ensure_input_actions() -> void:
	_clear_action_bindings("enter_cave")
	if InputMap.has_action("enter_house"):
		InputMap.erase_action("enter_house")
	_bind_key("move_left", KEY_A)
	_bind_key("move_left", KEY_LEFT)
	_bind_key("move_right", KEY_D)
	_bind_key("move_right", KEY_RIGHT)
	_bind_key("move_up", KEY_W)
	_bind_key("move_up", KEY_UP)
	_bind_key("move_down", KEY_S)
	_bind_key("move_down", KEY_DOWN)
	_bind_key("action", KEY_SPACE)
	_bind_key("build_arrow_turret", KEY_B)
	_bind_key("build_wall_light", KEY_1)
	_bind_key("build_wall_medium", KEY_2)
	_bind_key("build_wall_heavy", KEY_3)
	_bind_key("upgrade_turret", KEY_U)
	_bind_key("repair_wall", KEY_H)
	_bind_key("sell_structure", KEY_X)
	_bind_key("buy_sidearm", KEY_Q)
	_bind_key("dealer_menu", KEY_G)
	_bind_key("enter_cave", KEY_F)
	_bind_key("start_wave_early", KEY_ENTER)
	_bind_key("start_wave_early", KEY_KP_ENTER)
	_bind_key("skip_build_test", KEY_K)
	_bind_key("restart", KEY_R)


func _clear_action_bindings(action: String) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	else:
		InputMap.action_erase_events(action)


func _bind_key(action: String, keycode: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)

	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.keycode == keycode:
			return

	var key_event := InputEventKey.new()
	key_event.keycode = keycode
	InputMap.action_add_event(action, key_event)
