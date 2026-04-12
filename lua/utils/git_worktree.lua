local M = {}

local TITLE = "Git Worktree"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = TITLE })
end

local function run_git(args, opts)
  opts = opts or {}

  local cmd = { "git" }
  vim.list_extend(cmd, args)

  local result = vim.system(cmd, {
    cwd = opts.cwd,
    text = true,
  }):wait()

  if result.code ~= 0 then
    local stderr = result.stderr or ""
    local stdout = result.stdout or ""
    local message = vim.trim(stderr ~= "" and stderr or stdout)
    if message == "" then
      message = "Git command failed"
    end
    return nil, message
  end

  return result.stdout or ""
end

local function git_succeeds(args, cwd)
  local cmd = { "git" }
  vim.list_extend(cmd, args)

  local result = vim.system(cmd, {
    cwd = cwd,
    text = true,
  }):wait()

  return result.code == 0
end

local function normalize_path(path)
  if not path or path == "" then
    return path
  end

  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function resolve_worktree_path(repo_root, raw_path)
  local expanded = vim.fn.expand(raw_path)
  if expanded:sub(1, 1) == "/" or expanded:match("^%a:[/\\]") then
    return normalize_path(expanded)
  end

  return vim.fs.normalize(vim.fs.joinpath(repo_root, expanded))
end

local function get_context_dir()
  local current = vim.api.nvim_buf_get_name(0)
  if current ~= "" then
    local stat = vim.uv.fs_stat(current)
    if stat then
      if stat.type == "directory" then
        return normalize_path(current)
      end
      return normalize_path(vim.fn.fnamemodify(current, ":p:h"))
    end
  end

  return normalize_path(vim.fn.getcwd())
end

local function get_repo_root(start_dir)
  local output, err = run_git({ "rev-parse", "--show-toplevel" }, { cwd = start_dir })
  if not output then
    return nil, err
  end

  return normalize_path(vim.trim(output))
end

local function parse_worktrees(output, current_root)
  local worktrees = {}
  local current = {}

  local function finish_entry()
    if not current.path then
      current = {}
      return
    end

    current.path = normalize_path(current.path)
    current.branch_name = current.branch and current.branch:gsub("^refs/heads/", "") or nil
    current.is_current = current.path == current_root

    local head = (current.head or ""):sub(1, 7)
    local label
    if current.branch_name then
      label = current.branch_name
    elseif current.detached then
      label = "detached@" .. head
    elseif current.bare then
      label = "bare"
    else
      label = head ~= "" and head or "unknown"
    end

    local flags = {}
    if current.is_current then
      table.insert(flags, "current")
    end
    if current.locked then
      table.insert(flags, "locked")
    end
    if current.prunable then
      table.insert(flags, "prunable")
    end

    local suffix = #flags > 0 and (" [" .. table.concat(flags, ", ") .. "]") or ""
    current.display = string.format("%s%s - %s", label, suffix, current.path)

    table.insert(worktrees, current)
    current = {}
  end

  for line in (output .. "\n"):gmatch("([^\n]*)\n") do
    if line == "" then
      finish_entry()
    else
      local key, value = line:match("^(%S+)%s?(.*)$")
      if key == "worktree" then
        current.path = value
      elseif key == "HEAD" then
        current.head = value
      elseif key == "branch" then
        current.branch = value
      elseif key == "bare" then
        current.bare = true
      elseif key == "detached" then
        current.detached = true
      elseif key == "locked" then
        current.locked = value ~= "" and value or true
      elseif key == "prunable" then
        current.prunable = value ~= "" and value or true
      end
    end
  end

  table.sort(worktrees, function(left, right)
    if left.is_current ~= right.is_current then
      return left.is_current
    end
    return left.path < right.path
  end)

  return worktrees
end

local function get_modified_buffers()
  local modified = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_get_option_value("buflisted", { buf = buf })
      and vim.api.nvim_get_option_value("modified", { buf = buf }) then
      local name = vim.api.nvim_buf_get_name(buf)
      table.insert(modified, name ~= "" and name or "[No Name]")
    end
  end

  return modified
end

