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
	{ import = "ace.coding.copilot" },
	{ import = "ace.lang.cpp" },
	{ import = "ace.linting" },
}
if vim.fn.executable("flutter") == 1 then
	table.insert(plugins, { import = "ace.lang.flutter" })
end

if vim.fn.executable("java") == 1 then
	table.insert(plugins, { { import = "ace.lang.java" }, { import = "ace.lang.kotlin" } })
end

if vim.fn.executable("node") == 1 then
	table.insert(
		plugins,
		{ { import = "ace.lang.typescript" }, { import = "ace.lang.tailwind" }, { import = "ace.lang.html" } }
	)
end

if vim.fn.executable("docker") == 1 then
	table.insert(plugins, { import = "ace.lang.docker" })
end

if vim.fn.executable("go") == 1 then
	table.insert(plugins, { import = "ace.lang.go" })
end

if vim.fn.executable("dotnet") == 1 then
	table.insert(plugins, { import = "ace.lang.csharp" })
end

if vim.fn.executable("python") == 1 then
	table.insert(plugins, { import = "ace.lang.python" })
end
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
})
