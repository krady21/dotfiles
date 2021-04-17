call plug#begin()

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

call plug#end()

set statusline=%<\ %f\ %m%r%w%=%l\/%-6L\ %3c
set laststatus=1
set hidden
set nomodeline
set noswapfile
set matchpairs+=<:>
set splitbelow
set splitright
set shortmess+=c
set clipboard=unnamedplus
set completeopt=menuone,noinsert,noselect
set breakindent
set showbreak=↳
set number
set relativenumber
set lazyredraw
set nohlsearch
set report=0
set smartcase
set ignorecase
set incsearch
set nrformats+=alpha
set dictionary=/usr/share/dict/words
set diffopt+=context:3,indent-heuristic,algorithm:patience
set undofile
set wildignore+=*/.git/*,*/tmp/*,*~,*.swp,*.o
set virtualedit=block,insert
set listchars=tab:>\ ,trail:∙,nbsp:•
set expandtab
set shiftwidth=4
set softtabstop=4

set background=dark
set termguicolors
colorscheme happy_hacking

let mapleader=" "

cnoreabbrev Q q
cnoreabbrev W w
cnoreabbrev Wq wq

noremap H ^
noremap L $

inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O

nnoremap Y y$

nnoremap gp `[v`]

nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>

nnoremap <leader><leader> <C-^>

nnoremap <silent> <leader>dt :windo diffthis<CR>
nnoremap <silent> <leader>do :windo diffoff!<CR>
nnoremap <silent> <leader>du :windo diffupdate<CR>

nnoremap <silent> <F1> :set invrnu<CR>
nnoremap <silent> <F2> :set invspell<CR>
nnoremap <silent> <F3> :set invlist<CR>
nnoremap <silent> <F4> :set invwrap<CR>

function! StripTrailingWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

command! Trail call StripTrailingWhitespace()
command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

nnoremap <expr> <leader>f (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<CR>"
nnoremap <leader>F :GFiles?<CR>
nnoremap <leader>s :Rg<CR>

augroup Personal
  autocmd!
  autocmd FileType cpp,java setlocal commentstring=//\ %s
  autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=200}
augroup END

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('i', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', '<leader>w',  '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[g',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  require'compe'.setup {
    source = {
      nvim_lsp = true;
    };
  }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false
  }
)

local servers = { "clangd", "rust_analyzer", "pyright", "texlab", "hls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
