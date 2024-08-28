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
}
--#endregion

local execute = vim.fn.executable
if pcall(execute, "go") then
	plugins[#plugins + 1] = { import = "ace.lang.go" }
end

if pcall(execute, "python") then
	plugins[#plugins + 1] = { import = "ace.lang.python" }
end

if pcall(execute, "java") then
	plugins[#plugins + 1] = { import = "ace.lang.java" }
end

if pcall(execute, "node") then
	plugins[#plugins + 1] = { import = "ace.lang.typescript" }
end

if pcall(execute, "flutter") then
	plugins[#plugins + 1] = { import = "ace.lang.flutter" }
	plugins[#plugins + 1] = { import = "ace.lang.kotlin" }
end

if pcall(execute, "dotnet") then
	plugins[#plugins + 1] = { import = "ace.lang.csharp" }
end
if pcall(execute, "docker") then
	plugins[#plugins + 1] = { import = "ace.lang.docker" }
end

require("lazy").setup({
	spec = plugins,
	pgk = { enabled = false },
	rocks = { enabled = false },
	change_detection = {
		notify = false,
	},
	performance = {
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
