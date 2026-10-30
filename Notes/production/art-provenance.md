# Shipped Art Provenance

This release uses Foundry Eight artwork only. The export has three approved visual sources:

1. Direct team artwork under `Art/`.
2. Lossless or nearest-neighbor runtime derivatives under `assets/runtime/`, built from the source files listed in `scripts/tools/build_runtime_art.gd`.
3. Foundry Eight identity media: `assets/team_logo.png` and the team intro converted from `Art/foundry_eight_intro_12s.mp4` to `assets/intro/foundry_eight_intro.ogv`.

No stock, web-downloaded, marketplace, or third-party raster artwork is loaded by the game. Code-drawn rectangles, lines, circles, text, particles, targeting indicators, cave floor decoration, and UI panels are functional rendering—not imported art assets.

## Runtime Derivative Groups

| Shipped group | Team source |
| --- | --- |
| Menu background and five motion frames | `Art/menu screen (13).png` and the directly edited frame sources in `Art/generated/menu_animation/` |
| Bob idle and run frames | Bob source animation/art in `Art/`, with cleaned frame sources in `Art/generated/` |
| Bob sword | Team weapon art prepared as `Art/generated/bob_sword_cut.png` |
| IRS runner frames | Team IRS character/run art in `Art/`, prepared as frame sources in `Art/generated/` |
| House damage states | `Art/Bob's house.png`, `Art/Bobs house broken 1.png`, and `Art/Bob's house broken 2.png` |
| Gun sentry | Team sentry art in `Art/`, cropped into head/base runtime parts |
| Magic sentry | `Art/majestic centry top.png` and `Art/majestical centry bottom.png` |
| Arms dealer and energy drink | `Art/Arms dealer new.png` and `Art/Energy drink.png` |
| Shield states | Team shield frames under `Art/` |

## Direct-Load Audit

The gameplay loader points character, enemy, boss, animal, environment, resource, structure, projectile, item, icon, and interface textures directly at `Art/`. Historical duplicates under `assets/` are not used where a direct team source exists. `assets/player_reference.png` is intentionally not loaded.

The release audit is enforced by `scripts/tests/release_candidate_smoke_test.gd`, which rejects unexpected texture roots and verifies every required runtime derivative is present.

## UI font

- `assets/fonts/PixelifySans.ttf`: Pixelify Sans by the Pixelify Sans Project Authors, SIL Open Font License 1.1 (`assets/fonts/PixelifySans-OFL.txt`), downloaded 2026-10-29 from github.com/google/fonts. Not team art; chosen by the player for UI text.
- `assets/fonts/Silkscreen-Regular.ttf`: Silkscreen by the Silkscreen Project Authors, SIL Open Font License 1.1 (`assets/fonts/Silkscreen-OFL.txt`), downloaded 2026-10-29. Current UI font; Pixelify is kept on disk but unused.
