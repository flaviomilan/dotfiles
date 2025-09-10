return {
  {
    'nvim-java/nvim-java',
    ft = { 'java' },
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-refactor',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      },
    },
    config = function()
      -- Setup Java 21+ specific configuration
      local java21_config = require('custom.utils.java21-config')
      java21_config.setup()
      
      -- Setup custom Java handlers
      local java_handlers = require('custom.utils.java-handlers')
      java_handlers.setup()
      
      require('java').setup({
        -- Java installation path
        java_home = vim.fn.expand('~/.local/share/mise/installs/java/temurin-21.0.8+9.0.LTS'),
        
        -- Disable verification to avoid conflicts check
        verification = {
          invalid_order = false,
          duplicate_setup_calls = false,
        },
        
        -- Enable Spring Boot support
        spring_boot_tools = {
          enable = true,
        },
        -- Java test runner configuration
        java_test = {
          enable = true,
        },
        -- Java debug adapter configuration
        java_debug_adapter = {
          enable = true,
        },
        -- Additional JVM arguments for better performance and Java 21+ compatibility
        jdk = {
          auto_install = false,
        },
        notifications = {
          dap = true,
        },
        -- Custom JVM args for Java 21+ compatibility
        jvm_args = java21_config.jvm_args,
        
        -- JDTLS settings
        jdtls = {
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = 'JavaSE-21',
                    path = vim.fn.expand('~/.local/share/mise/installs/java/temurin-21.0.8+9.0.LTS'),
                  },
                },
                updateBuildConfiguration = 'interactive',
              },
              eclipse = {
                downloadSources = true,
              },
              maven = {
                downloadSources = true,
                updateSnapshots = false,
              },
              import = {
                gradle = {
                  enabled = true,
                  wrapper = {
                    enabled = true,
                  },
                },
                maven = {
                  enabled = true,
                  downloadSources = true,
                  updateSnapshots = false,
                },
                exclusions = {
                  "**/node_modules/**",
                  "**/.metadata/**", 
                  "**/archetype-resources/**",
                  "**/META-INF/maven/**",
                  "**/target/**",
                  "**/.settings/**"
                },
              },
              project = {
                referencedLibraries = {
                  "lib/**/*.jar",
                  "**/target/dependency/*.jar"
                }
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              signatureHelp = { 
                enabled = true 
              },
              contentProvider = { 
                preferred = 'fernflower' 
              },
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
              errors = {
                incompleteClasspath = {
                  severity = 'ignore'
                }
              },
            },
          },
          capabilities = java_handlers.get_capabilities(),
        },
      })
      
      -- Note: nvim-java manages JDTLS automatically, so we don't need manual lspconfig setup
    end,
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
      require('notify').setup({
        background_colour = '#000000',
        fps = 30,
        icons = {
          DEBUG = '',
          ERROR = '',
          INFO = '',
          TRACE = '✎',
          WARN = '',
        },
        level = 2,
        minimum_width = 50,
        render = 'default',
        stages = 'fade_in_slide_out',
        timeout = 5000,
        top_down = true,
      })
    end,
  },
}