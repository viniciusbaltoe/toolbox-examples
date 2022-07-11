;***************************************************************************
; Exercício de Programação
; Vinícius Breda Altoé
; Sistemas Embarcados
; 27/06/2022
;***************************************************************************
segment code
..start:
    mov 		ax,data
    mov 		ds,ax
    mov 		ax,stack
    mov 		ss,ax
    mov 		sp,stacktop

	; salvar modo corrente de video(vendo como est� o modo de video da maquina)
    mov  		ah,0Fh
    int  		10h
    mov  		[modo_anterior],al   

	; alterar modo de video para gr�fico 640x480 16 cores
    mov     	al,12h
   	mov     	ah,0
    int     	10h
;
; Desenho das retas divisórias
    mov		byte[cor], branco_intenso
    ; Borda Inferior
		mov		ax, 0
		push		ax
		mov		ax, 0
		push		ax
		mov		ax, 639
		push		ax
		mov		ax, 0
		push		ax
		call		line

	; Borda Direita
		mov		ax, 639
		push		ax
		mov		ax, 0
		push		ax
		mov		ax, 639
		push		ax
		mov		ax, 479
		push		ax
		call		line

	; Borda Superior
		mov		ax, 639
		push		ax
		mov		ax, 479
		push		ax
		mov		ax, 0
		push		ax
		mov		ax, 479
		push		ax
		call		line

	; Borda Esquerda
		mov		ax, 0
		push		ax
		mov		ax, 479
		push		ax
		mov		ax, 0
		push		ax
		mov		ax, 0
		push		ax
		call		line
    
    ; Borda Superior do campo de legenda.
        mov		ax, 0
		push		ax
		mov		ax, 90
		push		ax
		mov		ax, 639
		push		ax
		mov		ax, 90
		push		ax
		call		line
		
    ; Borda Inferior dos campos superiores
        mov		ax, 0
		push		ax
		mov		ax, 400
		push		ax
		mov		ax, 639
		push		ax
		mov		ax, 400
		push		ax
		call		line
    
    ; Borda Direita de Abrir
        mov		ax, 90
		push		ax
		mov		ax, 400
		push		ax
		mov		ax, 90
		push		ax
		mov		ax, 479
		push		ax
		call		line
    
    ; Borda Direita de Sair
        mov		ax, 150
		push		ax
		mov		ax, 400
		push		ax
		mov		ax, 150
		push		ax
		mov		ax, 479
		push		ax
		call		line
    
    ; Borda Vertical Central
        mov		ax, 320
		push		ax
		mov		ax, 90
		push		ax
		mov		ax, 320
		push		ax
		mov		ax, 479
		push		ax
		call		line

    ; Borda Direita de Passa-Altas
        mov		ax, 470
		push		ax
		mov		ax, 400
		push		ax
		mov		ax, 470
		push		ax
		mov		ax, 479
		push		ax
		call		line  
	; Retangulo Inferior
		; Linha Superior
			mov		ax, 50
			push		ax
			mov		ax, 70
			push		ax
			mov		ax, 590
			push		ax
			mov		ax, 70
			push		ax
			call		line
		; Linha Direita
			mov		ax, 590
			push		ax
			mov		ax, 70
			push		ax
			mov		ax, 590
			push		ax
			mov		ax, 20
			push		ax
			call		line
		; Linha Inferior
			mov		ax, 590
			push		ax
			mov		ax, 20
			push		ax
			mov		ax, 50
			push		ax
			mov		ax, 20
			push		ax
			call		line
		; Linha Esquerda
			mov		ax, 50
			push		ax
			mov		ax, 20
			push		ax
			mov		ax, 50
			push		ax
			mov		ax, 70
			push		ax
			call		line

;
; Escrita das Legendas Brancas
	call legendas_brancas
;
; Configuração Inicial do Mouse
	mov 	ax,		0
	int 	33h		
	mov 	ax,		1
	int 	33h		 
;
; Dinâmica do Programa
	wait_mouse_click:
		mov 	ax,		5              
		mov 	bx,		0
		int 	33h					; bx = n de click, cx = x e dx = y

		cmp 	bx,	0 
    	jne 	click_status
    	jmp 	wait_mouse_click 	; se AL = 0 então nada foi digitado e a animação do jogo deve continuar
	
    click_status:
		cmp		dx,		80		; Verifica se o local clicado possui um y correspondente as opções
		jb		click_options
		jmp		wait_mouse_click
	
	click_options:
    	cmp 	cx, 	    	90		
    	jb 	Click_Abrir
    	cmp 	cx, 	 		150	
    	jb 	Click_Sair	
		cmp 	cx, 	 		320	
    	jb 	Click_PBaixas	
		cmp 	cx, 	 		470	
    	jb 	Click_PAltas
		cmp 	cx, 	 		640	
    	jb 	Click_Gradiente
    	jmp 	wait_mouse_click
;
; Ações dos Clicks
	; Click Abrir
		Click_Abrir:
			; Mouse OFF
				call mouse_off
			; Pintar legendas de branco
				call legendas_brancas
			; Pintar de Amarelo
				mov		byte[cor], amarelo
				call print_abrir
			
			; Limpar a Imagem
				call limpar_imagem_base
			; Carregar Arquivo da Imagem
				; https://stackoverflow.com/questions/45778035/how-to-read-image-file-and-display-on-screen-in-windows-tasm-dosbox
				call read_file
			; Mouse ON
				call mouse_on
			; Retorno ao loop
				jmp wait_mouse_click

	; Click Sair
		Click_Sair:
			; Mouse OFF
				call mouse_off
			; Pintar legendas de branco
				call legendas_brancas
			; Pintar de Amarelo
				mov		byte[cor], amarelo
				call print_sair
			; Mouse ON
				call mouse_on
			; Finalizar o Programa
				mov ah,0 ; set video mode
				mov al,[modo_anterior] ; recupera o modo anterior
				int 10h
				mov ax,4c00h
				int 21h
	; Click Passa-Baixas
		Click_PBaixas:
			; Mouse OFF
				call mouse_off
			; Pintar legendas de branco
				call legendas_brancas
			; Pintar de Amarelo
				mov		byte[cor], amarelo
				call print_pbaixas
			; Limpar janela dos filtros
				call limpa_filtro
			; Filtro
				call filtro_pbaixa
			; Mouse ON
				call mouse_on
			; Retorno ao loop
				jmp wait_mouse_click
	; Click Passa-Altas
		Click_PAltas:
			; Mouse OFF
				call mouse_off
			; Pintar legendas de branco
				call legendas_brancas
			; Pintar de Amarelo
				mov		byte[cor], amarelo
				call print_paltas
			; Limpar janela dos filtros
				call limpa_filtro
			; Filtro
				call filtro_palta
			; Mouse ON
				call mouse_on
			; Retorno ao loop
				jmp wait_mouse_click
	; Click Gradiente
		Click_Gradiente:
			; Mouse OFF
				call mouse_off
			; Pintar legendas de branco
				call legendas_brancas
			; Pintar de Amarelo
				mov		byte[cor], amarelo
				call print_gradiente
			; Limpar janela dos filtros
				call limpa_filtro
			; Filtro
				call filtro_gradiente
			; Mouse ON
				call mouse_on
			; Retorno ao loop
				jmp wait_mouse_click

