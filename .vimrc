call plug#begin('~/.vim/plugged')

Plug 'edkolev/tmuxline.vim'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'gosukiwi/vim-atom-dark'
Plug 'rafi/awesome-vim-colorschemes'

call plug#end()

let g:indentLine_char = '⎸'
let g:indentLine_enabled = 0
nnoremap <F6> :IndentLinesToggle<CR>

nnoremap <F3> :TagbarToggle<CR>

nnoremap <F5> :UndotreeToggle<CR>

map <F2> :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = ' ▸'
let g:NERDTreeDirArrowCollapsible = ' ▾'

let g:airline_theme='iceberg'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enbaled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:gruvbox_contrast_dark = 'medium'

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] } 

" To force myself not to use arrow keys ;)
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>


inoremap {<cr> {<cr>}<c-o><s-o>
inoremap [<cr> [<cr>]<c-o><s-o>
inoremap (<cr> (<cr>)<c-o><s-o>

" Change the mapleader from \ to ,
let mapleader=","

" Easier movement
noremap K {
noremap J }
noremap H ^
noremap L $

" It clears the search buffer when you press <leader>/
nmap <silent> <leader>/ :nohlsearch<CR>

" Quicly close a file with <leader>q
noremap <leader>q :q<cr>

" Quicly save a file with <leader>s
noremap <leader>s :w<cr>

" Quickly get out of inserted mode without having to leave home row
inoremap jk <Esc>

" Reset options when re-sourcing vim
set nocompatible 

" Toggle to paste mode to stop cascading indents
set pastetoggle=<F4>

" Hide buffers instead of closing them
set hidden

" Display file name in window title bar
" set title 

" Get rid of the default mode indicator
set noshowmode

" Automatically reload files changed outside of vim
set autoread

" New splits open to right and bottom
set splitbelow
set splitright

" Set default encoding
set encoding=utf-8

"Allow backspacing over anything in insert mode
set backspace=indent,eol,start

" Use tabs instead of spaces
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Set how many lines of history vim has to remember
set history=10000

" Wrap text to new line
set wrap

" Auto indent
set ai

" Smart indent
set si

" Turn magic on for regular expressions
set magic

set relativenumber
set number

" Turn on left padding by 4 
set numberwidth=4

" Show file stats
set ruler

" Enable mouse support
set mouse=a

" Turn on wild menu 
set wildmenu

" Redraw only when we need to
set lazyredraw

" No annoying sound on errors
set noerrorbells
set novisualbell

" Highlight matching brace
" set showmatch

" Highlight all search results
set hlsearch

" Enable smart-case search
set smartcase

" Always case-insensitive
set ignorecase

" Searches for strings incrementally
set incsearch

" Enable undo file
set undodir=~/.vim/undodir
set undofile
set undolevels=1000

" Turn on backup action
set backup
set backupdir=~/.vim/backup

" Make backup before overwriting the current buffer
set writebackup

" Overwrite the original backup file
set backupcopy=yes

"Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

set termguicolors

colorscheme deep-space
set background=dark
syntax on

set t_Co=256

hi CursorLine cterm=NONE ctermbg=Gray ctermfg=DarkGray guibg=NONE guifg=NONE
set nocursorline


