extends SceneTree

const VIEW_SIZE := Vector2i(1280, 720)
const DIRECTIONS := {
	"left": "move_left",
	"right": "move_right",
	"up": "move_up",
	"down": "move_down",
}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = VIEW_SIZE
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	if game.team_intro_active:
		game._finish_team_intro()
		await process_frame

	await _verify_menu_pointer_routing(game)
	assert(game.phase == game.Phase.BUILD, "Clicking New Game must begin the build phase.")
	game.wave_banner_timer = 0.0
	game.set_process(false)
	game._sync_visual_nodes()
	_verify_player_visible(game, "build phase")

	_verify_all_run_frames(game)
	_verify_all_movement_directions(game)
	_verify_camera_edges(game)
	_verify_location_states(game)
	_verify_modal_states(game)
	_verify_phase_states(game)

	Input.action_release("action")
	for action_name in DIRECTIONS.values():
		Input.action_release(action_name)
	game.queue_free()
	for _cleanup_frame in range(10):
		await process_frame
	print("VISUAL_STATE_MATRIX_OK: menu routing, 5 run frames, 4 directions, camera edges, 3 locations, 4 modal states, and 4 phase states")
	quit()


func _verify_menu_pointer_routing(game: Node) -> void:
	assert(game.phase == game.Phase.MENU, "Visual matrix must begin at the main menu.")
	assert(game.menu_background_frames.size() == 5, "The title must load all five directly edited background frames.")
	var unique_menu_frames := {}
	for frame: Texture2D in game.menu_background_frames:
		assert(frame != null and frame.get_size() == Vector2(1280, 720), "Every title animation frame must be a full 1280x720 background.")
		unique_menu_frames[frame.resource_path] = true
	assert(unique_menu_frames.size() == 5, "The five title frames must reference distinct edited images.")
	assert(game.menu_start_button.visible and game.menu_settings_button.visible and game.menu_credits_button.visible, "Primary menu buttons must be visible.")
	assert(game.dev_tools_available and game.menu_dev_button.visible, "The protected Dev Tools entry must be available in normal builds.")
	_assert_control_on_screen(game.menu_start_button, "New Game")
	_assert_control_on_screen(game.menu_settings_button, "Settings")
	_assert_control_on_screen(game.menu_tutorial_button, "Tutorial")
	_assert_control_on_screen(game.menu_credits_button, "Credits")

	Input.action_press("action")
	assert(not game._menu_start_pressed(), "A left click must never be treated as the global New Game shortcut.")
	Input.action_release("action")

	await _click_control(game.menu_settings_button)
	assert(game.phase == game.Phase.MENU, "Clicking Settings must not start a run.")
	assert(game.menu_settings_open and game.menu_settings_panel.visible, "Clicking Settings must open its panel.")
	assert(not game.menu_start_button.visible, "Home buttons must hide behind Settings.")
	game._on_menu_settings_pressed()
	game._refresh_hud()
	assert(not game.menu_settings_open and game.menu_start_button.visible, "Settings Back must restore the menu.")

	await _click_control(game.menu_credits_button)
	assert(game.phase == game.Phase.MENU, "Clicking Credits must not start a run.")
	assert(game.menu_credits_open and game.menu_credits_panel.visible, "Clicking Credits must open its panel.")
	game._close_menu_credits()
	game._refresh_hud()
	assert(not game.menu_credits_open and game.menu_start_button.visible, "Credits Back must restore the menu.")

	game._on_menu_dev_pressed()
	game._refresh_hud()
	assert(game.dev_mode_prompt_open and game.menu_dev_panel.visible, "Dev Tools must open its protected PIN panel.")
	game.menu_dev_pin_input.text = game.DEV_MODE_PIN
	game._on_menu_dev_unlock_pressed()
	game._refresh_hud()
	assert(game.dev_mode_enabled and not game.dev_mode_prompt_open, "The team PIN must unlock Dev Mode.")
	game._on_menu_dev_pressed()
	game._refresh_hud()
	assert(not game.dev_mode_enabled and game.menu_dev_button.visible, "Dev Mode must toggle off without hiding its menu entry.")

	var tutorial_before: bool = game.tutorial_enabled
	await _click_control(game.menu_tutorial_button)
	assert(game.phase == game.Phase.MENU, "Clicking the tutorial toggle must not start a run.")
	assert(game.tutorial_enabled != tutorial_before, "The tutorial button must toggle its setting.")
	await _click_control(game.menu_tutorial_button)
	assert(game.tutorial_enabled == tutorial_before, "The tutorial toggle must be reversible.")

	await _click_control(game.menu_start_button)
	assert(game.phase == game.Phase.BUILD, "Clicking New Game must start a run.")


