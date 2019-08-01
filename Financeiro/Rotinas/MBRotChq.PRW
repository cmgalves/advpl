#include "protheus.ch"
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MBRotChq ³ Autor ³ Claudio Alves        ³ Data ³ 11/03/2014 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de cheques                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN FINA190                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function MBRotChq()
Local cChqBco	:=	M->EF_BANCO
Private	nChqSld	:=	0
Private	nChqVlr	:=	0
Private	nChqBxa	:=	0
Private xaAlias := { {Alias()},{"SE1"},{"SE5"},{"SEF"}}

U_ufAmbiente(xaAlias, "S")


Processa({|| MBUltChq() },"Atualizando os registros","Selecionando Registros... ")


U_ufAmbiente(xaAlias, "R")

Return(cChqBco)



Static Function MBUltChq()
Local cQuery	:=	''
Local cR		:=	Char(13) + Char(10)

cQuery	:=		"SELECT
cQuery	+= cR +	"	MAX(R_E_C_N_O_) CHNUM "
cQuery	+= cR +	"FROM "
cQuery	+= cR +	"	" + RetSqlName('SEF') + " A "
cQuery	+= cR +	"WHERE
cQuery	+= cR +	"	EF_FILIAL = '" + xFilial('SEF') + "' AND "
cQuery	+= cR +	"	EF_CART = 'R' AND "
cQuery	+= cR +	"	D_E_L_E_T_ = '' "

if select("CHTRB") > 0    // Atualiza cadastro de cheques
	CHTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(cQuery,cR,"") New Alias CHTRB


cQuery	:=		"SELECT "
cQuery	+= cR +	"	EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM, EF_VALOR,  "
cQuery	+= cR +	"	EF_VALORBX, EF_DATA, EF_VENCTO, EF_PREFIXO, EF_TITULO,  "
cQuery	+= cR +	"	EF_PARCELA, EF_TIPO, EF_BENEF, EF_CLIENTE, EF_LOJACLI,  "
cQuery	+= cR +	"	EF_CPFCNPJ, EF_EMITENT, EF_HIST, EF_HISTD, EF_DEPOSIT,  "
cQuery	+= cR +	"	EF_GARANT, EF_IMPRESS, EF_LA, EF_LIBER, EF_OK, EF_ORIGEM,  "
cQuery	+= cR +	"	EF_PORTADO, EF_RG, EF_SEQUENC, EF_TERCEIR, EF_TEL, EF_DTCOMP,  "
cQuery	+= cR +	"	EF_DEBITO, EF_CCD, EF_ITEMD, EF_CLVLDB, EF_CREDIT, EF_CCC,  "
cQuery	+= cR +	"	EF_ITEMC, EF_CLVLCR, EF_USADOBX, EF_NATUR, EF_FILORIG,  "
cQuery	+= cR +	"	EF_TALAO, EF_ZZDIRET, EF_ZZDEPOS "
cQuery	+= cR +	"FROM "
cQuery	+= cR +	"	" + RetSqlName('SEF') + " A "
cQuery	+= cR +	"WHERE  "
cQuery	+= cR +	"	EF_FILIAL = '" + xFilial('SEF') + "' AND "
cQuery	+= cR +	"	D_E_L_E_T_ = '' AND "
cQuery	+= cR +	"	R_E_C_N_O_ = " + Transform(CHTRB->CHNUM, "@E@Z 9999999999999") + " "

if select("CHTRB") > 0    // Atualiza cadastro de cheques
	CHTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(cQuery,cR,"") New Alias CHTRB


cQuery := 			"	SELECT  "
cQuery += cR + 	"		EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM, "
cQuery += cR + 	"		AVG(EF_VALOR) - SUM(EF_VALORBX) EF_VALORBX, AVG(EF_VALOR) EF_VALOR "
cQuery += cR + 	"	FROM "
cQuery += cR + 	"		" + RetSqlName('SEF') + " X "
cQuery += cR + 	"	WHERE "
cQuery += cR + 	"		EF_BANCO = '" +CHTRB->EF_BANCO + "' AND "
cQuery += cR + 	"		EF_AGENCIA = '" +CHTRB->EF_AGENCIA + "' AND "
cQuery += cR + 	"		EF_CONTA = '" +CHTRB->EF_CONTA + "' AND "
cQuery += cR + 	"		EF_NUM= '" +CHTRB->EF_NUM + "' AND "
cQuery += cR + 	"		EF_FILIAL  = '01' AND "
cQuery += cR + 	"		X.D_E_L_E_T_ = '' "
cQuery += cR + 	"	GROUP BY "
cQuery += cR + 	"		EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM "


MemoWrite('Saldo Cheque Lancamento.sql', cQuery)

if select("X1CHQ") > 0
	X1CHQ->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(cQuery,cR,"") New Alias X1CHQ

If X1CHQ->EF_VALORBX > 0
	If MsgYESNO("Deseja Atualizar? " + cR + ;
		"Banco:   " + CHTRB->EF_BANCO    + cR + ;
		"Agencia: " + CHTRB->EF_AGENCIA  + cR + ;
		"Conta:   " + CHTRB->EF_CONTA    + cR + ;
		"Cheque:  " + CHTRB->EF_NUM      + cR + ;
		"Saldo: " + Transform(X1CHQ->EF_VALORBX, "@E@Z 9,999,999.99") + cR + ;
		"Valor: " + Transform(X1CHQ->EF_VALOR, "@E@Z 9,999,999.99"),"Confirma Atualziação")
		
		
		M->EF_BANCO 	:= CHTRB->EF_BANCO
		M->EF_AGENCIA 	:= CHTRB->EF_AGENCIA
		M->EF_CONTA 	:= CHTRB->EF_CONTA
		M->EF_NUM 		:= CHTRB->EF_NUM
		M->EF_VALOR 	:= CHTRB->EF_VALOR
		M->EF_DATA 		:= STOD(CHTRB->EF_DATA)
		M->EF_VENCTO 	:= STOD(CHTRB->EF_VENCTO)
		M->EF_BENEF 	:= CHTRB->EF_BENEF
		M->EF_CLIENTE 	:= CHTRB->EF_CLIENTE
		M->EF_LOJACLI 	:= CHTRB->EF_LOJACLI
		M->EF_CPFCNPJ 	:= CHTRB->EF_CPFCNPJ
		M->EF_EMITENT 	:= CHTRB->EF_EMITENT
		M->EF_HIST 		:= CHTRB->EF_HIST
		M->EF_HISTD 	:= CHTRB->EF_HISTD
		M->EF_DEPOSIT 	:= CHTRB->EF_DEPOSIT
		M->EF_GARANT 	:= CHTRB->EF_GARANT
		M->EF_IMPRESS 	:= CHTRB->EF_IMPRESS
		M->EF_LA 		:= CHTRB->EF_LA
		M->EF_LIBER 	:= CHTRB->EF_LIBER
		M->EF_OK 		:= CHTRB->EF_OK
		M->EF_ORIGEM 	:= CHTRB->EF_ORIGEM
		M->EF_PORTADO 	:= CHTRB->EF_PORTADO
		M->EF_RG 		:= CHTRB->EF_RG
		M->EF_SEQUENC 	:= CHTRB->EF_SEQUENC
		
		U_MBPesqTit(CHTRB->EF_CLIENTE, CHTRB->EF_LOJACLI, CHTRB->EF_VALOR)
	EndIf
EndIf


Return
