# dotfiles v1.3.5 — release candidate

Prepared from staging for human review on 2026-11-19. No tag, release, or deployment has been published.

## Included change record

- fix: Promote staged workflow guard and checkout updates while preserving main history.

These candidate notes are prepared on the release branch for review before promotion.

## Net change inventory

- `.github/workflows/guard.yml`
- `.github/workflows/linter.yml`

## Promotion

Review and merge the release-preparation PR into staging first, then review staging → main. Keep auto-merge disabled. Release/CD jobs may publish packages, update production branches, and build/push images after promotion.
