return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({

            completion = {
                autocomplete = { cmp.TriggerEvent.TextChanged },
                completeopt = "menu,menuone,noinsert",
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-N>"] = cmp.mapping.select_next_item(),
                ["<C-P>"] = cmp.mapping.select_prev_item(),
            }),

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
            }, {
                { name = "buffer" },
                { name = "path" },
            }),

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
        })
    end
}

