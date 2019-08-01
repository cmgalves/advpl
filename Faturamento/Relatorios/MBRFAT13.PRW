#include "protheus.ch"
#Include "TopConn.ch"


/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBRFAT13  บAutor  ณClaudio Alves       บ Data ณ  16/05/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MBRFAT13()

PRIVATE	lEnd		:= .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ?
//?Executa a rotina de impressao ?
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// AjustaSx1("XFAT07")
// Pergunte("XFAT07",.T.)

Processa({ |lEnd| xPrint(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))



Return

/*                                                                 _
?????????????????????????????????????????????????????????????????????????????
??บDesc.     ? Imprime...                                                 บ??
?????????????????????????????????????????????????????????????????????????????
*/

Static Function xPrint()
Local xlTxQbr		:=	.T.
Local xcQuery		:=	''
Local xcR			:= 	Char(13) + Char(10)
Local xcPosic		:=	''
Local xcTxtPos		:=	''
Local xcCorPos		:=	''
Local xnMetaAlc		:=	0
Local xaTotais		:=	{}
Local xlAtu			:=	.F.
Private	oBrush		:= 	TBrush():New(,CLR_LIGHTGRAY)
Private	oPen		:= 	TPen():New(0,5,CLR_BLACK)
Private xcImpresPa	:= 	GetProfString( "PRINTER_"+ GetComputerName(), "DEFAULT","",.T.)
Private	rescoluna   := 	300 / 2.54
Private	reslinha	:= 	300 / 2.54
Private	xnLinM		:= 	0.4
Private	nColM		:= 	0.7
Private	cFileLogo	:= 	"\SYSTEM\Logo100.bmp"
Private	oFont07		:= 	TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.)
Private	oFont08		:= 	TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.)
Private	oFont08n	:= 	TFont():New('Courier New',08,08,,.T.,,,,.T.,.F.)
Private	oFont09		:= 	TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.)
Private	oFont10		:= 	TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.)
Private oFont10i	:= 	TFont():New('Times New Roman',10,10,,.F.,,,,.T.,.F.)
Private	oFont10n	:= 	TFont():New('Tahoma',10,10,,.T.,,,,.T.,.F.)
Private	oFont10u	:= 	TFont():New('Tahoma',10,10,,.T.,,,,.T.,.T.)
Private	oFont11		:= 	TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.)
Private	oFont11n	:= 	TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.)
Private	oFont12		:= 	TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.)
Private oFont12iu	:= 	TFont():New('Times New Roman',12,12,,.T.,,,,.T.,.T.)
Private	oFont12n	:= 	TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.)
Private	oFont13		:= 	TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.)
Private	oFont14		:= 	TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.)
Private oFont14iu	:= 	TFont():New('Times New Roman',14,14,,.T.,,,,.F.,.T.)
Private oFont14iun	:= 	TFont():New('Times New Roman',14,14,,.T.,,,,.T.,.T.)
Private	oFont14n	:= 	TFont():New('Tahoma',14,14,,.F.,,,,.T.,.F.)
Private	oFont15		:= 	TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.)
Private	oFont18		:= 	TFont():New('Arial',18,18,,.T.,,,,.T.,.f.)
Private	oFont16		:= 	TFont():New('Arial',16,16,,.T.,,,,.T.,.F.)
Private	oFont20		:= 	TFont():New('Arial',20,20,,.F.,,,,.T.,.F.)
Private	oFont20n	:= 	TFont():New('Arial',20,20,,.T.,,,,.T.,.F.)
Private	oFont22		:= 	TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)
Private xnPag		:=	1
Private xnAjust		:=  0
Private xcNota		:=  ""
Private xcCliente	:=  0
Private cPerg        := "MBRFAT08  "
Private xnLin		:=  0
Private xcAltVen	:=	''
Private xcNomeVen	:=	''
Private xnMeta		:=	0
Private xcDoc		:=	''

If !Pergunte(cPerg,.T.)
	Return()
EndIf


oPrint		:= 	TMSPrinter():New(OemToAnsi('MBRFAT13'))


