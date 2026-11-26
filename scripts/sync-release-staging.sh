#!/usr/bin/env bash
# Synchronize squash-release history without discarding concurrent staged work.
set -euo pipefail
release_sha="${1:?Missing released main SHA}"
git fetch origin main staging
test "$(git rev-parse origin/main)" = "$release_sha"
staging_sha="$(git rev-parse origin/staging)"
git diff --quiet "$release_sha" "$staging_sha"
git push origin "$release_sha:refs/heads/staging" \
  --force-with-lease="refs/heads/staging:$staging_sha"
