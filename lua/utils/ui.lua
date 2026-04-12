local M = {}

local did_setup = false
local augroup_name = "balanced_clarity_ui"

local function normalize_hex(color)
  if type(color) ~= "string" then
    return nil
  end

  if color == "NONE" then
    return nil
  end

  if color:sub(1, 1) ~= "#" then
    return nil
  end

  if #color == 4 then
    return string.format(
      "#%s%s%s%s%s%s",
      color:sub(2, 2),
      color:sub(2, 2),
      color:sub(3, 3),
      color:sub(3, 3),
      color:sub(4, 4),
      color:sub(4, 4)
    )
  end

  return color
end

local function to_hex(color)
  if type(color) == "number" then
    return string.format("#%06x", color)
  end

  return normalize_hex(color)
end

local function channels(hex)
  hex = normalize_hex(hex)
  if not hex then
    return nil
  end

  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function blend(foreground, background, amount)
  local fr, fg, fb = channels(foreground)
  local br, bg, bb = channels(background)

  if not fr or not br then
    return foreground or background
  end

  local function mix(first, second)
    return math.floor((first * amount) + (second * (1 - amount)) + 0.5)
  end

  return string.format("#%02x%02x%02x", mix(fr, br), mix(fg, bg), mix(fb, bb))
end

