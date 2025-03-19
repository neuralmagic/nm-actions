#!/bin/bash
# THIS expects two environment variables to be present
#  - INCLUDE_PATTERN
#  - EXCLUDE_PATTERN

set -ex

if [[ -z "${GITHUB_BASE_REF}" ]]; then
	# this is not a pull request event, just get the previous commit
	previous_sha=$(git rev-parse --verify 'HEAD^{commit}')
else
	previous_sha="origin/${GITHUB_BASE_REF}"
fi

current_branch=$(git branch --show-current)
CHANGED_FILES=$(git diff --name-only --diff-filter=ACMRT "${previous_sha}..${current_branch}")

readarray -t INCLUDE_PATTERNS < <(echo "${INCLUDE_PATTERN}")
readarray -t EXCLUDE_PATTERNS < <(echo "${EXCLUDE_PATTERN}")
declare -a MATCHED_FILES
while IFS= read -r file; do
	should_include=0
	should_exclude=0

	for include_pattern in "${INCLUDE_PATTERNS[@]}"; do
		if [[ "${file}" =~ ${include_pattern} ]]; then
			should_include=1
			break
		fi
	done

	if [[ ${should_include} -eq 1 ]] && [[ ${#EXCLUDE_PATTERNS[@]} -ne 0 ]]; then
		for exclude_pattern in "${EXCLUDE_PATTERNS[@]}"; do
			if [[ "${file}" =~ ${exclude_pattern} ]]; then
				should_exclude=1
				break
			fi
		done
	fi

	if [[ ${should_include} -eq 1 ]] && [[ ${should_exclude} -ne 1 ]]; then
		MATCHED_FILES+=("${file}")
	fi
done <<<"${CHANGED_FILES}"

echo "all_changed_files=${MATCHED_FILES[*]}" | tee -a "${GITHUB_OUTPUT}"
