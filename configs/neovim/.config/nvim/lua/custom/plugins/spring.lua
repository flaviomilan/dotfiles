return {
  {
    'JavaHello/spring-boot.nvim',
    ft = { 'java' },
    dependencies = {
      'mfussenegger/nvim-jdtls',
    },
    config = function()
      -- Only setup if spring-boot-tools is available
      local spring_boot_path = vim.fn.stdpath('data') .. '/mason/packages/spring-boot-tools'
      if vim.fn.isdirectory(spring_boot_path) == 1 then
        local spring_boot = require('spring_boot')
        spring_boot.setup({
          ls_path = spring_boot_path,
        })
      end
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