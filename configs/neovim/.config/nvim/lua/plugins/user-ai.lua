-- AI plugins are configured via LazyVim extras in lua/config/lazy.lua
-- (lazyvim.plugins.extras.ai.copilot + ai.copilot-chat)
--
-- Additional AI plugins below:

return {
  -- Avante: Cursor-like AI editing (inline diffs, multi-file edits, chat sidebar)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.icons",
      "MeanderingProgrammer/render-markdown.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
          },
        },
      },
    },
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      claude = { model = "claude-sonnet-4-20250514", max_tokens = 4096 },
      openai = { model = "gpt-4o", max_tokens = 4096 },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },
      selector = { provider = "telescope" },
      hints = { enabled = true },
    },
  },

  -- Render markdown for Avante/CopilotChat rich output
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
      heading = { icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " } },
      code = { sign = false, width = "block", right_pad = 1 },
      bullet = { icons = { "●", "○", "◆", "◇" } },
      checkbox = {
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
    },
  },
}
