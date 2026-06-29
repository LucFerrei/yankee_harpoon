local M = {}

function M.get_register_content(register)
  local text = vim.fn.getreg(register)
  if not text or text == "" then
    return nil, nil
  end
  local regtype = vim.fn.getregtype(register)
  return text, regtype
end

function M.truncate(str, width)
  if #str <= width then
    return str
  end
  return str:sub(1, width - 3) .. "..."
end

function M.paste(text, regtype)
  if not text then
    return
  end

  local type_char = "c"
  if regtype:sub(1, 1) == "V" or regtype:sub(1, 1) == "\22" then
    type_char = "l"
  elseif regtype:sub(1, 1) == "v" then
    type_char = "c"
  else
    -- Fallback based on content
    if text:find("\n") then
      type_char = "l"
    end
  end

  local lines = vim.split(text, "\n", { plain = true })
  vim.api.nvim_put(lines, type_char, true, false)
end

return M
