return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('user_lsp_attach', {clear = true}),
                callback = function(event)
                    local opts = {buffer = event.buf}

                    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
                    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
                end,
            })

            require('mason').setup({})
            -- mason-lspconfig v2：ensure_installed 里的 server 会被自动 enable，
            -- 不再需要 handlers 回调（该选项已从 v2 移除，写了也不生效）
            require('mason-lspconfig').setup({
                ensure_installed = {'bashls', 'clangd', 'ts_ls', 'pyright', 'dockerls', 'lua_ls', 'rust_analyzer'},
            })

            local cmp = require('cmp')
            local cmp_select = {behavior = cmp.SelectBehavior.Select}

            -- 注：代码片段（snippets）未启用。原先挂着 LuaSnip / cmp_luasnip /
            -- friendly-snippets 三个依赖，但 luasnip 补全源一直是注释状态，
            -- 属于从旧配置继承的死代码，已删除。如需启用：
            -- 加回上述三个依赖 + {name = 'luasnip', keyword_length = 2} 补全源
            -- + snippet.expand，并给 LSP 补上 cmp 的 capabilities。
            cmp.setup({
                sources = {
                    {name = 'buffer'},
                    {name = 'path'},
                    {name = 'nvim_lsp'},
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    -- ['<C-Space>'] = cmp.mapping.complete(),
                    -- -- ['<Esc>'] = cmp.mapping.abort(),
                    -- ['<Esc>'] = cmp.mapping.close(),
                    -- -- ['<Esc>'] = cmp.mapping.cancel(),
                }),
            })
        end,
    },
}
