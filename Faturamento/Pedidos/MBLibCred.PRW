#Include "Protheus.ch"
#Include "Topconn.ch"

//Esta Rotina é chamada pelo Ponto de Entrada FC010BTN na Tela da Posição dos Clientes

User Function MBLibCred()

Local oDlg, oObserv, oMarkF
Local aSize     	:= 	FWGetDialogSize( oMainWnd )
Local cCabecalho	:= 	"Selecionar Pedidos a Liberar"
Local lOK       	:= 	.F.
Local cObserv   	:= 	Space(255)
Local lInvert   	:= 	.F.
Local cMarca    	:= 	""
Local aCampos  		:= 	{{"OK","",""},{"PEDIDO","","Pedido"},{"EMISSAO","","Emissao do Pedido"},{"ESPEC","","Especial?"},{"CLIENTE","","Cliente"},{"LOJA","","Loja"},{"NOME","","Nome do Cliente"},{"TOTAL","","Total do Pedido"},{"TOTPED","","Total Pedido Não Faturado"},{"ATRASO","","Total em Atraso"},{"DUPLIC","","Total em Aberto"},{"RISCO","","Risco"},{"LIMITE","","Limite do Cliente"},{"VENCLIM","","Venc Limite"},{"DTCON","","Data da Consulta"},{"LIBCR","","Data do Crédito"},{"DIGITI","","Data da Digitação"},{"CADAST","","Liberação Cadastro"},{"LIBREG","","Data da Regra"},{"EXCPED","","Data da Reprovação"},{"CODVEND","","Cod Vendedor"},{"NOMVEND","","Nome Vendedor"},{"BLOQUE","","Bloquei Regras"},{"CODUSER","","Nome Usuário"},{"AUTOVEN","","Origem Pedido"}}
Local cArqOP
Private xaAlias 	:= { {Alias()},{"SE1"},{"SA1"},{"SA3"},{"SC5"},{"SC6"},{"SC9"},{"SD2"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)
Private aCores		:=	{}
//U_ufAmbiente(xaAlias, "S")




//Marck Browse Linha.
aStrut := {}

Aadd( aStrut , { "OK"     , "C" , 02 , 0 } )
Aadd( aStrut , { "PEDIDO" , "C" , 06 , 0 } )
Aadd( aStrut , { "EMISSAO", "D" , 08 , 0 } )
Aadd( aStrut , { "ESPEC"  , "C" , 03 , 0 } )
Aadd( aStrut , { "CLIENTE", "C" , 06 , 0 } )
Aadd( aStrut , { "LOJA"   , "C" , 02 , 0 } )
Aadd( aStrut , { "ZTPOPE" , "C" , 02 , 0 } )
Aadd( aStrut , { "NOME"   , "C" , 35 , 0 } )
Aadd( aStrut , { "TOTAL"  , "N" , 14 , 2 } )
Aadd( aStrut , { "TOTPED" , "N" , 14 , 2 } )
Aadd( aStrut , { "ATRASO" , "N" , 14 , 2 } )
Aadd( aStrut , { "DUPLIC" , "N" , 14 , 2 } )
Aadd( aStrut , { "TOTLIB" , "N" , 14 , 2 } )
Aadd( aStrut , { "VALPED" , "N" , 14 , 2 } )
Aadd( aStrut , { "RISCO"  , "C" , 01 , 0 } )
Aadd( aStrut , { "LIMITE" , "N" , 14 , 2 } )
Aadd( aStrut , { "VENCLIM", "D" , 08 , 0 } )
Aadd( aStrut , { "DTCON"  , "D" , 08 , 0 } )
Aadd( aStrut , { "LIBCR"  , "D" , 08 , 0 } )
Aadd( aStrut , { "DIGITI" , "D" , 08 , 0 } )
Aadd( aStrut , { "DATRET" , "D" , 08 , 0 } )
Aadd( aStrut , { "CADAST" , "D" , 08 , 0 } )
Aadd( aStrut , { "LIBREG" , "D" , 08 , 0 } )
Aadd( aStrut , { "EXCPED" , "D" , 08 , 0 } )
Aadd( aStrut , { "CODVEND", "C" , 06 , 0 } )
Aadd( aStrut , { "NOMVEND", "C" , 35 , 0 } )
Aadd( aStrut , { "BLOQUE" , "C" , 01 , 0 } )
Aadd( aStrut , { "CODUSER", "C" , 35 , 0 } )
Aadd( aStrut , { "AUTOVEN", "C" , 07 , 0 } )

cArqOP := CriaTrab(aStrut)

if select("XTIT") > 0
	XTIT->(dbclosearea())
endif

dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco

//Processa( { || xsfPedLib() })


Aadd(aCores, {'XTIT->BLOQUE == "5" ',"BR_BRANCO"	})																												//COMISSÃO INCORRETA
Aadd(aCores, {'(XTIT->ATRASO  > 0 .AND. DTOC(XTIT->LIBCR)  == "  /  /    ") .AND. DTOC(XTIT->EXCPED)=="  /  /    " ',"BR_PRETO"	})																												//CREDITO
Aadd(aCores, {'(DTOC(XTIT->DIGITI)=="  /  /    " .AND. XTIT->ATRASO == 0) .OR.  (DTOC(XTIT->DIGITI)=="  /  /    " .AND. XTIT->ATRASO  > 0 .AND. DTOC(XTIT->LIBCR) != "  /  /    ") .AND. DTOC(XTIT->EXCPED)=="  /  /    " ',"BR_AMARELO"	})	//DIGITAÇÃO
Aadd(aCores, {' DTOC(XTIT->DIGITI)!="  /  /    " .AND. DTOC(XTIT->CADAST)=="  /  /    " .AND. DTOC(XTIT->EXCPED)=="  /  /    " .AND. DTOC(XTIT->DATRET)=="  /  /    "  ',"BR_PINK"	})																									//CADASTRO
Aadd(aCores, {' DTOC(XTIT->CADAST)!="  /  /    " .AND. DTOC(XTIT->LIBREG)=="  /  /    " .AND. DTOC(XTIT->EXCPED)=="  /  /    "  ',"BR_AZUL"	})																							   		//REGRAS
Aadd(aCores, {' DTOC(XTIT->EXCPED)!="  /  /    "										',"BR_MARROM"})																							   		//REPROVADO
Aadd(aCores, {' DTOC(XTIT->DIGITI)!="  /  /    " .AND. DTOC(XTIT->CADAST)!="  /  /    " .AND. DTOC(XTIT->LIBREG)!="  /  /    " .AND. DTOC(XTIT->EXCPED)=="  /  /    "  ',"BR_VERDE"	})															//LIBERADO
Aadd(aCores, {' DTOC(XTIT->DATRET) != "  /  /    " ',"BR_LARANJA"	})																												//CREDITO



DbSelectArea( "XTIT" )
XTIT->( DbGoTop() )

cMarca := XTIT->(GetMark())

oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)


