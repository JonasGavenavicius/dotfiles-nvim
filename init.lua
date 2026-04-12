require "options"
require "autocmds"

local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")

local function echo_error(message)
  vim.api.nvim_echo({ { message, "ErrorMsg" } }, true, { err = true })
end

local function bootstrap_lazy()
  if vim.uv.fs_stat(lazypath) then
    return true
  end

  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    echo_error("Failed to bootstrap lazy.nvim:\n" .. output)
    return false
  end

  return true
end

if not bootstrap_lazy() then
  return
end

vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  echo_error("Failed to load lazy.nvim: " .. lazy)
  return
end

lazy.setup(require("plugins"))

local theme_picker = require("configs.theme-picker")
theme_picker.load_startup_theme()
theme_picker.register_ui()
require("utils.ui").setup()

vim.api.nvim_create_user_command("NvimBootstrap", function()
  require("utils.bootstrap").run()
end, { desc = "Install configured Neovim tools and parsers" })

require("configs.languages.go.test").setup_keymaps()
require("configs.languages.ruby.test").setup_keymaps()
require("utils.git_worktree").setup()

vim.schedule(function()
  require "mappings"
end)
