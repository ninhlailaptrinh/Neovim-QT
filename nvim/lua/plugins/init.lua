-- Cài đặt Packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
  end
  
  local packer_bootstrap = ensure_packer()
  
  return require('packer').startup(function(use)
    -- Packer quản lý chính nó
    use 'wbthomason/packer.nvim'
  
    -- Theme
    use 'navarasu/onedark.nvim'
  
    -- File explorer
    use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons',
      },
    }
  
    -- LSP
    use {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'mfussenegger/nvim-dap', -- Debug Adapter Protocol
      'rcarriga/nvim-dap-ui', -- UI cho DAP
      'mfussenegger/nvim-dap-python', -- DAP cho Python
    }
  
    -- Autocompletion
    use {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'kmarius/jsregexp',
    }
  
    -- Status line
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons' }
    }
  
    -- Auto pairs
    use 'windwp/nvim-autopairs'
      
     -- Gitsigns
      use {
          'lewis6991/gitsigns.nvim',
          config = function()
              require('gitsigns').setup()
          end
      }
      
       -- Trouble.nvim và dependencies
      use {
          "folke/trouble.nvim",
          requires = "nvim-tree/nvim-web-devicons",
      }
  
      -- LSP colors
      use 'folke/lsp-colors.nvim'
  
          -- Rainbow brackets
      use 'HiPhish/rainbow-delimiters.nvim'
      
      -- Treesitter
      use {
          'nvim-treesitter/nvim-treesitter',
          run = ':TSUpdate'
      }
      
       -- Animation indent scope
      use { 'echasnovski/mini.indentscope', branch = 'stable' }
      
      -- Floaterm
      use 'voldikss/vim-floaterm'
  

    -- Telescope - Tìm kiếm file và text
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep'
      }
    }
  
    -- Comment code
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }
  
    -- Which key - hiển thị phím tắt
    use {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end
    }
  
    -- Todo comments
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
    }
  
    -- Thêm nvim-nio trước nvim-dap-ui
    use 'nvim-neotest/nvim-nio'
  
    -- Null-ls for linting and formatting
    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    }

    -- Black for Python formatting
    use 'psf/black'

    -- Improved Python indentation
    use 'Vimjas/vim-python-pep8-indent'
  
    if packer_bootstrap then
      require('packer').sync()
    end
  end)
  
