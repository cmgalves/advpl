#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBMEPV2  ºAutor  ³Cassiano G. Ribeiro º Data ³  27/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do modo de edicao do campo C5_ZZDESCO.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMB-P10                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMBMEPV2()
	Local lRet 		:= .T.
	Local aAreaSA3  := SA3->(GetArea())
	Local aAreaDA0  := DA0->(GetArea())
	Local aAreaDA1  := DA1->(GetArea())
	Local nPosPrcVen:= GDFieldPos("C6_PRCVEN")
	Local nPosProd	:= GDFieldPos("C6_PRODUTO")

	DA0->(dbSetOrder(1))
	DA1->(dbSetOrder(1))

	if 10 > 15
		If M->C5_TIPO $ "N" .AND. M->C5_ZZMGDES == '1'
			SA3->(dbSetOrder(1))
			If SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1))
				If SA3->A3_ZZCATEG <> '2'
					If DA0->(dbSeek(xFilial("DA0") + M->C5_TABELA))
						If DA0->DA0_ZZMARG == '2'
							lRet := .F.
						ElseIf DA0->DA0_ZZMARG == '1'
							If DA1->(dbSeek(xFilial("DA1")+DA0->DA0_CODTAB+aCols[n,nPosProd]))
								If aCols[n,nPosPrcVen] > DA1->DA1_PRCVEN
									lRet := .F.
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf	
		EndIf
	EndIf
	RestArea(aAreaSA3)
	RestArea(aAreaDA0)
	RestArea(aAreaDA1)
Return lRet