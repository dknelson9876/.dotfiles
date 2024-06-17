return {
    {
        "rebelot/kanagawa.nvim",
        init = function()
            require("kanagawa").setup {
                transparent = true,
                theme = "dragon",
            }

            vim.cmd.colorscheme "kanagawa"
        end,
    },
}
