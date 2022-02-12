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

let g:netrw_bufsettings = "noma nomod nu rnu nowrap ro nobl"
let g:netrw_banner = 0
let g:netrw_altfile = 1
let g:netrw_fastbrowse = 0

augroup Personal
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd BufWritePre * call mkdir(expand("<afile>:h"), "p")
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
  autocmd FileType c,cpp setlocal commentstring=//\ %s
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType python setlocal makeprg=python\ %
  autocmd FileType gitcommit setlocal spell spelllang=en
augroup END

lua << EOF
-- Plugins
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({"git", "clone", "https://github.com/savq/paq-nvim.git", install_path})
end

require("paq") {
  "savq/paq-nvim",

  "ibhagwan/fzf-lua",
  "leoluz/nvim-dap-go",
  "lewis6991/gitsigns.nvim",
  "mfussenegger/nvim-dap",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "sindrets/diffview.nvim",

  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
}

-- FZF
require("fzf-lua").setup {
  winopts = {
    hl_border = "VertSplit",
  },
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

-- DAP
local dap = require("dap")
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode-10",
  name = "lldb",
}

local lldb = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path: ", vim.fn.getcwd() .. "/", "file")
    end,
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

dap.configurations.c = lldb
dap.configurations.cpp = lldb
dap.configurations.rust = lldb

require("dap-go").setup()

-- Diffview
require("diffview").setup {
  use_icons = false
}

-- Gitsigns
require("gitsigns").setup {
  signcolumn = false
}

vim.diagnostic.config {
  signs = false,
  underline = false,
  virtual_text = true,
}

-- LSP
local on_attach = function(client, bufnr)
  local function buf_nnoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true }) end
  local function buf_inoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, "i", lhs, rhs, { noremap = true }) end
  local function buf_option(...)        vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  buf_nnoremap("<space>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  buf_nnoremap("<space>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  buf_nnoremap("<space>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_nnoremap("<space>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  buf_nnoremap("<space>gR", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_nnoremap("<space>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_nnoremap("K",         "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_inoremap("<C-k>",     "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_nnoremap("<space>=",  "<cmd>lua vim.lsp.buf.formatting()<CR>")
  buf_nnoremap("<space>w",  "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")

  buf_nnoremap("<space>q",  "<cmd>lua vim.diagnostic.setqflist()<CR>")
  buf_nnoremap("<space>e",  "<cmd>lua vim.diagnostic.open_float(bufnr, {scope = 'line', border = 'single'})<CR>")
  buf_nnoremap("[g",        "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'single'}})<CR>")
  buf_nnoremap("]g",        "<cmd>lua vim.diagnostic.goto_next({float = {border = 'single'}})<CR>")
end

local defaults = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single"})
  }
}

local gopls = {
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true
    }
  }
}

local rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true
      }
    }
  }
}

local servers = {
  ["bashls"] = {},
  ["clangd"] = {},
  ["gopls"] = gopls,
  ["pyright"] = {},
  ["rust_analyzer"] = rust_analyzer,
}

local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", defaults, config))
end
EOF
