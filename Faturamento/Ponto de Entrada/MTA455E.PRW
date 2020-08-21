#include "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA455E   ºAutor  ³Claudio Alves       º Data ³  05/05/14   º±±
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
User Function MTA455E()
	Local xcRet		:=	1

	Private xaAlias 	:= { {Alias()},{"SC5"},{"SC6"},{"SC9"}}
	Private xcQuery		:=	""
	Private xcR			:=	Char(13) + Char(10)



	If GetMV('MB_LIBESTO') == 'S'
		//U_ufAmbiente(xaAlias, "S")

		xcRet	:=	xsfPedido(SC9->C9_PEDIDO)

		If xcRet == 1

			SC5->(dbSelectArea('SC5'))
			SC5->(dbSetOrder(1))
			SC5->(dbGoTop())
			SC5->(dbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
			If SC5->C5_TIPO == 'N' .AND. SC5->C5_ZZTPOPE $ '01 - 04 - 09 - 12' 
				If SC5->(DTOC(C5_ZDTDIGI) == "  /  /    " .OR. DTOC(C5_ZLIBREG) == "  /  /    " .OR. DTOC(C5_ZDLBCAD) == "  /  /    ")
					xcRet	:=	2
					Alert('PEDIDO EM PROCESSO DE LIBERAÇÃO', 'ALERTA MB')
				EndIf
				If DTOC(SC5->C5_ZEXCPED) != "  /  /    "
					xcRet	:=	2
					Alert('PEDIDO CANCELADO ', 'ALERTA MB')
				EndIf
			EndIf
		EndIf


		//U_ufAmbiente(xaAlias, "R")
	EndIf

Return(xcRet)




Static Function xsfPedido(xcPedido)
	Local xcPed		:=	xcPedido
	Local xcCred	:=	1
	Local xcMens	:=	''
	Local xcAsst	:=	'Pedido Liberação de Estoque'
	Local xcMail	:=	GetMv('MB_MAILDIG')
	Local xcCco		:=	''
	Local xcPath	:=	''


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
	xcQuery += xcR + 	"		C6_FILIAL = '" + xFilial('SC6') + "' "
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
	xcQuery += xcR + 	"		C6_FILIAL = '" + xFilial('SC6') + "'  AND "
	xcQuery += xcR + 	"		C6_BLQ = ''  AND "
	xcQuery += xcR + 	"	NOT EXISTS  "
	xcQuery += xcR + 	"	(  "
	xcQuery += xcR + 	"	SELECT  "
	xcQuery += xcR + 	"		D2_PEDIDO  "
	xcQuery += xcR + 	"	FROM  "
	xcQuery += xcR + 	"		" + RetSqlName("SD2") + "  "
	xcQuery += xcR + 	"	WHERE  "
	xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND  "
	xcQuery += xcR + 	"		D2_FILIAL = '" + xFilial('SD2') + "' AND "
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
	xcQuery += xcR + 	"		E1_FILIAL = '" + xFilial('SE1') + "'  "
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
	xcQuery += xcR + 	"		E1_FILIAL = '" + xFilial('SE1') + "'  AND "
	xcQuery += xcR + 	"		CONVERT(DATETIME,E1_VENCREA,103) - GETDATE() < -1 "
	xcQuery += xcR + 	"	GROUP BY "
	xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA "
	xcQuery += xcR + 	"	) J ON  "
	xcQuery += xcR + 	"	A1_COD = J.E1_CLIENTE AND "
	xcQuery += xcR + 	"	A1_LOJA = J.E1_LOJA  INNER JOIN
	xcQuery += xcR + 	"	" + RetSqlName("SA3") + " L ON "
	xcQuery += xcR + 	"	C5_VEND1 = A3_COD "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	C5_FILIAL = '" + xFilial('SC5') + "' AND "
	xcQuery += xcR + 	"	C5_TIPO = 'N' AND "
	xcQuery += xcR + 	"	C5_NUM = '" + xcPed + "' AND "
	xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	A1_FILIAL = '" + xFilial('SA1') + "' AND "
	xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	NOT EXISTS  "
	xcQuery += xcR + 	"	(  "
	xcQuery += xcR + 	"	SELECT  "
	xcQuery += xcR + 	"		D2_PEDIDO  "
	xcQuery += xcR + 	"	FROM  "
	xcQuery += xcR + 	"		" + RetSqlName("SD2") + "  "
	xcQuery += xcR + 	"	WHERE  "
	xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND  "
	xcQuery += xcR + 	"		D2_FILIAL = '" + xFilial('SD2') + "' AND "
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
	xcQuery += xcR + 	"		" + RetSqlName("SC6") + " A LEFT JOIN "
	xcQuery += xcR + 	"		" + RetSqlName("SC9") + " B ON "
	xcQuery += xcR + 	"		C6_NUM = C9_PEDIDO AND "
	xcQuery += xcR + 	"		C6_ITEM = C9_ITEM AND "
	xcQuery += xcR + 	"		C9_FILIAL = '" + xFilial('SC9') + "' AND "
	xcQuery += xcR + 	"		B.D_E_L_E_T_ = '' "
	xcQuery += xcR + 	"	WHERE "
	xcQuery += xcR + 	"		A.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"		C6_FILIAL = '" + xFilial('SC6') + "' AND "
	xcQuery += xcR + 	"		A.C6_NUM = C5_NUM "
	xcQuery += xcR + 	"	) C "
	xcQuery += xcR + 	"	WHERE "
	xcQuery += xcR + 	"		LIBERADO = 'FORA') "
	xcQuery += xcR + 	"	ORDER BY   "
	xcQuery += xcR + 	"		C5_NUM "

	//Gera um arquivo com a query acima.
	MemoWrite("\SQL\Libera Estoque Pedido 01.SQL",xcQuery)

	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif

	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB


	dbSelectArea('SC5')
	SC5->(dbSeek(xFilial('SC5') + xcPed))

	PswOrder(2)
	PswSeek(FWLEUSERLG("SC5->C5_USERLGI",1),.t.)
	xcCco   :=  PswRet(1)[1][14]

	XTRB->(dbGoTop())
	While !(XTRB->(EOF()))
		SC5->(dbSelectArea('SC5'))
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		SC5->(dbSeek(xFilial("SC5")+xcPed))
		If XTRB->TOTLIB > SC5->C5_ZTOTLIB
			xcMail	:=	GetMv('MB_MAILCRD')
			xcCred := 2
			RecLock("SC5",.F.)
			SC5->C5_ZZLIBCR  := Ctod('  /  /    ')
			SC5->(MsUnLock())

			xcMens	:=	'<html><head> '
			xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
			xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
			xcMens	+=	'<title>Observação</title> '
			xcMens	+=	'</head><body>
			xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
			xcMens	+=	'	<p style="text-align: left;">Pedido Bloqueado na Liberação do Estoque.</p> '
			xcMens	+=	'	<p style="text-align: left;">Este pedido retornou devido alteração no valor aprovado anteriormente de '+Transform(SC5->C5_ZTOTLIB,"999,999,999.99")+' para '+Transform(XTRB->TOTLIB,"999,999,999.99")+'.</p> '
			xcMens	+=	'	<table border="1" width="100%"> '
			xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
			xcMens	+=	'		<tr><td>'+XTRB->PEDIDO+'</td><td>'+XTRB->CLIENTE+'</td><td>'+XTRB->NOME+'</td><td>'+Transform(XTRB->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTRB->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTRB->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTRB->DUPLIC,"999,999,999.99")+'</td><td>'+XTRB->CODVEND+'</td></tr></table> '
			xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
			xcMens	+=	'	<p>&nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
			xcMens	+=	'<p style="text-align: left"> '
			xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
			xcMens	+=	'</body></html> '


			U_MBEnvMail(xcAsst,xcMail,xcCco,xcMens,xcPath)

			Alert('PEDIDO COM SALDO EM ATRASO MAIOR QUE O APROVADO', 'ALERTA MB')

			Return(xcCred)
		EndIf

		If STOD(XTRB->DTCON) < Date() - 10
			Return(1)
			xcMail	:=	GetMv('MB_MAILCAD')
			xcCred := 2
			Alert('SINTEGRA DESATUALIZADO', 'ALERTA MB')

			RecLock("SC5",.F.)
			SC5->C5_ZDLBCAD := Ctod('  /  /    ')
			SC5->(MsUnLock())

			xcMens	:=	'<html><head> '
			xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
			xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
			xcMens	+=	'<title>Observação</title> '
			xcMens	+=	'</head><body>
			xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
			xcMens	+=	'	<p style="text-align: left;">Pedido Bloqueado na Liberação do Estoque.</p> '
			xcMens	+=	'	<p style="text-align: left;">Este pedido retornou devido à data do Sintegra estar desatualizada: ' + DTOC(STOD(XTRB->DTCON)) + '.</p> '
			xcMens	+=	'	<table border="1" width="100%"> '
			xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
			xcMens	+=	'		<tr><td>'+XTRB->PEDIDO+'</td><td>'+XTRB->CLIENTE+'</td><td>'+XTRB->NOME+'</td><td>'+Transform(XTRB->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTRB->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTRB->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTRB->DUPLIC,"999,999,999.99")+'</td><td>'+XTRB->CODVEND+'</td></tr></table> '
			xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
			xcMens	+=	'	<p>&nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
			xcMens	+=	'<p style="text-align: left"> '
			xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
			xcMens	+=	'</body></html> '

			U_MBEnvMail(xcAsst,xcMail,xcCco,xcMens,xcPath)


			Return(xcCred)
		EndIf


		dbSelectArea("XTRB")
		XTRB->(dbSkip())
	Enddo

	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	C6_NUM PED, SUM(C6_QTDVEN) - SUM(C9_QTDLIB) DIF "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	" + RetSqlName("SC6") + " A INNER JOIN "
	xcQuery += xcR + 	"	" + RetSqlName("SC9") + " B ON "
	xcQuery += xcR + 	"	C6_NUM = C9_PEDIDO AND "
	xcQuery += xcR + 	"	C6_ITEM = C9_ITEM "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	C6_FILIAL = '" + xFilial('SC6') + "' AND "
	xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	C9_FILIAL = '" + xFilial('SC9') + "' AND "
	xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	C6_NUM = '" + xcPed + "' "
	xcQuery += xcR + 	"GROUP BY "
	xcQuery += xcR + 	"	C6_NUM "

	//Gera um arquivo com a query acima.
	MemoWrite("\SQL\Libera Estoque Pedido 02.SQL",xcQuery)

	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif

	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

	If XTRB->DIF <> 0
		xcCred := 2
		Alert('QUANTIDADE LIBERADA DIFERENTE DA QUANTIDADE VENDIDA', 'ALERTA MB')


		xcMens	:=	'<html><head> '
		xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
		xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
		xcMens	+=	'<title>Observação</title> '
		xcMens	+=	'</head><body>
		xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
		xcMens	+=	'	<p style="text-align: left;">Pedido Bloqueado na Liberação do Estoque.</p> '
		xcMens	+=	'	<p style="text-align: left;">Este pedido retornou devido à DIVERGÊNCIA entre a quantidade vendida e a quandidade liberada. Pedido deve passar novamente na digitação de pedidos para ser alterado e re-enviado para o processo de liberação.</p> '
		xcMens	+=	'	<table border="1" width="100%"> '
		xcMens	+=	'		<tr><td>Pedido</td><td>Diferença do Pedido</td></tr> '
		xcMens	+=	'		<tr><td>'+XTRB->PED+'<td>'+Transform(XTRB->DIF,"999,999,999.99")+'</td></tr></table> '
		xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
		xcMens	+=	'	<p>&nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
		xcMens	+=	'<p style="text-align: left"> '
		xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
		xcMens	+=	'</body></html> '

		xcMail	:=	xcCco
		U_MBEnvMail(xcAsst,xcMail,"",xcMens,xcPath)


		Return(xcCred)
	EndIf



Return(xcCred)
