--------------------
-- Option Aliases --
--------------------
local cmd = vim.cmd
local indent = 2

------------------
-- Color scheme --
------------------
vim.o.termguicolors = true
vim.cmd [[set cursorline]] -- Highlight the current cursor line.

-- Theming.
-- Gruvbox settings.
vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_palette = 'original'
-- Everforest settings.
vim.g.everforest_background = 'soft'
-- Set theme.
vim.o.background = 'light'
vim.cmd [[colorscheme gruvbox-material]]

-- Statusbar
vim.cmd [[set noshowmode]] -- Use lightline to display the current mode.
vim.o.laststatus = 2
vim.g.lightline = {
    colorscheme = 'gruvbox_material',
    active = {
        left = {
            {'mode', 'paste'}, {'gitbranch', 'readonly', 'filename', 'modified'}
        }
    },
    component_function = {gitbranch = 'fugitive#head'}
}

----------------------
-- General Settings --
----------------------
vim.o.clipboard = 'unnamed,unnamedplus'
vim.o.encoding = 'utf-8'
vim.w.foldmethod = 'marker' -- Enable folding (default 'foldmarker').
vim.wo.number = true -- Line numbers on by default.
vim.wo.colorcolumn = '80' -- Line length marker at 80 columns.
vim.o.splitright = true -- Vertical split to the right.
vim.o.splitbelow = true -- Horizontal split to the bottom.
vim.o.cmdheight = 1 -- Number of screen lines to use for the command line.

-- Tabs, indentation, and line breaks.
vim.o.breakindent = true -- Visually indent wrapped lines.
vim.b.expandtab = true -- Use spaces instead of tabs.
vim.o.linebreak = true -- Don't break lines in the middle of a word.
vim.b.shiftwidth = 2 -- Shift characters by 2 spaces (by default).
vim.b.smartindent = true -- Auto-indent new lines.
vim.b.tabstop = 2 -- 1 tab == 2 spaces (by default).
 
-- Indent by an additional 2 characters on wrapped lines.
-- 
-- When a line is >= 80 characters, put 'showbreak' at the start.
--
-- TODO: Try this out.
-- vim.b.breakindentopt=shift:2,min:40,sbr
-- -- Prepend '>>' to line-wrapped indentations.
-- vim.b.showbreak = '>>'

-- Syntax formatting and highlighting
vim.cmd 'filetype plugin indent on' -- Enable per-filetype indentation.
vim.o.syntax = 'enable' -- Enable syntax highlighting.
vim.o.showmatch = true -- Highlight matching parentheses.

-- Misc.
vim.o.backspace = 'indent,eol,start'
vim.o.mouse = 'a' -- Mice are good (sometimes).

-- Performance - Memory, CPU, etc.
vim.o.hidden = true -- Enable background buffers.
vim.o.history = 100 -- Remember n lines in history.
vim.o.lazyredraw = true -- Faster scrolling.
vim.b.synmaxcol = 240 -- Max column for syntax highlight.

------------
-- Search --
------------
-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = false

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- TODO: Port this to lua-based config
-- ---------------
-- ---- Haskell --
-- ---------------
-- -- let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
-- -- let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
-- -- let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
-- -- let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
-- -- let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
-- -- let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
-- -- let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
