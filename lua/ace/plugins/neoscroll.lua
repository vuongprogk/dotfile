local neoscroll = {
	"karb94/neoscroll.nvim",
	opts = {},
	cond = true,
	event = nil,
}
if vim.g.enabled_neovide then
	neoscroll.cond = false
else
	neoscroll.event = "VeryLazy"
end
return neoscroll
