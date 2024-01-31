local parser = require "nvim-curl.parser"

local M = {}

local defaults = {
  collections_dir = os.getenv("HOME") .. "/nvim-curl",
}

function M.setup(opts)
  opts = opts or {}
  for k, v in pairs(opts) do
    defaults[k] = v
  end

  -- create collections directory if it doesn't exist
  vim.fn.mkdir(defaults.collections_dir, "p")
  -- create file "environments" if it doesn't exist
  local f = io.open(defaults.collections_dir .. "/environments.toml", "w")
  if (f) then
    f.close(f)
  else
    vim.fn.touch(defaults.collections_dir .. "/environments.toml")
  end
end

function M.open_collections()
  vim.cmd("edit " .. defaults.collections_dir)
end

function M.execute()
  local content = parser.parse_current_buffer()
  if not content then
    return
  end
  local headers = ""
  if content.headers then
    for _, header in pairs(content.headers) do
      headers = headers .. " -H '" .. header .. "'"
    end
  end
  local command = "curl -X" .. content.method .. " " .. headers .. " " .. content.hostname .. " 2> /dev/null"
  local handle = io.popen(command)
  if handle == nil then
    return
  end
  local result = handle:read("*a")
  handle:close()

  if vim.fn.bufloaded("Response") == 0 then
    vim.cmd('vsplit')
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, "Response")
  else
    -- switch window to response
    local win = vim.fn.bufwinid("Response")
    vim.api.nvim_set_current_win(win)
  end

  local buf = vim.fn.bufadd("Response")
  local win = vim.api.nvim_get_current_win()
  vim.fn.bufload(buf)

  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, vim.split(result, "\n"))
  vim.api.nvim_buf_set_option(buf, 'filetype', 'json')
  -- go to the first line in a buffer
  vim.cmd("normal gg")
end

return M
