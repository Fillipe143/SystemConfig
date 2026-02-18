return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "javascript" },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = { enable = true },
            textobjects = { enable = true },
            fold = { enable = true },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                local ft = vim.bo.filetype
                local ok, parser = pcall(vim.treesitter.get_parser, 0, ft)
                if ok and parser then
                    vim.treesitter.start()
                end
            end,
        })
    end,
}
