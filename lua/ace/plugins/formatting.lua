return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>gf",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end,
      {
        desc = "formatting code",
        mode = { "n", "v" },
      },
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { { "prettierd", "prettier" } },
      java = {
        "clang_format",
      },
      cpp = {
        "clang_format",
      },
      html = { "prettier" },
      cs = { "csharpier" },
      css = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "prefer",
    },
    format_after_save = {
      lsp_format = "fallback",
    },
    formatters = {
      csharpier = {
        command = "dotnet-csharpier",
        args = { "--write-stdout" },
      },
    },
  },
}
