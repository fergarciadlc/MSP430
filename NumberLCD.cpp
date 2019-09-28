#include "io430.h"
#include "LCD16x2.h"

unsigned char DMillar, UMillar, Centena, Decena, Unidad;
unsigned int Dato;

int main( void )
{
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;
  
  Ini_LCD();                  //Solo una vez, inicializa el LCD 
  
  Cmd_Lcd(0x28);
    
  Dato_Lcd('a');
  
    Dato=0x00FF;

    DMillar=0x30;
    UMillar=0x30;
    Centena=0x30;
    Decena=0x30;
    Unidad=0x30;

    while(Dato>=10000)
    {
        Dato=Dato-10000;
        DMillar++;
    }
    while(Dato>=1000)
    {
        Dato=Dato-1000;
        UMillar++;
    }
    while(Dato>=100)
    {
        Dato=Dato-100;
        Centena++;
    }
    while(Dato>=10)
    {
        Dato=Dato-10;
        Decena++;
    }

    Unidad=Unidad+Dato;


 
  return 0;
}
