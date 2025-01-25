return {
  "nvim-telescope/telescope.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup{
      defaults = {
        prompt_prefix = ">> ",
        color_devicons = true,
      },
    }
  end
}
