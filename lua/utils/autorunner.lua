local config = {
    output_title = "Output",
    input_title = "Input",
    output_width = 0.5,
    output_height = 0.7,
    cache_file = vim.fn.stdpath("data") .. "/autorunner.json"
}

local state = {
    output = { buf = -1, win = -1, },
    input = { buf = -1, win = -1, },
}

local function create_floating_window(opts)
    opts = opts or {}

    local ui = vim.api.nvim_list_uis()[1]
    local width = opts.width or math.floor(ui.width * 0.3)
    local height = opts.height or math.floor(ui.height * 0.3)
    local col = opts.col or math.floor((ui.width - width) / 2)
    local row = opts.row or math.floor((ui.height - height) / 2)

    local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = opts.title or "",
        title_pos = "center",
    })
    vim.api.nvim_set_option_value("winhl", "FloatTitle:Normal", { win = win })
    return { buf = buf, win = win }
end

local function get_cache_content()
    local file = io.open(config.cache_file, "r")
    if not file then return {} end

    local content = file:read("*a")
    file:close()

    local ok, decoded = pcall(vim.json.decode, content)
    if not ok then return {} end

    return decoded
end

local function save_data()
    local cache = get_cache_content()
    local cwd = vim.fn.getcwd()

    local lines = vim.api.nvim_buf_get_lines(state.input.buf, 0, -1, false)
    if not lines[1] then return end
    cache[cwd] = string.sub(lines[1], 3)

    local json = vim.json.encode(cache)
    local file = io.open(config.cache_file, "w")
    if not file then return end

    file:write(json)
    file:close()
end

local function load_data()
    local cache = get_cache_content()
    local cwd = vim.fn.getcwd()
    if cache[cwd] == nil then return end
    vim.api.nvim_buf_set_lines(state.input.buf, 0, -1, false, { "" })
    vim.api.nvim_feedkeys(cache[cwd], "n", false)
end

local function stop_terminal()
    local chan = vim.b[state.output.buf].terminal_job_id
    vim.api.nvim_buf_call(state.output.buf, function()
        vim.cmd("normal! G")
        vim.api.nvim_chan_send(chan, "\x03")
    end)
end

local function clear_terminal()
    local chan = vim.b[state.output.buf].terminal_job_id
    vim.api.nvim_chan_send(chan, "\x0c")
end

local function send_command()
    local command = string.sub(vim.api.nvim_buf_get_lines(state.input.buf, 0, 1, false)[1], 3)
    local chan = vim.b[state.output.buf].terminal_job_id

    stop_terminal()
    vim.defer_fn(function()
        clear_terminal()
        vim.api.nvim_chan_send(chan, " " .. command .. "\n")
    end, 100)
end

local function open_windows()
    local ui = vim.api.nvim_list_uis()[1]
    state.output.title = config.output_title
    state.input.title = config.input_title

    state.output.width = math.floor(ui.width * config.output_width)
    state.input.width = state.output.width

    state.output.height = math.floor(ui.height * config.output_height)
    state.input.height = 1

    state.output.row = math.floor((ui.height - state.output.height) / 2 - state.input.height - 2)
    state.input.row = math.floor((ui.height + state.output.height) / 2 - 1)

    state.output = create_floating_window(state.output)
    state.input = create_floating_window(state.input)

    vim.api.nvim_set_option_value("modified", true, { buf = state.output.buf })
    vim.api.nvim_set_option_value("modified", true, { buf = state.input.buf })

    vim.keymap.set({ "i", "n" }, "<CR>", send_command, { buffer = state.input.buf, silent = true })
    vim.keymap.set({ "i", "n" }, "<C-c>", stop_terminal, { buffer = state.input.buf, silent = true })
    vim.keymap.set({ "i", "n" }, "<C-l>", clear_terminal, { buffer = state.input.buf, silent = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = vim.api.nvim_create_augroup("AutorunnerInput", { clear = true }),
        buffer = state.input.buf,
        callback = save_data,
    })

    if vim.bo[state.output.buf].buftype ~= "terminal" then
        vim.api.nvim_buf_call(state.output.buf, function()
            vim.cmd("terminal")
        end)
    end

    vim.api.nvim_set_option_value("buftype", "prompt", { buf = state.input.buf })
    vim.fn.prompt_setprompt(state.input.buf, "> ")
    vim.cmd("startinsert")
    load_data()
end

local function hide_windows()
    local is_open = false
    if vim.api.nvim_win_is_valid(state.output.win) then
        vim.api.nvim_set_option_value("modified", false, { buf = state.input.buf })
        vim.api.nvim_win_hide(state.output.win)
        is_open = true
    end
    if vim.api.nvim_win_is_valid(state.input.win) then
        vim.api.nvim_set_option_value("modified", false, { buf = state.output.buf })
        vim.api.nvim_win_hide(state.input.win)
        is_open = true
    end
    return is_open
end

local function toggle_autorunner()
    if not hide_windows() then open_windows() end
end

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function(args)
        if args.buf == state.input.buf then hide_windows() end
    end
})

vim.api.nvim_create_user_command("Autorunner", toggle_autorunner, {})
vim.keymap.set("n", "<Esc>", hide_windows, { buffer = state.input.buf, silent = true })
vim.keymap.set("n", "<leader>pt", toggle_autorunner)