;
;***************************************************************************
;								  FUNÇÕES
;***************************************************************************
;	FUNÇÃO LEGENDAS_BRANCAS
		legendas_brancas:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov		byte[cor], branco_intenso
			call print_nome
			call print_abrir
			call print_sair
			call print_pbaixas
			call print_paltas
			call print_gradiente
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_NOME
		print_nome:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
    		mov     	cx, 53			;numero de caracteres
    		mov     	bx, 0
    		mov     	dh, 27			;linha 0-29
    		mov     	dl, 12			;coluna 0-79
		loop_p1:
			call	cursor
		    mov     al,[bx+nome]
			call	caracter
		    inc     bx			;proximo caracter
			inc		dl			;avanca a coluna
		    loop    loop_p1
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_ABRIR
		print_abrir:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
    		mov     	cx, 5			;numero de caracteres
    		mov     	bx, 0
    		mov     	dh, 2			;linha 0-29
    		mov     	dl, 3			;coluna 0-79
		loop_p2:
			call	cursor
		    mov     al,[bx+abrir]
			call	caracter
		    inc     bx			;proximo caracter
			inc		dl			;avanca a coluna
		    loop    loop_p2
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_SAIR
		print_sair:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov     	cx, 4			;numero de caracteres
			mov     	bx, 0
			mov     	dh, 2			;linha 0-29
			mov     	dl, 13			;coluna 0-79
		loop_p3:
			call	cursor
		    mov     al,[bx+sair]
			call	caracter
		    inc     bx			;proximo caracter
			inc		dl			;avanca a coluna
		    loop    loop_p3
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_PBAIXAS
		print_pbaixas:
    		; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov     	cx, 12			;numero de caracteres
    		mov     	bx, 0
    		mov     	dh, 2			;linha 0-29
    		mov     	dl, 24			;coluna 0-79
		loop_p4:
			call	cursor
		    mov     al,[bx+pbaixas]
			call	caracter
		    inc     bx			;proximo caracter
			inc		dl			;avanca a coluna
		    loop    loop_p4
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_PALTAS
		print_paltas:
    		; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov     	cx, 11			;numero de caracteres
    		mov     	bx, 0
    		mov     	dh, 2			;linha 0-29
    		mov     	dl, 44			;coluna 0-79
		loop_p5:
			call	cursor
		    mov     al,[bx+paltas]
			call	caracter
		    inc     bx			;proximo caracter
			inc		dl			;avanca a coluna
		    loop    loop_p5
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_GRADIENTE
		print_gradiente:
    		; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov     	cx, 9			;numero de caracteres
    		mov     	bx, 0
    		mov     	dh, 2			;linha 0-29
    		mov     	dl, 65			;coluna 0-79
		loop_p6:
			call	cursor
		    mov     al,[bx+gradiente]
			call	caracter
		    inc     bx			;proximo caracter
			inc		dl			;avanca a coluna
		    loop    loop_p6
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO MOUSE_ON
		mouse_on:
			mov 	ax,		1
			int 	33h
		ret
;___________________________________________________________________________
;	FUNÇÃO MOUSE_OFF
		mouse_off:
			mov 	ax,		2
			int 	33h
		ret
;___________________________________________________________________________
;	FUNÇÃO READ_FILE
	read_file:
		; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
		; Abertura do Arquivo
			mov 	ah, 	3dh			; Config para abrir o arquivo
			mov		al,		00			; 00 = read only
			mov		dx,		file_cores
			int 	21h					; Abre o arquivo, ax = file handle
			mov		[handle],	ax			
		
		; Verificação se abriu
			lahf
			and 	ah,		01           
			cmp 	ah,		01           
			jne 	file_ready
			ret							; Se não abrir, volta ao menu.
		; Leitura do Arquivo
			file_ready:
				mov 	byte[img_ok],		1	; Sinaliza que a imagem está disponível para os filtros.
				mov 	word[x_value],		0	; Coluna
				mov 	word[y_value],		0	; Linha
				mov 	word[bytes_len],	0 	; Número de bytes lidos

				mov 	cx,		300				; Numero de Linhas da Imagem

			linha_y:
				push 	cx
				mov 	cx,		300				; Numero de colunas da Imagem

			coluna_x:
				push 	cx

			prox_caracter:
				mov 	bx,			[handle]
				mov 	dx, 		buffer
				mov 	cx,			1      			; Numero de caracteres a serem lidos
				mov 	ah,			3Fh      		; Código de AH para ler arquivos
				int 	21h       					; Executa a Interrupção
				cmp 	ax,			cx				; Verificação de leitura do caracter
				jne 	fim_leitura					; Se não leu nada, então acabou
				mov 	al, 		[buffer]		; al = caracter
				mov 	[ascii],	al				; O conteúdo de ascii passa a ser o caracter
				cmp 	al,			20h				; Se al = ' ' -> zf = 1, 20h é o código ascii do caracter "espaço"
				je 		add_num						; logo o programa terminou de ler o número
				inc 	word[bytes_len]				; Se al != ' ' -> bytes_len++
				call 	ascii_2_decimal				; Converte ascii para decimal
				jmp 	prox_caracter				; Continua a leitura

			add_num:
				inc		word[cores_count]			; Contagem das cores
				cmp 	word[bytes_len],	0		; Verificação para o primeiro caracter = ' '
				je 		prox_caracter				; Ignora o ' ' e continua a leitura
				call 	num_real					; Transformação para unidade, dezena e centena

		; Pintura dos pixel's
				call 	pintar_pixel
				inc 	word[x_value]
				pop 	cx
				loop 	coluna_x					; Interrompe o loop para [x_value] = 300

				dec 	word[y_value]				; A referência é superior esquerda
				mov 	word[x_value],		0		; X volta a ser zero, será printada outra linha
				pop 	cx							; Elimina o valor de x
				loop 	linha_y						; Interrompe o loop para [y_value] = 300
		; Fim da Leitura e Fechamento do Arquivo
			fim_leitura:
				pop 	cx
				pop		cx    
				mov 	word[y_value],	0
				mov 	word[x_value],	0
				mov 	bx,				[handle]
				mov 	ah,				3eh
				mov 	al,				00h
				int 	21h 
		; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
		ret
