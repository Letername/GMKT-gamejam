# Tax Season Siege

A polished Godot 4.6 portfolio game about defending Bob's house from the IRS.

You gather materials during a 60-second build phase, place walls and sentries on the yard grid, then survive an incoming wave. Between rounds, nearby resources dry up, so the run slowly pushes you deeper into the forest and into the cave for rarer loot, upgrades, crystals, and the final magic sentry.

## Core Loop

1. Gather wood and stone in the forest.
2. Spend materials on walls and sentries around the house.
3. Start the wave early or wait for the countdown to end.
4. Defend the house and its safe items from the IRS.
5. Push into the cave for iron, gunpowder, gold, keys, upgrades, the boss, and crystals.

## Controls

- During the Foundry Eight intro, click anywhere or press `Space` / `Esc` to skip
- `WASD` or arrow keys: move
- Left click or `Space`: attack during IRS waves and cave fights
- Right click or `H`: repair during build phases / parry in the cave
- `B`: open the build menu while standing on an outlined yard tile
- `Tab` or click: switch between the Sentries and Walls build tabs
- `E`: open or close the inventory
- `1 / 2 / 3`: quick-build wall tiers
- `H`: repair wall or repair house
- `T`: hide or show the first-run tutorial
- `G`: open the arms dealer
- `F`: enter or leave the cave / house when prompted
- `Enter`: start the wave early
- `X`: sell the selected structure while building
- `Esc`: open the confirmation menu
- `F11`: toggle fullscreen

Controller:

- Left stick or D-pad: move
- `A` / right trigger: attack or confirm
- `B`: close the current panel or open the safe leave-run confirmation
- `X`: enter or leave nearby locations
- `Y`: open the build menu
- Left shoulder: repair or parry
- Right shoulder: arms dealer
- Back: inventory
- Start: begin the wave early

## Running The Game

- Open `project.godot` in Godot 4.6.2 and press Play.
- Or run `Run Test Project.bat`.
- A Windows export is configured in `export_presets.cfg`.

Audio levels, fullscreen, effects quality, screen-shake strength, minimal HUD, damage numbers, low-health warning, menu motion, automatic control prompts, tutorial preference, highest round, earned sentry/shield unlocks, and boss progress are saved automatically between sessions.

## Submission Notes

- Portfolio release: `1.3.3`
- Main scene: `res://scenes/main.tscn`
- Main gameplay script: `res://scripts/main_runtime.gd`
- Standalone export target: `Build/windows/TaxSeasonSiegeStandalone.exe`
- The standalone executable embeds the game data and does not require a separate `.pck` file.
- The game is tuned around endless rounds, with the highest round acting as the score.
- The first three waves prioritize onboarding; special waves and post-round-five scaling turn the run into a demanding endless challenge.
- The menu uses a five-frame cel loop edited directly from the team's title artwork, with smooth display-rate in-betweens and no extra foreground chase sprites.
- The game-feel pass adds smooth acceleration and stopping, terrain-specific footsteps, sprite-safe stride timing, attack follow-through, sentry aim easing and recoil, construction pops, harvesting feedback, animated pickups, colored impact rings, sparks, tracers, combat-text bounce, and eased phase transitions while preserving the team's artwork.
- IRS squads use readable roles, reassess weak lanes, reposition at range, selectively dodge incoming fire, pressure Bob when useful, and send SWAT saboteurs after active sentries. Each sentry weapon uses a distinct automatic target priority.
- Early waves teach these behaviors gradually; coordinated pressure and stronger dodging ramp in later instead of overwhelming a new run.
- Selected sentries expose their automatic priority and target lock, while attack telegraphs combine a visible warning ring with a restrained warning sound.
- Enemy and sentry visual nodes are synchronized to gameplay and camera state every frame, preventing frozen or detached artwork during movement.
- Game over records rounds survived, defeats, gathering, construction, repairs, cave exploration, run time, and the best round.
- The protected Dev Tools entry is available from the normal main menu and still requires the team's PIN before it can change a run.
- Dev Mode can display enemy routes, numbered decision nodes, tactical targets, roles, and concise thought notes; Settings also exposes invincibility and a 25–400% simulation-speed dial while Dev Mode is unlocked.
- The handmade menu frame, responsive button lift/squish, smooth team-art background loop, automatic keyboard/controller prompts, compact contextual tutorial, prominent damage numbers, brief melee hit-stop, punchier construction/repair/sell feedback, IRS wave-clear jokes, and painful defeat reactions form the 1.3 satisfaction pass.
- The 1.3.3 interface pass adds a live inventory music visualizer, in-run Dev invincibility and speed controls, a compact two-column dealer with non-overlapping details and affordability states, smaller tutorial prompts, relevant-only material totals, grouped Settings, and clearer main-menu/death-screen hierarchy while leaving the team's original menu-button artwork unobstructed.
- Sentries retain valid targets briefly and stagger priority refreshes, keeping tactical target selection responsive while the 180-enemy/28-sentry stress test remains within the intended CPU budget on the target Intel UHD Graphics machine.
- Runtime-ready artwork in `assets/runtime/` is generated exclusively from the team's source art by `scripts/tools/build_runtime_art.gd`.
- Shipped-art provenance is recorded in `Notes/production/art-provenance.md`; direct gameplay textures load from the team's `Art/` folder, approved runtime derivatives, or the Foundry Eight logo.
- The team's `Art/foundry_eight_intro_12s.mp4` is preserved as the source master; `assets/intro/foundry_eight_intro.ogv` is the Godot-compatible release copy used by the skippable boot intro.

## Tunable Balance

Most of the important balancing values live near the top of `scripts/main_runtime.gd`, including:

- build phase duration
- player speed and health
- carry limit
- turret costs, damage, range, and ammo
- wall costs and durability
- enemy count, health, speed, and round scaling
- cave boss timings and rewards

## Art And Audio

- Gameplay art is loaded from `Art/`
- Sound effects are loaded from `Audio/sfx/`
- Footsteps, UI taps, pickups, build thunks, warning cues, and small impacts are original procedural sounds generated by the game, so they add variety without additional third-party files.
- The main menu plays "I miss you" only. Gameplay starts its own playlist with "A risky trek.", followed immediately by "Spaceflight" and "we. all. lain." Song changes are independent of the current round; cave and boss music pause the gameplay playlist so it resumes afterward.

### Credits

- Created by Foundry Eight
- Viktor Nikolaev Dimitrov — Team Chief and Main Programmer
- Aleksandar Hristov Panov — Digital Art
- Aleks Diqan Nikolov — Digital Art
- Joseph Mavlqnov — Game Tester
- Music by [SovieticoOfficial](https://sovieticoofficial.newgrounds.com/)
- "Spaceflight" by [SovieticoOfficial and Vista Sounds](https://www.newgrounds.com/audio/listen/1530823)
- Sound effects by ali_6868, xenonn, and ryansnook
- Built with Godot Engine

If you add or replace assets, the loading paths are centralized inside `_load_art_assets()` in `scripts/main_runtime.gd`. Re-run `scripts/tools/build_runtime_art.gd` after changing any source used by `assets/runtime/`.
