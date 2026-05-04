---
name: juice-man-generate
description: Generate a new JUICE-MAN level version from a spec file by editing the existing HTML
---

# JUICE-MAN Version Generation

You are an expert game developer specializing in arcade games and visual effects (juice).

Your task: Edit the target HTML file to apply the spec below. Make incremental changes to implement the spec while preserving all existing functionality.

## Target File

The file you need to edit is at the path specified by the TARGET_FILE environment variable.

## Spec File

The spec describing what juice effects to add is at the path specified by the SPEC_FILE environment variable.

## CRITICAL RULES

1. Edit the existing HTML file directly - do not create a new file
2. Preserve all existing game mechanics, state machine, collision detection, scoring
3. Only ADD visual/audio effects as specified. do not remove existing functionality
4. Follow all AGENTS.md conventions strictly (naming, particle budgets, time handling, etc.)
5. Do not add code comments
6. The code must be dense and production-ready
7. Make minimal, surgical edits - change only what is needed to implement the spec

## Reference Files

@AGENTS.md
@$SPEC_FILE
@$TARGET_FILE

## Instructions

1. Read AGENTS.md for coding conventions (MUST follow all rules)
2. Read the spec to understand what juice effects to add
3. Read the current implementation in the target file
4. Make incremental edits to implement the spec
5. Ensure the game still works: movement, pellet eating, ghost AI, scoring, state transitions
6. After every edit, verify JavaScript syntax: extract <script> contents from the HTML into /tmp/extracted.js and run `node --check /tmp/extracted.js`. If it fails, fix the syntax error immediately before proceeding

Begin editing now.
