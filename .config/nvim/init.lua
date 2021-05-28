local g, o, w, b = vim.g, vim.o, vim.wo, vim.bo
local cmd, fn = vim.cmd, vim.fn
local map = vim.api.nvim_set_keymap

cmd('packadd! fzf')
cmd('packadd! fzf.vim')
cmd('packadd! nvim-compe')
cmd('packadd! nvim-lspconfig')
cmd('packadd! targets.vim')
cmd('packadd! vim-commentary')
cmd('packadd! vim-dirvish')
cmd('packadd! vim-exchange')
cmd('packadd! vim-repeat')
cmd('packadd! vim-sleuth')
cmd('packadd! vim-surround')

g.mapleader = ' '
w.wrap = false
w.number = true
w.relativenumber = true
w.breakindent = true
w.foldenable = false
w.foldmethod = 'indent'
o.path = '.,,**'
o.showbreak = '↳'
o.laststatus = 1
o.report = 0
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.splitbelow = true
o.splitright = true
o.lazyredraw = true
o.hlsearch = false
o.incsearch = true
o.smartcase = true
o.ignorecase = true
o.hidden = true
b.undofile = true
b.swapfile = false
b.modeline = false
b.nrformats = 'bin,hex,alpha'
o.virtualedit = 'block,insert'
o.clipboard = 'unnamedplus'
o.inccommand = 'nosplit'
o.completeopt = 'menuone,noselect'
o.statusline = '%< %f %m%r%w%=%l/%-6L %3c '
o.listchars = 'tab:| ,trail:∙,nbsp:•'
o.dictionary = '/usr/share/dict/words'
o.wildignore = '*/.git/*,*/tmp/*,*.swp,*.o,*.pyc'
o.diffopt = 'internal,filler,closeoff,indent-heuristic,algorithm:patience'
o.shortmess = o.shortmess .. 'c'

o.termguicolors = true
g.colors_name = 'happy_hacking'

if fn['executable']('rg') then
  o.grepprg = 'rg --no-heading --vimgrep'
  o.grepformat = '%f:%l:%c:%m'
end

map('', 'H', '^', {noremap = true})
map('', 'L', '$', {noremap = true})

map('i', '{<CR>', '{<CR>}<C-o>O', {noremap = true})
map('i', '[<CR>', '[<CR>]<C-o>O', {noremap = true})

map('n', 'Y', 'y$', {noremap = true})
map('n', 'gp', '`[v`]', {noremap = true})

map('n', '<leader><leader>', '<C-^>', {noremap = true})

map('n', '<C-j>', ':cnext<CR>', {noremap = true, silent = true})
map('n', '<C-k>', ':cprev<CR>', {noremap = true, silent = true})

map('n', '<leader>dt', ':windo diffthis<CR>', {noremap = true, silent = true})
map('n', '<leader>do', ':windo diffoff<CR>', {noremap = true, silent = true})

map('n', '<F1>', ':set invrnu<CR>', {noremap = true, silent = true})
map('n', '<F2>', ':set invspell<CR>', {noremap = true, silent = true})
map('n', '<F3>', ':set invwrap<CR>', {noremap = true, silent = true})
map('n', '<F4>', ':set invlist<CR>', {noremap = true, silent = true})

map('n', '<leader>f', ':Files<CR>', {noremap = true})
map('n', '<leader>F', ':GFiles<CR>', {noremap = true})
map('n', '<leader>G', ':GFiles?<CR>', {noremap = true})
map('n', '<leader>h', ':History<CR>', {noremap = true})
map('n', '<leader>s', ':Rg<CR>', {noremap = true})

cmd('cnoreabbrev Q q')
cmd('cnoreabbrev W w')
cmd('cnoreabbrev Wq wq')
cmd('cnoreabbrev Qa qa')

cmd([[command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)]])
cmd([[command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")]])
cmd([[command! Sbd b#|bd#]])

cmd([[
augroup Personal
  autocmd!
  autocmd FileType cpp,java setlocal commentstring=//\ %s
  autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
augroup END
]])

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

  require('compe').setup({
    preselect = 'disable';
    source = {
      nvim_lsp = true;
    };
  }, bufnr)

  buf_opt('omnifunc', 'v:lua.vim.lsp.omnifunc')
  cmd('setlocal signcolumn=yes')

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
end

local nvim_lsp = require('lspconfig')
local servers = { "clangd", "rust_analyzer", "pyright", "texlab", "hls", "gopls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
