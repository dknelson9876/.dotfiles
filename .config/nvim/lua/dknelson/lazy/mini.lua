return {
    "echasnovski/mini.nvim",
    config = function()
        -- treesitter based text objects
        require("mini.ai").setup { n_lines = 500 }
        require("mini.align").setup()

        -- TODO: Other mini plugins
    end,
}
