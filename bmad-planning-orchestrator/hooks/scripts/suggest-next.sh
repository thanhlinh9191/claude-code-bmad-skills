#!/bin/bash
# BMAD Planning & Orchestrator — Stop Hook (suggest-next)
# Prints a SINGLE one-line nudge toward the next planning skill.
# Exits silently (code 0) when not a BMAD project — no noise, no token cost.

OUTPUT_FOLDER="bmad-output"

# Optional config override
if [ -f "bmad-output/project-config.yaml" ]; then
  _OF=$(grep -m1 "^output_folder:" "bmad-output/project-config.yaml" 2>/dev/null | cut -d: -f2 | tr -d ' "')
  OUTPUT_FOLDER=${_OF:-bmad-output}
fi

# Must have an output folder to be a BMAD project
if [ ! -d "$OUTPUT_FOLDER" ]; then
  exit 0
fi

# Probe for artifact presence (ordered by BMAD planning sequence)
# The FIRST missing artifact in the chain is the next step to suggest.

has() { ls "${OUTPUT_FOLDER}/$1" 2>/dev/null | head -1 | grep -q .; }

if ! has "project-context.md"; then
  echo "BMAD next: run /bmad-planning-orchestrator:bmad-init to initialize this project"
elif ! has "product-brief*.md"; then
  echo "BMAD next: run /bmad-planning-orchestrator:bmad-product-brief to create the product brief"
elif ! has "prd*.md" && ! has "tech-spec*.md"; then
  echo "BMAD next: run /bmad-planning-orchestrator:bmad-prd to create the PRD or tech spec"
elif ! has "architecture*.md"; then
  echo "BMAD next: run /bmad-planning-orchestrator:bmad-architecture to design the architecture"
elif ! has "epics*.md" && ! has "stories/" && ! ls "${OUTPUT_FOLDER}"/*.story.md 2>/dev/null | grep -q .; then
  echo "BMAD next: run /bmad-planning-orchestrator:bmad-epics-and-stories to plan epics and stories"
else
  # All major planning artifacts present — check for any story still in backlog/ready state
  PENDING=$(grep -rlE "^\*\*Status:\*\* *(backlog|ready-for-dev)" "${OUTPUT_FOLDER}" 2>/dev/null | head -1)
  if [ -n "$PENDING" ]; then
    STORY=$(basename "$PENDING")
    echo "BMAD next: run /bmad-planning-orchestrator:bmad-sprint-planning to sequence or hand off story ${STORY}"
  fi
  # If nothing pending, stay silent — project is fully planned
fi

exit 0
