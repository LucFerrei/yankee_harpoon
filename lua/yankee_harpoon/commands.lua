local M = {}

function M.create()
  vim.api.nvim_create_user_command("YHAdd", function()
    require("yankee_harpoon").add()
  end, { desc = "Add last yank to Yankee Harpoon" })

  vim.api.nvim_create_user_command("YHMenu", function()
    require("yankee_harpoon").toggle_menu()
  end, { desc = "Toggle Yankee Harpoon menu" })

  vim.api.nvim_create_user_command("YHClear", function()
    require("yankee_harpoon").clear()
  end, { desc = "Clear Yankee Harpoon list" })
end

return M
