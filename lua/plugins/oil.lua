return {
    "stevearc/oil.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", }
    },
    config = function()
        require("oil").setup({
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == ".."
                end
            },
            columns = { "icon", },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                ["<C-a>"] = { "actions.select", opts = { horizontal = true } },
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil",
            callback = function()
                local dir = require("oil").get_current_dir()
                vim.wo.winbar = "%#Directory#   " .. dir
            end,
        })
    end
}
