PACKAGEMANAGER_FZF_DNF_PREVIEW='dnf -C --nogpgcheck info {}'

###########################
# fzf completion bindings #
###########################

function _fzf_complete_dnf() {
    local arguments=$@

    if [[ $arguments == 'dnf install'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_DNF_PREVIEW -- "$@" < <(dnf list -q --cacheonly --nogpgcheck --available | tail -n +2 | cut -d' ' -f1)
    elif [[ $arguments == 'dnf remove'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_DNF_PREVIEW -- "$@" < <(dnf list -q --cacheonly --nogpgcheck --installed | tail -n +2 | cut -d' ' -f1)
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

########################
# standalone functions #
########################

function __pmf_dnf_install() {
    local packages=("${(@f)$(dnf list -q --cacheonly --nogpgcheck --available | tail -n +2 | cut -d' ' -f1 | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_DNF_PREVIEW)}")

    if [[ "${packages[@]}" ]]; then
        sudo dnf install "${packages[@]}"
    fi
}

function __pmf_dnf_remove() {
    local packages=("${(@f)$(dnf list -q --cacheonly --nogpgcheck --installed | tail -n +2 | cut -d' ' -f1 | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_DNF_PREVIEW)}")

    if [[ "${packages[@]}" ]]; then
        sudo dnf remove "${packages[@]}"
    fi
}

function __pmf_dnf_setup() {
    alias dip=__pmf_dnf_install
    alias drp=__pmf_dnf_remove
}
