#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RptDef.ch"


//Esta Rotina é chamada pelo Ponto de Entrada FC010BTN na Tela da Posição dos Clientes

User Function MBCobMail()
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


Aadd( aCampos , {"OK",""  ,"Ok"} )
Aadd( aCampos , {"PRF","" ,"Prefixo"} )
Aadd( aCampos , {"TIT","" ,"Título"} )
Aadd( aCampos , {"PARC","","Parcela"} )
Aadd( aCampos , {"TIPO","","Tipo"} )
Aadd( aCampos , {"VLR","" ,"Valor"} )
Aadd( aCampos , {"EMI","" ,"Emissão"} )
Aadd( aCampos , {"VCT","" ,"Vencimento"} )
Aadd( aCampos , {"RESP","","Responsável"} )
Aadd( aCampos , {"EMR","" ,"Email Resp"} )
Aadd( aCampos , {"CBR","" ,"Cobrador(a)"} )
Aadd( aCampos , {"EML","" ,"Email Cobrança"} )
Aadd( aCampos , {"VND","" ,"Vendedor"} )
Aadd( aCampos , {"EMV","" ,"Email Vendedor"} )
Aadd( aCampos , {"CLI","" ,"Cliente"} )
Aadd( aCampos , {"LOJ","" ,"Loja"} )
Aadd( aCampos , {"EMC","" ,"Email Cliente"} )
Aadd( aCampos , {"NCL","" ,"Nome Cliente"} )
Aadd( aCampos , {"NRZ","" ,"Nome FAntasia"} )


//Marck Browse Linha.
aStrut := {}

Aadd( aStrut , { "OK"   , "C" , 02 , 0 } )
Aadd( aStrut , { "RESP"	, "C" , 15 , 0 } )
Aadd( aStrut , { "EMR"	, "C" , 30 , 0 } )
Aadd( aStrut , { "CBR"  , "C" , 06 , 0 } )
Aadd( aStrut , { "EML"	, "C" ,120 , 0 } )
Aadd( aStrut , { "VND"  , "C" , 06 , 0 } )
Aadd( aStrut , { "NRP"	, "C" , 35 , 0 } )
Aadd( aStrut , { "EMV"	, "C" ,120 , 0 } )
Aadd( aStrut , { "EMC"  , "C" ,120 , 0 } )
Aadd( aStrut , { "LOJ" 	, "C" , 02 , 0 } )
Aadd( aStrut , { "CLI"  , "C" , 06 , 0 } )
Aadd( aStrut , { "NCL" 	, "C" , 35 , 0 } )
Aadd( aStrut , { "NRZ" 	, "C" , 14 , 0 } )
Aadd( aStrut , { "PRF"  , "C" , 03 , 0 } )
Aadd( aStrut , { "TIT" 	, "C" , 09 , 0 } )
Aadd( aStrut , { "PARC"	, "C" , 02 , 0 } )
Aadd( aStrut , { "TIPO" , "C" , 03 , 0 } )
Aadd( aStrut , { "VLR"  , "N" , 15 , 2 } )
Aadd( aStrut , { "VCT" 	, "D" , 08 , 0 } )
Aadd( aStrut , { "EMI" 	, "D" , 08 , 0 } )
Aadd( aStrut , { "LEG" 	, "C" , 01 , 0 } )
Aadd( aStrut , { "TIP" 	, "C" , 01 , 0 } )
//Aadd( aStrut , { "QTD" 	, "N" , 03 , 0 } )


cArqOP := CriaTrab(aStrut)

if select("XTIT") > 0
	XTIT->(dbclosearea())
endif

dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco


Processa( { || xsfDados() })

Aadd(aCores, {'XTIT->LEG == "A" ',"BR_PINK"		})	//RISCO A
Aadd(aCores, {'XTIT->LEG == "B" ',"BR_AZUL"		})	//RISCO B
Aadd(aCores, {'XTIT->LEG == "C" ',"BR_VERDE"	})	//RISCO C
Aadd(aCores, {'XTIT->LEG == "D" ',"BR_AMARELO"	})	//RISCO D
Aadd(aCores, {'XTIT->LEG == "E" ',"BR_LARANJA"	})	//RISCO E
Aadd(aCores, {'XTIT->LEG == "F" ',"BR_VERMELHO"	})	//"Risco não Preenchido
Aadd(aCores, {'XTIT->LEG == "G" ',"BR_BRANCO"	})	//"Risco não Preenchido


