-- Terminal utilities for running programs
local M = {}

-- Default run commands for different file types
M.run_commands = {
  go = function(file) return "go run " .. vim.fn.shellescape(file) end,
  rust = function(_) return "cargo run" end,
  ruby = function(file) return "bundle exec ruby " .. vim.fn.shellescape(file) end,
  python = function(file) return "python " .. vim.fn.shellescape(file) end,
  javascript = function(file) return "node " .. vim.fn.shellescape(file) end,
  typescript = function(file) return "tsx " .. vim.fn.shellescape(file) end,
  lua = function(file) return "lua " .. vim.fn.shellescape(file) end,
}

-- Terminal instance for running programs
local run_terminal = nil

-- Create or reuse terminal for running programs
M.get_run_terminal = function()
  if run_terminal == nil then
    local ok, Terminal = pcall(require, "toggleterm.terminal")
    if not ok then
      vim.notify("Failed to load toggleterm", vim.log.levels.ERROR)
      return nil
    end
    
    run_terminal = Terminal.Terminal:new({
      direction = "float",
      close_on_exit = false,
      on_exit = function() run_terminal = nil end,
    })
  end
  return run_terminal
end

-- Run current file with default command
M.run_current_file = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end
  
  local ft = vim.bo.filetype
  local command_fn = M.run_commands[ft]
  if not command_fn then
    vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  local cmd = command_fn(file)
  -- Add pause after execution
  cmd = cmd .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]

  local terminal = M.get_run_terminal()
  if terminal then
    terminal.cmd = cmd
    terminal:toggle()
  end
end

-- Run program with custom arguments
M.run_with_arguments = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end
  
  local ft = vim.bo.filetype
  local command_fn = M.run_commands[ft]
  if not command_fn then
    vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
    return
  end
  
  local default_cmd = command_fn(file)
  
  vim.ui.input({
    prompt = "Run command: ",
    default = default_cmd .. " ",
  }, function(command)
    if command and command ~= "" then
      local terminal = M.get_run_terminal()
      if terminal then
        -- Add pause after execution
        terminal.cmd = command .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]
        terminal:toggle()
      end
    end
  end)
end

return M