Vanity: Vim plugin for managing colorschemes 
=============

Introduction
------------

This plugin helps with managing colorschemes in vim. It does not contain any actual vim colorschemes - for those you can install a separate plugin (listed below).  

With this plugin installed you can:   
1. Cycle through available colourschems  
2. Set a default colourscheme   
3. Set a group of favourite colourschemes   

![Screenshot](https://user-images.githubusercontent.com/1413475/102801021-951be000-43ac-11eb-91d5-03cd65be287a.gif)

[Video](https://user-images.githubusercontent.com/1413475/102798713-5f292c80-43a9-11eb-853b-6d7f83352d20.mp4)

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
   

Basic Installation
------------

For a more detailed explanation and for more installation options see [Detailed Installation](#detailed-installation)

#### [Vundle.vim](https://github.com/VundleVim/Vundle.vim)
```vim
call vundle#begin()
Plugin 'whatever555/vanity'
call vundle#end()
```

Usage
------------

## Getting started

To cycle through available color schemes call `:VanityNextCol`.  
When you come across a colour scheme you LIKE call `:VanitySaveFavColorForFileType` to add it as a favourite.  
When you come across a colour scheme you LOVE call `:VanitySetDefaultColorForFiletype` to add it as the default colour scheme for that filetype.  

## Commands

#### Cycling through color schemes  
`:VanityNextCol`: Switch to next color scheme  
`:VanityPrevCol`: Switch to previous color scheme  
`:VanityRandomCol`: Switch to a random color scheme  
  
### Default color schemes  
`:VanitySetDefaultColor`: Set default color scheme for all file types   
`:VanitySetDefaultColorForFiletype`: Set default color scheme for current file type   

### Favourite Colorschemes
`VanitySaveFavColor`: Save a favourite colourscheme (for all filetypes)   
`VanitySaveFavColorForFileType`: Save a favourite colourscheme (for crrrent filetype)   

`VanityCycleAll`:  Set current list of cyclable colorschemes to all available    
`VanityCycleFavourites`:  Set current list of cyclable colorschemes to favourites only (for all filetypes)    
`VanityCycleFavouritesForFiletype`:  Set current list of cyclable colorschemes to favourites only (for current filetype only)    


### Default Colorschemes
`VanityLoadDefaultColorscheme`: Set colourscheme to default (for current filetype if set, otherwise it will set to 'allFiles' default type)      

Recommended Mappings
------------
There are no mapped keys but you can add this to your `.vimrc` file to enable colorscheme cycling with PageUp and PageDown keys
  

```
nnoremap <PageDown> :VanityPrevCol<CR>  
nnoremap <PageUp> :VanityNextCol<CR>  
```


Help 
------------

`:help vanity`


Demo
------------

![Screenshot](https://user-images.githubusercontent.com/1413475/102799675-c0053480-43aa-11eb-813b-32c6db54f84e.gif)

Detailed Installation
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
