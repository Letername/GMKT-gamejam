extends SceneTree

var failed := false


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var main_scene: Node = load("res://scenes/main.tscn").instantiate()
    root.add_child(main_scene)
    await process_frame

    _assert(main_scene.state == main_scene.AppState.MENU, "Main scene should start in menu state.")
    _assert(main_scene.menu_layer.visible, "Menu should be visible on boot.")

    main_scene._launch_selected_slot(1)
    await process_frame

    _assert(main_scene.state == main_scene.AppState.PLAYING, "Launching a slot should enter play state.")
    _assert(main_scene.active_game != null, "Placeholder game should exist after launch.")
    _assert(main_scene.countdown_display.visible, "Countdown display should be visible during play.")

    main_scene.active_game.exit_to_menu()
    await process_frame

    _assert(main_scene.state == main_scene.AppState.MENU, "Exiting placeholder should return to menu.")
    _assert(main_scene.active_game == null, "Active game should be cleared when returning to menu.")

    main_scene._launch_selected_slot(1)
    await process_frame
    main_scene.active_game.end_with_win("Shared result screen smoke test.")
    await process_frame

    _assert(main_scene.state == main_scene.AppState.RESULT, "Winning should show the shared result screen.")
    _assert(main_scene.result_screen.visible, "Result screen should be visible after a win.")

    main_scene._on_result_dismissed()
    await process_frame

    _assert(main_scene.state == main_scene.AppState.MENU, "Dismissing result screen should return to menu.")
    quit(1 if failed else 0)


func _assert(condition: bool, message: String) -> void:
    if condition:
        return
    failed = true
    push_error(message)
