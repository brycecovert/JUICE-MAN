---
date: 2026-05-02
topic: juice-man-water-theme
---

# JUICE-MAN: WATER THEME

## Problem Frame

Create a water-themed alternative version of JUICE-MAN that replaces the arcade aesthetic with an ocean environment while preserving the core gameplay mechanics. The goal is maximum visual juice — every pixel should feel alive, reactive, and intense.

---

## Requirements

**Ocean Environment**
- R1. Deep blue gradient background with animated caustic light rays filtering from above
- R2. Subtle floating particles throughout the background simulating plankton and marine snow
- R3. Maze walls rendered as interconnected wavy blue lines with constant turbulent animation
- R4. Wall turbulence uses multiple overlapping sine waves at different frequencies for organic churning motion

**Surfer Character**
- R5. Pac-Man replaced by a surfer character riding a visible surfboard
- R6. Surfer leaves a foamy white wake trail of particles behind that ripples and fades
- R7. Water displacement ripples emanate from the surfer's position as concentric expanding rings
- R8. Wake intensity scales with movement speed and direction changes

**Shark Ghosts**
- R9. Ghosts replaced by sharks that swim below the surface, showing only fin silhouettes normally
- R10. Sharks breach with full body visible and splashing when in chase/attack mode
- R11. Each shark maintains unique color/species identity from original ghost colors
- R12. Shark fin cuts through water with realistic displacement effects

**Clam Shell Pellets**
- R13. Pellets replaced by clam shells with continuous open/close animation loop
- R14. Shell collection triggers pop-open animation with pearl particle release
- R15. Pearl flies upward with sparkle trail and fades
- R16. Collection creates small water burst fountain effect with falling droplets

**Bioluminescent Power-Up**
- R17. Power pellets replaced by glowing bioluminescent orbs
- R18. Collection triggers blinding bioluminescent flash that illuminates entire maze
- R19. Sharks become translucent and flee during power-up duration
- R20. Eating sharks creates bubble explosion effects with expanding rings
- R21. Surfer gains glowing aura during power-up state

**Screen Effects**
- R22. Major events trigger tsunami screen shake with fluid underwater motion
- R23. Water warp ripple effect expands outward from event location
- R24. Chromatic aberration (RGB split) on bioluminescent flashes
- R25. Rising bubble particles fill screen on major events, popping at top
- R26. All screen effects layer and compound for maximum intensity

---

## Success Criteria

- Player immediately recognizes the ocean theme within 3 seconds of viewing
- Every action (move, collect, chase, eat) produces visible feedback
- Screen feels alive and reactive even during idle moments
- Core gameplay remains clear and playable through the visual intensity
- Effects layer naturally without visual clutter or performance degradation

---

## Scope Boundaries

- Core gameplay mechanics remain identical to v0 (same maze, same rules, same controls)
- No new game modes, power-ups, or mechanics beyond visual replacements
- No audio — visual effects only
- Performance target: 60fps on modern devices, graceful degradation on older hardware

---

## Key Decisions

- **Maximum juice intensity**: Every pixel should be doing something, effects layer and compound
- **Surfer with wake trail**: Visible board and character, water displacement ripples, foamy wake
- **Shark hybrid behavior**: Fin normally, full body when attacking for tension and threat
- **Turbulent walls**: Constant churning with multiple overlapping sine waves for organic motion
- **Bioluminescent power-up**: Flash illumination, translucent fleeing sharks, bubble explosions
- **Tsunami screen effects**: Shake + warp + bubbles + aberration layered on major events

---

## Next Steps

-> `/ce-plan` for structured implementation planning
