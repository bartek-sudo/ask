[bits 32]

call menu
call odczyt_wyboru



;call [ebx] ;exit

menu:
  call wypisz_menu
  ;db 'hello world', 0xa, 0
  db "1. Kamien", 10, "2. Papier", 10, "3. Scyzoryk", 10, "Wybierz przedmiot:", 0xa, 0

  wypisz_menu:
  call [ebx+3*4] ; printf
  add esp, 4
  ret

odczyt_wyboru:
  mov ebp, esp
  sub esp, 8

  lea eax, [ebp-4]
  push eax
  lea eax, [ebp-8]
  push eax
  call do_scan
  db "%i %i", 0
  do_scan:
  call [ebx+4*4]
  add esp, 12



  mov eax, [ebp-8]
  sub eax, [ebp-4]
  push eax

  jz wypisz_0
  js wypisz_ujemna

  ;dodatnia
  push '>'
  call [ebx+1*4]
  jmp wynik

  wypisz_0:
  push '='
  call [ebx+1*4]
  jmp wynik

  wypisz_ujemna:
  push '<'
  call [ebx+1*4]
  jmp wynik

wynik:
  add esp, 4
  call wypisz_wynik
  db "Wynik: %i", 0xa, 0
  wypisz_wynik:
  call [ebx+3*4]
  add esp, 8

  ret
