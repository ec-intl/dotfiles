#!/usr/bin/env bash
# Exercise real Git refs, including a staging update during the push.
set -euo pipefail
script_dir="$(cd "$(dirname "$0")" && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
export GIT_AUTHOR_NAME='Release test' GIT_COMMITTER_NAME='Release test'
export GIT_AUTHOR_EMAIL='test@example.invalid' GIT_COMMITTER_EMAIL='test@example.invalid'
for scenario in identical new-content concurrent; do
  remote="$fixture/$scenario.git"
  work="$fixture/$scenario"
  git init --bare -q "$remote"
  git init -q "$work"
  cd "$work"
  git remote add origin "$remote"
  echo base > VERSION
  git add VERSION
  git commit -qm base
  base=$(git rev-parse HEAD)
  git branch -M main
  echo release > VERSION
  git commit -qam release
  released=$(git rev-parse HEAD)
  # Same tree as main, but a different parent history as after a squash.
  staged=$(git commit-tree 'HEAD^{tree}' -p "$base" -m staging)
  git push -q origin main "$staged:refs/heads/staging"
  if [[ "$scenario" == new-content ]]; then
    git checkout -q --detach "$staged"
    echo new > VERSION
    git commit -qam new-content
    git push -q origin HEAD:staging
    staged=$(git rev-parse HEAD)
  elif [[ "$scenario" == concurrent ]]; then
    moved=$(git commit-tree 'HEAD^{tree}' -p "$staged" -m concurrent)
    # Make the object available remotely without updating staging yet.
    git push -q origin "$moved:refs/heads/future"
    printf '#!/bin/sh\ngit --git-dir="%s" update-ref refs/heads/staging %s\n' \
      "$remote" "$moved" > .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    staged="$moved"
  fi
  if bash "$script_dir/sync-release-staging.sh" "$released"; then
    [[ "$scenario" == identical ]]
    expected="$released"
    # An already synchronized release is safe to retry.
    bash "$script_dir/sync-release-staging.sh" "$released"
  else
    [[ "$scenario" != identical ]]
    expected="$staged"
  fi
  test "$(git --git-dir="$remote" rev-parse staging)" = "$expected"
done
echo 'Release staging synchronization tests passed.'
