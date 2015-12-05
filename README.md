This is my .vimrc file, so far I've only been working on it for a week or so and
it's definitely a work in progress.

## Installation

I am using [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins
so installation is as simple as download .vimrc, install vim-plug and run
PlugInstall. This can be done using the following commands.

```Shell
curl -fLo ~/.vimrc  \
    https://raw.githubusercontent.com/mgarratt/vimrc/master/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
```
