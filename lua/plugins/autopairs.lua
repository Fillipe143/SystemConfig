return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local autopairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        autopairs.setup()

        autopairs.add_rules({
            Rule("/**", "*/", { "javascript", "typescript", "java", "c", "cpp" })
            :set_end_pair_length(2)
            :with_move(function(opts) return opts.prev_char:match("/%*%*") ~= nil end)
        })

        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
