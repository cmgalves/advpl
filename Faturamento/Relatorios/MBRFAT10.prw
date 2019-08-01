#include "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "FileIO.ch"                

User Function MBRFAT10()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Vendas por Vendedor por Produto"
Local cPict          := ""
Local titulo         := "Vendas x Vend x Prod"
Local nLin           := 80
Local Cabec1		 := "REF             DESCRICAO                                        QUANT        VALOR  PREÇO MEDIO   QUANT       VALOR      LL MEDIO         LL TOTAL         MARKETING        DIRETORIA        INVESTIMENTO            ERRO "
Local Cabec2		 := "                                                                 VEND         VEND      VENDIDO     FAT         FAT           %                R$         %       R$        %       R$       %         R$         %         R$"
Local imprime        := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "MBRFAT10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MBRFAT10  "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MBRFAT10"	// Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		 := "SD2"
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
Private cNL     := Chr(13) + Chr(10)         // Caracteres p/ "Nova Linha"

titulo:=alltrim(titulo)+" ("+dtoc(MV_PAR01)+" - "+dtoc(MV_PAR02)+") "
//If FErase(cPerg+".csv") == -1
//	cCSV	:= AllTrim(cPerg)+StrTran(Time(),":","")+".csv"
//Else
//	cCSV	:= cPerg+".csv"
//EndIF


//If MV_PAR09 == 1
//	nHandle := FCreate(cCSV, FC_NORMAL )

//	If nHandle == -1
//		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
//	Else
//		FSeek(nHandle, 0, FS_END) // Posiciona no fim do arquivo                        admin	
//		FWrite(nHandle, "REF;DESCRICAO;QUANT;VALOR;PREÇO MEDIO;LL MEDIO %;LL TOTAL R$;MKT %;MKT R$;DIR %;DIR R$;INV %;INV R$;ERRO %;ERRO R$ "+cNL ) // Insere texto no arquivo
//	Endif
//EndIf

cQuery	:= "SELECT " +CRLF
cQuery	+= "		a.C6_NUM, " +CRLF
cQuery	+= "		d.C5_VEND1, " +CRLF
cQuery	+= "		e.A3_NOME,  " +CRLF
cQuery	+= "		a.C6_PRODUTO, " +CRLF
cQuery	+= "		b.B1_DESC, " +CRLF
cQuery	+= "		a.C6_QTDVEN, " +CRLF
cQuery	+= "		a.C6_VALOR, " +CRLF

cQuery	+= "		(SELECT SUM(g.D2_QUANT) " +CRLF
cQuery	+= "			FROM "+RETSQLNAME("SD2")+" g " +CRLF
cQuery	+= "			WHERE " +CRLF
cQuery	+= "				g.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "				AND a.C6_PRODUTO = g.D2_COD " +CRLF
cQuery	+= "				AND a.C6_NUM = g.D2_PEDIDO " +CRLF
cQuery	+= "				AND g.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
cQuery	+= "		) D2_QUANT, " +CRLF
cQuery	+= "		(SELECT SUM(g.D2_TOTAL) " +CRLF
cQuery	+= "			FROM "+RETSQLNAME("SD2")+" g " +CRLF
cQuery	+= "			WHERE " +CRLF
cQuery	+= "				g.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "				AND a.C6_PRODUTO = g.D2_COD " +CRLF
cQuery	+= "				AND a.C6_NUM = g.D2_PEDIDO " +CRLF
cQuery	+= "				AND g.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
cQuery	+= "		) D2_VALOR, " +CRLF

