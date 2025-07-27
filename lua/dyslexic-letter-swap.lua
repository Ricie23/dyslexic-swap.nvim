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
	opts = opts or {}
	local normal_key = opts.normal_mode ~= false and (opts.normal_mode or "z,")
	local insert_key = opts.insert_mode ~= false and (opts.insert_mode or "<C-x>")

	if normal_key then
		vim.keymap.set("n", normal_key, function()
			local _, col = unpack(vim.api.nvim_win_get_cursor(0))
			M.swap_letters_at(col)
		end, { desc = "Swap letters to the left of the cursor" })
	end

	if insert_key then
		vim.keymap.set("i", insert_key, function()
			local _, col = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
			vim.schedule(function()
				M.swap_letters_at(col)
				vim.api.nvim_feedkeys("i", "n", false)
			end)
		end, { desc = "Swap last two typed letters" })
	end
end

return M
