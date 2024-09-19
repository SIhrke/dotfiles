-- Install and configure nvim-dap
local dap = require('dap')

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode-14", -- adjust as needed
	name = "lldb"
}


if vim.fn.filereadable('.vscode/nvim_launch.json') == 1 then
  require('dap.ext.vscode').load_launchjs('.vscode/nvim_launch.json', { lldb = {'c', 'cpp'} })
else
  dap.configurations.cpp = {} 
end

table.insert(dap.configurations.cpp,{
    name = "Launch file",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  });

-- Configure nvim-dap-ui
local dapui = require("dapui")

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25,
      position = "bottom",
    },
  },
})

-- Integrate nvim-dap with nvim-dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


