local on_attach = function(client, bufnr)
  local function buf_nnoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true }) end
  local function buf_inoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, "i", lhs, rhs, { noremap = true }) end
  local function buf_option(...)        vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_option("omnifunc", "v:lua.vim.lsp.omnifunc")

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
end

local defaults = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "single"
      }
    ),
    ["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "single"
      }
    ),
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        underline = false,
        virtual_text = true,
      }
    )
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
  ["clangd"] = {},
  ["hls"] = {},
  ["pyright"] = {},
  ["rust_analyzer"] = rust_analyzer,
  ["texlab"] = {},
}

local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", defaults, config))
end
