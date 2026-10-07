-- Colorscheme: catppuccin mocha with a transparent background
require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = true,
  float = { transparent = true }, -- file explorer, pickers and popups too (borders keep them distinct)
  no_italic = true,
  integrations = {
    blink_cmp = true,
    mason = true,
    -- Transparency also clears the statusline's middle section; keep it solid
    lualine = {
      all = function(C)
        return {
          normal = { c = { bg = C.mantle } },
          inactive = { a = { bg = C.mantle }, b = { bg = C.mantle }, c = { bg = C.mantle } },
        }
      end,
    },
  },
})

-- Undercurl diagnostics (re-applied if the colorscheme is ever reloaded)
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('user_colorscheme', { clear = true }),
  callback = function()
    for _, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint', 'Ok' }) do
      local group = 'DiagnosticUnderline' .. severity
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      hl.underline, hl.undercurl = nil, true
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
})

vim.cmd.colorscheme('catppuccin-mocha')
