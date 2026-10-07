return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- rewrite: required on Neovim 0.12+ (master is locked to 0.11)
    lazy = false, -- main does not support lazy-loading
    build = ':TSUpdate',
    dependencies = {
      { 'HiPhish/rainbow-delimiters.nvim' },
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      -- Parsers install into stdpath('data')/site. Needs `tree-sitter-cli` >= 0.26.1.
      require('nvim-treesitter').install {
        'bash',
        'c',
        'html',
        'lua',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
        'yaml',
        'json',
        'javascript',
        'typescript',
        'python',
        'elixir',
        'heex',
        'eex',
      }

      -- Highlighting/indentation are provided by Neovim core since 0.12.
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
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

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
