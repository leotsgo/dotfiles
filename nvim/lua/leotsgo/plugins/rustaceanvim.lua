-- Successor to the archived rust-tools.nvim. Do NOT call a setup() function;
-- rustaceanvim is configured entirely through vim.g.rustaceanvim and lazy-loads
-- itself on the `rust` filetype.
return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false, -- plugin manages its own lazy-loading; don't lazy-load it
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          -- Hover actions (rustaceanvim's grouped hover)
          vim.keymap.set('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, { buffer = bufnr, desc = 'Rust Hover Actions' })
          -- Code action group
          vim.keymap.set('n', '<leader>C', function()
            vim.cmd.RustLsp 'codeAction'
          end, { buffer = bufnr, desc = 'Rust Code Action Group' })
        end,
        default_settings = {
          ['rust-analyzer'] = {},
        },
      },
      -- DAP: rustaceanvim auto-detects `codelldb` from mason if installed
      -- (the old lldb-vscode adapter name is gone). `:MasonInstall codelldb` to debug.
    }
  end,
  dependencies = {
    'mfussenegger/nvim-dap',
  },
}
