extends "res://scripts/framework/base_game.gd"

const BACKGROUND_COLOR := Color(0.14, 0.16, 0.20)
const PANEL_COLOR := Color(0.20, 0.22, 0.28)
const TEXT_COLOR := Color(0.98, 0.95, 0.88)

var slot_name := "Slot"
var time_left := 10.0
var status_label: Label


func configure(new_slot_name: String) -> void:
    slot_name = new_slot_name
    game_title = new_slot_name


func start() -> void:
    ensure_common_input_actions()
    time_left = 10.0
    _build_placeholder_view()
    _refresh_text()


func update(delta: float) -> void:
    time_left = max(time_left - delta, 0.0)
    if countdown_display != null:
        countdown_display.set_seconds(time_left)

    if Input.is_action_just_pressed("menu_back"):
        exit_to_menu()
        return

    if Input.is_action_just_pressed("debug_win"):
        end_with_win("Shared win screen reached from the empty placeholder.")
        return

    if Input.is_action_just_pressed("debug_lose"):
        end_with_loss("Shared loss screen reached from the empty placeholder.")
        return

    if time_left <= 0.0:
        end_with_loss("Placeholder timer expired. Countdown component works.")
        return

    _refresh_text()


func _build_placeholder_view() -> void:
    for child in get_children():
        child.queue_free()

    var background := ColorRect.new()
    background.color = BACKGROUND_COLOR
    background.position = Vector2(140, 120)
    background.size = Vector2(1000, 500)
    add_child(background)

    var panel := ColorRect.new()
    panel.color = PANEL_COLOR
    panel.position = Vector2(220, 180)
    panel.size = Vector2(840, 320)
    add_child(panel)

    var title := Label.new()
    title.position = Vector2(0, 36)
    title.size = Vector2(840, 56)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 44)
    title.text = "%s Placeholder" % slot_name
    title.modulate = TEXT_COLOR
    panel.add_child(title)

    status_label = Label.new()
    status_label.position = Vector2(60, 120)
    status_label.size = Vector2(720, 142)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 24)
    status_label.modulate = TEXT_COLOR
    panel.add_child(status_label)


func _refresh_text() -> void:
    if status_label == null:
        return

    status_label.text = "Foundation test only.\nSpace timer is live, W forces win, L forces lose, Esc returns to menu."
