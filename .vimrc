call plug#begin('~/.vim/plugged')

Plug 'bfrg/vim-cpp-modern'
Plug 'dense-analysis/ale'
Plug 'el-iot/buffer-tree'
Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'ycm-core/YouCompleteMe'
Plug 'yggdroot/indentline'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

call plug#end()

" Disable matchit
let g:loaded_matchit = 1

" Disable netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Change the mapleader from \ to ,
let mapleader=","

let g:pear_tree_repeatable_expand = 0

let g:buffertree_compress = 1

nnoremap <F6> :IndentLinesToggle<CR>
let g:indentLine_fileTypeExclude = ['text', 'json', 'markdown', 'xml']
let g:indentLine_faster = 1
let g:indentLine_char = '⎸'
let g:indentLine_enabled = 1

nnoremap <F3> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1

nnoremap <F4> :UndotreeToggle<CR>

map <leader>at :ALEToggle<CR>
map <leader>ad :ALEDetail<CR>
let g:ale_enabled = 0

noremap <leader>r :Rg<CR>
noremap <leader>s :Ag<CR>
noremap <leader>f :Files<CR>
noremap <leader>c :Commits<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>h :History<CR>

let g:ycm_show_diagnostics_ui = 0
let g:ycm_clangd_binary_path = "/home/boco/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/"
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0

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

" Command mode mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Don't lose , for f because of mapleader
nnoremap <Space>; ,

" Make Y behave like C and D
noremap Y y$

" To force myself not to use arrow keys ;)
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Easier movement
noremap K {
noremap J }
noremap H ^
noremap L $

" Quicly close a file with <leader>q
noremap <leader>q :q<CR>

" Quicly save a file with <leader>w
noremap <leader>w :w<CR>

" Quickly force close a file with <leader>Q
noremap <leader>Q :q!<CR>

" Quicly save and close a file with <leader>z
noremap <leader>z :wq<CR>

" Quickly get out of inserted mode without having to leave home row
inoremap jj <Esc>

" Clipboard mappings
noremap <leader>y "+y
noremap <leader>p "+p

" Vimdiff mappings
nnoremap <silent> <leader>dt :windo diffthis<CR>
nnoremap <silent> <leader>do :windo diffoff!<CR>
nnoremap <silent> <leader>du :windo diffupdate<CR>

" Buffer mappings
nnoremap <leader><leader> <C-^><CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

nnoremap <leader><space> :BufferTree<CR>
nnoremap <leader><Tab> :buffer<Space><Tab>
set wildcharm=<Tab>

" Disabled for security reasons
" https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme
set nomodeline

" Toggle to paste mode to stop cascading indents
set pastetoggle=<F5>

" Hide buffers instead of closing them
set hidden

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

" Don't give ins-completion-menu messages
set shortmess+=c

" Allow backspacing over anything in insert mode
set backspace=indent,eol,start

" Use tabs instead of spaces
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4

" Set how many lines of history vim has to remember
set history=10000

" Wrap text to new line
set wrap

" Keep indentation when wrapping
set breakindent

" Bent arrow glyph for wrapped lines
set showbreak=↳

" Auto indent
set autoindent

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

" Do not highlight search results
set nohlsearch

" Enable smart-case search
set smartcase

" Always case-insensitive
set ignorecase

" Searches for strings incrementally
set incsearch

" Allows alphabetical characters to be incremented and disables octal
set nrformats+=alpha
set nrformats-=octal

" Open vimdiff splits vertically
set diffopt=vertical,filler,context:3,iwhite

" Enable undo file
set undodir=~/.vim/undodir
set undofile
set undolevels=1000

" Ignore files for completion
set wildignore+=*/.git/*,*/tmp/*,*~,*.swp,*.o

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

nnoremap <silent> <leader>t :call ToggleNumber()<CR>
nnoremap <leader>gw :call <SID>StripTrailingWhitespaces()<CR>

" Just don't open vim when there's a swapfile
autocmd SwapExists * let v:swapchoice = 'q'

" Automatically resize vim splits
autocmd VimResized * wincmd =

" Set spell for markdown, git commits and latex
augroup Spell
    autocmd!
    autocmd FileType gitcommit,markdown,tex setlocal spell complete+=kspell
    autocmd FileType gitcommit,markdown,tex hi SpellBad cterm=underline
augroup END

set termguicolors
set t_Co=256

" Keep them in this order
set background=dark
syntax on
colorscheme gruvbox
