section .data
    ; Definicje danych sta³ych
    menu db "1. Kamien", 10, "2. Papier", 10, "3. Scyzoryk", 10, "Wybierz przedmiot:", 0
    choice db 0          ; Wybór u¿ytkownika (zapisany jako pojedynczy bajt)
    comp_choice db 0     ; Wybór komputera (zapisany jako pojedynczy bajt)
    result_msg db "Komputer wylosowa³ ", 0
    rock db "kamien", 0
    paper db "papier", 0
    scissors db "scyzoryk", 0
    win_msg db " i przegra³.", 10, 0
    lose_msg db " i wygra³.", 10, 0
    draw_msg db " i zremisowa³.", 10, 0

section .bss
    buffer resb 4         ; Bufor na dane wejœciowe od u¿ytkownika
    time resb 4           ; Bufor na czas systemowy

section .text
    global _start

_start:
    ; Wyœwietlenie menu
    push menu
    push 50
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar

    ; Odczyt wyboru u¿ytkownika
    push buffer
    push 2
    push 0 ; file descriptor for stdin
    push 2 ; getchar function index in asmloader API
    call [ebx + 2*4] ; getchar

    ; Zapis wyboru u¿ytkownika
    pop eax ; remove return value from getchar
    mov [choice], al

    ; Pobranie aktualnego czasu
    push time
    push 0 ; time function index in asmloader API
    call [ebx + 0*4] ; time

    ; Wygenerowanie losowego wyboru komputera na podstawie czasu
    pop eax ; remove return value from time
    and eax, 0x03
    add eax, '1'
    mov [comp_choice], al

    ; Wyœwietlenie wyboru komputera
    push result_msg
    push 19
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar

    ; Wyœwietlenie wyboru komputera
    mov al, [comp_choice]
    cmp al, '1'
    je .comp_rock
    cmp al, '2'
    je .comp_paper
    cmp al, '3'
    je .comp_scissors

.comp_rock:
    push rock
    push 7
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar
    jmp .check_result

.comp_paper:
    push paper
    push 7
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar
    jmp .check_result

.comp_scissors:
    push scissors
    push 9
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar

.check_result:
    ; Porównanie wyborów i wyœwietlenie wyniku
    mov al, [choice]
    mov bl, [comp_choice]

    cmp al, bl
    je .draw

    cmp al, '1'
    je .rock_vs_others
    cmp al, '2'
    je .paper_vs_others
    cmp al, '3'
    je .scissors_vs_others

.rock_vs_others:
    cmp bl, '3'
    je .user_wins
    cmp bl, '2'
    je .user_loses

.paper_vs_others:
    cmp bl, '1'
    je .user_wins
    cmp bl, '3'
    je .user_loses

.scissors_vs_others:
    cmp bl, '2'
    je .user_wins
    cmp bl, '1'
    je .user_loses

.draw:
    push draw_msg
    push 15
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar
    jmp .exit

.user_wins:
    push win_msg
    push 12
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar
    jmp .exit

.user_loses:
    push lose_msg
    push 11
    push 1 ; file descriptor for stdout
    push 1 ; putchar function index in asmloader API
    call [ebx + 1*4] ; putchar
    jmp .exit

.exit:
    ; Zakoñczenie programu
    push 0 ; exit status
    push 0 ; exit function index in asmloader API
    call [ebx + 0*4] ; exit
