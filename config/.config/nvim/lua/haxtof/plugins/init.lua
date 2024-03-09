-- Assuming each of your plugin config files returns a table of plugin specs
local plugins = {
  require 'haxtof.plugins.cmp',
  require 'haxtof.plugins.comment',
  require 'haxtof.plugins.conform',
  require 'haxtof.plugins.debug',
  require 'haxtof.plugins.gitsigns',
  require 'haxtof.plugins.indent_line',
  require 'haxtof.plugins.java',
  require 'haxtof.plugins.lsp',
  require 'haxtof.plugins.mini',
  require 'haxtof.plugins.nordic',
  require 'haxtof.plugins.obsidian',
  require 'haxtof.plugins.octo',
  require 'haxtof.plugins.projects',
  require 'haxtof.plugins.sleuth',
  require 'haxtof.plugins.telescope',
  require 'haxtof.plugins.todo_comments',
  require 'haxtof.plugins.treesitter',
  require 'haxtof.plugins.which_key',
}

-- Return the aggregated plugin specifications
return plugins
