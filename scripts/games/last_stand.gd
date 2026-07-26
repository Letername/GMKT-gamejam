extends "res://scripts/framework/base_game.gd"

const ARENA := Rect2(Vector2(180, 120), Vector2(920, 520))
const PLAYER_SIZE := Vector2(28, 28)
const PLAYER_SPEED := 270.0
const PLAYER_MAX_HP := 6
const ATTACK_RADIUS := 90.0
const ATTACK_COOLDOWN := 0.40
const ATTACK_FLASH_TIME := 0.14
const SURVIVE_TIME := 10.0
const CONTACT_COOLDOWN := 0.75

const BACKGROUND_COLOR := Color(0.10, 0.11, 0.14)
const ARENA_COLOR := Color(0.16, 0.18, 0.22)
const GRID_COLOR := Color(0.22, 0.24, 0.29)
const PLAYER_COLOR := Color(0.22, 0.82, 0.94)
const BRUTE_COLOR := Color(0.92, 0.38, 0.28)
const SWARMER_COLOR := Color(0.96, 0.76, 0.18)
const TANK_COLOR := Color(0.72, 0.31, 0.91)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)
const MUTED_TEXT_COLOR := Color(0.78, 0.80, 0.84)

const SPAWN_SCRIPT := [
    {"time": 0.6, "type": "brute", "side": "left", "lane": "mid"},
    {"time": 1.1, "type": "brute", "side": "right", "lane": "mid"},
    {"time": 1.8, "type": "swarmer", "side": "top", "lane": "left"},
    {"time": 2.2, "type": "swarmer", "side": "top", "lane": "right"},
    {"time": 2.8, "type": "brute", "side": "bottom", "lane": "left"},
    {"time": 3.4, "type": "tank", "side": "right", "lane": "mid"},
    {"time": 4.0, "type": "swarmer", "side": "left", "lane": "top"},
    {"time": 4.2, "type": "swarmer", "side": "left", "lane": "bottom"},
    {"time": 4.8, "type": "brute", "side": "top", "lane": "mid"},
    {"time": 5.3, "type": "brute", "side": "bottom", "lane": "mid"},
    {"time": 5.8, "type": "swarmer", "side": "right", "lane": "top"},
    {"time": 6.0, "type": "swarmer", "side": "right", "lane": "bottom"},
    {"time": 6.7, "type": "tank", "side": "left", "lane": "mid"},
    {"time": 7.4, "type": "brute", "side": "top", "lane": "left"},
    {"time": 7.4, "type": "brute", "side": "top", "lane": "right"},
    {"time": 8.0, "type": "swarmer", "side": "bottom", "lane": "left"},
    {"time": 8.2, "type": "swarmer", "side": "bottom", "lane": "right"},
    {"time": 8.8, "type": "tank", "side": "top", "lane": "mid"},
    {"time": 9.2, "type": "brute", "side": "left", "lane": "top"},
    {"time": 9.2, "type": "brute", "side": "right", "lane": "bottom"}
]

var player_position := Vector2.ZERO
var player_hp := PLAYER_MAX_HP
var time_left := SURVIVE_TIME
var elapsed_time := 0.0
var attack_cooldown_left := 0.0
var attack_flash_left := 0.0
var spawned_event_index := 0
var enemies: Array[Dictionary] = []
var info_label: Label
var tip_label: Label
var phase_label: Label


func _ready() -> void:
    game_title = "Last Stand"


func start() -> void:
    ensure_common_input_actions()
    game_title = "Last Stand"
    player_position = ARENA.get_center() - PLAYER_SIZE * 0.5
    player_hp = PLAYER_MAX_HP
    time_left = SURVIVE_TIME
    elapsed_time = 0.0
    attack_cooldown_left = 0.0
    attack_flash_left = 0.0
    spawned_event_index = 0
    enemies.clear()
    _build_scene()
    _refresh_labels()
    if countdown_display != null:
        countdown_display.set_seconds(time_left)


