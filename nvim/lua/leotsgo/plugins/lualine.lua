return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufRead', 'BufNewFile' },
  config = function()
    local status_ok, lualine = pcall(require, 'lualine')
    if not status_ok then
      return
    end

    -- https://gitlab.orion-technologies.io/philler/dots/-/blob/Development/dots/.nvim-environments/primary/config/lua/plugins/configs/statusline.lua
    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == '' then
        return ''
      else
        return 'Recording @' .. recording_register
      end
    end

    local macro_refresh_places = { 'statusline', 'winbar' }
    vim.api.nvim_create_autocmd('RecordingEnter', {
      callback = function()
        lualine.refresh {
          place = macro_refresh_places,
        }
      end,
    })

    vim.api.nvim_create_autocmd('RecordingLeave', {
      callback = function()
        local timer = vim.loop.new_timer()
        timer:start(
          5,
          0,
          vim.schedule_wrap(function()
            lualine.refresh {
              place = macro_refresh_places,
            }
          end)
        )
        timer:close()
      end,
    })

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    local codeium_status = function()
      return '{...}' .. vim.fn['codeium#GetStatusString']()
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ' },
      colored = false,
      always_visible = true,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = '', modified = '', removed = '' }, -- changes diff symbols
      cond = hide_in_width,
    }

    local filetype = {
      'filetype',
      icons_enabled = true,
      colored = false,
    }

    local location = {
      'location',
      padding = 0,
    }

    local filename = {
      'filename',
      path = 1,
    }

    local spaces = function()
      return 'spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth')
    end

    lualine.setup {
      options = {
        globalstatus = true,
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'alpha', 'dashboard' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          diagnostics,
          { 'macro-recording', fmt = show_macro_recording, color = { fg = '#8aadf4' } },
          -- { 'codeium', fmt = codeium_status },
          filename,
        },
        lualine_x = { diff, spaces, 'encoding', filetype },
        lualine_y = { location },
        lualine_z = { 'progress' },
      },
    }
  end,
}
