#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBGCOMI  �Autor  �Cassiano G. Ribeiro � Data �  27/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tratamento para preenchimento automatico do campo C5_COMIS1���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PMB-P10                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMBGCOMI()
local aArea	:=	GetArea()
local nRet 	:=	0

SA3->(dbSetOrder(1))
if SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1))
	SA1->(dbSetOrder(1))
	if SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
		if (SA1->A1_COMIS > 0) .AND. !(SA3->A3_ZZCATEG == '2')
			nRet := SA1->A1_COMIS
		else
			nRet := SA3->A3_COMIS
		endif
	endif
endif

if !Empty(Alltrim(M->C5_TABELA))
	
	aCols[n,GDFieldPos("C6_ZTABELA")] := M->C5_TABELA
	//aCols[n,GDFieldPos("C6_TES")] := '800'
	
	GETDREFRESH()
	///SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
	oGetDad:Refresh()
//	A410LinOk(oGetDad)	
	
endif

RestArea(aArea)
Return nRet