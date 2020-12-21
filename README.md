Vanity: Vim plugin for managing colorschemes 
=============

Introduction
------------

This plugin helps with managing colorschemes in vim.   
With this plugin installed you can:   
1. Cycle through available colourschems  
2. Set a default colourscheme   
3. Set a group of favourite colourschemes   

Requirements
------------
You will need to have vim 8+ and  some colourschemes installed to get the most out of this plugin.  
Here are some options:    
https://github.com/flazz/vim-colorschemes  
https://vimawesome.com/plugin/awesome-vim-colorschemes  
https://vimawesome.com/plugin/vim-colorschemes-sweeter-than-fiction  
https://github.com/mcchrish/vim-no-color-collections  
https://github.com/rainglow/vim  
https://github.com/nightsense/vimspectr  
https://github.com/chriskempson/base16-vim  
https://github.com/mswift42/vim-themes  
https://github.com/mkarmona/colorsbox  
   
Installation
------------

#### Vim 8+ packages

If you are using VIM version 8 or higher you can use its built-in package management; see `:help packages` for more information. Just run these commands in your terminal:

```bash
git clone https://github.com/whatever555/vanity.git ~/.vim/pack/vendor/start/vanity
vim -u NONE -c "helptags ~/.vim/pack/vendor/start/vanity/doc" -c q
```

Or you can use the following:  

#### [pathogen.vim](https://github.com/tpope/vim-pathogen)

In the terminal,
```bash
git clone https://github.com/whatever555/vanity.git ~/.vim/bundle/vanity
```
In your vimrc,
```vim
call pathogen#infect()
syntax on
filetype plugin indent on
```

Then reload vim, run `:helptags ~/.vim/bundle/vanity/doc/` or `:Helptags`.

#### [Vundle.vim](https://github.com/VundleVim/Vundle.vim)
```vim
call vundle#begin()
Plugin 'whatever555/vanity'
call vundle#end()
```

#### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
call plug#begin()
Plug 'whatever555/vanity'
call plug#end()
```

#### [dein.vim](https://github.com/Shougo/dein.vim)
```vim
call dein#begin()
call dein#add('whatever555/vanity')
call dein#end()
```

#### [apt-vim](https://github.com/egalpin/apt-vim)
```bash
apt-vim install -y https://github.com/whatever555/vanity.git
```

Usage
------------

To cycle through available colorthemes:  
next colour:   
`:call VNextCol()`   
previous colour:   
`:call VPrevCol()`   
random colour:   
`:call VRandCol()`   
  
To set the current colorscheme to default:  
`:call SetDefaultColorscheme()`   
  
To save the current colorscheme to your list of favourites:  
`:call SaveFavColor()`   
  
To allow only your favourite colourthemes to be cycled:  
`call SetFavouriteColorSchemes()`  

To allow all colourthemes to be cycled:  
`call SetFavouriteColorSchemes()`  
  
To view and edit favourite colour list:  
`coming soon`


Recomended Mappings
------------
There are no mapped keys but you can add this to your `.vimrc` file to enable colorscheme cycling with PageUp and PageDown keys
  

```
nnoremap <PageDown> :call VPrevCol()<CR>  
nnoremap <PageUp> :call VNextCol()<CR>  
```


Help 
------------

`:help vanity`

