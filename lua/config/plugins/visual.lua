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
    config = function()
      require('gruvbox').setup {
        terminal_colors = true, -- add neovim terminal colors
        contrast = 'hard', -- can be "hard", "soft" or empty string
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
      }
      vim.o.background = 'dark' -- or "light" for light mode
      vim.cmd 'colorscheme gruvbox'
    end,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
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
