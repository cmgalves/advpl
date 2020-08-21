#include "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F070ACONT ºAutor  ³Claudio Alves       º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada Depois da baixa do Título                  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F070ACONT()
Private xaAlias 	:= { {Alias()},{"SE5"},{"SEF"},{"SE1"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)

//U_ufAmbiente(xaAlias, "S")


If GetMv('MB_BXACHEQ') == 'S'
	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	EF_TITULO "
	xcQuery += xcR + 	"FROM  "
	xcQuery += xcR + 	"	" + RetSqlName('SEF') + "  "
	xcQuery += xcR + 	"WHERE  "
	xcQuery += xcR + 	"	EF_FILIAL =  '" + xFilial('SEF') + "' AND "
	xcQuery += xcR + 	"	EF_PREFIXO = '" + SE5->E5_PREFIXO + "' AND "
	xcQuery += xcR + 	"	EF_TITULO =  '" + SE5->E5_NUMERO + "' AND "
	xcQuery += xcR + 	"	EF_PARCELA = '" + SE5->E5_PARCELA + "' AND "
	xcQuery += xcR + 	"	EF_TIPO =    '" + SE5->E5_TIPO + "' AND "
	xcQuery += xcR + 	"	EF_DTALIN2 = '' AND "
	xcQuery += xcR + 	"	EF_VALORBX = " + Transform(SE5->E5_VALOR,"999999999.99") + " AND "
	xcQuery += xcR + 	"	D_E_L_E_T_ = '' "
	
	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif
	
	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB
	
	XTRB->(dbGoTop())
	While !(XTRB->(EOF()))
		If SE5->E5_NUMERO == XTRB->EF_TITULO
			If SE5->E5_TIPODOC == 'VL'
				RecLock("SE5",.F.)
				SE5->E5_TIPODOC := 'BA'
				SE5->(MsUnLock())
			EndIf
		EndIf
		dbSelectArea("XTRB")
		XTRB->(dbSkip())
	Enddo
EndIf

//U_ufAmbiente(xaAlias, "R")

Return



