#include "Protheus.ch"
#include "Topconn.ch"
#include "Rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MBCliDebi³ Autor ³ Claudio Alves        ³ Data ³ 03/04/2014 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Clientes devedores                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN MATA410                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//U_MBRotDesc()
User Function MBCliDebi(xcOrig)
Private xcCliente	:=	M->C5_CLIENTE
Private xcLoja		:=	M->C5_LOJACLI
Private xcPedido	:=	M->C5_NUM
Private xcTpPedi	:=	M->C5_TIPO
Private xcQuery		:=	''
Private xcR			:=	Char(13) + Char(10)
Private xcOri		:=	xcOrig
Private xaAlias 	:= { {Alias()},{"SA1"},{"SC5"}, {"SE1"}, {"SC6"}}
Private xcTitulo	:= 'CLIENTE COM SALDO DEVEDOR, PEDIDO: ' + xcPedido
Private xcDestina	:=	GetMV('MB_DESTMAI')
Private xcCco		:=	''
Private xcMens		:=	''
Private xcPath		:=	''

//U_ufAmbiente(xaAlias, "S")

If xcTpPedi $ 'DB'
	dbSelectArea('SA2')
	SA2->(dbSeek(xFilial('SA2')+xcCliente+xcLoja))
	M->C5_ZZNOMFC	:=	SA2->A2_NOME
Else
	dbSelectArea('SA1')
	SA1->(dbSeek(xFilial('SA1')+xcCliente+xcLoja))
	M->C5_ZZNOMFC	:=	SA1->A1_NOME
EndIf                        

If xcTpPedi $ GetMV('MB_TIPOPED')
	Return Iif(xcOri == "C",xcCliente,xcLoja)
EndIf



xcQuery := 			"SELECT  "
xcQuery += xcR + 	"	E1_PREFIXO, E1_NUM, E1_PARCELA, E1_VENCREA, E1_SALDO, A1_NOME  "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SE1') + " A INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName('SA1') + " B ON "
xcQuery += xcR + 	"	E1_CLIENTE = A1_COD AND  "
xcQuery += xcR + 	"	E1_LOJA = A1_LOJA "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	E1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	E1_CLIENTE = '"+xcCliente+"' AND  "
xcQuery += xcR + 	"	E1_LOJA = '"+xcLoja+"' AND  "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	E1_SALDO > 0 AND "
xcQuery += xcR + 	"	A1_RISCO <> 'A' AND "
xcQuery += xcR + 	"	E1_TIPO NOT IN ('NCC', 'RA ') AND "
xcQuery += xcR + 	"	CAST(GETDATE()-CAST(E1_VENCREA AS DATE) AS FLOAT) > 0 "

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

MemoWrite("Debito de Cliente.SQL",xcQuery)

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB


If XTRB->E1_SALDO > 0
	xcMens	:=  "       TÍTULO              VENCREA          SALDO " + xcR
	Do While !(XTRB->(EOF()))
		xcMens	+= PADR(XTRB->E1_PREFIXO + '-' + XTRB->E1_NUM + '-' + XTRB->E1_PARCELA,16) + '   ' + DTOC(STOD(XTRB->E1_VENCREA)) + '   ' + PADR(Transform(XTRB->E1_SALDO, "@E@Z 9,999,999.99"),12) + xcR
		XTRB->(dbSkip())
	End Do
	xcMens	+= xcR + xcR + "             DESEJA ENVIAR EMAIL?"
	If MsgYesNo(xcMens,'ALERTA MB')
		U_MBEnvMail(xcTitulo,xcDestina,xcCco,xcMens,xcPath)
	EndIf
	xcCliente	:=	''
	xcLoja		:=	''
EndIf



//U_ufAmbiente(xaAlias, "R")

Return Iif(xcOri == "C",xcCliente,xcLoja)


//MTA450TMAN    MTA456P MT450FIM          MTA450LIB
User Function MTA450LIB()
Private xcCliente	:=	SC9->C9_CLIENTE
Private xcLoja		:=	SC9->C9_LOJA
Private xcPedido	:=	SC9->C9_PEDIDO
Private xnItem		:=	0
Private	xlRet		:=	.T.
Private	xcRet		:=	'S'
Private xnPass		:=	0
Private xcQuery		:=	''
Private xcR			:=	Char(13) + Char(10)
Private xaAlias 	:= { {Alias()},{"SC5"}, {"SE1"}, {"SC6"}, {"SC9"}, {"SX6"}}
Private xcTitulo	:= 'CLIENTE COM SALDO DEVEDOR, PEDIDO: ' + xcPedido
Private xcDestina	:=	GetMV('MB_DESTMAI')
Private xcCco		:=	''
Private xcMens		:=	''
Private xcPath		:=	''
Private xcPedUlt	:=	GetMV('MB_LIBPEDI')

