MiniDeps.later(function()
  MiniDeps.add({
    source = 'mrcjkb/rustaceanvim',
    checkout = 'v6.4.1',
    monitor = 'master',
  })

  vim.g.rustaceanvim = function()
    return {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set(
            'n',
            '<leader>cR',
            function() vim.cmd.RustLsp('codeAction') end,
            { desc = 'Code Action', buffer = bufnr }
          )
          vim.keymap.set(
            'n',
            '<leader>dr',
            function() vim.cmd.RustLsp('debuggables') end,
            { desc = 'Rust Debuggables', buffer = bufnr }
          )
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- We're using bacon for that
            checkOnSave = { enable = false }, -- Add clippy lints for Rust if using rust-analyzer
            diagnostics = { enable = false }, -- Enable diagnostics if using rust-analyzer
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            files = {
              excludeDirs = {
                '.direnv',
                '.git',
                '.github',
                '.gitlab',
                'bin',
                'node_modules',
                'target',
                'venv',
                '.venv',
              },
            },
          },
        },
      },
    }
  end
end)
