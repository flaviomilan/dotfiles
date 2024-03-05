require('obsidian').setup {

  workspaces = {
    {
      name = 'Zettelkasten',
      path = '~/zettelkasten/',
    },
  },

  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },

  -- Directories config
  notes_subdir = 'zettel/',
  new_notes_location = 'notes_subdir',

  daily_notes = {
    folder = 'journal/',
    date_format = '%Y-%m-%d',
    alias_format = '%B %-d, %Y',
    template = nil,
  },

  templates = {
    subdir = 'templates/',
    date_format = '%Y-%m-%d-%a',
    time_format = '%H:%M',
    tags = '',
  },

  -- UI config
  ui = {
    enable = true,
    update_debounce = 200,
    checkboxes = {
      [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
      ['x'] = { char = '', hl_group = 'ObsidianDone' },
      ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
      ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
    },
    bullets = { char = '•', hl_group = 'ObsidianBullet' },
    external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
    reference_text = { hl_group = 'ObsidianRefText' },
    highlight_text = { hl_group = 'ObsidianHighlightText' },
    tags = { hl_group = 'ObsidianTag' },
    hl_groups = {
      ObsidianTodo = { bold = true, fg = '#f78c6c' },
      ObsidianDone = { bold = true, fg = '#89ddff' },
      ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
      ObsidianTilde = { bold = true, fg = '#ff5370' },
      ObsidianBullet = { bold = true, fg = '#89ddff' },
      ObsidianRefText = { underline = true, fg = '#c792ea' },
      ObsidianExtLinkIcon = { fg = '#c792ea' },
      ObsidianTag = { italic = true, fg = '#89ddff' },
      ObsidianHighlightText = { bg = '#75662e' },
    },
  },

  -- Attachments
  attachments = {
    img_folder = 'assets/imgs',
    img_text_func = function(client, path)
      local link_path
      local vault_relative_path = client:vault_relative_path(path)
      if vault_relative_path ~= nil then
        link_path = vault_relative_path
      else
        link_path = tostring(path)
      end
      local display_name = vim.fs.basename(link_path)
      return string.format('![%s](%s)', display_name, link_path)
    end,
  },

  note_frontmatter_func = function(note)
    local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = '', project = '' }
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,

  note_id_func = function(title)
    local suffix = ''
    if title ~= nil then
      suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. '-' .. suffix
  end,

  wiki_link_func = function(opts)
    if opts.id == nil then
      return string.format('[[%s]]', opts.label)
    elseif opts.label ~= opts.id then
      return string.format('[[%s|%s]]', opts.id, opts.label)
    else
      return string.format('[[%s]]', opts.id)
    end
  end,
}
