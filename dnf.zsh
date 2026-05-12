PACKAGEMANAGER_FZF_DNF_PREVIEW='dnf -C --nogpgcheck info {}'

###########################
# fzf completion bindings #
###########################

function _fzf_complete_dnf() {
    local arguments="$@"

    if [[ $arguments == 'dnf install'* ]]; then
        _fzf_complete -m --header="dnf install" --preview "$PACKAGEMANAGER_FZF_DNF_PREVIEW" -- "$@" < <(dnf list -q --cacheonly --nogpgcheck --available | tail -n +2 | cut -d' ' -f1 | grep .)
    elif [[ $arguments == 'dnf reinstall'* ]]; then
        _fzf_complete -m --header="dnf reinstall" --preview "$PACKAGEMANAGER_FZF_DNF_PREVIEW" -- "$@" < <(dnf list -q --cacheonly --nogpgcheck --installed | tail -n +2 | cut -d' ' -f1 | grep .)
    elif [[ $arguments == 'dnf remove'* ]]; then
        _fzf_complete -m --header="dnf remove" --preview "$PACKAGEMANAGER_FZF_DNF_PREVIEW" -- "$@" < <(dnf list -q --cacheonly --nogpgcheck --installed | tail -n +2 | cut -d' ' -f1 | grep .)
    elif [[ $arguments == 'dnf erase'* ]]; then
        _fzf_complete -m --header="dnf erase" --preview "$PACKAGEMANAGER_FZF_DNF_PREVIEW" -- "$@" < <(dnf list -q --cacheonly --nogpgcheck --installed | tail -n +2 | cut -d' ' -f1 | grep .)
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

########################
# standalone functions #
########################

function __fpm_dnf_install() {
    local packages=("${(@f)$(dnf list -q --cacheonly --nogpgcheck --available | tail -n +2 | cut -d' ' -f1 | grep . | fzf --query="$1" -m --header="dnf install" --preview "$PACKAGEMANAGER_FZF_DNF_PREVIEW")}")

    if (( ${#packages} )) && [[ -n "${packages[1]}" ]]; then
        sudo dnf install "${packages[@]}"
    fi
}

function __fpm_dnf_remove() {
    local packages=("${(@f)$(dnf list -q --cacheonly --nogpgcheck --installed | tail -n +2 | cut -d' ' -f1 | grep . | fzf --query="$1" -m --header="dnf remove" --preview "$PACKAGEMANAGER_FZF_DNF_PREVIEW")}")

    if (( ${#packages} )) && [[ -n "${packages[1]}" ]]; then
        sudo dnf remove "${packages[@]}"
    fi
}

function __fpm_dnf_setup() {
    alias dip=__fpm_dnf_install
    alias drp=__fpm_dnf_remove
}
