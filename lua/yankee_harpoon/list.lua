local M = {}

local items = {}

function M.add(text)
  if not text or text == "" then
    return false
  end

  for _, item in ipairs(items) do
    if item.text == text then
      return false
    end
  end

  table.insert(items, 1, { text = text })

  local config = require("yankee_harpoon.config").options
  while #items > config.max_items do
    table.remove(items)
  end

  return true
end

function M.remove(index)
  if index < 1 or index > #items then
    return false
  end
  table.remove(items, index)
  return true
end

function M.get(index)
  return items[index]
end

function M.get_all()
  return vim.deepcopy(items)
end

function M.clear()
  items = {}
end

function M.size()
  return #items
end

return M
