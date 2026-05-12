# zsh-fzf-packagemanager

Adds commands for installing tools via various package managers using [fzf](https://github.com/junegunn/fzf).

Supports the following package managers:

* brew
* apt
* dnf

## Usage

This package adds interactive aliases for installing packages using various package managers.
Alternatively to using them you can also take advantage of the [fzf completion feature](https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh), e.g. by typing `apt install git**` and pressing `<TAB>` to complete the argument using fzf.

### apt

The following aliases are available:

* `aip` apt install package
* `arp` apt remove package

### brew

The following aliases are available:

* `bip` brew install package
* `bup` brew uninstall package
* `bcip` brew --cask install package
* `bcup` brew --cask uninstall package

### dnf

The following aliases are available:

* `dip` dnf install package
* `drp` dnf remove package


## Configuration

The fzf preview command and keybindings can be customized by setting the following variables **after** the plugin is loaded:

| Variable | Default | Description |
|---|---|---|
| `PACKAGEMANAGER_FZF_APT_PREVIEW` | `apt-cache show {}` | Preview command for apt packages |
| `PACKAGEMANAGER_FZF_DNF_PREVIEW` | `dnf -C --nogpgcheck info {}` | Preview command for dnf packages |
| `PACKAGEMANAGER_FZF_BREW_PREVIEW` | `HOMEBREW_COLOR=true brew info {}` | Preview command for brew formulae |
| `PACKAGEMANAGER_FZF_BREW_BIND` | `ctrl-x:execute-silent(brew home {})` | Keybinding for brew formulae |
| `PACKAGEMANAGER_FZF_BREW_CASK_PREVIEW` | `HOMEBREW_COLOR=true brew info --cask {}` | Preview command for brew casks |
| `PACKAGEMANAGER_FZF_BREW_CASK_BIND` | `ctrl-x:execute-silent(brew home --cask {})` | Keybinding for brew casks |

## Installation

You need to have [fzf](https://github.com/junegunn/fzf) installed.

### Antidote
```
antidote install goarano/zsh-fzf-packagemanager
```

### Zgen
```
zgen load goarano/zsh-fzf-packagemanager
```

### Antigen
```
antigen bundle goarano/zsh-fzf-packagemanager
```

## Credits

♥ Kudos to @junegunn for developing [fzf](https://github.com/junegunn/fzf).

♥ This plugin was inspired by [fzf-brew](https://github.com/thirteen37/fzf-brew).