PRIVATE aButtons :=	{}
Aadd(aButtons, {"EnvPed", {|| xsfEnvPed(cMarca, cObserv)}, "EnvPed...", "Envia Pedido Digitado" 	, {|| .T.}} )
Aadd(aButtons, {"Regras", {|| xsfRegras(cMarca, cObserv)}, "Regras...", "Libera Regras" 			, {|| .T.}} )
Aadd(aButtons, {"Credit", {|| xsfCredit(cMarca, cObserv)}, "Credit...", "Libera Credito" 			, {|| .T.}} )
Aadd(aButtons, {"RetPed", {|| xsfRetPed(cMarca, cObserv)}, "RetPed...", "Retorna Pedido Digitação" 	, {|| .T.}} )
Aadd(aButtons, {"AtuTrb", {|| xsfAtuTrb()}               , "AtuTrb...", "Cadastro de Clientes "		, {|| .T.}} )
Aadd(aButtons, {"AtuCad", {|| xsfAtuCad(cMarca, cObserv)}, "AtuCad...", "Análise de Cadastro  "		, {|| .T.}} )
Aadd(aButtons, {"CancPD?",{|| xsfExcPed(cMarca, cObserv)}, "CancPD...", "Reprovação de Pedido "		, {|| .T.}} )
Aadd(aButtons, {"Legend", {|| MBLegen()}                 , "Legend...", "Legenda           " 		, {|| .T.}} )




Define MsDialog oDlg Title cCabecalho From aSize[1], aSize[2] To aSize[3], aSize[4] Pixel

@ (oDlg:nHeight/2)-88, 005 SAY oSay1 PROMPT "Justificativa"  SIZE 150, 010 OF oDlg COLORS 0, 16777215 FONT oFont20 PIXEL
@ (oDlg:nHeight/2)-80, 005 MSGET  oObserv VAR cObserv	 SIZE 200,010 PICTURE "@!S20" OF oDlg FONT oFont20 PIXEL


oMarkF:= MsSelect():New("XTIT","OK",,aCampos,@lInvert,@cMarca,{34,05,(oDlg:nHeight/2)-120,(oDlg:nWidth/2)-05},,,,,aCores)
oMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock(),XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }
oMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock()) })), XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }



ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||lOK:=.T., Alert('ESCOLHA SUA OPÇÃO EM AÇÕES RELACIONADAS','ALERTA MB'),IIF(MSGYESNO('DESEJA SAIR?','ALERTA MB'),oDlg:End(),.T.)},{||oDlg:End()},,@aButtons))



//U_ufAmbiente(xaAlias, "R")

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfAtuTrb ºAutor  ³Microsiga           º Data ³  28/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfAtuTrb()
Local xoMarkF

MATA030()

dbSelectArea("XTIT")
dbGoTop()
dbSelectArea("SA1")
dbGoTop()
While !(XTIT->(EOF()))
	If SA1->(dbSeek(xFilial("SA1") + XTIT->(CLIENTE+LOJA)))
		RecLock('XTIT',.F.)
		XTIT->DTCON	:= SA1->A1_ZZDTCON
		MsUnLock()
	EndIf
	XTIT->(dbSkip())
Enddo
XTIT->(dbGoTop())
Return


Static Function xsfPedLib()
Local xcLogUs	:=	__cUserId
Local xcTpUs	:=	''