xcQuery	:=			"SELECT  "
xcQuery += xcR + 	"	CASE  "
xcQuery += xcR + 	"	WHEN A.D_E_L_E_T_ = '*' OR C6_BLQ = 'R' THEN '04 - CANCELADO'  "
xcQuery += xcR + 	"	WHEN (A.D_E_L_E_T_ = '' OR C6_BLQ <> 'R')  AND C5_ZDTDIGI <> '' AND C5_ZDLBCAD <> '' AND C5_ZEXCPED = ''  "
xcQuery += xcR + 	"	AND C5_ZZLIBCR <> '' AND C5_ZLIBREG <> '' AND ISNULL(D2_VALBRUT, 0) = 0 THEN '02 - LIBERADO'  "
xcQuery += xcR + 	"	WHEN (A.D_E_L_E_T_ = '' OR C6_BLQ <> 'R' OR C5_ZDTDIGI <> '' OR C5_ZDLBCAD <> '' OR C5_ZEXCPED = ''  "
xcQuery += xcR + 	"	OR C5_ZZLIBCR <> '' OR C5_ZLIBREG <> '') AND ISNULL(D2_VALBRUT, 0) = 0 THEN '01 - EM ANDAMENTO'  "
xcQuery += xcR + 	"	WHEN (A.D_E_L_E_T_ = '' OR C6_BLQ <> 'R' ) AND ISNULL(D2_VALBRUT, 0) > 0 AND C5_ZZTPOPE = '04' THEN '05 - BONIFICACAO'  "
xcQuery += xcR + 	"	WHEN (A.D_E_L_E_T_ = '' OR C6_BLQ <> 'R' ) AND ISNULL(D2_VALBRUT, 0) > 0 AND C5_ZZTPOPE <> '04' THEN '03 - FATURADO'  "
xcQuery += xcR + 	"	ELSE '' END POSICAO,  "
xcQuery += xcR + 	"	C5_VEND1, ISNULL(A3_NOME, 'PEDIDO SEM VENDEDOR') A3_NOME, C5_EMISSAO, C5_NUM,  "
xcQuery += xcR + 	"	A1_NOME, A1_MUN, ISNULL(D2_EMISSAO, '') D2_EMISSAO,  "
xcQuery += xcR + 	"	ISNULL(D2_DOC+'-'+D2_SERIE, '') D2_DOC, ISNULL(D2_TOTAL, 0) D2_TOTAL,  "
xcQuery += xcR + 	"	C6_VALOR, C5_ZZLIBCR LIBCR, C5_ZEXCPED EXCPED, C5_ZDTDIGI DIGITI, C5_ZDLBCAD CADAST, C5_ZLIBREG LIBREG, "
xcQuery += xcR + 	"	CASE  "
xcQuery += xcR + 	"	WHEN C5_FRETEMB = '1' THEN 'CIF-RED' "
xcQuery += xcR + 	"	WHEN C5_FRETEMB = '2' THEN 'CIF-CLIENTE' "
xcQuery += xcR + 	"	WHEN C5_FRETEMB = '3' THEN 'FOB-RED' "
xcQuery += xcR + 	"	WHEN C5_FRETEMB = '4' THEN 'FOB-RETIRA' "
xcQuery += xcR + 	"	ELSE 'FRETE INCORRETO' END C5_FRETEMB,  "
xcQuery += xcR + 	"	C5_ZEXCOBS, C5_ZFRETE, C5_ZZTPOPE, ISNULL(META, 0) META, ISNULL(SLDATR,0) ATRASO "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SC5') + " A LEFT JOIN "
xcQuery += xcR + 	"	" + RetSqlName('SA3') + " B ON "
xcQuery += xcR + 	"	C5_VEND1 = A3_COD AND "
xcQuery += xcR + 	"	A3_FILIAL = '" + xFilial('SA3') + "' AND "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName('SA1') + " C ON "
xcQuery += xcR + 	"	C5_CLIENTE = A1_COD AND "
xcQuery += xcR + 	"	C5_LOJACLI = A1_LOJA LEFT JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		D2_EMISSAO, D2_PEDIDO, D2_DOC, D2_SERIE, "
xcQuery += xcR + 	"		SUM(D2_VALBRUT) D2_VALBRUT,  "
xcQuery += xcR + 	"		SUM(D2_TOTAL) D2_TOTAL "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName('SD2') + " X INNER JOIN "
xcQuery += xcR + 	"		" + RetSqlName('SF4') + " Z ON "
xcQuery += xcR + 	"		D2_TES = F4_CODIGO "
xcQuery += xcR + 	"	WHERE  "
xcQuery += xcR + 	"		D2_FILIAL = '" + xFilial('SD2') + "'  AND "
xcQuery += xcR + 	"		F4_FILIAL = '" + xFilial('SF4') + "'  AND "
xcQuery += xcR + 	"		X.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		Z.D_E_L_E_T_ = ''  "
If MV_PAR10 = 1
	xcQuery += xcR + 	"		AND F4_DUPLIC = 'S' "
