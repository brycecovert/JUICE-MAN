---
title: Rebase agent-browser branch and refactor prompts to skills
type: refactor
status: active
date: 2026-05-04
---

# Rebase agent-browser branch and refactor prompts to skills

## Overview

Clean up the agent-browser testing feature branch by rebasing onto main, squashing commits, and then creating a follow-up PR that removes test artifacts and extracts inline prompts into reusable opencode skills.

---

## Problem Frame

The current `feature/agent-browser-testing` branch has accumulated merge commits and test artifacts (v1 spec, generated HTML, manifest updates) from testing the PR workflow. We need to:
1. Clean up the branch history by rebasing onto main and squashing
2. Remove test artifacts that shouldn't be in the final PR
3. Extract the two inline prompts (generation + fix) into skill files for better maintainability

---

## Scope Boundaries

- **In scope:** Rebase, squash, skill extraction, workflow simplification
- **Out of scope:** Changing the browser testing logic itself, adding new features
- **Deferred:** None

---

## Implementation Units

- U1. **Rebase and squash agent-browser branch**

**Goal:** Clean up branch history to a single commit on top of main

**Dependencies:** None

**Files:**
- Branch: `feature/agent-browser-testing`

**Approach:**
- Fetch latest main
- Interactive rebase onto main, squash all commits into one
- Force push to remote

**Verification:**
- Branch history shows single commit on top of main
- PR diff shows only intended changes (workflow + AGENTS.md + screenshots dir structure)

---

- U2. **Remove test artifacts from branch**

**Goal:** Clean up files that were generated during PR workflow testing

**Dependencies:** U1

**Files:**
- Delete: `specs/level_1/v1.md`
- Delete: `levels/level_1_v1.html`
- Delete: `specs/level_2/v0.md`
- Delete: `specs/level_2/next_version`
- Delete: `previews.json` (or reset to original)
- Keep: `screenshots/` directory structure with `.gitkeep` files

**Approach:**
- Remove v1 spec and generated artifacts
- Keep screenshots directory structure for future use
- Amend the squashed commit to exclude these files

**Verification:**
- `git diff main --stat` shows only workflow, AGENTS.md, and screenshots dirs

---

- U3. **Create juice-man-generate skill**

**Goal:** Extract generation prompt into reusable skill file

**Dependencies:** U1

**Files:**
- Create: `.opencode/skills/juice-man-generate/SKILL.md`

**Approach:**
- Create skill with frontmatter (name, description)
- Include the generation prompt template
- Use `$TARGET_FILE` and `$SPEC_FILE` as placeholders for shell substitution
- Include instructions for reading AGENTS.md and spec files

**Skill frontmatter:**
```yaml
---
name: juice-man-generate
description: Generate a new JUICE-MAN level version from a spec file
---
```

**Verification:**
- Skill file exists with proper frontmatter
- Prompt content matches current inline prompt

---

- U4. **Create juice-man-fix skill**

**Goal:** Extract error-fixing prompt into reusable skill file

**Dependencies:** U1

**Files:**
- Create: `.opencode/skills/juice-man-fix/SKILL.md`

**Approach:**
- Create skill with frontmatter (name, description)
- Include the fix prompt template
- Use `$OUTPUT_FILE` and `$ERROR_LOG` as placeholders
- Include instructions for minimal surgical fixes

**Skill frontmatter:**
```yaml
---
name: juice-man-fix
description: Fix JavaScript errors in a JUICE-MAN generated HTML file
---
```

**Verification:**
- Skill file exists with proper frontmatter
- Prompt content matches current inline prompt

---

- U5. **Update workflow to use skill files**

**Goal:** Replace inline prompts with skill file references

**Dependencies:** U3, U4

**Files:**
- Modify: `.github/workflows/generate.yml`

**Approach:**
- Replace inline `printf` prompt construction with `envsubst` or `sed` on skill files
- For generation step: `envsubst < .opencode/skills/juice-man-generate/SKILL.md | opencode run ...`
- For fix step: `envsubst < .opencode/skills/juice-man-fix/SKILL.md | opencode run ...`
- Export required variables before envsubst
- Keep the JS syntax verification step as-is (not a skill)

**Verification:**
- Workflow YAML syntax validates
- Skill files are referenced correctly
- Variable substitution works for dynamic values

---

- U6. **Create follow-up PR for cleanup**

**Goal:** Submit cleaned-up changes as a new PR

**Dependencies:** U2, U5

**Files:**
- New branch: `feature/cleanup-and-skills`

**Approach:**
- Create new branch from rebased feature branch
- Push to remote
- Open PR with description of cleanup changes

**Verification:**
- PR shows clean diff (skills + workflow updates + artifact removal)
- No test artifacts in diff

---

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| Force push rewrites history | Ensure team knows about the rebase |
| envsubst not available in ubuntu-latest | Use `sed` as fallback or install gettext-base |
| Skill invocation doesn't work as expected | Test locally first with `opencode run` |

---

## Key Technical Decisions

- **Use envsubst for variable substitution:** Standard tool for substituting shell variables in templates
- **Keep screenshots directory:** Even empty, it establishes the convention for future PRs
- **Two separate PRs:** First PR = squashed agent-browser feature, Second PR = cleanup + skills refactor

---

## Sources & References

- **Skill structure:** `~/.config/opencode/skills/ce-work/SKILL.md`
- **Current workflow:** `.github/workflows/generate.yml`
- **Skill docs:** https://opencode.ai/docs (for skill frontmatter format)
