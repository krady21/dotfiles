packadd! fzf.vim
packadd! nvim-compe
packadd! nvim-lspconfig
packadd! targets.vim
packadd! vim-commentary
packadd! vim-dirvish
packadd! vim-sleuth

set statusline=%<\ %f\ %m%r%w%=%l\/%-6L\ %3c
set laststatus=1
set hidden
set nomodeline
set backspace=indent,eol,start
set noswapfile
set matchpairs+=<:>
set autoread
set updatetime=50
set splitbelow
set splitright
set encoding=utf-8
set shortmess+=c
set completeopt=menuone,noinsert,noselect
set history=10000
set nowrap
set breakindent
set showbreak=↳
set autoindent
set magic
set number
set relativenumber
set numberwidth=4
set ruler
set wildmenu
set lazyredraw
set noerrorbells
set novisualbell
set nohlsearch
set report=0
set smartcase
set ignorecase
set incsearch
set nrformats+=alpha
set nrformats-=octal
set dictionary=/usr/share/dict/words
set diffopt+=vertical,context:3,iwhite,indent-heuristic,algorithm:patience
set undofile
set undolevels=1000
set wildignore+=*/.git/*,*/tmp/*,*~,*.swp,*.o
set virtualedit=block,insert
set clipboard=unnamedplus
set listchars=tab:>\ ,trail:∙,nbsp:•
set expandtab
set smarttab
set shiftwidth=4
let &softtabstop = &shiftwidth
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

xnoremap < <gv
xnoremap > >gv

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

nmap gx yiW:!xdg-open <cWORD><CR> <C-r>" & <CR><CR>

function! <SID>StripTrailingWhitespaces()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
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

let g:loaded_compe_snippets_nvim=0
let g:loaded_compe_treesitter=0
let g:loaded_compe_spell=0
let g:loaded_compe_path=0
let g:loaded_compe_nvim_lua=0
let g:loaded_compe_calc=0
let g:loaded_compe_tags=0
let g:loaded_compe_emoji=0

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
    autocmd VimResized * wincmd =
    autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
augroup END
