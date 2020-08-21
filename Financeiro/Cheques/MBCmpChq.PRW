#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RptDef.ch"


//Esta Rotina é chamada pelo Ponto de Entrada FC010BTN na Tela da Posição dos Clientes

User Function MBCmpChq()
Local oDlg, oMarkF
Local aSize     	:= 	FWGetDialogSize( oMainWnd )
Local cCabecalho	:= 	"Selecionar Pedidos a Liberar"
Local lOK       	:= 	.F.
Local lInvert   	:= 	.F.
Local cMarca    	:= 	""
Local aCampos  		:= 	{}
Local cArqOP
Private xaAlias 	:= { {Alias()},{"SE1"},{"SA1"},{"SA3"},{"SZ4"}}
Private aCores		:=	{}
//U_ufAmbiente(xaAlias, "S")


Aadd( aCampos , {"OK" ,"" ,"Ok"} )
Aadd( aCampos , {"CRT","" ,"Carteira"} )
Aadd( aCampos , {"CHQ","" ,"Cheque"} )
Aadd( aCampos , {"BCO","" ,"Banco"} )
Aadd( aCampos , {"AGE","" ,"Agencia"} )
Aadd( aCampos , {"CTA","" ,"Conta"} )
Aadd( aCampos , {"PRF","" ,"Prefixo"} )
Aadd( aCampos , {"TIT","" ,"Título"} )
Aadd( aCampos , {"PRC","" ,"Parcela"} )
Aadd( aCampos , {"TIP","" ,"Tipo"} )
Aadd( aCampos , {"VLA","" ,"Valor Cheque"} )
Aadd( aCampos , {"VLB","" ,"Valor Baixa"} )
Aadd( aCampos , {"SLD","" ,"Saldo"} )
Aadd( aCampos , {"EMI","" ,"Emissão"} )
Aadd( aCampos , {"VCT","" ,"Vencimento"} )
Aadd( aCampos , {"DT1","" ,"Dt Compensa"} )
Aadd( aCampos , {"DT2","" ,"Dt2 Compensa"} )
Aadd( aCampos , {"CLI","" ,"Cliente"} )
Aadd( aCampos , {"LOJ","" ,"Loja"} )
Aadd( aCampos , {"NCL","" ,"Nome Cliente"} )


//Marck Browse Linha.
aStrut := {}

Aadd( aStrut , { "OK"   , "C" , 02 , 0 } )
Aadd( aStrut , { "CRT"	, "C" , 01 , 0 } )
Aadd( aStrut , { "CHQ"	, "C" , 09 , 0 } )
Aadd( aStrut , { "BCO"  , "C" , 06 , 0 } )
Aadd( aStrut , { "AGE"	, "C" , 10 , 0 } )
Aadd( aStrut , { "CTA"  , "C" , 10 , 0 } )
Aadd( aStrut , { "PRF"	, "C" , 03 , 0 } )
Aadd( aStrut , { "TIT"	, "C" , 09 , 0 } )
Aadd( aStrut , { "PRC" 	, "C" , 02 , 0 } )
Aadd( aStrut , { "TIP" 	, "C" , 03 , 0 } )
Aadd( aStrut , { "VLA"  , "N" , 14 , 2 } )
Aadd( aStrut , { "VLB"  , "N" , 14 , 2 } )
Aadd( aStrut , { "SLD"  , "N" , 14 , 2 } )
Aadd( aStrut , { "EMI" 	, "D" , 08 , 0 } )
Aadd( aStrut , { "VCT" 	, "D" , 08 , 0 } )
Aadd( aStrut , { "DT1" 	, "D" , 08 , 0 } )
Aadd( aStrut , { "DT2" 	, "D" , 08 , 0 } )
Aadd( aStrut , { "CLI"  , "C" , 06 , 0 } )
Aadd( aStrut , { "LOJ" 	, "C" , 02 , 0 } )
Aadd( aStrut , { "NCL" 	, "C" , 35 , 0 } )
Aadd( aStrut , { "LEG" 	, "C" , 01 , 0 } )


cArqOP := CriaTrab(aStrut)

if select("XTIT") > 0
	XTIT->(dbclosearea())
endif

dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco


Processa( { || xsfDados() })

Aadd(aCores, {'XTIT->LEG == "A" ',"BR_PINK"		})	//Compensado
Aadd(aCores, {'XTIT->LEG == "B" ',"BR_AZUL"		})	//Não Compensado


