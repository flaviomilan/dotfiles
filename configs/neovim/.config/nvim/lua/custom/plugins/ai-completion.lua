return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim', -- VS Code-like pictograms
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

      -- Load friendly snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            show_labelDetails = true,
            before = function(entry, vim_item)
              -- Add source information
              vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snippet]',
                buffer = '[Buffer]',
                path = '[Path]',
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true, -- Show ghost text like GitHub Copilot
        },
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local ls = require('luasnip')
      
      -- Java snippets
      ls.add_snippets('java', {
        ls.snippet('main', {
          ls.text_node({'public static void main(String[] args) {', '\t'}),
          ls.insert_node(1, '// TODO: implementation'),
          ls.text_node({'', '}'}),
        }),
        ls.snippet('class', {
          ls.text_node('public class '),
          ls.insert_node(1, 'ClassName'),
          ls.text_node({' {', '\t'}),
          ls.insert_node(2, '// TODO: implementation'),
          ls.text_node({'', '}'}),
        }),
        ls.snippet('method', {
          ls.text_node('public '),
          ls.insert_node(1, 'void'),
          ls.text_node(' '),
          ls.insert_node(2, 'methodName'),
          ls.text_node('('),
          ls.insert_node(3, ''),
          ls.text_node({') {', '\t'}),
          ls.insert_node(4, '// TODO: implementation'),
          ls.text_node({'', '}'}),
        }),
        ls.snippet('test', {
          ls.text_node({'@Test', 'public void '}),
          ls.insert_node(1, 'testMethodName'),
          ls.text_node({'() {', '\t'}),
          ls.insert_node(2, '// TODO: test implementation'),
          ls.text_node({'', '}'}),
        }),
      })

      -- Kotlin snippets
      ls.add_snippets('kotlin', {
        ls.snippet('fun', {
          ls.text_node('fun '),
          ls.insert_node(1, 'functionName'),
          ls.text_node('('),
          ls.insert_node(2, ''),
          ls.text_node('): '),
          ls.insert_node(3, 'Unit'),
          ls.text_node({' {', '\t'}),
          ls.insert_node(4, '// TODO: implementation'),
          ls.text_node({'', '}'}),
        }),
        ls.snippet('class', {
          ls.text_node('class '),
          ls.insert_node(1, 'ClassName'),
          ls.text_node('('),
          ls.insert_node(2, ''),
          ls.text_node({') {', '\t'}),
          ls.insert_node(3, '// TODO: implementation'),
          ls.text_node({'', '}'}),
        }),
        ls.snippet('data', {
          ls.text_node('data class '),
          ls.insert_node(1, 'DataClass'),
          ls.text_node('('),
          ls.insert_node(2, 'val property: String'),
          ls.text_node(')'),
        }),
        ls.snippet('test', {
          ls.text_node({'@Test', 'fun '}),
          ls.insert_node(1, 'testMethodName'),
          ls.text_node({'() {', '\t'}),
          ls.insert_node(2, '// TODO: test implementation'),
          ls.text_node({'', '}'}),
        }),
      })

      -- Enable jumping between snippet placeholders
      vim.keymap.set({ 'i', 's' }, '<C-l>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
    end,
  },
  {
    'onsails/lspkind.nvim',
    config = function()
      require('lspkind').init({
        mode = 'symbol_text',
        preset = 'codicons',
        symbol_map = {
          Text = '󰉿',
          Method = '󰆧',
          Function = '󰊕',
          Constructor = '',
          Field = '󰜢',
          Variable = '󰀫',
          Class = '󰠱',
          Interface = '',
          Module = '',
          Property = '󰜢',
          Unit = '󰑭',
          Value = '󰎠',
          Enum = '',
          Keyword = '󰌋',
          Snippet = '',
          Color = '󰏘',
          File = '󰈙',
          Reference = '󰈇',
          Folder = '󰉋',
          EnumMember = '',
          Constant = '󰏿',
          Struct = '󰙅',
          Event = '',
          Operator = '󰆕',
          TypeParameter = '',
        },
      })
    end,
  },
}