-- Personal tools and navigation
return {
  -- Oil.nvim: file browser that replaces netrw
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
    opts = { default_file_explorer = true },
  },

  -- Smart-splits: tmux-aware window navigation
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
    },
  },

  -- Octo: GitHub issues and PRs inside Neovim
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    opts = {},
  },
}
