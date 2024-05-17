-- Set up neovim using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)
--TODO this is for lsp
require("lazy").setup({{import =  "ace.plugins" },{import = "ace.lsp"},}, {
  checker = {
    enable = true,
    notify = false
  },
  change_detection = {
    notify = false
  }
})