return {
	"numToStr/FTerm.nvim",
	event = "VimEnter",
	config = function()
		local term = require("FTerm")
		vim.keymap.set({ "n", "t" }, "<C-\\>", term.toggle, { desc = "Toogle FTerm" })
		term.setup({
			blend = 0,
			cmd = function()
				if require("ace.custom.os").getName() == "Windows" then
					return "powershell /nologo"
				else
					return nil
				end
			end,
		})
		local lazygit = term:new({
			ft = "fterm_lazygit", -- You can also override the default filetype, if you want
			cmd = "lazygit",
			dimensions = {
				height = 0.9,
				width = 0.9,
			},
		})
		vim.keymap.set({ "n" }, "<leader>lg", function()
			lazygit:toggle()
		end, { desc = "Togle lazygit" })
	end,
}
