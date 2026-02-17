return {
    "rebelot/kanagawa.nvim",
    config = function()
        require("kanagawa").setup({
            theme = "dragon",
            background = { dark = "dragon" },
            colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
        })
        vim.cmd("colorscheme kanagawa")
    end,
}
