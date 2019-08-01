#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBGDESC  ºAutor  ³Cassiano G. Ribeiro º Data ³  20/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza campos apos a digitação do desconto no campo      º±±
±±º          ³ personalizado C6_ZZDESC.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMBGDESC()
Local aArea 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSA3 	:= SA3->(GetArea())
Local aAreaDA0 	:= DA0->(GetArea())
Local aAreaDA1 	:= DA1->(GetArea())
Local nRet		:= 0
Local nPosItem  := GDFieldPos("C6_ITEM")
Local nPosProd  := GDFieldPos("C6_PRODUTO")
Local nPosPrUnit:= GDFieldPos("C6_PRUNIT")//ATUALIZAR APOS O CALCULO
Local nPosPrcVen:= GDFieldPos("C6_PRCVEN")
Local nPosDescon:= GDFieldPos("C6_ZZDESC")
Local nPosValor := GDFieldPos("C6_VALOR")
Local nPosQtdVen:= GDFieldPos("C6_QTDVEN")

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+aCols[n,nPosProd]))
SA3->(dbSetOrder(1))
DA0->(dbSetOrder(1))
DA1->(dbSetOrder(1))

If M->C5_TIPO $ "N"	.and. M->C5_ZZMGDES == '1'
	If SA3->(dbSeek(xFilial("SA3")+M->C5_VEND1)) .and. SA3->A3_ZZCATEG <> '2'
		If DA0->(dbSeek(xFilial("DA0")+M->C5_TABELA))
			If DA0->DA0_ZZMARG == '1'//Considera Margem de Desnconto ? 1=sim;2=Nao
				If DA1->(dbSeek(xFilial("DA1")+DA0->DA0_CODTAB+aCols[n,nPosProd]))
						If U_ValidDesc(aCols[n,nPosDescon])
							nRet := IIF(aCols[n,nPosDescon]<>0,DA1->DA1_PRCVEN - (DA1->DA1_PRCVEN * (aCols[n,nPosDescon]/100)),DA1->DA1_PRCVEN)
							aCols[n,nPosValor] := A410Arred(aCols[n,nPosQtdVen] * nRet,"C6_VALOR",M->C5_MOEDA)//ATUALIZA VALOR TOTAL DO ITEM
							aCols[n,nPosPrUnit]:= nRet//ATUALIZA PRECO DE LISTA
						Else
							If SA3->A3_ZZPMARG == '1'//Processa Margem de Desconto ? 1=sim;2=Nao- Obrigatorio
								IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
									Alert("Desconto do Item: "+aCols[n,nPosItem]+" está fora da faixa! Verifique o desconto dado para o ITEM.")
								ENDIF
								nRet := DA1->DA1_PRCVEN
							ElseIf SA3->A3_ZZPMARG == '2'
								nRet := DA1->DA1_PRCVEN - (DA1->DA1_PRCVEN * (aCols[n,nPosDescon]/100))
								aCols[n,nPosValor] := A410Arred(aCols[n,nPosQtdVen] * nRet,"C6_VALOR",M->C5_MOEDA)//ATUALIZA VALOR TOTAL DO ITEM
								aCols[n,nPosPrUnit]:= nRet//ATUALIZA PRECO DE LISTA
								IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
									MsgInfo("O item: "+aCols[n,nPosItem]+" será gravado com Desconto fora da Faixa!")
								ENDIF
							Else
								IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
									MsgAlert("Nao está informado no cadastro do vendedor se ele considera ou não, Margem de Desconto!"+;
																									" Desconto não calculado.")         
								ENDIF
								nRet := aCols[n,nPosPrcVen]
							EndIf
						EndIf
				Else
					IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
						Alert("Produto: "+AllTrim(aCols[n,nPosProd])+" não faz parte da tabela de preço escolhida! Desconto nao calculado.")
					ENDIF
					nRet := aCols[n,nPosPrcVen]
				EndIf
			Else
				IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
					MsgInfo("A tabela de preço: "+DA0->DA0_CODTAB+" não considera Margem de Desconto. Não foi calculado desconto para o item: "+;
																														aCols[n,nPosItem]+"!")
				ENDIF
				nRet := aCols[n,nPosPrcVen]
			EndIf
		Else
			nRet := aCols[n,nPosPrcVen]
		EndIf
	EndIf
Else
	nRet := aCols[n,nPosPrcVen]
EndIf

RestArea(aArea)
RestArea(aAreaSB1)
RestArea(aAreaSA3)
RestArea(aAreaDA0)
RestArea(aAreaDA1)
Return (nRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDDESC ºAutor  ³Microsiga           º Data ³  29/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida % de desconto dado ao Item.                         º±±
±±º          ³ Nao deve ultrapassar o limite registrado na tabela SZ2.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMB-P10.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValidDesc(nDesc)
Local lRet 		:= .T.
Local cAlias	:= GetNextAlias()
Local cCod	    := SA3->A3_ZZMGDES//codigo da faixa de desconto.
Local lProd		:= .F.
Local nPDesc	:= 0

BeginSql Alias cAlias
	SELECT * FROM %TABLE:SZ2% Z2
	WHERE Z2.%NOTDEL%
	  AND Z2.Z2_FILIAL = %XFILIAL:SZ2%
	  AND Z2.Z2_COD = %Exp:cCod%
EndSql
Count to nCnt
If nCnt > 0
	(cAlias)->(dbGoTop())
	While (cAlias)->(!Eof())
		If (cAlias)->Z2_GRPROD == SB1->B1_GRUPO .AND. !lProd
			nPDesc := (cAlias)->Z2_FAIXADE
		ElseIf (cAlias)->Z2_CODPROD == SB1->B1_COD
			lProd := .T.
			nPDesc := (cAlias)->Z2_FAIXADE
		EndIf
		(cAlias)->(dbSkip())
	EndDo
	//(cAlias)->(dbCloseArea())
	If nPDesc < nDesc
		lRet := .F.
	EndIf
Else
	//MsgInfo("") necessario??
EndIf
(cAlias)->(dbCloseArea())
Return(lRet)