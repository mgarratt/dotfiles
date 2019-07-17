# MGarratt / vimrc

This is my .vimrc file, it adds functionality to Vim without adding any language
specific plugins.

## Plugin Management

I am using [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins,
installation is handeled in the [Installation](#Installation) section of this
document;

## Installation

### Standalone

To install standalone (without git) download `.vimrc` to your home directory,
then install vim-plug by downloading `plug.vim` to `~/.vim/autoload/`. Once
these files are in place run vim with flags to install all plugins and exit as
below:

```bash
curl -fLo ~/.vimrc  \
    https://raw.githubusercontent.com/mgarratt/vimrc/master/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
```

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
