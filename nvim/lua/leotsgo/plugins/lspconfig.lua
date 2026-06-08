return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp', -- capabilities (loaded before this config runs)
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- nvim 0.11+ / mason-lspconfig v2 API.
      -- The old `mason-lspconfig.setup{ handlers = {} }` pattern was REMOVED in v2.
      -- Servers are now auto-enabled (`automatic_enable`) using the configs
      -- registered via `vim.lsp.config()` below (merged over nvim-lspconfig defaults).
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Applied to every server.
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Per-server overrides.
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            completion = { callSnippet = 'Replace' },
          },
        },
      })

      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = { 'stylua' }, -- format lua
      }
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'gopls', 'pyright', 'clangd', 'ts_ls', 'eslint' },
        automatic_enable = true, -- enables installed servers via vim.lsp.enable
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
