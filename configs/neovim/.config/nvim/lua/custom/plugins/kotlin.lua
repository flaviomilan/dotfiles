return {
  {
    'udalov/kotlin-vim',
    ft = { 'kotlin' },
    config = function()
      vim.g.kotlin_fold = 1
    end,
  },
  {
    'mfussenegger/nvim-jdtls',
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = { 'java', 'kotlin' },
  },
}