;___________________________________________________________________________
;	FUNÇÃO ASCII_2_DECIMAL
		ascii_2_decimal:
			; push's
						pushf
						push 		ax
						push 		bx
						push		cx
						push		dx
						push		si
						push		di
						push		bp
			xor 	cx,				cx				; cx = 0
			mov 	al,				[ascii]		
			sub 	al,				30h
			mov 	cl, 			byte[unidade] 
			mov 	ch, 			byte[dezena] 
			; Aqui há deslocamentos caso o número tenha mais de 1 algarismo
			mov 	byte[unidade],	al  			
			mov 	byte[dezena],	cl  
			mov 	byte[centena],	ch  
			;pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret

;___________________________________________________________________________
;	FUNÇÃO NUM_REAL
		num_real:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			xor		ah,		ah				; ah = 0
			xor 	ch,		ch				; ch = 0
			mov 	al,		byte[centena]	; Algarismo da centena
			mov 	bl,		100
			mul 	bl
			mov 	cx,		ax 

			xor 	ah,		ah				; ah = 0
			mov 	al,		byte[dezena]	; Algarismo da dezena
			mov 	bl,		10
			mul 	bl
			add 	cx,		ax

			xor 	ah,		ah				; ah = 0
			mov 	al,		[unidade]		; Algarismo da unidade
			add 	cx,		ax 
			mov 	byte[valor_real],	cl

			mov 	byte[unidade],	0
			mov 	byte[dezena],	0
			mov 	byte[centena],	0
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PINTAR_PIXEL
		pintar_pixel:      
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov 	dl,				16
			mov 	al,				byte[valor_real]
			xor 	ah,				ah
			div 	dl   
			mov 	byte[cor],		al
			mov 	bx,				[x_value]
			add 	bx,				10
			push 	bx 									; Valor inicial de x
			mov 	bx,				[y_value]
			add 	bx,				395		
			push 	bx   								; Valor inicial de y (referencia inf. esq.)
			call 	plot_xy
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
		ret 
;___________________________________________________________________________
;	FUNÇÃO LIMPAR_IMAGEM_BASE:
		limpar_imagem_base:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov 	word[y_value],	0
			mov 	word[x_value],	0
			mov 	cx,				300			; Quantidade de linhas
			linha_img:
				push 	cx
				mov 	cx, 			300     ; Quantidade de colunas
			coluna_img:
				;push's
					push 	ax
					push 	bx
					push 	dx
				mov 	byte[cor],	preto   
				mov 	bx,			[x_value]
				add 	bx,			10
				push 	bx       
				mov 	bx,			[y_value]
				add 	bx,			395
				push 	bx       
				call 	plot_xy
				; pop's
					pop 	dx
					pop 	bx
					pop 	ax
				inc 	word[x_value]
				loop 	coluna_img
				dec 	word[y_value]
				mov 	word[x_value],0
				pop 	cx
				loop 	linha_img
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret

;___________________________________________________________________________
;	FUNÇÃO FILTRO_PBAIXA
		filtro_pbaixa:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			; Verifica se a Img já foi aberta
				cmp 	byte[img_ok], 	0
				jne		continue_pbaixa
				; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
				ret
				continue_pbaixa:
			; Filtro
				call 	read_first_3_lines
				mov 	word[x_value],		0
				mov 	word[y_value],		0
				mov 	bx,					0
				mov 	cx,					300

				; Aplica o filtro na primeira linha
					fpb_first_line:
						xor 	ax,		ax
						xor 	dx,		dx
						mov 	al,		byte[second_line+bx]
						mov 	dl,		byte[second_line+bx+1]
						add 	ax,		dx
						mov 	dl,		byte[second_line+bx-1]
						add 	ax,		dx
						mov 	dl,		byte[first_line+bx]
						add 	ax,		dx
						mov 	dl,		byte[first_line+bx+1]
						add 	ax,		dx
						mov 	dl,		byte[first_line+bx-1]
						add 	ax,		dx
						mov 	dl,		byte[third_line+bx]
						add 	ax,		dx
						mov 	dl,		byte[third_line+bx+1]
						add 	ax,		dx
						mov 	dl,		byte[third_line+bx-1]
						add 	ax,		dx
						mov 	dl,					9
						div 	dl
						mov 	[current_byte],		al
						call 	print_filtros
						inc 	word[x_value]
						inc 	bx
						loop 	fpb_first_line
				; Linhas seguintes
					dec word[y_value]
					mov word[x_value],0  
					mov cx,298
					fpb_next_lines:
						push cx
						call read_3_lines
						mov bx,0
						fpb_colunas:
							xor 	ax,		ax
							xor 	dx,		dx
							mov 	al,		byte[second_line+bx]
							mov 	dl,		byte[second_line+bx+1]
							add 	ax,		dx
							mov 	dl,		byte[second_line+bx-1]
							add 	ax,		dx
							mov 	dl,		byte[first_line+bx]
							add 	ax,		dx
							mov 	dl,		byte[first_line+bx+1]
							add 	ax,		dx
							mov 	dl,		byte[first_line+bx-1]
							add 	ax,		dx
							mov 	dl,		byte[third_line+bx]
							add 	ax,		dx
							mov 	dl,		byte[third_line+bx+1]
							add 	ax,		dx
							mov 	dl,		byte[third_line+bx-1]
							add 	ax,		dx
							mov 	dl,					9
							div 	dl
							mov 	[current_byte],		al
							call 	print_filtros
							inc 	word[x_value]
							inc 	bx

							cmp 	bx,					300
							jne 	fpb_colunas
							dec 	word[y_value]
							mov 	word[x_value],		0
							pop 	cx
							loop fpb_next_lines

			; Fim da função
				; Fechamento do Arquivo
					mov 	bx,		[handle]
					mov 	ah,		3eh
					mov 	al,		00h
					int 	21h
				; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
				fim_pbaixa:
					ret
