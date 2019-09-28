#include "msp430g2553.h"                     ; #define controlled include file
#include "Lib LCD.s43"

ORG     0xC000                  ;Donde empieza todo el codigo
main
RESET   MOV.W   #0x400,SP               ;STACK POINTER  UNA LOCALIDAD DESPUES 
        MOV.W   #WDTPW+WDTHOLD,&WDTCTL  ; Stop watchdog timer

        MOV.B   &CALBC1_1MHZ,&BCSCTL1   ;CALIBRAR EL RELOJ SOLO 1, 8 , 12, 16 MHZ
        MOV.B   &CALDCO_1MHZ,DCOCTL     ;CALIBRAR EL RELOJ SOLO 1, 8 , 12, 16 MHZ
          
;----------------------------------------------------------------
;             PROGRAMA PRINCIPAL
;----------------------------------------------------------------       
        CALL    #INI_LCD                       


        MOV.B   #'H',R15
        CALL    #DATO_LCD
        
        MOV.B   #'e',R15
        CALL    #DATO_LCD
        
        MOV.B   #'l',R15
        CALL    #DATO_LCD
        
        MOV.B   #'l',R15
        CALL    #DATO_LCD
        
        MOV.B   #'o',R15
        CALL    #DATO_LCD
        
        MOV.B   #' ',R15
        CALL    #DATO_LCD
        
        MOV.B   #'W',R15
        CALL    #DATO_LCD
        
        MOV.B   #'o',R15
        CALL    #DATO_LCD
        
        MOV.B   #'r',R15
        CALL    #DATO_LCD
        
        MOV.B   #'l',R15
        CALL    #DATO_LCD
        
        MOV.B   #'d',R15
        CALL    #DATO_LCD
        
        MOV.B   #'!',R15
        CALL    #DATO_LCD
        
     
        JMP $                           ; jump to current location '$' 
   
;----------------------------------------------------------------
;             SUBRUTINAS
;----------------------------------------------------------------



;----------------------------------------------------------------
;             VECTORES DE INTERRUPCION
;----------------------------------------------------------------
         ORG    0xFFFE
         DW     RESET
         END
         END    main
         
