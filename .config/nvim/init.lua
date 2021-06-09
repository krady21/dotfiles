local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim.git', install_path})
end

local paq = require'paq-nvim'.paq

paq {'savq/paq-nvim'}
paq {'neovim/nvim-lspconfig'}
paq {'hrsh7th/nvim-compe'}

paq {'junegunn/fzf', run = vim.fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'justinmk/vim-dirvish'}
paq {'tommcdo/vim-exchange'}
paq {'tpope/vim-commentary'}
paq {'tpope/vim-fugitive', opt = true}
paq {'tpope/vim-repeat'}
paq {'tpope/vim-sleuth'}
paq {'tpope/vim-surround'}
paq {'wellle/targets.vim'}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = 'menuone,noselect'
vim.opt.dictionary = '/usr/share/dict/words'
vim.opt.diffopt = vim.opt.diffopt + 'indent-heuristic,algorithm:histogram'
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.incsearch = true
vim.opt.laststatus = 1
vim.opt.lazyredraw = true
vim.opt.listchars = 'tab:| ,trail:∙,nbsp:•'
vim.opt.modeline = false
vim.opt.nrformats = 'bin,hex,alpha'
vim.opt.number = true
vim.opt.path = '.,,**'
vim.opt.relativenumber = true
vim.opt.report = 0
vim.opt.shiftwidth = 4
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.showbreak = '↳'
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = '%< %f %m%r%w%=%l/%-6L %3c '
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = 'block,insert'
vim.opt.wildignore = '*/.git/*,*/tmp/*,*.swp,*.o,*.pyc'
vim.opt.wrap = false

vim.g.mapleader = ' '
vim.g.colors_name = 'paper'

if vim.fn['executable']('rg') then
  vim.opt.grepprg = 'rg --no-heading --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.api.nvim_set_keymap('', 'H', '^', {noremap = true})
vim.api.nvim_set_keymap('', 'L', '$', {noremap = true})

vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<C-o>O', {noremap = true})
vim.api.nvim_set_keymap('i', '[<CR>', '[<CR>]<C-o>O', {noremap = true})

vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})
vim.api.nvim_set_keymap('n', 'gp', '`[v`]', {noremap = true})

vim.api.nvim_set_keymap('n', '<leader><leader>', '<C-^>', {noremap = true})

vim.api.nvim_set_keymap('n', '<C-j>', ':cnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', ':cprev<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>dt', ':windo diffthis<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>do', ':windo diffoff<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>du', ':windo diffupdate<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<F1>', ':set invrnu<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F2>', ':set invspell<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F3>', ':set invwrap<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F4>', ':set invlist<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>F', ':GFiles<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>G', ':GFiles?<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>h', ':History<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>s', ':Rg<CR>', {noremap = true})

vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Wq wq')
vim.cmd('cnoreabbrev Qa qa')

vim.cmd([[command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)]])
vim.cmd([[command! Sbd b#|bd#]])

vim.cmd([[
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
  require('compe').setup({ preselect = 'disable', source = { nvim_lsp = true } }, bufnr)

  vim.cmd('setlocal signcolumn=yes')
  vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>w',  '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[g',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']g',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

local nvim_lsp = require('lspconfig')
local servers = { "clangd", "rust_analyzer", "pyright", "texlab", "hls", "gopls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
