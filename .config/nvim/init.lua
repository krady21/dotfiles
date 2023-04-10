vim.loader.enable()

local fn, api, cmd = vim.fn, vim.api, vim.cmd
local g, opt, optl = vim.g, vim.opt, vim.opt_local
local map = vim.keymap.set
local lsp, diagnostic = vim.lsp, vim.diagnostic
local fs = vim.fs

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

local paq_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(paq_path)) > 0 then
  fn.system { "git", "clone", "--depth", "1", "https://github.com/savq/paq-nvim.git", paq_path }
end

require("paq") {
  { "savq/paq-nvim" },
  { "EdenEast/nightfox.nvim" },

  { "ibhagwan/fzf-lua" },
  { "neovim/nvim-lspconfig" },
  { "mfussenegger/nvim-jdtls" },
  { "elihunter173/dirbuf.nvim" },
  { "gbprod/substitute.nvim" },
  { "milisims/nvim-luaref" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "dcampos/cmp-snippy" },
  { "dcampos/nvim-snippy" },

  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/playground", opt = true },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "RRethy/nvim-treesitter-endwise" },
  { "windwp/nvim-ts-autotag" },
  { "drybalka/tree-climber.nvim" },

  { "mfussenegger/nvim-dap" },
  { "leoluz/nvim-dap-go" },

  { "nvim-lua/plenary.nvim" },
  { "sindrets/diffview.nvim" },

  { "lewis6991/gitsigns.nvim" },
  { "rhysd/conflict-marker.vim" },

  { "andymass/vim-matchup" },
  { "junegunn/vim-peekaboo" },
  { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-surround" },
}

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

cmd.colorscheme("nordfox")

opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.completeopt = { "menuone", "noselect" }
opt.dictionary = "/usr/share/dict/words"
opt.diffopt:append { "indent-heuristic" , "algorithm:histogram", "linematch:60" }
opt.expandtab = true
opt.gdefault = true
opt.hlsearch = false
opt.ignorecase = true
opt.incsearch = true
opt.lazyredraw = true
opt.listchars = { tab = "> ", trail = "∙", nbsp ="•" }
opt.mouse = ""
opt.nrformats:append("alpha")
opt.number = false
opt.path = ".,,**"
opt.relativenumber = false
opt.report = 0
opt.shiftwidth = 4
opt.shortmess:append("c")
opt.showbreak = "↳"
opt.signcolumn = "yes"
opt.smartcase = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.statusline = "%< %f %m%r%w%=%l/%-6L %3c "
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.virtualedit = { "block", "insert" }
opt.wildignore = "*/.git/*,*/tmp/*,*.swp,*.o,*.pyc"
opt.wildignorecase = true

opt.foldmethod = "expr"
opt.foldenable = false
opt.foldexpr = "nvim_treesitter#foldexpr()"

if fn.executable("rg") > 0 then
  opt.grepprg = "rg --no-heading --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end

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

map("n", "<F1>", "<cmd>set invnumber<CR>")
map("n", "<F2>", "<cmd>set invspell<CR>")
map("n", "<F3>", "<cmd>set invwrap<CR>")
map("n", "<F4>", "<cmd>set invlist<CR>")

map("n", "j", "v:count ? 'j' : 'gj'", { expr = true })
map("n", "k", "v:count ? 'k' : 'gk'", { expr = true })

map({ "n", "x" }, "c", [["_c]])
map({ "n", "x" }, "C", [["_C]])

map("x", "p", [["_dP]])

map("n", "dd", function()
  return api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd"
end, { expr = true })

map({"o", "x"}, "ae", function() cmd.normal("ggVG") end, { silent = true })

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
  callback = function () pcall(fn.mkdir, fn.expand("<afile>:h"), "p") end
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
  callback = function() optl.makeprg = "python3 %" end,
})

autocmd("FileType", {
  group = gid,
  pattern = "gitcommit",
  callback = function()
    optl.spell = true
    optl.spelllang = "en"
  end,
})

autocmd("FileType", {
  group = gid,
  pattern = "dirbuf",
  callback = function()
    -- muscle memory from dirvish
    optl.cursorline = true
    map("n", "gq", cmd.DirbufQuit, { buffer = 0 })
  end,
})

local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args) require("snippy").expand_snippet(args.body) end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
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
local servers = {
  "bashls",
  "clangd",
  "pyright",
  "graphql",
  "texlab",
  "tsserver",
  "lua_ls",
  "html",
  "cssls",
  "emmet_ls",
}

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.semanticTokens = nil

for _, server in pairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
  }
end

lspconfig.gopls.setup {
  cmd = { "gopls", "serve" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        nilness = true,
      },
      staticcheck = true,
    },
  },
}

lspconfig.rust_analyzer.setup {
  cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        features = "all",
      },
    },
  },
}

autocmd("FileType", {
  group = gid,
  pattern = "java",
  callback = function()
    require('jdtls').start_or_attach({
      cmd = fn.exepath("jdtls"),
      root_dir = fs.dirname(fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    })
  end,
})

-- Treesitter
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
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
        ["iC"] = "@conditional.inner",
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
  endwise = {
    enable = true,
  },
}

-- matchup
g.matchup_matchparen_offscreen = {}

map("n", "<M-j>", function() require("tree-climber").swap_next() end)
map("n", "<M-k>", function() require("tree-climber").swap_prev() end)

-- FZF
local fzf = require("fzf-lua")
-- fzf.register_ui_select()
fzf.setup {
  winopts = {
    hl_border = "VertSplit",
    preview = {
      layout = "vertical",
    },
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "toggle-all",
      ["ctrl-a"] = "select-all",
      ["ctrl-b"] = "half-page-up",
      ["ctrl-f"] = "half-page-down",
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

map("n", "<space>f", function() fzf.files() end)
map("n", "<space>F", function() fzf.files { fd_opts = "--color=never --no-ignore --type f --hidden --follow --exclude .git" } end)
map("n", "<space>t", function() fzf.buffers() end)
map("n", "<space>G", function() fzf.git_status() end)
map("n", "<space>h", function() fzf.oldfiles() end)
map("n", "<space>H", function() fzf.help_tags() end)
map("n", "<space>s", function() fzf.live_grep() end)
map("n", "<space>S", function() fzf.live_grep { rg_opts = "--no-ignore --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512" } end)
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

map("n", "<F5>", function() dap.continue() end)
map("n", "<F6>", function() dap.run_last() end)
map("n", "<F7>", function() dap.terminate() end)
map("n", "<space>b", function() dap.toggle_breakpoint() end)
map("n", "<space>B", function() dap.set_breakpoint(fn.input("Condition: ")) end)
map("n", "<down>", function() dap.step_over() end)
map("n", "<up>", function() dap.step_back() end)
map("n", "<right>", function() dap.step_into() end)
map("n", "<left>", function() dap.step_out() end)

-- gitsigns
require("gitsigns").setup {
  attach_to_untracked = false,
  on_attach = function(bufnr)
    local opts = { noremap = true, buffer = bufnr }

    map("n", "]c", require("gitsigns").next_hunk, opts)
    map("n", "[c", require("gitsigns").prev_hunk, opts)
    map("n", "<space>p", require("gitsigns").preview_hunk, opts)
  end,
}

-- substitute
require("substitute").setup()

map("n", "<space>x", function() require("substitute").operator() end)
map("n", "cx", function() require("substitute.exchange").operator() end)
map("n", "cxc", function() require("substitute.exchange").cancel() end)
