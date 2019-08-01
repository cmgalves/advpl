#include "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "FileIO.ch"                

User Function MBRFAT07()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Vendas/Faturamento por Período"
Local titulo         := "Relatorio de Vendas/Faturamento por Período"
Local nLin           := 80
Local Cabec1		 := "REF             DESCRICAO                                      QUANT        VALOR  PREÇO MEDIO    QUANT       VALOR     LL MEDIO    LL TOTAL      MARKETING        DIRETORIA           INVESTIMENTO               ERRO "
Local Cabec2		 := "                                                               FATUR        FATUR                 VEND        VEND         %           R$       %         R$      %          R$       %            R$         %          R$"
Local imprime        := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "MBRFAT07" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MBRFAT06  "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MBRFAT07"	// Coloque aqui o nome do arquivo usado para impressao em disco
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
Local nOrdem
Private cNL     := Chr(13) + Chr(10)         // Caracteres p/ "Nova Linha"

If FErase(cPerg+".csv") == -1
	cCSV	:= AllTrim(cPerg)+StrTran(Time(),":","")+".csv"
Else
	cCSV	:= cPerg+".csv"
EndIF


If MV_PAR03 == 1
	nHandle := FCreate(cCSV, FC_NORMAL )

	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END) // Posiciona no fim do arquivo                        admin	
		FWrite(nHandle, "REF;DESCRICAO;QUANT FAT;VALOR FAT;PREÇO MEDIO;QUANT VEND; VALOR VEND;LL MEDIO %;LL TOTAL R$;MKT %;MKT R$;DIR %;DIR R$;INV %;INV R$;ERRO %;ERRO R$;AJUSTE %;AJUSTE R$ "+cNL ) // Insere texto no arquivo
	Endif
EndIf

cQuery	:= "SELECT " +CRLF
cQuery	+= "		a.D2_COD, " +CRLF
cQuery	+= "		b.B1_DESC, " +CRLF
cQuery	+= "		a.D2_QUANT, " +CRLF
cQuery	+= "		a.D2_TOTAL, " +CRLF
cQuery	+= "		c.C6_QTDVEN, " +CRLF
cQuery	+= "		c.C6_VALOR, " +CRLF
cQuery	+= "		ISNULL(c.C6_ZZVLL,0) C6_ZZVLL, " +CRLF
cQuery	+= "		0 C6_ZZPLL, " +CRLF
cQuery	+= "		isnull(c.C6_ZZVLDIR,0) C6_ZZVLDIR, " +CRLF
cQuery	+= "		isnull(c.C6_ZZVLIND,0) C6_ZZVLIND, " +CRLF
cQuery	+= "		isnull(c.C6_ZZVLINV,0) C6_ZZVLINV, " +CRLF
cQuery	+= "		isnull(c.C6_ZZVLMKT,0) C6_ZZVLMKT, " +CRLF
cQuery	+= "		isnull(c.C6_ZZMERRO,0) C6_ZZMERRO, " +CRLF
cQuery	+= "		isnull(c.C6_ZZAJUER,0) C6_ZZAJUER " +CRLF
cQuery	+= "	FROM   " +CRLF
cQuery	+= "		"+RETSQLNAME("SD2")+" a LEFT JOIN  " +CRLF
cQuery	+= "		"+RETSQLNAME("SB1")+" b ON  " +CRLF
cQuery	+= "		b.B1_COD		=	a.D2_COD	and  " +CRLF
cQuery	+= "		b.D_E_L_E_T_	=	' '			LEFT JOIN  " +CRLF
cQuery	+= "		"+RETSQLNAME("SC6")+" c ON  " +CRLF
cQuery	+= "		c.C6_NUM		=	a.D2_PEDIDO	and  " +CRLF
cQuery	+= "		c.C6_ITEM		=	a.D2_ITEMPV	and  " +CRLF
cQuery	+= "		c.D_E_L_E_T_	= ''  " +CRLF
cQuery	+= "	WHERE  " +CRLF
cQuery	+= "		a.D_E_L_E_T_  =  ' '  " +CRLF
cQuery	+= "	AND	a.D2_TP IN('PA','PI')  " +CRLF
cQuery	+= "	AND	a.D2_EMISSAO	between '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
cQuery	+= "	AND	a.D2_CLIENTE BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' " +CRLF
cQuery	+= "	AND	c.C6_ZZTPOPE IN ('01', '09', '12')  " +CRLF
cQuery	+= "	ORDER BY  " +CRLF
cQuery	+= "		a.D2_COD  " +CRLF

MemoWrite("mbrfat07.SQL",cQuery)

TcQuery cQuery New Alias "TRA"

dbSelectArea("TRA")

SetRegua(RecCount())

nTotQtd	:=	0
nTotVlr	:=	0
nTotVll	:=	0

nTotQtdV:=	0
nTotVlrV:=	0

nTotMkt	:=	0
nTotDir	:=	0
nTotInv	:=	0
nTotErr	:=	0
nTotAje	:=	0

