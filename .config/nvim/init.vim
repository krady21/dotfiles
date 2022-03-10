colorscheme nordfox

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

cnoreabbrev Q q
cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa

command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)
command! Sbd b#|bd#

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
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({"git", "clone", "https://github.com/savq/paq-nvim.git", install_path})
end

require("paq") {
  "savq/paq-nvim",

  "EdenEast/nightfox.nvim",
  "ibhagwan/fzf-lua",
  "leoluz/nvim-dap-go",
  "lewis6991/gitsigns.nvim",
  "mfussenegger/nvim-dap",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "sindrets/diffview.nvim",
  "nvim-treesitter/nvim-treesitter",

  "justinmk/vim-dirvish",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
}

local border_opts = { border = "rounded" }

vim.diagnostic.config {
  signs = false,
  underline = false,
  virtual_text = true,
  float = border_opts,
}

-- LSP
local on_attach = function(client, bufnr)
  local opts = { silent = true, buffer = bufnr }

  vim.bo.omnifunc =  "v:lua.vim.lsp.omnifunc"

  vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<space>gn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<space>ga", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "K",         vim.lsp.buf.hover, opts)
  vim.keymap.set("i", "<C-k>",     vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<space>=",  vim.lsp.buf.formatting, opts)
  vim.keymap.set("n", "<space>w",  vim.lsp.buf.workspace_symbol, opts)

  vim.keymap.set("n", "<space>q",  vim.diagnostic.setqflist, opts)
  vim.keymap.set("n", "<space>e",  vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[g",        vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]g",        vim.diagnostic.goto_next, opts)
end

local defaults = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)
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
for server, server_config in pairs(servers) do
  config = vim.tbl_deep_extend("force", defaults, server_config)
  lspconfig[server].setup(config)
end

-- Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  }
}

-- FZF
require("fzf-lua").setup {
  winopts = {
    hl_border = "VertSplit",
    preview = {
      layout = "vertical",
    },
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
  use_icons = false,
  file_panel = {
    listing_style = "list"
  }
}

-- Gitsigns
require("gitsigns").setup {
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "]c", gs.next_hunk, opts)
    vim.keymap.set("n", "[c", gs.prev_hunk, opts)
    vim.keymap.set("n", "<space>p", gs.preview_hunk, opts)
    vim.keymap.set("n", "<space>P", gs.stage_hunk, opts)
  end
}
EOF
