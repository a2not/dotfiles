vim.g.gruvbox_material_transparent_background = 1

return {
  {
    'sainnhe/gruvbox-material',
    enabled = false,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}
