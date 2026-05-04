# JUICE-MAN — Agent Instructions

## Project

JUICE-MAN is a collaborative, democratically-elected Pac-Man variant. Starting May 10, 2026, nightly builds are generated automatically from winning PR specs. The game is split into **levels**, each containing 10 versions. Each level lives in its own `.html` file. Completing a level redirects the player to the next level.

## Structure

- `levels/` — Contains per-level `.html` files (e.g., `level_1.html`, `level_2.html`, etc.)
- `specs/` — Contains version spec files organized by level (e.g., `specs/level_1/v0.md`, `specs/level_1/v1.md`, etc.)
- `credits/` — Auto-generated credits for each level

## Competitive Format

JUICE-MAN is a democratic competition to create the juiciest Pac-Man that ever existed. Each cycle, the PR with the most thumbs up that respects the rules wins and becomes the next version.

**Start date:** May 10, 2026
**End date:** When no further submissions are made

### PR Format

PRs must contain:

1. **A spec file** at `specs/level_n/v$(cat next_version).md` — describes the expected changes (max 300 words)
2. **No direct code changes** — the AI will generate the implementation from the spec

The spec is the specification for what the next version should contain. It should describe expected visual/audio changes, new effects, or themes. Anything from prior versions is assumed to continue unless explicitly stated.

### PR Rules

1. **Max 300 words** — The spec file must not exceed 300 words.
2. **Additive only** — Cannot undo anything from a previous PR unless that PR broke something.
3. **Must be SFW** — No explicit, offensive, or inappropriate content.
4. **Respect the theme** — Each level has a theme decided in the first round of PRs for that level.
5. **Spirit of the law** — The rules are easy to game. But that won't be fun.

## Level System

- Each level has **10 versions** (v0–v9).
- Each level starts with **v0** as a base (clean Pac-Man baseline).
- The **theme** for a level is decided in the first round of PRs for that level.
- When a player completes a level, they are redirected to the next level.
- All authors for a level are automatically added to `credits/level_N_credits.md`.

### Theme Voting

When a new level opens, the first round of PRs are theme proposals. The winning theme sets the creative direction for that level's 10 versions.

## AI Generation

When a PR is opened, a GitHub Action triggers AI to:

1. Read the spec at `specs/level_n/v$(next_version).md`
2. Generate the next version of JUICE-MAN based on that spec, building on the prior version
3. Submit the generated code as a commit to the PR or main branch

## Voting

PRs are voted on by **thumbs up** on the PR itself. The PR with the most thumbs up that respects the rules wins. If there is no clear winner, AI will generate its own idea and pick one.

## Code Conventions

- **Naming**: Effect state arrays use plural nouns (`meteorParts`, `glitchBlocks`). Update functions prefixed `upd`, draw functions prefixed `draw`.
- **Particle budget**: Respect `MAX_PARTICLES=1500` for the main `parts[]` array. New persistent effect arrays should have their own reasonable caps.
- **Time**: Use `dt` (delta time in seconds) for all updates. Use `globalTime` for oscillating effects.
- **Canvas coords**: Maze uses grid coords (gx, gy), screen uses pixel coords. Convert with `tx(c)` and `ty(r)`.
- **Colors**: Use hex for constants, `hsla()` for dynamic effects. Rainbow palette in `RAINBOW` array.
- **No comments**: Do not add code comments. The code is dense by design.
- **State machine**: Game states are `title`, `playing`, `paused`, `lifeLost`, `levelComplete`, `gameOver`. New effects should check `state` where relevant.

## Anti-Goals

- Do not improve gameplay balance, difficulty curves, or ghost AI unless adding juice tied to those changes
- Do not refactor for "cleanliness" if it removes existing effects
- Do not optimize away visual effects for performance unless the game is unplayable
- Do not add new game mechanics (power-ups, levels, modes) unless they come with juice
- Do not touch input handling unless adding juice-reactive input feedback

## Quality Bar

Every added effect should pass the "noticeable at a glance" test: a player watching the screen should immediately see something new happening. If an effect is only visible when you know to look for it, it's not juice — it's decoration.

## Browser Validation

After generating code, the AI agent must validate the HTML file using agent-browser:

1. Open the generated HTML file in agent-browser (`agent-browser --allow-file-access open file://...`)
2. Wait 1 second for the page to fully load
3. Press the Space key to start the game
4. Wait 1 second for the game to react
5. Take a screenshot of the running game
6. Check for JavaScript errors using `agent-browser errors`
7. If any JavaScript errors are found, fix them with minimal surgical edits
8. Re-test until no errors remain

The screenshot and error report are automatically attached to the PR. Any JavaScript errors must be resolved before the PR is considered complete.

## Credits

All authors who contribute to a level are automatically added to `credits/level_N_credits.md`. Format is managed by the `add_author` workflow.
