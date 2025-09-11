-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  require 'custom.plugins.copilot',
  require 'custom.plugins.mini',
  require 'custom.plugins.octo',
  require 'custom.plugins.oil',
  require 'custom.plugins.smart-splits',
  require 'custom.plugins.which-key',
  require 'custom.plugins.telescope',

  -- theme and styling
  require 'custom.plugins.style.tokyonight',
  require 'custom.plugins.style.todo-comments',

  -- code related
  require 'custom.plugins.code.conform',
  require 'custom.plugins.code.lazydev',
  require 'custom.plugins.code.nvim-cmp',
  require 'custom.plugins.code.nvim-lspconfig',
  require 'custom.plugins.code.nvim-treesitter',
}