;___________________________________________________________________________
;	FUNÇÃO LIMPA_FILTRO
		limpa_filtro:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov 	word[y_value],	0
			mov 	word[x_value],	0
			mov 	cx,				300			; Quantidade de linhas
			linha_pbaixa:
				push 	cx
				mov 	cx, 			300     ; Quantidade de colunas
			coluna_pbaixa:
				;push's
					push 	ax
					push 	bx
					push 	dx
				mov 	byte[cor],	preto   
				mov 	bx,			[x_value]
				add 	bx,			330
				push 	bx       
				mov 	bx,			[y_value]
				add 	bx,			395
				push 	bx       
				call 	plot_xy
				; pop's
					pop 	dx
					pop 	bx
					pop 	ax
				inc 	word[x_value]
				loop 	coluna_pbaixa
				dec 	word[y_value]
				mov 	word[x_value],0
				pop 	cx
				loop 	linha_pbaixa
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
;___________________________________________________________________________
;	FUNÇÃO READ_FIRST_3_LINES
		read_first_3_lines: 
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov 	ah,			3dh        
			mov 	al,			00h
			mov 	dx,			file_cores
			int 	21h
			mov 	[handle],	ax  

			mov 	bx, 				[handle]
			mov 	dx, 				buffer      	
			mov 	cx,					1          		; Qntd de bytes a serem lidos
			mov 	ah,					3Fh          	; LER Arquivo
			int 	21h                 
			mov 	word[bytes_len],	0

			rf3l_first_line:
				mov 	bx,			[handle]
				mov 	dx, 		buffer
				mov 	cx,			1      	
				mov 	ah,			3Fh    				; LER Arquivo
				int 	21h       
				mov 	al, 		[buffer]
				mov 	[ascii],	al
				cmp 	al,			20h					; 20h == ' '
				je 		rf3l_f_num_lido
				call 	ascii_2_decimal					; O número n terminou de ser lido
				jmp 	rf3l_first_line

			rf3l_f_num_lido:
				call 	num_real
				mov 	ah,					[num_real]
				mov 	bx,					[bytes_len]
				mov 	[bx+first_line],	ah
				inc 	word[bytes_len]
				cmp 	word[bytes_len],	300
				jne 	rf3l_first_line

			mov 	word[bytes_len],		0
			rf3l_second_line:
				mov 	bx,			[handle]
				mov 	dx, 		buffer
				mov 	cx,			1      
				mov 	ah,			3Fh      
				int 	21h     	  
				mov 	al, 		[buffer]
				mov 	[ascii],	al
				cmp 	al,			20h
				je 		rf3l_s_num_lido
				call 	ascii_2_decimal
				jmp 	rf3l_second_line

			rf3l_s_num_lido:
				call 	num_real
				mov 	ah,					[num_real]
				mov 	bx,[bytes_len]
				mov 	[bx+second_line],ah
				inc 	word[bytes_len]
				cmp 	word[bytes_len],	300
				jne 	rf3l_second_line

			mov word[bytes_len],0
			rf3l_third_line:
				mov 	bx,			[handle]
				mov 	dx, 		buffer
				mov 	cx,			1      
				mov 	ah,			3Fh      
				int 	21h       
				mov 	al, 		[buffer]
				mov 	[ascii],	al
				cmp 	al,			20h
				je 		rf3l_t_num_lido
				call 	ascii_2_decimal
				jmp rf3l_third_line

			rf3l_t_num_lido:
				call 	num_real
				mov 	ah,					[num_real]
				mov 	bx,[bytes_len]
				mov 	[bx+third_line],	ah
				inc 	word[bytes_len]
				cmp 	word[bytes_len],	300
				jne 	rf3l_third_line

			; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
			ret
;___________________________________________________________________________
;	FUNÇÃO PRINT_FILTROS
		print_filtros:      
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			mov 	bl,		16
			mov 	al,		byte[current_byte]
			xor 	ah,		ah
			div 	bl   

			mov 	byte[cor],	al
			mov 	bx,			[x_value]
			add 	bx,			330
			push 	bx   
			mov 	bx,[y_value]
			add 	bx,			395
			push 	bx   
			call 	plot_xy
			; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
			ret 
;___________________________________________________________________________
;	FUNÇÃO READ_3_LINES
	read_3_lines:
		; push's
			pushf
			push 		ax
			push 		bx
			push		cx
			push		dx
			push		si
			push		di
			push		bp
		mov 	bx,	0
		mov 	cx,	300
		prox_linha:
			mov 	al,					[second_line+bx]
			mov 	[first_line+bx],	al						; First_line possui o valor da Second_line
			mov 	al,					[third_line+bx]
			mov 	[second_line+bx], 	al						; Second_line possui o valor da Third_line
			inc 	bx
			loop prox_linha

		mov 	word[bytes_len],	0
		read_3_line_loop:
			mov 	bx,			[handle]
			mov 	dx,	 		buffer
			mov 	cx,			1      
			mov 	ah,			3Fh   
			int 	21h	
			cmp 	ax,			cx
			jne 	exit_r3l       
			mov 	al, 		[buffer]
			mov 	[ascii],	al
			cmp 	al,			20h
			je 		next_num_r3l
			call 	ascii_2_decimal
			jmp 	read_3_line_loop

		next_num_r3l:
			call num_real
			mov ah,[valor_real]
			mov bx,[bytes_len]
			mov [third_line + bx],ah
			inc word[bytes_len]
			cmp word[bytes_len], 300
			jne read_3_line_loop

		exit_r3l:
			; pop's
				pop		bp
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
			ret
	
