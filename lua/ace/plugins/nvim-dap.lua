return {
  {
    "mfussenegger/nvim-dap",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<Leader>dt",
        function()
          local dap = require("dap")
          dap.toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<Leader>dc",
        function()
          require("dap").continue()
        end,
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local present, dap = pcall(require, "dap")
      if not present then
        vim.notify("DAP not loaded")
        return
      end

      local dapui = require("dapui")
      require("dapui").setup()

      --Change icons
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set("n",
        "<leader>du",
        function()
          dapui.toggle({})
        end,
        { desc = "Dap Toggle UI", }
      )
    end,
  },
}
