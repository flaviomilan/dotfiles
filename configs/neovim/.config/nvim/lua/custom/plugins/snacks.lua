return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Performance e grandes arquivos
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5MB
    },

    -- Renderização rápida de arquivos
    quickfile = { enabled = true },

    -- Dashboard personalizado para produtividade
    dashboard = {
      enabled = true,
      preset = {
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },

    -- Sistema de notificações aprimorado
    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      sort = { "level", "added" },
    },

    -- Picker avançado para navegação
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<C-j>"] = { "select_next", mode = { "i", "n" } },
            ["<C-k>"] = { "select_prev", mode = { "i", "n" } },
          },
        },
      },
    },

    -- Input melhorado
    input = { enabled = true },

    -- Guias de indentação e escopo
    indent = {
      enabled = true,
      priority = 1,
      char = "│",
      only_scope = false,
      only_current = false,
    },

    -- Detecção e navegação de escopo
    scope = {
      enabled = true,
      keys = {
        jump = {
          ["]]"] = { query = "@function.outer", desc = "Next function" },
          ["[["] = { query = "@function.outer", desc = "Prev function", backward = true },
          ["]c"] = { query = "@class.outer", desc = "Next class" },
          ["[c"] = { query = "@class.outer", desc = "Prev class", backward = true },
        },
      },
    },

    -- Palavras-chave destacadas
    words = {
      enabled = true,
      debounce = 100,
      notify_jump = false,
      notify_end = true,
    },

    -- Scroll suave
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 250 },
        easing = "linear",
      },
    },

    -- Coluna de status melhorada (integrada com GitSigns)
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = true,
        git_hl = true,
      },
      git = {
        patterns = { "GitSign.*" }, -- Melhor integração com GitSigns
      },
      refresh = 50,
    },

    -- Integração com Git
    git = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = { editPreset = "nvim-remote" },
        gui = { nerdFontsVersion = "3" },
      },
      theme = {
        activeBorderColor = { fg = "SpecialChar", bold = true },
        inactiveBorderColor = { fg = "FloatBorder" },
        searchingActiveBorderColor = { fg = "IncSearch", bold = true },
      },
    },

    -- Terminal integrado
    terminal = {
      enabled = true,
      bo = {
        filetype = "snacks_terminal",
      },
      wo = {},
      keys = {
        q = "hide",
        term_normal = {
          ["<esc>"] = "hide",
          ["<C-q>"] = "hide",
        },
      },
    },

    -- Modo Zen para foco
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = { backdrop = 0.95 },
    },

    -- Dim para foco em escopo
    dim = {
      enabled = true,
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
      },
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        easing = "outQuad",
        duration = {
          step = 10,
          total = 300,
        },
      },
    },

    -- Toggle utilities
    toggle = {
      enabled = true,
      map = vim.keymap.set,
      which_key = true,
    },

    -- Renomeação inteligente
    rename = {
      enabled = true,
      notify = true,
    },

    -- Debug utilities
    debug = { enabled = true },

    -- Profiler para otimização
    profiler = {
      enabled = true,
      pick = true,
    },

    -- Buffer delete sem quebrar layout
    bufdelete = { enabled = true },
  },
  keys = {
    -- Dashboard
    { "<leader>.", function() Snacks.dashboard() end, desc = "Dashboard" },

    -- Picker shortcuts
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find Text" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>gc", function() Snacks.picker.git_commits() end, desc = "Git Commits" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },

    -- Git integration (evitando duplicação com GitSigns)
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },

    -- Terminal
    { "<leader>t", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<leader>T", function() Snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h") }) end, desc = "Terminal (cwd)" },

    -- Zen mode
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },

    -- Notifications
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

    -- Buffer management
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },

    -- Rename
    { "<leader>r", function() Snacks.rename.rename_file() end, desc = "Rename File" },

    -- Words highlighting
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },

    -- Scratch buffer
    { "<leader>S", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>s", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
  },
}
