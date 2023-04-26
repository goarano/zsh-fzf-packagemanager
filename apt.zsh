PACKAGEMANAGER_FZF_APT_PREVIEW='apt-cache show {}'

###########################
# fzf completion bindings #
###########################

function _fzf_complete_apt() {
    local arguments=$@

    if [[ $arguments == 'apt install'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_APT_PREVIEW -- "$@" < <(apt-cache search . | cut -d' ' -f1)
    elif [[ $arguments == 'apt remove'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_APT_PREVIEW -- "$@" < <(dpkg --get-selections | cut -f1)
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

function _fzf_complete_apt-get() {
    local arguments=$@

    if [[ $arguments == 'apt-get install'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_APT_PREVIEW -- "$@" < <(apt-cache search . | cut -d' ' -f1)
    elif [[ $arguments == 'apt-get remove'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_APT_PREVIEW -- "$@" < <(dpkg --get-selections | cut -f1)
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

########################
# standalone functions #
########################

function __pmf_apt_install() {
    local packages=("${(@f)$(apt-cache search . | cut -d' ' -f1 | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_APT_PREVIEW)}")

    if [[ "${packages[@]}" ]]; then
        sudo apt-get install "${packages[@]}"
    fi
}

function __pmf_apt_remove() {
    local packages=("${(@f)$(dpkg --get-selections | cut -f1 | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_APT_PREVIEW)}")

    if [[ "${packages[@]}" ]]; then
        sudo apt-get remove "${packages[@]}"
    fi
}

function __pmf_apt_setup() {
    alias aip=__pmf_apt_install
    alias arp=__pmf_apt_remove
}
