#include <16F877.h> //Archivo necesario para el controlador PIC16F877
#fuses HS,NOWDT,NOPROTECT //cONFIGURAMOS FUSIBLES, OSCILADOR, QUITAMOS WHATCHDOG, Y NO SE HABILITA LA PROTECCION
#use delay(clock=20000000) //ESTABLECEMOS LA FRECUENCIA DE RELOJ A 20 MHZ
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW) //DEFINIMOS PINES SDA, SCL DEL BUS I2C

int contador=0; //Declaracion de una variable contadora

//Funcion encargada de escribir el valor de contador atraves del bus i2c
void escribir_i2c(){
   i2c_start();        //Inicia la comunicacion ic2
   i2c_write(0x42);    //Escribimos la direccion del dispositivo esclavo en el bus     
   i2c_write(contador); //Escribe el valor de contador en el bus
   output_b(contador);  //Agrega la salida para el contador en el puerto B
   i2c_stop(); //Finalizamos la comunicacion            
}

void main(){
    while(true){ //Ciclo infinito
        escribir_i2c(); //Ejecitamos la funcion para escribir
        delay_ms(500); //Esperamos un tiempo de 500 ms
        contador++;//Aumentamos el valor de contador
    } 
}
