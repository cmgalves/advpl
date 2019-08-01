#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MBPesqTit ºAutor  ³Cláudio Alves       º Data ³ 12/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adiciona itens no Acols dos Tútulos a receber              º±±
±±º          ³ Em aberto do cliente / loja específicos                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MBPesqTit(cCliente, cLoja, nValor)
Private xcCliente	:=	cCliente
Private xcLoja   	:=	cLoja
Private xnValor   	:=	nValor
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)
Private xaAlias 	:= { {Alias()},{"SF1"}}
Private xlRet		:=	.F.

U_ufAmbiente(xaAlias, "S")


U_MBTelaTit()

U_ufAmbiente(xaAlias, "R")

Return xcCliente



USER FUNCTION MBTelaTit()
Local aStrut    :=	{}
Local aTam      :=	{}
Local lInverte  :=	.F.
Local cMarca    :=	GetMark()
Local cArqOP
Local aBrwOP  	:= {{"OK","",""},{"PREF","","Prefixo"},{"TIT","","Título"},{"PARC","","Parcela"},{"TIPO","","Tipo"},{"VEND","","Vendedor"},{"VENCTO","","Vencimento"},{"EMIS","","Emissao"},{"VALOR","","Valor"},{"SALDO","","Saldo"},{"VLCHQ","","Vl Cheque"},{"VLCBX","","Vl Baixa"}}

//Marck Browse Linha.
aStrut := {}

Aadd( aStrut , { "OK"     , "C" , 02 , 0 } )
Aadd( aStrut , { "PREF"   , "C" , 03 , 0 } )
Aadd( aStrut , { "TIT"    , "C" , 09 , 0 } )
Aadd( aStrut , { "PARC"   , "C" , 02 , 0 } )
Aadd( aStrut , { "TIPO"   , "C" , 03 , 0 } )
Aadd( aStrut , { "VEND"   , "C" , 03 , 0 } )
Aadd( aStrut , { "VENCTO" , "D" , 08 , 0 } )
Aadd( aStrut , { "EMIS"   , "D" , 08 , 0 } )
Aadd( aStrut , { "VALOR"  , "N" , 14 , 2 } )
Aadd( aStrut , { "SALDO"  , "N" , 14 , 2 } )
Aadd( aStrut , { "VLCHQ"  , "N" , 14 , 2 } )
Aadd( aStrut , { "VLCBX"  , "N" , 14 , 2 } )

if select("XTIT") > 0
	XTIT->(dbclosearea())
endif

cArqOP := CriaTrab(aStrut)
dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)


Processa( { || xsfVisTit(xcCliente, xcLoja) })

If !xlRet
	Alert('SEM TÍTULOS','PLASTICOS MB')
	Return()
EndIf

DEFINE MSDIALOG oTela TITLE "Selecionar Selecionar Títulos em Aberto" FROM 97,05 TO 550,1100 OF oMainWnd Pixel

oMarkOP := MsSelect():New("XTIT","OK",,aBrwOP,lInverte,cMarca,{15,4,180,480})

oMarkOP:oBrowse:lCanAllMark :=.T.
oMarkOP:oBrowse:lHasMark	:=.T.

oMarkOP:bMark          	 	:= {|| (xsfMKOP(cMarca,lInverte),oMarkOP:oBrowse:Refresh()) }
oMarkOP:oBrowse:bAllMark	:= {|| (xsfMKOPALL(cMarca,lInverte),oMarkOP:oBrowse:Refresh()) }



ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar(oTela, {|| Processa({||xsfInclui(cMarca),oTela:End()})} ,{||oTela:End()} ) CENTERED




dbSelectArea("XTIT")
dbCloseArea("XTIT")
Ferase(cArqOP+GetDBExtension())
FErase(cArqOP+OrdBagExt())

Return



Static Function xsfInclui(cMarca)
Local xcMarca	:=	cMarca
Local xlOpc		:=	.T.
Local xnTotChq	:=	0
Local xnSldChq	:=	0
Local xnTotBxa	:=	0
Local xnVlrChq	:=	0

xcQuery := 			"	SELECT  "
xcQuery += xcR + 	"		EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM, EF_CLIENTE, EF_LOJACLI,  "
xcQuery += xcR + 	"		EF_VALORBX, EF_VALOR "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName('SEF') + " X "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		EF_BANCO = '" +M->EF_BANCO + "' AND "
xcQuery += xcR + 	"		EF_AGENCIA = '" +M->EF_AGENCIA + "' AND "
xcQuery += xcR + 	"		EF_CONTA = '" +M->EF_CONTA + "' AND "
xcQuery += xcR + 	"		EF_NUM= '" +M->EF_NUM + "' AND "
xcQuery += xcR + 	"		EF_FILIAL  = '01' AND "
xcQuery += xcR + 	"		X.D_E_L_E_T_ = '' "

if select("XCHQ") > 0
	XCHQ->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XCHQ

dbSelectArea("XCHQ")
XCHQ->(dbGoTop())

