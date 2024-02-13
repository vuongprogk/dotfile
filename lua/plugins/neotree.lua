return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  config = function()
    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal current<CR>', {silent = true})
  end
}
