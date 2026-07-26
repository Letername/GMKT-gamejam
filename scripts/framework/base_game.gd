extends Node2D

signal finished(outcome: String, title: String, message: String)
signal exited_to_menu()

var game_title := "Untitled Game"
var countdown_display


func start() -> void:
    pass


func update(_delta: float) -> void:
    pass


func attach_countdown(display) -> void:
    countdown_display = display


func ensure_common_input_actions() -> void:
    _bind_key("action", KEY_SPACE)
    _bind_key("move_left", KEY_A)
    _bind_key("move_left", KEY_LEFT)
    _bind_key("move_right", KEY_D)
    _bind_key("move_right", KEY_RIGHT)
    _bind_key("move_up", KEY_W)
    _bind_key("move_up", KEY_UP)
    _bind_key("move_down", KEY_S)
    _bind_key("move_down", KEY_DOWN)
    _bind_key("menu_back", KEY_ESCAPE)
    _bind_key("debug_win", KEY_W)
    _bind_key("debug_lose", KEY_L)


func end_with_win(message: String = "You win.") -> void:
    finished.emit("win", game_title, message)


func end_with_loss(message: String = "You lose.") -> void:
    finished.emit("lose", game_title, message)


func exit_to_menu() -> void:
    exited_to_menu.emit()


func _bind_key(action: String, keycode: Key) -> void:
    if not InputMap.has_action(action):
        InputMap.add_action(action)

    for event in InputMap.action_get_events(action):
        if event is InputEventKey and event.keycode == keycode:
            return

    var key_event := InputEventKey.new()
    key_event.keycode = keycode
    InputMap.action_add_event(action, key_event)
