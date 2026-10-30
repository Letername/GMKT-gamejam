# Spare ad production

## Approved final direction

- New fictional Letername Technologies budgeting app, not a Scan & Surrender rebuild.
- Sixty seconds with every recorded line retained. After reviewing the first export, the player chose to use each filmed clip once and fill the gaps with varied app screens. No face footage.
- White, deep blue and mint branding; a jar with an outward arrow.
- Starting balance €67.69. Small transfers precede Smart Budget taking the remaining balance during the spoken motto.
- Calm narration, expressive customer questions, awkward pauses with continued transfers.
- Full separate subtitles; selected animated phrases in the picture.

## Sources and preservation

The supplied Downloads ZIP was extracted into `.tools/ad-ingest/spare-20261005`. Original recordings and footage were preserved. Production copies are under `assets/ads/spare/`.

The usable wallet, monitor, typing, reach, headphones and empty-wallet clips form the edit. Each of these six source recordings is used in exactly one continuous insert in the recut, with no looping or long frozen footage. Alternate monitor composites are not treated as new recordings. The accidental floor clip and exact duplicate clips were excluded. The monitor replacement is tracked onto the filmed screen.

All twelve recorded voice lines were conservatively trimmed and loudness-matched to approximately -18 LUFS with peaks no higher than -2 dBTP. Processing and transcription were local. The quiet music bed, notification chimes and voices are mixed into a sixty-second master.

Music provenance and license: `assets/ads/spare/MUSIC-LICENSE.md`. Delivery attribution: `Build/media/Spare-Credits.md`.

## Integration

`AdService` now launches `scenes/ads/spare_ad.tscn` through the existing creative ID, preserving the game's revive workflow. Playback follows recorded audio position; silent target durations remain available when a line is missing. The player uses its own audio bus, true gameplay pause, the fifteen-second skip gate, forfeiture confirmation and developer skip.

The first Scan & Surrender scene remains available. Its real family-photo footage now uses a strongly blurred derivative, not an overwritten original.

## Deliverables

- `Build/media/Spare-Letername-Ad-Recut.mp4` — current revision, six single-use footage inserts plus varied banking screens.
- `Build/media/Spare-Letername-Ad.mp4`
- `Build/media/Spare.srt`
- `Build/media/Spare-Credits.md`
- `Build/media/Letername-Scan-and-Surrender.mp4`

Both MP4s use 1280×720 at 30 fps with H.264 video and AAC audio. The first ad is about 43.23 seconds; Spare is 60 seconds.

The original Spare export is preserved for comparison. `Spare.srt`, the voice/music/chime master, the sixty-second edit timing and the first Scan & Surrender MP4 are unchanged by the recut.

## Recut shot plan

| Original recording | Insert | Followed by |
|---|---|---|
| Wallet | Opening, approximately 0–5.53 s | Monitor demonstration |
| Monitor | Approximately 5.53–11.03 s | Question/support screen, then company growth chart |
| Reach | Approximately 17.69–20.09 s | Headphones |
| Headphones | Approximately 20.09–24.19 s | Lunch prevention screens |
| Typing | Approximately 30.18–35.68 s | Three-category Smart Budget allocation screen |
| Empty wallet | Approximately 38.94–41.04 s | Budget-review benefits, simplified dashboard, brand card and final balance transfer |

The player derives these windows from the audio-driven beat clock. The smoke test guards source uniqueness, insert lengths within the source duration, and app-screen routing at former repeat points.

## Checks

- `SPARE_AD_SMOKE_PASS`: twelve voices, timeline, balance conservation, zero balance during the recorded motto, pause restoration, skip/confirm/decline and developer reward.
- `REWARDED_AD_SMOKE_PASS`: existing game revive regression coverage.
- `SPARE_MOVIE_PASS`: complete hidden renderer export with Dummy audio.
- First-ad MP4 decoded without errors and its family-photo frame was independently inspected as unreadable.
- Final Spare MP4 fully decoded without errors. Packaged frames at 1, 8, 20, 36, 55, 56.7 and 59 seconds were inspected: footage and monitor composite are visible, the final balance is €0 during the motto, the end card is intact, and export controls are absent.
- Final Spare MP4 SHA-256: `460EF0C01036A256E317ABD7C1A884168C199B90C1957D6939DD3BD22C91D1BD`.
- Recut: `SPARE_AD_SMOKE_PASS`, `REWARDED_AD_SMOKE_PASS`, `SPARE_CAPTURE_MATRIX_PASS count=13`, and `SPARE_MOVIE_PASS`. An independent source audit confirmed all six original recordings are single-use, totaling 25.1294375 seconds.
- Recut MP4 fully decoded without errors: 60.00 seconds, 1280×720, 30 fps, H.264 and stereo 48 kHz AAC. Extracted frames across all six inserts, the allocation/budget screens and the zero-balance/end-card finish were inspected. No agent-started Godot/game processes remained.
- The encoded audio payload hashes match the prior Spare MP4 exactly: `75c2bcd581b5ebf1b7193503e23278d4c77b9c911af3b8c57b1846fb0edcda0f`. No recorded lines, music or dialogue timing were changed.
- Recut MP4 SHA-256: `E02E7B3D5A816756C9FAF1823B70D1DA9E451772BB2D0E6D17A082CA2D2680CB`.

No executable was rebuilt during this media-delivery pass. No commit or push was made.
