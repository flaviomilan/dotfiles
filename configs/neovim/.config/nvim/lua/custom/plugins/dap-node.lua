return {
  'mxsdev/nvim-dap-vscode-js',
  dependencies = {
    'mfussenegger/nvim-dap',
    {
      'microsoft/vscode-js-debug',
      opt = true,
      run = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'
    }
  },
  config = function()
    local dap = require('dap')

    -- Setup vscode-js-debug adapter
    require('dap-vscode-js').setup({
      -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug', -- Path to vscode-js-debug installation.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
    })

    -- Language specific configurations
    for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Start Chrome with "localhost"',
          url = 'http://localhost:3000',
          webRoot = '${workspaceFolder}',
          userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir'
        }
      }
    end

    -- Vue.js specific configuration
    dap.configurations.vue = {
      {
        type = 'pwa-chrome',
        request = 'launch',
        name = 'vuejs: chrome',
        url = 'http://localhost:8080',
        webRoot = '${workspaceFolder}/src',
        breakOnLoad = true,
        sourceMapPathOverrides = {
          ['webpack:///src/*'] = '${webRoot}/*'
        }
      }
    }

    -- Keymaps for debugging
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Continue' })
    vim.keymap.set('n', '<leader>dC', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
    vim.keymap.set('n', '<leader>dg', dap.goto_, { desc = 'Debug: Go to line (no execute)' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>dj', dap.down, { desc = 'Debug: Down' })
    vim.keymap.set('n', '<leader>dk', dap.up, { desc = 'Debug: Up' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>dO', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>dp', dap.pause, { desc = 'Debug: Pause' })
    vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Debug: Toggle REPL' })
    vim.keymap.set('n', '<leader>ds', dap.session, { desc = 'Debug: Session' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>dw', function()
      require('dap.ui.widgets').hover()
    end, { desc = 'Debug: Widgets' })
  end,
}