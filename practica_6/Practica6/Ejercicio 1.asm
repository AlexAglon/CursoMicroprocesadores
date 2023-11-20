		PROCESSOR 16F877		; Indicamos la version del procesador y en la siguiente linea la libreria del mismo
		INCLUDE <P16F877.INC>	

		VAL EQU H'20'     
		
		ORG 0			  
		GOTO INICIO		  

		ORG 5			
INICIO:	CLRF PORTA		  	; Limpiamos el puerto A
      	BSF STATUS, RP0	  	; Colocamos RP0 en 1 y RP1 en 0, para movernos al banco 1
		BCF STATUS, RP1	  	
		MOVLW H'00'		  	; Cargamos el valor 0 en W 
		MOVWF ADCON1      	; Carga los puertos A y E que se usan para operaciones analogicas y digitales (entrada/salida)
		CLRF PORTD			; Limpiamos el puerto D
      	BCF STATUS,RP0    	; Cambiamos al banco 0
      	MOVLW B'11101001' 	; Configuracion para ADCON0 
      	MOVWF ADCON0      	; Configuramos para que podamos hacer nuestra conversion

CICLO: 	BSF ADCON0,2      	; Asignanamos el valor 1 al bit 2 de ADCON0
       	CALL RETARDO      	; Nos movemos a retardo

ESPERA: BTFSC ADCON0,2    	; Preguntamos el si bit 2 de ADCON0 es 0
       	GOTO ESPERA       	; Si no es 0 nos movemos a ESPERA
       	MOVF ADRESH,W     	; Si es 0, Movemos el contenido de ADRESH a W
       	MOVWF PORTD       	; Posterior a eso movemos el valor de W a PORTB
       	GOTO CICLO			; Nos movemos ciclo a CICLO

RETARDO:MOVLW H'30'	 	  
       	MOVWF VAL			; Mueve el contenido de W a VAL

LOOP:	DECFSZ VAL			; Decrementa VAL hasta que valga 0
       	GOTO LOOP			; Si aaun no es 0 repetimos LOOP 
       	RETURN				; Si llegamos a 0 regresamos
    	END					
