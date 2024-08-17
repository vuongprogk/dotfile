if vim.loader then
	if not vim.loader.enabled then
		vim.loader.enable()
	end
end
vim.g.enabled_neovide = false
if vim.g.neovide then
	require("ace.core.neovide")
	vim.g.enabled_neovide = true
end
require("ace.core")
-- setup lazy
require("ace.lazy")
