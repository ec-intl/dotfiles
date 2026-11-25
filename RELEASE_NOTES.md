# dotfiles v1.3.5 — release candidate

Prepared for review on 2026-11-25. This candidate has not been published.

## Candidate scope

- Merged PR #92: ci: use production workflow templates (https://github.com/ec-intl/dotfiles/pull/92).

Already on staging:
- bug: Updates decrypt function (#81)
- fix: update checkout action and correct guard workflow checks (#83)
- release: prepare dotfiles v1.3.5 (#86)

Open pull requests listed above are prerequisites, not claims of merged behavior.

## Version

Retain the existing unpublished candidate; this preparation records remaining integration and release checks.

## Promotion prerequisites

Review and merge the scoped implementation work, then validate the actual integrated release head before promotion. Public access to the shared workflow repository remains a validation prerequisite; no access policy is changed here.

Merge the separate preparation PR into staging first. Review the actual staging-to-main comparison and required checks before authorizing promotion. Verify production publication separately after the release workflow runs. Keep consumer shared-workflow references on production; workflow-templates self-validation may use staging.

---

## Previous preparation record

# dotfiles v1.3.5 — release candidate

Prepared from staging for human review on 2026-11-19. No tag, release, or deployment has been published.

## Included change record

- fix: Promote staged workflow guard and checkout updates while preserving main history.
- release: Set VERSION to 1.3.5 and add release and release-log automation.

These candidate notes are prepared on the release branch for review before promotion.

## Net change inventory

- `.github/workflows/guard.yml`: staged branch guards and checkout updates.
- `.github/workflows/linter.yml`: staged lint updates, validation on PR updates,
  and permission to report commit statuses.
- `.github/workflows/release.yml`: run the pinned shared release workflow on
  main pushes, with contents-write permission and inherited secrets.
- `.github/workflows/release-log.yml`: call the pinned shared release-log
  workflow when PRs close, with contents-write permission and inherited secrets.
- `VERSION`: set the release candidate version to 1.3.5.
- `RELEASE_NOTES.md`: record the candidate scope and promotion prerequisites.

## Promotion

Review and merge the release-preparation PR into staging first. Before promoting staging → main:

- Review and promote the guarded shared-template release:
  [preparation PR #185](https://github.com/ec-intl/workflow-templates/pull/185) and
  [promotion PR #186](https://github.com/ec-intl/workflow-templates/pull/186).
  Confirm that immutable workflow references pin the reviewed commit.
- Confirm that the new release workflow can access the inherited RPAT credential. No repository-level RPAT is configured, and organization-secret visibility has not yet been verified.

Then review staging → main. Keep auto-merge disabled.


## Staging changes since the first audit

- bug: Updates decrypt function (#81) (#82)
- Merge branch 'main' into staging

Any matching PR listed earlier has now landed; remaining open PRs still require review.