;___________________________________________________________________________
;	FUNÇÃO FILTRO_PALTA
		filtro_palta:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			; Verifica se a Img já foi aberta
				cmp 	byte[img_ok], 	0
				jne		continue_palta
				; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
				ret
				continue_palta:
			; Filtro
				call 	read_first_3_lines
				mov 	word[x_value],		0
				mov 	word[y_value],		0
				mov 	bx,					0
				mov 	cx,					300
				
				; Aplicação do Filtro
					mov 	cx,				298
					fpa_next_lines:
						push cx
						call read_3_lines
						mov bx,0
						fpa_colunas:
							xor 	ax,			ax
							xor 	dx,			dx
							mov 	al,			[second_line+bx]
							mov 	dh,			9
							mul 	dh			
							xor 	dh,			dh
							mov 	dl,			[second_line+bx+1]
							sub 	ax,			dx
							mov 	dl,			[second_line+bx-1]
							sub 	ax,			dx
							mov 	dl,			[first_line+bx]
							sub 	ax,			dx
							mov 	dl,			[first_line+bx+1]
							sub 	ax,			dx
							mov 	dl,			[first_line+bx-1]
							sub 	ax,			dx
							mov 	dl,			[third_line+bx]
							sub 	ax,			dx
							mov 	dl,			[third_line+bx+1]
							sub 	ax,			dx
							mov 	dl,			[third_line+bx-1]
							sub 	ax,			dx

							push	ax
							or  	ax,				0           
							jns 	ax_positivo
							pop 	ax
							xor		ax,				ax
							push	ax

							ax_positivo:
								pop		ax
								cmp 	ax,					255
								jb 		next_palta
								mov 	ax,					255
							next_palta:
								mov 	[current_byte],		al
								call 	print_filtros
								inc 	word[x_value]
								inc 	bx
								cmp 	bx,					300
						jne 	fpa_colunas
						dec 	word[y_value]
						mov 	word[x_value],				0
						pop 	cx
						loop 	fpa_next_lines

			; Fim da função
				; Fechamento do Arquivo
					mov 	bx,		[handle]
					mov 	ah,		3eh
					mov 	al,		00h
					int 	21h
				; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
				fim_palta:
					ret
;___________________________________________________________________________
;	FUNÇÃO FILTRO_GRADIENTE
		filtro_gradiente:
			; push's
				pushf
				push 		ax
				push 		bx
				push		cx
				push		dx
				push		si
				push		di
				push		bp
			; Verifica se a Img já foi aberta
				cmp 	byte[img_ok], 	0
				jne		continue_gradiente
				; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
				ret
				continue_gradiente:
			; Filtro
				call 	read_first_3_lines
				mov 	word[x_value],		0
				mov 	word[y_value],		0
				mov 	bx,					0
				mov 	cx,					300

				; Aplica-se o filtro na primeira linha
					fgradiente_first_line:
						xor 	ax,		ax
						xor 	dx,		dx
						mov 	al,		[first_line+bx]
						mov 	dh,		2
						imul 	dh								; Signed Multiply -> ax
						xor 	dh,		dh
						sub 	dx,		ax
						mov 	ax,		dx
						xor 	dh,		dh
						mov 	dl,		[first_line+bx+1]
						sub 	ax,		dx 
						mov 	dl,		[first_line+bx-1]
						sub 	ax,		dx
						mov 	dx,		ax
						mov 	al,		[third_line+bx]
						xor 	ah,		ah
						push 	bx
						mov 	bh,		2
						mul 	bh
						pop 	bx
						add 	ax,			dx
						mov 	dl,			[third_line+bx+1]
						xor 	dh,			dh
						add 	ax,			dx
						mov 	dl,			[third_line+bx-1]
						add 	ax,			dx
						push	ax								; Guarda na memória
						or 		ax,			0					; Logical Inclusive OR
						jns 	gradiente_y						; Jump if SF = 0
						pop		ax								; Recupera da Memoria
						neg		ax
						push	ax								; Guarda na Memoria

					gradiente_y:
						xor 	ax,		ax
						xor 	dx,		dx
						mov 	dl,		[first_line+bx+1]
						add 	ax,		dx 
						mov 	dl,		[first_line+bx-1]
						sub 	ax,		dx
						mov 	dl,		[third_line+bx+1]
						add 	ax,		dx 
						mov 	dl,		[first_line+bx-1]
						sub 	ax,		dx
						mov 	dx,		ax
						mov 	al,		[second_line+bx+1]
						xor 	ah,		ah
						
						push 	bx
						mov 	bh,		2
						mul 	bh
						pop 	bx
						
						add 	ax,		dx 
						mov 	dx,		ax
						mov 	al,		[second_line+bx-1]
						xor 	ah,		ah
						
						push 	bx								; Guarda na Memoria
						mov 	bh,		2
						mul 	bh
						pop 	bx								; Recupera da Memoria
						
						sub 	dx,		ax
						mov 	ax,		dx
						mov 	dx,		ax
						
						or 		ax,				0
						jns 	gradiente_xy
						neg 	dx

					gradiente_xy:
						pop		ax								; Recupera da Memoria
						add 	dx,				ax
						cmp 	dx,				255				; if dx>255, dx = 255
						jb 		dx_menor						; if dx<255||dx==255, continua
						mov 	dx,				255

					dx_menor:
						mov 	[current_byte],		dl
						call 	print_filtros
						inc 	word[x_value]
						inc 	bx
						dec 	cx
						cmp 	cx,0
						je 		fgradiente_fim_first_line
						jmp 	fgradiente_first_line

					fgradiente_fim_first_line:
						dec 	word[y_value]
						mov 	word[x_value],	0
						mov 	cx,				298

				; Aplica-se o filtro nas linhas seguintes
					fg_next_lines:
						push 	cx								; Guarda o contador
						call 	read_3_lines
						mov 	bx,				0

						fg_colunas:
							xor 	ax,		ax
							xor 	dx,		dx
							mov 	al,		[first_line+bx]
							mov 	dh,		2
							imul 	dh
							xor 	dh,		dh
							sub 	dx,		ax
							mov 	ax,		dx
							xor 	dh,		dh
							mov 	dl,		[first_line+bx+1]
							sub 	ax,		dx 
							mov 	dl,		[first_line+bx-1]
							sub 	ax,		dx
							mov 	dx,		ax
							mov 	al,		[third_line+bx]
							xor 	ah,		ah
							push 	bx
							mov 	bh,		2
							mul 	bh
							pop 	bx
							add 	ax,		dx
							mov 	dl,		[third_line+bx+1]
							xor 	dh,		dh
							add 	ax,		dx
							mov 	dl,		[third_line+bx-1]
							add 	ax,		dx
							push	ax									; Guarda na Memória
							or 		ax,		0
							jns 	gradiente_y_next_lines
							pop		ax									; Recupera da Memória
							neg		ax									;
							push	ax									; Guarda na Memória

						gradiente_y_next_lines:
							xor 	ax,		ax
							xor 	dx,		dx
							mov 	dl,		[first_line+bx+1]
							add 	ax,		dx 
							mov 	dl,		[first_line+bx-1]
							sub 	ax,		dx
							mov 	dl,		[third_line+bx+1]
							add 	ax,		dx 
							mov 	dl,		[first_line+bx-1]
							sub 	ax,		dx
							mov 	dx,		ax
							mov 	al,		[second_line+bx+1]
							xor 	ah,		ah

							push	bx
							mov 	bh,		2
							mul 	bh
							pop 	bx
							
							add 	ax,		dx 
							mov 	dx,		ax
							mov 	al,		[second_line+bx-1]
							xor 	ah,		ah
							
							push 	bx
							mov 	bh,		2
							mul 	bh
							pop 	bx

							sub 	dx,		ax
							mov 	ax,		dx
							mov 	dx,		ax
							or 		ax,		0
							jns 	gradiente_xy_next_lines
							neg 	dx
							
						gradiente_xy_next_lines:
							pop		ax							; Recupera da Memória
							add 	dx,		ax
							cmp 	dx,		255
							jb 		dx_menor_next_lines
							mov 	dx,		255

						dx_menor_next_lines:
							mov	 	[current_byte],		dl
							call 	print_filtros
							inc 	word[x_value]
							inc 	bx
							cmp 	bx,					300
							je		fim_colunas
							jmp 	fg_colunas
						
						fim_colunas:
							dec 	word[y_value]
							mov 	word[x_value],	0
							pop 	cx
							dec 	cx
							cmp 	cx,				0
							je 		fim_gradiente
							jmp 	fg_next_lines
			; Fim da função
				fim_gradiente:
				; Fechamento do Arquivo
					mov 	bx,		[handle]
					mov 	ah,		3eh
					mov 	al,		00h
					int 	21h
				; pop's
					pop		bp
					pop		di
					pop		si
					pop		dx
					pop		cx
					pop		bx
					pop		ax
					popf
			ret
