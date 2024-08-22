return {
	"hrsh7th/nvim-cmp",
	event = { "BufRead", "BufNewFile" },
	dependencies = { "hrsh7th/cmp-emoji" },
	---@param opts cmp.ConfigSchema
	opts = function(_, opts)
		table.insert(opts.sources, { name = "emoji" })
	end,
}