ElseIf MV_PAR10 = 2
	xcQuery += xcR + 	"		AND F4_DUPLIC = 'N' "
EndIf
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		D2_EMISSAO, D2_PEDIDO, D2_DOC, D2_SERIE) D ON "
xcQuery += xcR + 	"	C5_NUM = D2_PEDIDO INNER JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT "
xcQuery += xcR + 	"		C6_NUM, C6_BLQ, SUM(C6_VALOR) C6_VALOR "
xcQuery += xcR + 	"	FROM "
xcQuery += xcR + 	"		" + RetSqlName('SC6') + " "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		C6_FILIAL = '" + xFilial('SC6') + "' "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		C6_NUM, C6_BLQ) E ON "
xcQuery += xcR + 	"	C5_NUM = C6_NUM LEFT JOIN "
xcQuery += xcR + 	"	( "
xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		CT_VEND, SUM(CT_VALOR) META "
xcQuery += xcR + 	"	FROM  "
xcQuery += xcR + 	"		SCT010 "
xcQuery += xcR + 	"	WHERE "
xcQuery += xcR + 	"		CT_FILIAL = '" + xFilial('SCT') + "' AND "
xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"		CT_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
xcQuery += xcR + 	"	GROUP BY "
xcQuery += xcR + 	"		CT_VEND) T ON "
xcQuery += xcR + 	"	C5_VEND1 = CT_VEND  LEFT JOIN "
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
xcQuery += xcR + 	"	C5_CLIENTE = J.E1_CLIENTE AND "
xcQuery += xcR + 	"	C5_LOJACLI = J.E1_LOJA  "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	C5_FILIAL = '" + xFilial('SC5') + "' AND "
xcQuery += xcR + 	"	A1_FILIAL = '" + xFilial('SA1') + "' AND "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	C5_TIPO = 'N' AND "
xcQuery += xcR + 	"	C5_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
xcQuery += xcR + 	"	C5_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
xcQuery += xcR + 	"	C5_VEND2 BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
xcQuery += xcR + 	"	C5_VEND3 BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
xcQuery += xcR + 	"ORDER BY "
xcQuery += xcR + 	"	C5_VEND1, POSICAO, C5_NUM "

//Gera um arquivo com a query acima.
MemoWrite("vendas do vendedor de vendas.SQL",xcQuery)

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


oPrint:SetLandscape()
//oPrint:SetPortrait()

/* Inicializa Impressora ( 1-Cliente, 2-Servidor ) */
InitPrint(1)


dbSelectArea('XTRB')
dbGoTop()

xcAltVen	:=	XTRB->C5_VEND1
xcNomeVen	:=	XTRB->A3_NOME
xnMeta		:=	XTRB->META
xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)



