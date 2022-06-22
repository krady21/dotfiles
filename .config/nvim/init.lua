local g, o, l = vim.g, vim.opt, vim.opt_local
local cmd, fn = vim.cmd, vim.fn

local function nmap(lhs, rhs, opts) vim.keymap.set("n", lhs, rhs, opts) end
local function imap(lhs, rhs, opts) vim.keymap.set("i", lhs, rhs, opts) end

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use {"wbthomason/packer.nvim"}
  use {"EdenEast/nightfox.nvim"}
  use {"lewis6991/impatient.nvim"}
  use {"lewis6991/gitsigns.nvim"}
  use {"neovim/nvim-lspconfig"}
  use {"nvim-treesitter/nvim-treesitter",  run = ":TSUpdate" }
  use {"ibhagwan/fzf-lua"}
  use {"hrsh7th/nvim-cmp"}
  use {"hrsh7th/cmp-nvim-lsp"}
  use {"mfussenegger/nvim-dap", requires = "leoluz/nvim-dap-go"}
  use {"leoluz/nvim-dap-go"}
  use {"sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim"}
  use {"TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim"}

  use {"justinmk/vim-dirvish"}
  use {"mbbill/undotree"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"tpope/vim-sleuth"}
  use {"tpope/vim-surround"}

  if Packer then
    require('packer').sync()
  end
end)

require("impatient")

require("nightfox").setup {
  all = {
    NormalFloat = {
      link = "Normal"
    }
  }
}

local cmp = require("cmp")
cmp.setup {
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = "nvim_lsp" },
  }
}

-- LSP
local on_attach = function(_, bufnr)
  local opts = { silent = true, buffer = bufnr }

  l.omnifunc =  "v:lua.vim.lsp.omnifunc"

  nmap("<space>gd", vim.lsp.buf.definition, opts)
  nmap("<space>gi", vim.lsp.buf.implementation, opts)
  nmap("<space>gt", vim.lsp.buf.type_definition, opts)
  nmap("<space>gr", vim.lsp.buf.references, opts)
  nmap("<space>gn", vim.lsp.buf.rename, opts)
  nmap("<space>ga", vim.lsp.buf.code_action, opts)
  imap("K",         vim.lsp.buf.hover, opts)
  nmap("<C-k>",     vim.lsp.buf.signature_help, opts)
  nmap("<space>=",  vim.lsp.buf.formatting, opts)
  nmap("<space>w",  vim.lsp.buf.workspace_symbol, opts)
  nmap("<space>q",  vim.diagnostic.setqflist, opts)
  nmap("<space>e",  vim.diagnostic.open_float, opts)
  nmap("[g",        vim.diagnostic.goto_prev, opts)
  nmap("]g",        vim.diagnostic.goto_next, opts)
end

local border_opts = { border = "rounded" }

vim.diagnostic.config {
  signs = false,
  underline = false,
  virtual_text = true,
  float = border_opts,
}

local defaults = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200,
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts),
  }
}

local gopls = {
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    }
  }
}

local rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      }
    }
  }
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local sumneko_lua = {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
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
  ["sumneko_lua"] = sumneko_lua,
  ["texlab"] = {},
  ["tsserver"] = {},
}

local lspconfig = require("lspconfig")
for server, server_config in pairs(servers) do
  local config = vim.tbl_deep_extend("force", defaults, server_config)
  lspconfig[server].setup(config)
end

-- Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}

-- FZF
local fzf = require("fzf-lua")
fzf.setup {
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

nmap("<space>f", fzf.files)
nmap("<space>F", fzf.git_files)
nmap("<space>G", fzf.git_status)
nmap("<space>h", fzf.oldfiles)
nmap("<space>s", fzf.live_grep)
nmap("<space>r", fzf.resume)

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
      return fn.input("Path: ", fn.getcwd() .. "/", "file")
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

nmap("<space>c", dap.continue)
nmap("<space>x", dap.terminate)
nmap("<space>l", dap.run_last)
nmap("<space>R", dap.repl.toggle)
nmap("<space>b", dap.toggle_breakpoint)
nmap("<space>B", function() dap.set_breakpoint(fn.input('Breakpoint condition: ')) end)
nmap("<down>", dap.step_over)
nmap("<up>", dap.step_back)
nmap("<right>", dap.step_into)
nmap("<left>", dap.step_out)

-- Diffview
require("diffview").setup {
  use_icons = false,
  file_panel = {
    listing_style = "list",
  }
}

-- Gitsigns
require("gitsigns").setup {
  attach_to_untracked = false,
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }

    nmap("]c", gs.next_hunk, opts)
    nmap("[c", gs.prev_hunk, opts)
  end
}

cmd("colorscheme nordfox")

g.do_filetype_lua = 1
g.did_load_filetypes = 0

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
o.wildignorecase = true
o.wrap = false

if fn["executable"]("rg") then
  o.grepprg = "rg --no-heading --vimgrep"
  o.grepformat = "%f:%l:%c:%m"
end

nmap("H", "^")
nmap("L", "$")

imap("{<CR>", "{<CR>}<C-o>O")
imap("[<CR>", "[<CR>]<C-o>O")

nmap("gp", "`[v`]")
nmap("<space><space>", "<C-^>")

nmap("<C-j>", "<cmd>cnext<CR>")
nmap("<C-k>", "<cmd>cprev<CR>")

nmap("<space>dt", "<cmd>windo diffthis<CR>")
nmap("<space>do", "<cmd>windo diffoff<CR>")

nmap("<F1>", "<cmd>set invrnu<CR>")
nmap("<F2>", "<cmd>set invspell<CR>")
nmap("<F3>", "<cmd>set invwrap<CR>")
nmap("<F4>", "<cmd>set invlist<CR>")

cmd("cnoreabbrev Q q")
cmd("cnoreabbrev W w")
cmd("cnoreabbrev Wq wq")
cmd("cnoreabbrev Qa qa")

vim.api.nvim_create_user_command("Sbd", "b#|bd#", {})
vim.api.nvim_create_user_command("Whitespace", function()
  local save = fn.winsaveview()
  cmd([[keeppatterns %s/\s\+$//e]])
  fn.winrestview(save)
end, {})

vim.api.nvim_create_augroup("Personal", { clear = true })
local autocmd = function(name, opts)
  local extended = vim.tbl_deep_extend("keep", opts, { group = "Personal" })
  vim.api.nvim_create_autocmd(name, extended)
end

autocmd("TermOpen", { command = "startinsert", })
autocmd("QuickFixCmdPost", { pattern = "[^l]*", command = "cwindow" })
autocmd("BufWritePre", { callback = function() fn.mkdir(fn.expand("<afile>:h"), "p") end })
autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({timeout = 200}) end })
autocmd("FileType", { pattern = "c,cpp", command = [[setlocal commentstring=//\ %s]] })
autocmd("FileType", { pattern = "go", command = [[setlocal tabstop=4 shiftwidth=4 noexpandtab]] })
autocmd("FileType", { pattern = "gitcommit", command = [[setlocal spell spelllang=en]] })
