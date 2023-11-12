" Name: screen (game)
" Version: 0.1
" Author: Code Monkey King <freesoft.for.people@gmail.com>
" Description: A library to manipulate text buffer (screen) in VIM
" Usage: just 'source /path/to/screen.vim' to your VIM script
" Test: open VIM, execute command ':source /path/to/screen.vim|call TestScreen()'

" Init screen
function! s:init_screen()
  syntax off
  set nonumber
  set nowrap
  set sidescrolloff=0
  set sidescroll=1
endfunction

" Fill screen
function! s:fill_screen(char)
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
function! s:print_at(col, row, char)
  " Move cursor to a given coordinate
  call cursor(a:row, a:col)

  " Set character
  execute "normal! r" . a:char

  " Update screen
  redraw
endfunction

" Test library
function! TestScreen()
  call s:init_screen()
  call s:fill_screen(" ")
  let msg = "VIM Screen by Code Monkey King, press any key to exit..."
  let row = winheight(0) / 2
  let col = winwidth(0) / 2 - len(msg) / 2
  for ch in msg
    call s:print_at(col, row, ch)
    let col = col + 1
  endfor
  call getchar()
endfunction
