---
date: 2026-05-03
topic: pr-ai-generation-pipeline
---

# PR AI Generation Pipeline

## Problem Frame

Currently, when a contributor opens a PR with a spec for the next JUICE-MAN version, no automation exists. The AI generation step described in the README — "AI generates the next version automatically via GitHub Action" — is a manual promise. The workflow requires:

1. Copying the previous version's HTML file
2. Asking an AI (opencode) to apply the spec
3. Committing the generated artifact to the PR branch
4. Making the generated version playable from the PR for review
5. Promoting the winning version when a PR is merged

Without this pipeline, every version requires manual intervention, which breaks the "democratic, collaborative effort" model at scale.

---

## Actors

- A1. **Contributor**: Opens a PR with a spec file. Wants to see their vision generated and playable for voting.
- A2. **Voter / Player**: Visits PRs to preview generated versions. Needs a playable link without downloading artifacts.
- A3. **GitHub Action (generate)**: Triggered on PR open/push. Validates the spec, generates the HTML via opencode, commits to PR branch, deploys preview.
- A4. **GitHub Action (promote)**: Triggered on merge. Promotes the versioned file to canonical path, updates next_version, credits author.
- A5. **opencode (headless)**: Runs inside the generate action. Receives prompt with conventions + spec + previous HTML, produces modified HTML.

---

## Key Flows

- F1. **Spec PR opened**
  - **Trigger:** Contributor opens PR targeting `main`
  - **Actors:** A1, A3, A5
  - **Steps:**
    1. Generate action checks out the PR branch
    2. Validates spec file exists at expected path (e.g. `specs/level_1/v1.md`)
    3. Validates spec is ≤300 words and targets correct next version
    4. Fetches previous version HTML (from `levels/level_1.html` on main)
    5. Builds prompt: AGENTS.md conventions + spec + previous HTML
    6. Runs opencode headless with prompt to generate new version
    7. Saves generated HTML to versioned path (e.g. `levels/level_1_v1.html`)
    8. Commits generated HTML to PR branch via bot commit
    9. Deploys preview via GitHub Pages preview environment
    10. Comments PR with preview URL and summary
  - **Outcome:** PR has a playable preview URL. Generated HTML is visible in PR diff.
  - **Covered by:** R1, R2, R3, R4, R5, R6, R7, R8

- F2. **PR updated (new push)**
  - **Trigger:** Contributor pushes changes to PR branch
  - **Actors:** A1, A3, A5
  - **Steps:**
    1. Regenerate from scratch: copy previous version again, apply latest spec
    2. Overwrite versioned HTML with new generation
    3. Amend commit or create new commit
    4. Redeploy preview
    5. Update PR comment with new preview URL
  - **Outcome:** Preview always reflects latest spec.
  - **Covered by:** R6, R9

- F3. **Winning PR merged**
  - **Trigger:** Winning PR is merged into `main`
  - **Actors:** A3, A4
  - **Steps:**
    1. Promote action copies versioned HTML (e.g. `levels/level_1_v1.html`) to canonical path (`levels/level_1.html`)
    2. Updates `specs/level_1/next_version` (increment number)
    3. Appends author to `credits/level_1_credits.md`
    4. Commits changes to `main`
  - **Outcome:** Main branch has updated canonical version, incremented version counter, and updated credits.
  - **Covered by:** R10, R11, R12

---

## Requirements

**Spec validation**
- R1. The generate action must check that exactly one spec file exists in the PR at the expected path (`specs/level_N/vN.md`).
- R2. The generate action must verify the spec is ≤300 words. Fail the workflow with a clear error if exceeded.
- R3. The generate action must verify the version number in the filename matches `next_version` for that level. Reject PRs that skip ahead or reuse a version.

**AI generation**
- R4. The generate action must fetch the previous version's HTML from `main` (or `levels/level_N.html` for the canonical current version).
- R5. The prompt sent to opencode must include: the full AGENTS.md conventions, the spec content, and the previous version HTML.
- R6. The generated HTML must be saved to a versioned path: `levels/level_N_vN.html`.
- R7. The generate action must commit the generated HTML to the PR branch via a bot commit, using a descriptive commit message.
- R8. The generate action must run opencode in non-interactive/headless mode with `--dangerously-skip-permissions` to allow CI execution.

**Preview deployment**
- R9. The generate action must deploy the PR branch's content as a GitHub Pages preview environment, making the generated HTML playable from a URL.
- R10. The generate action must post or update a comment on the PR containing: the preview URL, a link to the generated HTML diff, and a brief status summary (success/failure).

**Manifest and discoverability**
- R11. The generate action must write or update a `previews.json` file (or similar manifest) that lists active previews with PR number, level, version, title, preview URL, and status.
- R12. The manifest file must be committed to the PR branch (or to a known location) so it can be consumed by the homepage or other tools.

**Post-merge promotion**
- R13. The promote action must copy the versioned HTML (`levels/level_N_vN.html`) to the canonical path (`levels/level_N.html`).
- R14. The promote action must increment `specs/level_N/next_version`.
- R15. The promote action must append the PR author to `credits/level_N_credits.md` with their contribution.
- R16. The promote action must commit these changes to `main` as a bot commit.

**Configuration**
- R17. The workflow must read the LLM API key from a GitHub secret (e.g. `LLM_API_KEY`) and pass it to opencode as an environment variable.

---

