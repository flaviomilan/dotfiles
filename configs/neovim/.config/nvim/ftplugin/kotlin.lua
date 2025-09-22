-- Kotlin ftplugin using official JetBrains kotlin-lsp
-- This file is loaded automatically for Kotlin files

-- Debug: Verificar se ftplugin está sendo carregado
vim.notify('🔧 Kotlin ftplugin loaded!', vim.log.levels.INFO, { title = 'Debug' })

local function find_project_root()
  local util = require 'lspconfig.util'

  local patterns = {
    'settings.gradle',
    'settings.gradle.kts',
    'gradlew',
    'pom.xml',
    '.git',
    'build.gradle',
    'build.gradle.kts',
  }

  return util.root_pattern(unpack(patterns))(vim.api.nvim_buf_get_name(0))
end

local function run_in_terminal(cmd)
  vim.cmd('split | terminal ' .. cmd)
end

local function setup_kotlin_keymaps(bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, {
      buffer = bufnr,
      desc = 'Kotlin: ' .. desc,
      silent = true,
    })
  end

  local root = find_project_root()
  local is_gradle = false
  local is_maven = false

  if root then
    is_gradle = vim.fn.filereadable(root .. '/build.gradle') == 1 or vim.fn.filereadable(root .. '/build.gradle.kts') == 1
    is_maven = vim.fn.filereadable(root .. '/pom.xml') == 1
  end

  -- Debug: Notificar detecção do projeto
  vim.notify(string.format('Kotlin ftplugin: root=%s, gradle=%s, maven=%s', root or 'nil', is_gradle, is_maven), vim.log.levels.INFO)

  if is_gradle then
    local gradlew = root .. '/gradlew'
    map('<leader>kb', function()
      run_in_terminal(gradlew .. ' build')
    end, '[K]otlin [B]uild (Gradle)')
    map('<leader>kt', function()
      run_in_terminal(gradlew .. ' test')
    end, '[K]otlin [T]est (Gradle)')
    map('<leader>kc', function()
      run_in_terminal(gradlew .. ' clean')
    end, '[K]otlin [C]lean (Gradle)')
    map('<leader>kr', function()
      run_in_terminal(gradlew .. ' bootRun')
    end, '[K]otlin [R]un (Spring Boot)')
    map('<leader>kC', function()
      run_in_terminal(gradlew .. ' compileKotlin')
    end, '[K]otlin [C]ompile only')
  elseif is_maven then
    local mvn = 'mvn -f ' .. root .. '/pom.xml'
    map('<leader>kb', function()
      run_in_terminal(mvn .. ' compile')
    end, '[K]otlin [B]uild (Maven)')
    map('<leader>kt', function()
      run_in_terminal(mvn .. ' test')
    end, '[K]otlin [T]est (Maven)')
    map('<leader>kc', function()
      run_in_terminal(mvn .. ' clean')
    end, '[K]otlin [C]lean (Maven)')
    map('<leader>kr', function()
      run_in_terminal(mvn .. ' spring-boot:run')
    end, '[K]otlin [R]un (Spring Boot)')
    map('<leader>kC', function()
      run_in_terminal(mvn .. ' kotlin:compile')
    end, '[K]otlin [C]ompile only')
  end

  map('<leader>kf', function()
    vim.lsp.buf.format { async = true }
  end, '[K]otlin [F]ormat')

  map('<leader>ko', function()
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title:match 'Organize imports' or action.title:match 'Sort imports'
      end,
      apply = true,
      context = { only = { 'source.organizeImports' } },
    }
  end, '[K]otlin [O]rganize imports')

  map('<leader>kd', function()
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title:match 'data class' or action.title:match 'Data class'
      end,
      apply = true,
    }
  end, '[K]otlin convert to [D]ata class')

  map('<leader>kn', function()
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title:match 'null' or action.title:match 'safe'
      end,
      apply = true,
    }
  end, '[K]otlin [N]ull safety actions')

  map('<leader>kv', function()
    vim.lsp.buf.rename()
  end, '[K]otlin rename [V]ariable')

  map('<leader>km', function()
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title:match 'Extract' and action.title:match 'method'
      end,
      apply = true,
    }
  end, '[K]otlin extract [M]ethod')

  map('<leader>ks', function()
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title:match '@Service' or action.title:match '@Component' or action.title:match '@Repository' or action.title:match '@Controller'
      end,
      apply = true,
    }
  end, '[K]otlin [S]pring annotations')

  map('<leader>kg', function()
    vim.lsp.buf.code_action()
  end, '[K]otlin [G]enerate code / Code actions')

  map('<leader>kh', function()
    vim.lsp.buf.hover()
  end, '[K]otlin [H]over documentation')

  map('<leader>kw', function()
    -- Usar Snacks.picker com tratamento de erro
    local ok, err = pcall(function()
      Snacks.picker.lsp_workspace_symbols()
    end)
    if not ok then
      -- Fallback para nativo se Snacks falhar
      vim.notify('Snacks picker failed, using native LSP', vim.log.levels.WARN)
      vim.lsp.buf.workspace_symbol()
    end
  end, '[K]otlin [W]orkspace symbols')

  -- Comandos de navegação LSP adicionais com Snacks.picker
  map('<leader>ki', function()
    local ok = pcall(function()
      Snacks.picker.lsp_implementations()
    end)
    if not ok then
      vim.lsp.buf.implementation()
    end
  end, '[K]otlin [I]mplementation')

  map('<leader>kR', function()
    local ok = pcall(function()
      Snacks.picker.lsp_references()
    end)
    if not ok then
      vim.lsp.buf.references()
    end
  end, '[K]otlin [R]eferences')

  map('<leader>kD', function()
    local ok = pcall(function()
      Snacks.picker.lsp_type_definitions()
    end)
    if not ok then
      vim.lsp.buf.type_definition()
    end
  end, '[K]otlin Type [D]efinition')
