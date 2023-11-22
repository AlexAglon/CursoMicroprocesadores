#include <16F877.h>     //Archivo necesario para el controlador PIC16F877                                    
#fuses HS,NOWDT,NOPROTECT//cONFIGURAMOS FUSIBLES, OSCILADOR, QUITAMOS WHATCHDOG, Y NO SE HABILITA LA PROTECCION
#use delay(clock=20000000) //ESTABLECEMOS LA FRECUENCIA DE RELOJ A 20 MHZ                        
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW) //DEFINIMOS PINES SDA, SCL DEL BUS I2C
#include <i2c_Flex_LCD.c> // LIBRERIA PARA MANEJO DE LCD                              

int cont=0;  //VARIABLE QUE FUNCIONARA COMO CONTADOR
 
void escribir_i2c(){                              
   i2c_start(); //Inicia la comunicacion ic2                                   
   i2c_write(0x42); //Escribimos la direccion del dispositivo esclavo en el bus                               
   i2c_write(cont); //Escribe el valor de contador en el bus                            
   i2c_stop(); //Finalizamos la comunicacion                                              
}


void main(){
   lcd_init(0x4E,16,2); //Se inicializa el LCD con la direccion del esclavo
   lcd_backlight_led(ON);//Encendemos luz de led
  
   while(true)                                              
      { 
         escribir_i2c();//Llamamos a la funcion para escritura en el LCD
         output_b(cont);//Mandamos a la salida el valor de nuestro contador                                     
         lcd_gotoxy(1, 1);//Nos movemos a la fila 1 columna 1 del display                                 
         printf(lcd_putc, "Grupo 8");//Mandamos el mensaje                   
         lcd_gotoxy(1, 2);//Nos movemos a la fila 2 columna 1                       
         printf(lcd_putc, "Contador = %X",cont);//mandamos a imprimir el valor del contador
         delay_ms(500);//Esperamos 500 ms 
         cont++;//aumentamos el valor del contador                                          
      }
} 
