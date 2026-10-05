local langs = require('langs')

-- Install language servers + tools ------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup({ automatic_enable = false }) -- servers are enabled explicitly below
require('mason-tool-installer').setup({
  ensure_installed = vim.list_extend(vim.deepcopy(langs.servers), langs.tools),
  auto_update = false,
  run_on_start = true,
})

-- Defaults shared by every server (per-server overrides live in after/lsp/<name>.lua)
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.enable(langs.servers)

-- Diagnostics ----------------------------------------------------------------
local icons = require('core.icons').diagnostics
local severity_icons = {}
for name, icon in pairs(icons) do
  severity_icons[vim.diagnostic.severity[name]] = icon
end

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = function(diagnostic)
      return severity_icons[diagnostic.severity]
    end,
  },
  float = {
    source = 'if_many',
    prefix = function(diagnostic)
      local name = vim.diagnostic.severity[diagnostic.severity]
      return severity_icons[diagnostic.severity], 'DiagnosticSign' .. name:sub(1, 1) .. name:sub(2):lower()
    end,
  },
  signs = { text = severity_icons },
})

vim.lsp.inlay_hint.enable(false) -- off by default; toggle with <leader>th
vim.lsp.codelens.enable(false) -- no "N references" lenses; toggle with <leader>cl

-- Keymaps & per-buffer features on attach --------------------------------------
-- Neovim defaults already provide: K (hover), grn (rename), gra (code action),
-- grr (references), gri (implementation), grt (type definition), gO (symbols),
-- [d / ]d (prev/next diagnostic), <C-s> in insert mode (signature help).
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local bufnr = ev.buf

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = 'LSP: ' .. desc })
    end

    local picker = function(name)
      return function()
        Snacks.picker[name]()
      end
    end

    -- Navigation (results open in a picker with preview, like VSCode's peek)
    map('n', 'gd', picker('lsp_definitions'), 'Go to definition')
    map('n', '<F12>', picker('lsp_definitions'), 'Go to definition')
    map('n', 'gD', picker('lsp_declarations'), 'Go to declaration')
    map('n', 'gy', picker('lsp_type_definitions'), 'Go to type definition')
    map('n', 'grr', picker('lsp_references'), 'Find references')
    map('n', '<S-F12>', picker('lsp_references'), 'Find references')
    map('n', 'gri', picker('lsp_implementations'), 'Go to implementation')
    map('n', '<leader>fs', picker('lsp_symbols'), 'Document symbols')
    map('n', '<leader>fS', picker('lsp_workspace_symbols'), 'Workspace symbols')
    map('n', '<C-S-o>', picker('lsp_symbols'), 'Document symbols')

    -- Editing
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map({ 'n', 'v' }, '<C-.>', vim.lsp.buf.code_action, 'Code action')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>cl', function()
      vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, 'Toggle codelens')
    map('n', '<leader>cr', '<cmd>lsp restart<cr>', 'Restart LSP')

    -- Diagnostics
    map('n', '<leader>dl', vim.diagnostic.open_float, 'Line diagnostics')
    map('n', '<leader>dd', picker('diagnostics_buffer'), 'Buffer diagnostics')
    map('n', '<leader>dD', picker('diagnostics'), 'Workspace diagnostics')
    map('n', '<leader>q', vim.diagnostic.setloclist, 'Diagnostics list')
    map('n', '<leader>dt', function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, 'Toggle diagnostics')
    map('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, 'Toggle inlay hints')

    -- Highlight other references of the symbol under the cursor (like VSCode)
    if client:supports_method('textDocument/documentHighlight', bufnr) then
      local group = vim.api.nvim_create_augroup('user_lsp_highlight_' .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
