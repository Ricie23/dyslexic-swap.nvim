-- ~/.config/nvim/lua/dyslexic_swap/init.lua
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
  -- Normal mode mapping: z,
  vim.keymap.set("n", "z,", swap_letters, { desc = "Swap letters to the left" })

  -- Insert mode mapping: <C-x>
  vim.keymap.set("i", "<C-x>", function()
    -- Save current mode position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- Leave insert mode and defer swap to next tick
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

    vim.defer_fn(function()
      swap_letters()
      -- Return to insert mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("a", true, false, true), "n", false)
    end, 10) -- 10ms delay is usually enough
  end, { desc = "Swap letters to the left in insert mode" })
end

return M