xcQuery := 			"SELECT * FROM ( "
xcQuery += xcR + 	"SELECT "
xcQuery += xcR + 	"	C5_NUM PEDIDO, C5_CLIENTE CLIENTE, C5_LOJACLI LOJA, A1_NOME NOME, ROUND(D.C6_VALOR,2) TOTAL,  "
xcQuery += xcR + 	"	F.C6_VALOR TOTPED, ISNULL(SLDTOT,0) DUPLIC, ISNULL(SLDATR,0) ATRASO, A1_ZZDTCON DTCON, A1_RISCO RISCO,  "
xcQuery += xcR + 	"	A1_LC LIMITE, A1_VENCLC VENCLIM, C5_USERLGI CODUSER, C5_VEND1 CODVEND, A3_NOME NOMVEND, C5_ZTOTLIB TOTLIB, "
xcQuery += xcR + 	"	C5_BLQ BLOQUE, C5_ZDTDIGI DIGITI, C5_ZZLIBCR LIBCR, C5_ZLIBREG LIBREG, C5_ZDLBCAD CADAST, C5_ZEXCPED EXCPED, C5_EMISSAO EMISSAO, "
xcQuery += xcR + 	"	CASE WHEN C5_ZZCODPD = '' THEN 'MANUAL' ELSE 'AUTOVEN' END AUTOVEN, C5_ZDTRETO DATRET, "
xcQuery += xcR + 	"	CASE WHEN C5_ZESPECI = 'N' THEN 'NÃO' ELSE 'SIM' END ESPEC, C5_ZZTPOPE ZTPOPE, C5_ZVALPED VALPED "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName("SC5") + " A INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName("SA1") + " B ON "
xcQuery += xcR + 	"	C5_CLIENTE = A1_COD AND "
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
xcQuery += xcR + 	"	C5_ZZTPOPE NOT IN ('PA', '10') AND "
xcQuery += xcR + 	"	C5_NUM >= '049345' AND "
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
xcQuery += xcR + 	"		A.C6_NUM = C5_NUM AND "
xcQuery += xcR + 	"		A.C6_BLQ <> 'R' "
xcQuery += xcR + 	"	) C "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		LIBERADO = 'FORA'))X "
If __cUserId $ GetMv('MB_FILCADA')
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	((DIGITI <> '' AND CADAST = '' AND EXCPED = '' AND DATRET = '') OR "  
	xcQuery += xcR + 	"	(ATRASO > 0 AND LIBCR = '' AND EXCPED = '')) "  
	xcQuery += xcR + 	"ORDER BY   "
	xcQuery += xcR + 	"		ATRASO, PEDIDO "
Else
	xcQuery += xcR + 	"ORDER BY   "
	xcQuery += xcR + 	"	PEDIDO "
EndIf//Gera um arquivo com a query acima.

MemoWrite("Libera Pedido.SQL",xcQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTT


XTT->(dbGoTop())
While !(XTT->(EOF()))
	
	
	dbSelectArea("XTIT")
	RecLock("XTIT",.T.)
	XTIT->PEDIDO   	:= XTT->PEDIDO
	XTIT->ESPEC   	:= XTT->ESPEC
	XTIT->CLIENTE  	:= XTT->CLIENTE
	XTIT->LOJA   	:= XTT->LOJA
	XTIT->ZTPOPE	:= XTT->ZTPOPE
	XTIT->NOME   	:= XTT->NOME
	XTIT->TOTAL   	:= XTT->TOTAL
	XTIT->TOTPED   	:= XTT->TOTPED
	XTIT->ATRASO 	:= XTT->ATRASO
	XTIT->DUPLIC 	:= XTT->DUPLIC
	XTIT->TOTLIB 	:= XTT->TOTLIB
	XTIT->VALPED 	:= XTT->VALPED
	XTIT->LIMITE 	:= XTT->LIMITE
	XTIT->RISCO 	:= XTT->RISCO
	XTIT->VENCLIM 	:= STOD(XTT->VENCLIM)
	XTIT->DTCON 	:= STOD(XTT->DTCON)
	XTIT->DIGITI 	:= STOD(XTT->DIGITI)
	XTIT->DATRET 	:= STOD(XTT->DATRET)
	XTIT->CADAST 	:= STOD(XTT->CADAST)
	XTIT->LIBREG 	:= STOD(XTT->LIBREG)
	XTIT->EXCPED 	:= STOD(XTT->EXCPED)
	XTIT->LIBCR 	:= STOD(XTT->LIBCR)
	XTIT->EMISSAO 	:= STOD(XTT->EMISSAO)
	XTIT->CODVEND 	:= XTT->CODVEND
	XTIT->NOMVEND 	:= XTT->NOMVEND
	XTIT->BLOQUE 	:= XTT->BLOQUE
	XTIT->AUTOVEN 	:= XTT->AUTOVEN
	
	dbSelectArea('SC5')
	SC5->(dbSeek(xFilial('SC5') + XTT->PEDIDO))
	
	XTIT->CODUSER 	:= FWLEUSERLG("SC5->C5_USERLGI",1)
	XTIT->(MsUnLock())
	
	dbSelectArea("XTT")
	XTT->(dbSkip())
Enddo

XTT->(dbCloseArea())
XTIT->(dbGoTop())
Return


Static Function MBLegen()
Local aCores := {}

Aadd(aCores, {"BR_PRETO"   	,"Bloqueio Crédito"})
Aadd(aCores, {"BR_AZUL"    	,"Bloqueio Regras"})
Aadd(aCores, {"BR_AMARELO" 	,"Bloqueio Digitação"})
Aadd(aCores, {"BR_PINK" 	,"Bloqueio Cadastro" })
Aadd(aCores, {"BR_MARROM" 	,"Pedido Reprovado" })
Aadd(aCores, {"BR_VERDE"   	,"Libera para Faturar" })
Aadd(aCores, {"BR_LARANJA" 	,"Pedido Retorno Digitação" })
Aadd(aCores, {"BR_LARANJA" 	,"Comissão Fora da Faixa" })

BrwLegenda("LIBERAÇÃO PEDIDOS","LEGENDAS",aCores)//"Prepara‡„o dos Documentos de Sa¡da"/"Legenda"

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfEnvPed ºAutor  ³Claudio Alves       º Data ³  04/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfEnvPed(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xcObs		:=	cObserv
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xcMens	:=	''
Local xcAsst	:=	'Pedido Liberado na Digitação'
Local xcMail	:=	GetMv('MB_MAILDIG')
Local xcCco		:=	''
Local xcPath	:=	''

dbSelectArea("XTIT")
XTIT->(dbGoTop())


If !(__cUserId  $ GetMv('MB_ENVPEDI'))
	Alert('Usuário sem Acesso', 'ALERTA MB')
	Return
EndIf


While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	If !Empty(AllTrim(dToS(XTIT->DIGITI))) .AND. Empty(AllTrim(dToS(XTIT->DATRET)))
		Alert('Pedido Já Enviado', 'ALERTA MB')
		Return
	EndIf
	If XTIT->ATRASO > 0 .AND. DTOC(XTIT->LIBCR)=="  /  /    "
		Alert('CLIENTE COM ATRASO'+xcR+'PRECISA SER LIBERADO POR CRÉDITO', 'ALERTA MB')
	Else
		SC5->(dbSelectArea('SC5'))
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		SC5->(dbSeek(xFilial("SC5")+XTIT->PEDIDO))
		If XTIT->TOTLIB <= SC5->C5_ZTOTLIB
			If SC5->C5_ZVALPED	<	XTIT->TOTAL - 1 .AND. !Empty(AllTrim(dTos(XTIT->DATRET)))
				Alert('Valor Alterado para Maior, de: ' + Transform(SC5->C5_ZVALPED,"999,999,999.9999") + ' para ' + Transform(XTIT->TOTAL,"999,999,999.9999") + xcR + 'Vai voltar para o Processo de Liberação', 'ALERTA MB')

				xcQuery := xcR + 	"UPDATE SB2010 "
				xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
				xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
				xcQuery += xcR + 	"	FROM SC9010 SC9 "
				xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
				xcQuery += xcR + 	"	AND C9_BLEST='' "
				xcQuery += xcR + 	"	AND C9_BLCRED='' "
				xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
				xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
				xcQuery += xcR + 	"	) T "
				xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
				TCSQLEXEC(xcQuery)

				xcQuery := xcR + 	"UPDATE "
				xcQuery += xcR + 	"	" + RetSqlName("SC5") + " "
				xcQuery += xcR + 	"SET "
				xcQuery += xcR + 	"	C5_ZDTDIGI  = '" + Dtos(dDataBase) + "', "
				xcQuery += xcR + 	"	C5_ZDLBCAD  = '', "
				xcQuery += xcR + 	"	C5_ZZCADLB  = '', "
				xcQuery += xcR + 	"	C5_ZZLIBCR  = '', "
				xcQuery += xcR + 	"	C5_ZLIBREG  = '', "
				xcQuery += xcR + 	"	C5_ZZOBSDG  = '', "
				xcQuery += xcR + 	"	C5_ZDTRETO  = '', "
				xcQuery += xcR + 	"	C5_ZVALPED  = " + Alltrim(Transform(XTIT->TOTAL,"99999999.9999")) + " "
				xcQuery += xcR + 	"WHERE "
				xcQuery += xcR + 	"	D_E_L_E_T_ = ' ' AND "
				xcQuery += xcR + 	"	C5_FILIAL = '"  + xFilial('SC5')  + "' AND "
				xcQuery += xcR + 	"	C5_NUM = '"  + XTIT->PEDIDO  + "' "
				xcQuery += xcR + 	" "
				xcQuery += xcR + 	"UPDATE "
				xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
				xcQuery += xcR + 	"SET "
				xcQuery += xcR + 	"	C9_BLCRED  = '02', "
				xcQuery += xcR + 	"	C9_BLEST  = '02' "
				xcQuery += xcR + 	"WHERE "
				xcQuery += xcR + 	"	D_E_L_E_T_ = ' ' AND "
				xcQuery += xcR + 	"	C9_FILIAL = '"  + xFilial('SC9')  + "' AND "
				xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
				
				TCSQLEXEC(xcQuery)

				RecLock('XTIT', .F.)
				XTIT->DIGITI	:=	dDataBase
				XTIT->DATRET	:=	cTod('  /  /    ')
				XTIT->OK		:=	""
				XTIT->CADAST 	:=	cTod('  /  /    ')
				XTIT->LIBREG 	:=	cTod('  /  /    ')
				XTIT->LIBCR 	:=	cTod('  /  /    ')
				
				XTIT->(MsUnLock())
			Else
				
				xcMens	:=	'<html><head> '
				xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
				xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
				xcMens	+=	'<title>Observação</title> '
				xcMens	+=	'</head><body>
				xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
				xcMens	+=	'	<p style="text-align: left;">Temos um novo pedido para sua análise.</p> '
				xcMens	+=	'	<p style="text-align: left;">Segue abaixo o pedido liberado no departamento Comercial.</p> '
				If !Empty(xcObs)
					xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
				EndIf
				xcMens	+=	'	<table border="1" width="100%"> '
				xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
				xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
				xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
				xcMens	+=	'	<p>&nbsp;</p> '
				xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
				xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
				xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
				xcMens	+=	'<p style="text-align: left"> '
				xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
				xcMens	+=	'</body></html> '
				
				PswOrder(1)
				PswSeek(__cUserID,.t.)
				
				//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],xcMail,xcCco,xcMens,xcPath)
				
				NGSendMail(PswRet(1)[1][04], xcMail, xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
				                                        
				xcQuery := xcR + 	"UPDATE SB2010 "
				xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
				xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
				xcQuery += xcR + 	"	FROM SC9010 SC9 "
				xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
				xcQuery += xcR + 	"	AND C9_BLEST='' "
				xcQuery += xcR + 	"	AND C9_BLCRED='' "
				xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
				xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
				xcQuery += xcR + 	"	) T "
				xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
				TCSQLEXEC(xcQuery)

				xcQuery := xcR + 	"UPDATE "
				xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
				xcQuery += xcR + 	"SET "
				xcQuery += xcR + 	"	C9_BLCRED  = '  ', "
				xcQuery += xcR + 	"	C9_BLEST  = '02' "
				xcQuery += xcR + 	"WHERE "
				xcQuery += xcR + 	"	D_E_L_E_T_ = ' ' AND "
				xcQuery += xcR + 	"	C9_FILIAL = '"  + xFilial('SC9')  + "' AND "
				xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
				
				TCSQLEXEC(xcQuery)

				RecLock("SC5",.F.)
				SC5->C5_ZDTDIGI	:=	dDataBase
				SC5->C5_ZVALPED	:=	XTIT->TOTAL
				SC5->C5_ZDTRETO	:=	cTod('  /  /    ')
				SC5->C5_TRANSP	:=	""
				If Empty(AllTrim(XTIT->BLOQUE))
					SC5->C5_ZLIBREG	:=	dDataBase
					SC5->C5_ZZOBSRG	:=	"PEDIDO SEM BLOQUEIO DE REGRAS"
				EndIf
				SC5->(MsUnLock())
				
				RecLock('XTIT', .F.)
				XTIT->DIGITI	:=	dDataBase
				XTIT->DATRET	:=	cTod('  /  /    ')
				XTIT->OK		:=	""
				
				XTIT->(MsUnLock())
			EndIf
		Else
			Alert('HOUVE ALTERAÇÃO NO VALOR APROVADO' + xcR + 'DEVE SER RE-APROVADO PELO FINANCEIRO','ALERTA MB')
			
			RecLock("SC5",.F.)
			SC5->C5_ZZLIBCR	:=	Ctod('  /  /    ')
			SC5->C5_ZDTDIGI	:=	Ctod('  /  /    ')
			SC5->C5_ZVALPED	:=	XTIT->TOTAL
			SC5->C5_ZDTRETO	:=	cTod('  /  /    ')
			SC5->C5_TRANSP	:=	""
			SC5->(MsUnLock())
			xcMens	:=	'<html><head> '
			xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
			xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
			xcMens	+=	'<title>Observação</title> '
			xcMens	+=	'</head><body>
			xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
			xcMens	+=	'	<p style="text-align: left;">Temos um novo pedido para sua análise.</p> '
			xcMens	+=	'	<p style="text-align: left;">Este pedido retornou devido alteração no valor aprovado anteriormente de '+Transform(SC5->C5_ZTOTLIB,"999,999,999.99")+' para '+Transform(XTIT->TOTLIB,"999,999,999.99")+'.</p> '
			If !Empty(xcObs)
				xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
			EndIf
			xcMens	+=	'	<table border="1" width="100%"> '
			xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
			xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
			xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
			xcMens	+=	'	<p>&nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
			xcMens	+=	'<p style="text-align: left"> '
			xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
			xcMens	+=	'</body></html> '
			
			PswOrder(1)
			PswSeek(__cUserID,.t.)

			//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],GetMv('MB_MAILCRD'),xcCco,xcMens,xcPath)

			NGSendMail(PswRet(1)[1][04], GetMv('MB_MAILCRD'), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)

			RecLock('XTIT', .F.)
			XTIT->OK		:=	""
			XTIT->DATRET	:=	cTod('  /  /    ')
			XTIT->LIBCR 	:=	cTod('  /  /    ')
			XTIT->(MsUnLock())
			
		EndIf
		
	EndIf
	
	XTIT->(dbSkip())
Enddo

XTIT->(dbGoTop())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsf ºAutor  ³Claudio Alves       º Data ³  04/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfAtuCad(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xcObs		:=	cObserv
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xcMens	:=	''
Local xcAsst	:=	'Pedido Liberado em Cadastro'
Local xcMail	:=	GetMv('MB_MAILREG')
Local xcCco		:=	''
Local xcPath	:=	''


dbSelectArea("XTIT")
XTIT->(dbGoTop())


If !(__cUserId $ GetMv('MB_LIBCADA'))
	Alert('Usuário sem Acesso', 'ALERTA MB')
	Return
EndIf

While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	If DTOC(XTIT->DIGITI)=="  /  /    "
		Alert('PEDIDO AINDA NÃO LIBERADO PELA DIGITAÇÃO', 'ALERTA MB')
		XTIT->(dbSkip())
		Loop
	Endif
	
	If XTIT->DTCON < Date() - 10
		Alert('CADASTRO DE CLIENTE DESATUALIZADO', 'ALERTA MB')
		XTIT->(dbSkip())
		Loop
	Endif
	
	If !Empty(AllTrim(dToS(XTIT->CADAST)))
		Alert('Pedido Já Liberado', 'ALERTA MB')
		Return
	EndIf
	
	SC5->(dbSelectArea('SC5'))
	SC5->(dbSetOrder(1))
	SC5->(dbGoTop())
	SC5->(dbSeek(xFilial("SC5")+XTIT->PEDIDO))
	If XTIT->TOTLIB <= SC5->C5_ZTOTLIB
		RecLock("SC5",.F.)
		SC5->C5_ZDLBCAD	:=	dDataBase
		SC5->C5_TRANSP	:=	""
		If Empty(AllTrim(XTIT->BLOQUE))
			SC5->C5_ZLIBREG	:=	dDataBase
			SC5->C5_ZZOBSRG	:=	"PEDIDO SEM BLOQUEIO DE REGRAS"
			SC5->C5_TRANSP	:=	""
		EndIf
		If DTOC(SC5->C5_ZZLIBCR) == "  /  /    "
			SC5->C5_ZZLIBCR  := dDataBase
			SC5->C5_TRANSP	:=	""
		EndIf
		SC5->(MsUnLock())

		xcQuery := xcR + 	"UPDATE SB2010 "
		xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
		xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
		xcQuery += xcR + 	"	FROM SC9010 SC9 "
		xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
		xcQuery += xcR + 	"	AND C9_BLEST='' "
		xcQuery += xcR + 	"	AND C9_BLCRED='' "
		xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
		xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
		xcQuery += xcR + 	"	) T "
		xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
		TCSQLEXEC(xcQuery)

		
		xcQuery := xcR + 	"UPDATE "
		xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
		xcQuery += xcR + 	"SET "
		xcQuery += xcR + 	"	C9_BLCRED  = ' ', "
		xcQuery += xcR + 	"	C9_BLEST  = '02' "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
		
		TCSQLEXEC(xcQuery)
		
		xcMens	:=	'<html><head> '
		xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
		xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
		xcMens	+=	'<title>Observação</title> '
		xcMens	+=	'</head><body>
		xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
		xcMens	+=	'	<p style="text-align: left;">Temos um novo pedido para sua análise.</p> '
		xcMens	+=	'	<p style="text-align: left;">Segue abaixo o pedido liberado por Cadastro.</p> '
		If !Empty(xcObs)
			xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
		EndIf
		xcMens	+=	'	<table border="1" width="100%"> '
		xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
		xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
		xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
		xcMens	+=	'	<p>&nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
		xcMens	+=	'<p style="text-align: left"> '
		xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
		xcMens	+=	'</body></html> '
		
		PswOrder(1)
		PswSeek(__cUserID,.t.)

		//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],xcMail,xcCco,xcMens,xcPath)
		
		NGSendMail(PswRet(1)[1][04], xcMail, xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
		
		RecLock('XTIT', .F.)
		XTIT->CADAST	:=	dDataBase
		XTIT->OK		:=	""
		If DTOC(XTIT->LIBCR) = "  /  /    "
			XTIT->LIBCR		:=	dDataBase
		EndIF
		XTIT->(MsUnLock())
	Else
		RecLock("SC5",.F.)
		SC5->C5_ZZLIBCR	:=	Ctod('  /  /    ')
		SC5->C5_TRANSP	:=	""
		SC5->(MsUnLock())
		
		xcMens	:=	'<html><head> '
		xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
		xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
		xcMens	+=	'<title>Observação</title> '
		xcMens	+=	'</head><body>
		xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
		xcMens	+=	'	<p style="text-align: left;">Este pedido retornou devido alteração no valor aprovado anteriormente de '+Transform(SC5->C5_ZTOTLIB,"999,999,999.99")+' para '+Transform(XTIT->TOTLIB,"999,999,999.99")+'.</p> '
		If !Empty(xcObs)
			xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
		EndIf
		xcMens	+=	'	<table border="1" width="100%"> '
		xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
		xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
		xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
		xcMens	+=	'	<p>&nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
		xcMens	+=	'<p style="text-align: left"> '
		xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
		xcMens	+=	'</body></html> '
		
		PswOrder(1)
		PswSeek(__cUserID,.t.)

		//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],GetMv('MB_MAILCRD'),xcCco,xcMens,xcPath)
		
		NGSendMail(PswRet(1)[1][04], GetMv('MB_MAILCRD'), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
		
		RecLock('XTIT', .F.)
		XTIT->OK		:=	""
		XTIT->(MsUnLock())
		
	EndIf
	
	XTIT->(dbSkip())
Enddo

XTIT->(dbGoTop())

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfRegras ºAutor  ³Claudio Alves       º Data ³  04/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfRegras(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xcObs		:=	cObserv
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xcMens	:=	''
Local xcAsst	:=	'Pedido Liberado em Regras'
Local xcMail	:=	GetMv('MB_MAILREG')
Local xcCco		:=	''
Local xcPath	:=	''


dbSelectArea("XTIT")
XTIT->(dbGoTop())


If !(__cUserID $ GetMv('MB_LIBREGR'))
	Alert('Usuário sem Acesso', 'ALERTA MB')
	Return
EndIf

If Empty(AllTrim(xcObs))
	Alert('JUSTIFICATIVA OBRIGATÓRIA', 'ALERTA MB')
	Return
EndIf 



While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	If XTIT->ZTPOPE == "04" .AND. AllTrim(XTIT->BLOQUE) $ '3|4|5'
		If !(AllTrim(cUserName) $ GetMv('MB_USERBON'))
			Alert('Usuário sem Acesso', 'ALERTA MB')
			Return
		EndIf
	EndIf
	
	If !Empty(AllTrim(dToS(XTIT->LIBREG)))
		Alert('Pedido Já Liberado', 'ALERTA MB')
		Return
	EndIf
	
	If DTOC(XTIT->DIGITI) == "  /  /    " .OR. DTOC(XTIT->CADAST) == "  /  /    "
		Alert('AGUARDE LIBERAÇÕES ANTERIORES', 'ALERTA MB')
	Else
		SC5->(dbSelectArea('SC5'))
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		SC5->(dbSeek(xFilial("SC5")+XTIT->PEDIDO))
		If XTIT->TOTLIB > SC5->C5_ZTOTLIB
			RecLock("SC5",.F.)
			SC5->C5_ZZLIBCR	:=	Ctod('  /  /    ')
			SC5->C5_TRANSP	:=	""
			SC5->(MsUnLock())
			
			xcMens	:=	'<html><head> '
			xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
			xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
			xcMens	+=	'<title>Observação</title> '
			xcMens	+=	'</head><body>
			xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
			xcMens	+=	'	<p style="text-align: left;">Pedido Liberado por Regras.</p> '
			If !Empty(xcObs)
				xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
			EndIf
			xcMens	+=	'	<table border="1" width="100%"> '
			xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
			xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
			xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
			xcMens	+=	'	<p>&nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
			xcMens	+=	'<p style="text-align: left"> '
			xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
			xcMens	+=	'</body></html> '
			
			PswOrder(1)
			PswSeek(__cUserID,.t.)

			//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],GetMv('MB_MAILCRD'),xcCco,xcMens,xcPath)
			
			NGSendMail(PswRet(1)[1][04], GetMv('MB_MAILCRD'), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
		
			RecLock('XTIT', .F.)
			XTIT->OK		:=	""
			XTIT->LIBCR		:=	cTod('  /  /    ')
			XTIT->(MsUnLock())
			
		ElseIf XTIT->DTCON < Date() - 10
			Alert('SINTEGRA DESATUALIZADO', 'ALERTA MB')
			
			RecLock("SC5",.F.)
			SC5->C5_ZDLBCAD :=	Ctod('  /  /    ')
			SC5->C5_TRANSP	:=	""
			If Empty(AllTrim(XTIT->BLOQUE))
				SC5->C5_ZLIBREG	:=	dDataBase
				SC5->C5_ZZOBSRG	:=	"PEDIDO SEM BLOQUEIO DE REGRAS"
			EndIf
			SC5->(MsUnLock())
			
			xcMens	:=	'<html><head> '
			xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
			xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
			xcMens	+=	'<title>Observação</title> '
			xcMens	+=	'</head><body>
			xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
			xcMens	+=	'	<p style="text-align: left;">Este pedido retornou porque a data do Sintegra expirou, Favor aguarde o cadastro.</p> '
			If !Empty(xcObs)
				xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
			EndIf
			xcMens	+=	'	<table border="1" width="100%"> '
			xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
			xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
			xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
			xcMens	+=	'	<p>&nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
			xcMens	+=	'<p style="text-align: left"> '
			xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
			xcMens	+=	'</body></html> '
			
			PswOrder(1)
			PswSeek(__cUserID,.t.)
			
			//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],GetMv('MB_MAILCAD'),xcCco,xcMens,xcPath)
		
			NGSendMail(PswRet(1)[1][04], GetMv('MB_MAILCRD'), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
		
			RecLock('XTIT', .F.)
			XTIT->OK		:=	""
			XTIT->CADAST	:=	cTod('  /  /    ')
			XTIT->(MsUnLock())
			
		Else
			RecLock("SC5",.F.)
			SC5->C5_BLQ  := ''
			SC5->C5_ZLIBREG	:=	dDataBase
			SC5->C5_ZZOBSRG	:=	cObserv
			SC5->C5_ZTOTLIB	:=	XTIT->TOTLIB
			SC5->C5_TRANSP	:=	""
			SC5->(MsUnLock())
			
			xcQuery := xcR + 	"UPDATE SB2010 "
			xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
			xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
			xcQuery += xcR + 	"	FROM SC9010 SC9 "
			xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
			xcQuery += xcR + 	"	AND C9_BLEST='' "
			xcQuery += xcR + 	"	AND C9_BLCRED='' "
			xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
			xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
			xcQuery += xcR + 	"	) T "
			xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
			TCSQLEXEC(xcQuery)

			xcQuery := xcR + 	"UPDATE "
			xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
			xcQuery += xcR + 	"SET "
			xcQuery += xcR + 	"	C9_BLCRED  = ' ', "
			xcQuery += xcR + 	"	C9_BLEST  = '02' "
			xcQuery += xcR + 	"WHERE "
			xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
			
			TCSQLEXEC(xcQuery)
			
			xcMens	:=	'<html><head> '
			xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
			xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
			xcMens	+=	'<title>Observação</title> '
			xcMens	+=	'</head><body>
			xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
			xcMens	+=	'	<p style="text-align: left;">Temos um novo pedido para sua análise.</p> '
			xcMens	+=	'	<p style="text-align: left;">Segue abaixo o pedido liberado por Regras.</p> '
			If !Empty(xcObs)
				xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
			EndIf
			xcMens	+=	'	<table border="1" width="100%"> '
			xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
			xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
			xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
			xcMens	+=	'	<p>&nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
			xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
			xcMens	+=	'<p style="text-align: left"> '
			xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
			xcMens	+=	'</body></html> '
			
			PswOrder(1)
			PswSeek(__cUserID,.t.)

			//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],xcMail,xcCco,xcMens,xcPath)
			
			NGSendMail(PswRet(1)[1][04], xcMail, xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
			
			RecLock('XTIT', .F.)
			XTIT->LIBREG	:=	dDataBase
			XTIT->OK		:=	""
			XTIT->(MsUnLock())
		EndIf
	EndIf
	
	XTIT->(dbSkip())
Enddo
XTIT->(dbGoTop())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfCredit ºAutor  ³Claudio Alves       º Data ³  04/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfCredit(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xcObs		:=	cObserv
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xcMens	:=	''
Local xcAsst	:=	'Liberação de Crédito - Títulos em Atraso'
Local xcMail	:=	Alltrim(GetMv('MB_MAILCRD'))
Local xcMail2	:=	''
Local xcCco		:=	''
Local xcPath	:=	''

dbSelectArea("XTIT")
XTIT->(dbGoTop())


If !(__cUserID $ GetMv('MB_LIBCRED'))
	Alert('Usuário sem Acesso', 'ALERTA MB')
	Return
EndIf


If Empty(AllTrim(xcObs))
	Alert('JUSTIFICATIVA OBRIGATÓRIA', 'ALERTA MB')
	Return
EndIf


While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	If !Empty(AllTrim(dToS(XTIT->LIBCR)))
		Alert('Pedido Já Liberado', 'ALERTA MB')
		Return
	EndIf
	If XTIT->ATRASO > 0

		xcQuery := xcR + 	"UPDATE SB2010 "
		xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
		xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
		xcQuery += xcR + 	"	FROM SC9010 SC9 "
		xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
		xcQuery += xcR + 	"	AND C9_BLEST='' "
		xcQuery += xcR + 	"	AND C9_BLCRED='' "
		xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
		xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
		xcQuery += xcR + 	"	) T "
		xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
		TCSQLEXEC(xcQuery)

		xcQuery := xcR + 	"UPDATE "
		xcQuery += xcR + 	"	" + RetSqlName("SC5") + " "
		xcQuery += xcR + 	"SET "
		xcQuery += xcR + 	"	C5_ZZLIBCR  = '" + dTos(dDataBase) + "', "
		If Empty(AllTrim(XTIT->BLOQUE))
			xcQuery += xcR + 	"	C5_ZLIBREG	= '" + dTos(dDataBase) + "', "
			xcQuery += xcR + 	"	C5_ZZOBSRG	= 'PEDIDO SEM BLOQUEIO DE REGRAS', "
		Else
			xcQuery += xcR + 	"	C5_ZZOBSRG  = '" + cObserv + "', "
		EndIf
		xcQuery += xcR + 	"	C5_ZTOTLIB  = " + Transform(XTIT->ATRASO,"999999999.99") + " "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	C5_NUM = '"  + XTIT->PEDIDO  + "' "
		xcQuery += xcR + 	" "
		xcQuery += xcR + 	"UPDATE "
		xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
		xcQuery += xcR + 	"SET "
		xcQuery += xcR + 	"	C9_BLCRED  = ' ', "
		xcQuery += xcR + 	"	C9_BLEST  = '02' "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
		
		TCSQLEXEC(xcQuery)
		
		xcMens	:=	'<html><head> '
		xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
		xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
		xcMens	+=	'<title>Observação</title> '
		xcMens	+=	'</head><body>
		xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
		xcMens	+=	'	<p style="text-align: left;">Temos um novo pedido para sua análise.</p> '
		xcMens	+=	'	<p style="text-align: left;">Segue abaixo o pedido liberado por Crédito.</p> '
		If !Empty(xcObs)
			xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
		EndIf
		xcMens	+=	'	<table border="1" width="100%"> '
		xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
		xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
		xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
		xcMens	+=	'	<p>&nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
		xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
		xcMens	+=	'<p style="text-align: left"> '
		xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
		xcMens	+=	'</body></html> '
		
		PswOrder(2)
		PswSeek(XTIT->CODUSER,.t.)
		xcMail2   :=  PswRet(1)[1][14]
		
		PswOrder(1)
		PswSeek(__cUserID,.t.)
		
		//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],Iif(!Empty(xcMail2),xcMail+';'+xcMail2,xcMail),xcCco,xcMens,xcPath)
		
		NGSendMail(PswRet(1)[1][04], Iif(!Empty(xcMail2),xcMail+';'+xcMail2,xcMail), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
		
		RecLock('XTIT', .F.)
		XTIT->LIBCR		:=	dDataBase
		XTIT->OK		:=	""
		
		XTIT->(MsUnLock())
		
	EndIf
	
	XTIT->(dbSkip())
Enddo
XTIT->(dbGoTop())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfRetPed ºAutor  ³Claudio Alves       º Data ³  04/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfRetPed(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xcObs		:=	cObserv
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xcMens	:=	''
Local xcAsst	:=	'Retorno de Pedido para Digitação'
Local xcMail	:=	GetMv('MB_MAILRET')
Local xcMail2	:=	''
Local xcCco		:=	''
Local xcPath	:=	''


dbSelectArea("XTIT")
XTIT->(dbGoTop())


If !(__cUserID $ GetMv('MB_RETPEDI'))
	Alert('Usuário sem Acesso', 'ALERTA MB')
	Return
else
	alert('este procedimento deve ser feito pelo portal')
//	Return
EndIf

If Empty(AllTrim(xcObs))
	Alert('JUSTIFICATIVA OBRIGATÓRIA', 'ALERTA MB')
	Return
else
	alert('este procedimento deve ser feito pelo portal')
//	Return
EndIf


While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif

	xcQuery := xcR + 	"UPDATE SB2010 "
	xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
	xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
	xcQuery += xcR + 	"	FROM SC9010 SC9 "
	xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
	xcQuery += xcR + 	"	AND C9_BLEST='' "
	xcQuery += xcR + 	"	AND C9_BLCRED='' "
	xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
	xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
	xcQuery += xcR + 	"	) T "
	xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
	TCSQLEXEC(xcQuery)

	xcQuery := xcR + 	"UPDATE "
	xcQuery += xcR + 	"	" + RetSqlName("SC5") + " "
	xcQuery += xcR + 	"SET "
	If !Empty(dToc(XTIT->DATRET))
		xcQuery += xcR + 	"	C5_ZVALPED  = " + Alltrim(Transform(XTIT->TOTAL,"99999999.9999")) + ", "
	EndIf
	xcQuery += xcR + 	"	C5_ZDTRETO  = '" + Dtos(dDataBase) + "' "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	C5_NUM = '"  + XTIT->PEDIDO  + "' "
	xcQuery += xcR + 	" "
	xcQuery += xcR + 	"UPDATE "
	xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
	xcQuery += xcR + 	"SET "
	xcQuery += xcR + 	"	C9_BLCRED  = '02', "
	xcQuery += xcR + 	"	C9_BLEST  = '02' "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
	
	TCSQLEXEC(xcQuery)
	
	xcMens	:=	'<html><head> '
	xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
	xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
	xcMens	+=	'<title>Observação</title> '
	xcMens	+=	'</head><body>
	xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
	xcMens	+=	'	<p style="text-align: left;">Temos um novo pedido para sua análise.</p> '
	xcMens	+=	'	<p style="text-align: left;">Segue abaixo com retorno para Digitação.</p> '
	If !Empty(xcObs)
		xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
	EndIf
	xcMens	+=	'	<table border="1" width="100%"> '
	xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
	xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
	xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
	xcMens	+=	'	<p>&nbsp;</p> '
	xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
	xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
	xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
	xcMens	+=	'<p style="text-align: left"> '
	xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
	xcMens	+=	'</body></html> '
	
	
	PswOrder(2)
	PswSeek(XTIT->CODUSER,.t.)
	xcMail2   :=  	PswRet(1)[1][14]
	
	PswOrder(1)
	PswSeek(__cUserID,.t.)
	
	//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],Iif(!Empty(xcMail2),xcMail+';'+xcMail2,xcMail),xcCco,xcMens,xcPath)
	
	NGSendMail(PswRet(1)[1][04], Iif(!Empty(xcMail2),xcMail+';'+xcMail2,xcMail), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
	
	RecLock('XTIT', .F.)
	XTIT->LIBREG	:=	cTod('  /  /    ')
	XTIT->DATRET	:=	dDataBase
	XTIT->OK		:=	""
	XTIT->(MsUnLock())
	
	
	XTIT->(dbSkip())
Enddo
XTIT->(dbGoTop())
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfExcPed ºAutor  ³Claudio Alves       º Data ³  04/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xsfExcPed(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xcObs		:=	cObserv
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xcMens	:=	''
Local xcAsst	:=	'Pedido Reprovado'
Local xcMail	:=	GetMv('MB_MAILEXC')
Local xcMail2	:=	''
Local xcCco		:=	''
Local xcPath	:=	''
Local xcCod		:=	'A'

dbSelectArea("XTIT")
XTIT->(dbGoTop())


If xcCod == 'A' 
	Alert('Rotina Fora de Uso', 'ALERTA MB')
	Return
EndIf

If !(__cUserID $ GetMv('MB_EXCLPED'))
	Alert('Usuário sem Acesso', 'ALERTA MB')
	Return
EndIf

If Empty(AllTrim(xcObs))
	Alert('JUSTIFICATIVA OBRIGATÓRIA', 'ALERTA MB')
	Return
EndIf


While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif                            
	xcQuery := xcR + 	"UPDATE SB2010 "
	xcQuery += xcR + 	"SET B2_RESERVA=B2_RESERVA-QUANT "
	xcQuery += xcR + 	"FROM (SELECT C9_PRODUTO,C9_LOCAL,SUM(C9_QTDLIB) QUANT "
	xcQuery += xcR + 	"	FROM SC9010 SC9 "
	xcQuery += xcR + 	"	WHERE SC9.D_E_L_E_T_<>'*'  "
	xcQuery += xcR + 	"	AND C9_BLEST='' "
	xcQuery += xcR + 	"	AND C9_BLCRED='' "
	xcQuery += xcR + 	"	AND C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
	xcQuery += xcR + 	"	GROUP BY C9_PRODUTO,C9_LOCAL "
	xcQuery += xcR + 	"	) T "
	xcQuery += xcR + 	"WHERE C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL "
	TCSQLEXEC(xcQuery)
	
	xcQuery := xcR + 	"UPDATE "
	xcQuery += xcR + 	"	" + RetSqlName("SC5") + " "
	xcQuery += xcR + 	"SET "
	xcQuery += xcR + 	"	C5_ZEXCPED  = '" + dTos(dDataBase) + "', "
	xcQuery += xcR + 	"	C5_ZEXCOBS  = '" + cObserv + "' "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	C5_NUM = '"  + XTIT->PEDIDO  + "' "
	xcQuery += xcR + 	" "
	xcQuery += xcR + 	"UPDATE "
	xcQuery += xcR + 	"	" + RetSqlName("SC9") + " "
	xcQuery += xcR + 	"SET "
	xcQuery += xcR + 	"	C9_BLCRED  = '02', "
	xcQuery += xcR + 	"	C9_BLEST  = '02' "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	C9_PEDIDO = '"  + XTIT->PEDIDO  + "' "
	
	TCSQLEXEC(xcQuery)
	
	xcMens	:=	'<html><head> '
	xcMens	+=	'<meta http-equiv="Content-Language" content="pt-br"> '
	xcMens	+=	'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> '
	xcMens	+=	'<title>Observação</title> '
	xcMens	+=	'</head><body>
	xcMens	+=	'<div style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-align: center;"> '
	xcMens	+=	'	<p style="text-align: left;">Este pedido foi reprovado por ' + cUserName + '.</p> '
	If !Empty(xcObs)
		xcMens	+=	'	<p style="text-align: left;"><b>OBSERVAÇÃO:' + cObserv + '</b> .</p>
	EndIf
	xcMens	+=	'	<table border="1" width="100%"> '
	xcMens	+=	'		<tr><td>Pedido</td>	<td>Cliente</td><td>Nome</td><td>Valor do Pedido</td><td>Valor de Pedidos em Aberto</td><td>Valor em Atraso</td><td>Duplicatas em Aberto</td><td>Vendedor</td></tr> '
	xcMens	+=	'		<tr><td>'+XTIT->PEDIDO+'</td><td>'+XTIT->CLIENTE+'</td><td>'+XTIT->NOME+'</td><td>'+Transform(XTIT->TOTAL,"999,999,999.99")+'</td><td>'+Transform(XTIT->TOTPED,"999,999,999.99")+'</td><td>'+Transform(XTIT->ATRASO,"999,999,999.99")+'</td><td>'+Transform(XTIT->DUPLIC,"999,999,999.99")+'</td><td>'+XTIT->CODVEND+'</td></tr></table> '
	xcMens	+=	'	<p style="text-align: left;">&nbsp;</p> '
	xcMens	+=	'	<p>&nbsp;</p> '
	xcMens	+=	'	<p style="text-align: left;">Atenciosamente, &nbsp;</p> '
	xcMens	+=	'	<p style="text-align: left;">Departamento Comercial &nbsp;</p> '
	xcMens	+=	'	<p style="text-align: left;">Administrador</div> '
	xcMens	+=	'<p style="text-align: left"> '
	xcMens	+=	'<img border="0" src="http://plasticosmb.com.br/2009/img/mb.gif"></p> '
	xcMens	+=	'</body></html> '
	
	
	PswOrder(2)
	PswSeek(XTIT->CODUSER,.t.)
	xcMail2   :=  PswRet(1)[1][14]
	
	PswOrder(1)
	PswSeek(__cUserID,.t.)
	
	//U_MBEnvMail(xcAsst + ' - ' + PswRet(1)[1][04],Iif(!Empty(xcMail2),xcMail+';'+xcMail2,xcMail),xcCco,xcMens,xcPath)
	
	NGSendMail(PswRet(1)[1][04], Iif(!Empty(xcMail2),xcMail+';'+xcMail2,xcMail), xcCco, , xcAsst, , xcMens,,PswRet(1)[1][14],,,,)
	
	RecLock('XTIT', .F.)
	XTIT->OK		:=	""
	XTIT->(MsUnLock())
	
	XTIT->(dbSkip())
Enddo
XTIT->(dbGoTop())
Return