TRA->(dbGoTop())
cCodigo	:= TRA->D2_COD
cDescr	:= TRA->B1_DESC

While !TRA->(EOF())

	nValMkt	:=	0
	nValDir	:=	0
	nValInv	:=	0
	nValErr	:=	0
	nValAje	:=	0

	nQuant	:=	0
	nValTot	:=	0
	nValMed	:=	0

	nQuantV	:=	0
	nValTotV:=	0

	nValLL	:=	0
	nPerLL	:=	0

	nPerMkt	:=	0
	nPerDir	:=	0
	nPerInv	:=	0
	nPerErr	:=	0
	nPerAje	:=	0

	While !TRA->(EOF()) .and. cCodigo = TRA->D2_COD
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
             
		If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		nValMkt	+=	TRA->C6_ZZVLMKT/100*TRA->D2_TOTAL
		nValDir	+=	TRA->C6_ZZVLDIR/100*TRA->D2_TOTAL
		nValInv	+=	TRA->C6_ZZVLINV/100*TRA->D2_TOTAL
		nValErr	+=	TRA->C6_ZZMERRO/100*TRA->D2_TOTAL
		nValAje	+=	TRA->C6_ZZAJUER/100*TRA->D2_TOTAL
		
		nQuant	+=	TRA->D2_QUANT
		nValTot	+=	TRA->D2_TOTAL
		
		nQuantV	+=	TRA->C6_QTDVEN
		nValTotV+=	TRA->C6_VALOR
		
		nValLL	+=	TRA->C6_ZZPLL/100*TRA->D2_TOTAL
		
		TRA->(dbSkip())
	EndDo
	
//	SB1->(dbSeek(xFilial("SB1")+TRA->D2_COD))
	nValMed	:=	nValTot	/	nQuant
	nPerLL	:=	nValLL / nValTot * 100

	nPerMkt	:=	nValMkt	/ nValTot * 100
	nPerDir	:=	nValDir	/ nValTot * 100
	nPerInv	:=	nValInv	/ nValTot * 100
	nPerErr	:=	nValErr	/ nValTot * 100
	nPerAje	:=	nValAje	/ nValTot * 100

	@nLin,001 Psay cCodigo
	@nLin,017 Psay substr(cDescr,1,40)
	@nLin,059 Psay PadR(Transform(nQuant	, "@E 9,999,999.99"),15)
	@nLin,070 Psay PadR(Transform(nValTot	, "@E 999,999,999.99"),15)
	@nLin,085 Psay PadR(Transform(nValMed	, "@E 9999.99"),7)

	@nLin,093 Psay PadR(Transform(nQuantV	, "@E 9,999,999.99"),15)
	@nLin,105 Psay PadR(Transform(nValTotV	, "@E 999,999,999.99"),15)

	@nLin,120 Psay PadR(Transform(nPerLL	, "@E 999.99"),6)
	@nLin,127 Psay PadR(Transform(nValLL	, "@E 99,999,999.99"),13)
	
	@nLin,141 Psay PadR(Transform(nPerMkt, "@E 999.99"),6)
	@nLin,148 Psay PadR(Transform(nValMkt, "@E 9,999,999.99"),12)
	
	@nLin,161 Psay PadR(Transform(nPerDir, "@E 999.99"),6)
	@nLin,168 Psay PadR(Transform(nValDir, "@E 9,999,999.99"),12)
	
	@nLin,181 Psay PadR(Transform(nPerInv, "@E 999.99"),6)
	@nLin,188 Psay PadR(Transform(nValInv, "@E 9,999,999.99"),12)
	
	@nLin,201 Psay PadR(Transform(nPerErr, "@E 999.99"),6)
	@nLin,208 Psay PadR(Transform(nValErr, "@E 9,999,999.99"),12)
	
	nTotQtd	+=	nQuant 
	nTotVlr	+=	nValTot
	nTotVll	+=	nValLL

	nTotQtdV+=	nQuantV 
	nTotVlrV+=	nValTotV
	
	nTotMkt	+=	nValMkt
	nTotDir	+=	nValDir
	nTotInv	+=	nValInv
	nTotErr	+=	nValErr
	nTotAje	+=	nValAje

	nlin++
	
	If MV_PAR03 == 1
		_cTxt := ""
  		_cTxt := 	cCodigo+";"
        _cTxt += 	cDescr+";"+;
					Transform(nQuant	, "@E 9,999,999.99")+";"+;
					Transform(nValTot	, "@E 999,999,999.99")+";"+;
					Transform(nValMed	, "@E 999,999.9999")+";"+;
					Transform(nQuantV	, "@E 9,999,999.99")+";"+;
					Transform(nValTotV	, "@E 999,999,999.99")+";"+;
					Transform(nPerLL	, "@E 999,999.9999")+";"+;
					Transform(nValLL	, "@E 99,999,999.9999")+";"+;
					Transform(nPerMkt	, "@E 999.99")+";"+;
					Transform(nValMkt	, "@E 9,999,999.99")+";"+;
					Transform(nPerDir	, "@E 999.99")+";"+;
					Transform(nValDir	, "@E 9,999,999.99")+";"+;
					Transform(nPerInv	, "@E 999.99")+";"+;
					Transform(nValInv	, "@E 9,999,999.99")+";"+;
					Transform(nPerErr	, "@E 999.99")+";"+;
					Transform(nValErr	, "@E 9,999,999.99")+";"+;
					Transform(nPerAje	, "@E 999.99")+";"+;
					Transform(nValAje	, "@E 9,999,999.99")
		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
 		FWrite(nHandle, _cTxt+cNL)
 	EndIF

   	cCodigo := TRA->D2_COD
   	cDescr	:= TRA->B1_DESC
