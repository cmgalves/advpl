#include "protheus.ch"
#INCLUDE "topconn.ch"

User Function FC010BTN()

If Paramixb[1] == 1
	Return "Plásticos MB"
ElseIf Paramixb[1] == 2
	Return "Personal. Plásticos MB"
Else
	If MsgYESNO(" Relatório = SIM " + Char(13) + Char(10) + " Cobrança = NÃO ", "Selecione a Operação")
		U_MBRFin03()
	Else
		U_MBCobranc()
	Endif
Endif

Return

User Function MBRFin03

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Cheques Recebidos por Período"
Local titulo         := "Relatorio de Tít. protestados, Cheques Devolvidos e Cheques não compensados"
Local nLin           := 9
Local cPict          := ""
Local Cabec1		 := "TITULO          EMISSAO    VENC REAL      VALOR           ACRESCIMO      DT. MOVIMENTO "
Local Cabec2		 := "Banco Agencia Conta      Cheque    Cliente  Nome Cliente         Emitente             Emissão    Vencimento               Valor        Vlr baixa       Saldo     Dev "
Local imprime        := .T.

Private m_pag        := 01
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "MBRFin03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private wnrel        := "FC010BTN"	// Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		 := "SE1"
Private cPerg		 := "FC010 "
Private xaAlias 	:= { {Alias()},{"SE1"},{"SEF"}}

//U_ufAmbiente(xaAlias, "S")


//	wnrel := SetPrint(cString,NomeProg,cperg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
wnrel := SetPrint("",NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	//U_ufAmbiente(xaAlias, "R")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	//U_ufAmbiente(xaAlias, "R")
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//U_ufAmbiente(xaAlias, "R")

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
lPri	:=	.T.
nProt	:= 0
nPAcres	:= 0
nDev	:= 0
nNComp	:= 0

nTitP	:= 0
nTitD	:= 0
NTitC	:= 0

//relatório de títulos protestados

cQuery	:= "SELECT a.*  " +CRLF
cQuery	+= "FROM "+RETSQLNAME("SE1")+" a " +CRLF
cQuery	+= "WHERE " +CRLF
cQuery	+= "	a.E1_CLIENTE = '"+SA1->A1_COD+"' " +CRLF
cQuery	+= "AND a.E1_LOJA = '"+SA1->A1_LOJA+"' " +CRLF
cQuery	+= "AND a.E1_SALDO > 0   " +CRLF
cQuery	+= "AND a.E1_SITUACA = 'F' " +CRLF
cQuery	+= "AND a.D_E_L_E_T_ = '' " +CRLF



TcQuery ChangeQuery(cQuery) New Alias "TRA"

TCSETFIELD( "TRA","E1_EMISSAO","D")
TCSETFIELD( "TRA","E1_VENCREA","D")
TCSETFIELD( "TRA","E1_MOVIMEN","D")

dbSelectArea("TRA")

TRA->(dbGoTop())


While !TRA->(EOF())
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,001 Psay TRA->E1_PREFIXO
	@nLin,005 Psay TRA->E1_NUM
	@nLin,015 Psay TRA->E1_PARCELA
	@nLin,018 Psay PadR(dtoc(TRA->E1_EMISSAO),10)
	@nLin,029 Psay PadR(dtoc(TRA->E1_VENCREA),10)
	@nLin,040 Psay PadR(Transform(TRA->E1_VLCRUZ, "@E 999,999,999.99"),14)
	@nLin,057 Psay PadR(Transform(TRA->E1_ACRESC, "@E 999,999,999.99"),14)
	@nLin,075 Psay PadR(dtoc(TRA->E1_MOVIMEN),10)
	
	nProt	+= TRA->E1_VLCRUZ
	nPAcres	+= TRA->E1_ACRESC
	nTitP	++
	nlin	++
	TRA->(dbSkip())
EndDo
TRA->(dbCloseArea())
If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif
//	nLin	++
@nLin,001 Psay "TOTAL TÍTULOS PROTESTADOS"
nLin	++
@nLin,005 Psay PadR(Transform(nTitP, "@E 9,999,999"),09)
@nLin,040 Psay PadR(Transform(nProt, "@E 999,999,999.99"),15)
@nLin,057 Psay PadR(Transform(nPAcres, "@E 999,999,999.99"),14)
@nLin,075 Psay PadR(Transform(nProt+nPAcres, "@E 999,999,999.99"),14)


nLin	++
nLin	++

//relatório de cheques devolvidos

cQuery	:= "SELECT a.*  " +CRLF
cQuery	+= "FROM "+RETSQLNAME("SE1")+" a " +CRLF
cQuery	+= "WHERE " +CRLF
cQuery	+= "	a.E1_CLIENTE = '"+SA1->A1_COD+"' " +CRLF
cQuery	+= "AND a.E1_LOJA = '"+SA1->A1_LOJA+"' " +CRLF
cQuery	+= "AND a.E1_SALDO > 0   " +CRLF
//	cQuery	+= "AND E1_PREFIXO = 'CH' " +CRLF
cQuery	+= "AND E1_TIPO = 'CH' " +CRLF
cQuery	+= "AND a.D_E_L_E_T_ = '' " +CRLF



TcQuery ChangeQuery(cQuery) New Alias "TRA"

TCSETFIELD("TRA","E1_EMISSAO","D")
TCSETFIELD("TRA","E1_VENCREA","D")
TCSETFIELD("TRA","E1_MOVIMEN","D")

dbSelectArea("TRA")

TRA->(dbGoTop())
While !TRA->(EOF())
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,001 Psay TRA->E1_PREFIXO
	@nLin,005 Psay TRA->E1_NUM
	@nLin,015 Psay TRA->E1_PARCELA
	@nLin,018 Psay PadR(dtoc(TRA->E1_EMISSAO),10)
	@nLin,029 Psay PadR(dtoc(TRA->E1_VENCREA),10)
	@nLin,040 Psay PadR(Transform(TRA->E1_VLCRUZ, "@E 999,999,999.99"),14)
	@nLin,057 Psay PadR(Transform(TRA->E1_ACRESC, "@E 999,999,999.99"),14)
	@nLin,075 Psay PadR(dtoc(TRA->E1_MOVIMEN),10)
	
	nDev	+= TRA->E1_SALDO
	nTitD	++
	nlin	++
	
	TRA->(dbSkip())
EndDo
TRA->(dbCloseArea())
nLin	++
@nLin,001 Psay "TOTAL CHEQUES DEVOLVIDOS EM ABERTO"
nLin	++
@nLin,005 Psay PadR(Transform(nTitD, "@E 9,999,999"),09)
@nLin,040 Psay PadR(Transform(nDev, "@E 999,999,999.99"),15)

nLin	++
nLin	++

//relatório de cheques não compensados
cQuery	:= "SELECT DISTINCT  " +CRLF
cQuery	+= "		a.EF_FILIAL,  " +CRLF
cQuery	+= "		a.EF_BANCO,  " +CRLF
cQuery	+= "		a.EF_AGENCIA,  " +CRLF
cQuery	+= "		a.EF_CONTA,  " +CRLF
cQuery	+= "		a.EF_NUM,  " +CRLF
cQuery	+= "		a.EF_VALOR, " +CRLF
cQuery	+= "		CASE WHEN EF_ALINEA1 <> '' THEN 1 ELSE 0 END EF_DEVOL, " +CRLF
cQuery	+= "		(select " +CRLF
cQuery	+= "			sum(b.EF_VALORBX) " +CRLF
cQuery	+= "			from SEF010 b " +CRLF
cQuery	+= "			where " +CRLF
cQuery	+= "				b.EF_BANCO = a.EF_BANCO " +CRLF
cQuery	+= "			and b.EF_AGENCIA = a.EF_AGENCIA " +CRLF
cQuery	+= "			and b.EF_CONTA = a.EF_CONTA " +CRLF
cQuery	+= "			and b.EF_NUM = a.EF_NUM " +CRLF
cQuery	+= "			and b.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "			) EF_VALORBX " +CRLF
cQuery	+= "FROM "+RETSQLNAME("SEF")+" a " +CRLF
cQuery	+= "WHERE " +CRLF
cQuery	+= "	D_E_L_E_T_ = '' " +CRLF
cQuery	+= "AND EF_DTCOMP = '' " +CRLF
cQuery	+= "AND EF_ALINEA2 = '' " +CRLF
cQuery	+= "AND EF_CLIENTE = '"+SA1->A1_COD+"' " +CRLF
cQuery	+= "AND EF_LOJACLI = '"+SA1->A1_LOJA+"' " +CRLF

//MemoWrite('MBRFin03.sql', cQuery)

TcQuery ChangeQuery(cQuery) New Alias "TRA"

dbSelectArea("TRA")

TRA->(dbGoTop())
While !TRA->(EOF())
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If lPri
		@nLin,001 Psay "Banco Agencia Conta      Cheque    Cliente  Nome Cliente         Emitente             Emissão    Vencimento               Valor        Vlr baixa       Saldo     Dev "
		lPri	:=	.F.
		nLin ++
		nLin ++
	EndIf
	
	@nLin,001 Psay "__________________________________________________________________________________________________________________________________________________________________________________"
	nLin ++
	
	SEF->(dbSeek(xFilial("SEF")+TRA->EF_BANCO+TRA->EF_AGENCIA+TRA->EF_CONTA+TRA->EF_NUM))
	
	@nLin,001 Psay TRA->EF_BANCO
	@nLin,007 Psay TRA->EF_AGENCIA
	@nLin,015 Psay TRA->EF_CONTA
	@nLin,026 Psay TRA->EF_NUM
	@nLin,037 Psay SA1->A1_COD
	@nLin,046 Psay substr(SA1->A1_NOME,1,20)
	@nLin,067 Psay substr(SEF->EF_EMITENT,1,20)
	
	@nLin,088 Psay PadR(dtoc(SEF->EF_DATA),10)
	@nLin,099 Psay PadR(dtoc(SEF->EF_VENCTO),15)
	@nLin,120 Psay PadR(Transform(TRA->EF_VALOR, "@E 9,999,999.99"),12)
	@nLin,133 Psay PadR(Transform(TRA->EF_VALORBX, "@E 9,999,999.99"),12)
	@nLin,146 Psay PadR(Transform(TRA->EF_VALOR-TRA->EF_VALORBX, "@E 9,999,999.99"),12)
	@nLin,163 Psay TRA->EF_DEVOL
	
	cQuery	:= "SELECT " +CRLF
	cQuery	+= "	E1_PREFIXO+'-'+E1_NUM+'-'+E1_PARCELA+'-'+E1_TIPO TIT,  " +CRLF
	cQuery	+= "	E1_CLIENTE+'-'+E1_LOJA +'-'+E1_NOMCLI CLI, " +CRLF
	cQuery	+= "	E1_VALOR VLR, EF_VALORBX VBX " +CRLF
	cQuery	+= "FROM  " +CRLF
	cQuery	+= "	" + RetSqlName('SE1') + " A INNER JOIN " +CRLF
	cQuery	+= "	" + RetSqlName('SEF') + " B ON " +CRLF
	cQuery	+= "	E1_PREFIXO = EF_PREFIXO AND " +CRLF
	cQuery	+= "	E1_NUM = EF_TITULO AND " +CRLF
	cQuery	+= "	E1_PARCELA = EF_PARCELA AND " +CRLF
	cQuery	+= "	E1_TIPO = EF_TIPO AND " +CRLF
	cQuery	+= "	E1_CLIENTE = EF_CLIENTE AND " +CRLF
	cQuery	+= "	E1_LOJA = EF_LOJACLI " +CRLF
	cQuery	+= "WHERE " +CRLF
	cQuery	+= "	EF_BANCO = '" + TRA->EF_BANCO + "' AND " +CRLF
	cQuery	+= "	EF_AGENCIA = '" + TRA->EF_AGENCIA + "' AND " +CRLF
	cQuery	+= "	EF_CONTA = '" + TRA->EF_CONTA + "' AND " +CRLF
	cQuery	+= "	EF_NUM = '" + TRA->EF_NUM + "' AND " +CRLF
	cQuery	+= "	EF_FILIAL = '" + xFilial('SEF') + "' AND " +CRLF
	cQuery	+= "	E1_FILIAL = '" + xFilial('SE1') + "' AND " +CRLF
	cQuery	+= "	A.D_E_L_E_T_ = '' AND " +CRLF
	cQuery	+= "	B.D_E_L_E_T_ = '' " +CRLF
	
	//	MemoWrite('titulos dentro do cheque.sql', cQuery)
	if select("XCHQ") > 0
		XCHQ->(dbclosearea())
	endif
	
	//Gera o Arquivo de Trabalho
	TcQuery StrTran(cQuery,CRLF,"") New Alias XCHQ
	
	dbSelectArea("XCHQ")
	XCHQ->(dbGoTop())
	
	nLin ++
	nLin ++
	
	@nLin,015 Psay "Títulos Vinculados "
	@nLin,042 Psay "Valor Original"
	@nLin,060 Psay "Usado do Cheque"
	@nLin,080 Psay "Cliente"
	nLin ++
	
	Do While !(XCHQ->(EOF()))
		
		If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,015 Psay XCHQ->TIT
		@nLin,042 Psay PadR(Transform(XCHQ->VLR, "@E 9,999,999.99"),12)
		@nLin,060 Psay PadR(Transform(XCHQ->VBX, "@E 9,999,999.99"),12)
		@nLin,080 Psay XCHQ->CLI
		
		nLin ++
		XCHQ->(dbSkip())
	EndDo
	nLin ++
	
	nNComp	+= TRA->EF_VALOR
	nTitC	++
	TRA->(dbSkip())
EndDo
@nLin,001 Psay "__________________________________________________________________________________________________________________________________________________________________________________"

TRA->(dbCloseArea())
nLin	++
@nLin,001 Psay "TOTAL CHEQUES NÃO COMPENSADOS"
nLin	++
@nLin,005 Psay PadR(Transform(nTitc, "@E 9,999,999"),09)
@nLin,040 Psay PadR(Transform(nNComp, "@E 999,999,999.99"),15)

nLin	++
nLin	++
nLin	++
nLin	++
nLin	++
@nLin,001 Psay "TOTAL GERAL (Protestos + Devolvidos + Não Compensados)"
nLin	++
@nLin,040 Psay PadR(Transform(nNComp+nDev+nProt, "@E 999,999,999.99"),15)


//EXIBE RELATÓRIO
SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
