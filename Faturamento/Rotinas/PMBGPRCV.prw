#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBGPRCV  ºAutor  ³Cassiano G. Ribeiro º Data ³  20/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza campos apos a digitação do preço no campo padrao. º±±
±±º          ³ C6_PRCVEN.				                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMBGPRCV()
Local aArea 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSA3 	:= SA3->(GetArea())
Local aAreaDA0 	:= DA0->(GetArea())
Local aAreaDA1 	:= DA1->(GetArea())
Local nRet		:= 0
Local nPosItem  := GDFieldPos("C6_ITEM")
Local nPosProd  := GDFieldPos("C6_PRODUTO")
Local nPosPrUnit:= GDFieldPos("C6_PRUNIT")
Local nPosPrcVen:= GDFieldPos("C6_PRCVEN")
Local nPosDescon:= GDFieldPos("C6_ZZDESC")
Local nPosValor := GDFieldPos("C6_VALOR")
Local nPosQtdVen:= GDFieldPos("C6_QTDVEN")

SA3->(dbSetOrder(1))
SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1))
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+aCols[n,nPosProd]))
DA0->(dbSetOrder(1))
DA1->(dbSetOrder(1))

If M->C5_TIPO $ "N" .and. M->C5_ZZMGDES == '1' .and. SA3->A3_ZZCATEG <> '2'
	If DA0->(dbSeek(xFilial("DA0")+M->C5_TABELA))
		If DA0->DA0_ZZMARG == '1'
			If DA1->(dbSeek(xFilial("DA1")+DA0->DA0_CODTAB+aCols[n,nPosProd]))
				If aCols[n,nPosPrcVen] <= DA1->DA1_PRCVEN
					nRet := Round(Abs(((aCols[n,nPosPrcVen] / DA1->DA1_PRCVEN) - 1) * 100),2)
					//nRet := Abs(((aCols[n,nPosPrcVen] / DA1->DA1_PRCVEN) - 1) * 100)
				EndIf
				aCols[n,nPosPrUnit]:= aCols[n,nPosPrcVen]//ATUALIZA PRECO DE LISTA
			Else
				IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
					Alert("Produto: "+aCols[n,nPosProd]+" não faz parte da tabela de preço escolhida")
				ENDIF
				nRet := aCols[n,nPosDescon]
			EndIf
		Else
			IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
				MsgInfo("A tabela de preço: "+DA0->DA0_CODTAB+" não considera Margem de Desconto. Não foi calculado desconto para o item: "+;
																													aCols[n,nPosItem]+"!")
			ENDIF
			nRet := aCols[n,nPosDescon]
		EndIf
	Else
		IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
			Alert("Não há tabela de preço informada!")
		ENDIF
		nRet := aCols[n,nPosDescon]
	EndIf
Else
	nRet := aCols[n,nPosDescon]
EndIf

RestArea(aArea)
RestArea(aAreaSB1)
RestArea(aAreaSA3)
RestArea(aAreaDA0)
RestArea(aAreaDA1)
Return (nRet)