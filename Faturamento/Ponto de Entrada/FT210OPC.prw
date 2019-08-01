#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT210OPC  ºAutor  ³Microsiga           º Data ³  12/15/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este ponto de entrada é executado apos a confirmação da     º±±
±±º		     ³liberação do pedido de venda por regra e antes do inicio    º±±
±±º		     ³da transação.												  º±±
±±º          ³Seu objetivo é permitir a interrupção do&nbsp;processo,     º±±
±±º          ³mesmo com a confirmação do usuário.                         º±±
±±º          ³FATA210 - LIBERACAO DE REGRAS                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT210OPC
Local lRet := 0
Local cUserLib := GETMV("MV_USERLIB")
Local cUserLibBon := GETMV("MB_USERBON") //Libera Bonificação
Local cUser    := ""
                    
//cUser := SubStr(cUsuario,7,15)
cUser := Alltrim(cUsername)
If SC5->C5_BLQ $ '3 4' 
	If Alltrim(Upper(cUser)) $ Alltrim(Upper(cUserLibBon))
		lRet := 1
	Else
		lRet := 2
		Alert("Usuario sem acesso para liberação")
	EndIf
Else
	If Alltrim(Upper(cUser)) $ Alltrim(Upper(cUserLib))
		lRet := 1
	Else
		lRet := 2
		Alert("Usuario sem acesso para liberação")
	EndIF
EndIf

Return(lRet)