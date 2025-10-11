
-- ===============================
-- Neovim DAP + DAP-UI + persistent breakpoints
-- ===============================

local dap = require("dap")

-- === DAP Adapters ===
    
-- codelldb is very good :)
dap.adapters.codelldb = {
  type = "executable",
    -- install codelldb before using this! its a debug adapter from lldb to nvim-dap
    command = "/home/sihrke/codelldb_install/extension/adapter/codelldb", -- change this!
}

-- Optional LLDB adapter
-- dap.adapters.lldb = {
--   type = "executable",
--   command = "/usr/bin/lldb-vscode-14",
--   name = "lldb",
-- }

-- === Project directory & persistence files ===
local project_dir = vim.fn.getcwd()
local dap_targets_file = project_dir .. "/.nvim/dap_targets.json"
local breakpoints_file = project_dir .. "/.nvim/dap_breakpoints.json"

-- === Helper: Targets persistence ===
local function load_targets()
    if vim.fn.filereadable(dap_targets_file) == 1 then
        local content = vim.fn.readfile(dap_targets_file)
        local ok, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
        if ok and type(data) == "table" then return data end
    end
    return {}
end

local function save_targets(targets)
    vim.fn.mkdir(project_dir .. "/.nvim", "p")
    vim.fn.writefile({ vim.fn.json_encode(targets) }, dap_targets_file)
end

-- === Breakpoint persistence ===
local pb = require("persistent-breakpoints")

pb.setup({
        load_breakpoints_event = { "BufReadPost" },
    save_dir = vim.fn.getcwd() .. "/.nvim",
})


-- === DAP Configurations ===
dap.configurations.cpp = dap.configurations.cpp or {}
table.insert(dap.configurations.cpp, {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    terminal = "integrated",  
    program = function()
        local targets = load_targets()
        local cwd = vim.fn.getcwd()
        local input

        -- Helper function to check if file exists and is executable
        local function is_executable(path)
            local stat = vim.loop.fs_stat(path)
            return stat and stat.type == "file"
        end

        -- Helper function to save chosen target
        local function save_input(path)
            if path and path ~= "" and is_executable(path) then
                -- Remove duplicates
                for i = #targets, 1, -1 do
                    if targets[i] == path then table.remove(targets, i) end
                end
                table.insert(targets, path)
                if #targets > 10 then table.remove(targets, 1) end
                save_targets(targets)
                return path
            end
            return nil
        end

        -- Build selection menu: previous targets + "Add new executable"
        local menu = vim.tbl_extend("force", {}, targets)
        table.insert(menu, "<Add new executable>")

        local choice = nil
        vim.ui.select(menu, {
            prompt = "Select executable (Enter for first option):",
            format_item = function(item) return item end,
        }, function(selected)
            if selected == nil then
                -- Enter pressed without selection → first option
                choice = menu[1]
            elseif selected == "<Add new executable>" then
                -- Prompt for new executable
                local new_path = vim.fn.input("Path to executable: ", cwd .. "/", "file")
                if new_path == "" then
                    -- Enter pressed → default to first target if exists
                    choice = targets[1] or nil
                else
                    choice = new_path
                end
            else
                choice = selected
            end
        end)

        -- Wait until the user makes a choice
        vim.wait(10000, function() return choice ~= nil end)

        -- Only save and return if it's a valid executable
        if not is_executable(choice) then
            vim.notify("Invalid executable: " .. tostring(choice), vim.log.levels.ERROR)
            return nil  -- abort debugging
        end

        return save_input(choice)
    end,
    cwd = "${workspaceFolder}",
})


-- === Load VSCode launch.json if exists ===
local launch_json = '.vscode/nvim_launch.json'
if vim.fn.filereadable(launch_json) == 1 then
    require('dap.ext.vscode').load_launchjs(launch_json, {
        codelldb = { 'c', 'cpp', 'qml', 'NvimTree' },
    })
end
require("dapui").setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  require("dapui").open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  require("dapui").close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  require("dapui").close()
end
-- Keymapping to open dap-ui manually
--
--
vim.keymap.set('n', '<leader>do', require("dapui").toggle, { desc = '[D]ebug [O]open' })

-- Custom DAP signs

vim.fn.sign_define("DapBreakpoint", {
    text = "",          -- or use a Nerd Font icon like ""
    texthl = "DapBreakpointRed", -- custom highlight
    linehl = "",
    numhl = "",
})

-- Define the red highlight
vim.api.nvim_set_hl(0, "DapBreakpointRed", { fg = "#FF5555", bold = true })
