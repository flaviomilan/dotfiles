-- This file acts as a manifest for all plugins in this directory.
-- It's imported by `lazy.nvim` in the main `plugins/init.lua`.

return {
  require('custom.plugins.clipboard'),
  require('custom.plugins.copilot'),
  require('custom.plugins.octo'),
  require('custom.plugins.oil'),
  require('custom.plugins.smart-splits'),
  require('custom.plugins.cmp'),
  require('custom.plugins.java'),
  require('custom.plugins.kotlin'),
  require('custom.plugins.groovy'),
  require('custom.plugins.groovy-diagnostics'),
  require('custom.plugins.mason'),
  require('custom.plugins.nvim-lspconfig'),
  require('custom.plugins.schemastore'),
  require('custom.plugins.spring'),
  require('custom.plugins.project-navigation'),
  require('custom.plugins.testing'),
  require('custom.plugins.refactoring'),
  require('custom.plugins.ai-completion'),
}