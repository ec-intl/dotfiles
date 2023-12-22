# dotfiles 🚀

[![Lint Codebase](https://github.com/ec-intl/dotfiles/actions/workflows/linter.yml/badge.svg)](https://github.com/ec-intl/dotfiles/actions/workflows/linter.yml)

## About

This repository contains ECI's dotfiles 🟢, configuration files 📁 for the Company's various tools and applications. We use dotfiles to keep our environment consistent across machines 💻 and codespaces.

The dotfiles in this repository work on both Linux 🐧 and macOS 🍎. For Linux, we use Ubuntu 🐧 with the Bash shell. For macOS, we use the Zsh shell with Oh My Zsh. The src directory contains standardized aliases, functions, and other scripts that the dotfiles use. The install script updates your `.bashrc` or `.zshrc` file to source the files in the src directories. After installing, you can use the aliases and functions in your terminal.

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
        ./install.sh bash
    ```

4. Finally, source your shell's configuration file, for example, if you are using bash:

    ```bash
        source ~/.bashrc
    ```

Once you complete the installation steps, you will see a welcome message 📜.

## Customization

If you want to customize the dotfiles, edit the files in the dotfiles directory and rerun your shell's configuration file. You can add your own aliases, `.env` files, and functions to corresponding files in the `$HOME/bash-src` or `$HOME/zsh-src` directories. The install script will automatically source these files when you run it.

## Contents

Here is the dotfiles's directory structure (note that Zsh uses the bash functions file):

### Dotfiles Directory Structure

- src
  - bash
    - aliases
    - functions
    - env.env
  - zsh
    - aliases
    - env.env
- .github
  - workflows
    - linter.yml
  - super-liner.env
- install
- License
- README.md
- run-linter

## Further Information

You can find more information about each dot file in this repository by reading the comments in the files themselves.

## Troubleshooting

If you have any problems with the dotfiles, please open an issue in this repository.
