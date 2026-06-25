; ============================================================
; Proyecto 10: Maximo de N Numeros
; NASM x86-64 Linux
; Compilar:
;   nasm -f elf64 calculadora.asm -o calculadora.o
;   ld calculadora.o -o calculadora
; ============================================================

; ==============================================================
; MACROS  (Integrante 1)
;
; Nota tecnica: syscall puede destruir rcx y r11.
; Los macros PRINT y READ preservan esos registros con push/pop.
; Esto es importante porque las subrutinas los usan como contadores.
; ==============================================================

; PRINT direccion, longitud — imprime en stdout
%macro PRINT 2
    push rcx
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
    pop r11
    pop rcx
%endmacro

; READBYTE destino — lee UN byte de stdin -> rax = 1 si OK, 0 si EOF
%macro READBYTE 1
    push rcx
    push r11
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, 1
    syscall
    pop r11
    pop rcx
%endmacro

; EXIT codigo — termina el proceso
%macro EXIT 1
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

; ==============================================================
; DATOS  (Integrante 1)
; ==============================================================
section .data
    msg_n       db "Ingrese cuantos numeros desea comparar (max 2 digitos): "
    len_msg_n   equ $ - msg_n

    msg_num     db "Ingrese numero (max 2 digitos): "
    len_msg_num equ $ - msg_num

    msg_max     db "El maximo es: "
    len_msg_max equ $ - msg_max

    msg_err     db "Error: solo digitos del 0-9, max 2 caracteres.", 10
    len_msg_err equ $ - msg_err

    msg_nl      db 10
    len_msg_nl  equ 1

; ==============================================================
; BSS — variables sin inicializar  (Integrante 1)
; ==============================================================
section .bss
    buf_n       resb 4      ; buffer para N (max 2 digitos + \n + guard)
    buf_num     resb 4      ; buffer para cada numero ingresado
    buf_byte    resb 2      ; buffer auxiliar de 1 byte para lectura
    buf_res     resb 12     ; buffer para convertir resultado a texto

; ==============================================================
; CODIGO
; Registros globales:
;   r12 = N (total de numeros a ingresar)
;   r13 = maximo encontrado
;   r14 = i (contador del bucle)
; ==============================================================
section .text
global _start

; --------------------------------------------------------------
; _start — Punto de entrada  (Integrante 1)
; Orquesta el flujo completo del programa
; --------------------------------------------------------------
_start:
    PRINT msg_n, len_msg_n
    call leer_y_validar_n       ; Integrante 2 -> rax = N
    mov r12, rax                ; guardar N

    mov r13, -1                 ; maximo inicial (negativo garantiza actualizar en 1ra iter)

    call bucle_lectura          ; Integrante 3 -> r13 = maximo

    call mostrar_resultado      ; Integrante 5

    EXIT 0

; ==============================================================
; INTEGRANTE 2
; Subrutina: leer_y_validar_n
;
; Descripcion:
;   Lee caracteres del teclado uno por uno hasta encontrar \n.
;   Valida que sean entre 1 y 2 digitos numericos (0-9).
;   Convierte la cadena ASCII a valor binario.
;
; Retorna: rax = valor numerico de N
;
; Registros usados: rax, rbx, rcx, rdx (todos preservados internamente)
; ==============================================================
leer_y_validar_n:
.leer:
    xor rcx, rcx                ; rcx = cantidad de digitos leidos

.leer_char:
    READBYTE buf_byte           ; lee 1 byte -> rax = bytes leidos
    cmp rax, 0
    je .error                   ; EOF inesperado

    movzx rax, byte [buf_byte]

    ; si es \n, terminamos de leer
    cmp al, 10
    je .fin_lectura

    ; si es \r (Windows), ignorar
    cmp al, 13
    je .leer_char

    ; validar que sea digito '0'..'9'
    cmp al, '0'
    jl .error
    cmp al, '9'
    jg .error

    ; guardar en buf_n si hay espacio (max 2 digitos)
    cmp rcx, 2
    jge .error                  ; mas de 2 digitos -> error

    mov [buf_n + rcx], al
    inc rcx
    jmp .leer_char

.fin_lectura:
    ; verificar que hayamos leido al menos 1 digito
    cmp rcx, 0
    je .error

    jmp .convertir

.error:
    ; consumir resto de la linea si hay caracteres pendientes
    PRINT msg_err, len_msg_err
    PRINT msg_n, len_msg_n
    jmp .leer

.convertir:
    ; Convierte buf_n (rcx digitos ASCII) a numero binario en rax
    ; Algoritmo: valor = 0; for i in 0..rcx: valor = valor*10 + (buf[i]-'0')
    xor rax, rax
    xor rbx, rbx               ; rbx = indice i
.conv_loop:
    cmp rbx, rcx
    jge .conv_fin
    push rax
    movzx rax, byte [buf_n + rbx]
    sub rax, '0'               ; convertir ASCII -> digito
    mov rdx, rax
    pop rax
    imul rax, rax, 10          ; valor = valor * 10
    add rax, rdx               ; valor = valor + digito
    inc rbx
    jmp .conv_loop
.conv_fin:
    ret