xnTotChq	:=	IIF(XCHQ->EF_VALOR == 0, M->EF_VALOR, XCHQ->EF_VALOR)


While !(XCHQ->(EOF()))
	If xnTotChq	!= XCHQ->EF_VALOR
		Alert("Valor Do Cheque Errado" + xcR + Transform(xnTotChq, "@E@Z 999999999.9999") + xcR + Transform(XCHQ->EF_VALOR, "@E@Z 999999999.9999"))
		Exit
	EndIf
	xnTotBxa	+=	XCHQ->EF_VALORBX
	dbSelectArea("XCHQ")
	XCHQ->(dbSkip())
Enddo

xnSldChq	:=	xnTotChq - xnTotBxa




While !(XTIT->(EOF()))
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	If xnSldChq >= XTIT->VLCBX
		xnVlrChq := XTIT->VLCBX
	Else
		xnVlrChq := xnSldChq
	EndIf
	M->EF_VALORBX	:= xnVlrChq
	M->EF_PREFIXO	:= XTIT->PREF
	M->EF_TITULO	:= XTIT->TIT
	M->EF_PARCELA	:= XTIT->PARC
	M->EF_TIPO		:= XTIT->TIPO
	Exit
	XTIT->(dbSkip())
Enddo

Return xlOpc



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xsfMKOP ºAutor  ³Claudio Alves       º Data ³  12/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca OP para geração                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xufPesqOP                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xsfMKOP(cMarca,lInverte)
Local xcMarca	:=	cMarca
Local xlInvert	:=	lInverte

If IsMark("OK",xcMarca,xlInvert)
	RecLock("XTIT",.F.)
	If !xlInvert
		XTIT->OK := xcMarca
	Else
		XTIT->OK := "  "
	Endif
	MsUnlock()
Else
	RecLock("XTIT",.F.)
	If !xlInvert
		XTIT->OK := "  "
	Else
		XTIT->OK := xcMarca
	Endif
	MsUnlock()
Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xsfMKOPALLºAutor  ³Claudio Alves       º Data ³ 12/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inverte marcação do Markbrowse da op   .                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xufPesqOP                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xsfMKOPALL(cMarca,lInverte)
Local xcMarca	:=	cMarca
Local xlInvert	:=	lInverte
Local nRec 		:= XTIT->(Recno())
Local xaConteu	:=	{}
dbSelectArea("XTIT")
dbGoTop()
While !(XTIT->(EOF()))
	RecLock("XTIT",.F.)
	If Empty(XTIT->OK)
		XTIT->OK := xcMarca
	Else
		XTIT->OK := "  "
	Endif
	MsUnLock()
	
	XTIT->(dbSkip())
Enddo

XTIT->(dbGoTo(nRec))
Return .T.


Static Function xsfVisTit()

xcQuery := 			"SELECT "
xcQuery += xcR + 	"	* "
xcQuery += xcR + 	"FROM "
xcQuery += xcR + 	"( "
xcQuery += xcR + 	"SELECT  "
xcQuery += xcR + 	"	E1_PREFIXO 'PREF', E1_NUM 'TIT', E1_PARCELA 'PARC', E1_TIPO 'TIPO',  "
xcQuery += xcR + 	"	E1_VEND1 'VEND', E1_VENCREA 'VENCTO', E1_EMISSAO 'EMIS', E1_VALOR 'VALOR',  "
xcQuery += xcR + 	"	E1_VALOR + E1_ACRESC - E1_DECRESC - CASE WHEN E5_VALOR IS NULL THEN 0 ELSE E5_VALOR END 'SALDO', "
xcQuery += xcR + 	"	CASE WHEN EF_VALORBX IS NULL THEN 0 ELSE EF_VALORBX END 'VLCHQ', "
xcQuery += xcR + 	"	E1_VALOR + E1_SDACRES - E1_SDDECRE - CASE WHEN E5_VALOR IS NULL THEN 0 ELSE E5_VALOR END - "
xcQuery += xcR + 	"	CASE WHEN EF_VALORBX IS NULL THEN 0 ELSE EF_VALORBX END 'VLCBX' "
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
xcQuery += xcR + 	"		EF_DTCOMP = '' AND "
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
xcQuery += xcR + 	"	ROUND(VLCBX,1) > 0 "

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
	XTIT->VENCTO := STOD(XTT->VENCTO)
	XTIT->EMIS   := STOD(XTT->EMIS)
	XTIT->VALOR  := XTT->VALOR
	XTIT->SALDO  := XTT->SALDO
	XTIT->VLCHQ  := XTT->VLCHQ
	XTIT->VLCBX  := XTT->VLCBX
	
	If !Empty(AllTrim(XTIT->PREF)) .AND. !xlRet
		xlRet	:=	.T.	
	EndIf
		
	dbSelectArea("XTT")
	XTT->(dbSkip())
Enddo


XTT->(dbCloseArea())
XTIT->(dbGoTop())



Return
