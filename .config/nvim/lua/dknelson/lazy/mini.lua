return {
    "echasnovski/mini.nvim",
    config = function()
        -- treesitter based text objects
        require("mini.ai").setup { n_lines = 500 }

        -- TODO: Other mini plugins
    end,
}
