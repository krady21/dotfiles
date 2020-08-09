call plug#begin('~/.vim/plugged')

Plug 'bfrg/vim-cpp-modern'
Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'orderthruchaos/sbd.vim'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'tmsvg/pear-tree'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'yggdroot/indentline'

call plug#end()

set background=dark
colorscheme one

" Change cursor chape
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Enable matchit
runtime! macros/matchit.vim

" Change the mapleader from \ to ,
let mapleader=","

let g:python_highlight_indent_errors = 0
let g:python_highlight_space_errors = 0

let g:pear_tree_repeatable_expand = 0

xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

nnoremap <silent> <F2> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1

nnoremap <silent> <F4> :IndentLinesToggle<CR>
let g:indentLine_fileTypeExclude = ['text', 'json', 'markdown', 'xml']
let g:indentLine_faster = 1
let g:indentLine_char = '⎸'
let g:indentLine_enabled = 1

noremap <leader>r :Rg<CR>
noremap <leader>s :Ag<CR>
noremap <leader>f :Files<CR>
noremap <leader>F :GFiles?<CR>
noremap <leader>c :Commits<CR>
noremap <leader>b :Buffers<CR>

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


let g:coc_disable_startup_warning = 1
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Center search results
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Command mode mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

xnoremap < <gv
xnoremap > >gv

" Don't lose , for f because of mapleader
nnoremap <Space>; ,

" Make Y behave like C and D
noremap Y y$

" To force myself not to use arrow keys ;)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Easier movement
noremap K {
noremap J }
noremap H ^
noremap L $

" Quicly close a file with <leader>q
nnoremap <silent> <leader>q :q<CR>

" Quickly force close a file with <leader>Q
nnoremap <silent> <leader>Q :q!<CR>

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
nnoremap <leader><Space> :ls<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

nnoremap <leader><Tab> :buffer<Space><Tab>
set wildcharm=<Tab>

" Always show statusline
set laststatus=2

" Disabled for security reasons
" https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme
set nomodeline

" Disable swapfiles
set noswapfile

" Chage default statusline
set statusline=%<\ %f\ %m%r%w%=%l\/%-6L\ %3c

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
let &softtabstop = &shiftwidth

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

" Always report changed lines
set report=0

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

" Allows visual block over white space
set virtualedit=block

set ttyfast

set termguicolors
set t_Co=256

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

nnoremap <silent> <F1> :call ToggleNumber()<CR>
nnoremap <silent> <F12> :call <SID>StripTrailingWhitespaces()<CR>

" Automatically resize vim splits
augroup Window
  autocmd!
  autocmd VimResized * wincmd =
augroup END

augroup Spell
  autocmd!
  autocmd FileType gitcommit,markdown,tex setlocal spell complete+=kspell
augroup END

augroup Wrap
  autocmd!
  autocmd FileType xml,json setlocal nowrap
augroup END
