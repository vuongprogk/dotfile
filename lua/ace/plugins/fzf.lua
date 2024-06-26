return {
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "junegunn/fzf",
    },
    config = function()
      require("fzf-lua").setup({})
    end,
  },
}
