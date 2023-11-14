source ../src/screen.vim

let s:TETRIS_WIDTH = 12
let s:TETRIS_HEIGHT = 21

let s:tetris = [
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
\ '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'
\]

let s:tetrominos = [
\'    ' +
\' @@ ' +
\' @@ ' +
\'    ',
\
\'  @ ' +
\'  @ ' +
\'  @ ' +
\'  @ ',
\
\'  @ ' +
\' @@ ' +
\' @  ' +
\'    ',
\
\' @  ' +
\' @@ ' +
\'  @ ' +
\'    ',
\
\' @@ ' +
\'  @ ' +
\'  @ ' +
\'    ',
\
\' @@ ' +
\' @  ' +
\' @  ' +
\'    ',
\
\'  @ ' +
\' @@ ' +
\'  @ ' +
\'    ']
    
" Print tetris board to screen
function! s:draw_tetris()
  " Loop over tetris rows
  for row in range(s:TETRIS_HEIGHT)
    " Loop over tetris cols
    for col in range(s:TETRIS_WIDTH)
      " Convert row and col coordinates into a square index
      let square = row * s:TETRIS_WIDTH + col

      " Centeralize tetris
      let center_col = winwidth(0) / 2 - s:TETRIS_WIDTH / 2
      let center_row = winheight(0) / 2 - s:TETRIS_HEIGHT / 2
 
      " Render character
      call Print_at(col+center_col, row+center_row, s:tetris[square])
    endfor
  endfor
endfunction

call Init_screen()
call Fill_screen(' ')
call s:draw_tetris()
call getchar()
call Close_screen()
