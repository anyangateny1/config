-- Basic Options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.wo.relativenumber = true

-- Basic Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-s>', ':wa<CR>', { silent = true, desc = 'Save all buffers' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Install lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require('lazy').setup({
  -- Core plugins
  'tpope/vim-sleuth',
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        -- Basic navigation and editing
        { "<Esc>", desc = "Clear search highlights" },
        { "<C-s>", desc = "Save all buffers" },
        { "<C-d>", desc = "Scroll down (centered)" },
        { "<C-u>", desc = "Scroll up (centered)" },
        { "<C-h>", desc = "Move to left window" },
        { "<C-j>", desc = "Move to lower window" },
        { "<C-k>", desc = "Move to upper window" },
        { "<C-l>", desc = "Move to right window" },
        
        -- Terminal mode
        { "<Esc><Esc>", desc = "Exit terminal mode", mode = "t" },
        
        -- Leader key groups
        { "<leader>c", group = "[C]ode" },
        { "<leader>ca", desc = "Code [A]ctions" },
        { "<leader>ch", desc = "Go to [H]eader declaration" },
        { "<leader>ct", desc = "Go to [T]ype definition" },
        { "<leader>ci", desc = "[C]onform [I]nfo - Debug formatter" },
        
        { "<leader>d", group = "[D]ocument" },
        { "<leader>ds", desc = "[D]ocument [S]ymbols" },
        { "<leader>D", desc = "Type [D]efinition" },
        
        { "<leader>f", desc = "[F]ormat buffer" },
        
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        
        { "<leader>q", desc = "Open diagnostic quickfix list" },
        
        { "<leader>r", group = "[R]ename" },
        { "<leader>rn", desc = "[R]e[n]ame symbol" },
        
        { "<leader>s", group = "[S]earch" },
        { "<leader>sh", desc = "[S]earch [H]elp" },
        { "<leader>sk", desc = "[S]earch [K]eymaps" },
        { "<leader>sf", desc = "[S]earch [F]iles" },
        { "<leader>ss", desc = "[S]earch [S]elect Telescope" },
        { "<leader>sw", desc = "[S]earch current [W]ord" },
        { "<leader>sg", desc = "[S]earch by [G]rep" },
        { "<leader>sd", desc = "[S]earch [D]iagnostics" },
        { "<leader>sr", desc = "[S]earch [R]esume" },
        { "<leader>s.", desc = "[S]earch Recent Files" },
        { "<leader>s/", desc = "[S]earch in Open Files" },
        { "<leader>sn", desc = "[S]earch [N]eovim files" },
        
        { "<leader>t", group = "[T]oggle" },
        { "<leader>th", desc = "[T]oggle Inlay [H]ints" },
        
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>ws", desc = "[W]orkspace [S]ymbols" },
        
        { "<leader>/", desc = "Fuzzily search in current buffer" },
        { "<leader><leader>", desc = "Find existing buffers" },
        
        -- LSP navigation
        { "g", group = "[G]oto" },
        { "gd", desc = "[G]oto [D]efinition" },
        { "gr", desc = "[G]oto [R]eferences" },
        { "gI", desc = "[G]oto [I]mplementation" },
        { "gD", desc = "[G]oto [D]eclaration" },
        
        -- Hover documentation
        { "K", desc = "Hover Documentation" },
        
        -- Completion mappings (insert mode)
        { "<C-n>", desc = "Next completion item", mode = "i" },
        { "<C-p>", desc = "Previous completion item", mode = "i" },
        { "<C-b>", desc = "Scroll docs up", mode = "i" },
        { "<C-f>", desc = "Scroll docs down", mode = "i" },
        { "<C-y>", desc = "Confirm completion", mode = "i" },
        { "<C-Space>", desc = "Complete", mode = "i" },
        { "<C-l>", desc = "Snippet jump forward", mode = { "i", "s" } },
        { "<C-h>", desc = "Snippet jump backward", mode = { "i", "s" } },
      },
    },
  },
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { 'node_modules' },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -- Telescope keymaps
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  -- LSP Configuration
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Simple server configurations
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        clangd = {
          cmd = { 
            'clangd', 
            '--compile-commands-dir=build',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            '--clang-tidy',
            '--all-scopes-completion',
            '--cross-file-rename',
            '--log=info',
            '--background-index',
            '--pch-storage=memory',
            '--enable-config',
            '--header-insertion-decorators',
            '--suggest-missing-includes',
          },
          filetypes = { 'c', 'cpp' },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          on_attach = function(client, bufnr)
            vim.env.C_INCLUDE_PATH = '/usr/lib/x86_64-linux-gnu/openmpi/include:/usr/include'
            vim.env.LD_LIBRARY_PATH = '/usr/lib/x86_64-linux-gnu:/usr/local/lib'
            
            -- Enhanced keymap to go to header file declaration (like VSCode)
            vim.keymap.set('n', '<leader>ch', function()
              -- Use LSP to go to declaration (header file)
              vim.lsp.buf.declaration()
            end, { desc = 'Go to header declaration', buffer = bufnr })
            
            -- Alternative keymap for type definition (shows the actual type in headers)
            vim.keymap.set('n', '<leader>ct', function()
              vim.lsp.buf.type_definition()
            end, { desc = 'Go to type definition', buffer = bufnr })
          end,
        },
      }

      -- Setup LSP servers manually to avoid automatic_enable issues
      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
        require('lspconfig')[server_name].setup(server_config)
      end

      -- Setup tool installer separately
      require('mason-tool-installer').setup {
        ensure_installed = { 'lua_ls', 'clangd', 'stylua', 'clang-format' },
      }
    end,
  },
  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      {
        '<leader>ci',
        '<cmd>ConformInfo<cr>',
        desc = '[C]onform [I]nfo - Debug formatter info',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        cpp = { 'clang-format' },
      },
      formatters = {
        ['clang-format'] = {
          -- Ensure clang-format uses the directory containing .clang-format as working directory
          cwd = function(self, ctx)
            local style_file = vim.fs.find('.clang-format', {
              path = ctx.filename,
              upward = true,
            })[1]
            
            local working_dir
            if style_file then
              -- Use the directory containing the .clang-format file
              working_dir = vim.fn.fnamemodify(style_file, ':h')
            else
              -- Fallback to current file's directory
              working_dir = vim.fn.fnamemodify(ctx.filename, ':h')
            end
            
            -- Log the working directory
            print("🔧 clang-format working directory: " .. working_dir)
            return working_dir
          end,
          -- Explicitly specify the style file
          args = function(self, ctx)
            local style_file = vim.fs.find('.clang-format', {
              path = ctx.filename,
              upward = true,
            })[1]
            
            local args
            if style_file then
              args = { '-style=file:' .. style_file }
              print("🎨 Using .clang-format file: " .. style_file)
            else
              args = { '-style=file' }
              print("⚠️  No .clang-format found, using default style search")
            end
            
            -- Log the full command that will be executed
            print("📝 clang-format args: " .. table.concat(args, " "))
            return args
          end,
        },
      },
    },
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
        window = {
          completion = {
            max_height = 10,
            scrollbar = true,
          },
          documentation = {
            max_width = 60,
          },
        },
      }
    end,
  },
  -- Highlight todo, notes in comments
  { 'folke/todo-comments.nvim', event = 'vimenter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  -- Mini plugins collection
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  -- Treesitter for syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':tsupdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Load clang-format debug utility for WSL troubleshooting
require('custom.clang-format-debug')

-- Auto-remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.cpp', '*.h', '*.hpp', '*.c', '*.cc', '*.cxx' },
  callback = function()
    -- Save cursor position
    local save_cursor = vim.fn.getpos('.')
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos('.', save_cursor)
  end,
  desc = 'Remove trailing whitespace from C++ files before save',
})