Do While !XTRB->(EOF())
	xcPosic		:=	XTRB->POSICAO
	xcAltVen	:=	XTRB->C5_VEND1
	xcNomeVen	:=	XTRB->A3_NOME
	xnMeta		:=	XTRB->META
	
	If xlTxQbr
		if xnLin > 2300
			xRodape(oPrint,xnLin,dDataBase)
			oPrint:EndPage()
			xnLin := 0030
			xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
		Endif
		If AllTrim(XTRB->POSICAO)	==	"01 - EM ANDAMENTO"
			xcCorPos	:=	1 //CLR_BLACK
			xcTxtPos	:=	"Pedidos em Andamento"
			oPrint:Say(xnLin,1040,xcTxtPos ,oFont14n,,CLR_BLACK)
		ElseIf AllTrim(XTRB->POSICAO)	==	"02 - LIBERADO"
			xcCorPos	:=	2 //CLR_GREEN
			xcTxtPos	:=	"Pedidos Liberados"
			oPrint:Say(xnLin,1040,xcTxtPos ,oFont14n,,CLR_GREEN)
		ElseIf AllTrim(XTRB->POSICAO)	==	"03 - FATURADO"
			xcCorPos	:=	3 //CLR_GRAY
			xcTxtPos	:=	"Pedidos Faturados"
			oPrint:Say(xnLin,1040,xcTxtPos ,oFont14n,,CLR_BLUE)
		ElseIf AllTrim(XTRB->POSICAO)	==	"05 - BONIFICACAO"
			xcCorPos	:=	5 //CLR_GRAY
			xcTxtPos	:=	"Pedidos Bonifica็ใo"
			oPrint:Say(xnLin,1040,xcTxtPos ,oFont14n,,CLR_BROWN)
		ElseIf AllTrim(XTRB->POSICAO)	==	"04 - CANCELADO"
			xcCorPos	:=	4 //CLR_RED
			xcTxtPos	:=	"Pedidos Cancelados"
			oPrint:Say(xnLin,1040,xcTxtPos ,oFont14n,,CLR_RED)
		EndIf
		xlTxQbr := .F.
		xnLin+=0080
		
	EndIf
	
	For xi	:=	1 to Len(xaTotais)
		If xaTotais[xi][1] == xcTxtPos
			xlAtu	:=	.T.
			Exit
		EndIf
	Next xi
	If xlAtu
		xaTotais[xi][2] += IIF(XTRB->D2_TOTAL > 0, XTRB->D2_TOTAL, XTRB->C6_VALOR)
		xaTotais[xi][3] += XTRB->D2_TOTAL
		xlAtu	:=	.F.
	Else
		Aadd(xaTotais,{xcTxtPos, IIF(XTRB->D2_TOTAL > 0, XTRB->D2_TOTAL, XTRB->C6_VALOR), XTRB->D2_TOTAL})
	EndIf
	Do CASE
		Case xcCorPos	==	1
			xcColor	:=	CLR_BLACK
		Case xcCorPos	==	2
			xcColor	:=	CLR_GREEN
			xcDoc	:=	XTRB->(AllTrim(D2_DOC)) //
		Case xcCorPos	==	3
			xcColor	:=	CLR_BLUE
			xcDoc	:=	XTRB->(AllTrim(D2_DOC)) //
		Case xcCorPos	==	5
			xcColor	:=	CLR_BROWN
			xcDoc	:=	XTRB->(AllTrim(D2_DOC)) //
		OTHERWISE
			xcColor	:=	CLR_RED
			xcDoc	:=	XTRB->(AllTrim(D2_DOC)) //
	EndCase
	
	
	Do Case
		Case XTRB->ATRASO  > 0 .AND. Empty(XTRB->LIBCR) .AND. Empty(XTRB->EXCPED) 													//,"BR_PRETO"	})																												//CREDITO
			xcDoc	:=	'ATRASO' //xcColor	:=	CLR_BLACK
		Case (Empty(XTRB->DIGITI) .AND. XTRB->ATRASO == 0) .OR.  (Empty(XTRB->DIGITI) .AND. XTRB->ATRASO  > 0 .AND. !Empty(XTRB->LIBCR) .AND. Empty(XTRB->EXCPED)) //"BR_AMARELO"	})
			xcDoc	:=	'DIGITAวรO' //XTRB->(AllTrim(D2_DOC)) //xcColor	:=	CLR_YELLOW
		Case !Empty(XTRB->DIGITI) .AND. Empty(XTRB->CADAST) .AND. Empty(XTRB->EXCPED)  										//,"BR_PINK"	})																									//CADASTRO
			xcDoc	:=	'CADASTRO' //XTRB->(AllTrim(D2_DOC)) //xcColor	:=	CLR_MAGENTA
		Case !Empty(XTRB->CADAST) .AND. Empty(XTRB->LIBREG) .AND. Empty(XTRB->EXCPED)  										//,"BR_AZUL"	})
			xcDoc	:=	'REGRAS' //XTRB->(AllTrim(D2_DOC)) //	xcColor	:=	CLR_BLUE
		Case !Empty(XTRB->EXCPED)																														//,"BR_MARROM"	})
			xcDoc	:=	'EXCLUอDO' //XTRB->(AllTrim(D2_DOC)) //xcColor	:=	CLR_BROWN
		Case !Empty(XTRB->DIGITI) .AND. !Empty(XTRB->CADAST) .AND. !Empty(XTRB->LIBREG) .AND. Empty(XTRB->EXCPED)  	//,"BR_VERDE"	})
			xcDoc	:=	'LIBERADO' //XTRB->(AllTrim(D2_DOC)) //xcColor	:=	CLR_GREEN
		OTHERWISE
			xcColor	:=	CLR_RED
	EndCase
	
	If !Empty(AllTrim(XTRB->(AllTrim(D2_DOC))))
		xcDoc	:=	AllTrim(XTRB->(AllTrim(D2_DOC)))
	EndIf
	
	oPrint:Say(xnLin,0040,XTRB->(LEFT(A1_NOME,50)) 								,oFont08,,xcColor) //cinza
	oPrint:Say(xnLin,1000,XTRB->(LEFT(A1_MUN,12)) 								,oFont08,,xcColor)
	oPrint:Say(xnLin,1250,XTRB->(AllTrim(DTOC(STOD(C5_EMISSAO)))) 				,oFont08,,xcColor)
	oPrint:Say(xnLin,1450,XTRB->(AllTrim(C5_NUM)) 								,oFont08,,xcColor)
	oPrint:Say(xnLin,1630,Transform(IIF(XTRB->D2_TOTAL > 0, XTRB->D2_TOTAL, XTRB->C6_VALOR),"@E 9,999,999,999,999.99") 	,oFont08,,xcColor,,2)
	oPrint:Say(xnLin,1810,XTRB->(AllTrim(DTOC(STOD(D2_EMISSAO)))) 				,oFont08,,xcColor)
	oPrint:Say(xnLin,2000,xcDoc					 		   						,oFont08,,xcColor)
	oPrint:Say(xnLin,2250,Transform(XTRB->D2_TOTAL,"@E 9,999,999,999,999.99") 	,oFont08,,xcColor,,2)
	oPrint:Say(xnLin,2430,XTRB->(AllTrim(C5_FRETEMB)) 							,oFont08,,xcColor)
	oPrint:Say(xnLin,2630,XTRB->(AllTrim(LEFT(C5_ZEXCOBS,50))) 					,oFont08,,xcColor)
	xnLin+=055
	
	if xnLin > 2300
		xRodape(oPrint,xnLin,dDataBase)
		oPrint:EndPage()
		xnLin := 0030
		xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
	Endif
	XTRB->(dbSkip())
	
	If xcPosic	!=	XTRB->POSICAO .OR. xcAltVen	!=	XTRB->C5_VEND1
		xnLin+=0015
		xlTxQbr := .T.
		xnLin+=0070
	EndIf
	
	
	if  xcAltVen	!=	XTRB->C5_VEND1
		xnLin+=0015
		xnPag := 1
		
		if xnLin > 2300
			xRodape(oPrint,xnLin,dDataBase)
			oPrint:EndPage()
			xnLin := 0030
			xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
		Endif
		oPrint:Say(xnLin,0040,"Posi็ใo" ,oFont14iun,,CLR_BLACK)
		oPrint:Say(xnLin,0640,"Valor Pedido" ,oFont14iun,,CLR_BLACK)
		oPrint:Say(xnLin,1240,"Valor Nota" ,oFont14iun,,CLR_BLACK)
		
		For xa	:=	1 to Len(xaTotais)
			xnLin+=055
			if xnLin > 2300
				xRodape(oPrint,xnLin,dDataBase)
				oPrint:EndPage()
				xnLin := 0030
				xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
			Endif
			oPrint:Say(xnLin,0040,xaTotais[xa][1]	,oFont12n,,CLR_BLACK)
			oPrint:Say(xnLin,0840,Transform(xaTotais[xa][2],"@E 9,999,999,999,999.99") 	,oFont12n,,CLR_BLACK,,1)
			oPrint:Say(xnLin,1420,Transform(xaTotais[xa][3],"@E 9,999,999,999,999.99") 	,oFont12n,,CLR_BLACK,,1)
			If AllTrim(xaTotais[xa][1]) == "Pedidos Liberados"
				xnMetaAlc	+=	xaTotais[xa][2]
			EndIf
			If AllTrim(xaTotais[xa][1]) == "Pedidos Faturados"
				xnMetaAlc	+=	xaTotais[xa][3]
			EndIf
		Next xa
		xnLin+=055
		
		if xnLin > 2300
			xRodape(oPrint,xnLin,dDataBase)
			oPrint:EndPage()
			xnLin := 0030
			xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
		Endif
		
		oPrint:Say(xnLin,0040,"Meta Representante"	,oFont12n,,CLR_BLACK)
		oPrint:Say(xnLin,1420,Transform(xnMeta,"@E 9,999,999,999,999.99") 	,oFont12n,,CLR_BLACK,,1)
		
		xnLin+=055
		
		if xnLin > 2300
			xRodape(oPrint,xnLin,dDataBase)
			oPrint:EndPage()
			xnLin := 0030
			xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
			oPrint:Say(xnLin,0040,"Posi็ใo" ,oFont14iun,,CLR_BLACK)
			oPrint:Say(xnLin,0640,"Valor Pedido" ,oFont14iun,,CLR_BLACK)
			oPrint:Say(xnLin,1240,"Valor Nota" ,oFont14iun,,CLR_BLACK)
			xnLin+=055
		Endif
		
		oPrint:Say(xnLin,0040,"Faturados + Liberados"	,oFont12n,,CLR_BLACK)
		oPrint:Say(xnLin,1420,Transform(xnMetaAlc,"@E 9,999,999,999,999.99") 	,oFont12n,,CLR_BLACK,,1)
		
		
		xnLin+=055
		
		if xnLin > 2300
			xRodape(oPrint,xnLin,dDataBase)
			oPrint:EndPage()
			xnLin := 0030
			xCabec(@xnLin, @xcAltVen, @xcNomeVen, @xnMeta)
			oPrint:Say(xnLin,0040,"Posi็ใo" ,oFont14iun,,CLR_BLACK)
			oPrint:Say(xnLin,0640,"Valor Pedido" ,oFont14iun,,CLR_BLACK)
			oPrint:Say(xnLin,1240,"Valor Nota" ,oFont14iun,,CLR_BLACK)
			xnLin+=055
		Endif
		
		If xnMeta < xnMetaAlc
			oPrint:Say(xnLin,0040,"Meta Alcan็ada"	,oFont12n,,CLR_BLUE)
			oPrint:Say(xnLin,1420,Transform(xnMetaAlc - xnMeta,"@E 9,999,999,999,999.99") 	,oFont12n,,CLR_BLUE,,1)
		Else
			oPrint:Say(xnLin,0040,"Falta para Meta"	,oFont12n,,CLR_RED)
			oPrint:Say(xnLin,1420,Transform(xnMeta - xnMetaAlc,"@E 9,999,999,999,999.99") 	,oFont12n,,CLR_RED,,1)
		EndIf
		
		
		xnVlrTotP	:=	0
		xnVlrTotN	:=	0
		xRodape(oPrint,xnLin,dDataBase)
		oPrint:EndPage()
		xnLin := 0030
		xCabec(@xnLin, XTRB->C5_VEND1, XTRB->A3_NOME, XTRB->META)
		xlTxQbr := .T.
		xaTotais	:=	{}
		xnMetaAlc	:=	0
	Endif
