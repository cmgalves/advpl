#include "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT440AT   ºAutor  ³Claudio Alves       º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada chamado no Início da rotina do PV          º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT440AT()
Local xlRet		:=	.T.
local xcPed		:=	''

Private xaAlias 	:= { {Alias()},{"SC5"},{"SC6"},{"SC9"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)

xcPed	:=	SC5->C5_NUM

If GetMV('MB_LIBESTO') == 'S'
	U_ufAmbiente(xaAlias, "S")
	
	
	xlRet	:=	xsfPedido(xcPed)
	If xlRet
		
		If SC5->(DTOC(C5_ZDTDIGI) == "  /  /    " .OR. DTOC(C5_ZZLIBCR) == "  /  /    " .OR. DTOC(C5_ZLIBREG) == "  /  /    " .OR. DTOC(C5_ZDLBCAD) == "  /  /    ")
			xlRet	:=	.F.
			Alert('PEDIDO EM PROCESSO DE LIBERAÇÃO', 'ALERTA MB')
		EndIf
	EndIf
	
	
	U_ufAmbiente(xaAlias, "R")
EndIf

Return(xlRet)




Static Function xsfPedido(xcPedido)
Local xcPed		:=	xcPedido
Local xlCred	:=	.T.

xcQuery := 			"SELECT "
xcQuery += xcR + 	"	C5_NUM PEDIDO, C5_CLIENTE CLIENTE, C5_LOJACLI LOJA, A1_NOME NOME, ROUND(D.C6_VALOR,2) TOTAL,  "
xcQuery += xcR + 	"	F.C6_VALOR TOTPED, ISNULL(SLDTOT,0) DUPLIC, ISNULL(SLDATR,0) ATRASO, A1_ZZDTCON DTCON, A1_RISCO RISCO,  "
xcQuery += xcR + 	"	A1_LC LIMITE, A1_VENCLC VENCLIM, C5_USERLGI CODUSER, C5_VEND1 CODVEND, A3_NOME NOMVEND, C5_ZTOTLIB TOTLIB, "
xcQuery += xcR + 	"	C5_BLQ BLOQUE, C5_ZDTDIGI DIGITI, C5_ZZLIBCR LIBCR, C5_ZLIBREG LIBREG, C5_ZDLBCAD CADAST, C5_ZEXCPED EXCPED, C5_EMISSAO EMISSAO, "
xcQuery += xcR + 	"	CASE WHEN C5_ZZCODPD = '' THEN 'MANUAL' ELSE 'AUTOVEN' END AUTOVEN, "
xcQuery += xcR + 	"	CASE WHEN C5_ZESPECI = 'N' THEN 'NÃO' ELSE 'SIM' END ESPEC "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName("SC5") + " A INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName("SA1") + " B ON "
xcQuery += xcR + 	"	C5_CLIENT = A1_COD AND "
xcQuery += xcR + 	"	C5_LOJACLI = A1_LOJA INNER JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		C6_NUM, SUM(C6_VALOR) C6_VALOR "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName("SC6") + " C "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		C.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		C6_FILIAL = '01' "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		C6_NUM "
xcQuery += xcR + 	"	) D ON "
xcQuery += xcR + 	"	C5_NUM = C6_NUM INNER JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		C6_CLI, C6_LOJA, SUM(C6_VALOR) C6_VALOR "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName("SC6") + " E "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		E.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		C6_FILIAL = '01'  AND "
xcQuery += xcR + 	"		C6_BLQ = ''  AND "
xcQuery += xcR + 	"	NOT EXISTS  "
xcQuery += xcR + 	"	(  "
xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		D2_PEDIDO  "
xcQuery += xcR + 	"	FROM  "
xcQuery += xcR + 	"		" + RetSqlName("SD2") + "  "
xcQuery += xcR + 	"	WHERE  "
xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"		D2_FILIAL = '01' AND "
xcQuery += xcR + 	"		C6_NUM = D2_PEDIDO "
xcQuery += xcR + 	"	) "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		C6_CLI, C6_LOJA "
xcQuery += xcR + 	"	) F ON  "
xcQuery += xcR + 	"	A1_COD = C6_CLI AND "
xcQuery += xcR + 	"	A1_LOJA = C6_LOJA LEFT JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA, SUM(E1_SALDO) SLDTOT "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName("SE1") + " G "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		G.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		E1_TIPO NOT IN ('RA ', 'NCC') AND  "
xcQuery += xcR + 	"		E1_FILIAL = '01'  "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA "
xcQuery += xcR + 	"	) H ON  "
xcQuery += xcR + 	"	A1_COD = H.E1_CLIENTE AND "
xcQuery += xcR + 	"	A1_LOJA = H.E1_LOJA LEFT JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA, SUM(E1_SALDO) SLDATR "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName("SE1") + " I "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		I.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		E1_TIPO NOT IN ('RA ', 'NCC') AND  "
xcQuery += xcR + 	"		E1_FILIAL = '01'  AND "
xcQuery += xcR + 	"		CONVERT(DATETIME,E1_VENCREA,103) - GETDATE() < -1 "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA "
xcQuery += xcR + 	"	) J ON  "
xcQuery += xcR + 	"	A1_COD = J.E1_CLIENTE AND "
xcQuery += xcR + 	"	A1_LOJA = J.E1_LOJA  INNER JOIN
xcQuery += xcR + 	"	" + RetSqlName("SA3") + " L ON "
xcQuery += xcR + 	"	C5_VEND1 = A3_COD "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	C5_FILIAL = '01' AND "
xcQuery += xcR + 	"	C5_TIPO = 'N' AND "
xcQuery += xcR + 	"	C5_NUM = '" + xcPed + "' AND "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	A1_FILIAL = '' AND "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	NOT EXISTS  "
xcQuery += xcR + 	"	(  "
xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		D2_PEDIDO  "
xcQuery += xcR + 	"	FROM  "
xcQuery += xcR + 	"		" + RetSqlName("SD2") + "  "
xcQuery += xcR + 	"	WHERE  "
xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"		D2_FILIAL = '01' AND "
xcQuery += xcR + 	"		C5_NUM = D2_PEDIDO "
xcQuery += xcR + 	"	) AND "
xcQuery += xcR + 	"	NOT EXISTS "
xcQuery += xcR + 	"	(SELECT  "
xcQuery += xcR + 	"		C6_NUM, LIBERADO "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT DISTINCT "
xcQuery += xcR + 	"		C6_NUM, ISNULL(C9_PEDIDO,'FORA') LIBERADO "
xcQuery += xcR + 	"	FROM  "
xcQuery += xcR + 	"		SC6010 A LEFT JOIN "
xcQuery += xcR + 	"		SC9010 B ON "
xcQuery += xcR + 	"		C6_NUM = C9_PEDIDO AND "
xcQuery += xcR + 	"		C6_ITEM = C9_ITEM AND "
xcQuery += xcR + 	"		C9_FILIAL = '01' AND "
xcQuery += xcR + 	"		B.D_E_L_E_T_ = '' "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		C6_FILIAL = '01' AND "
xcQuery += xcR + 	"		A.C6_NUM = C5_NUM "
xcQuery += xcR + 	"	) C "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		LIBERADO = 'FORA') "
xcQuery += xcR + 	"	ORDER BY   "
xcQuery += xcR + 	"		C5_NUM "

//Gera um arquivo com a query acima.
MemoWrite("Libera Estoque Pedido.SQL",xcQuery)

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB


XTRB->(dbGoTop())
While !(XTRB->(EOF()))
	/*
	SC5->(dbSelectArea('SC5'))
	SC5->(dbSetOrder(1))
	SC5->(dbGoTop())
	SC5->(dbSeek(xFilial("SC5")+xcPed))
	*/
	If XTRB->TOTLIB >= SC5->C5_ZTOTLIB
		xlCred := .F.
	EndIf
	dbSelectArea("XTRB")
	XTRB->(dbSkip())
Enddo


Return(xlCred)
