local M = {}

local function swap_letters()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if col < 2 then
		vim.notify("Not enough characters to swap", vim.log.levels.WARN)
		return
	end

	local line = vim.api.nvim_get_current_line()
	local before = line:sub(1, col)
	local after = line:sub(col + 1)

	local c1 = before:sub(-2, -2)
	local c2 = before:sub(-1, -1)
	local new_before = before:sub(1, -3) .. c2 .. c1

	vim.api.nvim_set_current_line(new_before .. after)
	vim.api.nvim_win_set_cursor(0, { row, col })
	vim.notify("Swapped '" .. c1 .. "' and '" .. c2 .. "'", vim.log.levels.INFO)
end

function M.setup()
	vim.keymap.set("n", "z,", swap_letters, { desc = "Swap letters to the left" })
end
return M