;___________________________________________________________________________
;***************************************************************************
;___________________________________________________________________________
;   FUNÇÃO CURSOR
	; dh = linha (0-29) e  dl=coluna  (0-79)
	cursor:
		pushf
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
		push		bp
		mov     	ah,2
		mov     	bh,0
		int     	10h
		pop		bp
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		ret
;___________________________________________________________________________
;   FUNÇÃO CARACTER 
		; escrito na posi��o do cursor
		; al= caracter a ser escrito
		; cor definida na variavel cor
	caracter:
		pushf
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
		push		bp
    	mov     	ah,9
    	mov     	bh,0
    	mov     	cx,1
   		mov     	bl,[cor]
    	int     	10h
		pop		bp
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		ret
;___________________________________________________________________________
;   FUNÇÃO PLOT_XY
		; push x; push y; call plot_xy;  (x<639, y<479)
		; cor definida na variavel cor
		plot_xy:
			push		bp
			mov		bp,sp
			pushf
			push 		ax
			push 		bx
			push		cx
			push		dx
			push		si
			push		di
		    mov     	ah,0ch
		    mov     	al,[cor]
		    mov     	bh,0
		    mov     	dx,479
			sub			dx,[bp+4]
		    mov     	cx,[bp+6]
		    int     	10h
			pop		di
			pop		si
			pop		dx
			pop		cx
			pop		bx
			pop		ax
			popf
			pop		bp
			ret		4
