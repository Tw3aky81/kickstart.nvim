local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd('FileType', {
  pattern = 'netrw',
  group = augroup('netrw-custom', { clear = true }),
  callback = function()
    local function netrw_new_file()
      -- determine directory
      local dir = vim.b.netrw_curdir or ''
      if dir == '' then
        local lines = vim.api.nvim_buf_get_lines(0, 0, 5, false)
        for _, ln in ipairs(lines) do
          local s = ln:match 'Browsing%s+(.+)$'
          if s then
            dir = s
            break
          end
        end
      end
      if dir == '' then
        dir = vim.fn.getcwd()
      end

      -- prompt for file
      local name = vim.fn.input('New file (in ' .. dir .. '): ', '', 'file')
      if name == '' then
        return
      end
      local path = vim.fn.fnameescape(dir .. '/' .. name)

      -- if there is more than one window, jump to the next one (like netrw does)
      if vim.fn.winnr '$' > 1 then
        vim.cmd 'wincmd w' -- go to next window
      end

      vim.cmd('edit ' .. path)
    end

    vim.keymap.set('n', '%', netrw_new_file, { buffer = true, noremap = true })
  end,
})
