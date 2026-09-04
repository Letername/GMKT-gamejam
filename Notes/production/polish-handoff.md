# Tax Season Siege — Product Polish Handoff

This file is the source of truth for continuing the final polish pass. Do not ask the player to repeat these decisions unless a genuinely new choice is required.

## Product target

Make the entire game feel portfolio-quality, charming, impressive, addictive, funny, handmade, playful, smooth, responsive, and highly satisfying. Polish every screen and interaction, with the main menu as the highest-priority weak point.

## Non-negotiable constraints

- Preserve every piece of artwork made by the team. Do not replace, redraw, remove, or stylistically overwrite team art.
- Runtime visuals should use team art or clearly documented derivatives made from team art.
- Do not introduce a dramatic, rough, horror-like, or Ink Games-inspired animation direction. The player explicitly cancelled those references.
- Background animation should make the existing art feel alive while keeping each frame visually consistent. Do not paste unrelated objects or effects onto the artwork.
- Animation should be smooth rather than choppy.
- The Foundry Eight team intro must remain wired in and skippable by clicking or using keyboard/controller input.
- The tutorial must remain optional.
- Dev Mode must remain available from the normal menu and protected by PIN `5543`.
- Never run visible or audible automated tests. Use a hidden/headless window and `--audio-driver Dummy`. The player previously heard menu audio from a test and explicitly asked that this never happen again.
- End every test/export pass with zero `Godot` or `TaxSeasonSiege` processes running.
- Update `Build/windows/TaxSeasonSiegeStandalone.exe` only after the source and exported candidate pass the release checks.

## Latest 30-question alignment

1. **What feels least satisfying?** Fix everything, but the menu is specifically unsatisfying.
2. **UI direction?** More handmade and playful.
3. **Combat information density?** Minimal.
4. **Button interaction feel?** Very satisfying and better than the current version.
5. **Menu transitions?** Use whichever transition is most satisfying.
6. **Animated menu background energy?** Choose the most satisfying result.
7. **Movement response?** Add a tiny amount of natural momentum.
8. **Sword-hit satisfaction?** Agent decides.
9. **Screen-shake strength?** Agent decides, with settings available.
10. **Damage numbers?** Prominent.
11. **Enemy intention telegraphs?** Agent decides; keep them readable and fair.
12. **Smart enemy behavior?** Enemies should use navigation/decision nodes, think through decisions intelligently, and expose their plans in Dev Mode.
13. **Later-wave composition?** Use larger hordes, stronger specialists, and tactical combinations together.
14. **Building feedback?** Make placing sentries and walls satisfying.
15. **Upgrade/repair/target/sell feedback?** Agent decides.
16. **Sentry personality?** Mechanical and punchy.
17. **Resources and rare rewards?** Very obvious.
18. **Gathering feel?** A satisfying committed interaction rather than a flat pickup.
19. **Low-health presentation?** Agent decides; it must be clear without obstructing play.
20. **Wave-completion celebration?** Agent decides.
21. **Defeat tone?** It should feel meaningfully painful.
22. **Humor?** IRS jokes, absurd text, and character reactions.
23. **Tutorial structure?** Small contextual prompts, not a large persistent checklist panel.
24. **Settings?** Provide a lot of useful settings.
25. **Input prompts?** Automatically switch between keyboard/mouse and controller based on the most recent device.
26. **Dev Mode powers?** Show enemy AI nodes and notes explaining what enemies are thinking; add invincibility and a simulation-speed dial in Settings.
27. **Persistence?** Remember settings, tutorial choice, highest wave, unlocks, and useful progress between launches.
28. **Minimum-performance target?** The player's current computer. Previous rendering identified Intel UHD Graphics; run the existing late-wave benchmark locally.
29. **Three portfolio showcase moments?** Undecided; the agent should choose the strongest three after visual QA.
30. **Content that must not be redesigned/removed?** Every artwork made by the team.

## Earlier confirmed direction

- Overall quality target: full portfolio quality.
- Replace or stop using art that was not drawn by the team.
- Desired emotional result: charming, impressive, addictive, and funny.
- Use a very short hit-stop where appropriate.
- Enemy intelligence should be substantially improved without making early rounds unfair.
- Dev Mode was explicitly requested back and must not disappear again.
- The player previously encountered disappearing movement visuals and inaccessible buttons; movement visibility, modal ordering, focus, and clickable controls need regression coverage.

