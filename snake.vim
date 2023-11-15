" Name: Snake (game)
" Version: 0.1
" Author: Code Monkey King <freesoft.for.people@gmail.com>
" Description: A game of Snake for VIM

" Variables
let s:x = winwidth(0) / 4
let s:y = winheight(0) / 2
let s:snake = [[s:x, s:y], [s:x-1, s:y], [s:x-2, s:y]]
let s:food = [winwidth(0) / 2, winheight(0) / 2]
let s:direction = "right"
let s:speed = 200
let s:score = 0

" Init screen
function! s:init_screen()
  set t_ve=
  syntax off
  set nonumber
  set nowrap
  set sidescrolloff=0
  set sidescroll=1
endfunction

" Restore VIM configuration
function! s:close_screen()
  call timer_stopall()
  1,$d
  source $HOME/.vimrc
  set t_ve&vim
endfunction

" Fill screen
function! s:fill_screen()
  1,$d
  for row in range(winheight(0))
    execute "normal! i" . repeat(' ', winwidth(0)) . (row < winheight(0)-1 ? "\<CR>" : "\<ESC>") . "0"
  endfor
  redraw
endfunction

" Print character at COL, ROW
function! s:print_at(col, row, char)
  call cursor(a:row, a:col)
  execute "normal! r" . a:char
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

" Custom random function by Jacob Gelbman
" (http://github.com/zorgnax/vim-snake)
function! s:rand ()
    let b:rand = exists("b:rand") ? b:rand : 0
    let b:rand = abs((((b:rand + localtime()) * 31421) + 6927)) % 65536
    return b:rand
endfunction

" Change direction
function! s:move(direction)
  let s:direction = a:direction
endfunction

" Game loop
function! s:main(timer_id)
  " Print score
  echo "Score: " . s:score

  " Print apple
  call s:print_at(s:food[0], s:food[1], 'o')

  " Update snake
  let new_head = [s:snake[0][0], s:snake[0][1]]
  call insert(s:snake, new_head, 0)

  " Move snake
  if     s:direction == "up"    | let new_head[1] = new_head[1] - 1
  elseif s:direction == "down"  | let new_head[1] = new_head[1] + 1
  elseif s:direction == "left"  | let new_head[0] = new_head[0] - 1
  elseif s:direction == "right" | let new_head[0] = new_head[0] + 1
  endif

  " Wrap snake around screen
  if s:snake[0][0] >= winwidth(0)+1 | let s:snake[0][0] = 1
  elseif s:snake[0][0] <= 0 | let s:snake[0][0] = winwidth(0)
  elseif s:snake[0][1] >= winheight(0)+1 | let s:snake[0][1] = 1
  elseif s:snake[0][1] <= 0 | let s:snake[0][1] = winheight(0)
  endif

  " Snake hits itself
  if index(s:snake[1:], s:snake[0]) != -1
    let msg = "GAME OVER!"
    call s:print_message(winwidth(0) / 2 - len(msg) / 2, winheight(0) / 2, msg)
    call getchar()
    call s:close_screen()
  endif

  " Print snake
  if s:snake[0][0] == s:food[0] && s:snake[0][1] == s:food[1]
    call s:print_at(s:food[0], s:food[1], '*')
    let s:score = s:score + 1
    while 1
      " Generate food
      let s:food[0] = s:rand() % winwidth(0) + 1
      let s:food[1] = s:rand() % winheight(0) + 1
      if index(s:snake, s:food) == -1
        call s:print_at(s:food[0], s:food[1], 'o')
        break
      endif
    endwhile
  else 
    let tail = remove(s:snake, -1)
    call s:print_at(tail[0], tail[1], ' ')
    call s:print_at(s:snake[0][0], s:snake[0][1], '*')
  endif
endfunction

" Init screen
call s:init_screen()
call s:fill_screen()

" Print greetings
let msg = "Move snake using h j k l, press any key to start..."
call s:print_message(winwidth(0) / 2 - len(msg) / 2, winheight(0) / 2, msg)
call getchar()

" Clear screen
call s:fill_screen()

" Color snake & apple
syntax match snake "\*"
syntax match apple "o"
highlight snake ctermfg=green
highlight apple ctermfg=red

" Map control keys
map <buffer> <silent> <Esc> :call <SID>close_screen()<CR>
map <buffer> <silent> h :call <SID>move("left")<CR>
map <buffer> <silent> j :call <SID>move("down")<CR>
map <buffer> <silent> k :call <SID>move("up")<CR>
map <buffer> <silent> l :call <SID>move("right")<CR>

" Start game loop
call timer_start(s:speed, 's:main', {'repeat': -1})
