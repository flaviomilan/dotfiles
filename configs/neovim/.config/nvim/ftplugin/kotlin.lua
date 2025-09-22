-- Kotlin ftplugin for enhanced development experience
-- This file is loaded automatically for Kotlin files

local function setup_kotlin_keymaps(bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, {
      buffer = bufnr,
      desc = 'Kotlin: ' .. desc,
      silent = true
    })
  end

  -- Build tool detection and commands
  local is_gradle = vim.fn.filereadable('build.gradle') == 1 or vim.fn.filereadable('build.gradle.kts') == 1
  local is_maven = vim.fn.filereadable('pom.xml') == 1

  if is_gradle then
    -- Gradle Kotlin commands
    map('<leader>kb', function()
      vim.cmd('!./gradlew build')
    end, '[K]otlin [B]uild (Gradle)')

    map('<leader>kt', function()
      vim.cmd('!./gradlew test')
    end, '[K]otlin [T]est (Gradle)')

    map('<leader>kc', function()
      vim.cmd('!./gradlew clean')
    end, '[K]otlin [C]lean (Gradle)')

    map('<leader>kr', function()
      vim.cmd('!./gradlew bootRun')
    end, '[K]otlin [R]un (Spring Boot)')

    map('<leader>kC', function()
      vim.cmd('!./gradlew compileKotlin')
    end, '[K]otlin [C]ompile only')

  elseif is_maven then
    -- Maven Kotlin commands
    map('<leader>kb', function()
      vim.cmd('!mvn compile')
    end, '[K]otlin [B]uild (Maven)')

    map('<leader>kt', function()
      vim.cmd('!mvn test')
    end, '[K]otlin [T]est (Maven)')

    map('<leader>kc', function()
      vim.cmd('!mvn clean')
    end, '[K]otlin [C]lean (Maven)')

    map('<leader>kr', function()
      vim.cmd('!mvn spring-boot:run')
    end, '[K]otlin [R]un (Spring Boot)')

    map('<leader>kC', function()
      vim.cmd('!mvn kotlin:compile')
    end, '[K]otlin [C]ompile only')
  end

  -- Kotlin-specific actions
  map('<leader>kf', function()
    vim.lsp.buf.format({ async = true })
  end, '[K]otlin [F]ormat')

  map('<leader>ko', function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:match("Organize imports") or action.title:match("Sort imports")
      end,
      apply = true
    })
  end, '[K]otlin [O]rganize imports')

  -- Quick actions for common Kotlin patterns
  map('<leader>kd', function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:match("data class") or action.title:match("Data class")
      end,
      apply = true
    })
  end, '[K]otlin convert to [D]ata class')

  map('<leader>kn', function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:match("null") or action.title:match("safe")
      end,
      apply = true
    })
  end, '[K]otlin [N]ull safety actions')

  -- Refactoring commands
  map('<leader>kv', function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:match("Extract") and action.title:match("variable")
      end,
      apply = true
    })
  end, '[K]otlin extract [V]ariable')

  map('<leader>km', function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:match("Extract") and action.title:match("method")
      end,
      apply = true
    })
  end, '[K]otlin extract [M]ethod')

  -- Spring Boot specific actions
  map('<leader>ks', function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:match("@Service") or
               action.title:match("@Component") or
               action.title:match("@Repository") or
               action.title:match("@Controller")
      end,
      apply = true
    })
  end, '[K]otlin [S]pring annotations')

  -- Generate common code patterns
  map('<leader>kg', function()
    local choices = {
      "toString()",
      "hashCode() and equals()",
      "copy() method",
      "companion object",
      "data class conversion"
    }

    vim.ui.select(choices, {
      prompt = "Generate Kotlin code:",
    }, function(choice)
      if choice then
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.title:lower():match(choice:lower():gsub("[()%s]", ""))
          end,
          apply = true
        })
      end
    end)
  end, '[K]otlin [G]enerate code')

  -- Quick documentation
  map('<leader>kh', function()
    vim.lsp.buf.hover()
  end, '[K]otlin [H]over documentation')

  -- Symbol search
  map('<leader>kw', function()
    require('telescope.builtin').lsp_workspace_symbols({
      query = vim.fn.input("Kotlin symbols: ")
    })
  end, '[K]otlin [W]orkspace symbols')
end

-- Enhanced on_attach for Kotlin
local function on_attach(client, bufnr)
  -- Set up Kotlin-specific keymaps
  setup_kotlin_keymaps(bufnr)

  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    vim.keymap.set('n', '<leader>kth', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
    end, {
      buffer = bufnr,
      desc = '[K]otlin [T]oggle inlay [H]ints'
    })
  end

  -- Auto-organize imports on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.title:match("Organize imports") or action.title:match("Sort imports")
        end,
        apply = true
      })
    end,
  })

  vim.notify('Kotlin LSP attached with enhanced actions', vim.log.levels.INFO)
end

-- Configure kotlin_language_server with enhanced settings
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.kotlin_language_server.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = "17"
        }
      },
      completion = {
        snippets = {
          enabled = true
        }
      },
      codeGeneration = {
        enabled = true
      },
      indexing = {
        enabled = true
      }
    }
  },
  init_options = {
    storagePath = vim.fn.stdpath('cache') .. '/kotlin-language-server'
  }
})

-- Set Kotlin-specific options
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true

-- File patterns for better recognition
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.kt",
  callback = function()
    vim.bo.filetype = "kotlin"
  end,
})