return {
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  { 'echasnovski/mini.icons', opts = {} },
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  -- To punish me.
  { 'm4xshen/hardtime.nvim', opts = {} },

  {
    -- I just vibe with this theme
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
}
