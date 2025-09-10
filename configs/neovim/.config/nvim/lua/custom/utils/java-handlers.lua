-- Custom Java LSP handlers to fix unsupported commands and capabilities

local M = {}

-- Handler for unsupported reload bundles command
local function handle_reload_bundles()
  -- Silently handle the command without errors
  return {}
end

-- Custom LSP handlers
local custom_handlers = {
  ['_java.reloadBundles.command'] = handle_reload_bundles,
  ['workspace/executeCommand'] = function(err, result, params, config)
    -- Handle workspace commands gracefully
    if params and params.command == '_java.reloadBundles.command' then
      return handle_reload_bundles()
    end
    -- Fall back to default handler for other commands
    return vim.lsp.handlers['workspace/executeCommand'](err, result, params, config)
  end,
}

-- Function to setup custom handlers
function M.setup()
  -- Override LSP handlers for Java-specific commands
  for command, handler in pairs(custom_handlers) do
    vim.lsp.handlers[command] = handler
  end
  
  -- Disable certain capabilities that cause warnings
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.workspace = capabilities.workspace or {}
  capabilities.workspace.didChangeWorkspaceFolders = {
    dynamicRegistration = false
  }
  capabilities.textDocument = capabilities.textDocument or {}
  capabilities.textDocument.semanticTokens = {
    dynamicRegistration = false
  }
  
  -- Store modified capabilities for later use
  M.capabilities = capabilities
end

-- Function to get modified capabilities
function M.get_capabilities()
  return M.capabilities or vim.lsp.protocol.make_client_capabilities()
end

return M