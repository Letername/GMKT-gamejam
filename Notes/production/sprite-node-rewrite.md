# Sprite node rewrite — architecture and progress

The player asked for every sprite to become its own Node2D. This file records how
that is being done and what is left, so a later session can continue without
re-deriving the layering rules.

## The problem that had to be solved first

`main_runtime.gd` painted the whole game from a single `_draw()`. Any child node
of the runtime renders *above* everything that `_draw()` paints, so naively
turning a tree into a `Sprite2D` put that tree on top of the HUD.

The fix is a z-index band. The backdrop was moved down into its own canvas item,
which opens a range of negative z-indices between the backdrop and the runtime's
own drawing. World sprites live in that range.

| Layer | z | What it holds |
| --- | --- | --- |
| `$GroundLayer` | -400 | Screen fill, ground tiles, waving grass, build grid |
| `$WorldSpriteLayer` sprites | -380 … -320 | Converted world art (see below) |
| `$WorldSpriteLayer` own `_draw()` | -321 | Animal ground shadows |
| `main_runtime.gd` `_draw()` | 0 | Everything not yet converted, plus all HUD and menus |
| `$VisualLayer` | 0+ | Player, dealer, turrets, enemies (pre-existing nodes) |

Pooled sprites set `z_as_relative = false`, so their z values are absolute and a
change to a container's z cannot silently reorder the world.

## Files

- `scripts/world/sprite_pool.gd` — keyed, pooled `Sprite2D` manager. `begin()`,
  `put` / `put_region` / `put_transformed`, then `end()`. Sprites keyed the same
  way across frames are reused; untouched ones are hidden and recycled. This is
  what keeps each conversion short instead of hand-rolling node bookkeeping.
- `scripts/world/ground_layer.gd` — the backdrop. Holds the code that used to be
  `_draw_ground_area`, `_draw_waving_grass` and `_draw_grid`.
- `scripts/world/world_sprites.gd` — the converted world art.
- `scripts/tests/world_sprite_nodes_test.gd` — guards that world art really is
  nodes, that no world sprite can reach z >= 0 and cover the HUD, that the pool
  reuses nodes instead of growing, and that the menu retires them.

Both layers read the runtime's constants through
`get_script_constant_map()` rather than duplicating literals, so retuning the
grid or the art draw sizes in `main_runtime.gd` keeps the layers in step.

## Converted so far

| Art | Where it lives now | z |
| --- | --- | --- |
| Bob's house (all damage stages) | `_sync_house` | -380 |
| Trees, trunks, all three rock sizes | `_sync_resource_nodes` | -360 + grid row |
| Cave entrance | `_sync_cave_entrance` | -340 |
| Forest dog and beaver, with sway/bob/flip | `_sync_forest_animals` | -320 |
| Animal ground shadows | layer `_draw()` | -321 |

That is 10 of the original 68 `draw_texture` call sites. `main_runtime.gd` went
from 9,971 to about 9,850 lines.

Every converted function keeps its original no-texture fallback in
`main_runtime.gd`, guarded on the texture being null, so a missing asset still
degrades to the old procedural shapes rather than vanishing.

## Deliberate behaviour changes

Two things do not render exactly as before. Both were judgement calls, and both
should be looked at on screen before the next export.

1. **The build grid now draws under the house and dealer stand** instead of over
   them. The grid had to move down with the backdrop so trees could render on top
   of it. `HOUSE_BLOCK_CELLS` are skipped by the grid anyway, so the overlap is
   small, but it is a real change.
2. **The house damage overlay and repair wrench now draw above nearby trees.**
   They are procedural, so they stayed at z 0 while the house art moved to -380.
   The house sits at row 4 and trees start at row 8, so they should not actually
   overlap.

## Remaining work

58 `draw_texture` call sites are still immediate-mode. In rough order of value:

1. **Walls and structures** — `_draw_structures` (5 sites), `_draw_wall_visual`,
   `_draw_wall_repair_marker`. More entangled than the world art because the
   visuals key off hp, flash timers and build progress.
2. **Cave interior** — `_draw_cave_interior` is the single biggest cluster at 14
   sites, plus `_draw_cave_miner_shovel` and `_draw_cave_boss_hazards`.
3. **Build and dealer UI** — `_draw_sentry_preview_sprite` (11 sites),
   `_draw_dealer_menu`, `_draw_inventory_menu`. These are the menu/HUD rebuild
   the player also asked for, and want `Control` nodes rather than `Sprite2D`.
4. **Remaining enemy fallbacks** — `_draw_enemies` still has 6 sites used only
   when an enemy has no visual node.
5. **Odds and ends** — projectiles, house item display, energy drink status,
   countdown display, menu background, game-over background.

Note that `_draw_backyard_fence` (2 sites) has **no callers** and is dead code.
It was left in place rather than deleted.

## Testing

Run headless with Dummy audio, per `AGENTS.md`:

    .tools\godot-4.6.2\Godot_v4.6.2-stable_win64.exe --headless \
      --path <project> --audio-driver Dummy --log-file <log> \
      -s res://scripts/tests/world_sprite_nodes_test.gd

The 35-state visual capture baselines in `visual_state_matrix_test.gd`,
`ui_capture_test.gd` and `alternate_window_capture_test.gd` have **not** been
re-recorded against this change yet. They need a real renderer with the window
parked offscreen, and they should be re-recorded once the world art conversion
is finished rather than after every stage.
