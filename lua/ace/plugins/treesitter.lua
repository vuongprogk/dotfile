return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "vim", "cpp", "python", "css", "html", "dart", "lua" },
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				disable = { "c_sharp" },
			},
			indent = true,
		})
	end,
}
