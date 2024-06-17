return {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('oil').setup {
            columns = {
                'icon',
            },
        }

        vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "<space>-", require("oil").toggle_float, {desc = "Open directory in Oil" })
    end,
}
