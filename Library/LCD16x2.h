//******************************************************************************
// Programa para controlar un LCD de 16 caracteres por 2 líneas, utilizando tres 
// terminales del microcontrolador
//
//                MSP430G2553
//        3.3V -----------------       SN74HC164            LCD 16 x 2
//        /|\ |                 |     ___________            _______
//         |--| Vcc         P2.2|--->|CLOCK    Qa|---RS --> |  ___  |-->5V
//            |             P2.3|-+->|A        Qb|---DB4--> | |   | |
//            |                 | |->|B        Qc|---DB5--> | |   | |
//            |                 |    |         Qd|---DB6--> | |   | |
//            |                 |    |         Qe|---DB7--> | | L | |
//            |                 |    |      CLEAR|-->5V     | | C | |
//            |                 |    |___________|          | | D | |
//            |                 |                           | |   | |
//            |             P2.4|-------------------- E --> | |___| |RW---|GND
//            |                 |                           |_______|GND--+
//            |             Vss |-->GND                                 __|__
//            |                 |                                        ___
// JULIO 2012  IPN                                                        _
// EDGAR R CALDERÓN DÍAZ
//****************************************************************************** 
#ifndef LCD16x2_H_
#define LCD16x2_H_

void Ini_LCD(void);
void Cmd_Lcd(unsigned char CMD);
void Dato_Lcd(unsigned char DATO);
void Send_10b(unsigned int Dat_Ser);

#define CLK  BIT2
#define AB   BIT3
#define E    BIT4

//Función de inicialización LCD para un Bus de datos de 4Bits
void Ini_LCD()
{
  __delay_cycles(1000000);      //
  P2SEL &= ~E+AB+CLK;           //Configuración de las terminales P2.2, P2.3 y P2.4 para controlar el
  P2SEL2 &= ~E+AB+CLK;          //74HC164 y el LCD
  P2DIR |= E+AB+CLK;
  P2OUT &= ~E+AB+CLK;
  
  __delay_cycles(15000);        //Since VDD reaches more than 4.5V wait more than 15ms
  
  P2OUT |= CLK;                 //Function Set(Interface data length is 8-bit)
  P2OUT &= ~CLK;                //|RS|R/W|DB7|DB6|DB5|DB4|
  P2OUT |= CLK;                 //| 0| 0 | 0 | 0 | 1 | 0 |
  P2OUT &= ~CLK;                //Wait more than 40 us
  P2OUT |= AB;
  P2OUT |= CLK;
  P2OUT &= ~CLK;
  P2OUT &= ~AB;
  P2OUT |= CLK;
  P2OUT &= ~CLK;
  P2OUT |= CLK;
  P2OUT &= ~CLK;
  P2OUT |= E;
  P2OUT &= ~E;
  __delay_cycles(40);
  
  Cmd_Lcd(0x28);                //Function Set (Set interface data length (DL) number ofdisplay lines (N) and character font (F).)
                                //|DL=1 8bits DL=0 4bits| N=1 2 lines N=0 1line| F=1 5x10dots F=0 5x7dots|
                                //|RS|R/W|DB7|DB6|DB5| DB4|
                                //|  |   |DB3|DB2|DB1| DB0|
                                //| 0| 0 | 0 | 0 | 1 |DL=0|
                                //| 0| 0 |N=1|F=0| X | X  |  
                                //Wait more than 40 us
  
  Cmd_Lcd(0x0F);                //Display ON/OFF Control (Set ON/OFF of entire display (D),dresser ON/OFF (C), and blinking of cursor position B)
                                //|RS|R/W|DB7|DB6|DB5|DB4|
                                //|  |   |DB3|DB2|DB1|DB0|
                                //| 0| 0 | 0 | 0 | 0 | 0 |
                                //| 0| 0 | 1 |D=1|C=1|B=1|  
                                //Wait more than 40 us
  
  Cmd_Lcd(0x01);                //Display Clear
                                //|RS|R/W|DB7|DB6|DB5|DB4|
                                //|  |   |DB3|DB2|DB1|DB0|
                                //| 0| 0 | 0 | 0 | 0 | 0 |
                                //| 0| 0 | 0 | 0 | 0 | 1 |
                                //Wait more than 1.64ms 
}


void Cmd_Lcd(unsigned char CMD)
{
  unsigned int Dat10b;
  if ((CMD & 0xFC) <= 0x02)
  {
    Dat10b = CMD;
    Dat10b = Dat10b << 1;
    Send_10b(Dat10b);
    __delay_cycles(1640);
  }
  else
  {
    Dat10b = CMD;
    Dat10b = (Dat10b & 0x00F0) << 2;
    CMD = (CMD & 0x0F) << 1;
    Dat10b |= CMD; 
    Send_10b(Dat10b);
    __delay_cycles(40);
  }
}


void Dato_Lcd(unsigned char DATO)
{
  unsigned int Dat10b;
  Dat10b = DATO;
  Dat10b = (Dat10b & 0x00F0) << 2;
  DATO = (DATO & 0x0F) << 1;
  Dat10b |= DATO;
  Dat10b |= BIT5+BIT0;
  Send_10b(Dat10b);
  __delay_cycles(40);
}


void Send_10b(unsigned int Dat_Ser)
{
  for( char i=0; i<=9; i++)
  {
    if((Dat_Ser & BIT9) != 0)
    {
      P2OUT |= AB;
      P2OUT |= CLK;                 
      P2OUT &= ~CLK; 
      Dat_Ser <<= 1;
      if(i == 4)
      {
        P2OUT |= E;                 
        P2OUT &= ~E; 
      }
    }
    else
    {
      P2OUT &= ~AB;
      P2OUT |= CLK;                
      P2OUT &= ~CLK; 
      Dat_Ser <<= 1;
      if(i == 4)
      {
        P2OUT |= E;                
        P2OUT &= ~E; 
      }
    }
  }
  P2OUT |= E;                 
  P2OUT &= ~E;
}


#endif /*LCD16x2_H_*/
