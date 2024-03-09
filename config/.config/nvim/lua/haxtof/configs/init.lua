-- Assuming each of your plugin config files returns a table of plugin specs
local configs = {
  require 'haxtof.configs.obsidian',
  require 'haxtof.configs.java',
  require 'haxtof.configs.lsp',
  require 'haxtof.configs.which_key',
}

-- Return the aggregated plugin specifications
return configs
