local lint = require('lint')

lint.linters_by_ft = require('langs').linters

-- golangci-lint ---------------------------------------------------------------------
-- * Lint the file's package dir inside a module, or the file itself outside one.
-- * Run from the module root: from any other cwd it finds no Go files (exit 5).
-- * Code that doesn't compile (normal mid-edit) makes it log a typecheck error and exit 7.
--   gopls already reports those, so the exit code is ignored and only other errors are shown.
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

  local parse = golangcilint.parser
  golangcilint.ignore_exitcode = true
  golangcilint.parser = function(output, bufnr, cwd)
    local ok, decoded = pcall(vim.json.decode, output)
    local err = ok and type(decoded) == 'table' and type(decoded.Report) == 'table' and decoded.Report.Error
    if type(err) == 'string' and err ~= '' and not err:find('typechecking error', 1, true) then
      vim.notify('golangci-lint: ' .. err, vim.log.levels.WARN)
    end
    return ok and parse(output, bufnr, cwd) or {}
  end

  lint.linters.golangcilint = function()
    local file = vim.api.nvim_buf_get_name(0)
    golangcilint.cwd = vim.fs.root(file, { 'go.work', 'go.mod' }) or vim.fs.dirname(file)
    return golangcilint
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('user_lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
