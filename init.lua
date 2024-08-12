if vim.loader then
	vim.loader.enable()
end
vim.g.enabled_neovide = false
if vim.g.neovide then
	require("ace.core.neovide")
	vim.g.enabled_neovide = true
end
require("ace.core")
-- setup lazy
require("ace.lazy")
