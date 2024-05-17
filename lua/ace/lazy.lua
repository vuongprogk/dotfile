-- Set up neovim using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)
--TODO this is for lsp
local config_folder
if not vim.g.neovide then
  config_folder = {{import =  "ace.plugins" },{import = "ace.lsp"},{import = "ace.notneovide.animate"}}
else
  config_folder = {{import =  "ace.plugins" },{import = "ace.lsp"}}
end
require("lazy").setup(config_folder, {
  checker = {
    enable = true,
    notify = false
  },
  change_detection = {
    notify = false
  }
})
