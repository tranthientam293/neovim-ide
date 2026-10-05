-- Colorschemes. Pick one with <leader>tc (live preview); the choice is remembered across restarts.
local default = 'catppuccin-mocha'
local state_file = vim.fs.joinpath(vim.fn.stdpath('state'), 'colorscheme')

require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = true,
  float = { transparent = true }, -- file explorer, pickers and popups too (borders keep them distinct)
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
require('tokyonight').setup({ style = 'night' })
require('kanagawa').setup({})
require('gruvbox').setup({})
require('solarized-osaka').setup({ transparent = true })

-- Applied to every theme: undercurl diagnostics
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('user_colorscheme', { clear = true }),
  callback = function(ev)
    for _, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint', 'Ok' }) do
      local group = 'DiagnosticUnderline' .. severity
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      hl.underline, hl.undercurl = nil, true
      vim.api.nvim_set_hl(0, group, hl)
    end
    -- Remember the choice (cancelling the picker restores and re-saves the original)
    pcall(vim.fn.writefile, { ev.match }, state_file)
  end,
})

local saved = vim.fn.filereadable(state_file) == 1 and vim.fn.readfile(state_file)[1] or nil
if not (saved and pcall(vim.cmd.colorscheme, saved)) then
  vim.cmd.colorscheme(default)
end




vim.keymap.set('n', '<leader>tc', function()
  Snacks.picker.colorschemes()
end, { desc = 'Switch colorscheme' })
