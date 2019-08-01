#include "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBVLD3   ºAutor  ³Cassiano G. Ribeiro º Data ³  18/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida digitação da quantidade no pedido de venda.         º±±
±±º          ³ Deve ser o multiplo do fator de conversao do SB1.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PMBVLD3()
Local lRet 		:= .T.
Local nPosProd  := GDFieldPos("C6_PRODUTO")
Local nPosQtde  := GDFieldPos("C6_QTDVEN")
Local nPosLocal := GDFieldPos("C6_LOCAL")

If CEMPANT != '01'
	Return .T.
EndIf

dbSelectArea('DA1')
DA1->(dbSetOrder(1))
DA1->(dbGoTop())

DA1->(dbSeek(xFilial('DA1') + M->C5_TABELA + aCols[n,nPosProd]))

If DA1->DA1_ZQTLOT > 0
	If aCols[n,nPosQtde] >= DA1->DA1_ZQTLOT
		lRet := (Mod(aCols[n,nPosQtde],DA1->DA1_ZQTLOT ) == 0)
	Else
		lRet := .F.
	EndIf
	If !lRet
		Alert("Quantidade do produto incorreta! Verifique o Lote da Tabela. ")
		Return lRet
	Else
		Return lRet
	EndIf
EndIf

If M->C5_TIPO == 'N' .AND. M->C5_ZZMGDES == '1' .AND. !Empty(M->C5_CLIENTE)
	If !Empty(aCols[n,nPosProd])
		If SB1->B1_CONV > 0 .AND. SB1->B1_TIPCONV == 'D' .and. aCols[n,nPosQtde] > 0
			If aCols[n,nPosQtde] >= SB1->B1_CONV
				lRet := (Mod(aCols[n,nPosQtde],SB1->B1_CONV) == 0)
			Else
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf

If !lRet
	Alert("Quantidade do produto incorreta! Verifique o fator de conversão no cadastro de produto. ")
EndIf

Return (lRet)
