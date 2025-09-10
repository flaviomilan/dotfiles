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
  -- Note: JDTLS configuration for Groovy disabled to avoid conflicts with nvim-java
  -- nvim-java will handle all JDTLS functionality including Groovy DSL support in Gradle projects
}