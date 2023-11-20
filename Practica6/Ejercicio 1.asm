		PROCESSOR 16F877		; Indica la version del procesador	
		INCLUDE <P16F877.INC>	; Incluye la libreria de la version del procesador

		VAL EQU H'20'     ; Asigna la localidad 20 a VAL
		
		ORG 0			  ; Especifica un origen (Vector de reset) 
		GOTO INICIO		  ; Codigo del programa

		ORG 5				; Indica origen para inicio del programa
INICIO:	CLRF PORTA		  	; Limpia el puerto A
      	BSF STATUS, RP0	  	; Coloca la bandera RP0 en 1
		BCF STATUS, RP1	  	; Coloca la bandera RP1 en 0, asi se mueve al banco 1
		MOVLW H'00'		  	; Carga el valor 0 en W 
		MOVWF ADCON1      	; Carga los puertos A y E en ADCON1
		CLRF PORTD			; Limpia el puerto D
      	BCF STATUS,RP0    	; Cambia al banco 0
      	MOVLW B'11101001' 	; Configuracion para ADCON0 
      	MOVWF ADCON0      	; ADCS1 = 1 ADCS0 = 1 CHS2 = 0 CHS1 = 0 CHS0 = 0
						  	; GO/DONE = 0 - ADON = 1
CICLO: 	BSF ADCON0,2      	; Asigna el valor 1 al bit 2 de ADCON0
       	CALL RETARDO      	; Llamada a la subrutina RETARDO

ESPERA: BTFSC ADCON0,2    	; Pregunta el si bit 2 de ADCON0 es 0
       	GOTO ESPERA       	; NO, Vuelve a ESPERA
       	MOVF ADRESH,W     	; SI, Mueve el contenido de ADRESH a W
       	MOVWF PORTD       	; Mueve el contenido de W a PORTB
       	GOTO CICLO			; Salta a CICLO

RETARDO:MOVLW H'30'	 	  	; Carga el valor 30 en W 
       	MOVWF VAL			; Mueve el contenido de W a VAL

LOOP:	DECFSZ VAL			; Decrementa el valor de VAL hasta 0
       	GOTO LOOP			; VAL = 0 NO, Salta a LOOP 
       	RETURN				; VAL = 0 SI, Vuelve a la subrutina
    	END					; Directiva de fin de programa
