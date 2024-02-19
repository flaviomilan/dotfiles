return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    lazy = false, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},  -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.keybinds"] = {},
          ["core.dirman"] = {      -- Manages Neorg workspaces
            config = {
              workspaces = {
                personal = "~/zettelkasten",
              },
              index = "index.norg"
            },
          },
        }
      }

      vim.keymap.set("n", "<leader>nn", vim.cmd.Neorg)
      vim.keymap.set("n", "<leader>nw", [[:Neorg workspace ]])
    end,
  },
}
