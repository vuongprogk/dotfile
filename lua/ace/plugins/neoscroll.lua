local neoscroll = {
	"karb94/neoscroll.nvim",
	opts = {},
	enabled = true,
	event = nil,
}
if vim.g.enabled_neovide then
	neoscroll.enabled = false
else
	neoscroll.event = "VeryLazy"
end
return neoscroll
