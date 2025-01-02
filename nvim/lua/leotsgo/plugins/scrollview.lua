return {
  'dstein64/nvim-scrollview',
  lazy = false,
  config = function()
    require('scrollview').setup {
      signs_on_startup = { 'all' },
    }
  end,
}
