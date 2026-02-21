return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Lua
        vim.lsp.config("lua_ls", require("plugins.lsp.lua_ls"))
        vim.lsp.enable("lua_ls")

        -- Javascript/Typescript
        vim.lsp.enable("ts_ls")

        -- Html
        vim.lsp.enable("html")
        vim.lsp.enable("emmet_language_server")

        vim.keymap.set("n", "<leader>ai", function()
            vim.lsp.buf.format({ async = true })
        end)
    end,
}
