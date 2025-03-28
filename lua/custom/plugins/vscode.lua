return {
  'Mofiqul/vscode.nvim',
  config = function()
    vim.o.background = 'dark' -- or 'light' for light mode
    vim.cmd 'colorscheme vscode'
  end,
}
