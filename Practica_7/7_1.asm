processor 16f877  ; definimos que usaremos el procesador PIC16F877
include<p16f877.inc> ;Incluimos las definiciones para el procesaor 

        ORG 0 
        GOTO inicio

        ORG 5
INICIO: BSF STATUS,RP0 ; Realizaremos la configuracion del puerto en serie para transmision de datos
        BCF STATUS,RP1 
        BSF TXSTA,BRGH ; Establecemos el bit BRGH en el registro TXSTA para transmision de alta velocidad
        MOVLW D'129'  ; definimos Velocidad de transmision 
        MOVWF SPBRG  ; Cargamos la velocidad de tranmision
        BCF TXSTA,SYNC  ; Indicamos que el modo de sincronizacion sera asincrono
        BSF TXSTA,TXEN ; Habilitamos la tranmision colocando TXEN en TXSTA
        
        BCF STATUS,RP0 ; Nos movemos al registro de estado

        BSF RCSTA,SPEN ; Habilitamos el puerto serie
        BSF RCSTA,CREN ; Habilitamos el puerto de recepcion continua

RECIBE: BTFSS PIR1,RCIF ; verificamos si nuestro bit de interrupcion es diferente de 0 si no saltamos de nuevo a recibe
        GOTO RECIBE 
        
        MOVF RCREG,W ; si recibimos un caracter lo copiamos en el registro de recepcion RCREG
        MOVWF TXREG ; Una vez que copiamos el caracter lo enviamos a TXREG que es el registro de transmision

        BSF STATUS,RP0
TRASMITE: BTFSS TXSTA,TRMT ; Veirificamos si el bit de tramsision vacia esta en 1 (ya no hay mas datos)
        GOTO TRASMITE ; si el bit esta en 0 volvemos a transmite
        BCF STATUS,RP0 ; Nos movemos de banco
        GOTO RECIBE ; Nos movemos a recibe
END