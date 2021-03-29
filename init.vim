packadd! fzf.vim
packadd! nvim-compe
packadd! nvim-lspconfig
packadd! targets.vim
packadd! vim-commentary
packadd! vim-dirvish
packadd! vim-sleuth
packadd! vim-surround

set statusline=%<\ %f\ %m%r%w%=%l\/%-6L\ %3c
set laststatus=1
set hidden
set nomodeline
set noswapfile
set matchpairs+=<:>
set updatetime=50
set splitbelow
set splitright
set shortmess+=c
set completeopt=menuone,noinsert,noselect
set nowrap
set breakindent
set showbreak=↳
set magic
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
set clipboard=unnamedplus
set listchars=tab:>\ ,trail:∙,nbsp:•
set expandtab
set shiftwidth=4
set softtabstop=4
set rtp+=$HOME/.fzf

set background=dark
set termguicolors
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_invert_selection = 0
let g:gruvbox_contrast_dark = 'soft'
colorscheme gruvbox

let mapleader=","

cnoreabbrev Q q
cnoreabbrev W w
cnoreabbrev Wq wq

noremap H ^
noremap L $

inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O

nnoremap <leader><leader> <C-^><CR>
nnoremap <leader><Space> :ls<CR>

noremap Y y$

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz

nnoremap gp `[v`]

nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>

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

command! Strip call <SID>StripTrailingWhitespaces()
command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

nnoremap <leader>s :Rg<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles?<CR>

:lua << EOF
local nvim_lsp = require('lspconfig')
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false
  }
)
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
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

local servers = { "clangd", "rust_analyzer", "pyls", "texlab", "hls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

augroup Personal
  autocmd!
  autocmd FileType cpp,java setlocal commentstring=//\ %s
  autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=200}
augroup END
