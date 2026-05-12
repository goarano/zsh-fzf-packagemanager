#!/usr/bin/env zsh

if (( ! $+commands[fzf] )); then
    echo "zsh-fzf-packagemanager: fzf not found in PATH. Plugin not loaded." >&2
    return 1
fi

if [ $commands[apt-get] ]; then
    source "$(dirname $0)/apt.zsh"
    __fpm_apt_setup
    unfunction __fpm_apt_setup
fi

if [ $commands[brew] ]; then
    source "$(dirname $0)/brew.zsh"
    __fpm_brew_setup
    unfunction __fpm_brew_setup
fi

if [ $commands[dnf] ]; then
    source "$(dirname $0)/dnf.zsh"
    __fpm_dnf_setup
    unfunction __fpm_dnf_setup
fi
