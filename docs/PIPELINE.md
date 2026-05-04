# JUICE-MAN AI Generation Pipeline

This document describes the GitHub Actions pipeline that automatically generates JUICE-MAN versions from PR specs.

## Overview

When a contributor opens a PR with a spec file, the pipeline:

1. **Validates** the spec (word count ≤300, correct version path)
2. **Generates** a new HTML version by applying the spec to the previous version
3. **Commits** the generated file to the PR branch
4. **Comments** on the PR with a preview link
5. **Promotes** the winning version when merged

## Workflows

### `generate.yml` — PR Generation

**Trigger:** Pull request opened or synchronized against `main`

**What it does:**
- Finds the spec file in the PR (`specs/level_N/vN.md`)
- Validates word count ≤ 300
- Validates version matches `specs/level_N/next_version`
- Fetches the previous version from `main`
- Runs AI generation (configure opencode in the workflow)
- Saves generated HTML to `levels/level_N_vN.html`
- Commits to PR branch
- Updates `previews.json` manifest
- Comments on PR with preview link

**Required secrets:**
- `LLM_API_KEY` — API key for the LLM provider used by opencode
- `GITHUB_TOKEN` — Provided automatically, used for commits and comments

### `promote.yml` — Post-Merge Promotion

**Trigger:** Push to `main`

**What it does:**
- Detects if a versioned file (`levels/level_N_vN.html`) was merged
- Copies it to the canonical path (`levels/level_N.html`)
- Increments `specs/level_N/next_version`
- Appends author to `credits/level_N_credits.md`
- Commits changes to `main`

## File Structure

```
.github/workflows/
  generate.yml    # PR generation workflow
  promote.yml     # Post-merge promotion workflow
scripts/
  validate-spec.sh   # Local spec validation
  preview-url.sh     # Generate preview URLs
levels/
  level_1.html       # Canonical current version
  level_1_v1.html    # Generated version (in PR)
specs/
  level_1/
    v0.md            # Baseline spec
    v1.md            # PR spec
    next_version     # Counter for next expected version
previews.json        # Manifest of active previews
```

## Local Development

### Validate a spec locally

```bash
./scripts/validate-spec.sh specs/level_1/v1.md
```

### Generate preview URLs

```bash
./scripts/preview-url.sh levels/level_1_v1.html
```

## Configuring opencode

The generate workflow includes a placeholder step for opencode. To configure it:

1. Set the `LLM_API_KEY` secret in your repository settings
2. Update the "Generate new version with AI" step in `.github/workflows/generate.yml`
3. Install opencode in the workflow (e.g., `npm install -g opencode` or use a pre-built image)
4. Replace the placeholder `cp` command with the actual opencode invocation

Example opencode command:

```bash
opencode run \
  --dangerously-skip-permissions \
  -m anthropic/claude-sonnet-4 \
  -f /tmp/previous_version.html \
  -f ${{ steps.find_spec.outputs.spec_file }} \
  -f AGENTS.md \
  --title "Generate JUICE-MAN v${VERSION}" \
  "Apply the spec to the previous version HTML. Follow all conventions in AGENTS.md. Output a complete, valid HTML file that can replace the previous version."
```

The prompt should:
- Include the full `AGENTS.md` content
- Include the spec content
- Include the previous version HTML
- Instruct the model to follow all naming conventions, particle budgets, and state machine rules
- Request a complete, self-contained HTML file as output

## Preview URLs

PR previews are served via [HTMLPreview](https://htmlpreview.github.io/), which renders HTML from GitHub raw URLs. The workflow automatically generates these links in PR comments.

Alternative preview services:
- [GitHack](https://raw.githack.com/) — CDN-backed raw file serving
- [GitHub Pages](https://pages.github.com/) preview environments (requires additional setup)

## Troubleshooting

### "No spec file found in PR"
- Ensure the spec is at `specs/level_N/vN.md`
- Check that the PR is targeting `main`

### "Spec exceeds 300 words"
- Reduce spec length to ≤300 words
- Be concise — focus on the juice effects

### "Version mismatch"
- Check `specs/level_N/next_version` for the expected version number
- Ensure your spec targets the correct next version

### Generation fails
- Check that `LLM_API_KEY` is set in repository secrets
- Verify opencode is installed and configured in the workflow
- Check the Actions logs for error messages

## Security Notes

- The workflow uses `--dangerously-skip-permissions` with opencode to allow non-interactive execution
- Bot commits use a generic `juice-man-bot` identity
- The `GITHUB_TOKEN` has `contents: write` permission limited to the repository
- Preview URLs are public — do not include sensitive data in generated versions