end

-- Register keymaps immediately when file opens
local bufnr = vim.api.nvim_get_current_buf()
setup_kotlin_keymaps(bufnr)

local function on_attach(client, bufnr)
  -- Keymaps already registered above

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    vim.keymap.set('n', '<leader>kth', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, { buffer = bufnr, desc = '[K]otlin [T]oggle inlay [H]ints' })
  end

  vim.notify('Official Kotlin LSP (JetBrains) attached successfully!', vim.log.levels.INFO, { title = 'Kotlin LSP' })
end

-- Configure official JetBrains kotlin-lsp
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.kotlin_lsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    "kotlin-lsp",
    -- Suprimir warnings de desktop Java no WSL/Linux
    "-J-Djava.awt.headless=true",
    "-J-XX:+DisableAttachMechanism",
  },
  root_dir = function(fname)
    -- Detectar raiz do projeto Maven/Gradle corretamente
    local util = require 'lspconfig.util'
    return util.root_pattern('pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle', 'settings.gradle.kts', '.git')(fname)
  end,
  settings = {
    kotlin = {
      compiler = {
        jvm = { target = '21' },
        -- Forçar detecção de classpath Maven
        classpath = vim.fn.system('mvn dependency:build-classpath -q -Dmdep.outputFile=/dev/stdout 2>/dev/null'):gsub('\n', ''),
      },
      completion = { snippets = { enabled = true } },
      codeGeneration = { enabled = true },
      indexing = {
        enabled = true,
        -- Otimizações para evitar re-indexação constante
        excludeDirs = { "build", "target", ".gradle", "node_modules" },
      },
      -- Configurações experimentais para Maven
      externalSources = { enabled = true },
      maven = { enabled = true },
    },
  },
  init_options = {
    -- Cache para melhorar performance
    storePath = vim.fn.stdpath 'cache' .. '/kotlin-lsp',
    -- Configurações experimentais
    projectSettings = {
      languageLevel = "21",
      compilerOutputPath = vim.fn.getcwd() .. "/target/classes",
    },
  },
}

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true