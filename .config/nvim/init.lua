vim.g.mapleader = ' '
vim.g.colors_name = 'paper'

vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = 'menuone,noselect'
vim.opt.dictionary = '/usr/share/dict/words'
vim.opt.diffopt:append('indent-heuristic,algorithm:histogram')
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.incsearch = true
vim.opt.laststatus = 1
vim.opt.lazyredraw = true
vim.opt.listchars = 'tab:| ,trail:∙,nbsp:•'
vim.opt.nrformats:append('alpha')
vim.opt.number = true
vim.opt.path = '.,,**'
vim.opt.relativenumber = true
vim.opt.report = 0
vim.opt.shiftwidth = 4
vim.opt.shortmess:append('c')
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
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd BufWritePre * if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) | call mkdir(expand('<afile>:h'), 'p') | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
augroup END
]])

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { underline = false, virtual_text = false, signs = false })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

local on_attach = function(client, bufnr)
  require('compe').setup({ preselect = 'disable', source = { nvim_lsp = true } }, bufnr)
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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = "single"})<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[g',         '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "single"}})<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']g',         '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "single"}})<CR>', opts)
end

local lspconfig = require('lspconfig')
local servers = { "clangd", "rust_analyzer", "pyright", "texlab", "hls", "gopls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup { on_attach = on_attach }
end
