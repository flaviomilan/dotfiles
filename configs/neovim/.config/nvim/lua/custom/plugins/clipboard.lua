-- WSL Clipboard Integration
return {
  {
    'wsl-clipboard',
    dir = vim.fn.stdpath('config'),
    name = 'wsl-clipboard',
    lazy = false,
    priority = 1000,
    config = function()
      -- Only setup if we're in WSL
      local is_wsl = vim.fn.system('uname -r'):find('microsoft') ~= nil
      
      if is_wsl then
        -- Use Windows clipboard tools
        vim.g.clipboard = {
          name = 'WSL-Clipboard',
          copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
          },
          paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
          },
          cache_enabled = 0,
        }
        
        -- Enable clipboard integration
        vim.opt.clipboard = 'unnamedplus'
        
        -- Add some helpful keymaps
        vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
        vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank selection to system clipboard' })
        vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
        vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
        
        -- Diagnostic message
        vim.notify('WSL Clipboard integration enabled', vim.log.levels.INFO)
      else
        -- Fallback for non-WSL systems
        local clipboard_tools = {
          { 'xclip', '-selection', 'clipboard' },
          { 'xsel', '-b' },
          { 'wl-copy' },
        }
        
        for _, tool in ipairs(clipboard_tools) do
          if vim.fn.executable(tool[1]) == 1 then
            vim.opt.clipboard = 'unnamedplus'
            break
          end
        end
      end
    end,
  },
}