DbSelectArea( "XTIT" )
XTIT->( DbGoTop() )

///modulo
cMarca := XTIT->(GetMark())

oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)


PRIVATE aButtons :=	{}
Aadd(aButtons, {"Envia ", {|| Processa( { || xsfEnvia(cMarca) })}, "Envia ...", "Envia e-Mail " 	, {|| .T.}} )
Aadd(aButtons, {"Legend", {|| MBLegen()} , "Legend...", "Legenda      "		, {|| .T.}} )


Define MsDialog oDlg Title cCabecalho From aSize[1], aSize[2] To aSize[3], aSize[4] Pixel



oMarkF:= MsSelect():New("XTIT","OK",,aCampos,@lInvert,@cMarca,{34,05,(oDlg:nHeight/2)-120,(oDlg:nWidth/2)-05},,,,,aCores)
oMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock(),XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }
oMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock()) })), XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }



ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||lOK:=.T., Alert('ESCOLHA SUA OPÇÃO EM AÇÕES RELACIONADAS','ALERTA MB'),IIF(MSGYESNO('DESEJA SAIR?','ALERTA MB'),oDlg:End(),.T.)},{||oDlg:End()},,@aButtons))

//fim do módulo, substitui de acordo com a necessidade.


//U_ufAmbiente(xaAlias, "R")

Return()


Static Function xsfDados()
Local xcQuery	:=	""
Local xcR		:=	Char(13) + Char(10)

