return {
  -- Autocompletion
  {
    'Saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
          local luasnip = require 'luasnip'
          require('luasnip.loaders.from_vscode').lazy_load()
          luasnip.config.setup {}
        end,
      },
    },
    config = function()
      require('blink.cmp').setup {
        keymap = {
          -- See :h blink-cmp-config-keymap for defining your own keymap
          preset = 'default',

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
        },

        completion = {
          -- By default, you may press `<c-space>` to show the documentation.
          -- Optionally, set `auto_show = true` to show the documentation after a delay.
          documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'lazydev' },
          providers = {
            lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          },
        },

        snippets = { preset = 'luasnip' },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },

        fuzzy = { implementation = 'prefer_rust_with_warning' },
      }
    end,
  },
}
