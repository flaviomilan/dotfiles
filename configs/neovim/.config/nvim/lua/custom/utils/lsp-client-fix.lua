-- Universal LSP error fixes and handlers for client.lua:544 error

local M = {}

-- Store original handlers and functions
local original_handlers = {}
local original_client_request = nil

-- Global LSP client request wrapper to prevent nil access
local function safe_lsp_request(client_id, method, params, handler, bufnr)
  -- Get client safely
  local client = vim.lsp.get_client_by_id(client_id)
  
  if not client then
    vim.notify("LSP client not found for ID: " .. (client_id or "nil"), vim.log.levels.ERROR)
    return nil, "Client not found"
  end
  
  -- Check if client has request method
  if not client.request then
    vim.notify("LSP client missing request method (client: " .. (client.name or "unknown") .. ")", vim.log.levels.ERROR)
    return nil, "Request method missing"
  end
  
  -- Validate client is not shutting down
  if client.is_stopped() then
    vim.notify("LSP client is stopped: " .. (client.name or "unknown"), vim.log.levels.WARN)
    return nil, "Client stopped"
  end
  
  -- Safe call with error handling
  local success, result = pcall(function()
    return client.request(method, params, handler, bufnr)
  end)
  
  if not success then
    vim.notify("LSP request failed for " .. (client.name or "unknown") .. ": " .. (result or "unknown error"), vim.log.levels.ERROR)
    return nil, result
  end
  
  return result
end

-- Enhanced client validation 
local function validate_lsp_client(client)
  if not client then
    return false, "Client is nil"
  end
  
  if not client.request then
    return false, "Client missing request method"
  end
  
  if client.is_stopped and client.is_stopped() then
    return false, "Client is stopped"
  end
  
  return true, nil
end

-- Direct patch for vim.lsp.client request method
local function patch_client_request()
  -- Hook into LSP attach to patch each client
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.request then
        local original_request = client.request
        client.request = function(self, method, params, handler, bufnr)
          local is_valid, error_msg = validate_lsp_client(self)
          if not is_valid then
            vim.notify("LSP request blocked: " .. error_msg .. " (client: " .. (self.name or "unknown") .. ")", vim.log.levels.ERROR)
            return nil, error_msg
          end
          
          return original_request(self, method, params, handler, bufnr)
        end
      end
    end
  })
end

-- Patch vim.lsp to use our safe request wrapper
local function patch_lsp_core()
  -- Apply client-level patches
  patch_client_request()
  
  -- Store original if not already stored
  if not original_client_request and vim.lsp._request then
    original_client_request = vim.lsp._request
  end
  
  -- Override core LSP request function  
  vim.lsp._request = function(client_id, method, params, handler, bufnr)
    return safe_lsp_request(client_id, method, params, handler, bufnr)
  end
end

-- Enhanced error handler for Groovy LSP
local function groovy_error_handler(err, result, ctx, config)
  if not ctx then
    vim.notify("LSP context is nil", vim.log.levels.ERROR)
    return
  end
  
  if not ctx.client_id then
    vim.notify("LSP client_id is nil", vim.log.levels.ERROR)
    return
  end
  
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    vim.notify("LSP client not found for id: " .. ctx.client_id, vim.log.levels.ERROR)
    return
  end
  
  -- Call original handler if everything is valid
  if original_handlers[ctx.method] then
    return original_handlers[ctx.method](err, result, ctx, config)
  end
end

-- Setup universal LSP fixes
function M.setup()
  -- Apply core LSP patches first
  patch_lsp_core()
  
  -- Store original handlers before overriding
  original_handlers["textDocument/hover"] = vim.lsp.handlers["textDocument/hover"]
  original_handlers["textDocument/completion"] = vim.lsp.handlers["textDocument/completion"]
  original_handlers["textDocument/signatureHelp"] = vim.lsp.handlers["textDocument/signatureHelp"]
  original_handlers["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"]
  original_handlers["textDocument/references"] = vim.lsp.handlers["textDocument/references"]
  
  -- Override handlers with error checking
  vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
    return groovy_error_handler(err, result, ctx, config)
  end
  
  vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
    return groovy_error_handler(err, result, ctx, config)
  end
  
  vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    return groovy_error_handler(err, result, ctx, config)
  end
  
  vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
    return groovy_error_handler(err, result, ctx, config)
  end
  
  vim.lsp.handlers["textDocument/references"] = function(err, result, ctx, config)
    return groovy_error_handler(err, result, ctx, config)
  end
  
  -- Add autocmd for Groovy files to set up additional error handling
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "groovy",
    callback = function()
      -- Set up buffer-local error handling
      vim.api.nvim_create_autocmd("LspAttach", {
        buffer = 0,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "groovyls" then
            -- Patch client.request to handle nil cases
            local original_request = client.request
            client.request = function(method, params, handler, bufnr)
              if not original_request then
                vim.notify("Client request method is nil", vim.log.levels.ERROR)
                return
              end
              
              return safe_client_call(client, method, method, params, handler, bufnr)
            end
          end
        end,
      })
    end,
  })
end

-- Function to restart Groovy LSP safely
function M.restart_groovy_lsp()
  local clients = vim.lsp.get_clients({ name = "groovyls" })
  for _, client in ipairs(clients) do
    client.stop()
  end
  
  -- Wait a moment then restart
  vim.defer_fn(function()
    vim.cmd("LspStart groovyls")
  end, 1000)
end

return M