return {
  -- -------------------------------------------------------
  -- Copilot: AI completions (Lua-native, replaces copilot.vim)
  -- -------------------------------------------------------
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
          accept_word = '<C-Right>',
          accept_line = '<C-Down>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false }, -- we use CopilotChat instead
      filetypes = {
        markdown = true,
        yaml = true,
        ['.'] = false, -- disable for unlisted types
      },
    },
  },

  -- -------------------------------------------------------
  -- CopilotChat: AI chat, review, refactor, explain, docs
  -- -------------------------------------------------------
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'claude-3.5-sonnet', -- best model for code
      context = 'buffers', -- use all open buffers as context
      window = {
        layout = 'vertical',
        width = 0.4,
      },
    },
    keys = {
      -- Toggle chat window
      { '<leader>aa', '<cmd>CopilotChatToggle<cr>', desc = 'AI: Toggle Chat' },
      -- Quick actions on visual selection
      { '<leader>ae', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'AI: Explain selection' },
      { '<leader>ar', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'AI: Review selection' },
      { '<leader>af', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = 'AI: Fix selection' },
      { '<leader>ao', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = 'AI: Optimize selection' },
      { '<leader>ad', '<cmd>CopilotChatDocs<cr>', mode = 'v', desc = 'AI: Generate docs' },
      { '<leader>at', '<cmd>CopilotChatTests<cr>', mode = 'v', desc = 'AI: Generate tests' },
      -- Whole-buffer actions
      { '<leader>ae', '<cmd>CopilotChatExplain<cr>', mode = 'n', desc = 'AI: Explain buffer' },
      { '<leader>ar', '<cmd>CopilotChatReview<cr>', mode = 'n', desc = 'AI: Review buffer' },
      -- Custom prompts
      {
        '<leader>ap',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'AI: Prompt actions (Telescope)',
      },
      -- Quick chat with input
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'AI: '
          if input ~= '' then
            vim.cmd('CopilotChat ' .. input)
          end
        end,
        desc = 'AI: Quick chat',
      },
      -- Commit message
      { '<leader>am', '<cmd>CopilotChatCommit<cr>', desc = 'AI: Generate commit message' },
    },
  },
}
