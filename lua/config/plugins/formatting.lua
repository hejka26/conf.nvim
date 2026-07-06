return {
  -- Formatter support
  {
    'stevearc/conform.nvim',
    dependencies = {
      -- autoinstall formatters
      { 'zapling/mason-conform.nvim', opts = {} },
    },
    config = function()
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          cpp = { 'clang-format' },
          rust = { 'rustfmt', lsp_format = 'fallback' },
          javascript = { 'biome' },
          typescript = { 'biome' },
          css = { 'biome' },
          html = { 'prettier' },
          python = { 'ruff_organize_imports', 'ruff_format' },
        },
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = 'fallback',
        },
      }
    end,
  },
}
