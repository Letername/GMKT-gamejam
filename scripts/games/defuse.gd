extends "res://scripts/framework/base_game.gd"

const SCREEN_SIZE := Vector2(1280, 720)
const WORLD_SIZE := Vector2(2700, 1600)
const PLAYER_SIZE := Vector2(28, 36)
const PLAYER_SPEED := 210.0
const INTERACT_RANGE := 82.0
const ATTACK_RANGE := 94.0
const ATTACK_COOLDOWN := 0.34
const ATTACK_FLASH_TIME := 0.12
const PLAYER_MAX_HP := 10
const CONTACT_DAMAGE_COOLDOWN := 0.70
const COUNTDOWN_TIME := 420.0

const BG_COLOR := Color(0.08, 0.09, 0.12)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)
const MUTED_TEXT_COLOR := Color(0.76, 0.79, 0.83)
const PLAYER_COLOR := Color(0.22, 0.82, 0.95)
const ELDER_COLOR := Color(0.94, 0.78, 0.34)
const SMITH_COLOR := Color(0.89, 0.44, 0.29)
const HUNTER_COLOR := Color(0.44, 0.90, 0.58)
const ENEMY_COLOR := Color(0.84, 0.25, 0.28)
const BOSS_COLOR := Color(0.72, 0.30, 0.91)
const SHRINE_COLOR := Color(0.68, 0.68, 0.74)
const SEAL_ON_COLOR := Color(0.45, 0.95, 0.82)
const SEAL_OFF_COLOR := Color(0.44, 0.48, 0.54)

const BG_LAYER_1 := preload("res://Art/raw/Normal BG/GandalfHardcore Background layers_layer 1.png")
const BG_LAYER_2 := preload("res://Art/raw/Normal BG/GandalfHardcore Background layers_layer 2.png")
const BG_LAYER_3 := preload("res://Art/raw/Normal BG/GandalfHardcore Background layers_layer 3.png")
const BG_LAYER_4 := preload("res://Art/raw/Normal BG/GandalfHardcore Background layers_layer 4.png")
const BG_LAYER_5 := preload("res://Art/raw/Normal BG/GandalfHardcore Background layers_layer 5.png")
const CASTLE_BG := preload("res://Art/raw/Normal BG/Background Castle .png")
const HOUSE_TEX := preload("res://Art/raw/House Tiles.png")
const TREE_TEX := preload("res://Art/raw/Pine Trees.png")
const DECOR_TEX := preload("res://Art/raw/Decor.png")
const TENT_TEX := preload("res://Art/raw/Large Tent.png")
const FURNACE_TEX := preload("res://Art/raw/Pixel Art Furnace and Sawmill.png")
const ORE_TEX := preload("res://Art/raw/Ores.png")
const SUN_TEX := preload("res://Art/raw/sun.png")
const PORTAL_TEX := preload("res://Art/raw/GandalfHardcore Portal sheet.png")

enum QuestStage {
    MEET_ELDER,
    TALK_SMITH,
    FIND_SUN_SHARD,
    FIND_MOON_ORE,
    RETURN_TO_SMITH,
    LIGHT_SEALS,
    DEFEAT_WARDEN,
    ESCAPE,
    COMPLETE
}

var player_position := Vector2.ZERO
var player_hp := PLAYER_MAX_HP
var time_left := COUNTDOWN_TIME
var attack_cooldown_left := 0.0
var attack_flash_left := 0.0
var damage_cooldown_left := 0.0
var quest_stage := QuestStage.MEET_ELDER
var camera_position := Vector2.ZERO
var dialog_text := ""

var has_sun_shard := false
var has_moon_ore := false
var has_dawn_blade := false
var has_hunter_map := false
var seals_lit: Array[bool] = [false, false, false]

