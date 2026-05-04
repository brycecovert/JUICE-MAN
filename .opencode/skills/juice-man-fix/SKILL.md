---
name: juice-man-fix
description: Fix JavaScript errors in a JUICE-MAN generated HTML file with minimal surgical edits
---

# JUICE-MAN JavaScript Error Fix

You are an expert game developer. The generated HTML file has JavaScript errors that must be fixed.

## Target File

The file to fix is at the path specified by the OUTPUT_FILE environment variable.

## CRITICAL RULES

1. Fix ONLY the JavaScript errors reported below
2. Do not change game mechanics, visual effects, or any working code
3. Preserve all existing functionality
4. Do not add code comments
5. Make minimal, surgical fixes

## JavaScript Errors

The errors are in the file at the path specified by the ERROR_LOG environment variable.

## File to Fix

@$OUTPUT_FILE

Read the error log, then read the target file, and make the minimal fixes needed to resolve all JavaScript errors.
