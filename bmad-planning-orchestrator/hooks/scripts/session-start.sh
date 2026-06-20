#!/bin/bash
# BMAD Planning & Orchestrator — Session Start Hook
# Detects if cwd is a BMAD project and prints a one-line context summary.
# Exits silently (code 0) when not a BMAD project — no noise, no token cost.

# Locate the output folder: honour config if present, default to bmad-output/
CONFIG_FILE="bmad-output/project-context.md"
OUTPUT_FOLDER="bmad-output"

# Quick config probe (optional project-config.yaml takes precedence)
if [ -f "bmad-output/project-config.yaml" ]; then
  OUTPUT_FOLDER=$(grep -m1 "^output_folder:" "bmad-output/project-config.yaml" 2>/dev/null | cut -d: -f2 | tr -d ' "')
  OUTPUT_FOLDER=${OUTPUT_FOLDER:-bmad-output}
  CONFIG_FILE="${OUTPUT_FOLDER}/project-context.md"
fi

# Must have both an output folder AND project-context.md to be a BMAD project
if [ ! -d "$OUTPUT_FOLDER" ] || [ ! -f "$CONFIG_FILE" ]; then
  exit 0
fi

# Extract track and phase from project-context.md (first matching line each)
TRACK=$(grep -m1 "^track:" "$CONFIG_FILE" 2>/dev/null | cut -d: -f2 | tr -d ' "' | tr '[:upper:]' '[:lower:]')
PHASE=$(grep -m1 "^current_phase:" "$CONFIG_FILE" 2>/dev/null | cut -d: -f2 | tr -d ' "')

TRACK=${TRACK:-unknown}
PHASE=${PHASE:-unknown}

echo "BMAD context: track=${TRACK}, phase=${PHASE} — artifacts in ${OUTPUT_FOLDER}/"

exit 0
