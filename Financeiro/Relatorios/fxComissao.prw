#INCLUDE "FWPrintSetup.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#Include "Tbiconn.ch"



User Function fxEspComis(_cRc)
	local xcRc			:=	_cRc
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)
	local nLinha    	:= 100
	local xcNomFile		:=	'rel ' + time()
	private oPrint
	private oFont18
	private oFont14

	PrepEnvPor()

	oPrint:=FwMSPrinter():New(xcNomFile,6,.F.,,.T.)
	oPrint:cPathPDF := "c:\BKP\"
	oPrint:SetLandscape()
	oPrint:lServer	:= .F.
	oPrint:lInJob   := .T.
	oPrint:SetViewPDF(.F.)
	oPrint:StartPage()


	oFont12 := TFont():New( "Courier New", , -12, .F.,.T.)
	oFont18 := TFont():New( "Courier New", , -18, .T.,.T.)
	oFont14 := TFont():New( "Courier New", , -14, .T.,.T.)

	xcQuery += "SELECT " + xcR
	xcQuery += "	E3_ZVALIPI, E3_ZICMRET, PERDES, PEDIDO, " + xcR
	xcQuery += "	CLIENTE, LOJA, NOME, VEND, TOTAL, PERDESC, " + xcR
	xcQuery += "	VALDESC, VALFRETE, E3_PREFIXO, NOTA, E3_PARCELA, " + xcR
	xcQuery += "	BASCOMI, PERCOMI, COMIPED, LISTA, VALCOMI, EMIS, EMISSAO, TIPOFRETE " + xcR
	xcQuery += "FROM " + xcR
	xcQuery += "	vw_Fin_Rel_Comissao " + xcR
	xcQuery += "WHERE " + xcR
	xcQuery += "	CLIENTE = '007571' " + xcR

	MemoWrite("\sql\vw_Fin_Rel_Comissao.SQL",xcQuery)

	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif

	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

	oPrint:Box (59, 32, 3000, 2200)

	oPrint:SayBitmap( 120, 120, "system\LGMID01.png", 200, 200)
	oPrint:Say(300,100,"CADASTRO DE LIVROS", oFont18)

	nLinha := 450
	oPrint:Say( nLinha,0010, "PEDIDO"   , oFont18, , CLR_YELLOW )
	oPrint:Say( nLinha,0200, "CLIENTE"  , oFont14, , CLR_HCYAN  )
	oPrint:Say( nLinha,0330, "VEND" 	, oFont18, , CLR_YELLOW )
	oPrint:Say( nLinha,0480, "NOTA"    	, oFont18, , /*CLR_YELLOW*/ )
	oPrint:Say( nLinha,0685, "NOME"    	, oFont18, , /*CLR_YELLOW*/ )
	oPrint:Say( nLinha,0725, "VALFRETE"	, oFont18, , /*CLR_BLUE*/   )

	nLinha := 500

	While !XTRB->(EOF())

		oPrint:Say( nLinha,0010, XTRB->PEDIDO   , oFont18, , CLR_YELLOW )
		oPrint:Say( nLinha,0200, XTRB->CLIENTE  , oFont14, , CLR_HCYAN  )
		oPrint:Say( nLinha,0330, XTRB->VEND 	, oFont18, , CLR_YELLOW )
		oPrint:Say( nLinha,0480, XTRB->NOTA     , oFont18, , /*CLR_YELLOW*/ )
		oPrint:Say( nLinha,0685, XTRB->NOME     , oFont18, , /*CLR_YELLOW*/ )
		oPrint:Say( nLinha,0725, TRANSFORM(XTRB->VALFRETE, "@E 999.999,99")    , oFont18, , /*CLR_BLUE*/   )

		nLinha += 50
		XTRB->(DbSkip())
	End

	oPrint:EndPage()
	oPrint:Print()


	
Return .T.