-- Java ftplugin for nvim-jdtls
-- This file is loaded automatically for Java files

local jdtls = require('jdtls')

-- Get project name and workspace directory
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('~/.cache/jdtls/workspace/') .. project_name

-- Ensure workspace directory exists
vim.fn.mkdir(workspace_dir, 'p')

-- Mason paths
local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
local jdtls_cmd = jdtls_path .. '/bin/jdtls'
local lombok_path = jdtls_path .. '/lombok.jar'

-- Verify JDTLS is installed
if vim.fn.isdirectory(jdtls_path) == 0 then
  vim.notify('JDTLS não encontrado. Execute :MasonInstall jdtls', vim.log.levels.ERROR)
  return
end

-- Java runtime path from mise
local java_home = vim.fn.system('mise where java 2>/dev/null'):gsub('\n', '')
if java_home == '' or vim.fn.isdirectory(java_home) == 0 then
  vim.notify('Java não encontrado via mise', vim.log.levels.ERROR)
  return
end

-- Enhanced capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- Enable snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Root directory detection (modern approach for Neovim 0.10+)
local root_dir = vim.fs.root(0, {
  -- Gradle
  'gradlew',
  'gradle.properties',
  'build.gradle',
  'build.gradle.kts',
  'settings.gradle',
  'settings.gradle.kts',
  -- Maven
  'mvnw',
  'pom.xml',
  -- Git
  '.git',
  -- IntelliJ
  '.idea',
})

local config = {
  cmd = {
    jdtls_cmd,
    '-configuration', jdtls_path .. '/config_linux',
    '-data', workspace_dir,
    '--jvm-arg=-javaagent:' .. lombok_path,
    '--jvm-arg=-Xms1g',
    '--jvm-arg=-Xmx2G',
    '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
    '--jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '--jvm-arg=-Dosgi.bundles.defaultStartLevel=4',
    '--jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product',
  },

  root_dir = root_dir,

  settings = {
    java = {
      home = java_home,
      eclipse = {
        downloadSources = true
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-21',
            path = java_home,
          },
        },
      },
      maven = {
        downloadSources = true
      },
      import = {
        gradle = {
          enabled = true,
          wrapper = {
            enabled = true,
          },
          version = nil,
          home = nil,
          java = {
            home = java_home,
          },
          offline = false,
          arguments = {},
          jvmArguments = {},
          user = {
            home = nil,
          },
        },
      },
      -- Enhanced Java settings
      signatureHelp = {
        enabled = true
      },
      contentProvider = {
        preferred = 'fernflower'
      },
      saveActions = {
        organizeImports = true,
      },
      completion = {
        favoriteStaticMembers = {
          'org.springframework.boot.SpringApplication.run',
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.springframework.util.StringUtils.*',
        },
        filteredTypes = {
          'com.sun.*',
          'java.awt.*',
          'sun.*',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath('config') .. '/eclipse-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
    },
  },

  capabilities = capabilities,

  init_options = {
    bundles = vim.tbl_flatten({
      -- Java Test bundles
      vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/java-test/extension/server/*.jar', true, true),
      -- Java Debug bundles
      vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true),
    }),
    -- Extended client capabilities
    extendedClientCapabilities = {
      progressReportProvider = true,
      classFileContentsSupport = true,
      generateToStringPromptSupport = true,
      hashCodeEqualsPromptSupport = true,
      advancedExtractRefactoringSupport = true,
      advancedOrganizeImportsSupport = true,
      generateConstructorsPromptSupport = true,
      generateDelegateMethodsPromptSupport = true,
      moveRefactoringSupport = true,
    },
  },

  on_attach = function(client, bufnr)
    -- Enhanced Java-specific keymaps
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, {
        buffer = bufnr,
        desc = 'Java LSP: ' .. desc,
        silent = true
      })
    end

    -- Core JDTLS commands
    map('<leader>jo', jdtls.organize_imports, '[J]ava [O]rganize Imports')
    map('<leader>jv', jdtls.extract_variable, '[J]ava Extract [V]ariable')
    map('<leader>jc', jdtls.extract_constant, '[J]ava Extract [C]onstant')
    map('<leader>jm', jdtls.extract_method, '[J]ava Extract [M]ethod', { 'n', 'v' })

    -- Compilation
    map('<leader>jC', jdtls.compile, '[J]ava [C]ompile')

    -- Test commands (if available)
    map('<leader>jt', jdtls.test_nearest_method, '[J]ava [T]est method')
    map('<leader>jT', jdtls.test_class, '[J]ava [T]est class')

    -- Debug test commands
    map('<leader>jdt', function()
      jdtls.test_nearest_method({debug = true})
    end, '[J]ava [D]ebug [T]est method')

    map('<leader>jdT', function()
      jdtls.test_class({debug = true})
    end, '[J]ava [D]ebug [T]est class')

    -- Build tool detection and commands
    local is_gradle = vim.fn.filereadable('build.gradle') == 1 or vim.fn.filereadable('build.gradle.kts') == 1
    local is_maven = vim.fn.filereadable('pom.xml') == 1

    if is_gradle then
      -- Gradle commands
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

    elseif is_maven then
      -- Maven commands
      map('<leader>gb', function()
        vim.cmd('!mvn compile')
      end, '[M]aven [B]uild (compile)')

      map('<leader>gt', function()
        vim.cmd('!mvn test')
      end, '[M]aven [T]est')

      map('<leader>gc', function()
        vim.cmd('!mvn clean')
      end, '[M]aven [C]lean')

      map('<leader>gw', function()
        vim.cmd('!mvn spring-boot:run')
      end, '[M]aven [W]eb run (Spring Boot)')

      map('<leader>gp', function()
        vim.cmd('!mvn package')
      end, '[M]aven [P]ackage')
    end

    -- Manual project refresh command
    map('<leader>jr', function()
      vim.notify('Refreshing JDTLS workspace...', vim.log.levels.INFO)
      vim.lsp.buf.execute_command({
        command = 'java.clean.workspace'
      })
    end, '[J]ava [R]efresh workspace')

    -- Code generation
    map('<leader>jgs', function()
      vim.lsp.buf.execute_command({
        command = 'java.action.generateToStringPrompt'
      })
    end, '[J]ava [G]enerate toString')

    map('<leader>jgh', function()
      vim.lsp.buf.execute_command({
        command = 'java.action.hashCodeEqualsPrompt'
      })
    end, '[J]ava [G]enerate hashCode/equals')

    map('<leader>jgc', function()
      vim.lsp.buf.execute_command({
        command = 'java.action.generateConstructorsPrompt'
      })
    end, '[J]ava [G]enerate [C]onstructors')

    -- Update project configuration
    map('<leader>ju', function()
      vim.lsp.buf.execute_command({
        command = 'java.project.updateProjectConfiguration'
      })
    end, '[J]ava [U]pdate project config')

    -- Show project info
    map('<leader>ji', function()
      vim.lsp.buf.execute_command({
        command = 'java.project.getAll'
      })
    end, '[J]ava project [I]nfo')

    -- Notify when LSP is ready
    vim.notify('JDTLS attached to buffer ' .. bufnr, vim.log.levels.INFO)
  end,
}

-- Start or attach to jdtls
jdtls.start_or_attach(config)