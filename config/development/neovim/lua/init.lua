--------------------
-- Option Aliases --
--------------------
local cmd = vim.cmd
local indent = 2

------------------
-- Color scheme --
------------------
vim.opt.termguicolors = true
vim.cmd [[set cursorline]] -- Highlight the current cursor line.

-- Theming.
-- Gruvbox settings.
vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_palette = 'original'
-- Everforest settings.
vim.g.everforest_background = 'soft'
-- Set theme.
vim.opt.background = 'light'
vim.cmd [[colorscheme gruvbox-material]]

-- Status bar.
vim.cmd [[set noshowmode]] -- Use lightline to display the current mode.
vim.opt.laststatus = 2
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
vim.opt.cmdheight = 1 -- Number of screen lines to use for the command line.
vim.opt.clipboard = 'unnamed,unnamedplus'
vim.opt.encoding = 'utf-8'
vim.opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker').
vim.opt.number = true -- Line numbers on by default.
vim.opt.colorcolumn = '80' -- Line length marker at 80 columns.
vim.opt.splitright = true -- Vertical split to the right.
vim.opt.splitbelow = true -- Horizontal split to the bottom.

-- Tabs, indentation, and line breaks.
vim.opt.breakindent = true -- Visually indent wrapped lines.
vim.opt.breakindentopt = {shift=2, min=40, sbr=true} -- TODO: Documentation.
vim.opt.expandtab = true -- Use spaces instead of tabs.
vim.opt.linebreak = true -- Don't break lines in the middle of a word.
vim.opt.shiftwidth = 2 -- Shift characters by 2 spaces (by default).
vim.opt.showbreak = '>> ' -- Prepend wrapped lines with '>> '.
vim.opt.smartindent = true -- Auto-indent new lines.
vim.opt.tabstop = 2 -- 1 tab == 2 spaces (by default).
vim.opt.wrap = false

-- Text formatting behaviour.
--
-- - 'a' = Do not autoformat paragraphs (use a code formatter).
-- - 'c' = Auto-wrap comments using 'textwidth'.
-- - 'r' = Don't auto-insert a comment when pressing return in insert-mode...
-- - 'o' = ...and don't auto-insert a comment when 'O' or 'o' in normal-mode.
-- - 't' = Don't auto-wrap text using 'textwidth'.
-- - '2' = TODO: Document this.
--
-- + 'j' = Join comments intelligently (i.e. auto-remove them if possible).
-- + 'n' = Auto-format numbered lists.
-- + 'q' = Enable comment formatting with 'gq'.
--
-- XXX: I feel like there should be a nice way to do this in lua...
-- XXX: This doesn't even work?
vim.cmd [[
  augroup format_options
    au!
    au BufWinEnter * setlocal formatoptions-=acrot2 formatoptions+=jnq
    au BufRead     * setlocal formatoptions-=acrot2 formatoptions+=jnq
    au BufNewFile  * setlocal formatoptions-=acrot2 formatoptions+=jnq
    au FileType    * setlocal formatoptions-=acrot2 formatoptions+=jnq
  augroup END
]]

-- Syntax formatting and highlighting
vim.cmd 'filetype plugin indent on' -- Enable per-filetype indentation.
vim.opt.syntax = 'enable' -- Enable syntax highlighting.
vim.opt.showmatch = true -- Highlight matching parentheses.

-- Misc.
vim.opt.backspace = 'indent,eol,start'
vim.opt.mouse = 'a' -- Mice are good (sometimes).

-- Performance - Memory, CPU, etc.
vim.opt.hidden = true -- Enable background buffers.
vim.opt.history = 100 -- Remember n lines in history.
vim.opt.lazyredraw = true -- Faster scrolling.
vim.opt.synmaxcol = 240 -- Max column for syntax highlight.

------------
-- Search --
------------
-- Set highlight on search.
vim.opt.hlsearch = false
vim.opt.incsearch = false

-- Case insensitive searching UNLESS '/C' or a capital letter is in the search.
vim.opt.ignorecase = true                   
vim.opt.smartcase = true

---------------------
-- Version Control --
---------------------
vim.g.gitgutter_eager = 1
vim.g.gitgutter_realtime = 1

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
