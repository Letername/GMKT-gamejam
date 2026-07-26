extends SceneTree

var failed := false
var observed_outcome := ""


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var game: Node = load("res://scripts/games/rewind.gd").new()
    root.add_child(game)
    game.start()
    await process_frame
    game.finished.connect(_record_outcome)

    game.ghost_runs = [[game.switch_rect.position]]
    game._update_ghosts()
    game.player_position = game.exit_rect.position + Vector2(8, 8)
    game.update(0.01)
    await process_frame
    _assert(observed_outcome == "win", "Rewind should emit a win when a ghost holds the switch and the player reaches the exit.")

    observed_outcome = ""
    var game_two: Node = load("res://scripts/games/rewind.gd").new()
    root.add_child(game_two)
    game_two.start()
    await process_frame
    game_two.finished.connect(_record_outcome)
    game_two.loops_used = game_two.MAX_LOOPS
    game_two.time_left = 0.01
    game_two.update(0.02)
    await process_frame
    _assert(observed_outcome == "lose", "Rewind should emit a loss after the final loop expires.")

    quit(1 if failed else 0)


func _record_outcome(outcome: String, _title: String, _message: String) -> void:
    observed_outcome = outcome


func _assert(condition: bool, message: String) -> void:
    if condition:
        return
    failed = true
    push_error(message)
