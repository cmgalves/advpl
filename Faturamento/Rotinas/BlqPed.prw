#include "Protheus.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BlqPed    ºAutor  ³Cassiano G. Ribeiro º Data ³  20/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a linha do pedido de venda                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BlqPed(cBloq)

Local nPosBloq	:= GDFieldPos("C6_BLOQUEI")
Local cQuery	:= ""

//If M->C5_ZZMGDES == "1" .AND. (INCLUI .OR. ALTERA)
    If (INCLUI .OR. ALTERA) .AND. Empty(SC5->C5_BLQ) //SC5->C5_BLQ <> '1'
		cQuery	:=	" UPDATE " + RetSQLName("SC5")
	    cQuery 	+= 	" SET   C5_BLQ = '" + cBloq + "' 
	    cQuery 	+= 	" WHERE C5_FILIAL = '" + xFilial("SC5") + "' and "
	    cQuery 	+= 		"   C5_NUM  = '" + SC5->C5_NUM 	+ "' and "
	    cQuery 	+= 		"   D_E_L_E_T_ = '' "
		If 	TcSQLExec(Upper(Alltrim(cQuery))) < 0
	      	Alert( "Error : " + TcSQLError())
	    EndIf
	    TcSqlExec("COMMIT")
	EndIf
//    Alert("Pedido Bloqueado!")
//EndIf 
Return