-- Tailwind CSS
-- Only attaches in projects that use Tailwind (lspconfig's root_dir looks for a tailwind config
-- or `tailwindcss` in package.json / an `@import "tailwindcss"` CSS entry).
return {
  servers = { 'tailwindcss' },
}
