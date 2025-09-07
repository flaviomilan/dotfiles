return {
  {
    'mfussenegger/nvim-jdtls',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
    },
    ft = { 'java', 'groovy' },
    config = function()
      local jdtls = require('jdtls')
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      
      -- Find root directory
      local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle' }
      local root_dir = require('jdtls.setup').find_root(root_markers)
      if not root_dir then
        return
      end

      -- Workspace directory
      local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
      vim.fn.mkdir(workspace_dir, 'p')

      -- JDTLS installation path (adjust based on your Mason installation)
      local mason_path = vim.fn.stdpath('data') .. '/mason'
      local jdtls_path = mason_path .. '/packages/jdtls'
      local java_debug_path = mason_path .. '/packages/java-debug-adapter'
      local java_test_path = mason_path .. '/packages/java-test'

      -- Configuration for different OS
      local config_dir = 'config_linux'
      if vim.fn.has('mac') == 1 then
        config_dir = 'config_mac'
      elseif vim.fn.has('win32') == 1 then
        config_dir = 'config_win'
      end

      local bundles = {}
      
      -- Add java-debug-adapter (check if it exists)
      local java_debug_bundle = java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'
      local debug_jars = vim.fn.glob(java_debug_bundle)
      if debug_jars ~= '' then
        vim.list_extend(bundles, vim.split(debug_jars, '\n'))
      end
      
      -- Add java-test bundles (check if they exist)
      local java_test_bundle = java_test_path .. '/extension/server/*.jar'
      local test_jars = vim.fn.glob(java_test_bundle)
      if test_jars ~= '' then
        -- Filter out problematic jars
        local filtered_jars = {}
        for _, jar in ipairs(vim.split(test_jars, '\n')) do
          if not string.match(jar, 'jacocoagent%.jar$') and not string.match(jar, 'com%.microsoft%.java%.test%.runner%-jar%-with%-dependencies%.jar$') then
            table.insert(filtered_jars, jar)
          end
        end
        vim.list_extend(bundles, filtered_jars)
      end

      local config = {
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ERROR',
          '-Xmx4g',
          '-Xms1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens', 'java.base/java.util=ALL-UNNAMED',
          '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
          '--add-opens', 'java.base/sun.nio.fs=ALL-UNNAMED',
          '--add-opens', 'java.base/sun.security.util=ALL-UNNAMED',
          '--add-opens', 'java.base/sun.security.ssl=ALL-UNNAMED',
          '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
          '-configuration', jdtls_path .. '/' .. config_dir,
          '-data', workspace_dir,
        },

        root_dir = root_dir,

        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = 'interactive',
              runtimes = {
                {
                  name = 'JavaSE-21',
                  path = vim.fn.expand('~/.local/share/mise/installs/java/temurin-21.0.8+9.0.LTS'),
                },
              },
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath('config') .. '/lang-servers/intellij-java-google-style.xml',
                profile = 'GoogleStyle',
              },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
              importOrder = {
                'java',
                'javax',
                'com',
                'org',
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
              },
              hashCodeEquals = {
                useJava7Objects = true,
              },
              useBlocks = true,
            },
          },
        },

        init_options = {
          bundles = bundles,
        },

        on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings specific to Java
          local opts = { noremap=true, silent=true }
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>oi', '<Cmd>lua require\'jdtls\'.organize_imports()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>crv', '<Cmd>lua require\'jdtls\'.extract_variable()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>crv', '<Esc><Cmd>lua require\'jdtls\'.extract_variable(true)<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>crc', '<Cmd>lua require\'jdtls\'.extract_constant()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>crc', '<Esc><Cmd>lua require\'jdtls\'.extract_constant(true)<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>crm', '<Esc><Cmd>lua require\'jdtls\'.extract_method(true)<CR>', opts)

          -- Java specific keymaps
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>df', '<Cmd>lua require\'jdtls\'.test_class()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dn', '<Cmd>lua require\'jdtls\'.test_nearest_method()<CR>', opts)
          
          -- DAP setup
          jdtls.setup_dap({ hotcodereplace = 'auto' })
          require('jdtls.dap').setup_dap_main_class_configs()
        end,

        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }

      -- Start or attach JDTLS
      jdtls.start_or_attach(config)
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- DAP UI setup
      dapui.setup({
        layouts = {
          {
            elements = {
              'scopes',
              'breakpoints',
              'stacks',
              'watches',
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              'repl',
              'console',
            },
            size = 10,
            position = 'bottom',
          },
        },
      })

      -- Virtual text setup
      require('nvim-dap-virtual-text').setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Keymaps for debugging
      vim.keymap.set('n', '<F5>', dap.continue)
      vim.keymap.set('n', '<F10>', dap.step_over)
      vim.keymap.set('n', '<F11>', dap.step_into)
      vim.keymap.set('n', '<F12>', dap.step_out)
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end)
      vim.keymap.set('n', '<leader>dr', dap.repl.open)
      vim.keymap.set('n', '<leader>dl', dap.run_last)
      vim.keymap.set('n', '<leader>dh', require('dap.ui.widgets').hover)
      vim.keymap.set('n', '<leader>dp', require('dap.ui.widgets').preview)
    end,
  },
}
