#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBINIB2  �Autor  �Cassiano G. Ribeiro � Data �  15/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicializador de browse para campo virtual.                ���
���          � Apenas para visualiza��o em browse.                        ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMBINIB2()
Local cRet 		:= ""
Local aArea		:= GetArea()
Local aAreaSA1  := SA1->(GetArea())
Local aAreaSA2  := SA2->(GetArea())
Local aAreaSC5  := SC5->(GetArea())

If SC5->C5_TIPO $ "D/B"
	cRet := Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME")
Else
	cRet := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
EndIf

RestArea(aArea)
RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aAreaSC5)
Return (cRet)