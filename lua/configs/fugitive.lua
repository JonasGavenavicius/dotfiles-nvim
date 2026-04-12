local function run_git(args)
  local output = vim.fn.systemlist(vim.list_extend({ "git" }, args))
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return output
end

local function get_default_remote_branch()
  local ref = run_git({ "symbolic-ref", "--quiet", "refs/remotes/origin/HEAD" })
  if ref and ref[1] and ref[1] ~= "" then
    return ref[1]:gsub("^refs/remotes/", "")
  end

  for _, branch in ipairs({ "origin/main", "origin/master" }) do
    if run_git({ "rev-parse", "--verify", branch }) then
      return branch
    end
  end

  return nil
end

local function tab_git(args)
  vim.cmd("tab Git " .. args)
end

local function open_repo_diff()
  tab_git("--paginate diff")
end

local function open_staged_diff()
  tab_git("--paginate diff --cached")
end

local function open_branch_diff()
  local branch = get_default_remote_branch()
  if not branch then
    vim.notify("Could not detect the default remote branch for Fugitive", vim.log.levels.WARN)
    return
  end

  tab_git("--paginate diff " .. branch .. "...HEAD")
end

local function open_repo_history()
  tab_git("--paginate log --stat --decorate")
end

local function open_file_history()
  if vim.api.nvim_buf_get_name(0) == "" then
    vim.notify("Current buffer has no file path for Fugitive history", vim.log.levels.WARN)
    return
  end

  tab_git("--paginate log --follow -- %")
end

local function close_fugitive_view()
  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype
  local is_fugitive = name:match("^fugitive://") ~= nil or ft == "fugitive" or ft == "git"

  if not is_fugitive then
    vim.notify("Current buffer is not a Fugitive view", vim.log.levels.WARN)
    return
  end

  vim.cmd("tabclose")
end

return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gclog" },
  keys = {
    { "<leader>gvd", open_repo_diff, desc = "Fugitive Diff" },
    { "<leader>gvD", open_staged_diff, desc = "Fugitive Staged Diff" },
    { "<leader>gvm", open_branch_diff, desc = "Fugitive Branch Diff" },
    { "<leader>gvq", close_fugitive_view, desc = "Close Fugitive View" },
    { "<leader>gvh", open_repo_history, desc = "Fugitive Repo History" },
    { "<leader>gvH", open_file_history, desc = "Fugitive Current File History" },
  },
}