cQuery	+= "		ISNULL(a.C6_ZZVLL,0) C6_ZZVLL, " +CRLF
cQuery	+= "		0 C6_ZZPLL, " +CRLF
cQuery	+= "		ISNULL(a.C6_ZZPLLM,0) C6_ZZPLLM, " +CRLF
cQuery	+= "		isnull(a.C6_ZZVLDIR,0) C6_ZZVLDIR, " +CRLF
cQuery	+= "		isnull(a.C6_ZZVLIND,0) C6_ZZVLIND, " +CRLF
cQuery	+= "		isnull(a.C6_ZZVLINV,0) C6_ZZVLINV, " +CRLF
cQuery	+= "		isnull(a.C6_ZZVLMKT,0) C6_ZZVLMKT, " +CRLF
cQuery	+= "		isnull(a.C6_ZZMERRO,0) C6_ZZMERRO " +CRLF
cQuery	+= "	FROM   " +CRLF
cQuery	+= "		"+RETSQLNAME("SC6")+" a LEFT JOIN  " +CRLF
cQuery	+= "		"+RETSQLNAME("SF4")+" f ON   " +CRLF
cQuery	+= "		f.F4_CODIGO		=	a.C6_TES	and   " +CRLF
cQuery	+= "		f.D_E_L_E_T_	<> '*' LEFT JOIN" +CRLF
cQuery	+= "		"+RETSQLNAME("SB1")+" b ON  " +CRLF
cQuery	+= "		b.B1_COD		=	a.C6_PRODUTO	and  " +CRLF
cQuery	+= "		b.D_E_L_E_T_	<>	'*'			LEFT JOIN  " +CRLF
cQuery	+= "		"+RETSQLNAME("SC5")+" d ON  " +CRLF
cQuery	+= "		d.C5_NUM		=	a.C6_NUM	and " +CRLF  
cQuery	+= "		d.D_E_L_E_T_	<> '*'  LEFT JOIN  " +CRLF
cQuery	+= "		"+RETSQLNAME("SA3")+" e ON  " +CRLF
cQuery	+= "		e.A3_COD = d.C5_VEND1 and  " +CRLF
cQuery	+= "		e.D_E_L_E_T_ = ''  " +CRLF
cQuery	+= "	WHERE  " +CRLF
cQuery	+= "		a.D_E_L_E_T_ <> '*'  " +CRLF
IF MV_PAR09 = 1
	cQuery	+= "	and	f.F4_DUPLIC		= 'S'  " +CRLF
ELSEIF MV_PAR09 = 2
	cQuery	+= "	and	f.F4_DUPLIC		= 'N'  " +CRLF
ENDIF
cQuery	+= "	AND	d.C5_EMISSAO	between '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
cQuery	+= "	AND d.C5_VEND1 between '"+MV_PAR03+"' and '"+MV_PAR04+"'  " +CRLF
cQuery	+= "	AND d.C5_VEND2 between '"+MV_PAR05+"' and '"+MV_PAR06+"'  " +CRLF
cQuery	+= "	AND d.C5_VEND3 between '"+MV_PAR07+"' and '"+MV_PAR08+"'  " +CRLF
cQuery	+= "	AND	b.B1_TIPO IN('PA','PI')  " +CRLF
cQuery	+= "	ORDER BY  " +CRLF
cQuery	+= "		d.C5_VEND1, a.C6_PRODUTO  " +CRLF

//MemoWrite("C:\mbrfat07.txt",cQuery)

TcQuery cQuery New Alias "TRA"

dbSelectArea("TRA")

SetRegua(RecCount())

nTotQtd	:=	0
nTotVlr	:=	0
nTotQtdF:=	0
nTotVlrF:=	0

nTotVll	:=	0

nTotMkt	:=	0
nTotDir	:=	0
nTotInv	:=	0
nTotErr	:=	0

nTVQtd	:=	0
nTVVlr	:=	0

nTVQtdF	:=	0
nTVVlrF	:=	0

nTVLL	:=	0
nTVMkt	:=	0
nTVDir	:=	0
nTVInv	:=	0
nTVErr	:=	0


TRA->(dbGoTop())
cCodigo	:= TRA->C6_PRODUTO
cDescr	:= TRA->B1_DESC
cVend1	:= TRA->C5_VEND1

If !TRA->(EOF())
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	@nLin,001 Psay alltrim(TRA->C5_VEND1)+" - "+TRA->A3_NOME
	nLin++
	nLin++
