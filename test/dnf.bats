#!/usr/bin/env bats

# Tests for dnf.zsh — configuration, alias targets, and completion routing.

load helpers/setup

setup() {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    create_mock dnf
}

# ── configuration variables ──────────────────────────────────────────

@test "dnf preview variable is set to default" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        echo "$PACKAGEMANAGER_FZF_DNF_PREVIEW"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"dnf -C --nogpgcheck info {}"* ]]
}

# ── alias targets ────────────────────────────────────────────────────

@test "dip alias points to __fpm_dnf_install" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        __fpm_dnf_setup
        alias dip
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_dnf_install"* ]]
}

@test "drp alias points to __fpm_dnf_remove" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        __fpm_dnf_setup
        alias drp
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_dnf_remove"* ]]
}

# ── completion routing ───────────────────────────────────────────────

@test "dnf completion routes 'dnf install' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_dnf "dnf install vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"dnf install"* ]]
    [[ "$output" == *"dnf -C --nogpgcheck info {}"* ]]
}

@test "dnf completion routes 'dnf remove' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_dnf "dnf remove vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"dnf remove"* ]]
}

@test "dnf completion routes 'dnf erase' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_dnf "dnf erase vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"dnf erase"* ]]
    [[ "$output" == *"dnf -C --nogpgcheck info {}"* ]]
}

@test "dnf completion routes 'dnf reinstall' correctly" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        _fzf_complete() { echo "FZF_ARGS: $*" }
        _fzf_complete_dnf "dnf reinstall vim"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"dnf reinstall"* ]]
    [[ "$output" == *"dnf -C --nogpgcheck info {}"* ]]
}

@test "dnf completion falls back for unknown subcommand" {
    run_zsh '
        source "$PLUGIN_DIR/dnf.zsh"
        _fzf_complete() { echo "SHOULD_NOT_BE_CALLED" }
        zle() { echo "ZLE_FALLBACK: $*" }
        fzf_default_completion="expand-or-complete"
        _fzf_complete_dnf "dnf update"
    '
    [ "$status" -eq 0 ]
    [[ "$output" != *"SHOULD_NOT_BE_CALLED"* ]]
}
