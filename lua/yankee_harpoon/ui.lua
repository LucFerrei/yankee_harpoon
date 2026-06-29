local M = {}

local buf = nil
local win = nil

local function close_menu()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  win = nil
  buf = nil
end

local function get_menu_dimensions()
  local config = require("yankee_harpoon.config").options
  local list = require("yankee_harpoon.list")
  local height = math.min(list.size(), config.menu_height)
  height = math.max(height, 1)

  local editor_width = vim.o.columns
  local editor_height = vim.o.lines

  local row = math.floor((editor_height - height) / 2)
  local col = math.floor((editor_width - config.menu_width) / 2)

  return {
    width = config.menu_width,
    height = height,
    row = row,
    col = col,
  }
end

local function render()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local list = require("yankee_harpoon.list")
  local utils = require("yankee_harpoon.utils")
  local items = list.get_all()
  local config = require("yankee_harpoon.config").options

  local lines = {}
  for i, item in ipairs(items) do
    local preview = utils.truncate(item.text:gsub("\n", "\\n"), config.menu_width - 4)
    table.insert(lines, string.format("%d. %s", i, preview))
  end

  if #lines == 0 then
    table.insert(lines, "(empty)")
  end

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

local function select_item(index)
  local list = require("yankee_harpoon.list")
  local utils = require("yankee_harpoon.utils")
  local item = list.get(index)

  if not item then
    return
  end

  close_menu()

  local _, regtype = utils.get_register_content(require("yankee_harpoon.config").options.register)
  utils.paste(item.text, regtype or "v")
end

local function delete_item(index)
  local list = require("yankee_harpoon.list")
  list.remove(index)
  render()
end

local function setup_buffer_keymaps()
  local config = require("yankee_harpoon.config").options
  local km = config.menu_keymaps

  local opts = { buffer = buf, silent = true, nowait = true }

  for _, key in ipairs(km.close) do
    vim.keymap.set("n", key, function()
      close_menu()
    end, opts)
  end

  vim.keymap.set("n", km.select, function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    select_item(cursor[1])
  end, opts)

  vim.keymap.set("n", km.delete, function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    delete_item(cursor[1])
  end, opts)

  vim.keymap.set("n", km.next, function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local last_line = vim.api.nvim_buf_line_count(buf)
    if cursor[1] < last_line then
      vim.api.nvim_win_set_cursor(win, { cursor[1] + 1, cursor[2] })
    end
  end, opts)

  vim.keymap.set("n", km.prev, function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    if cursor[1] > 1 then
      vim.api.nvim_win_set_cursor(win, { cursor[1] - 1, cursor[2] })
    end
  end, opts)

  -- Direct number access
  for i = 1, config.max_items do
    vim.keymap.set("n", tostring(i), function()
      select_item(i)
    end, opts)
  end
end

function M.toggle_menu()
  if win and vim.api.nvim_win_is_valid(win) then
    close_menu()
    return
  end

  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "yankee-harpoon")

  local dims = get_menu_dimensions()

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = dims.width,
    height = dims.height,
    row = dims.row,
    col = dims.col,
    style = "minimal",
    border = "rounded",
    title = " Yankee Harpoon ",
    title_pos = "center",
  })

  vim.api.nvim_win_set_option(win, "cursorline", true)
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)

  setup_buffer_keymaps()
  render()
end

function M.close()
  close_menu()
end

return M
