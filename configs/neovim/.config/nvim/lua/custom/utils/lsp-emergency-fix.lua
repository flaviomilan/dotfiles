-- Emergency fix for client.lua:544 error
-- This module provides the most aggressive fix for the LSP client request error

local M = {}

-- Original error handler
local original_error_handler = vim.lsp._error_handler

-- Enhanced error handler that catches client.lua:544 errors
local function emergency_error_handler(err, method, params, message, bufnr, lsp_config)
  -- Check if this is the specific error we're trying to fix
  if err and type(err) == "string" and err:find("attempt to call field 'request'") then
    vim.notify("Intercepted LSP client.lua:544 error - prevented crash", vim.log.levels.WARN)
    return -- Silently ignore this specific error
  end
  
  -- Call original handler for other errors
  if original_error_handler then
    return original_error_handler(err, method, params, message, bufnr, lsp_config)
  end
end

-- Monkey patch the entire LSP system
local function emergency_patch()
  -- Override global error handler
  vim.lsp._error_handler = emergency_error_handler
  
  -- Protect vim.lsp.rpc functions
  if vim.lsp.rpc and vim.lsp.rpc.request then
    local original_rpc_request = vim.lsp.rpc.request
    vim.lsp.rpc.request = function(client, method, params, callback)
      if not client or not client.request then
        vim.notify("Emergency LSP fix: Invalid client for RPC request", vim.log.levels.WARN)
        if callback then callback(nil, { code = -1, message = "Invalid client" }) end
        return
      end
      
      return original_rpc_request(client, method, params, callback)
    end
  end
  
  -- Global pcall wrapper for any LSP function that might fail
  local function safe_lsp_call(func, ...)
    local success, result = pcall(func, ...)
    if not success then
      if result and result:find("attempt to call field 'request'") then
        vim.notify("Emergency LSP fix: Prevented client.request error", vim.log.levels.WARN)
        return nil
      else
        error(result) -- Re-throw other errors
      end
    end
    return result
  end
  
  -- Override vim.lsp.buf functions that commonly trigger the error
  local buf_functions = {
    'hover',
    'signature_help',
    'definition',
    'references',
    'implementation',
    'completion',
    'code_action',
    'format',
    'rename'
  }
  
  for _, func_name in ipairs(buf_functions) do
    if vim.lsp.buf[func_name] then
      local original_func = vim.lsp.buf[func_name]
      vim.lsp.buf[func_name] = function(...)
        return safe_lsp_call(original_func, ...)
      end
    end
  end
end

-- Setup emergency fixes
function M.setup()
  emergency_patch()
  
  -- Add global error handler for unhandled LSP errors
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspRequest',
    callback = function(args)
      -- Additional safety check before any LSP request
      if args.data and args.data.client_id then
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.request then
          vim.notify("Emergency LSP fix: Blocking invalid request", vim.log.levels.WARN)
          return true -- Block the request
        end
      end
    end
  })
  
  vim.notify("Emergency LSP client fixes applied", vim.log.levels.INFO)
end

return M