xcQuery := 			"SELECT "
xcQuery += xcR + 	"	* FROM ( "
xcQuery += xcR + 	"SELECT  "
xcQuery += xcR + 	"	'3' TIP, 'Ana Paula Forner' 'RESP', 'sup.cobranca@plasticosmb.com.br' 'EMR',ISNULL(A3_ZZCOBRA,'XXXXXX') CBR,  "
xcQuery += xcR + 	"	ISNULL(Z4_MAIL,'FORA') 'EML', E1_VEND1 VND, ISNULL(A3_NOME,'') NRP, ISNULL(A3_EMAIL,'FORA') EMV, E1_CLIENTE CLI,  "
xcQuery += xcR + 	"	A1_ZZMAIL2 EMC, A1_NOME NCL, A1_NREDUZ NRZ,  "
xcQuery += xcR + 	"	ROUND(CAST(GETDATE() - CONVERT(DATETIME, E1_VENCREA, 103) AS INT),0,1) DIAS,  "
xcQuery += xcR + 	"	E1_PREFIXO PRF, E1_NUM TIT,  "
xcQuery += xcR + 	"	E1_PARCELA PARC, E1_TIPO TIPO, CASE WHEN A1_ZZTXBOL = '1' THEN E1_VALOR + E1_ZZTXBOL ELSE E1_VALOR END VLR,  "
xcQuery += xcR + 	"	E1_LOJA LOJ, E1_VENCREA VCT, E1_EMISSAO EMI,  "
xcQuery += xcR + 	"	DATEPART(WEEKDAY,GETDATE()) DSM,  "
xcQuery += xcR + 	"	CASE  "
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 1 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ) - 2,112) " --//Domingo na Quarta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 2 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Segunda na Quarta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 3 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Terça na Quinta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 4 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Quarta na Sexta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 5 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Quinta na Segunda
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 6 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Sexta na Terça
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 7 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ) - 1,112) " --//Sábado na Quarta
xcQuery += xcR + 	"	END ENV,  "
xcQuery += xcR + 	"	CASE   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'A' THEN 'A'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'B' THEN 'B'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'C' THEN 'C'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'D' THEN 'D'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'E' THEN 'E'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = ' ' THEN 'F'  "
xcQuery += xcR + 	"	ELSE 'G'  "
xcQuery += xcR + 	"	END LEG "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	SE1010 A INNER JOIN  "
xcQuery += xcR + 	"	SA1010 B ON  "
xcQuery += xcR + 	"	E1_CLIENTE = A1_COD AND  "
xcQuery += xcR + 	"	E1_LOJA = A1_LOJA LEFT JOIN  "
xcQuery += xcR + 	"	SA3010 C ON  "
xcQuery += xcR + 	"	E1_VEND1 = A3_COD AND  "
xcQuery += xcR + 	"	A3_FILIAL = '  ' AND  "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = ' ' LEFT JOIN  "
xcQuery += xcR + 	"	SZ4010 D ON  "
xcQuery += xcR + 	"	A3_ZZCOBRA = Z4_ZZCOD AND  "
xcQuery += xcR + 	"	Z4_FILIAL = '  ' AND  "
xcQuery += xcR + 	"	D.D_E_L_E_T_ = ' '  "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	E1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = ' '  AND  "
xcQuery += xcR + 	"	A1_FILIAL = '  ' AND  "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = ' '  AND  "
xcQuery += xcR + 	"	E1_TIPO NOT IN ('RA', 'NCC') AND  "
xcQuery += xcR + 	"	E1_SALDO > 0 AND  "
xcQuery += xcR + 	"	E1_ZENVMAI = '' AND  "
xcQuery += xcR + 	"	E1_ZENVMA2 = '' AND  "
xcQuery += xcR + 	"	E1_NUMBCO <> '' AND "
xcQuery += xcR + 	"	A1_BCO1 NOT IN ('CX1', 'CXC') AND "
xcQuery += xcR + 	"	E1_EMISSAO >= '20140531' "
xcQuery += xcR + 	" "
xcQuery += xcR + 	"UNION ALL  "
xcQuery += xcR + 	"	  "
xcQuery += xcR + 	"SELECT  "
xcQuery += xcR + 	"	'7' TIP, 'Ana Paula Forner' 'RESP', 'sup.cobranca@plasticosmb.com.br' 'EMR',ISNULL(A3_ZZCOBRA,'XXXXXX') CBR,  "
xcQuery += xcR + 	"	ISNULL(Z4_MAIL,'FORA') 'EML', E1_VEND1 VND, ISNULL(A3_NOME,'') NRP, ISNULL(A3_EMAIL,'FORA') EMV, E1_CLIENTE CLI,  "
xcQuery += xcR + 	"	A1_ZZMAIL2 EMC, A1_NOME NCL, A1_NREDUZ NRZ,  "
xcQuery += xcR + 	"	ROUND(CAST(GETDATE() - CONVERT(DATETIME, E1_VENCREA, 103) AS FLOAT),0,1) DIAS,  "
xcQuery += xcR + 	"	E1_PREFIXO PRF, E1_NUM TIT,  "
xcQuery += xcR + 	"	E1_PARCELA PARC, E1_TIPO TIPO, CASE WHEN A1_ZZTXBOL = '1' THEN E1_VALOR + E1_ZZTXBOL ELSE E1_VALOR END VLR,  "
xcQuery += xcR + 	"	E1_LOJA LOJ, E1_VENCREA VCT, E1_EMISSAO EMI,  "
xcQuery += xcR + 	"	DATEPART(WEEKDAY,GETDATE()) DSM,  "
xcQuery += xcR + 	"	CASE  "
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 1 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ) -2,112) " --//Domingo na Segunda
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 2 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Segunda na Terça
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 3 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Terça na Quarta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 4 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Quarta na Quinta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 5 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Quinta na Quinta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 6 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 ),112) " --//Sexta na Quinta
xcQuery += xcR + 	"	WHEN DATEPART(WEEKDAY,CAST(E1_VENCREA AS DATE)) = 7 THEN CONVERT(VARCHAR,CONVERT(DATETIME, E1_VENCREA,103 )- 1,112) " --//Sábado na Sexta
xcQuery += xcR + 	"	END ENV,  "
xcQuery += xcR + 	"	CASE    "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'A' THEN 'A'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'B' THEN 'B'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'C' THEN 'C'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'D' THEN 'D'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = 'E' THEN 'E'   "
xcQuery += xcR + 	"	WHEN A1_RISCO = ' ' THEN 'F'   "
xcQuery += xcR + 	"	ELSE 'G'  "
xcQuery += xcR + 	"	END LEG "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	SE1010 A INNER JOIN  "
xcQuery += xcR + 	"	SA1010 B ON  "
xcQuery += xcR + 	"	E1_CLIENTE = A1_COD AND  "
xcQuery += xcR + 	"	E1_LOJA = A1_LOJA LEFT JOIN  "
xcQuery += xcR + 	"	SA3010 C ON  "
xcQuery += xcR + 	"	E1_VEND1 = A3_COD AND  "
xcQuery += xcR + 	"	A3_FILIAL = '  ' AND  "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = ' ' LEFT JOIN  "
xcQuery += xcR + 	"	SZ4010 D ON  "
xcQuery += xcR + 	"	A3_ZZCOBRA = Z4_ZZCOD AND  "
xcQuery += xcR + 	"	Z4_FILIAL = '  ' AND  "
xcQuery += xcR + 	"	D.D_E_L_E_T_ = ' '  "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	E1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = ' '  AND  "
xcQuery += xcR + 	"	A1_FILIAL = '  ' AND  "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = ' '  AND  "
xcQuery += xcR + 	"	E1_TIPO NOT IN ('RA', 'NCC') AND  "
xcQuery += xcR + 	"	E1_SALDO > 0 AND  "
xcQuery += xcR + 	"	E1_ZENVMA2 = '' AND  "
xcQuery += xcR + 	"	E1_NUMBCO <> '' AND "
xcQuery += xcR + 	"	A1_BCO1 NOT IN ('CX1', 'CXC') AND "
xcQuery += xcR + 	"	E1_EMISSAO >= '20140531' "
xcQuery += xcR + 	") DS "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	DATEDIFF(DAY,GETDATE(), CAST(ENV AS DATE)) = 0 "
xcQuery += xcR + 	"ORDER BY 1,3,5,7,8,17 "


