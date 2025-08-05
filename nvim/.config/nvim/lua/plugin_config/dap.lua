-- Install and configure nvim-dap
local dap = require('dap')

--dap.adapters.lldb = {
--	type = "executable",
--	command = "/usr/bin/lldb-vscode-14", -- adjust as needed
--	name = "lldb"
--}
dap.adapters.gdb = {
  type = "executable",
  command = "/usr/bin/gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.cpp = {} 
if vim.fn.filereadable('.vscode/nvim_launch.json') == 1 then
  require('dap.ext.vscode').load_launchjs('.vscode/nvim_launch.json', { gdb = {'c', 'cpp','qml', 'NvimTree' }})
end

table.insert(dap.configurations.cpp,{
  name = "Launch file",
  type = "gdb",
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


-- Function to save window layout and open debug tab
local function open_debug_tab()


  -- Open a new tab
  vim.cmd("tabnew")
  vim.t.debug_tab=true
  vim.api.nvim_tabpage_set_var(0, 'tabname', 'Debug')
  -- Open dap-ui
  dapui.open()
end

-- Function to close debug tab and restore previous layout
local function close_debug_tab()
  if vim.t.debug_tab ~= nil then
    -- Close dap-ui
    dapui.close()
    -- Close the current tab
    vim.cmd("tabclose")
  end
end

-- Set up DAP event listeners
dap.listeners.after.event_initialized["dapui_config"] = open_debug_tab
dap.listeners.before.event_terminated["dapui_config"] = close_debug_tab
dap.listeners.before.event_exited["dapui_config"] = close_debug_tab

-- Keymaps for manual control (optional)
vim.keymap.set('n', '<leader>do', open_debug_tab, { desc = "Open Debug Tab" })
vim.keymap.set('n', '<leader>dc', close_debug_tab, { desc = "Close Debug Tab" })