EndDo

oPrint:Preview()


Return
/*
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function xCabec(xnLin, xcVend, xcNomev, xnMetaVen)
Local cProt 		:= "Pedidos X Vendedor entre: " + dToc(MV_PAR01) + " e "  + dToc(MV_PAR02)
Local cCliente      := ""
Local aSx3Box		:= ''//RetSx3Box( Posicione("SX3", 2, "C5_SOLICIT", "X3CBox()" ),,, 1 )
Local cSolic 		:= ''//Upper(AllTrim( aSx3Box[Ascan( aSx3Box, { |aBox| aBox[2] = sc5->c5_solicit } )][3] ))
Local lOrcamento	:= .f.
Local lContato		:= .f.
Local _cTecno		:= ""//iif(Empty(sc6->c6_cc),'SEM CCusto',Trim(Posicione("CTT",1,xFilial("CTT")+sc6->c6_cc,"CTT_DESC01")))
Local _nPos			:= 0
Local xcVenda		:= xcVend
Local xcNomeva		:= xcNomev
Local xnMetaVena	:= xnMetaVen
xnAjust := 0

_nItemx :=0


oPrint:StartPage()


oPrint:Line(xnLin+0047,0030,xnLin+0047,3250)
oPrint:Line(xnLin+0053,0030,xnLin+0053,3250)

oPrint:SayBitmap(xnLin+0060,0060,cFileLogo,xnLin+0250,0250)

xnLin	+=	0060

oPrint:Say(xnLin+0051,0500,cProt,oFont22)
oPrint:Say(xnLin+0030,2830,'Folha: ' + Transform(xnPag,"@E 999"),oFont12)


xnLin	+=	0200
oPrint:Line(xnLin+53,30,xnLin+53,3250)
oPrint:Line(xnLin+59,30,xnLin+59,3250)
oPrint:Line(xnLin+65,30,xnLin+65,3250)

oPrint:Say(xnLin,0040,"Cliente" ,oFont10)
oPrint:Say(xnLin,1000,"Cidade" ,oFont10)
oPrint:Say(xnLin,1250,"Data" ,oFont10)
oPrint:Say(xnLin,1450,"Pedido" ,oFont10)
oPrint:Say(xnLin,1600,"Valor Ped" ,oFont10)
oPrint:Say(xnLin,1800,"Data Fat" ,oFont10)
oPrint:Say(xnLin,2000,"Nota" ,oFont10)
oPrint:Say(xnLin,2200,"Valor Nota" ,oFont10)
oPrint:Say(xnLin,2370,"Tipo Frete" ,oFont10)
oPrint:Say(xnLin,2630,"Observa็๕es" ,oFont10)


xnLin	+=	0110

oPrint:Say(xnLin,0040,xcVenda + ' - ' + xcNomeva ,oFont12iu)
oPrint:Say(xnLin,1500,"Meta: " + Transform(xnMetaVena,"@E 9,999,999.99") 	,oFont12iu,,)

xnPag++

xnLin+=0080

Return

/*

ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function xRodape(oPrint,xnLin,_dEmissao)
DEFAULT _dEmissao := dDataBase


oPrint:Line(2400,30,2400,3250)

oPrint:Say(2450,0030,"Documento emitido em "+Dtoc(dDataBase)+" e impresso em "+Dtoc(dDataBase)+", เs "+Time() ,oFont08n)
oPrint:Say(2490,0040,"Emitido por:  "+Subs(cUsuario,7,15),oFont08)
oPrint:Say(2490,1740,"Desenvolvido por Plแsticos MB ฎ",oFont10)
oPrint:EndPage()

Return

