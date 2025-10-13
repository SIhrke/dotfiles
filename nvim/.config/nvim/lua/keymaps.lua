-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
--vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files({hidden=true}) end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() require('telescope.builtin').live_grep({additional_args={"--hidden"}}) end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })



--Own new remappings: nvim-tree
vim.api.nvim_set_keymap('n', '<leader>o', ':NvimTreeToggle<CR>', { noremap = true, silent = true , desc = "Toggle Explorer" })
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeFocus<CR>', { noremap = true, silent = true, desc = "Focus Explorer" } )
require('scrollview').setup()
vim.api.nvim_set_keymap('n', '<Leader>gs', ':LspClangdSwitchSourceHeader<CR>', { noremap = true, silent = true ,desc = "Switch Header/Source"})
vim.api.nvim_set_keymap('n', '<Leader>wa', ':wa<CR>', { noremap = true, silent = true, desc = "Write all Buffers" } )

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<Leader>qq", ':qall<CR>')

--neotest
vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run current file" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
local last_test = {}
-- Debug nearest test and save its ID
vim.keymap.set('n', '<leader>td', function()
  local neotest = require("neotest")
  local test_id = neotest.run.run({strategy = "dap"})
  if test_id then
    last_test.id = test_id
  end
end, { desc = "Debug Nearest Test" })

-- Debug last test again
vim.keymap.set('n', '<leader>tD', function()
  local neotest = require("neotest")
  if last_test.id then
    neotest.run.run({id = last_test.id, strategy = "dap"})
  else
    vim.notify("No test has been debugged yet", vim.log.levels.WARN)
  end
end, { desc = "Debug Last Test Again" })

local dap = require('dap')
-- DAP debug
vim.keymap.set('n', '<F5>', function() 

  if vim.fn.filereadable('.vscode/nvim_launch.json') == 1 then
    require('dap.ext.vscode').load_launchjs('.vscode/nvim_launch.json', { codelldb = {'c', 'cpp','qml', 'NvimTree' }})
  end
  dap.continue() end,{ desc = "Debug continue" })
vim.keymap.set('n', '<F10>', function() dap.step_over() end,{ desc = "Debug step over" })
vim.keymap.set('n', '<F11>', function() dap.step_into() end,{ desc = "Debug step into" })
vim.keymap.set('n', '<Leader>rr', function() dap.repl.open() end,{ desc = "[r]un [r]eplay" })
vim.keymap.set('n', '<Leader>rl', function() dap.run_last() end,{ desc = "[r]un [l]ast" })
-- vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end,{ desc = "Toggle breakpoint" })
vim.keymap.set('n', '<Leader>b', "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>",{ desc = "Toggle breakpoint" })

-- Build with conan
vim.keymap.set("n", "<Leader>cbx", ':AsyncRun cobx86<CR>', {desc = "Conan Build x86"})
vim.keymap.set("n", "<Leader>cbfx", ':AsyncRun cmake --build ./build/x86/Debug<CR>', {desc = "Conan Build Fast x86"})
vim.keymap.set("n", "<Leader>cix", ':AsyncRun coix86<CR>', {desc = "Conan Install x86"})
vim.keymap.set("n", "<Leader>ccx", ':AsyncRun cocx86<CR>', {desc = "Conan Create x86"})

vim.keymap.set("n", "<Leader>cba", ':AsyncRun cobarm<CR>', {desc = "Conan Build arm"})
vim.keymap.set("n", "<Leader>cbfa", ':AsyncRun cmake --build ./build/arm/Debug<CR>', {desc = "Conan Build Fast arm"})
vim.keymap.set("n", "<Leader>cia", ':AsyncRun coiarm<CR>', {desc = "Conan Install arm"})
vim.keymap.set("n", "<Leader>cca", ':AsyncRun cocarm<CR>', {desc = "Conan Create arm"})

vim.keymap.set("n", "<leader>cs", ":AsyncStop<CR>", { noremap = true, silent = true, desc = "Stop Async Command" })
-- flying through vim windows with alt+hjkl
-- Insert mode mappings
vim.api.nvim_set_keymap('i', '<A-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<C-\\><C-n><C-w>l', { noremap = true })

-- Normal mode mappings
vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', { noremap = true })
vim.keymap.set('n', '<leader>tp', function()
  require("neotest").output.open({ enter = true })
end, { desc = "Open Neotest Output" })


-- quickfix list
-- Function to toggle quickfix window
local function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
  else
    vim.cmd "copen"
  end
end

-- Keymaps for quickfix navigation
vim.keymap.set("n", "<leader>co", toggle_quickfix, { noremap = true, silent = true, desc = "Toggle Quickfix" })
vim.keymap.set("n", "<leader>qn", ":cnewer<CR>", { noremap = true, silent = true, desc = "[Q]uickfix [N]ext List" })
vim.keymap.set("n", "<leader>qp", ":colder<CR>", { noremap = true, silent = true, desc = "[Q]uickfix [P]revious List" })
vim.keymap.set("n", "<leader>cn", ":cnext<CR>", { noremap = true, silent = true, desc = "Quickfix Next" })
vim.keymap.set("n", "<leader>cp", ":cprev<CR>", { noremap = true, silent = true, desc = "Quickfix Previous" })
vim.keymap.set("n", "<leader>cl", ":clast<CR>", { noremap = true, silent = true, desc = "Quickfix Last" })
vim.keymap.set("n", "<leader>tc", ":set ignorecase! ignorecase?<CR>", { noremap = true, silent = true, desc = "Toggle Case (Search)" })

-- Keymaps for buffer navigation
vim.api.nvim_set_keymap('n', '<leader>bca', ':%bd|e#|bd#<CR>', { noremap = true, silent = true , desc= "Buffer Close All"})
vim.api.nvim_set_keymap('n', '<leader>bcf', ':bd<CR>', { noremap = true, silent = true , desc= "Buffer Close"})

vim.keymap.set('n', '<leader>hh',':noh<CR>', { noremap = true, silent = true, desc = "Hide highlight" })
vim.keymap.set('n', '<A-H>', ':vertical resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-J>', ':resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-K>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-L>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gt', ':GitBlameToggle<CR>', { noremap = true, silent = true , desc= "GitBlame Toggle"})
vim.keymap.set("n", "<leader>gh", ":LazyGitFilterCurrentFile<CR>", { desc = "File history" })

vim.keymap.set('n', '<leader>dt', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print("Diagnostics enabled")
  else
    vim.diagnostic.disable()
    print("Diagnostics disabled")
  end
end, { silent = true, noremap = true ,desc= "Diagnostics Toggle"})

vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })
