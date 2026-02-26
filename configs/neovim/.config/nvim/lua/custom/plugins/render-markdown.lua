-- -------------------------------------------------------
-- render-markdown.nvim — Beautiful markdown rendering
-- Used by avante.nvim and CopilotChat for rich output
-- -------------------------------------------------------
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.icons',
  },
  ft = { 'markdown', 'Avante' },
  opts = {
    file_types = { 'markdown', 'Avante' },
    heading = {
      icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
    },
    code = {
      sign = false,
      width = 'block',
      right_pad = 1,
    },
    bullet = {
      icons = { '●', '○', '◆', '◇' },
    },
    checkbox = {
      unchecked = { icon = '☐ ' },
      checked = { icon = '☑ ' },
    },
  },
}
