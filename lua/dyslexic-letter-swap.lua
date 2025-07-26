local M = {}

function M.setup()
  vim.keymap.set("n", "z,", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col < 2 then
      vim.notify("Not enough characters to swap", vim.log.levels.WARN)
      return
    end

    local line = vim.api.nvim_get_current_line()
    local i1 = col       -- 0-based
    local i2 = col - 1   -- 0-based

    local c1 = line:sub(i2 + 1, i2 + 1)
    local c2 = line:sub(i1 + 1, i1 + 1)

    local new_line = line:sub(1, i2) .. c2 .. c1 .. line:sub(i1 + 2)

    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, col })
    vim.notify("Swapped '" .. c1 .. "' and '" .. c2 .. "'", vim.log.levels.INFO)
  end, { desc = "Swap letters to the left of the cursor" })
end

return M
