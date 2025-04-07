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

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'oil',
      callback = function()
        local function move_or_tmux(dir)
          return function()
            local key = ({ h = 'L', j = 'D', k = 'U', l = 'R' })[dir]
            local curr_win = vim.api.nvim_get_current_win()
            vim.cmd('wincmd ' .. dir)
            local new_win = vim.api.nvim_get_current_win()

            if curr_win == new_win then
              vim.fn.system { 'tmux', 'select-pane', '-' .. key }
            end
          end
        end

        local opts = { noremap = true, silent = true, buffer = true }

        vim.keymap.set('n', '<C-h>', move_or_tmux 'h', opts)
        vim.keymap.set('n', '<C-j>', move_or_tmux 'j', opts)
        vim.keymap.set('n', '<C-k>', move_or_tmux 'k', opts)
        vim.keymap.set('n', '<C-l>', move_or_tmux 'l', opts)
      end,
    })
  end,
}
