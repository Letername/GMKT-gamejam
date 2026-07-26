extends "res://scripts/framework/base_game.gd"

const PLAYFIELD := Rect2(Vector2(140, 90), Vector2(1000, 560))
const PLAYER_SIZE := Vector2(28, 42)
const MOVE_SPEED := 210.0
const JUMP_SPEED := -520.0
const GRAVITY := 1450.0
const LOOP_DURATION := 10.0
const MAX_LOOPS := 5

const BACKGROUND_COLOR := Color(0.08, 0.09, 0.12)
const FIELD_COLOR := Color(0.14, 0.16, 0.20)
const PLATFORM_COLOR := Color(0.38, 0.45, 0.54)
const PLAYER_COLOR := Color(0.96, 0.84, 0.28)
const GHOST_COLOR := Color(0.35, 0.80, 0.95, 0.45)
const SWITCH_COLOR := Color(0.39, 0.87, 0.46)
const DOOR_COLOR := Color(0.88, 0.31, 0.32)
const OPEN_DOOR_COLOR := Color(0.35, 0.92, 0.57, 0.45)
const EXIT_COLOR := Color(0.96, 0.96, 0.98)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)

var spawn_position := Vector2(210, 528)
var player_position := Vector2.ZERO
var player_velocity := Vector2.ZERO
var loop_time_left := LOOP_DURATION
var loops_used := 1
var frame_index := 0
var current_run: Array[Vector2] = []
var ghost_runs: Array[Array] = []
var ghost_positions: Array[Vector2] = []

var platforms: Array[Rect2] = []
var switch_rect := Rect2()
var door_rect := Rect2()
var exit_rect := Rect2()
var info_label: Label
var help_label: Label


func _ready() -> void:
    game_title = "Rewind"


func start() -> void:
    ensure_common_input_actions()
    game_title = "Rewind"
    _build_level()
    _build_scene()
    ghost_runs.clear()
    ghost_positions.clear()
    loops_used = 1
    _reset_current_loop()
    _refresh_labels()


func update(delta: float) -> void:
    if Input.is_action_just_pressed("menu_back"):
        exit_to_menu()
        return

    loop_time_left = max(loop_time_left - delta, 0.0)
    if countdown_display != null:
        countdown_display.set_seconds(loop_time_left)

    _update_ghosts()
    _move_player(delta)
    current_run.append(player_position)
    frame_index += 1

    if _door_is_open() and Rect2(player_position, PLAYER_SIZE).intersects(exit_rect):
        end_with_win("You used your previous loops to hold the switch and reach the exit.")
        return

    if loop_time_left <= 0.0:
        _finish_loop()
        if loops_used > MAX_LOOPS:
            end_with_loss("The loop collapsed before you solved the room.")
            return

    _refresh_labels()
    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), BACKGROUND_COLOR, true)
    draw_rect(PLAYFIELD, FIELD_COLOR, true)

    for platform in platforms:
        draw_rect(platform, PLATFORM_COLOR, true)

    draw_rect(switch_rect, SWITCH_COLOR, true)
    draw_rect(door_rect, OPEN_DOOR_COLOR if _door_is_open() else DOOR_COLOR, true)
    draw_rect(exit_rect, EXIT_COLOR, true)

    for ghost_position in ghost_positions:
        draw_rect(Rect2(ghost_position, PLAYER_SIZE), GHOST_COLOR, true)

    draw_rect(Rect2(player_position, PLAYER_SIZE), PLAYER_COLOR, true)


func _build_level() -> void:
    platforms = [
        Rect2(PLAYFIELD.position + Vector2(0, 480), Vector2(1000, 80)),
        Rect2(PLAYFIELD.position + Vector2(170, 360), Vector2(210, 24)),
        Rect2(PLAYFIELD.position + Vector2(610, 300), Vector2(230, 24))
    ]
    switch_rect = Rect2(PLAYFIELD.position + Vector2(230, 332), Vector2(90, 28))
    door_rect = Rect2(PLAYFIELD.position + Vector2(790, 198), Vector2(28, 102))
    exit_rect = Rect2(PLAYFIELD.position + Vector2(888, 238), Vector2(62, 62))
    spawn_position = PLAYFIELD.position + Vector2(70, 438)


