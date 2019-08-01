#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

User Function Pagban()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_BANCO,")

/////  PROGRAMA PARA SEPARAR O BANCO DO FORNECEDOR
//// PAGFOR - POSICOES ( 96 - 98 )

_BANCO  :=  SUBSTR(SE2->E2_CODBAR,1,3)

IF SUBSTR(SE2->E2_CODBAR,1,3) == "   "
   _BANCO  :=  SA2->A2_BANCO
Else
   _BANCO := SUBSTR(SE2->E2_CODBAR,1,3)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 31/05/00 ==> __return(_BANCO)
Return(_BANCO)        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00
