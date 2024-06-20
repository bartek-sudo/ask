[bits 32]



RDRAND eax
push eax ; Umieszcza wylosowan¹ liczbê na stosie.


; wypisanie liczby

call wypisz_liczbe
db "Wylosowana liczba: %i", 0xa, 0
wypisz_liczbe:
call [ebx+3*4]
add esp, 8

;--------

