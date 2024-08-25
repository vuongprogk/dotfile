if vim.g.neovide then
	require("ace.core.neovide")
end
require("ace.core")
-- setup lazy
if not vim.g.vscode then
	require("ace.lazy")
end
