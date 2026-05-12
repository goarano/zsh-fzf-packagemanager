PACKAGEMANAGER_FZF_BREW_PREVIEW='HOMEBREW_COLOR=true brew info {}'
PACKAGEMANAGER_FZF_BREW_BIND="ctrl-x:execute-silent(brew home {})"
PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW='HOMEBREW_COLOR=true brew info --cask {}'
PACKAGEMANAGER_FZF_BREW_CASK_BIND="ctrl-x:execute-silent(brew home --cask {})"

###########################
# fzf completion bindings #
###########################

function _fzf_complete_brew() {
    local arguments="$@"

    if [[ $arguments == 'brew install'* ]] && [[ $arguments == *'--cask'* ]]; then
        _fzf_complete -m --header="brew install --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND" -- "$@" < <(brew casks | grep .)
    elif [[ $arguments == 'brew reinstall'* ]] && [[ $arguments == *'--cask'* ]]; then
        _fzf_complete -m --header="brew reinstall --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND" -- "$@" < <(brew list --cask | grep .)
    elif [[ $arguments == 'brew uninstall'* ]] && [[ $arguments == *'--cask'* ]]; then
        _fzf_complete -m --header="brew uninstall --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND" -- "$@" < <(brew list --cask | grep .)
    elif [[ $arguments == 'brew remove'* ]] && [[ $arguments == *'--cask'* ]]; then
        _fzf_complete -m --header="brew remove --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND" -- "$@" < <(brew list --cask | grep .)
    elif [[ $arguments == 'brew rm'* ]] && [[ $arguments == *'--cask'* ]]; then
        _fzf_complete -m --header="brew rm --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND" -- "$@" < <(brew list --cask | grep .)
    elif [[ $arguments == 'brew install'* ]]; then
        _fzf_complete -m --header="brew install" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND" -- "$@" < <(brew formulae | grep .)
    elif [[ $arguments == 'brew reinstall'* ]]; then
        _fzf_complete -m --header="brew reinstall" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND" -- "$@" < <(brew list --formula | grep .)
    elif [[ $arguments == 'brew uninstall'* ]]; then
        _fzf_complete -m --header="brew uninstall" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND" -- "$@" < <(brew leaves | grep .)
    elif [[ $arguments == 'brew remove'* ]]; then
        _fzf_complete -m --header="brew remove" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND" -- "$@" < <(brew leaves | grep .)
    elif [[ $arguments == 'brew rm'* ]]; then
        _fzf_complete -m --header="brew rm" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND" -- "$@" < <(brew leaves | grep .)
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}


########################
# standalone functions #
########################

function __fpm_brew_install() {
    local packages=("${(@f)$( brew formulae | grep . | fzf --query="$1" -m --header="brew install" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND")}")

    if (( ${#packages} )) && [[ -n "${packages[1]}" ]]; then
        brew install "${packages[@]}"
    fi
}

function __fpm_brew_uninstall() {
    local packages=("${(@f)$( brew leaves | grep . | fzf --query="$1" -m --header="brew uninstall" --preview "$PACKAGEMANAGER_FZF_BREW_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_BIND")}")

    if (( ${#packages} )) && [[ -n "${packages[1]}" ]]; then
        brew uninstall "${packages[@]}"
    fi
}

function __fpm_brew_cask_install() {
    local packages=("${(@f)$( brew casks | grep . | fzf --query="$1" -m --header="brew install --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND")}")

    if (( ${#packages} )) && [[ -n "${packages[1]}" ]]; then
        brew install --cask "${packages[@]}"
    fi
}

function __fpm_brew_cask_uninstall() {
    local packages=("${(@f)$( brew list --cask | grep . | fzf --query="$1" -m --header="brew uninstall --cask" --preview "$PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW" --bind "$PACKAGEMANAGER_FZF_BREW_CASK_BIND")}")

    if (( ${#packages} )) && [[ -n "${packages[1]}" ]]; then
        brew uninstall --cask "${packages[@]}"
    fi
}

function __fpm_brew_setup() {
    alias bip=__fpm_brew_install
    alias bup=__fpm_brew_uninstall
    alias bcip=__fpm_brew_cask_install
    alias bcup=__fpm_brew_cask_uninstall
}