## Acceptance Examples

- AE1. **Covers R1, R2, R3.** Given a PR opened with `specs/level_1/v1.md` containing 250 words, when the generate action runs, it passes validation, generates `levels/level_1_v1.html`, commits it to the PR branch, and comments a preview URL.
- AE2. **Covers R2.** Given a PR with a spec of 350 words, when the generate action runs, it fails immediately with a clear error message in the PR checks and does not call the LLM.
- AE3. **Covers R3.** Given `specs/level_1/next_version` contains `2`, when a PR opens with `specs/level_1/v5.md`, the action fails with "version mismatch" and does not generate.
- AE4. **Covers R5.** Given a spec requesting "add neon particle trails", when opencode runs, the prompt includes AGENTS.md rules (e.g. `MAX_PARTICLES=1500`, `upd`/`draw` prefixes) and the resulting HTML follows these conventions.
- AE5. **Covers R13, R14, R15.** Given PR #42 for `level_1_v1.html` is merged, when the promote action runs, it copies `levels/level_1_v1.html` to `levels/level_1.html`, increments `next_version` to `2`, adds the author to credits, and commits to main.
- AE6. **Covers R9, R10.** Given a successful generation, when the preview deploys, a bot comments on the PR: "Play preview: https://brycecovert.github.io/JUICE-MAN/previews/42/levels/level_1_v1.html".

---

## Success Criteria

- Contributors can open a PR with only a spec file and receive a playable, AI-generated version within minutes.
- Reviewers can click a link in the PR to play the generated version without downloading anything.
- The generated code follows AGENTS.md conventions (verified by spot-checking a few PRs).
- Merging a winning PR automatically updates the canonical version, credits, and version counter without manual steps.
- The pipeline is robust: invalid specs fail fast with clear messages, and the LLM is never called for malformed PRs.

---

## Scope Boundaries

- Homepage changes to consume `previews.json` and display preview versions are **out of scope** — this pipeline only produces the manifest.
- Model selection and configuration (which provider/model opencode uses) is **out of scope** — this is configured via opencode's own config and the `LLM_API_KEY` secret.
- Voting / counting thumbs-up to determine the winner is **out of scope** — this pipeline assumes the merge decision is made externally.
- Cleanup of old preview deployments is **out of scope** — previews persist after PR close/merge.
- Re-generating previous versions (backfilling) is **out of scope** — only the current next version is generated.
- Handling spec changes that undo prior effects (allowed only if prior PR broke something) is **not validated by the pipeline** — the AI is expected to interpret the spec.

---

## Key Decisions

- **Versioned path for generated HTML:** `levels/level_N_vN.html` keeps the canonical `level_N.html` untouched on the PR branch. On merge, a separate action promotes the versioned file to the canonical path.
- **No cleanup of previews:** Old previews remain accessible. This is a deliberate tradeoff to avoid complexity; previews are cheap (static HTML).
- **opencode in headless mode:** Uses `opencode run` with `--dangerously-skip-permissions` for CI. This is the only practical way to run an interactive tool non-interactively.
- **Custom prompt with conventions:** The prompt explicitly includes AGENTS.md rules so the generated code follows project standards without relying on the model's in-context understanding.
- **GitHub Pages preview environment:** Provides native GitHub integration for per-PR deploys. Alternative (Netlify/Vercel) was rejected to avoid external dependencies.
- **Commit to PR branch:** The generated HTML is part of the PR diff, making review natural. When merged, the versioned file enters main.
- **Separate promote action on merge:** Keeps generation and promotion decoupled. Generation happens per-PR; promotion happens once per winning PR.

---

## Dependencies / Assumptions

- Assumes opencode CLI is available in the GitHub Actions runner or can be installed quickly (e.g. via npm/pip).
- Assumes the repository owner has configured a GitHub secret (`LLM_API_KEY`) with a valid API key for the LLM provider opencode is configured to use.
- Assumes GitHub Pages preview deployments are enabled for the repository (requires GitHub Actions-based Pages deploy with per-environment support).
- Assumes the previous version's HTML is always available at `levels/level_N.html` on the `main` branch.
- Assumes each PR targets exactly one level and one version.
- Assumes `specs/level_N/next_version` exists and contains a single integer.
- Verified: Repository has GitHub Pages enabled with `build_type: "workflow"` and source from `main` branch. Preview environment support requires additional workflow configuration.

---

## Outstanding Questions

### Resolve Before Planning

*(Empty — all blocking questions resolved.)*

### Deferred to Planning

- [Affects R5][Technical] Exact prompt engineering: how much of AGENTS.md to include, how to structure the prompt for opencode, and how to ensure the model outputs a complete HTML file.
- [Affects R8][Technical] opencode headless mode behavior in CI: does `opencode run` handle file writes correctly in a non-interactive context? Needs testing.
- [Affects R9][Technical] GitHub Pages preview environment URL format and configuration. Needs research on how to set up per-PR previews with `actions/deploy-pages`.
- [Affects R11][Technical] Where should `previews.json` live? In the PR branch, a separate `gh-pages` branch, or a known path on `main`? Each has tradeoffs for how `index.html` consumes it.
- [Affects R17][Technical] Which exact secret name and provider model? This is configured at the repo level, but planning should document the expected setup.

---

## Next Steps

-> `/ce-plan` for structured implementation planning (after resolving the one blocking question about GitHub Pages preview configuration).
