#include "protheus.ch"
User Function M460NITE()
Local aArea	:= GetArea()
Local nItens:= PARAMIXB[1]// Numero de itens da Nota Fiscal
Local aPed	:= PARAMIXB[2]// Pedidos a serem faturados
Local nRet	:= GetMV("MV_NUMITEN")//Numero de intens para quebra por Padrao.

If Ascan(__aQuebraIt,{|x| x[1] == aPed[Len(aPed),1] + aPed[Len(aPed),2] + aPed[Len(aPed),3]}) <> 0
	nRet := nItens
EndIf

RestArea(aArea)
Return (nRet)