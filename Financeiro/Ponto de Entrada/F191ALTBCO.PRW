#include "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F191ALTBCOºAutor  ³Claudio Alves       º Data ³  21/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada Antes da compensação do cheques            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F191ALTBCO()
Local xcBanco := paramixb[1]
Local xcAgencia := paramixb[2]
Local xcConta := paramixb[3]
Local xaDadoBco := {}   
Private xaAlias 	:= { {Alias()},{"SEF"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)

//U_ufAmbiente(xaAlias, "S")

AADD (xaDadoBco,{xcBanco,xcAgencia,xcConta}) 

	xcQuery := 		"UPDATE "
	xcQuery += xcR +  "	" + RetSqlName('SEF') + " "
	xcQuery += xcR +  "SET "
	xcQuery += xcR +  "	EF_ZDTCOMP = EF_DTCOMP "
	xcQuery += xcR +  "WHERE  "
	xcQuery += xcR +  "	EF_FILIAL = '" + xFilial('SEF') + "' AND "
	xcQuery += xcR +  "	D_E_L_E_T_ = '' AND "
	xcQuery += xcR +  "	EF_TITULO = '" + SEF->EF_TITULO + "' AND "
	xcQuery += xcR +  "	EF_PREFIXO = '" + SEF->EF_PREFIXO + "' AND "
	xcQuery += xcR +  "	EF_PARCELA = '" + SEF->EF_PARCELA + "' "
	
	TCSQLExec(xcQuery)
                    

//U_ufAmbiente(xaAlias, "R")

Return xaDadoBco