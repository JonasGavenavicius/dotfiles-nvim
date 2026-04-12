local function run_git(args)
  local output = vim.fn.systemlist(vim.list_extend({ "git" }, args))
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return output
end

local function get_default_remote_branch()
  local ref = run_git { "symbolic-ref", "--quiet", "refs/remotes/origin/HEAD" }
  if ref and ref[1] and ref[1] ~= "" then
    return ref[1]:gsub("^refs/remotes/", "")
  end

  for _, branch in ipairs { "origin/main", "origin/master" } do
    if run_git { "rev-parse", "--verify", branch } then
      return branch
    end
  end

  return nil
end

local function open_default_branch_diff()
  local branch = get_default_remote_branch()
  if not branch then
    vim.notify("Could not detect the default remote branch for Diffview", vim.log.levels.WARN)
    return
  end

  vim.cmd("DiffviewOpen " .. branch .. "...HEAD")
end

return {
  -- Git diff viewer
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diffview" },
    { "<leader>gD", "<cmd>DiffviewOpen --staged<cr>", desc = "Git Staged Diffview" },
    { "<leader>gm", open_default_branch_diff, desc = "Git Branch Diff" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
  },
  config = function()
    local ok, diffview = pcall(require, "diffview")
    if not ok then
      vim.notify("Failed to load diffview", vim.log.levels.ERROR)
      return
    end

    diffview.setup {
      keymaps = {
        file_panel = {
          ["gf"] = function()
            local ok_lib, diffview_lib = pcall(require, "diffview.lib")
            if not ok_lib then
              return
            end

            local file = diffview_lib.get_current_view():get_file()
            if file then
              vim.cmd "DiffviewClose"
              vim.cmd("edit " .. vim.fn.fnameescape(file.path))
            end
          end,
        },
      },
    }
  end,
}
