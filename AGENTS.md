# JUICE-MAN — Agent Instructions

## Project

Single-file Pac-Man variant (`juice_man.html`). Canvas-based, no dependencies. Space-themed aesthetic with neon holographic walls, warp stars, planets, and aggressive particle effects.

## Competitive Format

JUICE-MAN is a democratic, collaborative competition to create the juiciest Pac-Man that ever existed. Each week, a new "Juice-Man" is elected via poll of open PRs.

**Start date:** May 10, 2026
**End date:** When no further submissions are made

### PR Rules

1. **Make it juicer** — Every PR must make JUICE-MAN more juicy than before.
2. **Single prompt** — Each PR must come from a single prompt applied to the current `juice_man.html`. The prompt is limited to 1,000 tokens.
3. **Build on prior work** — PRs must build on the current `juice_man.html`. Never a full rewrite.
4. **Single file** — `juice_man.html` is the only file. No external dependencies.

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

The game already has these effects — build on them, don't replace them:

| Layer | Effects |
|-------|---------|
| Background | Deep space gradient, warp stars (250, depth-layered), 4 planets with rings/features, space nebulae (6), shooting stars, engine particles |
| Maze | Holographic energy walls (multi-frequency noise pulsation, scan lines, spike bursts), spaceship floor grid, hull edge glow with corner accents, energy door with sparkle |
| Pellets | Energy cell pellets with glow/core, warp core power pellets with orbiting dots/rings, alien artifact fruit with rotating rings |
| Pac-Man | Rainbow trail (pmTrail + rainbowParts), mouth animation, eye, outer glow, inner highlight, death animation |
| Ghosts | Trail particles, body glow, inner highlight, animated wavy feet, scared face with zigzag mouth, eye tracking, spirit particles on eat |
| Particles | Main particle system (1500 max), burst/ringBurst/rainbowBurst helpers, spark type, gravity |
| FX overlays | Screen shake (shakeT/shakeI), white flash (flashT), shockwaves (multi-ring), lightning bolts, ambient fireworks, nebula clouds, wall energy flow, pixel rain, electric arcs (ghost-to-pacman proximity), floating text, score popups, edge glow (rainbow), CRT scanlines |
| Power mode | Blue screen tint, red warning vignette when expiring, HUD power bar with pulse |
| Overdrive | Red wash + vignette, scan bars, thick border flash, "OVERDRIVE" text with scale pulse, timer bar, continuous random flash/shake, red edge particles |
| Ambient | Auto-spawning lightning strikes and fireworks every 2-4 seconds |
| HUD | Score, high score, level, combo indicator, lives, power timer bar, neon separator line |
| Screens | Title (rainbow title glow, animated particles, pacman/ghost animation), game over (red vignette, high score stars), paused (scanlines), level complete (celebration particles) |
| Mobile | Touch swipe controls, pause tap, D-pad arrows |


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
  - New update logic goes in `update()` at line ~1758
  - New draw logic goes in `draw()` at line ~1770, ordered back-to-front
  - New init logic goes in `resize()` or a dedicated init called from `resize()`
  - New state arrays declared near top with other arrays (line ~61-96)

## Anti-Goals

- Do not improve gameplay balance, difficulty curves, or ghost AI unless adding juice tied to those changes
- Do not refactor for "cleanliness" if it removes existing effects
- Do not optimize away visual effects for performance unless the game is unplayable
- Do not add new game mechanics (power-ups, levels, modes) unless they come with juice
- Do not touch input handling unless adding juice-reactive input feedback

## Quality Bar

Every added effect should pass the "noticeable at a glance" test: a player watching the screen should immediately see something new happening. If an effect is only visible when you know to look for it, it's not juice — it's decoration.
