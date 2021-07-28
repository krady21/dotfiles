-- Lua version of nord.vim

vim.cmd [[
  highlight clear
  syntax reset
]]

vim.g.colors_name = "nord"
vim.opt.background = "dark"

local nord0  = "#2E3440"
local nord1  = "#3B4252"
local nord2  = "#434C5E"
local nord3  = "#4C566A"
local nord3b = "#616E88"
local nord4  = "#D8DEE9"
local nord5  = "#E5E9F0"
local nord6  = "#ECEFF4"
local nord7  = "#8FBCBB"
local nord8  = "#88C0D0"
local nord9  = "#81A1C1"
local nord10 = "#5E81AC"
local nord11 = "#BF616A"
local nord12 = "#D08770"
local nord13 = "#EBCB8B"
local nord14 = "#A3BE8C"
local nord15 = "#B48EAD"

-- Neovim Terminal Colors
vim.g.terminal_color_0  = nord1
vim.g.terminal_color_1  = nord11
vim.g.terminal_color_2  = nord14
vim.g.terminal_color_3  = nord13
vim.g.terminal_color_4  = nord9
vim.g.terminal_color_5  = nord15
vim.g.terminal_color_6  = nord8
vim.g.terminal_color_7  = nord5
vim.g.terminal_color_8  = nord3
vim.g.terminal_color_9  = nord11
vim.g.terminal_color_10 = nord14
vim.g.terminal_color_11 = nord13
vim.g.terminal_color_12 = nord9
vim.g.terminal_color_13 = nord15
vim.g.terminal_color_14 = nord7
vim.g.terminal_color_15 = nord6

local hi = function(opts)
  vim.cmd(
    string.format("hi %s guifg=%s guibg=%s gui=%s guisp=%s", 
      opts.group, 
      opts.guifg or "NONE", 
      opts.guibg or "NONE", 
      opts.gui or "NONE", 
      opts.guisp or "NONE"
    )
  )
end

local link = function(from, to)
  vim.cmd(string.format("hi! link %s %s", from, to))
end

hi { group = "ColorColumn", guibg = nord1 }
hi { group = "Cursor", guifg = nord0, guibg = nord4 }
hi { group = "CursorLine", guibg = nord1 }
hi { group = "Error", guifg = nord4, guibg = nord11 }
hi { group = "iCursor", guifg = nord0, guibg = nord4 }
hi { group = "LineNr", guifg = nord3}
hi { group = "MatchParen", guifg = nord8, guibg = nord3 }
hi { group = "NonText", guifg = nord2 }
hi { group = "Normal", guifg = nord4, guibg = nord0 }
hi { group = "PMenu", guifg = nord4, guibg = nord2 }
hi { group = "PMenuSbar", guifg = nord4, guibg = nord2 }
hi { group = "PMenuSel", guifg = nord8, guibg = nord3 }
hi { group = "PMenuThumb", guifg = nord8, guibg = nord3 }
hi { group = "SpecialKey", guifg = nord3 }
hi { group = "SpellBad", guifg = nord11, guibg = nord0, gui = "underline", guisp = nord11 }
hi { group = "SpellCap", guifg = nord13, guibg = nord0, gui = "underline", guisp = nord13 }
hi { group = "SpellLocal", guifg = nord5, guibg = nord0, gui = "underline", guisp = nord5 }
hi { group = "SpellRare", guifg = nord6, guibg = nord0, gui = "underline", guisp = nord6 }
hi { group = "Visual", guibg = nord2 }
hi { group = "VisualNOS", guibg = nord2 }
hi { group = "TermCursorNC", guibg = nord1 }

hi { group = "CursorLineNr", guifg = nord4 }
hi { group = "Folded", guifg = nord3, guibg = nord1, gui = "bold" }
hi { group = "FoldColumn", guifg = nord3, guibg = nord0 }
hi { group = "SignColumn", guifg = nord1, guibg = nord0 }
hi { group = "Directory", guifg = nord8 }
hi { group = "EndOfBuffer", guifg = nord1 }
hi { group = "ErrorMsg", guifg = nord4, guibg = nord11 }
hi { group = "ModeMsg", guifg = nord4, gui = "bold" }
hi { group = "MoreMsg", guifg = nord8 }
hi { group = "Question", guifg = nord4 }

