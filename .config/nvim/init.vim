colorscheme paper

set breakindent
set clipboard=unnamedplus
set completeopt=menuone,noselect
set dictionary=/usr/share/dict/words
set diffopt+=indent-heuristic,algorithm:histogram
set expandtab
set ignorecase
set incsearch
set lazyredraw
set listchars=tab:\|\ ,trail:∙,nbsp:•
set nohlsearch
set noswapfile
set nowrap
set nrformats+=alpha
set number
set path=.,,**
set relativenumber
set report=0
set shiftwidth=4
set shortmess+=c
set showbreak=↳
set smartcase
set softtabstop=4
set splitbelow
set splitright
set statusline=%<\ %f\ %m%r%w%=%l\/%-6L\ %3c
set termguicolors
set undofile
set virtualedit=block,insert
set wildignore=*/.git/*,*/tmp/*,*.o,*.pyc

if executable("rg")
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

lua require("config.fzf")
lua require("config.lsp")
lua require("config.dap")

noremap H ^
noremap L $

inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O

nnoremap gp `[v`]
nnoremap <space><space> <C-^>

nnoremap <C-j> <cmd>cnext<CR>
nnoremap <C-k> <cmd>cprev<CR>

nnoremap <space>dt <cmd>windo diffthis<CR>
nnoremap <space>do <cmd>windo diffoff<CR>

nnoremap <F1> <cmd>set invrnu<CR>
nnoremap <F2> <cmd>set invspell<CR>
nnoremap <F3> <cmd>set invwrap<CR>
nnoremap <F4> <cmd>set invlist<CR>

nnoremap <space>f <cmd>lua require("fzf-lua").files()<CR>
nnoremap <space>F <cmd>lua require("fzf-lua").git_files()<CR>
nnoremap <space>G <cmd>lua require("fzf-lua").git_status()<CR>
nnoremap <space>h <cmd>lua require("fzf-lua").oldfiles()<CR>
nnoremap <space>s <cmd>lua require("fzf-lua").live_grep()<CR>

nnoremap <space>b <cmd>lua require("dap").toggle_breakpoint()<CR>
nnoremap <space>c <cmd>lua require("dap").continue()<CR>
nnoremap <space>r <cmd>lua require("dap").repl.toggle()<CR>

cnoreabbrev Q q
cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa

command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)
command! Sbd b#|bd#

augroup Personal
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd BufWritePre * call mkdir(expand("<afile>:h"), "p")
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
augroup END
