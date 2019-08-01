#include"protheus.ch"
#include"rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMP650    �Autor  �Amitech             � Data � 21/01/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto para Alterar o armazem de empenho dos  produtos       ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Alteracao �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Ponto no geracao do empenho na rotina MATA650 (Abertura OP) ���
�������������������������������������������������������������������������ͼ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Luiz Gustavo �21/01/12�oooooo�Cria��o do fonte���
���              �        �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function Emp650()

Local _cEPAlias	:= GetArea()
Local _cEP_SC2 	:= SC2->(GetArea())
Local cLocEmp  	:= ""
Local cProd		:= ""
Local cTipoPI   := ""


DbSelectArea("SC2")

For _nI := 1 To Len(aCols)
	cTipoPI  := Posicione("SB1",1,xFilial("SB1")+aCols[_nI][GdFieldPos("G1_COMP",aHeader)],"SB1->B1_TIPO")
	cProd	 := aCols[_nI][GdFieldPos("G1_COMP",aHeader)]
	If !cTipoPI $ "PI,PA,MO"
		cLocEmp := GETMV("MB_ARMPRO")
		// Ajusta Armazem de Empenho
		aCols[_nI][GdFieldPos("D4_LOCAL",aHeader)] := cLocEmp
	EndIf
Next

dbSelectArea("SC2")
                            
RestArea(_cEP_SC2)
RestArea(_cEPAlias)

Return




/*User Function Emp650()

Local _cEPAlias	:= GetArea()
Local _cEP_SC2 	:= SC2->(GetArea())
Local cLocEmp  	:= ""


DbSelectArea("SC2")

For _nI := 1 To Len(aCols)
		cLocEmp := "99"
		cProd:=aCols[_nI][GdFieldPos("D4_COD",aHeader)]
		// Ajusta Armazem de Empenho
		aCols[_nI][GdFieldPos("D4_LOCAL",aHeader)] := cLocEmp
	
Next

dbSelectArea("SC2")
                            
RestArea(_cEP_SC2)
RestArea(_cEPAlias)

Return*/
