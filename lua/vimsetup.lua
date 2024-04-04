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
  vim.opt.guifont = "JetBrains Mono:h13"
end
vim.opt.belloff = "all"
vim.opt.termguicolors = true
vim.opt.scrolloff = 15
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.compatible = false
vim.keymap.set("n", "<space>", "<NOP>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })
vim.keymap.set('i', "jk", '<ESC>', {silent = true, desc = "Exit insert mode with jk"})
