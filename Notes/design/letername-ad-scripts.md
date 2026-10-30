# Letername Technologies — ad voiceover scripts

> The EVIL CUT table below is archived. The produced evil cut is the live-action
> Scan & Surrender concept in `letername-scan-and-surrender.md`. The older
> ClearHome timing draft remains in `letername-evil-30s.md`. Keep this file for
> the recording setup and the unresolved good-cut direction.

Two 30-second in-game commercials for the ad-gated revive. Same shot list, same music,
same timing. Only the voiceover and on-screen text differ: the "good" cut is the polished
lie, the "evil" cut is the honest version of that identical ad.

Genre note: play it completely straight. This is a real commercial read — warm, unhurried,
confident, slightly too intimate. Never wink. Never do a villain voice. The entire joke is
that the delivery does not change when the content becomes horrifying.

## Recording

- One file per line, named exactly as the ID below (e.g. `evil_04.wav`).
- 48 kHz, mono, 16-bit WAV. Convert to `.ogg` on import; keep the WAVs.
- Leave ~1 second of silence at the head and tail of every take. Do not trim tight.
- Record the whole ad top to bottom in one sitting so the tone matches across lines,
  even though you are saving them separately.
- Do a second pass of every line about 10% slower. Commercial reads are slower than
  they feel in the booth, and it is much easier to tighten a slow take than to stretch a fast one.
- Stay the same distance from the mic on every line — the cut will expose any change.
- The target durations below are guidance for pacing, not marks to hit. The ad player
  sequences these files and drives the visuals from playback position, so your read
  sets the timing.
- Files go in `assets/ads/`, matching the existing `assets/intro/` convention.

---

## EVIL CUT — "The Honest Cut"

| ID | Line | Direction | ~Target |
|----|------|-----------|---------|
| `evil_01` | Letername Technologies. | Neutral, clean. A logo sting, nothing more. | 1.5s |
| `evil_02` | You've worked hard. You've built something. A home. A family. A mug that says you're the best dad. | Warm. Genuine affection. Sell it completely. | 7s |
| `evil_03` | And we've noticed. | Same warmth. Do not add menace. The line does the work. | 1.5s |
| `evil_04` | At Letername, we believe every family deserves a partner who understands their finances completely. Every account. Every drawer. Every jar above the fridge. | Corporate-sincere. The three "every"s get gentler, not harder. | 8s |
| `evil_05` | Other firms will ask for a percentage. A reasonable share. A fair contribution. | Faint disapproval, as if describing a competitor's weak coverage. | 5s |
| `evil_06` | We find that insulting. | Flat. Sincere. The first honest thing in the ad. | 1.5s |
| `evil_07` | Letername Technologies offers total financial clarity. We take everything — and then there is nothing left to worry about. That's peace of mind. | Fully back into warm ad-voice. Land "peace of mind" like a real tagline. | 8s |
| `evil_08` | Bob switched to Letername. Bob no longer files taxes. Bob no longer files anything. | Testimonial cadence. Proud of him. | 5s |
| `evil_09` | Letername Technologies. We don't want some of your money. We want all of it. | The motto. Calm, generous, almost kind. Never triumphant. | 5s |

## GOOD CUT — "Peace of Mind"

| ID | Line | Direction | ~Target |
|----|------|-----------|---------|
| `good_01` | Letername Technologies. | Identical read to `evil_01` if you can manage it. | 1.5s |
| `good_02` | You've worked hard. You've built something. And it deserves protecting. | Warm, same as the evil cut. | 5s |
| `good_03` | Your savings should work as hard as you do. | Reassuring. | 3s |
| `good_04` | At Letername, we believe every family deserves a partner who understands their finances. That's why we're here — for the paperwork, the deadlines, and the deep breath afterward. | The sincere version of `evil_04`. Same warmth, no creep. | 9s |
| `good_05` | When the season comes, you won't face it alone. | Quietly confident. | 3s |
| `good_06` | We restore what matters. | Simple. Let it sit. | 2s |
| `good_07` | Bob switched to Letername. Bob sleeps fine. | Same testimonial cadence as `evil_08`. | 4s |
| `good_08` | Letername Technologies. We're on your side of the table. | Tagline read. | 4s |

---

## Shot list (identical for both cuts)

All art already exists in `Art/`. Nothing new needs drawing.

| Beat | Visual | Evil overlay | Good overlay |
|------|--------|--------------|--------------|
| Sting | Wordmark on black | — | — |
| Wholesome | `Family photo.png`, `Best dad mug.png`, soft light, slow push-in | small print: MUG NOT INCLUDED. MUG IS OURS. | — |
| Coins | `Couch with coins.png`, camera lingers | — | — |
| Promise | `Bob n stuff.png` before `Bob's house.png`, golden hour | — | — |
| **Reveal (skip unlocks here)** | `IRS ROBOT 1.png` steps in beside Bob. Bob does not react. Lighting does not change. | — | framed as an agent arriving to help |
| Escalation | House dissolve chain | `Bob's house` → `broken 1` → `broken 2` | reversed: `broken 2` → `broken 1` → `Bob's house` |
| Testimonial | Caption: BOB R. — SATISFIED CLIENT | `Bob with no stuff.png`, bare floor, still smiling | `Bob n stuff.png` |
| Tagline | Wordmark, everything else black | WE DON'T WANT SOME OF YOUR MONEY. WE WANT ALL OF IT. | WE'RE ON YOUR SIDE OF THE TABLE. |

The skip button unlocks at 15 seconds, which must land on the reveal beat — the robot
stepping into frame is the hook that keeps a player watching the second half.

## Small print (on-screen only, never voiced)

Rendered with `draw_string`, tiny, low contrast, held just long enough to read if you
are looking for it. Evil cut only.

- MUG NOT INCLUDED. MUG IS OURS.
- "NOTHING LEFT TO WORRY ABOUT" IS A LEGAL DESCRIPTION OF YOUR SITUATION, NOT A FEELING.
- LETERNAME TECHNOLOGIES IS NOT AVAILABLE IN ANY STATE. LETERNAME TECHNOLOGIES IS ALREADY IN YOUR STATE.

## Audio routing

- The ad plays under `get_tree().paused`, so its players must have
  `process_mode = PROCESS_MODE_ALWAYS` or the voiceover will freeze with the game.
- Give the ad its own audio bus rather than reusing the menu music bus, so ad volume
  respects the existing settings without fighting the menu/gameplay playlist state.
- Duck or pause the gameplay playlist for the duration and resume at position afterward,
  the same way the cave music already does.
