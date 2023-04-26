PACKAGEMANAGER_FZF_BREW_PREVIEW='HOMEBREW_COLOR=true brew info {}'
PACKAGEMANAGER_FZF_BREW_BIND="ctrl-x:execute-silent(brew home {})"
PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW='HOMEBREW_COLOR=true brew info --cask {}'
PACKAGEMANAGER_FZF_BREW_CASK_BIND="ctrl-x:execute-silent(brew home --cask {})"

###########################
# fzf completion bindings #
###########################

function _fzf_complete_brew() {
    local arguments=$@

    if [[ $arguments == 'brew install'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_BREW_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_BIND -- "$@" < <(brew formulae)
    elif [[ $arguments == 'brew uninstall'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_BREW_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_BIND -- "$@" < <(brew leaves)
    elif [[ $arguments == 'brew install --cask'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_CASK_BIND -- "$@" < <(brew casks)
    elif [[ $arguments == 'brew uninstall --cask'* ]]; then
        _fzf_complete -m --preview $PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_CASK_BIND -- "$@" < <(brew list --cask)
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}


########################
# standalone functions #
########################

function __pmf_brew_install() {
    local packages=("${(@f)$( brew formulae | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_BREW_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_BIND)}")

    if [[ "${packages[@]}" ]]; then
        for package in "${packages[@]}"; do
            brew install "$package"
        done
    fi
}

function __pmf_brew_uninstall() {
    local packages=("${(@f)$( brew leaves | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_BREW_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_BIND)}")

    if [[ "${packages[@]}" ]]; then
        for package in "${packages[@]}"; do
            brew uninstall "$package"
        done
    fi
}

function __pmf_brew_cask_install() {
    local packages=("${(@f)$( brew casks | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_CASK_BIND)}")

    if [[ "${packages[@]}" ]]; then
        for package in "${packages[@]}"; do
            brew install --cask "$package"
        done
    fi
}

function __pmf_brew_cask_uninstall() {
    local packages=("${(@f)$( brew list --cask | fzf --query="$1" -m --preview $PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW --bind $PACKAGEMANAGER_FZF_BREW_CASK_BIND)}")

    if [[ "${packages[@]}" ]]; then
        for package in "${packages[@]}"; do
            brew uninstall --cask "$package"
        done
    fi
}

function __pmf_brew_setup() {
    alias bip=__pmf_brew_install
    alias bup=__pmf_brew_uninstall
    alias bcip=__pmf_brew_cask_install
    alias bcup=__pmf_brew_cask_uninstall
}
