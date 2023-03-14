" Load base vim config.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
set shell=/bin/bash

call plug#begin()
    Plug 'tyru/open-browser.vim' " Open queries with the browser.
    Plug 'derekwyatt/vim-fswitch' " Switch between header and source files (C++).
    " Plug 'ludovicchabant/vim-gutentags' " Auto generate ctags.
    Plug 'liuchengxu/vista.vim'
    Plug 'itchyny/lightline.vim' " Pretty status bar.
    Plug 'neovim/nvim-lspconfig'
    " for nvim-cmp
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    " Plug 'kyazdani42/nvim-tree.lua'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'morhetz/gruvbox'
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'mcchrish/nnn.vim'
    Plug 'tikhomirov/vim-glsl'
    Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
    Plug 'sakshamgupta05/vim-todo-highlight'
    Plug 'psf/black', { 'branch': 'stable' }
call plug#end()


" File browser with nnn
let g:nnn#command = 'nnn -d -o'
let g:nnn#action = {
      \ '<c-o>': 'e',
      \ '<c-t>': 'tab split',
      \ '<c-s>': 'split',
      \ '<c-v>': 'vsplit' }
" nnoremap <silent> <C-n> :NnnExplorer<cr>

" Check for extra spaces after end line.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()

" Remove all trailing whitespaces
nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
"
" Highlight trailing whitespaces
:highlight ExtraWhitespace ctermbg=red guibg=red

function! s:JbzCppMan()
    let old_isk = &iskeyword
    setl iskeyword+=:
    let str = expand("<cword>")
    let &l:iskeyword = old_isk
    execute 'Man ' . str
endfunction
command! JbzCppMan :call s:JbzCppMan()
au FileType cpp nnoremap <buffer>K :JbzCppMan<CR>

" Open browser plugin config.
let g:openbrowser_search_engines = extend(
\ get(g:, 'openbrowser_search_engines', {}),
\ {
\   'cppreference': 'https://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search={query}',
\   'gl3': 'https://docs.gl/gl3/{query}',
\ },
\ 'keep'
\)
nnoremap <silent> <leader>osx :call openbrowser#smart_search(expand('<cword>'), "cppreference")<CR>
nnoremap <silent> <leader>oso :call openbrowser#smart_search(expand('<cword>'), "gl3")<CR>

" Switch between header and source file.
au BufEnter *.h  let b:fswitchdst = "c,cpp,cc,m"
au BufEnter *.cc let b:fswitchdst = "h,hpp"
au BufEnter *.h let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:|include.*|src/**|'
nnoremap <silent> <A-o> :FSHere<cr>
" Extra hotkeys to open header/source in the split
nnoremap <silent> <localleader>oh :FSSplitLeft<cr>
nnoremap <silent> <localleader>oj :FSSplitBelow<cr>
nnoremap <silent> <localleader>ok :FSSplitAbove<cr>
nnoremap <silent> <localleader>ol :FSSplitRight<cr>

" ctags
" set tags=./tags;
" let g:gutentags_ctags_exclude_wildignore = 1
" " Ignore some unwanted file extensions.
" let g:gutentags_ctags_exclude = [
"   \'node_modules', '_build', 'build', 'CMakeFiles', '.mypy_cache', 'venv',
"   \'*.md', '*.tex', '*.css', '*.html', '*.json', '*.xml', '*.xmls', '*.ui']

" ## Vista vim ##
nnoremap <silent> <A-6> :Vista!!<CR>
" Show current function in status bar.
" function! LightlineCurrentFunctionVista() abort
"   let l:method = get(b:, 'vista_nearest_method_or_function', '')
"   if l:method != ''
"     let l:method = '[' . l:method . ']'
"   endif
"   return l:method
" endfunction
" au VimEnter * call vista#RunForNearestMethodOrFunction()
" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'nvim_lsp'
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1
" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

" ### Lightline ###
let g:lightline = {
  \ 'colorscheme': 'sonokai',
  \ 'active': {
  \   'left':  [ [ 'mode', 'paste' ],
  \              [ 'readonly', 'filename', 'modified' ],
  \              [ 'current_function'] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype' ],
  \              [ 'gitbranch' ] ],
  \ },
  \ 'component_expand': {
  \   'lsp_warnings': 'LightlineLspWarnings',
  \   'lsp_errors': 'LightlineLspErrors',
  \ },
  \ 'component_function': {
  \   'current_function': 'LightlineCurrentFunctionVista',
  \   'filename': 'LightlineStrippedFilename'
  \ },
  \ 'component_type': {
  \   'lsp_warnings': 'warning',
  \   'lsp_errors': 'error',
  \   'readonly': 'error',
  \ },
  \ }

" nvim-cmp
set completeopt=menu,menuone,noselect

" ### Format source code with clang-format ###
function! s:JbzClangFormat(first, last)
  let l:winview = winsaveview()
  execute a:first . "," . a:last . "!clang-format-12 -style=\"{BasedOnStyle: Google, IndentWidth: 4, AccessModifierOffset: -4, BreakBeforeBraces: Allman, ColumnLimit: 120, NamespaceIndentation: All}\""
  call winrestview(l:winview)
endfunction
command! -range=% JbzClangFormat call <sid>JbzClangFormat (<line1>, <line2>)

" Autoformatting with clang-format
au FileType c,cpp nnoremap <buffer><leader>lf :<C-u>JbzClangFormat<CR>
au FileType c,cpp vnoremap <buffer><leader>lf :JbzClangFormat<CR>

" Formatting with black for python.
au FileType python nnoremap <buffer><leader>lf :Black<CR>
let g:black_preview=1
" au FileType py vnoremap <buffer><leader>lf :Black<CR>

lua <<EOF
    require'lspconfig'.clangd.setup{}

    -- Setup nvim-cmp.
    local cmp = require'cmp'

    cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
        },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        },
    mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
        sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
        }, {
        { name = 'buffer' },
        })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
        { name = 'buffer' },
        })
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
            }
        })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
        { name = 'path' }
        }, {
        { name = 'cmdline' }
        })
    })

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    require('lspconfig')['clangd'].setup {
        capabilities = capabilities
        }

    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'clangd', 'cmake', 'pyright' }
    for _, lsp in pairs(servers) do
      require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
          -- This will be the default in neovim 0.7+
          debounce_text_changes = 150,
        }
      }
    end

    -- Tree sitter
    require'nvim-treesitter.configs'.setup {
      -- A list of parser names, or "all"
      ensure_installed = { "c", "cpp", "python", "cmake" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- List of parsers to ignore installing (for "all")
      ignore_install = { "javascript" },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
    }

    -- nvim-tree web icons.
    require'nvim-web-devicons'.setup{}
    require'nvim-web-devicons'.get_icons()
EOF

let g:todo_highlight_config = {
      \   'TODO': {
      \     'gui_bg_color': '#FFD885',
      \   },
      \   'NOTE': {
      \     'gui_bg_color': '#E7C8DD',
      \   }
      \ }

set background=dark
colorscheme sonokai 
" colorscheme tokyonight
