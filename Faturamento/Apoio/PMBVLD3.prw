#include "Protheus.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBVLD3   �Autor  �Cassiano G. Ribeiro � Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida digita��o da quantidade no pedido de venda.         ���
���          � Deve ser o multiplo do fator de conversao do SB1.          ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
	Alert("Quantidade do produto incorreta! Verifique o fator de convers�o no cadastro de produto. ")
EndIf

Return (lRet)
