return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'groovy' })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'groovyls' })
    end,
  },
  {
    -- Gradle specific support
    'mfussenegger/nvim-jdtls',
    ft = { 'groovy' },
    config = function()
      -- JDTLS can also provide some support for Groovy files in Gradle projects
      local jdtls = require('jdtls')
      
      -- Only setup for Groovy files that are part of Gradle builds
      if vim.fn.expand('%:e') == 'groovy' then
        local root_dir = require('jdtls.setup').find_root({
          'gradlew', 'build.gradle', 'build.gradle.kts', 'settings.gradle', '.git'
        })
        
        if root_dir and (
          vim.fn.filereadable(root_dir .. '/build.gradle') == 1 or
          vim.fn.filereadable(root_dir .. '/build.gradle.kts') == 1 or
          vim.fn.filereadable(root_dir .. '/gradlew') == 1
        ) then
          -- This is a Gradle project, JDTLS can help with Groovy DSL
          local config = {
            cmd = { 'jdtls' },
            root_dir = root_dir,
            settings = {
              java = {
                configuration = {
                  updateBuildConfiguration = 'interactive',
                },
              },
            },
          }
          
          -- Start JDTLS for additional Gradle DSL support
          jdtls.start_or_attach(config)
        end
      end
    end,
  },
}