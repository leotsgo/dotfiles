return {
  'alexghergh/nvim-tmux-navigation',
  config = function()
    local nvim_tmux_nav = require 'nvim-tmux-navigation'

    nvim_tmux_nav.setup {
      disable_when_zoomed = true, -- defaults to false
    }

    vim.keymap.set('n', '<C-Left>', nvim_tmux_nav.NvimTmuxNavigateLeft)
    vim.keymap.set('n', '<C-Down>', nvim_tmux_nav.NvimTmuxNavigateDown)
    vim.keymap.set('n', '<C-Up>', nvim_tmux_nav.NvimTmuxNavigateUp)
    vim.keymap.set('n', '<C-Right>', nvim_tmux_nav.NvimTmuxNavigateRight)
    vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
    vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateNext)
  end,
}
