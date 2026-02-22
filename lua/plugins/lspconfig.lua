return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Keybinds
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)                                           -- Ir para definição
        vim.keymap.set("n", "<leader>lx", vim.lsp.buf.declaration, opts)                                          -- Ir para declaração
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)                                       -- Ir para implementação
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)                                           -- Ver referências
        vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts)                                        -- Abrir diagnóstico flutuante
        vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)  -- Próximo diagnóstico
        vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts) -- Diagnóstico anterior
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)                                          -- Code actions
        vim.keymap.set("n", "<leader>lm", vim.lsp.buf.rename, opts)                                               -- Renomear
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)              -- Formatar código
        vim.keymap.set("n", "<C-;>", "<Plug>(comment_toggle_linewise_current)", {})
        vim.keymap.set("v", "<C-;>", "<Plug>(comment_toggle_linewise_visual)", {})

        -- Lua
        vim.lsp.config("lua_ls", require("plugins.lsp.lua_ls"))
        vim.lsp.enable("lua_ls")

        -- Javascript/Typescript
        vim.lsp.enable("ts_ls")

        -- Html
        vim.lsp.enable("html")
        vim.lsp.enable("emmet_language_server")

        -- Rust
        vim.lsp.enable("rust_analyzer")

        -- Ocaml
        vim.opt.rtp:prepend(vim.fn.expand("~/.opam/default/share/ocp-indent/vim"))
        vim.lsp.enable("ocamllsp")
    end,
}
