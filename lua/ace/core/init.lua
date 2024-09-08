_G.Ace = require("ace.core.util")
local M = {}

---@param name "autocmds" | "vim" | "keymap" | "customcmds" | "neovide"
function M.load(name)
	local function _load(mod)
		if require("lazy.core.cache").find(mod)[1] then
			Ace.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end
	local pattern = "Ace" .. name:sub(1, 1):upper() .. name:sub(2)
	_load("ace.core." .. name)
	if vim.bo.filetype == "lazy" then
		vim.cmd([[do VimResized]])
	end
	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end
function M.setup()
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
		M.load("customcmds")
	end

	local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = function()
			if lazy_autocmds then
				M.load("autocmds")
			end
			M.load("keymap")

			Ace.format.setup()
			Ace.root.setup()
		end,
	})
end
M.load("vim")
if vim.g.neovide then
	M.load("neovide")
end

return M
