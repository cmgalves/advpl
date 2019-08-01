#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

User Function Pagacta()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CTACED,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4")
SetPrvt("_DIG5,_DIG6,_DIG7,_MULT,_RESUL,_RESTO")
SetPrvt("_DIGITO")

/////  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA PARA O PROGRAMA DO
/////  PAGFOR - POSICOES ( 105 - 119 )

_CTACED := "0000000000000"

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
    _Ctaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
    
    _RETDIG := " "
    _DIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
    _DIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
    _DIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
    _DIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
    _DIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
    _DIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
    _DIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
    
    _MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
    _RESUL  := INT(_MULT /11 )
    _RESTO  := INT(_MULT % 11)
    _DIGITO := STRZERO((11 - _RESTO),1,0)

    _RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))

    _Ctaced := _Ctaced + _RETDIG
Else
    IF SUBSTR(SE2->E2_CODBAR,1,3) == "   "
       _Ctaced  := STRZERO(VAL(SUBSTR(SA2->A2_NUMCON,1,13)),13,0)
    Else
       _Ctaced  := "0000000000000"
    Endif
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 31/05/00 ==> __return(_Ctaced)
Return(_Ctaced)        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00


