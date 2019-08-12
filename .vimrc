" Fold at marker, open with all folds closed
" vim:fdm=marker fdl=0

" Plugins {{{
" Install Vim-Plug if it's missing
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                 \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-dispatch' " Allow async tasks, dependency of many plugins

" Visual
Plug 'altercation/vim-colors-solarized' " Solarized theme
Plug 'nathanaelkane/vim-indent-guides'  " Alternate indent background colours
Plug 'airblade/vim-gitgutter'           " Display modified git lines
Plug 'ap/vim-css-color'                 " Show colours in CSS files
Plug 'vim-airline/vim-airline'          " Status bar
Plug 'vim-airline/vim-airline-themes'   " Themes for status bar
Plug 'edkolev/tmuxline.vim'             " Export status bar theme to tmux

" Navigation
Plug 'benmills/vimux'                 " Send commands to tmux from vim
Plug 'christoomey/vim-tmux-navigator' " Integrate window movement with tmux
Plug 'scrooloose/nerdtree'            " Tree-style file browser
Plug 'Xuyuanp/nerdtree-git-plugin'    " Git status in NERDTree
Plug 'unblevable/quick-scope'         " Highlight nearest unique letters
Plug '/usr/local/opt/fzf'             " File fuzzy search
Plug 'junegunn/fzf.vim'               " Additional fuzzy searching

" General coding
Plug 'ervandew/supertab'  " Tab completion
Plug 'dense-analysis/ale' " Linting

" Lisp
Plug 'guns/vim-sexp'                              " S-Expression editing (paredit alternative)
Plug 'tpope/vim-sexp-mappings-for-regular-people' " Better mappings for sexp
Plug 'eraserhd/parinfer-rust', {'do':
     \  'cargo build --release'}                  " Automatically adjust parens using indenting
Plug 'kien/rainbow_parentheses.vim'               " Highlight ()[]{}<> in rainbow colours
Plug 'tpope/vim-surround'                         " Modify surrounding pairs

" Clojure
Plug 'tpope/vim-fireplace'     " Integration with Clojure REPL
Plug 'clojure-vim/vim-jack-in' " Run Leiningen from Vim (requires vim-dispatch)

call plug#end()
" }}}

" Base Vim {{{
set encoding=utf-8
set nocompatible      " Enable Vi Improved features
set modeline          " Enable modelines in files
set modelines=5       " Read modelines from first or last 5 lines
set number            " Enable line numbers
set showcmd           " Show key press / visual line count
set showmode          " Display current mode
set ruler             " Display current line/column
set incsearch         " Display search results as they're typed
set hidden            " Enable leaving a buffer without saving
set background=dark   " Use colours suitable for dark backgrounds
set ignorecase        " Case insensitive search
set smartcase         " Search case sensitive if term has capital
set autoindent        " Indent newlines
set cindent           " Indent to C rules
set tabstop=4         " Tab width is 4 spaces
set shiftwidth=0      " Use tabstop for indent size
set expandtab         " Tab key inserts spaces (C-v<Tab> for literal tab)
set foldmethod=syntax " Use syntax definitions to fold
set foldlevelstart=99 " Essentially do not fold on file open
set switchbuf=usetab  " Switch to open windows/tabs
set laststatus=2      " Always show status line
set matchpairs+=<:>   " Add <> to bracket pairs
set list listchars=tab:>-,trail:·,extends:> " Visible tabs and trailing spaces
syntax enable         " Syntax highlighting

" Highlight 80 & 120 characters
highlight ColorColumn ctermbg=16
call matchadd('ColorColumn', '\%81v', 100)
call matchadd('ColorColumn', '\%121v', 100)
" }}}

" Solarized {{{
silent! colorscheme solarized " Set colourscheme - silent! prevents errors on PlugInstall
" }}}

" Indent Guildelines {{{
let g:indent_guides_auto_colors = 0                           " Use defined colours below
let g:indent_guides_enable_on_vim_startup = 1                 " Always enable
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=0 " Dark
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=8 " Light
" }}}

" Airline {{{
let g:airline_powerline_fonts=1            " Fancy arrow icons
let g:airline_theme='solarized'            " Visual theme match editor theme
let g:airline_solarized_normal_green=1     " Keep mode colours
let g:airline#extensions#tabline#enabled=1 " Display tab line at top of screen
" }}}

" ViMux {{{
map <Leader>vp :VimuxPromptCommand<CR>   " Command prompt for tmux pane
map <Leader>vl :VimuxRunLastCommand<CR>  " Rerun last command in tmux pane
map <Leader>vi :VimuxInspectRunner<CR>   " Change focus to tmux pane
map <Leader>vz :VimuxZoomRunner<CR>      " Change focus and zoom tmux pane
map <Leader>vq :VimuxCloseRunner<CR>     " Close tmux pane
map <Leader>vx :VimuxInterruptRunner<CR> " Send interrupt to tmux pane
" }}}

" Tmux Navigator {{{
let g:tmux_navigator_save_on_switch=2 " Save when moving from Vim to Tmux
" }}}

" NERDTree {{{
map <C-n> :NERDTreeToggle<CR>
" Quit if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" FZF {{{
noremap <C-p> :Files<CR>        " Mimic Ctrl-P mapping with fzf
nnoremap <Leader>a :Ag!<Space>  " Search across all files
nnoremap <Leader>/ :BLines<CR>  " Search open files
nnoremap <Leader>b :Buffers<CR> " List open buffers
" }}}

" ALE {{{
let g:ale_completion_enabled=0          " Completion is handled by SuperTab
let g:ale_set_highlights=0              " Don't hightlight errors
let g:ale_lint_on_text_changed='always' " Run linting whenever something changes
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'clojure': ['joker','clj-kondo'],
\   'JSON': ['jq'],
\   'ruby': ['ruby'],
\   'SQL': ['sqlint']
\}                                      " Linters to run by filetype
" }}}

" Rainbow Parentheses {{{
au VimEnter * RainbowParenthesesActivate   " Activate on start up
au Syntax * RainbowParenthesesLoadRound    " Enable ()
au Syntax * RainbowParenthesesLoadSquare   " Enable []
au Syntax * RainbowParenthesesLoadBraces   " Enable {}
au Syntax * RainbowParenthesesLoadChevrons " Enable <>
" }}}
