-- Set up for neovide
if vim.g.neovide then
	vim.opt.linespace = 0
	vim.g.neovide_scale_factor = 1.0
	local alpha = function()
		return string.format("%x", math.floor(0.8))
	end
	vim.g.neovide_transparency = 0.9
	vim.g.transparency = 0.9
	vim.g.neovide_background_color = "#0f1117" .. alpha()
	vim.g.neovide_scroll_animation_far_lines = 3
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_refresh_rate = 60
	vim.opt.guifont = "Hack Nerd Font:h12"
end
local opt = vim.opt
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.terminal_emulator='wezterm'
opt.belloff = "all"
opt.background = "dark"
opt.termguicolors = true
opt.scrolloff = 15
opt.number = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.wrap = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.clipboard:append("unnamedplus")
opt.ignorecase = true
opt.smartcase = true
vim.keymap.set("n", "<space>", "<NOP>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("n", "<Leader>tn", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tp", ":tabprevious<CR>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", { silent = true, desc = "Exit insert mode with jk" })
