" Title:        Neovim Curl 
" Description:  A plugin to manage a curl collections
" Last Change:  28 January 2023
" Maintainer:   Michal Nowak <https://github.com/minowak>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_exampleplugin")
    finish
endif
let g:loaded_exampleplugin = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/nvim-curl/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 CurlOpen lua require("nvim-curl").open_collections()
command! -nargs=0 CurlExecute lua require("nvim-curl").execute()