hi { group = "StatusLine", guifg = nord8, guibg = nord3 }
hi { group = "StatusLineNC", guifg = nord4, guibg = nord1 }
hi { group = "StatusLineTerm", guifg = nord8, guibg = nord3 }
hi { group = "StatusLineTermNC", guifg = nord4, guibg = nord1 }

hi { group = "WarningMsg", guifg = nord0, guibg = nord13 }
hi { group = "WildMenu", guifg = nord8, guibg = nord1 }
hi { group = "IncSearch", guifg = nord6, guibg = nord10 }
hi { group = "Search", guifg = nord1, guibg = nord8 }

hi { group = "TabLine", guifg = nord4, guibg = nord1 }
hi { group = "TabLineFill", guifg = nord4, guibg = nord1 }
hi { group = "TabLineSel", guifg = nord8, guibg = nord3 }

hi { group = "Title", guifg = nord4 }
hi { group = "VertSplit", guifg = nord2, guibg = nord0 }

hi { group = "Boolean", guifg = nord9 }
hi { group = "Character", guifg = nord14 }
hi { group = "Comment", guifg = nord3b }
hi { group = "Conditional", guifg = nord9 }
hi { group = "Constant", guifg = nord4 }
hi { group = "Define", guifg = nord9 }
hi { group = "Delimiter", guifg = nord6 }
hi { group = "Exception", guifg = nord9 }
hi { group = "Float", guifg = nord15 }
hi { group = "Function", guifg = nord8 }
hi { group = "Identifier", guifg = nord4 }
hi { group = "Include", guifg = nord9 }
hi { group = "Keyword", guifg = nord9 }
hi { group = "Label", guifg = nord9 }
hi { group = "Number", guifg = nord15 }
hi { group = "Operator", guifg = nord9 }
hi { group = "PreProc", guifg = nord9 }
hi { group = "Repeat", guifg = nord9 }
hi { group = "Special", guifg = nord4 }
hi { group = "SpecialChar", guifg = nord13 }
hi { group = "SpecialComment", guifg = nord8 }
hi { group = "Statement", guifg = nord9, gui = "bold" }
hi { group = "StorageClass", guifg = nord9 }
hi { group = "String", guifg = nord14 }
hi { group = "Structure", guifg = nord9 }
hi { group = "Tag", guifg = nord4 }
hi { group = "Todo", guifg = nord13, gui = "bold" }
hi { group = "Type", guifg = nord9 }
hi { group = "Typedef", guifg = nord9 }

link("Macro", "Define")
link("PreCondit", "PreProc")

-- Languages
hi { group = "asciidocAttributeEntry", guifg = nord10 }
hi { group = "asciidocAttributeList", guifg = nord10 }
hi { group = "asciidocAttributeRef", guifg = nord10 }
hi { group = "asciidocHLabel", guifg = nord9 }
hi { group = "asciidocListingBlock", guifg = nord7 }
hi { group = "asciidocMacroAttributes", guifg = nord8 }
hi { group = "asciidocOneLineTitle", guifg = nord8 }
hi { group = "asciidocPassthroughBlock", guifg = nord9 }
hi { group = "asciidocQuotedMonospaced", guifg = nord7 }
hi { group = "asciidocTriplePlusPassthrough", guifg = nord7 }

link("asciidocAdmonition", "Keyword")
link("asciidocAttributeRef", "markdownH1")
link("asciidocBackslash", "Keyword")
link("asciidocMacro", "Keyword")
link("asciidocQuotedBold", "Bold")
link("asciidocQuotedEmphasized", "Italic")
link("asciidocQuotedMonospaced2", "asciidocQuotedMonospaced")
link("asciidocQuotedUnconstrainedBold", "asciidocQuotedBold")
link("asciidocQuotedUnconstrainedEmphasized", "asciidocQuotedEmphasized")
link("asciidocURL", "markdownLinkText")

hi { group = "awkCharClass", guifg = nord7 }
hi { group = "awkPatterns", guifg = nord9, gui = "bold" }

