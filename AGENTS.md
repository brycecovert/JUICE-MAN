# JUICE-MAN — Agent Instructions

## Project

Single-file Pac-Man variant (`juice_man.html`). Canvas-based, no dependencies. Forked from brycecovert/JUICE-MAN v0 (clean baseline with no visual effects). All juice must be additive on top of v0.

## Competitive Format

JUICE-MAN is a democratic, collaborative competition to create the juiciest Pac-Man that ever existed. Each week, a new "JUICE-MAN" is elected via poll of open PRs.

**Start date:** May 10, 2026
**End date:** When no further submissions are made

### PR Rules

1. **Make it juicer** — Every PR must make JUICE-MAN more visually intense than before.
2. **Single prompt** — Each PR comes from a single prompt (max 300 tokens) applied to the current `juice_man.html`.
3. **Additive only** — Build on prior work. No rewrites, no removals.
4. **Single file** — Everything lives in `juice_man.html`. No dependencies.
5. **No mechanic changes** — The game has to play as if the same inputs would result in the same output.
6. **Spirit of the law** — The rules are easy to game. But that won't be fun.

## Core Rule: Additive Juice Only

Every change must be **additive** to existing code. Never remove, simplify, or refactor away existing effects. The goal is to stack more juice on top of what's already there, making the game increasingly over-the-top.

Think of it as layering: each iteration adds a new visual, audio, or feedback layer without touching what came before.

## What Counts as "Juice"

Juice is any effect that makes the game feel more intense, reactive, or alive. Categories include:

- **Screen effects**: shake, rumble, flash, vignette, scanlines, chromatic aberration, zoom pulses, screen warp, pixel sorting, color inversion bursts
- **Particles**: bursts, trails, rings, fountains, explosions, sparks, embers, confetti, pixel debris, liquid splashes
- **Lighting**: glow, bloom, lens flares, light rays, fireflies, neon pulses, dynamic spotlights
- **Weather**: meteors, lightning, rain, snow, electric arcs, plasma storms, aurora, solar flares
- **Physics**: shockwaves, ripple effects, bounce, squash-and-stretch, wobble, jelly deformation
- **Typography**: floating text, score popups, combo announcements, screen-filling text slams, glitch text
- **Audio feedback**: (if added) hit sounds, power-ups, explosions, ambient drones
- **Timing**: slow-mo on big events, speed ramps, freeze frames, elastic transitions

## Existing Juice Inventory (Do Not Remove)

v0 is a clean baseline with no visual effects. Any juice added on top must be tracked here and never removed by subsequent PRs.

| Layer | Effects |
|-------|---------|
| — | *(none yet — v0 is the starting point)* |


## Code Conventions

- **Single file**: Everything lives in `juice_man.html`. No external files or dependencies.
- **Naming**: Effect state arrays use plural nouns (`meteorParts`, `glitchBlocks`). Update functions prefixed `upd`, draw functions prefixed `draw`.
- **Particle budget**: Respect `MAX_PARTICLES=1500` for the main `parts[]` array. New persistent effect arrays should have their own reasonable caps.
- **Time**: Use `dt` (delta time in seconds) for all updates. Use `globalTime` for oscillating effects.
- **Canvas coords**: Maze uses grid coords (gx, gy), screen uses pixel coords. Convert with `tx(c)` and `ty(r)`.
- **Colors**: Use hex for constants, `hsla()` for dynamic effects. Rainbow palette in `RAINBOW` array.
- **No comments**: Do not add code comments. The code is dense by design.
- **State machine**: Game states are `title`, `playing`, `paused`, `lifeLost`, `levelComplete`, `gameOver`. New effects should check `state` where relevant.
- **Integration points**:
  - New update logic goes in `update()` at line ~657
  - New draw logic goes in `draw()` at line ~666, ordered back-to-front
  - New init logic goes in `resize()` at line ~69 or a dedicated init called from `resize()`
  - New state arrays declared near top with other arrays (line ~58-66)

## Anti-Goals

- Do not improve gameplay balance, difficulty curves, or ghost AI unless adding juice tied to those changes
- Do not refactor for "cleanliness" if it removes existing effects
- Do not optimize away visual effects for performance unless the game is unplayable
- Do not add new game mechanics (power-ups, levels, modes) unless they come with juice
- Do not touch input handling unless adding juice-reactive input feedback

## Quality Bar

Every added effect should pass the "noticeable at a glance" test: a player watching the screen should immediately see something new happening. If an effect is only visible when you know to look for it, it's not juice — it's decoration.
