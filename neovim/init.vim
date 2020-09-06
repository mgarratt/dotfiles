" Fold at marker, open with all folds closed
" vim:fdm=marker fdl=0

" Plugins {{{

call plug#begin(stdpath('data') . '/plugged')

" Visual
Plug 'nathanaelkane/vim-indent-guides'  " Alternate indent background colours
Plug 'qstrahl/vim-matchmaker'           " Highlight matches for the word under the cursor

" Theme
Plug 'arcticicestudio/nord-vim'

" Navigation
Plug 'unblevable/quick-scope'         " Highlight nearest unique letters
Plug 'junegunn/fzf'                   " File fuzzy search
Plug 'junegunn/fzf.vim'               " Additional fuzzy searching

" Vim Skills
Plug 'takac/vim-hardtime' "Prevent using arrows or hjkl for navigation

" General coding
Plug 'dense-analysis/ale' " Linting
Plug 'majutsushi/tagbar'  " Tag bar

" Tmux
Plug 'tmux-plugins/vim-tmux'              " Integration of tmux config files
Plug 'tmux-plugins/vim-tmux-focus-events' " Ensure focus events work inside Vim
Plug 'christoomey/vim-tmux-navigator'     " Easier navigation between tmux and vim

" Lisp
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}

" Clojure
Plug 'tpope/vim-fireplace'     " Integration with Clojure REPL

" Ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'  " Automatically add end to blocks

call plug#end()
" }}}

" Base Vim {{{
set encoding=utf-8
set nocompatible      " Enable Vi Improved features
set modeline          " Enable modelines in files
set modelines=5       " Read modelines from first or last 5 lines
set number            " Enable line numbers
set relativenumber    " Display relative line number for easy movement
set showcmd           " Show key press / visual line count
set showmode          " Display current mode
set ruler             " Display current line/column
set incsearch         " Display search results as they're typed
set hidden            " Enable leaving a buffer without saving
set splitbelow        " Open splits below instead of on top
set splitright        " Open splits to the right instead of left
set background=dark   " Use colours suitable for dark backgrounds
set ignorecase        " Case insensitive search
set smartcase         " Search case sensitive if term has capital
set autoindent        " Indent newlines
set cindent           " Indent to C rules
set tabstop=4         " Tab width is 4 spaces
set shiftwidth=0      " Use tabstop for indent size
set expandtab         " Tab key inserts spaces (C-v<Tab> for literal tab)
set foldmethod=syntax " Use syntax definitions to fold
set nofoldenable      " Do not fold on file open
set switchbuf=usetab  " Switch to open windows/tabs
set laststatus=2      " Always show status line
set ttimeoutlen=10    " Reduce timeout after keypresses
set matchpairs+=<:>   " Add <> to bracket pairs
set list listchars=tab:>-,trail:·,extends:> " Visible tabs and trailing spaces
syntax enable         " Syntax highlighting
let g:clojure_fold=1  " Syntax based clojure folding
let g:clojure_align_multiline_strings=1 " Align to the text not the quote
set tags+=.git/tags   " Location of tags file to go with git hooks
set diffopt+=algorithm:patience,indent-heuristic
set signcolumn=yes    " Always show the gutter
highlight clear SignColumn " Do not colour the 'Gutter'
set wildmenu          " Command line autocompletion
set wildmode=list:longest,full
set completeopt=longest,menuone " Autocomplete menu insert longest item, display menu if only one item

filetype plugin on
set omnifunc=syntaxcomplete#Complete

colorscheme nord

" Highlight 80 & 120 characters
highlight ColorColumn ctermbg=16
call matchadd('ColorColumn', '\%80v', 100)
call matchadd('ColorColumn', '\%120v', 100)
" }}}

" Indent Guildelines {{{
let g:indent_guides_auto_colors = 0                            " Use defined colours below
let g:indent_guides_enable_on_vim_startup = 1                  " Always enable
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=Black    ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=DarkGrey ctermbg=8
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=0  " Dark
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=0 " Light
" }}}

" Matchmaker {{{
let g:matchmaker_enable_startup = 1
" }}}

" FZF {{{
" ctags compatibility with git hooks
let g:fzf_tags_command = 'ctags -f .git/tags -R'
" Open a file
noremap <Leader>f :Files<CR>
" Search across all files
nnoremap <Leader>a :Ag!<Space>
" Search open files
nnoremap <Leader>/ :BLines<CR>
" List open buffers
nnoremap <Leader>b :Buffers<CR>
" Search vim commands
nnoremap <Leader>: :Commands<CR>
" Search tags
nnoremap <Leader>t :Tags<CR>
" }}}

" ALE {{{
let g:ale_completion_enabled=0          " Completion is handled by vim
let g:ale_set_highlights=0              " Don't hightlight errors
let g:ale_lint_on_text_changed='always' " Run linting whenever something changes
"let g:ale_linters = {
"\   'javascript': ['eslint'],
"\   'clojure': ['joker','clj-kondo'],
"\   'JSON': ['jq'],
"\   'ruby': ['ruby'],
"\   'SQL': ['sqlint']
"\}                                      " Linters to run by filetype
" }}}

" Custom mappings {{{
" Close the current buffer, but keep the pane
nnoremap <Leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
" Save
nnoremap <Leader>s :w<CR>
" }}}
