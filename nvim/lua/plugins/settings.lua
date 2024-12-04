-- Cấu hình cơ bản
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.mouse = 'a'
vim.opt.encoding = 'UTF-8'
vim.opt.background = 'dark'
vim.opt.clipboard = "unnamedplus"

-- Theme
require('onedark').setup {
    style = 'dark',
    transparent = true,
    term_colors = true,
}
require('onedark').load()

-- Nvim-tree
require('nvim-tree').setup()
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

-- LSP setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd', 'pyright' }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').clangd.setup{
  capabilities = capabilities
}
require('lspconfig').pyright.setup{
  capabilities = capabilities
}

-- Cấu hình Gitsigns
require('gitsigns').setup({
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
})

-- Thêm keymaps cho Gitsigns
local gs = package.loaded.gitsigns

vim.keymap.set('n', ']c', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
end, {expr=true})

vim.keymap.set('n', '[c', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
end, {expr=true})

-- Các phím tắt khác
vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
vim.keymap.set('n', '<leader>hS', gs.stage_buffer)
vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk)
vim.keymap.set('n', '<leader>hR', gs.reset_buffer)
vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end)
vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
vim.keymap.set('n', '<leader>hd', gs.diffthis)
vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)

-- Completion setup
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Lualine
require('lualine').setup()

-- Autopairs
require('nvim-autopairs').setup()

-- Cấu hình hiển thị diagnostic
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- Thay đổi các biểu tượng diagnostic
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Cấu hình Trouble
require("trouble").setup {
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = {"<cr>", "<tab>"},
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = {"o"},
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = {"zM", "zm"},
        open_folds = {"zR", "zr"},
        toggle_fold = {"zA", "za"},
        previous = "k",
        next = "j"
    },
    indent_lines = true,
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    auto_fold = false,
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = false
}

-- Phím tắt cho Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  {silent = true, noremap = true}
)

-- Hiển thị diagnostic khi di chuyển con trỏ
vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- Cấu hình rainbow-delimiters
local rainbow_delimiters = require('rainbow-delimiters')
require('rainbow-delimiters.setup').setup {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

-- Cấu hình Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    highlight = {
        enable = true,
    },
}

-- Cấu hình rainbow
vim.cmd([[highlight RainbowDelimiterRed guifg=#E06C75]])
vim.cmd([[highlight RainbowDelimiterYellow guifg=#E5C07B]])
vim.cmd([[highlight RainbowDelimiterBlue guifg=#61AFEF]])
vim.cmd([[highlight RainbowDelimiterOrange guifg=#D19A66]])
vim.cmd([[highlight RainbowDelimiterGreen guifg=#98C379]])
vim.cmd([[highlight RainbowDelimiterViolet guifg=#C678DD]])
vim.cmd([[highlight RainbowDelimiterCyan guifg=#56B6C2]])


-- Cấu hình mini.indentscope
require('mini.indentscope').setup({
    symbol = "│",
    options = { 
        try_as_border = true,
        border = 'both',
    },
    draw = {
        animation = require('mini.indentscope').gen_animation.none()
    }
})

-- Cấu hình Floaterm
vim.g.floaterm_shell = 'pwsh'
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_position = 'center'
vim.g.floaterm_borderchars = '─│─│╭╮╯╰'

-- Phím tắt cho Floaterm
vim.keymap.set('n', '<leader>ft', ':FloatermToggle<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:FloatermToggle<CR>')
vim.keymap.set('n', '<leader>fn', ':FloatermNew<CR>')
vim.keymap.set('n', '<leader>fp', ':FloatermPrev<CR>')
vim.keymap.set('n', '<leader>fk', ':FloatermKill<CR>')

-- Cấu hình Telescope
local telescope = require('telescope')
telescope.setup{
  defaults = {
    file_ignore_patterns = {"node_modules", ".git"},
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      }
    }
  }
}
-- Phím tắt cho Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

-- Cấu hình Which Key
require("which-key").setup{}

-- Cấu hình Todo Comments
require("todo-comments").setup{
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
}

-- Cấu hình DAP cho Python
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python') -- Đường dẫn đến Python trong virtualenv

-- Cấu hình DAP UI
require('dapui').setup()

-- Phím tắt cho DAP
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end)

-- Cấu hình null-ls
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.mypy,
    },
})
