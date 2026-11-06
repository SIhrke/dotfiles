-- neotest-gtest requires the compiled treesitter "cpp" parser at setup
-- time. plugin/ files load alphabetically, so this runs before
-- plugin/treesitter.lua ever gets a chance to install it - on a brand new
-- nvim data dir (parsers not yet compiled) this throws instead of just
-- degrading gracefully. pcall it so a cold profile gets a one-line nudge
-- instead of a full stack trace; re-open the file once TSInstall finishes.
local ok, err = pcall(function()
  require("neotest").setup({
    adapters = {
      require("neotest-gtest").setup({
        root_files = { "CMakeLists.txt", "Makefile", ".git" },
         -- Accept both lowercase test_*.cpp and capital Test*.cpp
        is_test_file = function(file)
          -- Extract just the filename
          local name = file:match("^.+/(.+)$") or file
          -- Match either test_*.cpp or Test*.cpp
          return name:match("^test_.*%.cpp$") or name:match("^Test.*%.cpp$")
        end,
        debug_adapter = "codelldb",
        args = { "--gtest_color=yes" },
        filter_dir = function(name)
          return name ~= "build"
        end
      })
    },
    summary= {
        open = "botright vsplit | vertical resize 70"
    },
    -- Other neotest configurations
    log_level=vim.log.levels.DEBUG,
    output = { enabled=true, open_on_run=true},

  })
end)

if not ok then
  vim.notify("neotest setup failed (likely missing treesitter parser on a fresh install) - re-open nvim once :TSUpdate finishes\n" .. tostring(err), vim.log.levels.WARN)
end

