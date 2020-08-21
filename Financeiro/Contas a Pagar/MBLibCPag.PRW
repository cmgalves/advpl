#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

//Tradução PTG 20080721
//Tradução PTG 20080721



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FiNA580  ³ Autor ³ Claudio Alves         ³ Data ³ 15/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Liberacao dos  Titulos a Pagar                     		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FiNA580()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MBLibPag()
Local oDlg, oObserv, oMarkF
Local aSize     	:= 	FWGetDialogSize( oMainWnd )
Local cCabecalho	:= 	"SELECIONAR TÍTULOS A PAGAR PARA LIBERAR O PAGAMENTO"
Local lOK       	:= 	.F.
Local cObserv   	:= 	Space(255)
Local lInvert   	:= 	.F.
Local cMarca    	:= 	""
Local aCampos 	:= {{"OK","",""},{"E2_PREFIXO","","Prefixo"},{"E2_NUM","","Título"},{"E2_PARCELA","","Parcela"},{"E2_TIPO","","Tipo"},{"E2_NATUREZ","","Natureza"},{"E2_VALOR","","Valor Título"},{"E2_FORNECE","","Cod Fornece"},{"E2_LOJA","","Loja"},{"E2_NOMFOR","","Nome do Fornecedor"},{"E2_EMISSAO","","Emissao"},{"E2_VENCTO","","Vencimento"},{"E2_VENCREA","","Vencimento Real"},{"E2_DATALIB","","DAta Liberação"},{"E2_STATLIB","","Status Liberação"},{"E2_USUALIB","","Usuário Liberação"},{"E2_IRRF","","Valor IR"},{"E2_ISS","","Valor ISS"},{"E2_CSLL","","Valor CSLL"},{"E2_PIS","","Valor PIS"},{"E2_COFINS","","Valor COFINS"}}
Local cArqOP
Private xaAlias 	:= { {Alias()},{"SE2"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)                                                 
Private aCores		:=	{}


//U_ufAmbiente(xaAlias, "S")




//Marck Browse Linha.
aStrut := {}

Aadd( aStrut , { "OK"     		, "C" , 02 , 0 } )
Aadd( aStrut , { "E2_PREFIXO" 	, "C" , 03 , 0 } )
Aadd( aStrut , { "E2_NUM"		, "C" , 09 , 0 } )
Aadd( aStrut , { "E2_PARCELA"  	, "C" , 02 , 0 } )
Aadd( aStrut , { "E2_TIPO"   	, "C" , 03 , 0 } )
Aadd( aStrut , { "E2_NATUREZ"  	, "C" , 10 , 2 } )
Aadd( aStrut , { "E2_VALOR" 	, "N" , 14 , 2 } )
Aadd( aStrut , { "E2_FORNECE" 	, "C" , 06 , 2 } )
Aadd( aStrut , { "E2_LOJA" 		, "C" , 02 , 2 } )
Aadd( aStrut , { "E2_NOMFOR" 	, "C" , 35 , 2 } )
Aadd( aStrut , { "E2_EMISSAO" 	, "D" , 08 , 2 } )
Aadd( aStrut , { "E2_VENCTO" 	, "D" , 08 , 2 } )
Aadd( aStrut , { "E2_VENCREA" 	, "D" , 08 , 2 } )
Aadd( aStrut , { "E2_DATALIB" 	, "D" , 08 , 2 } )
Aadd( aStrut , { "E2_STATLIB" 	, "C" , 02 , 2 } )
Aadd( aStrut , { "E2_USUALIB" 	, "C" , 35 , 2 } )
Aadd( aStrut , { "E2_IRRF" 		, "N" , 14 , 2 } )
Aadd( aStrut , { "E2_ISS" 		, "N" , 14 , 2 } )
Aadd( aStrut , { "E2_CSLL" 		, "N" , 14 , 2 } )
Aadd( aStrut , { "E2_PIS" 		, "N" , 14 , 2 } )
Aadd( aStrut , { "E2_COFINS" 	, "N" , 14 , 2 } )


cArqOP := CriaTrab(aStrut)

if select("XTIT") > 0
	XTIT->(dbclosearea())
endif

dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco

Processa( { || xsfTitDeb() })

Aadd(aCores, {' DTOC(XTIT->E2_DATALIB)!="  /  /    " ',"BR_VERDE"	})	//CADASTRO
Aadd(aCores, {' DTOC(XTIT->E2_DATALIB)=="  /  /    " ',"BR_AZUL"	})	//CADASTRO


DbSelectArea( "XTIT" )
XTIT->( DbGoTop() )

cMarca := XTIT->(GetMark())

oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)


// ******************** Interface com usuario
Define MsDialog oDlg Title cCabecalho From aSize[1], aSize[2] To aSize[3], aSize[4] Pixel


oMarkF := MsSelect():New( "XTIT","OK",,aCampos,@lInvert,@cMarca ,{34,05,(oDlg:nHeight/2)-120,(oDlg:nWidth/2)-05},,,,,aCores)
oMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock(),XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }
oMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock()) })), XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }


Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,{|| Processa( {||xsfLibPed(cMarca)})},{|| lOK := .F., oDlg:End()},.F.) Centered


//U_ufAmbiente(xaAlias, "R")
Return()

