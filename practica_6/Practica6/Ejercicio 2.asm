		;En las siguientes lineas se indica el procesador, las librerias 
		PROCESSOR 16F877		
		INCLUDE <P16F877.INC>

		VAL EQU H'20'     
		
		ORG 0			   
		GOTO INICIO		  

		ORG 5			
INICIO:	CLRF PORTA		  	; Limpiamos el puerto A
      	BSF STATUS, RP0	  	; Colocamos RP0 en 1 y RP1 en 0 para movernos al banco 1
		BCF STATUS, RP1	  	
		MOVLW H'00'		  	; Cargamos el valor 0 en W 
		MOVWF ADCON1      	; Cargamos los puertos A y E que se usan para operaciones analogicas y digitales (entrada/salida)
		CLRF PORTD			; Limpiamos el puerto D
      	BCF STATUS,RP0    	; Cambiamos al banco 0
      	MOVLW B'11101001' 	; Configuracion para ADCON0 
      	MOVWF ADCON0      	; Configuramos para que podamos hacer nuestra conversion

CICLO: 	BSF ADCON0,2      	; Asignanamos el valor 1 al bit 2 de ADCON0
       	CALL RETARDO      	; Nos movemos a retardo

ESPERA:	BTFSC ADCON0,2    	; Pregunta si el bit 2 de ADCON0 es 0 lo que indica que la conversion se realizo con exito
       	GOTO ESPERA       	; Si no es 0 nos movemos a ESPERA
       	MOVF ADRESH,0     	; Si es 0 Movemos el contenido de ADRESH a  W
       	SUBLW 130H        	; Restamos 130 - W para saber si el voltaje es menor a 0
       	BTFSC STATUS,0    	; Pregunta si el bit Zero de status esta encendido
       	GOTO SALIDA0      	; Si es no, Salta a SALIDA0 lo que nos indica que es un valor menor a 0
       	MOVF ADRESH,0     	; Si es si, Movemos el contenido de ADRESH a W

		;Validando para 1
       	SUBLW 265H        	; Restamos 265 - W 
       	BTFSC STATUS,0    	; Pregunta si el bit Zero de status esta encendido
       	GOTO SALIDA1      	; si es no, Salta a SALIDA1 lo que no indica que es el valor es mayor a 0 pero menor a 2
       	MOVF ADRESH,0     	; Si es si Movemos el contenido de ADRESH a W (indica que el valor es mas grande)

		;Validando para 2
       	SUBLW 398H      	; Resta 398 - W 
       	BTFSC STATUS,0    	;Pregunta si el bit Zero de status esta encendido   
       	GOTO SALIDA2      	; si es no, Salta a SALIDA1 lo que no indica que es el valor es mayor a 1 pero menor a 3
		MOVF ADRESH,0     	; Si es si Movemos el contenido de ADRESH a W (indica que el valor es mas grande)

		;Validando para 3
       	SUBLW 3CAH      	; Resta 3CAH - W (3/5 VCC = 332H)
       	BTFSC STATUS,0    	; Pregunta si el bit Zero de status esta encendido
       	GOTO SALIDA3		;  si es no, Salta a SALIDA1 lo que no indica que es el valor es mayor a 2 pero menor a 4
		MOVF ADRESH,0     	; Si es si Movemos el contenido de ADRESH a W (indica que el valor es mas grande)


		;Validando para 4
       	SUBLW H'3F7'      	; Resta 3F7 - W (VCC = 3FFH)
       	BTFSC STATUS,0    	; Pregunta si el bit Zero de status esta encendido
       	GOTO SALIDA4		; si es no, Salta a SALIDA1 lo que no indica que es el valor es mayor a 3 pero menor a 5
		MOVF ADRESH,0     	; Si es si Movemos el contenido de ADRESH a W (indica que el valor es mas grande)


		;Validando para 5
       	SUBLW H'3FF'    	; Resta 3FFH - W
       	BTFSC STATUS,0    	; Pregunta si el bit Zero de status esta encendido
       	GOTO SALIDA5		; si es no, Salta a SALIDA1 lo que no indica que es el valor es mayor a 4

;Para cada salida lo primero que haremos sera mover el valor del caso que corresponde 0 a 5 a W
;posterior movemos al puertoD y regresamos a ciclo

SALIDA0:	MOVLW H'0'		
       		MOVWF PORTD   
       		GOTO CICLO	

SALIDA1:	MOVLW H'1'    
       		MOVWF PORTD   
       		GOTO CICLO			

SALIDA2:	MOVLW H'2'    	
       		MOVWF PORTD   	
       		GOTO CICLO		

SALIDA3:	MOVLW H'3'    
       		MOVWF PORTD   	
       		GOTO CICLO	
		
SALIDA4:	MOVLW H'4'  
       		MOVWF PORTD   	
       		GOTO CICLO	
		
SALIDA5:	MOVLW H'5'    	
       		MOVWF PORTD   
       		GOTO CICLO		

RETARDO:	MOVLW H'30'	  	; Cargamos el valor 30 en W 
       		MOVWF VAL		

LOOP:	DECFSZ VAL			; Decrementa el valor de VAL hasta 0
       	GOTO LOOP			; Si aun no llegamos a 0 nos movemos a LOOP 
       	RETURN				; si VAL = 0, regresamos
    	END					