U_ufAmbiente(xaAlias, "S")


xcQuery := 			"SELECT  "
xcQuery += xcR + 	"	COUNT(*) QTDE "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SC9') + " A "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	C9_FILIAL = '01' AND  "
xcQuery += xcR + 	"	C9_PEDIDO = '"+xcPedido+"' AND  "
xcQuery += xcR + 	"	D_E_L_E_T_ = '' "

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

xnItem		:=	XTRB->QTDE

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

If Val(xcPedUlt) > xnItem
	PUTMV("MB_LIBPEDI", '0')
	xcPedUlt	:=	'0'
EndIf


xcQuery := 			"	SELECT  "
xcQuery += xcR + 	"	SUM(E1_SALDO) E1_SALDO "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SE1') + " A "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	E1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	E1_CLIENTE = '"+xcCliente+"' AND  "
xcQuery += xcR + 	"	E1_LOJA = '"+xcLoja+"' AND  "
xcQuery += xcR + 	"	D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	E1_SALDO > 0 AND "
xcQuery += xcR + 	"	E1_TIPO NOT IN ('NCC', 'RA ') AND "
xcQuery += xcR + 	"	CAST(GETDATE()-CAST(E1_VENCREA AS DATE) AS FLOAT) > 0 "

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

If XTRB->E1_SALDO > 0
	If xcPedUlt == '0'
		If PswRet()[1][1] $ GetMv('MB_ALCNIV3')
			xcMens	:=  "O Cliente: " + xcCliente + ' - ' + xcLoja + xcR
			xcMens	+=  "Está com: " + Transform(XTRB->E1_SALDO, "@E@Z 9,999,999.99") + xcR
			xcMens	+=	xcR + xcR + xcR  + "                 DESEJA LIBERAR O PEDIDO?"
			If MsgYesNo(xcMens,'ALERTA MB')
				xlRet	:=	.T.
				xcRet	:=	'S'
				xsfJustfy()
			Else
				xlRet	:=	.F.
				xcRet	:=	'N'
			EndIf
			
		Else
			xcMens	:=  "O Cliente: " + xcCliente + ' - ' + xcLoja + xcR
			xcMens	+=  "Está com: " + Transform(XTRB->E1_SALDO, "@E@Z 9,999,999.99") + xcR
			xcMens	+=  "O Pedido: " + xcPedido + " não será liberado."
			xcMens	+=  xcR + xcR + xcR  + "                 DESEJA ENVIAR EMAIL?"
			If MsgYesNo(xcMens,'ALERTA MB')
				U_MBEnvMail(xcTitulo,xcDestina,xcCco,xcMens,xcPath)
			EndIf
			xlRet	:=	.F.
			xcRet	:=	'N'
		EndIf
	EndIf
EndIf

If Val(GetMV('MB_LIBPEDI')) == 0
	PUTMV("MB_LIBPED2", xcRet)
EndIf

PUTMV("MB_LIBPEDI", AllTrim(str(val(xcPedUlt) + 1)))


If xnItem == Val(GetMV('MB_LIBPEDI'))
	PUTMV("MB_LIBPEDI", '0')
EndIF

U_ufAmbiente(xaAlias, "R")

Return IIF(GetMV('MB_LIBPED2') == 'S',.T.,.F.)


Static Function xsfJustfy()
Local xcMotCan := Space(50)

oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("LIBERAÇÃO CRÉDITO PEDIDO") FROM 09,10 To 14,70 OF oMainWnd
@ 011,030 SAY   OemToAnsi("Justificativa")  SIZE 080,009 OF oDlg FONT oFont20 PIXEL
@ 011,110 MSGET  xcMotCan	 		 SIZE 120,009 PICTURE "@!S20" OF oDlg FONT oFont20 PIXEL VALID !Empty(xcMotCan)
@ 026,200 BmpButton Type 1 ACTION Close(oDlg)

ACTIVATE MSDIALOG oDlg CENTERED

If RecLock("SC5",.F.)
	SC5->C5_ZUSRLIB	:=	__cUserId
	SC5->C5_ZOBSLIB := 	xcMotCan
	SC5->(msUnLock())
Endif


Return()
