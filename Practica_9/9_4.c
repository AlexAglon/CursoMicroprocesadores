#include <16F877.h>     //Archivo necesario para el controlador PIC16F877                                    
#fuses HS,NOWDT,NOPROTECT//cONFIGURAMOS FUSIBLES, OSCILADOR, QUITAMOS WHATCHDOG, Y NO SE HABILITA LA PROTECCION
#use delay(clock=20000000) //ESTABLECEMOS LA FRECUENCIA DE RELOJ A 20 MHZ                        
#use i2c(MASTER, SDA=PIN_C4, SCL=PIN_C3,SLOW, NOFORCE_SW) //DEFINIMOS PINES SDA, SCL DEL BUS I2C
#include <i2c_Flex_LCD.c> // LIBRERIA PARA MANEJO DE LCD                          


int cont;  //VARIABLE QUE FUNCIONARA COMO CONTADOR

void input_i2c(){
   i2c_start();//Inicia la comunicacion ic2                                   
   i2c_write(0x41);//Escribimos la direccion del dispositivo esclavo en modo lectura 0x41                             
   cont = i2c_read();//Leemos el valor del esclavo y lo guaradamos en contador
   i2c_stop();//Finalizamos la comunicacion                                              
}

 
void escribir_i2c(){                              
   i2c_start(); //Inicia la comunicacion ic2                                   
   i2c_write(0x42); //Escribimos la direccion del dispositivo esclavo en el bus                               
   i2c_write(cont); //Escribe el valor de contador en el bus                            
   output_b(cont);//mandamos a la salida el valor de contador
   i2c_stop(); //Finalizamos la comunicacion                                              
}

void lcd_i2c(){
   i2c_start();//iniciamos comunicacion ic2
   lcd_init(0x4E,16,2);//Configuracion del LCD con la direccion del escalvo, el numero de columnas y renglones 2x16
   LCD_GOTOXY(1,1); //Nos colocamos en el renglon 1 columna 1
   printf(lcd_putc, "UNAM FI\n");//Mensaje que se vera en el lcd
   LCD_GOTOXY(1,2); //Nos posicionamos en la fila 2 columna 1
   printf(lcd_putc, "Contador = %i",cont);//Imprimimos en el LCD el valor de contador
   i2c_stop();//Finaliza la comunicacion i2c
}


void main(){
   while(true)
      {
         input_i2c(); //Esta funcion se encarga de realizar operaciones de lectura en i2c
         cont = cont * -1 ;//Cambiamos el signo del contador
         escribir_i2c(); //Llamamos a la funcion de escritura
         lcd_i2c();//Llamamos a la funcion lcd_i2c
         delay_ms(500); //Colocamos un delay de 500ms
      }
}
