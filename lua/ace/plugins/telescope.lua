return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    branch = "0.1.x",
    keys = {
      {
        "<leader>ff", function()
        require("telescope.builtin").find_files()
      end, { desc = "Telescope search file" },
      },
      {
        "<leader>fs", function ()
          require("telescope.builtin").live_grep()
        end, {desc = "Telescope search word in file"}
      },
      {
        "<leader>fb", function ()
          require("telescope.builtin").buffers()
        end, {desc = "Telescope read buffers"}
      },
      {
        "<leader>fh", function ()
          require("telescope.builtin").help_tags()
        end, {desc = "Telescope help tags"}
      }
    },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      require("telescope").load_extension("ui-select")
    end,
  },
}
