#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

/*
Foram alteradas todas as funções abaixo porque estava considerando os valores de acréscimos e/ou decréscimos
e não o saldo desses dois campos.
Esta correção foi feita para evitar que os descontos fossem dados em duplicidade.
*/
//FUNCAO RESPONSAVEL POR ACRESCENTAR R$1,50 AO VALOR DO TITULO ENVIADO AO BANCO

User Function MBValCnb()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00
Local nTaxa := GetMv("ZZ_TXBOL")

	IF SA1->A1_ZZTXBOL="1"
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES+nTaxa)*100),13)                         
	ELSE
	    _ret := STRZERO(INT(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES)*100),13)      
	ENDIF

Return _ret

//FUNCAO RESPONSAVEL POR RETIRAR R$1,50 DO VALOR DO TITULO RETORNADO PELO BANCO
User Function MBRetCnb()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00
Local nTaxa := GetMv("ZZ_TXBOL")

	IF SA1->A1_ZZTXBOL="1"
	   _ret := STRZERO(INT(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES-nTaxa)*100),13)     
	ELSE
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES)*100),13)   
	ENDIF

Return _ret

//FUNCAO RESPONSAVEL POR DEMONSTRAR O R$1,50 DO VALOR DO TITULO RETORNADO PELO BANCO NA COLUNA OUTROS CREDITOS
User Function MBOCrCnb()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00
Local nTaxa := GetMv("ZZ_TXBOL")

	IF SA1->A1_ZZTXBOL="1"
	    _ret := STRZERO(INT(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES-nTaxa)*100),13)
	ELSE
	   _ret := STRZERO(INT(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES)*100),13)
	ENDIF

Return _ret