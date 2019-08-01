#include "Protheus.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBVLD5   �Autor  �Jose Vicktor        � Data �  21/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida digita��o da quantidade no pedido de venda.         ���
���          � Deve ser o multiplo do fator de conversao do SB1.          ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function PMBVLD5()
Local lRet 		:= .T.
Local cProd  := M->C2_PRODUTO
Local nQtde  := M->C2_QUANT


		DbSelectArea("SB1")
		DbSetorder(1)
		DbSeek(xFilial("SB1")+cProd)
		If SB1->B1_CONV > 0 .AND. SB1->B1_TIPCONV == 'D' .and. nQtde > 0
			If nQtde >= SB1->B1_CONV
				lRet := (Mod(nQtde,SB1->B1_CONV) == 0)
			Else
				lRet := .F. 
			    M->C2_QUANT := 0
			EndIf
		EndIf

If !lRet
	Alert("Quantidade do produto incorreta! Verifique o fator de convers�o no cadastro de produto! ")
EndIf
Return (lRet)