func update(delta: float) -> void:
    if Input.is_action_just_pressed("menu_back"):
        exit_to_menu()
        return

    time_left = max(time_left - delta, 0.0)
    elapsed_time = SURVIVE_TIME - time_left
    attack_cooldown_left = max(attack_cooldown_left - delta, 0.0)
    attack_flash_left = max(attack_flash_left - delta, 0.0)

    if countdown_display != null:
        countdown_display.set_seconds(time_left)

    _spawn_scripted_enemies()
    _move_player(delta)
    _update_enemies(delta)

    if Input.is_action_just_pressed("action") and attack_cooldown_left <= 0.0:
        _perform_attack()

    if player_hp <= 0:
        end_with_loss("The final wave broke through before the ten-second stand was over.")
        return

    if time_left <= 0.0:
        end_with_win("You survived the full ten-second attack pattern.")
        return

    _refresh_labels()
    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), BACKGROUND_COLOR, true)
    draw_rect(ARENA, ARENA_COLOR, true)

    for x in range(1, 5):
        var line_x := ARENA.position.x + x * ARENA.size.x / 5.0
        draw_rect(Rect2(Vector2(line_x, ARENA.position.y), Vector2(2, ARENA.size.y)), GRID_COLOR, true)
    for y in range(1, 4):
        var line_y := ARENA.position.y + y * ARENA.size.y / 4.0
        draw_rect(Rect2(Vector2(ARENA.position.x, line_y), Vector2(ARENA.size.x, 2)), GRID_COLOR, true)

    draw_rect(Rect2(ARENA.position, Vector2(ARENA.size.x, 4)), Color.WHITE, true)
    draw_rect(Rect2(ARENA.position + Vector2(0, ARENA.size.y - 4), Vector2(ARENA.size.x, 4)), Color.WHITE, true)
    draw_rect(Rect2(ARENA.position, Vector2(4, ARENA.size.y)), Color.WHITE, true)
    draw_rect(Rect2(ARENA.position + Vector2(ARENA.size.x - 4, 0), Vector2(4, ARENA.size.y)), Color.WHITE, true)

    for enemy in enemies:
        draw_rect(Rect2(enemy["position"], enemy["size"]), enemy["color"], true)

    draw_rect(Rect2(player_position, PLAYER_SIZE), PLAYER_COLOR, true)

    if attack_flash_left > 0.0:
        draw_circle(player_position + PLAYER_SIZE * 0.5, ATTACK_RADIUS, Color(0.34, 0.92, 0.96, 0.18))


func _build_scene() -> void:
    for child in get_children():
        child.queue_free()

    info_label = Label.new()
    info_label.position = Vector2(160, 32)
    info_label.size = Vector2(960, 34)
    info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    info_label.add_theme_font_size_override("font_size", 28)
    info_label.modulate = TEXT_COLOR
    add_child(info_label)

    phase_label = Label.new()
    phase_label.position = Vector2(160, 66)
    phase_label.size = Vector2(960, 28)
    phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    phase_label.add_theme_font_size_override("font_size", 20)
    phase_label.modulate = MUTED_TEXT_COLOR
    add_child(phase_label)

    tip_label = Label.new()
    tip_label.position = Vector2(160, 690)
    tip_label.size = Vector2(960, 24)
    tip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    tip_label.add_theme_font_size_override("font_size", 18)
    tip_label.modulate = MUTED_TEXT_COLOR
    tip_label.text = "Move with WASD or arrows. Tap Space for a short-range blast."
    add_child(tip_label)


