[bits 32]

section .data
n equ 3 ; Initialize n with 0
n_format db "%u", 0

section .text

;        esp -> [ret] ; ret - adres powrotu do asmloader

        mov eax, 1  ; eax = 1

        ; Read n from user
        call [ebx+2*4] ; getchar();
        sub eax, '0'   ; Convert from ASCII to number
        mov [n], eax

        mov ecx, [n]  ; ecx = n ; mov instruction does not affect flags

        test ecx, ecx  ; ecx & ecx    ; ZF affected
        jz done        ; jump if zero ; jump if ZF = 1

petla    mul ecx  ; edx:eax = eax*ecx

        loop petla

done     push eax

;        esp -> [eax][ret]

        call getaddr
format:
        db "silnia = %u", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

        call [ebx+3*4]  ; printf("silnia = %u\n", eax);
        add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

        push 0         ; esp -> [0][ret]
        call [ebx+0*4] ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387