-- open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- facilitar minha vida nas marretadas por aí
vim.keymap.set('n', '<C-m>,', [[:%s/\v(.+)/"\1",/<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<C-m>.', [[::%s/\n\|\s\+/","/g | %s/\v^|$/" /g<CR>]], { noremap = true, silent = true })
