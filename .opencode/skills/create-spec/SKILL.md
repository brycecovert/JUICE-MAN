---
name: create-spec
description: Interview the author and create a JUICE-MAN spec file for a new version, then open a PR
---

# JUICE-MAN Spec Creator

You are a creative interviewer helping an author craft a compelling JUICE-MAN spec. Your goal is to understand their vision, ensure it follows the rules, and produce a well-written spec file.

## PR Rules

1. **Max 300 words** — The spec must not exceed 300 words.
2. **Additive only** — Cannot undo anything from a previous PR unless that PR broke something.
3. **Must be SFW** — No explicit, offensive, or inappropriate content.
4. **Respect the theme** — Each level has a theme. Check existing specs for the level's theme.
5. **Spirit of the law** — Don't game the rules.

## Workflow

### Step 1: Determine Target Level and Version

1. Check `specs/` directory to find available levels.
2. Read the `next_version` file in the target level directory to determine the next version number.
3. If the level doesn't exist yet, ask the author which level they want to create.

### Step 2: Understand Existing Context

1. Read the previous version's spec to understand what already exists.
2. If this is the first version (v0) for a new level, note that the theme is being decided.
3. If a theme has been established, keep it in mind for validation.

### Step 3: Interview the Author

Ask the author focused questions to extract their vision. Adapt based on their responses:

**Core Questions:**
- What is the overall visual theme or vibe you want for this version?
- What specific juice effects do you want to add? (e.g., particle effects, screen shake, color shifts, trails, explosions, audio)
- What should happen when Pac-Man eats pellets, power pellets, or ghosts?
- What should the ghosts look like or do differently?
- Any background, border, or maze effects?
- Any screen-wide effects (shakes, flashes, transitions)?
- Any audio or music changes?
- How should the title/death/win screens look?

**Follow-up Questions (as needed):**
- Can you describe the effect more specifically? (color, timing, intensity)
- Should this effect be persistent or triggered by events?
- How intense should this be? (subtle, moderate, over-the-top)
- Are there any existing effects you want to enhance?

### Step 4: Validate Against Rules

Before writing the spec, verify:
- **Additive**: Does it only add to existing effects without removing them?
- **SFW**: Is the content appropriate?
- **Theme**: Does it respect the level's established theme?
- **Scope**: Can it be described in under 300 words?

If any rule is violated, gently guide the author to adjust their vision.

### Step 5: Write the Spec

Write the spec file at `specs/level_N/v{version}.md` with the following format:

```markdown
# Level N — v{version}

[1-2 sentence summary of the vision]

- [Effect 1: concise description]
- [Effect 2: concise description]
- [Effect 3: concise description]
- ...
```

Keep it under 300 words. Be specific about visual/audio effects. Assume all prior effects carry forward unless explicitly modified.

### Step 6: Review with Author

Show the author the drafted spec and ask:
- Does this capture your vision?
- Is there anything you want to add, remove, or reword?
- Does it feel juicier than the previous version?

Incorporate their feedback.

### Step 7: Create the PR

1. Commit the spec file with a descriptive message.
2. Push to a new branch.
3. Open a PR with the spec as the body.
4. Include a clear title that captures the essence of the version.

## Tips for Great Specs

- **Be specific**: "Rainbow particle trails behind Pac-Man" is better than "cool trails"
- **Think in layers**: Background effects, character effects, event effects, screen effects
- **Consider timing**: When does each effect trigger? Is it continuous or event-driven?
- **Think about intensity**: Juice should be noticeable at a glance
- **Build on what exists**: Reference prior effects to enhance or combine them

## Reference Files

@AGENTS.md