Endif
While !TRA->(EOF())

	nValMkt	:=	0
	nValDir	:=	0
	nValInv	:=	0
	nValErr	:=	0

	nQuant	:=	0
	nQuantF	:=	0
	nValTot	:=	0
	nValTotF:=	0
	nValMed	:=	0

	nValLL	:=	0
	nPerLL	:=	0

	nPerMkt	:=	0
	nPerDir	:=	0
	nPerInv	:=	0
	nPerErr	:=	0
	If !cVend1 = TRA->C5_VEND1
		nLin++
		@nLin,001 Psay "TOTAL DO VENDEDOR : "
		@nLin,059 Psay PadR(Transform(nTVQtd	, "@E 9,999,999.99"),12)
		@nLin,093 Psay PadR(Transform(nTVQtdF	, "@E 9,999,999.99"),12)
		@nLin,125 Psay PadR(Transform(Round(nTVLL / nTVVlr * 100,4)	, "@E 999.9999"),8)
		@nLin,151 Psay PadR(Transform(Round(nTVMkt	/ nTVVlr * 100,2), "@E 9999.99"),7)
		@nLin,169 Psay PadR(Transform(Round(nTVDir	/ nTVVlr * 100,2), "@E 9999.99"),7)
		@nLin,187 Psay PadR(Transform(Round(nTVInv	/ nTVVlr * 100,2), "@E 9999.99"),7)
		@nLin,205 Psay PadR(Transform(Round(nTVErr	/ nTVVlr * 100,2), "@E 9999.99"),7)
		
		nLin++
		
		@nLin,071 Psay PadR(Transform(nTVVlr	, "@E 999,999,999.99"),14)
		@nLin,085 Psay PadR(Transform(Round(nTVVlr/nTVQtd,4) , "@E 9,999.9999"),10)
		@nLin,105 Psay PadR(Transform(nTVVlrF	, "@E 999,999,999.99"),14)
		@nLin,134 Psay PadR(Transform(nTVLL	, "@E 99,999,999.9999"),15)
		@nLin,158 Psay PadR(Transform(nTVMkt, "@E 999,999.99"),10)
		@nLin,176 Psay PadR(Transform(nTVDir, "@E 999,999.99"),10)
		@nLin,194 Psay PadR(Transform(nTVInv, "@E 999,999.99"),10)
		@nLin,210 Psay PadR(Transform(nTVErr, "@E 999,999.99"),10)
		nLin++
		@nLin,000 Psay Replicate("_",220)
		nLin++

		@nLin,001 Psay alltrim(TRA->C5_VEND1)+" - "+TRA->A3_NOME
		nLin++
		nLin++
		nTVQtd	:=	0
		nTVVlr	:=	0

		nTVQtdF	:=	0
		nTVVlrF	:=	0

		nTVLL	:=	0
		nTVMkt	:=	0
		nTVDir	:=	0
		nTVInv	:=	0
		nTVErr	:=	0
		cVend1	:= TRA->C5_VEND1
	Endif

	While !TRA->(EOF()) .and. cCodigo = TRA->C6_PRODUTO .and. cVend1 = TRA->C5_VEND1
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
             
		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		nValMkt	+=	TRA->C6_ZZVLMKT/100*TRA->C6_VALOR
		nValDir	+=	TRA->C6_ZZVLDIR/100*TRA->C6_VALOR
		nValInv	+=	TRA->C6_ZZVLINV/100*TRA->C6_VALOR
		nValErr	+=	TRA->C6_ZZMERRO/100*TRA->C6_VALOR
		
		nQuant	+=	TRA->C6_QTDVEN
		nValTot	+=	TRA->C6_VALOR

		nQuantF	+=	TRA->D2_QUANT
		nValTotF+=	TRA->D2_VALOR
		
		nValLL	+=	TRA->C6_ZZPLL/100*TRA->C6_VALOR
		
		TRA->(dbSkip())
	EndDo
	
//	SB1->(dbSeek(xFilial("SB1")+TRA->D2_COD))
	nValMed	:=	nValTot	/	nQuant
	nPerLL	:=	nValLL / nValTot * 100

	nPerMkt	:=	nValMkt	/ nValTot * 100
	nPerDir	:=	nValDir	/ nValTot * 100
	nPerInv	:=	nValInv	/ nValTot * 100
	nPerErr	:=	nValErr	/ nValTot * 100

	nTVQtd	+=	nQuant
	nTVVlr	+=	nValTot
	
	nTVQtdF	+=	nQuantF
	nTVVlrF	+=	nValTotF

	nTVLL	+=	nValLL
	nTVMkt	+=	nValMkt
	nTVDir	+=	nValDir
	nTVInv	+=	nValInv
	nTVErr	+=	nValErr

	@nLin,001 Psay cCodigo
	@nLin,017 Psay cDescr

	@nLin,059 Psay PadR(Transform(nQuant	, "@E 9,999,999.99"),12)
	@nLin,071 Psay PadR(Transform(nValTot	, "@E 999,999,999.99"),14)
	@nLin,085 Psay PadR(Transform(nValMed	, "@E 9,999.9999"),10)
	
	@nLin,093 Psay PadR(Transform(nQuantF	, "@E 9,999,999.99"),12)
	@nLin,105 Psay PadR(Transform(nValTotF	, "@E 999,999,999.99"),14)

	@nLin,125 Psay PadR(Transform(nPerLL	, "@E 999.9999"),8)
	@nLin,134 Psay PadR(Transform(nValLL	, "@E 99,999,999.9999"),15)
	
	@nLin,151 Psay PadR(Transform(nPerMkt, "@E 9999.99"),7)
	@nLin,158 Psay PadR(Transform(nValMkt, "@E 999,999.99"),10)
	
	@nLin,169 Psay PadR(Transform(nPerDir, "@E 9999.99"),7)
	@nLin,176 Psay PadR(Transform(nValDir, "@E 999,999.99"),10)
	
	@nLin,187 Psay PadR(Transform(nPerInv, "@E 9999.99"),7)
	@nLin,194 Psay PadR(Transform(nValInv, "@E 999,999.99"),10)
	
	@nLin,205 Psay PadR(Transform(nPerErr, "@E 9999.99"),7)
	@nLin,212 Psay PadR(Transform(nValErr, "@E 999,999.99"),10)
	
	nTotQtd	+=	nQuant 
	nTotVlr	+=	nValTot

	nTotQtdF+=	nQuantF 
	nTotVlrF+=	nValTotF
	
	nTotVll	+=	nValLL
	
	nTotMkt	+=	nValMkt
	nTotDir	+=	nValDir
	nTotInv	+=	nValInv
	nTotErr	+=	nValErr

	nlin++
	
