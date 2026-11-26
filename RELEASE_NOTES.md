# dotfiles v1.4.0 — task-interface release candidate

## Shared startup command

Include #104 (issue #103) in this unpublished candidate. The installed
`start-server <repository> <branch>` command preserves pre-pull disk-space pruning,
socket preparation, application and proxy pulls, checkout update, foreground
staging and detached production. Improvements cover progress messages, separate
pull reports, failure propagation and reusable preparation. The instance-maker
script becomes a deprecated forwarding wrapper; ecisite retains its separately
approved one-time content migration. No deployment-policy change is included.

Local container tests and lint passed. Validate the integrated candidate before
promotion. Keep preparation #100 and release #101/#102 reviewable; the temporary
final source remains blocked and must be replaced with the actual staging-to-main
PR after preparation lands. No release, installation or deployment was performed.

## Public release automation correction — 2026-11-26

Release publishing now runs locally using the built-in GitHub token, after any
existing deployment job succeeds. It verifies the current main commit matches
staging's tree and refuses to reuse a version tag from another commit. GitHub
generates release notes from repository history. No internal workflow access or
RPAT is needed for this release job.

The separate release-log workflow is removed: generated release notes replace
its bookkeeping. Existing log files remain as history. This job does not rewrite
main/staging, delete feature branches, or update a production branch. Existing
package deployment steps are preserved. Validate hosted checks before promotion;
publication is a separate outcome to verify after merge.

The earlier preparation records below are historical; their shared-template and
RPAT prerequisites are superseded for these two workflows.

Supersedes the unpublished v1.3.5 proposal below because feature PR #98 adds
repository task dispatch to the existing `dcpu` / `dcpub` interface. Retain
preparation #93/#95 and release #94/#96; do not create a duplicate release track.

The helper preserves ordinary Compose profiles, validates task names and returns
task failures. Bash and Zsh tests cover task dispatch and legacy profile fallback.
Review and merge #98 before final candidate qualification. Publish the approved
helper before adopting the dependent ecisite #178 task commands.

All unresolved public-workflow and credential prerequisites in #90 still apply.
Release #96 is a blocked temporary-source draft and must not be merged. After
preparation lands, open the actual staging-to-main promotion for #94 and close
that temporary draft unmerged. Nothing is merged, published or installed here.

## Earlier preparation record (retained)

## dotfiles v1.3.5 — release candidate

Prepared for review on 2026-11-25. This candidate has not been published.

## Candidate scope

- Merged PR #92: ci: use production workflow templates ([pull request](https://github.com/ec-intl/dotfiles/pull/92)).

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

### Historical: dotfiles v1.3.5 — release candidate

Prepared from staging for human review on 2026-11-19. No tag, release, or deployment has been published.

#### Historical: Included change record

- fix: Promote staged workflow guard and checkout updates while preserving main history.
- release: Set VERSION to 1.3.5 and add release and release-log automation.

These candidate notes are prepared on the release branch for review before promotion.

#### Historical: Net change inventory

- `.github/workflows/guard.yml`: staged branch guards and checkout updates.
- `.github/workflows/linter.yml`: staged lint updates, validation on PR updates,
  and permission to report commit statuses.
- `.github/workflows/release.yml`: run the shared release workflow from `production` on
  main pushes, with contents-write permission and inherited secrets.
- `.github/workflows/release-log.yml`: call the shared release-log
  workflow from `production` when PRs close, with contents-write permission and inherited secrets.
- `VERSION`: set the release candidate version to 1.3.5.
- `RELEASE_NOTES.md`: record the candidate scope and promotion prerequisites.

#### Historical: Promotion

Review and merge the release-preparation PR into staging first. Before promoting staging → main:

- Review and promote the guarded shared-template release:
  [preparation PR #185](https://github.com/ec-intl/workflow-templates/pull/185) and
  [promotion PR #186](https://github.com/ec-intl/workflow-templates/pull/186).
  Confirm that consumer workflow references use `@production`.
- Confirm that the new release workflow can access the inherited RPAT credential. No repository-level RPAT is configured, and organization-secret visibility has not yet been verified.

Then review staging → main. Keep auto-merge disabled.

#### Historical: Staging changes since the first audit

- bug: Updates decrypt function (#81) (#82)
- Merge branch 'main' into staging

Any matching PR listed earlier has now landed; remaining open PRs still require review.