var elder_rect := Rect2(Vector2(250, 360), Vector2(34, 48))
var smith_rect := Rect2(Vector2(510, 455), Vector2(34, 48))
var hunter_rect := Rect2(Vector2(660, 300), Vector2(34, 48))
var sun_shard_rect := Rect2(Vector2(1420, 250), Vector2(28, 28))
var moon_ore_rect := Rect2(Vector2(1495, 1160), Vector2(32, 32))
var gate_rect := Rect2(Vector2(1760, 280), Vector2(30, 260))
var shrine_rect := Rect2(Vector2(1940, 240), Vector2(560, 440))
var seal_rects: Array[Rect2] = []
var portal_rect := Rect2(Vector2(2430, 420), Vector2(64, 110))

var boss_rect := Rect2(Vector2(2200, 420), Vector2(58, 72))
var boss_hp := 0
var boss_active := false

var blockers: Array[Rect2] = []
var props: Array[Dictionary] = []
var enemies: Array[Dictionary] = []

var title_label: Label
var objective_label: Label
var hint_label: Label
var dialog_label: Label


func _ready() -> void:
    game_title = "Kingdom Under Zero"


func start() -> void:
    ensure_common_input_actions()
    game_title = "Kingdom Under Zero"
    player_position = Vector2(230, 470)
    player_hp = PLAYER_MAX_HP
    time_left = COUNTDOWN_TIME
    attack_cooldown_left = 0.0
    attack_flash_left = 0.0
    damage_cooldown_left = 0.0
    quest_stage = QuestStage.MEET_ELDER
    camera_position = Vector2.ZERO
    has_sun_shard = false
    has_moon_ore = false
    has_dawn_blade = false
    has_hunter_map = false
    seals_lit = [false, false, false]
    boss_active = false
    boss_hp = 0
    boss_rect.position = Vector2(2200, 420)

    _build_world()
    _build_scene()
    _set_dialog("The eclipse clock has started. Find the elder in Ember Vale.")
    _refresh_labels()
    if countdown_display != null:
        countdown_display.set_seconds(time_left)


func update(delta: float) -> void:
    if Input.is_action_just_pressed("menu_back"):
        exit_to_menu()
        return

    time_left = max(time_left - delta, 0.0)
    attack_cooldown_left = max(attack_cooldown_left - delta, 0.0)
    attack_flash_left = max(attack_flash_left - delta, 0.0)
    damage_cooldown_left = max(damage_cooldown_left - delta, 0.0)

    if countdown_display != null:
        countdown_display.set_seconds(time_left)

    _move_player(delta)
    _update_enemies(delta)
    _update_boss(delta)
    _handle_interactions()

    camera_position = player_position + PLAYER_SIZE * 0.5 - SCREEN_SIZE * 0.5
    camera_position.x = clamp(camera_position.x, 0.0, WORLD_SIZE.x - SCREEN_SIZE.x)
    camera_position.y = clamp(camera_position.y, 0.0, WORLD_SIZE.y - SCREEN_SIZE.y)

    if player_hp <= 0:
        end_with_loss("Your journey ended before the eclipse was broken.")
        return

    if time_left <= 0.0:
        end_with_loss("The eclipse completed before you could finish the quest.")
        return

    if quest_stage == QuestStage.ESCAPE and Rect2(player_position, PLAYER_SIZE).intersects(portal_rect):
        quest_stage = QuestStage.COMPLETE
        end_with_win("You crossed the dawn gate with the kingdom saved behind you.")
        return

    _refresh_labels()
    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), BG_COLOR, true)
    _draw_parallax_background()
    _draw_ground_zones()
    _draw_props()
    _draw_world_entities()


