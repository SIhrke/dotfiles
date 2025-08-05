require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  -- async run for compiling with quickfixlist
  {
    'skywind3000/asyncrun.vim',
    lazy = false,
    config = function()
      vim.g.asyncrun_open = 8 -- Set height of quickfix window
    end
  },

  'hrsh7th/cmp-buffer',
  --"HiPhish/rainbow-delimiters.nvim",
  -- minimap
  'dstein64/nvim-scrollview',
  --{
  --  "lukas-reineke/indent-blankline.nvim",
  --  main = "ibl",
  --  ---@module "ibl"
  --  ---@type ibl.config
  --  opts = {},
  --},
  {
    "gbprod/substitute.nvim",
    opts = {}
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "alfaix/neotest-gtest"
    },
    config = function()
      -- Configuration will be added here
    end,
  },
  --tabs
  -- {
  --  'romgrk/barbar.nvim',
  --  dependencies = {
  --    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --  },
  --  init = function() vim.g.barbar_auto_setup = false end,
  --  opts = {
  --    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
  --     animation = true
  --    -- insert_at_start = true,
  --    -- …etc.
  --  },
  --  version = '^1.0.0', -- optional: only update when a new 1.x version is released
  --},
  -- Git related plugins   
  --'tpope/vim-fugitive',
  --'tpope/vim-rhubarb',
  'f-person/git-blame.nvim',

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, noremap = true })
    end,
  },
  --debug adapter
  'mfussenegger/nvim-dap',
  'nvim-neotest/nvim-nio',
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp'

    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require("onedark").setup {
        style = 'deep'
      }
      require('onedark').load()
    end,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'horizon',
      },
    },
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },{
    'nvim-tree/nvim-web-devicons',
    config = function()
      require("nvim-web-devicons").setup {
        override = {
          qml = {
            icon = "",
            color = "#AAFF00",
            name = "qml"
          }
        };
      }
    end,
  },
  {
    -- Highlight, edit, and navigate code

    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        actions = {
          open_file = {
            window_picker = {
              enable = false  -- Disable the window picker
            }
          }
        },
        filters = {
          git_ignored = false, -- Set this to false to show gitignored files
        },
        update_focused_file = {
          enable = true,
        }
      }
    end,
  }
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})
require("plugin_config.telescope")
require("plugin_config.treesitter")
require("plugin_config.lsp")
require("plugin_config.luasnip")
require("plugin_config.neotest")
require("plugin_config.dap")
--require("plugin_config.ibl")
--require('rainbow-delimiters.setup').setup {}
