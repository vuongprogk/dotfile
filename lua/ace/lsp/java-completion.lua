return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local config = {
      cmd = { vim.fn.expand(vim.fn.stdpath("data") .. "\\mason\\bin\\jdtls.cmd") },
      root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),
    }
    require("jdtls").start_or_attach(config)
  end,
}