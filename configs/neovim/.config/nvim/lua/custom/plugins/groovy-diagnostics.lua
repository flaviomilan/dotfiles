-- Groovy LSP Diagnostics helper
return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Add command to check Groovy LSP status
      vim.api.nvim_create_user_command('GroovyLSPDiagnostics', function()
        local mason_path = vim.fn.stdpath('data') .. '/mason'
        local groovy_ls_path = mason_path .. '/packages/groovy-language-server'
        
        print("=== Groovy LSP Diagnostics ===")
        
        -- Check Mason installation
        if vim.fn.isdirectory(groovy_ls_path) == 1 then
          print("✓ groovyls installed in Mason")
          
          -- Check executable script
          local groovy_executable = groovy_ls_path .. '/groovy-language-server'
          if vim.fn.executable(groovy_executable) == 1 then
            print("✓ Executable script exists and is executable: " .. groovy_executable)
          else
            print("✗ Executable script not found or not executable: " .. groovy_executable)
          end
          
          -- Check JAR file
          local jar_path = groovy_ls_path .. '/build/libs/groovy-language-server-all.jar'
          if vim.fn.filereadable(jar_path) == 1 then
            print("✓ JAR file exists: " .. jar_path)
            
            -- Test Java availability
            if vim.fn.executable('java') == 1 then
              print("✓ Java executable found")
              local java_version = vim.fn.system('java -version 2>&1 | head -1')
              print("  Java version: " .. java_version:gsub('\n', ''))
            else
              print("✗ Java executable NOT found - required for groovyls")
            end
          else
            print("✗ JAR file not found: " .. jar_path)
            -- List actual files in directory
            local files = vim.fn.glob(groovy_ls_path .. '/**/*.jar', false, true)
            if #files > 0 then
              print("  Available JAR files:")
              for _, file in ipairs(files) do
                print("    " .. file)
              end
            end
          end
        else
          print("✗ groovyls NOT installed in Mason")
          print("  Run :Mason and install groovyls")
        end
        
        -- Check current buffer
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype
        print("Current filetype: " .. filetype)
        
        if filetype == 'groovy' then
          local filename = vim.api.nvim_buf_get_name(bufnr)
          print("Current file: " .. filename)
          
          -- Check root directory detection
          local lspconfig = require('lspconfig')
          local root = lspconfig.util.root_pattern(
            'pom.xml', 'build.gradle', 'build.gradle.kts',
            'settings.gradle', 'settings.gradle.kts', 'gradlew',
            'Jenkinsfile', '.git'
          )(filename)
          
          if root then
            print("✓ Root directory detected: " .. root)
            -- List markers found
            local markers = { 'pom.xml', 'build.gradle', 'build.gradle.kts', 
                             'settings.gradle', 'settings.gradle.kts', 'gradlew',
                             'Jenkinsfile', '.git' }
            for _, marker in ipairs(markers) do
              if vim.fn.filereadable(root .. '/' .. marker) == 1 or 
                 vim.fn.isdirectory(root .. '/' .. marker) == 1 then
                print("  Found marker: " .. marker)
              end
            end
          else
            print("✗ No root directory detected")
            print("  Current directory: " .. vim.fn.getcwd())
            print("  File directory: " .. vim.fn.fnamemodify(filename, ':h'))
            print("  Missing markers: pom.xml, build.gradle, .git, etc.")
          end
          
          -- Check LSP clients
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          local groovy_client = nil
          for _, client in ipairs(clients) do
            if client.name == 'groovyls' then
              groovy_client = client
              break
            end
          end
          
          if groovy_client then
            print("✓ groovyls client attached")
            print("  Client ID: " .. groovy_client.id)
            print("  Root directory: " .. (groovy_client.config.root_dir or 'nil'))
          else
            print("✗ groovyls client NOT attached")
            print("  Available clients:")
            for _, client in ipairs(clients) do
              print("    " .. client.name)
            end
          end
        else
          print("Current buffer is not a Groovy file")
        end
        
        print("=== End Diagnostics ===")
      end, { desc = 'Run Groovy LSP diagnostics' })
      
      -- Shortcut command
      vim.api.nvim_create_user_command('GLD', 'GroovyLSPDiagnostics', { desc = 'Groovy LSP Diagnostics (short)' })
    end,
  },
}