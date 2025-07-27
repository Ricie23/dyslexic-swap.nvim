local M = {}

local function swap_two_chars(line, a, b)
    if a < 1 or b < 1 or a > #line or b > #line then return nil end
    local chars = vim.split(line, "")
    chars[a], chars[b] = chars[b], chars[a]
    return table.concat(chars)
end

function M.swap_letters_at(col)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()

    if col < 2 then return end

    local new_line = swap_two_chars(line, col, col - 1)
    if not new_line then return end

    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, col })
end

-- Default key mappings (users can override)
local default_opts = {
    normal_mode = "z,",
    insert_mode = "<C-x>",
}

function M.setup(opts)
    opts = vim.tbl_extend("force", default_opts, opts or {})

    -- Clear existing mappings to avoid duplicates (optional)
    vim.keymap.del("n", opts.normal_mode)
    vim.keymap.del("i", opts.insert_mode)

    -- Normal mode mapping
    vim.keymap.set("n", opts.normal_mode, function()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        M.swap_letters_at(col)
    end, { desc = "Swap letters to the left of the cursor" })

    -- Insert mode mapping
    vim.keymap.set("i", opts.insert_mode, function()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.schedule(function()
            M.swap_letters_at(col)
            vim.api.nvim_feedkeys("i", "n", false)
        end)
    end, { desc = "Swap last two typed letters" })
end

return M
