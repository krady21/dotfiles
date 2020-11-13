call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'mhinz/vim-signify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/tagbar'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

call plug#end()

set background=dark
set termguicolors
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_invert_selection = 0
colorscheme gruvbox

let mapleader=","

let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1

nnoremap <leader>s :Rg<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles?<CR>
nnoremap <leader>b :Buffers<CR>

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

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Search results centered
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz

" Command mode mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Easier indentation in visual mode
xnoremap < <gv
xnoremap > >gv

" Make Y behave like C and D
noremap Y y$

" Select last pasted text
nnoremap gp `[v`]

" noremap K {
" noremap J }
noremap H ^
noremap L $

command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")
command! -nargs=1 Rename try | saveas <args> | call delete(expand('#')) | silent bd # | endtry

cnoreabbrev Q q
cnoreabbrev W w

" Smart buffer delete
command! Sbd bp\|bd \#

" Bracket autoexpansion
inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O

" Vimdiff mappings
nnoremap <silent> <leader>dt :windo diffthis<CR>
nnoremap <silent> <leader>do :windo diffoff!<CR>
nnoremap <silent> <leader>du :windo diffupdate<CR>

" Buffer mappings
nnoremap <leader><leader> <C-^><CR>
nnoremap <leader><Space> :ls<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

" Highlight matching angle brackets
set matchpairs+=<:>

" Always show statusline
set laststatus=1

" Disabled for security reasons
" https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme
set nomodeline

" Disable swapfiles
set noswapfile

" Change default statusline
set statusline=%<\ %f\ %m%r%w%=%l\/%-6L\ %3c

" Hide buffers instead of closing them
set hidden

" Automatically reload files changed outside of vim
set autoread

" Update time for signify
set updatetime=50

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
set virtualedit=block,insert

" Use system clipboard
set clipboard=unnamedplus

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

command! Strip call <SID>StripTrailingWhitespaces()

nnoremap <silent> <F1> :set rnu!<CR>
nnoremap <silent> <F2> :set spell!<CR>
nnoremap <silent> <F3> :TagbarToggle<CR>
nnoremap <silent> <F4> :set wrap!<CR>

augroup Personal
    autocmd!
    autocmd FileType xml,json setlocal nowrap
    autocmd VimResized * wincmd =
    autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
augroup END
