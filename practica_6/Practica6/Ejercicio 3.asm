	;En las siguientes lineas se indica el procesador, las librerias 
	PROCESSOR 16F877		
	INCLUDE <P16F877.INC>

	valor1 	 equ H'21'			
	valor2 	 equ H'22'		
	valor3 	 equ H'23'		

	cte1 equ 1H		
	cte2 equ 2H			
	cte3 equ 3H		

	ve1 equ H'31'		
	ve2 equ H'35'		
	ve3 equ H'36'	
	mayor equ H'37'	

		ORG 0 			
		GOTO INICIO 	

		ORG 5 			
INICIO:	CLRF PORTA 			; Limpiamos el puerto A
		CLRF PORTD			; Limpiamos el puerto D
		CLRF PORTE			; Limpiamos el puerto E
		BSF STATUS, RP0	  	; Colocamos RP0 en 1 y RP1 en 0 para movernos al banco 1
		BCF STATUS, RP1	  	
		MOVLW H'00'		  	; Carga el valor 0 en W			
		MOVWF TRISD			; Configuramos puerto D como salida
		MOVLW H'00'		  	; Cargamos el valor 0 en W
		MOVWF ADCON1		; Cargamos los puertos A y E que se usan para operaciones analogicas y digitales (entrada/salida)
		BCF STATUS,RP0 		; Cambiamos al banco 0 		

;Guardaremos el valor de la conversion de los canales analogico digital dentro de las variables ve1 ve2 v3
 				
E1: 	MOVLW 0x69 		; Carga el valor 69 en W
		MOVWF ADCON0	; Configuramos ADCON0 para conversion analogico/digital en el canal 5
		BSF ADCON0,2 	; colocamos en 1 el bit 2 de ADCON0 para iniciar conversion analogico/digital
		CALL ESPERA		; Nos movemos a ESPERA
		MOVF ADRESH,W	; Movemos el contenido de ADRESH a W
		MOVWF ve1		; Movemos el contenido de W a ve1 para almacenar su valor

E2: 	MOVLW 0x71 		; Carga el valor 71 en W
		MOVWF ADCON0	; Configuramos ADCON0 para conversion analogico/digital en el canal 7
		BSF ADCON0,2 	; Establece en 1 el bit 2 de ADCON0
		CALL ESPERA		; Nos movemos a ESPERA
		MOVF ADRESH,W	; Mueve el contenido de ADRESH a W
		MOVWF ve2		; Mueve el contenido de W a ve2

E3: 	MOVLW 0x79 		; Carga el valor 79 en W
		MOVWF ADCON0    ; Configuramos ADCON0 para conversion analogico/digital en el canal 15
		BSF ADCON0,2 	; colocamos en 1 el bit 2 de ADCON0 para iniciar conversion analogico/digital
		CALL ESPERA		; Nos movemos a ESPERA
		MOVF ADRESH,W	; Mueve el contenido de ADRESH a W
		MOVWF ve3		; Mueve el contenido de W a ve3


; Proceoso de comparacion de los valores de las variables

;Comparamos ve1 y ve2 para saber cual es mas grande

Comp: 	MOVF ve1, W     	; Mueve el contenido de ve1 a W 
        SUBWF ve2, W    	; Restamos ve1 - ve2 
        BTFSS STATUS, C 	; Pregunta si la bandera de zero esta encendida
        GOTO MAYOR_1		; No es cero, Salta a MAYOR_1  ve1 > ve2
		GOTO MAYOR_2		; Si es cero, Salta a MAYOR_2 ve2 > ve1

;Compramos ve1 con ve3
MAYOR_1: MOVF ve1,W			; Mueve el contenido de ve1 a W
		 MOVWF mayor		; Movemos mayor el valor de w (Ve1)
		 SUBWF ve3, W       ; Restamos ve3 - w (Ve1)
         BTFSS STATUS, C    ; Pregunta si la bandera de zero esta encendida
		 GOTO ASIG1			; Si no, Salta a ASIG1 
		 MOVF ve3,W			; Si si, Mueve ve3 a W
		 MOVWF mayor		; mayor pasa a ser ve3
		 GOTO ASIG3			; Nos movemos a ASIG3

;Compramos ve2 con ve3
MAYOR_2: MOVF ve2,W			; Mueve el contenido de ve2 a W
		 MOVWF mayor		; Movemos a mayor el valor de w (Ve1)
         SUBWF ve3, W       ; Resta ve3 - w (ve2)
         BTFSS STATUS, C    ; Pregunta si la bandera de zero esta encendida
		 GOTO ASIG2			; Si no, Salta a ASIG2
		 MOVF ve3,W			; Si si, Mueve ve3 a W
		 MOVWF mayor		; mayor pasa a ser ve3
		 GOTO ASIG3			; Salta a ASIG3		


;Una vez que comparamos ya solo queda mostrar en el display que vector es el que es mayor
; Primero movemos el numero que indica el display 
; movemos al puerte d
; regresamos a E1

ASIG1:	MOVLW 0x01		; Mueve 01 a W
		MOVWF PORTD		; Mueve el contenido de W a PORTD
		GOTO E1			; Salta a E1

ASIG2:	MOVLW 0x03		; Mueve 03 a W
		MOVWF PORTD		
		GOTO E1			

ASIG3:	MOVLW 0x07		; Mueve 07 a W
		MOVWF PORTD	
		GOTO E1					
	

; Rutina para generar un retardo 

ESPERA:	CALL RETARDO	; Llamada a la subrutina RETARDO
		BTFSC ADCON0,2 
		GOTO ESPERA		
		RETURN		
			
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