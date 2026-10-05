-- Minimal lazy-loading helpers built on autocommands (no plugin manager needed).
-- A loader is a module name (required once, `require` caches it) or a function (wrap it in M.once).
local M = {}

local group = vim.api.nvim_create_augroup('user_lazy', { clear = true })

---@alias LazyLoader string|fun()

---@param loader LazyLoader
local function run(loader)
  if type(loader) == 'string' then
    require(loader)
  else
    loader()
  end
end

--- Wrap `fn` so it only runs the first time it is called.
---@param fn fun()
---@return fun()
function M.once(fn)
  local done = false
  return function()
    if not done then
      done = true
      fn()
    end
  end
end

local added = {}

--- :packadd a plugin registered with `vim.pack.add(..., { load = function() end })` (only once).
---@param name string plugin directory name
function M.packadd(name)
  if not added[name] then
    added[name] = true
    vim.cmd.packadd(name)
  end
end

--- Run `loader` the first time any of `events` fires.
---@param events string|string[]
---@param loader LazyLoader
function M.on(events, loader)
  vim.api.nvim_create_autocmd(events, {
    group = group,
    once = true,
    callback = function()
      run(loader)
    end,
  })
end

--- Run `loader` right after the first screen has been drawn.
---@param loader LazyLoader
function M.after_ui(loader)
  M.on('UIEnter', function()
    vim.schedule(function()
      run(loader)
    end)
  end)
end

--- Define a stub `:name` command that runs `loader` (which must redefine `:name`), then re-runs the command.
---@param name string
---@param loader LazyLoader
function M.cmd(name, loader)
  vim.api.nvim_create_user_command(name, function(cmd)
    vim.api.nvim_del_user_command(name)
    run(loader)
    vim.cmd({ cmd = name, args = cmd.fargs, bang = cmd.bang })
  end, { nargs = '*', bang = true })
end

return M
