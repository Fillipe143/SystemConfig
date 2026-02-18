-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Linhas Relativas
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab = 4 Espaços
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Usar cores reais
vim.opt.termguicolors = true

-- Fazer buffers serem criados na direita e em baixo
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Keybinds
vim.keymap.set("n", "<leader><leader>", "<cmd>b#<CR>", { desc = "Voltar para o último buffer", })
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>", { desc = "Abrir explorador de arquivos (Netrw)", })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Rolar para baixo e centralizar a tela" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Rolar para cima e centralizar a tela" })
vim.keymap.set("n", "<leader>d", "<cmd>noh<CR>", { desc = "Desmarcar busca (nohlsearch)" })

-- Ponteiro como block sempre
vim.opt.guicursor = "n-v-c-sm-i-ci-ve-r-cr-o:block"

-- Sempre mostrar coluna de simbolos
vim.opt.signcolumn = "yes"

-- Mostrar avisos no final da linha
vim.diagnostic.config({ virtual_text = true, })

-- Bordas redondas e sem background
vim.opt.winborder = "rounded"
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        local float_border = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg, })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal_bg, fg = float_border, })
    end,
})
