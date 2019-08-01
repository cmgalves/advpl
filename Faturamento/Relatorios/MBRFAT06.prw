#include "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "FileIO.ch"                

User Function MBRFAT06()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Vendas/Faturamento por Período"
Local cPict          := ""
Local titulo         := "Relatorio de Vendas/Faturamento por Período"
Local nLin           := 80
Local Cabec1		 := "REF             DESCRICAO                                            QUANT          VALOR       PREÇO MEDIO    LL MEDIO         LL TOTAL         MARKETING        DIRETORIA           INVESTIMENTO             ERRO "
Local Cabec2		 := "                                                                                                                    %                R$         %       R$        %       R$          %         R$         %          R$"
Local imprime        := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "MBRFAT06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MBRFAT06  "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MBRFAT06"	// Coloque aqui o nome do arquivo usado para impressao em disco
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
		FWrite(nHandle, "REF;DESCRICAO;QUANT;VALOR;PREÇO MEDIO;LL MEDIO %;LL TOTAL R$;MKT %;MKT R$;DIR %;DIR R$;INV %;INV R$;ERRO %;ERRO R$ "+cNL ) // Insere texto no arquivo
	Endif
EndIf

cQuery	:= "SELECT " +CRLF
cQuery	+= "	a.D2_COD,  " +CRLF
cQuery	+= "	b.B1_DESC,  " +CRLF
cQuery	+= "	sum(a.D2_QUANT) AS D2_QUANT,  " +CRLF
cQuery	+= "	sum(a.D2_TOTAL) AS D2_TOTAL,  " +CRLF
cQuery	+= "	sum(c.C6_QTDVEN) AS C6_QUANT,  " +CRLF
cQuery	+= "	sum(c.C6_VALOR) AS C6_VALOR,  " +CRLF
cQuery	+= "	sum(a.D2_TOTAL)/sum(a.D2_QUANT) as D2_MEDIO, " +CRLF
cQuery	+= "	sum(c.C6_ZZVLL) AS C6_ZZVLL,  " +CRLF
cQuery	+= "	sum(c.C6_ZZVLL)/sum(a.D2_TOTAL)*100 AS C6_ZZPLL " +CRLF
cQuery	+= "FROM  " +CRLF
cQuery	+= "	"+RETSQLNAME("SD2")+" a LEFT JOIN " +CRLF
cQuery	+= "	"+RETSQLNAME("SB1")+" b ON " +CRLF
cQuery	+= "	b.B1_COD		=	a.D2_COD	and " +CRLF
cQuery	+= "	b.D_E_L_E_T_	<>	'*'			LEFT JOIN " +CRLF
cQuery	+= "	"+RETSQLNAME("SC6")+" c ON " +CRLF
cQuery	+= "	c.C6_NUM		=	a.D2_PEDIDO	and " +CRLF
cQuery	+= "	c.C6_ITEM		=	a.D2_ITEMPV	and " +CRLF
cQuery	+= "	c.D_E_L_E_T_	<> '*' " +CRLF
cQuery	+= "WHERE " +CRLF
cQuery	+= "	a.D_E_L_E_T_ <> '*' " +CRLF
cQuery	+= "AND	a.D2_TP IN('PA','PI') " +CRLF
cQuery	+= "and	a.D2_EMISSAO	between '"+dtos(MV_PAR01)+"' and '"+dtos(MV_PAR02)+"' " +CRLF
cQuery	+= "GROUP BY " +CRLF
cQuery	+= "	a.D2_COD,  " +CRLF
cQuery	+= "	b.B1_DESC " +CRLF
cQuery	+= "ORDER BY " +CRLF
cQuery	+= "	a.D2_COD " +CRLF

//MemoWrite("C:\mbrfat06.txt",cQuery)

TcQuery cQuery New Alias "TRA"

dbSelectArea("TRA")

SetRegua(RecCount())


