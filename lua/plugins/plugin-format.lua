return {
    {
        'stevearc/conform.nvim',
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    lua = { 'stylua' },
                    sh = { 'shfmt' },
                    zsh = { 'shfmt' },
                    bash = { 'shfmt' },
                    javascript = { 'prettier' },
                    typescript = { 'prettier' },
                    json = { 'prettier' },
                    css = { 'prettier' },
                    html = { 'prettier' },
                    markdown = { 'prettier' },
                },
                format_on_save = true,
            })
        end,
    },
}
