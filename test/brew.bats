#!/usr/bin/env bats

# Tests for brew.zsh — configuration, alias targets, and completion routing.

load helpers/setup

setup() {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    create_mock brew
}

# ── configuration variables ──────────────────────────────────────────

@test "brew preview variables are set to defaults" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        echo "$PACKAGEMANAGER_FZF_BREW_PREVIEW"
        echo "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW"
    '
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == *"brew info {}"* ]]
    [[ "${lines[1]}" == *"brew info --cask {}"* ]]
}

@test "brew bind variables are set to defaults" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        echo "$PACKAGEMANAGER_FZF_BREW_BIND"
        echo "$PACKAGEMANAGER_FZF_BREW_CASK_BIND"
    '
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == *"ctrl-x:execute-silent(brew home {})"* ]]
    [[ "${lines[1]}" == *"ctrl-x:execute-silent(brew home --cask {})"* ]]
}

# ── alias targets ────────────────────────────────────────────────────

@test "bip alias points to __fpm_brew_install" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        __fpm_brew_setup
        alias bip
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_brew_install"* ]]
}

@test "bup alias points to __fpm_brew_uninstall" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        __fpm_brew_setup
        alias bup
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_brew_uninstall"* ]]
}

@test "bcip alias points to __fpm_brew_cask_install" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        __fpm_brew_setup
        alias bcip
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_brew_cask_install"* ]]
}

@test "bcup alias points to __fpm_brew_cask_uninstall" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        __fpm_brew_setup
        alias bcup
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_brew_cask_uninstall"* ]]
}

# ── completion routing: install ──────────────────────────────────────
#
# We mock _fzf_complete to record which arguments it received, then
# verify the correct branch was taken by checking the recorded args.

@test "completion routes 'brew install --cask' to cask branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-cask-list" }
        _fzf_complete_brew "brew install --cask foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew install --cask"* ]]
    [[ "$output" == *"brew info --cask"* ]]
}

@test "completion routes 'brew install' to formulae branch (not cask)" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-formulae" }
        _fzf_complete_brew "brew install foo"
    '
    [ "$status" -eq 0 ]
    # Should use the formulae preview, NOT the cask preview
    [[ "$output" == *"brew info {}"* ]]
    [[ "$output" != *"brew info --cask"* ]]
}

@test "completion routes 'brew install --verbose --cask' to cask branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-cask-list" }
        _fzf_complete_brew "brew install --verbose --cask foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew install --cask"* ]]
    [[ "$output" == *"brew info --cask"* ]]
}

# ── completion routing: uninstall / remove / rm ──────────────────────

@test "completion routes 'brew uninstall --cask' to cask uninstall branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-cask" }
        _fzf_complete_brew "brew uninstall --cask foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew uninstall --cask"* ]]
    [[ "$output" == *"brew info --cask"* ]]
}

@test "completion routes 'brew uninstall' to leaves branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-leaves" }
        _fzf_complete_brew "brew uninstall foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew uninstall"* ]]
    [[ "$output" == *"brew info {}"* ]]
    [[ "$output" != *"brew info --cask"* ]]
}

@test "completion routes 'brew remove' to leaves branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-leaves" }
        _fzf_complete_brew "brew remove foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew remove"* ]]
    [[ "$output" == *"brew info {}"* ]]
    [[ "$output" != *"brew info --cask"* ]]
}

@test "completion routes 'brew rm' to leaves branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-leaves" }
        _fzf_complete_brew "brew rm foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew rm"* ]]
    [[ "$output" == *"brew info {}"* ]]
    [[ "$output" != *"brew info --cask"* ]]
}

@test "completion routes 'brew remove --cask' to cask branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-cask" }
        _fzf_complete_brew "brew remove --cask foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew remove --cask"* ]]
    [[ "$output" == *"brew info --cask"* ]]
}

@test "completion routes 'brew rm --cask' to cask branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-cask" }
        _fzf_complete_brew "brew rm --cask foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew rm --cask"* ]]
    [[ "$output" == *"brew info --cask"* ]]
}

# ── completion routing: reinstall ────────────────────────────────────

@test "completion routes 'brew reinstall' to installed formulae" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-installed" }
        _fzf_complete_brew "brew reinstall foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew reinstall"* ]]
    [[ "$output" == *"brew info {}"* ]]
    [[ "$output" != *"brew info --cask"* ]]
}

@test "completion routes 'brew reinstall --cask' to cask branch" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        brew() { echo "mock-cask" }
        _fzf_complete_brew "brew reinstall --cask foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"brew reinstall --cask"* ]]
    [[ "$output" == *"brew info --cask"* ]]
}

# ── completion routing: fallback ─────────────────────────────────────

@test "completion falls back for unknown brew subcommand" {
    run_zsh '
        source "$PLUGIN_DIR/brew.zsh"
        _fzf_complete() { echo "SHOULD_NOT_BE_CALLED" }
        zle() { echo "ZLE_FALLBACK: $*" }
        fzf_default_completion="expand-or-complete"
        _fzf_complete_brew "brew search foo"
    '
    [ "$status" -eq 0 ]
    [[ "$output" != *"SHOULD_NOT_BE_CALLED"* ]]
}