EndDo
nlin++
@nLin,002 Psay "TOTAL "
@nLin,059 Psay PadR(Transform(nTotQtd	, "@E 9,999,999.99"),12)
@nLin,093 Psay PadR(Transform(nTotQtdV, "@E 9,999,999.99"),12)
@nLin,120 Psay PadR(Transform(nTotVll/nTotVlr*100, "@E 999.99"),6)
@nLin,141 Psay PadR(Transform(nTotMkt/nTotVlr*100, "@E 999.99"),6)
@nLin,161 Psay PadR(Transform(nTotDir/nTotVlr*100, "@E 999.99"),6)
@nLin,181 Psay PadR(Transform(nTotInv/nTotVlr*100, "@E 999.99"),6)
@nLin,201 Psay PadR(Transform(nTotErr/nTotVlr*100, "@E 999.99"),6)
nlin++
@nLin,071 Psay PadR(Transform(nTotVlr	, "@E 999,999,999.99"),14)
@nLin,085 Psay PadR(Transform(nTotVlr/nTotQtd	, "@E 9,999.9999"),10)
@nLin,105 Psay PadR(Transform(nTotVlrV, "@E 999,999,999.99"),14)
@nLin,127 Psay PadR(Transform(nTotVll, "@E 999,999,999.99"),14)
@nLin,148 Psay PadR(Transform(nTotMkt, "@E 9,999,999.99"),12)
@nLin,168 Psay PadR(Transform(nTotDir, "@E 9,999,999.99"),12)
@nLin,188 Psay PadR(Transform(nTotInv, "@E 9,999,999.99"),12)
@nLin,208 Psay PadR(Transform(nTotErr, "@E 9,999,999.99"),12)

	If MV_PAR03 == 1
		_cTxt := ""
  		_cTxt := 	";"
        _cTxt += 	"TOTAL;"+;
					Transform(nTotQtd, "@E 9,999,999.99")+";"+;
					Transform(nTotVlr, "@E 999,999,999.99")+";"+;
					Transform(nTotVlr/nTotQtd, "@E 999,999.9999")+";"+;
					Transform(nTotQtdV, "@E 9,999,999.99")+";"+;
					Transform(nTotVlrV, "@E 999,999,999.99")+";"+;
					Transform(nTotVll/nTotVlr*100, "@E 999,999.9999")+";"+;
					Transform(nTotVll, "@E 99,999,999.9999")+";"+;
					Transform(nTotMkt/nTotVlr*100, "@E 999.99")+";"+;
					Transform(nTotMkt, "@E 9,999,999.99")+";"+;
					Transform(nTotDir/nTotVlr*100, "@E 999.99")+";"+;
					Transform(nTotDir, "@E 9,999,999.99")+";"+;
					Transform(nTotInv/nTotVlr*100, "@E 999.99")+";"+;
					Transform(nTotInv, "@E 9,999,999.99")+";"+;
					Transform(nTotErr/nTotVlr*100, "@E 999.99")+";"+;
					Transform(nTotErr, "@E 9,999,999.99")+";"+;
					Transform(nTotAje/nTotVlr*100, "@E 999.99")+";"+;
					Transform(nTotAje, "@E 9,999,999.99")
		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
 		FWrite(nHandle, _cTxt+cNL)
 	EndIF

TRA->(dbCloseArea())
                                           
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
                          
If MV_PAR03 == 1
   FClose(nHandle)
   u_fOpenXLS(cCSV) 
EndIf 

Return

Static Function ValidPerg

_aArea := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))

aRegs:={}
aAdd(aRegs,{cPerg,"01","Data De ? "    ,"mv_ch01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate ? "   ,"mv_ch02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Gera Planilha?","mv_ch03","N",01,0,0,"C","","MV_PAR03","Sim","","","Não","","","","","","","","","","",""})

//aAdd(aRegs,{cPerg,"03","Cliente de?"   ,"mv_ch03","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA1"})
//aAdd(aRegs,{cPerg,"04","Loja de?"      ,"mv_ch04","C",02,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"05","Cliente ate?"  ,"mv_ch05","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SA1"})
//aAdd(aRegs,{cPerg,"06","Loja ate?"     ,"mv_ch06","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""})

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
