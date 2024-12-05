#!/usr/bin/env bash

#
# Run eslint and abort commit if errors
# Put this to .git/hooks/post-checkout
#
# Stronly influenced by: https://github.com/pacificclimate/climate-explorer-frontend/blob/master/git/hooks/pre-commit-eslint
#

# Verify storyboards and xibs
# taken from : https://github.com/krzysztofzablocki/Sourcery/blob/master/Scripts/pre-commit.sh

PASS=true

misplaced_pattern='misplaced="YES"'

if git diff-index -p -M --cached HEAD -- '*.xib' '*.storyboard' | grep '^+' | grep -E "$misplaced_pattern" >/dev/null 2>&1; then
  echo "COMMIT REJECTED for misplaced views. Correct them before committing." >&2
  echo '----' >&2
  git grep --cached -E "$misplaced_pattern" '*.xib' '*.storyboard' >&2
  echo '----' >&2
  PASS=false
fi

SWIFT_LINT=./Pods/SwiftLint/swiftlint
SWIFT_FORMAT=./Pods/SwiftFormat/CommandLineTool/swiftformat

echo "SwiftLint version: $(${SWIFT_LINT} version)"
${SWIFT_FORMAT} --version

git diff --cached --name-only --diff-filter=ACM | grep "\.swift$" | grep -v ".*R.generated.swift$" | while read -r line; do
  echo "SwiftFormat ${line}"
  "${SWIFT_FORMAT}" --indent 2 "${line}"
  git add -- "${line}"
done

 while IFS= read -r F; do
  echo "SwiftLint ${F}"
  OUTPUT=$(${SWIFT_LINT} lint --quiet --path "${F}")
  if [ "$OUTPUT" == '' ]; then
    echo "SwiftLint Passed: ${F}"
  else
    PASS=false
    echo "SwiftLint Failed: ${F}"
    while read -r line; do
      FILEPATH=$(echo "$line" | cut -d : -f 1)
      L=$(echo "$line" | cut -d : -f 2)
      C=$(echo "$line" | cut -d : -f 3)
      TYPE=$(echo "$line" | cut -d : -f 4 | cut -c 2-)
      MESSAGE=$(echo "$line" | cut -d : -f 5 | cut -c 2-)
      DESCRIPTION=$(echo "$line" | cut -d : -f 6 | cut -c 2-)
      if [ "$TYPE" == 'error' ]; then
        printf "\n  \e[31m%s\e[39m\n" "$TYPE"
      else
        printf "\n  \e[33m%s\e[39m\n" "$TYPE"
      fi
      printf "    \e[90m%s:%s:%s\e[39m\n" "$FILEPATH" "$L" "$C"
      printf "    %s - %s\n" "$MESSAGE" "$DESCRIPTION"
    done <<<"$OUTPUT"
  fi
done < <(git diff --cached --name-only --diff-filter=ACM | grep "\.swift$" | grep -v ".*R.generated.swift$")

if ! $PASS; then
  echo "COMMIT FAILED: Fix linting errors and try again."
  exit 1
else
  echo "COMMIT SUCCEEDED"
  exit 0
fi
