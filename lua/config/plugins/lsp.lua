return {
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/lazydev.nvim',

      -- Status updates for LSP
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            override_vim_notify = true, -- Automatically override vim.notify() with Fidget
          },
        },
      },
    },
    config = function()
      --  This function gets run when an LSP connects to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>cr', vim.lsp.buf.rename, '[c]ode [r]ename')
          map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

          map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
          map('grr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[g]oto [I]mplementation')
          map('gy', require('telescope.builtin').lsp_type_definitions, '[g]oto t[y]pe Definition')
          map('<leader>fs', require('telescope.builtin').lsp_document_symbols, '[f]ind document [s]ymbols')
          map('<leader>fS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[f]ind workspace [S]ymbols')

          -- See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Lesser used LSP functionality
          map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
          map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
          map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
          map('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[w]orkspace [l]ist Folders')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            if client.name == 'ruff' then
              -- Disable hover in favor of basedpyright
              client.server_capabilities.hoverProvider = false
            end
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[t]oggle Inlay [h]ints')
          end
        end,
      })

      -- document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[c]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>f', group = '[f]earch' },
        { '<leader>f_', hidden = true },
        { '<leader>g', group = '[g]it' },
        { '<leader>g_', hidden = true },
        { '<leader>gh', group = '[g]it [h]unk' },
        { '<leader>gh_', hidden = true },
        { '<leader>t', group = '[t]oggle' },
        { '<leader>t_', hidden = true },
        { '<leader>w', group = '[w]orkspace' },
        { '<leader>w_', hidden = true },
      }
      -- register which-key VISUAL mode
      require('which-key').add { { '<leader>', group = 'VISUAL <leader>', mode = 'v' } }

      -- mason-lspconfig requires that these setup functions are called in this order
      -- before setting up the servers.
      require('mason').setup()
      require('mason-lspconfig').setup()

      -- Enable the following language servers
      local servers = {
        clangd = {},
        rust_analyzer = {},
        basedpyright = {},
        ruff = {},
        lua_ls = {},
        ts_ls = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        cssls = {},
        slint_lsp = {},
      }

      -- Setup neovim lua configuration
      require('lazydev').setup()

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      -- Lua LSP config
      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }
      -- Rust LSP config
      vim.lsp.config.rust_analyzer = {
        settings = {
          autoformat = true,
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
          },
        },
      }
      -- BasedPyright LSP config
      vim.lsp.config.basedpyright = {
        root_markers = {
          'pyrightconfig.json',
          'pyproject.toml',
          'setup.py',
          'setup.cfg',
          'Pipfile',
          '.git',
        },
        settings = {
          basedpyright = {
            -- Disable organize imports in favor of Ruff
            disableOrganizeImports = true,
            analysis = {
              typeCheckingMode = "standard", -- Prevent aggressive type annotation checks
              -- Avoid duplicate diagnostics already covered by Ruff
              diagnosticSeverityOverrides = {
                reportUnusedImport = "none",
                reportUnusedVariable = "none",
                -- Disable warnings related to not explicitly defining types
                reportUnknownParameterType = "none",
                reportUnknownArgumentType = "none",
                reportUnknownVariableType = "none",
                reportUnknownMemberType = "none",
                reportUnknownLambdaType = "none",
                reportMissingParameterType = "none",
                reportMissingTypeArgument = "none",
              },
            },
          },
        },
      }
      -- Disable legacy pyright server to prevent duplicate diagnostics/references
      vim.lsp.enable('pyright', false)
    end,
  },
}
