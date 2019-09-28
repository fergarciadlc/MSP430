#include "msp430g2553.h"                     ; #define controlled include file
#include "Lib LCD.s43"

#define DMillar   (0x200)
#define UMillar   (0x201)
#define Centena   (0x202)
#define Decena    (0x203)
#define Unidad    (0x204)

ORG     0xC000                  ;Donde empieza todo el codigo 
main
RESET   MOV.W   #0x400,SP               ;STACK POINTER  UNA LOCALIDAD DESPUES 
        MOV.W   #WDTPW+WDTHOLD,&WDTCTL  ; Stop watchdog timer

        MOV.B   &CALBC1_1MHZ,&BCSCTL1   ;CALIBRAR EL RELOJ SOLO 1, 8 , 12, 16 MHZ
        MOV.B   &CALDCO_1MHZ,DCOCTL     ;CALIBRAR EL RELOJ SOLO 1, 8 , 12, 16 MHZ
          
;----------------------------------------------------------------
;             PROGRAMA PRINCIPAL
;---------------------------------------------------------------- 
;　　　　　　　　　　 O L O    U N A   V E Z!!!!!!!!!!!!!!!!!!!!!!!        
        CALL    #INI_LCD                 
;　　　　　　　　　　 O L O    U N A   V E Z!!!!!!!!!!!!!!!!!!!!!!!        

        MOV.W   #0xFFFF,R4                ;DATO A IMPRIMIR
        
        ;INICIALIZAMOS VARIABLES EN CERO
        
        MOV.B   #0x30,DMillar
        MOV.B   #0x30,UMillar
        MOV.B   #0x30,Centena
        MOV.B   #0x30,Decena
        MOV.B   #0x30,Unidad

RES1    CMP.W   #10000,R4               ;comparar r4 con 10,000
        JLO     RES2
        SUB.W   #10000,R4
        INC.B   DMillar
        JMP     RES1
        
RES2    CMP.W   #1000,R4               ;comparar r4 con 1,000
        JLO     RES3
        SUB.W   #1000,R4
        INC.B   UMillar
        JMP     RES2      
        
RES3    CMP.W   #100,R4               ;comparar r4 con 100
        JLO     RES4
        SUB.W   #100,R4
        INC.B   Centena
        JMP     RES3
        
RES4    CMP.W   #10,R4               ;comparar r4 con 10
        JLO     Uni
        SUB.W   #10,R4
        INC.B   Decena
        JMP     RES4
        
Uni     ADD.B   R4,Unidad

;===============MANDAR DATOS A LCD=======================

        MOV.B   DMillar,R15
        CALL    #DATO_LCD
        MOV.B   UMillar,R15
        CALL    #DATO_LCD
        MOV.B   Centena,R15
        CALL    #DATO_LCD
        MOV.B   Decena,R15
        CALL    #DATO_LCD
        MOV.B   Unidad,R15
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