ntotQtd	:= 0
nTotVlr	:= 0
nTotVll	:= 0

TRA->(dbGoTop())

While !TRA->(EOF())

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
             
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	SB1->(dbSeek(xFilial("SB1")+TRA->D2_COD))
	nValMkt	:=	SB1->B1_ZZVLMKT/100*TRA->D2_TOTAL
	nValDir	:=	SB1->B1_ZZVLDIR/100*TRA->D2_TOTAL
	nValInv	:=	SB1->B1_ZZVLINV/100*TRA->D2_TOTAL
	nValErr	:=	SB1->B1_ZZMERRO/100*TRA->D2_TOTAL
	

	@nLin,001 Psay TRA->D2_COD
	@nLin,017 Psay TRA->B1_DESC
	@nLin,062 Psay PadR(Transform(TRA->D2_QUANT, "@E 9,999,999.99"),15)
	@nLin,077 Psay PadR(Transform(TRA->D2_TOTAL, "@E 999,999,999.99"),15)
	@nLin,095 Psay PadR(Transform(TRA->D2_MEDIO, "@E 9,999.9999"),12)
	
	@nLin,062 Psay PadR(Transform(TRA->C6_QUANT, "@E 9,999,999.99"),15)
	@nLin,077 Psay PadR(Transform(TRA->C6_VALOR, "@E 999,999,999.99"),15)
	
	@nLin,112 Psay PadR(Transform(TRA->C6_ZZPLL, "@E 999.9999"),15)
	@nLin,123 Psay PadR(Transform(TRA->C6_ZZVLL, "@E 99,999,999.9999"),15)
	
	@nLin,140 Psay PadR(Transform(SB1->B1_ZZVLMKT, "@E 999.99"),6)
	@nLin,146 Psay PadR(Transform(nValMkt, "@E 9,999,999.99"),12)
	
	@nLin,158 Psay PadR(Transform(SB1->B1_ZZVLDIR, "@E 999.99"),6)
	@nLin,164 Psay PadR(Transform(nValDir, "@E 9,999,999.99"),12)
	
	@nLin,180 Psay PadR(Transform(SB1->B1_ZZVLINV, "@E 999.99"),6)
	@nLin,188 Psay PadR(Transform(nValInv, "@E 9,999,999.99"),12)
	
	@nLin,202 Psay PadR(Transform(SB1->B1_ZZMERRO, "@E 999.99"),6)
	@nLin,210 Psay PadR(Transform(nValErr, "@E 9,999,999.99"),12)
	
	ntotQtd	+= TRA->D2_QUANT
	nTotVlr	+= TRA->D2_TOTAL
	nTotVll	+= TRA->C6_ZZVLL

	nlin++
	
	If MV_PAR03 == 1
		_cTxt := ""
  		_cTxt := 	TRA->D2_COD+";"
        _cTxt += 	TRA->B1_DESC+";"+;
					Transform(TRA->D2_QUANT, "@E 9,999,999.99")+";"+;
					Transform(TRA->D2_TOTAL, "@E 999,999,999.99")+";"+;
					Transform(TRA->D2_MEDIO, "@E 999,999.9999")+";"+;
					Transform(TRA->C6_ZZPLL, "@E 999,999.9999")+";"+;
					Transform(TRA->C6_ZZVLL, "@E 99,999,999.9999")
		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
 		FWrite(nHandle, _cTxt+cNL)
 	EndIF

   	TRA->(dbSkip())
EndDo
nlin++
@nLin,002 Psay "TOTAL "
@nLin,062 Psay PadR(Transform(nTotQtd, "@E 9,999,999.99"),15)
@nLin,077 Psay PadR(Transform(nTotVlr, "@E 999,999,999.99"),15)
@nLin,112 Psay PadR(Transform(nTotVll/nTotVlr*100, "@E 999.99"),15)
@nLin,123 Psay PadR(Transform(nTotVll, "@E 999,999,999.99"),15)

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
