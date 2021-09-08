local o, l, fn, cmd = vim.opt, vim.opt_local, vim.fn, vim.cmd

local function nnoremap(lhs, rhs) vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true }) end
local function inoremap(lhs, rhs) vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true }) end
local function noremap(lhs, rhs)  vim.api.nvim_set_keymap("", lhs, rhs, { noremap = true }) end

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(function(use)
  use {"wbthomason/packer.nvim"}
  use {"neovim/nvim-lspconfig"}
  use {"justinmk/vim-dirvish"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"tpope/vim-sleuth"}
  use {"tpope/vim-surround"}
  use {"wellle/targets.vim"}
  use {"ibhagwan/fzf-lua", requires = {"vijaymarupudi/nvim-fzf"}}
end)

cmd("colorscheme paper")

o.breakindent = true
o.clipboard = "unnamedplus"
o.completeopt = "menuone,noselect"
o.dictionary = "/usr/share/dict/words"
o.diffopt:append("indent-heuristic,algorithm:histogram")
o.expandtab = true
o.hlsearch = false
o.ignorecase = true
o.incsearch = true
o.lazyredraw = true
o.listchars = "tab:> ,trail:∙,nbsp:•"
o.nrformats:append("alpha")
o.number = true
o.path = ".,,**"
o.relativenumber = true
o.report = 0
o.shiftwidth = 4
o.shortmess:append("c")
o.showbreak = "↳"
o.smartcase = true
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.statusline = "%< %f %m%r%w%=%l/%-6L %3c "
o.swapfile = false
o.termguicolors = true
o.undofile = true
o.virtualedit = "block,insert"
o.wildignore = "*/.git/*,*/tmp/*,*.swp,*.o,*.pyc"
o.wrap = false

if fn["executable"]("rg") then
  o.grepprg = "rg --no-heading --vimgrep"
  o.grepformat = "%f:%l:%c:%m"
end

noremap("H", "^")
noremap("L", "$")

inoremap("{<CR>", "{<CR>}<C-o>O")
inoremap("[<CR>", "[<CR>]<C-o>O")

nnoremap("gp", "`[v`]")
nnoremap("<space><space>", "<C-^>")

nnoremap("<C-j>", "<cmd>cnext<CR>")
nnoremap("<C-k>", "<cmd>cprev<CR>")

nnoremap("<space>dt", "<cmd>windo diffthis<CR>")
nnoremap("<space>do", "<cmd>windo diffoff<CR>")

nnoremap("<F1>", "<cmd>set invrnu<CR>")
nnoremap("<F2>", "<cmd>set invspell<CR>")
nnoremap("<F3>", "<cmd>set invwrap<CR>")
nnoremap("<F4>", "<cmd>set invlist<CR>")

nnoremap("<space>f", "<cmd>lua require('fzf-lua').files()<CR>")
nnoremap("<space>F", "<cmd>lua require('fzf-lua').git_files()<CR>")
nnoremap("<space>G", "<cmd>lua require('fzf-lua').git_status()<CR>")
nnoremap("<space>h", "<cmd>lua require('fzf-lua').oldfiles()<CR>")
nnoremap("<space>s", "<cmd>lua require('fzf-lua').live_grep()<CR>")
nnoremap("<space>b", "<cmd>lua require('fzf-lua').buffers()<CR>")

cmd("cnoreabbrev Q q")
cmd("cnoreabbrev W w")
cmd("cnoreabbrev Wq wq")
cmd("cnoreabbrev Qa qa")

function whitespace()
    local save = fn.winsaveview()
    cmd([[keeppatterns %s/\s\+$//e]])
    fn.winrestview(save)
end

cmd([[command! White lua whitespace()]])
cmd([[command! Sbd b#|bd#]])

cmd([[
augroup Personal
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd BufWritePre * call mkdir(expand("<afile>:h"), "p")
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
augroup END
]])

require'fzf-lua'.setup {
  fzf_colors = {
    ["fg"] = { "fg", "Normal" },
    ["bg"] = { "bg", "Normal" },
    ["hl"] = { "fg", "Comment" },
    ["fg+"] = { "fg", "Normal" },
    ["bg+"] = { "bg", "CursorLine" },
    ["hl+"] = { "fg", "Statement" },
    ["info"] = { "fg", "PreProc" },
    ["prompt"] = { "fg", "Conditional" },
    ["pointer"] = { "fg", "Exception" },
    ["marker"] = { "fg", "Keyword" },
    ["spinner"] = { "fg", "Label" },
    ["header"] = { "fg", "Comment" },
    ["gutter"] = { "bg", "Normal" },
  }
}

local on_attach = function(client, bufnr)
  local function buf_nnoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true }) end
  local function buf_inoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, "i", lhs, rhs, { noremap = true }) end

  buf_nnoremap("<space>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  buf_nnoremap("<space>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  buf_nnoremap("<space>gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_nnoremap("<space>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  buf_nnoremap("<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_nnoremap("<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_nnoremap("K",         "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_inoremap("<C-k>",     "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_nnoremap("<space>=",  "<cmd>lua vim.lsp.buf.formatting()<CR>")
  buf_nnoremap("<space>w",  "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
  buf_nnoremap("<space>q",  "<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>")
  buf_nnoremap("<space>e",  "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = 'single'})<CR>")
  buf_nnoremap("[g",        "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'single'}})<CR>")
  buf_nnoremap("]g",        "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'single'}})<CR>")

  l.omnifunc = "v:lua.vim.lsp.omnifunc"
  -- l.complete:append('o')
end

local lspconfig = require("lspconfig")
local servers = { "clangd", "rust_analyzer", "pyright", "texlab", "hls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 200
    }
  }
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "single"
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "single"
  }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = true,
    signs = false,
  }
)
