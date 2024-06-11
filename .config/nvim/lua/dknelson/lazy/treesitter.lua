local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua", "vimdoc", "c", "bash", "diff", "markdown", "go"
            },

            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "markdown" },
            },
        })
    end
}

return {M}
