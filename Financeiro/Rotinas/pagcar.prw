#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

User Function Pagcar()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_RETCAR,")

////  PROGRAMA PARA SELECIONAR A CARTEIRA NO CODIGO DE BARRAS QUANDO
////  NAO TIVER TEM QUE SER COLOCADO "00"

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
   _Retcar := "000"
Else
   _Retcar := "0" + SUBS(SE2->E2_CODBAR,24,2)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 31/05/00 ==> __return(_Retcar)
Return(_Retcar)        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00
