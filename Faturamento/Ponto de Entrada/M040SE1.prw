#include "protheus.ch"
//Ponto de Entrada para atualizar o campo A1_ZZBOLET.
//Este campo é utilizado no ponto de entrada FA060QRY 
//para não gerar boleto para os clientes que pagam antecipado.

User Function M040SE1
Local nTaxa := GetMv("ZZ_TXBOL")
If CEMPANT != '01'
	Return .T.
EndIf

    If SA1->A1_ZZTXBOL == "1"
//	  RecLock("SE1",.F.)
      SE1->E1_ZZTXBOL := nTaxa
//      MsUnlock()    
	Endif

Return