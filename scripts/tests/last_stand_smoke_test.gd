extends SceneTree

var failed := false
var observed_outcome := ""


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var game: Node = load("res://scripts/games/last_stand.gd").new()
    root.add_child(game)
    game.start()
    await process_frame

    _assert(game.game_title == "Last Stand", "Last Stand should set its title.")
    _assert(game.player_hp == game.PLAYER_MAX_HP, "Last Stand should reset player health on start.")

    game.finished.connect(_record_outcome)
    game.time_left = 0.01
    game.update(0.02)
    await process_frame
    _assert(observed_outcome == "win", "Last Stand should emit a win when the survival timer reaches zero.")

    var game_two: Node = load("res://scripts/games/last_stand.gd").new()
    root.add_child(game_two)
    game_two.start()
    await process_frame

    observed_outcome = ""
    game_two.finished.connect(_record_outcome)
    game_two.player_hp = 0
    game_two.update(0.01)
    await process_frame
    _assert(observed_outcome == "lose", "Last Stand should emit a loss when player health reaches zero.")

    quit(1 if failed else 0)


func _record_outcome(outcome: String, _title: String, _message: String) -> void:
    observed_outcome = outcome


func _assert(condition: bool, message: String) -> void:
    if condition:
        return
    failed = true
    push_error(message)
