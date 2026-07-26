extends CanvasLayer

const BOX_COLOR := Color(0.08, 0.10, 0.14, 0.88)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)

var panel: ColorRect
var label: Label


func _ready() -> void:
    panel = ColorRect.new()
    panel.color = BOX_COLOR
    panel.position = Vector2(24, 20)
    panel.size = Vector2(180, 72)
    add_child(panel)

    label = Label.new()
    label.position = Vector2(24, 18)
    label.size = panel.size
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 36)
    label.modulate = TEXT_COLOR
    add_child(label)

    set_seconds(0.0)


func set_seconds(seconds: float) -> void:
    if label == null:
        return
    label.text = "Time %04.1f" % max(seconds, 0.0)


func set_visible_for_game(is_visible: bool) -> void:
    visible = is_visible