;___________________________________________________________________________
;   FUNÇÃO CIRCLE
		; push xc; push yc; push r; call circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
		; cor definida na variavel cor
	circle:
		push 	bp
		mov	 	bp,sp
		pushf                        ;coloca os flags na pilha
		push 	ax
		push 	bx
		push	cx
		push	dx
		push	si
		push	di

		mov		ax,[bp+8]    ; resgata xc
		mov		bx,[bp+6]    ; resgata yc
		mov		cx,[bp+4]    ; resgata r

		mov 	dx,bx	
		add		dx,cx       ;ponto extremo superior
		push    ax			
		push	dx
		call plot_xy

		mov		dx,bx
		sub		dx,cx       ;ponto extremo inferior
		push    ax			
		push	dx
		call plot_xy

		mov 	dx,ax	
		add		dx,cx       ;ponto extremo direita
		push    dx			
		push	bx
		call plot_xy

		mov		dx,ax
		sub		dx,cx       ;ponto extremo esquerda
		push    dx			
		push	bx
		call plot_xy

		mov		di,cx
		sub		di,1	 ;di=r-1
		mov		dx,0  	;dx ser� a vari�vel x. cx � a variavel y

		;aqui em cima a l�gica foi invertida, 1-r => r-1
		;e as compara��es passaram a ser jl => jg, assim garante 
		;valores positivos para d

		stay:				;loop
			mov		si,di
			cmp		si,0
			jg		inf       ;caso d for menor que 0, seleciona pixel superior (n�o  salta)
			mov		si,dx		;o jl � importante porque trata-se de conta com sinal
			sal		si,1		;multiplica por doi (shift arithmetic left)
			add		si,3
			add		di,si     ;nesse ponto d=d+2*dx+3
			inc		dx		;incrementa dx
			jmp		plotar
		inf:	
			mov		si,dx
			sub		si,cx  		;faz x - y (dx-cx), e salva em di 
			sal		si,1
			add		si,5
			add		di,si		;nesse ponto d=d+2*(dx-cx)+5
			inc		dx		;incrementa x (dx)
			dec		cx		;decrementa y (cx)

		plotar:	
			mov		si,dx
			add		si,ax
			push    si			;coloca a abcisa x+xc na pilha
			mov		si,cx
			add		si,bx
			push    si			;coloca a ordenada y+yc na pilha
			call plot_xy		;toma conta do segundo octante
			mov		si,ax
			add		si,dx
			push    si			;coloca a abcisa xc+x na pilha
			mov		si,bx
			sub		si,cx
			push    si			;coloca a ordenada yc-y na pilha
			call plot_xy		;toma conta do s�timo octante
			mov		si,ax
			add		si,cx
			push    si			;coloca a abcisa xc+y na pilha
			mov		si,bx
			add		si,dx
			push    si			;coloca a ordenada yc+x na pilha
			call plot_xy		;toma conta do segundo octante
			mov		si,ax
			add		si,cx
			push    si			;coloca a abcisa xc+y na pilha
			mov		si,bx
			sub		si,dx
			push    si			;coloca a ordenada yc-x na pilha
			call plot_xy		;toma conta do oitavo octante
			mov		si,ax
			sub		si,dx
			push    si			;coloca a abcisa xc-x na pilha
			mov		si,bx
			add		si,cx
			push    si			;coloca a ordenada yc+y na pilha
			call plot_xy		;toma conta do terceiro octante
			mov		si,ax
			sub		si,dx
			push    si			;coloca a abcisa xc-x na pilha
			mov		si,bx
			sub		si,cx
			push    si			;coloca a ordenada yc-y na pilha
			call plot_xy		;toma conta do sexto octante
			mov		si,ax
			sub		si,cx
			push    si			;coloca a abcisa xc-y na pilha
			mov		si,bx
			sub		si,dx
			push    si			;coloca a ordenada yc-x na pilha
			call plot_xy		;toma conta do quinto octante
			mov		si,ax
			sub		si,cx
			push    si			;coloca a abcisa xc-y na pilha
			mov		si,bx
			add		si,dx
			push    si			;coloca a ordenada yc-x na pilha
			call plot_xy		;toma conta do quarto octante

			cmp		cx,dx
			jb		fim_circle  ;se cx (y) est� abaixo de dx (x), termina     
			jmp		stay		;se cx (y) est� acima de dx (x), continua no loop


		fim_circle:
			pop		di
			pop		si
			pop		dx
			pop		cx
			pop		bx
			pop		ax
			popf
			pop		bp
			ret		6
;___________________________________________________________________________
;   FUNÇÃO FULL_CIRCLE
	; push xc; push yc; push r; call full_circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
	; cor definida na variavel cor					  
	full_circle:
		push 	bp
		mov	 	bp,sp
		pushf                        ;coloca os flags na pilha
		push 	ax
		push 	bx
		push	cx
		push	dx
		push	si
		push	di

		mov		ax,[bp+8]    ; resgata xc
		mov		bx,[bp+6]    ; resgata yc
		mov		cx,[bp+4]    ; resgata r

		mov		si,bx
		sub		si,cx
		push    ax			;coloca xc na pilha			
		push	si			;coloca yc-r na pilha
		mov		si,bx
		add		si,cx
		push	ax		;coloca xc na pilha
		push	si		;coloca yc+r na pilha
		call line


		mov		di,cx
		sub		di,1	 ;di=r-1
		mov		dx,0  	;dx ser� a vari�vel x. cx � a variavel y

		;aqui em cima a l�gica foi invertida, 1-r => r-1
		;e as compara��es passaram a ser jl => jg, assim garante 
		;valores positivos para d

		stay_full:				;loop
			mov		si,di
			cmp		si,0
			jg		inf_full       ;caso d for menor que 0, seleciona pixel superior (n�o  salta)
			mov		si,dx		;o jl � importante porque trata-se de conta com sinal
			sal		si,1		;multiplica por doi (shift arithmetic left)
			add		si,3
			add		di,si     ;nesse ponto d=d+2*dx+3
			inc		dx		;incrementa dx
			jmp		plotar_full
		inf_full:	
			mov		si,dx
			sub		si,cx  		;faz x - y (dx-cx), e salva em di 
			sal		si,1
			add		si,5
			add		di,si		;nesse ponto d=d+2*(dx-cx)+5
			inc		dx		;incrementa x (dx)
			dec		cx		;decrementa y (cx)

		plotar_full:	
			mov		si,ax
			add		si,cx
			push	si		;coloca a abcisa y+xc na pilha			
			mov		si,bx
			sub		si,dx
			push    si		;coloca a ordenada yc-x na pilha
			mov		si,ax
			add		si,cx
			push	si		;coloca a abcisa y+xc na pilha	
			mov		si,bx
			add		si,dx
			push    si		;coloca a ordenada yc+x na pilha	
			call 	line

			mov		si,ax
			add		si,dx
			push	si		;coloca a abcisa xc+x na pilha			
			mov		si,bx
			sub		si,cx
			push    si		;coloca a ordenada yc-y na pilha
			mov		si,ax
			add		si,dx
			push	si		;coloca a abcisa xc+x na pilha	
			mov		si,bx
			add		si,cx
			push    si		;coloca a ordenada yc+y na pilha	
			call	line

			mov		si,ax
			sub		si,dx
			push	si		;coloca a abcisa xc-x na pilha			
			mov		si,bx
			sub		si,cx
			push    si		;coloca a ordenada yc-y na pilha
			mov		si,ax
			sub		si,dx
			push	si		;coloca a abcisa xc-x na pilha	
			mov		si,bx
			add		si,cx
			push    si		;coloca a ordenada yc+y na pilha	
			call	line

			mov		si,ax
			sub		si,cx
			push	si		;coloca a abcisa xc-y na pilha			
			mov		si,bx
			sub		si,dx
			push    si		;coloca a ordenada yc-x na pilha
			mov		si,ax
			sub		si,cx
			push	si		;coloca a abcisa xc-y na pilha	
			mov		si,bx
			add		si,dx
			push    si		;coloca a ordenada yc+x na pilha	
			call	line

			cmp		cx,dx
			jb		fim_full_circle  ;se cx (y) est� abaixo de dx (x), termina     
			jmp		stay_full		;se cx (y) est� acima de dx (x), continua no loop


		fim_full_circle:
			pop		di
			pop		si
			pop		dx
			pop		cx
			pop		bx
			pop		ax
			popf
			pop		bp
			ret		6

