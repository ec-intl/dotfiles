#!/usr/bin/env bash
# Publish one reviewed tree atomically, without discarding concurrent updates.
set -euo pipefail
release_sha="${1:?Missing released main SHA}"
git fetch origin main staging
test "$(git rev-parse origin/main)" = "$release_sha"
staging_sha="$(git rev-parse origin/staging)"
git diff --quiet "$release_sha" "$staging_sha"
version=$(git show "$release_sha:VERSION")
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
major="v${version%%.*}"
production_sha=$(git ls-remote --heads origin refs/heads/production | cut -f1)
major_sha=$(git ls-remote --heads origin "refs/heads/$major" | cut -f1)
git push --atomic origin \
  --force-with-lease="refs/heads/production:$production_sha" \
  --force-with-lease="refs/heads/$major:$major_sha" \
  --force-with-lease="refs/heads/staging:$staging_sha" \
  "$release_sha:refs/heads/production" \
  "$release_sha:refs/heads/$major" \
  "$release_sha:refs/heads/staging"
for branch in production "$major" staging; do
  test "$(git ls-remote --heads origin "refs/heads/$branch" | cut -f1)" = "$release_sha"
done
