# Tax Season Siege

A Godot 4 jam game about defending Bob's house from the IRS.

You gather materials during a 60-second build phase, place walls and sentries on the yard grid, then survive an incoming wave. Between rounds, nearby resources dry up, so the run slowly pushes you deeper into the forest and into the cave for rarer loot, upgrades, crystals, and the final magic sentry.

## Core Loop

1. Gather wood and stone in the forest.
2. Spend materials on walls and sentries around the house.
3. Start the wave early or wait for the countdown to end.
4. Defend the house and its safe items from the IRS.
5. Push into the cave for iron, gunpowder, gold, keys, upgrades, the boss, and crystals.

## Controls

- `WASD` or arrow keys: move
- `B`: open build menu
- `1 / 2 / 3`: quick-build wall tiers
- `H`: repair wall or repair house
- `G`: open the arms dealer
- `F`: enter or leave the cave / house when prompted
- `Enter`: start the wave early
- `X`: sell the selected structure while building
- `Esc`: open the confirmation menu

## Running The Game

- Open `project.godot` in Godot 4.5 and press Play.
- Or run `Run Test Project.bat`.
- A Windows export is configured in `export_presets.cfg`.

## Submission Notes

- Main scene: `res://scenes/main.tscn`
- Main gameplay script: `res://scripts/main_runtime.gd`
- Export target: `Build/windows/TaxSeasonSiege.exe`
- The game is tuned around endless rounds, with the highest round acting as the score.

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

If you add or replace assets, the loading paths are all centralized inside `_load_art_assets()` in `scripts/main_runtime.gd`.
