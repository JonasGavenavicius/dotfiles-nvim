local M = {}

local did_setup = false

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  ts = "typescript",
  uxn = "uxntal",
}

local function error_writeln(message)
  vim.api.nvim_err_writeln(message)
end

local function valid_args(name, pred, count, strict_count)
  local arg_count = #pred - 1

  if strict_count then
    if arg_count ~= count then
      error_writeln(string.format("%s must have exactly %d arguments", name, count))
      return false
    end
  elseif arg_count < count then
    error_writeln(string.format("%s must have at least %d arguments", name, count))
    return false
  end

  return true
end

local function capture_node(match, capture_id)
  local capture = match[capture_id]
  if type(capture) == "table" then
    return capture[#capture] or capture[1]
  end
  return capture
end

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match({ filename = "a." .. injection_alias })
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

function M.setup()
  if did_setup or vim.fn.has("nvim-0.12") == 0 then
    return
  end

  local ok = pcall(require, "nvim-treesitter.query_predicates")
  if not ok then
    return
  end

  did_setup = true

  local query = require("vim.treesitter.query")
  local opts = { force = true }

  query.add_predicate("nth?", function(match, _, _, pred)
    if not valid_args("nth?", pred, 2, true) then
      return
    end

    local node = capture_node(match, pred[2])
    local n = tonumber(pred[3])
    if node and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end

    return false
  end, opts)

  query.add_predicate("is?", function(match, _, bufnr, pred)
    if not valid_args("is?", pred, 2) then
      return
    end

    local node = capture_node(match, pred[2])
    if not node then
      return true
    end

    local locals = require("nvim-treesitter.locals")
    local _, _, kind = locals.find_definition(node, bufnr)
    return vim.tbl_contains({ table.unpack(pred, 3) }, kind)
  end, opts)

  query.add_predicate("kind-eq?", function(match, _, _, pred)
    if not valid_args(pred[1], pred, 2) then
      return
    end

    local node = capture_node(match, pred[2])
    if not node then
      return true
    end

    return vim.tbl_contains({ table.unpack(pred, 3) }, node:type())
  end, opts)

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = capture_node(match, pred[2])
    if not node then
      return
    end

    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = capture_node(match, pred[2])
    if not node then
      return
    end

    local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = capture_node(match, id)
    if not node then
      return
    end

    metadata[id] = metadata[id] or {}
    metadata[id].text = string.lower(vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or "")
  end, opts)
end

return M