local function path_belongs_to_root(path, root)
  if not path or path == "" or not root or root == "" then
    return false
  end

  if path == root then
    return true
  end

  return path:sub(1, #root + 1) == root .. "/"
end

local function buffers_for_root(root)
  local buffers = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local raw_name = vim.api.nvim_buf_get_name(buf)
      if raw_name:match("^%a+://") then
        goto continue
      end

      local name = normalize_path(raw_name)
      if path_belongs_to_root(name, root) then
        table.insert(buffers, buf)
      end
    end

    ::continue::
  end

  return buffers
end

local function clear_current_workspace(current_root)
  local current_tab = vim.api.nvim_get_current_tabpage()
  local target_buffers = buffers_for_root(current_root)
  local scratch = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = scratch })

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
    if vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_set_buf, win, scratch)
    end
  end

  pcall(vim.cmd, "silent! only")

  for _, buf in ipairs(target_buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

local function open_worktree_picker(path)
  local ok, snacks = pcall(require, "snacks")
  if not ok or not snacks.picker then
    notify("Snacks picker is unavailable", vim.log.levels.ERROR)
    return
  end

  snacks.picker.files({ cwd = path })
end

local function switch_to_worktree(entry, current_root)
  local target_path = normalize_path(entry.path)

  if target_path == current_root then
    vim.cmd("tcd " .. vim.fn.fnameescape(target_path))
    open_worktree_picker(target_path)
    return
  end

  local modified_buffers = get_modified_buffers()
  if #modified_buffers > 0 then
    local first = vim.fn.fnamemodify(modified_buffers[1], ":~:.")
    notify(
      string.format(
        "Save or discard %d modified buffer(s) before switching worktrees. First: %s",
        #modified_buffers,
        first
      ),
      vim.log.levels.WARN
    )
    return
  end

  clear_current_workspace(current_root)
  vim.cmd("tcd " .. vim.fn.fnameescape(target_path))

  vim.schedule(function()
    open_worktree_picker(target_path)
  end)

  notify("Switched to " .. target_path)
end

local function default_worktree_path(repo_root, branch)
  local repo_name = vim.fn.fnamemodify(repo_root, ":t")
  local parent_dir = vim.fn.fnamemodify(repo_root, ":h")
  local safe_branch = branch:gsub("[/\\]+", "-"):gsub("%s+", "-")

  if safe_branch == "" then
    safe_branch = "new"
  end

  return vim.fs.joinpath(parent_dir, repo_name .. "-" .. safe_branch)
end

function M.switch_worktree()
  local start_dir = get_context_dir()
  local repo_root, err = get_repo_root(start_dir)
  if not repo_root then
    notify("Not inside a git repository: " .. err, vim.log.levels.WARN)
    return
  end

  local output, list_err = run_git({ "worktree", "list", "--porcelain" }, { cwd = repo_root })
  if not output then
    notify("Failed to list worktrees: " .. list_err, vim.log.levels.ERROR)
    return
  end

  local worktrees = parse_worktrees(output, repo_root)
  if #worktrees == 0 then
    notify("No worktrees found for this repository", vim.log.levels.WARN)
    return
  end

  vim.ui.select(worktrees, {
    prompt = "Select worktree:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end

    switch_to_worktree(choice, repo_root)
  end)
end

function M.create_worktree()
  local start_dir = get_context_dir()
  local repo_root, err = get_repo_root(start_dir)
  if not repo_root then
    notify("Not inside a git repository: " .. err, vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = "Worktree branch: " }, function(branch)
    branch = branch and vim.trim(branch) or branch
    if not branch or branch == "" then
      return
    end

    local suggested_path = default_worktree_path(repo_root, branch)
    vim.ui.input({
      prompt = "Worktree path: ",
      default = suggested_path,
    }, function(path)
      path = path and vim.trim(path) or path
      if not path or path == "" then
        return
      end

      vim.ui.input({
        prompt = "Start point: ",
        default = "HEAD",
      }, function(start_point)
        if start_point == nil then
          return
        end

        start_point = vim.trim(start_point)

        local target_path = resolve_worktree_path(repo_root, path)
        local branch_exists = git_succeeds(
          { "show-ref", "--verify", "--quiet", "refs/heads/" .. branch },
          repo_root
        )

        local args = { "worktree", "add" }
        if branch_exists then
          table.insert(args, target_path)
          table.insert(args, branch)
        else
          table.insert(args, "-b")
          table.insert(args, branch)
          table.insert(args, target_path)
          table.insert(args, start_point ~= "" and start_point or "HEAD")
        end

        local _, add_err = run_git(args, { cwd = repo_root })
        if add_err then
          notify("Failed to create worktree: " .. add_err, vim.log.levels.ERROR)
          return
        end

        if branch_exists and start_point ~= "" and start_point ~= "HEAD" then
          notify("Created worktree: " .. target_path .. " (existing branch; start point ignored)")
          return
        end

        notify("Created worktree: " .. target_path)
      end)
    end)
  end)
end

function M.setup()
  if vim.g.git_worktree_setup then
    return
  end

  vim.g.git_worktree_setup = true

  local map = vim.keymap.set

  vim.api.nvim_create_user_command("GitWorktreeSwitch", function()
    require("utils.git_worktree").switch_worktree()
  end, { desc = "Switch git worktree" })

  vim.api.nvim_create_user_command("GitWorktreeCreate", function()
    require("utils.git_worktree").create_worktree()
  end, { desc = "Create git worktree" })

  map("n", "<leader>gwl", function()
    require("utils.git_worktree").switch_worktree()
  end, { desc = "List worktrees" })

  map("n", "<leader>gwc", function()
    require("utils.git_worktree").create_worktree()
  end, { desc = "Create worktree" })
end

return M
