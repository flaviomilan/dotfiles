return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'jdtls',            -- Java
          'kotlin_language_server', -- Kotlin
          'groovyls',         -- Groovy
          'gradle_ls',        -- Gradle
          'lemminx',          -- XML (for Maven pom.xml)
        },
        automatic_installation = true,
      })
      
      -- Install additional tools if available
      local mason_registry = require('mason-registry')
      local tools_to_install = {
        'spring-boot-tools',
        'google-java-format',
      }
      
      for _, tool in ipairs(tools_to_install) do
        if mason_registry.has_package(tool) then
          local pkg = mason_registry.get_package(tool)
          if not pkg:is_installed() then
            pkg:install()
          end
        end
      end
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('mason-nvim-dap').setup({
        ensure_installed = {
          'java-debug-adapter',
          'java-test',
        },
        automatic_installation = true,
        handlers = {},
      })
    end,
  },
}