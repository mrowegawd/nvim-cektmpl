if exists('g:loaded_cektmpl' ) | finish | endif

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:cektmpl_path')
  let g:cektmpl_path = $HOME . '/Dropbox/vimwiki/nvimcektest'
endif

fun! MyfirstPluginYo()
  lua for k in pairs(package.loaded) do if k:match('^cektmpl')
        \ then package.loaded[k] = nil end end
  " lua require'cektmpl'.toggle()
  lua require'cektmpl'
endfunction

command! Cektmpl lua require'cektmpl.init'.toggle()


nnoremap rr :call MyfirstPluginYo()<CR>

augroup MyfirstPluginYo
  autocmd!
augroup END


let g:loaded_cektmpl = 1

let &cpo = s:save_cpo
unlet s:save_cpo
