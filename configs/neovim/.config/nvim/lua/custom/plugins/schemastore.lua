return {
  {
    'b0o/schemastore.nvim',
    ft = { 'json', 'jsonc', 'yaml' },
    config = function()
      local lspconfig = require('lspconfig')
      
      -- JSON Schema support
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = require('schemastore').json.schemas({
              select = {
                '.eslintrc',
                'package.json',
                'tsconfig.json',
                'jsconfig.json',
              },
            }),
            validate = { enable = true },
          },
        },
      })

      -- YAML Schema support  
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      })
    end,
  },
}