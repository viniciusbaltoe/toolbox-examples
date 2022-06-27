segment code
..start:
mov ax, dados
mov ds, ax
mov ax, stack
mov ss,ax
mov sp,stacktop

; AQUI COMECA A EXECUCAO DO PROGRAMA PRINCIPAL

mov dx,mensini ; mensagem de inicio
mov ah,9
int 21h
mov ax,0 ; primeiro elemento da série
mov bx,1 ; segundo elemento da série

L10:
mov dx,ax
add dx,bx ; calcula novo elemento da série
mov ax,bx
mov bx,dx
call print_num
cmp dx, 0x8000
jb L10  ; jb é 32768 -> 32768 (decimal) = 0x8000 (hexa)
;jl L10   ; -32768

; AQUI TERMINA A EXECUCAO DO PROGRAMA PRINCIPAL

exit:
mov dx,mensfim ; mensagem de fim
mov ah,9
int 21h

quit:
mov ah,4CH ; retorna para o DOS com código 0
int 21h

print_num:
;; Aqui, você deve salvar o contexto
push ax
push bx
push cx
push dx

mov di,saida
call bin2ascii
mov dx,saida
mov ah,9
int 21h

;; Aqui, você deve recuperar o contexto
pop dx
pop cx
pop bx
pop ax
ret

bin2ascii:
push ax
push bx
push cx
push dx

add di, 4
mov bx, 10

mov cx, 5 ; Serão 5 divisões por 10
mov ax, dx
volta:
mov dx, 0
div bx
add dl, 0x30 ; Adiciona-se 30 ao resto de (ax, dx)/bx ; binário -> ascii
mov [di], dl
dec di
loop volta

pop dx
pop cx
pop bx
pop ax
ret


segment dados ;segmento de dados inicializados
mensini: db 'Programa que calcula a Série de Fibonacci. ',13,10,'$'
mensfim: db 'bye',13,10,'$'
saida: db '00000',13,10,'$'
segment stack stack
resb 256 ; reserva 256 bytes para formar a pilha
stacktop: ; posição de memória que indica o topo da pilha=SP
