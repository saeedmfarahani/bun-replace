#!/usr/bin/env bash
#
# bun-replace installer
# ======================
#
# Replaces `node`, `npm`, and `npx` with `bun` and `bunx` by downloading
# shell wrapper scripts from the bun-replace GitHub repository.
#
# What this script does:
#   1. Downloads 3 scripts (node, npm, npx) from the repo
#   2. Installs them to ~/bin (or $BUN_REPLACE_INSTALL if set)
#   3. Makes them executable
#   4. Adds the install directory to your PATH in your shell config
#
# The scripts themselves simply forward all commands to `bun`/`bunx`
# while reporting standard version strings for compatibility.
#
# Environment variables:
#   BUN_REPLACE_INSTALL  - custom install directory (default: $HOME/bin)
#   GITHUB               - custom GitHub host (default: https://github.com)
#
# Source: https://github.com/saeedtahmtan/bun-replace
# License: GPL-3.0
#
# Usage:  curl -fsSL https://raw.githubusercontent.com/saeedtahmtan/bun-replace/main/install.sh | bash

set -euo pipefail

# ------------------------------------------------------------------
# Platform check — Windows is not supported (use WSL instead)
# ------------------------------------------------------------------
if [[ ${OS:-} = Windows_NT ]]; then
  echo "Windows is not supported yet. Please use WSL or copy the scripts manually."
  exit 1
fi

# ------------------------------------------------------------------
# Terminal color support — only enable when stdout is a TTY
# ------------------------------------------------------------------
Color_Off=''
Red=''
Green=''
Dim=''
Bold_White=''
Bold_Green=''

if [[ -t 1 ]]; then
    Color_Off='\033[0m'
    Red='\033[0;31m'
    Green='\033[0;32m'
    Dim='\033[0;2m'
    Bold_Green='\033[1;32m'
    Bold_White='\033[1m'
fi

# ------------------------------------------------------------------
# Output helpers
# ------------------------------------------------------------------
error() {
    echo -e "${Red}error${Color_Off}:" "$@" >&2
    exit 1
}

info() {
    echo -e "${Dim}$@ ${Color_Off}"
}

info_bold() {
    echo -e "${Bold_White}$@ ${Color_Off}"
}

success() {
    echo -e "${Green}$@ ${Color_Off}"
}

# ------------------------------------------------------------------
# Source repo configuration
# These can be overridden via environment variables (e.g. GITHUB)
# so power users can test against forks or mirror hosts.
# ------------------------------------------------------------------
GITHUB=${GITHUB-"https://github.com"}
REPO="${GITHUB}/saeedtahmtan/bun-replace"
BRANCH="main"

# ------------------------------------------------------------------
# Install directory — defaults to ~/bin, overridable via env var
# ------------------------------------------------------------------
install_dir="${BUN_REPLACE_INSTALL:-$HOME/bin}"
bin_dir="$install_dir"

if [[ ! -d $bin_dir ]]; then
    mkdir -p "$bin_dir" ||
        error "Failed to create install directory \"$bin_dir\""
fi

# ------------------------------------------------------------------
# Download each script from GitHub and make it executable
# ------------------------------------------------------------------
for script in node npm npx; do
    uri="$REPO/raw/$BRANCH/$script"
    info "Downloading $script..."
    curl --fail --location --progress-bar --output "$bin_dir/$script" "$uri" ||
        error "Failed to download $script from $uri"
    chmod +x "$bin_dir/$script" ||
        error "Failed to set permissions on $script"
done

# ------------------------------------------------------------------
# Helper: replace $HOME with ~ for prettier path display
# ------------------------------------------------------------------
tildify() {
    if [[ $1 = $HOME/* ]]; then
        local replacement=\~/
        echo "${1/$HOME\//$replacement}"
    else
        echo "$1"
    fi
}

success "Scripts installed successfully to $(tildify "$bin_dir")"

tilde_bin_dir=$(tildify "$bin_dir")
quoted_install_dir=\"${install_dir//\"/\\\"}\"

if [[ $quoted_install_dir = \"$HOME/* ]]; then
    quoted_install_dir=${quoted_install_dir/$HOME\//\$HOME/}
fi

# ------------------------------------------------------------------
# Detect the user's shell and add the install directory to PATH
# Supports bash, zsh, and fish. Falls back to printing instructions.
# ------------------------------------------------------------------
case $(basename "${SHELL:-}") in

# Fish shell
fish)
    commands=(
        "set --export BUN_REPLACE_INSTALL $quoted_install_dir"
        "set --export PATH $tilde_bin_dir \$PATH"
    )

    fish_config=$HOME/.config/fish/config.fish
    tilde_fish_config=$(tildify "$fish_config")

    if [[ -w $fish_config ]]; then
        {
            echo -e '\n# bun-replace'
            for command in "${commands[@]}"; do
                echo "$command"
            done
        } >>"$fish_config"

        info "Added \"$tilde_bin_dir\" to \$PATH in \"$tilde_fish_config\""
    else
        echo "Manually add the directory to $tilde_fish_config (or similar):"
        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;

# Zsh
zsh)
    commands=(
        "export BUN_REPLACE_INSTALL=$quoted_install_dir"
        "export PATH=\"$tilde_bin_dir:\$PATH\""
    )

    zsh_config=$HOME/.zshrc
    tilde_zsh_config=$(tildify "$zsh_config")

    if [[ -w $zsh_config ]]; then
        {
            echo -e '\n# bun-replace'
            for command in "${commands[@]}"; do
                echo "$command"
            done
        } >>"$zsh_config"

        info "Added \"$tilde_bin_dir\" to \$PATH in \"$tilde_zsh_config\""
    else
        echo "Manually add the directory to $tilde_zsh_config (or similar):"
        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;

# Bash
bash)
    commands=(
        "export BUN_REPLACE_INSTALL=$quoted_install_dir"
        "export PATH=\"$tilde_bin_dir:\$PATH\""
    )

    bash_configs=(
        "$HOME/.bash_profile"
        "$HOME/.bashrc"
    )

    if [[ ${XDG_CONFIG_HOME:-} ]]; then
        bash_configs+=(
            "$XDG_CONFIG_HOME/.bash_profile"
            "$XDG_CONFIG_HOME/.bashrc"
            "$XDG_CONFIG_HOME/bash_profile"
            "$XDG_CONFIG_HOME/bashrc"
        )
    fi

    set_manually=true
    for bash_config in "${bash_configs[@]}"; do
        tilde_bash_config=$(tildify "$bash_config")

        if [[ -w $bash_config ]]; then
            {
                echo -e '\n# bun-replace'
                for command in "${commands[@]}"; do
                    echo "$command"
                done
            } >>"$bash_config"

            info "Added \"$tilde_bin_dir\" to \$PATH in \"$tilde_bash_config\""
            set_manually=false
            break
        fi
    done

    if [[ $set_manually = true ]]; then
        echo "Manually add the directory to $HOME/.bashrc (or similar):"
        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;

# Unknown shell — print manual instructions
*)
    echo "Manually add the directory to ~/.bashrc (or similar):"
    info_bold "  export BUN_REPLACE_INSTALL=$quoted_install_dir"
    info_bold "  export PATH=\"$tilde_bin_dir:\$PATH\""
    ;;
esac

# ------------------------------------------------------------------
# Print verification steps
# ------------------------------------------------------------------
echo
info "To verify, run:"
echo
info_bold "  node --version"
info_bold "  npm --version"
info_bold "  npx --version"
echo
success "Done! 🚀"
