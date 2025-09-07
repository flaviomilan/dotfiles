return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-n>'] = actions.cycle_history_next,
              ['<C-p>'] = actions.cycle_history_prev,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<CR>'] = actions.select_default,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
              ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
          prompt_prefix = '🔍 ',
          selection_caret = '➤ ',
          entry_prefix = '  ',
          initial_mode = 'insert',
          selection_strategy = 'reset',
          sorting_strategy = 'descending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              mirror = false,
            },
            vertical = {
              mirror = false,
            },
          },
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          file_ignore_patterns = {
            'node_modules',
            '.git/',
            '%.o',
            '%.class',
            'target/',
            'build/',
            '.gradle/',
            '.idea/',
          },
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          color_devicons = true,
          use_less = true,
          path_display = {},
          set_env = { ['COLORTERM'] = 'truecolor' },
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        pickers = {
          find_files = {
            theme = 'dropdown',
          },
          live_grep = {
            theme = 'ivy',
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      })

      -- Load extensions
      telescope.load_extension('fzf')

      -- Keymaps
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
      vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Find commands' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
      
      -- LSP-related searches (similar to IntelliJ navigation)
      vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
      vim.keymap.set('n', '<leader>fw', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
      vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Go to definitions' })
      vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = 'Go to implementations' })
      vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, { desc = 'Go to type definitions' })
      vim.keymap.set('n', '<leader>fx', builtin.lsp_references, { desc = 'Find references' })
      
      -- Git integration
      vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      position = 'bottom',
      height = 10,
      width = 50,
      icons = true,
      mode = 'workspace_diagnostics',
      fold_open = '',
      fold_closed = '',
      group = true,
      padding = true,
      action_keys = {
        close = 'q',
        cancel = '<esc>',
        refresh = 'r',
        jump = { '<cr>', '<tab>' },
        open_split = { '<c-x>' },
        open_vsplit = { '<c-v>' },
        open_tab = { '<c-t>' },
        jump_close = { 'o' },
        toggle_mode = 'm',
        toggle_preview = 'P',
        hover = 'K',
        preview = 'p',
        close_folds = { 'zM', 'zm' },
        open_folds = { 'zR', 'zr' },
        toggle_fold = { 'zA', 'za' },
        previous = 'k',
        next = 'j',
      },
      indent_lines = true,
      auto_open = false,
      auto_close = false,
      auto_preview = true,
      auto_fold = false,
      auto_jump = { 'lsp_definitions' },
      signs = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '﫠',
      },
      use_diagnostic_signs = false,
    },
    config = function(_, opts)
      require('trouble').setup(opts)
      
      -- Keymaps
      vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Toggle Trouble' })
      vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { desc = 'Workspace diagnostics' })
      vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', { desc = 'Document diagnostics' })
      vim.keymap.set('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', { desc = 'Location list' })
      vim.keymap.set('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', { desc = 'Quickfix list' })
      vim.keymap.set('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', { desc = 'LSP references' })
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup({
        backends = { 'treesitter', 'lsp', 'markdown', 'man' },
        layout = {
          max_width = { 40, 0.2 },
          width = nil,
          min_width = 10,
          win_opts = {},
          default_direction = 'prefer_right',
          placement = 'window',
        },
        attach_mode = 'window',
        close_automatic_events = {},
        keymaps = {
          ['?'] = 'actions.show_help',
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.jump',
          ['<2-LeftMouse>'] = 'actions.jump',
          ['<C-v>'] = 'actions.jump_vsplit',
          ['<C-s>'] = 'actions.jump_split',
          ['p'] = 'actions.scroll',
          ['<C-j>'] = 'actions.down_and_scroll',
          ['<C-k>'] = 'actions.up_and_scroll',
          ['{'] = 'actions.prev',
          ['}'] = 'actions.next',
          ['[['] = 'actions.prev_up',
          [']]'] = 'actions.next_up',
          ['q'] = 'actions.close',
          ['o'] = 'actions.tree_toggle',
          ['za'] = 'actions.tree_toggle',
          ['O'] = 'actions.tree_toggle_recursive',
          ['zA'] = 'actions.tree_toggle_recursive',
          ['l'] = 'actions.tree_open',
          ['zo'] = 'actions.tree_open',
          ['L'] = 'actions.tree_open_recursive',
          ['zO'] = 'actions.tree_open_recursive',
          ['h'] = 'actions.tree_close',
          ['zc'] = 'actions.tree_close',
          ['H'] = 'actions.tree_close_recursive',
          ['zC'] = 'actions.tree_close_recursive',
          ['zr'] = 'actions.tree_increase_fold_level',
          ['zR'] = 'actions.tree_open_all',
          ['zm'] = 'actions.tree_decrease_fold_level',
          ['zM'] = 'actions.tree_close_all',
          ['zx'] = 'actions.tree_sync_folds',
          ['zX'] = 'actions.tree_sync_folds',
        },
        lazy_load = true,
        disable_max_lines = 10000,
        disable_max_size = 2000000,
        filter_kind = {
          'Class',
          'Constructor',
          'Enum',
          'Function',
          'Interface',
          'Module',
          'Method',
          'Struct',
        },
        highlight_mode = 'split_width',
        highlight_closest = true,
        highlight_on_hover = false,
        highlight_on_jump = 300,
        icons = {},
        show_guides = false,
        guides = {
          mid_item = '├─',
          last_item = '└─',
          nested_top = '│ ',
          whitespace = '  ',
        },
        float = {
          border = 'rounded',
          relative = 'cursor',
          max_height = 0.9,
          height = nil,
          min_height = { 8, 0.1 },
          override = function(conf, source_winid)
            return conf
          end,
        },
        lsp = {
          diagnostics_trigger_update = true,
          update_when_errors = true,
          update_delay = 300,
        },
        treesitter = {
          update_delay = 300,
        },
        markdown = {
          update_delay = 300,
        },
        man = {
          update_delay = 300,
        },
      })

      -- Keymaps for aerial (structure view like IntelliJ)
      vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial' })
      vim.keymap.set('n', '<leader>A', '<cmd>AerialNavToggle<CR>', { desc = 'Toggle Aerial Navigation' })
      vim.keymap.set('n', '[a', '<cmd>AerialPrev<CR>', { desc = 'Previous symbol' })
      vim.keymap.set('n', ']a', '<cmd>AerialNext<CR>', { desc = 'Next symbol' })
    end,
  },
}