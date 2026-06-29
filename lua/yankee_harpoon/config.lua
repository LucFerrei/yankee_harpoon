local M = {}

M.defaults = {
  max_items = 5,
  menu_width = 60,
  menu_height = 10,
  register = "0",
  save_mapping = "<leader>ya",
  toggle_mapping = "<leader>yh",
  paste_mappings = {
    "<leader>y1",
    "<leader>y2",
    "<leader>y3",
    "<leader>y4",
    "<leader>y5",
  },
  menu_keymaps = {
    close = { "q", "<Esc>" },
    select = "<CR>",
    delete = "d",
    next = "j",
    prev = "k",
  },
}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
