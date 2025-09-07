return {
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('refactoring').setup({
        prompt_func_return_type = {
          java = true,
          kotlin = true,
        },
        prompt_func_param_type = {
          java = true,
          kotlin = true,
        },
        printf_statements = {
          java = {
            'System.out.println("%s", %s);',
          },
          kotlin = {
            'println("%s" + %s)',
          },
        },
        print_var_statements = {
          java = {
            'System.out.println("%s = " + %s);',
          },
          kotlin = {
            'println("%s = " + %s)',
          },
        },
      })

      -- Refactoring keymaps (similar to IntelliJ refactoring shortcuts)
      vim.keymap.set(
        { 'n', 'x' },
        '<leader>re',
        function() require('refactoring').refactor('Extract Function') end,
        { desc = 'Extract Function' }
      )
      vim.keymap.set(
        { 'n', 'x' },
        '<leader>rf',
        function() require('refactoring').refactor('Extract Function To File') end,
        { desc = 'Extract Function To File' }
      )
      vim.keymap.set(
        { 'x' },
        '<leader>rv',
        function() require('refactoring').refactor('Extract Variable') end,
        { desc = 'Extract Variable' }
      )
      vim.keymap.set(
        { 'n', 'x' },
        '<leader>ri',
        function() require('refactoring').refactor('Inline Variable') end,
        { desc = 'Inline Variable' }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>rb',
        function() require('refactoring').refactor('Extract Block') end,
        { desc = 'Extract Block' }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>rbf',
        function() require('refactoring').refactor('Extract Block To File') end,
        { desc = 'Extract Block To File' }
      )
      
      -- Debug helpers
      vim.keymap.set(
        'n',
        '<leader>rp',
        function() require('refactoring').debug.printf({below = false}) end,
        { desc = 'Debug print' }
      )
      vim.keymap.set(
        'n',
        '<leader>rP',
        function() require('refactoring').debug.printf({below = true}) end,
        { desc = 'Debug print (below)' }
      )
      vim.keymap.set(
        { 'x', 'n' },
        '<leader>rv',
        function() require('refactoring').debug.print_var() end,
        { desc = 'Debug print variable' }
      )
      vim.keymap.set(
        'n',
        '<leader>rc',
        function() require('refactoring').debug.cleanup({}) end,
        { desc = 'Debug cleanup' }
      )
    end,
  },
  {
    'cshuaimin/ssr.nvim',
    module = 'ssr',
    config = function()
      require('ssr').setup({
        border = 'rounded',
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        keymaps = {
          close = 'q',
          next_match = 'n',
          prev_match = 'N',
          replace_confirm = '<cr>',
          replace_all = '<leader><cr>',
        },
      })

      -- Structural search and replace (like IntelliJ's SSR)
      vim.keymap.set({ 'n', 'x' }, '<leader>sr', function() require('ssr').open() end, { desc = 'Structural search/replace' })
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    config = function()
      require('inc_rename').setup({
        cmd_name = 'IncRename', -- the name of the command
        hl_group = 'Substitute', -- the highlight group used for highlighting the identifier
        preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancel
        show_message = true, -- whether to display a message when the operation succeeds/fails
        input_buffer_type = nil, -- the type of the external input buffer to use (the only supported value is currently "dressing")
        post_hook = nil, -- callback to run after renaming, receives the result table (from LSP response) as an argument
      })

      -- Smart rename (like IntelliJ's rename refactoring)
      vim.keymap.set('n', '<leader>rn', function()
        return ':IncRename ' .. vim.fn.expand('<cword>')
      end, { expr = true, desc = 'Incremental rename' })
    end,
  },
}