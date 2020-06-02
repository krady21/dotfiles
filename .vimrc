call plug#begin('~/.vim/plugged')

" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'Nequo/vim-allomancer'
Plug 'altercation/vim-colors-solarized'
Plug 'arcticicestudio/nord-vim'
Plug 'bfrg/vim-cpp-modern'
Plug 'dense-analysis/ale'
Plug 'glts/vim-magnum'
Plug 'glts/vim-radical'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'osyo-manga/vim-over'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tmsvg/pear-tree'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'ycm-core/YouCompleteMe'
Plug 'yggdroot/indentline'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

call plug#end()

" Enable built-in matchit plugin (% for if/else and tags)
runtime macros/matchit.vim

" Change the mapleader from \ to ,
let mapleader=","

let g:pear_tree_repeatable_expand = 0

nnoremap <F6> :IndentLinesToggle<CR>
let g:indentLine_fileTypeExclude = ['text', 'json', 'markdown', 'xml']
let g:indentLine_char = '⎸'
let g:indentLine_enabled = 1

nnoremap <F3> :TagbarToggle<CR>

nnoremap <F4> :UndotreeToggle<CR>

map <F2> :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = ' ▸'
let g:NERDTreeDirArrowCollapsible = ' ▾'

map <leader>a :ALEToggle<CR>
let g:ale_enabled = 0

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
let g:ycm_confirm_extra_conf = 0


" Fzf shortcuts
nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>c :Commits<CR>
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

" Quicly close a file with <leader>q
noremap <leader>q :q<cr>

" Quicly save a file with <leader>s
noremap <leader>w :w<cr>

" Quickly force close a file with <leader>Q
noremap <leader>Q :q!<cr>

" Quicly save and close a file with <leader>S
noremap <leader>wq :wq<cr>

" Quickly get out of inserted mode without having to leave home row
inoremap jj <Esc>

" Shortcuts for buffer navigation
set wildcharm=<Tab>
nnoremap <Leader><Tab> :buffer<Space><Tab>

" Buffer mappings
noremap <leader><leader> :bn<cr>
noremap <leader>d :bd<cr>
noremap <leader>ls :ls<cr>

" Disabled for security reasons
" https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme
set nomodeline

" Reset options when re-sourcing vim
set nocompatible

" Toggle to paste mode to stop cascading indents
set pastetoggle=<F5>

" Hide buffers instead of closing them
set hidden

" Change directory automatically when opening or switching buffers
set autochdir

" Get rid of the default mode indicator if using airline
" set noshowmode

" Automatically reload files changed outside of vim
set autoread

" Update time for signify
set updatetime=100

" Fix slow O inserts (be careful over slow connections)
set timeout
set timeoutlen=1000
set ttimeoutlen=100

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

" Allows moving the cursor after the last character
set virtualedit+=onemore

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

" Open vimdiff splits vertically. TODO: test preffered context nr.
set diffopt=vertical,filler,context:3,iwhite

" Enable undo file
set undodir=~/.vim/undodir
set undofile
set undolevels=1000

" Don't create backups for certain files
if has('wildignore')
    set backupskip=/tmp/*
    set backupskip+=/private/tmp/*
endif

" Ignore files for completion
set wildignore+=*/.git/*,*/tmp/*,*~,*.swp,*.o,*.obj,*.class

" Turn on backup action
set backup
set backupdir=~/.vim/backup

" Make backup before overwriting the current buffer
set writebackup

" Overwrite the original backup file
set backupcopy=yes

" Disable cursorline
set nocursorline

" Toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" Strips trailing whitespace and saves cursor position
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

nnoremap <leader>t :call ToggleNumber()<CR>
nnoremap <leader>s :call <SID>StripTrailingWhitespaces()<CR>

" Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Automatically resize vim splits
autocmd VimResized * wincmd =

set termguicolors

set t_Co=256
" Cool ones: deep-space, Oceanic_next, Hybrid_material, Hybrid_reverse,
" two-firewatch, snow, nord, gruvbox, one, onedark, allomancer
colorscheme gruvbox
set background=dark
syntax on
