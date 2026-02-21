return {
    "ThePrimeagen/harpoon",
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")
        vim.api.nvim_set_hl(0, "HarpoonBorder", { link = "FloatBorder" })
        vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Adicionar o arquivo atual ao Harpoon" })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Abrir o menu de navegação rápida do Harpoon" })
        vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Navegar até o primeiro arquivo marcado" })
        vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, { desc = "Navegar até o segundo arquivo marcado" })
        vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, { desc = "Navegar até o terceiro arquivo marcado" })
        vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, { desc = "Navegar até o quarto arquivo marcado" })
    end,
}
