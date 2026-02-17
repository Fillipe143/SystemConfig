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
