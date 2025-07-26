-- ~/.config/nvim/lua/dyslexic_swap/init.lua
local M = {}

function M.swap_letters()
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
end

function M.setup()
	-- Normal mode mapping: z,
	vim.keymap.set("n", "z,", M.swap_letters, { desc = "Swap letters to the left" })

	-- Insert mode mapping: <C-x>
vim.keymap.set("i", "<C-t>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

	vim.schedule(function()
		require("dyslexic_swap").swap_letters()
		vim.api.nvim_feedkeys("a", "n", false)
	end)
end, { desc = "Swap letters to the left in insert mode" })
end
return M
