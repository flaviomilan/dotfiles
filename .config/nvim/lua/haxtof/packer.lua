vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- themes
    use({"catppuccin/nvim", as = "catppuccin"})
    use("kyazdani42/nvim-web-devicons")

    -- treesitter
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use({
        "NTBBloodbath/galaxyline.nvim",
        config = function()
            require("galaxyline.themes.eviline")
        end,
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    })

    -- extra
    use('theprimeagen/harpoon')
    use("mbbill/undotree")
    use("tpope/vim-fugitive")

    -- lsp
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- LSP Support
            {'neovim/nvim-lspconfig'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }

    -- org-mode and org-roam
    use {'nvim-orgmode/orgmode', config = function()
        require('orgmode').setup{}
    end}
    use {
        'renerocksai/telekasten.nvim',
        requires = {'nvim-telescope/telescope.nvim'}
    }


end)
