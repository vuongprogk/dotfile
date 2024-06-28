return {
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason"
    },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "stylua",
        "pylint",
        "isort",
        "black",
        "prettier",
        "clang_format",
        "cpplint"
      },
      automatic_installation = true,
    }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "tsserver",
        "pyright",
        "jdtls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
      },

    }
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    opts = {
      ensure_installed = {
        "cppdbg"
      },
      handlers = {
        cppdbg = function(config)
          config.configurations = {
            {
              name = 'cppdbg: Launch file',
              type = 'cppdbg',
              request = 'launch',
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = '${workspaceFolder}',
              stopAtEntry = true,
            },
            {
              name = 'cppdbg: Attach to gdbserver :1234',
              type = 'cppdbg',
              request = 'launch',
              MIMode = 'gdb',
              miDebuggerServerAddress = 'localhost:1234',
              miDebuggerPath = vim.fn.exepath('gdb'),
              cwd = '${workspaceFolder}',
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
            },
          }
          require('mason-nvim-dap').default_setup(config)
        end
      }
    }
  },
}
