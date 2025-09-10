-- Java 21+ specific configurations to handle warnings and compatibility issues

local M = {}

-- Java 21+ JVM arguments to suppress warnings and enable modern features
M.jvm_args = {
  -- Suppress Unsafe warnings
  '--add-opens=java.base/java.lang=ALL-UNNAMED',
  '--add-opens=java.base/java.util=ALL-UNNAMED',
  '--add-opens=java.base/java.io=ALL-UNNAMED',
  '--add-opens=java.base/java.net=ALL-UNNAMED',
  '--add-opens=java.base/sun.nio.fs=ALL-UNNAMED',
  '--add-opens=java.base/sun.security.util=ALL-UNNAMED',
  '--add-opens=java.base/sun.security.ssl=ALL-UNNAMED',
  
  -- Enable native access for restricted methods
  '--enable-native-access=ALL-UNNAMED',
  
  -- Suppress incubator module warnings
  '--add-modules=ALL-SYSTEM',
  
  -- Disable multi-release jar processing (can cause issues)
  '-Djdk.util.jar.enableMultiRelease=false',
  
  -- Ignore unrecognized VM options
  '-XX:+IgnoreUnrecognizedVMOptions',
  
  -- Performance optimizations
  '-XX:+UseG1GC',
  '-XX:+UseStringDeduplication',
  '-XX:MaxGCPauseMillis=200',
  
  -- Memory settings
  '-Xmx4g',
  '-Xms1g',
  '-XX:MetaspaceSize=512m',
  '-XX:MaxMetaspaceSize=2g',
}

-- Environment variables for Java 21+
M.env_vars = {
  JAVA_HOME = vim.fn.expand('~/.local/share/mise/installs/java/temurin-21.0.8+9.0.LTS'),
  JAVA_TOOL_OPTIONS = table.concat({
    '--add-opens=java.base/java.lang=ALL-UNNAMED',
    '--add-opens=java.base/java.util=ALL-UNNAMED',
    '--enable-native-access=ALL-UNNAMED',
    '-XX:+IgnoreUnrecognizedVMOptions'
  }, ' '),
}

-- Function to setup Java 21+ environment
function M.setup()
  -- Set environment variables
  for key, value in pairs(M.env_vars) do
    vim.env[key] = value
  end
  
  -- Configure LSP log level to reduce noise
  vim.lsp.set_log_level('ERROR')
  
  -- Create autocmd to set JAVA_HOME when opening Java files
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
      vim.env.JAVA_HOME = M.env_vars.JAVA_HOME
    end,
  })
end

-- Function to get JVM args as a string
function M.get_jvm_args_string()
  return table.concat(M.jvm_args, ' ')
end

return M