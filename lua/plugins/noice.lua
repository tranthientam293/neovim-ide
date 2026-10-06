-- Noice: command line as a floating popup in the center of the screen, plus messages and
-- notifications (shown through Snacks notifier). Loaded right after the first screen is drawn.
require('noice').setup({
  presets = {
    bottom_search = true, -- / and ? stay at the bottom like the built-in search
    long_message_to_split = true, -- long messages open in a split instead of a popup
  },
  lsp = {
    signature = { enabled = false }, -- blink.cmp already shows signature help
  },
})

vim.keymap.set('n', '<leader>fm', '<cmd>Noice pick<cr>', { desc = 'Message history' })

-- Backdrop: dim the editor while the `:` popup is open so focus stays on the command line.
-- A full-screen float just under Noice's cmdline_popup (zindex 200); completion menus sit above both.
local backdrop = { win = nil, buf = nil }
local group = vim.api.nvim_create_augroup('CmdlineBackdrop', { clear = true })
vim.api.nvim_set_hl(0, 'CmdlineBackdrop', { bg = '#1e1e2e', default = true })

local function close_backdrop()
  if backdrop.win and vim.api.nvim_win_is_valid(backdrop.win) then
    vim.api.nvim_win_close(backdrop.win, true)
  end
  backdrop.win = nil
end

local function open_backdrop()
  if backdrop.win and vim.api.nvim_win_is_valid(backdrop.win) then
    return
  end
  if not (backdrop.buf and vim.api.nvim_buf_is_valid(backdrop.buf)) then
    backdrop.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[backdrop.buf].bufhidden = 'hide'
  end
  backdrop.win = vim.api.nvim_open_win(backdrop.buf, false, {
    relative = 'editor',
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    style = 'minimal',
    border = 'none',
    zindex = 199,
    noautocmd = true,
  })
  vim.wo[backdrop.win].winblend = 40 -- 40% opacity (0 = solid, 100 = no dimming)
  vim.wo[backdrop.win].winhighlight = 'Normal:CmdlineBackdrop,NormalFloat:CmdlineBackdrop'
end

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = group,
  callback = function()
    if vim.fn.getcmdtype() ~= ':' then
      return -- keep / and ? searches undimmed so matches stay visible
    end
    vim.schedule(function()
      if vim.fn.getcmdtype() == ':' then
        open_backdrop()
        vim.cmd.redraw()
      end
    end)
  end,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = group,
  callback = function()
    vim.schedule(close_backdrop)
  end,
})
vim.api.nvim_create_autocmd('VimResized', {
  group = group,
  callback = function()
    if backdrop.win and vim.api.nvim_win_is_valid(backdrop.win) then
      vim.api.nvim_win_set_config(backdrop.win, {
        relative = 'editor',
        row = 0,
        col = 0,
        width = vim.o.columns,
        height = vim.o.lines,
      })
    end
  end,
})
