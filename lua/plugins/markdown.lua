-- Markdown preview rendered inside the buffer (headings, code blocks, tables, checkboxes, links).
-- Loaded on the first markdown buffer. Off by default (raw text); <leader>mp switches it on.
-- When on, rendering applies in normal mode (cursor line included); insert mode shows raw text.

-- The plugin/ file calls setup() with this table, then attaches to the current buffer.
vim.g.render_markdown_config = {
  enabled = false, -- start raw; <leader>mp turns the preview on
  file_types = { 'markdown' },
  anti_conceal = { enabled = false }, -- keep the cursor line rendered too
}
require('core.lazy').packadd('render-markdown.nvim')

local function set_keymaps(buf)
  local map = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
  end
  map('<leader>mp', function() require('render-markdown').toggle() end, 'Toggle preview / raw')
  map('<leader>ms', function() require('render-markdown').preview() end, 'Preview in side split')
end

set_keymaps(0)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_markdown', { clear = true }),
  pattern = 'markdown',
  callback = function(ev)
    set_keymaps(ev.buf)
  end,
})
