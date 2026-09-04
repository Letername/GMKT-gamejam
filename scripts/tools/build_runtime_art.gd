extends SceneTree

# Produces compact, nearest-neighbor runtime copies from the team's source art.
# Source files stay untouched and remain the single source of truth.
const OUTPUT_DIR := "res://assets/runtime"

const JOBS: Array[Dictionary] = [
	{"src": "res://Art/menu screen (13).png", "dst": "menu_background.png", "region": Rect2i(0, 1296, 4793, 2721), "size": Vector2i(1280, 720)},
	{"src": "res://Art/generated/menu_animation/menu_background_frame_1_source.png", "dst": "menu_background_frame_1.png", "size": Vector2i(1280, 720)},
	{"src": "res://Art/generated/menu_animation/menu_background_frame_2_source.png", "dst": "menu_background_frame_2.png", "size": Vector2i(1280, 720)},
	{"src": "res://Art/generated/menu_animation/menu_background_frame_3_source.png", "dst": "menu_background_frame_3.png", "size": Vector2i(1280, 720)},
	{"src": "res://Art/generated/menu_animation/menu_background_frame_4_source.png", "dst": "menu_background_frame_4.png", "size": Vector2i(1280, 720)},
	{"src": "res://Art/generated/menu_animation/menu_background_frame_5_source.png", "dst": "menu_background_frame_5.png", "size": Vector2i(1280, 720)},
	{"src": "res://Art/Bob's house.png", "dst": "house.png", "size": Vector2i(292, 292)},
	{"src": "res://Art/Bobs house broken 1.png", "dst": "house_damaged.png", "size": Vector2i(292, 292)},
	{"src": "res://Art/Bob's house broken 2.png", "dst": "house_breached.png", "size": Vector2i(292, 292)},
	{"src": "res://Art/generated/bob_idle_left_1.png", "dst": "bob_idle_left_1.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_idle_left_2.png", "dst": "bob_idle_left_2.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_idle_right_1.png", "dst": "bob_idle_right_1.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_idle_right_2.png", "dst": "bob_idle_right_2.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_run_1_clean.png", "dst": "bob_run_1.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_run_2_clean.png", "dst": "bob_run_2.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_run_3_clean.png", "dst": "bob_run_3.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_run_4_clean.png", "dst": "bob_run_4.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/bob_run_5_clean.png", "dst": "bob_run_5.png", "size": Vector2i(92, 184)},
	{"src": "res://Art/generated/irs_runner_1.png", "dst": "irs_runner_1.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/irs_runner_2.png", "dst": "irs_runner_2.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/irs_runner_3.png", "dst": "irs_runner_3.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/irs_runner_4.png", "dst": "irs_runner_4.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/irs_runner_5.png", "dst": "irs_runner_5.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/irs_runner_6.png", "dst": "irs_runner_6.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/irs_runner_7.png", "dst": "irs_runner_7.png", "size": Vector2i(96, 164)},
	{"src": "res://Art/generated/gun_sentry_head_cut.png", "dst": "gun_sentry_head.png", "crop": true, "size": Vector2i(136, 42)},
	{"src": "res://Art/generated/gun_sentry_base_cut.png", "dst": "gun_sentry_base.png", "crop": true, "size": Vector2i(104, 64)},
	{"src": "res://Art/majestic centry top.png", "dst": "magic_sentry_head.png", "crop": true, "size": Vector2i(168, 120)},
	{"src": "res://Art/majestical centry bottom.png", "dst": "magic_sentry_base.png", "crop": true, "size": Vector2i(148, 128)},
	{"src": "res://Art/Arms dealer new.png", "dst": "arms_dealer.png", "crop": true, "size": Vector2i(116, 224)},
	{"src": "res://Art/Energy drink.png", "dst": "energy_drink.png", "crop": true, "size": Vector2i(76, 112)},
	{"src": "res://Art/generated/bob_sword_cut.png", "dst": "bob_sword.png", "crop": true, "size": Vector2i(28, 108)},
	{"src": "res://Art/shield block left 1-1.png.png", "dst": "shield_left_idle.png", "crop": true, "size": Vector2i(84, 92)},
	{"src": "res://Art/shield block left 2-2.png.png", "dst": "shield_left_block.png", "crop": true, "size": Vector2i(84, 92)},
	{"src": "res://Art/shield block right 1-1.png.png", "dst": "shield_right_idle.png", "crop": true, "size": Vector2i(84, 92)},
	{"src": "res://Art/shield block right 2-2.png.png", "dst": "shield_right_block.png", "crop": true, "size": Vector2i(84, 92)}
]


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	var absolute_output_dir := ProjectSettings.globalize_path(OUTPUT_DIR)
	var directory_error := DirAccess.make_dir_recursive_absolute(absolute_output_dir)
	if directory_error != OK:
		push_error("Could not create runtime art directory (error %d)." % directory_error)
		quit(1)
		return

	for job in JOBS:
		var source_path: String = String(job["src"])
		var image := Image.load_from_file(ProjectSettings.globalize_path(source_path))
		if image == null or image.is_empty():
			push_error("Could not load %s." % source_path)
			quit(1)
			return
		if job.has("region"):
			image = image.get_region(Rect2i(job["region"]))
		if bool(job.get("crop", false)):
			var used_rect := image.get_used_rect()
			if used_rect.has_area():
				image = image.get_region(used_rect)
		var target_size: Vector2i = Vector2i(job["size"])
		image.resize(target_size.x, target_size.y, Image.INTERPOLATE_NEAREST)
		var output_path := "%s/%s" % [OUTPUT_DIR, String(job["dst"])]
		var save_error := image.save_png(ProjectSettings.globalize_path(output_path))
		if save_error != OK:
			push_error("Could not save %s (error %d)." % [output_path, save_error])
			quit(1)
			return

	print("RUNTIME_ART_BUILD_PASS (%d assets)" % JOBS.size())
	quit(0)
