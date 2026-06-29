local M = {}

local config = require("yankee_harpoon.config")
local list = require("yankee_harpoon.list")
local ui = require("yankee_harpoon.ui")
local utils = require("yankee_harpoon.utils")
local commands = require("yankee_harpoon.commands")

function M.setup(opts)
  config.setup(opts)
  commands.create()
  M._apply_mappings()
end

function M.add()
  local text, _ = utils.get_register_content(config.options.register)
  if not text then
    vim.notify("Yankee Harpoon: no yank to add", vim.log.levels.WARN)
    return
  end

  local added = list.add(text)
  if added then
    vim.notify("Yankee Harpoon: yank added", vim.log.levels.INFO)
  else
    vim.notify("Yankee Harpoon: yank already exists", vim.log.levels.INFO)
  end
end

function M.toggle_menu()
  ui.toggle_menu()
end

function M.paste(index)
  local item = list.get(index)
  if not item then
    vim.notify("Yankee Harpoon: no item at index " .. index, vim.log.levels.WARN)
    return
  end

  local _, regtype = utils.get_register_content(config.options.register)
  utils.paste(item.text, regtype or "v")
end

function M.remove(index)
  list.remove(index)
end

function M.clear()
  list.clear()
  vim.notify("Yankee Harpoon: list cleared", vim.log.levels.INFO)
end

function M._apply_mappings()
  local opts = config.options

  if opts.save_mapping and opts.save_mapping ~= "" then
    vim.keymap.set("n", opts.save_mapping, function()
      M.add()
    end, { silent = true, desc = "Yankee Harpoon: add yank" })
  end

  if opts.toggle_mapping and opts.toggle_mapping ~= "" then
    vim.keymap.set("n", opts.toggle_mapping, function()
      M.toggle_menu()
    end, { silent = true, desc = "Yankee Harpoon: toggle menu" })
  end

  if opts.paste_mappings then
    for i, mapping in ipairs(opts.paste_mappings) do
      if mapping and mapping ~= "" then
        vim.keymap.set("n", mapping, function()
          M.paste(i)
        end, { silent = true, desc = "Yankee Harpoon: paste item " .. i })
      end
    end
  end
end

return M