func _build_scene() -> void:
    for child in get_children():
        child.queue_free()

    info_label = Label.new()
    info_label.position = Vector2(120, 28)
    info_label.size = Vector2(1040, 40)
    info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    info_label.add_theme_font_size_override("font_size", 30)
    info_label.modulate = TEXT_COLOR
    add_child(info_label)

    help_label = Label.new()
    help_label.position = Vector2(100, 62)
    help_label.size = Vector2(1080, 28)
    help_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    help_label.add_theme_font_size_override("font_size", 18)
    help_label.modulate = TEXT_COLOR
    help_label.text = "Stand on the switch in one loop so a ghost can hold the door for the next one."
    add_child(help_label)


func _reset_current_loop() -> void:
    player_position = spawn_position
    player_velocity = Vector2.ZERO
    loop_time_left = LOOP_DURATION
    frame_index = 0
    current_run.clear()
    if countdown_display != null:
        countdown_display.set_seconds(loop_time_left)


func _finish_loop() -> void:
    ghost_runs.append(current_run.duplicate())
    loops_used += 1
    _reset_current_loop()


func _update_ghosts() -> void:
    ghost_positions.clear()
    for run in ghost_runs:
        if run.is_empty():
            continue
        var ghost_frame := mini(frame_index, run.size() - 1)
        ghost_positions.append(run[ghost_frame])


func _move_player(delta: float) -> void:
    var on_floor := _is_on_floor()
    var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    player_velocity.x = input_vector.x * MOVE_SPEED
    player_velocity.y += GRAVITY * delta

    if (Input.is_action_just_pressed("action") or Input.is_action_just_pressed("move_up")) and on_floor:
        player_velocity.y = JUMP_SPEED

    player_position.x += player_velocity.x * delta
    if not _door_is_open() and Rect2(player_position, PLAYER_SIZE).intersects(door_rect):
        if player_velocity.x > 0.0:
            player_position.x = door_rect.position.x - PLAYER_SIZE.x
        elif player_velocity.x < 0.0:
            player_position.x = door_rect.end.x

    for platform in platforms:
        if Rect2(player_position, PLAYER_SIZE).intersects(platform):
            if player_velocity.x > 0.0:
                player_position.x = platform.position.x - PLAYER_SIZE.x
            elif player_velocity.x < 0.0:
                player_position.x = platform.end.x

    player_position.y += player_velocity.y * delta
    for platform in platforms:
        if Rect2(player_position, PLAYER_SIZE).intersects(platform):
            if player_velocity.y > 0.0:
                player_position.y = platform.position.y - PLAYER_SIZE.y
                player_velocity.y = 0.0
            elif player_velocity.y < 0.0:
                player_position.y = platform.end.y
                player_velocity.y = 0.0

    player_position.x = clamp(player_position.x, PLAYFIELD.position.x, PLAYFIELD.end.x - PLAYER_SIZE.x)
    player_position.y = min(player_position.y, PLAYFIELD.end.y - PLAYER_SIZE.y)


func _is_on_floor() -> bool:
    var probe := Rect2(player_position + Vector2(0, 2), PLAYER_SIZE)
    for platform in platforms:
        if probe.intersects(platform):
            return true
    return false


func _door_is_open() -> bool:
    if Rect2(player_position, PLAYER_SIZE).intersects(switch_rect):
        return true
    for ghost_position in ghost_positions:
        if Rect2(ghost_position, PLAYER_SIZE).intersects(switch_rect):
            return true
    return false


func _refresh_labels() -> void:
    if info_label == null:
        return
    info_label.text = "Loop %d / %d  |  Ghosts %d" % [loops_used, MAX_LOOPS, ghost_runs.size()]
