local M = {}

-- Swap two characters at a given position in the line
local function swap_chars(line, left_idx)
    if left_idx < 1 or left_idx >= #line then
        return nil
    end

    local before = line:sub(1, left_idx - 1)
    local c1 = line:sub(left_idx, left_idx)
    local c2 = line:sub(left_idx + 1, left_idx + 1)
    local after = line:sub(left_idx + 2)

    return before .. c2 .. c1 .. after
end

function M.swap_letters(mode)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()

    -- Abort early if not enough characters to the left
    if col < 2 then
        return
    end

    local left_idx = col - 1 -- character index to the *left* of the cursor
    local new_line = swap_chars(line, left_idx)

    if new_line then
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, { row, col })
    end
end

function M.setup()
    -- Normal mode: swap two letters to the left of the cursor
    vim.keymap.set("n", "z,", function()
        M.swap_letters("normal")
    end, { desc = "Swap letters to the left of the cursor" })

    -- Insert mode: swap the two letters before the cursor
    vim.keymap.set("i", "<C-x>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

        vim.schedule(function()
            M.swap_letters("insert")
            vim.api.nvim_feedkeys("a", "n", false)
        end)
    end, { desc = "Swap last two typed letters" })
end

return M
