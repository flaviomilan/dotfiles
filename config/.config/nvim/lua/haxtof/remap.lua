-- NOTE: Define binds with which-key
--
require('which-key').register {
  ['<leader>p'] = {
    name = '[P]',
    v = { vim.cmd.Ex, 'Navigate' },
  },
  ['<leader>m'] = {
    name = '[M]arreta',
    m = { '<cmd>%s/\\v(.+)/"\\1",/<CR>', '"word", each line' },
    n = { '<cmd>%s/\\n\\|\\s\\+/", "/g | %s/\\v^(.*[^ ]) *$/\\"\\1\\"/g<CR>', '"word", same line' },
  },
}
