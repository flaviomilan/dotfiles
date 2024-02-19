-- open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- facilitar minha vida nas marretadas por aí
vim.keymap.set('n', '<C-m>,', [[:%s/\v(.+)/"\1",/<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<C-m>.', [[::%s/\n\|\s\+/","/g | %s/\v^|$/" /g<CR>]], { noremap = true, silent = true })

-- Keybinds
local map = vim.api.nvim_set_keymap

-- Neorg keybinds
map('n', '<Leader>on', [[:Neorg new<CR>]], { noremap = true, silent = true })
map('n', '<Leader>ot', [[:NeorgCapture<CR>]], { noremap = true, silent = true })
map('n', '<Leader>os', [[:NeShowSubtree<CR>]], { noremap = true, silent = true })

-- Normal mode keybinds for Neorg-specific commands
map('n', '<Leader>on', [[:NeorgOrgNext<CR>]], { noremap = true, silent = true })
map('n', '<Leader>op', [[:NeorgOrgPrev<CR>]], { noremap = true, silent = true })

-- Insert mode keybind for quickly adding TODO items
map('i', '<Leader>ti', [[<ESC>:NeorgCapture! --template todo<CR>i]], { noremap = true, silent = true })

-- Visual mode keybind for marking items as done
map('x', '<Leader>td', [[:lua require('neorg').capture.visual_capture()<CR>]], { noremap = true, silent = true })