//Gera um arquivo com a query acima.
MemoWrite("Email de Cobranca.SQL",xcQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTT



XTT->(dbGoTop())
While !(XTT->(EOF()))
	dbSelectArea("XTIT")
	RecLock("XTIT",.T.)
	
	XTIT->RESP  := XTT->RESP
	XTIT->EMR   := XTT->EMR
	XTIT->CBR  	:= XTT->CBR
	XTIT->EML   := AllTrim(XTT->EML)
	XTIT->VND	:= XTT->VND
	XTIT->EMV   := AllTrim(XTT->EMV)
	XTIT->NRP   := XTT->NRP
	XTIT->EMC  	:= AllTrim(XTT->EMC)
	XTIT->LOJ   := XTT->LOJ
	XTIT->CLI 	:= XTT->CLI
	XTIT->NCL 	:= XTT->NCL
	XTIT->NRZ 	:= XTT->NRZ
	XTIT->PRF 	:= XTT->PRF
	XTIT->TIT	:= XTT->TIT
	XTIT->PARC 	:= XTT->PARC
	XTIT->TIPO 	:= XTT->TIPO
	XTIT->VLR 	:= XTT->VLR
	XTIT->VCT 	:= STOD(XTT->VCT)
	XTIT->EMI 	:= STOD(XTT->EMI)
	XTIT->LEG 	:= XTT->LEG
	XTIT->TIP 	:= XTT->TIP
	
	dbSelectArea("XTT")
	XTT->(dbSkip())
Enddo

XTT->(dbCloseArea())
XTIT->(dbGoTop())



Return


Static Function xsfEnvia(cMarca)
Local xaSend	:=	{}
Local aDados	:=	{}
Local xcAsst	:=	'Aviso de Cobrança'
Local xcMail	:=	'ti@plasticosmb.com.br'
Local xcNoMail	:=	GetMv('MB_MAILCAD')
Local xcSender	:=	Getmv('MB_ENVCOBR')
Local xcCco		:=	''
Local xcMens	:=	''
Local xcPath	:=	''
Local xa		:=	0
Local xcMarca	:=	cMarca
Local xcQuery	:=	""
Local xcR		:=	Char(13) + Char(10)
Local xcCliente	:=	''
Local xcVend	:=	''

dbSelectArea("XTIT")
XTIT->(dbGoTop())


While !(XTIT->(EOF()))
	
	If XTIT->OK != xcMarca
		XTIT->(dbSkip())
		Loop
	Endif         //   01      02          03         04         05          06         07          08         09        10          11         12         13         14          15         16        17
	aAdd(xaSend, {XTIT->EMR, XTIT->EML, XTIT->EMV, XTIT->EMC, XTIT->PRF, XTIT->TIT, XTIT->PARC, XTIT->VLR, XTIT->VCT, XTIT->NCL, XTIT->CLI, XTIT->LOJ, XTIT->NRZ, XTIT->TIPO, XTIT->TIP, XTIT->EMI, XTIT->NRP } )
	
	RecLock('XTIT', .F.)
	XTIT->OK		:=	""
	XTIT->(MsUnLock())
	
	If Len(AllTrim(XTIT->EMC)) > 5
		XTIT->LEG		:=	"G"
		
		xcQuery := xcR + 	"UPDATE "
		xcQuery += xcR + 	"	" + RetSqlName("SE1") + " "
		xcQuery += xcR + 	"SET "
		If XTIT->TIP == '3'
			xcQuery += xcR + 	"	E1_ZENVMAI  = '" + dTos(dDataBase) + "' "
		Else
			xcQuery += xcR + 	"	E1_ZENVMA2  = '" + dTos(dDataBase) + "' "
		EndIf
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	E1_PREFIXO 	= '" + XTIT->PRF   + "' AND "
		xcQuery += xcR + 	"	E1_NUM 		= '" + XTIT->TIT   + "' AND "
		xcQuery += xcR + 	"	E1_PARCELA 	= '" + XTIT->PARC  + "' AND "
		xcQuery += xcR + 	"	E1_TIPO 	= '" + XTIT->TIPO  + "' AND "
		xcQuery += xcR + 	"	E1_CLIENTE 	= '" + XTIT->CLI   + "' AND "
		xcQuery += xcR + 	"	E1_LOJA 	= '" + XTIT->LOJ   + "' "
		
		TCSQLEXEC(xcQuery)
		
	EndIf
	
	XTIT->(dbSkip())
EndDo
//(cAlias)->(dbCloseArea())

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif


//Envio do Cliente
For xi	:=	1 To Len(xaSEnd)    
	xlConfirm	:=	.F.
	xcCliente	:=	xaSend[xi][11] + xaSend[xi][12]
	
	xcMens 		:=	'PEDREIRA, ' + AllTrim(Str(Day(Date()))) + ' de ' + MesExtenso(Month(Date())) + ' de ' + AllTrim(Str(Year(Date()))) + '' + xcR + xcR + xcR + xcR
	xcMens+= xcR + 	'À'
	xcMens+= xcR + 	xaSend[xi][10] + xcR + xcR + xcR + xcR
	xcMens+= xcR + 	'Caro Cliente' + xcR + xcR
	
	xcMens+= xcR + 	'Visando melhorias em nosso departamento de cobranças e para evitarmos que os nossos clientes paguem multas e/ou juros'
	xcMens+= xcR + 	'Informamos que o(s) seu(s) título(s) vence(m) hoje, conforme mencionado(s) abaixo:' + xcR + xcR + xcR + xcR
	
	For xi	:=	xi To Len(xaSend)
		If xcCliente	!=	xaSend[xi][11] + xaSend[xi][12]
			Exit
		EndIf
		xcMens+= xcR + 'Nota Fiscal: '+		xaSend[xi][06] + '-' + xaSend[xi][07] + '  -  Emissão: '+ DTOC(xaSend[xi][16])+ '  -  Vencimento: '+DTOC(xaSend[xi][09])+ '  -  Valor: '+Transform(xaSend[xi][08],'99,999,999.99') + ''
		xa := xi
	Next xi
	xi	:=	xa
	xcMens+= xcR + xcR + xcR + xcR
	
	xcMens+= xcR + 	'Caso não tenham recebido o boleto corretamente, favor entrar em contato com a PLÁSTICOS MB, por meio dos contatos abaixo'+ xcR + xcR
	
	xcMens+= xcR + 	'Muito Obrigado '+ xcR + xcR + xcR + xcR
	xcMens+= xcR + 	'Ana Paula Forner'
	xcMens+= xcR + 	'Depto. Financeiro'
	xcMens+= xcR + 	'E-Mail: sup.cobranca@plasticosmb.com.br'
	xcMens+= xcR + 	'Skype: supcobrancamb'
	xcMens+= xcR + 	'PABX: (19)3852-9079'+ xcR + xcR + xcR + xcR + xcR + xcR + xcR
	
	xcMens+= xcR + 	'PLÁSTICOS MB LTDA'
	xcMens+= xcR + 	'RODOVIA SP 095 KM 54,9 - PEDREIRA - SP  CEP: 13920000'
	xcMens+= xcR + 	'Sítio: www.plasticosmb.com.br'
	
	If Len(AllTrim(xaSend[xi][04])) > 5
		xlConfirm	:=	NGSendMail('Ana Paula Forner',AllTrim(xaSend[xi][04]),,,xcAsst,,xcMens,,'sup.cobranca@plasticosmb.com.br',,,,)
		If !xlConfirm
			NGSendMail('Ana Paula Forner',xcSender,,,'Erro de Email ' + xcAsst,, xcMens,,'sup.cobranca@plasticosmb.com.br',,,,)
		EndIf
	Else
		NGSendMail('Ana Paula Forner',xcNoMail,,,'Sem Email Cliente: ' + xcAsst,,xcMens,,'sup.cobranca@plasticosmb.com.br',,,,)
		xlConfirm	:=	.T.
	EndIf
	
 
Next xi



//Envio do Representante
xcAsst	:=	'Aviso de Cobranca - Plasticos MB'

For xi	:=	1 To Len(xaSEnd)
	xcVend	:=	xaSend[xi][17]
	
	xcMens	:=	 	'PEDREIRA, ' + AllTrim(Str(Day(Date()))) + ' de ' + MesExtenso(Month(Date())) + ' de ' + AllTrim(Str(Year(Date()))) + '' + xcR + xcR + xcR + xcR
	xcMens+= xcR + 	'À'
	xcMens+= xcR + 	xaSend[xi][17] + xcR + xcR + xcR + xcR
	xcMens+= xcR + 	'Prezados Senhores' + xcR + xcR
	
	xcMens+= xcR + 	'Segue listagem de títulos que vencendo hoje, os quais enviamos por email para os clientes.' + xcR + xcR + xcR + xcR
	
	For xi	:=	xi To Len(xaSend)
		If xcVend	!=	xaSend[xi][17]
			Exit
		EndIf
		xcMens+= xcR + 'Cliente: '+	AllTrim(xaSend[xi][10]) + '   -   Nota Fiscal: '+		xaSend[xi][06] + '-' + xaSend[xi][07] + '  -  Emissão: '+ DTOC(xaSend[xi][16])+ '  -  Vencimento: '+DTOC(xaSend[xi][09])+ '  -  Valor: '+Transform(xaSend[xi][08],'99,999,999.99') +  Iif(xaSend[xi][15]=='3','   Primeiro Aviso','   Segundo Aviso') + ' '
		xa := xi
	Next xi
	xi	:=	xa
	xcMens+= xcR + xcR + xcR + xcR
	
	
	xcMens+= xcR + 	'Atenciosamente '+ xcR + xcR + xcR + xcR
	xcMens+= xcR + 	'Ana Paula Forner'
	xcMens+= xcR + 	'Contas a Receber'
	xcMens+= xcR + 	'E-Mail: sup.cobranca@plasticosmb.com.br'
	xcMens+= xcR + 	'Skype: supcobrancamb'
	xcMens+= xcR + 	'PABX: (19)3852-9082 R 319'+ xcR + xcR + xcR + xcR + xcR + xcR + xcR
	
	xcMens+= xcR + 	'PLÁSTICOS MB LTDA'
	xcMens+= xcR + 	'RODOVIA SP 095 KM 54,9 - PEDREIRA - SP  CEP: 13920000'
	xcMens+= xcR + 	'Sítio: www.plasticosmb.com.br'
	
	If Len(AllTrim(xaSend[xi][03])) > 5
		NGSendMail('Ana Paula Forner' , AllTrim(xaSend[xi][03]), , , xcAsst, , xcMens,,'sup.cobranca@plasticosmb.com.br',,,,)
	Else
		NGSendMail('Ana Paula Forner' , xcNoMail, , , 'Sem Email Vendedor: ' + xcAsst, , xcMens,,'sup.cobranca@plasticosmb.com.br',,,,)
	EndIf
Next xi




XTIT->(dbGoTop())

Return()


Static Function MBLegen()
Local aCores := {}

Aadd(aCores, {"BR_PINK"   	,"Risco A"})
Aadd(aCores, {"BR_AZUL" 	,"Risco B" })
Aadd(aCores, {"BR_VERDE"   	,"Risco C" })
Aadd(aCores, {"BR_AMARELO" 	,"Risco D" })
Aadd(aCores, {"BR_LARANJA" 	,"Risco E" })
Aadd(aCores, {"BR_VERMELHO"	,"Risco não Preenchido" })
Aadd(aCores, {"BR_BRANCO"	,"Email Enviado" })

BrwLegenda("EMAIL COBRANÇA","LEGENDAS",aCores)//"Prepara‡„o dos Documentos de Sa¡da"/"Legenda"

Return(.T.)
