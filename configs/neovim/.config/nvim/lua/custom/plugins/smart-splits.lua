return {
  'mrjones2014/smart-splits.nvim',
  opts = {
    at_edge = 'stop',
    -- Ignored filetypes (we want to disable smart-splits in nvim-tree, and alpha)
    ignored_filetypes = {
      'neo-tree',
      'alpha',
    },
  },
  config = function(_, opts)
    require('smart-splits').setup(opts)
    -- recommended mappings
    -- resizing splits
    vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
    vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
    vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
    vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    -- moving between splits
    vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
  end,
}
