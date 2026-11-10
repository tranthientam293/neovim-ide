-- Go
-- Mason builds gopls / goimports / gofumpt with `go install`, so the Go toolchain must be on PATH.
return {
  servers = { 'gopls' },
  formatters = {
    go = { 'goimports', 'gofumpt' }, -- fix imports, then stricter gofmt
  },
  linters = {
    go = { 'golangcilint' }, -- runs the project's .golangci.yml (falls back to golangci-lint defaults)
  },
  tools = { 'goimports', 'gofumpt', 'golangci-lint' },
  parsers = { 'go', 'gomod', 'gosum', 'gowork', 'gotmpl' },
}
