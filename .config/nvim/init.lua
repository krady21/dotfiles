local fn, api, cmd = vim.fn, vim.api, vim.cmd
local opt, optl = vim.opt, vim.opt_local
local map = vim.keymap.set
local lsp, diagnostic = vim.lsp, vim.diagnostic

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system { "git", "clone", "--depth", "1", "https://github.com/savq/paq-nvim.git", install_path }
end

require("paq") {
  { "savq/paq-nvim" },
  { "EdenEast/nightfox.nvim" },
  { "lewis6991/impatient.nvim" },

  { "ibhagwan/fzf-lua" },
  { "neovim/nvim-lspconfig" },
  { "folke/neodev.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "dcampos/nvim-snippy" },
  { "dcampos/cmp-snippy" },

  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/playground", opt = true },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "windwp/nvim-ts-autotag" },
  { "drybalka/tree-climber.nvim" },
  { "Wansmer/treesj" },

  { "mfussenegger/nvim-dap" },
  { "leoluz/nvim-dap-go" },

  { "lewis6991/gitsigns.nvim" },

  { "andymass/vim-matchup" },
  { "justinmk/vim-dirvish" },
  { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-surround" },
}

cmd.colorscheme("nordfox")

require("impatient")

opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.dictionary = "/usr/share/dict/words"
opt.diffopt:append("indent-heuristic,algorithm:histogram")
opt.expandtab = true
opt.hlsearch = false
opt.ignorecase = true
opt.incsearch = true
opt.lazyredraw = true
opt.listchars = "tab:> ,trail:∙,nbsp:•"
opt.mouse = ""
opt.nrformats:append("alpha")
opt.number = true
opt.path = ".,,**"
opt.relativenumber = true
opt.report = 0
opt.shiftwidth = 4
opt.shortmess:append("c")
opt.showbreak = "↳"
opt.smartcase = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.statusline = "%< %f %m%r%w%=%l/%-6L %3c "
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.virtualedit = "block,insert"
opt.wildignore = "*/.git/*,*/tmp/*,*.swp,*.o,*.pyc"
opt.wildignorecase = true

if fn.executable("rg") then
  opt.grepprg = "rg --no-heading --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end

map("t", "<Esc>", [[<C-\><C-n>]])

map({ "v", "n" }, "H", "^")
map({ "v", "n" }, "L", "$")

map("i", "{<CR>", "{<CR>}<C-o>O")
map("i", "[<CR>", "[<CR>]<C-o>O")
map("i", "(<CR>", "(<CR>)<C-o>O")

map("n", "gp", "`[v`]")
map("n", "<space><space>", "<C-^>")

map("n", "<C-j>", "<cmd>cnext<CR>")
map("n", "<C-k>", "<cmd>cprev<CR>")

map("n", "<space>dt", "<cmd>windo diffthis<CR>")
map("n", "<space>do", "<cmd>windo diffoff<CR>")

map("n", "<F1>", "<cmd>set invrnu<CR>")
map("n", "<F2>", "<cmd>set invspell<CR>")
map("n", "<F3>", "<cmd>set invwrap<CR>")
map("n", "<F4>", "<cmd>set invlist<CR>")

map("n", "j", "v:count ? 'j' : 'gj'", { expr = true })
map("n", "k", "v:count ? 'k' : 'gk'", { expr = true })

cmd.cnoreabbrev("Q q")
cmd.cnoreabbrev("W w")
cmd.cnoreabbrev("Wq wq")
cmd.cnoreabbrev("Qa qa")

command("Whitespace", function()
  local save = fn.winsaveview()
  cmd([[keeppatterns %s/\s\+$//e]])
  fn.winrestview(save)
end, {})
command("Sbd", "b#|bd#", {})

local gid = api.nvim_create_augroup("Personal", {})

autocmd("TermOpen", {
  group = gid,
  pattern = "*",
  command = "startinsert",
})

autocmd("QuickFixCmdPost", {
  group = gid,
  pattern = "[^l]*",
  command = "cwindow",
})

autocmd("BufWritePre", {
  group = gid,
  pattern = "*",
  command = [[call mkdir(expand("<afile>:h"), "p")]],
})

autocmd("TextYankPost", {
  group = gid,
  pattern = "*",
  callback = function() vim.highlight.on_yank { timeout = 200 } end,
})

autocmd("FileType", {
  group = gid,
  pattern = "c,cpp",
  callback = function() optl.commentstring = "// %s" end,
})

autocmd("FileType", {
  group = gid,
  pattern = "go",
  callback = function()
    optl.tabstop = 2
    optl.shiftwidth = 2
    optl.expandtab = false
  end,
})

autocmd("FileType", {
  group = gid,
  pattern = "python",
  callback = function() optl.makeprg = "python3% %" end,
})

autocmd("FileType", {
  group = gid,
  pattern = "gitcommit",
  callback = function()
    optl.spell = true
    optl.spelllang = "en"
  end,
})

require("nightfox").setup {
  groups = {
    all = {
      NormalFloat = {
        link = "Normal",
      },
      TreesitterContext = {
        bg = "palette.bg2",
      },
    },
  },
}

local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args) require("snippy").expand_snippet(args.body) end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping.confirm { select = false },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "snippy" },
  },
}

-- LSP
autocmd("LspAttach", {
  callback = function(args)
    optl.omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { noremap = true, silent = true, buffer = args.buf }

    map("n", "<space>gd", lsp.buf.definition, opts)
    map("n", "<space>gd", lsp.buf.definition, opts)
    map("n", "<space>gi", lsp.buf.implementation, opts)
    map("n", "<space>gt", lsp.buf.type_definition, opts)
    map("n", "<space>gr", lsp.buf.references, opts)
    map("n", "<space>gn", lsp.buf.rename, opts)
    map("n", "<space>ga", lsp.buf.code_action, opts)
    map("n", "K", lsp.buf.hover, opts)
    map("i", "<C-k>", lsp.buf.signature_help, opts)
    map("n", "<space>=", lsp.buf.format, opts)
    map("n", "<space>w", lsp.buf.workspace_symbol, opts)
  end,
})

map("n", "<space>q", diagnostic.setqflist)
map("n", "<space>e", diagnostic.open_float)
map("n", "[g", diagnostic.goto_prev)
map("n", "]g", diagnostic.goto_next)

local border_opts = { border = "rounded" }

diagnostic.config {
  signs = false,
  underline = false,
  virtual_text = true,
  float = border_opts,
}

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)

