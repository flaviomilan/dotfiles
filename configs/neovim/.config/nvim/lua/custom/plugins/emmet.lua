return {
  'mattn/emmet-vim',
  ft = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'astro' },
  init = function()
    -- Enable Emmet in JavaScript/TypeScript files for JSX
    vim.g.user_emmet_settings = {
      javascript = {
        extends = 'jsx',
      },
      typescript = {
        extends = 'jsx',
      },
      javascriptreact = {
        extends = 'jsx',
      },
      typescriptreact = {
        extends = 'jsx',
      },
      vue = {
        extends = 'html',
      },
      astro = {
        extends = 'html',
      },
    }

    -- Set the leader key for Emmet to <C-z> (default is <C-y>)
    vim.g.user_emmet_leader_key = '<C-z>'

    -- Enable Emmet only in insert mode
    vim.g.user_emmet_mode = 'i'
  end,
}