# MGarratt / vimrc

This is my .vimrc file, currently targetted at developing Clojure.

## Plugin Management

I am using [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins,
installation is handeled in vimrc directly. `curl` must be installed.

## Installation

Note: There is a bug when first installing where Rainbow Parenthesis will try to
load before Plug has installed it.

### Standalone

To install standalone (without git) download `.vimrc` to your home directory and
open vim.

### Git

To install via git clone this repository to a location of your choosing, ensure
`install.sh` is executable and run it. The script will fail if a `.vimrc` file
is already present, but will overwrite vim-plug with the latest version.

```bash
git clone https://github.com/mgarratt/vimrc.git
cd vimrc
chmod +x install.sh
./install.sh
```

## Quick Reference

[NERDTree]: https://github.com/scrooloose/nerdtree
[fzf]: https://github.com/junegunn/fzf.vim
[Supertab]: https://github.com/ervandew/supertab

| Binding | Mode | Action                | Plugin       |
|---------|------|-----------------------|--------------|
| <C-n>   | *    | Open/Close NERDTree   | [NERDTree][] |
| <C-p>   | *    | Open fzf              | [fzf][]      |
| <Tab>   | i    | Supertab              | [Supertab][] |

TODO: Complete this list.
