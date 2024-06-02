-- Plugins that are simple enough to include that they don't deserve their own file
return {
    {
        'nvim-lua/plenary.nvim',
        name = 'plenary'
    },
    {
        'numToStr/Comment.nvim', opts = {}
    },
    {
        'norcalli/nvim-colorizer.lua',
        init = function()
            require('colorizer').setup({
                '*';
                lua = {RRGGBBAA = true; };
            })
        end
    },
}
