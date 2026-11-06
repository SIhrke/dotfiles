-- [[ Configure Treesitter ]]
-- nvim-treesitter's `main` branch (what lazy-lock.json pins to) is a full,
-- incompatible rewrite: the old `require('nvim-treesitter.configs').setup{}`
-- API (ensure_installed/highlight/indent/textobjects in one table) no
-- longer exists. Parser install and feature-enabling are now separate,
-- explicit steps. Requires Neovim >= 0.12 (the rewrite's own requirement).
--
-- NOTE: the old `incremental_selection` feature (<c-space>/<c-s>/<M-space>
-- to grow/shrink selection by AST node) has no equivalent in the new API or
-- in core treesitter yet - dropped, not ported.

-- install() is async and a no-op for already-installed parsers (fast on every
-- normal startup); :wait() only actually blocks the first time, while a
-- parser is being downloaded/compiled. Without it, plugin/neotest.lua's
-- (pcall-guarded) cpp-parser lookup races ahead of this on a fresh profile.
require('nvim-treesitter').install({
  'c', 'cpp', 'go', 'lua', 'python', 'rust',
  'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
}):wait(300000)

-- Highlighting + indentation are opt-in per buffer now; `vim.treesitter.start()`
-- already resolves language from filetype and is a no-op error for
-- filetypes without an installed parser, hence the pcall.
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- [[ Configure Treesitter textobjects ]]
-- Replaces the old `textobjects = {...}` sub-table; same keymaps as before.
require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
}

local ts_select = require('nvim-treesitter-textobjects.select')
vim.keymap.set({ 'x', 'o' }, 'aa', function() ts_select.select_textobject('@parameter.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ia', function() ts_select.select_textobject('@parameter.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'af', function() ts_select.select_textobject('@function.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'if', function() ts_select.select_textobject('@function.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ac', function() ts_select.select_textobject('@class.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ic', function() ts_select.select_textobject('@class.inner', 'textobjects') end)

local ts_move = require('nvim-treesitter-textobjects.move')
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() ts_move.goto_next_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() ts_move.goto_next_start('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function() ts_move.goto_next_end('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '][', function() ts_move.goto_next_end('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() ts_move.goto_previous_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() ts_move.goto_previous_start('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function() ts_move.goto_previous_end('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[]', function() ts_move.goto_previous_end('@class.outer', 'textobjects') end)

local ts_swap = require('nvim-treesitter-textobjects.swap')
vim.keymap.set('n', '<leader>a', function() ts_swap.swap_next('@parameter.inner') end)
vim.keymap.set('n', '<leader>A', function() ts_swap.swap_previous('@parameter.inner') end)
