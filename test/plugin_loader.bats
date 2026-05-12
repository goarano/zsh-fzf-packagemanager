#!/usr/bin/env bats

# Tests for zsh-fzf-packagemanager.plugin.zsh — the main plugin loader.

load helpers/setup

# ── fzf dependency check ─────────────────────────────────────────────

@test "plugin fails with error when fzf is not in PATH" {
    # No mocks at all — fzf is not on the mock PATH.
    run_zsh 'source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh" 2>&1'
    [ "$status" -ne 0 ]
    [[ "$output" == *"fzf not found"* ]]
}

@test "plugin loads successfully when fzf is present" {
    create_mock fzf
    run_zsh 'source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"'
    [ "$status" -eq 0 ]
}

# ── brew detection & aliases ─────────────────────────────────────────

@test "brew aliases are registered when brew is available" {
    create_mock fzf
    create_mock brew
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias bip && alias bup && alias bcip && alias bcup
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_brew_install"* ]]
    [[ "$output" == *"__fpm_brew_uninstall"* ]]
    [[ "$output" == *"__fpm_brew_cask_install"* ]]
    [[ "$output" == *"__fpm_brew_cask_uninstall"* ]]
}

@test "brew aliases are not registered when brew is absent" {
    create_mock fzf
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias bip 2>&1
    '
    [ "$status" -ne 0 ]
}

# ── apt detection & aliases ──────────────────────────────────────────

@test "apt aliases are registered when apt-get is available" {
    create_mock fzf
    create_mock apt-get
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias aip && alias arp
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_apt_install"* ]]
    [[ "$output" == *"__fpm_apt_remove"* ]]
}

@test "apt aliases are not registered when apt-get is absent" {
    create_mock fzf
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias aip 2>&1
    '
    [ "$status" -ne 0 ]
}

# ── dnf detection & aliases ──────────────────────────────────────────

@test "dnf aliases are registered when dnf is available" {
    create_mock fzf
    create_mock dnf
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias dip && alias drp
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"__fpm_dnf_install"* ]]
    [[ "$output" == *"__fpm_dnf_remove"* ]]
}

@test "dnf aliases are not registered when dnf is absent" {
    create_mock fzf
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias dip 2>&1
    '
    [ "$status" -ne 0 ]
}

# ── multiple package managers ────────────────────────────────────────

@test "all aliases registered when multiple package managers are available" {
    create_mock fzf
    create_mock brew
    create_mock apt-get
    create_mock dnf
    run_zsh '
        source "$PLUGIN_DIR/zsh-fzf-packagemanager.plugin.zsh"
        alias bip && alias bup && alias bcip && alias bcup &&
        alias aip && alias arp &&
        alias dip && alias drp
    '
    [ "$status" -eq 0 ]
}
