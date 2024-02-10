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
end
vim.o.guifont = "JetBrains Mono:h13"
vim.opt.termguicolors = true
vim.cmd("set scrolloff=15")
vim.cmd("set number")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set autoindent")
vim.cmd("set expandtab")
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("set nocompatible")
vim.g.mapleader = " "
-- set up for coc nvim
--vim.g.coc_global_extensions = {'coc-css', 'coc-clangd', 'coc-pyright','coc-sumneko-lua','coc-java','coc-rust-analyzer'}
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })
