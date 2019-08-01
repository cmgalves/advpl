#include "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "FileIO.ch"                

User Function MBRFAT12()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Vendas Estado"
Local cPict          := ""
Local nLin           := 90
Local Cabec1		 := "REG/ESTADO                     %FATURAMENTO      %REGIAO"
Local Cabec2		 := ""
Local imprime        := .T.

Private titulo         := "Relatorio de Vendas Estado"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "MBRFAT12" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MBRFAT12  "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MBRFAT12"	// Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		 := "SC6"
ValidPerg()

Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem
Local cNord	:= "AL BA CE MA PB PE PI RN SE"
Local cSude	:= "ES MG RJ SP"
Local cCoes	:= "DF GO MS MT"
Local cNort	:= "AC AM AP PA RO RR TO"
Local cSul	:= "PR RS SC"
Local cOutr	:= "EX"

Local nNord	:= 0
Local nSude	:= 0
Local nCoes	:= 0
Local nNort	:= 0
Local nSul	:= 0
Local nOutr	:= 0

Local aNord	:= {}
Local aSude	:= {}
Local aCoes	:= {}                   
Local aNort	:= {}
Local aSul	:= {}
Local aOutr	:= {}

Private cNL     := Chr(13) + Chr(10)         // Caracteres p/ "Nova Linha"
IF MV_PAR09 = 1
	titulo:= "Fat por Estado" + " ("+dtoc(MV_PAR01)+" - "+dtoc(MV_PAR02)+") "
ELSE
	titulo:= "Vendas por Estado" + " ("+dtoc(MV_PAR01)+" - "+dtoc(MV_PAR02)+") "
ENDIF

//If FErase(cPerg+".csv") == -1
//	cCSV	:= AllTrim(cPerg)+StrTran(Time(),":","")+".csv"
//Else
//	cCSV	:= cPerg+".csv"
//EndIF


IF MV_PAR09 = 2
	cQuery	:= "SELECT " +CRLF
	cQuery	+= "		b.A1_EST, " +CRLF
	cQuery	+= "		sum(a.C6_VALOR) C6_VALOR " +CRLF
	cQuery	+= "	FROM   " +CRLF
	cQuery	+= "		"+RETSQLNAME("SC6")+" a LEFT JOIN   " +CRLF
	cQuery	+= "		"+RETSQLNAME("SF4")+" e ON   " +CRLF
	cQuery	+= "		e.F4_CODIGO		=	a.C6_TES	and   " +CRLF
	cQuery	+= "		e.D_E_L_E_T_	<> '*' LEFT JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SC5")+" d ON   " +CRLF
	cQuery	+= "		d.C5_NUM		=	a.C6_NUM	and   " +CRLF
	cQuery	+= "		d.D_E_L_E_T_	<> '*' LEFT JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SA1")+" b ON        " +CRLF
	cQuery	+= "		b.A1_COD		=	d.C5_CLIENTE	and  " +CRLF
	cQuery	+= "		b.A1_LOJA		=	d.C5_LOJACLI	AND " +CRLF
	cQuery	+= "		b.D_E_L_E_T_	<>	'*'				LEFT JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SB1")+" c ON " +CRLF
	cQuery	+= "		c.B1_COD		= a.C6_PRODUTO		AND " +CRLF
	cQuery	+= "		c.D_E_L_E_T_	<>	'*'		 " +CRLF
	cQuery	+= "	WHERE  " +CRLF
	cQuery	+= "		a.D_E_L_E_T_ <> '*'   " +CRLF
	cQuery	+= "	AND	c.B1_TIPO IN('PA','PI', 'SU')  " +CRLF
	cQuery	+= "	AND	d.C5_EMISSAO	between '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
	IF MV_PAR10 = 1
		cQuery	+= "	AND e.F4_DUPLIC		= 'S'  " +CRLF
	ELSEIF MV_PAR10 = 2
		cQuery	+= "	AND e.F4_DUPLIC		= 'N'  " +CRLF
	ENDIF
	cQuery	+= "	AND d.C5_VEND1 between '"+MV_PAR03+"' and '"+MV_PAR04+"'  " +CRLF
	cQuery	+= "	AND d.C5_VEND2 between '"+MV_PAR05+"' and '"+MV_PAR06+"'  " +CRLF
	cQuery	+= "	AND d.C5_VEND3 between '"+MV_PAR07+"' and '"+MV_PAR08+"'  " +CRLF
	cQuery	+= "	GROUP BY  " +CRLF
	cQuery	+= "		b.A1_EST " +CRLF
	cQuery	+= "	ORDER BY " +CRLF
	cQuery	+= "		b.A1_EST " +CRLF