link("awkArrayElement", "Identifier")
link("awkBoolLogic", "Keyword")
link("awkBrktRegExp", "SpecialChar")
link("awkComma", "Delimiter")
link("awkExpression", "Keyword")
link("awkFieldVars", "Identifier")
link("awkLineSkip", "Keyword")
link("awkOperator", "Operator")
link("awkRegExp", "SpecialChar")
link("awkSearch", "Keyword")
link("awkSemicolon", "Delimiter")
link("awkSpecialCharacter", "SpecialChar")
link("awkSpecialPrintf", "SpecialChar")
link("awkVariables", "Identifier")

hi { group = "cIncluded", guifg = nord7 }
link("cOperator", "Operator")
link("cPreCondit", "PreCondit")

hi { group = "cmakeGeneratorExpression", guifg = nord10 }

link("csPreCondit", "PreCondit")
link("csType", "Type")
link("csXmlTag", "SpecialComment")

hi { group = "DiffAdd", guifg = nord14, guibg = nord0, gui = "inverse" }
hi { group = "DiffChange", guifg = nord13, guibg = nord0, gui = "inverse" }
hi { group = "DiffDelete", guifg = nord11, guibg = nord0, gui = "inverse" }
hi { group = "DiffText", guifg = nord9, guibg = nord0, gui = "inverse" }

hi { group = "cssAttributeSelector", guifg = nord7 }
hi { group = "cssDefinition", guifg = nord7 }
hi { group = "cssIdentifier", guifg = nord7, gui = "underline" }
hi { group = "cssStringQ", guifg = nord7 }

hi { group = "gitconfigVariable", guifg = nord7 }

link("cssAttr", "Keyword")
link("cssBraces", "Delimiter")
link("cssClassName", "cssDefinition")
link("cssColor", "Number")
link("cssProp", "cssDefinition")
link("cssPseudoClass", "cssDefinition")
link("cssPseudoClassId", "cssPseudoClass")
link("cssVendor", "Keyword")

link("diffAdded", "DiffAdd")
link("diffChanged", "DiffChange")
link("diffRemoved", "DiffDelete")

hi { group = "goBuiltins", guifg = nord7 }
link("goConstants", "Keyword")

hi { group = "htmlArg", guifg = nord7 }
hi { group = "htmlLink", guifg = nord4 }

link("htmlBold", "Bold")
link("htmlEndTag", "htmlTag")
link("htmlItalic", "Italic")
link("htmlH1", "markdownH1")
link("htmlH2", "markdownH1")
link("htmlH3", "markdownH1")
link("htmlH4", "markdownH1")
link("htmlH5", "markdownH1")
link("htmlH6", "markdownH1")
link("htmlSpecialChar", "SpecialChar")
link("htmlTag", "Keyword")
link("htmlTagN", "htmlTag")

hi { group = "javaDocTags", guifg = nord7 }
link("javaCommentTitle", "Comment")
link("javaScriptBraces", "Delimiter")
link("javaScriptIdentifier", "Keyword")
link("javaScriptNumber", "Number")

hi { group = "jsonKeyword", guifg = nord7 }

hi { group = "lessClass", guifg = nord7 }
link("lessAmpersand", "Keyword")
link("lessCssAttribute", "Delimiter")
link("lessFunction", "Function")

link("lispAtomBarSymbol", "SpecialChar")
link("lispAtomList", "SpecialChar")
link("lispAtomMark", "Keyword")
link("lispBarSymbol", "SpecialChar")
link("lispFunc", "Function")

link("luaFunc", "Function")

hi { group = "markdownBlockquote", guifg = nord7 }
hi { group = "markdownCode", guifg = nord7 }
hi { group = "markdownCodeDelimiter", guifg = nord7 }
hi { group = "markdownFootnote", guifg = nord7 }
hi { group = "markdownId", guifg = nord7 }
hi { group = "markdownIdDeclaration", guifg = nord8 }
hi { group = "markdownLinkText", guifg = nord8 }
hi { group = "markdownUrl", guifg = nord4 }
link("markdownBold", "Bold")
link("markdownBoldDelimiter", "Keyword")
link("markdownFootnoteDefinition", "markdownFootnote")
link("markdownH2", "markdownH1")
link("markdownH3", "markdownH1")
link("markdownH4", "markdownH1")
link("markdownH5", "markdownH1")
link("markdownH6", "markdownH1")
link("markdownIdDelimiter", "Keyword")
link("markdownItalic", "Italic")
link("markdownItalicDelimiter", "Keyword")
link("markdownLinkDelimiter", "Keyword")
link("markdownLinkTextDelimiter", "Keyword")
link("markdownListMarker", "Keyword")
link("markdownRule", "Keyword")
link("markdownHeadingDelimiter", "Keyword")

