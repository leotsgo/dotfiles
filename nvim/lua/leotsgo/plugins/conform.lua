return {
  { -- Format on save / <leader>f (replaces none-ls formatters)
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      formatters_by_ft = {
        python = { 'black' },
        go = { 'golines' },
        lua = { 'stylua' },
        luau = { 'stylua' },
        sh = { 'shfmt' },
        elixir = { 'mix' },
        heex = { 'mix' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        vue = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        less = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        ['markdown.mdx'] = { 'prettierd' },
        graphql = { 'prettierd' },
        handlebars = { 'prettierd' },
        svelte = { 'prettierd' },
        astro = { 'prettierd' },
        htmlangular = { 'prettierd' },
      },
      formatters = {
        black = { prepend_args = { '--fast' } },
        golines = { prepend_args = { '--base-formatter', 'gofumpt' } },
      },
      -- Format on save when a formatter is configured, else use the LSP.
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = 'fallback',
      },
    },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = { 'n', 'x' },
        desc = 'Format buffer',
      },
    },
  },

  { -- Linting (replaces none-ls diagnostics)
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('lint').linters_by_ft = {
        python = { 'flake8' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
