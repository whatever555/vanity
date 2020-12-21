if v:version < 800 || exists('initiated_vanity') || &cp
  finish
endif

let initiated_vanity = 1
let s:fully_loaded_vanity = 0

silent !mkdir ~/.vim/Vanity > /dev/null 2>&1

let g:vanity_unsupported_colors = ['tcsoft','surveyor','sunburst','soruby','guardian','grayorange','distill','edo_sea','editplus', 'dracula_bold','dracula','dark-ruby', 'corn','autumnleaf','AutumnLeaf','PaperColor', 'abyss','briofita','nordisk','mythos']

let s:colschemes=getcompletion('', 'color')

function! s:SetActiveColorschemes(conf)
  if a:conf == 'all'
    let s:colschemes=getcompletion('', 'color')
  endif 
  if a:conf == 'favourites'
    let s:colschemes=readfile(glob('~/.vim/Vanity/favourites'))
  endif 
endfunction

function! SetFavouriteColorschemes()
  call s:SetActiveColorschemes('favourites')
endfunction

function! SetAllColorschemes()
  call s:SetActiveColorschemes('all')
endfunction

command! -nargs=* SetActiveColorschemes call s:SetActiveColorschemes('<args>')

let s:setColorsCurrentIncrementTimer=0

:function SaveFavColor()
    :let c = g:colors_name
    :call writefile([c], expand('~/.vim/Vanity/favourites'), "a")
:endfunction

:function SetDefaultColor()
    :let c = g:colors_name
    :call writefile([c], expand('~/.vim/Vanity/default'), "w")
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

function! VNextCol()
  call s:SwitchCol(1)
endfunction
function! VPrevCol()
  call s:SwitchCol(-1)
endfunction

function! s:SetColor(n, thenDc)
  if s:setColorsCurrentIncrementTimer !=1 && a:thenDc <s:setColorsCurrentIncrementTimer 
    return
  endif

  if len(s:colschemes) == 0
    call s:SetActiveColorschemes('all')
  endif 

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
  s:setColorsCurrentIncrementTimer = 1
  let s:current = index(s:colschemes, g:colors_name)
  let l:rand = str2nr(matchstr(reltimestr(reltime()), '\v\.\zs\d+'))
  let l:rand = l:rand % (len(s:colschemes) - 0 + 1) + 0 
  call s:SetCol(s:current-l:rand, 1))
endfunction

if !exists("g:colors_name")
  let g:colors_name=s:colschemes[0]
  if filereadable(glob('~/.vim/Vanity/default'))
    let g:colors_name=readfile(glob('~/.vim/Vanity/default'))[0]
    let s:current = index(s:colschemes, g:colors_name)
    if s:current > -1
      call s:SetColor(s:current, 0)
    endif
  endif
endif
let s:fully_loaded_vanity = 1
