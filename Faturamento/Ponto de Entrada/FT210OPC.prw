#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT210OPC  �Autor  �Microsiga           � Data �  12/15/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada � executado apos a confirma��o da     ���
���		     �libera��o do pedido de venda por regra e antes do inicio    ���
���		     �da transa��o.												  ���
���          �Seu objetivo � permitir a interrup��o do&nbsp;processo,     ���
���          �mesmo com a confirma��o do usu�rio.                         ���
���          �FATA210 - LIBERACAO DE REGRAS                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT210OPC
Local lRet := 0
Local cUserLib := GETMV("MV_USERLIB")
Local cUserLibBon := GETMV("MB_USERBON") //Libera Bonifica��o
Local cUser    := ""
                    
//cUser := SubStr(cUsuario,7,15)
cUser := Alltrim(cUsername)
If SC5->C5_BLQ $ '3 4' 
	If Alltrim(Upper(cUser)) $ Alltrim(Upper(cUserLibBon))
		lRet := 1
	Else
		lRet := 2
		Alert("Usuario sem acesso para libera��o")
	EndIf
Else
	If Alltrim(Upper(cUser)) $ Alltrim(Upper(cUserLib))
		lRet := 1
	Else
		lRet := 2
		Alert("Usuario sem acesso para libera��o")
	EndIF
EndIf

Return(lRet)