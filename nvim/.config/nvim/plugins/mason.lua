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

        -- Language servers
        'biome',
        'css-lsp', -- cssls
        'eslint-lsp', -- eslint
        'lua-language-server', -- lua_ls
        'pyright',
        'rubocop',
        'ruby-lsp', -- ruby_lsp
        'ruff',
        'stimulus-language-server', -- stimulus_ls
        'typescript-language-server', -- ts_ls

        -- Awaiting for a stable release
        'pyrefly', -- https://github.com/facebook/pyrefly
        'ty', -- https://github.com/astral-sh/ty
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)
