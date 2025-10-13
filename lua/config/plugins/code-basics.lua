return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/lazydev.nvim',

      --Status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            override_vim_notify = true, -- Automatically override vim.notify() with Fidget
          },
        },
      },
    },
  },
  {
    -- Autocompletion
    'Saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      -- NOTE: nvim-cmp requires snipper engine to be installed, should have checked before removing it.
      'L3MON4D3/LuaSnip',
    },
  },

  -- Add region to code implementation
  { 'numToStr/Comment.nvim', opts = {} },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- Formatter support
  {
    'stevearc/conform.nvim',
    dependencies = {
      -- autoinstall formatters
      { 'zapling/mason-conform.nvim', opts = {} },
    },
  },

  -- Live reload HTML, CSS, and JavaScript files
  { 'barrett-ruth/live-server.nvim', opts = {} },
  -- Mostly for webdev tbh
  { 'ziontee113/color-picker.nvim', opts = {} },
}