;___________________________________________________________________________
;	FUNÇÃO LINE
	; push x1; push y1; push x2; push y2; call line;  (x<639, y<479)
	line:
		push		bp
		mov		bp,sp
		pushf                        ;coloca os flags na pilha
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
		mov		ax,[bp+10]   ; resgata os valores das coordenadas
		mov		bx,[bp+8]    ; resgata os valores das coordenadas
		mov		cx,[bp+6]    ; resgata os valores das coordenadas
		mov		dx,[bp+4]    ; resgata os valores das coordenadas
		cmp		ax,cx
		je		line2
		jb		line1
		xchg		ax,cx
		xchg		bx,dx
		jmp		line1
		line2:		; deltax=0
				cmp		bx,dx  ;subtrai dx de bx
				jb		line3
				xchg		bx,dx        ;troca os valores de bx e dx entre eles
		line3:	; dx > bx
				push		ax
				push		bx
				call 		plot_xy
				cmp		bx,dx
				jne		line31
				jmp		fim_line
		line31:		inc		bx
				jmp		line3
		;deltax <>0
		line1:
		; comparar m�dulos de deltax e deltay sabendo que cx>ax
			; cx > ax
				push		cx
				sub		cx,ax
				mov		[deltax],cx
				pop		cx
				push		dx
				sub		dx,bx
				ja		line32
				neg		dx
		line32:		
				mov		[deltay],dx
				pop		dx

				push		ax
				mov		ax,[deltax]
				cmp		ax,[deltay]
				pop		ax
				jb		line5

			; cx > ax e deltax>deltay
				push		cx
				sub		cx,ax
				mov		[deltax],cx
				pop		cx
				push		dx
				sub		dx,bx
				mov		[deltay],dx
				pop		dx

				mov		si,ax
		line4:
				push		ax
				push		dx
				push		si
				sub		si,ax	;(x-x1)
				mov		ax,[deltay]
				imul		si
				mov		si,[deltax]		;arredondar
				shr		si,1
		; se numerador (DX)>0 soma se <0 subtrai
				cmp		dx,0
				jl		ar1
				add		ax,si
				adc		dx,0
				jmp		arc1
		ar1:		sub		ax,si
				sbb		dx,0
		arc1:
				idiv		word [deltax]
				add		ax,bx
				pop		si
				push		si
				push		ax
				call		plot_xy
				pop		dx
				pop		ax
				cmp		si,cx
				je		fim_line
				inc		si
				jmp		line4

		line5:		cmp		bx,dx
				jb 		line7
				xchg		ax,cx
				xchg		bx,dx
		line7:
				push		cx
				sub		cx,ax
				mov		[deltax],cx
				pop		cx
				push		dx
				sub		dx,bx
				mov		[deltay],dx
				pop		dx



				mov		si,bx
		line6:
				push		dx
				push		si
				push		ax
				sub		si,bx	;(y-y1)
				mov		ax,[deltax]
				imul		si
				mov		si,[deltay]		;arredondar
				shr		si,1
		; se numerador (DX)>0 soma se <0 subtrai
				cmp		dx,0
				jl		ar2
				add		ax,si
				adc		dx,0
				jmp		arc2
		ar2:		sub		ax,si
				sbb		dx,0
		arc2:
				idiv		word [deltay]
				mov		di,ax
				pop		ax
				add		di,ax
				pop		si
				push		di
				push		si
				call		plot_xy
				pop		dx
				cmp		si,dx
				je		fim_line
				inc		si
				jmp		line6

		fim_line:
				pop		di
				pop		si
				pop		dx
				pop		cx
				pop		bx
				pop		ax
				popf
				pop		bp
				ret		8

;
;***************************************************************************
;									DADOS
;***************************************************************************
	segment data
	cor		db		branco_intenso

	; Legenda das Cores
		; I R G B COR
		; 0 0 0 0 preto
		; 0 0 0 1 azul
		; 0 0 1 0 verde
		; 0 0 1 1 cyan
		; 0 1 0 0 vermelho
		; 0 1 0 1 magenta
		; 0 1 1 0 marrom
		; 0 1 1 1 branco
		; 1 0 0 0 cinza
		; 1 0 0 1 azul claro
		; 1 0 1 0 verde claro
		; 1 0 1 1 cyan claro
		; 1 1 0 0 rosa
		; 1 1 0 1 magenta claro
		; 1 1 1 0 amarelo
		; 1 1 1 1 branco intenso
	;
	preto			equ		0
	azul			equ		1
	verde			equ		2
	cyan			equ		3
	vermelho		equ		4
	magenta			equ		5
	marrom			equ		6
	branco			equ		7
	cinza			equ		8
	azul_claro		equ		9
	verde_claro		equ		10
	cyan_claro		equ		11
	rosa			equ		12
	magenta_claro	equ		13
	amarelo			equ		14
	branco_intenso	equ		15

	modo_anterior	db		0
	linha   		dw  	0
	coluna  		dw  	0
	deltax			dw		0
	deltay			dw		0	

	nome    		db  	'Vinicius Breda Altoe, Sistemas Embarcados - 7 Periodo'
	abrir 			db		'Abrir'
	sair 			db		'Sair'
	pbaixas			db		'Passa-Baixas'
	paltas			db		'Passa-Altas'
	gradiente		db		'Gradiente'

	file_cores		db		"imagem.txt$", 	0
	handle			dw		1						; Para armazenar o identificador do arquivo
	buffer			db		0						; Buffer para guardar os dados da imagem
	img_ok			db		0						; Será 1 quando for aberta a imagem

	x_value			dw		0
	y_value			dw		0
	unidade			db		0
	dezena			db		0
	centena			db		0
	valor_real		db		0
	bytes_len		dw		0
	ascii			db		0

	cores_count		dw		0

	first_line  	resb  	300
	second_line    	resb  	300
	third_line  	resb  	300
	current_byte    db		0

	;*************************************************************************
	segment stack stack
	resb 		512
	stacktop:
