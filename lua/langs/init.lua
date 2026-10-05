-- Language registry.
--
-- Every file in lua/langs/ (except this one) describes one language/stack:
--
--   return {
--     servers    = { 'vtsls' },                        -- LSP names (nvim-lspconfig names)
--     formatters = { typescript = { 'prettierd' } },   -- conform.nvim formatters_by_ft
--     linters    = { sh = { 'shellcheck' } },          -- nvim-lint linters_by_ft (for non-LSP linters)
--     tools      = { 'prettierd' },                    -- extra Mason packages to auto-install
--     parsers    = { 'typescript', 'tsx' },            -- treesitter parsers (syntax highlight, folds, indent)
--   }
--
-- Per-server settings go in after/lsp/<server>.lua.
-- To add a language: create lua/langs/<name>.lua and restart Neovim.

local M = {
  servers = {},
  formatters = {},
  linters = {},
  tools = {},
  parsers = {},
}

local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'langs')

for name, type in vim.fs.dir(dir) do
  if type == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
    local mod = 'langs.' .. name:gsub('%.lua$', '')
    local ok, spec = pcall(require, mod)
    if not ok then
      vim.notify('Failed to load ' .. mod .. ': ' .. spec, vim.log.levels.ERROR)
    else
      vim.list_extend(M.servers, spec.servers or {})
      vim.list_extend(M.tools, spec.tools or {})
      vim.list_extend(M.parsers, spec.parsers or {})
      M.formatters = vim.tbl_extend('force', M.formatters, spec.formatters or {})
      M.linters = vim.tbl_extend('force', M.linters, spec.linters or {})
    end
  end
end

M.servers = vim.fn.uniq(vim.fn.sort(M.servers))
M.tools = vim.fn.uniq(vim.fn.sort(M.tools))
M.parsers = vim.fn.uniq(vim.fn.sort(M.parsers))

return M
