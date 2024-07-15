-- Set up for neovide
if vim.g.neovide then
	vim.opt.linespace = 0
	vim.g.neovide_scale_factor = 1.0
	local alpha = function()
		return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
	end
	vim.g.neovide_transparency = 0.9
	vim.g.transparency = 0.9
	vim.g.neovide_background_color = "#0f1117" .. alpha()
	vim.g.neovide_scroll_animation_far_lines = 3
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_refresh_rate = 60
	vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
end
local opt = vim.opt
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Turn off bell
opt.belloff = "all"

-- set default background
opt.background = "dark"
opt.termguicolors = true

--set croll off
opt.scrolloff = 15

-- show number
opt.number = true
opt.relativenumber = true

-- set tabsize
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2

--set no wrap
opt.wrap = false
opt.signcolumn = "yes"

-- open cursor line
opt.cursorline = true

-- set copy direct to clipboard
opt.clipboard:append("unnamedplus")
opt.ignorecase = true
opt.smartcase = true

-- set key map space when enter do nothing
vim.keymap.set({ "n", "v" }, "<space>", "<NOP>", { silent = true, remap = false })

-- set leader key
vim.g.mapleader = " "

-- TODo auto read file
opt.autoread = true
-- TODO set update time
vim.opt.updatetime = 100

-- set keymap for tab
vim.keymap.set("n", "<Leader>tn", "<cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tp", "<cmd>tabprevious<CR>", { silent = true })