func _verify_all_run_frames(game: Node) -> void:
	Input.action_press("move_right")
	for frame_index in range(5):
		game.world_time = float(frame_index) / 10.0 + 0.001
		game._sync_player_visual()
		var expected_texture: Texture2D = game._current_player_run_texture()
		assert(expected_texture != null, "Run frame %d must be loaded." % (frame_index + 1))
		assert(expected_texture.get_size() == Vector2(92, 184), "Run frame %d must use its cleaned 92x184 runtime image." % (frame_index + 1))
		assert(expected_texture.get_image().get_used_rect().has_area(), "Run frame %d must contain visible pixels." % (frame_index + 1))
		assert(game.player_visual_sprite.texture == expected_texture, "Run frame %d must reach Bob's body sprite." % (frame_index + 1))
		assert(not game.player_visual_sprite.region_enabled, "Run frame %d must not reuse source-sheet crop coordinates." % (frame_index + 1))
		_verify_player_visible(game, "run frame %d" % (frame_index + 1))
	Input.action_release("move_right")
	game._sync_player_visual()
	assert(not game.player_visual_sprite.region_enabled, "The cleaned idle frame must render without a source-sheet region.")


func _verify_all_movement_directions(game: Node) -> void:
	for direction_name in DIRECTIONS:
		var action_name: String = DIRECTIONS[direction_name]
		var before_position: Vector2 = game.player_position
		Input.action_press(action_name)
		game._move_player(0.12)
		game._update_camera()
		game._sync_visual_nodes()
		assert(game.player_position != before_position, "Moving %s must change Bob's position." % direction_name)
		_verify_player_visible(game, "%s movement" % direction_name)
		assert(not game.player_visual_sprite.region_enabled, "Moving %s must keep the run frame visible." % direction_name)
		Input.action_release(action_name)


func _verify_camera_edges(game: Node) -> void:
	var edge_positions := [
		Vector2(game.GRID_ORIGIN.x, game.GRID_ORIGIN.y),
		Vector2(game.WORLD_SIZE.x - game.PLAYER_SIZE.x, game.GRID_ORIGIN.y),
		Vector2(game.GRID_ORIGIN.x, game.GRID_ORIGIN.y + 2800.0),
		Vector2(game.WORLD_SIZE.x - game.PLAYER_SIZE.x, game.GRID_ORIGIN.y + 2800.0),
	]
	for edge_index in range(edge_positions.size()):
		game.player_position = edge_positions[edge_index]
		game._update_camera()
		game._sync_visual_nodes()
		_verify_player_visible(game, "camera edge %d" % (edge_index + 1))


func _verify_location_states(game: Node) -> void:
	game.inside_house = false
	game.inside_cave = false
	game.cave_mode_token = false
	game.player_position = game._cell_to_world(game.PLAYER_START_CELL) + Vector2(11, 11)
	game._update_camera()
	game._sync_visual_nodes()
	_verify_player_visible(game, "overworld")

	game._enter_house()
	game._sync_visual_nodes()
	assert(game.inside_house, "House state must remain active.")
	_verify_player_visible(game, "house interior")
	game._leave_house()

	game.inside_cave = true
	game.cave_mode_token = true
	game.cave_transition_cooldown = 10.0
	game.cave_player_position = Vector2(640, 360)
	game._sync_visual_nodes()
	_verify_player_visible(game, "cave interior")
	game.inside_cave = false
	game.cave_mode_token = false
	game._sync_visual_nodes()


