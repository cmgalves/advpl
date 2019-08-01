#include "protheus.ch"
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MBRotDesc³ Autor ³ Claudio Alves        ³ Data ³ 01/04/2014 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Descontos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN FINA190                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//U_MBRotDesc()
User Function MBRotDesc()
Local xcUser	:=	__cUserID
Local xlRet		:=	.F.
Local xaAlcNiv	:=	{}

Aadd(xaAlcNiv,{Getmv("MB_ALCNIV1"),Getmv("MB_ALCFIN1")})
Aadd(xaAlcNiv,{Getmv("MB_ALCNIV2"),Getmv("MB_ALCFIN2")})
Aadd(xaAlcNiv,{Getmv("MB_ALCNIV3"),Getmv("MB_ALCFIN3")})


For xi := 1 to Len(xaAlcNiv)
	If xcUser $ xaAlcNiv[xi][1]
		xlret := .T.
	EndIf
Next xi

Return xlRet


User Function MBRotAlc()
Local xcUser	:=	__cUserID
Local xaAlcNiv	:=	{}
Local xnDesc	:=	0

Aadd(xaAlcNiv,{Getmv("MB_ALCNIV1"),Getmv("MB_ALCFIN1")})
Aadd(xaAlcNiv,{Getmv("MB_ALCNIV2"),Getmv("MB_ALCFIN2")})
Aadd(xaAlcNiv,{Getmv("MB_ALCNIV3"),Getmv("MB_ALCFIN3")})


xnDesc	:=	M->E1_DECRESC

For xi := 1 to Len(xaAlcNiv)
	If xcUser $ xaAlcNiv[xi][1]
		If xnDesc > xaAlcNiv[xi][2]
			xnDesc	:=	0
		EndIf
	EndIf
Next xi

Return xnDesc
