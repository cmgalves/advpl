#include "Protheus.ch"
#include "Topconn.ch"

//Rotina chamada pelo ponto de entrada M410LIOK para calcular o LL em tempo de execução
//Esta rotina foi tirada do ponto de entrada MT410TOK
User Function MBPVMUDA()                             
Local aArea 	:= GetArea()
Local aAreaSB1 	:= {}
Local aAreaSA1 	:= SA1->(GetArea())
Local aAreaSA3	:= SA3->(GetArea())
Local aAreaDA0	:= DA0->(GetArea())
Local lRet		:= .T.
Local aRet		:= {}
Local lVendedor	:= .F.
Local cMarg	    := ""
Local nPosLocal	:= GDFieldPos("C6_LOCAL")
Local nPosProd	:= GDFieldPos("C6_PRODUTO")
Local nPosItem 	:= GDFieldPos("C6_ITEM")
Local nPosValor := GDFieldPos("C6_VALOR")
Local nPosDescon:= GDFieldPos("C6_ZZDESC")
Local nPosQtdVen:= GDFieldPos("C6_QTDVEN")
Local nPosPll   := GDFieldPos("C6_ZZPLL")
Local nPosVll   := GDFieldPos("C6_ZZVLL")
Local nPosPllm  := GDFieldPos("C6_ZZPLLM")
Local nTotItens := 0
Local nTllItens := 0
Local nQtdVol	:= 0
Local nQtdCub	:= 0
Local lTampa	:= .F.
Local xcR		:=	Char(13) + Char(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Manga Vendedor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nMangaVend:= SA3->A3_ZZMANGA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Manga Global³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nMangaGlob:= GetMV("MV_LLMANGA")

SA3->(dbSetOrder(1))
If SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1))
	lVendedor := .T.
	cMarg := SA3->A3_ZZMARG
EndIf
If (Inclui .or. Altera) .AND. (M->C5_TIPO $ "N") .and. (M->C5_ZZMGDES == "1")

	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
		If !SA1->A1_COMIS > 0
			If lVendedor
				If M->C5_COMIS1 > SA3->A3_COMIS
					Alert("C A D A S T R O   V E N D E D O R" + xcR + "COMISSÃO DO PEDIDO MAIOR QUE O CADASTRO!" + xcR + "ACERTE O CAMPO COMISSÃO.")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	If lRet
		If	SA3->A3_ZZCATEG == '2'
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Regras de Faixas de Valor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aRet:= U_AtuComis(cMarg)
			
			lRet := aRet[1]
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Regras de Faixas de Desconto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If RegraFDesc(1)//Valida Desconto do Item
				lRet := RegraFDesc(2)//Valida Desconto do pedido
			Else
				lRet:= .F.
			EndIf
		EndIf
	EndIf
//ÚÄÄÄÄÄÄÄÄÄ¿
//³Totais LL³
//ÀÄÄÄÄÄÄÄÄÄÙ
//	If lRet
For nY := 1 to Len(aCols)
	If !aCols[nY,Len(aHeader)+1]
		nTotItens += aCols[nY,nPosValor]
		nTllItens += aCols[nY,nPosVll]
	EndIf
Next nY
M->C5_ZZTOTLL := nTllItens
M->C5_ZZMEDLL := (M->C5_ZZTOTLL / nTotItens) * 100
M->C5_ZZPLLM  := Round(M->C5_ZZMEDLL - _nMangaVend - _nMangaGlob,2)
//	EndIf

ElseIf M->C5_ZZMGDES == '2'                           // Mudei a linha antes era igual linha acima
	For	nK := 1 to Len(aCols)
		aCols[nK,nPosLocal] := "11"
	Next nK
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Correção do volume do Pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For	 nK := 1 to Len(aCols)
	If !aCols[nK][Len(aCols[nK])]
	lTampa := (!Empty(Posicione("SB1",1,xFilial("SB1")+aCols[nK,nPosProd],"B1_ZZADD")))
	nQtdVol	+= U_MBCALVOL(aCols[nK,nPosProd],aCols[nK,nPosQtdVen],lTampa)
	nQtdCub	+= U_MBCALCUB(aCols[nK,nPosProd],aCols[nK,nPosQtdVen],lTampa)
	EndIf
Next nK
If nQtdVol > 0
	M->C5_VOLUME1 := nQtdVol
	M->C5_ZZCUBA  := nQtdCub
EndIf
RestArea(aArea)
RestArea(aAreaSA1)
RestArea(aAreaSA3)
RestArea(aAreaDA0)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REGRAFDESCºAutor  ³Cassiano G. Ribeiro º Data ³  29/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aplica calculo de % de Desconto Real para os itens.        º±±
±±º          ³ Não permite desconto fora da faixa. SZ2. User Function     º±±
±±º          ³ ValidDesc(nPercentual)encontrada no fonte PMBGDESC.PRW     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMB-P10.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RegraFDesc(nTipo)
Local lRet 		:= .T.
Local lMsg 		:= .T.
Local nY		:= 0
Local cItens1	:= ""
Local cItens2	:= ""
Local nPosItem 	:= GDFieldPos("C6_ITEM")
Local nPosValor := GDFieldPos("C6_VALOR")
Local nPosDescon:= GDFieldPos("C6_ZZDESC")
Local nDesc 	:= M->C5_ZZDESCO

For nY := 1 to Len(aCols)
	If !aCols[nY,Len(aHeader)+1]
		lRet := IIF(nTipo==1,U_ValidDesc(aCols[nY,nPosDescon]),U_ValidDesc(nDesc))
		If !lRet
			lMsg := .T.
			If SA3->A3_ZZPMARG == '1'//Processa Margem de Desconto? 1=sim;2=não
				cItens1 += aCols[nY,nPosItem]
			ElseIf SA3->A3_ZZPMARG == '2'
				cItens2 += aCols[nY,nPosItem]
				lRet := .T.
			EndIf
		EndIf
	EndIf
Next nY

//If !Empty(cItens1)
//	Alert("Desconto do(s) Item(s): "+cItens1+" está fora da faixa! Verifique o desconto dado para o(s) ITEM(S).")
//ElseIf !Empty(cItens2)
//	MsgInfo("O(s) item(s): "+cItens2+" será gravado com Desconto fora da Faixa!")
//EndIf
Return(lRet)