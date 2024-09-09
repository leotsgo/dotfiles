return {
  'simrat39/rust-tools.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  config = function()
    local rt = require 'rust-tools'

    rt.setup {
      server = {
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set('n', 'K', rt.hover_actions.hover_actions, { buffer = bufnr, desc = 'Hover Actions' })
          -- Code action groups
          vim.keymap.set('n', '<leader>C', rt.code_action_group.code_action_group, { buffer = bufnr, desc = 'Code Action Group' })
        end,
      },
      dap = {
        adapter = {
          type = 'executable',
          command = 'lldb-vscode',
          name = 'rt_lldb',
        },
      },
    }
  end,
}
