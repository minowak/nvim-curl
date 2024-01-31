local M = {}

local replace_env = function(env_file, line, env)
  if env == "" then
    return line
  end
  local envs = vim.split(env, ",")
end

function M.parse_current_buffer()
  local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  if #content == 0 then
    return
  end
  local host = ""
  local headers = {}
  local last_tag = ""
  local method = "GET"
  local env = ""
  for _, line in pairs(content) do
    -- trim line
    line = string.gsub(line, "^%s*(.-)%s*$", "%1")
    local first_char = string.sub(line, 1, 1)
    -- skip comments
    if first_char ~= "#" and line ~= "" then
      -- check if line starts with '['
      if first_char == "[" then
        last_tag = line
      else
        if last_tag == "[headers]" then
          -- replace "=" with ": "
          line = string.gsub(line, "=", ": ")
          -- remove quotes
          line = string.gsub(line, '"', "")
          table.insert(headers, line)
        end
        if last_tag == "[host]" then
          host = line
        end
        if last_tag == "[method]" then
          method = line
        end
        if last_tag == "[env]" then
          env = line
        end
      end
    end
  end
  return {
    hostname = host,
    method = method,
    headers = headers,
    env = env
  }
end

return M
