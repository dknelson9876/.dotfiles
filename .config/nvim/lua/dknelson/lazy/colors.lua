return {
    {
        "rebelot/kanagawa.nvim",
        init = function()
            require("kanagawa").setup {
                transparent = true,
            }

            vim.cmd.colorscheme "kanagawa"
        end,
        overrides = function(colors)
            local theme = colors.theme
            return {
                Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                PmenuSbaar = { bg = theme.ui.bg_m1 },
                PmenuThumb = { bg = theme.ui.bg_p2 },
            }
        end,
    },
}