## Work completed before this handoff

- Team intro is implemented and skippable.
- Optional guided tutorial exists.
- Dev Mode is available with PIN protection.
- Smooth five-frame menu background animation exists using team-art derivatives.
- Player movement uses velocity, acceleration, deceleration, turn acceleration, skid feedback, footsteps, and visible run frames.
- Enemy roles include skirmisher, flanker, breacher, saboteur, and commander behaviors.
- Enemies assess weak lanes, pressure Bob after early rounds, target defenses, keep ranged spacing, and probabilistically dodge projectiles.
- Turret targeting was optimized with caches; selected/Dev sentries show target lines.
- Procedural UI, pickup, build, warning, impact, and surface-footstep sounds exist.
- Controller bindings, menu focus, dealer controller navigation, and safe modal cancellation exist.
- Runtime-art provenance is documented in `Notes/production/art-provenance.md`.
- A 28-screen visual capture suite and several gameplay/release tests exist under `scripts/tests/`.
- The previous stable standalone was version 1.2.0. Its SHA-256 was `FF6263A28BDC51C3EEECB04BBEF61B5F252EE778D309E87D19580952B95F37BC` before the new, unexported pass began.
- The previous late-wave benchmark passed with 180 enemies and 28 sentries at about 15.24 ms per frame on this computer.

## Work started in the current pass — verify before continuing

The source has been edited but has **not yet been parsed, regression-tested, visually captured, or exported** after these newest edits. Continue from the working tree; do not discard unrelated or previous user changes.

Started changes in `scripts/main_runtime.gd`:

- Added planned settings/state for minimal HUD, prominent damage numbers, low-health warnings, automatic control prompts, menu motion, Dev invincibility, and Dev simulation speed.
- Added persistent progress fields for sentry unlocks, shield unlock, and boss completion.
- Added automatic input-device detection and prompt helpers.
- Replaced the large first-run tutorial checklist with a smaller contextual next-step card.
- Added dynamic keyboard/controller labels to house, dealer, cave, repair, and tutorial prompts.
- Added procedural hover audio and button hover/press/release scale-and-rotation feedback.
- Added subtle menu-background parallax and a handmade frame around the menu without modifying team artwork.
- Expanded the Settings panel to two columns with readability, prompt, motion, invincibility, and simulation-speed controls.
- Added loading/saving for the new settings and persistent-progress fields.

These changes were interrupted immediately after the expanded Settings panel patch. The next agent must first run a parser/smoke test and fix any errors before adding more behavior.

## Remaining implementation work

1. Parse and smoke-test the interrupted source changes using hidden/headless Godot with Dummy audio.
2. Finish Settings behavior and verify every control is visible, focusable, clickable, controller-accessible, and persisted.
3. Refresh Settings button text/state after Dev Mode is enabled or disabled.
4. Implement Dev invincibility at every player-damage site, including cave rocks, cave enemies, the boss, and yard enemies.
5. Finish persistent unlock behavior: apply saved unlocks at run start and save immediately when each unlock/boss achievement is earned.
6. Make prominent damage numbers configurable; use larger outlined numbers for damage while keeping non-damage status text restrained.
7. Add satisfying wave-clear feedback and painful, funny IRS-themed defeat copy/reactions.
8. Add Dev Mode enemy navigation nodes, current target lines, role labels, and concise thought notes. These displays must only appear in Dev Mode.
9. Improve enemy planning only where tests demonstrate a benefit; keep rounds 1–2 fair and readable.
10. Finish minimal-HUD behavior and ensure contextual prompts do not overlap menus, countdowns, or world interactions.
11. Check menu hover animation carefully so buttons never move outside hitboxes or become inaccessible.
12. Update automated tests for every new setting, persistence field, device switch, Dev feature, and AI visualization.
13. Capture and inspect all UI states at 1280×720 plus at least one alternate aspect ratio/window size.
14. Run the late-wave performance benchmark on this machine and keep the average near or below the previous result.
15. Bump the product version, export to a separate candidate, run the exact candidate hidden/muted, then replace the standalone.

