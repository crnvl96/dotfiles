---@class NvimUtils.Constants
local M = {}

M.mason_tools = {
  'stylua',
  'prettier',
  'gofumpt',
  'pyproject-fmt',

  'json-lsp', -- jsonls
  'yaml-language-server', -- yamlls
  'bacon',
  'bacon-ls', -- bacon_ls
  'rust-analyzer',
  'taplo',
  'gopls',
  'biome',
  'css-lsp', -- cssls
  'eslint-lsp', -- eslint
  'lua-language-server', -- lua_ls
  'pyright',
  'ruff',
  'typescript-language-server', -- ts_ls
  'tailwindcss-language-server', -- tailwindcss
  'jq', -- json
}

M.ts_tools = {
  'c',
  'lua',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'javascript',
  'typescript',
  'tsx',
  'jsx',
  'python',
  'rust',
  'ron',
  'bash',
  'gitcommit',
  'html',
  'hyprlang',
  'json',
  'json5',
  'jsonc',
  'rasi',
  'regex',
  'scss',
  'toml',
  'vim',
  'yaml',
}

return M