//	If MV_PAR09 == 1
//		_cTxt := ""
//  		_cTxt := 	cCodigo+";"
//        _cTxt += 	cDescr+";"+;
//					Transform(nQuant	, "@E 9,999,999.99")+";"+;
//					Transform(nValTot	, "@E 999,999,999.99")+";"+;
//					Transform(nValMed	, "@E 999,999.9999")+";"+;
//  					Transform(nPerLL	, "@E 999,999.9999")+";"+;
//					Transform(nValLL	, "@E 99,999,999.9999")+";"+;
//					Transform(nPerMkt	, "@E 999.99")+";"+;
//					Transform(nValMkt	, "@E 9,999,999.99")+";"+;
//					Transform(nPerDir	, "@E 999.99")+";"+;
//					Transform(nValDir	, "@E 9,999,999.99")+";"+;
//					Transform(nPerInv	, "@E 999.99")+";"+;
//					Transform(nValInv	, "@E 9,999,999.99")+";"+;
//					Transform(nPerErr	, "@E 999.99")+";"+;
//					Transform(nValErr	, "@E 9,999,999.99")
//		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
// 		FWrite(nHandle, _cTxt+cNL)
// 	EndIF

   	cCodigo := TRA->C6_PRODUTO
   	cDescr	:= TRA->B1_DESC
EndDo
If !cVend1 = TRA->C5_VEND1
	nLin++
