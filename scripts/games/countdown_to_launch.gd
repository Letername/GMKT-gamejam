extends "res://scripts/framework/base_game.gd"

const ROOM := Rect2(Vector2(160, 120), Vector2(960, 520))
const PLAYER_SIZE := Vector2(28, 28)
const PLAYER_SPEED := 240.0
const TASK_FILL_RATE := 0.60
const TIME_LIMIT := 28.0

const BACKGROUND_COLOR := Color(0.07, 0.09, 0.12)
const ROOM_COLOR := Color(0.14, 0.16, 0.20)
const PLAYER_COLOR := Color(0.24, 0.84, 0.95)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)
const MUTED_TEXT := Color(0.75, 0.78, 0.82)

var player_position := Vector2.ZERO
var time_left := TIME_LIMIT
var stations: Array[Dictionary] = []
var info_label: Label
var help_label: Label


func _ready() -> void:
    game_title = "Countdown to Launch"


func start() -> void:
    ensure_common_input_actions()
    game_title = "Countdown to Launch"
    player_position = ROOM.position + Vector2(460, 250)
    time_left = TIME_LIMIT
    _build_stations()
    _build_scene()
    _refresh_labels()
    if countdown_display != null:
        countdown_display.set_seconds(time_left)


func update(delta: float) -> void:
    if Input.is_action_just_pressed("menu_back"):
        exit_to_menu()
        return

    time_left = max(time_left - delta, 0.0)
    if countdown_display != null:
        countdown_display.set_seconds(time_left)

    _move_player(delta)
    _update_station_work(delta)

    if _all_tasks_complete():
        end_with_win("The rocket launched with every prep task completed in time.")
        return

    if time_left <= 0.0:
        end_with_loss("Launch hit zero while the ship was still not ready.")
        return

    _refresh_labels()
    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), BACKGROUND_COLOR, true)
    draw_rect(ROOM, ROOM_COLOR, true)

    for station in stations:
        var station_rect: Rect2 = station["rect"]
        var station_color: Color = station["color"]
        draw_rect(station_rect, station_color, true)

        var progress: float = station["progress"]
        draw_rect(Rect2(station_rect.position + Vector2(0, station_rect.size.y + 8), Vector2(station_rect.size.x * progress, 10)), Color.WHITE, true)

    draw_rect(Rect2(player_position, PLAYER_SIZE), PLAYER_COLOR, true)


func _build_stations() -> void:
    stations = [
        {"name": "Fuel", "rect": Rect2(ROOM.position + Vector2(90, 120), Vector2(140, 90)), "progress": 0.0, "color": Color(0.95, 0.72, 0.18)},
        {"name": "Repair", "rect": Rect2(ROOM.position + Vector2(390, 80), Vector2(160, 90)), "progress": 0.0, "color": Color(0.42, 0.86, 0.46)},
        {"name": "Navigation", "rect": Rect2(ROOM.position + Vector2(700, 120), Vector2(170, 90)), "progress": 0.0, "color": Color(0.32, 0.66, 0.95)},
        {"name": "Coolant", "rect": Rect2(ROOM.position + Vector2(250, 340), Vector2(160, 90)), "progress": 0.0, "color": Color(0.86, 0.38, 0.94)},
        {"name": "Seal Hatch", "rect": Rect2(ROOM.position + Vector2(600, 330), Vector2(190, 90)), "progress": 0.0, "color": Color(0.91, 0.32, 0.34)}
    ]


func _build_scene() -> void:
    for child in get_children():
        child.queue_free()

    info_label = Label.new()
    info_label.position = Vector2(100, 34)
    info_label.size = Vector2(1080, 44)
    info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    info_label.add_theme_font_size_override("font_size", 34)
    info_label.modulate = TEXT_COLOR
    add_child(info_label)

    help_label = Label.new()
    help_label.position = Vector2(120, 74)
    help_label.size = Vector2(1040, 32)
    help_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    help_label.add_theme_font_size_override("font_size", 20)
    help_label.modulate = MUTED_TEXT
    help_label.text = "Move between stations. Hold Space while touching one to fill its task meter."
    add_child(help_label)


func _move_player(delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    player_position += input_vector * PLAYER_SPEED * delta
    player_position.x = clamp(player_position.x, ROOM.position.x, ROOM.end.x - PLAYER_SIZE.x)
    player_position.y = clamp(player_position.y, ROOM.position.y, ROOM.end.y - PLAYER_SIZE.y)


func _update_station_work(delta: float) -> void:
    var player_rect := Rect2(player_position, PLAYER_SIZE)
    for station in stations:
        var station_rect: Rect2 = station["rect"]
        if station_rect.intersects(player_rect) and Input.is_action_pressed("action"):
            station["progress"] = min(float(station["progress"]) + TASK_FILL_RATE * delta, 1.0)


func _all_tasks_complete() -> bool:
    for station in stations:
        if float(station["progress"]) < 1.0:
            return false
    return true


func _refresh_labels() -> void:
    if info_label == null:
        return

    var finished_tasks := 0
    for station in stations:
        if float(station["progress"]) >= 1.0:
            finished_tasks += 1

    info_label.text = "Tasks complete %d / %d" % [finished_tasks, stations.size()]
