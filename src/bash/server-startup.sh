#!/usr/bin/env bash
# Shared implementation of the established website startup sequence.

_eci_prepare_server_images() (
  set -euo pipefail
  repository="$1"
  branch="$2"
  registry="${AWSECR:-${aws_ecr:-185299487714.dkr.ecr.us-east-2.amazonaws.com}}"
  reports="$HOME/deployments"
  mkdir -p "$reports" || exit "$?"
  echo 'Preparing Docker access and reclaiming unused space...'
  sudo chmod 666 /var/run/docker.sock || exit "$?"
  docker system prune -af || exit "$?"
  echo "Authenticating to $registry..."
  aws ecr get-login-password --region us-east-2 |
    docker login --username AWS --password-stdin "$registry" || exit "$?"
  echo "Pulling $repository:$branch and ECI proxy images..."
  # Keep the established image list. Each report retains its own output.
  for image in "$repository:$branch" ecisite:dante-proxy ecisite:squid-proxy; do
    report="$reports/out.${image//[:\/]/_}"
    if docker pull "$registry/$image" >"$report" 2>&1; then
      cat "$report"
    else
      pull_status="$?"
      cat "$report" >&2
      exit "$pull_status"
    fi
  done
)

_eci_validate_server_arguments() {
  local command="$1"
  shift
  if [[ $# -lt 1 || $# -gt 2 || ! "$1" =~ ^[a-zA-Z0-9_.-]+$ || "$1" == .* || "$1" == -* ||
        ! "${2-production}" =~ ^[a-zA-Z0-9_.-]+$ || "${2-production}" == .* || "${2-production}" == -* ]]; then
    echo "Usage: $command <repository> [branch] (default: production)" >&2
    return 2
  fi
}

_eci_start_server() (
  set -eo pipefail
  _eci_validate_server_arguments start-server "$@" || exit "$?"
  repository="$1"
  branch="${2-production}"
  _eci_prepare_server_images "$repository" "$branch"
  echo "Updating $repository checkout to $branch..."
  cd "$HOME/$repository"
  git checkout "$branch"
  git pull
  echo "Starting $repository ($branch)..."
  # A registered application task may share image preparation with dcpu.
  export ECI_SERVER_IMAGES_READY="$repository:$branch"
  if [[ "$branch" == staging ]]; then
    dcpu "$branch"
  else
    dcpud "$branch"
  fi
  rm -rf "$HOME/deployments/"
  echo 'Server started successfully.'
)

_eci_stop_server() (
  set -eo pipefail
  _eci_validate_server_arguments stop-server "$@" || exit "$?"
  repository="$1"
  branch="${2-production}"
  cd "$HOME/$repository" || exit "$?"
  echo "Stopping $repository ($branch)..."
  dcpd "$branch" || exit "$?"
  echo 'Server stopped successfully.'
)

_eci_restart_server() (
  set -eo pipefail
  _eci_validate_server_arguments restart-server "$@" || exit "$?"
  _eci_stop_server "$@" || exit "$?"
  _eci_start_server "$@"
)
