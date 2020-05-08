call plug#begin('~/.vim/plugged')

" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'edkolev/tmuxline.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'tmsvg/pear-tree'
Plug 'yggdroot/indentline'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-characterize'
Plug 'andrewradev/splitjoin.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'osyo-manga/vim-over'
Plug 'mbbill/undotree'
Plug 'majutsushi/tagbar'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'rafi/awesome-vim-colorschemes'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
" Update time for signify
set updatetime=100

call plug#end()

" Change the mapleader from \ to ,
let mapleader=","

let g:pear_tree_repeatable_expand = 0

let g:indentLine_fileTypeExclude = ['text', 'json', 'markdown', 'xml']
let g:indentLine_char = '⎸'
let g:indentLine_enabled = 1
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

" Cool theme iceberg, alduin, one
" let g:airline_theme='gruvbox'
" let g:airline_powerline_fonts = 1
" let g:airline_skip_empty_sections = 1
" let g:airline#extensions#tabline#enbaled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline_highlighting_cache = 1

" Hide >> sign
let g:ycm_clangd_binary_path = "/home/boco/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/"
let g:ycm_show_diagnostics_ui = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

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

" Fzf shortcuts
nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>c :Commits<CR>

" Avoid unintentional switches to Ex mode
nnoremap Q q
nnoremap q <Nop>

" Make Y behave like C and D
noremap Y y$

" To force myself not to use arrow keys ;)
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Quick window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Easier movement
noremap K {
noremap J }
noremap H ^
noremap L $

" Shortcuts for buffer navigation
" It used to be n and p, but m is right next to ,
noremap <leader>m :bn<cr>
noremap <leader>M :bp<cr>
noremap <leader>d :bd<cr>

" It clears the search buffer when you press <leader>/
" nmap <silent> <leader>/ :nohlsearch<CR>

" Quicly close a file with <leader>q
noremap <leader>q :q<cr>

" Quicly save a file with <leader>s
noremap <leader>s :w<cr>

" Quickly force close a file with <leader>Q
noremap <leader>Q :q!<cr>

" Quicly save and close a file with <leader>S
noremap <leader>S :wq<cr>

" Quickly get out of inserted mode without having to leave home row
inoremap jj <Esc>

set wildcharm=<Tab>
nnoremap <Leader><Tab> :buffer<Space><Tab>

" Disabled for security reasons
" https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme
set nomodeline

" Reset options when re-sourcing vim
set nocompatible 

" Toggle to paste mode to stop cascading indents
set pastetoggle=<F4>

" When scrolling, keep the cursor 4 lines below the top and 4 lines above the
" bottom of the screen
" set scrolloff=4

" Hide buffers instead of closing them
set hidden

" Display file name in window title bar
" set title 

" Get rid of the default mode indicator
" set noshowmode

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

" Keep indentation when wrapping
set breakindent

" Bent arrow glyph for wrapped lines
set showbreak=↳

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
" set mouse=a

" Turn on wild menu 
set wildmenu

" Redraw only when we need to
set lazyredraw

" No annoying sound on errors
set noerrorbells
set novisualbell

" Highlight matching brace
" set showmatch

" Do not highlight search results
set nohlsearch

" Enable smart-case search
set smartcase

" Always case-insensitive
" set infercase might be an alternative
set ignorecase

" Searches for strings incrementally
set incsearch

" Enable undo file
set undodir=~/.vim/undodir
set undofile
set undolevels=1000

" Don't create backups for certain files
if has('wildignore')
    set backupskip=/tmp/*
    set backupskip+=/private/tmp/*
endif

" Turn on backup action
set backup
set backupdir=~/.vim/backup

" Make backup before overwriting the current buffer
set writebackup

" Overwrite the original backup file
set backupcopy=yes

" Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Automatically resize vim splits
autocmd VimResized * wincmd =

set termguicolors

" Cool ones: deep-space, Oceanic_next, Hybrid_material, Hybrid_reverse,
" two-firewatch, snow, nord, gruvbox
colorscheme gruvbox
set background=dark
syntax on

set t_Co=256

hi CursorLine cterm=NONE ctermbg=Gray ctermfg=DarkGray guibg=NONE guifg=NONE
set nocursorline

