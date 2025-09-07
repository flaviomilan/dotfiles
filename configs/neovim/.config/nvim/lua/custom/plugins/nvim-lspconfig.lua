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

      -- Groovy Language Server
      lspconfig.groovyls.setup({
        cmd = function()
          local mason_path = vim.fn.stdpath('data') .. '/mason'
          local groovy_executable = mason_path .. '/packages/groovy-language-server/groovy-language-server'
          
          -- Check if Mason executable exists
          if vim.fn.executable(groovy_executable) == 1 then
            return { groovy_executable }
          end
          
          -- Fallback to JAR file directly
          local jar_path = mason_path .. '/packages/groovy-language-server/build/libs/groovy-language-server-all.jar'
          if vim.fn.filereadable(jar_path) == 1 then
            return { 'java', '-jar', jar_path }
          end
          
          -- Final fallback
          return { 'groovy-language-server' }
        end,
        capabilities = capabilities,
        filetypes = { 'groovy' },
        root_dir = function(fname)
          return lspconfig.util.root_pattern(
            'pom.xml',           -- Maven projects
            'build.gradle',      -- Gradle projects
            'build.gradle.kts',
            'settings.gradle',
            'settings.gradle.kts',
            'gradlew',
            'Jenkinsfile',       -- Jenkins pipelines
            '.git'               -- Git repositories
          )(fname) or lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
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
          print("Groovy LSP attached to buffer " .. bufnr .. " in " .. (client.config.root_dir or 'unknown'))
        end,
      })

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