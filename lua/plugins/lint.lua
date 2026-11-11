local lint = require('lint')

lint.linters_by_ft = require('langs').linters

local golangcilint = lint.linters.golangcilint
if golangcilint and type(golangcilint.args) == 'table' then
  local args = golangcilint.args
  if type(args[#args]) == 'function' then
    args[#args] = function()
      local file = vim.api.nvim_buf_get_name(0)
      local in_module = vim.fs.root(file, { 'go.mod', 'go.work' }) ~= nil
      return vim.fn.fnamemodify(file, in_module and ':h' or ':p')
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('user_lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
