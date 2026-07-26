extends "res://scripts/framework/base_game.gd"

const BACKGROUND_COLOR := Color(0.05, 0.05, 0.08)
const PANEL_COLOR := Color(0.14, 0.15, 0.20)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)
const MUTED_TEXT := Color(0.74, 0.76, 0.82)
const CHOICE_COLORS := [
    Color(0.33, 0.67, 0.95),
    Color(0.92, 0.43, 0.35),
    Color(0.40, 0.85, 0.52)
]
const TIME_LIMIT := 10.0

var time_left := TIME_LIMIT
var title_label: Label
var body_label: Label
var choices: Array[Dictionary] = []


func _ready() -> void:
    game_title = "10 Seconds Left"


func start() -> void:
    ensure_common_input_actions()
    game_title = "10 Seconds Left"
    time_left = TIME_LIMIT
    _build_choices()
    _build_scene()
    if countdown_display != null:
        countdown_display.set_seconds(time_left)


func update(delta: float) -> void:
    if Input.is_action_just_pressed("menu_back"):
        exit_to_menu()
        return

    time_left = max(time_left - delta, 0.0)
    if countdown_display != null:
        countdown_display.set_seconds(time_left)

    if Input.is_key_pressed(KEY_1):
        _choose(0)
    elif Input.is_key_pressed(KEY_2):
        _choose(1)
    elif Input.is_key_pressed(KEY_3):
        _choose(2)

    if time_left <= 0.0:
        end_with_loss("You ran out of time and said nothing.")


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var click_event: InputEventMouseButton = event
        for index in range(choices.size()):
            if Rect2(choices[index]["rect"]).has_point(click_event.position):
                _choose(index)
                get_viewport().set_input_as_handled()
                return


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), BACKGROUND_COLOR, true)
    draw_rect(Rect2(Vector2(180, 100), Vector2(920, 500)), PANEL_COLOR, true)

    for index in range(choices.size()):
        draw_rect(choices[index]["rect"], CHOICE_COLORS[index], true)


func _build_choices() -> void:
    choices = [
        {
            "title": "Call your sister",
            "body": "You use the final seconds to say what mattered. The line connects.",
            "outcome": "win",
            "rect": Rect2(Vector2(260, 360), Vector2(220, 120))
        },
        {
            "title": "Freeze",
            "body": "You wait for the perfect words and lose the chance entirely.",
            "outcome": "lose",
            "rect": Rect2(Vector2(530, 360), Vector2(220, 120))
        },
        {
            "title": "Open the door",
            "body": "You step into the light and choose motion over panic.",
            "outcome": "win",
            "rect": Rect2(Vector2(800, 360), Vector2(220, 120))
        }
    ]


func _build_scene() -> void:
    for child in get_children():
        child.queue_free()

    title_label = Label.new()
    title_label.position = Vector2(210, 132)
    title_label.size = Vector2(860, 54)
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 42)
    title_label.modulate = TEXT_COLOR
    title_label.text = "10 SECONDS LEFT"
    add_child(title_label)

    body_label = Label.new()
    body_label.position = Vector2(260, 210)
    body_label.size = Vector2(760, 94)
    body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    body_label.add_theme_font_size_override("font_size", 24)
    body_label.modulate = MUTED_TEXT
    body_label.text = "The alarms have gone quiet. There is just enough time to choose one last thing."
    add_child(body_label)

    for index in range(choices.size()):
        var label := Label.new()
        label.position = choices[index]["rect"].position + Vector2(12, 24)
        label.size = Vector2(choices[index]["rect"].size.x - 24, 72)
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        label.add_theme_font_size_override("font_size", 24)
        label.modulate = TEXT_COLOR
        label.text = "%d. %s" % [index + 1, choices[index]["title"]]
        add_child(label)


func _choose(index: int) -> void:
    var choice: Dictionary = choices[index]
    if String(choice["outcome"]) == "win":
        end_with_win(String(choice["body"]))
    else:
        end_with_loss(String(choice["body"]))
