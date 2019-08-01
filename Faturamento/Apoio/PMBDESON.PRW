#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBDESON  ºAutor  ³Cláudio Alves      º Data ³  15/01/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do produto com ou sem desoneração                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMBDESON()
Local aArea 	:= GetArea()
Local aAreaSB5 	:= SB5->(GetArea())
Local aAreaSB1 	:= SB1->(GetArea())

Local jcCodProd	:= 	''
Local cMailFis	:=	AllTrim(GETMV("MB_MAILFIS"))


Private nPosProd  := GDFieldPos("C6_PRODUTO")

jcCodProd	:=	aCols[n,nPosProd]

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+jcCodProd))

If ALLTRIM(SB1->B1_POSIPI) $ '39231090 | 39241000 | 39249000 | 39259090 | 76129090 | 94018000 | 94030000 | 39269090'
	SB5->(dbSelectArea(1))
	If !SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
		U_MBEnvMail("Produto sem Desoneração: " + SB1->B1_COD,&cMailFis,"","","")
		Alert('Produto sem Desonaração, Avise o Denilson')
		jcCodProd	:=	''
		Return (jcCodProd)
	Else
		If Empty(SB5->B5_CODATIV) .OR. Empty(SB5->B5_INSPAT)
			U_MBEnvMail("Produto sem Desoneração: " + SB1->B1_COD,&cMailFis,"","","")
			Alert('Produto sem Desoneração, Avise o Denilson')
		jcCodProd	:=	''
			Return (jcCodProd)
		EndIf
	EndIf
EndIf

RestArea(aAreaSB1)
RestArea(aAreaSB5)
RestArea(aArea)
Return(jcCodProd)
