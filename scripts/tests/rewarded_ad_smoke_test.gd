extends SceneTree

var failed := false


func _initialize() -> void:
	call_deferred("_run")


func _fail(message: String) -> void:
	failed = true
	push_error(message)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _run() -> void:
	root.size = Vector2i(1280, 720)
	var service := root.get_node_or_null("AdService")
	_check(service != null, "AdService must be registered as an autoload.")
	if service == null:
		_finish(null)
		return
	_check(AudioServer.get_bus_index("AdAudio") >= 0, "The ad needs its own audio bus.")
	_check(service.available_creatives == PackedStringArray(["evil"]), "The current Spare creative must use the existing evil-ad service slot.")

	var requested: bool = bool(service.request_rewarded_ad("evil", true))
	_check(requested, "The mock rewarded ad should start without network access.")
	await process_frame
	var player: CanvasLayer = service.active_player
	_check(player != null, "AdService must own the active player.")
	if player != null:
		_check(paused, "The scene tree must be truly paused during the ad.")
		_check(player.process_mode == Node.PROCESS_MODE_ALWAYS, "The ad player must keep processing while paused.")
		_check(player.voice.process_mode == Node.PROCESS_MODE_ALWAYS, "Voiceover must not freeze under tree pause.")
		_check(player.voice.bus == "AdAudio", "Voiceover must use the dedicated ad bus.")
		_check(player.music.process_mode == Node.PROCESS_MODE_ALWAYS and player.music.bus == "AdAudio", "Ad music must continue safely on the dedicated ad bus while paused.")
		_check(player.music.stream != null, "The licensed commercial music must be loaded.")
		_check(player.video.process_mode == Node.PROCESS_MODE_ALWAYS and player.video.stream != null, "The live-action footage must play while gameplay is paused.")
		_check(player.beats.size() == 12, "Spare must contain all nine narrator and three customer recordings.")
		_check(player.voice.stream != null, "The player's recorded voiceover must load automatically.")
		player.debug_show_time(20.0)
		await process_frame
		_check(player.skip_button.visible, "Skip must unlock after fifteen seconds.")
		_check(player.video.visible, "Spare must remain footage-led during its demonstrations.")
		player.debug_show_time(58.0)
		_check(is_zero_approx(player.current_balance()), "The final Smart Budget transfer must take the remaining money.")
		player.debug_complete()
		await process_frame
		_check(not paused, "Completing the ad must restore the previous tree pause state.")
		_check(service.active_player == null, "The completed ad player must be retired.")

	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence_enabled = false
	if game.team_intro_active:
		game._finish_team_intro()
		await process_frame
	game.set_process(false)
	game._start_new_game()
	_check(game.revive_offer_panel != null and game.revive_offer_watch_button != null and game.revive_offer_decline_button != null, "The game-over offer must be keyboard, mouse, and controller navigable.")
	game.round_number = 4
	game.trophy_stolen = true
	game._enter_game_over_from_trophy_loss()
	_check(game.phase == game.Phase.GAME_OVER and game.revive_offer_pending, "Trophy loss must show the normal game-over beat before the offer.")
	game._update_revive_offer(game.REVIVE_OFFER_DELAY + 0.01)
	_check(game.revive_offer_visible and is_equal_approx(game.revive_offer_countdown, game.REVIVE_OFFER_DURATION), "The revive offer must appear after the defeat beat with a ten-second timer.")
	game._update_revive_offer(game.REVIVE_OFFER_DURATION + 0.01)
	_check(not game.revive_offer_visible and game.revive_used, "The offer must auto-decline and remain one-use per run.")

	game._start_new_game()
	game.round_number = 6
	game.highest_round = 5
	game.trophy_stolen = true
	game.turret_ammo = 7
	game.house_damage_stage = game.HOUSE_MAX_DAMAGE_STAGES
	game.house_items.erase(game.PRIZED_HOUSE_ITEM)
	game.stolen_house_items.append(game.PRIZED_HOUSE_ITEM)
	var wall_key := "test_wall"
	var turret_key := "test_turret"
	game.structures[wall_key] = {"type": game.StructureType.WALL_HEAVY, "cell": Vector2i(2, 2), "hp": 1, "flash_timer": 0.0}
	game.structures[turret_key] = {"type": game.StructureType.TURRET, "cell": Vector2i(3, 3), "weapon": "arrow", "hp": 2, "max_hp": 12, "ammo": 1, "max_ammo": 42, "cooldown": 0.0, "aim_direction": Vector2.RIGHT, "has_target": false, "level": 1, "flash_timer": 0.0, "build_time": 0.0, "build_total": 1.0}
	game.enemies.append({"id": 1})
	game.spawn_queue.append({"type": "runner"})
	game._apply_rewarded_revive()
	_check(game.phase == game.Phase.BUILD and game.round_number == 7, "Reward must clear the lost round and advance to build phase.")
	_check(game.highest_round == 7, "The revived round must count toward normal progression.")
	_check(not game.trophy_stolen and game.PRIZED_HOUSE_ITEM in game.house_items, "Reward must restore the stolen trophy.")
	_check(game.player_hp == game.PLAYER_MAX_HP + game._extra_player_max_hp(), "Reward must fully heal Bob.")
	_check(game.house_damage_stage == 0, "Reward must fully repair the house.")
	_check(int(game.structures[wall_key]["hp"]) == game.WALL_HEAVY_HP, "Reward must fully repair every wall.")
	_check(int(game.structures[turret_key]["hp"]) == 12 and int(game.structures[turret_key]["ammo"]) == 42, "Reward must repair and refill every placed turret.")
	_check(game.turret_ammo == 7, "The conservative revive must not refill the shared ammo reserve.")
	_check(game.enemies.is_empty() and game.spawn_queue.size() > 0, "Reward must clear the defeated wave and prepare the next one.")

	_finish(game)


func _finish(game: Node) -> void:
	if game != null:
		game.queue_free()
	for _cleanup_frame in range(10):
		await process_frame
	if failed:
		print("REWARDED_AD_SMOKE_FAIL")
		quit(1)
	else:
		print("REWARDED_AD_SMOKE_PASS")
		quit()
