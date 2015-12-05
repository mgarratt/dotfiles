" vim:fdm=marker fdl=0
set nocompatible
set modeline
set modelines=5

" Spell check
"set spell spelllang=en_gb

" Vim-Plug {{{
call plug#begin('~/.vim/plugged')

Plug 'nathanaelkane/vim-indent-guides'
Plug 'StanAngeloff/php.vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'ervandew/supertab'
Plug 'craigemery/vim-autotag'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'joonty/vdebug'
Plug 'tomasr/molokai'
Plug 'ap/vim-css-color'

call plug#end()
" }}}

" GUI {{{
set nu
set showcmd
set showmode
set ruler
set incsearch
set hidden
set background=dark
colorscheme molokai
let g:rehash256 = 1
" }}}

" Indenting {{{
set autoindent
set cindent
set shiftwidth=4
set tabstop=4
set expandtab

let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
" }}}

" Folding {{{
set foldmethod=indent
set foldlevelstart=99
" }}}

" NERDTree {{{
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" Tabs {{{
set switchbuf=usetab,newtab
nnoremap <F8> :bnext<CR>
nnoremap <S-F8> :bprevious<CR>
" }}}

" Statusbar {{{
set laststatus=2
set timeoutlen=50
let g:airline#extensions#tabline#enabled = 1
" }}}

" Syntax {{{
syntax enable
set list listchars=tab:>-,trail:·,extends:>
set mps+=<:>
" }}}

" PHP Linting {{{
let g:syntastic_php_phpcs_args='--standard=PSR2'
" }}}

" PHP Syntax {{{
set tags=./tags;/
function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
    autocmd!
    autocmd FileType php call PhpSyntaxOverride()
augroup END
" }}}