## Recommended portfolio showcase moments

Because answer 29 was undecided, use these unless visual QA reveals stronger shots:

1. Main menu with the team-art background, handmade frame, and polished focus/hover state.
2. A dense defense wave showing punchy sentries, readable damage numbers, rewards, and enemy telegraphs with minimal HUD.
3. Dev Mode during a tactical wave, visibly showing enemy navigation nodes, targets, roles, and thought notes.

## Local tools and release checks

- Godot executable: `.tools/godot-4.6.2/Godot_v4.6.2-stable_win64.exe`
- Main runtime: `scripts/main_runtime.gd`
- Main scene: `scenes/main.tscn`
- Export preset: `Windows Desktop`
- Final executable: `Build/windows/TaxSeasonSiegeStandalone.exe`
- Useful tests include:
  - `scripts/tests/release_candidate_smoke_test.gd`
  - `scripts/tests/visual_state_matrix_test.gd`
  - `scripts/tests/ui_capture_test.gd`
  - `scripts/tests/satisfaction_ai_smoke_test.gd`
  - `scripts/tests/late_wave_performance_test.gd`
  - `scripts/tests/intro_smoke_test.gd`

Always preserve the dirty working tree and avoid destructive Git operations.

## 2026-08-29 music follow-up

- The player requested that the first song stop repeating until gameplay progression and that every main track play directly after the previous one.
- Player correction: `I miss you` is menu-only. Starting a run stops it and starts the separate three-track gameplay playlist: `A risky trek.`, `Spaceflight`, then `we. all. lain.`
- Gameplay playlist advancement is independent of the round. Cave/boss music pauses the gameplay playlist so it resumes at the same song position afterward.
- Every MP3 is explicitly non-looping. The release smoke suite checks the menu/gameplay boundary, order, immediate advancement, round independence, and cave pause/resume behavior.
- Hidden Dummy-audio release and intro checks passed with zero remaining Godot/game processes.
- Windows standalone `1.3.1` was exported, candidate-tested, promoted, and retested at `Build/windows/TaxSeasonSiegeStandalone.exe`.
- Final SHA-256: `9C82D12AE166020775639CB425314CFF65BD2464345F4FE10CA0AC09A7F967D8`.

## 2026-08-29 UI follow-up

- The player identified the dealer, Settings, tutorial prompts, main menu, and death screen as the weakest remaining UI.
- Panels should cover little of the game world. Material totals should remain hidden until a build, inventory, or trade makes them relevant.
- The inventory now includes a live spectrum visualizer and current-song title. When Dev Mode is active, it also exposes invincibility and the persistent 25–400% simulation-speed dial.
- The dealer uses a compact readable two-column layout with affordability/owned states and a dedicated detail strip; product cards and descriptions no longer overlap.
- Tutorial prompts are now small next-action cards. Settings uses grouped sections and correctly changes its Dev hint after unlock.
- The main and death screens have clearer hierarchy. Do not place a `FORM 1040-BOB` badge on the main menu and do not cover or correct the team-drawn Settings label; the original menu artwork must remain unobstructed. The game-over seizure badge may remain.
- Release smoke, 35-state hidden visual capture, interaction matrix, and hidden 1440×900 alternate-window capture passed with Dummy audio and zero remaining processes.
- Windows standalone `1.3.2` was candidate-tested, promoted, and retested. Final SHA-256: `CC01CB65DFCDFF5BF7829E83978C8A2CEDDEC313C9E0F2B425BD8D3DB4FA8948`.

## 2026-08-29 player correction release

- Removed the `FORM 1040-BOB` main-menu badge and the correction overlay that covered the team-drawn Settings button.
- Restored the intended split between menu-only and gameplay music, with immediate song-to-song gameplay advancement and no round gates.
- Windows standalone `1.3.3` passed release smoke, hidden-renderer visual capture, candidate launch, and final promoted-executable launch with Dummy audio and zero remaining processes. Final SHA-256: `8BCC52E36EC54559AEEB99A393F0B31CFAF8CEF624BE590A8029439C045C68B7`.
