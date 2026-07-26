extends CanvasLayer

signal dismissed()

const BACKDROP_COLOR := Color(0.04, 0.05, 0.08, 0.92)
const PANEL_COLOR := Color(0.16, 0.18, 0.24)
const WIN_COLOR := Color(0.36, 0.84, 0.48)
const LOSE_COLOR := Color(0.93, 0.31, 0.29)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)

var outcome := ""
var title_label: Label
var message_label: Label
var prompt_label: Label
var panel: ColorRect


func _ready() -> void:
    visible = false

    var backdrop := ColorRect.new()
    backdrop.color = BACKDROP_COLOR
    backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(backdrop)

    panel = ColorRect.new()
    panel.color = PANEL_COLOR
    panel.position = Vector2(320, 180)
    panel.size = Vector2(640, 280)
    add_child(panel)

    title_label = Label.new()
    title_label.position = Vector2(40, 36)
    title_label.size = Vector2(560, 64)
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 44)
    panel.add_child(title_label)

    message_label = Label.new()
    message_label.position = Vector2(50, 116)
    message_label.size = Vector2(540, 86)
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    message_label.add_theme_font_size_override("font_size", 24)
    panel.add_child(message_label)

    prompt_label = Label.new()
    prompt_label.position = Vector2(40, 220)
    prompt_label.size = Vector2(560, 34)
    prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    prompt_label.add_theme_font_size_override("font_size", 22)
    prompt_label.text = "Press Space to return to the menu"
    panel.add_child(prompt_label)

    _set_text_colors(TEXT_COLOR)


func _input(event: InputEvent) -> void:
    if not visible:
        return
    if event.is_action_pressed("action") or event.is_action_pressed("ui_accept"):
        dismissed.emit()
        get_viewport().set_input_as_handled()


func show_result(outcome_value: String, game_title: String, message: String) -> void:
    outcome = outcome_value
    visible = true

    if outcome == "win":
        title_label.text = "%s - You Win" % game_title
        panel.color = WIN_COLOR.darkened(0.55)
    else:
        title_label.text = "%s - Game Over" % game_title
        panel.color = LOSE_COLOR.darkened(0.55)

    message_label.text = message
    _set_text_colors(TEXT_COLOR)


func hide_result() -> void:
    visible = false


func _set_text_colors(color: Color) -> void:
    title_label.modulate = color
    message_label.modulate = color
    prompt_label.modulate = color
