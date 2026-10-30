extends Node2D

# -------------------------------------------------------------------
# TUNABLE BALANCE CONSTANTS
# -------------------------------------------------------------------
const SCREEN_SIZE := Vector2(1280, 720)
const REPLAY_GAME_VERSION := "tax-season-siege-1.3.4"
const REPLAY_HASH_INTERVAL := 30
const LEADERBOARD_BASE_URL := "https://tax-season-siege-leaderboard.danaildimitrov07.chatgpt.site"
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
const MENU_BACKGROUND_REGION := Rect2(0, 0, 1280, 720)
const MENU_UI_NEW_GAME_REGION := Rect2(72, 360, 1080, 192)
const MENU_UI_SETTINGS_REGION := Rect2(72, 624, 996, 204)
const MENU_UI_DEV_MODE_REGION := Rect2(72, 900, 912, 192)
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
const DEALER_ENERGY_DRINK_GOLD_COST := 2
const ENERGY_DRINK_DURATION := 20.0
const ENERGY_DRINK_SPEED_MULTIPLIER := 1.45
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
const MELEE_HIT_STOP_TIME := 0.035

const TURRET_UPGRADE_1_WOOD_COST := 4
const TURRET_UPGRADE_1_STONE_COST := 2
const TURRET_UPGRADE_2_WOOD_COST := 6
const TURRET_UPGRADE_2_STONE_COST := 4

const HIT_FLASH_TIME := 0.16
const WAVE_BANNER_TIME := 1.6
const INVENTORY_FULL_FLASH_TIME := 0.9
const CAMERA_SHAKE_DECAY := 22.0
const CAMERA_SHAKE_MAX := 7.0
const PLAYER_STEP_EFFECT_INTERVAL := 0.105
const PLAYER_ACCELERATION := 1500.0
const PLAYER_TURN_ACCELERATION := 2450.0
const PLAYER_DECELERATION := 2050.0
const PLAYER_SKID_MIN_SPEED := 105.0
const PLAYER_SKID_TIME := 0.16
const MOTION_SPARK_TIME := 0.42
const SLASH_TRAIL_TIME := 0.24
const PHASE_TRANSITION_TIME := 0.46
# Player-chosen UI motion length (pick sheet, 2026-10-29): about 460 ms.
const UI_ANIM_TIME := 0.46
const UI_STAMP_TIME := 0.46
const UI_IRIS_TIME := 0.7
const DAMAGE_CRIT_THRESHOLD := 6
const UI_PAPER_FILL := Color(0.94, 0.89, 0.77)
const UI_PAPER_INK := Color(0.17, 0.14, 0.09)
const UI_PAPER_CARD := Color(0.99, 0.96, 0.88)
const UI_PAPER_MUTED := Color(0.40, 0.34, 0.25)
const UI_STAMP_LIFE := 0.9
const UI_FONT_PATH := "res://assets/fonts/Silkscreen-Regular.ttf"
const UI_STAMP_RED := Color(0.78, 0.23, 0.20)
const TURRET_BUILD_TIME := 2.2
const SELL_REFUND_RATIO := 0.5
const MENU_MUSIC_VOLUME_DB := -10.0
const GAMEPLAY_MUSIC_VOLUME_DB := -10.0
const MENU_MUSIC_START_TIME := 60.0
const CAVE_MUSIC_VOLUME_DB := -9.0
const BOSS_MUSIC_VOLUME_DB := -8.0
const BOSS_MUSIC_START_TIME := 22.0
const MENU_BACKGROUND_BEAT_ZOOM := 0.055
const MENU_BACKGROUND_FRAME_RATE := 4.6
const MENU_BACKGROUND_PARALLAX := 5.0
const MENU_MUSIC_CROSSFADE_TIME := 1.2
const MENU_MUSIC_CROSSFADE_START_DB := -32.0
const MENU_MUSIC_BUS_NAME := "MenuMusic"
const SFX_BUS_NAME := "SFX"
const SETTINGS_PATH := "user://tax_season_siege.cfg"
const MUSIC_CREDIT_TOAST_TIME := 6.0
const TEAM_INTRO_PATH := "res://assets/intro/foundry_eight_intro.ogv"
const TEAM_INTRO_FADE_IN_TIME := 0.45
const TEAM_INTRO_FADE_OUT_TIME := 0.38
const TEAM_INTRO_SKIP_HINT_DELAY := 0.65
const REVIVE_OFFER_DELAY := 1.35
const REVIVE_OFFER_DURATION := 10.0
const GAMEPLAY_MUSIC_TITLES := ["A risky trek.", "Spaceflight", "we. all. lain."]
const GAMEPLAY_MUSIC_ARTISTS := ["SovieticoOfficial", "SovieticoOfficial & Vista Sounds", "SovieticoOfficial"]
const MUSIC_CREDIT_LINKS := [
	{"label": "I miss you. - SovieticoOfficial", "url": "https://www.newgrounds.com/audio/listen/1497951"},
	{"label": "A risky trek. - SovieticoOfficial", "url": "https://www.newgrounds.com/audio/listen/1517909"},
	{"label": "we. all. lain. - SovieticoOfficial", "url": "https://www.newgrounds.com/audio/listen/1525368"},
	{"label": "Spaceflight - SovieticoOfficial & Vista Sounds", "url": "https://www.newgrounds.com/audio/listen/1530823"},
	{"label": "Betrayal - SovieticoOfficial", "url": "https://www.newgrounds.com/audio/listen/1593618"},
	{"label": "a breakcore song - SovieticoOfficial", "url": "https://www.newgrounds.com/audio/listen/1598849"}
]
const SFX_CREDIT_LINKS := [
	{"label": "Crossbow - ali_6868", "url": "https://freesound.org/s/384919/"},
	{"label": "Layered gunshot - xenonn", "url": "https://freesound.org/s/128296/"},
	{"label": "Small explosion - ryansnook", "url": "https://freesound.org/s/110115/"}
]
const TEAM_CREDIT_LINES := [
	"Viktor Nikolaev Dimitrov - Team Chief and Main Programmer",
	"Aleksandar Hristov Panov - Digital Art",
	"Aleks Diqan Nikolov - Digital Art",
	"Joseph Mavlqnov - Game Tester"
]
const IRS_WAVE_CLEAR_LINES := [
	"AUDIT DENIED\nThe paperwork retreats",
	"DEDUCTION ACCEPTED\nSomehow that worked",
	"IRS RECONSIDERING\nPlease hold forever",
	"NO BALANCE DUE\nExcept emotional damage"
]
const IRS_DEFEAT_TAUNTS := [
	"The IRS has assessed one air fryer, two couches, and Bob's last shred of dignity.",
	"Official notice: the console is now government property. The save file remains emotionally taxable.",
	"Bob requested an extension. The breach team requested the television.",
	"Penalty applied: one treasured console and several extremely personal receipts."
]
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
const ROUND_DIFFICULTY_MULTIPLIER := 1.22
const ENEMY_ATTACK_RATE := 0.62
const ENEMY_ATTACK_WINDUP := 0.34
const SPAWN_WARNING_LOOKAHEAD := 1.65
const EARLY_ROUND_ENEMY_COUNTS := [3, 5, 7, 10, 13]
const EARLY_ROUND_ENEMY_HP := [3, 4, 5, 6, 8]
const EARLY_ROUND_ENEMY_SPEED := [52.0, 58.0, 64.0, 71.0, 78.0]
const EARLY_ROUND_SPAWN_GAP := [1.42, 1.18, 1.02, 0.90, 0.80]
const EARLY_ROUND_BRUTE_EVERY := [0, 0, 0, 5, 3]
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
const PLAYER_IDLE_DRAW_SIZE := PLAYER_DRAW_SIZE
const PLAYER_IDLE_DRAW_OFFSET := PLAYER_DRAW_OFFSET
const PLAYER_RUN_DRAW_SIZE := PLAYER_DRAW_SIZE
const PLAYER_RUN_DRAW_OFFSET := PLAYER_DRAW_OFFSET
const TURRET_DRAW_SIZE := Vector2(56, 28)
const CANNON_TURRET_DRAW_SIZE := Vector2(102, 50)
const GOLDEN_TURRET_DRAW_SIZE := Vector2(90, 66)
const GUN_TURRET_DRAW_SIZE := Vector2(88, 56)
const CANNON_TURRET_TOP_DRAW_SIZE := Vector2(74, 46)
const CANNON_TURRET_BASE_DRAW_SIZE := Vector2(62, 66)
const GUN_TURRET_TOP_DRAW_SIZE := Vector2(68, 21)
const GUN_TURRET_BASE_DRAW_SIZE := Vector2(52, 32)
const MAGIC_TURRET_DRAW_SIZE := Vector2(92, 92)
const MAGIC_TURRET_TOP_DRAW_SIZE := Vector2(84, 60)
const MAGIC_TURRET_BASE_DRAW_SIZE := Vector2(74, 64)
const DECOR_GRASS_DRAW_SIZE := Vector2(44, 16)
const DECOR_SUNFLOWER_DRAW_SIZE := Vector2(48, 30)
const FOREST_TREE_DRAW_SIZE := Vector2(132, 164)
const FOREST_DOG_DRAW_SIZE := Vector2(86, 68)
const FOREST_BEAVER_DRAW_SIZE := Vector2(80, 64)
const DEALER_STAND_DRAW_SIZE := Vector2(80, 96)
const ARMS_DEALER_REGION := Rect2()
const ARMS_DEALER_DRAW_SIZE := Vector2(58, 112)
const ROCK_BIG_DRAW_SIZE := Vector2(28, 28)
const ROCK_MEDIUM_DRAW_SIZE := Vector2(24, 18)
const ROCK_SMALL_DRAW_SIZE := Vector2(18, 12)
const IRS_ROBOT_WALK_REGION := Rect2(42, 35, 12, 25)
const IRS_ROBOT_DEATH_REGION := Rect2(36, 35, 24, 25)
const IRS_ROBOT_DRAW_SIZE := Vector2(32, 66)
const IRS_BRUTE_DRAW_SIZE := Vector2(40, 84)
const IRS_BRUTE_DEATH_DRAW_SIZE := Vector2(80, 84)
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
const PLAYER_SWORD_DRAW_SIZE := Vector2(14, 54)
const PLAYER_SHIELD_DRAW_SIZE := Vector2(30, 38)
const PLAYER_SHIELD_BLOCK_DRAW_SIZE := Vector2(42, 46)
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
enum ReplayMode { OFF, RECORD, PLAYBACK }
signal replay_requested(run_id: String, entry_id: String)

const PLAYER_VISUAL_SCENE := preload("res://scenes/visuals/player_visual.tscn")
const DEALER_VISUAL_SCENE := preload("res://scenes/visuals/dealer_visual.tscn")
const TURRET_VISUAL_SCENE := preload("res://scenes/visuals/turret_visual.tscn")
const ENEMY_VISUAL_SCENE := preload("res://scenes/visuals/enemy_visual.tscn")

var phase := Phase.MENU
var simulation_rng := RandomNumberGenerator.new()
var replay_tape: RefCounted
var replay_mode := ReplayMode.OFF
var replay_frame_index := 0
var replay_run_seed := 0
var replay_diverged := false
var replay_divergence_tick := -1
var replay_input_actions: Array[String] = []
var replay_mouse_position := Vector2.ZERO
var replay_pending_events: Array[Dictionary] = []
var replay_injecting_event := false
var replay_gui_dispatching := false
var replay_recording_error := ""
var replay_was_persistence_enabled := true
var replay_pre_playback_metadata: Dictionary = {}
var replay_last_run_id := ""
var replay_last_path := ""
var replay_playback_paused := false
var replay_playback_speed := 1.0
var replay_playback_accumulator := 0.0
var replay_seek_in_progress := false
var replay_used_dev_mode := false
var leaderboard_host: Node
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
var player_move_velocity := Vector2.ZERO
var player_stride_clock := 0.0
var player_skid_timer := 0.0
var player_step_impact := 0.0
var selected_cell := Vector2i.ZERO
var camera_position := Vector2.ZERO
var camera_shake_strength := 0.0
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
var player_gun_kick_timer := 0.0
var hit_stop_timer := 0.0
var player_facing_left := false
var house_flash_timer := 0.0
var wave_banner_timer := 0.0
var wave_banner_text := ""
var build_menu_open := false
var selected_sentry_kind := "arrow"
var build_menu_tab := "sentries"
var dealer_menu_open := false
var dealer_page := "buy"
var dealer_selected_index := 0
var inventory_menu_open := false
var run_start_input_lock_timer := 0.0
var dev_mode_enabled := false
var dev_tools_available := false
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
var tutorial_moved := false
var tutorial_visible := true
var tutorial_opened_dealer := false
var tutorial_entered_cave := false
var tutorial_repaired_house := false
var tutorial_enabled := true

var run_elapsed_time := 0.0
var run_enemies_defeated := 0
var run_resources_gathered := 0
var run_structures_built := 0
var run_repairs_completed := 0

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
var menu_state_badge_label: Label
var menu_start_button: Button
var menu_settings_button: Button
var menu_tutorial_button: Button
var menu_dev_button: Button
var menu_leaderboard_button: Button
var menu_credits_button: Button
var menu_continue_hint_label: Label
var menu_info_label: Label
var menu_settings_panel: ColorRect
var menu_fullscreen_button: Button
var menu_effects_button: Button
var menu_minimal_hud_button: Button
var menu_damage_numbers_button: Button
var menu_low_health_button: Button
var menu_control_prompts_button: Button
var menu_motion_button: Button
var menu_dev_invincible_button: Button
var screen_shake_slider: HSlider
var screen_shake_value_label: Label
var menu_dev_speed_slider: HSlider
var menu_dev_speed_value_label: Label
var menu_dev_settings_hint_label: Label
var menu_credits_panel: ColorRect
var menu_credits_back_button: Button
var music_volume_slider: HSlider
var sfx_volume_slider: HSlider
var inventory_music_volume_slider: HSlider
var inventory_sfx_volume_slider: HSlider
var inventory_dev_invincible_button: Button
var inventory_dev_speed_slider: HSlider
var inventory_dev_speed_value_label: Label
var music_volume_value_label: Label
var sfx_volume_value_label: Label
var menu_dev_panel: ColorRect
var menu_dev_pin_label: Label
var menu_dev_pin_input: LineEdit
var menu_dev_status_label: Label
var menu_settings_open := false
var menu_credits_open := false
var escape_confirm_panel: ColorRect
var escape_confirm_title_label: Label
var escape_confirm_body_label: Label
var escape_confirm_hint_label: Label
var revive_offer_panel: ColorRect
var revive_offer_countdown_label: Label
var revive_offer_watch_button: Button
var revive_offer_decline_button: Button
var player_body_texture: Texture2D
var player_idle_left_1_texture: Texture2D
var player_idle_left_2_texture: Texture2D
var player_idle_right_1_texture: Texture2D
var player_idle_right_2_texture: Texture2D
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
var gun_sentry_top_texture: Texture2D
var gun_sentry_bottom_texture: Texture2D
var majestic_sentry_top_texture: Texture2D
var majestic_sentry_bottom_texture: Texture2D
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
var player_sword_texture: Texture2D
var shield_left_idle_texture: Texture2D
var shield_left_block_texture: Texture2D
var shield_right_idle_texture: Texture2D
var shield_right_block_texture: Texture2D
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
var energy_drink_texture: Texture2D
var menu_background_texture: Texture2D
var menu_background_frames: Array[Texture2D] = []
var menu_ui_texture: Texture2D
var loss_screen_texture: Texture2D
var loss_screen_used_rect := Rect2()
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
var ui_click_sound: AudioStreamWAV
var ui_hover_sound: AudioStreamWAV
var pickup_sound: AudioStreamWAV
var build_sound: AudioStreamWAV
var warning_sound: AudioStreamWAV
var impact_sound: AudioStreamWAV
var step_grass_sound: AudioStreamWAV
var step_wood_sound: AudioStreamWAV
var step_cave_sound: AudioStreamWAV
var menu_music_stream: AudioStream
var gameplay_music_streams: Array[AudioStream] = []
var cave_music_stream: AudioStream
var boss_music_stream: AudioStream
var world_time := 0.0
var explosion_effects: Array[Dictionary] = []
var motion_effects: Array[Dictionary] = []
var player_step_effect_timer := 0.0
var warning_sfx_cooldown := 0.0
var phase_transition_timer := 0.0
var phase_transition_color := Color(0.96, 0.82, 0.44)
# Cosmetic-only UI motion; never part of replay state hashes.
var ui_last_phase := -1
var menu_title_stamp_elapsed := 99.0
var iris_open_timer := 0.0
var hp_flinch_timer := 0.0
var ui_paper_active := false
var ui_panel_xform := Transform2D.IDENTITY
var ui_panel_was_open := false
var ui_panel_open_elapsed := 0.0
var ui_stamps: Array = []
var wave_banner_duration := WAVE_BANNER_TIME
var dealer_status_text := "The arms dealer trades in dollars."
var energy_drink_timer := 0.0
var turret_damage_bonus := 0
var gun_damage_bonus := 0
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_player_index := 0
var turret_visual_nodes := {}
var menu_music_player: AudioStreamPlayer
var gameplay_music_player: AudioStreamPlayer
var gameplay_music_track_index := 0
var cave_music_player: AudioStreamPlayer
var boss_music_player: AudioStreamPlayer
var music_credit_panel: ColorRect
var music_credit_title_label: Label
var music_credit_body_label: Label
var menu_music_bus_index := -1
var sfx_bus_index := -1
var created_menu_music_bus := false
var created_sfx_bus := false
var menu_music_spectrum_effect_index := 0
var menu_music_visual_pulse := 0.0
var menu_music_energy_smooth := 0.0
var menu_music_crossfade_remaining := 0.0
var current_cave_music_segment_id := ""
var music_volume_percent := 100.0
var sfx_volume_percent := 100.0
var fullscreen_enabled := true
var effects_quality_high := true
var screen_shake_percent := 100.0
var minimal_hud_enabled := true
var damage_numbers_enabled := true
var low_health_warning_enabled := true
var auto_control_prompts_enabled := true
var menu_motion_enabled := true
var last_input_device := "keyboard"
var dev_invincible_enabled := false
var dev_speed_percent := 100.0
var game_over_taunt := ""
var persistent_gun_sentry_unlocked := false
var persistent_golden_sentry_unlocked := false
var persistent_magic_sentry_unlocked := false
var persistent_shield_unlocked := true
var persistent_cave_boss_defeated := false
var settings_path := SETTINGS_PATH
var persistence_enabled := true
var team_intro_active := false
var team_intro_fading_out := false
var team_intro_elapsed := 0.0
var team_intro_fade_elapsed := 0.0
var team_intro_layer: CanvasLayer
var team_intro_video: VideoStreamPlayer
var team_intro_fade: ColorRect
var team_intro_skip_label: Label
var music_credit_track_id := ""
var music_credit_hide_at := 0.0
var enemy_visual_nodes := {}
var enemy_cluster_counts := {}
var enemy_cluster_cache_timer := 0.0
var graceful_shutdown_started := false
var revive_used := false
var revive_offer_pending := false
var revive_offer_visible := false
var revive_offer_delay := 0.0
var revive_offer_countdown := 0.0
var ad_in_progress := false

@onready var visual_layer: Node2D = $VisualLayer
@onready var player_visual_node: Node2D = $VisualLayer/PlayerVisual
@onready var dealer_visual_node: Node2D = $VisualLayer/DealerVisual
@onready var turret_visual_container: Node2D = $VisualLayer/TurretVisuals
@onready var enemy_visual_container: Node2D = $VisualLayer/EnemyVisuals
@onready var player_visual_sprite: Sprite2D = $VisualLayer/PlayerVisual/Body
@onready var player_shield_sprite: Sprite2D = $VisualLayer/PlayerVisual/Shield
@onready var player_sword_sprite: Sprite2D = $VisualLayer/PlayerVisual/Sword
@onready var dealer_visual_sprite: Sprite2D = $VisualLayer/DealerVisual/Dealer


func _ready() -> void:
	get_tree().auto_accept_quit = false
	_apply_ui_font()
	_load_persistent_settings()
	_apply_window_mode()
	# Keep the team's protected developer menu available in normal builds.
	# The PIN gate still prevents it from being enabled accidentally.
	dev_tools_available = true
	randomize()
	simulation_rng.randomize()
	_ensure_input_actions()
	replay_input_actions.clear()
	for action in InputMap.get_actions():
		replay_input_actions.append(String(action))
	replay_input_actions.sort()
	_load_art_assets()
	_build_audio_players()
	_build_hud()
	_paperize_settings_panel()
	_connect_ad_service()
	_setup_leaderboard_host()
	_connect_ui_audio_feedback(self)
	_reset_static_layout()
	_setup_visual_nodes()
	_setup_team_intro()
	if "--autostart-run" in OS.get_cmdline_user_args():
		call_deferred("_start_new_game")
	if "--standalone-smoke-exit" in OS.get_cmdline_user_args():
		call_deferred("_run_standalone_smoke_exit")
	_refresh_hud()
	if menu_start_button != null:
		menu_start_button.call_deferred("grab_focus")


func start_replay_recording(seed_value: int = -1) -> bool:
	if replay_mode == ReplayMode.PLAYBACK:
		return false
	if replay_tape == null:
		replay_tape = load("res://scripts/replay/replay_tape.gd").new()
	replay_run_seed = seed_value if seed_value >= 0 else int(Time.get_ticks_usec() % 9007199254740991)
	if not replay_tape.begin(REPLAY_GAME_VERSION, replay_run_seed, 60, _capture_replay_metadata()):
		return false
	replay_mode = ReplayMode.RECORD
	replay_frame_index = 0
	replay_diverged = false
	replay_divergence_tick = -1
	replay_recording_error = ""
	replay_pending_events.clear()
	replay_last_run_id = _new_replay_run_id()
	replay_used_dev_mode = dev_mode_enabled
	replay_mouse_position = get_viewport().get_mouse_position() if is_inside_tree() else Vector2.ZERO
	_start_new_game()
	return true


func finish_replay_recording() -> PackedByteArray:
	if replay_mode != ReplayMode.RECORD or replay_tape == null:
		return PackedByteArray()
	replay_mode = ReplayMode.OFF
	var encoded: PackedByteArray = replay_tape.encode()
	if encoded.is_empty():
		replay_recording_error = "Recording could not be finalized: compressed replay exceeded the 5 MiB limit or was invalid."
		return PackedByteArray()
	if not _save_replay_artifact(encoded):
		replay_recording_error = "Replay bytes were recorded but could not be saved locally."
		return PackedByteArray()
	return encoded


func start_replay_playback(encoded_tape: PackedByteArray) -> bool:
	var candidate = load("res://scripts/replay/replay_tape.gd").new()
	var recording: Dictionary = candidate.decode(encoded_tape)
	if recording.is_empty():
		printerr("REPLAY_LOAD_REJECTED invalid tape; bytes=", encoded_tape.size(), " reason=", candidate.last_decode_error)
		return false
	if String(recording.get("game_version", "")) != REPLAY_GAME_VERSION:
		printerr("REPLAY_LOAD_REJECTED replay game version mismatch")
		return false
	if not candidate.load_playback(recording):
		return false
	replay_pre_playback_metadata = _capture_replay_metadata()
	replay_tape = candidate
	replay_mode = ReplayMode.PLAYBACK
	replay_run_seed = int(recording["seed"])
	replay_frame_index = 0
	replay_diverged = false
	replay_divergence_tick = -1
	replay_playback_paused = false
	replay_playback_speed = 1.0
	replay_playback_accumulator = 0.0
	replay_mouse_position = Vector2(recording.get("metadata", {}).get("mouse", [0.0, 0.0])[0], recording.get("metadata", {}).get("mouse", [0.0, 0.0])[1])
	replay_pending_events.clear()
	replay_was_persistence_enabled = persistence_enabled
	persistence_enabled = false
	_apply_replay_metadata(recording.get("metadata", {}))
	_start_new_game()
	return true


func seek_replay(target_tick: int) -> bool:
	if replay_mode != ReplayMode.PLAYBACK or replay_tape == null or target_tick < 0 or target_tick > replay_tape.data["frames"].size():
		return false
	if not replay_tape.seek(0):
		return false
	replay_frame_index = 0
	replay_diverged = false
	replay_divergence_tick = -1
	replay_playback_paused = false
	replay_playback_speed = 1.0
	replay_playback_accumulator = 0.0
	var metadata: Dictionary = replay_tape.data.get("metadata", {})
	var initial_mouse: Array = metadata.get("mouse", [0.0, 0.0])
	replay_mouse_position = Vector2(initial_mouse[0], initial_mouse[1])
	_apply_replay_metadata(metadata)
	_start_new_game()
	replay_seek_in_progress = true
	for _step in range(target_tick):
		_process(0.0)
		if replay_diverged:
			replay_seek_in_progress = false
			return false
	replay_seek_in_progress = false
	return true


func seek_replay_to_wave(wave: int) -> bool:
	if replay_tape == null or wave < 1:
		return false
	var tick: int = replay_tape.marker_tick("wave", wave - 1)
	return tick >= 0 and seek_replay(tick)


func set_replay_paused(paused: bool) -> void:
	if replay_mode == ReplayMode.PLAYBACK:
		replay_playback_paused = paused


func set_replay_speed(speed: float) -> void:
	if replay_mode == ReplayMode.PLAYBACK and is_finite(speed):
		replay_playback_speed = clampf(speed, 0.1, 4.0)


func stop_replay_playback() -> void:
	if replay_mode == ReplayMode.PLAYBACK:
		replay_mode = ReplayMode.OFF
		persistence_enabled = replay_was_persistence_enabled
		replay_playback_paused = false
		replay_playback_speed = 1.0
		replay_playback_accumulator = 0.0
		_apply_replay_metadata(replay_pre_playback_metadata)


func _capture_replay_metadata() -> Dictionary:
	var mouse := get_viewport().get_mouse_position() if is_inside_tree() else Vector2.ZERO
	return {
		"dev_mode": dev_mode_enabled,
		"dev_invincible": dev_invincible_enabled,
		"dev_speed": dev_speed_percent,
		"tutorial_enabled": tutorial_enabled,
		"effects_high": effects_quality_high,
		"shake_percent": screen_shake_percent,
		"gun_unlocked": persistent_gun_sentry_unlocked,
		"golden_unlocked": persistent_golden_sentry_unlocked,
		"magic_unlocked": persistent_magic_sentry_unlocked,
		"shield_unlocked": persistent_shield_unlocked,
		"mouse": [mouse.x, mouse.y]
	}


func _apply_replay_metadata(metadata: Dictionary) -> void:
	dev_mode_enabled = bool(metadata.get("dev_mode", false))
	dev_invincible_enabled = bool(metadata.get("dev_invincible", false))
	dev_speed_percent = clampf(float(metadata.get("dev_speed", 100.0)), 25.0, 400.0)
	tutorial_enabled = bool(metadata.get("tutorial_enabled", true))
	effects_quality_high = bool(metadata.get("effects_high", true))
	screen_shake_percent = clampf(float(metadata.get("shake_percent", 100.0)), 0.0, 150.0)
	persistent_gun_sentry_unlocked = bool(metadata.get("gun_unlocked", false))
	persistent_golden_sentry_unlocked = bool(metadata.get("golden_unlocked", false))
	persistent_magic_sentry_unlocked = bool(metadata.get("magic_unlocked", false))
	persistent_shield_unlocked = bool(metadata.get("shield_unlocked", true))
	if leaderboard_host != null:
		leaderboard_host.set_dev_mode_active(dev_mode_enabled)


func _new_replay_run_id() -> String:
	var hex := Crypto.new().generate_random_bytes(16).hex_encode()
	hex = hex.substr(0, 12) + "4" + hex.substr(13)
	hex = hex.substr(0, 16) + "8" + hex.substr(17)
	return "%s-%s-%s-%s-%s" % [hex.substr(0, 8), hex.substr(8, 4), hex.substr(12, 4), hex.substr(16, 4), hex.substr(20, 12)]


func _save_replay_artifact(encoded: PackedByteArray) -> bool:
	if replay_last_run_id.is_empty() or encoded.is_empty() or encoded.size() > 5 * 1024 * 1024:
		return false
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("user://replays")) != OK:
		return false
	replay_last_path = "user://replays/%s.tsr" % replay_last_run_id
	var file := FileAccess.open(replay_last_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_buffer(encoded)
	file.flush()
	file.close()
	return FileAccess.file_exists(replay_last_path)


func _finalize_run_after_game_over() -> void:
	if replay_mode != ReplayMode.RECORD:
		return
	var used_dev := replay_used_dev_mode or dev_mode_enabled
	finish_replay_recording()
	if leaderboard_host != null:
		leaderboard_host.set_dev_mode_active(dev_mode_enabled)
		leaderboard_host.open_game_over(round_number, replay_last_run_id, round_number, replay_last_path, used_dev)


func _setup_leaderboard_host() -> void:
	var host_script = load("res://scripts/leaderboard/leaderboard_host.gd")
	if host_script == null:
		return
	leaderboard_host = host_script.new()
	leaderboard_host.name = "LeaderboardHost"
	add_child(leaderboard_host)
	if not leaderboard_host.setup(self, LEADERBOARD_BASE_URL):
		leaderboard_host.queue_free()
		leaderboard_host = null
		return
	leaderboard_host.set_dev_mode_active(dev_mode_enabled)
	leaderboard_host.replay_open_requested.connect(_on_leaderboard_replay_open_requested)
	leaderboard_host.replay_downloaded.connect(_on_leaderboard_replay_downloaded)
	leaderboard_host.replay_download_failed.connect(_on_leaderboard_replay_download_failed)


func _on_leaderboard_replay_open_requested(run_id: String, entry_id: String) -> void:
	replay_requested.emit(run_id, entry_id)
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		_on_leaderboard_replay_download_failed(run_id, "Close the current run before opening a shared replay.")
		return
	if not leaderboard_host.download_replay(run_id):
		_on_leaderboard_replay_download_failed(run_id, "The replay download could not be started.")


func _on_leaderboard_replay_downloaded(run_id: String, bytes: PackedByteArray) -> void:
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		_on_leaderboard_replay_download_failed(run_id, "Close the current run before opening a shared replay.")
		return
	if not start_replay_playback(bytes):
		_on_leaderboard_replay_download_failed(run_id, "The downloaded replay is invalid or was made by a different game version.")
		return
	leaderboard_host.close_panel()


func _on_leaderboard_replay_download_failed(run_id: String, message: String) -> void:
	replay_recording_error = "Replay %s: %s" % [run_id, message]
	if leaderboard_host != null:
		leaderboard_host._update_snapshot("error", message)


func _on_menu_leaderboard_pressed() -> void:
	if leaderboard_host != null:
		leaderboard_host.open_menu()


func _capture_replay_inputs() -> Dictionary:
	var held: Array[String] = []
	var strengths := {}
	for action in replay_input_actions:
		var strength := Input.get_action_strength(action)
		if Input.is_action_pressed(action) or strength > 0.0:
			held.append(action)
			strengths[action] = clampf(strength, 0.0, 1.0)
	return {"held": held, "strengths": strengths}


func _serialize_replay_input_event(event: InputEvent) -> Dictionary:
	var base := {"device": event.device}
	if event is InputEventKey:
		var key := event as InputEventKey
		base.merge({"type": "key", "keycode": key.keycode, "physical": key.physical_keycode, "label": key.key_label, "unicode": key.unicode, "pressed": key.pressed, "echo": key.echo, "alt": key.alt_pressed, "shift": key.shift_pressed, "ctrl": key.ctrl_pressed, "meta": key.meta_pressed, "location": key.location}, true)
	elif event is InputEventMouseButton:
		var button := event as InputEventMouseButton
		base.merge({"type": "mouse_button", "button": button.button_index, "pressed": button.pressed, "double": button.double_click, "factor": button.factor, "position": [button.position.x, button.position.y], "global_position": [button.global_position.x, button.global_position.y]}, true)
	elif event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		base.merge({"type": "mouse_motion", "position": [motion.position.x, motion.position.y], "global_position": [motion.global_position.x, motion.global_position.y], "relative": [motion.relative.x, motion.relative.y], "velocity": [motion.velocity.x, motion.velocity.y], "button_mask": motion.button_mask, "pressure": motion.pressure, "tilt": [motion.tilt.x, motion.tilt.y]}, true)
	elif event is InputEventJoypadButton:
		var button := event as InputEventJoypadButton
		base.merge({"type": "joy_button", "button": button.button_index, "pressed": button.pressed, "pressure": button.pressure}, true)
	elif event is InputEventJoypadMotion:
		var motion := event as InputEventJoypadMotion
		base.merge({"type": "joy_motion", "axis": motion.axis, "value": motion.axis_value}, true)
	elif event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		base.merge({"type": "touch", "index": touch.index, "pressed": touch.pressed, "double": touch.double_tap, "position": [touch.position.x, touch.position.y]}, true)
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		base.merge({"type": "screen_drag", "index": drag.index, "position": [drag.position.x, drag.position.y], "relative": [drag.relative.x, drag.relative.y], "velocity": [drag.velocity.x, drag.velocity.y], "pressure": drag.pressure, "tilt": [drag.tilt.x, drag.tilt.y]}, true)
	elif event is InputEventAction:
		var action := event as InputEventAction
		base.merge({"type": "action", "action": String(action.action), "pressed": action.pressed, "strength": action.strength}, true)
	else:
		return {}
	return base


func _deserialize_replay_input_event(data: Dictionary) -> InputEvent:
	var event: InputEvent
	match String(data.get("type", "")):
		"key":
			var key := InputEventKey.new()
			key.keycode = int(data.get("keycode", 0))
			key.physical_keycode = int(data.get("physical", 0))
			key.key_label = int(data.get("label", 0))
			key.unicode = int(data.get("unicode", 0))
			key.pressed = bool(data.get("pressed", false))
			key.echo = bool(data.get("echo", false))
			key.alt_pressed = bool(data.get("alt", false))
			key.shift_pressed = bool(data.get("shift", false))
			key.ctrl_pressed = bool(data.get("ctrl", false))
			key.meta_pressed = bool(data.get("meta", false))
			key.location = int(data.get("location", 0))
			event = key
		"mouse_button":
			var button := InputEventMouseButton.new()
			button.button_index = int(data.get("button", MOUSE_BUTTON_LEFT))
			button.pressed = bool(data.get("pressed", false))
			button.double_click = bool(data.get("double", false))
			button.factor = float(data.get("factor", 1.0))
			button.position = Vector2(data.get("position", [0.0, 0.0])[0], data.get("position", [0.0, 0.0])[1])
			button.global_position = Vector2(data.get("global_position", [0.0, 0.0])[0], data.get("global_position", [0.0, 0.0])[1])
			event = button
		"mouse_motion":
			var motion := InputEventMouseMotion.new()
			motion.position = Vector2(data.get("position", [0.0, 0.0])[0], data.get("position", [0.0, 0.0])[1])
			motion.global_position = Vector2(data.get("global_position", [0.0, 0.0])[0], data.get("global_position", [0.0, 0.0])[1])
			motion.relative = Vector2(data.get("relative", [0.0, 0.0])[0], data.get("relative", [0.0, 0.0])[1])
			motion.velocity = Vector2(data.get("velocity", [0.0, 0.0])[0], data.get("velocity", [0.0, 0.0])[1])
			motion.button_mask = int(data.get("button_mask", 0))
			motion.pressure = float(data.get("pressure", 0.0))
			motion.tilt = Vector2(data.get("tilt", [0.0, 0.0])[0], data.get("tilt", [0.0, 0.0])[1])
			event = motion
		"joy_button":
			var button := InputEventJoypadButton.new()
			button.button_index = int(data.get("button", 0))
			button.pressed = bool(data.get("pressed", false))
			button.pressure = float(data.get("pressure", 0.0))
			event = button
		"joy_motion":
			var motion := InputEventJoypadMotion.new()
			motion.axis = int(data.get("axis", 0))
			motion.axis_value = float(data.get("value", 0.0))
			event = motion
		"touch":
			var touch := InputEventScreenTouch.new()
			touch.index = int(data.get("index", 0))
			touch.pressed = bool(data.get("pressed", false))
			touch.double_tap = bool(data.get("double", false))
			touch.position = Vector2(data.get("position", [0.0, 0.0])[0], data.get("position", [0.0, 0.0])[1])
			event = touch
		"screen_drag":
			var drag := InputEventScreenDrag.new()
			drag.index = int(data.get("index", 0))
			drag.position = Vector2(data.get("position", [0.0, 0.0])[0], data.get("position", [0.0, 0.0])[1])
			drag.relative = Vector2(data.get("relative", [0.0, 0.0])[0], data.get("relative", [0.0, 0.0])[1])
			drag.velocity = Vector2(data.get("velocity", [0.0, 0.0])[0], data.get("velocity", [0.0, 0.0])[1])
			drag.pressure = float(data.get("pressure", 0.0))
			drag.tilt = Vector2(data.get("tilt", [0.0, 0.0])[0], data.get("tilt", [0.0, 0.0])[1])
			event = drag
		"action":
			var action := InputEventAction.new()
			action.action = StringName(String(data.get("action", "")))
			action.pressed = bool(data.get("pressed", false))
			action.strength = float(data.get("strength", 1.0))
			event = action
	if event != null:
		event.device = int(data.get("device", -1))
	return event


func _replay_deliver_input_event(data: Dictionary) -> void:
	var event := _deserialize_replay_input_event(data)
	if event == null:
		replay_diverged = true
		replay_divergence_tick = replay_frame_index
		return
	if data.has("position"):
		replay_mouse_position = Vector2(data["position"][0], data["position"][1])
	replay_injecting_event = true
	_input(event)
	replay_gui_dispatching = true
	Input.parse_input_event(event)
	replay_gui_dispatching = false
	replay_injecting_event = false


func _replay_get_mouse_position() -> Vector2:
	return replay_mouse_position if replay_mode != ReplayMode.OFF else get_viewport().get_mouse_position()


func _replay_action_pressed(action: String) -> bool:
	if replay_mode == ReplayMode.PLAYBACK:
		return replay_tape.is_action_pressed(action)
	return Input.is_action_pressed(action)


func _replay_action_just_pressed(action: String) -> bool:
	if replay_mode == ReplayMode.PLAYBACK:
		return replay_tape.is_action_just_pressed(action)
	return Input.is_action_just_pressed(action)


func _replay_action_strength(action: String) -> float:
	if replay_mode == ReplayMode.PLAYBACK:
		return replay_tape.get_action_strength(action)
	return Input.get_action_strength(action)


func _replay_get_vector(left: String, right: String, up: String, down: String, deadzone: float = -1.0) -> Vector2:
	if replay_mode != ReplayMode.PLAYBACK:
		if deadzone < 0.0:
			return Input.get_vector(left, right, up, down)
		return Input.get_vector(left, right, up, down, deadzone)
	var vector := Vector2(_replay_action_strength(right) - _replay_action_strength(left), _replay_action_strength(down) - _replay_action_strength(up))
	var magnitude := vector.length()
	var effective_deadzone := deadzone if deadzone >= 0.0 else 0.2
	if magnitude <= effective_deadzone:
		return Vector2.ZERO
	return vector.normalized() * clampf((magnitude - effective_deadzone) / maxf(1.0 - effective_deadzone, 0.001), 0.0, 1.0)


func _simulation_randf() -> float:
	return simulation_rng.randf()


func _simulation_randf_range(from: float, to: float) -> float:
	return simulation_rng.randf_range(from, to)


func _simulation_randi() -> int:
	return simulation_rng.randi()


func _simulation_randi_range(from: int, to: int) -> int:
	return simulation_rng.randi_range(from, to)


func _simulation_shuffle(values: Array) -> void:
	for index in range(values.size() - 1, 0, -1):
		var other := _simulation_randi_range(0, index)
		var temporary: Variant = values[index]
		values[index] = values[other]
		values[other] = temporary


func _simulation_pick_random(values: Array) -> Variant:
	if values.is_empty():
		return null
	return values[_simulation_randi_range(0, values.size() - 1)]


func _replay_json_safe(value: Variant) -> Variant:
	if value is Vector2:
		return [value.x, value.y]
	if value is Vector2i:
		return [value.x, value.y]
	if value is Rect2:
		return [value.position.x, value.position.y, value.size.x, value.size.y]
	if value is Color:
		return [value.r, value.g, value.b, value.a]
	if value is StringName:
		return String(value)
	if value is Dictionary:
		var result := {}
		for key in value:
			result[String(key)] = _replay_json_safe(value[key])
		return result
	if value is Array:
		var result: Array = []
		for item in value:
			result.append(_replay_json_safe(item))
		return result
	if value is Object:
		return "<" + value.get_class() + ">"
	return value


func get_replay_state_hash() -> String:
	var snapshot := {
		"phase": phase, "round": round_number, "countdown": countdown, "world_time": world_time,
		"run_elapsed": run_elapsed_time, "player_hp": player_hp, "player_position": player_position,
		"player_velocity": player_move_velocity, "player_stride": player_stride_clock,
		"pointer": replay_mouse_position, "build_menu": build_menu_open, "dealer_menu": dealer_menu_open,
		"inventory_menu": inventory_menu_open, "escape_confirm": escape_confirm_open, "tutorial": tutorial_visible,
		"selected_cell": selected_cell, "build_tab": build_menu_tab, "selected_sentry": selected_sentry_kind,
		"inside_house": inside_house, "inside_cave": inside_cave, "interior_position": interior_player_position,
		"cave_position": cave_player_position, "wood": wood, "stone": stone, "iron": iron,
		"gold": gold, "gunpowder": gunpowder, "crystals": cave_crystals_owned,
		"structures": structures, "enemies": enemies, "corpses": enemy_corpses,
		"projectiles": projectiles, "spawn_queue": spawn_queue, "enemy_spawn_index": enemy_spawn_index,
		"resource_nodes": resource_nodes, "forest_trees": forest_tree_cells, "forest_animals": forest_animals,
		"generated_chunks": generated_forest_chunk_count, "cave_nodes": cave_nodes,
		"cave_enemies": cave_enemies, "cave_corpses": cave_enemy_corpses,
		"cave_crystals": cave_crystals, "rock_markers": cave_boss_rock_markers,
		"falling_rocks": cave_falling_rocks, "rock_rubble": cave_rock_rubble,
		"cave_room": cave_room_id, "cave_cycle": cave_cycle_index, "cave_boss_defeated": cave_boss_defeated,
		"defend_elapsed": defend_elapsed, "next_enemy_id": next_enemy_id,
		"enemy_shots": enemy_shots, "harvest_timer": harvest_timer
	}
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(JSON.stringify(_replay_json_safe(snapshot)).to_utf8_buffer())
	return context.finish().hex_encode()


func _get_replay_state_group_hashes() -> Dictionary:
	var groups := {
		"phase": [phase, round_number, countdown, world_time, run_elapsed_time, defend_elapsed, enemy_spawn_index, next_enemy_id],
		"player": [player_hp, player_position, player_move_velocity, player_stride_clock, player_attack_cooldown, player_swing_timer, player_aim_direction],
		"inventory": [wood, stone, iron, gold, gunpowder, cave_crystals_owned, turret_ammo, cannon_shells],
		"yard": [structures, enemies, enemy_corpses, projectiles, spawn_queue, enemy_shots],
		"forest": [resource_nodes, forest_tree_cells, forest_animals, generated_forest_chunk_count],
		"cave": [inside_cave, cave_player_position, cave_room_id, cave_nodes, cave_enemies, cave_enemy_corpses, cave_crystals, cave_boss_rock_markers, cave_falling_rocks, cave_rock_rubble]
	}
	var result := {}
	for group_name in groups:
		var context := HashingContext.new()
		context.start(HashingContext.HASH_SHA256)
		context.update(JSON.stringify(_replay_json_safe(groups[group_name])).to_utf8_buffer())
		result[group_name] = context.finish().hex_encode()
	return result


func _setup_team_intro() -> void:
	var user_args := OS.get_cmdline_user_args()
	var force_intro := "--force-intro" in user_args
	if "--skip-intro" in user_args or "--autostart-run" in user_args:
		return
	if DisplayServer.get_name() == "headless" and not force_intro:
		return
	var intro_stream := load(TEAM_INTRO_PATH) as VideoStream
	if intro_stream == null:
		push_warning("Team intro could not be loaded; continuing to the menu.")
		return

	team_intro_layer = CanvasLayer.new()
	team_intro_layer.layer = 200
	add_child(team_intro_layer)

	var intro_background := ColorRect.new()
	intro_background.position = Vector2.ZERO
	intro_background.size = SCREEN_SIZE
	intro_background.color = Color.BLACK
	intro_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	team_intro_layer.add_child(intro_background)

	team_intro_video = VideoStreamPlayer.new()
	team_intro_video.position = Vector2.ZERO
	team_intro_video.size = SCREEN_SIZE
	team_intro_video.expand = true
	team_intro_video.loop = false
	team_intro_video.bus = MENU_MUSIC_BUS_NAME
	team_intro_video.stream = intro_stream
	team_intro_video.mouse_filter = Control.MOUSE_FILTER_IGNORE
	team_intro_video.finished.connect(_begin_team_intro_exit)
	team_intro_layer.add_child(team_intro_video)

	team_intro_skip_label = Label.new()
	team_intro_skip_label.position = Vector2(0, SCREEN_SIZE.y - 62)
	team_intro_skip_label.size = Vector2(SCREEN_SIZE.x, 34)
	team_intro_skip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	team_intro_skip_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	team_intro_skip_label.text = "Click anywhere  •  Space or Esc to skip"
	team_intro_skip_label.add_theme_font_size_override("font_size", 17)
	team_intro_skip_label.add_theme_color_override("font_color", Color(0.94, 0.94, 0.94))
	team_intro_skip_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.88))
	team_intro_skip_label.add_theme_constant_override("shadow_offset_x", 2)
	team_intro_skip_label.add_theme_constant_override("shadow_offset_y", 2)
	team_intro_skip_label.modulate.a = 0.0
	team_intro_skip_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	team_intro_layer.add_child(team_intro_skip_label)

	team_intro_fade = ColorRect.new()
	team_intro_fade.position = Vector2.ZERO
	team_intro_fade.size = SCREEN_SIZE
	team_intro_fade.color = Color.BLACK
	team_intro_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	team_intro_layer.add_child(team_intro_fade)

	team_intro_active = true
	team_intro_fading_out = false
	team_intro_elapsed = 0.0
	team_intro_fade_elapsed = 0.0
	team_intro_video.play()


func _begin_team_intro_exit() -> void:
	if not team_intro_active or team_intro_fading_out:
		return
	team_intro_fading_out = true
	team_intro_fade_elapsed = 0.0


func _finish_team_intro() -> void:
	if team_intro_video != null and is_instance_valid(team_intro_video):
		team_intro_video.stop()
		team_intro_video.stream = null
	if team_intro_layer != null and is_instance_valid(team_intro_layer):
		team_intro_layer.queue_free()
	team_intro_active = false
	team_intro_fading_out = false
	team_intro_layer = null
	team_intro_video = null
	team_intro_fade = null
	team_intro_skip_label = null
	if phase == Phase.MENU:
		_play_menu_music(true)
	_refresh_hud()
	queue_redraw()


func _update_team_intro(delta: float) -> void:
	if not team_intro_active:
		return
	team_intro_elapsed += delta
	if team_intro_fading_out:
		team_intro_fade_elapsed += delta
		var fade_out_ratio := clampf(team_intro_fade_elapsed / TEAM_INTRO_FADE_OUT_TIME, 0.0, 1.0)
		if team_intro_fade != null:
			team_intro_fade.color.a = fade_out_ratio
		if team_intro_skip_label != null:
			team_intro_skip_label.modulate.a = 1.0 - fade_out_ratio
		if team_intro_video != null and is_instance_valid(team_intro_video) and team_intro_video.is_playing():
			team_intro_video.volume_db = lerpf(0.0, -36.0, fade_out_ratio)
		if fade_out_ratio >= 1.0:
			_finish_team_intro()
		return

	var fade_in_ratio := clampf(team_intro_elapsed / TEAM_INTRO_FADE_IN_TIME, 0.0, 1.0)
	if team_intro_fade != null:
		team_intro_fade.color.a = 1.0 - fade_in_ratio
	if team_intro_skip_label != null:
		team_intro_skip_label.modulate.a = clampf((team_intro_elapsed - TEAM_INTRO_SKIP_HINT_DELAY) * 2.5, 0.0, 0.82)


func _input(event: InputEvent) -> void:
	if replay_mode == ReplayMode.PLAYBACK and replay_gui_dispatching:
		return
	if replay_mode == ReplayMode.PLAYBACK and not replay_injecting_event:
		if event is InputEventKey:
			var replay_key := event as InputEventKey
			if replay_key.pressed and not replay_key.echo:
				match replay_key.keycode:
					KEY_ESCAPE:
						stop_replay_playback()
						_return_to_main_menu()
					KEY_SPACE:
						set_replay_paused(not replay_playback_paused)
					KEY_EQUAL, KEY_PLUS, KEY_KP_ADD:
						set_replay_speed(replay_playback_speed + 0.25)
					KEY_MINUS, KEY_KP_SUBTRACT:
						set_replay_speed(replay_playback_speed - 0.25)
					KEY_LEFT:
						seek_replay(maxi(replay_frame_index - 120, 0))
					KEY_RIGHT:
						seek_replay(mini(replay_frame_index + 120, replay_tape.data["frames"].size()))
					_:
						pass
				queue_redraw()
				get_viewport().set_input_as_handled()
				return
		get_viewport().set_input_as_handled()
		return
	if replay_mode == ReplayMode.RECORD and not replay_injecting_event:
		var serialized_event := _serialize_replay_input_event(event)
		if serialized_event.is_empty():
			replay_recording_error = "Unsupported input event: %s" % event.get_class()
		else:
			replay_pending_events.append(serialized_event)
			if event is InputEventMouseButton or event is InputEventMouseMotion:
				replay_mouse_position = event.position
	if auto_control_prompts_enabled:
		var detected_device := last_input_device
		if event is InputEventJoypadButton and (event as InputEventJoypadButton).pressed:
			detected_device = "controller"
		elif event is InputEventJoypadMotion and absf((event as InputEventJoypadMotion).axis_value) >= 0.35:
			detected_device = "controller"
		elif event is InputEventKey and (event as InputEventKey).pressed:
			detected_device = "keyboard"
		elif event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
			detected_device = "keyboard"
		if detected_device != last_input_device:
			last_input_device = detected_device
			_refresh_hud()
			queue_redraw()
	if event is InputEventKey:
		var global_key_event: InputEventKey = event
		if global_key_event.pressed and not global_key_event.echo and global_key_event.keycode == KEY_F11:
			_toggle_fullscreen()
			get_viewport().set_input_as_handled()
			return
	if team_intro_active:
		var skip_intro := false
		if event is InputEventMouseButton:
			var intro_mouse_event: InputEventMouseButton = event
			skip_intro = intro_mouse_event.pressed
		elif event is InputEventScreenTouch:
			var intro_touch_event: InputEventScreenTouch = event
			skip_intro = intro_touch_event.pressed
		elif event is InputEventKey:
			var intro_key_event: InputEventKey = event
			skip_intro = intro_key_event.pressed and not intro_key_event.echo and intro_key_event.keycode in [KEY_SPACE, KEY_ENTER, KEY_KP_ENTER, KEY_ESCAPE]
		elif event is InputEventJoypadButton:
			var intro_joy_event := event as InputEventJoypadButton
			skip_intro = intro_joy_event.pressed
		if skip_intro:
			_begin_team_intro_exit()
			get_viewport().set_input_as_handled()
		return
	if revive_offer_pending or revive_offer_visible or ad_in_progress:
		if revive_offer_visible:
			if event is InputEventKey:
				var revive_key := event as InputEventKey
				if revive_key.pressed and not revive_key.echo:
					if revive_key.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_Y]:
						_accept_revive_offer()
						get_viewport().set_input_as_handled()
					elif revive_key.keycode in [KEY_ESCAPE, KEY_N]:
						_decline_revive_offer("The offer was declined.")
						get_viewport().set_input_as_handled()
			elif event is InputEventJoypadButton:
				var revive_joy := event as InputEventJoypadButton
				if revive_joy.pressed and revive_joy.button_index == JOY_BUTTON_A:
					_accept_revive_offer()
					get_viewport().set_input_as_handled()
				elif revive_joy.pressed and revive_joy.button_index == JOY_BUTTON_B:
					_decline_revive_offer("The offer was declined.")
					get_viewport().set_input_as_handled()
		return
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
		if event is InputEventJoypadButton:
			var confirm_joy_event := event as InputEventJoypadButton
			if confirm_joy_event.pressed and confirm_joy_event.button_index == JOY_BUTTON_A:
				_accept_escape_confirm()
				get_viewport().set_input_as_handled()
				return
			if confirm_joy_event.pressed and confirm_joy_event.button_index == JOY_BUTTON_B:
				_close_escape_confirm()
				get_viewport().set_input_as_handled()
				return
	if event is InputEventJoypadButton:
		var cancel_joy_event := event as InputEventJoypadButton
		if cancel_joy_event.pressed and cancel_joy_event.button_index == JOY_BUTTON_B:
			if phase != Phase.MENU and phase != Phase.GAME_OVER:
				_handle_gameplay_cancel()
			elif menu_credits_open:
				_close_menu_credits()
			elif menu_settings_open:
				menu_settings_open = false
				_refresh_hud()
			elif dev_mode_prompt_open:
				_close_dev_mode_prompt()
				_refresh_hud()
			get_viewport().set_input_as_handled()
			return
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		if event is InputEventKey:
			var gameplay_key_event: InputEventKey = event
			if gameplay_key_event.pressed and not gameplay_key_event.echo and gameplay_key_event.keycode == KEY_TAB and build_menu_open:
				_set_build_menu_tab("walls" if build_menu_tab == "sentries" else "sentries")
				queue_redraw()
				get_viewport().set_input_as_handled()
				return
			if gameplay_key_event.pressed and not gameplay_key_event.echo and gameplay_key_event.keycode == KEY_E:
				if not build_menu_open and not dealer_menu_open and not escape_confirm_open:
					inventory_menu_open = not inventory_menu_open
					if inventory_menu_open:
						if dev_mode_enabled and inventory_dev_invincible_button != null:
							inventory_dev_invincible_button.call_deferred("grab_focus")
						elif inventory_music_volume_slider != null:
							inventory_music_volume_slider.call_deferred("grab_focus")
					_refresh_hud()
					queue_redraw()
					get_viewport().set_input_as_handled()
					return
			if gameplay_key_event.pressed and not gameplay_key_event.echo and gameplay_key_event.keycode == KEY_T:
				tutorial_visible = not tutorial_visible
				queue_redraw()
				get_viewport().set_input_as_handled()
				return
			if gameplay_key_event.pressed and not gameplay_key_event.echo and gameplay_key_event.keycode == KEY_ESCAPE:
				_handle_gameplay_cancel()
				get_viewport().set_input_as_handled()
				return
	if dealer_menu_open and not inside_house and not inside_cave:
		if event is InputEventMouseButton:
			var dealer_mouse_event: InputEventMouseButton = event
			if dealer_mouse_event.pressed and dealer_mouse_event.button_index == MOUSE_BUTTON_LEFT:
				var clicked_dealer_page: String = _dealer_page_at_position(dealer_mouse_event.position)
				if clicked_dealer_page != "":
					dealer_page = clicked_dealer_page
					dealer_selected_index = 0
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
				var clicked_build_tab: String = _build_menu_tab_at_position(build_mouse_event.position)
				if clicked_build_tab != "":
					_set_build_menu_tab(clicked_build_tab)
					queue_redraw()
					get_viewport().set_input_as_handled()
					return
				var clicked_weapon: String = _build_menu_weapon_at_position(build_mouse_event.position)
				if clicked_weapon != "":
					selected_sentry_kind = clicked_weapon
					_try_place_selected_sentry()
					get_viewport().set_input_as_handled()
					return
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	if menu_credits_open:
		if event is InputEventKey:
			var credits_key_event: InputEventKey = event
			if credits_key_event.pressed and not credits_key_event.echo and credits_key_event.keycode == KEY_ESCAPE:
				_close_menu_credits()
				get_viewport().set_input_as_handled()
				return
		return
	if menu_settings_open and event is InputEventKey:
		var settings_key_event: InputEventKey = event
		if settings_key_event.pressed and not settings_key_event.echo and settings_key_event.keycode == KEY_ESCAPE:
			menu_settings_open = false
			_refresh_hud()
			get_viewport().set_input_as_handled()
			return
	if menu_settings_open:
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


func _handle_gameplay_cancel() -> void:
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


func _return_to_main_menu() -> void:
	highest_round = max(highest_round, round_number)
	_save_persistent_settings()
	phase = Phase.MENU
	build_menu_open = false
	dealer_menu_open = false
	inventory_menu_open = false
	dev_mode_prompt_open = false
	menu_settings_open = false
	menu_credits_open = false
	inside_house = false
	inside_cave = false
	_sync_visual_nodes()
	_refresh_hud()
	if menu_start_button != null:
		menu_start_button.call_deferred("grab_focus")
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


func _play_menu_music(fade_in: bool = false) -> void:
	if menu_music_player == null or menu_music_stream == null:
		return
	if menu_music_player.stream != menu_music_stream:
		menu_music_player.stream = menu_music_stream
	menu_music_player.stream_paused = false
	menu_music_player.volume_db = MENU_MUSIC_CROSSFADE_START_DB if fade_in else MENU_MUSIC_VOLUME_DB
	menu_music_player.play(MENU_MUSIC_START_TIME)
	menu_music_crossfade_remaining = MENU_MUSIC_CROSSFADE_TIME if fade_in else 0.0


func _update_menu_music(delta: float) -> void:
	var should_play_menu_music: bool = phase == Phase.MENU
	if should_play_menu_music:
		if menu_music_player != null and not menu_music_player.playing:
			_play_menu_music()
	else:
		if menu_music_player != null and menu_music_player.playing:
			menu_music_player.stop()
		menu_music_visual_pulse = max(menu_music_visual_pulse - delta * 3.0, 0.0)
		menu_music_energy_smooth = 0.0
	if should_play_menu_music and menu_music_player != null and menu_music_player.playing:
		if menu_music_crossfade_remaining > 0.0:
			menu_music_crossfade_remaining = maxf(menu_music_crossfade_remaining - delta, 0.0)
			var crossfade_progress := 1.0 - menu_music_crossfade_remaining / MENU_MUSIC_CROSSFADE_TIME
			menu_music_player.volume_db = lerpf(MENU_MUSIC_CROSSFADE_START_DB, MENU_MUSIC_VOLUME_DB, crossfade_progress)
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
	if _revive_flow_holds_music():
		if cave_music_player != null and cave_music_player.playing:
			cave_music_player.stream_paused = true
		if boss_music_player != null and boss_music_player.playing:
			boss_music_player.stream_paused = true
		return
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


func _should_play_gameplay_music() -> bool:
	return (phase == Phase.BUILD or phase == Phase.DEFEND) and not inside_cave


func _update_gameplay_music() -> void:
	if gameplay_music_player == null:
		return
	if _revive_flow_holds_music():
		if gameplay_music_player.playing:
			gameplay_music_player.stream_paused = true
		_update_music_credit_panel()
		return
	if phase == Phase.MENU or phase == Phase.GAME_OVER:
		if gameplay_music_player.playing:
			gameplay_music_player.stop()
		gameplay_music_player.stream_paused = false
		_update_music_credit_panel()
		return
	if inside_cave:
		if gameplay_music_player.playing and not gameplay_music_player.stream_paused:
			gameplay_music_player.stream_paused = true
		_update_music_credit_panel()
		return
	if not _should_play_gameplay_music() or gameplay_music_streams.is_empty():
		_update_music_credit_panel()
		return
	gameplay_music_track_index = clampi(gameplay_music_track_index, 0, gameplay_music_streams.size() - 1)
	var current_stream: AudioStream = gameplay_music_streams[gameplay_music_track_index]
	if gameplay_music_player.stream != current_stream:
		gameplay_music_player.stream = current_stream
	if gameplay_music_player.stream_paused:
		gameplay_music_player.stream_paused = false
	elif not gameplay_music_player.playing:
		gameplay_music_player.volume_db = GAMEPLAY_MUSIC_VOLUME_DB
		gameplay_music_player.play()
	_update_music_credit_panel()


func _on_gameplay_music_finished() -> void:
	if gameplay_music_streams.is_empty():
		return
	gameplay_music_track_index = (gameplay_music_track_index + 1) % gameplay_music_streams.size()
	if _should_play_gameplay_music() and gameplay_music_player != null:
		gameplay_music_player.stream = gameplay_music_streams[gameplay_music_track_index]
		gameplay_music_player.stream_paused = false
		gameplay_music_player.play()
	_update_music_credit_panel()


func _update_music_credit_panel() -> void:
	if music_credit_panel == null:
		return
	var next_track_id := ""
	var next_title := ""
	var next_artist := ""
	if phase == Phase.MENU and menu_music_player != null and menu_music_player.playing:
		next_track_id = "menu"
		next_title = "Now Playing: I miss you"
		next_artist = "Music by SovieticoOfficial"
	elif inside_cave and boss_music_player != null and boss_music_player.playing:
		next_track_id = "boss"
		next_title = "Now Playing: a breakcore song"
		next_artist = "Music by SovieticoOfficial"
	elif inside_cave and cave_music_player != null and cave_music_player.playing:
		next_track_id = "cave"
		next_title = "Now Playing: Betrayal"
		next_artist = "Music by SovieticoOfficial"
	elif gameplay_music_player != null and gameplay_music_player.playing and not gameplay_music_player.stream_paused:
		var safe_track_index: int = clampi(gameplay_music_track_index, 0, GAMEPLAY_MUSIC_TITLES.size() - 1)
		next_track_id = "gameplay_%d" % safe_track_index
		next_title = "Now Playing: %s" % GAMEPLAY_MUSIC_TITLES[safe_track_index]
		next_artist = "Music by %s" % GAMEPLAY_MUSIC_ARTISTS[safe_track_index]

	if next_track_id == "":
		music_credit_track_id = ""
		music_credit_panel.visible = false
		return
	if next_track_id != music_credit_track_id:
		music_credit_track_id = next_track_id
		music_credit_hide_at = world_time + MUSIC_CREDIT_TOAST_TIME
		music_credit_title_label.text = next_title
		music_credit_body_label.text = next_artist
	var modal_open := menu_settings_open or menu_credits_open or dev_mode_prompt_open or build_menu_open or dealer_menu_open or inventory_menu_open or escape_confirm_open
	music_credit_panel.visible = world_time < music_credit_hide_at and not modal_open
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


func _music_visualizer_bands(band_count: int = 18) -> PackedFloat32Array:
	var bands := PackedFloat32Array()
	bands.resize(band_count)
	if menu_music_bus_index < 0:
		return bands
	var analyzer := AudioServer.get_bus_effect_instance(menu_music_bus_index, menu_music_spectrum_effect_index) as AudioEffectSpectrumAnalyzerInstance
	if analyzer == null:
		return bands
	for band_index in range(band_count):
		var ratio_a: float = float(band_index) / float(band_count)
		var ratio_b: float = float(band_index + 1) / float(band_count)
		var frequency_a: float = lerpf(45.0, 12000.0, ratio_a * ratio_a)
		var frequency_b: float = lerpf(45.0, 12000.0, ratio_b * ratio_b)
		var magnitude: Vector2 = analyzer.get_magnitude_for_frequency_range(frequency_a, frequency_b)
		var energy: float = maxf((magnitude.x + magnitude.y) * 0.5, 0.0)
		bands[band_index] = clampf(sqrt(energy) * 4.8, 0.025, 1.0)
	return bands


func _current_main_music_title() -> String:
	if inside_cave and boss_music_player != null and boss_music_player.playing:
		return "a breakcore song"
	if inside_cave and cave_music_player != null and cave_music_player.playing:
		return "Betrayal"
	if phase == Phase.MENU:
		return "I miss you"
	if gameplay_music_streams.is_empty() or GAMEPLAY_MUSIC_TITLES.is_empty():
		return "Playlist ready"
	var safe_track_index: int = clampi(gameplay_music_track_index, 0, mini(gameplay_music_streams.size(), GAMEPLAY_MUSIC_TITLES.size()) - 1)
	return String(GAMEPLAY_MUSIC_TITLES[safe_track_index])


func _leave_house() -> void:
	inside_house = false
	_reset_player_motion()
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_WARM_ACCENT
	player_position = _house_door_rect().position + Vector2(-PLAYER_SIZE.x * 0.5 + 10.0, 8.0)
	_refresh_hud()
	queue_redraw()


func _enter_house() -> void:
	if phase != Phase.BUILD and phase != Phase.DEFEND:
		return
	build_menu_open = false
	dealer_menu_open = false
	inside_house = true
	_reset_player_motion()
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_WARM_ACCENT
	interior_player_position = _house_interior_spawn_position()
	_refresh_hud()
	queue_redraw()


func _process(delta: float) -> void:
	_update_ui_motion(delta)
	if replay_mode == ReplayMode.PLAYBACK:
		if replay_playback_paused:
			return
		replay_playback_accumulator += delta * replay_playback_speed
		var processed_steps := 0
		var max_playback_steps := 1 if replay_seek_in_progress else 16
		while replay_tape.has_next_frame() and processed_steps < max_playback_steps:
			var preview: Dictionary = replay_tape.peek_frame()
			var recorded_delta := float(preview.get("delta", 0.0))
			if not replay_seek_in_progress and replay_playback_accumulator + 0.0000001 < recorded_delta:
				break
			var playback_frame: Dictionary = replay_tape.next_frame()
			if not replay_seek_in_progress:
				replay_playback_accumulator = maxf(replay_playback_accumulator - recorded_delta, 0.0)
			replay_frame_index = int(playback_frame["tick"])
			for event_data in playback_frame.get("events", []):
				_replay_deliver_input_event(event_data)
				if replay_diverged:
					replay_mode = ReplayMode.OFF
					return
			var expected_checkpoint: Dictionary = playback_frame.get("checkpoint", {})
			if not String(expected_checkpoint.get("state_hash", "")).is_empty() and String(expected_checkpoint.get("state_hash", "")) != get_replay_state_hash():
				replay_diverged = true
				replay_divergence_tick = replay_frame_index
				printerr("REPLAY_DIVERGED tick=", replay_frame_index, " expected_groups=", expected_checkpoint.get("groups", {}), " actual_groups=", _get_replay_state_group_hashes(), " expected_player=", expected_checkpoint.get("player", []), " actual_player=", _replay_json_safe([player_hp, player_position, player_move_velocity, player_stride_clock, player_attack_cooldown, player_swing_timer, player_aim_direction]), " expected_input=", playback_frame.get("held", []), " strengths=", playback_frame.get("strengths", {}))
				replay_mode = ReplayMode.OFF
				return
			_process_game_step(recorded_delta)
			processed_steps += 1
		return
	elif replay_mode == ReplayMode.RECORD:
		var replay_inputs := _capture_replay_inputs()
		var checkpoint := {}
		if replay_frame_index % REPLAY_HASH_INTERVAL == 0:
			checkpoint = {"state_hash": get_replay_state_hash()}
		var pending_events := replay_pending_events.duplicate(true)
		replay_pending_events.clear()
		if not replay_recording_error.is_empty():
			replay_mode = ReplayMode.OFF
			return
		if not replay_tape.record_frame(replay_frame_index, replay_inputs["held"], checkpoint, replay_inputs["strengths"], delta, pending_events):
			replay_recording_error = "Recording stopped: replay size or frame limits reached."
			replay_mode = ReplayMode.OFF
			return
		replay_frame_index += 1
	_process_game_step(delta)


func _process_game_step(delta: float) -> void:
	if team_intro_active:
		_update_team_intro(delta)
		return
	if hit_stop_timer > 0.0 and (phase == Phase.BUILD or phase == Phase.DEFEND):
		hit_stop_timer = maxf(hit_stop_timer - delta, 0.0)
		delta *= 0.08
	if dev_mode_enabled and (phase == Phase.BUILD or phase == Phase.DEFEND):
		delta *= clampf(dev_speed_percent / 100.0, 0.25, 4.0)
	world_time += delta
	phase_transition_timer = maxf(phase_transition_timer - delta, 0.0)
	_update_menu_music(delta)
	_update_cave_music()
	_update_gameplay_music()
	if phase == Phase.BUILD or phase == Phase.DEFEND:
		run_elapsed_time += delta
	if phase == Phase.MENU:
		_sync_visual_nodes()
		if dev_mode_prompt_open or menu_settings_open or menu_credits_open:
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
		_update_revive_offer(delta)
		if revive_offer_pending or revive_offer_visible or ad_in_progress:
			_refresh_hud()
			queue_redraw()
			return
		if dev_mode_prompt_open or menu_settings_open or menu_credits_open:
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

	if inventory_menu_open:
		_sync_visual_nodes()
		_refresh_hud()
		queue_redraw()
		return

	_sanitize_location_state()

	run_start_input_lock_timer = max(run_start_input_lock_timer - delta, 0.0)

	_update_house_toggle()
	if dealer_menu_open:
		_update_dealer_controller_input()
		_update_player_combat_state(delta)
		_update_gather_effects(delta)
		_update_explosion_effects(delta)
		_update_motion_effects(delta)
		if phase == Phase.BUILD:
			countdown = maxf(countdown - delta, 0.0)
			if countdown <= 0.0:
				dealer_menu_open = false
				_start_defend_phase()
		_sync_visual_nodes()
		_refresh_hud()
		queue_redraw()
		return
	_move_player(delta)
	_update_selected_cell()
	_update_player_combat_state(delta)
	_update_gathering(delta)
	_update_gather_effects(delta)
	_update_explosion_effects(delta)
	_update_motion_effects(delta)
	_update_forest_animals(delta)

	if phase == Phase.BUILD:
		_update_build_phase(delta)
	else:
		_update_defend_phase(delta)

	_update_camera()
	_apply_camera_shake(delta)
	_sync_visual_nodes()
	_refresh_hud()
	queue_redraw()


func _sanitize_location_state() -> void:
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
		player_shield_sprite = player_visual_node.get_node("Shield")
		player_sword_sprite = player_visual_node.get_node("Sword")
	if dealer_visual_node == null:
		dealer_visual_node = DEALER_VISUAL_SCENE.instantiate()
		visual_layer.add_child(dealer_visual_node)
		dealer_visual_sprite = dealer_visual_node.get_node("Dealer")
	_configure_sprite_region(player_visual_sprite, player_body_texture, PLAYER_BODY_REGION, PLAYER_DRAW_SIZE, PLAYER_DRAW_OFFSET, false)
	_configure_sprite_region(dealer_visual_sprite, arms_dealer_texture, ARMS_DEALER_REGION, ARMS_DEALER_DRAW_SIZE, Vector2(-6, -72), false)
	_sync_visual_nodes()


func _sync_visual_nodes() -> void:
	if visual_layer != null:
		# Full-screen custom-drawn menus are rendered by the parent CanvasItem.
		# Hide sprite children while those menus are open so characters cannot
		# render over cards, labels, or previews.
		visual_layer.visible = not (phase == Phase.MENU or phase == Phase.GAME_OVER or build_menu_open or dealer_menu_open or inventory_menu_open)
	_sync_player_visual()
	_sync_dealer_visual()
	_sync_turret_visuals()
	_sync_enemy_visuals()


func _sync_player_visual() -> void:
	if player_visual_node == null or player_visual_sprite == null:
		return
	var visible_world: bool = (phase == Phase.BUILD or phase == Phase.DEFEND) and not dealer_menu_open
	player_visual_node.visible = visible_world
	if not visible_world:
		return
	var raw_move_input: Vector2 = _replay_get_vector("move_left", "move_right", "move_up", "move_down")
	var move_input: Vector2 = player_move_velocity.normalized() if player_move_velocity.length_squared() > 1.0 else raw_move_input
	var base_position: Vector2 = player_position - camera_position
	if inside_cave:
		base_position = cave_player_position
	elif inside_house:
		base_position = interior_player_position
	var expected_speed: float = PLAYER_SPEED * (ENERGY_DRINK_SPEED_MULTIPLIER if energy_drink_timer > 0.0 else 1.0)
	var moving_amount: float = clampf(player_move_velocity.length() / maxf(expected_speed, 1.0), 0.0, 1.0)
	if moving_amount <= 0.01 and raw_move_input.length_squared() > 0.01:
		moving_amount = 0.18
	var stride_phase: float = player_stride_clock
	var stride_wave: float = sin(stride_phase)
	var bob_amount: float = absf(sin(stride_phase)) * 2.4 * moving_amount
	var visual_scale := Vector2(
		1.0 + stride_wave * 0.025 * moving_amount,
		1.0 - stride_wave * 0.018 * moving_amount
	)
	var visual_rotation: float = -move_input.x * 0.028 * moving_amount
	if player_skid_timer > 0.0:
		var skid_ratio: float = player_skid_timer / PLAYER_SKID_TIME
		visual_rotation += move_input.x * 0.055 * skid_ratio
		visual_scale *= Vector2(1.035, 0.975)
	if player_step_impact > 0.0:
		visual_scale *= Vector2(1.0 + player_step_impact * 0.035, 1.0 - player_step_impact * 0.025)
	if moving_amount <= 0.12:
		var breathe: float = sin(world_time * 2.25) * 0.018
		visual_scale = Vector2(1.0 - breathe * 0.35, 1.0 + breathe)
	if player_swing_timer > 0.0:
		var swing_progress: float = clampf(1.0 - player_swing_timer / PLAYER_SWORD_SWING_TIME, 0.0, 1.0)
		var strike_punch: float = sin(swing_progress * PI)
		visual_scale *= Vector2(1.0 + strike_punch * 0.075, 1.0 - strike_punch * 0.045)
		visual_rotation += player_swing_direction.x * strike_punch * 0.075
		base_position += player_swing_direction * strike_punch * 4.0
	if player_gun_kick_timer > 0.0:
		var gun_kick: float = clampf(player_gun_kick_timer / 0.14, 0.0, 1.0)
		base_position -= player_aim_direction * gun_kick * 3.5
		visual_rotation -= player_aim_direction.y * gun_kick * 0.045
		visual_scale *= Vector2(1.0 + gun_kick * 0.045, 1.0 - gun_kick * 0.025)
	if _parry_active():
		var brace_pulse: float = sin((PLAYER_PARRY_WINDOW - parry_timer) / PLAYER_PARRY_WINDOW * PI)
		visual_scale *= Vector2(1.08 - brace_pulse * 0.03, 0.94 + brace_pulse * 0.03)
	player_visual_node.position = base_position + Vector2(0.0, -bob_amount)
	player_visual_node.scale = visual_scale
	player_visual_node.rotation = visual_rotation
	var run_texture: Texture2D = _current_player_run_texture() if moving_amount > 0.12 else null
	if move_input.x < -0.05:
		player_facing_left = true
	elif move_input.x > 0.05:
		player_facing_left = false
	elif player_swing_timer > 0.0 and absf(player_swing_direction.x) > 0.05:
		player_facing_left = player_swing_direction.x < 0.0
	if run_texture != null:
		# Runtime run frames are already cropped to the character. Applying the
		# source-sheet region here samples outside the 92x184 image and hides Bob.
		_configure_sprite(player_visual_sprite, run_texture, PLAYER_RUN_DRAW_SIZE, PLAYER_RUN_DRAW_OFFSET, false)
		# The cleaned run frames are authored facing left.
		player_visual_sprite.flip_h = not player_facing_left
	else:
		var idle_texture: Texture2D = _current_player_idle_texture(player_facing_left)
		if idle_texture != null:
			_configure_sprite(player_visual_sprite, idle_texture, PLAYER_IDLE_DRAW_SIZE, PLAYER_IDLE_DRAW_OFFSET, false)
			player_visual_sprite.flip_h = false
		else:
			_configure_sprite_region(player_visual_sprite, player_body_texture, PLAYER_BODY_REGION, PLAYER_DRAW_SIZE, PLAYER_DRAW_OFFSET, false)
			player_visual_sprite.flip_h = player_facing_left
	_sync_player_equipment_visuals()


func _sync_player_equipment_visuals() -> void:
	if player_shield_sprite == null or player_sword_sprite == null:
		return
	var facing_left: bool = player_facing_left
	var parrying: bool = _parry_active()
	var shield_texture: Texture2D = null
	if facing_left:
		shield_texture = shield_left_block_texture if parrying else shield_left_idle_texture
	else:
		shield_texture = shield_right_block_texture if parrying else shield_right_idle_texture
	player_shield_sprite.visible = shield_unlocked and shield_texture != null
	if player_shield_sprite.visible:
		var shield_size: Vector2 = PLAYER_SHIELD_BLOCK_DRAW_SIZE if parrying else PLAYER_SHIELD_DRAW_SIZE
		var shield_x: float = 23.0 if facing_left else 3.0
		if parrying:
			shield_x += 6.0 if facing_left else -6.0
		_configure_sprite(player_shield_sprite, shield_texture, shield_size, Vector2(shield_x, -13), true)
		player_shield_sprite.rotation = 0.0
		player_shield_sprite.flip_h = false

	player_sword_sprite.visible = player_swing_timer > 0.0 and player_sword_texture != null
	if not player_sword_sprite.visible:
		return
	var swing_phase: float = clampf(1.0 - player_swing_timer / PLAYER_SWORD_SWING_TIME, 0.0, 1.0)
	var eased_phase: float = 1.0 - pow(1.0 - swing_phase, 3.0)
	var swing_dir: Vector2 = player_swing_direction.normalized() if player_swing_direction != Vector2.ZERO else Vector2.RIGHT
	var sweep_normal: Vector2 = Vector2(-swing_dir.y, swing_dir.x)
	var handedness: float = -1.0 if swing_dir.x < 0.0 else 1.0
	if absf(swing_dir.x) < 0.14:
		handedness = -1.0 if swing_dir.y < 0.0 else 1.0
	var hand_anchor := Vector2(13, 9) + swing_dir * 6.0 + sweep_normal * 7.0 * handedness
	var strike_angle: float = swing_dir.angle() + lerpf(-2.15, 0.82, eased_phase)
	var reach_length: float = 8.0 + sin(swing_phase * PI) * 5.0
	var sword_position: Vector2 = hand_anchor + Vector2.RIGHT.rotated(strike_angle - 0.52 * handedness) * reach_length
	sword_position += sweep_normal * lerpf(-4.0 * handedness, 5.0 * handedness, eased_phase)
	_configure_sprite(player_sword_sprite, player_sword_texture, PLAYER_SWORD_DRAW_SIZE, sword_position, true)
	player_sword_sprite.offset = Vector2(0, -player_sword_texture.get_height() * 0.5)
	player_sword_sprite.rotation = strike_angle + PI * 0.5
	player_sword_sprite.flip_h = false


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
		var completion_pop: float = float(structure.get("completion_pop", 0.0))
		var pop_progress: float = clampf(1.0 - completion_pop / 0.34, 0.0, 1.0)
		var pop_scale: float = 1.0
		if completion_pop > 0.0:
			pop_scale = 0.72 + pop_progress * 0.28 + sin(pop_progress * PI) * 0.18
		turret_visual.scale = Vector2.ONE * pop_scale
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
	var base_sprite: Sprite2D = turret_visual.get_node("Base")
	var flash: bool = float(structure.get("flash_timer", 0.0)) > 0.0
	var visual_aim_angle: float = float(structure.get("visual_aim_angle", Vector2(structure.get("aim_direction", Vector2.RIGHT)).angle()))
	var aim_direction: Vector2 = Vector2.RIGHT.rotated(visual_aim_angle)
	if aim_direction == Vector2.ZERO:
		aim_direction = Vector2.RIGHT
	var aim_angle: float = aim_direction.angle()
	var reload_progress: float = _turret_reload_progress(structure)
	var recoil_strength: float = _turret_recoil_strength(structure)
	var recoil_offset: Vector2 = -aim_direction * recoil_strength * 7.0
	body_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	body_sprite.flip_h = false
	body_sprite.visible = true
	body_sprite.rotation = 0.0
	body_sprite.offset = Vector2.ZERO
	base_sprite.visible = false
	base_sprite.rotation = 0.0
	base_sprite.flip_h = false
	base_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var weapon: String = String(structure.get("weapon", "arrow"))
	match weapon:
		"cannon":
			var cannon_facing_left: bool = aim_direction.x < -0.08
			var cannon_recoil := Vector2(10.0 if cannon_facing_left else -10.0, 0.0) * recoil_strength
			_configure_sprite_region(body_sprite, cannon_turret_texture, CANNON_TURRET_REGION, CANNON_TURRET_DRAW_SIZE, Vector2(0, -10), true)
			body_sprite.position += cannon_recoil
			body_sprite.rotation = 0.0
			body_sprite.flip_h = cannon_facing_left
		"gun":
			if gun_sentry_top_texture != null and gun_sentry_bottom_texture != null:
				_configure_sprite(base_sprite, gun_sentry_bottom_texture, GUN_TURRET_BASE_DRAW_SIZE, Vector2(0, 8), true)
				_configure_sprite(body_sprite, gun_sentry_top_texture, GUN_TURRET_TOP_DRAW_SIZE, Vector2(0, -3), true)
				body_sprite.offset = Vector2(0, -gun_sentry_top_texture.get_height() * 0.5)
			elif gun_turret_texture != null:
				_configure_sprite(body_sprite, gun_turret_texture, Vector2(98, 98), Vector2(0, -4), true)
			elif irs_agent_gun_texture != null:
				_configure_sprite(body_sprite, irs_agent_gun_texture, Vector2(56, 24), Vector2(0, 4), true)
			else:
				_configure_sprite_region(body_sprite, turret_sprite_texture, TURRET_LOADED_REGION, Vector2(60, 34), Vector2.ZERO, true)
			body_sprite.position += recoil_offset
			body_sprite.rotation = aim_angle
		"magic":
			if majestic_sentry_top_texture != null and majestic_sentry_bottom_texture != null:
				_configure_sprite(base_sprite, majestic_sentry_bottom_texture, MAGIC_TURRET_BASE_DRAW_SIZE, Vector2(0, 12), true)
				_configure_sprite(body_sprite, majestic_sentry_top_texture, MAGIC_TURRET_TOP_DRAW_SIZE, Vector2(0, -16), true)
			else:
				_configure_sprite(body_sprite, crystal_sentry_texture, MAGIC_TURRET_DRAW_SIZE, Vector2(0, -MAGIC_TURRET_DRAW_SIZE.y * 0.18), true)
			body_sprite.position += recoil_offset + Vector2(0, sin(world_time * 3.0 + turret_visual.position.x * 0.02) * 2.0)
			body_sprite.rotation = aim_angle
		"golden":
			var golden_facing_left: bool = aim_direction.x < -0.08
			var golden_recoil := Vector2(7.0 if golden_facing_left else -7.0, 0.0) * recoil_strength
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
		body_sprite.modulate = Color(1.48, 1.34, 1.10, 1.0)
		base_sprite.modulate = Color(1.34, 1.24, 1.08, 1.0)


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
		var lane_direction: float = 1.0 if String(enemy.get("lane", "left")) == "left" else -1.0
		var motion_phase: float = world_time * (11.5 if String(enemy.get("type", "runner")) == "runner" else 8.0) + float(enemy_id) * 1.37
		var stride_bob: float = absf(sin(motion_phase)) * 2.6
		var stride_squash: float = sin(motion_phase) * 0.035
		var windup_ratio: float = clampf(float(enemy.get("attack_windup", 0.0)) / maxf(0.01, ENEMY_ATTACK_WINDUP), 0.0, 1.0)
		var windup_progress: float = 1.0 - windup_ratio
		var attack_lean: float = sin(windup_progress * PI)
		var spawn_anim: float = float(enemy.get("spawn_anim", 0.0))
		var spawn_progress: float = clampf(1.0 - spawn_anim / 0.28, 0.0, 1.0)
		var spawn_scale: float = 1.0 if spawn_anim <= 0.0 else 0.56 + spawn_progress * 0.44 + sin(spawn_progress * PI) * 0.16
		enemy_visual.position = _enemy_center(enemy) - camera_position + Vector2(-lane_direction * attack_lean * 5.0, -stride_bob * (1.0 - windup_ratio))
		enemy_visual.scale = Vector2((1.0 + stride_squash - attack_lean * 0.05) * spawn_scale, (1.0 - stride_squash + attack_lean * 0.08) * spawn_scale)
		enemy_visual.rotation = lane_direction * (-0.028 + attack_lean * 0.075)
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
		var run_texture: Texture2D = _current_runner_texture(float(enemy.get("anim_phase", 0.0)))
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
		_configure_sprite_region(body_sprite, _current_robot_walk_texture(float(enemy.get("anim_phase", 0.0))), IRS_ROBOT_WALK_REGION, robot_size, Vector2.ZERO, true)
		body_sprite.flip_h = false
		body_sprite.rotation = 0.0
		gun_sprite.visible = false
	if flash:
		body_sprite.modulate = Color(1.58, 1.28, 1.22, 1.0)
		gun_sprite.modulate = Color(1.58, 1.34, 1.18, 1.0)


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
	sprite.offset = Vector2.ZERO
	var texture_size := texture.get_size()
	var has_region: bool = region.size.x > 0.0 and region.size.y > 0.0
	var region_in_bounds: bool = (
		region.position.x >= 0.0
		and region.position.y >= 0.0
		and region.end.x <= texture_size.x
		and region.end.y <= texture_size.y
	)
	# An invalid source-sheet crop makes Sprite2D sample transparent pixels.
	# Falling back to the whole image keeps a bad asset contract visible and
	# debuggable instead of making the character disappear entirely.
	var use_region: bool = has_region and region_in_bounds
	sprite.region_enabled = use_region
	if use_region:
		sprite.region_rect = region
	var source_size: Vector2 = region.size if use_region else texture.get_size()
	source_size.x = max(source_size.x, 1.0)
	source_size.y = max(source_size.y, 1.0)
	sprite.scale = Vector2(draw_size.x / source_size.x, draw_size.y / source_size.y)


func _menu_start_pressed() -> bool:
	return (
		_replay_action_just_pressed("restart")
		or _replay_action_just_pressed("start_wave_early")
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


func _on_menu_settings_pressed() -> void:
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	menu_settings_open = not menu_settings_open
	if menu_settings_open:
		menu_credits_open = false
		dev_mode_prompt_open = false
		_close_dev_mode_prompt()
	_refresh_hud()
	if menu_settings_open and menu_effects_button != null:
		menu_effects_button.call_deferred("grab_focus")
	elif menu_start_button != null:
		menu_start_button.call_deferred("grab_focus")


func _on_menu_tutorial_pressed() -> void:
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	tutorial_enabled = not tutorial_enabled
	_save_persistent_settings()
	_refresh_hud()


func _on_menu_credits_pressed() -> void:
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	menu_credits_open = not menu_credits_open
	if menu_credits_open:
		menu_settings_open = false
		_close_dev_mode_prompt()
	_refresh_hud()
	if menu_credits_open and menu_credits_back_button != null:
		menu_credits_back_button.call_deferred("grab_focus")
	elif menu_start_button != null:
		menu_start_button.call_deferred("grab_focus")


func _close_menu_credits() -> void:
	menu_credits_open = false
	_refresh_hud()
	if menu_start_button != null:
		menu_start_button.call_deferred("grab_focus")


func _on_menu_dev_pressed() -> void:
	if phase != Phase.MENU and phase != Phase.GAME_OVER:
		return
	menu_settings_open = false
	menu_credits_open = false
	if dev_mode_enabled:
		dev_mode_enabled = false
		if leaderboard_host != null:
			leaderboard_host.set_dev_mode_active(false)
		dev_mode_prompt_open = false
		_close_dev_mode_prompt()
		_refresh_settings_buttons()
		_refresh_hud()
		return
	dev_mode_prompt_open = true
	menu_dev_pin_input.text = ""
	menu_dev_status_label.text = "Protected team tools"
	menu_dev_pin_input.grab_focus()


func _on_menu_dev_unlock_pressed() -> void:
	if menu_dev_pin_input.text == DEV_MODE_PIN:
		dev_mode_enabled = true
		if leaderboard_host != null:
			leaderboard_host.set_dev_mode_active(true)
		dev_mode_prompt_open = false
		menu_dev_status_label.text = "Dev mode unlocked"
		_refresh_settings_buttons()
		_refresh_hud()
	else:
		menu_dev_status_label.text = "Wrong PIN"
		menu_dev_pin_input.text = ""
		menu_dev_pin_input.grab_focus()


func _close_dev_mode_prompt() -> void:
	dev_mode_prompt_open = false
	if menu_dev_pin_input != null:
		menu_dev_pin_input.text = ""
	if menu_dev_status_label != null:
		menu_dev_status_label.text = "Protected team tools"


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
	# The screen fill, ground tiles, waving grass and build grid moved to
	# $GroundLayer, which renders beneath this canvas item. That opens the
	# z-index band $WorldSpriteLayer uses for real sprite nodes, so world art can
	# become a Sprite2D without covering the effects and HUD drawn below.
	if phase == Phase.MENU and menu_background_texture != null:
		_draw_menu_background(true)
	elif phase == Phase.GAME_OVER:
		_draw_game_over_background()
	if phase == Phase.MENU or phase == Phase.GAME_OVER:
		_draw_menu_handmade_frame()
		_draw_scene_transition()
		_draw_replay_controls()
		return
	_draw_house()
	_draw_dealer_stand()
	_draw_resources()
	_draw_forest_animals()
	_draw_trees()
	_draw_structures()
	_draw_enemies()
	_draw_enemy_shots()
	_draw_projectiles()
	_draw_player()
	_draw_selection()
	_draw_world_callouts()
	_draw_side_spawn_warnings()
	_draw_gather_effects()
	_draw_wave_banner()
	_draw_inventory_full_warning()
	_draw_energy_drink_status()
	_draw_house_prompt()
	_draw_dealer_prompt()
	_draw_cave_prompt()
	_draw_house_interior()
	_draw_cave_interior()
	_draw_explosion_effects()
	_draw_motion_effects()
	_draw_danger_overlay()
	_draw_hit_effects()
	_draw_countdown_display()
	_draw_tutorial_panel()
	_draw_ui_stamps(false)
	_draw_paper_panels()
	_draw_scene_transition()
	_draw_iris_open()
	_draw_replay_controls()


func _draw_replay_controls() -> void:
	if replay_mode != ReplayMode.PLAYBACK:
		return
	var status := "REPLAY  %s  %.2fx     Space: pause  ←/→: seek  +/-: speed  Esc: exit" % ["PAUSED" if replay_playback_paused else "PLAYING", replay_playback_speed]
	var bar := Rect2(Vector2(12, 12), Vector2(710, 30))
	draw_rect(bar, Color(0.03, 0.05, 0.08, 0.88), true)
	draw_rect(bar, Color(0.96, 0.82, 0.44, 0.55), false, 1.0)
	draw_string(ThemeDB.fallback_font, bar.position + Vector2(10, 21), status, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14, UI_WARM_ACCENT)


func _draw_menu_background(react_to_music: bool) -> void:
	var draw_rect: Rect2 = Rect2(Vector2.ZERO, SCREEN_SIZE)
	var overlay_alpha: float = 0.18
	var active_background: Texture2D = menu_background_texture
	var next_background: Texture2D = null
	var frame_blend: float = 0.0
	if not menu_background_frames.is_empty():
		var frame_position: float = fposmod(world_time * MENU_BACKGROUND_FRAME_RATE, float(menu_background_frames.size()))
		var frame_index := int(floor(frame_position))
		var next_frame_index := (frame_index + 1) % menu_background_frames.size()
		active_background = menu_background_frames[frame_index]
		next_background = menu_background_frames[next_frame_index]
		var linear_blend: float = frame_position - floor(frame_position)
		# Smootherstep keeps the authored cels crisp at each key pose while
		# producing fluid in-betweens at the display refresh rate.
		frame_blend = linear_blend * linear_blend * linear_blend * (linear_blend * (linear_blend * 6.0 - 15.0) + 10.0)
	if react_to_music:
		var beat_pulse: float = menu_music_visual_pulse
		var zoom_scale: float = 1.0 + beat_pulse * MENU_BACKGROUND_BEAT_ZOOM
		var scaled_size: Vector2 = SCREEN_SIZE * zoom_scale
		var parallax_offset := Vector2.ZERO
		if menu_motion_enabled:
			var mouse_ratio: Vector2 = _replay_get_mouse_position() / SCREEN_SIZE - Vector2(0.5, 0.5)
			if _using_controller_prompts():
				mouse_ratio = Vector2(sin(world_time * 0.37), cos(world_time * 0.29)) * 0.32
			parallax_offset = -mouse_ratio * MENU_BACKGROUND_PARALLAX
		draw_rect = Rect2((SCREEN_SIZE - scaled_size) * 0.5 + parallax_offset, scaled_size)
		overlay_alpha = 0.16 + beat_pulse * 0.12
	if active_background != null:
		draw_texture_rect_region(active_background, draw_rect, MENU_BACKGROUND_REGION)
	if next_background != null and frame_blend > 0.001:
		draw_texture_rect_region(next_background, draw_rect, MENU_BACKGROUND_REGION, Color(1.0, 1.0, 1.0, frame_blend))
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.02, 0.04, 0.06, overlay_alpha), true)


func _draw_menu_handmade_frame() -> void:
	var rect := Rect2(Vector2(164, 86), Vector2(952, 548))
	var pulse: float = 0.5 + 0.5 * sin(world_time * 1.7)
	var ink := Color(0.98, 0.84, 0.44, 0.42 + pulse * 0.08)
	var rough_outline := PackedVector2Array([
		rect.position + Vector2(-3, 5),
		Vector2(rect.end.x + 4, rect.position.y - 2),
		rect.end + Vector2(1, 4),
		Vector2(rect.position.x - 4, rect.end.y - 2),
		rect.position + Vector2(-3, 5)
	])
	draw_polyline(rough_outline, Color(0.01, 0.01, 0.01, 0.58), 8.0, true)
	draw_polyline(rough_outline, ink, 2.5, true)
	draw_line(rect.position + Vector2(18, 14), rect.position + Vector2(92, 8), Color(0.96, 0.82, 0.52, 0.30), 13.0, true)
	draw_line(rect.end - Vector2(94, 10), rect.end - Vector2(20, 16), Color(0.96, 0.82, 0.52, 0.30), 13.0, true)


func _draw_game_over_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.045, 0.04, 0.05), true)
	if loss_screen_texture != null:
		# Player pick: the team's death art stays large and undimmed above the receipt.
		if loss_screen_used_rect.size == Vector2.ZERO:
			var loss_image := loss_screen_texture.get_image()
			loss_screen_used_rect = Rect2(loss_image.get_used_rect()) if loss_image != null else Rect2(Vector2.ZERO, loss_screen_texture.get_size())
		var art_size := loss_screen_used_rect.size
		var art_width: float = 860.0
		var art_height: float = art_width * art_size.y / maxf(art_size.x, 1.0)
		var art_rect := Rect2(Vector2((SCREEN_SIZE.x - art_width) * 0.5, 104.0), Vector2(art_width, art_height))
		draw_texture_rect_region(loss_screen_texture, art_rect, loss_screen_used_rect)
	elif menu_background_texture != null:
		_draw_menu_background(false)
	_draw_game_over_receipt()


func _game_over_receipt_lines() -> Array:
	var run_minutes := int(floor(run_elapsed_time / 60.0))
	var run_seconds := int(floor(run_elapsed_time)) % 60
	return [
		["Taxpayer", "Bob"],
		["Rounds survived", str(maxi(round_number - 1, 0))],
		["Agents defeated", str(run_enemies_defeated)],
		["Best round ever", str(highest_round)],
		["Resources gathered", str(run_resources_gathered)],
		["Defenses built", str(run_structures_built)],
		["Repairs", str(run_repairs_completed)],
		["Cave rooms", str(cave_seen_rooms.size())],
		["Boss", "defeated" if cave_boss_defeated else "collecting interest"],
		["Run time", "%d:%02d" % [run_minutes, run_seconds]],
		["Air fryer", "SEIZED"],
	]


func _draw_game_over_receipt() -> void:
	var font := ThemeDB.fallback_font
	var receipt := Rect2(Vector2(672, 292), Vector2(410, 330))
	draw_set_transform(receipt.get_center(), 0.022, Vector2.ONE)
	var local := Rect2(-receipt.size * 0.5, receipt.size)
	draw_rect(Rect2(local.position + Vector2(5, 7), local.size), Color(0, 0, 0, 0.5), true)
	draw_rect(local, UI_PAPER_FILL, true)
	var line_y := local.position.y + 54.0
	while line_y < local.end.y - 8.0:
		draw_line(Vector2(local.position.x + 10, line_y), Vector2(local.end.x - 10, line_y), Color(0.72, 0.64, 0.48, 0.45), 1.0)
		line_y += 22.0
	draw_string(font, local.position + Vector2(18, 32), "IRS NOTICE OF SEIZURE", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, UI_PAPER_INK)
	var row_y := local.position.y + 70.0
	for row in _game_over_receipt_lines():
		draw_string(font, Vector2(local.position.x + 18, row_y), String(row[0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, UI_PAPER_INK)
		draw_string(font, Vector2(local.position.x + 18, row_y), String(row[1]), HORIZONTAL_ALIGNMENT_RIGHT, local.size.x - 36.0, 14, UI_STAMP_RED if String(row[1]) == "SEIZED" else UI_PAPER_INK)
		row_y += 20.0
	var taunt := game_over_taunt if game_over_taunt != "" else String(IRS_DEFEAT_TAUNTS[0])
	draw_multiline_string(font, Vector2(local.position.x + 18, row_y + 6.0), taunt, HORIZONTAL_ALIGNMENT_LEFT, local.size.x - 36.0, 13, 2, Color(UI_PAPER_INK, 0.78))
	draw_set_transform(receipt.get_center() + Vector2(150, -148), 0.22, Vector2.ONE * 0.78)
	var stamp := Rect2(Vector2(-92, -22), Vector2(184, 44))
	draw_rect(stamp, Color(UI_STAMP_RED, 0.12), true)
	draw_rect(stamp, Color(UI_STAMP_RED, 0.9), false, 3.0)
	draw_string(font, Vector2(-92, 8), "ASSET SEIZED", HORIZONTAL_ALIGNMENT_CENTER, 184, 22, Color(UI_STAMP_RED, 0.95))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _layout_game_over_home(show_dev: bool) -> void:
	var y := 236.0
	menu_start_button.position = Vector2(92, y)
	y += 70.0
	menu_settings_button.position = Vector2(92, y)
	y += 74.0
	if show_dev:
		menu_dev_button.position = Vector2(111, y)
		menu_dev_button.size = Vector2(262, 55)
		menu_dev_button.pivot_offset = menu_dev_button.size * 0.5
		y += 72.0
	menu_tutorial_button.position = Vector2(112, y + 6.0)
	menu_tutorial_button.size = Vector2(260, 44)


func _start_new_game() -> void:
	if replay_mode == ReplayMode.OFF:
		replay_run_seed = int(Time.get_ticks_usec() % 9007199254740991)
		replay_tape = load("res://scripts/replay/replay_tape.gd").new()
		replay_tape.begin(REPLAY_GAME_VERSION, replay_run_seed, 60, _capture_replay_metadata())
		replay_mode = ReplayMode.RECORD
		replay_frame_index = 0
		replay_recording_error = ""
		replay_pending_events.clear()
		replay_last_run_id = _new_replay_run_id()
		replay_used_dev_mode = dev_mode_enabled
		replay_mouse_position = get_viewport().get_mouse_position() if is_inside_tree() else Vector2.ZERO
	if replay_mode == ReplayMode.PLAYBACK:
		replay_run_seed = int(replay_tape.data["seed"])
	elif replay_mode != ReplayMode.RECORD:
		replay_run_seed = int(Time.get_ticks_usec() % 9007199254740991)
	simulation_rng.seed = replay_run_seed
	menu_settings_open = false
	menu_credits_open = false
	round_number = 1
	run_elapsed_time = 0.0
	run_enemies_defeated = 0
	run_resources_gathered = 0
	run_structures_built = 0
	run_repairs_completed = 0
	wood = 0
	stone = 0
	iron = 0
	gold = 0
	gunpowder = 0
	cave_crystals_owned = 0
	player_hp = PLAYER_MAX_HP
	player_position = _cell_to_world(PLAYER_START_CELL) + Vector2(11, 11)
	player_move_velocity = Vector2.ZERO
	player_stride_clock = 0.0
	player_skid_timer = 0.0
	player_step_impact = 0.0
	selected_cell = PLAYER_START_CELL
	camera_position = Vector2.ZERO
	camera_shake_strength = 0.0
	world_time = 0.0
	gameplay_music_track_index = 0
	if gameplay_music_player != null and gameplay_music_player.playing:
		gameplay_music_player.stop()
	if gameplay_music_player != null:
		gameplay_music_player.stream_paused = false
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
	player_gun_kick_timer = 0.0
	hit_stop_timer = 0.0
	player_facing_left = false
	house_flash_timer = 0.0
	wave_banner_timer = 0.0
	wave_banner_text = ""
	game_over_taunt = ""
	revive_used = false
	revive_offer_pending = false
	revive_offer_visible = false
	revive_offer_delay = 0.0
	revive_offer_countdown = 0.0
	ad_in_progress = false
	if revive_offer_panel != null:
		revive_offer_panel.visible = false
	wave_banner_duration = WAVE_BANNER_TIME
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_WARM_ACCENT
	_start_iris_open()
	player_step_effect_timer = 0.0
	run_start_input_lock_timer = 0.25
	build_menu_open = false
	selected_sentry_kind = "arrow"
	build_menu_tab = "sentries"
	dealer_menu_open = false
	dealer_page = "buy"
	dealer_status_text = "The arms dealer trades in dollars."
	energy_drink_timer = 0.0
	gun_sentry_unlocked = persistent_gun_sentry_unlocked
	magic_sentry_unlocked = persistent_magic_sentry_unlocked
	golden_sentry_unlocked = persistent_golden_sentry_unlocked
	rifle_sentry_unlocked = false
	shield_unlocked = persistent_shield_unlocked
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
	tutorial_moved = false
	tutorial_visible = tutorial_enabled
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
	enemy_cluster_counts.clear()
	enemy_cluster_cache_timer = 0.0
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
	motion_effects.clear()
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
		if _replay_action_just_pressed("dealer_menu"):
			dealer_menu_open = false
		if _replay_action_just_pressed("enter_cave") and _is_player_near_cave_exit():
			_leave_cave()
		elif _replay_action_just_pressed("enter_cave") and _is_boss_encounter_locked():
			_show_wave_banner_for("Arena Sealed\nBeat The Broodmother", 1.1)
		return
	if inside_house:
		if _replay_action_just_pressed("enter_cave") and _is_player_near_house_exit():
			_leave_house()
		return
	if run_start_input_lock_timer > 0.0:
		return
	if build_menu_open:
		return
	if phase == Phase.BUILD and _replay_action_just_pressed("dealer_menu") and _is_player_near_dealer_stand():
		dealer_menu_open = not dealer_menu_open
		if dealer_menu_open:
			build_menu_open = false
			dealer_page = "buy"
			dealer_selected_index = 0
			tutorial_opened_dealer = true
		return
	if not _replay_action_just_pressed("enter_cave"):
		return
	if _is_player_near_house_door() and (phase == Phase.BUILD or phase == Phase.DEFEND):
		_enter_house()
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
	_reset_player_motion()
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = MAGIC_COLOR
	cave_mode_token = true
	cave_room_id = "entrance"
	cave_seen_rooms[cave_room_id] = true
	_refresh_cave_room_state()
	cave_player_position = _cave_spawn_position()
	cave_transition_cooldown = CAVE_TRANSITION_COOLDOWN


func _leave_cave() -> void:
	inside_cave = false
	_reset_player_motion()
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_COOL_ACCENT
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
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = Color(_cave_zone_palette(int(_current_cave_room().get("zone", 0)))["accent"])
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
	_reset_player_motion()
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
			var spawn_noise: float = _simulation_randf()
			var spawn_score: float = spawn_noise + center_bias * 0.24 + depth_bias * 0.12
			if spawn_score < FOREST_TREE_DENSITY:
				var stone_chance: float = FOREST_STONE_DENSITY + depth_bias * DEEP_STONE_DENSITY_BONUS
				if _simulation_randf() < stone_chance and _find_resource_node_at_cell(cell) == -1:
					resource_nodes.append(_make_resource_node(cell, "stone"))
				else:
					animal_candidates.append(cell)
				continue
			forest_tree_cells.append(cell)
			if _simulation_randf() < FOREST_RESOURCE_DENSITY + depth_bias * DEEP_RESOURCE_DENSITY_BONUS:
				_add_wood_tree_node(cell)
	_spawn_forest_animals_for_chunk(chunk_index, animal_candidates)


func _spawn_forest_animals_for_chunk(chunk_index: int, candidate_cells: Array[Vector2i]) -> void:
	if candidate_cells.is_empty():
		return
	var shuffled_cells: Array[Vector2i] = candidate_cells.duplicate()
	_simulation_shuffle(shuffled_cells)
	var spawn_count: int = mini(FOREST_ANIMALS_PER_CHUNK, shuffled_cells.size())
	for spawn_index in range(spawn_count):
		var animal_cell: Vector2i = shuffled_cells[spawn_index]
		if animal_cell.distance_to(PLAYER_START_CELL) <= 4:
			continue
		var animal_kind: String = "dog" if _simulation_randf() < 0.55 else "beaver"
		forest_animals.append(_make_forest_animal(animal_cell, animal_kind, chunk_index))


func _make_forest_animal(cell: Vector2i, animal_kind: String, chunk_index: int) -> Dictionary:
	var anchor_position: Vector2 = _cell_to_world(cell) + Vector2(CELL_SIZE * 0.5 + _simulation_randf_range(-8.0, 8.0), CELL_SIZE * 0.5 + _simulation_randf_range(-2.0, 6.0))
	return {
		"kind": animal_kind,
		"chunk": chunk_index,
		"anchor": anchor_position,
		"position": anchor_position,
		"direction": -1.0 if _simulation_randf() < 0.5 else 1.0,
		"speed": _simulation_randf_range(FOREST_ANIMAL_WANDER_SPEED_MIN, FOREST_ANIMAL_WANDER_SPEED_MAX),
		"range": _simulation_randf_range(24.0, 54.0),
		"facing_left": _simulation_randf() < 0.5,
		"bob_phase": _simulation_randf() * TAU
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
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_SUCCESS_ACCENT
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
	elif round_number == 2:
		_show_wave_banner_for("Tutorial Complete\nKeep Building, Keep Surviving", 2.8)
	elif _is_swat_round():
		_show_wave_banner_for("SWAT Prep\nRound %d" % round_number, 2.5)
	else:
		_show_wave_banner("Build Phase\nRound %d" % round_number)


func _start_defend_phase() -> void:
	if replay_mode == ReplayMode.RECORD:
		replay_tape.record_marker(replay_frame_index, "wave", {"round": round_number})
	phase = Phase.DEFEND
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_DANGER_ACCENT
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
		if round_number >= 3:
			var weak_lane: String = _weakest_defense_lane()
			var adaptive_chance: float = clampf(0.18 + float(round_number - 3) * 0.045, 0.18, 0.62)
			if _simulation_randf() < adaptive_chance:
				lane = weak_lane
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

	if _replay_action_just_pressed("build_arrow_turret"):
		_toggle_build_menu()
	elif build_menu_open:
		_update_build_menu_input()
	elif _replay_action_just_pressed("upgrade_turret"):
		_try_upgrade_turret()
	elif _replay_action_just_pressed("repair_wall"):
		if not _try_repair_wall():
			_try_repair_house()
	elif _replay_action_just_pressed("sell_structure"):
		_try_sell_structure()
	elif _replay_action_just_pressed("start_wave_early"):
		_start_defend_phase()
		return
	elif _replay_action_just_pressed("skip_build_test"):
		_start_defend_phase()
		return

	if countdown <= 0.0:
		_start_defend_phase()


func _toggle_build_menu() -> void:
	if phase != Phase.BUILD or inside_house:
		return
	build_menu_open = not build_menu_open
	if build_menu_open:
		_set_build_menu_tab("walls" if _is_wall_build(selected_sentry_kind) else "sentries")


func _update_build_menu_input() -> void:
	var hovered_weapon: String = _build_menu_weapon_at_position(_replay_get_mouse_position())
	if hovered_weapon != "":
		selected_sentry_kind = hovered_weapon
	if _replay_action_just_pressed("move_left") or _replay_action_just_pressed("move_up"):
		_cycle_sentry_selection(-1)
	elif _replay_action_just_pressed("move_right") or _replay_action_just_pressed("move_down"):
		_cycle_sentry_selection(1)
	elif _replay_action_just_pressed("action") or _replay_action_just_pressed("start_wave_early") or _replay_action_just_pressed("build_arrow_turret"):
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
	var sentry_kinds: Array[String] = _available_turret_kinds()
	sentry_kinds.append_array(_available_wall_kinds())
	return sentry_kinds


func _available_turret_kinds() -> Array[String]:
	var sentry_kinds: Array[String] = ["arrow", "cannon"]
	if gun_sentry_unlocked:
		sentry_kinds.append("gun")
	if golden_sentry_unlocked:
		sentry_kinds.append("golden")
	if magic_sentry_unlocked:
		sentry_kinds.append("magic")
	return sentry_kinds


func _available_wall_kinds() -> Array[String]:
	return ["wall_light", "wall_medium", "wall_heavy"]


func _build_menu_items() -> Array[String]:
	return _available_wall_kinds() if build_menu_tab == "walls" else _available_turret_kinds()


func _is_wall_build(build_kind: String) -> bool:
	return build_kind == "wall_light" or build_kind == "wall_medium" or build_kind == "wall_heavy"


func _set_build_menu_tab(tab_name: String) -> void:
	build_menu_tab = "walls" if tab_name == "walls" else "sentries"
	var tab_items: Array[String] = _build_menu_items()
	if not selected_sentry_kind in tab_items and not tab_items.is_empty():
		selected_sentry_kind = tab_items[0]


func _cycle_sentry_selection(direction: int) -> void:
	var sentry_kinds: Array[String] = _build_menu_items()
	if sentry_kinds.is_empty():
		return
	var current_index: int = maxi(sentry_kinds.find(selected_sentry_kind), 0)
	selected_sentry_kind = sentry_kinds[posmod(current_index + direction, sentry_kinds.size())]


func _update_defend_phase(delta: float) -> void:
	defend_elapsed += delta
	_spawn_enemies()
	_update_enemies(delta)
	_update_turrets(delta)
	_update_projectiles(delta)

	if trophy_stolen:
		_enter_game_over_from_trophy_loss()
		return

	if enemy_spawn_index >= spawn_queue.size() and enemies.is_empty() and projectiles.is_empty():
		var cleared_round := round_number
		round_number += 1
		highest_round = max(highest_round, round_number)
		_save_persistent_settings()
		_start_build_phase()
		_show_wave_banner_for(_wave_clear_message(cleared_round), 2.35)
		var celebration_position: Vector2 = _active_player_position() + PLAYER_SIZE * 0.5
		_spawn_motion_burst(celebration_position, UI_SUCCESS_ACCENT, 18, 42.0, 128.0, inside_house or inside_cave, "spark")
		_play_sfx(build_sound, -10.0, 1.16)
		_play_sfx(pickup_sound, -14.0, 1.32)


func _enter_game_over_from_trophy_loss() -> void:
	phase = Phase.GAME_OVER
	if game_over_taunt == "":
		game_over_taunt = String(_simulation_pick_random(IRS_DEFEAT_TAUNTS))
	phase_transition_timer = PHASE_TRANSITION_TIME
	phase_transition_color = UI_DANGER_ACCENT
	camera_shake_strength = CAMERA_SHAKE_MAX * screen_shake_percent / 100.0
	_play_sfx(warning_sound, -11.0, 0.62)
	highest_round = max(highest_round, round_number)
	_save_persistent_settings()
	if not revive_used:
		_begin_revive_offer_flow()
	else:
		_finalize_run_after_game_over()
		if menu_start_button != null:
			menu_start_button.call_deferred("grab_focus")


func _begin_revive_offer_flow() -> void:
	revive_offer_pending = true
	revive_offer_visible = false
	revive_offer_delay = REVIVE_OFFER_DELAY
	revive_offer_countdown = REVIVE_OFFER_DURATION
	_pause_music_for_revive()
	if menu_start_button != null:
		menu_start_button.release_focus()


func _update_revive_offer(delta: float) -> void:
	if revive_offer_pending:
		revive_offer_delay = maxf(revive_offer_delay - delta, 0.0)
		if revive_offer_delay <= 0.0:
			revive_offer_pending = false
			revive_offer_visible = true
			revive_offer_countdown = REVIVE_OFFER_DURATION
			if revive_offer_watch_button != null:
				revive_offer_watch_button.call_deferred("grab_focus")
			return
	if not revive_offer_visible:
		return
	revive_offer_countdown = maxf(revive_offer_countdown - delta, 0.0)
	if revive_offer_countdown_label != null:
		revive_offer_countdown_label.text = "Offer expires in %02d" % int(ceili(revive_offer_countdown))
	if revive_offer_countdown <= 0.0:
		_decline_revive_offer("The revive offer expired.")


func _accept_revive_offer() -> void:
	if not revive_offer_visible or ad_in_progress:
		return
	revive_offer_visible = false
	revive_offer_pending = false
	revive_used = true
	ad_in_progress = true
	if revive_offer_panel != null:
		revive_offer_panel.visible = false
	var service := get_node_or_null("/root/AdService")
	if service == null:
		_on_ad_failed("The rewarded-ad service is unavailable.")
		return
	service.call("set_volume_percent", music_volume_percent)
	var requested: bool = bool(service.call("request_rewarded_ad", "evil", dev_tools_available and dev_mode_enabled))
	if not requested and ad_in_progress:
		_on_ad_failed("The rewarded ad could not start.")


func _decline_revive_offer(_reason: String = "") -> void:
	revive_used = true
	revive_offer_pending = false
	revive_offer_visible = false
	revive_offer_delay = 0.0
	revive_offer_countdown = 0.0
	ad_in_progress = false
	if revive_offer_panel != null:
		revive_offer_panel.visible = false
	_finish_revive_music(false)
	if menu_start_button != null:
		menu_start_button.disabled = false
		menu_start_button.call_deferred("grab_focus")
	_finalize_run_after_game_over()
	_refresh_hud()
	queue_redraw()


func _connect_ad_service() -> void:
	var service := get_node_or_null("/root/AdService")
	if service == null:
		return
	var reward_callback := Callable(self, "_on_ad_rewarded")
	var decline_callback := Callable(self, "_on_ad_declined")
	var fail_callback := Callable(self, "_on_ad_failed")
	if not service.is_connected("rewarded", reward_callback):
		service.connect("rewarded", reward_callback)
	if not service.is_connected("declined", decline_callback):
		service.connect("declined", decline_callback)
	if not service.is_connected("failed", fail_callback):
		service.connect("failed", fail_callback)
	service.call("set_volume_percent", music_volume_percent)


func _on_ad_rewarded(_creative: String) -> void:
	if not ad_in_progress:
		return
	ad_in_progress = false
	_apply_rewarded_revive()


func _on_ad_declined(reason: String) -> void:
	if not ad_in_progress:
		return
	_decline_revive_offer(reason)


func _on_ad_failed(message: String) -> void:
	if not ad_in_progress:
		return
	push_warning("Rewarded ad failed: %s" % message)
	_decline_revive_offer(message)


func _apply_rewarded_revive() -> void:
	trophy_stolen = false
	stolen_house_items.erase(PRIZED_HOUSE_ITEM)
	if not PRIZED_HOUSE_ITEM in house_items:
		house_items.append(PRIZED_HOUSE_ITEM)
	player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
	house_damage_stage = 0
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		var structure_type := int(structure.get("type", StructureType.NONE))
		if _is_wall_structure(structure):
			structure["hp"] = _wall_max_hp(structure_type)
		elif structure_type == StructureType.TURRET:
			structure["hp"] = int(structure.get("max_hp", 12))
			structure["ammo"] = int(structure.get("max_ammo", _turret_starting_ammo_for_weapon(String(structure.get("weapon", "arrow")))))
		enemies.clear()
	projectiles.clear()
	enemy_shots.clear()
	spawn_queue.clear()
	enemy_spawn_index = 0
	inside_house = false
	inside_cave = false
	cave_mode_token = false
	player_position = _cell_to_world(PLAYER_START_CELL) + Vector2(11, 11)
	_reset_player_motion()
	var revived_round := round_number
	round_number += 1
	highest_round = max(highest_round, round_number)
	_save_persistent_settings()
	_finish_revive_music(true)
	_start_build_phase()
	_show_wave_banner_for("LETERNAME REVIVAL APPROVED\nRound %d cleared — assets restored" % revived_round, 3.2)
	_spawn_motion_burst(_active_player_position() + PLAYER_SIZE * 0.5, UI_SUCCESS_ACCENT, 24, 52.0, 156.0, false, "spark")
	_play_sfx(build_sound, -8.0, 1.12)
	_refresh_hud()
	queue_redraw()


func _revive_flow_holds_music() -> bool:
	return revive_offer_pending or revive_offer_visible or ad_in_progress


func _pause_music_for_revive() -> void:
	for player in [gameplay_music_player, cave_music_player, boss_music_player]:
		if player != null and player.playing:
			player.stream_paused = true


func _finish_revive_music(resume_gameplay: bool) -> void:
	if cave_music_player != null:
		cave_music_player.stop()
		cave_music_player.stream_paused = false
	if boss_music_player != null:
		boss_music_player.stop()
		boss_music_player.stream_paused = false
	if gameplay_music_player == null:
		return
	if resume_gameplay and gameplay_music_player.playing:
		gameplay_music_player.stream_paused = false
	else:
		gameplay_music_player.stop()
		gameplay_music_player.stream_paused = false


func _wave_clear_message(cleared_round: int) -> String:
	var message_index: int = posmod(cleared_round - 1, IRS_WAVE_CLEAR_LINES.size())
	var message_lines: PackedStringArray = String(IRS_WAVE_CLEAR_LINES[message_index]).split("\n")
	if cleared_round == 1 and tutorial_enabled:
		return "Tutorial Complete — Round 1\n%s" % message_lines[1]
	return "%s — ROUND %d\n%s" % [message_lines[0], cleared_round, message_lines[1]]


func _update_player_combat_state(delta: float) -> void:
	player_attack_cooldown = max(player_attack_cooldown - delta, 0.0)
	player_swing_timer = max(player_swing_timer - delta, 0.0)
	player_gun_kick_timer = maxf(player_gun_kick_timer - delta, 0.0)
	house_flash_timer = max(house_flash_timer - delta, 0.0)
	wave_banner_timer = max(wave_banner_timer - delta, 0.0)
	inventory_full_timer = max(inventory_full_timer - delta, 0.0)
	cave_player_hit_cooldown = max(cave_player_hit_cooldown - delta, 0.0)
	cave_transition_cooldown = max(cave_transition_cooldown - delta, 0.0)
	warning_sfx_cooldown = maxf(warning_sfx_cooldown - delta, 0.0)
	parry_timer = max(parry_timer - delta, 0.0)
	parry_cooldown = max(parry_cooldown - delta, 0.0)
	if not dealer_menu_open and not build_menu_open:
		energy_drink_timer = max(energy_drink_timer - delta, 0.0)
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if structure.has("build_time"):
			var previous_build_time: float = float(structure.get("build_time", 0.0))
			structure["build_time"] = max(previous_build_time - delta, 0.0)
			if previous_build_time > 0.0 and float(structure["build_time"]) <= 0.0:
				structure["completion_pop"] = 0.34
				var completed_center: Vector2 = _cell_center(Vector2i(structure["cell"]))
				_add_explosion_effect(completed_center, 20.0, UI_SUCCESS_ACCENT)
				_add_hit_effect(completed_center, "READY!", UI_SUCCESS_ACCENT)
		if structure.has("completion_pop"):
			structure["completion_pop"] = maxf(float(structure["completion_pop"]) - delta, 0.0)
		if structure.has("flash_timer"):
			structure["flash_timer"] = max(float(structure["flash_timer"]) - delta, 0.0)
	for enemy in enemies:
		if enemy.has("flash_timer"):
			enemy["flash_timer"] = max(float(enemy["flash_timer"]) - delta, 0.0)
		if enemy.has("spawn_anim"):
			enemy["spawn_anim"] = maxf(float(enemy["spawn_anim"]) - delta, 0.0)
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
		if _replay_action_just_pressed("action"):
			_try_player_sword_attack()
		return

	if phase == Phase.DEFEND and _replay_action_just_pressed("action"):
		_try_player_sword_attack()


func _move_player(delta: float) -> void:
	if build_menu_open or dealer_menu_open:
		player_move_velocity = player_move_velocity.move_toward(Vector2.ZERO, PLAYER_DECELERATION * delta)
		return
	var move_vector: Vector2 = _replay_get_vector("move_left", "move_right", "move_up", "move_down")
	player_step_effect_timer = maxf(player_step_effect_timer - delta, 0.0)
	player_skid_timer = maxf(player_skid_timer - delta, 0.0)
	player_step_impact = move_toward(player_step_impact, 0.0, delta * 8.0)
	var base_move_speed: float = PLAYER_SPEED * (ENERGY_DRINK_SPEED_MULTIPLIER if energy_drink_timer > 0.0 else 1.0)
	if move_vector.length_squared() > 0.01:
		tutorial_moved = true
	var target_velocity: Vector2 = move_vector * base_move_speed
	var reversing: bool = move_vector.length_squared() > 0.01 and player_move_velocity.length() >= PLAYER_SKID_MIN_SPEED and player_move_velocity.normalized().dot(move_vector.normalized()) < -0.35
	if reversing and player_skid_timer <= 0.0:
		player_skid_timer = PLAYER_SKID_TIME
		var skid_position: Vector2 = _active_player_position() + PLAYER_SIZE * Vector2(0.5, 0.92)
		_spawn_motion_burst(skid_position, _player_ground_dust_color(), 5, 18.0, 46.0, inside_house or inside_cave, "dust")
	var acceleration: float = PLAYER_TURN_ACCELERATION if reversing else PLAYER_ACCELERATION
	if move_vector.length_squared() <= 0.01:
		player_move_velocity = player_move_velocity.move_toward(Vector2.ZERO, PLAYER_DECELERATION * delta)
	else:
		player_move_velocity = player_move_velocity.move_toward(target_velocity, acceleration * delta)
	var speed_ratio: float = clampf(player_move_velocity.length() / maxf(base_move_speed, 1.0), 0.0, 1.25)
	player_stride_clock += delta * lerpf(5.5, 10.5, speed_ratio) * speed_ratio
	if inside_house:
		interior_player_position += player_move_velocity * delta
		var interior_bounds := _house_interior_walk_bounds()
		var unclamped_interior := interior_player_position
		interior_player_position.x = clampf(interior_player_position.x, interior_bounds.position.x, interior_bounds.end.x - PLAYER_SIZE.x)
		interior_player_position.y = clampf(interior_player_position.y, interior_bounds.position.y, interior_bounds.end.y - PLAYER_SIZE.y)
		_stop_motion_against_bounds(unclamped_interior, interior_player_position)
		_update_player_step_effect(player_move_velocity, interior_player_position + PLAYER_SIZE * Vector2(0.5, 0.95), true)
		return
	if _cave_active():
		var move_speed: float = base_move_speed + (28.0 if bool(cave_pickups_claimed.get("move_upgrade", false)) else 0.0)
		if _is_player_on_cave_rubble():
			move_speed *= 0.68
		if move_vector.length_squared() > 0.01:
			player_move_velocity = player_move_velocity.limit_length(move_speed)
		if shield_unlocked and _replay_action_just_pressed("repair_wall") and parry_cooldown <= 0.0:
			parry_timer = PLAYER_PARRY_WINDOW
			parry_cooldown = PLAYER_PARRY_COOLDOWN
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Parry", MAGIC_COLOR)
		cave_player_position += player_move_velocity * delta
		var cave_bounds: Rect2 = _cave_walk_bounds()
		var unclamped_cave := cave_player_position
		cave_player_position.x = clampf(cave_player_position.x, cave_bounds.position.x, cave_bounds.end.x - PLAYER_SIZE.x)
		cave_player_position.y = clampf(cave_player_position.y, cave_bounds.position.y, cave_bounds.end.y - PLAYER_SIZE.y)
		_stop_motion_against_bounds(unclamped_cave, cave_player_position)
		_update_player_step_effect(player_move_velocity, cave_player_position + PLAYER_SIZE * Vector2(0.5, 0.95), true)
		_try_transition_cave_room(move_vector)
		return
	player_position += player_move_velocity * delta
	var unclamped_world := player_position
	player_position.x = clampf(player_position.x, GRID_ORIGIN.x, GRID_ORIGIN.x + GRID_SIZE.x * CELL_SIZE - PLAYER_SIZE.x)
	player_position.y = max(player_position.y, GRID_ORIGIN.y)
	_stop_motion_against_bounds(unclamped_world, player_position)
	_update_player_step_effect(player_move_velocity, player_position + PLAYER_SIZE * Vector2(0.5, 0.95), false)
	_ensure_forest_generated_for_player()


func _active_player_position() -> Vector2:
	if inside_cave:
		return cave_player_position
	if inside_house:
		return interior_player_position
	return player_position


func _reset_player_motion() -> void:
	player_move_velocity = Vector2.ZERO
	player_skid_timer = 0.0
	player_step_impact = 0.0


func _stop_motion_against_bounds(unclamped_position: Vector2, clamped_position: Vector2) -> void:
	if not is_equal_approx(unclamped_position.x, clamped_position.x):
		player_move_velocity.x = 0.0
	if not is_equal_approx(unclamped_position.y, clamped_position.y):
		player_move_velocity.y = 0.0


func _player_ground_dust_color() -> Color:
	if inside_cave:
		return Color(0.62, 0.58, 0.68, 0.64)
	if inside_house:
		return Color(0.58, 0.42, 0.28, 0.58)
	return Color(0.82, 0.74, 0.58, 0.68)


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


func _apply_player_damage(damage_amount: int, effect_position: Vector2) -> int:
	if damage_amount <= 0:
		return 0
	if dev_mode_enabled and dev_invincible_enabled:
		_add_overlay_effect(effect_position, "AUDIT IMMUNITY", MAGIC_COLOR)
		_play_sfx(ui_hover_sound, -22.0, 0.72)
		return 0
	player_hp -= damage_amount
	hp_flinch_timer = UI_ANIM_TIME
	camera_shake_strength = minf(CAMERA_SHAKE_MAX, camera_shake_strength + 2.2 * screen_shake_percent / 100.0)
	return damage_amount


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
		run_resources_gathered += 1
		_add_gather_effect(source_cell, material_kind.capitalize())
		_play_sfx(pickup_sound, -22.0, 0.88 if material_kind == "stone" else 1.02)
		var gather_color: Color = STONE_NODE_COLOR if material_kind == "stone" else WOOD_NODE_COLOR
		_spawn_motion_burst(_cell_center(source_cell), gather_color, 7, 24.0, 78.0, false, "spark")

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
	var cave_node_position: Vector2 = Vector2(cave_nodes[touching_index]["position"])
	cave_nodes[touching_index]["remaining"] = int(cave_nodes[touching_index]["remaining"]) - 1
	_play_sfx(pickup_sound, -20.0, 0.82 if material_kind == "iron" else 1.08)
	match material_kind:
		"gold":
			gold += CAVE_GOLD_YIELD
			run_resources_gathered += CAVE_GOLD_YIELD
			_add_overlay_effect(Vector2(cave_nodes[touching_index]["position"]), "+%d$" % CAVE_GOLD_YIELD, GOLD_NODE_COLOR)
		"gunpowder":
			gunpowder += CAVE_GUNPOWDER_YIELD
			run_resources_gathered += CAVE_GUNPOWDER_YIELD
			_add_overlay_effect(Vector2(cave_nodes[touching_index]["position"]), "+%d Powder" % CAVE_GUNPOWDER_YIELD, GUNPOWDER_NODE_COLOR)
		_:
			iron += CAVE_IRON_YIELD
			run_resources_gathered += CAVE_IRON_YIELD
			_add_overlay_effect(Vector2(cave_nodes[touching_index]["position"]), "+%d Iron" % CAVE_IRON_YIELD, IRON_NODE_COLOR)
	var cave_gather_color: Color = GOLD_NODE_COLOR if material_kind == "gold" else (GUNPOWDER_NODE_COLOR if material_kind == "gunpowder" else IRON_NODE_COLOR)
	_spawn_motion_burst(cave_node_position, cave_gather_color, 8, 28.0, 86.0, true, "spark")
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
	var marker_count: int = _simulation_randi_range(CAVE_BOSS_ROCKFALL_MIN, CAVE_BOSS_ROCKFALL_MAX)
	var cave_bounds: Rect2 = _cave_walk_bounds()
	var player_center: Vector2 = cave_player_position + PLAYER_SIZE * 0.5
	var chosen_positions: Array[Vector2] = []
	for marker_index in range(marker_count):
		var is_big: bool = marker_index == marker_count - 1 and _simulation_randf() < 0.55
		var marker_position := Vector2.ZERO
		var found_spot := false
		for attempt in range(10):
			var candidate := Vector2(
				_simulation_randf_range(cave_bounds.position.x + 94.0, cave_bounds.end.x - 94.0),
				_simulation_randf_range(cave_bounds.position.y + 86.0, cave_bounds.end.y - 76.0)
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
				_simulation_randf_range(cave_bounds.position.x + 94.0, cave_bounds.end.x - 94.0),
				_simulation_randf_range(cave_bounds.position.y + 86.0, cave_bounds.end.y - 76.0)
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
			rock_damage = _apply_player_damage(rock_damage, player_center)
			if rock_damage > 0:
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
		_play_sfx(explosion_sound, -7.5, _simulation_randf_range(0.86, 0.94))
		cave_falling_rocks.remove_at(rock_index)
	for rubble_index in range(cave_rock_rubble.size() - 1, -1, -1):
		cave_rock_rubble[rubble_index]["time"] = float(cave_rock_rubble[rubble_index]["time"]) - delta
		if float(cave_rock_rubble[rubble_index]["time"]) <= 0.0:
			cave_rock_rubble.remove_at(rubble_index)
	return true


func _cave_miner_steering(miner: Dictionary, player_center: Vector2) -> Vector2:
	var center: Vector2 = Vector2(miner["position"]) + Vector2(miner["size"]) * 0.5
	var pursuit: Vector2 = (player_center - center).normalized()
	var separation := Vector2.ZERO
	for other in cave_enemies:
		if is_same(other, miner) or bool(other.get("boss", false)):
			continue
		var away: Vector2 = center - (Vector2(other["position"]) + Vector2(other["size"]) * 0.5)
		var distance: float = away.length()
		if distance > 0.01 and distance < 54.0:
			separation += away.normalized() * (1.0 - distance / 54.0)
	for marker in cave_boss_rock_markers:
		var away: Vector2 = center - Vector2(marker["position"])
		var danger_radius: float = float(marker.get("impact_radius", 30.0)) + 28.0
		if away.length() < danger_radius:
			miner["ai_thought"] = "Avoid falling rock"
			var escape: Vector2 = away.normalized() if away.length() > 0.01 else -pursuit
			miner["ai_direction"] = escape
			return escape
	miner["ai_thought"] = "Spread out and pursue" if separation.length_squared() > 0.01 else "Pursue Bob"
	var direction: Vector2 = (pursuit + separation * 1.5).normalized()
	miner["ai_direction"] = direction
	return direction


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
			run_enemies_defeated += 1
			_add_explosion_effect(collapse_pos, 20.0 if not bool(cave_enemies[index].get("boss", false)) else 30.0, Color(0.82, 0.24, 0.20))
			_add_overlay_effect(collapse_pos, "DOWN +%d$" % cave_reward, GOLD_NODE_COLOR)
			if bool(cave_enemies[index].get("boss", false)):
				cave_boss_defeated = true
				persistent_cave_boss_defeated = true
				cave_shortcuts_unlocked["forest_shortcut_3"] = true
				cave_boss_rock_markers.clear()
				cave_falling_rocks.clear()
				_grant_boss_victory_rewards()
				_save_persistent_settings()
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
			var move_direction: Vector2 = to_player.normalized() if is_boss else _cave_miner_steering(cave_enemies[index], player_center)
			var next_position: Vector2 = Vector2(cave_enemies[index]["position"]) + move_direction * float(cave_enemies[index]["speed"]) * boss_speed_scale * delta
			if not is_boss:
				var bounds: Rect2 = _cave_walk_bounds()
				var enemy_size: Vector2 = Vector2(cave_enemies[index]["size"])
				next_position = Vector2(clampf(next_position.x, bounds.position.x, bounds.end.x - enemy_size.x), clampf(next_position.y, bounds.position.y, bounds.end.y - enemy_size.y))
			cave_enemies[index]["position"] = next_position
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
					boss_damage = _apply_player_damage(boss_damage, cave_player_position + PLAYER_SIZE * 0.5)
					if boss_damage > 0:
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
			damage_amount = _apply_player_damage(damage_amount, cave_player_position + PLAYER_SIZE * 0.5)
			if damage_amount > 0:
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
				_add_explosion_effect(Vector2(crystal["position"]), 24.0, MAGIC_COLOR)
				_play_sfx(pickup_sound, -13.0, 1.28)
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
	persistent_magic_sentry_unlocked = true
	selected_sentry_kind = "magic"
	cave_shortcuts_unlocked["forest_shortcut_3"] = true
	_add_overlay_effect(_cave_panel().position + Vector2(504, 48), "Final Sentry Unlocked", MAGIC_COLOR)
	_show_wave_banner("Final Sentry\nCrystal Magic Online")
	_save_persistent_settings()


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
		_play_sfx(pickup_sound, -15.5, 1.12)
		_add_explosion_effect(Vector2(pickup["position"]), 24.0, UI_WARM_ACCENT if String(pickup["type"]) == "key" else MAGIC_COLOR)
	if String(room.get("switch_id", "")) != "":
		var switch_rect := Rect2(_cave_panel().position + Vector2(904, 470), Vector2(42, 22))
		if switch_rect.intersects(player_rect):
			var switch_id: String = String(room["switch_id"])
			var was_active: bool = bool(cave_switch_states.get(switch_id, false))
			cave_switch_states[switch_id] = true
			if not was_active:
				_play_sfx(ui_click_sound, -14.0, 0.78)
				_add_explosion_effect(switch_rect.position + switch_rect.size * 0.5, 18.0, UI_SUCCESS_ACCENT)
				_add_overlay_effect(switch_rect.position + switch_rect.size * 0.5, "CLICK!", UI_SUCCESS_ACCENT)
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
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Energy Drink", Color(1.0, 0.94, 0.28))
			_show_wave_banner("Energy Drink\nPermanent Speed Up")
		"upgrade_gather":
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Gather Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nGather Faster")
		"upgrade_sword":
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Sword Up", TEXT_COLOR)
			_show_wave_banner("Cave Upgrade\nWrench Hits Harder")
		"unlock_parry":
			shield_unlocked = true
			persistent_shield_unlocked = true
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Parry", MAGIC_COLOR)
			_show_wave_banner("Cave Unlock\nParry")
			_save_persistent_settings()
		"unlock_golden":
			golden_sentry_unlocked = true
			persistent_golden_sentry_unlocked = true
			_add_overlay_effect(cave_player_position + PLAYER_SIZE * 0.5, "Golden Sentry", GOLD_NODE_COLOR)
			_show_wave_banner("Sentry Unlock\nGolden Turret")
			_save_persistent_settings()
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
	var is_damage_number := _is_damage_number_text(text)
	if is_damage_number and not damage_numbers_enabled:
		return
	hit_effects.append({
		"position": screen_position + camera_position,
		"offset": Vector2.ZERO,
		"text": text,
		"color": color,
		"time": 0.72 if is_damage_number else 0.55,
		"duration": 0.72 if is_damage_number else 0.55,
		"damage": is_damage_number
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
	var placed_cell: Vector2i = selected_cell
	var placed: bool = _try_place_structure_inner(structure_type, sentry_kind)
	if placed:
		_add_ui_stamp(_cell_center(placed_cell), "PAID", true)
	return placed


func _try_place_structure_inner(structure_type: int, sentry_kind: String = "arrow") -> bool:
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
			"hp": 12,
			"max_hp": 12,
			"build_time": TURRET_BUILD_TIME,
			"build_total": TURRET_BUILD_TIME
		}
		tutorial_built_once = true
		run_structures_built += 1
		_celebrate_structure_placement(selected_cell, true)
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
	run_structures_built += 1
	_celebrate_structure_placement(selected_cell, false)
	return true


func _celebrate_structure_placement(cell: Vector2i, is_turret: bool) -> void:
	var build_center: Vector2 = _cell_center(cell)
	var build_color: Color = UI_COOL_ACCENT if is_turret else UI_SUCCESS_ACCENT
	_spawn_motion_burst(build_center, build_color, 10 if is_turret else 7, 32.0, 92.0, false, "spark")
	_add_hit_effect(build_center, "BUILDING" if is_turret else "THUNK!", build_color)
	_play_sfx(build_sound, -13.5 if is_turret else -11.5, 0.94 if is_turret else 0.82)
	if not is_turret:
		_add_explosion_effect(build_center, 14.0, build_color)


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
	run_repairs_completed += 1
	house_flash_timer = HIT_FLASH_TIME
	_add_hit_effect(_cell_center(HOUSE_CELL), "House Repaired", Color(0.65, 1.0, 0.72))
	_add_explosion_effect(_cell_center(HOUSE_CELL), 18.0, Color(0.64, 0.94, 0.74, 0.22))
	_spawn_motion_burst(_cell_center(HOUSE_CELL), UI_SUCCESS_ACCENT, 12, 28.0, 90.0, false, "spark")
	_play_sfx(build_sound, -11.0, 1.02)


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
	var sold_center: Vector2 = _cell_center(selected_cell)
	_add_hit_effect(sold_center, "Packed Up" if refund_ratio >= 0.99 else "SOLD!", Color(0.84, 0.96, 0.78))
	_spawn_motion_burst(sold_center, UI_SUCCESS_ACCENT, 9, 28.0, 82.0, false, "spark")
	_play_sfx(pickup_sound, -17.0, 0.82)


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
	run_repairs_completed += 1
	var repair_center: Vector2 = _cell_center(selected_cell)
	_add_hit_effect(repair_center, "+%d" % WALL_REPAIR_AMOUNT, Color(0.65, 1.0, 0.72))
	_spawn_motion_burst(repair_center, UI_SUCCESS_ACCENT, 7, 20.0, 66.0, false, "spark")
	_play_sfx(build_sound, -18.0, 1.14)
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
	structure["completion_pop"] = 0.30
	var upgrade_center: Vector2 = _cell_center(selected_cell)
	_add_hit_effect(upgrade_center, "UPGRADED  LV.%d" % int(structure["level"]), UI_WARM_ACCENT)
	_add_explosion_effect(upgrade_center, 22.0, Color(UI_WARM_ACCENT.r, UI_WARM_ACCENT.g, UI_WARM_ACCENT.b, 0.30))
	_spawn_motion_burst(upgrade_center, UI_WARM_ACCENT, 12, 30.0, 96.0, false, "spark")
	_play_sfx(build_sound, -12.0, 1.24)


func _try_player_sword_attack() -> void:
	if player_attack_cooldown > 0.0:
		return
	var player_center := cave_player_position + PLAYER_SIZE * 0.5 if inside_cave else player_position + PLAYER_SIZE * 0.5
	if inside_cave:
		player_aim_direction = _best_melee_target_direction(player_center, cave_enemies)
		player_attack_cooldown = PLAYER_SWORD_COOLDOWN
		player_swing_timer = PLAYER_SWORD_SWING_TIME
		player_swing_direction = player_aim_direction
		_add_slash_effect(player_center, player_swing_direction, true)
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
			_add_explosion_effect(enemy_center, 12.0, SLASH_COLOR)
			_register_melee_impact()
			_play_sfx(impact_sound, -14.0, 1.18)
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
			_add_explosion_effect(enemy_center, 12.0, SLASH_COLOR)
			_register_melee_impact()
			_play_sfx(impact_sound, -14.0, 1.12)
		return
	player_aim_direction = _best_melee_target_direction(player_center, enemies)
	player_attack_cooldown = PLAYER_SWORD_COOLDOWN
	player_swing_timer = PLAYER_SWORD_SWING_TIME
	player_swing_direction = player_aim_direction
	_add_slash_effect(player_center, player_swing_direction, false)
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
		_add_explosion_effect(enemy_center, 12.0, SLASH_COLOR)
		_register_melee_impact()
		_play_sfx(impact_sound, -14.0, 1.18)
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
		_add_explosion_effect(enemy_center, 12.0, SLASH_COLOR)
		_register_melee_impact()
		_play_sfx(impact_sound, -14.0, 1.12)


func _register_melee_impact() -> void:
	hit_stop_timer = maxf(hit_stop_timer, MELEE_HIT_STOP_TIME)
	camera_shake_strength = minf(CAMERA_SHAKE_MAX, camera_shake_strength + 2.8 * screen_shake_percent / 100.0)


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
		var entry_cell: Vector2i = Vector2i(2, _simulation_randi_range(SIDE_SPAWN_ROW_RANGE.x, SIDE_SPAWN_ROW_RANGE.y)) if lane == "left" else Vector2i(GRID_SIZE.x - 3, _simulation_randi_range(SIDE_SPAWN_ROW_RANGE.x, SIDE_SPAWN_ROW_RANGE.y))
		var entry_target: Vector2 = _cell_center(entry_cell) - enemy_size * 0.5
		var spawn_position: Vector2 = _side_spawn_position(lane, enemy_size)
		var enemy_role: String = _enemy_role_for(enemy_type, enemy_spawn_index)
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
			"wander_offset": _simulation_randf_range(-26.0, 26.0),
			"anim_phase": _simulation_randf_range(0.0, 0.7),
			"spawn_anim": 0.28,
			"role": enemy_role,
			"squad_id": int(floor(float(enemy_spawn_index) / 3.0)),
			"formation_slot": posmod(enemy_spawn_index, 3) - 1,
			"decision_timer": _simulation_randf_range(0.12, 0.42),
			"lane_switch_cooldown": _simulation_randf_range(1.2, 2.4),
			"focus_player": false,
			"dodge_timer": 0.0,
			"dodge_cooldown": _simulation_randf_range(0.4, 1.2),
			"dodge_direction": Vector2.ZERO,
			"ai_nodes": [],
			"ai_node_index": 0,
			"ai_target_kind": "entry",
			"ai_thought": "%s: entering audit zone" % enemy_role.capitalize()
		})
		_spawn_motion_burst(entry_target + enemy_size * 0.5, UI_DANGER_ACCENT, 7, 26.0, 72.0, false, "dust")
		next_enemy_id += 1
		enemy_spawn_index += 1


func _enemy_role_for(enemy_type: String, spawn_index: int) -> String:
	if enemy_type == "brute":
		return "breacher"
	if enemy_type == "swat":
		return "commander" if posmod(spawn_index, 3) == 0 else "saboteur"
	return "flanker" if posmod(spawn_index, 3) == 1 else "skirmisher"


func _weakest_defense_lane() -> String:
	var left_score := 0.0
	var right_score := 0.0
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		var structure_type: int = int(structure.get("type", StructureType.NONE))
		var cell: Vector2i = Vector2i(structure.get("cell", HOUSE_CELL))
		var value: float = float(structure.get("hp", 7))
		if structure_type == StructureType.TURRET:
			value = 5.0 + float(structure.get("level", 1)) * 2.0
		if cell.x <= HOUSE_CELL.x:
			left_score += value
		else:
			right_score += value
	return "left" if left_score <= right_score else "right"


func _find_enemy_turret_target(enemy: Dictionary) -> Dictionary:
	var enemy_center: Vector2 = _enemy_center(enemy)
	var lane: String = String(enemy.get("lane", "left"))
	var best_info: Dictionary = {}
	var best_score := INF
	for structure_key in structures.keys():
		var structure: Dictionary = structures[structure_key]
		if int(structure.get("type", StructureType.NONE)) != StructureType.TURRET or float(structure.get("build_time", 0.0)) > 0.0:
			continue
		var cell: Vector2i = Vector2i(structure["cell"])
		var same_lane: bool = (lane == "left" and cell.x <= HOUSE_CELL.x) or (lane == "right" and cell.x >= HOUSE_CELL.x)
		var center: Vector2 = _cell_center(cell)
		var score: float = enemy_center.distance_to(center) + (0.0 if same_lane else 180.0) - float(structure.get("level", 1)) * 12.0
		if score < best_score:
			best_score = score
			best_info = {"kind": "turret", "center": center, "structure": structure, "key": String(structure_key)}
	return best_info


func _enemy_target_info(enemy: Dictionary, has_active_walls: bool = true) -> Dictionary:
	var role: String = String(enemy.get("role", "skirmisher"))
	if bool(enemy.get("focus_player", false)) and not inside_house and not inside_cave:
		return {"kind": "player", "center": player_position + PLAYER_SIZE * 0.5}
	if role == "saboteur" or role == "commander":
		var turret_target: Dictionary = _find_enemy_turret_target(enemy)
		if not turret_target.is_empty():
			return turret_target
	if has_active_walls:
		var target_wall: Dictionary = _find_enemy_wall_target(enemy)
		if not target_wall.is_empty():
			return {"kind": "wall", "center": _cell_center(Vector2i(target_wall["cell"])), "structure": target_wall, "key": _cell_key(Vector2i(target_wall["cell"]))}
	var lane: String = String(enemy.get("lane", "left"))
	return {"kind": "house", "center": _cell_center(_side_house_target_cell(lane))}


func _update_enemy_decision(enemy: Dictionary, delta: float) -> void:
	enemy["decision_timer"] = float(enemy.get("decision_timer", 0.0)) - delta
	enemy["lane_switch_cooldown"] = maxf(float(enemy.get("lane_switch_cooldown", 0.0)) - delta, 0.0)
	enemy["dodge_timer"] = maxf(float(enemy.get("dodge_timer", 0.0)) - delta, 0.0)
	enemy["dodge_cooldown"] = maxf(float(enemy.get("dodge_cooldown", 0.0)) - delta, 0.0)
	if float(enemy["decision_timer"]) <= 0.0:
		enemy["decision_timer"] = _simulation_randf_range(0.45, 0.85)
		var enemy_center: Vector2 = _enemy_center(enemy)
		var player_distance: float = enemy_center.distance_to(player_position + PLAYER_SIZE * 0.5)
		var role: String = String(enemy.get("role", "skirmisher"))
		var pressure_chance: float = 0.0 if round_number <= 2 else clampf(0.06 + float(round_number - 3) * 0.025, 0.06, 0.34)
		enemy["focus_player"] = role != "breacher" and player_distance < 230.0 and _simulation_randf() < pressure_chance
		if float(enemy.get("lane_switch_cooldown", 0.0)) <= 0.0 and round_number >= 3:
			var weak_lane: String = _weakest_defense_lane()
			if String(enemy.get("lane", "left")) != weak_lane and _simulation_randf() < clampf(0.14 + round_number * 0.025, 0.14, 0.48):
				enemy["lane"] = weak_lane
				enemy["lane_switch_cooldown"] = _simulation_randf_range(2.4, 4.2)
	if round_number >= 2 and float(enemy.get("dodge_cooldown", 0.0)) <= 0.0 and String(enemy.get("role", "")) != "breacher":
		var enemy_center: Vector2 = _enemy_center(enemy)
		for projectile in projectiles:
			var projectile_position: Vector2 = Vector2(projectile.get("position", Vector2.ZERO))
			if enemy_center.distance_to(projectile_position) > 78.0:
				continue
			var projectile_direction: Vector2 = Vector2(projectile.get("direction", Vector2.RIGHT)).normalized()
			var to_enemy: Vector2 = enemy_center - projectile_position
			if to_enemy.dot(projectile_direction) <= 0.0:
				continue
			var dodge_skill: float = clampf(0.18 + float(round_number) * 0.025, 0.18, 0.54)
			if String(enemy.get("type", "runner")) == "swat":
				dodge_skill = minf(0.82, dodge_skill + 0.26)
			if _simulation_randf() > dodge_skill:
				enemy["dodge_cooldown"] = 0.28
				break
			enemy["dodge_direction"] = Vector2(-projectile_direction.y, projectile_direction.x) * (-1.0 if _simulation_randf() < 0.5 else 1.0)
			enemy["dodge_timer"] = 0.18
			enemy["dodge_cooldown"] = _simulation_randf_range(1.1, 2.0)
			enemy["ai_thought"] = "Incoming shot — sidestepping"
			break


func _update_enemy_plan(enemy: Dictionary, target_info: Dictionary) -> void:
	var target_kind: String = String(target_info.get("kind", "house"))
	var target_center: Vector2 = Vector2(target_info.get("center", _cell_center(HOUSE_CELL)))
	var enemy_center: Vector2 = _enemy_center(enemy)
	var lane: String = String(enemy.get("lane", "left"))
	var role: String = String(enemy.get("role", "skirmisher"))
	var planned_nodes: Array[Vector2] = []
	if target_kind == "house":
		var route_cells: Array[Vector2i] = []
		if lane == "left":
			route_cells.assign([Vector2i(5, 6), Vector2i(8, 4)])
		else:
			route_cells.assign([Vector2i(18, 6), Vector2i(15, 4)])
		for route_cell in route_cells:
			var route_center: Vector2 = _cell_center(route_cell)
			var ahead: bool = route_center.x > enemy_center.x + 20.0 if lane == "left" else route_center.x < enemy_center.x - 20.0
			if ahead:
				planned_nodes.append(route_center)
	elif target_kind == "wall":
		var wall_approach := target_center + Vector2(-54.0 if lane == "left" else 54.0, float(enemy.get("formation_slot", 0)) * 18.0)
		if enemy_center.distance_to(wall_approach) > 42.0:
			planned_nodes.append(wall_approach)
	elif target_kind == "turret":
		var flank_sign: float = -1.0 if int(enemy.get("formation_slot", 0)) <= 0 else 1.0
		planned_nodes.append(target_center + Vector2(-64.0 if lane == "left" else 64.0, 52.0 * flank_sign))
	planned_nodes.append(target_center)
	enemy["ai_nodes"] = planned_nodes
	enemy["ai_node_index"] = 0
	enemy["ai_target_kind"] = target_kind
	enemy["ai_target_center"] = target_center
	enemy["ai_plan_lane"] = lane
	match target_kind:
		"player":
			enemy["ai_thought"] = "Bob exposed — close in"
		"turret":
			enemy["ai_thought"] = "Disable the highest-value sentry"
		"wall":
			enemy["ai_thought"] = "Breach the cheapest route"
		_:
			enemy["ai_thought"] = "Advance on the %s lane" % lane


func _apply_enemy_attack(enemy_index: int, target_info: Dictionary) -> void:
	if enemy_index < 0 or enemy_index >= enemies.size():
		return
	enemies[enemy_index]["attack_cooldown"] = ENEMY_ATTACK_RATE
	enemies[enemy_index]["attack_windup"] = 0.0
	var enemy: Dictionary = enemies[enemy_index]
	var damage: int = int(enemy["damage"])
	var kind: String = String(target_info.get("kind", "house"))
	var target_center: Vector2 = Vector2(target_info.get("center", _cell_center(HOUSE_CELL)))
	var ranged: bool = String(enemy["type"]) == "runner" or String(enemy["type"]) == "swat"
	if ranged:
		_add_enemy_shot(_enemy_center(enemy), target_center)
	if kind == "player":
		if cave_player_hit_cooldown > 0.0:
			enemies[enemy_index]["attack_cooldown"] = 0.22
			return
		var player_damage: int = _apply_player_damage(maxi(1, damage - 1), player_position + PLAYER_SIZE * 0.5)
		cave_player_hit_cooldown = 0.55
		if player_damage > 0:
			var knock_direction: Vector2 = (player_position + PLAYER_SIZE * 0.5 - _enemy_center(enemy)).normalized()
			player_move_velocity += knock_direction * 145.0
			_add_hit_effect(player_position + PLAYER_SIZE * 0.5, "-%d" % player_damage, HOUSE_DANGER_COLOR)
		_add_explosion_effect(player_position + PLAYER_SIZE * 0.5, 13.0, Color(0.92, 0.34, 0.30, 0.35))
		_play_sfx(impact_sound, -12.0, 0.86)
		if player_hp <= 0:
			player_hp = PLAYER_MAX_HP + _extra_player_max_hp()
			player_position = _cell_to_world(PLAYER_START_CELL) + Vector2(11, 11)
			_reset_player_motion()
			_show_wave_banner_for("BOB KNOCKED BACK\nProtect the house!", 1.2)
		return
	if kind == "wall" or kind == "turret":
		var target_structure: Dictionary = target_info.get("structure", {})
		if target_structure.is_empty():
			return
		target_structure["hp"] = int(target_structure.get("hp", 8)) - damage
		target_structure["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(target_center, "-%d" % damage, HOUSE_DANGER_COLOR)
		_add_explosion_effect(target_center, 11.0 if kind == "wall" else 14.0, HOUSE_DANGER_COLOR)
		_play_sfx(impact_sound, -16.0 if kind == "wall" else -13.5, 0.78 if kind == "wall" else 1.04)
		if int(target_structure["hp"]) <= 0:
			_add_explosion_effect(target_center, 24.0, Color(0.72, 0.58, 0.36))
			_add_hit_effect(target_center, "CRUMBLE" if kind == "wall" else "DISABLED", Color(0.92, 0.80, 0.62))
			structures.erase(String(target_info.get("key", "")))
		return
	if _count_remaining_walls() > 0:
		_damage_outer_wall(damage)
		enemies[enemy_index]["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(_cell_center(HOUSE_CELL), "WALLS!", HOUSE_DANGER_COLOR)
	elif house_damage_stage < HOUSE_MAX_DAMAGE_STAGES:
		_damage_house(damage)
		enemies[enemy_index]["flash_timer"] = HIT_FLASH_TIME
		_add_hit_effect(Vector2(enemies[enemy_index]["position"]) + Vector2(enemies[enemy_index]["size"]) * 0.5, "RUN!", MUTED_TEXT_COLOR)
		enemies.remove_at(enemy_index)
	else:
		_steal_house_item(enemy_index)


func _update_enemies(delta: float) -> void:
	var has_active_walls: bool = _count_remaining_walls() > 0
	for index in range(enemies.size() - 1, -1, -1):
		if int(enemies[index]["hp"]) <= 0:
			_kill_enemy(index)
			continue
		var previous_windup: float = float(enemies[index].get("attack_windup", 0.0))
		var attack_windup: float = max(previous_windup - delta, 0.0)
		enemies[index]["attack_windup"] = attack_windup
		enemies[index]["attack_cooldown"] = max(float(enemies[index]["attack_cooldown"]) - delta, 0.0)
		_update_enemy_decision(enemies[index], delta)
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
		var target_info: Dictionary = _enemy_target_info(enemies[index], has_active_walls)
		var target_center: Vector2 = Vector2(target_info.get("center", _cell_center(HOUSE_CELL)))
		var target_kind: String = String(target_info.get("kind", "house"))
		var planned_nodes = enemies[index].get("ai_nodes", [])
		var plan_target_center: Vector2 = Vector2(enemies[index].get("ai_target_center", Vector2(INF, INF)))
		var plan_changed: bool = (
			planned_nodes.is_empty()
			or String(enemies[index].get("ai_target_kind", "")) != target_kind
			or String(enemies[index].get("ai_plan_lane", "")) != String(enemies[index].get("lane", "left"))
			or plan_target_center.distance_squared_to(target_center) > 16.0
		)
		if plan_changed:
			_update_enemy_plan(enemies[index], target_info)
			planned_nodes = enemies[index].get("ai_nodes", [])
		var ranged: bool = String(enemies[index]["type"]) == "runner" or String(enemies[index]["type"]) == "swat"
		var desired_range: float = 126.0 if String(enemies[index]["type"]) == "runner" else (148.0 if String(enemies[index]["type"]) == "swat" else CELL_SIZE * 0.28)
		if target_kind == "house" and has_active_walls:
			desired_range = CELL_SIZE * 0.28
		var enemy_center: Vector2 = enemy_position + enemy_size * 0.5
		var target_distance: float = enemy_center.distance_to(target_center)
		var in_attack_range: bool = target_distance <= desired_range
		if in_attack_range:
			if previous_windup > 0.0 and attack_windup <= 0.0:
				_apply_enemy_attack(index, target_info)
			elif previous_windup <= 0.0 and float(enemies[index]["attack_cooldown"]) <= 0.0:
				enemies[index]["attack_windup"] = ENEMY_ATTACK_WINDUP * (0.82 if String(enemies[index]["type"]) == "swat" else 1.0)
				enemies[index]["flash_timer"] = max(float(enemies[index].get("flash_timer", 0.0)), 0.06)
				if warning_sfx_cooldown <= 0.0 and (String(enemies[index]["type"]) == "swat" or target_distance < 84.0):
					warning_sfx_cooldown = 0.12
					_play_sfx(warning_sound, -22.0, 1.08 if String(enemies[index]["type"]) == "swat" else 0.92)
			# Ranged units reposition instead of standing in a single pile.
			if not ranged or target_distance > desired_range * 0.58:
				continue

		var navigation_target_center: Vector2 = target_center
		var planned_node_index: int = clampi(int(enemies[index].get("ai_node_index", 0)), 0, planned_nodes.size())
		while planned_node_index < planned_nodes.size() and enemy_center.distance_to(Vector2(planned_nodes[planned_node_index])) <= 30.0:
			planned_node_index += 1
		enemies[index]["ai_node_index"] = planned_node_index
		if planned_node_index < planned_nodes.size():
			navigation_target_center = Vector2(planned_nodes[planned_node_index])
		var formation_slot: float = float(enemies[index].get("formation_slot", 0))
		var target_offset := Vector2(0.0, formation_slot * 24.0 + float(enemies[index].get("wander_offset", 0.0)) * 0.14)
		var target_position := navigation_target_center + target_offset - enemy_size * 0.5
		var to_target := target_position - enemy_position
		var move_direction: Vector2 = to_target.normalized() if to_target != Vector2.ZERO else Vector2.ZERO
		if ranged and target_distance < desired_range * 0.58:
			move_direction = (enemy_center - target_center).normalized()
		if float(enemies[index].get("dodge_timer", 0.0)) > 0.0:
			move_direction = (move_direction * 0.45 + Vector2(enemies[index].get("dodge_direction", Vector2.ZERO)) * 0.92).normalized()
		var speed_scale: float = 1.18 if float(enemies[index].get("dodge_timer", 0.0)) > 0.0 else 1.0
		if String(enemies[index].get("role", "")) == "commander":
			speed_scale *= 0.92
		if to_target.length() <= float(enemies[index]["speed"]) * delta and not ranged:
			enemies[index]["position"] = target_position
		else:
			enemies[index]["position"] = enemy_position + move_direction * float(enemies[index]["speed"]) * speed_scale * delta


func _kill_enemy(index: int) -> void:
	var enemy_type: String = String(enemies[index]["type"])
	if enemy_type == "brute":
		_spawn_robot_corpse(enemies[index])
	elif enemy_type == "swat":
		gold += SWAT_GOLD_REWARD
		_add_hit_effect(_enemy_center(enemies[index]), "+%d$" % SWAT_GOLD_REWARD, GOLD_NODE_COLOR)
	_add_explosion_effect(_enemy_center(enemies[index]), 18.0 if enemy_type == "runner" else 24.0, Color(0.82, 0.24, 0.20))
	_add_hit_effect(_enemy_center(enemies[index]), "DOWN", Color(1.0, 0.86, 0.72))
	run_enemies_defeated += 1
	_play_sfx(explosion_sound, -15.0 if enemy_type == "runner" else -11.5, _simulation_randf_range(1.06, 1.18) if enemy_type == "runner" else _simulation_randf_range(0.86, 0.96))
	enemies.remove_at(index)


func _spawn_robot_corpse(enemy: Dictionary) -> void:
	enemy_corpses.append({
		"position": Vector2(enemy["position"]),
		"size": Vector2(enemy["size"]),
		"time": 0.0,
		"lane": String(enemy.get("lane", "left"))
	})


func _update_turrets(delta: float) -> void:
	enemy_cluster_cache_timer = maxf(enemy_cluster_cache_timer - delta, 0.0)
	if enemy_cluster_cache_timer <= 0.0 or enemy_cluster_counts.is_empty():
		_prepare_turret_targeting_cache()
		enemy_cluster_cache_timer = 0.18
	var enemy_index_by_id := {}
	for enemy_index in range(enemies.size()):
		enemy_index_by_id[int(enemies[enemy_index].get("id", -1))] = enemy_index
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
		var nearest_index: int = int(enemy_index_by_id.get(int(structure.get("target_id", -1)), -1))
		if nearest_index >= 0:
			var current_target_center: Vector2 = _enemy_center(enemies[nearest_index])
			if turret_center.distance_squared_to(current_target_center) > turret_range * turret_range:
				nearest_index = -1
		var target_refresh_timer: float = maxf(float(structure.get("target_refresh_timer", 0.0)) - delta, 0.0)
		structure["target_refresh_timer"] = target_refresh_timer
		if target_refresh_timer <= 0.0 or nearest_index < 0:
			nearest_index = -1
			var best_target_score := -INF
			for enemy_index in range(enemies.size()):
				var enemy_center: Vector2 = _enemy_center(enemies[enemy_index])
				var distance := turret_center.distance_to(enemy_center)
				if distance <= turret_range:
					var target_score: float = _turret_target_score(structure, enemy_index, distance, turret_range)
					if target_score <= best_target_score:
						continue
					best_target_score = target_score
					nearest_index = enemy_index
			structure["target_refresh_timer"] = 0.11 + float(posmod(int(Vector2i(structure["cell"]).x + Vector2i(structure["cell"]).y), 4)) * 0.012

		if nearest_index != -1:
			var target_center: Vector2 = Vector2(enemies[nearest_index]["position"]) + Vector2(enemies[nearest_index]["size"]) * 0.5
			var aim_direction: Vector2 = (target_center - turret_center).normalized()
			if aim_direction != Vector2.ZERO:
				structure["aim_direction"] = aim_direction
				var current_visual_angle: float = float(structure.get("visual_aim_angle", aim_direction.angle()))
				var aim_lerp_weight: float = 1.0 - exp(-delta * 12.0)
				structure["visual_aim_angle"] = lerp_angle(current_visual_angle, aim_direction.angle(), aim_lerp_weight)
			structure["has_target"] = true
			structure["target_id"] = int(enemies[nearest_index]["id"])
		else:
			structure["target_id"] = -1
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
				_play_sfx(explosion_sound, -10.0, _simulation_randf_range(0.92, 1.00))
			elif fired_weapon == "arrow" or fired_weapon == "golden" or fired_weapon == "rifle":
				_play_sfx(crossbow_sound, -11.5, _simulation_randf_range(0.96, 1.04))
			else:
				_play_sfx(gunshot_sound, -13.0, _simulation_randf_range(0.96, 1.04))


func _turret_target_score(structure: Dictionary, enemy_index: int, distance: float, turret_range: float) -> float:
	var enemy: Dictionary = enemies[enemy_index]
	var weapon: String = String(structure.get("weapon", "arrow"))
	var hp_ratio: float = float(enemy.get("hp", 1)) / maxf(float(enemy.get("max_hp", 1)), 1.0)
	var speed: float = float(enemy.get("speed", 0.0))
	var distance_score: float = 1.0 - distance / maxf(turret_range, 1.0)
	var enemy_type: String = String(enemy.get("type", "runner"))
	match weapon:
		"cannon":
			var cluster_count: int = int(enemy_cluster_counts.get(int(enemy.get("id", -1)), 1))
			return float(cluster_count) * 4.0 + float(enemy.get("hp", 1)) * 0.16 + distance_score
		"gun":
			return speed * 0.035 + (1.0 - hp_ratio) * 3.0 + distance_score
		"golden":
			return (8.0 if enemy_type == "swat" else 0.0) + float(enemy.get("max_hp", 1)) * 0.18 + distance_score
		"rifle":
			return float(enemy.get("hp", 1)) * 0.32 + (4.0 if enemy_type == "swat" else 0.0) + distance_score
		"magic":
			return speed * 0.025 + float(enemy.get("hp", 1)) * 0.12 + distance_score * 2.0
		_:
			return distance_score * 6.0 + (2.0 if enemy_type == "runner" else 0.0)


func _prepare_turret_targeting_cache() -> void:
	enemy_cluster_counts.clear()
	if enemies.is_empty():
		return
	var bucket_size: float = maxf(CANNON_TURRET_SPLASH_RADIUS, 48.0)
	var buckets := {}
	for enemy in enemies:
		var center: Vector2 = _enemy_center(enemy)
		var bucket := Vector2i(floori(center.x / bucket_size), floori(center.y / bucket_size))
		if not buckets.has(bucket):
			buckets[bucket] = []
		buckets[bucket].append(enemy)
	for enemy in enemies:
		var center: Vector2 = _enemy_center(enemy)
		var bucket := Vector2i(floori(center.x / bucket_size), floori(center.y / bucket_size))
		var nearby_count := 0
		for offset_y in range(-1, 2):
			for offset_x in range(-1, 2):
				for other_enemy in buckets.get(bucket + Vector2i(offset_x, offset_y), []):
					if _enemy_center(other_enemy).distance_squared_to(center) <= CANNON_TURRET_SPLASH_RADIUS * CANNON_TURRET_SPLASH_RADIUS:
						nearby_count += 1
		enemy_cluster_counts[int(enemy.get("id", -1))] = nearby_count


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


func _turret_recoil_strength(structure: Dictionary) -> float:
	var fire_rate: float = _turret_fire_rate(structure)
	var time_since_fire: float = maxf(0.0, fire_rate - float(structure.get("cooldown", 0.0)))
	var recoil_duration: float = 0.24 if String(structure.get("weapon", "arrow")) == "cannon" else 0.13
	if time_since_fire >= recoil_duration:
		return 0.0
	var recoil_progress: float = clampf(time_since_fire / recoil_duration, 0.0, 1.0)
	return pow(1.0 - recoil_progress, 2.0)


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
	_add_explosion_effect(_cell_center(wall["cell"]), 10.0, HOUSE_DANGER_COLOR)
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
	var shot_direction: Vector2 = (enemy_center - player_center).normalized()
	if shot_direction == Vector2.ZERO:
		shot_direction = player_aim_direction
	gun_cooldowns[gun_name] = fire_rate
	player_gun_kick_timer = 0.14
	projectiles.append({
		"position": player_center,
		"target_id": int(enemies[target_index]["id"]),
		"speed": 430.0 if gun_name == "sidearm" else 520.0,
		"damage": damage + gun_damage_bonus,
		"color": projectile_color,
		"radius": radius,
		"kind": "orb",
		"direction": shot_direction
	})
	_add_explosion_effect(player_center + shot_direction * 16.0, 8.0 if gun_name == "sidearm" else 11.0, projectile_color)
	_play_sfx(gunshot_sound, -11.5 if gun_name == "rifle" else -13.5, _simulation_randf_range(0.97, 1.05))


func _update_projectiles(delta: float) -> void:
	var enemy_index_by_id := {}
	for enemy_index in range(enemies.size()):
		enemy_index_by_id[int(enemies[enemy_index].get("id", -1))] = enemy_index
	for index in range(projectiles.size() - 1, -1, -1):
		var projectile_kind: String = String(projectiles[index].get("kind", "orb"))
		var target_index: int = int(enemy_index_by_id.get(int(projectiles[index]["target_id"]), -1))
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
					_play_sfx(explosion_sound, -7.0, _simulation_randf_range(0.94, 1.02))
				else:
					if target_index != -1:
						enemies[target_index]["hp"] = int(enemies[target_index]["hp"]) - landing_damage
						enemies[target_index]["flash_timer"] = HIT_FLASH_TIME
					_add_hit_effect(target_center, "-%d" % landing_damage, Color(projectiles[index]["color"]))
					_add_explosion_effect(target_center, 10.0, Color(projectiles[index]["color"]))
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
				_add_explosion_effect(target_center, 10.0 if projectile_kind != "laser" else 15.0, Color(projectiles[index]["color"]))
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
		"time": 0.48,
		"color": color,
		"screen_space": inside_house or inside_cave
	})
	_spawn_motion_burst(world_position, color, clampi(int(radius * 0.28), 4, 14), 28.0, maxf(52.0, radius * 3.0), inside_house or inside_cave, "spark")
	if radius >= 18.0 and not inside_house:
		var shake_scale: float = screen_shake_percent / 100.0
		camera_shake_strength = maxf(camera_shake_strength, clampf((radius - 10.0) * 0.18 * shake_scale, 0.0, CAMERA_SHAKE_MAX * shake_scale))


func _apply_camera_shake(delta: float) -> void:
	if camera_shake_strength <= 0.01:
		camera_shake_strength = 0.0
		return
	var shake_offset := Vector2(_simulation_randf_range(-camera_shake_strength, camera_shake_strength), _simulation_randf_range(-camera_shake_strength, camera_shake_strength)).round()
	camera_position += shake_offset
	camera_shake_strength = move_toward(camera_shake_strength, 0.0, CAMERA_SHAKE_DECAY * delta)


func _update_explosion_effects(delta: float) -> void:
	for index in range(explosion_effects.size() - 1, -1, -1):
		explosion_effects[index]["time"] = float(explosion_effects[index]["time"]) - delta
		if float(explosion_effects[index]["time"]) <= 0.0:
			explosion_effects.remove_at(index)


func _update_player_step_effect(move_vector: Vector2, foot_position: Vector2, screen_space: bool) -> void:
	if move_vector.length_squared() <= 0.02 or player_step_effect_timer > 0.0:
		return
	player_step_effect_timer = PLAYER_STEP_EFFECT_INTERVAL if energy_drink_timer > 0.0 else PLAYER_STEP_EFFECT_INTERVAL * 1.35
	player_step_impact = 1.0
	var dust_color := _player_ground_dust_color()
	var footstep_stream: AudioStream = step_grass_sound
	var footstep_pitch := 1.0
	if inside_cave:
		footstep_stream = step_cave_sound
		footstep_pitch = 0.88
	elif inside_house:
		footstep_stream = step_wood_sound
		footstep_pitch = 1.04
	_play_sfx(footstep_stream, -27.0, footstep_pitch + sin(player_stride_clock * 1.7) * 0.035)
	_spawn_motion_burst(foot_position, dust_color, 3 if energy_drink_timer <= 0.0 else 5, 12.0, 34.0, screen_space, "dust")
	if energy_drink_timer > 0.0:
		_spawn_motion_burst(foot_position - move_vector.normalized() * 8.0, Color(1.0, 0.92, 0.22, 0.76), 2, 26.0, 58.0, screen_space, "spark")


func _spawn_motion_burst(position: Vector2, color: Color, count: int, min_speed: float, max_speed: float, screen_space: bool, kind: String = "spark") -> void:
	var adjusted_count: int = count if effects_quality_high else maxi(1, int(ceil(float(count) * 0.48)))
	var particle_cap: int = 360 if effects_quality_high else 150
	adjusted_count = mini(adjusted_count, maxi(0, particle_cap - motion_effects.size()))
	for particle_index in range(adjusted_count):
		var angle: float = _simulation_randf_range(0.0, TAU)
		if kind == "dust":
			angle = _simulation_randf_range(PI * 1.08, PI * 1.92)
		var speed: float = _simulation_randf_range(min_speed, max_speed)
		var particle_time: float = _simulation_randf_range(MOTION_SPARK_TIME * 0.72, MOTION_SPARK_TIME * 1.18)
		motion_effects.append({
			"kind": kind,
			"position": position + Vector2(_simulation_randf_range(-3.0, 3.0), _simulation_randf_range(-2.0, 2.0)),
			"velocity": Vector2.RIGHT.rotated(angle) * speed,
			"color": color,
			"size": _simulation_randf_range(1.8, 3.8) if kind == "spark" else _simulation_randf_range(2.5, 5.0),
			"time": particle_time,
			"total": particle_time,
			"screen_space": screen_space,
			"spin": _simulation_randf_range(-8.0, 8.0),
			"rotation": _simulation_randf_range(0.0, TAU)
		})


func _add_slash_effect(position: Vector2, direction: Vector2, screen_space: bool) -> void:
	var slash_direction: Vector2 = direction.normalized() if direction != Vector2.ZERO else Vector2.RIGHT
	motion_effects.append({
		"kind": "slash",
		"position": position,
		"direction": slash_direction,
		"color": SLASH_COLOR,
		"time": SLASH_TRAIL_TIME,
		"total": SLASH_TRAIL_TIME,
		"screen_space": screen_space
	})
	_spawn_motion_burst(position + slash_direction * 24.0, SLASH_COLOR, 6, 56.0, 118.0, screen_space, "spark")


func _update_motion_effects(delta: float) -> void:
	for index in range(motion_effects.size() - 1, -1, -1):
		motion_effects[index]["time"] = float(motion_effects[index]["time"]) - delta
		if float(motion_effects[index]["time"]) <= 0.0:
			motion_effects.remove_at(index)
			continue
		if String(motion_effects[index].get("kind", "spark")) == "slash":
			continue
		var velocity: Vector2 = Vector2(motion_effects[index].get("velocity", Vector2.ZERO))
		motion_effects[index]["position"] = Vector2(motion_effects[index]["position"]) + velocity * delta
		motion_effects[index]["velocity"] = velocity * pow(0.045, delta)
		motion_effects[index]["rotation"] = float(motion_effects[index].get("rotation", 0.0)) + float(motion_effects[index].get("spin", 0.0)) * delta


func _draw_motion_effects() -> void:
	for effect in motion_effects:
		var total: float = maxf(0.001, float(effect.get("total", MOTION_SPARK_TIME)))
		var life_ratio: float = clampf(float(effect["time"]) / total, 0.0, 1.0)
		var progress: float = 1.0 - life_ratio
		var center: Vector2 = Vector2(effect["position"])
		if not bool(effect.get("screen_space", false)):
			center -= camera_position
		var effect_color: Color = Color(effect.get("color", Color.WHITE))
		var draw_color := Color(effect_color.r, effect_color.g, effect_color.b, effect_color.a * life_ratio)
		var kind: String = String(effect.get("kind", "spark"))
		if kind == "slash":
			var direction: Vector2 = Vector2(effect.get("direction", Vector2.RIGHT))
			var slash_angle: float = direction.angle()
			var radius: float = lerpf(22.0, 54.0, 1.0 - pow(1.0 - progress, 3.0))
			var sweep_center: float = slash_angle + lerpf(-0.82, 0.34, progress)
			draw_arc(center, radius, sweep_center - 0.72, sweep_center + 0.72, 18, draw_color, 6.0 * life_ratio + 1.0, true)
			draw_arc(center, radius - 7.0, sweep_center - 0.58, sweep_center + 0.58, 16, Color(1.0, 1.0, 0.92, 0.62 * life_ratio), 2.0, true)
			continue
		var size: float = float(effect.get("size", 2.0))
		if kind == "dust":
			draw_circle(center, size * lerpf(0.65, 1.8, progress), draw_color)
		else:
			var velocity: Vector2 = Vector2(effect.get("velocity", Vector2.ZERO))
			var tail: Vector2 = velocity.normalized() * minf(12.0, velocity.length() * 0.08) if velocity.length_squared() > 0.01 else Vector2.ZERO
			draw_line(center - tail, center + tail * 0.15, draw_color, maxf(1.0, size * life_ratio), true)


func _update_ui_motion(delta: float) -> void:
	if phase != ui_last_phase:
		ui_last_phase = phase
		if phase == Phase.MENU or phase == Phase.GAME_OVER:
			menu_title_stamp_elapsed = 0.0
	if team_intro_active:
		menu_title_stamp_elapsed = 0.0
	else:
		menu_title_stamp_elapsed += delta
	iris_open_timer = maxf(iris_open_timer - delta, 0.0)
	hp_flinch_timer = maxf(hp_flinch_timer - delta, 0.0)
	ui_panel_open_elapsed += delta
	_update_ui_stamps(delta)
	if title_label != null:
		# Player pick: the health number flinches (shakes and flashes red) on each hit.
		var flinch: float = hp_flinch_timer / UI_ANIM_TIME
		var shake_x: float = sin(hp_flinch_timer * 70.0) * 6.0 * flinch
		title_label.position = Vector2(60.0 + shake_x, 18.0)
		title_label.self_modulate = Color.WHITE.lerp(Color(1.0, 0.32, 0.30), flinch)
		if hud_heart_icon != null:
			hud_heart_icon.position = Vector2(24.0 + shake_x, 17.0)
			hud_heart_icon.scale = Vector2.ONE * (1.0 + 0.25 * flinch)
	if music_credit_panel != null and music_credit_panel.visible:
		# Song credit slides in from the right when a track starts and slides out before hiding.
		var shown_for: float = world_time - (music_credit_hide_at - MUSIC_CREDIT_TOAST_TIME)
		var left_in: float = music_credit_hide_at - world_time
		var slide: float = clampf(minf(shown_for, left_in) / UI_ANIM_TIME, 0.0, 1.0)
		var eased_slide: float = 1.0 - pow(1.0 - slide, 3.0)
		music_credit_panel.position.x = lerpf(SCREEN_SIZE.x + 8.0, 886.0, eased_slide)
	if menu_title_label != null and menu_title_label.visible:
		_apply_title_stamp(menu_title_label, menu_title_stamp_elapsed)


# Rubber-stamp slam: drops in large, overshoots small, then settles slightly tilted.
func _apply_title_stamp(label: Label, elapsed: float) -> void:
	label.pivot_offset = label.size * 0.5
	var t: float = clampf(elapsed / UI_STAMP_TIME, 0.0, 1.0)
	var scale_value: float
	if t < 0.55:
		scale_value = lerpf(2.6, 0.92, pow(t / 0.55, 2.2))
	else:
		scale_value = lerpf(0.92, 1.0, sin((t - 0.55) / 0.45 * PI * 0.5))
	label.scale = Vector2.ONE * scale_value
	label.rotation = lerpf(-0.11, -0.03, t)
	label.modulate.a = clampf(t / 0.3, 0.0, 1.0)
	if t >= 1.0 and elapsed - UI_STAMP_TIME < 0.18:
		var shake: float = (1.0 - (elapsed - UI_STAMP_TIME) / 0.18) * 3.0
		label.position.x = 72.0 + sin(elapsed * 90.0) * shake
	else:
		label.position.x = 72.0


func _start_iris_open() -> void:
	iris_open_timer = UI_IRIS_TIME


func _draw_iris_open() -> void:
	if iris_open_timer <= 0.0:
		return
	var t: float = 1.0 - iris_open_timer / UI_IRIS_TIME
	var eased: float = 1.0 - pow(1.0 - t, 3.0)
	var center: Vector2 = player_position - camera_position
	var outer: float = SCREEN_SIZE.length() + center.distance_to(SCREEN_SIZE * 0.5)
	var hole: float = lerpf(0.0, outer, eased)
	# A thick ring whose inner edge is the hole covers everything outside it.
	draw_arc(center, (hole + outer) * 0.5, 0.0, TAU, 96, Color.BLACK, outer - hole + 2.0, true)


func _draw_scene_transition() -> void:
	if phase_transition_timer <= 0.0 or iris_open_timer > 0.0:
		return
	var remaining: float = clampf(phase_transition_timer / PHASE_TRANSITION_TIME, 0.0, 1.0)
	var progress: float = 1.0 - remaining
	var eased_remaining: float = pow(remaining, 2.0)
	var tint := Color(phase_transition_color.r, phase_transition_color.g, phase_transition_color.b, 0.12 * eased_remaining)
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), tint, true)
	var bar_height: float = 42.0 * eased_remaining
	draw_rect(Rect2(Vector2.ZERO, Vector2(SCREEN_SIZE.x, bar_height)), Color(0.02, 0.03, 0.04, 0.78 * remaining), true)
	draw_rect(Rect2(Vector2(0, SCREEN_SIZE.y - bar_height), Vector2(SCREEN_SIZE.x, bar_height)), Color(0.02, 0.03, 0.04, 0.78 * remaining), true)
	var ring_radius: float = lerpf(24.0, 440.0, 1.0 - pow(1.0 - progress, 3.0))
	draw_arc(SCREEN_SIZE * 0.5, ring_radius, 0.0, TAU, 64, Color(phase_transition_color.r, phase_transition_color.g, phase_transition_color.b, 0.52 * remaining), 3.0, true)


func _find_enemy_index_by_id(enemy_id: int) -> int:
	for index in range(enemies.size()):
		if int(enemies[index]["id"]) == enemy_id:
			return index
	return -1


func _show_wave_banner_for(text: String, duration: float) -> void:
	wave_banner_text = text
	wave_banner_timer = duration
	wave_banner_duration = duration


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


func _make_atlas_texture(texture: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = region
	return atlas_texture


func _style_menu_art_button(button: Button, region: Rect2) -> void:
	if menu_ui_texture == null:
		_style_action_button(button, UI_WARM_ACCENT)
		return
	button.text = ""
	button.icon = _make_atlas_texture(menu_ui_texture, region)
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.add_theme_stylebox_override("normal", _make_flat_style(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0, 0))
	button.add_theme_stylebox_override("hover", _make_flat_style(Color(1, 1, 1, 0.10), Color(1.0, 0.90, 0.56, 0.72), 2, 8))
	button.add_theme_stylebox_override("pressed", _make_flat_style(Color(0, 0, 0, 0.18), Color(1.0, 0.84, 0.42, 0.88), 2, 8))
	button.add_theme_stylebox_override("focus", _make_flat_style(Color(1, 1, 1, 0.06), Color(0.70, 0.90, 1.0, 0.86), 2, 8))
	button.add_theme_stylebox_override("disabled", _make_flat_style(Color(0, 0, 0, 0.30), Color(1, 1, 1, 0.10), 1, 8))


# Player pick: Settings shares the in-game tax-form paper look.
func _paperize_settings_panel() -> void:
	if menu_settings_panel == null:
		return
	menu_settings_panel.color = UI_PAPER_FILL
	ui_paper_active = true
	var pending: Array[Node] = [menu_settings_panel]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		pending.append_array(node.get_children())
		if node is Label:
			var label := node as Label
			var label_color: Color = label.modulate * label.get_theme_color("font_color")
			label.modulate = Color.WHITE
			label.add_theme_color_override("font_color", _paper_ink(label_color))
			label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0))
		elif node is Panel:
			var card_style := (node as Panel).get_theme_stylebox("panel") as StyleBoxFlat
			if card_style != null:
				var paper_style := card_style.duplicate() as StyleBoxFlat
				paper_style.bg_color = UI_PAPER_CARD
				paper_style.border_color = Color(_paper_ink(Color(card_style.border_color, 1.0)), 0.7)
				(node as Panel).add_theme_stylebox_override("panel", paper_style)
	ui_paper_active = false


# Player pick: Pixelify Sans (SIL OFL, assets/fonts) for all UI text. Every Control and
# every draw_string call reads ThemeDB.fallback_font, so swapping it restyles both.
func _apply_ui_font() -> void:
	var pixel_font := load(UI_FONT_PATH) as FontFile
	if pixel_font == null:
		return
	var weighted := FontVariation.new()
	weighted.base_font = pixel_font
	var text_server := TextServerManager.get_primary_interface()
	weighted.variation_opentype = {text_server.name_to_tag("wght"): 500}
	# The font's "fi" ligature reads as a stray glyph at UI sizes.
	weighted.opentype_features = {text_server.name_to_tag("liga"): 0, text_server.name_to_tag("calt"): 0}
	# Silkscreen ships with wide built-in tracking; tighten it so existing layouts fit.
	weighted.spacing_glyph = -2
	weighted.spacing_space = -3
	ThemeDB.fallback_font = weighted
	# HUD Controls hang off this Node2D, so they never see a Window theme; they fall
	# back to the engine default theme instead.
	ThemeDB.get_default_theme().default_font = weighted


func _style_paper_checkbox(button: Button) -> void:
	for state in ["normal", "hover", "pressed", "focus"]:
		var style := _make_flat_style(UI_PAPER_FILL if state != "pressed" else UI_PAPER_FILL.darkened(0.06), UI_PAPER_INK if state != "focus" else UI_COOL_ACCENT, 2 if state != "focus" else 3, 3)
		style.shadow_color = Color(0, 0, 0, 0.45)
		style.shadow_size = 0
		style.shadow_offset = Vector2(0, 4)
		button.add_theme_stylebox_override(state, style)
	button.add_theme_stylebox_override("disabled", _make_flat_style(UI_PAPER_FILL.darkened(0.3), UI_PAPER_INK, 1, 3))
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(color_name, UI_PAPER_INK)
	button.add_theme_font_size_override("font_size", 19)


# Stack the plank buttons under the title once the help text is gone.
func _layout_menu_home(top_y: float, show_dev: bool) -> void:
	var y := top_y
	menu_start_button.position = Vector2(326, y)
	y += 70.0
	menu_settings_button.position = Vector2(326, y)
	y += 74.0
	if show_dev:
		menu_dev_button.position = Vector2(345, y)
		menu_dev_button.size = Vector2(262, 55)
		menu_dev_button.pivot_offset = menu_dev_button.size * 0.5
		y += 72.0
	menu_tutorial_button.position = Vector2(346, y + 6.0)
	menu_tutorial_button.size = Vector2(260, 44)


func _style_text_input(line_edit: LineEdit) -> void:
	line_edit.add_theme_stylebox_override("normal", _make_flat_style(Color(0.08, 0.10, 0.12, 0.96), UI_PANEL_BORDER, 2, 12))
	line_edit.add_theme_stylebox_override("focus", _make_flat_style(Color(0.10, 0.12, 0.15, 0.98), UI_WARM_ACCENT, 2, 12))
	line_edit.add_theme_color_override("font_color", TEXT_COLOR)
	line_edit.add_theme_color_override("font_placeholder_color", MUTED_TEXT_COLOR)
	line_edit.add_theme_color_override("caret_color", UI_WARM_ACCENT)


func _draw_ui_card(rect: Rect2, accent: Color = UI_PANEL_BORDER, fill: Color = UI_PANEL_FILL, border_width: float = 2.0, shadow_offset: Vector2 = Vector2(0, 8)) -> void:
	if ui_paper_active:
		var is_sheet: bool = rect.size.x >= 400.0 and rect.size.y >= 300.0
		var paper_shadow: Vector2 = shadow_offset if is_sheet else Vector2(0, minf(shadow_offset.y, 3.0))
		draw_rect(Rect2(rect.position + paper_shadow, rect.size), Color(0, 0, 0, 0.42 if is_sheet else 0.14), true)
		_prect(rect, fill, true)
		if rect.size.x >= 400.0 and rect.size.y >= 300.0:
			var line_y: float = rect.position.y + 30.0
			while line_y < rect.end.y - 6.0:
				_pline(Vector2(rect.position.x + 8, line_y), Vector2(rect.end.x - 8, line_y), Color(0.70, 0.62, 0.46, 0.28), 1.0)
				line_y += 24.0
		_prect(rect, accent, false, border_width)
		return
	draw_rect(Rect2(rect.position + shadow_offset, rect.size), UI_PANEL_SHADOW, true)
	draw_rect(rect, fill, true)
	draw_rect(rect, accent, false, border_width)


# Player pick: in-game panels look like tax-form paper. Panel code keeps its dark-UI
# colors; these helpers translate them to ink-on-paper while ui_paper_active is set.
func _paper_ink(color: Color) -> Color:
	if not ui_paper_active:
		return color
	if color.r > 0.9 and color.g > 0.9 and color.b > 0.9 and color.a < 0.4:
		return Color(UI_PAPER_INK, minf(color.a * 2.6, 0.55))
	if color.s < 0.28 and color.get_luminance() > 0.45:
		# Neutral light text becomes ink; dimmer neutrals become faded ink.
		return Color(UI_PAPER_INK if color.get_luminance() > 0.8 else UI_PAPER_MUTED, color.a)
	if color.get_luminance() > 0.45:
		return Color(color.darkened(0.6), color.a)
	return color


func _paper_fill(color: Color) -> Color:
	if not ui_paper_active or color.get_luminance() > 0.32 or color.a < 0.3:
		return _paper_ink(color)
	var tone: float = clampf(color.get_luminance() / 0.28, 0.0, 1.0)
	var paper: Color = UI_PAPER_CARD.lerp(UI_PAPER_FILL.darkened(0.10), tone)
	# Keep a hint of the original hue so owned/selected states still read.
	if color.s > 0.25:
		# Keep a hint of the original hue so owned/selected states still read.
		paper = paper.lerp(Color(color.r * 3.0, color.g * 3.0, color.b * 3.0).clamp(), 0.14)
	return Color(paper, maxf(color.a, 0.96))


func _pstr(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT, width: float = -1, font_size: int = 16, modulate: Color = Color.WHITE) -> void:
	draw_string(font, pos, text, alignment, width, font_size, _paper_ink(modulate))


func _pmstr(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT, width: float = -1, font_size: int = 16, max_lines: int = -1, modulate: Color = Color.WHITE) -> void:
	draw_multiline_string(font, pos, text, alignment, width, font_size, max_lines, _paper_ink(modulate))


func _prect(rect: Rect2, color: Color, filled: bool = true, width: float = -1.0) -> void:
	if filled:
		draw_rect(rect, _paper_fill(color), true)
	else:
		draw_rect(rect, _paper_ink(color), false, width)


func _pline(from: Vector2, to: Vector2, color: Color, width: float = -1.0, antialiased: bool = false) -> void:
	draw_line(from, to, _paper_ink(color), width, antialiased)


func _pxform(position: Vector2, rotation: float = 0.0, scale: Vector2 = Vector2.ONE) -> void:
	draw_set_transform_matrix(ui_panel_xform * Transform2D(rotation, scale, 0.0, position))


func _draw_paper_panels() -> void:
	var any_open: bool = dealer_menu_open or build_menu_open or inventory_menu_open
	if any_open and not ui_panel_was_open:
		ui_panel_open_elapsed = 0.0
	ui_panel_was_open = any_open
	if not any_open:
		return
	# Player pick: panels pop open with a small overshoot.
	var t: float = clampf(ui_panel_open_elapsed / UI_ANIM_TIME, 0.0, 1.0)
	var back: float = 1.70158
	var eased: float = 1.0 + (back + 1.0) * pow(t - 1.0, 3.0) + back * pow(t - 1.0, 2.0)
	var scale_value: float = lerpf(0.82, 1.0, eased)
	var pivot: Vector2 = SCREEN_SIZE * 0.5
	ui_panel_xform = Transform2D(0.0, Vector2.ONE * scale_value, 0.0, pivot - pivot * scale_value)
	ui_paper_active = true
	draw_set_transform_matrix(ui_panel_xform)
	_draw_dealer_menu()
	_draw_build_menu()
	_draw_inventory_menu()
	_draw_ui_stamps(true)
	ui_paper_active = false
	ui_panel_xform = Transform2D.IDENTITY
	draw_set_transform_matrix(Transform2D.IDENTITY)


func _add_ui_stamp(center: Vector2, text: String, world_space: bool) -> void:
	ui_stamps.append({"center": center, "text": text, "time": 0.0, "world": world_space})


func _update_ui_stamps(delta: float) -> void:
	for stamp in ui_stamps:
		stamp["time"] = float(stamp["time"]) + delta
	ui_stamps = ui_stamps.filter(func(stamp): return float(stamp["time"]) < UI_STAMP_LIFE)


func _draw_ui_stamps(panel_pass: bool) -> void:
	var font := ThemeDB.fallback_font
	for stamp in ui_stamps:
		if bool(stamp["world"]) == panel_pass:
			continue
		var t: float = float(stamp["time"])
		var slam: float = clampf(t / 0.12, 0.0, 1.0)
		var stamp_scale: float = lerpf(2.4, 1.0, 1.0 - pow(1.0 - slam, 3.0))
		var alpha: float = clampf((UI_STAMP_LIFE - t) / 0.25, 0.0, 1.0) * clampf(t / 0.05, 0.0, 1.0)
		var center: Vector2 = Vector2(stamp["center"])
		if bool(stamp["world"]):
			center -= camera_position
		var base := ui_panel_xform if panel_pass else Transform2D.IDENTITY
		draw_set_transform_matrix(base * Transform2D(-0.2, Vector2.ONE * stamp_scale, 0.0, center))
		var text: String = String(stamp["text"])
		var box := Rect2(Vector2(-58, -22), Vector2(116, 44))
		draw_rect(box, Color(UI_STAMP_RED, 0.14 * alpha), true)
		draw_rect(box, Color(UI_STAMP_RED, 0.92 * alpha), false, 3.0)
		draw_string(font, Vector2(-58, 10), text, HORIZONTAL_ALIGNMENT_CENTER, 116, 26, Color(UI_STAMP_RED, alpha))
	draw_set_transform_matrix(ui_panel_xform if panel_pass else Transform2D.IDENTITY)


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


func _using_controller_prompts() -> bool:
	return auto_control_prompts_enabled and last_input_device == "controller"


func _control_prompt(action: String, keyboard_fallback: String) -> String:
	if not _using_controller_prompts():
		return keyboard_fallback
	match action:
		"action":
			return "A"
		"build_arrow_turret":
			return "Y"
		"repair_wall":
			return "LB"
		"dealer_menu":
			return "RB"
		"inventory_menu":
			return "BACK"
		"enter_cave":
			return "X"
		"start_wave_early":
			return "START"
		_:
			return keyboard_fallback


func _is_swat_round() -> bool:
	return round_number >= SWAT_START_ROUND and round_number % SWAT_WAVE_FREQUENCY == 0


func _add_hit_effect(world_position: Vector2, text: String, color: Color) -> void:
	var is_damage_number := _is_damage_number_text(text)
	if is_damage_number and not damage_numbers_enabled:
		return
	hit_effects.append({
		"position": world_position,
		"offset": Vector2.ZERO,
		"text": text,
		"color": color,
		"time": 0.72 if is_damage_number else 0.55,
		"duration": 0.72 if is_damage_number else 0.55,
		"damage": is_damage_number
	})


func _is_damage_number_text(text: String) -> bool:
	if not text.begins_with("-") or text.length() <= 1:
		return false
	return text.substr(1).is_valid_int()


func _add_enemy_shot(start_position: Vector2, end_position: Vector2) -> void:
	enemy_shots.append({
		"start": start_position,
		"end": end_position,
		"time": 0.14
	})


func _enemy_center(enemy: Dictionary) -> Vector2:
	return Vector2(enemy["position"]) + Vector2(enemy["size"]) * 0.5


func _side_spawn_position(lane: String, enemy_size: Vector2) -> Vector2:
	var spawn_row: int = _simulation_randi_range(SIDE_SPAWN_ROW_RANGE.x, SIDE_SPAWN_ROW_RANGE.y)
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


func _draw_world_callouts() -> void:
	if phase != Phase.BUILD or inside_house or inside_cave or dealer_menu_open or build_menu_open or inventory_menu_open or escape_confirm_open:
		return
	var tutorial_round: bool = round_number <= 2
	var help_active: bool = tutorial_round or house_damage_stage > 0 or _is_player_near_dealer_stand() or _is_player_near_cave_entrance()
	if not help_active:
		return
	if tutorial_round and not tutorial_moved:
		_draw_world_callout(_cell_center(HOUSE_CELL) + Vector2(-142, -22), "House\nProtect this", Color(0.98, 0.88, 0.70, 0.96))
	elif tutorial_round and tutorial_got_wood and tutorial_got_stone and not tutorial_built_once:
		_draw_world_callout(_cell_center(Vector2i(6, 5)) + Vector2(0, -12), "Outlined yard\nBuild here", Color(0.72, 0.90, 1.0, 0.92))
	if not tutorial_opened_dealer and _is_player_near_dealer_stand():
		_draw_world_callout(_cell_center(DEALER_STAND_CELL) + Vector2(0, -58), "Dealer\nAmmo, buffs, buying, selling", Color(0.98, 0.84, 0.48, 0.96))
	if not tutorial_entered_cave and _is_player_near_cave_entrance():
		_draw_world_callout(_cell_center(CAVE_ENTRANCE_CELL) + Vector2(0, -58), "Cave\nRare loot and upgrades", Color(0.78, 0.72, 1.0, 0.96))
	if house_damage_stage > 0 and not tutorial_repaired_house:
		_draw_world_callout(_cell_center(HOUSE_CELL) + Vector2(82, -20), "Repair here", Color(0.74, 0.98, 0.74, 0.96))
	var wood_label_drawn: bool = false
	var stone_label_drawn: bool = false
	for node in resource_nodes:
		if not tutorial_round or not tutorial_moved or (tutorial_got_wood and tutorial_got_stone):
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


func _draw_house() -> void:
	var house_rect := Rect2(_cell_center(HOUSE_CELL) - Vector2(44, 34), Vector2(88, 68))
	# The house art is a Sprite2D in $WorldSpriteLayer. The damage overlay and
	# repair marker below are procedural, so they stay on this canvas item.
	var current_texture := _current_house_texture()
	if current_texture == null:
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
	if house_damage_stage <= 0:
		return house_texture
	if house_damage_stage == 1:
		return house_broken_1_texture
	return house_broken_2_texture


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
		var harvest_jitter := Vector2.ZERO
		if index == harvesting_node_index:
			var harvest_intensity: float = 0.45 + 0.55 * clampf(harvest_timer / maxf(0.01, _current_gather_time()), 0.0, 1.0)
			harvest_jitter = Vector2(sin(world_time * 42.0), cos(world_time * 33.0) * 0.45) * 2.6 * harvest_intensity
		# Tree, trunk and rock art are Sprite2D nodes in $WorldSpriteLayer now.
		# What stays here is the no-texture fallback plus the charge pips and
		# harvest readout, which are procedural shapes rather than sprites.
		if node_kind == "wood":
			var wood_has_sprite: bool = (forest_tree_texture != null and int(node["remaining"]) > 0) or tree_trunk_texture != null
			if not wood_has_sprite:
				var trunk := Rect2(_cell_to_world(node["cell"]) + Vector2(20, 24), Vector2(8, 18))
				var leaves_color := node_color if int(node["remaining"]) > 0 else Color(0.31, 0.34, 0.26)
				var leaves := Rect2(_cell_to_world(node["cell"]) + Vector2(6, 2), Vector2(36, 28))
				_draw_world_rect(trunk, Color(0.38, 0.24, 0.16))
				_draw_world_rect(leaves, leaves_color)
				if int(node["remaining"]) <= 0:
					_draw_world_rect(Rect2(_cell_to_world(node["cell"]) + Vector2(14, 30), Vector2(20, 10)), Color(0.42, 0.30, 0.18))
		else:
			var rock_variant := (node_cell.x + node_cell.y) % 3
			var rock_has_sprite: bool = (
				(rock_variant == 0 and rock_big_texture != null)
				or (rock_variant == 1 and rock_medium_texture != null)
				or rock_small_texture != null
			)
			if not rock_has_sprite:
				_draw_world_rect(node_rect, node_color)
		var charges := int(node["remaining"])
		for pip in range(charges):
			_draw_world_rect(Rect2(node_rect.position + Vector2(4 + pip * 6, -8), Vector2(4, 4)), node_color.lightened(0.2))
		if index == harvesting_node_index:
			var progress := harvest_timer / _current_gather_time()
			draw_rect(Rect2(node_rect.position - camera_position + Vector2(0, -14), Vector2(36 * progress, 5)), node_color.lightened(0.35), true)
			draw_rect(Rect2(node_rect.position - camera_position + Vector2(-2, -2), node_rect.size + Vector2(4, 4)), Color(1, 1, 1, 0.65), false, 2.0)
	# The cave mouth art is a Sprite2D in $WorldSpriteLayer; this is its fallback.
	var cave_rect := Rect2(_cell_to_world(CAVE_ENTRANCE_CELL) + Vector2(2, 2), Vector2(44, 44))
	if cave_entrance_texture == null:
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
		# $WorldSpriteLayer owns the animal sprite, its sway, bob, facing flip
		# and its ground shadow. Only the no-texture fallback is drawn here.
		if animal_texture != null:
			continue
		var animal_size: Vector2 = _forest_animal_draw_size(animal_kind)
		var animal_draw_rect: Rect2 = Rect2(animal_position + Vector2(-animal_size.x * 0.5, -animal_size.y + 8.0), animal_size)
		var shadow_rect: Rect2 = Rect2(animal_position + Vector2(-animal_size.x * 0.28, 6.0), Vector2(animal_size.x * 0.56, 12.0))
		draw_rect(Rect2(shadow_rect.position - camera_position, shadow_rect.size), Color(0.02, 0.03, 0.04, 0.18), true)
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
					var construction_pulse: float = 0.5 + 0.5 * sin(world_time * 9.0 + float(cell.x + cell.y))
					var construction_radius: float = lerpf(22.0, 13.0, build_progress) + construction_pulse * 2.0
					draw_circle(turret_center + Vector2(0, 10), construction_radius, Color(UI_COOL_ACCENT.r, UI_COOL_ACCENT.g, UI_COOL_ACCENT.b, 0.08 + construction_pulse * 0.06))
					draw_arc(turret_center + Vector2(0, 4), construction_radius, -PI * 0.5, -PI * 0.5 + TAU * build_progress, 24, Color(UI_COOL_ACCENT.r, UI_COOL_ACCENT.g, UI_COOL_ACCENT.b, 0.74), 3.0, true)
					var scaffold_height: float = lerpf(4.0, 28.0, build_progress)
					draw_line(turret_center + Vector2(-12, 16), turret_center + Vector2(-12, 16 - scaffold_height), Color(0.78, 0.70, 0.48, 0.80), 3.0)
					draw_line(turret_center + Vector2(12, 16), turret_center + Vector2(12, 16 - scaffold_height), Color(0.78, 0.70, 0.48, 0.80), 3.0)
					draw_line(turret_center + Vector2(-14, 6), turret_center + Vector2(14, -2), Color(0.94, 0.84, 0.54, 0.64), 2.0)
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
				if bool(structure.get("has_target", false)) and (cell == selected_cell or dev_mode_enabled):
					var target_index: int = _find_enemy_index_by_id(int(structure.get("target_id", -1)))
					if target_index != -1:
						var locked_center: Vector2 = _enemy_center(enemies[target_index]) - camera_position
						var lock_color: Color = Color(_turret_projectile_color(structure), 0.38)
						draw_dashed_line(turret_center + aim_direction * 20.0, locked_center, lock_color, 1.5, 8.0, true)
						draw_arc(locked_center, 10.0 + absf(sin(world_time * 5.0)) * 2.0, 0.0, TAU, 16, Color(lock_color.r, lock_color.g, lock_color.b, 0.72), 2.0, true)
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
		var corpse_draw_rect := Rect2(corpse_pos + corpse_size * 0.5 - IRS_BRUTE_DEATH_DRAW_SIZE * 0.5 - camera_position, IRS_BRUTE_DEATH_DRAW_SIZE)
		if corpse_texture != null:
			draw_texture_rect_region(corpse_texture, corpse_draw_rect, IRS_ROBOT_DEATH_REGION, Color(1, 1, 1, corpse_alpha))
		else:
			draw_rect(corpse_draw_rect, Color(0.42, 0.12, 0.14, corpse_alpha), true)
	var dev_note_count := 0
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
			draw_texture_rect_region(
				_current_robot_walk_texture(),
				enemy_draw_rect,
				IRS_ROBOT_WALK_REGION
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
		if dev_mode_enabled:
			var center_on_screen: Vector2 = _enemy_center(enemy) - camera_position
			var on_screen: bool = Rect2(Vector2(-80, -80), SCREEN_SIZE + Vector2(160, 160)).has_point(center_on_screen)
			var show_note: bool = on_screen and dev_note_count < 8
			_draw_enemy_dev_plan(enemy, show_note)
			if show_note:
				dev_note_count += 1


func _draw_enemy_dev_plan(enemy: Dictionary, show_note: bool) -> void:
	var enemy_center: Vector2 = _enemy_center(enemy) - camera_position
	var planned_nodes: Array = Array(enemy.get("ai_nodes", []))
	var node_index: int = clampi(int(enemy.get("ai_node_index", 0)), 0, planned_nodes.size())
	var previous_point: Vector2 = enemy_center
	for plan_index in range(node_index, planned_nodes.size()):
		var node_point: Vector2 = Vector2(planned_nodes[plan_index]) - camera_position
		var is_final: bool = plan_index == planned_nodes.size() - 1
		var node_color: Color = Color(1.0, 0.42, 0.34, 0.82) if is_final else Color(0.36, 0.92, 1.0, 0.72)
		draw_dashed_line(previous_point, node_point, Color(node_color.r, node_color.g, node_color.b, 0.48), 1.5, 7.0, true)
		draw_circle(node_point, 7.0 if is_final else 5.0, Color(0.03, 0.06, 0.08, 0.92))
		draw_arc(node_point, 7.0 if is_final else 5.0, 0.0, TAU, 12, node_color, 2.0, true)
		draw_string(ThemeDB.fallback_font, node_point + Vector2(8, 4), str(plan_index + 1), HORIZONTAL_ALIGNMENT_LEFT, 18, 11, node_color)
		previous_point = node_point
	if not show_note:
		return
	var note_size := Vector2(278, 42)
	var note_position := enemy_center + Vector2(-note_size.x * 0.5, -72.0)
	note_position.x = clampf(note_position.x, 8.0, SCREEN_SIZE.x - note_size.x - 8.0)
	note_position.y = clampf(note_position.y, 8.0, SCREEN_SIZE.y - note_size.y - 8.0)
	var note_rect := Rect2(note_position, note_size)
	draw_rect(Rect2(note_rect.position + Vector2(3, 4), note_rect.size), Color(0, 0, 0, 0.36), true)
	draw_rect(note_rect, Color(0.03, 0.06, 0.08, 0.90), true)
	draw_rect(note_rect, MAGIC_COLOR, false, 1.5)
	var role_text: String = "%s #%d" % [String(enemy.get("role", "agent")).to_upper(), int(enemy.get("id", 0))]
	draw_string(ThemeDB.fallback_font, note_rect.position + Vector2(8, 15), role_text, HORIZONTAL_ALIGNMENT_LEFT, 90, 12, MAGIC_COLOR)
	draw_string(ThemeDB.fallback_font, note_rect.position + Vector2(8, 33), String(enemy.get("ai_thought", "Calculating...")), HORIZONTAL_ALIGNMENT_LEFT, 260, 12, TEXT_COLOR)


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
			if projectile_kind == "cannonball":
				projectile_rotation += float(projectile.get("flight_progress", 0.0)) * TAU * 2.4
			var projectile_pulse: float = 1.0
			if projectile_kind == "laser":
				projectile_pulse = 0.92 + absf(sin(world_time * 24.0)) * 0.14
			draw_set_transform(projectile_position, projectile_rotation, Vector2.ONE)
			draw_texture_rect(
				projectile_texture,
				Rect2(-projectile_size * projectile_pulse * 0.5, projectile_size * projectile_pulse),
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
		var progress: float = 1.0 - alpha
		var ring_radius: float = effect_radius * (0.42 + (1.0 - pow(1.0 - progress, 3.0)) * 0.86)
		var center: Vector2 = world_position
		if not bool(effect.get("screen_space", false)):
			center -= camera_position
		var effect_color: Color = Color(effect.get("color", UI_WARM_ACCENT))
		var hot_color: Color = effect_color.lightened(0.42)
		draw_circle(center, ring_radius * 0.42, Color(effect_color.r, effect_color.g, effect_color.b, 0.18 * alpha))
		draw_circle(center, ring_radius * 0.20, Color(hot_color.r, hot_color.g, hot_color.b, 0.28 * alpha))
		draw_arc(center, ring_radius, 0.0, TAU, 24, Color(effect_color.r, effect_color.g, effect_color.b, 0.95 * alpha), 4.0 + alpha * 2.0, true)
		draw_arc(center, ring_radius * 0.58, 0.0, TAU, 20, Color(hot_color.r, hot_color.g, hot_color.b, 0.74 * alpha), 3.0, true)
		for spark_index in range(8):
			var spark_angle: float = float(spark_index) / 8.0 * TAU + world_position.x * 0.01
			var spark_start: Vector2 = center + Vector2.RIGHT.rotated(spark_angle) * ring_radius * 0.24
			var spark_end: Vector2 = center + Vector2.RIGHT.rotated(spark_angle) * ring_radius * (0.82 + 0.12 * alpha)
			draw_line(spark_start, spark_end, Color(hot_color.r, hot_color.g, hot_color.b, 0.54 * alpha), 2.0)


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
		var shot_progress: float = 1.0 - shot_alpha
		var start_pos: Vector2 = Vector2(shot["start"]) - camera_position
		var end_pos: Vector2 = Vector2(shot["end"]) - camera_position
		var tracer_end: Vector2 = start_pos.lerp(end_pos, minf(1.0, shot_progress * 4.0))
		draw_line(start_pos, tracer_end, Color(1.0, 0.54, 0.18, shot_alpha * 0.36), 6.0)
		draw_line(start_pos, tracer_end, Color(1.0, 0.96, 0.66, shot_alpha), 2.0)
		draw_circle(start_pos, 4.0 + shot_alpha * 5.0, Color(1.0, 0.78, 0.24, shot_alpha * 0.72))
		if shot_progress > 0.62:
			var impact_alpha: float = clampf((shot_progress - 0.62) / 0.38, 0.0, 1.0) * shot_alpha
			draw_circle(end_pos, 8.0 + shot_progress * 5.0, Color(1.0, 0.64, 0.24, impact_alpha * 0.34))


func _draw_gather_effects() -> void:
	for effect in gather_effects:
		var effect_position: Vector2 = Vector2(effect["position"]) + Vector2(effect["offset"]) - camera_position
		var effect_alpha: float = clamp(float(effect["time"]) / 0.65, 0.0, 1.0)
		var gather_progress: float = 1.0 - effect_alpha
		var gather_scale: float = 0.72 + (1.0 - pow(1.0 - minf(gather_progress * 3.2, 1.0), 3.0)) * 0.28 + sin(minf(gather_progress * 3.0, 1.0) * PI) * 0.12
		var effect_color: Color = Color(effect.get("color", TEXT_COLOR))
		draw_set_transform(effect_position, 0.0, Vector2.ONE * gather_scale)
		draw_string(ThemeDB.fallback_font, Vector2(2, 2), String(effect["text"]), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.02, 0.03, 0.04, effect_alpha * 0.72))
		draw_string(
			ThemeDB.fallback_font,
			Vector2.ZERO,
			String(effect["text"]),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			16,
			Color(effect_color.r, effect_color.g, effect_color.b, effect_alpha)
		)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


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


func _draw_energy_drink_status() -> void:
	if energy_drink_timer <= 0.0 or phase == Phase.MENU or phase == Phase.GAME_OVER or dealer_menu_open or inventory_menu_open:
		return
	var badge_rect := Rect2(Vector2(18, 58), Vector2(156, 46))
	_draw_ui_card(badge_rect, Color(0.86, 0.82, 0.24), Color(0.08, 0.08, 0.16, 0.90), 2.0, Vector2(0, 3))
	if energy_drink_texture != null:
		draw_texture_rect(energy_drink_texture, Rect2(badge_rect.position + Vector2(8, 5), Vector2(28, 36)), false)
	draw_string(ThemeDB.fallback_font, badge_rect.position + Vector2(44, 29), "ENERGY  %ds" % ceili(energy_drink_timer), HORIZONTAL_ALIGNMENT_LEFT, 102, 16, Color(1.0, 0.96, 0.52))


func _draw_danger_overlay() -> void:
	if phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	if hp_flinch_timer > 0.0:
		var flash: float = hp_flinch_timer / UI_ANIM_TIME
		for band in range(4):
			var inset: float = band * 14.0
			draw_rect(Rect2(Vector2(inset, inset), SCREEN_SIZE - Vector2(inset, inset) * 2.0), Color(0.86, 0.08, 0.08, 0.34 * flash * (1.0 - band * 0.24)), false, 14.0)
	if not low_health_warning_enabled and not _is_boss_encounter_locked():
		return
	var max_hp_total: int = PLAYER_MAX_HP + _extra_player_max_hp()
	if max_hp_total <= 0:
		return
	var hp_ratio: float = clampf(float(player_hp) / float(max_hp_total), 0.0, 1.0)
	if hp_ratio > 0.45 and not _is_boss_encounter_locked():
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
		var effect_duration: float = float(effect.get("duration", 0.55))
		var is_damage_number: bool = bool(effect.get("damage", false))
		var hit_alpha: float = clamp(float(effect["time"]) / effect_duration, 0.0, 1.0)
		var hit_progress: float = 1.0 - hit_alpha
		var pop_in: float = minf(hit_progress * 5.0, 1.0)
		var hit_scale: float = 0.62 + (1.0 - pow(1.0 - pop_in, 3.0)) * 0.38 + sin(pop_in * PI) * (0.34 if is_damage_number else 0.22)
		var font_size: int = 18
		var hit_rotation: float = -0.035 + hit_progress * 0.035
		var effect_text: String = String(effect["text"])
		if is_damage_number:
			# Player pick: chunky tilted numbers; big hits slam in larger and red.
			var is_crit: bool = absi(effect_text.to_int()) >= DAMAGE_CRIT_THRESHOLD
			var slam: float = clampf(hit_progress / 0.12, 0.0, 1.0)
			hit_scale = lerpf(2.2 if is_crit else 1.7, 1.0, 1.0 - pow(1.0 - slam, 3.0))
			hit_rotation = -0.14
			font_size = 40 if is_crit else 30
			if is_crit:
				effect_color = Color(1.0, 0.36, 0.28)
				if not effect_text.ends_with("!"):
					effect_text += "!"
		draw_set_transform(effect_position, hit_rotation, Vector2.ONE * hit_scale)
		var shadow_offsets: Array[Vector2] = []
		if is_damage_number:
			shadow_offsets.assign([Vector2(-3, 0), Vector2(3, 0), Vector2(0, -3), Vector2(0, 3), Vector2(2, 4), Vector2(-2, 4)])
		else:
			shadow_offsets.append(Vector2(2, 2))
		for shadow_offset in shadow_offsets:
			draw_string(ThemeDB.fallback_font, shadow_offset, effect_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.02, 0.02, 0.03, hit_alpha * 0.90))
		draw_string(
			ThemeDB.fallback_font,
			Vector2.ZERO,
			effect_text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			font_size,
			Color(effect_color.r, effect_color.g, effect_color.b, hit_alpha)
		)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


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
	if player_swing_timer > 0.0 and (player_sword_sprite == null or player_visual_node == null or not player_visual_node.visible):
		_draw_sword_swing_fallback(player_center)


func _draw_sword_swing_fallback(player_center: Vector2) -> void:
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
	var swing_angle: float = strike_angle + PI * 0.5
	if player_sword_texture != null:
		draw_set_transform(swing_position, swing_angle, Vector2.ONE)
		draw_texture_rect(
			player_sword_texture,
			Rect2(Vector2(-PLAYER_SWORD_DRAW_SIZE.x * 0.5, -PLAYER_SWORD_DRAW_SIZE.y), PLAYER_SWORD_DRAW_SIZE),
			false
		)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_line(hand_anchor, swing_position, SLASH_COLOR, 5.0)


func _load_art_assets() -> void:
	player_body_texture = _load_texture("res://Art/Bob with no stuff.png")
	player_idle_left_1_texture = _load_texture("res://assets/runtime/bob_idle_left_1.png")
	player_idle_left_2_texture = _load_texture("res://assets/runtime/bob_idle_left_2.png")
	player_idle_right_1_texture = _load_texture("res://assets/runtime/bob_idle_right_1.png")
	player_idle_right_2_texture = _load_texture("res://assets/runtime/bob_idle_right_2.png")
	player_run_1_texture = _load_texture("res://assets/runtime/bob_run_1.png")
	player_run_2_texture = _load_texture("res://assets/runtime/bob_run_2.png")
	player_run_3_texture = _load_texture("res://assets/runtime/bob_run_3.png")
	player_run_4_texture = _load_texture("res://assets/runtime/bob_run_4.png")
	player_run_5_texture = _load_texture("res://assets/runtime/bob_run_5.png")
	team_logo_texture = _load_texture("res://assets/team_logo.png")
	turret_sprite_texture = _load_texture("res://Art/cross bow.png")
	cannon_turret_texture = _load_texture("res://Art/Canon.png")
	golden_turret_texture = _load_texture("res://Art/golden minigun.png")
	# Cut both sentries directly from their original complete artwork. Keeping the
	# source alpha preserves the black pixel-art outlines around every component.
	gun_sentry_top_texture = _load_texture("res://assets/runtime/gun_sentry_head.png")
	gun_sentry_bottom_texture = _load_texture("res://assets/runtime/gun_sentry_base.png")
	majestic_sentry_top_texture = _load_texture("res://assets/runtime/magic_sentry_head.png")
	majestic_sentry_bottom_texture = _load_texture("res://assets/runtime/magic_sentry_base.png")
	arrow_projectile_texture = _load_texture("res://Art/Arrow Projectile.png")
	cannonball_projectile_texture = _load_texture("res://Art/Cannon ball Projectile.png")
	healing_fountain_texture = _load_texture("res://Art/Healing fountain-1.png.png")
	crystal_sentry_texture = _load_texture("res://Art/lazer shooting thingy.png")
	laser_projectile_texture = _load_texture("res://Art/Lazer Projectile.png")
	arms_dealer_texture = _load_texture("res://assets/runtime/arms_dealer.png")
	energy_drink_texture = _load_texture("res://assets/runtime/energy_drink.png")
	menu_background_texture = _load_texture("res://assets/runtime/menu_background.png")
	menu_background_frames.clear()
	for menu_frame_index in range(1, 6):
		var menu_frame := _load_texture("res://assets/runtime/menu_background_frame_%d.png" % menu_frame_index)
		if menu_frame != null:
			menu_background_frames.append(menu_frame)
	menu_ui_texture = _load_texture("res://Art/Ui(menu screen).png")
	# Already has an alpha channel, so no chroma key: keying black out here would
	# erase the artwork's outlines.
	loss_screen_texture = _load_first_existing_texture([
		"res://Art/Death screen.png"
	])
	backyard_fence_texture = _load_texture("res://Art/Fence 1-1.png.png")
	cave_boss_texture = _load_texture("res://Art/Bony Spider Boss-1.png.png")
	cave_boss_walk_1_texture = _load_texture("res://Art/Spider walking 1-1.png.png")
	cave_boss_walk_2_texture = _load_texture("res://Art/Spider walking 2-2.png.png")
	cave_boss_walk_3_texture = _load_texture("res://Art/Spider walking 3-3.png.png")
	cave_boss_attack_texture = _load_first_existing_texture([
		"res://Art/Boss attack 1.png",
		"res://Art/Boss attack 1.png.png",
		"res://Art/boss attack 1.png",
		"res://Art/boss attack 1.png.png",
		"res://Art/Bony Spider Boss attack 1.png",
		"res://Art/Bony Spider Boss attack 1.png.png",
		"res://Art/Bony Spider Attack 1.png",
		"res://Art/Bony Spider Attack 1.png.png"
	])
	cave_boss_slam_frames.clear()
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 1-1.png.png"))
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 2-2.png.png"))
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 3-3.png.png"))
	cave_boss_slam_frames.append(_load_texture("res://Art/Spider attack 2 4-4.png.png"))
	falling_rock_frames.clear()
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 1-1.png.png"))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 2-2.png.png"))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 3-3.png.png"))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 4-4.png.png"))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 5-5.png.png"))
	falling_rock_frames.append(_load_texture("res://Art/Falling Rock 6-6.png.png"))
	decor_sprite_texture = _load_texture("res://Art/devils tree (1).png")
	forest_tree_texture = _load_texture("res://Art/tree.png")
	forest_dog_texture = _load_texture("res://Art/Cutie Patootie Doggie-1.png.png")
	forest_beaver_texture = _load_texture("res://Art/Cutie Patootie Beaver-2.png.png")
	tree_trunk_texture = _load_texture("res://Art/tree trunk-1.png.png")
	irs_robot_texture = _load_texture("res://Art/IRS ROBOT 1.png")
	irs_robot_walk_1_texture = _load_texture("res://Art/Robot moving 1-1.png.png")
	irs_robot_walk_2_texture = _load_texture("res://Art/Robot moving 2-2.png.png")
	irs_robot_walk_3_texture = _load_texture("res://Art/Robot moving 3-3.png.png")
	irs_robot_death_1_texture = _load_texture("res://Art/Robot Death 1-1.png.png")
	irs_robot_death_2_texture = _load_texture("res://Art/Robot Death 2-2.png.png")
	irs_robot_death_3_texture = _load_texture("res://Art/Robot Death 3-3.png.png")
	irs_agent_body_texture = _load_texture("res://Art/irs enemy 2.png")
	irs_agent_gun_texture = _load_texture("res://Art/irs enemy 2 gun.png")
	swat_texture = _load_first_existing_texture([
		"res://Art/irs enemy 2.png",
		"res://Art/irs enemy_2 run.png"
	])
	irs_agent_run_1_texture = _load_texture("res://assets/runtime/irs_runner_1.png")
	irs_agent_run_2_texture = _load_texture("res://assets/runtime/irs_runner_2.png")
	irs_agent_run_3_texture = _load_texture("res://assets/runtime/irs_runner_3.png")
	irs_agent_run_4_texture = _load_texture("res://assets/runtime/irs_runner_4.png")
	irs_agent_run_5_texture = _load_texture("res://assets/runtime/irs_runner_5.png")
	irs_agent_run_6_texture = _load_texture("res://assets/runtime/irs_runner_6.png")
	irs_agent_run_7_texture = _load_texture("res://assets/runtime/irs_runner_7.png")
	rock_big_texture = _load_texture("res://Art/Big rock.png")
	rock_medium_texture = _load_texture("res://Art/Medium rock.png")
	rock_small_texture = _load_texture("res://Art/Small rock.png")
	iron_ore_texture = _load_texture("res://Art/Iron ore.png")
	gold_ore_texture = _load_texture("res://Art/Gold ore.png")
	gunpowder_ore_texture = _load_texture("res://Art/Gun powder ore.png")
	cave_miner_walk_1_texture = _load_texture("res://Art/miner walking 1-1.png.png")
	cave_miner_walk_2_texture = _load_texture("res://Art/miner walking 2-2.png.png")
	cave_miner_walk_3_texture = _load_texture("res://Art/miner walking 3-3.png.png")
	cave_miner_death_1_texture = _load_texture("res://Art/Miner death 1-1.png.png")
	cave_miner_death_2_texture = _load_texture("res://Art/Miner death 2-2.png.png")
	cave_miner_death_3_texture = _load_texture("res://Art/Miner death 3-3.png.png")
	cave_miner_shovel_texture = _load_texture("res://Art/Miners shovel_weapon.png")
	cave_entrance_texture = _load_texture("res://Art/Cave Entrance.png")
	wrench_texture = _load_first_existing_texture(["res://Art/Wrench.png", "res://assets/wrench.png"])
	player_sword_texture = _load_texture("res://assets/runtime/bob_sword.png")
	shield_left_idle_texture = _load_texture("res://assets/runtime/shield_left_idle.png")
	shield_left_block_texture = _load_texture("res://assets/runtime/shield_left_block.png")
	shield_right_idle_texture = _load_texture("res://assets/runtime/shield_right_idle.png")
	shield_right_block_texture = _load_texture("res://assets/runtime/shield_right_block.png")
	house_texture = _load_texture("res://assets/runtime/house.png")
	house_broken_1_texture = _load_texture("res://assets/runtime/house_damaged.png")
	house_broken_2_texture = _load_texture("res://assets/runtime/house_breached.png")
	gun_turret_texture = _load_texture("res://Art/gun go pew pew.png")
	grass_tile_texture = _load_texture("res://Art/grass tile.png")
	wall_light_texture = _load_texture("res://Art/Cheap wall.png")
	wall_medium_texture = _load_texture("res://Art/stone wall.png")
	wall_heavy_texture = _load_texture("res://Art/Iron wall.png")
	countdown_numbers_texture = _load_texture("res://Art/numbers (1).png")
	heart_icon_texture = _load_texture("res://Art/Heart.png")
	inventory_icon_texture = _load_texture("res://Art/Inventory icon-2.png.png")
	inventory_full_icon_texture = _load_texture("res://Art/Inventory full icon-3.png.png")
	tax_papers_texture = _load_texture("res://Art/Tax Papers.png")
	mug_texture = _load_texture("res://Art/Best dad mug.png")
	trophy_texture = _load_texture("res://Art/gold trophy.png")
	couch_coins_texture = _load_texture("res://Art/Couch with coins.png")
	kfz_console_texture = _load_texture("res://Art/kfz console air fryer.png")
	family_photo_texture = _load_texture("res://Art/Family photo.png")
	crossbow_sound = load("res://Audio/sfx/384919__ali_6868__crossbow-firing-and-hitting-target.wav") as AudioStream
	gunshot_sound = load("res://Audio/sfx/128296__xenonn__layered-gunshot-0.wav") as AudioStream
	explosion_sound = load("res://Audio/sfx/110115__ryansnook__small-explosion.wav") as AudioStream
	menu_music_stream = load("res://Audio/music/1497951_I-miss-you.mp3") as AudioStream
	if menu_music_stream is AudioStreamMP3:
		(menu_music_stream as AudioStreamMP3).loop = false
	gameplay_music_streams.clear()
	for gameplay_music_path in [
		"res://Audio/music/1517909_A-risky-trek.mp3",
		"res://Audio/music/1530823_Sovietico-amp-Vista-Sounds.mp3",
		"res://Audio/music/1525368_we-all-lain.mp3"
	]:
		var gameplay_stream := load(gameplay_music_path) as AudioStream
		if gameplay_stream != null:
			if gameplay_stream is AudioStreamMP3:
				(gameplay_stream as AudioStreamMP3).loop = false
			gameplay_music_streams.append(gameplay_stream)
	cave_music_stream = load("res://Audio/music/1593618_Betrayal.mp3") as AudioStream
	boss_music_stream = load("res://Audio/music/1598849_a-quotbreakcorequot-song.mp3") as AudioStream


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_begin_graceful_shutdown()


func _begin_graceful_shutdown() -> void:
	if graceful_shutdown_started:
		return
	graceful_shutdown_started = true
	set_process(false)
	_release_audio_streams()
	call_deferred("_finish_graceful_shutdown")


func _run_standalone_smoke_exit() -> void:
	for _smoke_frame in range(180):
		await get_tree().process_frame
	_begin_graceful_shutdown()


func _finish_graceful_shutdown() -> void:
	for _audio_release_frame in range(6):
		await get_tree().process_frame
	get_tree().quit()


func _release_audio_streams() -> void:
	if team_intro_video != null and is_instance_valid(team_intro_video):
		team_intro_video.stop()
		team_intro_video.stream = null
	var music_players: Array[AudioStreamPlayer] = [
		menu_music_player,
		gameplay_music_player,
		cave_music_player,
		boss_music_player
	]
	for player in music_players:
		if player != null and is_instance_valid(player):
			player.stop()
			player.stream = null
	for player in sfx_players:
		if is_instance_valid(player):
			player.stop()
			player.stream = null
	gameplay_music_streams.clear()
	menu_music_stream = null
	cave_music_stream = null
	boss_music_stream = null


func _exit_tree() -> void:
	_release_audio_streams()
	crossbow_sound = null
	gunshot_sound = null
	explosion_sound = null
	ui_click_sound = null
	ui_hover_sound = null
	pickup_sound = null
	build_sound = null
	warning_sound = null
	impact_sound = null
	step_grass_sound = null
	step_wood_sound = null
	step_cave_sound = null
	if created_menu_music_bus:
		var current_menu_bus_index: int = AudioServer.get_bus_index(MENU_MUSIC_BUS_NAME)
		if current_menu_bus_index != -1:
			while AudioServer.get_bus_effect_count(current_menu_bus_index) > 0:
				AudioServer.remove_bus_effect(current_menu_bus_index, AudioServer.get_bus_effect_count(current_menu_bus_index) - 1)
	if created_sfx_bus:
		var current_sfx_bus_index: int = AudioServer.get_bus_index(SFX_BUS_NAME)
		if current_sfx_bus_index > 0:
			AudioServer.remove_bus(current_sfx_bus_index)
	if created_menu_music_bus:
		var removable_menu_bus_index: int = AudioServer.get_bus_index(MENU_MUSIC_BUS_NAME)
		if removable_menu_bus_index > 0:
			AudioServer.remove_bus(removable_menu_bus_index)


func _build_audio_players() -> void:
	_ensure_sfx_bus()
	_build_procedural_sfx()
	for player in sfx_players:
		if is_instance_valid(player):
			player.queue_free()
	sfx_players.clear()
	for _pool_index in range(16):
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
	if gameplay_music_player != null and is_instance_valid(gameplay_music_player):
		gameplay_music_player.queue_free()
	gameplay_music_player = AudioStreamPlayer.new()
	gameplay_music_player.bus = MENU_MUSIC_BUS_NAME
	gameplay_music_player.volume_db = GAMEPLAY_MUSIC_VOLUME_DB
	gameplay_music_player.autoplay = false
	gameplay_music_player.finished.connect(_on_gameplay_music_finished)
	add_child(gameplay_music_player)
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


func _build_procedural_sfx() -> void:
	# Original micro-sounds generated at runtime: no additional third-party
	# audio files, tiny memory cost, and consistent volume/pitch behavior.
	ui_click_sound = _make_procedural_sfx(620.0, 0.045, 0.03, 170.0, 1001)
	ui_hover_sound = _make_procedural_sfx(420.0, 0.032, 0.02, 90.0, 1009)
	pickup_sound = _make_procedural_sfx(430.0, 0.15, 0.02, 780.0, 1002)
	build_sound = _make_procedural_sfx(92.0, 0.14, 0.48, -24.0, 1003)
	warning_sound = _make_procedural_sfx(760.0, 0.12, 0.04, -220.0, 1004)
	impact_sound = _make_procedural_sfx(118.0, 0.09, 0.42, -38.0, 1005)
	step_grass_sound = _make_procedural_sfx(88.0, 0.055, 0.62, -12.0, 1006)
	step_wood_sound = _make_procedural_sfx(168.0, 0.050, 0.24, -52.0, 1007)
	step_cave_sound = _make_procedural_sfx(68.0, 0.070, 0.52, -18.0, 1008)


func _make_procedural_sfx(base_frequency: float, duration: float, noise_amount: float, chirp_amount: float, seed_value: int) -> AudioStreamWAV:
	var sample_rate := 22050
	var sample_count: int = maxi(1, int(ceil(duration * sample_rate)))
	var audio_data := PackedByteArray()
	audio_data.resize(sample_count * 2)
	var audio_rng := RandomNumberGenerator.new()
	audio_rng.seed = seed_value
	for sample_index in range(sample_count):
		var time_seconds: float = float(sample_index) / float(sample_rate)
		var progress: float = float(sample_index) / float(maxi(sample_count - 1, 1))
		var attack: float = clampf(time_seconds / 0.004, 0.0, 1.0)
		var envelope: float = attack * pow(1.0 - progress, 2.35)
		var frequency: float = maxf(24.0, base_frequency + chirp_amount * progress)
		var tone: float = sin(TAU * frequency * time_seconds)
		var overtone: float = sin(TAU * frequency * 2.01 * time_seconds) * 0.22
		var noise: float = audio_rng.randf_range(-1.0, 1.0) * noise_amount
		var mixed_sample: float = clampf((tone + overtone) * (1.0 - noise_amount * 0.55) + noise, -1.0, 1.0) * envelope * 0.72
		audio_data.encode_s16(sample_index * 2, int(round(mixed_sample * 32767.0)))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = audio_data
	return stream


func _connect_ui_audio_feedback(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			var button := child as BaseButton
			if not button.pressed.is_connected(_play_ui_click):
				button.pressed.connect(_play_ui_click)
			if not button.has_meta("polish_signals_connected"):
				button.set_meta("polish_signals_connected", true)
				button.pivot_offset = button.size * 0.5
				button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
				button.mouse_entered.connect(_on_button_hovered.bind(button, true))
				button.mouse_exited.connect(_on_button_hovered.bind(button, false))
				button.focus_entered.connect(_on_button_hovered.bind(button, true))
				button.focus_exited.connect(_on_button_hovered.bind(button, false))
				button.button_down.connect(_on_button_pressed_visual.bind(button))
				button.button_up.connect(_on_button_released_visual.bind(button))
		_connect_ui_audio_feedback(child)


func _on_button_hovered(button: BaseButton, hovered: bool) -> void:
	if button == null or not is_instance_valid(button) or button.disabled:
		return
	# Player pick: tilt and grow on hover, squish on press.
	_animate_button_to(button, Vector2(1.07, 1.07) if hovered else Vector2.ONE, -0.045 if hovered else 0.0, UI_ANIM_TIME * 0.5 if hovered else UI_ANIM_TIME * 0.4)
	if hovered:
		_play_sfx(ui_hover_sound, -30.0, _simulation_randf_range(0.98, 1.04))


func _on_button_pressed_visual(button: BaseButton) -> void:
	_animate_button_to(button, Vector2(1.1, 0.82), 0.0, 0.06)


func _on_button_released_visual(button: BaseButton) -> void:
	if button.has_meta("polish_tween"):
		var old_tween: Tween = button.get_meta("polish_tween") as Tween
		if old_tween != null and old_tween.is_valid():
			old_tween.kill()
	var settle_tween := create_tween()
	settle_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# Springs tall, then settles exactly to its accessible size (release smoke contract).
	settle_tween.tween_property(button, "scale", Vector2(0.95, 1.1), 0.07)
	settle_tween.tween_property(button, "scale", Vector2.ONE, 0.14)
	settle_tween.parallel().tween_property(button, "rotation", 0.0, 0.14)
	button.set_meta("polish_tween", settle_tween)


func _animate_button_to(button: BaseButton, target_scale: Vector2, target_rotation: float, duration: float) -> void:
	if button.has_meta("polish_tween"):
		var old_tween: Tween = button.get_meta("polish_tween") as Tween
		if old_tween != null and old_tween.is_valid():
			old_tween.kill()
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", target_scale, duration)
	tween.parallel().tween_property(button, "rotation", target_rotation, duration)
	button.set_meta("polish_tween", tween)


func _play_ui_click() -> void:
	_play_sfx(ui_click_sound, -18.0, _simulation_randf_range(0.97, 1.03))


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
		created_menu_music_bus = true
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
		created_sfx_bus = true
		sfx_bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(sfx_bus_index, SFX_BUS_NAME)


func _volume_percent_to_db(percent: float) -> float:
	if percent <= 0.0:
		return -80.0
	return linear_to_db(percent / 100.0)


func _load_persistent_settings() -> void:
	if not persistence_enabled:
		return
	var settings := ConfigFile.new()
	if settings.load(settings_path) != OK:
		return
	music_volume_percent = clampf(float(settings.get_value("audio", "music", music_volume_percent)), 0.0, 100.0)
	sfx_volume_percent = clampf(float(settings.get_value("audio", "sfx", sfx_volume_percent)), 0.0, 100.0)
	fullscreen_enabled = bool(settings.get_value("display", "fullscreen", fullscreen_enabled))
	effects_quality_high = bool(settings.get_value("display", "high_effects", effects_quality_high))
	screen_shake_percent = clampf(float(settings.get_value("display", "screen_shake", screen_shake_percent)), 0.0, 100.0)
	minimal_hud_enabled = bool(settings.get_value("display", "minimal_hud", minimal_hud_enabled))
	damage_numbers_enabled = bool(settings.get_value("display", "damage_numbers", damage_numbers_enabled))
	low_health_warning_enabled = bool(settings.get_value("display", "low_health_warning", low_health_warning_enabled))
	menu_motion_enabled = bool(settings.get_value("display", "menu_motion", menu_motion_enabled))
	auto_control_prompts_enabled = bool(settings.get_value("controls", "auto_prompts", auto_control_prompts_enabled))
	tutorial_enabled = bool(settings.get_value("gameplay", "guided_tutorial", tutorial_enabled))
	dev_invincible_enabled = bool(settings.get_value("developer", "invincible", dev_invincible_enabled))
	dev_speed_percent = clampf(float(settings.get_value("developer", "speed_percent", dev_speed_percent)), 25.0, 400.0)
	highest_round = maxi(1, int(settings.get_value("progress", "highest_round", highest_round)))
	persistent_gun_sentry_unlocked = bool(settings.get_value("progress", "gun_sentry_unlocked", persistent_gun_sentry_unlocked))
	persistent_golden_sentry_unlocked = bool(settings.get_value("progress", "golden_sentry_unlocked", persistent_golden_sentry_unlocked))
	persistent_magic_sentry_unlocked = bool(settings.get_value("progress", "magic_sentry_unlocked", persistent_magic_sentry_unlocked))
	persistent_shield_unlocked = bool(settings.get_value("progress", "shield_unlocked", persistent_shield_unlocked))
	persistent_cave_boss_defeated = bool(settings.get_value("progress", "cave_boss_defeated", persistent_cave_boss_defeated))


func _save_persistent_settings() -> void:
	if not persistence_enabled:
		return
	var settings := ConfigFile.new()
	settings.set_value("audio", "music", music_volume_percent)
	settings.set_value("audio", "sfx", sfx_volume_percent)
	settings.set_value("display", "fullscreen", fullscreen_enabled)
	settings.set_value("display", "high_effects", effects_quality_high)
	settings.set_value("display", "screen_shake", screen_shake_percent)
	settings.set_value("display", "minimal_hud", minimal_hud_enabled)
	settings.set_value("display", "damage_numbers", damage_numbers_enabled)
	settings.set_value("display", "low_health_warning", low_health_warning_enabled)
	settings.set_value("display", "menu_motion", menu_motion_enabled)
	settings.set_value("controls", "auto_prompts", auto_control_prompts_enabled)
	settings.set_value("gameplay", "guided_tutorial", tutorial_enabled)
	settings.set_value("developer", "invincible", dev_invincible_enabled)
	settings.set_value("developer", "speed_percent", dev_speed_percent)
	settings.set_value("progress", "highest_round", highest_round)
	settings.set_value("progress", "gun_sentry_unlocked", persistent_gun_sentry_unlocked)
	settings.set_value("progress", "golden_sentry_unlocked", persistent_golden_sentry_unlocked)
	settings.set_value("progress", "magic_sentry_unlocked", persistent_magic_sentry_unlocked)
	settings.set_value("progress", "shield_unlocked", persistent_shield_unlocked)
	settings.set_value("progress", "cave_boss_defeated", persistent_cave_boss_defeated)
	var save_error := settings.save(settings_path)
	if save_error != OK:
		push_warning("Could not save settings (error %d)." % save_error)


func _apply_window_mode() -> void:
	if DisplayServer.get_name() == "headless" or OS.has_feature("editor"):
		return
	if fullscreen_enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(SCREEN_SIZE))
		var usable_rect := DisplayServer.screen_get_usable_rect()
		DisplayServer.window_set_position(usable_rect.position + (usable_rect.size - Vector2i(SCREEN_SIZE)) / 2)


func _toggle_fullscreen() -> void:
	fullscreen_enabled = not fullscreen_enabled
	_apply_window_mode()
	if menu_fullscreen_button != null:
		menu_fullscreen_button.text = "Fullscreen: %s" % ("On" if fullscreen_enabled else "Off")
	_save_persistent_settings()


func _toggle_effects_quality() -> void:
	effects_quality_high = not effects_quality_high
	_refresh_settings_buttons()
	_save_persistent_settings()
	queue_redraw()


func _toggle_minimal_hud() -> void:
	minimal_hud_enabled = not minimal_hud_enabled
	_refresh_settings_buttons()
	_save_persistent_settings()
	_refresh_hud()
	queue_redraw()


func _toggle_damage_numbers() -> void:
	damage_numbers_enabled = not damage_numbers_enabled
	_refresh_settings_buttons()
	_save_persistent_settings()


func _toggle_low_health_warning() -> void:
	low_health_warning_enabled = not low_health_warning_enabled
	_refresh_settings_buttons()
	_save_persistent_settings()
	queue_redraw()


func _toggle_auto_control_prompts() -> void:
	auto_control_prompts_enabled = not auto_control_prompts_enabled
	if not auto_control_prompts_enabled:
		last_input_device = "keyboard"
	_refresh_settings_buttons()
	_save_persistent_settings()
	_refresh_hud()
	queue_redraw()


func _toggle_menu_motion() -> void:
	menu_motion_enabled = not menu_motion_enabled
	_refresh_settings_buttons()
	_save_persistent_settings()
	queue_redraw()


func _toggle_dev_invincible() -> void:
	if not dev_mode_enabled:
		return
	dev_invincible_enabled = not dev_invincible_enabled
	_refresh_settings_buttons()
	_save_persistent_settings()
	_refresh_hud()
	queue_redraw()


func _on_dev_speed_changed(value: float) -> void:
	dev_speed_percent = clampf(value, 25.0, 400.0)
	if menu_dev_speed_value_label != null:
		menu_dev_speed_value_label.text = "%d%%" % int(round(dev_speed_percent))
	if inventory_dev_speed_value_label != null:
		inventory_dev_speed_value_label.text = "%d%%" % int(round(dev_speed_percent))
	_save_persistent_settings()
	queue_redraw()


func _refresh_settings_buttons() -> void:
	if menu_effects_button != null:
		menu_effects_button.text = "Effects: %s" % ("High" if effects_quality_high else "Low")
	if menu_minimal_hud_button != null:
		menu_minimal_hud_button.text = "Minimal HUD: %s" % ("On" if minimal_hud_enabled else "Off")
	if menu_damage_numbers_button != null:
		menu_damage_numbers_button.text = "Damage Numbers: %s" % ("On" if damage_numbers_enabled else "Off")
	if menu_low_health_button != null:
		menu_low_health_button.text = "Low Health Warning: %s" % ("On" if low_health_warning_enabled else "Off")
	if menu_control_prompts_button != null:
		menu_control_prompts_button.text = "Auto Control Prompts: %s" % ("On" if auto_control_prompts_enabled else "Off")
	if menu_motion_button != null:
		menu_motion_button.text = "Menu Motion: %s" % ("On" if menu_motion_enabled else "Off")
	if menu_dev_invincible_button != null:
		menu_dev_invincible_button.text = "Invincible: %s" % ("On" if dev_invincible_enabled else "Off")
		menu_dev_invincible_button.disabled = not dev_mode_enabled
	if menu_dev_speed_slider != null:
		menu_dev_speed_slider.editable = dev_mode_enabled
		menu_dev_speed_slider.set_value_no_signal(dev_speed_percent)
	if menu_dev_speed_value_label != null:
		menu_dev_speed_value_label.text = "%d%%" % int(round(dev_speed_percent))
		menu_dev_speed_value_label.modulate = TEXT_COLOR if dev_mode_enabled else MUTED_TEXT_COLOR
	if menu_dev_settings_hint_label != null:
		menu_dev_settings_hint_label.text = "Live run controls • changes save automatically" if dev_mode_enabled else "Unlock Dev Tools first • PIN protected"
		menu_dev_settings_hint_label.modulate = MAGIC_COLOR if dev_mode_enabled else MUTED_TEXT_COLOR
	if inventory_dev_invincible_button != null:
		inventory_dev_invincible_button.text = "Invincible  %s" % ("ON" if dev_invincible_enabled else "OFF")
		inventory_dev_invincible_button.disabled = not dev_mode_enabled
	if inventory_dev_speed_slider != null:
		inventory_dev_speed_slider.editable = dev_mode_enabled
		inventory_dev_speed_slider.set_value_no_signal(dev_speed_percent)
	if inventory_dev_speed_value_label != null:
		inventory_dev_speed_value_label.text = "%d%%" % int(round(dev_speed_percent))


func _on_screen_shake_changed(value: float) -> void:
	screen_shake_percent = clampf(value, 0.0, 100.0)
	if screen_shake_value_label != null:
		screen_shake_value_label.text = "%d%%" % int(round(screen_shake_percent))
	_save_persistent_settings()


func _apply_audio_settings() -> void:
	if sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(sfx_bus_index, _volume_percent_to_db(sfx_volume_percent))
	if menu_music_bus_index != -1:
		AudioServer.set_bus_volume_db(menu_music_bus_index, _volume_percent_to_db(music_volume_percent))
	if music_volume_value_label != null:
		music_volume_value_label.text = "%d%%" % int(round(music_volume_percent))
	if sfx_volume_value_label != null:
		sfx_volume_value_label.text = "%d%%" % int(round(sfx_volume_percent))
	if music_volume_slider != null:
		music_volume_slider.set_value_no_signal(music_volume_percent)
	if sfx_volume_slider != null:
		sfx_volume_slider.set_value_no_signal(sfx_volume_percent)
	if inventory_music_volume_slider != null:
		inventory_music_volume_slider.set_value_no_signal(music_volume_percent)
	if inventory_sfx_volume_slider != null:
		inventory_sfx_volume_slider.set_value_no_signal(sfx_volume_percent)
	var ad_service := get_node_or_null("/root/AdService")
	if ad_service != null:
		ad_service.call("set_volume_percent", music_volume_percent)


func _on_music_volume_changed(value: float) -> void:
	music_volume_percent = clampf(value, 0.0, 100.0)
	_apply_audio_settings()
	_save_persistent_settings()


func _on_sfx_volume_changed(value: float) -> void:
	sfx_volume_percent = clampf(value, 0.0, 100.0)
	_apply_audio_settings()
	_save_persistent_settings()

func _load_texture(resource_path: String, chroma_key: Variant = null, crop_visible: bool = false, max_size: Vector2i = Vector2i.ZERO) -> Texture2D:
	# Most team artwork already contains a clean alpha channel. Returning Godot's
	# imported texture avoids decoding it again and preserves intentional black
	# outlines that an old runtime chroma-key pass used to erase.
	if chroma_key == null and not crop_visible and max_size == Vector2i.ZERO:
		var cached_texture := load(resource_path) as Texture2D
		if cached_texture != null:
			return cached_texture
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
	if max_size.x > 0 and max_size.y > 0 and (image.get_width() > max_size.x or image.get_height() > max_size.y):
		var resize_scale := minf(
			float(max_size.x) / float(image.get_width()),
			float(max_size.y) / float(image.get_height())
		)
		image.resize(
			maxi(1, int(round(float(image.get_width()) * resize_scale))),
			maxi(1, int(round(float(image.get_height()) * resize_scale))),
			Image.INTERPOLATE_LANCZOS
		)
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
	if phase != Phase.BUILD or build_menu_open or dealer_menu_open or inventory_menu_open or escape_confirm_open or inside_house or inside_cave:
		return
	# Player pick: a shrinking ring around the team's pixel digits.
	var ring_center := Vector2(SCREEN_SIZE.x * 0.5, 66.0)
	var ring_radius: float = 50.0
	var remaining_ratio: float = clampf(countdown / BUILD_PHASE_DURATION, 0.0, 1.0)
	var urgent: bool = countdown <= 10.0
	var ring_color: Color = UI_DANGER_ACCENT if urgent else UI_WARM_ACCENT
	var second_fraction: float = countdown - floor(countdown)
	var tick_bump: float = 1.0 + (0.08 if urgent else 0.04) * clampf((second_fraction - 0.85) / 0.15, 0.0, 1.0)
	draw_circle(ring_center + Vector2(0, 4), ring_radius + 6.0, UI_PANEL_SHADOW)
	draw_circle(ring_center, ring_radius + 6.0, UI_PANEL_FILL)
	draw_arc(ring_center, ring_radius, 0.0, TAU, 64, Color(1, 1, 1, 0.12), 8.0, true)
	if remaining_ratio > 0.0:
		draw_arc(ring_center, ring_radius, -PI * 0.5, -PI * 0.5 + TAU * remaining_ratio, 64, ring_color, 8.0, true)
	var hint_rect := Rect2(ring_center + Vector2(-70, ring_radius + 10.0), Vector2(140, 24))
	draw_rect(hint_rect, UI_PANEL_FILL, true)
	draw_string(ThemeDB.fallback_font, hint_rect.position + Vector2(0, 17), "%s  starts now" % _control_prompt("start_wave_early", "Enter"), HORIZONTAL_ALIGNMENT_CENTER, hint_rect.size.x, 14, TEXT_COLOR)
	var countdown_text: String = "%02d" % int(ceili(countdown))
	var digit_size: Vector2 = COUNTDOWN_DIGIT_DRAW_SIZE * 0.72 * tick_bump
	var digit_gap: float = 6.0
	var digits_width: float = digit_size.x * countdown_text.length() + digit_gap * (countdown_text.length() - 1)
	var digit_start := ring_center - Vector2(digits_width * 0.5, digit_size.y * 0.5)
	for digit_index in range(countdown_text.length()):
		var digit_char: String = countdown_text.substr(digit_index, 1)
		var digit_value: int = int(digit_char)
		var digit_draw_rect: Rect2 = Rect2(digit_start + Vector2(digit_index * (digit_size.x + digit_gap), 0), digit_size)
		if countdown_numbers_texture != null and digit_value >= 0 and digit_value < COUNTDOWN_DIGIT_SOURCE_RECTS.size():
			var digit_tile_rect: Rect2 = digit_draw_rect.grow(2.0)
			draw_rect(digit_tile_rect, Color(0.98, 0.88, 0.58, 0.96), true)
			draw_rect(digit_tile_rect, ring_color, false, 2.0)
			var source_rect: Rect2 = COUNTDOWN_DIGIT_SOURCE_RECTS[digit_value]
			draw_texture_rect_region(countdown_numbers_texture, digit_draw_rect, source_rect)
		else:
			draw_string(ThemeDB.fallback_font, digit_draw_rect.position + Vector2(2, digit_size.y * 0.85), digit_char, HORIZONTAL_ALIGNMENT_LEFT, -1, int(digit_size.y), Color(1.0, 0.93, 0.52))


func _draw_tutorial_panel() -> void:
	if not tutorial_enabled or round_number > 1 or phase == Phase.MENU or phase == Phase.GAME_OVER:
		return
	if build_menu_open or dealer_menu_open or inventory_menu_open or escape_confirm_open or inside_house or inside_cave:
		return
	if not tutorial_visible:
		var reopen_rect := Rect2(Vector2(1090, 92), Vector2(168, 38))
		_draw_ui_card(reopen_rect, UI_COOL_ACCENT, UI_PANEL_FILL_SOFT, 2.0, Vector2(0, 4))
		draw_string(ThemeDB.fallback_font, reopen_rect.position + Vector2(14, 25), "T  Show next step", HORIZONTAL_ALIGNMENT_LEFT, 144, 16, TEXT_COLOR)
		return

	if phase == Phase.DEFEND:
		_draw_tutorial_defend_panel()
		return

	var panel_rect := Rect2(Vector2(926, 92), Vector2(332, 82))
	_draw_ui_card(panel_rect, UI_COOL_ACCENT, UI_PANEL_FILL, 2.0, Vector2(0, 6))
	var objective := "Move toward the forest"
	var detail := "Left stick moves Bob" if _using_controller_prompts() else "WASD or arrow keys move Bob"
	if tutorial_moved and not tutorial_got_wood:
		objective = "Gather wood"
		detail = "Stay close to a tree"
	elif tutorial_got_wood and not tutorial_got_stone:
		objective = "Gather stone"
		detail = "Find a rock deeper in the forest"
	elif tutorial_got_stone and not tutorial_built_once:
		objective = "Build a defense"
		detail = "%s opens Build on a yard tile" % _control_prompt("build_arrow_turret", "B")
	elif tutorial_built_once:
		objective = "Ready for the audit"
		detail = "%s starts the IRS wave" % _control_prompt("start_wave_early", "ENTER")
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 25), "NEXT", HORIZONTAL_ALIGNMENT_LEFT, 46, 13, UI_COOL_ACCENT)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(64, 27), objective, HORIZONTAL_ALIGNMENT_LEFT, 224, 17 if ThemeDB.fallback_font.get_string_size(objective, HORIZONTAL_ALIGNMENT_LEFT, -1, 18).x <= 224.0 else 15, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 58), detail, HORIZONTAL_ALIGNMENT_LEFT, 272, 14, UI_WARM_ACCENT)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(294, 22), "T×", HORIZONTAL_ALIGNMENT_LEFT, 26, 12, MUTED_TEXT_COLOR)


func _draw_tutorial_defend_panel() -> void:
	var panel_rect := Rect2(Vector2(926, 92), Vector2(332, 82))
	_draw_ui_card(panel_rect, UI_DANGER_ACCENT, UI_PANEL_FILL, 2.0, Vector2(0, 6))
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 25), "FIRST IRS WAVE", HORIZONTAL_ALIGNMENT_LEFT, 190, 18, UI_DANGER_ACCENT)
	var attack_key := _control_prompt("action", "SPACE / CLICK")
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 56), "%s attacks  •  Sentries auto-fire" % attack_key, HORIZONTAL_ALIGNMENT_LEFT, 294, 14, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel_rect.position + Vector2(294, 22), "T×", HORIZONTAL_ALIGNMENT_LEFT, 26, 12, MUTED_TEXT_COLOR)


func _draw_wave_banner() -> void:
	if wave_banner_timer <= 0.0:
		return
	var age: float = maxf(0.0, wave_banner_duration - wave_banner_timer)
	var enter_progress: float = clampf(age / 0.28, 0.0, 1.0)
	var exit_progress: float = clampf(wave_banner_timer / 0.30, 0.0, 1.0)
	var enter_eased: float = 1.0 - pow(1.0 - enter_progress, 3.0)
	var alpha: float = minf(enter_progress, exit_progress)
	var bounce_scale: float = 0.78 + enter_eased * 0.22 + sin(enter_progress * PI) * 0.07
	var banner_size := Vector2(560, 112) * Vector2(bounce_scale, 0.92 + enter_eased * 0.08)
	var banner_center := Vector2(640, lerpf(38.0, 146.0, enter_eased))
	var banner_rect := Rect2(banner_center - banner_size * 0.5, banner_size)
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
	if inside_house or inside_cave or phase == Phase.MENU or phase == Phase.GAME_OVER or build_menu_open or dealer_menu_open or inventory_menu_open or escape_confirm_open:
		return
	if not _is_player_near_house_door():
		if phase == Phase.BUILD and house_damage_stage > 0 and _is_player_near_house_shell():
			var repair_prompt_rect := Rect2(Vector2(390, 608), Vector2(500, 42))
			_draw_ui_prompt(repair_prompt_rect, _control_prompt("repair_wall", "H"), "Repair house  %d wood  %d stone" % [HOUSE_REPAIR_WOOD_COST, HOUSE_REPAIR_STONE_COST], UI_SUCCESS_ACCENT, wrench_texture)
		return
	var enter_prompt_rect := Rect2(Vector2(426, 608), Vector2(428, 42))
	_draw_ui_prompt(enter_prompt_rect, _control_prompt("enter_cave", "F"), "See what's inside the house", UI_WARM_ACCENT)


func _draw_dealer_prompt() -> void:
	if inside_house or inside_cave or phase != Phase.BUILD or build_menu_open or dealer_menu_open or inventory_menu_open or escape_confirm_open:
		return
	if not _is_player_near_dealer_stand():
		return
	var prompt_rect := Rect2(Vector2(426, 656), Vector2(428, 42))
	_draw_ui_prompt(prompt_rect, _control_prompt("dealer_menu", "G"), "Visit the arms dealer", UI_WARM_ACCENT)


func _draw_cave_prompt() -> void:
	if inside_house or _cave_active() or phase == Phase.MENU or phase == Phase.GAME_OVER or build_menu_open or dealer_menu_open or inventory_menu_open or escape_confirm_open:
		return
	if not _is_player_near_cave_entrance():
		return
	var prompt_rect := Rect2(Vector2(432, 608), Vector2(416, 42))
	_draw_ui_prompt(prompt_rect, _control_prompt("enter_cave", "F"), "Enter the cave", UI_COOL_ACCENT)


func _draw_house_interior() -> void:
	if not inside_house:
		return
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color(0.025, 0.025, 0.03, 0.98), true)
	var panel := _house_interior_panel()
	_draw_ui_card(panel, UI_WARM_ACCENT, Color(0.11, 0.085, 0.065, 0.99), 4.0, Vector2(0, 10))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(34, 46), "Inside Bob's House", HORIZONTAL_ALIGNMENT_LEFT, 420, 30, TEXT_COLOR)
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(34, 76), "These valuables are what the IRS is trying to take.", HORIZONTAL_ALIGNMENT_LEFT, 600, 17, MUTED_TEXT_COLOR)
	var status_text := "House intact" if house_damage_stage == 0 else "House damage: %d/%d" % [house_damage_stage, HOUSE_MAX_DAMAGE_STAGES]
	var status_color := UI_SUCCESS_ACCENT if house_damage_stage == 0 else HOUSE_DANGER_COLOR
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(650, 48), status_text, HORIZONTAL_ALIGNMENT_RIGHT, 216, 18, status_color)

	var wall_rect := Rect2(panel.position + Vector2(32, 96), Vector2(panel.size.x - 64, 152))
	draw_rect(wall_rect, Color(0.30, 0.20, 0.14), true)
	draw_rect(wall_rect, Color(0.72, 0.52, 0.30, 0.65), false, 3.0)
	for item_index in range(HOUSE_START_ITEMS.size()):
		var item_name: String = String(HOUSE_START_ITEMS[item_index])
		var item_position := wall_rect.position + Vector2(30 + item_index * 158, 42)
		_draw_house_item_display(item_position, item_name, item_name in stolen_house_items)

	var floor_rect := Rect2(panel.position + Vector2(32, 258), Vector2(panel.size.x - 64, 258))
	draw_rect(floor_rect, Color(0.22, 0.15, 0.10), true)
	for floor_line in range(1, 6):
		var floor_y: float = floor_rect.position.y + float(floor_line) * floor_rect.size.y / 6.0
		draw_line(Vector2(floor_rect.position.x, floor_y), Vector2(floor_rect.end.x, floor_y), Color(0.46, 0.30, 0.18, 0.34), 2.0)
	var rug_rect := Rect2(panel.position + Vector2(284, 330), Vector2(332, 102))
	draw_rect(rug_rect, Color(0.34, 0.12, 0.10), true)
	draw_rect(rug_rect, Color(0.82, 0.58, 0.30), false, 3.0)

	var exit_rect := _house_interior_exit_rect()
	draw_rect(exit_rect, Color(0.20, 0.12, 0.07), true)
	draw_rect(exit_rect, UI_WARM_ACCENT, false, 3.0)
	draw_circle(exit_rect.position + Vector2(exit_rect.size.x - 12, exit_rect.size.y * 0.5), 3.0, UI_WARM_ACCENT)
	var exit_text := "%s  Leave the house" % _control_prompt("enter_cave", "F") if _is_player_near_house_exit() else "Walk to the door to leave"
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(290, 538), exit_text, HORIZONTAL_ALIGNMENT_CENTER, 320, 16, TEXT_COLOR)


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
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(294, 47), "%d%s" % [player_hp, "  |  H/RMB parry" if shield_unlocked else ""], HORIZONTAL_ALIGNMENT_LEFT, 210, 16, MUTED_TEXT_COLOR)
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
		var pickup_base_pos: Vector2 = Vector2(pickup["position"])
		var pickup_phase: float = world_time * 3.8 + pickup_base_pos.x * 0.021 + pickup_base_pos.y * 0.013
		var pickup_pos: Vector2 = pickup_base_pos + Vector2(0.0, sin(pickup_phase) * 4.5)
		var pickup_type: String = String(pickup["type"])
		var pickup_rect: Rect2 = Rect2(pickup_pos + Vector2(-16, -16), Vector2(32, 32))
		var pickup_glow: float = 0.13 + (0.5 + 0.5 * sin(pickup_phase * 1.7)) * 0.11
		draw_circle(pickup_pos, 24.0 + sin(pickup_phase) * 2.0, Color(0.84, 0.78, 1.0, pickup_glow))
		if pickup_type == "upgrade_hp" and heart_icon_texture != null:
			draw_texture_rect(heart_icon_texture, pickup_rect, false)
			draw_rect(pickup_rect.grow(2.0), Color(1.0, 0.52, 0.56, 0.58), false, 2.0)
		elif pickup_type == "upgrade_carry" and inventory_icon_texture != null:
			draw_texture_rect(inventory_icon_texture, pickup_rect, false)
			draw_rect(pickup_rect.grow(2.0), Color(0.96, 0.88, 0.58, 0.55), false, 2.0)
		elif pickup_type == "upgrade_speed" and energy_drink_texture != null:
			var drink_rect := Rect2(pickup_pos + Vector2(-12, -20), Vector2(24, 40))
			draw_texture_rect(energy_drink_texture, drink_rect, false)
			draw_rect(drink_rect.grow(3.0), Color(1.0, 0.92, 0.24, 0.72), false, 2.0)
		elif pickup_type == "upgrade_gather" and wrench_texture != null:
			draw_texture_rect(wrench_texture, pickup_rect, false)
			draw_rect(pickup_rect.grow(2.0), Color(0.78, 0.86, 0.94, 0.64), false, 2.0)
		elif pickup_type == "upgrade_sword" and player_sword_texture != null:
			var sword_rect := Rect2(pickup_pos + Vector2(-9, -22), Vector2(18, 44))
			draw_texture_rect(player_sword_texture, sword_rect, false)
			draw_rect(sword_rect.grow(3.0), Color(0.86, 0.90, 0.98, 0.66), false, 2.0)
		elif pickup_type == "unlock_parry" and shield_right_idle_texture != null:
			draw_texture_rect(shield_right_idle_texture, pickup_rect, false)
			draw_rect(pickup_rect.grow(2.0), Color(0.52, 0.82, 1.0, 0.66), false, 2.0)
		elif pickup_type == "unlock_golden" and golden_turret_texture != null:
			var golden_icon_rect := Rect2(pickup_pos + Vector2(-24, -24), Vector2(48, 48))
			draw_texture_rect_region(golden_turret_texture, golden_icon_rect, GOLDEN_TURRET_REGION)
			draw_rect(golden_icon_rect.grow(2.0), Color(1.0, 0.82, 0.22, 0.72), false, 2.0)
		else:
			draw_rect(pickup_rect, CAVE_KEY_COLOR if pickup_type == "key" else MAGIC_COLOR, true)
	if harvesting_node_index != -1 and harvesting_node_index < cave_nodes.size():
		var gather_rect: Rect2 = _cave_node_rect(cave_nodes[harvesting_node_index])
		var progress: float = harvest_timer / _current_gather_time()
		draw_rect(Rect2(gather_rect.position + Vector2(0, -14), Vector2(36 * progress, 5)), IRON_NODE_COLOR.lightened(0.35), true)
	for crystal in cave_crystals:
		var crystal_color: Color = MAGIC_COLOR if not bool(crystal["claimed"]) else MAGIC_COLOR.lightened(0.45)
		var crystal_base_pos: Vector2 = Vector2(crystal["position"])
		var crystal_phase: float = world_time * 2.7 + crystal_base_pos.x * 0.016
		var crystal_pos: Vector2 = crystal_base_pos + Vector2(sin(crystal_phase * 0.7) * 1.5, sin(crystal_phase) * 3.2)
		draw_circle(crystal_pos, 28.0 + sin(crystal_phase * 1.4) * 2.0, Color(MAGIC_COLOR.r, MAGIC_COLOR.g, MAGIC_COLOR.b, 0.10 + absf(sin(crystal_phase)) * 0.08))
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
		var cave_anim_offset: float = enemy_rect.position.x * 0.007 + enemy_rect.position.y * 0.003
		var cave_stride_phase: float = (world_time + cave_anim_offset) * (5.2 if is_boss else 8.4)
		var cave_stride: float = sin(cave_stride_phase)
		var cave_bob: float = absf(sin(cave_stride_phase)) * (2.0 if is_boss else 4.0)
		var attack_time: float = float(cave_enemy.get("attack_timer", 0.0))
		var attack_punch: float = sin(clampf(1.0 - attack_time / (CAVE_BOSS_ATTACK_TIME if is_boss else 0.24), 0.0, 1.0) * PI) if attack_time > 0.0 else 0.0
		var miner_texture: Texture2D = _boss_display_texture(cave_enemy) if is_boss else _current_cave_miner_texture(cave_anim_offset)
		var miner_facing_left: bool = cave_player_position.x < enemy_rect.position.x
		if miner_texture != null:
			var draw_size: Vector2 = CAVE_BOSS_DRAW_SIZE if is_boss else CAVE_MINER_DRAW_SIZE
			var miner_draw_rect: Rect2 = Rect2(
				enemy_rect.position + Vector2(enemy_rect.size.x * 0.5 - draw_size.x * 0.5, enemy_rect.size.y * 0.5 - draw_size.y * 0.56 - cave_bob),
				draw_size
			)
			if is_boss:
				draw_set_transform(enemy_rect.position + Vector2(enemy_rect.size.x * 0.5, enemy_rect.size.y + 18), 0.0, Vector2(1.9, 0.66))
				draw_circle(Vector2.ZERO, 22.0, CAVE_BOSS_SHADOW_COLOR)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			var side_scale: float = -1.0 if miner_facing_left else 1.0
			var miner_scale := Vector2(side_scale * (1.0 + cave_stride * (0.028 if is_boss else 0.045) + attack_punch * 0.10), 1.0 - cave_stride * (0.022 if is_boss else 0.035) - attack_punch * 0.055)
			var miner_rotation: float = (-0.025 if miner_facing_left else 0.025) * cave_stride + (-0.08 if miner_facing_left else 0.08) * attack_punch
			draw_set_transform(miner_draw_rect.position + miner_draw_rect.size * 0.5, miner_rotation, miner_scale)
			draw_texture_rect(miner_texture, Rect2(-miner_draw_rect.size * 0.5, miner_draw_rect.size), false)
			if float(cave_enemy.get("flash_timer", 0.0)) > 0.0:
				draw_rect(Rect2(-miner_draw_rect.size * 0.5, miner_draw_rect.size), Color(1, 1, 1, 0.18), true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_rect(enemy_rect, enemy_color, true)
			draw_rect(enemy_rect, Color(0.10, 0.04, 0.04, 0.55), false, 2.0)
		if not is_boss:
			_draw_cave_miner_shovel(enemy_rect, miner_facing_left, float(cave_enemy.get("attack_timer", 0.0)))
			if dev_mode_enabled:
				draw_line(enemy_rect.get_center(), enemy_rect.get_center() + Vector2(cave_enemy.get("ai_direction", Vector2.ZERO)) * 48.0, Color(0.45, 0.9, 1.0, 0.75), 2.0)
				draw_string(ThemeDB.fallback_font, enemy_rect.position + Vector2(-18, -20), String(cave_enemy.get("ai_thought", "Pursue Bob")), HORIZONTAL_ALIGNMENT_LEFT, 180, 11, Color(0.75, 0.95, 1.0))
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
	if player_swing_timer > 0.0 and (player_sword_sprite == null or player_visual_node == null or not player_visual_node.visible):
		_draw_sword_swing_fallback(player_center)
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
		"ruin_hub": Vector2(52, 74),
		"mine_crossroads": Vector2(88, 74),
		"fountain_room": Vector2(124, 74),
		"lava_forge": Vector2(160, 74),
		"crystal_boss": Vector2(196, 74)
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
	var run_frame: int = int(floor(player_stride_clock * 0.82)) % 5
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


func _current_player_idle_texture(facing_left: bool) -> Texture2D:
	var second_frame: bool = int(floor(world_time * 2.0)) % 2 == 1
	# The exported idle filenames are reversed: the files named "right" face
	# left on screen, and the files named "left" face right.
	if facing_left:
		return player_idle_right_2_texture if second_frame else player_idle_right_1_texture
	return player_idle_left_2_texture if second_frame else player_idle_left_1_texture


func _current_cave_miner_texture(phase_offset: float = 0.0) -> Texture2D:
	var walk_frame: int = int(floor((world_time + phase_offset) * 7.0)) % 3
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


func _current_robot_walk_texture(phase_offset: float = 0.0) -> Texture2D:
	var walk_frame: int = int(floor((world_time + phase_offset) * 7.5)) % 3
	match walk_frame:
		0:
			return irs_robot_walk_1_texture if irs_robot_walk_1_texture != null else irs_robot_texture
		1:
			return irs_robot_walk_2_texture if irs_robot_walk_2_texture != null else irs_robot_texture
		_:
			return irs_robot_walk_3_texture if irs_robot_walk_3_texture != null else irs_robot_texture


func _current_runner_texture(phase_offset: float = 0.0) -> Texture2D:
	var run_frame: int = int(floor((world_time + phase_offset) * 10.0)) % 7
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
	var hp_ratio: float = clampf(float(structure.get("hp", 12)) / maxf(float(structure.get("max_hp", 12)), 1.0), 0.0, 1.0)
	var hp_badge_rect := Rect2(turret_center + Vector2(-18, -18), Vector2(36, 4))
	draw_rect(hp_badge_rect, Color(0.08, 0.04, 0.04, 0.76), true)
	draw_rect(Rect2(hp_badge_rect.position, Vector2(hp_badge_rect.size.x * hp_ratio, hp_badge_rect.size.y)), UI_SUCCESS_ACCENT.lerp(UI_DANGER_ACCENT, 1.0 - hp_ratio), true)
	if ammo_ratio <= 0.25 and weapon != "magic":
		draw_circle(turret_center + Vector2(0, -34), 4.0, Color(1.0, 0.32, 0.24, 0.92))
		draw_circle(turret_center + Vector2(0, -34), 7.0, Color(1.0, 0.32, 0.24, 0.18))
	if Vector2i(structure.get("cell", Vector2i.ZERO)) == selected_cell:
		var priority_labels := {"arrow": "CLOSE", "cannon": "GROUP", "gun": "FAST", "golden": "SWAT", "rifle": "TOUGH", "magic": "POWER"}
		var priority_text: String = String(priority_labels.get(weapon, "AUTO"))
		draw_string(ThemeDB.fallback_font, turret_center + Vector2(-22, -38), priority_text, HORIZONTAL_ALIGNMENT_CENTER, 44, 10, Color(0.94, 0.94, 0.88, 0.86))


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
			return "Family Photo"
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
	var hovered_weapon: String = _build_menu_weapon_at_position(_replay_get_mouse_position())
	_draw_ui_card(panel_rect, UI_COOL_ACCENT, UI_PANEL_FILL, 2.0)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(22, 28), "Build Defenses", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(22, 52), "Stand on an outlined yard tile, then choose what to build here.", HORIZONTAL_ALIGNMENT_LEFT, 670, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(880, 32), "BUILD TIME  %02ds" % int(ceili(countdown)), HORIZONTAL_ALIGNMENT_RIGHT, 200, 18, UI_WARM_ACCENT)
	_draw_build_menu_tab(panel_rect, "sentries", "Sentries")
	_draw_build_menu_tab(panel_rect, "walls", "Walls")
	var sentry_kinds: Array[String] = _build_menu_items()
	for option_index in range(sentry_kinds.size()):
		var option_weapon: String = sentry_kinds[option_index]
		var option_rect: Rect2 = _build_menu_option_rect(panel_rect, option_index)
		_draw_sentry_option(option_rect, option_weapon, _sentry_label(option_weapon), _sentry_price_label(option_weapon), selected_sentry_kind == option_weapon, hovered_weapon == option_weapon)
	var preview_weapon: String = hovered_weapon if hovered_weapon != "" else selected_sentry_kind
	if preview_weapon != "":
		_draw_sentry_hover_preview(Rect2(panel_rect.position + Vector2(746, 82), Vector2(356, 424)), preview_weapon)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(24, 522), "Tab switches category  |  Arrows preview  |  Click or Space builds  |  B / Esc closes", HORIZONTAL_ALIGNMENT_LEFT, 850, 14, MUTED_TEXT_COLOR)


func _draw_build_menu_tab(panel_rect: Rect2, tab_name: String, tab_label: String) -> void:
	var tab_rect: Rect2 = _build_menu_tab_rect(panel_rect, tab_name)
	var is_active: bool = build_menu_tab == tab_name
	var accent: Color = UI_COOL_ACCENT if tab_name == "sentries" else Color(0.86, 0.70, 0.42)
	var fill: Color = Color(0.16, 0.22, 0.26, 0.98) if is_active else Color(0.10, 0.12, 0.15, 0.94)
	_draw_ui_card(tab_rect, accent if is_active else Color(1, 1, 1, 0.16), fill, 2.0, Vector2.ZERO)
	_pstr(ThemeDB.fallback_font, tab_rect.position + Vector2(20, 27), tab_label, HORIZONTAL_ALIGNMENT_CENTER, tab_rect.size.x - 40.0, 18, TEXT_COLOR if is_active else MUTED_TEXT_COLOR)


func _draw_sentry_option(option_rect: Rect2, weapon: String, title: String, price_text: String, is_selected: bool, is_hovered: bool) -> void:
	if is_hovered:
		option_rect.position.y -= 4.0
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
	_pstr(ThemeDB.fallback_font, option_rect.position + Vector2(14, 22), title, HORIZONTAL_ALIGNMENT_LEFT, option_rect.size.x - 78.0, 17, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, option_rect.position + Vector2(14, 42), price_text, HORIZONTAL_ALIGNMENT_LEFT, option_rect.size.x - 66.0, 14 if ThemeDB.fallback_font.get_string_size(price_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x <= option_rect.size.x - 66.0 else 12, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, option_rect.position + Vector2(14, 60), String(_sentry_summary_lines(weapon)[0]), HORIZONTAL_ALIGNMENT_LEFT, option_rect.size.x - 78.0, 13, accent_color)
	var icon_center: Vector2 = option_rect.position + Vector2(option_rect.size.x - 34, option_rect.size.y * 0.5)
	draw_circle(icon_center, 13.0, accent_color)
	if weapon == "wall_light" or weapon == "wall_medium" or weapon == "wall_heavy":
		var wall_width: float = 22.0
		var wall_height: float = 14.0 if weapon == "wall_light" else (18.0 if weapon == "wall_medium" else 22.0)
		_prect(Rect2(icon_center - Vector2(wall_width * 0.5, wall_height * 0.5), Vector2(wall_width, wall_height)), accent_color, true)
		_prect(Rect2(icon_center - Vector2(wall_width * 0.5, wall_height * 0.5), Vector2(wall_width, wall_height)), Color(0.12, 0.10, 0.08), false, 2.0)
	elif weapon == "cannon":
		draw_circle(icon_center, 5.0, Color(0.16, 0.14, 0.12))
	elif weapon == "gun":
		_pline(icon_center - Vector2(10, 0), icon_center + Vector2(12, 0), Color(0.16, 0.14, 0.12), 3.0)
		_prect(Rect2(icon_center + Vector2(-4, -5), Vector2(10, 10)), accent_color, true)
	elif weapon == "magic":
		draw_colored_polygon(PackedVector2Array([
			icon_center + Vector2(0, -12),
			icon_center + Vector2(10, 0),
			icon_center + Vector2(0, 12),
			icon_center + Vector2(-10, 0)
		]), MAGIC_COLOR)
	else:
		_pline(icon_center - Vector2(12, 0), icon_center + Vector2(12, 0), Color(0.18, 0.12, 0.06), 3.0)
		_pline(icon_center + Vector2(4, -7), icon_center + Vector2(12, 0), Color(0.18, 0.12, 0.06), 3.0)
		_pline(icon_center + Vector2(4, 7), icon_center + Vector2(12, 0), Color(0.18, 0.12, 0.06), 3.0)


func _build_menu_panel_rect() -> Rect2:
	return Rect2(Vector2(76, 92), Vector2(1128, 548))


func _build_menu_tab_rect(panel_rect: Rect2, tab_name: String) -> Rect2:
	var tab_index: int = 1 if tab_name == "walls" else 0
	return Rect2(panel_rect.position + Vector2(22 + tab_index * 174, 68), Vector2(158, 42))


func _build_menu_tab_at_position(mouse_position: Vector2) -> String:
	if not build_menu_open or phase != Phase.BUILD or inside_house or inside_cave:
		return ""
	var panel_rect: Rect2 = _build_menu_panel_rect()
	if _build_menu_tab_rect(panel_rect, "sentries").has_point(mouse_position):
		return "sentries"
	if _build_menu_tab_rect(panel_rect, "walls").has_point(mouse_position):
		return "walls"
	return ""


func _build_menu_option_rect(panel_rect: Rect2, option_index: int) -> Rect2:
	var row: int = option_index / 2
	var col: int = option_index % 2
	return Rect2(panel_rect.position + Vector2(22 + col * 350, 124 + row * 94), Vector2(332, 82))


func _build_menu_weapon_at_position(mouse_position: Vector2) -> String:
	if not build_menu_open or phase != Phase.BUILD or inside_house or inside_cave:
		return ""
	var panel_rect: Rect2 = _build_menu_panel_rect()
	var sentry_kinds: Array[String] = _build_menu_items()
	for option_index in range(sentry_kinds.size()):
		var option_rect: Rect2 = _build_menu_option_rect(panel_rect, option_index)
		if option_rect.has_point(mouse_position):
			return sentry_kinds[option_index]
	return ""


func _draw_sentry_hover_preview(preview_rect: Rect2, weapon: String) -> void:
	_draw_ui_card(preview_rect, UI_COOL_ACCENT, UI_PANEL_FILL_SOFT, 2.0, Vector2(0, 4))
	_pstr(ThemeDB.fallback_font, preview_rect.position + Vector2(18, 30), "BUILD PREVIEW", HORIZONTAL_ALIGNMENT_LEFT, 180, 14, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, preview_rect.position + Vector2(18, 60), _sentry_label(weapon), HORIZONTAL_ALIGNMENT_LEFT, 210, 24, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, preview_rect.position + Vector2(18, 84), _sentry_price_label(weapon), HORIZONTAL_ALIGNMENT_LEFT, 270, 15, UI_WARM_ACCENT)
	var stage_rect := Rect2(preview_rect.position + Vector2(18, 102), Vector2(preview_rect.size.x - 36, 150))
	_draw_ui_card(stage_rect, Color(1, 1, 1, 0.12), Color(0.06, 0.08, 0.10, 0.96), 1.0, Vector2.ZERO)
	draw_circle(stage_rect.position + Vector2(stage_rect.size.x * 0.5, 118), 72.0, Color(0.24, 0.32, 0.22, 0.34))
	var preview_center: Vector2 = stage_rect.position + Vector2(stage_rect.size.x * 0.5, 82)
	_draw_sentry_preview_sprite(preview_center, weapon)
	var summary_lines: PackedStringArray = _sentry_summary_lines(weapon)
	for summary_index in range(summary_lines.size()):
		_pstr(
			ThemeDB.fallback_font,
			preview_rect.position + Vector2(20, 284 + summary_index * 26),
			summary_lines[summary_index],
			HORIZONTAL_ALIGNMENT_LEFT,
			preview_rect.size.x - 40.0,
			16,
			MUTED_TEXT_COLOR if summary_index < summary_lines.size() - 1 else Color(0.92, 0.84, 0.48)
		)
	_pstr(ThemeDB.fallback_font, preview_rect.position + Vector2(20, 402), "Click its card to build on the selected tile.", HORIZONTAL_ALIGNMENT_LEFT, preview_rect.size.x - 40.0, 14, MUTED_TEXT_COLOR)


func _draw_sentry_preview_sprite(preview_center: Vector2, weapon: String) -> void:
	if _is_wall_build(weapon):
		var wall_texture: Texture2D = wall_light_texture
		if weapon == "wall_medium":
			wall_texture = wall_medium_texture
		elif weapon == "wall_heavy":
			wall_texture = wall_heavy_texture
		if wall_texture != null:
			draw_texture_rect(wall_texture, Rect2(preview_center - Vector2(70, 58), Vector2(140, 116)), false)
		else:
			var wall_color: Color = LIGHT_WALL_COLOR if weapon == "wall_light" else (MEDIUM_WALL_COLOR if weapon == "wall_medium" else HEAVY_WALL_COLOR)
			_prect(Rect2(preview_center - Vector2(64, 38), Vector2(128, 76)), wall_color, true)
		return
	if weapon == "cannon" and cannon_turret_texture != null:
		var cannon_preview_size: Vector2 = CANNON_TURRET_DRAW_SIZE * 1.45
		draw_texture_rect_region(cannon_turret_texture, Rect2(preview_center - cannon_preview_size * 0.5 + Vector2(0, -10), cannon_preview_size), CANNON_TURRET_REGION)
		return
	if weapon == "golden" and golden_turret_texture != null:
		var golden_preview_size: Vector2 = GOLDEN_TURRET_DRAW_SIZE * 1.45
		draw_texture_rect_region(golden_turret_texture, Rect2(preview_center - golden_preview_size * 0.5 + Vector2(0, -8), golden_preview_size), GOLDEN_TURRET_REGION)
		return
	if weapon == "gun" and gun_sentry_top_texture != null and gun_sentry_bottom_texture != null:
		var gun_base_size: Vector2 = GUN_TURRET_BASE_DRAW_SIZE * 1.45
		var gun_top_size: Vector2 = GUN_TURRET_TOP_DRAW_SIZE * 1.45
		draw_texture_rect(gun_sentry_bottom_texture, Rect2(preview_center - gun_base_size * 0.5 + Vector2(0, 18), gun_base_size), false)
		draw_texture_rect(gun_sentry_top_texture, Rect2(preview_center - gun_top_size * 0.5 + Vector2(0, -12), gun_top_size), false)
		return
	if weapon == "gun" and gun_turret_texture != null:
		draw_texture_rect(gun_turret_texture, Rect2(preview_center - Vector2(68, 76), Vector2(136, 136)), false)
		return
	if weapon == "gun":
		if irs_agent_gun_texture != null:
			draw_texture_rect(irs_agent_gun_texture, Rect2(preview_center - Vector2(28, 4), Vector2(56, 24)), false)
		else:
			_draw_simple_gun_turret(preview_center + Vector2(0, 8), Vector2.RIGHT, false)
		return
	if weapon == "magic" and majestic_sentry_top_texture != null and majestic_sentry_bottom_texture != null:
		var magic_base_size: Vector2 = MAGIC_TURRET_BASE_DRAW_SIZE * 1.45
		var magic_top_size: Vector2 = MAGIC_TURRET_TOP_DRAW_SIZE * 1.45
		draw_texture_rect(majestic_sentry_bottom_texture, Rect2(preview_center - magic_base_size * 0.5 + Vector2(0, 26), magic_base_size), false)
		draw_texture_rect(majestic_sentry_top_texture, Rect2(preview_center - magic_top_size * 0.5 + Vector2(0, -20), magic_top_size), false)
		return
	if weapon == "magic" and crystal_sentry_texture != null:
		var magic_preview_size: Vector2 = MAGIC_TURRET_DRAW_SIZE * 1.35
		draw_texture_rect(crystal_sentry_texture, Rect2(preview_center - Vector2(magic_preview_size.x * 0.5, magic_preview_size.y * 0.60), magic_preview_size), false)
		return
	if turret_sprite_texture != null:
		var preview_region: Rect2 = TURRET_LOADED_REGION if weapon == "rifle" or weapon == "golden" else TURRET_IDLE_REGION
		draw_texture_rect_region(turret_sprite_texture, Rect2(preview_center - Vector2(64, 38), Vector2(128, 76)), preview_region)
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
	return Rect2(Vector2(174, 86), Vector2(932, 548))


func _update_dealer_controller_input() -> void:
	var items: Array[Dictionary] = _dealer_items(dealer_page)
	if items.is_empty():
		dealer_selected_index = 0
		return
	dealer_selected_index = clampi(dealer_selected_index, 0, items.size() - 1)
	if _replay_action_just_pressed("build_arrow_turret"):
		dealer_page = "sell" if dealer_page == "buy" else "buy"
		dealer_selected_index = 0
		_play_sfx(ui_click_sound, -17.0, 1.04)
		return
	if _replay_action_just_pressed("move_left"):
		dealer_selected_index = posmod(dealer_selected_index - 1, items.size())
	elif _replay_action_just_pressed("move_right"):
		dealer_selected_index = posmod(dealer_selected_index + 1, items.size())
	elif _replay_action_just_pressed("move_up"):
		dealer_selected_index = posmod(dealer_selected_index - 2, items.size())
	elif _replay_action_just_pressed("move_down"):
		dealer_selected_index = posmod(dealer_selected_index + 2, items.size())
	elif _replay_action_just_pressed("action"):
		_purchase_dealer_item(String(items[dealer_selected_index]["id"]))


func _dealer_items(page: String = "buy") -> Array[Dictionary]:
	var buy_items: Array[Dictionary] = [
		{"id": "unlock_gun_turret", "title": "Unlock Gun Turret", "price": DEALER_GUN_TURRET_UNLOCK_GOLD_COST, "desc": "Unlocks gun sentry builds."},
		{"id": "turret_buff", "title": "Turret Buff", "price": DEALER_TURRET_BUFF_GOLD_COST, "desc": "Permanent sentry damage +1."},
		{"id": "buy_turret_ammo", "title": "Turret Ammo", "price": DEALER_TURRET_AMMO_GOLD_COST, "desc": "Refill every non-cannon sentry."},
		{"id": "buy_cannon_shells", "title": "Cannon Shells", "price": DEALER_CANNON_SHELL_GOLD_COST, "desc": "Refill every cannon sentry."},
		{"id": "buy_wood", "title": "Wood Crate", "price": DEALER_WOOD_GOLD_COST, "desc": "+%d wood." % DEALER_WOOD_AMOUNT},
		{"id": "buy_stone", "title": "Stone Crate", "price": DEALER_STONE_GOLD_COST, "desc": "+%d stone." % DEALER_STONE_AMOUNT},
		{"id": "buy_iron", "title": "Iron Bundle", "price": DEALER_IRON_GOLD_COST, "desc": "+%d iron." % DEALER_IRON_AMOUNT},
		{"id": "buy_gunpowder", "title": "Powder Bundle", "price": DEALER_GUNPOWDER_GOLD_COST, "desc": "+%d gunpowder." % DEALER_GUNPOWDER_AMOUNT},
		{"id": "heal", "title": "Field Medkit", "price": DEALER_HEAL_GOLD_COST, "desc": "Restore Bob to full HP."},
		{"id": "energy_drink", "title": "Energy Drink", "price": DEALER_ENERGY_DRINK_GOLD_COST, "desc": "Move 45% faster for 20 seconds."}
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
	var row: int = item_index / 2
	var col: int = item_index % 2
	return Rect2(panel_rect.position + Vector2(24 + col * 442, 118 + row * 68), Vector2(420, 58))


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


func _dealer_item_can_activate(item: Dictionary) -> bool:
	var item_id := String(item.get("id", ""))
	if _dealer_item_owned(item_id):
		return false
	if dev_mode_enabled:
		return true
	match item_id:
		"sell_wood":
			return wood >= DEALER_SELL_WOOD_AMOUNT
		"sell_stone":
			return stone >= DEALER_SELL_STONE_AMOUNT
		"sell_iron":
			return iron >= DEALER_SELL_IRON_AMOUNT
		"sell_gunpowder":
			return gunpowder >= DEALER_SELL_GUNPOWDER_AMOUNT
		_:
			return gold >= int(item.get("price", 0))


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
	var wallet_before := [gold, wood, stone, iron, gunpowder, player_hp, energy_drink_timer]
	_purchase_dealer_item_inner(item_id)
	if wallet_before != [gold, wood, stone, iron, gunpowder, player_hp, energy_drink_timer]:
		var items: Array[Dictionary] = _dealer_items(dealer_page)
		for item_index in range(items.size()):
			if String(items[item_index]["id"]) == item_id:
				var item_rect: Rect2 = _dealer_item_rect(_dealer_panel_rect(), item_index)
				_add_ui_stamp(item_rect.get_center() + Vector2(70, 0), "SOLD" if item_id.begins_with("sell_") else "PAID", false)
				break


func _purchase_dealer_item_inner(item_id: String) -> void:
	_play_sfx(ui_click_sound, -18.0, 0.96)
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
		_play_sfx(pickup_sound, -17.0, 0.92)
		return
	if not dev_mode_enabled and gold < item_price:
		dealer_status_text = "Need more dollars."
		return
	if not dev_mode_enabled:
		gold -= item_price
	match item_id:
		"unlock_gun_turret":
			gun_sentry_unlocked = true
			persistent_gun_sentry_unlocked = true
			selected_sentry_kind = "gun"
			dealer_status_text = "Gun turret unlocked."
			_save_persistent_settings()
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
		"energy_drink":
			energy_drink_timer = ENERGY_DRINK_DURATION
			dealer_status_text = "Energy up! Speed boosted for 20 seconds."
	_play_sfx(pickup_sound, -16.0, 1.08)


func _draw_dealer_menu() -> void:
	if not dealer_menu_open or inside_house or inside_cave:
		return
	var panel_rect: Rect2 = _dealer_panel_rect()
	var buy_tab_rect: Rect2 = _dealer_page_rect(panel_rect, "buy")
	var sell_tab_rect: Rect2 = _dealer_page_rect(panel_rect, "sell")
	var hovered_id: String = _dealer_item_at_position(_replay_get_mouse_position())
	var ammo_totals: Dictionary = _turret_ammo_totals()
	_draw_ui_card(panel_rect, UI_WARM_ACCENT, UI_PANEL_FILL, 3.0, Vector2(0, 10))
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 36), "BOB'S TOTALLY LEGAL ARMS DEALER", HORIZONTAL_ALIGNMENT_LEFT, 520, 25, TEXT_COLOR)
	var dealer_wallet_text := "Wallet  %d$  •  Ammo %d/%d  •  Shells %d/%d" % [gold, int(ammo_totals["ammo"]), int(ammo_totals["ammo_max"]), int(ammo_totals["shells"]), int(ammo_totals["shells_max"])]
	if dealer_page == "sell":
		dealer_wallet_text = "Sell stock  •  Wood %d  Stone %d  Iron %d  Powder %d  •  Wallet %d$" % [wood, stone, iron, gunpowder, gold]
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 61), dealer_wallet_text, HORIZONTAL_ALIGNMENT_LEFT, 660, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(648, 39), "BUILD TIME  %02ds" % int(ceili(countdown)), HORIZONTAL_ALIGNMENT_RIGHT, 176, 17, UI_WARM_ACCENT)
	if arms_dealer_texture != null:
		draw_texture_rect(arms_dealer_texture, Rect2(panel_rect.position + Vector2(850, 8), Vector2(58, 104)), false)
	_draw_ui_card(buy_tab_rect, UI_WARM_ACCENT if dealer_page == "buy" else Color(1, 1, 1, 0.14), Color(0.18, 0.21, 0.24, 0.98) if dealer_page != "buy" else Color(0.22, 0.26, 0.16, 0.98), 2.0, Vector2.ZERO)
	_draw_ui_card(sell_tab_rect, UI_WARM_ACCENT if dealer_page == "sell" else Color(1, 1, 1, 0.14), Color(0.18, 0.21, 0.24, 0.98) if dealer_page != "sell" else Color(0.24, 0.18, 0.14, 0.98), 2.0, Vector2.ZERO)
	_pstr(ThemeDB.fallback_font, buy_tab_rect.position + Vector2(35, 22), "Buy", HORIZONTAL_ALIGNMENT_LEFT, 52, 18, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, sell_tab_rect.position + Vector2(34, 22), "Sell", HORIZONTAL_ALIGNMENT_LEFT, 54, 18, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(304, 94), "Gear in. Spare materials out. Receipts absolutely unavailable.", HORIZONTAL_ALIGNMENT_LEFT, 500, 14, MUTED_TEXT_COLOR)
	var items: Array[Dictionary] = _dealer_items(dealer_page)
	dealer_selected_index = clampi(dealer_selected_index, 0, maxi(items.size() - 1, 0))
	var active_item_id: String = hovered_id
	if active_item_id == "" and not items.is_empty():
		active_item_id = String(items[dealer_selected_index]["id"])
	for item_index in range(items.size()):
		var item: Dictionary = items[item_index]
		var item_rect: Rect2 = _dealer_item_rect(panel_rect, item_index)
		var owned: bool = _dealer_item_owned(String(item["id"]))
		var can_activate: bool = _dealer_item_can_activate(item)
		var hovered: bool = active_item_id == String(item["id"])
		if hovered:
			item_rect.position.y -= 4.0
		var fill_color: Color = Color(0.13, 0.16, 0.19, 0.96) if can_activate else Color(0.09, 0.10, 0.11, 0.94)
		if owned:
			fill_color = Color(0.18, 0.24, 0.18, 0.96)
		if hovered:
			fill_color = fill_color.lightened(0.08)
		var item_border := UI_WARM_ACCENT if hovered else (UI_SUCCESS_ACCENT if owned else Color(1, 1, 1, 0.12))
		_draw_ui_card(item_rect, item_border, fill_color, 2.0, Vector2(0, 3))
		var item_text_x := 14.0
		if String(item["id"]) == "energy_drink" and energy_drink_texture != null:
			draw_texture_rect(energy_drink_texture, Rect2(item_rect.position + Vector2(10, 6), Vector2(30, 44)), false)
			item_text_x = 48.0
		var item_text_color := TEXT_COLOR if can_activate or owned else MUTED_TEXT_COLOR.darkened(0.18)
		_pstr(ThemeDB.fallback_font, item_rect.position + Vector2(item_text_x, 21), String(item["title"]), HORIZONTAL_ALIGNMENT_LEFT, 252.0 - item_text_x + 14.0, 17, item_text_color)
		_pstr(ThemeDB.fallback_font, item_rect.position + Vector2(item_text_x, 43), String(item["desc"]), HORIZONTAL_ALIGNMENT_LEFT, 306.0 - item_text_x + 14.0, 13, MUTED_TEXT_COLOR)
		var price_text: String = "Owned" if owned else ("%d dollars" % int(item["price"]))
		if String(item["id"]).begins_with("sell_"):
			price_text = "+%d$" % _dealer_sell_gold_gain(String(item["id"]))
		_pstr(ThemeDB.fallback_font, item_rect.position + Vector2(item_rect.size.x - 104, 24), price_text, HORIZONTAL_ALIGNMENT_RIGHT, 88, 15, UI_SUCCESS_ACCENT if can_activate else MUTED_TEXT_COLOR)
	if active_item_id != "":
		_draw_dealer_hover_panel(Rect2(panel_rect.position + Vector2(24, 456), Vector2(884, 46)), active_item_id)
	_draw_ui_card(Rect2(panel_rect.position + Vector2(24, 510), Vector2(884, 22)), Color(1, 1, 1, 0.08), Color(0.10, 0.12, 0.14, 1.0), 1.0, Vector2.ZERO)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(36, 526), dealer_status_text + "  •  Y tab  •  A buy/sell  •  G/RB close", HORIZONTAL_ALIGNMENT_LEFT, 856, 14, TEXT_COLOR)


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
		"energy_drink":
			title = "Energy Drink"
			body = "A 20-second movement boost for fast gathering or emergencies."
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(14, 22), title, HORIZONTAL_ALIGNMENT_LEFT, panel_rect.size.x - 28.0, 18, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(178, 22), body, HORIZONTAL_ALIGNMENT_LEFT, panel_rect.size.x - 194.0, 14, MUTED_TEXT_COLOR)


func _wrap_ui_text(text: String, max_characters: int) -> Array[String]:
	var lines: Array[String] = []
	var current_line := ""
	for word in text.split(" "):
		var candidate := word if current_line == "" else "%s %s" % [current_line, word]
		if candidate.length() > max_characters and current_line != "":
			lines.append(current_line)
			current_line = word
		else:
			current_line = candidate
	if current_line != "":
		lines.append(current_line)
	return lines


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
	var panel_rect := Rect2(Vector2(318, 120), Vector2(644, 480))
	_draw_ui_card(panel_rect, UI_SUCCESS_ACCENT, UI_PANEL_FILL, 3.0, Vector2(0, 10))
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 38), "Inventory", HORIZONTAL_ALIGNMENT_LEFT, 220, 30, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, panel_rect.position + Vector2(28, 64), "Press E or Esc to close", HORIZONTAL_ALIGNMENT_LEFT, 240, 16, MUTED_TEXT_COLOR)
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
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(42, 24), "%d/%d" % [player_hp, hp_total], HORIZONTAL_ALIGNMENT_LEFT, 104, 18, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(168, 24), "Carry %d/%d" % [total_carried, carry_limit], HORIZONTAL_ALIGNMENT_LEFT, 144, 18, Color(1.0, 0.84, 0.52) if total_carried >= carry_limit else TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(332, 24), "Round %d" % round_number, HORIZONTAL_ALIGNMENT_LEFT, 96, 18, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(444, 24), phase_text, HORIZONTAL_ALIGNMENT_LEFT, 94, 18, UI_COOL_ACCENT)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(16, 52), "House %d/%d" % [_house_integrity_left(), HOUSE_MAX_DAMAGE_STAGES], HORIZONTAL_ALIGNMENT_LEFT, 120, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(168, 52), "Ammo %d/%d" % [int(ammo_totals["ammo"]), int(ammo_totals["ammo_max"])], HORIZONTAL_ALIGNMENT_LEFT, 134, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(332, 52), "Shells %d/%d" % [int(ammo_totals["shells"]), int(ammo_totals["shells_max"])], HORIZONTAL_ALIGNMENT_LEFT, 132, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, stats_rect.position + Vector2(474, 52), location_text, HORIZONTAL_ALIGNMENT_LEFT, 90, 16, MUTED_TEXT_COLOR)

	var left_rect := Rect2(panel_rect.position + Vector2(26, 190), Vector2(272, 142))
	var right_rect := Rect2(panel_rect.position + Vector2(346, 190), Vector2(272, 142))
	_draw_ui_card(left_rect, Color(1, 1, 1, 0.10), UI_PANEL_FILL_SOFT, 1.0)
	_draw_ui_card(right_rect, Color(1, 1, 1, 0.10), UI_PANEL_FILL_SOFT, 1.0)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(16, 24), "Materials", HORIZONTAL_ALIGNMENT_LEFT, 180, 20, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(16, 52), "Wood: %d" % wood, HORIZONTAL_ALIGNMENT_LEFT, 100, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(16, 78), "Stone: %d" % stone, HORIZONTAL_ALIGNMENT_LEFT, 100, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(16, 104), "Iron: %d" % iron, HORIZONTAL_ALIGNMENT_LEFT, 100, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(132, 52), "Powder: %d" % gunpowder, HORIZONTAL_ALIGNMENT_LEFT, 116, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(132, 78), "Dollars: %d" % gold, HORIZONTAL_ALIGNMENT_LEFT, 116, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, left_rect.position + Vector2(132, 104), "Crystals: %d" % cave_crystals_owned, HORIZONTAL_ALIGNMENT_LEFT, 116, 16, MUTED_TEXT_COLOR)

	_pstr(ThemeDB.fallback_font, right_rect.position + Vector2(16, 24), "Run Status", HORIZONTAL_ALIGNMENT_LEFT, 180, 20, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, right_rect.position + Vector2(16, 52), "Safe house items: %d" % house_items.size(), HORIZONTAL_ALIGNMENT_LEFT, 180, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, right_rect.position + Vector2(16, 78), "Stolen by IRS: %d" % stolen_house_items.size(), HORIZONTAL_ALIGNMENT_LEFT, 180, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, right_rect.position + Vector2(16, 104), "Selected build: %s" % _sentry_label(selected_sentry_kind), HORIZONTAL_ALIGNMENT_LEFT, 220, 16, MUTED_TEXT_COLOR)

	var audio_rect := Rect2(panel_rect.position + Vector2(26, 344), Vector2(592, 88))
	_draw_ui_card(audio_rect, Color(1, 1, 1, 0.10), UI_PANEL_FILL_SOFT, 1.0)
	_pstr(ThemeDB.fallback_font, audio_rect.position + Vector2(16, 24), "NOW PLAYING  •  %s" % _current_main_music_title(), HORIZONTAL_ALIGNMENT_LEFT, 278, 15, TEXT_COLOR)
	var visualizer_rect := Rect2(audio_rect.position + Vector2(306, 10), Vector2(270, 24))
	var visualizer_bands := _music_visualizer_bands(18)
	var visualizer_gap := 3.0
	var visualizer_bar_width: float = (visualizer_rect.size.x - visualizer_gap * float(visualizer_bands.size() - 1)) / float(visualizer_bands.size())
	for band_index in range(visualizer_bands.size()):
		var band_height: float = maxf(2.0, visualizer_rect.size.y * visualizer_bands[band_index])
		var band_position := Vector2(visualizer_rect.position.x + float(band_index) * (visualizer_bar_width + visualizer_gap), visualizer_rect.end.y - band_height)
		var band_color := UI_WARM_ACCENT.lerp(MAGIC_COLOR, float(band_index) / maxf(float(visualizer_bands.size() - 1), 1.0))
		_prect(Rect2(band_position, Vector2(visualizer_bar_width, band_height)), _with_alpha(band_color, 0.88), true)
	_pstr(ThemeDB.fallback_font, audio_rect.position + Vector2(16, 60), "Music", HORIZONTAL_ALIGNMENT_LEFT, 56, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, audio_rect.position + Vector2(236, 60), "%d%%" % int(round(music_volume_percent)), HORIZONTAL_ALIGNMENT_LEFT, 56, 16, TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, audio_rect.position + Vector2(310, 60), "SFX", HORIZONTAL_ALIGNMENT_LEFT, 40, 16, MUTED_TEXT_COLOR)
	_pstr(ThemeDB.fallback_font, audio_rect.position + Vector2(532, 60), "%d%%" % int(round(sfx_volume_percent)), HORIZONTAL_ALIGNMENT_LEFT, 48, 16, TEXT_COLOR)

	if dev_mode_enabled:
		var dev_rect := Rect2(panel_rect.position + Vector2(26, 438), Vector2(592, 38))
		_draw_ui_card(dev_rect, MAGIC_COLOR, Color(0.10, 0.07, 0.14, 0.98), 2.0, Vector2.ZERO)
		_pstr(ThemeDB.fallback_font, dev_rect.position + Vector2(204, 25), "Simulation speed", HORIZONTAL_ALIGNMENT_LEFT, 130, 14, MUTED_TEXT_COLOR)
	else:
		var tip_rect := Rect2(panel_rect.position + Vector2(26, 450), Vector2(592, 18))
		_draw_ui_card(tip_rect, Color(1, 1, 1, 0.08), Color(0.10, 0.12, 0.14, 1.0), 1.0, Vector2.ZERO)
		_pstr(ThemeDB.fallback_font, tip_rect.position + Vector2(14, 14), "Materials stay here until a build or trade needs them.", HORIZONTAL_ALIGNMENT_LEFT, 560, 14, MUTED_TEXT_COLOR)


func _open_credit_url(url: String) -> void:
	if url.begins_with("https://"):
		OS.shell_open(url)


func _add_credit_link(parent: Control, label_text: String, url: String, link_position: Vector2, link_size: Vector2) -> void:
	var credit_link := LinkButton.new()
	credit_link.position = link_position
	credit_link.size = link_size
	credit_link.text = label_text
	credit_link.tooltip_text = url
	credit_link.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	credit_link.add_theme_font_size_override("font_size", 14)
	credit_link.add_theme_color_override("font_color", Color(0.70, 0.86, 1.0))
	credit_link.add_theme_color_override("font_hover_color", Color(1.0, 0.88, 0.42))
	credit_link.add_theme_color_override("font_pressed_color", Color(0.96, 0.74, 0.28))
	credit_link.pressed.connect(_open_credit_url.bind(url))
	parent.add_child(credit_link)


func _build_hud() -> void:
	menu_panel = ColorRect.new()
	menu_panel.position = Vector2(164, 86)
	menu_panel.size = Vector2(952, 548)
	menu_panel.color = Color(0.03, 0.05, 0.07, 0.76)
	add_child(menu_panel)

	menu_title_label = Label.new()
	menu_title_label.position = Vector2(72, 34)
	menu_title_label.size = Vector2(808, 64)
	menu_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_title_label.add_theme_font_size_override("font_size", 48)
	menu_title_label.modulate = TEXT_COLOR
	menu_title_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.82))
	menu_title_label.add_theme_constant_override("shadow_offset_x", 3)
	menu_title_label.add_theme_constant_override("shadow_offset_y", 4)
	menu_panel.add_child(menu_title_label)

	menu_state_badge_label = Label.new()
	menu_state_badge_label.position = Vector2(371, -20)
	menu_state_badge_label.size = Vector2(210, 38)
	menu_state_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_state_badge_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	menu_state_badge_label.rotation = -0.035
	menu_state_badge_label.add_theme_font_size_override("font_size", 17)
	menu_state_badge_label.add_theme_color_override("font_color", Color(0.98, 0.86, 0.50))
	menu_state_badge_label.add_theme_stylebox_override("normal", _make_flat_style(Color(0.12, 0.09, 0.05, 0.82), Color(0.98, 0.76, 0.28, 0.72), 2, 8))
	menu_state_badge_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_panel.add_child(menu_state_badge_label)

	menu_desc_label = Label.new()
	menu_desc_label.position = Vector2(86, 104)
	menu_desc_label.size = Vector2(780, 130)
	menu_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	menu_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_desc_label.add_theme_font_size_override("font_size", 24)
	menu_desc_label.modulate = MUTED_TEXT_COLOR
	menu_panel.add_child(menu_desc_label)

	menu_info_label = Label.new()
	menu_info_label.position = Vector2(82, 246)
	menu_info_label.size = Vector2(788, 52)
	menu_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_info_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	menu_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_info_label.add_theme_font_size_override("font_size", 18)
	menu_info_label.modulate = Color(0.94, 0.90, 0.78)
	menu_panel.add_child(menu_info_label)

	menu_start_button = Button.new()
	menu_start_button.position = Vector2(326, 310)
	menu_start_button.size = Vector2(300, 54)
	menu_start_button.text = "New Game"
	_style_menu_art_button(menu_start_button, MENU_UI_NEW_GAME_REGION)
	menu_start_button.pressed.connect(_on_menu_start_pressed)
	menu_panel.add_child(menu_start_button)

	menu_settings_button = Button.new()
	menu_settings_button.position = Vector2(326, 374)
	menu_settings_button.size = Vector2(300, 58)
	menu_settings_button.text = "Settings"
	_style_menu_art_button(menu_settings_button, MENU_UI_SETTINGS_REGION)
	menu_settings_button.pressed.connect(_on_menu_settings_pressed)
	menu_panel.add_child(menu_settings_button)

	menu_tutorial_button = Button.new()
	menu_tutorial_button.position = Vector2(326, 442)
	menu_tutorial_button.size = Vector2(300, 48)
	menu_tutorial_button.text = "[x]  Guided tutorial"
	_style_paper_checkbox(menu_tutorial_button)
	menu_tutorial_button.pressed.connect(_on_menu_tutorial_pressed)
	menu_panel.add_child(menu_tutorial_button)

	menu_dev_button = Button.new()
	menu_dev_button.position = Vector2(810, 18)
	menu_dev_button.size = Vector2(124, 40)
	menu_dev_button.text = "Dev Tools"
	menu_dev_button.tooltip_text = "Dev Mode (PIN protected)"
	_style_menu_art_button(menu_dev_button, MENU_UI_DEV_MODE_REGION)
	menu_dev_button.pressed.connect(_on_menu_dev_pressed)
	menu_panel.add_child(menu_dev_button)

	menu_leaderboard_button = Button.new()
	menu_leaderboard_button.position = Vector2(796, 18)
	menu_leaderboard_button.size = Vector2(142, 40)
	menu_leaderboard_button.text = "Leaderboard"
	_style_action_button(menu_leaderboard_button, UI_WARM_ACCENT)
	menu_leaderboard_button.pressed.connect(_on_menu_leaderboard_pressed)
	menu_panel.add_child(menu_leaderboard_button)

	menu_credits_button = Button.new()
	menu_credits_button.position = Vector2(18, 18)
	menu_credits_button.size = Vector2(124, 40)
	menu_credits_button.text = "Credits"
	_style_action_button(menu_credits_button, UI_COOL_ACCENT)
	menu_credits_button.pressed.connect(_on_menu_credits_pressed)
	menu_panel.add_child(menu_credits_button)

	menu_continue_hint_label = Label.new()
	menu_continue_hint_label.position = Vector2(112, 502)
	menu_continue_hint_label.size = Vector2(728, 32)
	menu_continue_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_continue_hint_label.add_theme_font_size_override("font_size", 18)
	menu_continue_hint_label.modulate = Color(0.92, 0.90, 0.78)
	menu_panel.add_child(menu_continue_hint_label)

	menu_settings_panel = ColorRect.new()
	menu_settings_panel.position = Vector2(166, 24)
	menu_settings_panel.size = Vector2(620, 500)
	menu_settings_panel.color = Color(0.04, 0.06, 0.08, 0.96)
	menu_settings_panel.visible = false
	menu_panel.add_child(menu_settings_panel)

	var settings_left_card := Panel.new()
	settings_left_card.position = Vector2(8, 38)
	settings_left_card.size = Vector2(284, 406)
	settings_left_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	settings_left_card.add_theme_stylebox_override("panel", _make_flat_style(Color(0.08, 0.10, 0.12, 0.92), Color(0.96, 0.78, 0.34, 0.28), 1, 10))
	menu_settings_panel.add_child(settings_left_card)

	var settings_right_card := Panel.new()
	settings_right_card.position = Vector2(308, 38)
	settings_right_card.size = Vector2(304, 406)
	settings_right_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	settings_right_card.add_theme_stylebox_override("panel", _make_flat_style(Color(0.07, 0.09, 0.12, 0.92), Color(0.54, 0.72, 0.98, 0.28), 1, 10))
	menu_settings_panel.add_child(settings_right_card)

	var settings_title_label := Label.new()
	settings_title_label.position = Vector2(18, 10)
	settings_title_label.size = Vector2(584, 26)
	settings_title_label.add_theme_font_size_override("font_size", 20)
	settings_title_label.modulate = TEXT_COLOR
	settings_title_label.text = "Settings  /  Fine Print"
	menu_settings_panel.add_child(settings_title_label)

	var music_volume_label := Label.new()
	music_volume_label.position = Vector2(18, 44)
	music_volume_label.size = Vector2(180, 22)
	music_volume_label.add_theme_font_size_override("font_size", 18)
	music_volume_label.modulate = TEXT_COLOR
	music_volume_label.text = "Music Volume"
	menu_settings_panel.add_child(music_volume_label)

	music_volume_slider = HSlider.new()
	music_volume_slider.position = Vector2(18, 70)
	music_volume_slider.size = Vector2(174, 24)
	music_volume_slider.min_value = 0.0
	music_volume_slider.max_value = 100.0
	music_volume_slider.step = 1.0
	music_volume_slider.modulate = UI_WARM_ACCENT
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	music_volume_slider.value = music_volume_percent
	menu_settings_panel.add_child(music_volume_slider)

	music_volume_value_label = Label.new()
	music_volume_value_label.position = Vector2(202, 68)
	music_volume_value_label.size = Vector2(62, 28)
	music_volume_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	music_volume_value_label.add_theme_font_size_override("font_size", 18)
	music_volume_value_label.modulate = MUTED_TEXT_COLOR
	menu_settings_panel.add_child(music_volume_value_label)

	var sfx_volume_label := Label.new()
	sfx_volume_label.position = Vector2(18, 108)
	sfx_volume_label.size = Vector2(180, 22)
	sfx_volume_label.add_theme_font_size_override("font_size", 18)
	sfx_volume_label.modulate = TEXT_COLOR
	sfx_volume_label.text = "SFX Volume"
	menu_settings_panel.add_child(sfx_volume_label)

	sfx_volume_slider = HSlider.new()
	sfx_volume_slider.position = Vector2(18, 134)
	sfx_volume_slider.size = Vector2(174, 24)
	sfx_volume_slider.min_value = 0.0
	sfx_volume_slider.max_value = 100.0
	sfx_volume_slider.step = 1.0
	sfx_volume_slider.modulate = UI_COOL_ACCENT
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	sfx_volume_slider.value = sfx_volume_percent
	menu_settings_panel.add_child(sfx_volume_slider)

	sfx_volume_value_label = Label.new()
	sfx_volume_value_label.position = Vector2(202, 132)
	sfx_volume_value_label.size = Vector2(62, 28)
	sfx_volume_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	sfx_volume_value_label.add_theme_font_size_override("font_size", 18)
	sfx_volume_value_label.modulate = MUTED_TEXT_COLOR
	menu_settings_panel.add_child(sfx_volume_value_label)

	var effects_settings_label := Label.new()
	effects_settings_label.position = Vector2(18, 170)
	effects_settings_label.size = Vector2(264, 24)
	effects_settings_label.add_theme_font_size_override("font_size", 18)
	effects_settings_label.modulate = TEXT_COLOR
	effects_settings_label.text = "Visual Effects"
	menu_settings_panel.add_child(effects_settings_label)

	menu_effects_button = Button.new()
	menu_effects_button.position = Vector2(18, 198)
	menu_effects_button.size = Vector2(264, 36)
	menu_effects_button.text = "Effects: %s" % ("High" if effects_quality_high else "Low")
	_style_action_button(menu_effects_button, UI_WARM_ACCENT)
	menu_effects_button.pressed.connect(_toggle_effects_quality)
	menu_settings_panel.add_child(menu_effects_button)

	var screen_shake_label := Label.new()
	screen_shake_label.position = Vector2(18, 242)
	screen_shake_label.size = Vector2(160, 22)
	screen_shake_label.add_theme_font_size_override("font_size", 16)
	screen_shake_label.modulate = MUTED_TEXT_COLOR
	screen_shake_label.text = "Screen Shake"
	menu_settings_panel.add_child(screen_shake_label)

	screen_shake_slider = HSlider.new()
	screen_shake_slider.position = Vector2(18, 267)
	screen_shake_slider.size = Vector2(174, 24)
	screen_shake_slider.min_value = 0.0
	screen_shake_slider.max_value = 100.0
	screen_shake_slider.step = 5.0
	screen_shake_slider.modulate = UI_DANGER_ACCENT
	screen_shake_slider.value = screen_shake_percent
	screen_shake_slider.value_changed.connect(_on_screen_shake_changed)
	menu_settings_panel.add_child(screen_shake_slider)

	screen_shake_value_label = Label.new()
	screen_shake_value_label.position = Vector2(202, 265)
	screen_shake_value_label.size = Vector2(62, 28)
	screen_shake_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	screen_shake_value_label.add_theme_font_size_override("font_size", 18)
	screen_shake_value_label.modulate = MUTED_TEXT_COLOR
	screen_shake_value_label.text = "%d%%" % int(round(screen_shake_percent))
	menu_settings_panel.add_child(screen_shake_value_label)

	var display_settings_label := Label.new()
	display_settings_label.position = Vector2(18, 302)
	display_settings_label.size = Vector2(264, 24)
	display_settings_label.add_theme_font_size_override("font_size", 18)
	display_settings_label.modulate = TEXT_COLOR
	display_settings_label.text = "Display"
	menu_settings_panel.add_child(display_settings_label)

	menu_fullscreen_button = Button.new()
	menu_fullscreen_button.position = Vector2(18, 330)
	menu_fullscreen_button.size = Vector2(264, 42)
	menu_fullscreen_button.text = "Fullscreen: %s" % ("On" if fullscreen_enabled else "Off")
	_style_action_button(menu_fullscreen_button, UI_COOL_ACCENT)
	menu_fullscreen_button.pressed.connect(_toggle_fullscreen)
	menu_settings_panel.add_child(menu_fullscreen_button)

	var fullscreen_hint := Label.new()
	fullscreen_hint.position = Vector2(18, 378)
	fullscreen_hint.size = Vector2(264, 20)
	fullscreen_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fullscreen_hint.add_theme_font_size_override("font_size", 14)
	fullscreen_hint.modulate = MUTED_TEXT_COLOR
	fullscreen_hint.text = "F11 toggles fullscreen anytime"
	menu_settings_panel.add_child(fullscreen_hint)

	var gameplay_settings_label := Label.new()
	gameplay_settings_label.position = Vector2(320, 44)
	gameplay_settings_label.size = Vector2(282, 24)
	gameplay_settings_label.add_theme_font_size_override("font_size", 18)
	gameplay_settings_label.modulate = TEXT_COLOR
	gameplay_settings_label.text = "Gameplay & Readability"
	menu_settings_panel.add_child(gameplay_settings_label)

	menu_minimal_hud_button = Button.new()
	menu_minimal_hud_button.position = Vector2(320, 72)
	menu_minimal_hud_button.size = Vector2(282, 36)
	_style_action_button(menu_minimal_hud_button, UI_SUCCESS_ACCENT)
	menu_minimal_hud_button.pressed.connect(_toggle_minimal_hud)
	menu_settings_panel.add_child(menu_minimal_hud_button)

	menu_damage_numbers_button = Button.new()
	menu_damage_numbers_button.position = Vector2(320, 114)
	menu_damage_numbers_button.size = Vector2(282, 36)
	_style_action_button(menu_damage_numbers_button, UI_WARM_ACCENT)
	menu_damage_numbers_button.pressed.connect(_toggle_damage_numbers)
	menu_settings_panel.add_child(menu_damage_numbers_button)

	menu_low_health_button = Button.new()
	menu_low_health_button.position = Vector2(320, 156)
	menu_low_health_button.size = Vector2(282, 36)
	_style_action_button(menu_low_health_button, UI_DANGER_ACCENT)
	menu_low_health_button.pressed.connect(_toggle_low_health_warning)
	menu_settings_panel.add_child(menu_low_health_button)

	menu_control_prompts_button = Button.new()
	menu_control_prompts_button.position = Vector2(320, 198)
	menu_control_prompts_button.size = Vector2(282, 36)
	_style_action_button(menu_control_prompts_button, UI_COOL_ACCENT)
	menu_control_prompts_button.pressed.connect(_toggle_auto_control_prompts)
	menu_settings_panel.add_child(menu_control_prompts_button)

	menu_motion_button = Button.new()
	menu_motion_button.position = Vector2(320, 240)
	menu_motion_button.size = Vector2(282, 36)
	_style_action_button(menu_motion_button, MAGIC_COLOR)
	menu_motion_button.pressed.connect(_toggle_menu_motion)
	menu_settings_panel.add_child(menu_motion_button)

	var dev_settings_label := Label.new()
	dev_settings_label.position = Vector2(320, 294)
	dev_settings_label.size = Vector2(282, 24)
	dev_settings_label.add_theme_font_size_override("font_size", 18)
	dev_settings_label.modulate = MAGIC_COLOR
	dev_settings_label.text = "Dev Run Controls"
	menu_settings_panel.add_child(dev_settings_label)

	menu_dev_invincible_button = Button.new()
	menu_dev_invincible_button.position = Vector2(320, 322)
	menu_dev_invincible_button.size = Vector2(282, 36)
	_style_action_button(menu_dev_invincible_button, MAGIC_COLOR)
	menu_dev_invincible_button.pressed.connect(_toggle_dev_invincible)
	menu_settings_panel.add_child(menu_dev_invincible_button)

	var dev_speed_label := Label.new()
	dev_speed_label.position = Vector2(320, 368)
	dev_speed_label.size = Vector2(170, 22)
	dev_speed_label.add_theme_font_size_override("font_size", 16)
	dev_speed_label.modulate = MUTED_TEXT_COLOR
	dev_speed_label.text = "Simulation Speed"
	menu_settings_panel.add_child(dev_speed_label)

	menu_dev_speed_slider = HSlider.new()
	menu_dev_speed_slider.position = Vector2(320, 394)
	menu_dev_speed_slider.size = Vector2(190, 24)
	menu_dev_speed_slider.min_value = 25.0
	menu_dev_speed_slider.max_value = 400.0
	menu_dev_speed_slider.step = 25.0
	menu_dev_speed_slider.modulate = MAGIC_COLOR
	menu_dev_speed_slider.value_changed.connect(_on_dev_speed_changed)
	menu_settings_panel.add_child(menu_dev_speed_slider)

	menu_dev_speed_value_label = Label.new()
	menu_dev_speed_value_label.position = Vector2(520, 392)
	menu_dev_speed_value_label.size = Vector2(72, 28)
	menu_dev_speed_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	menu_dev_speed_value_label.add_theme_font_size_override("font_size", 18)
	menu_settings_panel.add_child(menu_dev_speed_value_label)

	menu_dev_settings_hint_label = Label.new()
	menu_dev_settings_hint_label.position = Vector2(320, 424)
	menu_dev_settings_hint_label.size = Vector2(282, 20)
	menu_dev_settings_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_dev_settings_hint_label.add_theme_font_size_override("font_size", 13)
	menu_dev_settings_hint_label.modulate = MUTED_TEXT_COLOR
	menu_dev_settings_hint_label.text = "Unlock Dev Tools first • PIN protected"
	menu_settings_panel.add_child(menu_dev_settings_hint_label)

	var settings_back_button := Button.new()
	settings_back_button.position = Vector2(240, 452)
	settings_back_button.size = Vector2(140, 38)
	settings_back_button.text = "Back"
	_style_action_button(settings_back_button, UI_WARM_ACCENT)
	settings_back_button.pressed.connect(_on_menu_settings_pressed)
	menu_settings_panel.add_child(settings_back_button)
	_refresh_settings_buttons()

	inventory_music_volume_slider = HSlider.new()
	inventory_music_volume_slider.position = Vector2(424, 503)
	inventory_music_volume_slider.size = Vector2(150, 24)
	inventory_music_volume_slider.min_value = 0.0
	inventory_music_volume_slider.max_value = 100.0
	inventory_music_volume_slider.step = 1.0
	inventory_music_volume_slider.modulate = UI_WARM_ACCENT
	inventory_music_volume_slider.value = music_volume_percent
	inventory_music_volume_slider.value_changed.connect(_on_music_volume_changed)
	inventory_music_volume_slider.visible = false
	add_child(inventory_music_volume_slider)

	inventory_sfx_volume_slider = HSlider.new()
	inventory_sfx_volume_slider.position = Vector2(714, 503)
	inventory_sfx_volume_slider.size = Vector2(150, 24)
	inventory_sfx_volume_slider.min_value = 0.0
	inventory_sfx_volume_slider.max_value = 100.0
	inventory_sfx_volume_slider.step = 1.0
	inventory_sfx_volume_slider.modulate = UI_COOL_ACCENT
	inventory_sfx_volume_slider.value = sfx_volume_percent
	inventory_sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	inventory_sfx_volume_slider.visible = false
	add_child(inventory_sfx_volume_slider)

	inventory_dev_invincible_button = Button.new()
	inventory_dev_invincible_button.position = Vector2(360, 562)
	inventory_dev_invincible_button.size = Vector2(176, 30)
	inventory_dev_invincible_button.text = "Invincible  OFF"
	_style_action_button(inventory_dev_invincible_button, MAGIC_COLOR)
	inventory_dev_invincible_button.pressed.connect(_toggle_dev_invincible)
	inventory_dev_invincible_button.visible = false
	add_child(inventory_dev_invincible_button)

	inventory_dev_speed_slider = HSlider.new()
	inventory_dev_speed_slider.position = Vector2(642, 564)
	inventory_dev_speed_slider.size = Vector2(164, 24)
	inventory_dev_speed_slider.min_value = 25.0
	inventory_dev_speed_slider.max_value = 400.0
	inventory_dev_speed_slider.step = 25.0
	inventory_dev_speed_slider.modulate = MAGIC_COLOR
	inventory_dev_speed_slider.value_changed.connect(_on_dev_speed_changed)
	inventory_dev_speed_slider.visible = false
	add_child(inventory_dev_speed_slider)

	inventory_dev_speed_value_label = Label.new()
	inventory_dev_speed_value_label.position = Vector2(814, 562)
	inventory_dev_speed_value_label.size = Vector2(72, 28)
	inventory_dev_speed_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	inventory_dev_speed_value_label.add_theme_font_size_override("font_size", 17)
	inventory_dev_speed_value_label.modulate = TEXT_COLOR
	inventory_dev_speed_value_label.visible = false
	add_child(inventory_dev_speed_value_label)

	menu_credits_panel = ColorRect.new()
	menu_credits_panel.position = Vector2(56, 38)
	menu_credits_panel.size = Vector2(840, 474)
	menu_credits_panel.color = Color(0.04, 0.06, 0.08, 0.98)
	menu_credits_panel.visible = false
	menu_panel.add_child(menu_credits_panel)

	var credits_title_label := Label.new()
	credits_title_label.position = Vector2(24, 10)
	credits_title_label.size = Vector2(792, 40)
	credits_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits_title_label.add_theme_font_size_override("font_size", 30)
	credits_title_label.modulate = TEXT_COLOR
	credits_title_label.text = "Credits"
	menu_credits_panel.add_child(credits_title_label)

	var team_logo_image := TextureRect.new()
	team_logo_image.name = "FoundryEightLogo"
	team_logo_image.position = Vector2(27, 52)
	team_logo_image.size = Vector2(112, 112)
	team_logo_image.texture = team_logo_texture
	team_logo_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	team_logo_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	team_logo_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_credits_panel.add_child(team_logo_image)

	var credits_studio_label := Label.new()
	credits_studio_label.position = Vector2(160, 52)
	credits_studio_label.size = Vector2(650, 28)
	credits_studio_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	credits_studio_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	credits_studio_label.add_theme_font_size_override("font_size", 20)
	credits_studio_label.modulate = Color(1.0, 0.78, 0.26)
	credits_studio_label.text = "A game by Foundry Eight"
	menu_credits_panel.add_child(credits_studio_label)
	for team_index in range(TEAM_CREDIT_LINES.size()):
		var team_credit_label := Label.new()
		team_credit_label.position = Vector2(160, 78 + team_index * 22)
		team_credit_label.size = Vector2(650, 20)
		team_credit_label.add_theme_font_size_override("font_size", 14)
		team_credit_label.modulate = TEXT_COLOR if team_index == 0 else MUTED_TEXT_COLOR
		team_credit_label.text = String(TEAM_CREDIT_LINES[team_index])
		menu_credits_panel.add_child(team_credit_label)
	var credits_divider := ColorRect.new()
	credits_divider.position = Vector2(24, 170)
	credits_divider.size = Vector2(792, 2)
	credits_divider.color = Color(1.0, 0.78, 0.26, 0.42)
	menu_credits_panel.add_child(credits_divider)

	var music_links_title := Label.new()
	music_links_title.position = Vector2(28, 182)
	music_links_title.size = Vector2(390, 24)
	music_links_title.add_theme_font_size_override("font_size", 17)
	music_links_title.modulate = TEXT_COLOR
	music_links_title.text = "Music - click to open"
	menu_credits_panel.add_child(music_links_title)
	for music_index in range(MUSIC_CREDIT_LINKS.size()):
		var music_credit: Dictionary = MUSIC_CREDIT_LINKS[music_index]
		_add_credit_link(menu_credits_panel, String(music_credit["label"]), String(music_credit["url"]), Vector2(28, 208 + music_index * 24), Vector2(400, 22))

	var sfx_links_title := Label.new()
	sfx_links_title.position = Vector2(454, 182)
	sfx_links_title.size = Vector2(358, 24)
	sfx_links_title.add_theme_font_size_override("font_size", 17)
	sfx_links_title.modulate = TEXT_COLOR
	sfx_links_title.text = "Sound effects - click to open"
	menu_credits_panel.add_child(sfx_links_title)
	for sfx_index in range(SFX_CREDIT_LINKS.size()):
		var sfx_credit: Dictionary = SFX_CREDIT_LINKS[sfx_index]
		_add_credit_link(menu_credits_panel, String(sfx_credit["label"]), String(sfx_credit["url"]), Vector2(454, 208 + sfx_index * 24), Vector2(358, 22))

	var engine_credit_label := Label.new()
	engine_credit_label.position = Vector2(454, 290)
	engine_credit_label.size = Vector2(358, 24)
	engine_credit_label.add_theme_font_size_override("font_size", 15)
	engine_credit_label.modulate = MUTED_TEXT_COLOR
	engine_credit_label.text = "Made with Godot Engine"
	menu_credits_panel.add_child(engine_credit_label)

	var credits_thanks_label := Label.new()
	credits_thanks_label.position = Vector2(32, 358)
	credits_thanks_label.size = Vector2(776, 30)
	credits_thanks_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits_thanks_label.add_theme_font_size_override("font_size", 20)
	credits_thanks_label.modulate = Color(0.96, 0.86, 0.56)
	credits_thanks_label.text = "Thanks for playing!"
	menu_credits_panel.add_child(credits_thanks_label)

	menu_credits_back_button = Button.new()
	menu_credits_back_button.position = Vector2(350, 414)
	menu_credits_back_button.size = Vector2(140, 36)
	menu_credits_back_button.text = "Back"
	_style_action_button(menu_credits_back_button, UI_WARM_ACCENT)
	menu_credits_back_button.pressed.connect(_close_menu_credits)
	menu_credits_panel.add_child(menu_credits_back_button)

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
	music_credit_body_label.text = "Music by SovieticoOfficial"
	music_credit_panel.add_child(music_credit_body_label)

	menu_dev_panel = ColorRect.new()
	menu_dev_panel.position = Vector2(264, 164)
	menu_dev_panel.size = Vector2(424, 204)
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
	menu_dev_unlock_button.position = Vector2(76, 120)
	menu_dev_unlock_button.size = Vector2(128, 38)
	menu_dev_unlock_button.text = "Unlock"
	_style_action_button(menu_dev_unlock_button, UI_WARM_ACCENT)
	menu_dev_unlock_button.pressed.connect(_on_menu_dev_unlock_pressed)
	menu_dev_panel.add_child(menu_dev_unlock_button)

	var menu_dev_back_button := Button.new()
	menu_dev_back_button.position = Vector2(220, 120)
	menu_dev_back_button.size = Vector2(128, 38)
	menu_dev_back_button.text = "Back"
	_style_action_button(menu_dev_back_button, UI_COOL_ACCENT)
	menu_dev_back_button.pressed.connect(_close_dev_mode_prompt)
	menu_dev_panel.add_child(menu_dev_back_button)

	menu_dev_status_label = Label.new()
	menu_dev_status_label.position = Vector2(24, 168)
	menu_dev_status_label.size = Vector2(376, 18)
	menu_dev_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_dev_status_label.add_theme_font_size_override("font_size", 14)
	menu_dev_status_label.modulate = Color(0.92, 0.90, 0.78)
	menu_dev_status_label.text = "Protected team tools"
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
	hint_label.position = Vector2(170, 670)
	hint_label.size = Vector2(940, 38)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.add_theme_font_size_override("font_size", 16)
	hint_label.modulate = MUTED_TEXT_COLOR
	hint_label.add_theme_stylebox_override("normal", _make_flat_style(Color(0.04, 0.06, 0.08, 0.90), Color(1, 1, 1, 0.14), 1, 10))
	add_child(hint_label)

	overlay_label = Label.new()
	overlay_label.position = Vector2(180, 220)
	overlay_label.size = Vector2(920, 220)
	overlay_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	overlay_label.add_theme_font_size_override("font_size", 36)
	overlay_label.modulate = TEXT_COLOR
	add_child(overlay_label)

	_build_revive_offer_ui()
	_apply_audio_settings()


func _build_revive_offer_ui() -> void:
	revive_offer_panel = ColorRect.new()
	revive_offer_panel.name = "ReviveOffer"
	revive_offer_panel.position = Vector2.ZERO
	revive_offer_panel.size = SCREEN_SIZE
	revive_offer_panel.color = Color(0.01, 0.012, 0.016, 0.88)
	revive_offer_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	revive_offer_panel.z_index = 120
	revive_offer_panel.z_as_relative = false
	revive_offer_panel.visible = false
	add_child(revive_offer_panel)

	var offer_card := Panel.new()
	offer_card.name = "OfferCard"
	offer_card.position = Vector2(298, 146)
	offer_card.size = Vector2(684, 428)
	offer_card.add_theme_stylebox_override("panel", _make_flat_style(Color(0.04, 0.045, 0.055, 0.98), Color(0.96, 0.76, 0.34, 0.78), 2, 16))
	revive_offer_panel.add_child(offer_card)

	var sponsor_label := Label.new()
	sponsor_label.position = Vector2(42, 30)
	sponsor_label.size = Vector2(600, 26)
	sponsor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sponsor_label.add_theme_font_size_override("font_size", 15)
	sponsor_label.modulate = Color(0.78, 0.78, 0.78)
	sponsor_label.text = "A MESSAGE FROM LETERNAME TECHNOLOGIES"
	offer_card.add_child(sponsor_label)

	var offer_title := Label.new()
	offer_title.position = Vector2(42, 70)
	offer_title.size = Vector2(600, 58)
	offer_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	offer_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	offer_title.add_theme_font_size_override("font_size", 36)
	offer_title.modulate = UI_WARM_ACCENT
	offer_title.text = "RESTORE BOB'S ASSETS?"
	offer_card.add_child(offer_title)

	var offer_body := Label.new()
	offer_body.position = Vector2(70, 134)
	offer_body.size = Vector2(544, 108)
	offer_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	offer_body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	offer_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	offer_body.add_theme_font_size_override("font_size", 19)
	offer_body.modulate = TEXT_COLOR
	offer_body.text = "Watch one 30-second sponsored presentation to restore the trophy,\nrepair Bob and his defenses, and clear this round.\nOne offer per run."
	offer_card.add_child(offer_body)

	revive_offer_countdown_label = Label.new()
	revive_offer_countdown_label.position = Vector2(100, 258)
	revive_offer_countdown_label.size = Vector2(484, 32)
	revive_offer_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	revive_offer_countdown_label.add_theme_font_size_override("font_size", 19)
	revive_offer_countdown_label.modulate = UI_DANGER_ACCENT
	revive_offer_countdown_label.text = "Offer expires in 10"
	offer_card.add_child(revive_offer_countdown_label)

	revive_offer_watch_button = Button.new()
	revive_offer_watch_button.name = "WatchAd"
	revive_offer_watch_button.position = Vector2(70, 308)
	revive_offer_watch_button.size = Vector2(260, 62)
	revive_offer_watch_button.text = "WATCH AD  •  REVIVE"
	revive_offer_watch_button.focus_mode = Control.FOCUS_ALL
	_style_action_button(revive_offer_watch_button, UI_SUCCESS_ACCENT)
	revive_offer_watch_button.pressed.connect(_accept_revive_offer)
	offer_card.add_child(revive_offer_watch_button)

	revive_offer_decline_button = Button.new()
	revive_offer_decline_button.name = "Decline"
	revive_offer_decline_button.position = Vector2(354, 308)
	revive_offer_decline_button.size = Vector2(260, 62)
	revive_offer_decline_button.text = "DECLINE"
	revive_offer_decline_button.focus_mode = Control.FOCUS_ALL
	_style_action_button(revive_offer_decline_button, UI_DANGER_ACCENT)
	revive_offer_decline_button.pressed.connect(_decline_revive_offer.bind("The offer was declined."))
	offer_card.add_child(revive_offer_decline_button)

	var disclosure := Label.new()
	disclosure.position = Vector2(44, 384)
	disclosure.size = Vector2(596, 24)
	disclosure.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	disclosure.add_theme_font_size_override("font_size", 12)
	disclosure.modulate = MUTED_TEXT_COLOR
	disclosure.text = "In-game presentation • no network request • no download • no purchase"
	offer_card.add_child(disclosure)


func _refresh_hud() -> void:
	escape_confirm_panel.visible = escape_confirm_open
	if revive_offer_panel != null:
		revive_offer_panel.visible = revive_offer_visible
	if revive_offer_countdown_label != null and revive_offer_visible:
		revive_offer_countdown_label.text = "Offer expires in %02d" % int(ceili(revive_offer_countdown))
	if escape_confirm_open:
		escape_confirm_title_label.text = escape_confirm_title
		escape_confirm_body_label.text = escape_confirm_body
		escape_confirm_hint_label.text = "A confirms  •  B stays" if _using_controller_prompts() else "Enter / Y confirms  •  N / Esc stays"
	var player_hp_text: String = "%d/%d" % [player_hp, PLAYER_MAX_HP + _extra_player_max_hp()]
	title_label.text = "%s  |  DEV" % player_hp_text if dev_mode_enabled and (phase == Phase.BUILD or phase == Phase.DEFEND) else player_hp_text
	title_label.modulate = Color(1.0, 0.87, 0.36) if dev_mode_enabled and (phase == Phase.BUILD or phase == Phase.DEFEND) else TEXT_COLOR
	hud_heart_icon.texture = heart_icon_texture
	var show_inventory_audio_controls: bool = inventory_menu_open and (phase == Phase.BUILD or phase == Phase.DEFEND)
	var show_inventory_dev_controls: bool = show_inventory_audio_controls and dev_mode_enabled
	if inventory_music_volume_slider != null:
		inventory_music_volume_slider.visible = show_inventory_audio_controls
	if inventory_sfx_volume_slider != null:
		inventory_sfx_volume_slider.visible = show_inventory_audio_controls
	if inventory_dev_invincible_button != null:
		inventory_dev_invincible_button.visible = show_inventory_dev_controls
	if inventory_dev_speed_slider != null:
		inventory_dev_speed_slider.visible = show_inventory_dev_controls
	if inventory_dev_speed_value_label != null:
		inventory_dev_speed_value_label.visible = show_inventory_dev_controls
	_refresh_settings_buttons()
	match phase:
		Phase.MENU:
			var show_menu_home := not menu_credits_open and not menu_settings_open and not dev_mode_prompt_open
			menu_panel.color = Color(0.03, 0.05, 0.07, 0.70)
			menu_title_label.visible = show_menu_home
			# Player pick: the menu shows only the title and buttons, no help text.
			menu_desc_label.visible = false
			menu_start_button.visible = show_menu_home
			menu_settings_button.visible = show_menu_home
			menu_tutorial_button.visible = show_menu_home
			menu_dev_button.visible = show_menu_home and dev_tools_available
			menu_leaderboard_button.visible = show_menu_home
			menu_credits_button.visible = show_menu_home
			menu_continue_hint_label.visible = show_menu_home and dev_mode_enabled
			_layout_menu_home(150.0, dev_tools_available)
			title_label.visible = false
			hud_heart_icon.visible = false
			stats_label.visible = false
			stats_label.text = ""
			hint_label.visible = false
			menu_panel.visible = true
			menu_info_label.visible = false
			menu_state_badge_label.visible = false
			menu_title_label.text = "TAX SEASON SIEGE"
			menu_desc_label.text = "Defend Bob's house from the IRS.\nGather fast. Build smarter. Keep the suspicious air fryer."
			menu_info_label.text = "Tutorial hints appear only when useful.\nLeft stick move  •  A attack  •  Y build  •  Back inventory" if _using_controller_prompts() else "Tutorial hints appear only when useful.\nWASD move  •  Click/Space attack  •  B build  •  E inventory"
			menu_start_button.text = "" if menu_ui_texture != null else "New Game"
			menu_start_button.disabled = false
			menu_settings_button.text = "" if menu_ui_texture != null else "Settings"
			menu_tutorial_button.text = ("[x]" if tutorial_enabled else "[  ]") + "  Guided tutorial"
			menu_dev_button.text = "" if menu_ui_texture != null else ("Dev On" if dev_mode_enabled else "Dev Tools")
			menu_dev_button.self_modulate = Color(1.15, 1.05, 1.25) if dev_mode_enabled else Color.WHITE
			menu_dev_button.disabled = false
			menu_dev_panel.visible = dev_mode_prompt_open and not menu_credits_open
			menu_settings_panel.visible = menu_settings_open and not dev_mode_prompt_open and not menu_credits_open
			menu_credits_panel.visible = menu_credits_open
			menu_continue_hint_label.text = "DEV MODE ON"
			overlay_label.visible = false
		Phase.BUILD:
			menu_state_badge_label.visible = false
			title_label.visible = not inside_house and not inside_cave and not dealer_menu_open
			hud_heart_icon.visible = title_label.visible and heart_icon_texture != null
			stats_label.visible = not minimal_hud_enabled and title_label.visible
			if build_menu_open:
				stats_label.text = "Build stock  •  Wood %d  Stone %d  Iron %d  $%d  Powder %d" % [wood, stone, iron, gold, gunpowder]
			else:
				stats_label.text = "Round %d  •  Build time %02ds  •  Carry %d/%d" % [round_number, int(ceili(countdown)), _current_carried_total(), _current_carry_limit()]
			hint_label.visible = false
			menu_panel.visible = false
			menu_info_label.visible = false
			menu_dev_panel.visible = false
			menu_settings_panel.visible = false
			menu_credits_panel.visible = false
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
				hint_label.text = "%s build  |  %s dealer  |  %s cave  |  %s wave" % [_control_prompt("build_arrow_turret", "B"), _control_prompt("dealer_menu", "G"), _control_prompt("enter_cave", "F"), _control_prompt("start_wave_early", "Enter")]
			elif dealer_menu_open:
				hint_label.text = "Dealer open. Buy on one tab, sell on the other. G or Esc closes it."
			else:
				hint_label.text = "%s build  |  %s dealer  |  %s cave  |  %s wave" % [_control_prompt("build_arrow_turret", "B"), _control_prompt("dealer_menu", "G"), _control_prompt("enter_cave", "F"), _control_prompt("start_wave_early", "Enter")]
			overlay_label.visible = false
		Phase.DEFEND:
			menu_state_badge_label.visible = false
			title_label.visible = not inside_house and not inside_cave and not dealer_menu_open
			hud_heart_icon.visible = title_label.visible and heart_icon_texture != null
			stats_label.visible = not minimal_hud_enabled and title_label.visible
			stats_label.text = "Round %d  •  IRS left %d  •  House %d/%d  •  Defeated %d" % [round_number, enemies.size() + maxi(spawn_queue.size() - enemy_spawn_index, 0), _house_integrity_left(), HOUSE_MAX_DAMAGE_STAGES, run_enemies_defeated]
			hint_label.visible = false
			menu_panel.visible = false
			menu_info_label.visible = false
			menu_dev_panel.visible = false
			menu_settings_panel.visible = false
			menu_credits_panel.visible = false
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
			var show_game_over_home := not menu_credits_open and not menu_settings_open and not dev_mode_prompt_open
			menu_panel.color = Color(0, 0, 0, 0)
			# Player pick: art first, run stats on the drawn IRS receipt.
			menu_title_label.visible = false
			menu_desc_label.visible = false
			menu_start_button.visible = show_game_over_home
			menu_settings_button.visible = show_game_over_home
			menu_tutorial_button.visible = show_game_over_home
			menu_dev_button.visible = show_game_over_home and dev_tools_available
			menu_leaderboard_button.visible = show_game_over_home
			menu_credits_button.visible = show_game_over_home
			menu_continue_hint_label.visible = false
			_layout_game_over_home(dev_tools_available)
			title_label.visible = false
			hud_heart_icon.visible = false
			stats_label.visible = false
			stats_label.text = ""
			hint_label.visible = false
			menu_panel.visible = true
			menu_info_label.visible = false
			menu_state_badge_label.visible = false
			menu_state_badge_label.text = "ASSET SEIZED"
			menu_state_badge_label.add_theme_color_override("font_color", UI_DANGER_ACCENT)
			menu_title_label.text = "THE CONSOLE IS GONE"
			var run_minutes := int(floor(run_elapsed_time / 60.0))
			var run_seconds := int(floor(run_elapsed_time)) % 60
			menu_desc_label.text = "The IRS repossessed Bob's treasured air fryer.\nSURVIVED %d ROUNDS  •  DEFEATED %d AGENTS  •  BEST %d\nGathered %d  •  Built %d  •  Run %d:%02d" % [maxi(round_number - 1, 0), run_enemies_defeated, highest_round, run_resources_gathered, run_structures_built, run_minutes, run_seconds]
			menu_info_label.text = "%s\nRepairs %d  •  Cave rooms %d  •  Boss %s" % [game_over_taunt if game_over_taunt != "" else String(IRS_DEFEAT_TAUNTS[0]), run_repairs_completed, cave_seen_rooms.size(), "defeated" if cave_boss_defeated else "still collecting interest"]
			menu_start_button.text = "" if menu_ui_texture != null else "New Game"
			menu_start_button.disabled = revive_offer_pending or revive_offer_visible or ad_in_progress
			menu_settings_button.text = "" if menu_ui_texture != null else "Settings"
			menu_tutorial_button.text = ("[x]" if tutorial_enabled else "[  ]") + "  Guided tutorial"
			menu_dev_button.text = "" if menu_ui_texture != null else ("Dev On" if dev_mode_enabled else "Dev Tools")
			menu_dev_button.self_modulate = Color(1.15, 1.05, 1.25) if dev_mode_enabled else Color.WHITE
			menu_dev_button.disabled = false
			menu_dev_panel.visible = dev_mode_prompt_open and not menu_credits_open
			menu_settings_panel.visible = menu_settings_open and not dev_mode_prompt_open and not menu_credits_open
			menu_credits_panel.visible = menu_credits_open
			menu_continue_hint_label.text = "Press Esc or Back to return." if menu_credits_open else (("DEV MODE ON  |  " if dev_mode_enabled else "") + "Press Space, Enter, or click New Game.")
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
	_bind_joy_axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	_bind_joy_axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	_bind_joy_axis("move_up", JOY_AXIS_LEFT_Y, -1.0)
	_bind_joy_axis("move_down", JOY_AXIS_LEFT_Y, 1.0)
	_bind_joy_button("move_left", JOY_BUTTON_DPAD_LEFT)
	_bind_joy_button("move_right", JOY_BUTTON_DPAD_RIGHT)
	_bind_joy_button("move_up", JOY_BUTTON_DPAD_UP)
	_bind_joy_button("move_down", JOY_BUTTON_DPAD_DOWN)
	_bind_key("action", KEY_SPACE)
	_bind_mouse_button("action", MOUSE_BUTTON_LEFT)
	_bind_joy_button("action", JOY_BUTTON_A)
	_bind_joy_axis("action", JOY_AXIS_TRIGGER_RIGHT, 1.0)
	_bind_key("build_arrow_turret", KEY_B)
	_bind_joy_button("build_arrow_turret", JOY_BUTTON_Y)
	_bind_key("build_wall_light", KEY_1)
	_bind_key("build_wall_medium", KEY_2)
	_bind_key("build_wall_heavy", KEY_3)
	_bind_key("upgrade_turret", KEY_U)
	_bind_joy_button("upgrade_turret", JOY_BUTTON_RIGHT_STICK)
	_bind_key("repair_wall", KEY_H)
	_bind_mouse_button("repair_wall", MOUSE_BUTTON_RIGHT)
	_bind_joy_button("repair_wall", JOY_BUTTON_LEFT_SHOULDER)
	_bind_key("sell_structure", KEY_X)
	_bind_joy_button("sell_structure", JOY_BUTTON_LEFT_STICK)
	_bind_key("buy_sidearm", KEY_Q)
	_bind_key("dealer_menu", KEY_G)
	_bind_joy_button("dealer_menu", JOY_BUTTON_RIGHT_SHOULDER)
	_bind_key("inventory_menu", KEY_E)
	_bind_joy_button("inventory_menu", JOY_BUTTON_BACK)
	_bind_key("enter_cave", KEY_F)
	_bind_joy_button("enter_cave", JOY_BUTTON_X)
	_bind_key("start_wave_early", KEY_ENTER)
	_bind_key("start_wave_early", KEY_KP_ENTER)
	_bind_joy_button("start_wave_early", JOY_BUTTON_START)
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


func _bind_mouse_button(action: String, button_index: MouseButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for event in InputMap.action_get_events(action):
		if event is InputEventMouseButton and event.button_index == button_index:
			return
	var mouse_event := InputEventMouseButton.new()
	mouse_event.button_index = button_index
	InputMap.action_add_event(action, mouse_event)


func _bind_joy_button(action: String, button_index: JoyButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton and event.button_index == button_index:
			return
	var joy_event := InputEventJoypadButton.new()
	joy_event.button_index = button_index
	InputMap.action_add_event(action, joy_event)


func _bind_joy_axis(action: String, axis: JoyAxis, axis_value: float) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadMotion and event.axis == axis and is_equal_approx(event.axis_value, axis_value):
			return
	var joy_event := InputEventJoypadMotion.new()
	joy_event.axis = axis
	joy_event.axis_value = axis_value
	InputMap.action_add_event(action, joy_event)
