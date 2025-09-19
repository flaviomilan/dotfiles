-- Groovy ftplugin
-- This file is loaded automatically for Groovy files

-- Check if Mason's groovy-language-server is available
local mason_bin = vim.fn.stdpath('data') .. '/mason/bin/groovy-language-server'

if vim.fn.executable(mason_bin) == 0 then
  vim.notify('Groovy Language Server not found. Execute :MasonInstall groovy-language-server', vim.log.levels.ERROR)
  return
end

-- Root directory detection
local root_dir = vim.fs.root(0, {
  'build.gradle',
  'build.gradle.kts',
  'settings.gradle',
  'settings.gradle.kts',
  'Jenkinsfile',
  '.git'
})

-- Enhanced capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local config = {
  name = 'groovyls',
  cmd = { mason_bin },
  root_dir = root_dir,
  settings = {
    groovy = {
      classpath = {},
      ['java.home'] = vim.fn.system('mise where java 2>/dev/null'):gsub('\n', ''),
    },
  },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Groovy specific keymaps
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, {
        buffer = bufnr,
        desc = 'Groovy LSP: ' .. desc,
        silent = true
      })
    end

    -- Gradle specific commands
    map('<leader>gb', function()
      vim.cmd('!./gradlew build')
    end, '[G]radle [B]uild')

    map('<leader>gt', function()
      vim.cmd('!./gradlew test')
    end, '[G]radle [T]est')

    map('<leader>gc', function()
      vim.cmd('!./gradlew clean')
    end, '[G]radle [C]lean')

    map('<leader>gw', function()
      vim.cmd('!./gradlew bootRun')
    end, '[G]radle [W]eb run (Spring Boot)')

    -- Notify when LSP is ready
    vim.notify('Groovy LSP attached to buffer ' .. bufnr, vim.log.levels.INFO)
  end,
}

-- Prevent multiple instances of the same LSP
local clients = vim.lsp.get_clients({name = 'groovyls'})
if #clients > 0 then
  vim.notify('Groovy LSP already running', vim.log.levels.INFO)
  return
end

-- Start LSP client directly
vim.lsp.start(config)