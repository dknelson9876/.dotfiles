return {{
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Auto install LSPs and related tools to stdpath for nvim
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        { 'j-hui/fidget.nvim', opts = {} },

        -- lsp for your nvim config
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function ()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),

            -- Add LSP related keybinds, only when an LSP is running
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, {buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                map('K', vim.lsp.buf.hover, 'Hover Documentation')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            end
        })

        -- Include additional LSP client features from plugins in what we tell LSP servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
            gopls = {},
            tsserver = {},
            pyright = {},

            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                    },
                },
            },
        }

        require('mason').setup()
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua', -- Lua formatter
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end
            },
        }
    end
},
    { -- Autoformatter
        'stevearc/conform.nvim',
        lazy = false,
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format {async = true, lsp_fallback = true }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- disable for languages that don't have a single standard style
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                javascript = { { "prettierd", "prettier" } },
            },
        },
    },

    { -- Completion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- build step is necessary for regex support in snippets
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                     -- see README at https://github.com/rafamadriz/friendly-snippets
                },
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },

        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {completeopt = 'menu,menuone,noinsert' },

                mapping = cmp.mapping.preset.insert {
                      ['<C-n>'] = cmp.mapping.select_next_item(),
                      ['<C-p>'] = cmp.mapping.select_prev_item(),
                      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                      ['<C-f>'] = cmp.mapping.scroll_docs(4),

                      ['<C-y>'] = cmp.mapping.confirm { select = true },

                      -- Manually trigger a completion from nvim-cmp.
                      --  Generally you don't need this, because nvim-cmp will display
                      --  completions whenever it has completion options available.
                      ['<C-Space>'] = cmp.mapping.complete {},

                      ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                          luasnip.expand_or_jump()
                        end
                      end, { 'i', 's' }),
                      ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                          luasnip.jump(-1)
                        end
                      end, { 'i', 's' }),

                      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },

                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
            }
        end,
    },
}
