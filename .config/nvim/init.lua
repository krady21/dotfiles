vim.loader.enable()

local fn, api, cmd = vim.fn, vim.api, vim.cmd
local g, opt, optl = vim.g, vim.opt, vim.opt_local
local map = vim.keymap.set
local lsp, diagnostic = vim.lsp, vim.diagnostic
local fs, json = vim.fs, vim.json
local uv = vim.loop

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

local paq_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(paq_path)) > 0 then
  fn.system { "git", "clone", "--depth", "1", "https://github.com/savq/paq-nvim.git", paq_path }
end

require("paq") {
  { "savq/paq-nvim" },
  { "EdenEast/nightfox.nvim" },
  { "arzg/vim-colors-xcode" },

  { "ibhagwan/fzf-lua" },
  { "neovim/nvim-lspconfig" },
  { "folke/neodev.nvim" },
  { "elihunter173/dirbuf.nvim" },
  { "gbprod/substitute.nvim" },
  { "milisims/nvim-luaref" },
  { "j-hui/fidget.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "dcampos/cmp-snippy" },
  { "dcampos/nvim-snippy" },

  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/playground", opt = true },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-endwise" },
  { "windwp/nvim-ts-autotag" },
  { "drybalka/tree-climber.nvim" },

  { "mfussenegger/nvim-dap" },

  { "nvim-lua/plenary.nvim" },
  { "sindrets/diffview.nvim" },

  { "lewis6991/gitsigns.nvim" },
  { "rhysd/conflict-marker.vim" },

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
opt.diffopt:append { "indent-heuristic", "algorithm:histogram", "linematch:60" }
opt.expandtab = true
opt.hlsearch = false
opt.ignorecase = true
opt.incsearch = true
opt.lazyredraw = true
opt.listchars = { tab = "> ", trail = "∙", nbsp = "•" }
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

if fn.executable("rg") > 0 then
  opt.grepprg = "rg --no-heading --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end

map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "$")

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

map(
  "n",
  "dd",
  function() return api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd" end,
  { expr = true }
)

map({ "o", "x" }, "ae", function() cmd.normal("ggVG") end, { silent = true })

cmd.cnoreabbrev { "Q", "q" }
cmd.cnoreabbrev { "W", "w" }
cmd.cnoreabbrev { "Wq", "wq" }
cmd.cnoreabbrev { "Qa", "qa" }

cmd.cnoreabbrev { "tq", "tabclose" }
cmd.cnoreabbrev { "grep", "silent grep!" }

command("Whitespace", function()
  local save = fn.winsaveview()
  cmd([[keeppatterns %s/\s\+$//e]])
  fn.winrestview(save)
end, {})
command("Sbd", "b#|bd#", {})

local gid = api.nvim_create_augroup("Personal", {})

autocmd("QuickFixCmdPost", {
  group = gid,
  pattern = "[^l]*",
  command = "cwindow",
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

map("i", "<Tab>", require("snippy.mapping").expand_or_advance("<Tab>"))
map("s", "<Tab>", require("snippy.mapping").next("<Tab>"))
map({ "i", "s" }, "<S-Tab>", require("snippy.mapping").previous("<S-Tab>"))

-- vim.diagnostic
local min_severity = { min = diagnostic.severity.WARN }
local border_opts = { border = "rounded" }

diagnostic.config {
  signs = false,
  underline = false,
  virtual_text = { severity = min_severity },
  float = border_opts,
}

-- LSP
local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("neodev").setup()

local servers = {
  ["clangd"] = {
    filetypes = "c,cpp",
    root_dir = { ".clang-format", "compile_commands.json", ".git" },
    capabilities = {
      textDocument = {
        completion = {
          editsNearCursor = true,
        },
      },
      offsetEncoding = { "utf-8", "utf-16" },
    },
  },
  ["gopls"] = {
    filetypes = "go",
    opts = { "serve" },
    root_dir = { "go.mod", ".git" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          nilness = true,
        },
        staticcheck = true,
      },
    },
  },
  ["pyright-langserver"] = {
    filetypes = "python",
    opts = { "--stdio" },
    root_dir = { "setup.py", "requirements.txt", ".git" },
    settings = {
      bashIde = {
        globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
      },
    },
  },
  ["jdtls"] = {
    filetypes = "java",
    root_dir = { "gradlew", ".git", "mvnw" },
  },
  ["lua-language-server"] = {
    filetypes = "lua",
    before_init = require("neodev.lsp").before_init,
    settings = {
      Lua = {
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
      },
    },
  },
  ["bash-language-server"] = {
    filetypes = "sh,bash",
    opts = { "start" },
  },
  ["typescript-language-server"] = {
    filetypes = "javascript,typescript",
    opts = { "--stdio" },
    root_dir = { "tsconfig.json", "package.json", ".git" },
  },
  ["vscode-html-language-server"] = {
    filetypes = "html",
    opts = { "--stdio" },
    root_dir = { "package.json", ".git" },
    init_options = {
      provideFormatter = true,
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { "html", "css", "javascript" },
    },
  },
  ["emmet-ls"] = {
    filetypes = "html",
    opts = { "--stdio" },
    root_dir = { "package.json", ".git" },
  },
  ["vscode-css-language-server"] = {
    filetypes = "css,scss,less",
    opts = { "--stdio" },
    root_dir = { "package.json", ".git" },
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
  },
  ["rust-analyzer"] = {
    filetypes = "rust",
    root_dir = { "Cargo.toml", ".git" },
    settings = {
      ["rust-analyzer"] = {
        cachePriming = { enable = false },
        cargo = { features = "all" },
      },
    },
  },
}

local lsp_group = api.nvim_create_augroup("Lsp", {})

for cmd, config in pairs(servers) do
  autocmd("FileType", {
    group = lsp_group,
    pattern = config.filetypes,
    callback = function()
      if optl.buftype:get() ~= "" or fn.executable(cmd) ~= 1 then
        return
      end

      local root_dir
      if config.root_dir then
        root_dir = fs.dirname(fs.find(config.root_dir or {}, {
          upward = true,
          stop = uv.os_homedir(),
          path = fs.dirname(),
        })[1])
      else
        root_dir = uv.cwd()
      end
      vim.print(root_dir)

      lsp.start({
        name = cmd,
        cmd = { cmd, unpack(config.opts or {}) },
        root_dir = root_dir,
        capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {}),
        before_init = config.before_init,
        settings = config.settings,
      })
    end,
  })
end

autocmd("LspAttach", {
  group = lsp_group,
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

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

map("n", "<space>q", diagnostic.setqflist)
map("n", "<space>e", diagnostic.open_float)
map("n", "[g", function() diagnostic.goto_prev { severity = min_severity } end)
map("n", "]g", function() diagnostic.goto_next { severity = min_severity } end)

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)

-- Treesitter
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, buf)
      local max_filesize_KB = 200 * 1024
      local ok, stats = pcall(uv.fs_stat, api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > max_filesize_KB
    end,
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
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
      },
    },
  },
  autotag = {
    enable = true,
  },
}

map("n", "<M-j>", function() require("tree-climber").swap_next() end)
map("n", "<M-k>", function() require("tree-climber").swap_prev() end)

-- FZF
local fzf = require("fzf-lua")
-- fzf.register_ui_select()
fzf.setup {
  fzf_opts = {
    ["--history"] = fn.stdpath("data") .. "/fzf-lua-history",
  },
  grep = {
    rg_glob = true,
  },
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
map("n", "<space>t", function() fzf.buffers() end)
map("n", "<space>G", function() fzf.git_status() end)
map("n", "<space>h", function() fzf.oldfiles() end)
map("n", "<space>H", function() fzf.help_tags() end)
map("n", "<space>s", function() fzf.live_grep() end)
map("n", "<space>r", function() fzf.resume() end)
map(
  "n",
  "<space>F",
  function() fzf.files { fd_opts = "--color=never --no-ignore --type f --hidden --follow --exclude .git" } end
)
map(
  "n",
  "<space>S",
  function()
    fzf.live_grep {
      rg_opts = "--no-ignore --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512",
    }
  end
)

-- DAP
local dap = require("dap")
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode-10",
  name = "lldb",
}

dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

local lldb = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function() return fn.input("Path: ", uv.cwd() .. "/", "file") end,
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

local delve = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

dap.configurations.c = lldb
dap.configurations.cpp = lldb
dap.configurations.rust = lldb
dap.configurations.go = delve

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

    map("n", "]c", function() require("gitsigns").next_hunk() end, opts)
    map("n", "[c", function() require("gitsigns").prev_hunk() end, opts)
    map("n", "<space>p", function() require("gitsigns").preview_hunk() end, opts)
  end,
}

-- diffview
require("diffview").setup {
  use_icons = false,
  show_help_hints = false,
  file_panel = {
    listing_style = "list",
  },
}

-- substitute
require("substitute").setup()

map("n", "s", function() require("substitute").operator() end)
map("n", "cx", function() require("substitute.exchange").operator() end)
map("n", "cxc", function() require("substitute.exchange").cancel() end)

require("fidget").setup()
