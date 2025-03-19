#!/bin/bash
# THIS expects two environment variables to be present
#  - INCLUDE_PATTERN
#  - EXCLUDE_PATTERN

set -ex

if [ -z "${GITHUB_BASE_REF}" ]; then
  # this is not a pull request event, just get the previous commit
  previous_sha=$(git rev-parse --verify 'HEAD^{commit}')
else
  previous_sha=${GITHUB_BASE_REF}
fi
CHANGED_FILES=$(git diff --name-only --diff-filter=ACMRT ${previous_sha}..HEAD )

IFS=$'\n' read -r -a INCLUDE_PATTERNS <<< "${INCLUDE_PATTERN}"
IFS=$'\n' read -r -a EXCLUDE_PATTERNS <<< "${EXCLUDE_PATTERN}"
MATCHED_FILES=""
while IFS= read -r file; do
  # Check if the file matches any include pattern
  for include_pattern in "${INCLUDE_PATTERNS[@]}"; do
    if [[ "$file" =~ $include_pattern ]]; then
      if [ -n "${EXCLUDE_PATTERN}" ]; then
        exclude_match=false
        for exclude_pattern in "${EXCLUDE_PATTERNS[@]}"; do
          if [[ "$file" =~ $exclude_pattern ]]; then
            exclude_match=true
            break
          fi
        done
        if [ "$exclude_match" = true ]; then
          break
        fi
      fi
      echo "Matched changed file: $file"
      MATCHED_FILES+="$file"$'\n'
      if [ -n "${EXCLUDE_PATTERN}" ]; then
        exclude_match=false
        for exclude_pattern in "${EXCLUDE_PATTERNS[@]}"; do
          if [[ "$file" =~ $exclude_pattern ]]; then
            exclude_match=true
            break
          fi
        done
        if [ "$exclude_match" = true ]; then
          break
        fi
      fi
      echo "Matched changed file: $file"
      MATCHED_FILES+="$file"$'\n'
      break
    fi
  done
done <<< "$CHANGED_FILES"
echo "all_changed_files=$MATCHED_FILES" >> "$GITHUB_OUTPUT"
