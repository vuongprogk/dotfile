return {
	"quentingruber/pomodoro.nvim",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	opts = {
		start_at_launch = true,
		work_duration = 25,
		break_duration = 5,
		snooze_duration = 1, -- The additionnal work time you get when you delay a break
	},
}
