[bits 32]

;call [ebx+2*4] ; getchar

;cmp eax, 'A'
;jne dalej

call wypisz_hello
call wypisz_hello
call wypisz_hello
call wypisz_hello
call [ebx]

wypisz_hello:
  call wypisz_h
  db 'hello world', 0xa, 0

  wypisz_h:
  call [ebx+3*4] ; printf
  add esp, 4
  ret


