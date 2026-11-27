#!/usr/bin/env bash
# Publish selected distribution files without discarding concurrent updates.
set -euo pipefail
release_sha="${1:?Missing released main SHA}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
manifest="${ECI_RELEASE_MANIFEST:-$script_dir/release-files.txt}"
git fetch origin main staging
test "$(git rev-parse origin/main)" = "$release_sha"
staging_sha="$(git rev-parse origin/staging)"
git diff --quiet "$release_sha" "$staging_sha"
version=$(git show "$release_sha:VERSION")
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
major="v${version%%.*}"
production_sha=$(git ls-remote --heads origin refs/heads/production | cut -f1)
major_sha=$(git ls-remote --heads origin "refs/heads/$major" | cut -f1)
files=()
while IFS= read -r path || [[ -n "$path" ]]; do
  [[ -n "$path" && "$path" != \#* ]] || continue
  case "$path" in /*|..|../*|*/../*|.git|.git/*) exit 2 ;; esac
  git cat-file -e "$release_sha:$path"
  files+=("$path")
done < "$manifest"
[[ ${#files[@]} -gt 0 ]]
# Construct a clean Git tree directly from tracked blobs, preserving file modes.
# Never copy a checkout's .git directory or include files outside the manifest.
index_dir=$(mktemp -d)
trap 'rm -rf "$index_dir"' EXIT
export GIT_INDEX_FILE="$index_dir/index"
git read-tree --empty
git ls-tree -rz "$release_sha" -- "${files[@]}" | git update-index -z --index-info
distribution_tree=$(git write-tree)
unset GIT_INDEX_FILE
parents=()
if [[ -n "$production_sha" ]]; then
  git fetch origin "$production_sha"
  parents=(-p "$production_sha")
fi
if [[ -n "$production_sha" && "$(git rev-parse "$production_sha^{tree}")" == "$distribution_tree" ]]; then
  distribution_sha="$production_sha"
else
  distribution_sha=$(git -c user.name='Elizabeth R.' -c user.email=eci-robot@ec-intl.com \
    commit-tree "$distribution_tree" "${parents[@]}" -m "production update for v$version")
fi
git push --atomic origin \
  --force-with-lease="refs/heads/production:$production_sha" \
  --force-with-lease="refs/heads/$major:$major_sha" \
  --force-with-lease="refs/heads/staging:$staging_sha" \
  "$distribution_sha:refs/heads/production" \
  "$distribution_sha:refs/heads/$major" \
  "$release_sha:refs/heads/staging"
for branch in production "$major"; do
  test "$(git ls-remote --heads origin "refs/heads/$branch" | cut -f1)" = "$distribution_sha"
done
test "$(git ls-remote --heads origin refs/heads/staging | cut -f1)" = "$release_sha"