func _verify_modal_states(game: Node) -> void:
	game.build_menu_open = true
	game._sync_visual_nodes()
	assert(not game.visual_layer.visible, "Sprite children must stay behind the custom-drawn build menu.")
	game.build_menu_open = false
	game._sync_visual_nodes()
	_verify_player_visible(game, "after closing build menu")

	game.escape_confirm_open = true
	game._sync_visual_nodes()
	assert(game.visual_layer.visible, "The world must remain visible behind the escape confirmation.")
	_verify_player_visible(game, "escape confirmation")
	game.escape_confirm_open = false

	game.dealer_menu_open = true
	game._sync_visual_nodes()
	assert(not game.visual_layer.visible, "The dealer's full overlay should intentionally hide the world layer.")
	game.dealer_menu_open = false
	game._sync_visual_nodes()
	_verify_player_visible(game, "after closing dealer")

	game.inventory_menu_open = true
	game._sync_visual_nodes()
	assert(not game.visual_layer.visible, "The inventory's full overlay should intentionally hide the world layer.")
	game.inventory_menu_open = false
	game._sync_visual_nodes()
	_verify_player_visible(game, "after closing inventory")


func _verify_phase_states(game: Node) -> void:
	game.phase = game.Phase.DEFEND
	game._sync_visual_nodes()
	_verify_player_visible(game, "defend phase")
	game.phase = game.Phase.GAME_OVER
	game._sync_visual_nodes()
	assert(not game.visual_layer.visible and not game.player_visual_node.visible, "Gameplay visuals must hide on Game Over.")
	game.phase = game.Phase.MENU
	game._sync_visual_nodes()
	assert(not game.visual_layer.visible and not game.player_visual_node.visible, "Gameplay visuals must hide on the main menu.")
	game.phase = game.Phase.BUILD
	game._sync_visual_nodes()
	_verify_player_visible(game, "return to build phase")


func _verify_player_visible(game: Node, scenario: String) -> void:
	assert(game.visual_layer.visible, "Visual layer unexpectedly hidden during %s." % scenario)
	assert(game.player_visual_node.visible, "Bob's visual node unexpectedly hidden during %s." % scenario)
	assert(game.player_visual_sprite.visible, "Bob's body sprite unexpectedly hidden during %s." % scenario)
	assert(game.player_visual_sprite.texture != null, "Bob has no body texture during %s." % scenario)
	assert(game.player_visual_sprite.modulate.a > 0.99 and game.player_visual_node.modulate.a > 0.99, "Bob became transparent during %s." % scenario)
	var bob_rect := Rect2(game.player_visual_node.position + game.PLAYER_DRAW_OFFSET, game.PLAYER_DRAW_SIZE)
	assert(bob_rect.intersects(Rect2(Vector2.ZERO, Vector2(VIEW_SIZE))), "Bob moved outside the viewport during %s: %s" % [scenario, bob_rect])


func _assert_control_on_screen(control: Control, label: String) -> void:
	assert(control.visible and not control.disabled, "%s must be visible and enabled." % label)
	assert(control.mouse_filter != Control.MOUSE_FILTER_IGNORE, "%s must accept pointer input." % label)
	assert(control.get_global_rect().intersects(Rect2(Vector2.ZERO, Vector2(VIEW_SIZE))), "%s must be inside the viewport." % label)


func _click_control(control: Control) -> void:
	var click_position := control.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = click_position
	Input.parse_input_event(motion)
	await process_frame
	var press := InputEventMouseButton.new()
	press.position = click_position
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	Input.parse_input_event(press)
	await process_frame
	var release := InputEventMouseButton.new()
	release.position = click_position
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	Input.parse_input_event(release)
	await process_frame
