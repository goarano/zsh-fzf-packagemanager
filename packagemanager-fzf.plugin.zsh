if ! [ $commands[fzf] ]; then
    echo 'zsh-fzf-packagemanager: fzf command not found, please install https://github.com/junegunn/fzf' >&2
else
    if [ $commands[apt-get] ]; then
        source "$(dirname $0)/apt.zsh"
        __pmf_apt_setup
        unfunction __pmf_apt_setup
    fi
    if [ $commands[brew] ]; then
        source "$(dirname $0)/brew.zsh"
        __pmf_brew_setup
        unfunction __pmf_brew_setup
    fi
    if [ $commands[dnf] ]; then
        source "$(dirname $0)/dnf.zsh"
        __pmf_dnf_setup
        unfunction __pmf_dnf_setup
    fi
fi
