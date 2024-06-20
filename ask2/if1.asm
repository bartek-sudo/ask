[bits 32] ; Ustawia tryb na 32 bity.

mov ebp, esp ; Ustawia wskaŸnik bazowy (EBP) na wskaŸnik stosu (ESP), co jest typowym pocz¹tkiem funkcji.
sub esp, 8 ; Rezerwuje 8 bajtów na stosie dla dwóch zmiennych (po 4 bajty na zmienn¹).
lea eax, [ebp-4] ; £aduje adres pierwszej zmiennej (4 bajty poni¿ej EBP) do rejestru EAX.
push eax ; Umieszcza adres pierwszej zmiennej na stosie.
lea eax, [ebp-8] ; £aduje adres drugiej zmiennej (8 bajtów poni¿ej EBP) do rejestru EAX.
push eax ; Umieszcza adres drugiej zmiennej na stosie.
call do_scan ; Wywo³uje funkcjê do_scan, która wczytuje dwie liczby od u¿ytkownika.
db "%i %i", 0 ; Definiuje ci¹g formatu dla funkcji do_scan.

do_scan: ; Etykieta dla funkcji do_scan.
call [ebx+4*4] ; Wywo³uje funkcjê scanf (lub odpowiednik), która wczytuje dwie liczby od u¿ytkownika.
add esp, 12 ; Czyœci stos po wywo³aniu funkcji.

mov eax, [ebp-8] ; £aduje wartoœæ pierwszej zmiennej do rejestru EAX.
mov edx, [ebp-4] ; £aduje wartoœæ drugiej zmiennej do rejestru EDX.
;---------
;cmp eax, 1
;je remis ; Skacze do etykiety remis, jeœli wartoœci s¹ równe.
CMP eax, edx
        JE  remis    ; Skacze do etykiety remis, jeœli wartoœci s¹ równe.
;=======================================
        CMP eax, 1
        JE  EQ1   
        CMP eax, 2
        JE  EQ2
        CMP eax, 3
        JE  EQ3
        
    EQ1:
        CMP edx, 2
        JE  gracz2_wygral
        CMP edx, 3
        JE  gracz1_wygral

    EQ2:  
        CMP edx, 1
        JE  gracz1_wygral
        CMP edx, 3
        JE  gracz2_wygral
 
    EQ3:  
        CMP edx, 1
        JE  gracz2_wygral
        CMP edx, 2
        JE  gracz1_wygral

;=======================================

;jg gracz1_wygral ; Skacze do etykiety gracz1_wygral, jeœli wartoœæ pierwszej zmiennej jest wiêksza.

;cmp eax, 3 ; Porównuje wartoœæ pierwszej zmiennej z 3.

;jne gracz2_wygral ; Skacze do etykiety gracz2_wygral, jeœli wartoœci nie s¹ równe.

;cmp dword [ebp-8], 1 ; Porównuje wartoœæ drugiej zmiennej z 1.

;je gracz2_wygral ; Skacze do etykiety gracz2_wygral, jeœli wartoœci s¹ równe.

gracz1_wygral: ; Etykieta dla przypadku, gdy gracz 1 wygrywa.
  push '1' ; Umieszcza '1' na stosie.
  jmp wynik ; Skacze do etykiety wynik.

remis: ; Etykieta dla przypadku remisu.
  push '0' ; Umieszcza '0' na stosie.
  jmp wynik ; Skacze do etykiety wynik.

gracz2_wygral: ; Etykieta dla przypadku, gdy gracz 2 wygrywa.
  push '2' ; Umieszcza '2' na stosie.
  jmp wynik ; Skacze do etykiety wynik.

wynik: ; Etykieta dla wyniku.
call wypisz_wynik ; Wywo³uje funkcjê wypisz_wynik, która wypisuje wynik na ekran.
  db "Wynik: %c", 0xa, 0 ; Definiuje ci¹g formatu dla funkcji wypisz_wynik.
  wypisz_wynik: ; Etykieta dla funkcji wypisz_wynik.
  call [ebx+3*4] ; Wywo³uje funkcjê printf (lub odpowiednik), która wypisuje wynik na ekran.
  add esp, 8 ; Czyœci stos po wywo³aniu funkcji.