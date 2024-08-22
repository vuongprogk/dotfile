return {
	"numToStr/FTerm.nvim",
	event = "VeryLazy",
	opts = {
		blend = 0,
		cmd = function()
			if require("ace.custom.os").getName() == "Windows" then
				return "powershell /nologo"
			else
				return nil
			end
		end,
	},
	config = function(_, opts)
		local term = require("FTerm")
		term.setup(opts)
		vim.keymap.set({ "n", "t" }, "<C-\\>", term.toggle, { desc = "Toogle FTerm", remap = true })

		local lazygit = term:new({
			ft = "fterm_lazygit", -- You can also override the default filetype, if you want
			cmd = "lazygit",
			dimensions = {
				height = 0.9,
				width = 0.9,
			},
		})
		vim.keymap.set("n", "<leader>lg", function()
			lazygit:toggle()
		end, { desc = "Togle lazygit", remap = true })
	end,
}
