-- Most languages are configured via LazyVim extras in lua/config/lazy.lua
-- This file contains overrides and languages without an official LazyVim extra.

return {
  -- neotest: Ruby adapters + go guard
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "olimorris/neotest-rspec",
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return { "bundle", "exec", "rspec" }
          end,
        },
        ["neotest-golang"] = (function()
          if vim.fn.executable("go") == 1 then
            return {}
          end
          return nil
        end)(),
      },
      output = { open_on_run = false },
      quickfix = { open = false },
    },
  },

  -- Bash LSP + formatting
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
}
