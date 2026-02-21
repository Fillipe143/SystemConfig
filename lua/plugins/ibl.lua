return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = { indent = { char = "·", tab_char = "·" }, },
    config = function(_, opts)
        require("ibl").setup(opts)

        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.SKIP_LINE, function(_, _, _, line)
            return line:match("^$")
        end)
    end,
}
