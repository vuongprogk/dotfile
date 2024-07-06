return {
	"numToStr/FTerm.nvim",
	config = function()
		local term = require("FTerm")
		vim.keymap.set({ "n", "i", "t" }, "<C-\\>", term.toggle, { desc = "Toogle FTerm" })
    term.setup({
      blend = 30
    })
	end,
}
