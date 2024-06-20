    [bits 32]
    
section .data
    ; Definicje danych stałych
    menu db "1. Kamien", 10, "2. Papier", 10, "3. Scyzoryk", 10, "Wybierz przedmiot:", 0
    choice db 0          ; Wybór użytkownika (zapisany jako pojedynczy bajt)
    comp_choice db 0     ; Wybór komputera (zapisany jako pojedynczy bajt)
    result_msg db "Komputer wylosowal ", 0
    rock db "kamien", 0
    paper db "papier", 0
    scissors db "scyzoryk", 0
    win_msg db " i przegral.", 10, 0
    lose_msg db " i wygral.", 10, 0
    draw_msg db " i zremisowal.", 10, 0

section .bss
    buffer resb 4         ; Bufor na dane wejściowe od użytkownika
    time resb 4           ; Bufor na czas systemowy

section .text
    global _start

_start:
    ; Wyświetlenie menu
    mov eax, 4            ; Kod operacji "write" (systemowe wywołanie 4)
    mov ebx, 1            ; Deskryptor pliku (1 - standardowe wyjście)
    mov ecx, menu         ; Adres danych do wyświetlenia
    mov edx, 50           ; Długość danych do wyświetlenia
    int 0x80              ; Wywołanie systemowe

    ; Odczyt wyboru użytkownika
    mov eax, 3            ; Kod operacji "read" (systemowe wywołanie 3)
    mov ebx, 0            ; Deskryptor pliku (0 - standardowe wejście)
    mov ecx, buffer       ; Bufor na dane wejściowe
    mov edx, 2            ; Liczba bajtów do odczytu
    int 0x80              ; Wywołanie systemowe

    ; Zapis wyboru użytkownika
    mov al, [buffer]      ; Zapis pierwszego bajtu z bufora do AL
    mov [choice], al      ; Zapis wartości AL do zmiennej choice

    ; Pobranie aktualnego czasu
    mov eax, 13           ; Kod operacji "time" (systemowe wywołanie 13)
    mov ebx, time         ; Adres bufora na czas systemowy
    int 0x80              ; Wywołanie systemowe

    ; Wygenerowanie losowego wyboru komputera na podstawie czasu
    mov eax, [time]       ; Odczyt wartości czasu z bufora
    and eax, 0x03         ; Maskowanie wartości, aby uzyskać zakres 0-3
    add eax, '1'          ; Dopasowanie do zakresu ASCII '1'-'3'
    mov [comp_choice], al ; Zapis wyboru komputera do zmiennej comp_choice

    ; Wyświetlenie wyboru komputera
    mov eax, 4            ; Kod operacji "write" (systemowe wywołanie 4)
    mov ebx, 1            ; Deskryptor pliku (1 - standardowe wyjście)
    mov ecx, result_msg   ; Adres danych do wyświetlenia
    mov edx, 19           ; Długość danych do wyświetlenia
    int 0x80              ; Wywołanie systemowe

    ; Sprawdzenie wyboru komputera
    mov al, [comp_choice] ; Odczyt wyboru komputera
    cmp al, '1'           ; Porównanie z '1' (kamień)
    je .comp_rock         ; Skok do etykiety .comp_rock jeśli równa się '1'
    cmp al, '2'           ; Porównanie z '2' (papier)
    je .comp_paper        ; Skok do etykiety .comp_paper jeśli równa się '2'
    cmp al, '3'           ; Porównanie z '3' (nożyce)
    je .comp_scissors     ; Skok do etykiety .comp_scissors jeśli równa się '3'

.comp_rock:
    ; Wyświetlenie wyboru komputera: kamień
    mov eax, 4
    mov ebx, 1
    mov ecx, rock
    mov edx, 7
    int 0x80
    jmp .check_result     ; Skok do sprawdzenia wyniku gry

.comp_paper:
    ; Wyświetlenie wyboru komputera: papier
    mov eax, 4
    mov ebx, 1
    mov ecx, paper
    mov edx, 7
    int 0x80
    jmp .check_result     ; Skok do sprawdzenia wyniku gry

.comp_scissors:
    ; Wyświetlenie wyboru komputera: nożyce
    mov eax, 4
    mov ebx, 1
    mov ecx, scissors
    mov edx, 9
    int 0x80

.check_result:
    ; Porównanie wyborów i wyświetlenie wyniku
    mov al, [choice]      ; Odczyt wyboru użytkownika
    mov bl, [comp_choice] ; Odczyt wyboru komputera

    ; Remis
    cmp al, bl
    je .draw              ; Skok do etykiety .draw jeśli są równe

    ; Wybor użytkownika: kamień
    cmp al, '1'
    je .rock_vs_others    ; Skok do etykiety .rock_vs_others jeśli równa się '1'

    ; Wybor użytkownika: papier
    cmp al, '2'
    je .paper_vs_others   ; Skok do etykiety .paper_vs_others jeśli równa się '2'

    ; Wybor użytkownika: nożyce
    cmp al, '3'
    je .scissors_vs_others ; Skok do etykiety .scissors_vs_others jeśli równa się '3'

.rock_vs_others:
    ; Porównanie wyboru komputera z kamieniem
    cmp bl, '3'
    je .user_wins         ; Skok do etykiety .user_wins jeśli komputer wybrał nożyce
    cmp bl, '2'
    je .user_loses        ; Skok do etykiety .user_loses jeśli komputer wybrał papier

.paper_vs_others:
    ; Porównanie wyboru komputera z papierem
    cmp bl, '1'
    je .user_wins         ; Skok do etykiety .user_wins jeśli komputer wybrał kamień
    cmp bl, '3'
    je .user_loses        ; Skok do etykiety .user_loses jeśli komputer wybrał nożyce

.scissors_vs_others:
    ; Porównanie wyboru komputera z nożycami
    cmp bl, '2'
    je .user_wins         ; Skok do etykiety .user_wins jeśli komputer wybrał papier
    cmp bl, '1'
    je .user_loses        ; Skok do etykiety .user_loses jeśli komputer wybrał kamień

.draw:
    ; Komunikat o remisie
    mov eax, 4
    mov ebx, 1
    mov ecx, draw_msg
    mov edx, 15
    int 0x80
    jmp .exit              ; Skok do etykiety .exit

.user_wins:
    ; Komunikat o wygranej użytkownika
    mov eax, 4
    mov ebx, 1
    mov ecx, win_msg
    mov edx, 12
    int 0x80
    jmp .exit              ; Skok do etykiety .exit

.user_loses:
    ; Komunikat o przegranej użytkownika
    mov eax, 4
    mov ebx, 1
    mov ecx, lose_msg
    mov edx, 11
    int 0x80
    jmp .exit              ; Skok do etykiety .exit

.exit:
    ; Zakończenie programu
    mov eax, 1             ; Kod operacji "exit" (systemowe wywołanie 1)
    xor ebx, ebx           ; Wartość statusu wyjścia
    int 0x80               ; Wywołanie systemowe