DbSelectArea( "XTIT" )
XTIT->( DbGoTop() )

cMarca := XTIT->(GetMark())

oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)


PRIVATE aButtons :=	{}
Aadd(aButtons, {"Envia ", {|| Processa( { || xsfEnvia(cMarca) })}, "Envia ...", "Habilita Cheque " 	, {|| .T.}} )
Aadd(aButtons, {"CmpChq", {|| Processa( { || FINA191() })}, "Envia ...", "Cheques Recebidos " 	, {|| .T.}} )
Aadd(aButtons, {"Legend", {|| MBLegen()} , "Legend...", "Legenda      "		, {|| .T.}} )


Define MsDialog oDlg Title cCabecalho From aSize[1], aSize[2] To aSize[3], aSize[4] Pixel



oMarkF:= MsSelect():New("XTIT","OK",,aCampos,@lInvert,@cMarca,{34,05,(oDlg:nHeight/2)-120,(oDlg:nWidth/2)-05},,,,,aCores)
oMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock(),XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }
oMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock()) })), XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }



ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||lOK:=.T., Alert('ESCOLHA SUA OPÇÃO EM AÇÕES RELACIONADAS','ALERTA MB'),IIF(MSGYESNO('DESEJA SAIR?','ALERTA MB'),oDlg:End(),.T.)},{||oDlg:End()},,@aButtons))



//U_ufAmbiente(xaAlias, "R")

Return()


Static Function xsfDados()
Local xcQuery	:=	""
Local xcR		:=	Char(13) + Char(10)

xcQuery := 			"SELECT "
xcQuery += xcR + 	"	EF_CART CRT, EF_NUM CHQ, EF_BANCO BCO, EF_AGENCIA AGE,  "
xcQuery += xcR + 	"	EF_CONTA CTA, EF_PREFIXO PRF, EF_TITULO TIT, EF_PARCELA PRC,  "
xcQuery += xcR + 	"	EF_TIPO TIP, EF_VALOR VLA, EF_VALORBX VLB, EF_DATA EMI, EF_VENCTO VCT,  "
xcQuery += xcR + 	"	EF_DTCOMP DT1, EF_ZDTCOMP DT2, A1_COD CLI, A1_LOJA LOJ, A1_NOME NCL, ISNULL(E1_SALDO,0) SLD, "
xcQuery += xcR + 	"	CASE WHEN EF_DTCOMP = '' THEN 'A' ELSE 'B' END LEG "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SEF') + " A INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName('SA1') + " B ON "
xcQuery += xcR + 	"	EF_CLIENTE = A1_COD AND "
xcQuery += xcR + 	"	EF_LOJACLI = A1_LOJA LEFT JOIN "
xcQuery += xcR + 	"	" + RetSqlName('SE1') + " C ON "
xcQuery += xcR + 	"	EF_PREFIXO = E1_PREFIXO AND "
xcQuery += xcR + 	"	EF_TITULO = E1_NUM AND "
xcQuery += xcR + 	"	EF_PARCELA = E1_PARCELA AND "
xcQuery += xcR + 	"	EF_TIPO = E1_TIPO "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	EF_FILIAL = '" + xFilial('SEF') + "' AND "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	A1_FILIAL = '" + xFilial('SA1') + "' AND "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	E1_FILIAL = '" + xFilial('SE1') + "' AND "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	EXISTS "
xcQuery += xcR + 	"	(SELECT	 "
xcQuery += xcR + 	"		EF_NUM "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName('SEF') + " F "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		F.EF_DTCOMP = '' AND "
xcQuery += xcR + 	"		F.EF_FILIAL = '" + xFilial('SEF') + "' AND "
xcQuery += xcR + 	"		F.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		F.EF_TITULO = A.EF_TITULO AND "
xcQuery += xcR + 	"		F.EF_PARCELA = A.EF_PARCELA AND "
xcQuery += xcR + 	"		F.EF_PREFIXO = A.EF_PREFIXO) "
xcQuery += xcR + 	"ORDER BY 7 DESC "