local function highlight(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and hl or {}
end

local function resolve_color(groups, attr, fallback)
  local names = type(groups) == "table" and groups or { groups }

  for _, name in ipairs(names) do
    local hl = highlight(name)
    if hl[attr] then
      return to_hex(hl[attr])
    end
  end

  return fallback
end

local function set(name, spec)
  vim.api.nvim_set_hl(0, name, spec)
end

function M.apply()
  local base_bg = resolve_color({ "Normal", "NormalFloat", "CursorLine" }, "bg", "#1e1e2e")
  local text = resolve_color({ "Normal", "@variable", "Identifier" }, "fg", "#cad3f5")
  local muted = resolve_color({ "Comment", "LineNr" }, "fg", "#6c7086")
  local accent = resolve_color({ "@function", "Function", "Directory" }, "fg", "#8aadf4")
  local accent_alt = resolve_color({ "@property", "Identifier", "Type" }, "fg", "#c6a0f6")
  local keyword = resolve_color({ "@keyword", "Keyword", "Statement" }, "fg", "#f5bde6")
  local success = resolve_color({ "@string", "String", "DiagnosticOk" }, "fg", "#a6da95")
  local info = resolve_color({ "@module", "Include", "DiagnosticInfo" }, "fg", "#91d7e3")
  local warn = resolve_color({ "DiagnosticWarn", "WarningMsg", "@constant" }, "fg", "#eed49f")
  local error = resolve_color({ "DiagnosticError", "ErrorMsg" }, "fg", "#ed8796")
  local border = resolve_color({ "WinSeparator", "VertSplit", "Comment" }, "fg", blend(muted, base_bg, 0.65))
  local float_bg = blend(accent, base_bg, 0.10)
  local elevated_bg = blend(accent_alt, base_bg, 0.16)
  local cursorline_bg = blend(accent, base_bg, 0.07)
  local selection_bg = blend(accent, base_bg, 0.20)
  local gutter_bg = blend(muted, base_bg, 0.10)
  local scope_color = blend(accent, base_bg, 0.45)
  local property = resolve_color({ "@property", "@field", "Identifier", "Directory" }, "fg", accent_alt)
  local parameter = resolve_color({ "@parameter", "Identifier", "Constant" }, "fg", accent)
  local builtin = resolve_color({ "@variable.builtin", "Special", "Keyword" }, "fg", warn)
  local namespace = resolve_color({ "@module", "@namespace", "Include", "PreProc" }, "fg", info)
  local type_fg = resolve_color({ "@type", "Type" }, "fg", accent_alt)
  local function_fg = resolve_color({ "@function", "Function" }, "fg", accent)

  set("NormalFloat", { fg = text, bg = float_bg })
  set("FloatBorder", { fg = border, bg = float_bg })
  set("FloatTitle", { fg = accent, bg = float_bg, bold = true })
  set("FloatFooter", { fg = muted, bg = float_bg })
  set("Pmenu", { fg = text, bg = float_bg })
  set("PmenuSel", { fg = text, bg = selection_bg, bold = true })
  set("PmenuSbar", { bg = gutter_bg })
  set("PmenuThumb", { bg = elevated_bg })
  set("WinSeparator", { fg = border, bg = base_bg })
  set("CursorLine", { bg = cursorline_bg })
  set("CursorLineNr", { fg = accent, bold = true })
  set("LineNr", { fg = muted })
  set("Visual", { bg = selection_bg })
  set("Search", { fg = base_bg, bg = warn })
  set("CurSearch", { fg = base_bg, bg = accent })
  set("IncSearch", { fg = base_bg, bg = accent_alt })
  set("MatchParen", { fg = accent, bg = selection_bg, bold = true })
  set("WinBar", { fg = text, bg = "NONE", bold = true })
  set("WinBarNC", { fg = muted, bg = "NONE" })

  set("@property", { fg = property })
  set("@field", { fg = property })
  set("@variable.member", { fg = property })
  set("@parameter", { fg = parameter, italic = true })
  set("@variable.parameter", { fg = parameter, italic = true })
  set("@variable.builtin", { fg = builtin, italic = true })
  set("@module", { fg = namespace })
  set("@namespace", { fg = namespace })
  set("@type.builtin", { fg = type_fg, bold = true })
  set("@constructor", { fg = type_fg, bold = true })
  set("@function.builtin", { fg = function_fg, bold = true })
  set("@function.method", { fg = function_fg })
  set("@keyword.import", { fg = keyword, italic = true })
  set("@keyword.return", { fg = keyword, italic = true })
  set("@lsp.type.property", { link = "@property" })
  set("@lsp.type.variable", { link = "@variable" })
  set("@lsp.type.parameter", { link = "@parameter" })
  set("@lsp.type.method", { link = "@function.method" })
  set("@lsp.type.namespace", { link = "@namespace" })
  set("@lsp.type.class", { link = "@type" })
  set("@lsp.type.struct", { link = "@type" })
  set("@lsp.type.enum", { link = "@type" })

  set("CmpItemAbbr", { fg = text })
  set("CmpItemAbbrDeprecated", { fg = muted, strikethrough = true })
  set("CmpItemAbbrMatch", { fg = accent, bold = true })
  set("CmpItemAbbrMatchFuzzy", { fg = accent_alt, italic = true })
  set("CmpItemMenu", { fg = muted, italic = true })
  set("CmpItemKindFunction", { fg = function_fg })
  set("CmpItemKindMethod", { fg = function_fg })
  set("CmpItemKindConstructor", { fg = type_fg })
  set("CmpItemKindVariable", { fg = text })
  set("CmpItemKindField", { fg = property })
  set("CmpItemKindProperty", { fg = property })
  set("CmpItemKindClass", { fg = type_fg })
  set("CmpItemKindInterface", { fg = type_fg })
  set("CmpItemKindStruct", { fg = type_fg })
  set("CmpItemKindModule", { fg = namespace })
  set("CmpItemKindFile", { fg = text })
  set("CmpItemKindFolder", { fg = namespace })
  set("CmpItemKindKeyword", { fg = keyword })
  set("CmpItemKindSnippet", { fg = info })
  set("CmpItemKindConstant", { fg = warn })

  set("AlphaHeader", { fg = accent, bold = true })
  set("AlphaButtons", { fg = text })
  set("AlphaShortcut", { fg = accent_alt, bold = true })
  set("AlphaFooter", { fg = muted, italic = true })

  set("WhichKeyBorder", { fg = border, bg = float_bg })
  set("WhichKeyNormal", { fg = text, bg = float_bg })
  set("WhichKeyTitle", { fg = accent, bg = float_bg, bold = true })
  set("WhichKeyDesc", { fg = text })
  set("WhichKeyGroup", { fg = accent_alt, bold = true })
  set("WhichKeySeparator", { fg = muted })
  set("WhichKeyValue", { fg = muted, italic = true })

  set("NvimTreeNormal", { fg = text, bg = "NONE" })
  set("NvimTreeNormalNC", { fg = text, bg = "NONE" })
  set("NvimTreeEndOfBuffer", { fg = "NONE", bg = "NONE" })
  set("NvimTreeWinSeparator", { fg = border, bg = "NONE" })
  set("NvimTreeRootFolder", { fg = accent, bold = true })
  set("NvimTreeIndentMarker", { fg = gutter_bg })
  set("NvimTreeOpenedFile", { fg = accent, bold = true })
  set("NvimTreeOpenedHL", { fg = accent, bold = true })
  set("NvimTreeModifiedFile", { fg = warn, bold = true })
  set("NvimTreeModifiedFileHL", { fg = warn, bold = true })
  set("NvimTreeGitDirty", { fg = warn })
  set("NvimTreeGitStaged", { fg = success })
  set("NvimTreeGitNew", { fg = success })
  set("NvimTreeGitDeleted", { fg = error })
  set("NvimTreeGitFileDirtyHL", { fg = warn })
  set("NvimTreeGitFileStagedHL", { fg = success })
  set("NvimTreeGitFileNewHL", { fg = success })
  set("NvimTreeGitFileDeletedHL", { fg = error })

  set("OilDir", { fg = accent, bold = true })
  set("OilLink", { fg = info, italic = true })
  set("OilOrphanLink", { fg = error, italic = true })
  set("OilLinkTarget", { fg = muted })
  set("OilFile", { fg = text })

  set("TroubleNormal", { fg = text, bg = float_bg })
  set("TroubleNormalNC", { fg = text, bg = float_bg })

  set("SnacksNormal", { fg = text, bg = float_bg })
  set("SnacksNormalNC", { fg = text, bg = float_bg })
  set("SnacksWinBar", { fg = accent, bg = float_bg, bold = true })
  set("SnacksWinBarNC", { fg = muted, bg = float_bg })
  set("SnacksTitle", { fg = accent, bg = float_bg, bold = true })
  set("SnacksFooter", { fg = muted, bg = float_bg })
  set("SnacksPickerDir", { fg = muted })
  set("SnacksPickerFile", { fg = text })
  set("SnacksPickerMatch", { fg = accent, bold = true })
  set("SnacksPickerCursorLine", { bg = selection_bg })
  set("SnacksIndent", { fg = gutter_bg })
  set("SnacksIndentScope", { fg = scope_color })

  set("MiniIndentscopeSymbol", { fg = scope_color, nocombine = true })
  set("MiniIndentscopeSymbolOff", { fg = muted, nocombine = true })
  set("ScrollbarHandle", { bg = elevated_bg })
  set("ScrollbarCursorHandle", { bg = accent })
  set("LspSignatureActiveParameter", { fg = accent_alt, bold = true, underline = true })
end

function M.setup()
  if did_setup then
    return
  end

  did_setup = true

  local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      M.apply()
    end,
  })

  if vim.g.colors_name then
    M.apply()
  end
end

return M
