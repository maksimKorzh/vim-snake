" Name: screen (game)
" Version: 0.1
" Author: Code Monkey King <freesoft.for.people@gmail.com>
" Description: A library to manipulate text buffer (screen) in VIM
" Usage: just 'source /path/to/screen.vim' to your VIM script
" Test: open VIM, execute command ':source /path/to/screen.vim|call TestScreen()'

" Init screen
function! Init_screen()
  syntax off
  set nonumber
  set nowrap
  set sidescrolloff=0
  set sidescroll=1
endfunction

" Fill screen
function! Fill_screen(char)
  " Remove all lines from buffer 
  1,$d
  
  " Get window size
  let width = winwidth(0)
  let height = winheight(0)
 
  " Fill text buffer with a given character
  for row in range(height)
    execute "normal! i" . repeat(a:char, width) . (row < height-1 ? "\<CR>" : "\<ESC>") . "0"
  endfor

  " Update screen
  redraw
endfunction

" Print character at COL, ROW
function! Print_at(col, row, char)
  " Move cursor to a given coordinate
  call cursor(a:row, a:col)

  " Set character
  execute "normal! r" . a:char

  " Update screen
  redraw
endfunction

" Print string at COL, ROW
function! Print_message(col, row, msg)
  let col = a:col
  for ch in a:msg
    call s:print_at(col, a:row, ch)
    let col = col + 1
  endfor
endfunction

" Restore VIM configuration
function! Close_screen()
  source $HOME/.vimrc
endfunction

" Test library
function! TestScreen()
  call Init_screen()
  call Fill_screen(" ")
  let msg = "VIM Screen by Code Monkey King, press any key to exit..."
  let row = winheight(0) / 2
  let col = winwidth(0) / 2 - len(msg) / 2
  call Print_message(col, row, msg)
  call Close_screen()
  call getchar()
endfunction
