require('blink.cmp').setup({
  -- VSCode-like: <CR>/<Tab> accept, <C-Space> opens the menu, <Up>/<Down> or <C-n>/<C-p> to move
  keymap = {
    preset = 'enter',
    ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
  },
  completion = {
    list = { selection = { preselect = true, auto_insert = false } },
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true }, -- parameter hints while typing a call
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
