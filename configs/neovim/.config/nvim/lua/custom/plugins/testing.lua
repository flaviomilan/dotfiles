return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-java',
      'rcasia/neotest-java',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-java')({
            ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
            -- Ensure neotest-java doesn't interfere with nvim-java JDTLS management
            junit_jar = nil, -- Let nvim-java handle this
          }),
        },
        discovery = {
          enabled = true,
          concurrent = 0,
        },
        running = {
          concurrent = true,
        },
        summary = {
          enabled = true,
          expand_errors = true,
        },
        output = {
          enabled = true,
          open_on_run = 'short',
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        icons = {
          child_indent = '│',
          child_prefix = '├',
          collapsed = '─',
          expanded = '╮',
          failed = '',
          final_child_indent = ' ',
          final_child_prefix = '╰',
          non_collapsible = '─',
          passed = '',
          running = '',
          running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
          skipped = '',
          unknown = '',
          watching = '',
        },
        highlights = {
          adapter_name = 'NeotestAdapterName',
          border = 'NeotestBorder',
          dir = 'NeotestDir',
          expand_marker = 'NeotestExpandMarker',
          failed = 'NeotestFailed',
          file = 'NeotestFile',
          focused = 'NeotestFocused',
          indent = 'NeotestIndent',
          marked = 'NeotestMarked',
          namespace = 'NeotestNamespace',
          passed = 'NeotestPassed',
          running = 'NeotestRunning',
          select_win = 'NeotestWinSelect',
          skipped = 'NeotestSkipped',
          target = 'NeotestTarget',
          test = 'NeotestTest',
          unknown = 'NeotestUnknown',
          watching = 'NeotestWatching',
        },
        floating = {
          border = 'rounded',
          max_height = 0.6,
          max_width = 0.6,
          options = {},
        },
        default_strategy = 'integrated',
      })

      -- Keymaps for testing (similar to IntelliJ test runner)
      local neotest = require('neotest')
      vim.keymap.set('n', '<leader>tn', function() neotest.run.run() end, { desc = 'Run nearest test' })
      vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand('%')) end, { desc = 'Run current file tests' })
      vim.keymap.set('n', '<leader>ta', function() neotest.run.run(vim.fn.getcwd()) end, { desc = 'Run all tests' })
      vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = 'Toggle test summary' })
      vim.keymap.set('n', '<leader>to', function() neotest.output.open() end, { desc = 'Open test output' })
      vim.keymap.set('n', '<leader>tO', function() neotest.output_panel.toggle() end, { desc = 'Toggle output panel' })
      vim.keymap.set('n', '<leader>td', function() neotest.run.run({strategy = 'dap'}) end, { desc = 'Debug nearest test' })
      vim.keymap.set('n', '<leader>tw', function() neotest.watch.toggle() end, { desc = 'Watch tests' })
      vim.keymap.set('n', '[t', function() neotest.jump.prev({ status = 'failed' }) end, { desc = 'Previous failed test' })
      vim.keymap.set('n', ']t', function() neotest.jump.next({ status = 'failed' }) end, { desc = 'Next failed test' })
    end,
  },
  {
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('coverage').setup({
        commands = true, -- create commands
        highlights = {
          covered = { fg = '#C3E88D' },   -- supports style, fg, bg, sp (see :h highlight-gui)
          uncovered = { fg = '#F07178' },
        },
        signs = {
          covered = { hl = 'CoverageCovered', text = '▎' },
          uncovered = { hl = 'CoverageUncovered', text = '▎' },
        },
        summary = {
          min_coverage = 80.0,
        },
        lang = {
          java = {
            coverage_command = 'mvn jacoco:report',
            coverage_file = 'target/site/jacoco/jacoco.xml',
            project_files_only = true,
          },
        },
      })

      -- Coverage keymaps
      vim.keymap.set('n', '<leader>cc', '<cmd>Coverage<cr>', { desc = 'Show coverage' })
      vim.keymap.set('n', '<leader>ct', '<cmd>CoverageToggle<cr>', { desc = 'Toggle coverage' })
      vim.keymap.set('n', '<leader>cs', '<cmd>CoverageSummary<cr>', { desc = 'Coverage summary' })
      vim.keymap.set('n', '<leader>cl', '<cmd>CoverageLoad<cr>', { desc = 'Load coverage' })
    end,
  },
}