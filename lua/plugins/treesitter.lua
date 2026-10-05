-- Treesitter: accurate syntax highlighting, indentation and folding.
-- Parsers come from lua/langs/*.lua `parsers` plus a few always-useful ones.
-- Requires the tree-sitter CLI and a C compiler (both installed).
local base_parsers = { 'vim', 'vimdoc', 'query', 'regex', 'diff', 'bash' }
local parsers = vim.list_extend(vim.deepcopy(base_parsers), require('langs').parsers)

require('nvim-treesitter').install(parsers) -- async; already installed parsers are skipped

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
  callback = function(ev)
    if not pcall(vim.treesitter.start, ev.buf) then
      return -- no parser for this filetype
    end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

-- Sticky scroll: keep the current function/class header at the top
require('treesitter-context').setup({ max_lines = 3 })

-- Auto close and auto rename paired JSX/HTML tags
require('nvim-ts-autotag').setup({})
