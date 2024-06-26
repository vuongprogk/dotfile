return {
	-- setup formatting
  "nvimtools/none-ls.nvim",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
      opts = nil,
    },
    "williamboman/mason.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>gf",
      vim.lsp.buf.format,
      { silent = true, desc = "formatting code" },
    },
  },
}
