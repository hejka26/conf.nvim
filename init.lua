--[[

  ░░░    ░░ ░░░░░░░  ░░░░░░      ░░    ░░ ░░ ░░░    ░░░ 
  ▒▒▒▒   ▒▒ ▒▒      ▒▒    ▒▒     ▒▒    ▒▒ ▒▒ ▒▒▒▒  ▒▒▒▒ 
  ▒▒ ▒▒  ▒▒ ▒▒▒▒▒   ▒▒    ▒▒     ▒▒    ▒▒ ▒▒ ▒▒ ▒▒▒▒ ▒▒ 
  ▓▓  ▓▓ ▓▓ ▓▓      ▓▓    ▓▓      ▓▓  ▓▓  ▓▓ ▓▓  ▓▓  ▓▓ 
  ██   ████ ███████  ██████        ████   ██ ██      ██ 

  My personal neovim config based on Kickstart.nvim

  Guide for Lua:
  - https://learnxinyminutes.com/docs/lua/

  Neovim specific help you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: Plugin configuration and list is in seperate folder
  require 'config.plugins.git',

  require 'config.plugins.code-basics',

  require 'config.plugins.visual',

  require 'config.plugins.telescope',

  require 'config.plugins.debug',

  -- NOTE: Following line can supposedly auto import all lua files from set folder, need to figure it out
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Don't highlight every match on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Shows completion menu when there's only one match and dosn't auto select
vim.o.completeopt = 'menuone,noselect'

-- Increase range of colors
vim.o.termguicolors = true

-- Disable linewrapping (Sin)
vim.o.wrap = false

require 'config.keymaps'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Load configuration for fuzzy finder
require 'config.telescope'

require 'config.code-basics'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