func _build_world() -> void:
    blockers = [
        Rect2(Vector2(160, 180), Vector2(280, 220)),
        Rect2(Vector2(450, 380), Vector2(220, 220)),
        Rect2(Vector2(1740, 260), Vector2(60, 300)),
        Rect2(Vector2(1980, 250), Vector2(60, 360)),
        Rect2(Vector2(2360, 250), Vector2(60, 360)),
        Rect2(Vector2(1980, 250), Vector2(420, 40)),
        Rect2(Vector2(1980, 570), Vector2(420, 40)),
        Rect2(Vector2(960, 1010), Vector2(420, 210)),
        Rect2(Vector2(1290, 1100), Vector2(170, 170))
    ]

    seal_rects = [
        Rect2(Vector2(2050, 330), Vector2(36, 36)),
        Rect2(Vector2(2180, 500), Vector2(36, 36)),
        Rect2(Vector2(2320, 330), Vector2(36, 36))
    ]

    props = [
        {"texture": HOUSE_TEX, "position": Vector2(140, 160), "size": Vector2(320, 240), "source": Rect2(0, 0, HOUSE_TEX.get_width() / 2, HOUSE_TEX.get_height())},
        {"texture": HOUSE_TEX, "position": Vector2(410, 320), "size": Vector2(320, 240), "source": Rect2(HOUSE_TEX.get_width() / 2, 0, HOUSE_TEX.get_width() / 2, HOUSE_TEX.get_height())},
        {"texture": TENT_TEX, "position": Vector2(630, 240), "size": Vector2(180, 120), "source": Rect2()},
        {"texture": FURNACE_TEX, "position": Vector2(520, 520), "size": Vector2(120, 120), "source": Rect2(0, 0, FURNACE_TEX.get_width() / 6, FURNACE_TEX.get_height())},
        {"texture": TREE_TEX, "position": Vector2(880, 180), "size": Vector2(120, 200), "source": Rect2(0, 0, 96, TREE_TEX.get_height())},
        {"texture": TREE_TEX, "position": Vector2(1130, 130), "size": Vector2(120, 220), "source": Rect2(96, 0, 96, TREE_TEX.get_height())},
        {"texture": TREE_TEX, "position": Vector2(1260, 370), "size": Vector2(120, 220), "source": Rect2(192, 0, 96, TREE_TEX.get_height())},
        {"texture": TREE_TEX, "position": Vector2(1510, 230), "size": Vector2(120, 220), "source": Rect2(288, 0, 96, TREE_TEX.get_height())},
        {"texture": TREE_TEX, "position": Vector2(1100, 920), "size": Vector2(120, 220), "source": Rect2(384, 0, 96, TREE_TEX.get_height())},
        {"texture": TREE_TEX, "position": Vector2(1420, 980), "size": Vector2(120, 220), "source": Rect2(480, 0, 96, TREE_TEX.get_height())},
        {"texture": CASTLE_BG, "position": Vector2(2240, 30), "size": Vector2(240, 200), "source": Rect2()},
        {"texture": DECOR_TEX, "position": Vector2(2040, 560), "size": Vector2(120, 120), "source": Rect2(0, 64, 96, 96)},
        {"texture": DECOR_TEX, "position": Vector2(2280, 560), "size": Vector2(120, 120), "source": Rect2(96, 64, 96, 96)}
    ]

    enemies = [
        {"position": Vector2(1170, 500), "size": Vector2(28, 28), "hp": 3, "speed": 95.0, "damage": 1, "cooldown": 0.0},
        {"position": Vector2(1470, 420), "size": Vector2(28, 28), "hp": 3, "speed": 105.0, "damage": 1, "cooldown": 0.0},
        {"position": Vector2(1230, 1080), "size": Vector2(32, 32), "hp": 4, "speed": 90.0, "damage": 1, "cooldown": 0.0},
        {"position": Vector2(1550, 930), "size": Vector2(32, 32), "hp": 4, "speed": 100.0, "damage": 1, "cooldown": 0.0},
        {"position": Vector2(2080, 420), "size": Vector2(34, 34), "hp": 5, "speed": 108.0, "damage": 1, "cooldown": 0.0}
    ]


