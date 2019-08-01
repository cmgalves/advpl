#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xufSldOP  ºAutor  ³Claudio Alves       º Data ³  20/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra tela com os componentes da Estrutura calculando     º±±
±±º          ³ a necessidade e o saldo em estoque                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Empresa MB                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xufSldOP()
Local xcProduto	:=	M->C2_PRODUTO
Local xcMens	:=	''
Local xcQuery	:=	''
Local xcR		:=	Char(13) + Char(10)
Local xaTela	:=	{}
Local __oDlgConEst,__oLbx1

If !(__cUserId $ GetMV('MB_USEROP'))
	Return .T.
EndIf


xcQuery := 			"SELECT  "
xcQuery += xcR + 	"	G1_COMP CMP, B1_CONV EMB, ISNULL(B2_QATU,0) SLD, ISNULL(B2_QATU,0) / G1_QUANT * B1_CONV QTD "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	SG1010 A INNER JOIN "
xcQuery += xcR + 	"	SB1010 B ON  "
xcQuery += xcR + 	"	G1_COD = B1_COD LEFT JOIN "
xcQuery += xcR + 	"	SB2010 C ON "
xcQuery += xcR + 	"	G1_COMP = B2_COD  AND "
xcQuery += xcR + 	"	B2_FILIAL = '01' AND  "
xcQuery += xcR + 	"	B2_LOCAL IN ('01', '02') AND "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = ''  "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	G1_FILIAL = '01' AND "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	B1_FILIAL = '01' AND "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	G1_COD = '" + xcProduto + "' "
xcQuery += xcR + 	"ORDER BY "
xcQuery += xcR + 	"	1 "

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

MemoWrite("Debito de Cliente.SQL",xcQuery)

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

	Do While !(XTRB->(EOF()))
		aadd(xaTela,{AllTrim(XTRB->CMP),XTRB->EMB, XTRB->SLD, XTRB->QTD })
		XTRB->(dbSkip())
	End Do


If Len(xaTela) > 0

	DEFINE MSDIALOG _oDlgConEst FROM  31,150 TO 310,760 TITLE "Visualizacao da Estrutura de Produtos" PIXEL

	@ 05,05 LISTBOX _oLbx1 FIELDS HEADER "Codigo","Fator Conv","Saldo","Qtde a Produzir" SIZE 270, 115 OF _oDlgConEst PIXEL 

	_oLbx1:SetArray(xaTela)
	_oLbx1:bLine := { || {xaTela[_oLbx1:nAt,1],xaTela[_oLbx1:nAt,2],xaTela[_oLbx1:nAt,3],xaTela[_oLbx1:nAt,4]} }

	DEFINE SBUTTON FROM 125, 250 TYPE 1  ENABLE OF _oDlgConEst ACTION (_oDlgConEst:End())

	ACTIVATE MSDIALOG _oDlgConEst CENTERED
Else
	MsgInfo("Não Há Estrutura!","Atenção")
Endif

Return  .T.