require('which-key').register {
  -- INFO: Navigation
  ['<leader>n'] = {
    name = '[N]avigate',
    e = { vim.cmd.Ex, 'Explorer' },
  },

  -- INFO: Marreta binds
  -- Binds referente às marretadas da vida de dev
  ['<leader>m'] = {
    name = '[M]arreta',
    m = { '<cmd>%s/\\v(.+)/"\\1",/<CR>', '"word", each line' },
    n = { '<cmd>%s/\\n\\|\\s\\+/", "/g | %s/\\v^(.*[^ ]) *$/\\"\\1\\"/g<CR>', '"word", same line' },
  },

  -- INFO: Obidisian binds
  -- Binds utilizados em conjunto com o plugin `obsidian.nvim`
  ['<leader>o'] = {
    name = '[O]bsidian',

    -- notes
    a = { '<cmd>ObsidianQuickSwitch<cr>', '[Notes] Quick Switch' },
    c = { '<cmd>ObsidianNew<cr>', '[Notes] Create new' },
    e = { '<cmd>ObsidianSearch<cr>', '[Notes] Search all' },

    -- journal
    j = { '<cmd>ObsidianYesterday<cr>', '[Journal] Yesterday' },
    k = { '<cmd>ObsidianToday<cr>', '[Journal] Today' },
    l = { '<cmd>ObsidianTomorrow<cr>', '[Journal] Tomorrow' },

    -- links
    m = { '<cmd>ObsidianBacklinks<cr>', '[Links] Show location list of backlinks' },
    n = { '<cmd>ObsidianFollowLink<cr>', '[Links] Follow under cursor' },
    o = { '<cmd>ObsidianLinks<cr>', '[Links] Show all links' },

    -- templates
    t = { '<cmd>ObsidianTemplate<cr>', 'Templates' },
    p = { '<cmd>ObsidianTags<cr>', 'Tags' },
    w = { '<cmd>ObsidianWorkspace<cr>', 'Workspaces' },
  },
}