hi { group = "perlPackageDecl", guifg = nord7 }

hi { group = "phpClasses", guifg = nord7 }
hi { group = "phpClass", guifg = nord7 }
hi { group = "phpDocTags", guifg = nord7 }
link("phpDocCustomTags", "phpDocTags")
link("phpMemberSelector", "Keyword")
link("phpMethod", "Function")
link("phpFunction", "Function")

link("pythonBuiltin", "Type")
link("pythonEscape", "SpecialChar")

hi { group = "rubyConstant", guifg = nord7 }
hi { group = "rubySymbol", guifg = nord6, gui = "bold" }
link("rubyAttribute", "Identifier")
link("rubyBlockParameterList", "Operator")
link("rubyInterpolationDelimiter", "Keyword")
link("rubyKeywordAsMethod", "Function")
link("rubyLocalVariableOrMethod", "Function")
link("rubyPseudoVariable", "Keyword")
link("rubyRegexp", "SpecialChar")

hi { group = "rustAttribute", guifg = nord10 }
hi { group = "rustEnum", guifg = nord7, gui = "bold" }
hi { group = "rustMacro", guifg = nord8, gui = "bold" }
hi { group = "rustAttribute", guifg = nord7 }
hi { group = "rustPanic", guifg = nord9, gui = "bold" }
hi { group = "rustTrait", guifg = nord7 }
link("rustCommentLineDoc", "Comment")
link("rustDerive", "rustAttribute")
link("rustEnumVariant", "rustEnum")
link("rustEscape", "SpecialChar")
link("rustQuestionMark", "Keyword")

link("shCmdParenRegion", "Delimiter")
link("shCmdSubRegion", "Delimiter")
link("shDerefSimple", "Identifier")
link("shDerefVar", "Identifier")

link("shCmdParenRegion", "Delimiter")
link("shCmdSubRegion", "Delimiter")
link("shDerefSimple", "Identifier")
link("shDerefVar", "Identifier")

link("sqlKeyword", "Keyword")
link("sqlSpecial", "Keyword")

hi { group = "vimAugroup", guifg = nord7 }
hi { group = "vimMapRhs", guifg = nord7 }
hi { group = "vimNotation", guifg = nord7 }
link("vimFunc", "Function")
link("vimFunction", "Function")
link("vimUserFunc", "Function")

hi { group = "xmlAttrib", guifg = nord7 }
hi { group = "xmlCdataStart", guifg = nord3b, gui = "bold" }
hi { group = "xmlNamespace", guifg = nord7 }
link("xmlAttribPunct", "Delimiter")
link("xmlCdata", "Comment")
link("xmlCdataCdata", "xmlCdataStart")
link("xmlCdataEnd", "xmlCdataStart")
link("xmlEndTag", "xmlTagName")
link("xmlProcessingDelim", "Keyword")
link("xmlTagName", "Keyword")

hi { group = "yamlBlockMappingKey", guifg = nord7 }
link("yamlBool", "Keyword")
link("yamlDocumentStart", "Keyword")

-- Fugitive
hi { group = "gitcommitDiscardedFile", guifg = nord11 }
hi { group = "gitcommitUntrackedFile", guifg = nord11 }
hi { group = "gitcommitSelectedFile", guifg = nord14 }

-- Neovim LSP
hi { group = "LSPDiagnosticsWarning", guifg = nord13 }
hi { group = "LSPDiagnosticsError", guifg = nord11 }
hi { group = "LSPDiagnosticsInformation", guifg = nord8 }
hi { group = "LSPDiagnosticsHint", guifg = nord10 }
