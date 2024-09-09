return {
  'nvimtools/none-ls.nvim',
  lazy = true,
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jay-babu/mason-null-ls.nvim',
  },
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
    if not null_ls_status_ok then
      return
    end

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    -- https://github.com/prettier-solidity/prettier-plugin-solidity
    null_ls.setup {
      debug = false,
      sources = {
        formatting.black.with { extra_args = { '--fast' } },
        formatting.golines.with {
          extra_args = { '--base-formatter', 'gofumpt' },
        },
        formatting.stylua,
        formatting.prettierd,
        formatting.shfmt,
        -- formatting.clang_format,
        -- formatting.terraform_fmt,

        require 'none-ls.diagnostics.eslint_d',
        require 'none-ls.diagnostics.flake8',

        -- diagnostics.golangci_lint,
        -- diagnostics.eslint_d,
      },
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr }
            end,
          })
        end
      end,
    }
  end,
}