func _move_player(delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    player_position += input_vector * PLAYER_SPEED * delta
    player_position.x = clamp(player_position.x, ARENA.position.x, ARENA.end.x - PLAYER_SIZE.x)
    player_position.y = clamp(player_position.y, ARENA.position.y, ARENA.end.y - PLAYER_SIZE.y)


func _spawn_scripted_enemies() -> void:
    while spawned_event_index < SPAWN_SCRIPT.size() and float(SPAWN_SCRIPT[spawned_event_index]["time"]) <= elapsed_time:
        var event_data: Dictionary = SPAWN_SCRIPT[spawned_event_index]
        _spawn_enemy(String(event_data["type"]), String(event_data["side"]), String(event_data["lane"]))
        spawned_event_index += 1


func _spawn_enemy(enemy_type: String, side: String, lane: String) -> void:
    var spawn_position: Vector2 = _lane_spawn(side, lane)
    if enemy_type == "brute":
        enemies.append({
            "type": enemy_type,
            "position": spawn_position,
            "size": Vector2(30, 30),
            "speed": 118.0,
            "damage": 1,
            "damage_cooldown": 0.0,
            "color": BRUTE_COLOR
        })
    elif enemy_type == "swarmer":
        enemies.append({
            "type": enemy_type,
            "position": spawn_position,
            "size": Vector2(18, 18),
            "speed": 190.0,
            "damage": 1,
            "damage_cooldown": 0.0,
            "color": SWARMER_COLOR
        })
    else:
        enemies.append({
            "type": enemy_type,
            "position": spawn_position,
            "size": Vector2(40, 40),
            "speed": 82.0,
            "damage": 2,
            "damage_cooldown": 0.0,
            "color": TANK_COLOR
        })


func _lane_spawn(side: String, lane: String) -> Vector2:
    var lane_x := {
        "left": ARENA.position.x + 80.0,
        "mid": ARENA.position.x + ARENA.size.x * 0.5,
        "right": ARENA.end.x - 110.0
    }
    var lane_y := {
        "top": ARENA.position.y + 80.0,
        "mid": ARENA.position.y + ARENA.size.y * 0.5,
        "bottom": ARENA.end.y - 110.0
    }

    if side == "left":
        return Vector2(ARENA.position.x + 8.0, float(lane_y.get(lane, lane_y["mid"])))
    if side == "right":
        return Vector2(ARENA.end.x - 48.0, float(lane_y.get(lane, lane_y["mid"])))
    if side == "top":
        return Vector2(float(lane_x.get(lane, lane_x["mid"])), ARENA.position.y + 8.0)
    return Vector2(float(lane_x.get(lane, lane_x["mid"])), ARENA.end.y - 48.0)


func _update_enemies(delta: float) -> void:
    var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5
    var player_rect := Rect2(player_position, PLAYER_SIZE)

    for enemy in enemies:
        enemy["damage_cooldown"] = max(float(enemy["damage_cooldown"]) - delta, 0.0)
        var enemy_position: Vector2 = enemy["position"]
        var enemy_size: Vector2 = enemy["size"]
        var enemy_center: Vector2 = enemy_position + enemy_size * 0.5
        var direction: Vector2 = (player_center - enemy_center).normalized()
        enemy["position"] = enemy_position + direction * float(enemy["speed"]) * delta

        if Rect2(enemy["position"], enemy_size).intersects(player_rect) and float(enemy["damage_cooldown"]) <= 0.0:
            enemy["damage_cooldown"] = CONTACT_COOLDOWN
            player_hp -= int(enemy["damage"])


func _perform_attack() -> void:
    attack_cooldown_left = ATTACK_COOLDOWN
    attack_flash_left = ATTACK_FLASH_TIME
    var player_center: Vector2 = player_position + PLAYER_SIZE * 0.5

    for index in range(enemies.size() - 1, -1, -1):
        var enemy_position: Vector2 = enemies[index]["position"]
        var enemy_size: Vector2 = enemies[index]["size"]
        var enemy_center: Vector2 = enemy_position + enemy_size * 0.5
        if enemy_center.distance_to(player_center) <= ATTACK_RADIUS:
            enemies.remove_at(index)


func _current_phase_text() -> String:
    if time_left > 7.0:
        return "Opening wave: learn the lanes"
    if time_left > 4.0:
        return "Pressure phase: mixed entry points"
    if time_left > 1.5:
        return "Final crush: tanks and crossfire"
    return "Hold the center. Almost there."


func _refresh_labels() -> void:
    if info_label == null:
        return
    info_label.text = "LAST STAND  |  HP %d/%d  |  Enemies %d" % [player_hp, PLAYER_MAX_HP, enemies.size()]
    phase_label.text = _current_phase_text()
