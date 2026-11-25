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
