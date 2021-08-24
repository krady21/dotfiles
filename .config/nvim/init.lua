local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(function(use)
  use {"wbthomason/packer.nvim"}
  use {"neovim/nvim-lspconfig"}
  use {"junegunn/fzf"}
  use {"junegunn/fzf.vim"}
  use {"justinmk/vim-dirvish"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"tpope/vim-sleuth"}
  use {"tpope/vim-surround"}
  use {"wellle/targets.vim"}
end)

vim.cmd("syntax on")
vim.cmd("colorscheme paper")

vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menuone,noselect"
vim.opt.dictionary = "/usr/share/dict/words"
vim.opt.diffopt:append("indent-heuristic,algorithm:histogram")
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.lazyredraw = true
vim.opt.listchars = "tab:> ,trail:∙,nbsp:•"
vim.opt.nrformats:append("alpha")
vim.opt.number = true
vim.opt.path = ".,,**"
vim.opt.relativenumber = true
vim.opt.report = 0
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("c")
vim.opt.showbreak = "↳"
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = "%< %f %m%r%w%=%l/%-6L %3c "
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block,insert"
vim.opt.wildignore = "*/.git/*,*/tmp/*,*.swp,*.o,*.pyc"
vim.opt.wrap = false

if vim.fn["executable"]("rg") then
  vim.opt.grepprg = "rg --no-heading --vimgrep"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.g.fzf_preview_window = ""
vim.g.fzf_colors = {
  ["fg"] = { "fg", "Normal" },
  ["bg"] = { "bg", "Normal" },
  ["hl"] = { "fg", "Comment" },
  ["fg+"] = { "fg", "Cursorline", "CursorColumn", "Normal" },
  ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
  ["hl+"] = { "fg", "Statement" },
  ["info"] = { "fg", "PreProc" },
  ["border"] = { "fg", "Ignore" },
  ["prompt"] = { "fg", "Conditional" },
  ["pointer"] = { "fg", "Exception" },
  ["marker"] = { "fg", "Keyword" },
  ["spinner"] = { "fg", "Label" },
  ["header"] = { "fg", "Comment" },
}

local opts = { noremap = true }

vim.api.nvim_set_keymap("", "H", "^", opts)
vim.api.nvim_set_keymap("", "L", "$", opts)

vim.api.nvim_set_keymap("i", "{<CR>", "{<CR>}<C-o>O", opts)
vim.api.nvim_set_keymap("i", "[<CR>", "[<CR>]<C-o>O", opts)

vim.api.nvim_set_keymap("n", "gp", "`[v`]", opts)
vim.api.nvim_set_keymap("n", "<space><space>", "<C-^>", opts)

vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>cprev<CR>", opts)

vim.api.nvim_set_keymap("n", "<space>dt", "<cmd>windo diffthis<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>do", "<cmd>windo diffoff<CR>", opts)

vim.api.nvim_set_keymap("n", "<F1>", "<cmd>set invrnu<CR>", opts)
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>set invspell<CR>", opts)
vim.api.nvim_set_keymap("n", "<F3>", "<cmd>set invwrap<CR>", opts)
vim.api.nvim_set_keymap("n", "<F4>", "<cmd>set invlist<CR>", opts)

vim.api.nvim_set_keymap("n", "<space>f", "<cmd>Files<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>F", "<cmd>GFiles<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>G", "<cmd>GFiles?<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>h", "<cmd>History<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>s", "<cmd>Rg<CR>", opts)

vim.cmd("cnoreabbrev Q q")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Qa qa")

vim.cmd([[command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)]])
vim.cmd([[command! Sbd b#|bd#]])

vim.cmd([[
augroup Personal
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd BufWritePre * if "<afile>" !~ "^scp:" && !isdirectory(expand("<afile>:h")) | call mkdir(expand("<afile>:h"), "p") | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
augroup END
]])

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { underline = false, virtual_text = false, signs = false })

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K",         "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-k>",     "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>=",  "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>w",  "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>q",  "<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>e",  "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = 'single'})<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[g",        "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'single'}})<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]g",        "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'single'}})<CR>", opts)
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
