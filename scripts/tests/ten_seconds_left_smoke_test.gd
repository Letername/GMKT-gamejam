extends SceneTree

var failed := false
var observed_outcome := ""


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var game: Node = load("res://scripts/games/ten_seconds_left.gd").new()
    root.add_child(game)
    game.start()
    await process_frame
    game.finished.connect(_record_outcome)
    game._choose(0)
    await process_frame
    _assert(observed_outcome == "win", "10 Seconds Left should emit a win for a positive ending choice.")

    observed_outcome = ""
    var game_two: Node = load("res://scripts/games/ten_seconds_left.gd").new()
    root.add_child(game_two)
    game_two.start()
    await process_frame
    game_two.finished.connect(_record_outcome)
    game_two.time_left = 0.01
    game_two.update(0.02)
    await process_frame
    _assert(observed_outcome == "lose", "10 Seconds Left should emit a loss when time reaches zero.")

    quit(1 if failed else 0)


func _record_outcome(outcome: String, _title: String, _message: String) -> void:
    observed_outcome = outcome


func _assert(condition: bool, message: String) -> void:
    if condition:
        return
    failed = true
    push_error(message)
