-- Assuming each of your plugin config files returns a table of plugin specs
local configs = {
  require 'haxtof.configs.obsidian',
}

-- Return the aggregated plugin specifications
return configs
