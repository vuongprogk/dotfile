-- Set up neovim using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

--#region
-- config basic
local plugins = {
	{ import = "ace.ui" },
	{ import = "ace.editor" },
	{ import = "ace.utils" },
	{ import = "ace.coding" },
	{ import = "ace.plugins" },
	{ import = "ace.lang.lua" },
	{ import = "ace.lang.schema" },
	{ import = "ace.lang.markdown" },
	{ import = "ace.lang.tailwind" },
	{ import = "ace.coding.copilot" },
	{ import = "ace.lang.go" },
	{ import = "ace.lang.python" },
	{ import = "ace.lang.java" },
	{ import = "ace.lang.typescript" },
	{ import = "ace.lang.flutter" },
	{ import = "ace.lang.kotlin" },
	{ import = "ace.lang.csharp" },
	{ import = "ace.lang.docker" },
}
--#endregion

require("lazy").setup({
	spec = plugins,
	pgk = { enabled = false },
	rocks = { enabled = false },
	change_detection = {
		notify = false,
	},
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		-- only generate markdown helptags for plugins that dont have docs
		skip_if_doc_exists = true,
	},
})
