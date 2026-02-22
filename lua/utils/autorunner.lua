-- Estado global das janelas e buffers (input e output)
local state = {
    input = { buf = -1, win = -1 },
    output = { buf = -1, win = -1 },
}

-- Caminho global do cache (JSON)
local function get_cache_path()
    return vim.fn.stdpath("data") .. "/autorunner.json"
end

-- Chave do projeto atual (baseada na pasta de trabalho)
local function get_project_key()
    local cwd = vim.fn.getcwd():gsub("[/\\:]", "_")
    return cwd
end

-- Cria uma janela flutuante reutilizando buffer se ele já existir
local function create_floating_window(opts)
    opts = opts or {}
    local ui = vim.api.nvim_list_uis()[1]

    local width = opts.width or math.floor(ui.width * 0.3)
    local height = opts.height or math.floor(ui.height * 0.3)
    local col = opts.col or math.floor((ui.width - width) / 2)
    local row = opts.row or math.floor((ui.height - height) / 2)

    local buf = opts.buf
    if not vim.api.nvim_buf_is_valid(buf) then
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = opts.title or " ",
        title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)
    return { buf = buf, win = win }
end

-- Fecha automaticamente ambas as janelas se uma delas for fechada
local function auto_close_windows()
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = "*",
        callback = function(args)
            local closed = tonumber(args.match)
            if closed == state.input.win or closed == state.output.win then
                if vim.api.nvim_win_is_valid(state.input.win) then
                    vim.api.nvim_win_close(state.input.win, true)
                end
                if vim.api.nvim_win_is_valid(state.output.win) then
                    vim.api.nvim_win_close(state.output.win, true)
                end
            end
        end,
    })
end

-- Esconde as janelas se estiverem abertas
local function close_windows()
    local open = false
    if vim.api.nvim_win_is_valid(state.input.win) then
        vim.api.nvim_win_hide(state.input.win)
        open = true
    end
    if vim.api.nvim_win_is_valid(state.output.win) then
        vim.api.nvim_win_hide(state.output.win)
        open = true
    end
    return open
end

-- Cria a janela de saída (terminal)
local function create_output_window(width, screen_height)
    local height = math.floor(screen_height * 0.5)
    local row = math.floor((screen_height - height) / 2 - 1)

    state.output = create_floating_window({
        title = " Autorunner Output ",
        width = width,
        height = height,
        row = row,
        buf = state.output.buf,
    })

    vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

    if vim.bo[state.output.buf].buftype ~= "terminal" then
        vim.api.nvim_buf_call(state.output.buf, function()
            vim.cmd("terminal")
        end)
    end

    return height
end

-- Cria a janela de entrada
local function create_input_window(width, screen_height, output_height)
    local height = 1
    local row = math.floor((screen_height - output_height) / 2 + output_height + 1)

    state.input = create_floating_window({
        title = " Command Input ",
        width = width,
        height = height,
        row = row,
        buf = state.input.buf,
    })

    vim.bo[state.input.buf].buftype = "prompt"
    vim.bo[state.input.buf].bufhidden = "wipe"
    vim.bo[state.input.buf].swapfile = false

    vim.fn.prompt_setprompt(state.input.buf, "> ")

    local cache_path = get_cache_path()
    local project_key = get_project_key()

    -- 🔹 Ler último comando do projeto
    local last_command = ""
    local f_read = io.open(cache_path, "r")
    if f_read then
        local content = f_read:read("*all")
        f_read:close()
        if content ~= "" then
            local ok, data = pcall(vim.fn.json_decode, content)
            if ok and data and data[project_key] then
                last_command = data[project_key]
                local lines = vim.split(last_command, "\n")
                vim.api.nvim_buf_set_lines(state.input.buf, 0, -1, false, lines)
            end
        end
    end

    -- 🔹 Salvar automaticamente comando por projeto
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = state.input.buf,
        callback = function()
            local lines = vim.api.nvim_buf_get_lines(state.input.buf, 0, -1, false)
            local command = table.concat(lines, "\n")

            local data = {}
            local f_read = io.open(cache_path, "r")
            if f_read then
                local content = f_read:read("*all")
                f_read:close()
                if content ~= "" then
                    local ok, decoded = pcall(vim.fn.json_decode, content)
                    if ok and decoded then
                        data = decoded
                    end
                end
            end

            data[project_key] = command

            local f_save = io.open(cache_path, "w")
            if f_save then
                f_save:write(vim.fn.json_encode(data))
                f_save:close()
            end

            vim.bo[state.input.buf].modified = false
        end,
    })

    -- Envia comando para o terminal
    local function send_command()
        local lines = vim.api.nvim_buf_get_lines(state.input.buf, 0, -1, false)
        if #lines > 0 then
            lines[1] = lines[1]:gsub("^%s*>%s?", "")
        end
        local command = table.concat(lines, "\n")
        if command == "" then return end

        local job = vim.b[state.output.buf].terminal_job_id
        if job then
            vim.api.nvim_chan_send(job, "clear\n")
            vim.api.nvim_chan_send(job, command .. "\n")
        end
        vim.cmd("stopinsert")
    end

    local opts = { buffer = state.input.buf, silent = true }
    vim.keymap.set({ "i", "n" }, "<CR>", send_command, opts)
    vim.keymap.set("n", "<Esc>", close_windows, opts)

    vim.cmd("startinsert!")
    auto_close_windows()
end

-- Alterna o Autorunner
local function toggle_autorunner()
    if close_windows() then return end

    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor(ui.width * 0.4)
    local height = ui.height

    local output_height = create_output_window(width, height)
    create_input_window(width, height, output_height)
end

vim.api.nvim_create_user_command("Autorunner", toggle_autorunner, {})
vim.keymap.set({ "n", "t" }, "<leader>pt", toggle_autorunner)
