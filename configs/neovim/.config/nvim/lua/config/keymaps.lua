-- Keymaps are automatically loaded on the VeryLazy event
-- Add any additional keymaps here

-- Keep selection when indenting in visual mode
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and reselect" })

-- Select all content
vim.keymap.set("n", "==", "ggVG", { desc = "Select all" })
