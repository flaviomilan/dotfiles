-- lua/plugins/lsp.lua

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Gerenciamento de LSPs, Formatters e Linters
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Feedback visual para o LSP
    { 'j-hui/fidget.nvim', opts = {} },

    -- Autocompletar com LSP
    'hrsh7th/cmp-nvim-lsp',

    -- ✨ NOVO: Plugin especialista em Java (essencial!)
    {
      'nvim-java/nvim-java',
      dependencies = {
        'nvim-java/lua-async-await',
        'nvim-java/nvim-java-core',
        'nvim-java/nvim-java-test',
        'nvim-java/nvim-java-dap',
        'mfussenegger/nvim-dap',
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
      },
    },

    -- ✨ NOVO: Para formatação de código
    {
      'stevearc/conform.nvim',
      opts = {
        formatters_by_ft = {
          java = { 'google-java-format' },
          groovy = { 'npm-groovy-lint' },
          kotlin = { 'ktlint', 'prettier' },
          python = { 'ruff_format', 'isort' },
          go = { 'gofumpt', 'goimports' },
          rust = { 'rustfmt' },
          lua = { 'stylua' },
          -- Adicione outros formatadores se precisar
          ['*'] = { 'trim_whitespace' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      },
    },

    -- ✨ NOVO: Para análise estática (linting)
    {
      'mfussenegger/nvim-lint',
      config = function()
        require('lint').linters_by_ft = {
          python = { 'ruff' },
          go = { 'golangci-lint' },
          -- Adicione outros linters se precisar
        }
        -- Executa o lint ao salvar e ao digitar
        vim.api.nvim_create_autocmd({ 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
          callback = function()
            require('lint').try_lint()
          end,
        })
      end,
    },
  },
  config = function()
    -- Função de anexo do LSP (on_attach) - Mantém a sua, que é excelente!
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- ... seu callback `on_attach` existente vai aqui ...
        -- (É a parte que define gd, gr, gI, <leader>rn, etc.)
        -- Vou omitir por brevidade, mas você deve mantê-lo exatamente como está.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        -- ... resto do seu on_attach
      end,
    })

    -- Configuração de diagnósticos - Mantém a sua
    vim.diagnostic.config {
      -- ... sua configuração de diagnostics ...
    }

    -- Capacidades do cliente LSP (importante para o nvim-cmp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- ✨ MELHORADO: Configuração do nvim-java para detectar o JDK do mise
    require('java').setup {
      lsp = {
        -- Isso diz ao nvim-java para encontrar o JDK gerenciado pelo mise!
        java_path = vim.fn.trim(vim.fn.system('mise where java | cut -d" " -f2') .. '/bin/java'),
      },
    }

    -- ✨ MELHORADO: Lista de servidores LSP a serem instalados e configurados
    local servers = {
      -- Java: agora é gerenciado pelo `nvim-java`, não precisa estar aqui!
      -- Groovy
      groovyls = {},
      -- Kotlin (servidor oficial da JetBrains, melhor que o kotlin_language_server)
      kotlin_language_server = {},
      -- Python
      pyright = {},
      ruff_lsp = {}, -- Excelente para linting e formatação
      -- Go
      gopls = {
        settings = {
          gopls = {
            -- Habilita análise estática com golangci-lint
            ['ui.diagnostic.staticcheck'] = true,
          },
        },
      },
      -- Rust
      rust_analyzer = {},
      -- Outros
      clangd = {},
      tsserver = {}, -- Em vez de ts_ls, para melhor performance
      astro = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            workspace = { checkThirdParty = false }, -- Evita avisos sobre 'vim'
            telemetry = { enable = false },
          },
        },
      },
    }

    -- ✨ MELHORADO: Lista de ferramentas (formatadores, linters) a serem instalados pelo Mason
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      -- Java
      'google-java-format',
      -- Groovy
      'npm-groovy-lint',
      -- Kotlin
      'ktlint',
      -- Python
      'ruff',
      'isort',
      'black',
      -- Go
      'gofumpt',
      'goimports',
      'golangci-lint',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Configuração do Mason + Lspconfig para usar as configurações da nossa tabela `servers`
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}