local lspconfig = require("lspconfig")
local servers = { "bashls", "clangd", "pyright", "graphql", "texlab", "tsserver", "sumneko_lua" }

for _, server in pairs(servers) do
  lspconfig[server].setup {}
end

lspconfig.gopls.setup {
  cmd = { "gopls", "serve" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

lspconfig.rust_analyzer.setup {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
}

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
  capabilities = capabilities,
}

lspconfig.html.setup {
  capabilities = capabilities,
}

-- Treesitter
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "+",
      node_incremental = "+",
      node_decremental = "_",
    },
  },
  textobjects = {
    select = {
      lookahead = true,
      enable = true,
      keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
  },
  context_commentstring = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
}

-- matchup
vim.g.matchup_matchparen_offscreen = {}

require("treesj").setup {}

map("n", "<space>gj", "<cmd>TSJJoin<CR>")
map("n", "<space>gk", "<cmd>TSJSplit<CR>")

map("n", "<M-j>", require("tree-climber").swap_next)
map("n", "<M-k>", require("tree-climber").swap_prev)

-- FZF
local fzf = require("fzf-lua")
fzf.setup {
  winopts = {
    hl_border = "VertSplit",
    preview = {
      layout = "vertical",
    },
  },
  keymap = {
    fzf = {
      ["ctrl-a"] = "toggle-all",
      ["ctrl-b"] = "beginning-of-line",
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
  },
}

local fd_opts = "--color=never --no-ignore --type f --hidden --follow --exclude .git"
local rg_opts =
  "--no-ignore --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512"

map("n", "<space>f", function() fzf.files() end)
map("n", "<space>F", function() fzf.files { fd_opts = fd_opts } end)
map("n", "<space>G", function() fzf.git_status() end)
map("n", "<space>h", function() fzf.oldfiles() end)
map("n", "<space>s", function() fzf.live_grep() end)
map("n", "<space>S", function() fzf.live_grep { rg_opts = rg_opts } end)
map("n", "<space>r", function() fzf.resume() end)

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
    program = function() return fn.input("Path: ", fn.getcwd() .. "/", "file") end,
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

dap.configurations.c = lldb
dap.configurations.cpp = lldb
dap.configurations.rust = lldb

require("dap-go").setup()

map("n", "<space>c", dap.continue)
map("n", "<space>x", dap.terminate)
map("n", "<space>l", dap.run_last)
map("n", "<space>R", dap.repl.toggle)
map("n", "<space>b", dap.toggle_breakpoint)
map("n", "<space>B", function() dap.set_breakpoint(fn.input("Condition: ")) end)
map("n", "<down>", dap.step_over)
map("n", "<up>", dap.step_back)
map("n", "<right>", dap.step_into)
map("n", "<left>", dap.step_out)

-- Gitsigns
require("gitsigns").setup {
  attach_to_untracked = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local opts = { noremap = true, buffer = bufnr }

    map("n", "]c", gs.next_hunk, opts)
    map("n", "[c", gs.prev_hunk, opts)
    map("n", "<space>p", gs.preview_hunk, opts)
  end,
}
