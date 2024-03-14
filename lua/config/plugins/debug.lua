return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Adds UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters automatically
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Section to add debugger extensions
    'leoluz/nvim-dap-go',
    'simrat39/rust-tools.nvim',
    'mfussenegger/nvim-dap-python',

    -- Dependency for rust tools
    'nvim-lua/plenary.nvim',
  },
  'jay-babu/mason-nvim-dap.nvim',
}
