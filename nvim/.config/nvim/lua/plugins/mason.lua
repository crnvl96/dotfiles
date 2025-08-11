MiniDeps.now(function()
  MiniDeps.add({
    source = 'mason-org/mason.nvim',
    hooks = {
      post_checkout = function() vim.cmd('MasonUpdate') end,
    },
  })

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs({
        -- Formatters
        'stylua',
        'prettier',
        'gofumpt',

        -- Language servers
        'json-lsp', -- jsonls
        'yaml-language-server', -- yamlls
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
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)
