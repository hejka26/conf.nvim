return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Adds UI
    'rcarriga/nvim-dap-ui',
    -- Dependency of dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters automatically
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Section to add debugger extensions
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',

    -- Dependency for rust tools
    'nvim-lua/plenary.nvim',
  },
}
