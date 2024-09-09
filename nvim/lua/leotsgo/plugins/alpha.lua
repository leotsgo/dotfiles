return {
  'goolord/alpha-nvim',
  enabled = true,
  event = 'VimEnter',
  lazy = true,
  config = function()
    local status_ok, alpha = pcall(require, 'alpha')
    if not status_ok then
      return
    end

    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
    }

    dashboard.section.buttons.val = {
      dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'),
      dashboard.button('e', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('p', ' ' .. ' Find project', ":lua require('telescope').extensions.projects.projects()<CR>"),
      dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
      dashboard.button('t', 'ﰍ ' .. ' Find text', ':Telescope live_grep <CR>'),
      dashboard.button('l', '鈴' .. ' Lazy', ':Lazy <CR>'),
      dashboard.button('s', ' ' .. ' Update TreeSitter', ':TSUpdate <CR>'),
      dashboard.button('m', '🝚 ' .. ' Open Mason', ':Mason <CR>'),
      dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
    }

    local function footer()
      return 'github.com/leonardodiber'
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = 'Type'
    dashboard.section.header.opts.hl = 'Include'
    dashboard.section.buttons.opts.hl = 'Keyword'

    dashboard.opts.opts.noautocmd = true

    dashboard.opts.layout = {
      { type = 'padding', val = 20 },
      dashboard.section.header,
      dashboard.section.buttons,
      dashboard.section.footer,
    }
    alpha.setup(dashboard.opts)
  end,
}
