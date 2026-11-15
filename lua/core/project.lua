-- Detect which JS/TS tools the buffer's project is set up for.
--
-- A project "uses" a tool when a config file for it exists in a parent directory of the buffer,
-- or when a package.json up the tree mentions it (as a dependency or a config key).
-- The search stops at the repository root (.git), so a stray config in $HOME doesn't count.

local M = {}

M.tools = {
  eslint = {
    files = {
      'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
      'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
      '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json',
    },
    pkg = { 'eslintConfig' },
  },
  oxlint = {
    files = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' },
    pkg = { 'oxlint' },
  },
  biome = {
    files = { 'biome.json', 'biome.jsonc', '.biome.json', '.biome.jsonc' },
    pkg = { '@biomejs/biome' },
  },
  tailwind = {
    files = { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts' },
    pkg = { 'tailwindcss' }, -- v4 has no config file, but the package is always a dependency
  },
  oxfmt = {
    files = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' },
    pkg = { 'oxfmt' },
  },
}

local function buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name ~= '' and vim.fs.dirname(name) or vim.fn.getcwd()
end

-- The directory above the repo root, used as the `stop` of upward searches
local function stop_dir(dir)
  local git = vim.fs.root(dir, '.git')
  return git and vim.fs.dirname(git) or nil
end

-- Does any package.json between `dir` and the repo root contain `"<key>"`?
local function package_json_mentions(dir, keys)
  local files = vim.fs.find('package.json', { path = dir, upward = true, limit = math.huge, stop = stop_dir(dir) })
  for _, file in ipairs(files) do
    local ok, lines = pcall(vim.fn.readfile, file)
    if ok then
      local text = table.concat(lines, '\n')
      for _, key in ipairs(keys) do
        if text:find('"' .. key .. '"', 1, true) then
          return true
        end
      end
    end
  end
  return false
end

--- Is the buffer's project configured for `tool` (a key of M.tools)?
---@param bufnr integer
---@param tool string
---@return boolean
function M.uses(bufnr, tool)
  local spec = assert(M.tools[tool], 'unknown tool: ' .. tool)
  local dir = buf_dir(bufnr)
  local found = vim.fs.find(spec.files, { path = dir, upward = true, limit = 1, stop = stop_dir(dir) })[1]
  return found ~= nil or package_json_mentions(dir, spec.pkg)
end

--- Project root for tools that run without a config: package.json / tsconfig / .git, else the cwd.
---@param bufnr integer
---@return string
function M.root(bufnr)
  return vim.fs.root(bufnr, { { 'package.json', 'tsconfig.json', 'jsconfig.json' }, '.git' }) or vim.fn.getcwd()
end

return M