Static Function xsfLibPed(cMarca, cObserv)
Local xcMarca	:=	cMarca
Local xlOpc		:=	.T.


If !(__cUserID $ GetMV("MB_LIBCPAG")) // Liberado apenas para Diretoria -->"000000 | 000013 | 000012 | 000011 "
	Alert('USUARIO SEM ACESSO', 'ALERTA MB')
	Return()
EndIf

dbSelectArea("XTIT")
dbGoTop()

dbSelectArea("SE2")
dbSetOrder(1)
dbGoTop()

While !(XTIT->(EOF()))
	
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif
	
	SE2->(dbSeek(xFilial("SE2") + XTIT->E2_PREFIXO + XTIT->E2_NUM + XTIT->E2_PARCELA + XTIT->E2_TIPO + XTIT->E2_FORNECE + XTIT->E2_LOJA))
	RecLock("SE2")
	SE2->E2_STATLIB := "03"
	SE2->E2_DATALIB	:= dDataBase
	SE2->E2_USUALIB	:= cUsername
	MsUnlock()
	
	
	RecLock('XTIT', .F.)
	XTIT->E2_DATALIB 	:= dDataBase
	XTIT->E2_STATLIB 	:= '03'
	XTIT->E2_USUALIB 	:= cUsername
	XTIT->OK			:=	""
	XTIT->(MsUnLock())
	
	XTIT->(dbSkip())
Enddo

XTIT->(dbGoTop())

Return xlOpc



Static function xsfTitDeb(cCli, cloj)

cQuery 	:= 		 "SELECT "
cQuery  += xcR + "	E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_FORNECE,E2_LOJA, "
cQuery 	+= xcR + "	E2_NOMFOR,E2_EMISSAO,E2_VENCTO,E2_VENCREA, E2_VALOR, E2_IRRF, E2_ISS, "
cQuery 	+= xcR + "	E2_CSLL, E2_PIS, E2_COFINS, E2_DATALIB, E2_STATLIB, E2_USUALIB "
cQuery 	+= xcR + "FROM "
cQuery 	+= xcR + "	" + RetSqlName("SE2") + " A "
cQuery 	+= xcR + "WHERE "
cQuery  += xcR + "	E2_FILIAL = '"+xFilial("SE2")+"' AND "
cQuery 	+= xcR + " 	E2_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " AND "
cQuery  += xcR + " 	E2_SALDO > 0 AND "
cQuery 	+= xcR + "	E2_DATALIB = '' AND "
//cQuery 	+= xcR + "	E2_VENCREA >= '20140412' AND "
cQuery 	+= xcR + "	D_E_L_E_T_ = '' AND "
cQuery 	+= xcR + " 	E2_TIPO NOT IN ('PR ', 'NDF') "
cQuery  += xcR + "ORDER BY "
cQuery 	+= xcR + "	E2_FILIAL, E2_NUM, E2_PARCELA, E2_TIPO "

//Gera um arquivo com a query acima.
//MemoWrite("Libera Cta Pag.SQL",cQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(cQuery,xcR,"") New Alias XTT


XTT->(dbGoTop())
While !(XTT->(EOF()))
	
	
	
	dbSelectArea("XTIT")
	RecLock("XTIT",.T.)
	XTIT->E2_PREFIXO   	:= XTT->E2_PREFIXO
	XTIT->E2_NUM  		:= XTT->E2_NUM
	XTIT->E2_PARCELA   	:= XTT->E2_PARCELA
	XTIT->E2_TIPO   	:= XTT->E2_TIPO
	XTIT->E2_NATUREZ   	:= XTT->E2_NATUREZ
	XTIT->E2_FORNECE 	:= XTT->E2_FORNECE
	XTIT->E2_LOJA 		:= XTT->E2_LOJA
	XTIT->E2_NOMFOR 	:= XTT->E2_NOMFOR
	XTIT->E2_EMISSAO 	:= STOD(XTT->E2_EMISSAO)
	XTIT->E2_VENCTO 	:= STOD(XTT->E2_VENCTO)
	XTIT->E2_VENCREA 	:= STOD(XTT->E2_VENCREA)
	XTIT->E2_DATALIB 	:= STOD(XTT->E2_DATALIB)
	XTIT->E2_STATLIB 	:= XTT->E2_STATLIB
	XTIT->E2_USUALIB 	:= XTT->E2_USUALIB
	XTIT->E2_VALOR 		:= XTT->E2_VALOR
	XTIT->E2_IRRF  		:= XTT->E2_IRRF
	XTIT->E2_ISS   		:= XTT->E2_ISS
	XTIT->E2_CSLL  		:= XTT->E2_CSLL
	XTIT->E2_PIS   		:= XTT->E2_PIS
	XTIT->E2_COFINS		:= XTT->E2_COFINS
	
	dbSelectArea("XTT")
	XTT->(dbSkip())
Enddo

XTT->(dbCloseArea())
XTIT->(dbGoTop())

Return


Static Function MBLegen()
Local aCores := {}

Aadd(aCores, {"BR_AZUL"    	,"Título Bloqueado"})
Aadd(aCores, {"BR_VERDE"   	,"Título Liberado" })

BrwLegenda("LIBERAÇÃO DE PAGAMENTOS","LEGENDAS",aCores)//"Prepara‡„o dos Documentos de Sa¡da"/"Legenda"

Return(.T.)

