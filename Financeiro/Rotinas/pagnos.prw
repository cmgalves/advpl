#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

User Function Pagnos()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_RETNOS,")

//// RETORNA O NOSSO NUMERO QUANDO COM VALOR NO E2_CODBAR, E ZEROS QUANDO NAO
//// TEM VALOR POSICAO ( 142 - 150 )

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
    _RETNOS := "000000000"
Else
    _RETNOS := SUBS(SE2->E2_CODBAR,28,9)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 31/05/00 ==> __return(_RETNOS)
Return(_RETNOS)        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00