; ==============================================================
; INTEGRANTE 3
; Subrutina: bucle_lectura
;
; Descripcion:
;   Repite r12 veces: pide un numero, lo lee/valida, actualiza maximo.
;   Usa r14 como variable de iteracion (i = 0 .. N-1).
;   Llama a leer_numero_valido (lectura) y actualizar_maximo (Int. 4).
;
; Modifica: r13 (via actualizar_maximo), r14
; ==============================================================
bucle_lectura:
    xor r14, r14                ; i = 0

.bucle_inicio:
    cmp r14, r12                ; i >= N?
    jge .bucle_fin              ; si, terminar

    PRINT msg_num, len_msg_num

    call leer_numero_valido     ; rax = numero ingresado
    call actualizar_maximo      ; Integrante 4: actualiza r13 si rax > r13

    inc r14                     ; i++
    jmp .bucle_inicio

.bucle_fin:
    ret

; Subrutina auxiliar (Integrante 3):
; Lee y valida un numero de 1-2 digitos del teclado byte a byte
; Retorna en rax el valor numerico
leer_numero_valido:
.leer:
    xor rcx, rcx               ; rcx = digitos leidos

.leer_char:
    READBYTE buf_byte
    cmp rax, 0
    je .error

    movzx rax, byte [buf_byte]

    cmp al, 10                 ; \n = fin de entrada
    je .fin_lectura

    cmp al, 13                 ; \r ignorar
    je .leer_char

    ; validar digito
    cmp al, '0'
    jl .error
    cmp al, '9'
    jg .error

    cmp rcx, 2                 ; max 2 digitos
    jge .error

    mov [buf_num + rcx], al
    inc rcx
    jmp .leer_char

.fin_lectura:
    cmp rcx, 0
    je .error
    jmp .convertir

.error:
    PRINT msg_err, len_msg_err
    PRINT msg_num, len_msg_num
    jmp .leer

.convertir:
    xor rax, rax
    xor rbx, rbx
.conv_loop:
    cmp rbx, rcx
    jge .conv_fin
    push rax
    movzx rax, byte [buf_num + rbx]
    sub rax, '0'
    mov rdx, rax
    pop rax
    imul rax, rax, 10
    add rax, rdx
    inc rbx
    jmp .conv_loop
.conv_fin:
    ret

; ==============================================================
; INTEGRANTE 4
; Subrutina: actualizar_maximo
;
; Descripcion:
;   Implementa el algoritmo de busqueda del maximo.
;   Compara el numero actual (rax) con el maximo guardado (r13).
;   Si rax > r13, actualiza r13 = rax.
;
; Entrada:  rax = numero actual, r13 = maximo anterior
; Salida:   r13 = nuevo maximo
; ==============================================================
actualizar_maximo:
    cmp rax, r13               ; numero actual > maximo?
    jle .no_actualizar         ; si no, no cambiar
    mov r13, rax               ; si si, actualizar maximo
.no_actualizar:
    ret

; ==============================================================
; INTEGRANTE 5
; Subrutina: mostrar_resultado
;
; Descripcion:
;   Imprime el mensaje "El maximo es: " seguido del valor en r13.
;   Convierte r13 de binario a ASCII usando num_a_ascii.
;   Responsable tambien de: compilar, enlazar y preparar el ZIP.
;
; Comandos de compilacion:
;   nasm -f elf64 calculadora.asm -o calculadora.o
;   ld calculadora.o -o calculadora
; ==============================================================
mostrar_resultado:
    PRINT msg_max, len_msg_max
    mov rax, r13
    call num_a_ascii            ; rax = longitud de cadena en buf_res
    mov r15, rax               ; guardar longitud en r15 (PRINT clobbers rax antes de usarlo)
    PRINT buf_res, r15
    PRINT msg_nl, len_msg_nl
    ret

; Subrutina auxiliar (Integrante 5):
; Convierte numero binario en rax a cadena ASCII en buf_res
; Algoritmo: divisiones sucesivas entre 10, extraer digitos en reversa, copiar
; Retorna: rax = longitud de la cadena
num_a_ascii:
    push rbx
    push rcx
    push rdx

    cmp rax, 0
    jne .no_cero
    mov byte [buf_res], '0'
    mov rax, 1
    jmp .fin2

.no_cero:
    ; Extraer digitos de derecha a izquierda (del menos al mas significativo)
    lea rbx, [buf_res + 10]    ; puntero temporal al final del buffer
    xor rcx, rcx               ; cuenta digitos extraidos

.div_loop:
    cmp rax, 0
    je .copiar
    xor rdx, rdx
    mov r9, 10
    div r9                     ; rax = cociente, rdx = digito (resto)
    add dl, '0'                ; convertir a ASCII
    dec rbx
    mov [rbx], dl              ; guardar en buffer temporal (derecha a izquierda)
    inc rcx
    jmp .div_loop

.copiar:
    ; Copiar digitos de buf temporal a buf_res (de izquierda a derecha)
    xor r9, r9
.copy_loop:
    cmp r9, rcx
    jge .fin
    mov dl, [rbx + r9]
    mov [buf_res + r9], dl
    inc r9
    jmp .copy_loop
.fin:
    mov rax, rcx
.fin2:
    pop rdx
    pop rcx
    pop rbx
    ret
