" Name: Snake (game)
" Version: 0.1
" Author: Code Monkey King <freesoft.for.people@gmail.com>
" Description: A game of Snake for VIM
" Usage: open VIM, execute command ':source /path/to/screen.vim|call Snake()'

" Print snake to screen
let s:x = winwidth(0) / 4
let s:y = winheight(0) / 2
let s:snake = [[s:x, s:y], [s:x-1, s:y], [s:x-2, s:y]]
let s:food = [winwidth(0) / 2, winheight(0) / 2]
let s:direction = "right"

" Init screen
function! s:init_screen()
  syntax off
  set nonumber
  set nowrap
  set sidescrolloff=0
  set sidescroll=1
endfunction

" Fill screen
function! s:fill_screen()
  " Remove all lines from buffer 
  1,$d
  
  " Get window size
  let width = winwidth(0)
  let height = winheight(0)
 
  " Fill text buffer with a given character
  for row in range(height)
    execute "normal! i" . repeat(' ', width) . (row < height-1 ? "\<CR>" : "\<ESC>") . "0"
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

" Print string at COL, ROW
function! s:print_message(col, row, msg)
  let col = a:col
  for ch in a:msg
    call s:print_at(col, a:row, ch)
    let col = col + 1
  endfor
endfunction

" Restore VIM configuration
function! s:close_screen()
  source $HOME/.vimrc
endfunction

" Change direction
function! s:move(direction)
  let s:direction = a:direction
endfunction

" Custom random function by Jacob Gelbman
" (http://github.com/zorgnax/vim-snake)
function! s:rand ()
    let b:rand = exists("b:rand") ? b:rand : 0
    let b:rand = abs((((b:rand + localtime()) * 31421) + 6927)) % 65536
    return b:rand
endfunction

" Print snake to screen
function! s:print_snake(timer_id)
  let new_head = [s:snake[0][0], s:snake[0][1]]
  call insert(s:snake, new_head, 0)
  if s:direction == "up"
    let new_head[1] = new_head[1] - 1
  elseif s:direction == "down"
    let new_head[1] = new_head[1] + 1
  elseif s:direction == "left"
    let new_head[0] = new_head[0] - 1
  elseif s:direction == "right"
    let new_head[0] = new_head[0] + 1
  endif

  if s:snake[0][0] == s:food[0] && s:snake[0][1] == s:food[1]
    call s:print_at(s:food[0], s:food[1], '*')
    while 1
      let s:food[0] = s:rand() % winheight(0) + 1
      let s:food[0] = s:rand() % winwidth(0) + 1
      if index(s:snake, s:food) == -1
        echo s:food
        call s:print_at(s:food[0], s:food[1], '@')
        break
      endif
    endwhile
  else 
    let tail = remove(s:snake, -1)
    call s:print_at(tail[0], tail[1], ' ')
    call s:print_at(s:snake[0][0], s:snake[0][1], '*')
  endif
endfunction

" Start game
function! s:main()
  call getchar()
  set t_ve=
  call s:print_at(s:food[0], s:food[1], '@')
  map <buffer> <silent> h :call <SID>move("left")<CR>
  map <buffer> <silent> j :call <SID>move("down")<CR>
  map <buffer> <silent> k :call <SID>move("up")<CR>
  map <buffer> <silent> l :call <SID>move("right")<CR>
  call timer_start(200, 's:print_snake', {'repeat': -1})
endfunction





call s:init_screen()
call s:fill_screen()
call s:main()
"call s:close_screen()

