return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main", -- Keep on the main branch for perfect compatibility with Neovim 0.12
        build = ":TSUpdate",

        -- 1. Replace the deprecated rainbow parentheses with its modern, independent successor
        dependencies = {
            "HiPhish/rainbow-delimiters.nvim", 
        },

        config = function()
            -- 2. The main branch removed the complex configs.setup, returning to a minimalist approach
            -- Directly call install to asynchronously install your required parsers
            local ensure_installed = { 
                "c", "cpp", "lua", "vim", "vimdoc", "query", 
                "markdown", "markdown_inline", "java", "python", 
                "javascript", "typescript" 
            }
            require("nvim-treesitter").install(ensure_installed)

            -- 3. Enable highlighting: the main branch hands highlighting control back to the native Neovim API
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    -- Attempt to start native treesitter highlighting for the current file type (silently skips if the parser is not installed)
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    }
}
