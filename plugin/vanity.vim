if v:version < 800 || exists('initiated_vanity') || &cp
  finish
endif

let initiated_vanity = 1
let s:fully_loaded_vanity = 0

silent !mkdir ~/.vim/Vanity > /dev/null 2>&1

let g:vanity_unsupported_colors = ['tcsoft','surveyor','sunburst','soruby','guardian','grayorange','distill','edo_sea','editplus', 'dracula_bold','dracula','dark-ruby', 'corn','autumnleaf','AutumnLeaf','PaperColor', 'abyss','briofita','nordisk','mythos']

let s:colschemes=getcompletion('', 'color')
let g:vanity_default_colors = {}
let g:vanity_favourite_colors = {}

function! s:SetActiveColorschemes(conf)
  if a:conf == 'file favourites'
    :call s:LoadFavouriteColorschemes(&filetype)
  endif 
  if a:conf == 'favourites'
    :call s:LoadFavouriteColorschemes('allFiles')
  endif 
  if a:conf == 'all'
    let s:colschemes=getcompletion('', 'color')
  endif 
endfunction

function! SetFavouriteColorschemes()
  call s:SetActiveColorschemes('favourites')
endfunction

function! SetFavouriteColorschemesForFiletype()
  call s:SetActiveColorschemes('file favourites')
endfunction

function! SetAllColorschemes()
  call s:SetActiveColorschemes('all')
endfunction

command! -nargs=* SetActiveColorschemes call s:SetActiveColorschemes('<args>')

let s:setColorsCurrentIncrementTimer=0

:function SaveFavColor()
    :call SaveFavColorForFileType('allFiles')
:endfunction

:function SaveFavColorForFileType(file_type)
    call s:LoadFavColsToVar()
    :let l:c = g:colors_name
    if !has_key(s:favourite_colors, a:file_type)
      :let s:favourite_colors[a:file_type] = []
    endif
    :call add(s:favourite_colors[a:file_type], l:c)
call filter(s:favourite_colors[a:file_type], 'count(s:favourite_colors[a:file_type], v:val) == 1')
    :call writefile([string(s:favourite_colors)], expand('~/.vim/Vanity/favouriteColorSchemes'), "w")
:endfunction

:function SetDefaultColorForFiletype(file_type)
    :let l:c = g:colors_name
    if !exists("s:default_colors")
      :let s:default_colors = {}
    endif 
    :let s:default_colors[a:file_type] = l:c
    :call writefile([string(s:default_colors)], expand('~/.vim/Vanity/default'), "w")
:endfunction

:function SetDefaultColor()
    :call SetDefaultColorForFiletype('allFiles')
:endfunction

function! s:SwitchCol(n)
  let s:setColorsCurrentIncrementTimer+=1
  let l:ct = s:setColorsCurrentIncrementTimer
  let s:current = index(s:colschemes, g:colors_name)
  let l:nxtCol=s:current+(a:n*l:ct)
  let l:joinedParams = l:nxtCol.",".l:ct
  call timer_start(160, { -> execute("call s:SetColor(" . l:joinedParams .  ")", "")})
  if l:nxtCol < 0
    let l:nxtCol = len(s:colschemes)-1
  endif
  if l:nxtCol > len(s:colschemes)-1
    let l:nxtCol = 0 
  endif
  echo l:nxtCol.": ".s:colschemes[l:nxtCol]
endfunction

command! VanityNextCol call s:SwitchCol(1)
command! VanityPrevCol call s:SwitchCol(-1)
command! VanityRandomCol call VRandCol()
command! VanitySetDefaultColor call SetDefaultColor()
command! VanitySetDefaultColorForFiletype call SetDefaultColorForFiletype(&filetype)
command! VanitySaveFavColor call SaveFavColor()
command! VanitySetAllColorschemes call SetAllColorschemes()
command! VanitySaveFavColorForFileType call SaveFavColorForFileType(&filetype)
command! VanityLoadDefaultColorscheme call s:LoadDefaultColorscheme(&filetype)
command! VanityLoadFavouriteColorschemes call s:LoadFavouriteColorschemes(&filetype)
command! VanityCycleFavourites call SetFavouriteColorschemes()
command! VanityCycleFavouritesForFiletype call SetFavouriteColorschemesForFiletype()
command! VanityCycleAll call SetAllColorschemes()

function! VNextCol()
  call s:SwitchCol(1)
endfunction

function! VPrevCol()
  call s:SwitchCol(-1)
endfunction

function! s:EnsureColorValueIsSet()
  if len(s:colschemes) == 0
    call s:SetActiveColorschemes('all')
  endif 
  if !exists("g:colors_name")
    let g:colors_name=s:colschemes[0]
  endif
