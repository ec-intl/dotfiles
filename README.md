# dotfiles 🚀

## Project Status

Welcome to our project! Here's the current status of our workflows:

| Workflow | Status |
|----------|--------|
| **Guard Main Branch** | [![Guard Main](https://github.com/ec-intl/workflow-templates/actions/workflows/guard.yml/badge.svg)](https://github.com/ec-intl/workflow-templates/actions/workflows/guard.yml) |
| **Lint Codebase** | [![Lint Codebase](https://github.com/ec-intl/workflow-templates/actions/workflows/super-linter.yml/badge.svg)](https://github.com/ec-intl/workflow-templates/actions/workflows/super-linter.yml) |

## About

This repository contains ECI's dotfiles 🟢, configuration files 📁 for the Company's various tools and applications. We use dotfiles to keep our environment consistent across machines 💻 and codespaces.

The dotfiles in this repository work on both Linux 🐧 and macOS 🍎. For Linux, we use Ubuntu 🐧 with the Bash shell. For macOS, we use the Zsh shell with Oh My Zsh.

The src directory contains standardized aliases, functions, and other scripts that the dotfiles use. The install script updates your `.bashrc` or `.zshrc` file to source the files in the src directories. After installing, you can use the aliases and functions in your terminal.

The bin direcotry contains scripts that you can run from the command-line. The install script adds the bin directory to your PATH so that you can run the scripts from anywhere. See installation steps below.

## Installation

To install the dotfiles, clone this repository to your 🏠 📂 and then 🏃 the following commands:

1. Clone the repository on your local machine:

    ```bash
        git clone git@github.com:ec-intl/dotfiles.git
    ```

2. Navigate to the dotfiles directory:

    ```bash
        cd dotfiles
    ```

3. Run the install.sh script stating the shell you are using, for example, if you are using bash:

    ```bash
        ./install bash
    ```

4. Finally, source your shell's configuration file, for example, if you are using bash:

    ```bash
        source ~/.bashrc
    ```

Once you complete the installation steps, you will see a welcome message 📜.

## Container task interface

Use `dcpu <task>` to perform a task and `dcpub <task>` to build and perform it.
Existing Compose profiles, such as `dcpu production` and `dcpub ci-testing`,
retain their behavior when no repository task is registered.

A repository can list task names, one per line, in `.eci/compose-tasks` and
provide an executable `.eci/compose-task` handler. The helpers call that handler
with the operation (`up`, `up-build`, `up-detached`, `build`, or `down`) and task
name, and return its exit status. The handler owns the Compose files, local
isolation, interactive input, cleanup and failure reporting for its tasks.
Only files in the current directory are consulted; no shell configuration is
installed or sourced by dispatch. Treat task handlers as executable repository
code, just like its existing build and container scripts.

For example, ecisite provides `dcpu preview`, `dcpu preview-assets` and
`dcpu preview-checks`. Use that repository's README for its supported tasks.
After the approved dotfiles change is published, update the installed dotfiles
before using repository tasks. This addition does not install itself.

## Uninstallation

To uninstall the dotfiles, run the following commands:

1. Navigate to the dotfiles directory:

    ```bash
        cd dotfiles
    ```

2. Run the uninstall.sh script stating the shell you are using, for example, if you are using bash:

    ```bash
        ./uninstall bash
    ```

The uninstall script will remove the dotfiles from your home directory and restore your shell's configuration file to its original state.

## Getting the latest version

To get the latest version of the dotfiles, run the following commands:

1. Navigate to the dotfiles directory:

    ```bash
        cd dotfiles
    ```

2. Run the update.sh script stating the shell you are using, for example, if you are using bash:

    ```bash
        ./update bash
    ```

The update script will pull the latest version of the dotfiles from the remote repository and update your shell's configuration file to source the files in the src directories.

## Customization

If you want to customize the dotfiles, edit the files in the dotfiles directory and rerun your shell's configuration file. You can add your own aliases, `.env` files, and functions to corresponding files in the `$HOME/bash-src` or `$HOME/zsh-src` directories. The install script will automatically source these files when you run it.

## Contents

Here is the dotfiles's directory structure (note that Zsh uses the bash functions file):

### Dotfiles Directory Structure

```plaintext
|--- src
    |--- bash
        |--- aliases
        |--- functions
        |--- env.env
    |--- zsh
        |--- aliases
        |--- env.env
|--- bin
    |--- gres: This script replaces a pattern in a file, but does not change the file's contents.
|--- install
|--- License
|--- README.md
|--- run-linter
|--- uninstall
|--- update
```

## Further Information

You can find more information about each dot file in this repository by reading the comments in the files themselves.

## Troubleshooting

If you have any problems with the dotfiles, please open an issue in this repository.

## Site startup

The installed `start-server <repository> [branch]` command preserves the existing
startup sequence: prepare Docker access, prune unused resources to reclaim disk
space, authenticate, pull the application and ECI proxy images, update the
checkout, and launch through the shared Compose interface. Staging runs in the
foreground; other branches run detached. Failures stop startup and retain the
pull reports in `~/deployments`; successful completion removes that directory.

The branch defaults to `production` for all three commands:

```bash
start-server ecisite
stop-server ecisite
restart-server ecisite
```

Pass a branch explicitly when needed, for example `start-server ecisite staging`.
`stop-server` calls the shared Compose `down` task without pulling or pruning.
`restart-server` stops first and starts only if stopping succeeds.

After updating an existing installation, open a new terminal or load the shared
helpers with `source "$HOME/dotfiles/src/bash/functions"`. This adds the installed
commands to PATH without duplicating that entry. Check availability with
`command -v start-server stop-server restart-server`.

For example, `start-server ecisite production` updates and starts the production
checkout. Within an updated ecisite checkout, `dcpu production` uses the same
image preparation. Its approved content migration is owned by ecisite, runs once,
and preserves subsequent administration edits. The older instance-maker
`start-server.sh` is a deprecated forwarding wrapper.

Use `dcpu ci-testing` and `dcpu ci-linting` for local container checks. Tests replace
server commands with isolated fixtures; they never prune the host or contact AWS.
