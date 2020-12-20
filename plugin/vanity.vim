if v:version < 800 || exists('loaded_vanity') || &cp
  finish
endif

let loaded_vanity = 1

let g:vanity_unsupported_colors = ['tcsoft','surveyor','sunburst','soruby','guardian','grayorange','distill','edo_sea','editplus', 'dracula_bold','dracula','dark-ruby', 'corn','autumnleaf','AutumnLeaf','PaperColor', 'abyss','briofita','nordisk','mythos']

let s:colschemes=getcompletion('', 'color')

function! s:SetActiveColorschemes(conf)
  if conf == 'all'
    let s:colschemes=getcompletion('', 'color')
  endif 
  if conf == 'faves'
    let s:colschemes=readfile('.favouriteColourSchemes')
  endif 
endfunction

command! -nargs=* SetActiveColorschemes call s:SetActiveColorschemes('<args>')

let s:setColorsCurrentIncrementTimer=0

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

function! NextCol()
  s:SwitchCol(1)
endfunction
function! PrevCol()
  s:SwitchCol(-1)
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
          echo "there was an issue loading colour: ". s:colschemes[s:next]
        endtry
    endif
    if s:next > s:current
      let s:next = s:next+1
    else
      let s:next = s:next-1
    endif

  endwhile
  redraw
  echo s:next . ": " .g:colors_name
endfunction