endfunction

function! s:LoadDefaultColorscheme(file_type)
  call s:EnsureColorValueIsSet()
  if filereadable(glob('~/.vim/Vanity/default'))
    let l:d_cs=readfile(glob('~/.vim/Vanity/default'))[0]
    let s:default_colors = {}
    let l:indexOfCurly = stridx(l:d_cs, '}')
    let l:default_colors_tmp = {}
    if l:indexOfCurly > -1
      execute 'let l:default_colors_tmp = ' . l:d_cs
      let s:default_colors = l:default_colors_tmp 
    elseif len(l:d_cs) > 0
      let s:default_colors = {'allFiles': l:d_cs}
    endif
    let s:default_colors = extend(s:default_colors, g:vanity_default_colors)
    let s:default_colors = extend(s:default_colors, g:vanity_default_colors)
    if has_key(s:default_colors, a:file_type)
      let g:colors_name = s:default_colors[a:file_type] 
    elseif has_key(s:default_colors, 'allFiles')
      let g:colors_name = s:default_colors['allFiles'] 
    else 
      let g:colors_name=s:colschemes[0]
    endif
    let s:current = index(s:colschemes, g:colors_name)
    if s:current > -1
      call s:SetColor(s:current, 0)
    endif
  endif
endfunction

function! s:LoadFavColsToVar()
  let s:favourite_colors = {}
  if filereadable(glob('~/.vim/Vanity/favouriteColorSchemes'))
    let l:fav_io=readfile(glob('~/.vim/Vanity/favouriteColorSchemes'))[0]
    execute 'let s:favourite_colors = ' . l:fav_io
  endif
endfunction

function! s:LoadFavouriteColorschemes(file_type)
    call s:LoadFavColsToVar()
    call s:EnsureColorValueIsSet()
    let l:favourite_colors = extend(s:favourite_colors, g:vanity_favourite_colors)
    if exists("l:favourite_colors")
      if has_key(l:favourite_colors, a:file_type)
        let l:favs = l:favourite_colors[a:file_type] 
      else 
        echom "No favourites set for this file type. To set a favourite use the :VanitySaveFavColorForFileType command".a:file_type
        let l:favs=getcompletion('', 'color')
      endif
    endif
    :call add(l:favs, g:colors_name)
    let s:colschemes=uniq(l:favs)
endfunction

function! s:SetColor(n, thenDc)
  if s:setColorsCurrentIncrementTimer !=1 && a:thenDc <s:setColorsCurrentIncrementTimer 
    return
  endif
  call s:EnsureColorValueIsSet()
  let s:current = index(s:colschemes, g:colors_name)

  let s:notChanged = 1
  let s:next = a:n

  while s:notChanged == 1 
  if s:setColorsCurrentIncrementTimer !=1 && a:thenDc <s:setColorsCurrentIncrementTimer 
      return
    endif
    if s:next < 0 
      let s:next = len(s:colschemes)-1
    endif
    if s:next > len(s:colschemes)-1
      let s:next = 0
    endif
    if index(g:vanity_unsupported_colors, s:colschemes[s:next]) == -1
        try
          hi clear
          if exists("syntax_on")
            syntax reset
          endif
        catch /.*/
        endtry

        try
          execute 'colorscheme '.s:colschemes[s:next]
          if g:colors_name == s:colschemes[s:next]
            let s:setColorsCurrentIncrementTimer = 0
            let s:notChanged=0
            break
          else
            echom "colour is configured incorrectly. name is set to  ".g:colors_name. " and it is listed as ".s:colschemes[s:next]
          endif
        catch /.*/
          echom "there was an issue loading colour: ". s:colschemes[s:next]
        endtry
    endif
    if s:next > s:current
      let s:next = s:next+1
    else
      let s:next = s:next-1
    endif

  endwhile
  redraw
  if s:fully_loaded_vanity == 1
    echo s:next . ": " .g:colors_name
  endif
endfunction

function! VRandCol()
  let s:setColorsCurrentIncrementTimer = 1
  let s:current = index(s:colschemes, g:colors_name)
  let l:rand = str2nr(matchstr(reltimestr(reltime()), '\v\.\zs\d+'))
  let l:rand = l:rand % (len(s:colschemes) - 0 + 1) + 0 
  call s:SetColor(s:current-l:rand, 1)
endfunction

:augroup setcolorgroup 
    set background=dark
    hi clear
    if exists("syntax_on")
    syntax reset
    endif
    " Set colour scheme
    autocmd VimEnter,BufNewFile,BufRead * :VanityLoadDefaultColorscheme
:augroup END

let s:fully_loaded_vanity = 1
