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


## Installation

You need to have [fzf](https://github.com/junegunn/fzf) installed.

### Antidote
```
antidote install goarano/zsh-packagemanager-fzf
```

### Zgen
```
zgen load goarano/zsh-packagemanager-fzf
```

### Antigen
```
antigen bundle goarano/zsh-packagemanager-fzf
```

## Credits

♥ Kudos to @jungeunn for developing [fzf](https://github.com/junegunn/fzf).

♥ This plugin was inspired by [fzf-brew](https://github.com/thirteen37/fzf-brew).