ELSE
	cQuery	:= "SELECT " +CRLF
	cQuery	+= "		b.A1_EST, " +CRLF
	cQuery	+= "		sum(a.D2_TOTAL) C6_VALOR " +CRLF
	cQuery	+= "	FROM   " +CRLF
	cQuery	+= "		"+RETSQLNAME("SD2")+" a LEFT JOIN   " +CRLF

	cQuery	+= "		"+RETSQLNAME("SF4")+" e ON   " +CRLF
	cQuery	+= "		e.F4_CODIGO		=	a.D2_TES	and   " +CRLF
	cQuery	+= "		e.D_E_L_E_T_	<> '*' LEFT JOIN " +CRLF

	cQuery	+= "		"+RETSQLNAME("SF2")+" d ON   " +CRLF
	cQuery	+= "		d.F2_DOC		=	a.D2_DOC	and   " +CRLF
	cQuery	+= "		d.F2_SERIE		=	a.D2_SERIE	and   " +CRLF
	cQuery	+= "		d.D_E_L_E_T_	<> '*' LEFT JOIN " +CRLF

	cQuery	+= "		"+RETSQLNAME("SC5")+" f ON   " +CRLF
	cQuery	+= "		f.C5_NUM		=	a.D2_PEDIDO	and   " +CRLF
	cQuery	+= "		f.D_E_L_E_T_	<> '*' LEFT JOIN " +CRLF

	cQuery	+= "		"+RETSQLNAME("SA1")+" b ON        " +CRLF
	cQuery	+= "		b.A1_COD		=	d.F2_CLIENTE	and  " +CRLF
	cQuery	+= "		b.A1_LOJA		=	d.F2_LOJA	AND " +CRLF
	cQuery	+= "		b.D_E_L_E_T_	<>	'*'				LEFT JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SB1")+" c ON " +CRLF
	cQuery	+= "		c.B1_COD		= a.D2_COD		AND " +CRLF
	cQuery	+= "		c.D_E_L_E_T_	<>	'*'		 " +CRLF
	cQuery	+= "	WHERE  " +CRLF
	cQuery	+= "		a.D_E_L_E_T_ <> '*'   " +CRLF
	cQuery	+= "	AND	c.B1_TIPO IN('PA','PI', 'SU', 'GG')  " +CRLF
	cQuery	+= "	AND	d.F2_EMISSAO	between '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
	IF MV_PAR10 = 1
		cQuery	+= "	AND e.F4_DUPLIC		= 'S'  " +CRLF
	ELSEIF MV_PAR10 = 2
		cQuery	+= "	AND e.F4_DUPLIC		= 'N'  " +CRLF
	ENDIF
	cQuery	+= "	AND f.C5_VEND1 between '"+MV_PAR03+"' and '"+MV_PAR04+"'  " +CRLF
	cQuery	+= "	AND f.C5_VEND2 between '"+MV_PAR05+"' and '"+MV_PAR06+"'  " +CRLF
	cQuery	+= "	AND f.C5_VEND3 between '"+MV_PAR07+"' and '"+MV_PAR08+"'  " +CRLF
	cQuery	+= "	GROUP BY  " +CRLF
	cQuery	+= "		b.A1_EST " +CRLF
 
	
	cQuery	+= "	UNION ALL  " +CRLF    
	
	cQuery	+= "	SELECT  " +CRLF
	cQuery	+= " 	D.A1_EST, " +CRLF
	cQuery	+= "    SUM(-D1_TOTAL+D1_VALDESC) C6_VALOR " +CRLF
	cQuery	+= "	FROM  " +CRLF
	cQuery	+= "		"+RETSQLNAME("SD1")+" A INNER JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SF4")+" B ON " +CRLF
	cQuery	+= "	D1_TES = F4_CODIGO INNER JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SB1")+" C ON " +CRLF
	cQuery	+= "	D1_COD = B1_COD INNER JOIN " +CRLF
	cQuery	+= "		"+RETSQLNAME("SA1")+" D ON " +CRLF
	cQuery	+= "	D1_FORNECE = A1_COD AND " +CRLF
	cQuery	+= "	D1_LOJA = A1_LOJA INNER JOIN " +CRLF 
	cQuery	+= "		"+RETSQLNAME("SF2")+" E ON " +CRLF
	cQuery	+= "	F2_DOC = D1_NFORI AND " +CRLF
	cQuery	+= "	F2_FILIAL = D1_FILIAL " +CRLF 
	cQuery	+= "	WHERE " +CRLF
	cQuery	+= "	D1_FILIAL = '01' AND " +CRLF
	cQuery	+= "	A.D_E_L_E_T_ = '' AND " +CRLF
	cQuery	+= "	F4_FILIAL = '01' AND " +CRLF
	cQuery	+= "	B.D_E_L_E_T_ = '' AND " +CRLF
	cQuery	+= "	B1_FILIAL = '01' AND " +CRLF
	cQuery	+= "	C.D_E_L_E_T_ = '' AND " +CRLF
	cQuery	+= "	B1_TIPO IN ('PI', 'PA', 'GG') AND  " +CRLF
	cQuery	+= "	D1_TIPO IN ('D') AND " +CRLF
	cQuery	+= "	D1_DTDIGIT	between '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
	IF MV_PAR10 = 1
		cQuery	+= "	AND F4_DUPLIC		= 'S'  " +CRLF
	ELSEIF MV_PAR10 = 2
		cQuery	+= "	AND F4_DUPLIC		= 'N'  " +CRLF
	ENDIF 
	cQuery	+= "	AND E.F2_VEND1 between '"+MV_PAR03+"' and '"+MV_PAR04+"'  " +CRLF
	cQuery	+= "	AND E.F2_VEND2 between '"+MV_PAR05+"' and '"+MV_PAR06+"'  " +CRLF        
	cQuery	+= "	AND E.F2_VEND3 between '"+MV_PAR07+"' and '"+MV_PAR08+"'  " +CRLF
	cQuery	+= "	GROUP BY  " +CRLF
	cQuery	+= "		D.A1_EST " +CRLF
 
	
ENDIF
TcQuery ChangeQuery(cQuery) New Alias "TRA"

dbSelectArea("TRA")

SetRegua(RecCount())

TRA->(dbGoTop())
While !TRA->(EOF())
	IF TRA->A1_EST $ cNord	// "AL BA CE MA PB PE PI RN SE"
		nNord	+= TRA->C6_VALOR             
		aAdd(aNord,{TRA->A1_EST,TRA->C6_VALOR})
	ELSEIF TRA->A1_EST $ cSude	// "ES MG RJ SP"
		nSude	+= TRA->C6_VALOR
		aAdd(aSude,{TRA->A1_EST,TRA->C6_VALOR})
	ELSEIF TRA->A1_EST $ cCoes	// "DF GO MS MT"
		nCoes	+= TRA->C6_VALOR
		aAdd(aCoes,{TRA->A1_EST,TRA->C6_VALOR})
	ELSEIF TRA->A1_EST $ cNort	// "AC AM PA RO RR TO"
		nNort	+= TRA->C6_VALOR
		aAdd(aNort,{TRA->A1_EST,TRA->C6_VALOR})
	ELSEIF TRA->A1_EST $ cSul		// "PR RS SC"
		nSul	+= TRA->C6_VALOR
		aAdd(aSul,{TRA->A1_EST,TRA->C6_VALOR})
	ELSEIF TRA->A1_EST $ cOutr		// "EX"
		nOutr	+= TRA->C6_VALOR
		aAdd(aOutr,{TRA->A1_EST,TRA->C6_VALOR})
	ENDIF
	TRA->(dbSkip())
EndDo
nTotal	:= nNord + nSude + nCoes + nNort + nSul + nOutr

If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

@nLin,001 Psay "Parâmetros do relatório:"
nLin++
@nLin,001 Psay "Data De ?            "+dtoc(mv_par01)
nLin++
@nLin,001 Psay "Data Ate ?           "+dtoc(mv_par02)
nLin++
@nLin,001 Psay "Vendedor De ?        "+mv_par03
nLin++
@nLin,001 Psay "Vendedor Ate ?       "+mv_par04
nLin++
@nLin,001 Psay "Supervisor Reg. De ? "+mv_par05
nLin++
@nLin,001 Psay "Supervisor Reg. Ate ?"+mv_par06
nLin++
@nLin,001 Psay "Supervisor Nac. De ? "+mv_par07
nLin++
@nLin,001 Psay "Supervisor Nac. Ate ?"+mv_par08
nLin++
@nLin,001 Psay "Tipo (1-Fat/2-Vendas)"+str(mv_par09)
nLin++
@nLin,001 Psay "Tes Gera Duplicata ? "+str(mv_par10)
nLin++
@nLin,000 Psay Replicate("_",80)
nLin++
nLin++


If !Empty(aNord)
	@nLin,001 Psay "NORDESTE "
	for i:=1 to len(aNord)
		nLin++
		@nLin,001 Psay aNord[i][1]
		@nLin,010 Psay PadR(Transform(aNord[i][2]	, "@E 999,999,999.99"),15)
		@nLin,027 Psay PadR(Transform(Round(aNord[i][2]/nTotal*100,2)	, "@E 999,999,999.99"),15)
		@nLin,042 Psay PadR(Transform(Round(aNord[i][2]/nNord*100,2)	, "@E 999,999,999.99"),15)
	next i
	nLin++
	@nLin,010 Psay PadR(Transform(nNord	, "@E 999,999,999.99"),15)
	@nLin,027 Psay PadR(Transform(Round(nNord/nTotal*100,2)	, "@E 999,999,999.99"),15)
	nLin++
	nLin++
Endif

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

If !Empty(aSude)
	@nLin,001 Psay "SUDESTE "
	for i:=1 to len(aSude)
		nLin++
		@nLin,001 Psay aSude[i][1]
		@nLin,010 Psay PadR(Transform(aSude[i][2]	, "@E 999,999,999.99"),15)
		@nLin,027 Psay PadR(Transform(Round(aSude[i][2]/nTotal*100,2)	, "@E 999,999,999.99"),15)
		@nLin,042 Psay PadR(Transform(Round(aSude[i][2]/nSude*100,2)	, "@E 999,999,999.99"),15)
	next i
	nLin++
	@nLin,010 Psay PadR(Transform(nSude	, "@E 999,999,999.99"),15)
	@nLin,027 Psay PadR(Transform(Round(nSude/nTotal*100,2)	, "@E 999,999,999.99"),15)
	nLin++
	nLin++
Endif

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

If !Empty(aCoes)
	@nLin,001 Psay "CENTRO OESTE "
	for i:=1 to len(aCoes)
		nLin++
		@nLin,001 Psay aCoes[i][1]
		@nLin,010 Psay PadR(Transform(aCoes[i][2]	, "@E 999,999,999.99"),15)
		@nLin,027 Psay PadR(Transform(Round(aCoes[i][2]/nTotal*100,2)	, "@E 999,999,999.99"),15)
		@nLin,042 Psay PadR(Transform(Round(aCoes[i][2]/nCoes*100,2)	, "@E 999,999,999.99"),15)
	next i
	nLin++
	@nLin,010 Psay PadR(Transform(nCoes	, "@E 999,999,999.99"),15)
	@nLin,027 Psay PadR(Transform(Round(nCoes/nTotal*100,2)	, "@E 999,999,999.99"),15)
	nLin++
	nLin++
Endif

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

