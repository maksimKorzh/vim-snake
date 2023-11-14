source ../src/screen.vim

" map <buffer> <silent> h :call <SID>setdirection(0, -1)<CR>
map <buffer> <silent> q :call s:quit()<CR>

let s:is_running = 1

function! s:quit()
  call Print_at(10, 10, 'E')
  let s:is_running = 0
endfunction

function! s:snake()
  call Init_screen()
  call Fill_screen(' ')
  let snake_x = winwidth(0) / 4
  let snake_y = winheight(0) / 2
  let snake = [
      \[snake_y, snake_x],
      \[snake_y, snake_x - 1],
      \[snake_y, snake_x - 2]
  \]

  let food = [winwidth(0) / 2, winheight(0) / 2]
  call Print_at(food[0], food[1], '@')
 
  let key = 'l'

  while 1
    if s:is_running == 0 | break | endif

"    key = key if next_key == -1 else next_key
"  
"    if (
"        snake[0][0] in [0, sh] or
"        snake[0][1] in [0, sw] or
"        snake[0] in snake[1:]
"    ):
"        curses.endwin()
"        quit()
"  
    let new_head = [snake[0][0], snake[0][1]]
"  
"    if key == curses.KEY_DOWN:
"        new_head[0] += 1
"    if key == curses.KEY_UP:
"        new_head 0] -= 1
"    if key == cu ses.KEY_LEFT:
"        new_head 1] -= 1
"    if key == curses.KEY_RIGHT:
"        new_head[1] += 1
"  
    call insert(snake, new_head, 0)
"  
"    if (
"        snake[0][0] == food[0] and
"        snake[0][1] == food[1]
"    ):
"        food = None
"        while food is None:
"            nf = [
"                random.randint(1, sh - 1),
"                random.randint(1, sw - 1)
"            ]
"            food = nf if nf not in snake else None
"        w.addch(food[0], food[1], curses.ACS_PI)
"    else:
       let tail = remove(snake, -1)
       call Print_at(tail[0], tail[1], ' ')
"  
    call Print_at(snake[0][0], snake[0][1], '#')
  endwhile
  call Close_screen()
endfunction

call s:snake()
