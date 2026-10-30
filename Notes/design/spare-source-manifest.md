# Spare production source manifest

Prepared 2026-10-05 from the player's supplied archive. Originals are retained unchanged.

- Archive: `C:/Users/miros/Downloads/drive-download-20261005T185129Z-1-001.zip`
- Archive SHA-256: `35B34302C8A26D39CB94813BACD4E3DF2F0D22F7BF1D07E3CCC77706689946B9`
- Extracted originals: `.tools/ad-ingest/spare-20261005/`
- Production footage: `assets/ads/spare/footage/`

## Footage

| Original filename | Production asset | Source duration | Content / edit use |
|---|---|---:|---|
| `20261005_212308.mp4` | `wallet.ogv` | 5.57 s | Hand opens patterned wallet/pouch; opening insert. Starts with motion blur, so favour the later opening/hold section. |
| `20261005_212327.mp4` | `screen.ogv` | 5.85 s | Main monitor has four tracking crosses; wider desk/laptop visible. Suitable for short screen insert. Handheld movement requires tracking if replacing the monitor surface. |
| `20261005_212344.mp4` | `reach.ogv` | 2.49 s | Hand reaches toward wallet/pouch and withdraws; Spending Protection insert. |
| `20261005_212356.mp4` | `headphones.ogv` | 4.16 s | Hand handles white headphones; supplied alternative to the planned mug. Treat as another prevented purchase, not as a drinking action. |
| `20261005_212412.mp4` | `empty.ogv` | 2.17 s | Empty wallet/pouch detail. Original rotation metadata incorrectly produces a portrait frame; output restores its landscape composition. |
| `20261005_213210.mp4` | `typing.ogv` | 5.80 s | Hand types on white keyboard; setup/action insert. |

Full source durations are preserved in the production files so the edit can choose clean moments. These are short inserts; do not stretch the 2-second reach/empty clips to fill a long narration beat. Freeze or transition into an animated app screen if a longer beat is needed.

Every production file is silent Ogg Theora, 1280 x 720, 30 FPS, square pixels, quality 8, yuv420p. Camera rotation is baked into pixels and source metadata removed. Ordinary source footage uses a 180-degree correction. The empty-wallet source ignores its misleading 90-degree metadata and receives the same 180-degree correction after visual inspection. No AI artwork, extra markers, personal face footage, or colour replacement is added.

## Excluded from the edit, retained in the source folder

- `20261005_212308(1).mp4`: exact SHA-256 duplicate of `20261005_212308.mp4`.
- `20261005_212327(1).mp4`: exact SHA-256 duplicate of `20261005_212327.mp4`.
- `20261005_213255.mp4`: accidental 1.77-second floor shot.

## Original footage SHA-256

| Filename | SHA-256 |
|---|---|
| `20261005_212308.mp4` | `EB140E0CBC7640CF86E6E543642B47818531170231D73D8BEBE1D9EEF1D5C39F` |
| `20261005_212327.mp4` | `80CC6735750CA45B777E583A541227AC9531B5E21C0A14CA2113AF1793F7700F` |
| `20261005_212344.mp4` | `6ADB8E9B3BDD0681FF2D1D8BB7D39CD74BF01E147BFB026B93B6BC18AC7BEF9C` |
| `20261005_212356.mp4` | `0239371ECF88DA9ACB8892E587CB39736EDC80FB71C19003A635A53C98994C5C` |
| `20261005_212412.mp4` | `163ADE8745F45F8B8F8E5CDE43CD492921F5A0C53D71A9D36B1A9B77AD785E21` |
| `20261005_213210.mp4` | `239DF0626E17CC9C88FDE4D8788E94166035ED3B964A223E94430C4705E549A8` |

## Narration source inventory

The same source folder contains `Spare 1.m4a` through `Spare 7.m4a`, `Spare  08.m4a` (two spaces before 08), `Spare 9.m4a`, and `Customer 1.m4a` through `Customer 3.m4a`. Audio production is handled separately. Filenames alone do not verify the spoken wording.

Local Python module discovery found no installed `faster_whisper`, `whisper`, or `torch`; no speech model was installed and no media was uploaded by this footage preparation pass.
