return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Auto close pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Commenting utility
  { 'numToStr/Comment.nvim', opts = {} },

  -- Live reload HTML, CSS, and JavaScript files
  { 'barrett-ruth/live-server.nvim' },

  -- Color picker
  { 'ziontee113/color-picker.nvim', opts = {} },

  -- Slint UI framework support
  { 'slint-ui/vim-slint' },

  -- File explorer
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
