-- Cấu hình cho GUI Neovim (neovim-qt)
local M = {}

function M.setup()
  if vim.fn.exists('g:GuiLoaded') == 1 then
    -- Cấu hình font
    vim.g.fontsize = 11
    vim.g.fontname = 'JetBrainsMono NFM'
    vim.cmd('GuiFont! ' .. vim.g.fontname .. ':h' .. vim.g.fontsize)
  end
end

return M