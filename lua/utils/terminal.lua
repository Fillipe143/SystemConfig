local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    opts = opts or {}

    -- Get editor dimensions
    local ui = vim.api.nvim_list_uis()[1]
    local screen_width = ui.width
    local screen_height = ui.height

    -- Default to 80% of screen
    local width = opts.width or math.floor(screen_width * 0.8)
    local height = opts.height or math.floor(screen_height * 0.8)

    -- Ensure it fits
    width = math.min(width, screen_width)
    height = math.min(height, screen_height)

    -- Center calculation
    local col = math.floor((screen_width - width) / 2)
    local row = math.floor((screen_height - height) / 2)

    -- Create scratch buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    -- Window options
    vim.api.nvim_set_hl(0, "FloatTitle", { link = "NormalFloat" })
    local win_opts = {
        title = "   Floating Terminal ",
        title_pos = "center",
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window({ buf = state.floating.buf })
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end

        vim.keymap.set("n", "<Esc>", function()
            vim.api.nvim_win_hide(state.floating.win)
        end, { buffer = state.floating.buf, silent = true })
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("Terminal", toggle_terminal, {})
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<leader>pt", toggle_terminal)
