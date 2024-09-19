require("neotest").setup({
  adapters = {
    require("neotest-gtest").setup({
      root_files = { "CMakeLists.txt", "Makefile", ".git" },
      build_directory = "build/x86/Debug",
      debug_adapter = "lldb",
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

