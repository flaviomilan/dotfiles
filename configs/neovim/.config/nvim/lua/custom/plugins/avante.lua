-- -------------------------------------------------------
-- avante.nvim — Cursor-like AI editing experience
-- Inline diffs, multi-file edits, chat sidebar
-- Supports Claude, GPT, Copilot as backends
-- -------------------------------------------------------
return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- latest
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    -- optional but recommended
    'echasnovski/mini.icons',
    'MeanderingProgrammer/render-markdown.nvim',
    {
      -- image pasting support
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
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
    -- Primary AI provider (change to "openai" or "copilot" if preferred)
    provider = 'copilot',
    -- Auto-suggestions while typing (experimental)
    auto_suggestions_provider = 'copilot',
    -- Claude config (requires ANTHROPIC_API_KEY env var)
    claude = {
      model = 'claude-sonnet-4-20250514',
      max_tokens = 4096,
    },
    -- OpenAI config (requires OPENAI_API_KEY env var)
    openai = {
      model = 'gpt-4o',
      max_tokens = 4096,
    },
    -- Behavior
    behaviour = {
      auto_suggestions = false, -- enable when you want inline ghost text from Avante
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },
    -- Keymaps under <leader>a namespace
    mappings = {
      ask = '<leader>ac', -- ask AI about code
      edit = '<leader>ae', -- edit selected code
      refresh = '<leader>aR', -- refresh response
      diff = {
        ours = 'co', -- choose our change
        theirs = 'ct', -- choose AI change
        all_theirs = 'ca', -- accept all AI changes
        both = 'cb', -- keep both
        cursor = 'cc', -- apply at cursor
        next = ']x', -- next conflict
        prev = '[x', -- prev conflict
      },
      submit = {
        normal = '<CR>',
        insert = '<C-s>',
      },
      sidebar = {
        apply_all = 'A',
        apply_cursor = 'a',
        switch_windows = '<Tab>',
        reverse_switch_windows = '<S-Tab>',
      },
    },
    -- File selector
    selector = {
      provider = 'telescope',
    },
    hints = { enabled = true },
  },
}
