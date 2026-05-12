#!/usr/bin/env bash

# Shared test helpers for zsh-fzf-packagemanager bats tests.
#
# Usage: add `load helpers/setup` at the top of each .bats file.

# Absolute path to the plugin repository root.
PLUGIN_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

# ── helpers ──────────────────────────────────────────────────────────

# create_mock <name>
#   Creates an executable no-op script in $BATS_TEST_TMPDIR/bin/.
#   The mock simply exits 0 unless overridden.
create_mock() {
    local name="$1"
    local body="${2:-exit 0}"
    printf '#!/bin/sh\n%s\n' "$body" > "$BATS_TEST_TMPDIR/bin/$name"
    chmod +x "$BATS_TEST_TMPDIR/bin/$name"
}

# mock_path
#   Returns a PATH with only the mock bin dir and essential system dirs.
#   This ensures tests don't accidentally pick up real brew/apt/dnf.
mock_path() {
    echo "$BATS_TEST_TMPDIR/bin:/usr/bin:/bin:/usr/sbin:/sbin"
}

# run_zsh <script>
#   Runs a zsh script string in a clean environment with the mock PATH.
#   The plugin directory is passed so scripts can source plugin files.
run_zsh() {
    run zsh -f -c "
        export PATH=\"$(mock_path)\"
        export PLUGIN_DIR=\"$PLUGIN_DIR\"
        $1
    "
}

# ── lifecycle ────────────────────────────────────────────────────────

setup() {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
}
