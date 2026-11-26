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

_eci_start_server() (
  set -eo pipefail
  if [[ $# -ne 2 || ! "$1" =~ ^[a-zA-Z0-9_.-]+$ || "$1" == .* || "$1" == -* ||
        ! "$2" =~ ^[a-zA-Z0-9_.-]+$ || "$2" == .* || "$2" == -* ]]; then
    echo 'Usage: start-server <repository> <branch>' >&2
    exit 2
  fi
  repository="$1"
  branch="$2"
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
