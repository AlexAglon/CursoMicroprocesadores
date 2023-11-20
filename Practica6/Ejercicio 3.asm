	PROCESSOR 16F877		; Indica la version del procesador	
	INCLUDE <P16F877.INC>	; Incluye la libreria de la version del procesador

	valor1 	 equ H'21'			;Asigna el valor de 21 a valor1
	valor2 	 equ H'22'			;Asigna el valor de 22 a valor2
	valor3 	 equ H'23'			;Asigna el valor de 23 a valor3	

	cte1 equ 1H			; Asigna el valor de 1 a cte1
	cte2 equ 2H			; Asigna el valor de 2 a cte2	
	cte3 equ 3H			; Asigna el valor de 3 a cte3

	ve1 equ H'31'		; Asigna el valor de 31 a ve1	
	ve2 equ H'35'		; Asigna el valor de 35 a ve2
	ve3 equ H'36'		; Asigna el valor de 36 a ve3
	mayor equ H'37'		; Asigna el valor de 37 a mayor

		ORG 0 				;Especifica un origen (vector de reset)
		GOTO INICIO 		;C�digo del programa

		ORG 5 				;Indica origen para inicio del programa
INICIO:	CLRF PORTA 			; Limpia el puerto A
		CLRF PORTD			; Limpia el puerto D
		CLRF PORTE			; Limpia el puerto E
		BSF STATUS, RP0	  	; Coloca la bandera RP0 en 1
		BCF STATUS, RP1	  	; Coloca la bandera RP1 en 0, asi se mueve al banco 1	
		MOVLW H'00'		  	; Carga el valor 0 en W			
		MOVWF TRISD			; Configura puerto D como salida
		MOVLW H'00'		  	; Carga el valor 0 en W
		MOVWF ADCON1		; Carga los puertos A y E en ADCON1
		BCF STATUS,RP0 		; Cambia al banco 0 		
				
E1: 	MOVLW 0x69 		; Carga el valor 69 en W
		MOVWF ADCON0	; Mueve el contenido de W a ADCON0
		BSF ADCON0,2 	; Establece en 1 el bit 2 de ADCON0
		CALL ESPERA		; Llamada a la subrutina ESPERA
		MOVF ADRESH,W	; Mueve el contenido de ADRESH a W
		MOVWF ve1		; Mueve el contenido de W a ve1

E2: 	MOVLW 0x71 		; Carga el valor 71 en W
		MOVWF ADCON0	; Mueve el contenido de W a ADCON0
		BSF ADCON0,2 	; Establece en 1 el bit 2 de ADCON0
		CALL ESPERA		; Llamada a la subrutina ESPERA
		MOVF ADRESH,W	; Mueve el contenido de ADRESH a W
		MOVWF ve2		; Mueve el contenido de W a ve2

E3: 	MOVLW 0x79 		; Carga el valor 79 en W
		MOVWF ADCON0	; Mueve el contenido de W a ADCON0
		BSF ADCON0,2 	; Establece en 1 el bit 2 de ADCON0
		CALL ESPERA		; Llamada a la subrutina ESPERA
		MOVF ADRESH,W	; Mueve el contenido de ADRESH a W
		MOVWF ve3		; Mueve el contenido de W a ve3

Comp: 	MOVF ve1, W     	; Mueve el contenido de ve1 a W 
        SUBWF ve2, W    	; Resta ve2 - W
        BTFSS STATUS, C 	; Pregunta si el bit C de STATUS es 1
        GOTO MAYOR_1		; NO, Salta a MAYOR_1
		GOTO MAYOR_2		; SI, Salta a MAYOR_2

MAYOR_1: MOVF ve1,W			; Mueve el contenido de ve1 a W
		 MOVWF mayor		; Mueve el contenido de W a mayor
		 SUBWF ve3, W       ; Resta ve3 - W
         BTFSS STATUS, C    ; Pregunta si el bit C de STATUS es 1
		 GOTO ASIG1			; NO, Salta a ASIG1 
		 MOVF ve3,W			; SI, Mueve el contenido de ve3 a W
		 MOVWF mayor		; Mueve el contenido de W a mayor
		 GOTO ASIG3			; Salta a ASIG3

MAYOR_2: MOVF ve2,W			; Mueve el contenido de ve2 a W
		 MOVWF mayor		; Mueve el contenido de W a mayor
         SUBWF ve3, W       ; Resta ve3 - W
         BTFSS STATUS, C    ; Pregunta si el bit C de STATUS es 1
		 GOTO ASIG2			; NO, Salta a ASIG2
		 MOVF ve3,W			; SI, Mueve el contenido de ve3 a W
		 MOVWF mayor		; Mueve el contenido de W a mayor
		 GOTO ASIG3			; Salta a ASIG3		

ASIG1:	MOVLW 0x01		; Mueve 01 a W
		MOVWF PORTD		; Mueve el contenido de W a PORTD
		GOTO E1			; Salta a E1

ASIG2:	MOVLW 0x03		; Mueve 03 a W
		MOVWF PORTD		; Mueve el contenido de W a PORTD
		GOTO E1			; Salta a E1		

ASIG3:	MOVLW 0x07		; Mueve 07 a W
		MOVWF PORTD		; Mueve el contenido de W a PORTD
		GOTO E1			; Salta a E1			
	
ESPERA:	CALL RETARDO	; Llamada a la subrutina RETARDO
		BTFSC ADCON0,2 	; Pregunta si el bit 2 de ADCON0 es 0
		GOTO ESPERA		; NO, Salta a ESPERA	
		RETURN			; SI, Regresa a la subrutina
			
RETARDO: MOVLW cte1		; Guarda en el registo W el valor de cte1
		 MOVWF valor1	; Mueve el contenido del registro W al registro valor1
		
TRES: 	 MOVLW cte2		; Guarda en el registo W el valor de cte2
	  	 MOVWF valor2	; Mueve el contenido del registro W al registro valor2

DOS: 	 MOVLW cte3		; Guarda en el registo W el valor de cte3
	 	 MOVWF valor3	; Mueve el contenido del registro W al registro valor3

UNO: 	 DECFSZ valor3	; Decrementa el registro valor3 hasta cero
	 	 GOTO UNO		; Salta a UNO
	 	 DECFSZ valor2	; Decrementa el registro valor2 hasta cero
	 	 GOTO DOS		; Salta a DOS
	 	 DECFSZ valor1	; Decrementa el registro valor1 hasta cero
	 	 GOTO TRES		; Salta a TRES
	 	 RETURN			; Regresa de la subrutina
	 	 END			; Directiva de fin de programa