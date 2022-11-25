lua << EOF
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/savq/paq-nvim.git", install_path})
end

require("paq") {
  {"savq/paq-nvim"};
  {"EdenEast/nightfox.nvim"};

  {"ibhagwan/fzf-lua"};
  {"neovim/nvim-lspconfig"};
  {"folke/neodev.nvim"};

  {"hrsh7th/nvim-cmp"};
  {"hrsh7th/cmp-nvim-lsp"};
  {"hrsh7th/cmp-path"};
  {"dcampos/nvim-snippy"};
  {"dcampos/cmp-snippy"};

  {"nvim-treesitter/nvim-treesitter"};
  {"nvim-treesitter/playground", opt=true};
  {"nvim-treesitter/nvim-treesitter-context"};
  {"nvim-treesitter/nvim-treesitter-textobjects"};
  {"JoosepAlviste/nvim-ts-context-commentstring"};
  {"windwp/nvim-ts-autotag"};
  {"drybalka/tree-climber.nvim"};
  {"Wansmer/treesj"};

  {"mfussenegger/nvim-dap"};
  {"leoluz/nvim-dap-go"};

  {"lewis6991/gitsigns.nvim"};

  {"andymass/vim-matchup"};
  {"justinmk/vim-dirvish"};
  {"svermeulen/vim-subversive"};
  {"tommcdo/vim-exchange"};
  {"tpope/vim-commentary"};
  {"tpope/vim-repeat"};
  {"tpope/vim-sleuth"};
  {"tpope/vim-surround"};
}

require("nightfox").setup {
  groups = {
    all = {
      NormalFloat = {
        link = "Normal"
      },
      TreesitterContext = {
        bg = "palette.bg2"
      }
    }
  }
}

local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "snippy" },
  }
}

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].omnifunc =  "v:lua.vim.lsp.omnifunc"

    local opts = { noremap = true, silent = true, buffer = args.buf }

    vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>gn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<space>ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "K",         vim.lsp.buf.hover, opts)
    vim.keymap.set("i", "<C-k>",     vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>=",  vim.lsp.buf.format, opts)
    vim.keymap.set("n", "<space>w",  vim.lsp.buf.workspace_symbol, opts)
  end
})

vim.keymap.set("n", "<space>q", vim.diagnostic.setqflist, opts)
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[g",       vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]g",       vim.diagnostic.goto_next, opts)

local border_opts = { border = "rounded" }

vim.diagnostic.config({
  signs = false,
  underline = false,
  virtual_text = true,
  float = border_opts,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)

local lspconfig = require("lspconfig")
local servers = { "bashls", "clangd", "pyright", "graphql", "texlab", "tsserver" }

for _, server in pairs(servers) do
  lspconfig[server].setup{}
end

lspconfig.gopls.setup {
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

lspconfig.rust_analyzer.setup {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      }
    }
  }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
  capabilities = capabilities,
}

lspconfig.html.setup {
  capabilities = capabilities,
}

-- Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '+',
      node_incremental = '+',
      node_decremental = '_',
    },
  },
  textobjects = {
    select = {
      lookahead = true,
      enable  = true,
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

vim.g.matchup_matchparen_offscreen = {}

require('treesj').setup({})

vim.keymap.set('n', '<space>gj', "<cmd>TSJJoin<CR>")
vim.keymap.set('n', '<space>gk', "<cmd>TSJSplit<CR>")

vim.keymap.set('n', '<M-j>', require('tree-climber').swap_next)
vim.keymap.set('n', '<M-k>', require('tree-climber').swap_prev)

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
  }
}

local fd_opts = "--color=never --no-ignore --type f --hidden --follow --exclude .git"
local rg_opts = "--no-ignore --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512"

vim.keymap.set("n", "<space>f", function() fzf.files() end)
vim.keymap.set("n", "<space>F", function() fzf.files({ fd_opts = fd_opts }) end)
vim.keymap.set("n", "<space>G", function() fzf.git_status() end)
vim.keymap.set("n", "<space>h", function() fzf.oldfiles() end)
vim.keymap.set("n", "<space>s", function() fzf.live_grep() end)
vim.keymap.set("n", "<space>S", function() fzf.live_grep({ rg_opts = rg_opts}) end)
vim.keymap.set("n", "<space>r", function() fzf.resume() end)

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

vim.keymap.set("n", "<space>c", dap.continue)
vim.keymap.set("n", "<space>x", dap.terminate)
vim.keymap.set("n", "<space>l", dap.run_last)
vim.keymap.set("n", "<space>R", dap.repl.toggle)
vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>B", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<down>", dap.step_over)
vim.keymap.set("n", "<up>", dap.step_back)
vim.keymap.set("n", "<right>", dap.step_into)
vim.keymap.set("n", "<left>", dap.step_out)

-- Gitsigns
require("gitsigns").setup {
  attach_to_untracked = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local opts = { noremap = true, buffer = bufnr }

    vim.keymap.set("n", "]c", gs.next_hunk, opts)
    vim.keymap.set("n", "[c", gs.prev_hunk, opts)
    vim.keymap.set("n", "<space>p", gs.preview_hunk, opts)
  end
}
EOF

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
set signcolumn=yes
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
set wildignorecase
set mouse=

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

if executable("rg")
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

tnoremap <Esc> <C-\><C-n>

noremap H ^
noremap L $

inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O
inoremap (<CR> (<CR>)<C-o>O

nmap R  <Plug>(SubversiveSubstitute)
nmap RR <Plug>(SubversiveSubstituteLine)

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

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

cnoreabbrev Q q
cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa
cnoreabbrev fd Fd

command! Whitespace let b:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:save)
command! Sbd b#|bd#

augroup Personal
  autocmd!
  autocmd TermOpen * startinsert
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd BufWritePre * call mkdir(expand("<afile>:h"), "p")
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout = 200}
  autocmd FileType c,cpp setlocal commentstring=//\ %s
  autocmd FileType go setlocal tabstop=2 shiftwidth=2 noexpandtab
  autocmd FileType python setlocal makeprg=python%\ %
  autocmd FileType gitcommit setlocal spell spelllang=en
augroup END
