return {
  'stevearc/oil.nvim',
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },
  },
  lazy = false,
  config = function()
    require('oil').setup {
      default_file_explorer = true,
    }

    -- Navigation no Oil usa smart-splits para integração consistente com tmux
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'oil',
      callback = function()
        local ss = require 'smart-splits'
        local opts = { noremap = true, silent = true, buffer = true }

        -- Usar smart-splits para navegação consistente
        vim.keymap.set('n', '<C-h>', ss.move_cursor_left, opts)
        vim.keymap.set('n', '<C-j>', ss.move_cursor_down, opts)
        vim.keymap.set('n', '<C-k>', ss.move_cursor_up, opts)
        vim.keymap.set('n', '<C-l>', ss.move_cursor_right, opts)
      end,
    })
  end,
}
