extends SceneTree

var failed := false
var observed_outcome := ""


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var game: Node = load("res://scripts/games/countdown_to_launch.gd").new()
    root.add_child(game)
    game.start()
    await process_frame
    game.finished.connect(_record_outcome)

    for station in game.stations:
        station["progress"] = 1.0
    game.update(0.01)
    await process_frame
    _assert(observed_outcome == "win", "Countdown to Launch should emit a win when all tasks are complete.")

    observed_outcome = ""
    var game_two: Node = load("res://scripts/games/countdown_to_launch.gd").new()
    root.add_child(game_two)
    game_two.start()
    await process_frame
    game_two.finished.connect(_record_outcome)
    game_two.time_left = 0.01
    game_two.update(0.02)
    await process_frame
    _assert(observed_outcome == "lose", "Countdown to Launch should emit a loss when time runs out.")

    quit(1 if failed else 0)


func _record_outcome(outcome: String, _title: String, _message: String) -> void:
    observed_outcome = outcome


func _assert(condition: bool, message: String) -> void:
    if condition:
        return
    failed = true
    push_error(message)
