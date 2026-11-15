-- Merged on top of nvim-lspconfig's lsp/tailwindcss.lua
-- Settings mirror VSCode's `tailwindCSS.*` settings.

-- Show colors as a small swatch before the class instead of painting the text background
-- (Neovim enables LSP document colors by default with style = 'background').
vim.lsp.document_color.enable(true, nil, { style = 'virtual' })

local project = require('core.project')
local base_file = vim.api.nvim_get_runtime_file('lsp/tailwindcss.lua', false)[1]
local base = base_file and dofile(base_file) or {}

return {
  -- lspconfig falls back to `.git` (for Tailwind v4, which has no config file), so it would attach
  -- in every git repo. Only attach when the project really uses Tailwind (config file or
  -- `tailwindcss` in a package.json).
  root_dir = function(bufnr, on_dir)
    if not project.uses(bufnr, 'tailwind') then
      return
    end
    if base.root_dir then
      return base.root_dir(bufnr, on_dir)
    end
    on_dir(project.root(bufnr))
  end,
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      -- Class completion/hover inside these helper calls, e.g. cn('px-2', cond && 'text-red-500')
      classFunctions = { 'cn', 'clsx', 'cva', 'cx', 'tw', 'twMerge', 'twJoin', 'tv' },
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidConfigPath = 'error',
        invalidScreen = 'error',
        invalidTailwindDirective = 'error',
        invalidVariant = 'error',
        recommendedVariantOrder = 'warning',
      },
      validate = true,
    },
  },
}
