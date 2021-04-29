local g, o, w, b = vim.g, vim.o, vim.wo, vim.bo
local cmd, fn = vim.cmd, vim.fn
local map = vim.api.nvim_set_keymap

cmd 'packadd paq-nvim'
local paq = require'paq-nvim'.paq

paq {'savq/paq-nvim', opt = true}
paq {'neovim/nvim-lspconfig'}
paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'justinmk/vim-dirvish'}
paq {'tommcdo/vim-exchange'}
paq {'tpope/vim-commentary'}
paq {'tpope/vim-sleuth'}
paq {'tpope/vim-surround'}
paq {'wellle/targets.vim'}

g.mapleader = ' '
b.undofile = true
w.wrap = false
w.number = true
w.relativenumber = true
w.breakindent = true
o.showbreak = '↳'
o.laststatus = 1
o.report = 0
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.hidden = true
o.swapfile = false
o.modeline = false
o.splitbelow = true
o.splitright = true
o.lazyredraw = true
o.hlsearch = false
o.incsearch = true
o.smartcase = true
o.ignorecase = true
o.virtualedit = 'block,insert'
o.clipboard = 'unnamedplus'
o.completeopt = 'menuone,noinsert,noselect'
o.statusline = '%< %f %m%r%w%=%l/%-6L %3c '
o.listchars = 'tab:> ,trail:∙,nbsp:•'
o.dictionary = '/usr/share/dict/words'
o.wildignore = '*/.git/*,*/tmp/*,*.swp,*.o,*.pyc'
o.diffopt = 'internal,filler,closeoff,indent-heuristic,algorithm:patience'
o.shortmess = vim.o.shortmess .. 'c'

o.background = 'dark'
o.termguicolors = true
cmd 'colorscheme happy_hacking'

if fn['executable']('rg') then
  o.grepprg = 'rg --no-heading --vimgrep'
  o.grepformat = '%f:%l:%c:%m'
end

cmd 'cnoreabbrev Q q'
cmd 'cnoreabbrev W w'
cmd 'cnoreabbrev Wq wq'
cmd 'cnoreabbrev Qa qa'

map('', 'H', '^', {noremap = true})
map('', 'L', '$', {noremap = true})

map('i', '{<CR>', '{<CR>}<C-o>O', {noremap = true})
map('i', '[<CR>', '[<CR>]<C-o>O', {noremap = true})

map('n', 'Y', 'y$', {noremap = true})
map('n', 'gp', '`[v`]', {noremap = true})

map('n', '<C-j>', ':cnext<CR>', {noremap = true, silent = true})
map('n', '<C-k>', ':cprev<CR>', {noremap = true, silent = true})

map('n', '<leader><leader>', '<C-^>', {noremap = true})

map('n', '<leader>dt', ':windo diffthis<CR>', {noremap = true, silent = true})
map('n', '<leader>do', ':windo diffoff!<CR>', {noremap = true, silent = true})

map('n', '<F1>', ':set invrnu<CR>', {noremap = true, silent = true})
map('n', '<F2>', ':set invspell<CR>', {noremap = true, silent = true})
map('n', '<F3>', ':set invwrap<CR>', {noremap = true, silent = true})
map('n', '<F4>', ':set invlist<CR>', {noremap = true, silent = true})

map('n', '<leader>f', [[(len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<CR>"]], {noremap = true, expr = true})
map('n', '<leader>F', ':GFiles?<CR>', {noremap = true})
map('n', '<leader>s', ':Rg<CR>', {noremap = true})
map('n', '<leader>h', ':History<CR>', {noremap = true})

cmd [[command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)]]
cmd [[command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")]]

vim.api.nvim_exec([[
augroup Personal
  autocmd!
  autocmd FileType cpp,java setlocal commentstring=//\ %s
  autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=200}
augroup END
]], false)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    signs = true,
    virtual_text = false,
  }
)

local on_attach = function(client, bufnr)
  local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_map('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_map('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_map('n', '<leader>gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_map('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_map('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_map('i', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_map('n', '<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_map('n', '<leader>w',  '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_map('n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_map('n', '[g',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_map('n', ']g',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  buf_opt('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_map('i', '<C-n>', '<C-x><C-o>', opts)
end

local nvim_lsp = require('lspconfig')
local servers = { "clangd", "rust_analyzer", "pyright", "texlab", "hls", "gopls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