//Gera um arquivo com a query acima.
MemoWrite("LIBERACAO DOS CHEQUES.SQL",xcQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTT



XTT->(dbGoTop())
While !(XTT->(EOF()))
	dbSelectArea("XTIT")
	RecLock("XTIT",.T.)
	
	XTIT->CRT := XTT->CRT
	XTIT->CHQ := XTT->CHQ
	XTIT->BCO := XTT->BCO
	XTIT->AGE := XTT->AGE
	XTIT->CTA := XTT->CTA
	XTIT->PRF := XTT->PRF
	XTIT->TIT := XTT->TIT
	XTIT->PRF := XTT->PRF
	XTIT->PRC := XTT->PRC
	XTIT->TIP := XTT->TIP
	XTIT->VLA := XTT->VLA
	XTIT->VLB := XTT->VLB
	XTIT->SLD := XTT->SLD
	XTIT->EMI := STOD(XTT->EMI)
	XTIT->VCT := STOD(XTT->VCT)
	XTIT->DT1 := STOD(XTT->DT1)
	XTIT->DT2 := STOD(XTT->DT2)
	XTIT->CLI := XTT->CLI
	XTIT->LOJ := XTT->LOJ
	XTIT->NCL := XTT->NCL
	XTIT->LEG := XTT->LEG
	
	dbSelectArea("XTT")
	XTT->(dbSkip())
Enddo

XTT->(dbCloseArea())
XTIT->(dbGoTop())



Return


Static Function xsfEnvia(cMarca)
Local xcMarca	:=	cMarca

dbSelectArea("XTIT")
XTIT->(dbGoTop())

xlEntra	:=	.T.


While !(XTIT->(EOF()))
	
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif


	If !EMPTY(DTOS(XTIT->DT1))
		
		xcQuery := "UPDATE "
		xcQuery += "	" + RetSqlName('SEF') + " "
		xcQuery += "SET "
		xcQuery += "	EF_ZDTCOMP = EF_DTCOMP, "
		xcQuery += "	EF_DTCOMP  = '' "
		xcQuery += "WHERE  "
		xcQuery += "	EF_FILIAL = '" + xFilial('SEF') + "' AND "
		xcQuery += "	EF_NUM = '" + XTIT->CHQ + "' AND "
		xcQuery += "	EF_BANCO = '" + XTIT->BCO + "' AND "
		xcQuery += "	EF_AGENCIA = '" + XTIT->AGE + "' AND "
		xcQuery += "	EF_CONTA = '" + XTIT->CTA + "' AND "
		xcQuery += "	EF_PREFIXO = '" + XTIT->PRF + "' AND "
		xcQuery += "	EF_TITULO = '" + XTIT->TIT + "' AND "
		xcQuery += "	EF_PARCELA = '" + XTIT->PRC + "' AND "
		xcQuery += "	EF_TIPO = '" + XTIT->TIP + "' AND "
		xcQuery += "	EF_CART = '" + XTIT->CRT + "' "
		
		TCSQLExec(xcQuery)
		
		RecLock('XTIT', .F.)
		XTIT->DT2		:=	XTIT->DT1
		XTIT->DT1		:=	CTOD('  /  /    ')
		XTIT->(MsUnLock())
		xlEntra	:=	.F.
		
	EndIf
	
	If EMPTY(DTOS(XTIT->DT1)) .AND. !EMPTY(DTOS(XTIT->DT2)) .AND. xlEntra
		
		xcQuery := "UPDATE "
		xcQuery += "	" + RetSqlName('SEF') + " "
		xcQuery += "SET "
		xcQuery += "	EF_DTCOMP = EF_ZDTCOMP "
		xcQuery += "WHERE  "
		xcQuery += "	EF_FILIAL = '" + xFilial('SEF') + "' AND "
		xcQuery += "	EF_DTCOMP = '' AND "
		xcQuery += "	EF_ZDTCOMP <> '' "
		
		TCSQLExec(xcQuery)
		
		
		RecLock('XTIT', .F.)
		XTIT->OK		:=	''
		XTIT->DT1		:=	XTIT->DT2
		XTIT->(MsUnLock())
		
	EndIf
	
	
	XTIT->(dbSkip())
	
EndDo

XTIT->(dbGoTop())


Return()


Static Function MBLegen()
Local aCores := {}

Aadd(aCores, {"BR_PINK"   	,"Compensado"})
Aadd(aCores, {"BR_AZUL" 	,"Não Compensado" })

BrwLegenda("CHEQUES A COMPENSAR","LEGENDAS",aCores)//"Prepara‡„o dos Documentos de Sa¡da"/"Legenda"

Return(.T.)
