#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBVLD4   �Autor  �Cassiano G. Ribeiro � Data �  01/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida digita��o da quantidade no pedido de venda.         ���
���          � Deve ser o multiplo do fator de conversao do SB1.          ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMBVLD4()
Local lRet 		:= .T.
//buscar combina��o nA SZ3 PARA VALIDAR
/*If AllTrim(M->C5_TPFRETE) == 'C' .AND. Empty(M->C5_FRETEMB)
	Alert("Se o tipo do frete for CIF, o campo Frete MB n�o pode ficar em branco! Verifique.")
	lRet := .F.
EndIf*/
Return (lRet)