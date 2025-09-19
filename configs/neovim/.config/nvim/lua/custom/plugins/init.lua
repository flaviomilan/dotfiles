-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  require 'custom.plugins.conform',
  require 'custom.plugins.mini-nvim',
  require 'custom.plugins.oil',
  require 'custom.plugins.smart-splits',
  require 'custom.plugins.which-key',
  require 'custom.plugins.snacks',

  -- code
  require 'custom.plugins.code.nvim-cmp',
  require 'custom.plugins.code.nvim-lspconfig',
  require 'custom.plugins.code.nvim-jdtls',
  require 'custom.plugins.code.nvim-treesitter',
  require 'custom.plugins.code.lazydev',

  -- style
  require 'custom.plugins.style.todo-comments',
  require 'custom.plugins.style.tokyo-night',
}
