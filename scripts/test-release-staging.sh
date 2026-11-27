#!/usr/bin/env bash
# Exercise real Git refs, including a staging update during the push.
set -euo pipefail
script_dir="$(cd "$(dirname "$0")" && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
export GIT_AUTHOR_NAME='Release test' GIT_COMMITTER_NAME='Release test'
export GIT_AUTHOR_EMAIL='test@example.invalid' GIT_COMMITTER_EMAIL='test@example.invalid'
for scenario in identical missing-major new-content stale-main concurrent-staging concurrent-production concurrent-major; do
  remote="$fixture/$scenario.git"
  work="$fixture/$scenario"
  git init --bare -q "$remote"
  git init -q "$work"
  cd "$work"
  git remote add origin "$remote"
  echo 1.4.0 > VERSION
  git add VERSION
  git commit -qm base
  base=$(git rev-parse HEAD)
  git branch -M main
  echo 1.5.0 > VERSION
  git commit -qam release
  released=$(git rev-parse HEAD)
  # Same tree as main, but a different parent history as after a squash.
  staged=$(git commit-tree 'HEAD^{tree}' -p "$base" -m staging)
  git push -q origin main "$staged:refs/heads/staging"
  git push -q origin "$base:refs/heads/production"
  production="$base"
  major=""
  if [[ "$scenario" != missing-major ]]; then
    git push -q origin "$base:refs/heads/v1"
    major="$base"
  fi
  if [[ "$scenario" == new-content ]]; then
    git checkout -q --detach "$staged"
    echo 1.5.1 > VERSION
    git commit -qam new-content
    git push -q origin HEAD:staging
    staged=$(git rev-parse HEAD)
  elif [[ "$scenario" == stale-main ]]; then
    echo 1.5.1 > VERSION
    git commit -qam newer-main
    git push -q origin HEAD:main
  elif [[ "$scenario" == concurrent-* ]]; then
    moved=$(git commit-tree 'HEAD^{tree}' -p "$staged" -m concurrent)
    # Make the object available remotely without updating staging yet.
    git push -q origin "$moved:refs/heads/future"
    case "$scenario" in
      concurrent-staging) target=staging; staged="$moved" ;;
      concurrent-production) target=production; production="$moved" ;;
      concurrent-major) target=v1; major="$moved" ;;
    esac
    printf '#!/bin/sh\ngit --git-dir="%s" update-ref refs/heads/%s %s\n' \
      "$remote" "$target" "$moved" > .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
  fi
  if bash "$script_dir/sync-release-branches.sh" "$released"; then
    [[ "$scenario" == identical || "$scenario" == missing-major ]]
    expected="$released"
    production="$released"
    major="$released"
    # An already synchronized release is safe to retry.
    bash "$script_dir/sync-release-branches.sh" "$released"
  else
    [[ "$scenario" != identical && "$scenario" != missing-major ]]
    expected="$staged"
  fi
  test "$(git --git-dir="$remote" rev-parse staging)" = "$expected"
  test "$(git --git-dir="$remote" rev-parse production)" = "$production"
  actual_major=$(git --git-dir="$remote" rev-parse --verify refs/heads/v1 2>/dev/null || true)
  test "$actual_major" = "$major"
done
echo 'Release staging synchronization tests passed.'
