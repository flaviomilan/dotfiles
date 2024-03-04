-- Assuming each of your plugin config files returns a table of plugin specs
local plugins = {
  require 'haxtof.plugins.java',
  require 'haxtof.plugins.obsidian',
  require 'haxtof.plugins.octo',
}

-- Return the aggregated plugin specifications
return plugins
