--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("plugins")
require("options")
require("keymaps")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Autocommand to run qmlformat on save for QML files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.qml",
  callback = function()
    local filename = vim.fn.expand("%:p")
    local cmd = string.format("qmlformat -i %s", filename)
    
    vim.fn.jobstart(cmd, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          print("QML formatting successful")
          -- Reload the buffer to show changes
          vim.cmd("e!")
        else
          print("QML formatting failed")
        end
      end,
      stdout_buffered = true,
      stderr_buffered = true,
    })
  end,
})
