        NAME    main                    ; module name
        PUBLIC  main                    ; make the main label vissible
                                        ; outside this module
#include "msp430g2553.h" 
        
        ORG     0xC000                  ;Donde empieza todo el codigo
main
RESET   MOV.W   #0x400,SP               ;STACK POINTER  UNA LOCALIDAD DESPUES
        MOV.W   #WDTPW+WDTHOLD,&WDTCTL  ; Stop watchdog timer

        MOV.B   &CALBC1_1MHZ,&BCSCTL1   ;CALIBRAR EL RELOJ SOLO 1, 8 , 12, 16 MHZ
        MOV.B   &CALDCO_1MHZ,DCOCTL     ;CALIBRAR EL RELOJ SOLO 1, 8 , 12, 16 MHZ
          
;-------------------------------------------------------------------------------
;                            PROGRAMA PRINCIPAL
;-------------------------------------------------------------------------------
        
          CLR.B   &P2SEL                  ;CONFIG PUERTO 1
          CLR.B   &P2SEL2

          MOV.B   #0xFF, &P2DIR           ;CONFIGURANDO A PUERTO 1 COMO SALIDA
INI
          MOV.W   #DATOS1, R4
          
CICLO1    MOV.B   @R4+, &P2OUT
          MOV.W   #2725, R14              ;11 segmentos a 150ms = 2725.2727
          CALL    #TIEMPO
          CMP.B   #0xAA, 0(R4)
          JNE     CICLO1
          JMP     INI

;-------------------------------------------------------------------------------
;                               SUBRUTINAS
;-------------------------------------------------------------------------------
TIEMPO: DEC.W     R14
        NOP
        CMP.W   #0,R14
        JNE     TIEMPO
        RET
        

DATOS1: DC8 0x3C, 0x72, 0xF1, 0x91, 0xB1, 0x91, 0xB1, 0x91, 0x0F1, 0x72, 0x3C, 0xAA ;Honguito de MARIO BROS
;----------------------------------------------------------------
;             VECTORES DE INTERRUPCION
;----------------------------------------------------------------
         ORG    0xFFFE
         DW     RESET
         END
         END    main
         
;     0 0 0 0 0 0 0      
;   0               0
; 0                   0 
; 0                   0 
; 0 0 0 0 0 0 0 0 0 0 0 
; 0 0 0   0   0   0 0 0 
;   0               0 
;     0 0 0 0 0 0 0  
