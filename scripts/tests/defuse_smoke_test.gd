extends SceneTree

var failed := false
var observed_outcome := ""


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var game: Node = load("res://scripts/games/defuse.gd").new()
    root.add_child(game)
    game.start()
    await process_frame
    game.finished.connect(_record_outcome)

    game._meet_elder()
    game._first_smith_talk()
    game._collect_sun_shard()
    game._collect_moon_ore()
    game._forge_dawn_blade()
    game._light_seal(0)
    game._light_seal(1)
    game._light_seal(2)
    game._awaken_warden()
    game.boss_hp = 1
    game._attack_boss()
    game.player_position = game.exit_rect.position + Vector2(8, 8)
    game.update(0.01)
    await process_frame
    _assert(observed_outcome == "win", "Kingdom Under Zero should emit a win after the quest chain and exit.")

    observed_outcome = ""
    var game_two: Node = load("res://scripts/games/defuse.gd").new()
    root.add_child(game_two)
    game_two.start()
    await process_frame
    game_two.finished.connect(_record_outcome)
    game_two.player_hp = 0
    game_two.update(0.01)
    await process_frame
    _assert(observed_outcome == "lose", "Kingdom Under Zero should emit a loss when the player dies.")

    quit(1 if failed else 0)


func _record_outcome(outcome: String, _title: String, _message: String) -> void:
    observed_outcome = outcome


func _assert(condition: bool, message: String) -> void:
    if condition:
        return
    failed = true
    push_error(message)
