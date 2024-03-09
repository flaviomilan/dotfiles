return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },

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
        d = {
          function()
            RemoveDuplicates()
          end,
          'remove duplicated items',
        },
      },

      -- INFO: Obidisian binds
      -- Binds utilizados em conjunto com o plugin `obsidian.nvim`
      ['<leader>o'] = {
        name = '[O]bsidian',

        -- notes
        n = {
          name = '[N]otes',
          q = { '<cmd>ObsidianQuickSwitch<cr>', 'Quick Switch' },
          c = { '<cmd>ObsidianNew<cr>', 'Create new' },
          s = { '<cmd>ObsidianSearch<cr>', 'Search all' },
        },

        -- journal
        j = {
          name = '[J]ournal',
          y = { '<cmd>ObsidianYesterday<cr>', 'Yesterday' },
          t = { '<cmd>ObsidianToday<cr>', 'Today' },
          o = { '<cmd>ObsidianTomorrow<cr>', 'Tomorrow' },
        },

        -- links
        l = {
          name = '[L]inks',
          m = { '<cmd>ObsidianBacklinks<cr>', 'Show location list of backlinks' },
          n = { '<cmd>ObsidianFollowLink<cr>', 'Follow under cursor' },
          o = { '<cmd>ObsidianLinks<cr>', 'Show all links' },
        },

        -- templates, tags and workspaces
        t = { '<cmd>ObsidianTemplate<cr>', 'Templates' },
        p = { '<cmd>ObsidianTags<cr>', 'Tags' },
        w = { '<cmd>ObsidianWorkspace<cr>', 'Workspaces' },
      },

      -- INFO: Git binds
      -- Binds utilizado em conjunto com o plugin `octo.nvim`
      ['<leader>g'] = {
        name = '[G]it',
        g = {
          name = '[G]ithub',
          a = { '<cmd>Octo actions<cr>', 'Octo Actions' },
          i = {
            name = 'Issues',
            c = { '<cmd>Octo issue close<cr>', 'Close current issue' },
            r = { '<cmd>Octo issue reopen<cr>', 'Reopen current issue' },
            a = { '<cmd>Octo issue create<cr>', 'Create new issue' },
            e = { '<cmd>Octo issue edit<cr>', 'Edit issue' },
            l = { '<cmd>Octo issue list<cr>', 'List issues' },
            s = { '<cmd>Octo issue search<cr>', 'Search issue' },
            t = { '<cmd>Octo issue reload<cr>', 'Reload issue' },
            b = { '<cmd>Octo issue browser<cr>', 'Open current issue in the browser' },
            u = { '<cmd>Octo issue url<cr>', 'Copies the URL of the current issue' },
          },
          p = {
            name = "PR's",
            l = { '<cmd>Octo pr list<cr>', "List all PR's" },
            s = { '<cmd>Octo pr search<cr>', 'Search' },
            e = { '<cmd>Octo pr edit<cr>', 'Edit PR' },
            r = { '<cmd>Octo pr reopen<cr>', 'Reopen the current PR' },
            c = { '<cmd>Octo pr create<cr>', 'Create a new PR' },
            x = { '<cmd>Octo pr close<cr>', 'Close current PR' },
            z = { '<cmd>Octo pr checkout<cr>', 'Checkout PR' },
            t = { '<cmd>Octo pr commits<cr>', 'List all PR commits' },
            g = { '<cmd>Octo pr changes<cr>', 'Show all PR changes' },
            d = { '<cmd>Octo pr diff<cr>', 'Show PR diff' },
            y = { '<cmd>Octo pr ready<cr>', 'Mark draft PR as ready' },
            u = { '<cmd>Octo pr draft<cr>', 'Mark ready PR as draft' },
            k = { '<cmd>Octo pr checks<cr>', 'Show the status of all checks' },
            j = { '<cmd>Octo pr reload<cr>', 'Reload PR' },
            b = { '<cmd>Octo pr browser<cr>', 'Open current PR in the browser' },
            p = { '<cmd>Octo pr url<cr>', 'Copy the URL of the current PR' },
          },
          r = {
            name = 'Repository',
            l = { '<cmd>Octo repo list<cr>', 'List repositories' },
            z = { '<cmd>Octo repo fork<cr>', 'Fork repository' },
            b = { '<cmd>Octo repo browser<cr>', 'Open in browser' },
            u = { '<cmd>Octo repo url<cr>', 'Copy url of current repo' },
            v = { '<cmd>Octo repo view<cr>', 'Open repo by path {org}/{repo}' },
          },
          q = { '<cmd>Octo reviewer add<cr>', 'Add reviewer' },
          o = {
            name = 'Reaction',
            u = { '<cmd>Octo reaction thumbs_up<cr>', 'Add 👍 reaction' },
            d = { '<cmd>Octo reaction thumbs_down<cr>', 'Add 👎 reaction' },
            e = { '<cmd>Octo reaction eyes<cr>', 'Add 👀 reaction' },
            l = { '<cmd>Octo reaction laugh<cr>', 'Add 😄 reaction' },
            c = { '<cmd>Octo reaction confused<cr>', 'Add 😕 reaction' },
            r = { '<cmd>Octo reaction rocket<cr>', 'Add 🚀 reaction' },
            h = { '<cmd>Octo reaction heart<cr>', 'Add ❤️  reaction' },
            t = { '<cmd>Octo reaction tada<cr>', 'Add 🎉 reaction' },
          },
          e = {
            name = 'Reviews',
            s = { '<cmd>Octo review start<cr>', 'Start review' },
            d = { '<cmd>Octo review submit<cr>', 'Submit review' },
            r = { '<cmd>Octo review resume<cr>', 'Resume pending review' },
            t = { '<cmd>Octo review discard<cr>', 'Deletes a pending review' },
            p = { '<cmd>Octo review commit<cr>', 'Pick a specific commit' },
            c = { '<cmd>Octo review close<cr>', 'Close the review window' },
          },
        },
      },

      -- INFO: Projects binds
      -- Binds utilizados em conjunto com o plugin `neovim-project`
      ['<leader>p'] = {
        name = '[P]rojects',
        d = { '<cmd>Telescope neovim-project discover<cr>', 'Find projects' },
        h = { '<cmd>Telescope neovim-project history<cr>', 'History' },
        l = { '<cmd>NeovimProjectLoadRecent<cr>', 'Load recent' },
      },
    }

    function RemoveDuplicates()
      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local seen = {}
      local unique_lines = {}

      for _, line in ipairs(lines) do
        if not seen[line] then
          table.insert(unique_lines, line)
          seen[line] = true
        end
      end

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, unique_lines)
    end
  end,
}