/*	@nLin,001 Psay "TOTAL DO VENDEDOR : "
	@nLin,059 Psay PadR(Transform(nTVQtd	, "@E 9,999,999.99"),12)
	@nLin,071 Psay PadR(Transform(nTVVlr	, "@E 999,999,999.99"),14)
	@nLin,085 Psay PadR(Transform(Round(nTVVlr/nTVQtd,4) , "@E 9,999.9999"),10)

	@nLin,093 Psay PadR(Transform(nTVQtdF	, "@E 9,999,999.99"),12)
	@nLin,105 Psay PadR(Transform(nTVVlrF	, "@E 999,999,999.99"),14)

	@nLin,125 Psay PadR(Transform(Round(nTVLL / nTVVlr * 100,4)	, "@E 999.9999"),8)
	@nLin,134 Psay PadR(Transform(nTVLL	, "@E 99,999,999.9999"),15)
	
	@nLin,151 Psay PadR(Transform(Round(nTVMkt	/ nTVVlr * 100,2), "@E 9999.99"),7)
	@nLin,158 Psay PadR(Transform(nTVMkt, "@E 999,999.99"),12)
	
	@nLin,169 Psay PadR(Transform(Round(nTVDir	/ nTVVlr * 100,2), "@E 9999.99"),7)
	@nLin,176 Psay PadR(Transform(nTVDir, "@E 999,999.99"),12)
	
	@nLin,187 Psay PadR(Transform(Round(nTVInv	/ nTVVlr * 100,2), "@E 9999.99"),7)
	@nLin,194 Psay PadR(Transform(nTVInv, "@E 999,999.99"),12)
	
	@nLin,205 Psay PadR(Transform(Round(nTVErr	/ nTVVlr * 100,2), "@E 9999.99"),7)
	@nLin,212 Psay PadR(Transform(nTVErr, "@E 999,999.99"),10)
*/
		@nLin,001 Psay "TOTAL DO VENDEDOR : "
		@nLin,059 Psay PadR(Transform(nTVQtd	, "@E 9,999,999.99"),12)
		@nLin,093 Psay PadR(Transform(nTVQtdF	, "@E 9,999,999.99"),12)
		@nLin,125 Psay PadR(Transform(Round(nTVLL / nTVVlr * 100,4)	, "@E 999.9999"),8)
		@nLin,151 Psay PadR(Transform(Round(nTVMkt	/ nTVVlr * 100,2), "@E 9999.99"),7)
		@nLin,169 Psay PadR(Transform(Round(nTVDir	/ nTVVlr * 100,2), "@E 9999.99"),7)
		@nLin,187 Psay PadR(Transform(Round(nTVInv	/ nTVVlr * 100,2), "@E 9999.99"),7)
		@nLin,205 Psay PadR(Transform(Round(nTVErr	/ nTVVlr * 100,2), "@E 9999.99"),7)
		
		nLin++
		
		@nLin,071 Psay PadR(Transform(nTVVlr	, "@E 999,999,999.99"),14)
		@nLin,085 Psay PadR(Transform(Round(nTVVlr/nTVQtd,4) , "@E 9,999.9999"),10)
		@nLin,105 Psay PadR(Transform(nTVVlrF	, "@E 999,999,999.99"),14)
		@nLin,134 Psay PadR(Transform(nTVLL	, "@E 99,999,999.9999"),15)
		@nLin,158 Psay PadR(Transform(nTVMkt, "@E 999,999.99"),10)
		@nLin,176 Psay PadR(Transform(nTVDir, "@E 999,999.99"),10)
		@nLin,194 Psay PadR(Transform(nTVInv, "@E 999,999.99"),10)
		@nLin,210 Psay PadR(Transform(nTVErr, "@E 999,999.99"),10)

	nLin++
	@nLin,000 Psay Replicate("_",220)
	nLin++

Endif

nlin++

@nLin,002 Psay "TOTAL GERAL "
@nLin,059 Psay PadR(Transform(nTotQtd	, "@E 9,999,999.99"),12)
@nLin,093 Psay PadR(Transform(nTotQtdF	, "@E 9,999,999.99"),12)
@nLin,125 Psay PadR(Transform(nTotVll/nTotVlr*100, "@E 999.99"),15)
@nLin,151 Psay PadR(Transform(nTotMkt/nTotVlr*100, "@E 999.99"),6)
@nLin,169 Psay PadR(Transform(nTotDir/nTotVlr*100, "@E 999.99"),6)
@nLin,187 Psay PadR(Transform(nTotInv/nTotVlr*100, "@E 999.99"),6)
@nLin,205 Psay PadR(Transform(nTotErr/nTotVlr*100, "@E 999.99"),6)
nLin++
@nLin,071 Psay PadR(Transform(nTotVlr	, "@E 999,999,999.99"),14)
@nLin,085 Psay PadR(Transform(nTotVlr/nTotQtd	, "@E 9,999.9999"),12)
@nLin,105 Psay PadR(Transform(nTotVlrF	, "@E 999,999,999.99"),14)
@nLin,134 Psay PadR(Transform(nTotVll, "@E 999,999,999.99"),15)
@nLin,158 Psay PadR(Transform(nTotMkt, "@E 9,999,999.99"),12)
@nLin,176 Psay PadR(Transform(nTotDir, "@E 9,999,999.99"),12)
@nLin,194 Psay PadR(Transform(nTotInv, "@E 9,999,999.99"),12)
@nLin,208 Psay PadR(Transform(nTotErr, "@E 9,999,999.99"),12)

TRA->(dbCloseArea())
                                           
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
                          
//If MV_PAR09 == 1
//   FClose(nHandle)
//   u_fOpenXLS(cCSV) 
//EndIf 

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
aAdd(aRegs,{cPerg,"09","Tes Gera Duplicata ? ","mv_ch09","N",01,0,0,"C","","MV_PAR09","Sim","","","Não","","","Ambas","","","","","","","",""})
//aAdd(aRegs,{cPerg,"09","Gera Planilha?"       ,"mv_ch09","N",01,0,0,"C","","MV_PAR09","Sim","","","Não","","","","","","","","","","",""})


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
