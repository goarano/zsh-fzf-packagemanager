#!/usr/bin/env bats

# Tests for apt.zsh — configuration, alias targets, and completion routing.

load helpers/setup

setup() {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    create_mock fzf
    create_mock apt-get
    create_mock apt-cache 'echo "vim - Vi IMproved"'
    create_mock dpkg 'printf "vim\tinstall\ngit\tinstall\nold-pkg\tdeinstall\n"'
}

# ── configuration variables ──────────────────────────────────────────

@test "apt preview variable is set to default" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        echo "$PACKAGEMANAGER_FZF_APT_PREVIEW"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt-cache show {}"* ]]
}

# ── alias targets ────────────────────────────────────────────────────

@test "aip alias points to __fpm_apt_install" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        __fpm_apt_setup
        alias aip
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_apt_install"* ]]
}

@test "arp alias points to __fpm_apt_remove" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        __fpm_apt_setup
        alias arp
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_apt_remove"* ]]
}

# ── apt completion routing ───────────────────────────────────────────

@test "apt completion routes 'apt install' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt "apt install vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt install"* ]]
    [[ "$output" == *"apt-cache show {}"* ]]
}

@test "apt completion routes 'apt remove' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt "apt remove vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt remove"* ]]
}

@test "apt completion routes 'apt purge' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt "apt purge vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt purge"* ]]
    [[ "$output" == *"apt-cache show {}"* ]]
}

@test "apt completion routes 'apt reinstall' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt "apt reinstall vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt reinstall"* ]]
    [[ "$output" == *"apt-cache show {}"* ]]
}

@test "apt completion falls back for unknown subcommand" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "SHOULD_NOT_BE_CALLED" }
        zle() { echo "ZLE_FALLBACK: $*" }
        fzf_default_completion="expand-or-complete"
        _fzf_complete_apt "apt update"
    '
    [ "$status" -eq 0 ]
    [[ "$output" != *"SHOULD_NOT_BE_CALLED"* ]]
}

# ── apt-get completion routing ───────────────────────────────────────

@test "apt-get completion routes 'apt-get install' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt-get "apt-get install vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt-get install"* ]]
    [[ "$output" == *"apt-cache show {}"* ]]
}

@test "apt-get completion routes 'apt-get remove' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt-get "apt-get remove vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt-get remove"* ]]
}

@test "apt-get completion routes 'apt-get purge' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/apt.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_apt-get "apt-get purge vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"apt-get purge"* ]]
    [[ "$output" == *"apt-cache show {}"* ]]
}
