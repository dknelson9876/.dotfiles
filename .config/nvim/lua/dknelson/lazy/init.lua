-- Plugins that are simple enough to include that they don't deserve their own file
return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary",
    },
    {
        "norcalli/nvim-colorizer.lua",
        init = function()
            require("colorizer").setup {
                "*",
                lua = { RRGGBBAA = true },
            }
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    -- TODO telescope, nvim-cmp or mini.completions, todo highlights
}
