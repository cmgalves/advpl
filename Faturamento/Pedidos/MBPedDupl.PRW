•#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

//Esta Rotina é chamada pelo Ponto de Entrada FC010BTN na Tela da Posição dos Clientes

User Function MBPedDupl(xcOrig)
Private xcCabec		:= 	"ALERTA MB"
Private xaAlias 	:= { {Alias()},{"SE1"},{"SA1"},{"SC5"},{"SC6"},{"SC9"}}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)
Private	xcCliente	:=	M->C5_CLIENTE
Private	xcLoja		:=	M->C5_LOJACLI
Private	xcMens		:=	""
Private xcOri		:=	xcOrig
Private xcMotCan	:=	Space(100)

U_ufAmbiente(xaAlias, "S")


xsfTitDeb()

aCols[n,GDFieldPos("C6_ZTABELA")] := M->C5_TABELA


U_ufAmbiente(xaAlias, "R")

Return Iif(xcOri == "C",xcCliente,xcLoja)


Static function xsfTitDeb()

xcQuery := 			"SELECT "
xcQuery += xcR + 	"	C5_NUM PEDIDO, C5_CLIENTE CLIENTE,   "
xcQuery += xcR + 	"	C5_LOJACLI LOJA, A1_NREDUZ NOME, TOTAL, A1_LC LIMITE  "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName("SC5") + " A INNER JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		C6_NUM, SUM(C6_VALOR) TOTAL "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName("SC6") + "  E "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		E.C6_FILIAL = '01' AND "
xcQuery += xcR + 	"		E.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		C6_BLQ = ''  "
xcQuery += xcR + 	" "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		C6_NUM) B ON "
xcQuery += xcR + 	"	C5_NUM = C6_NUM INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName("SA1") + " D ON "
xcQuery += xcR + 	"	C5_CLIENTE = A1_COD AND "
xcQuery += xcR + 	"	C5_LOJACLI = A1_LOJA "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	C5_FILIAL = '01' AND "
xcQuery += xcR + 	"	C5_CLIENTE = '" + xcCliente + "' AND "
xcQuery += xcR + 	"	C5_LOJACLI = '" + xcLoja + "' AND "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	NOT EXISTS ( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		D2_PEDIDO "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName("SD2") + " C "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		D2_FILIAL = '01' AND "
xcQuery += xcR + 	"		C.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		C5_NUM = D2_PEDIDO) "


//Gera um arquivo com a query acima.
MemoWrite("Pedido Duplicado.SQL",xcQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

If !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
	
	If !EMPTY(XTT->PEDIDO)
		xcMens	:=	"EXISTE(M) PEDIDO(S) DUPLICADO(S)" + xcR + xcR
		XTT->(dbGoTop())
		While !(XTT->(EOF()))
			
			xcMens	+= "PEDIDO: " + XTT->PEDIDO + "  VALOR: " + Transform(XTT->TOTAL, "@E@Z 9,999,999.99") + xcR
			
			
			dbSelectArea("XTT")
			XTT->(dbSkip())
		Enddo
		xcMens	+= xcR + xcR + "DESESA CONTINUAR COM O PEDIDO?"
		
		If MSGYESNO(xcMens,xcCabec)
			
			oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
			
			DEFINE MSDIALOG oDlg TITLE OemToAnsi("PEDIDO DUPLICADO") FROM 09,10 To 14,70 OF oMainWnd
			@ 011,030 SAY   OemToAnsi("Motivo")  SIZE 080,009 OF oDlg FONT oFont20 PIXEL
			@ 011,110 MSGET  xcMotCan	 		 SIZE 120,009 PICTURE "@!S20" OF oDlg FONT oFont20 PIXEL VALID !Empty(xcMotCan)
			@ 026,200 BmpButton Type 1 ACTION Close(oDlg)
			
			ACTIVATE MSDIALOG oDlg CENTERED
			
			M->C5_ZUSRDUP 	:= cUserName
			M->C5_ZOBSDUP	:= xcMotCan
			msUnLock()
			
		Else
			xcCliente	:=	''
			xcLoja		:=	''
			
		EndIf
		
		
		
	EndIf
EndIf

XTT->(dbCloseArea())

Return
