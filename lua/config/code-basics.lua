-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>cr', vim.lsp.buf.rename, '[c]ode [r]ename')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[g]oto [I]mplementation')
  nmap('gy', require('telescope.builtin').lsp_type_definitions, '[g]oto t[y]pe Definition')
  nmap('<leader>fs', require('telescope.builtin').lsp_document_symbols, '[f]ind document [s]ymbols')
  nmap('<leader>fS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[f]ind workspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[g]oto [d]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[w]orkspace [l]ist Folders')
end

-- document existing key chains
require('which-key').add ({
    { "<leader>c", group = "[c]ode" },
    { "<leader>c_", hidden = true },
    { "<leader>f", group = "[f]earch" },
    { "<leader>f_", hidden = true },
    { "<leader>g", group = "[g]it" },
    { "<leader>g_", hidden = true },
    { "<leader>gh", group = "[g]it [h]unk" },
    { "<leader>gh_", hidden = true },
    { "<leader>w", group = "[w]orkspace" },
    { "<leader>w_", hidden = true },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').add({
    { "<leader>", group = "VISUAL <leader>", mode = "v" },
    { "<leader>gh", desc = "Git [H]unk", mode = "v" },
}, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {
    settings = {
      ['rust_analyzer'] = {
        check = {
          command = 'clippy',
        },
      },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
  ts_ls = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  cssls = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
-- NOTE: The annotation on next line is needed due to treesitter mantainers not setting their god damn parameters as optional, why
---@diagnostic disable: missing-fields
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'go', 'lua', 'python', 'rust', 'vimdoc', 'bash', 'cpp', 'javascript', 'html', 'css', 'scss', 'glimmer' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>cs'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>cS'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)
---@diagnostic enable: missing-fields
require 'nvim-treesitter.configs'
-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
-- Needed for cmp to work
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
  },
}

--Setup code formatting
require('formatter').setup {
  logging = true,
  log_leve = vim.log.levels.WARN,
  filetype = {
    lua = {
      require('formatter.filetypes.lua').stylua(),
    },
    cpp = {
      require('formatter.filetypes.cpp').clangformat(),
    },
    js = {
      require('formatter.filetypes.javascript').biome(),
    },
    mjs = {
      require('formatter.filetypes.javascript').biome(),
    },
    cjs = {
      require('formatter.filetypes.javascript').biome(),
    },
    html = {
      require('formatter.filetypes.html').prettier(),
    },
    hbs = {
      require('formatter.filetypes.html').prettier(),
    },
    css = {
      require('formatter.filetypes.css').prettier(),
    },
    scss = {
      require('formatter.filetypes.css').prettier(),
    },
  },
}
-- Add auto format on save for formatter
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup('__formatter__', { clear = true })
autocmd('BufWritePost', {
  group = '__formatter__',
  command = ':FormatWriteLock',
})
