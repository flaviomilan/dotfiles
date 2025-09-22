return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = 'zettelkasten',
        path = '/mnt/c/Users/flavi/OneDrive/Documentos/zettelkasten/',
      },
      {
        name = 'work',
        path = '~/vaults/work',
      },
    },

    -- Daily notes configuration
    daily_notes = {
      folder = 'daily',
      date_format = '%Y-%m-%d',
      template = nil,
    },

    -- Completion settings
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- Note naming and templates
    note_id_func = function(title)
      local suffix = ''
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Keybindings
    mappings = {
      -- Smart action (follow link or toggle checkbox)
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
      -- Toggle checkbox
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Follow link
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
  },

  keys = {
    -- Quick switch between notes
    { '<leader>os', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Obsidian Quick Switch' },
    -- Search notes
    { '<leader>of', '<cmd>ObsidianSearch<cr>', desc = 'Obsidian Search' },
    -- Create new note
    { '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'Obsidian New Note' },
    -- Open today's daily note
    { '<leader>ot', '<cmd>ObsidianToday<cr>', desc = 'Obsidian Today' },
    -- Open yesterday's daily note
    { '<leader>oy', '<cmd>ObsidianToday -1<cr>', desc = 'Obsidian Yesterday' },
    -- Open tomorrow's daily note
    { '<leader>oT', '<cmd>ObsidianToday 1<cr>', desc = 'Obsidian Tomorrow' },
    -- Show backlinks
    { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = 'Obsidian Backlinks' },
    -- Insert template
    { '<leader>otp', '<cmd>ObsidianTemplate<cr>', desc = 'Obsidian Template' },
    -- Paste image
    { '<leader>oi', '<cmd>ObsidianPasteImg<cr>', desc = 'Obsidian Paste Image' },
    -- Rename note
    { '<leader>or', '<cmd>ObsidianRename<cr>', desc = 'Obsidian Rename' },
    -- Open in Obsidian app
    { '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = 'Obsidian Open' },
    -- Follow link in vertical split
    { '<leader>olv', '<cmd>ObsidianFollowLink vsplit<cr>', desc = 'Obsidian Follow Link (vsplit)' },
    -- Follow link in horizontal split
    { '<leader>olh', '<cmd>ObsidianFollowLink hsplit<cr>', desc = 'Obsidian Follow Link (hsplit)' },
  },
}