func _build_scene() -> void:
    for child in get_children():
        child.queue_free()

    title_label = Label.new()
    title_label.position = Vector2(70, 22)
    title_label.size = Vector2(1140, 32)
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 30)
    title_label.modulate = TEXT_COLOR
    add_child(title_label)

    objective_label = Label.new()
    objective_label.position = Vector2(70, 54)
    objective_label.size = Vector2(1140, 28)
    objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    objective_label.add_theme_font_size_override("font_size", 18)
    objective_label.modulate = MUTED_TEXT_COLOR
    add_child(objective_label)

    hint_label = Label.new()
    hint_label.position = Vector2(70, 86)
    hint_label.size = Vector2(1140, 24)
    hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint_label.add_theme_font_size_override("font_size", 16)
    hint_label.modulate = MUTED_TEXT_COLOR
    hint_label.text = "Explore, talk, gather, fight, and reach the portal before the eclipse clock hits zero."
    add_child(hint_label)

    dialog_label = Label.new()
    dialog_label.position = Vector2(120, 620)
    dialog_label.size = Vector2(1040, 68)
    dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    dialog_label.add_theme_font_size_override("font_size", 21)
    dialog_label.modulate = TEXT_COLOR
    add_child(dialog_label)


func _move_player(delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    _move_player_axis(Vector2(input_vector.x * PLAYER_SPEED * delta, 0.0))
    _move_player_axis(Vector2(0.0, input_vector.y * PLAYER_SPEED * delta))


func _move_player_axis(amount: Vector2) -> void:
    var target_rect: Rect2 = Rect2(player_position + amount, PLAYER_SIZE)
    if not has_sun_shard and target_rect.intersects(gate_rect):
        return

    for blocker in blockers:
        if target_rect.intersects(blocker):
            return

    player_position += amount
    player_position.x = clamp(player_position.x, 0.0, WORLD_SIZE.x - PLAYER_SIZE.x)
    player_position.y = clamp(player_position.y, 0.0, WORLD_SIZE.y - PLAYER_SIZE.y)


func _handle_interactions() -> void:
    if not Input.is_action_just_pressed("action"):
        return

    if has_dawn_blade and boss_active and _distance_to_rect(boss_rect) <= ATTACK_RANGE:
        _attack_boss()
        return

    for enemy in enemies:
        if has_dawn_blade and _distance_to_rect(Rect2(enemy["position"], enemy["size"])) <= ATTACK_RANGE:
            _attack_enemy()
            return

    if quest_stage == QuestStage.MEET_ELDER and _distance_to_rect(elder_rect) <= INTERACT_RANGE:
        _meet_elder()
        return

    if quest_stage == QuestStage.TALK_SMITH and _distance_to_rect(smith_rect) <= INTERACT_RANGE:
        _first_smith_talk()
        return

    if quest_stage == QuestStage.FIND_SUN_SHARD and not has_sun_shard and _distance_to_rect(sun_shard_rect) <= INTERACT_RANGE:
        _collect_sun_shard()
        return

    if quest_stage == QuestStage.FIND_MOON_ORE and not has_moon_ore and _distance_to_rect(moon_ore_rect) <= INTERACT_RANGE:
        _collect_moon_ore()
        return

    if quest_stage == QuestStage.RETURN_TO_SMITH and _distance_to_rect(smith_rect) <= INTERACT_RANGE:
        _forge_dawn_blade()
        return

    if quest_stage == QuestStage.LIGHT_SEALS:
        for i in range(seal_rects.size()):
            if not seals_lit[i] and _distance_to_rect(seal_rects[i]) <= INTERACT_RANGE:
                _light_seal(i)
                return

    if quest_stage == QuestStage.DEFEAT_WARDEN and not boss_active and Rect2(player_position, PLAYER_SIZE).intersects(shrine_rect):
        _awaken_warden()
        return

    if quest_stage == QuestStage.FIND_MOON_ORE and _distance_to_rect(hunter_rect) <= INTERACT_RANGE and not has_hunter_map:
        has_hunter_map = true
        _set_dialog("Hunter: The cave entrance lies south of the pines. Look for the pale stones.")
        return

    _show_context_line()


func _meet_elder() -> void:
    quest_stage = QuestStage.TALK_SMITH
    _set_dialog("Elder: The shrine locks at zero. Find the smith and arm yourself for the road.")


func _first_smith_talk() -> void:
    quest_stage = QuestStage.FIND_SUN_SHARD
    _set_dialog("Smith: Bring me the Sun Shard from the Whispering Grove. Then I will ask one more thing.")


func _collect_sun_shard() -> void:
    has_sun_shard = true
    quest_stage = QuestStage.FIND_MOON_ORE
    _set_dialog("You recovered the Sun Shard. The smith also needs Moon Ore from the southern cave.")


func _collect_moon_ore() -> void:
    has_moon_ore = true
    quest_stage = QuestStage.RETURN_TO_SMITH
    _set_dialog("Moon Ore secured. Return to the smith and forge the Dawn Blade.")


func _forge_dawn_blade() -> void:
    has_dawn_blade = true
    quest_stage = QuestStage.LIGHT_SEALS
    _set_dialog("Smith: The gate will yield to the shard. Light the three shrine seals, then face the warden.")


func _light_seal(index: int) -> void:
    seals_lit[index] = true
    if _all_seals_lit():
        quest_stage = QuestStage.DEFEAT_WARDEN
        _set_dialog("All three seals blaze. Enter the inner shrine to awaken the warden.")
    else:
        _set_dialog("Seal %d lit. Two more braziers answer the shard." % (index + 1))


func _awaken_warden() -> void:
    boss_active = true
    boss_hp = 18
    _set_dialog("The Eclipse Warden rises from the shrine floor.")


func _attack_enemy() -> void:
    if attack_cooldown_left > 0.0:
        return

    attack_cooldown_left = ATTACK_COOLDOWN
    attack_flash_left = ATTACK_FLASH_TIME
    var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5

    for index in range(enemies.size() - 1, -1, -1):
        var enemy_rect: Rect2 = Rect2(enemies[index]["position"], enemies[index]["size"])
        var enemy_center: Vector2 = enemy_rect.position + enemy_rect.size * 0.5
        if enemy_center.distance_to(player_center) <= ATTACK_RANGE:
            enemies[index]["hp"] = int(enemies[index]["hp"]) - 2
            if int(enemies[index]["hp"]) <= 0:
                enemies.remove_at(index)


func _attack_boss() -> void:
    if attack_cooldown_left > 0.0:
        return

    attack_cooldown_left = ATTACK_COOLDOWN
    attack_flash_left = ATTACK_FLASH_TIME
    boss_hp -= 1
    if boss_hp <= 0:
        boss_active = false
        quest_stage = QuestStage.ESCAPE
        _set_dialog("The warden falls. The dawn portal is open.")
    else:
        _set_dialog("The Dawn Blade bites. Warden HP: %d" % boss_hp)


func _update_enemies(delta: float) -> void:
    var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5
    var player_rect: Rect2 = Rect2(player_position, PLAYER_SIZE)

    for enemy in enemies:
        enemy["cooldown"] = max(float(enemy["cooldown"]) - delta, 0.0)
        var enemy_position: Vector2 = enemy["position"]
        var enemy_size: Vector2 = enemy["size"]
        var enemy_center: Vector2 = enemy_position + enemy_size * 0.5
        var direction: Vector2 = player_center - enemy_center
        var distance: float = direction.length()
        if distance < 260.0 and distance > 0.0:
            var next_position: Vector2 = enemy_position + direction.normalized() * float(enemy["speed"]) * delta
            var next_rect: Rect2 = Rect2(next_position, enemy_size)
            var blocked: bool = false
            for blocker in blockers:
                if next_rect.intersects(blocker):
                    blocked = true
                    break
            if not blocked:
                enemy["position"] = next_position

        if Rect2(enemy["position"], enemy_size).intersects(player_rect) and float(enemy["cooldown"]) <= 0.0 and damage_cooldown_left <= 0.0:
            enemy["cooldown"] = CONTACT_DAMAGE_COOLDOWN
            damage_cooldown_left = CONTACT_DAMAGE_COOLDOWN
            player_hp -= int(enemy["damage"])
            _set_dialog("A shadow creature wounds you. HP left: %d" % player_hp)


func _update_boss(delta: float) -> void:
    if not boss_active:
        return

    var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5
    var boss_center: Vector2 = boss_rect.position + boss_rect.size * 0.5
    var direction: Vector2 = player_center - boss_center
    if direction.length() > 0.0:
        boss_rect.position += direction.normalized() * 125.0 * delta

    if boss_rect.position.x < shrine_rect.position.x:
        boss_rect.position.x = shrine_rect.position.x
    if boss_rect.position.y < shrine_rect.position.y:
        boss_rect.position.y = shrine_rect.position.y
    if boss_rect.end.x > shrine_rect.end.x:
        boss_rect.position.x = shrine_rect.end.x - boss_rect.size.x
    if boss_rect.end.y > shrine_rect.end.y:
        boss_rect.position.y = shrine_rect.end.y - boss_rect.size.y

    if Rect2(player_position, PLAYER_SIZE).intersects(boss_rect) and damage_cooldown_left <= 0.0:
        damage_cooldown_left = CONTACT_DAMAGE_COOLDOWN
        player_hp -= 2
        _set_dialog("The warden crashes into you. HP left: %d" % player_hp)


func _draw_parallax_background() -> void:
    _draw_layer(BG_LAYER_1, 0.12, Vector2(-40, -30), Vector2(920, 360))
    _draw_layer(BG_LAYER_2, 0.18, Vector2(110, -10), Vector2(980, 380))
    _draw_layer(BG_LAYER_3, 0.24, Vector2(160, 40), Vector2(940, 360))
    _draw_layer(BG_LAYER_4, 0.32, Vector2(260, 90), Vector2(920, 340))
    _draw_layer(BG_LAYER_5, 0.42, Vector2(360, 120), Vector2(920, 320))
    _draw_texture_world(CASTLE_BG, Vector2(2140, 70), Vector2(260, 220), Rect2())


func _draw_ground_zones() -> void:
    _draw_world_rect(Rect2(Vector2(100, 130), Vector2(720, 520)), Color(0.27, 0.33, 0.24))
    _draw_world_rect(Rect2(Vector2(820, 120), Vector2(840, 620)), Color(0.18, 0.27, 0.18))
    _draw_world_rect(Rect2(Vector2(920, 880), Vector2(760, 420)), Color(0.23, 0.21, 0.24))
    _draw_world_rect(Rect2(Vector2(1820, 140), Vector2(770, 620)), Color(0.27, 0.25, 0.31))


func _draw_props() -> void:
    for prop in props:
        _draw_texture_world(prop["texture"], prop["position"], prop["size"], prop["source"])

    if not has_sun_shard:
        _draw_texture_world(SUN_TEX, sun_shard_rect.position - Vector2(14, 14), Vector2(56, 56), Rect2())

    if not has_moon_ore:
        _draw_texture_world(ORE_TEX, moon_ore_rect.position - Vector2(6, 16), Vector2(72, 56), Rect2(0, 0, ORE_TEX.get_width(), ORE_TEX.get_height()))

    _draw_world_rect(gate_rect, Color(0.72, 0.72, 0.78) if has_sun_shard else Color(0.44, 0.47, 0.52))
    _draw_world_rect(shrine_rect, Color(0.15, 0.15, 0.19), false)

    for i in range(seal_rects.size()):
        _draw_world_rect(seal_rects[i], SEAL_ON_COLOR if seals_lit[i] else SEAL_OFF_COLOR)

    if quest_stage == QuestStage.ESCAPE:
        var frame_width: float = PORTAL_TEX.get_width() / 10.0
        _draw_texture_world(PORTAL_TEX, portal_rect.position - Vector2(6, 18), Vector2(76, 128), Rect2(0, 0, frame_width, PORTAL_TEX.get_height()))
    else:
        _draw_world_rect(portal_rect, Color(0.44, 0.45, 0.50))


func _draw_world_entities() -> void:
    _draw_world_rect(elder_rect, ELDER_COLOR)
    _draw_world_rect(smith_rect, SMITH_COLOR)
    _draw_world_rect(hunter_rect, HUNTER_COLOR)

    for enemy in enemies:
        _draw_world_rect(Rect2(enemy["position"], enemy["size"]), ENEMY_COLOR)

    if boss_active:
        _draw_world_rect(boss_rect, BOSS_COLOR)

    _draw_world_rect(Rect2(player_position, PLAYER_SIZE), PLAYER_COLOR)

    if attack_flash_left > 0.0:
        draw_circle(player_position + PLAYER_SIZE * 0.5 - camera_position, ATTACK_RANGE, Color(0.34, 0.92, 0.96, 0.18))


func _draw_layer(texture: Texture2D, parallax: float, screen_offset: Vector2, size: Vector2) -> void:
    var position: Vector2 = screen_offset - camera_position * parallax
    draw_texture_rect(texture, Rect2(position, size), false)


func _draw_texture_world(texture: Texture2D, world_position: Vector2, size: Vector2, source_rect: Rect2) -> void:
    var screen_rect: Rect2 = Rect2(world_position - camera_position, size)
    if source_rect.size == Vector2.ZERO:
        draw_texture_rect(texture, screen_rect, false)
    else:
        draw_texture_rect_region(texture, screen_rect, source_rect)


func _draw_world_rect(world_rect: Rect2, color: Color, filled: bool = true) -> void:
    draw_rect(Rect2(world_rect.position - camera_position, world_rect.size), color, filled)


func _distance_to_rect(target: Rect2) -> float:
    var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5
    var target_center: Vector2 = target.position + target.size * 0.5
    return player_center.distance_to(target_center)


func _all_seals_lit() -> bool:
    for lit in seals_lit:
        if not lit:
            return false
    return true


func _show_context_line() -> void:
    if _distance_to_rect(elder_rect) <= INTERACT_RANGE:
        _set_dialog("Elder: The path starts with listening.")
    elif _distance_to_rect(smith_rect) <= INTERACT_RANGE:
        _set_dialog("Smith: Bring me what the world still remembers of the sun and moon.")
    elif _distance_to_rect(hunter_rect) <= INTERACT_RANGE:
        _set_dialog("Hunter: The south road drops into the pale-stone cave.")


func _current_objective() -> String:
    match quest_stage:
        QuestStage.MEET_ELDER:
            return "Speak to the elder"
        QuestStage.TALK_SMITH:
            return "Find the smith in the village"
        QuestStage.FIND_SUN_SHARD:
            return "Recover the Sun Shard in the forest"
        QuestStage.FIND_MOON_ORE:
            return "Bring Moon Ore from the southern cave"
        QuestStage.RETURN_TO_SMITH:
            return "Return to the smith and forge the Dawn Blade"
        QuestStage.LIGHT_SEALS:
            return "Light the three shrine seals"
        QuestStage.DEFEAT_WARDEN:
            return "Enter the shrine and defeat the Eclipse Warden"
        QuestStage.ESCAPE:
            return "Reach the dawn portal"
        _:
            return "Quest complete"


func _set_dialog(text: String) -> void:
    dialog_text = text
    if dialog_label != null:
        dialog_label.text = dialog_text


func _refresh_labels() -> void:
    if title_label == null:
        return
    title_label.text = "KINGDOM UNDER ZERO  |  HP %d/%d" % [player_hp, PLAYER_MAX_HP]
    objective_label.text = "Objective: %s" % _current_objective()
    if dialog_label != null:
        dialog_label.text = dialog_text
