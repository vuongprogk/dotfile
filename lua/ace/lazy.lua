-- Set up neovim using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
local plugin_path = {
	{ import = "ace.plugins" },
	{ import = "ace.lsp" },
}
require("lazy").setup({
	spec = plugin_path,
	install = {
		colorscheme = { "solarized-osaka" },
	},
	pgk = { enabled = false },
	rocks = { enabled = false },
	change_detection = {
		notify = false,
	},
})
