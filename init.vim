" =====================================================
" Unified Neovim Config (init.vim) - Java / C# / WebDev
" =====================================================

" ---------- General Settings ----------
set nocompatible
filetype plugin indent on
syntax on
set termguicolors
"set number
set number relativenumber
set tabstop=4 shiftwidth=4 expandtab
set autoindent smartindent
set cursorline
set mouse=a
set clipboard=unnamedplus

let mapleader=" "

" Save shortcut
noremap <Leader>s :w<CR>

" ---------- Plugin Manager ----------
call plug#begin(stdpath('data') . '/plugged')

" --- UI ---
Plug 'morhetz/gruvbox'                " Colorscheme option 1
Plug 'folke/tokyonight.nvim'          " Colorscheme option 2
Plug 'sainnhe/everforest'             " Colorscheme option 3
Plug 'nvim-lualine/lualine.nvim'      " Statusline
Plug 'nvim-tree/nvim-tree.lua'        " File explorer
Plug 'nvim-tree/nvim-web-devicons'    " Icons

" --- Navigation ---
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" --- Syntax ---
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" --- Completion ---
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind.nvim'
Plug 'rafamadriz/friendly-snippets'

" --- Autopairs ---
Plug 'jiangmiao/auto-pairs'           " Simpler autopairs
Plug 'windwp/nvim-autopairs'          " Smarter autopairs (with cmp integration)

" --- LSP & Mason ---
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" --- Debugging (C# / others) ---
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'williamboman/mason-nvim-dap.nvim'

" --- Formatting / Linting ---
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

call plug#end()

" ---------- Colors ----------
" Choose your theme:
"colorscheme gruvbox
" colorscheme tokyonight
 colorscheme everforest

" ---------- Keymaps ----------
nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-f> <cmd>Telescope live_grep<cr>

" =====================================================
" LUA CONFIGS
" =====================================================

lua << EOF
-------------------------------------------------------
-- Mason Setup
-------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "jdtls",     -- Java
    "omnisharp", -- C#
    "ts_ls",  -- Mason package (maps to ts_ls)
    "html",
    "cssls"
  }
}

-- JAVA & SNIPPETS
require("luasnip.loaders.from_vscode").lazy_load()

-------------------------------------------------------
-- CMP Setup (completion)
-------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"]   = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"]    = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-b>"]   = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]   = cmp.mapping.scroll_docs(4),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = { format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 }) }
})

-- Cmdline completion
cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })
cmp.setup.cmdline(":", { mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) })

-------------------------------------------------------
-- Autopairs
-------------------------------------------------------
local npairs = require("nvim-autopairs")
npairs.setup({})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    disable = { "c_sharp" }, -- ✅ disable only for C#
  }
}

-------------------------------------------------------
-- LSP Configurations
-------------------------------------------------------
local lspconfig = require("lspconfig")

-- Java
lspconfig.jdtls.setup { capabilities = capabilities }

-- C# with OmniSharp
lspconfig.omnisharp.setup {
  cmd = { "C:/tools/omnisharp-win-x64/OmniSharp.exe", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  capabilities = capabilities,
  enable_editorconfig_support = true,
  enable_ms_build_load_projects_on_demand = true,
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
  sdk_include_prereleases = true,
  analyze_open_documents_only = false,
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
  end,
}

-- Web (JS/TS, HTML, CSS)
lspconfig.ts_ls.setup { capabilities = capabilities }
lspconfig.html.setup   { capabilities = capabilities }
lspconfig.cssls.setup  { capabilities = capabilities }

-------------------------------------------------------
-- Treesitter
-------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "json", "markdown", "javascript", "typescript", "html", "css", "c_sharp" },
  highlight = { enable = true },
  indent = { enable = true }
}

-------------------------------------------------------
-- Lualine
-------------------------------------------------------
require("lualine").setup { options = { theme = "gruvbox" } }

-------------------------------------------------------
-- Debugger
-------------------------------------------------------
require("mason-nvim-dap").setup { ensure_installed = { "netcoredbg" } }

EOF

" =====================================================
" Formatting
" =====================================================
" Format web files on save
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.html,*.json PrettierAsync

" =====================================================
" Transparency (use terminal background instead of theme bg)
" =====================================================
augroup TransparentBG
  autocmd!
  " apply right now (in case colorscheme already loaded)
  silent! hi Normal       ctermbg=NONE guibg=NONE
  silent! hi NormalNC     ctermbg=NONE guibg=NONE
  silent! hi SignColumn   ctermbg=NONE guibg=NONE
  silent! hi EndOfBuffer  ctermbg=NONE guibg=NONE
  silent! hi LineNr       ctermbg=NONE guibg=NONE
  silent! hi CursorLineNr ctermbg=NONE guibg=NONE
  silent! hi NonText      ctermbg=NONE guibg=NONE
  silent! hi NormalFloat  ctermbg=NONE guibg=NONE
  silent! hi FloatBorder  ctermbg=NONE guibg=NONE
  silent! hi Pmenu        ctermbg=NONE guibg=NONE
  silent! hi PmenuSel     ctermbg=NONE guibg=NONE
  silent! hi CursorColumn ctermbg=NONE guibg=NONE
  silent! hi ColorColumn  ctermbg=NONE guibg=NONE
  silent! hi VertSplit    ctermbg=NONE guibg=NONE

  " re-apply whenever a colorscheme loads
  autocmd ColorScheme * silent! hi Normal       ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi NormalNC     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi SignColumn   ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi EndOfBuffer  ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi LineNr       ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi CursorLineNr ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi NonText      ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi NormalFloat  ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi FloatBorder  ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi Pmenu        ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi PmenuSel     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi CursorColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi ColorColumn  ctermbg=NONE guibg=NONE
  autocmd ColorScheme * silent! hi VertSplit    ctermbg=NONE guibg=NONE
augroup END


