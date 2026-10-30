# Worldwide leaderboard and replay implementation plan

Goal: deliver a public top-100 leaderboard and complete, in-game best-run replays, with a separately protected moderator dashboard.

Constraints: preserve the dirty tree and team art; do not commit or push the game repository; all Godot tests hidden/headless with Dummy audio; do not replace the standalone until candidate and release checks pass. Dev PIN remains 5543; the moderator code is a separate server-side secret, never embedded in the game.

1. Replay foundation: record versioned timing, inputs, wave boundaries, random state and relevant snapshots; verify save/load, truncated input handling and wave seeking. Separate gameplay randomness from cosmetic randomness or record sufficient authoritative state to prevent divergence. Validate full runs, menu interactions, cave, death and revive, audio and different frame rates. Do not label an incomplete recording a playable replay.
2. Service: public Sites Worker with D1 scores and reports and R2 replay objects; installation-specific secrets; server receipt time for ties; bounded resumable uploads, retry and atomic best-score/replay association. Server-only moderator secret, throttling, and server-side authorization. Test validation, duplicate names, score ties, authorization, upload failures and delete/recreate behavior. Verify actual Sites quotas and public game API access.
3. Game integration: nickname prompt and recording notice after first game, queued offline submission, dev-run exclusion and revive support; menu/game-over leaderboard, search and rank celebration; player deletion and moderator review tools. Test mouse/controller access and preservation of existing game states.
4. Verify real replay playback against original recorded state through multiple waves, upload interruption, restart and version incompatibility; test two independent clients against the live service; inspect hidden visual captures. Export separately and silently launch the exact candidate before promoting it.

Open engineering risks: variable frame times, shared random number generation, immediate UI input, external ad flow, checkpoint seek fidelity, serverless replay verification cost, and unverified Sites quotas. Flag questionable scores rather than claiming replay checks prove legitimacy. An older replay shown during an upload must be explicitly labeled as previous.
