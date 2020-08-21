#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

//Esta Rotina é chamada pelo Ponto de Entrada FC010BTN na Tela da Posição dos Clientes

User Function MBCobranc()

Local oDlg, oObserv, oMarkF
Local aSize     	:= 	FWGetDialogSize( oMainWnd )
Local cCabecalho	:= 	"Selecionar Selecionar Títulos em Aberto"
Local lOK       	:= 	.F.
Local cObserv   	:= 	Space(255)
Local lInvert   	:= 	.F.
Local cMarca    	:= 	""
Local aCampos  		:= 	{{"OK","",""},{"PREF","","Prefixo"},{"TIT","","Título"},{"PARC","","Parcela"},{"TIPO","","Tipo"},{"VEND","","Vendedor"},{"VENCTO","","Vencimento"},{"EMIS","","Emissao"},{"VALOR","","Valor"},{"SALDO","","Saldo"},{"VLCHQ","","Vl Cheque"},{"VLCBX","","Vl Baixa"}}
Local cArqOP
Private xaAlias 	:= { {Alias()},{"SE1"},{"SA1"},{"ACF"},{"ACG"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)
Private xcCliente	:=	SA1->A1_COD
Private xcLoja   	:=	SA1->A1_LOJA
Private xcNome   	:=	SA1->A1_NOME
Private xcFone   	:=	SA1->A1_DDD + '-' + SA1->A1_TEL
Private cRec:= {'1=Pago','2=Negociado','3=Cartorio','4=Baixa','5=Abatimento'}

//U_ufAmbiente(xaAlias, "S")




//Marck Browse Linha.
aStrut := {}

Aadd( aStrut , { "OK"     , "C" , 02 , 0 } )
Aadd( aStrut , { "PREF"   , "C" , 03 , 0 } )
Aadd( aStrut , { "TIT"    , "C" , 09 , 0 } )
Aadd( aStrut , { "PARC"   , "C" , 02 , 0 } )
Aadd( aStrut , { "TIPO"   , "C" , 03 , 0 } )
Aadd( aStrut , { "VEND"   , "C" , 03 , 0 } )
Aadd( aStrut , { "VENCTO" , "D" , 08 , 0 } )
Aadd( aStrut , { "VENC01" , "D" , 08 , 0 } )
Aadd( aStrut , { "EMIS"   , "D" , 08 , 0 } )
Aadd( aStrut , { "VALOR"  , "N" , 14 , 2 } )
Aadd( aStrut , { "ACRESC" , "N" , 14 , 2 } )
Aadd( aStrut , { "DECRESC", "N" , 14 , 2 } )
Aadd( aStrut , { "SALDO"  , "N" , 14 , 2 } )
Aadd( aStrut , { "VLCHQ"  , "N" , 14 , 2 } )
Aadd( aStrut , { "VLCBX"  , "N" , 14 , 2 } )

cArqOP := CriaTrab(aStrut)

if select("XTIT") > 0
	XTIT->(dbclosearea())
endif

dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco

Processa( { || xsfTitDeb() })


DbSelectArea( "XTIT" )
XTIT->( DbGoTop() )

cMarca := XTIT->(GetMark())

// ******************** Interface com usuario
Define MsDialog oDlg Title cCabecalho From aSize[1], aSize[2] To aSize[3], aSize[4] Pixel

@ (oDlg:nHeight/2)-88, 005 SAY oSay1 PROMPT "Observações"            SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ (oDlg:nHeight/2)-80, 005 GET oObserv VAR cObserv OF oDlg MULTILINE SIZE (oDlg:nWidth/2)-11,50 COLORS 0, 16777215 HSCROLL PIXEL

@ (oDlg:nHeight/2)-108, 005 SAY oSay2 PROMPT "Cliente"            SIZE 20, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ (oDlg:nHeight/2)-100, 005 GET oCli VAR xcNome OF oDlg MULTILINE SIZE (oDlg:nWidth/2)-435,12 COLORS 0, 16777215 HSCROLL PIXEL
@ (oDlg:nHeight/2)-108, 200 SAY oSay3 PROMPT 'Fone'            	 SIZE 20, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ (oDlg:nHeight/2)-100, 200 GET oFone VAR xcFone OF oDlg MULTILINE SIZE (oDlg:nWidth/2)-530,12 COLORS 0, 16777215 HSCROLL PIXEL

//TSay():Create(oDlg,{|| "Recopa ?" },015,001,,,,,,.T.,,,050,020,,,,,,)
		
//TComboBox():Create(oDlg,{|u| if( Pcount( )>0, cRec := u, cRec)}, 015,035,aRec,050,010,,,,,,.T.,,,,,,,,,"cRec",,,,)


oMarkF := MsSelect():New( "XTIT","OK",,aCampos,@lInvert,@cMarca , { 34, 05, (oDlg:nHeight/2)-120, (oDlg:nWidth/2)-05} )
oMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock(),XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }
oMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock()) })), XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }

/*
DEFINE SBUTTON FROM 110, 135 TYPE 1  ACTION ( IIf(fVldQtdPrd(nQtdPrd), Processa({|| fProcPRD(aPedido,nQtdPrd,'1')}),MsgBox("Corrigir Informações!!!")) , oDlg:END()) ENABLE OF oDlg
DEFINE SBUTTON FROM 110, 165 TYPE 2  ACTION ( oDlg:END() ) ENABLE OF oDlg
*/
Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,{|| lOK := .T., oDlg:End() },{|| lOK := .F., oDlg:End()},.F.) Centered


If lOK == .T.
	Processa( { || xsfPrcCob(cMarca, cObserv) })
EndIf


//U_ufAmbiente(xaAlias, "R")
Return()

Static Function xsfPrcCob(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xlOpc		:=	.T.
Local xcObs		:=	cObserv
Local xnTam   	:= 	TamSX3("ACF_OBSCAN")
Local xnTam1 	:= 	xnTam[1]
Local xcTxt		:=	''
Local xcCodAcf	:=	''

xcTxt := NoAcento(AnsiToOem(AllTrim(xcObs)))



//ACF e ACG
//Status 1=Pago;2=Negociado;3=Cartorio;4=Baixa;5=Abatimento

/*
// Realiza a alteração do campo MEMO usando SYP
_cTeste := NoAcento(AnsiToOem(AllTrim(cObsCte)))
_nTam   := TamSX3("DTC_OBS")
_nTam1 := _nTam[1]
MSMM(,_nTam1,,_cTeste,1,,,"DTC","DTC_CODOBS")
*/
dbSelectArea("XTIT")
dbGoTop()

While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	xcCodAcf	:=	GetSxeNum("ACF","ACF_CODIGO")

	RecLock("ACF", .T.)
	ACF_FILIAL	:= xFilial("ACF")
	ACF_CODIGO	:=	xcCodAcf
	ACF_CLIENT	:=	SA1->A1_COD
	ACF_LOJA	:=	SA1->A1_LOJA
	ACF_OPERAD	:=	PswRet()[1][1]
	ACF_DESCOP	:=	PswRet()[1][4]
	ACF_STATUS	:=	"2" //xcPosic
	ACF_DATA	:=	dDataBase
	ACF_CODOBS	:=	MSMM(,xnTam1,,xcTxt,1,,,"ACF","ACF_CODOBS")
	MsUnlock("ACF")
	
	RecLock("ACG", .T.)
	ACG_FILIAL	:=	xFilial("ACG")
	ACG_CODIGO	:=	xcCodAcf
	ACG_PREFIX	:=	XTIT->PREF
	ACG_TITULO	:=	XTIT->TIT
	ACG_PARCEL	:=	XTIT->PARC
	ACG_TIPO	:=	XTIT->TIPO
	ACG_STATUS	:=	"2" //xcPosic
	ACG_DTVENC	:=	XTIT->VENC01
	ACG_DTREAL	:=	XTIT->VENCTO
	ACG_ACRESC	:=	XTIT->ACRESC
	ACG_DECRES	:=	XTIT->DECRESC
	ACG_VALOR	:=	XTIT->VALOR
	MsUnlock("ACG")
	
	ConfirmSX8()

	XTIT->(dbSkip())
Enddo

Return xlOpc



Static function xsfTitDeb(cCli, cloj)

xcQuery := 			"SELECT "
xcQuery += xcR + 	"	* "
xcQuery += xcR + 	"FROM "
xcQuery += xcR + 	"( "
xcQuery += xcR + 	"SELECT  "
xcQuery += xcR + 	"	E1_PREFIXO 'PREF', E1_NUM 'TIT', E1_PARCELA 'PARC', E1_TIPO 'TIPO',  "
xcQuery += xcR + 	"	E1_VEND1 'VEND', E1_VENCTO 'VENC01', E1_VENCREA 'VENCTO', "
xcQuery += xcR + 	"	E1_EMISSAO 'EMIS', E1_VALOR 'VALOR',  "
xcQuery += xcR + 	"	E1_ACRESC 'ACRESC', E1_DECRESC 'DECRESC', "
xcQuery += xcR + 	"	E1_VALOR - E1_DECRESC - CASE WHEN "
xcQuery += xcR + 	"	E5_VALOR IS NULL THEN 0 ELSE E5_VALOR END 'SALDO', "
xcQuery += xcR + 	"	CASE WHEN EF_VALORBX IS NULL THEN 0 ELSE EF_VALORBX END 'VLCHQ', "
xcQuery += xcR + 	"	E1_VALOR - E1_SDDECRE - CASE WHEN "
xcQuery += xcR + 	"	E5_VALOR IS NULL THEN 0 ELSE E5_VALOR END 'VLCBX' "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SE1') + " A LEFT JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIENTE, E5_LOJA, ROUND(SUM(E5_VALOR), 2) E5_VALOR "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"		SELECT  "
xcQuery += xcR + 	"			E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIENTE, E5_LOJA, E5_TIPODOC, E5_DOCUMEN, "
xcQuery += xcR + 	"			CASE WHEN	 "
xcQuery += xcR + 	"				LEFT(E5_DOCUMEN,2) NOT IN ('RA') "
xcQuery += xcR + 	"			THEN  "
xcQuery += xcR + 	"				CASE WHEN  "
xcQuery += xcR + 	"					( "
xcQuery += xcR + 	"					SELECT  "
xcQuery += xcR + 	"						COUNT(*)  "
xcQuery += xcR + 	"					FROM  "
xcQuery += xcR + 	"						" + RetSqlName('SE5') + " X   "
xcQuery += xcR + 	"					WHERE  "
xcQuery += xcR + 	"						E5_TIPODOC = 'CH' AND  "
xcQuery += xcR + 	"						X.E5_NUMERO = F.E5_NUMERO AND  "
xcQuery += xcR + 	"						X.E5_PREFIXO=F.E5_PREFIXO AND  "
xcQuery += xcR + 	"						X.E5_PARCELA=F.E5_PARCELA AND  "
xcQuery += xcR + 	"						X.E5_TIPO=F.E5_TIPO AND  "
xcQuery += xcR + 	"						X.E5_CLIENTE=F.E5_CLIENTE AND  "
xcQuery += xcR + 	"						X.E5_LOJA=F.E5_LOJA ) > 0  "
xcQuery += xcR + 	"				THEN "
xcQuery += xcR + 	"					CASE WHEN "
xcQuery += xcR + 	"					( "
xcQuery += xcR + 	"					SELECT  "
xcQuery += xcR + 	"						COUNT(*)  "
xcQuery += xcR + 	"					FROM  "
xcQuery += xcR + 	"						" + RetSqlName('SE5') + " X   "
xcQuery += xcR + 	"					WHERE  "
xcQuery += xcR + 	"						E5_TIPODOC = 'ES' AND  "
xcQuery += xcR + 	"						X.E5_NUMERO = F.E5_NUMERO AND  "
xcQuery += xcR + 	"						X.E5_PREFIXO=F.E5_PREFIXO AND  "
xcQuery += xcR + 	"						X.E5_PARCELA=F.E5_PARCELA AND  "
xcQuery += xcR + 	"						X.E5_TIPO=F.E5_TIPO AND  "
xcQuery += xcR + 	"						X.E5_CLIENTE=F.E5_CLIENTE AND  "
xcQuery += xcR + 	"						X.E5_LOJA=F.E5_LOJA ) > 0  "
xcQuery += xcR + 	"					THEN "
xcQuery += xcR + 	"						CASE  "
xcQuery += xcR + 	"							WHEN E5_TIPODOC IN ('BA', 'JR', 'MT', 'DC') THEN 0  "
xcQuery += xcR + 	"							WHEN E5_TIPODOC = 'ES' THEN -ROUND(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO), 2) "
xcQuery += xcR + 	"						ELSE  "
xcQuery += xcR + 	"							ROUND(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO) , 2)  "
xcQuery += xcR + 	"						END "
xcQuery += xcR + 	"					ELSE "
xcQuery += xcR + 	"						CASE  "
xcQuery += xcR + 	"						WHEN E5_TIPODOC IN ('BA') THEN 0  "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'ES' THEN -ROUND(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO), 2) "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'JR' THEN -ROUND(SUM(E5_VALOR), 2) "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'MT' THEN -ROUND(SUM(E5_VALOR), 2) "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'DC' THEN  ROUND(SUM(E5_VALOR), 2) "
xcQuery += xcR + 	"						ELSE  "
xcQuery += xcR + 	"							ROUND(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO) , 2)  "
xcQuery += xcR + 	"						END "
xcQuery += xcR + 	"					END "
xcQuery += xcR + 	"				ELSE "
xcQuery += xcR + 	"					CASE WHEN  "
xcQuery += xcR + 	"						E5_TIPODOC = 'CP'  "
xcQuery += xcR + 	"					THEN  "
xcQuery += xcR + 	"						ROUND(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO), 2)  "
xcQuery += xcR + 	"					ELSE "
xcQuery += xcR + 	"						CASE  "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'ES' THEN -ROUND(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO), 2) "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'JR' THEN -ROUND(SUM(E5_VALOR), 2) "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'MT' THEN -ROUND(SUM(E5_VALOR), 2) "
xcQuery += xcR + 	"						WHEN E5_TIPODOC = 'DC' THEN  ROUND(SUM(E5_VALOR), 2) "
xcQuery += xcR + 	"						ELSE "
xcQuery += xcR + 	"							ROUND(SUM(E5_VALOR) , 2) "
xcQuery += xcR + 	"						END  "
xcQuery += xcR + 	"					END "
xcQuery += xcR + 	"				END "
xcQuery += xcR + 	"			ELSE "
xcQuery += xcR + 	"				CASE "
xcQuery += xcR + 	"					WHEN E5_TIPODOC = 'ES'	THEN -SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO)  "
xcQuery += xcR + 	"					WHEN E5_TIPODOC = 'CP'	THEN  SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO)  "
xcQuery += xcR + 	"				ELSE "
xcQuery += xcR + 	"					SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO) "
xcQuery += xcR + 	"				END	 "
xcQuery += xcR + 	"			END E5_VALOR "
xcQuery += xcR + 	"		FROM "
xcQuery += xcR + 	"			" + RetSqlName('SE5') + " F "
xcQuery += xcR + 	"		WHERE "
xcQuery += xcR + 	"			E5_FILIAL = '01' AND "
xcQuery += xcR + 	"			F.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"			E5_TIPODOC IN ('VL', 'BA', 'CP', 'JR', 'MT', 'DC', 'ES', 'CH') "
xcQuery += xcR + 	"		GROUP BY "
xcQuery += xcR + 	"			E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIENTE, E5_LOJA, E5_TIPODOC, E5_DOCUMEN "
xcQuery += xcR + 	"	) A "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIENTE, E5_LOJA "
xcQuery += xcR + 	") E ON "
xcQuery += xcR + 	"	E1_PREFIXO = E5_PREFIXO AND "
xcQuery += xcR + 	"	E1_NUM = E5_NUMERO AND "
xcQuery += xcR + 	"	E1_PARCELA = E5_PARCELA AND "
xcQuery += xcR + 	"	E1_TIPO = E5_TIPO AND "
xcQuery += xcR + 	"	E1_CLIENTE = E5_CLIENTE AND "
xcQuery += xcR + 	"	E1_LOJA = E5_LOJA LEFT JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		EF_PREFIXO, EF_TITULO, EF_PARCELA, EF_TIPO, EF_CLIENTE, EF_LOJACLI,  "
xcQuery += xcR + 	"		SUM(EF_VALORBX) EF_VALORBX "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName('SEF') + " X "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		EF_FILIAL = '01' AND "
xcQuery += xcR + 	"		EF_ALINEA2 = '' AND "
xcQuery += xcR + 	"		X.D_E_L_E_T_ = '' "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		EF_PREFIXO, EF_TITULO, EF_PARCELA, EF_TIPO, EF_CLIENTE, EF_LOJACLI) G ON "
xcQuery += xcR + 	"	E1_PREFIXO = EF_PREFIXO AND "
xcQuery += xcR + 	"	E1_NUM = EF_TITULO AND "
xcQuery += xcR + 	"	E1_PARCELA = EF_PARCELA AND "
xcQuery += xcR + 	"	E1_TIPO = EF_TIPO AND "
xcQuery += xcR + 	"	E1_CLIENTE = EF_CLIENTE AND "
xcQuery += xcR + 	"	E1_LOJA = EF_LOJACLI "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	E1_FILIAL = '" + xFilial('SE1') + "' AND "
xcQuery += xcR + 	"	E1_SALDO > 0 AND "
xcQuery += xcR + 	"	E1_CLIENTE = '" + xcCliente + "' AND "
xcQuery += xcR + 	"	E1_LOJA = '" + xcLoja + "' AND "
xcQuery += xcR + 	"	E1_TIPO NOT IN('NCC', 'RA') "
xcQuery += xcR + 	") SL "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	VLCBX > 0 "

//Gera um arquivo com a query acima.
MemoWrite("xufPesqTit - Busca OP.SQL",xcQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

TcSetField("XTT","QUANT","N",12,4)


XTT->(dbGoTop())
While !(XTT->(EOF()))
	
	
	dbSelectArea("XTIT")
	RecLock("XTIT",.T.)
	XTIT->PREF   := XTT->PREF
	XTIT->TIT    := XTT->TIT
	XTIT->PARC   := XTT->PARC
	XTIT->TIPO   := XTT->TIPO
	XTIT->VEND   := XTT->VEND
	XTIT->VENC01 := STOD(XTT->VENC01)
	XTIT->VENCTO := STOD(XTT->VENCTO)
	XTIT->EMIS   := STOD(XTT->EMIS)
	XTIT->VALOR  := XTT->VALOR
	XTIT->ACRESC := XTT->ACRESC
	XTIT->DECRESC:= XTT->DECRESC
	XTIT->SALDO  := XTT->SALDO
	XTIT->VLCHQ  := XTT->VLCHQ
	XTIT->VLCBX  := XTT->VLCBX
	
	dbSelectArea("XTT")
	XTT->(dbSkip())
Enddo

XTT->(dbCloseArea())
XTIT->(dbGoTop())

Return
