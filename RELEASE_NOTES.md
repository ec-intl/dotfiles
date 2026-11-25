# dotfiles v1.3.5 — release candidate

Prepared from staging for human review on 2026-11-19. No tag, release, or deployment has been published.

## Included change record

- fix: Promote staged workflow guard and checkout updates while preserving main history.

These candidate notes are prepared on the release branch for review before promotion.

## Net change inventory

- `.github/workflows/guard.yml`
- `.github/workflows/linter.yml`

## Promotion

Review and merge the release-preparation PR into staging first. Before promoting staging → main:

- Review and promote the guarded shared-template release: https://github.com/ec-intl/workflow-templates/pull/185 and https://github.com/ec-intl/workflow-templates/pull/186. Confirm that immutable workflow references pin the reviewed commit.
- Confirm that the new release workflow can access the inherited RPAT credential. No repository-level RPAT is configured, and organization-secret visibility has not yet been verified.

Then review staging → main. Keep auto-merge disabled.
