-- Merged on top of nvim-lspconfig's lsp/tailwindcss.lua
-- Settings mirror VSCode's `tailwindCSS.*` settings.

-- Show colors as a small swatch before the class instead of painting the text background
-- (Neovim enables LSP document colors by default with style = 'background').
vim.lsp.document_color.enable(true, nil, { style = 'virtual' })

return {
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
