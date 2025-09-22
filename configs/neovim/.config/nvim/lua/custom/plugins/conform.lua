return {
  'stevearc/conform.nvim', -- Autoformat
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },
      cpp = { 'clang-format' },
      c = { 'clang-format' },
      rust = { 'rustfmt' },
      go = { 'goimports', 'gofmt' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      vue = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      json = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
      elixir = { 'mix_format' },
      heex = { 'mix_format' },
      -- Java/Kotlin
      java = { 'google-java-format' },
      kotlin = { 'ktlint' },
    },
  },
}
