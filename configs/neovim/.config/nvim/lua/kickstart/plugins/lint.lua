return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- Web Development
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
        vue = { 'eslint' },
        astro = { 'eslint' },
        html = { 'htmlhint' },
        css = { 'stylelint' },

        -- Python
        python = { 'ruff' },

        -- Go
        go = { 'golangcilint' },

        -- Rust (cargo clippy via LSP é melhor)
        -- rust = { 'clippy' },

        -- Shell scripting
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },

        -- Documentation
        markdown = { 'markdownlint' },

        -- YAML/JSON
        yaml = { 'yamllint' },
        json = { 'jsonlint' },

        -- Docker
        dockerfile = { 'hadolint' },

        lua = {},

        elixir = { 'credo' },

        -- Java/Kotlin
        java = { 'checkstyle' },
        kotlin = { 'ktlint' },
      }

      -- Customizar configurações específicas de linters
      local eslint = lint.linters.eslint
      eslint.args = {
        '--no-eslintrc',
        '--config',
        vim.fn.expand '~/.eslintrc.js',
        '--format',
        'json',
        '--stdin',
        '--stdin-filename',
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })

      -- Comando manual para lint
      vim.api.nvim_create_user_command('Lint', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })

      -- Keybind para lint manual
      vim.keymap.set('n', '<leader>cl', function()
        lint.try_lint()
      end, { desc = '[C]ode [L]int' })
    end,
  },
}