If !Empty(aNort)
	@nLin,001 Psay "NORTE "
	for i:=1 to len(aNort)
		nLin++
		@nLin,001 Psay aNort[i][1]
		@nLin,010 Psay PadR(Transform(aNort[i][2]	, "@E 999,999,999.99"),15)
		@nLin,027 Psay PadR(Transform(Round(aNort[i][2]/nTotal*100,2)	, "@E 999,999,999.99"),15)
		@nLin,042 Psay PadR(Transform(Round(aNort[i][2]/nNort*100,2)	, "@E 999,999,999.99"),15)
	next i
	nLin++
	@nLin,010 Psay PadR(Transform(nNort	, "@E 999,999,999.99"),15)
	@nLin,027 Psay PadR(Transform(Round(nNort/nTotal*100,2)	, "@E 999,999,999.99"),15)
	nLin++
	nLin++
Endif

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

If !Empty(aSul)
	@nLin,001 Psay "SUL "
	for i:=1 to len(aSul)
		nLin++
		@nLin,001 Psay aSul[i][1]
		@nLin,010 Psay PadR(Transform(aSul[i][2]	, "@E 999,999,999.99"),15)
		@nLin,027 Psay PadR(Transform(Round(aSul[i][2]/nTotal*100,2)	, "@E 999,999,999.99"),15)
		@nLin,042 Psay PadR(Transform(Round(aSul[i][2]/nSul*100,2)	, "@E 999,999,999.99"),15)
	next i
	nLin++
	@nLin,010 Psay PadR(Transform(nSul	, "@E 999,999,999.99"),15)
	@nLin,027 Psay PadR(Transform(Round(nSul/nTotal*100,2)	, "@E 999,999,999.99"),15)
	nLin++
	nLin++
Endif

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

If !Empty(aOutr)
	@nLin,001 Psay "OUTROS "
	for i:=1 to len(aOutr)
		nLin++
		@nLin,001 Psay aOutr[i][1]
		@nLin,010 Psay PadR(Transform(aOutr[i][2]	, "@E 999,999,999.99"),15)
		@nLin,027 Psay PadR(Transform(Round(aOutr[i][2]/nTotal*100,2)	, "@E 999,999,999.99"),15)
		@nLin,042 Psay PadR(Transform(Round(aOutr[i][2]/nOutr*100,2)	, "@E 999,999,999.99"),15)
	next i
	nLin++
	@nLin,010 Psay PadR(Transform(nOutr	, "@E 999,999,999.99"),15)
	@nLin,027 Psay PadR(Transform(Round(nOutr/nTotal*100,2)	, "@E 999,999,999.99"),15)
	nLin++
	nLin++
	nLin++
Endif

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

If !Empty(aNord) .or. !Empty(aSude) .or. !Empty(aCoes) .or. !Empty(aNort) .or. !Empty(aSul) .or. !Empty(aOutr)

	@nLin,002 Psay "TOTAL GERAL "
	nLin++
	@nLin,010 Psay PadR(Transform(nTotal	, "@E 999,999,999.99"),15)
Else
	@nLin,002 Psay "NÃO HÁ DADOS PARA EXIBIR!!!"
Endif

TRA->(dbCloseArea())
                                           
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
                          

Return

Static Function ValidPerg

_aArea := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))

aRegs:={}
aAdd(aRegs,{cPerg,"01","Data De ? "    ,"mv_ch01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate ? "   ,"mv_ch02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Vendedor De ?        ","mv_ch03","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"04","Vendedor Ate ?       ","mv_ch04","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"05","Supervisor Reg. De ? ","mv_ch05","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"06","Supervisor Reg. Ate ?","mv_ch06","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"07","Supervisor Nac. De ? ","mv_ch07","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"08","Supervisor Nac. Ate ?","mv_ch08","C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"09","Tipo (1-Fat/2-Vendas)","mv_ch09","N",01,0,0,"C","","MV_PAR09","Faturamento","","","Vendas","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Tes Gera Duplicata ? ","mv_ch10","N",01,0,0,"C","","MV_PAR10","Sim","","","Não","","","Ambas","","","","","","","",""})


For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]
		MsUnlock()
		DbCommit()
	EndIf
Next

Return
