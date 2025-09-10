return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'j-hui/fidget.nvim', -- LSP progress notifications
    },
    config = function()
      -- Apply emergency LSP fixes first (highest priority)
      require('custom.utils.lsp-emergency-fix').setup()
      
      -- Setup universal LSP client fixes
      require('custom.utils.lsp-client-fix').setup()
      
      -- Setup fidget for LSP progress
      require('fidget').setup({})

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Kotlin Language Server
      lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
        settings = {
          kotlin = {
            compiler = {
              jvm = {
                target = '17',
              },
            },
            completion = {
              snippets = {
                enabled = true,
              },
            },
            linting = {
              debounceTime = 300,
            },
            indexing = {
              enabled = true,
            },
          },
        },
      })

      -- Gradle Language Server
      lspconfig.gradle_ls.setup({
        capabilities = capabilities,
      })

      -- XML Language Server (for Maven)
      lspconfig.lemminx.setup({
        capabilities = capabilities,
        settings = {
          xml = {
            java = {
              home = vim.fn.getenv('JAVA_HOME') or '/usr/lib/jvm/default-java',
            },
            server = {
              workDir = '~/.cache/lemminx',
            },
            logs = {
              client = true,
              file = '~/.cache/lemminx/lemminx.log',
            },
            format = {
              enabled = true,
              splitAttributes = false,
            },
            completion = {
              autoCloseTags = true,
            },
          },
        },
      })

      -- Groovy Language Server with error handling
      local groovy_setup_success, groovy_error = pcall(function()
        lspconfig.groovyls.setup({
          cmd = function()
            local mason_path = vim.fn.stdpath('data') .. '/mason'
            
            -- Try JAR file first (most reliable)
            local jar_path = mason_path .. '/packages/groovy-language-server/build/libs/groovy-language-server-all.jar'
            if vim.fn.filereadable(jar_path) == 1 then
              return { 
                'java',
                '--add-opens=java.base/java.lang=ALL-UNNAMED',
                '--add-opens=java.base/java.util=ALL-UNNAMED',
                '-Xmx512m',
                '-jar', 
                jar_path 
              }
            end
            
            -- Try executable
            local groovy_executable = mason_path .. '/packages/groovy-language-server/groovy-language-server'
            if vim.fn.executable(groovy_executable) == 1 then
              return { groovy_executable }
            end
            
            -- Final fallback
            vim.notify("Groovy Language Server not found, using fallback", vim.log.levels.WARN)
            return { 'groovy-language-server' }
          end,
          capabilities = capabilities,
          filetypes = { 'groovy' },
          root_dir = function(fname)
            local root = lspconfig.util.root_pattern(
              'build.gradle',      -- Gradle projects (prioritize)
              'build.gradle.kts',
              'settings.gradle',
              'settings.gradle.kts',
              'gradlew',
              'pom.xml',           -- Maven projects
              'Jenkinsfile',       -- Jenkins pipelines
              '.git'               -- Git repositories
            )(fname)
            
            if root then
              return root
            end
            
            -- Fallback to git ancestor or current directory
            return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
          end,
          settings = {
            groovy = {
              classpath = {},
            },
          },
          init_options = {
            settings = {
              groovy = {
                classpath = {},
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Enhanced error handling for on_attach
            if client and client.server_capabilities then
              vim.notify("Groovy LSP attached successfully to buffer " .. bufnr, vim.log.levels.INFO)
            else
              vim.notify("Groovy LSP attached but client capabilities missing", vim.log.levels.WARN)
            end
          end,
          on_init = function(client, initialize_result)
            vim.notify("Groovy LSP initialized", vim.log.levels.INFO)
          end,
          on_error = function(code, err)
            vim.notify("Groovy LSP error: " .. (err or "unknown"), vim.log.levels.ERROR)
          end,
          handlers = {
            -- Override default handlers to prevent nil access
            ["textDocument/hover"] = function(err, result, ctx, config)
              if not ctx or not ctx.client_id then
                return
              end
              return vim.lsp.handlers["textDocument/hover"](err, result, ctx, config)
            end,
          }
        })
      end)
      
      if not groovy_setup_success then
        vim.notify("Failed to setup Groovy LSP: " .. (groovy_error or "unknown error"), vim.log.levels.ERROR)
      end
      
      -- Add command to restart Groovy LSP
      vim.api.nvim_create_user_command("GroovyLspRestart", function()
        require('custom.utils.lsp-client-fix').restart_groovy_lsp()
        vim.notify("Groovy LSP restarted", vim.log.levels.INFO)
      end, { desc = "Restart Groovy LSP" })
      
      -- Add command to restart all LSP clients
      vim.api.nvim_create_user_command("LspClientRestart", function()
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
          vim.notify("Restarting LSP: " .. client.name, vim.log.levels.INFO)
          client.stop()
        end
        vim.defer_fn(function()
          vim.cmd("LspStart")
        end, 1000)
      end, { desc = "Restart all LSP clients" })
      
      -- Add diagnostic command for LSP issues
      vim.api.nvim_create_user_command("LspDiagnose", function()
        local clients = vim.lsp.get_clients()
        vim.notify("=== LSP Client Diagnosis ===", vim.log.levels.INFO)
        
        for _, client in ipairs(clients) do
          local status = "Unknown"
          local has_request = client.request and "✓" or "✗"
          local is_stopped = "Unknown"
          
          if client.is_stopped then
            is_stopped = client.is_stopped() and "✗ Stopped" or "✓ Running"
          end
          
          vim.notify(string.format(
            "Client: %s | Request: %s | Status: %s", 
            client.name or "unnamed", 
            has_request, 
            is_stopped
          ), vim.log.levels.INFO)
        end
        
        vim.notify("=== End Diagnosis ===", vim.log.levels.INFO)
      end, { desc = "Diagnose LSP client issues" })

      -- Global LSP keymaps (applied to all LSP clients)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          
          -- Navigation
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          
          -- Workspace
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          
          -- Type and rename
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          
          -- Code actions
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          
          -- Format
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach',
    opts = {},
  },
}