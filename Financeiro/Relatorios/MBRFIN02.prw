#include "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "FileIO.ch"

User Function MBRFIN02()
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Cheques Recebidos por Período"
Local cPict         := ""
Local titulo        := "Relatorio de Cheques Recebidos por Período"
Local nLin          := 80
//000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1		:= "BANCO AGENCIA CONTA      CHEQUE     CODIGO CLIENTE                                EMISSAO    VENCTO          VALOR         VALOR BAIXA    SALDO          TITULO     DT 2 DEV"
Local Cabec2		:= ""
Local imprime       := .T.

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "MBRFIN02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "MBRFIN02A "
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "MBRFIN02"	// Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		:= "SEF"
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)
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


If MV_PAR05 == 1
	nHandle := FCreate(cCSV, FC_NORMAL )
	
	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END) // Posiciona no fim do arquivo                        admin
		FWrite(nHandle, "BANCO;AGENCIA;CONTA;CHEQUE;CLIENTE;;EMISSAO;VENCIMENTO;VALOR;VALORBX"+cNL ) // Insere texto no arquivo
	Endif
EndIf


xcQuery := 			"SELECT DISTINCT "
xcQuery += xcR + 	"	EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_DATA, EF_VENCTO, EF_NUM, EF_VALOR, "
If MV_PAR07 == 2
	xcQuery += xcR + 	"	EF_PREFIXO, EF_TITULO, EF_PARCELA, EF_VALORBX "
Else
	xcQuery += xcR + 	"	( "
	xcQuery += xcR + 	"	SELECT  "
	xcQuery += xcR + 	"		SUM(EF_VALORBX)  "
	xcQuery += xcR + 	"	FROM "
	xcQuery += xcR + 	"		" + RetSqlName('SEF') + " B "
	xcQuery += xcR + 	"	WHERE  "
	xcQuery += xcR + 	"		B.EF_BANCO = A.EF_BANCO AND "
	xcQuery += xcR + 	"		B.EF_AGENCIA = A.EF_AGENCIA AND "
	xcQuery += xcR + 	"		B.EF_CONTA = A.EF_CONTA AND "
	xcQuery += xcR + 	"		B.EF_FILIAL = '" + xFilial('SEF') + "' AND "
	xcQuery += xcR + 	"		B.EF_NUM = A.EF_NUM AND "
	xcQuery += xcR + 	"		B.D_E_L_E_T_ = ''  "
	xcQuery += xcR + 	"	) EF_VALORBX "
EndIf
xcQuery += xcR + 	"FROM "
xcQuery += xcR + 	"	" + RetSqlName('SEF') + " A INNER JOIN "
xcQuery += xcR + 	"	" + RetSqlName('SE1') + " C ON "
xcQuery += xcR + 	"	EF_PREFIXO = E1_PREFIXO AND "
xcQuery += xcR + 	"	EF_TITULO = E1_NUM AND "
xcQuery += xcR + 	"	EF_PARCELA = E1_PARCELA AND "
xcQuery += xcR + 	"	EF_TIPO = E1_TIPO "
xcQuery += xcR + 	"WHERE "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND	 "
If MV_PAR06 == 1
	xcQuery += xcR + 	"	A.EF_DTCOMP <> '' AND "
ElseIf MV_PAR06 == 2
	xcQuery += xcR + 	"	A.EF_DTCOMP = '' AND "
EndIf
xcQuery += xcR + 	"	A.EF_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "
xcQuery += xcR + 	"	A.EF_VENCTO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' AND "
xcQuery += xcR + 	"	E1_FILIAL = '" + xFilial('SE1') + "' AND "
xcQuery += xcR + 	"	EF_FILIAL = '" + xFilial('SEF') + "' AND "
If MV_PAR07 == 2
	xcQuery += xcR + 	"	E1_SALDO > 0 AND "
	xcQuery += xcR + 	"	EF_DTREPRE = '' AND "
	xcQuery += xcR + 	"	EF_ZZDEPOS <> '' "
ElseIf MV_PAR07 == 3
	xcQuery += xcR + 	"	EF_ALINEA2 <> '' AND "
	xcQuery += xcR + 	"	EF_ZZPAGO = 'N' "
Else
	xcQuery += xcR + 	"	EF_DTREPRE = '' AND "
	xcQuery += xcR + 	"	EF_ZZDEPOS = '' "
EndIf
MemoWrite("MBRFIN02_01.SQL", xcQuery)
TcQuery ChangeQuery(xcQuery) New Alias "TRA"

//TCSETFIELD( "TRA","EF_DATA","D")
//TCSETFIELD( "TRA","EF_VENCTO","D")

dbSelectArea("TRA")

SetRegua(RecCount())

ntotQtd	:= 0
nTotVlr	:= 0
nTotVlrbx	:= 0
nReg:=0
TRA->(dbGoTop())

While !TRA->(EOF())
	nReg++
	If lAbortPrint           é
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	SEF->(dbSeek(xFilial("SEF")+TRA->EF_BANCO+TRA->EF_AGENCIA+TRA->EF_CONTA+TRA->EF_NUM))
	SA1->(dbSeek(xFilial("SA1")+SEF->EF_CLIENTE+SEF->EF_LOJACLI))
	
	@nLin,001 Psay TRA->EF_BANCO
	@nLin,007 Psay TRA->EF_AGENCIA
	@nLin,015 Psay TRA->EF_CONTA
	@nLin,026 Psay TRA->EF_NUM
	@nLin,037 Psay SA1->A1_COD
	@nLin,044 Psay substr(SA1->A1_NOME,1,35)
	@nLin,044 Psay substr(SA1->A1_NOME,1,35)
	
	@nLin,083 Psay PadR(dtoc(SEF->EF_DATA),10)
	@nLin,094 Psay PadR(dtoc(SEF->EF_VENCTO),15)
	@nLin,106 Psay PadR(Transform(TRA->EF_VALOR, "@E 9,999,999.99"),12)
	@nLin,122 Psay PadR(Transform(TRA->EF_VALORBX, "@E 9,999,999.99"),12)
	@nLin,135 Psay PadR(Transform(TRA->EF_VALOR-TRA->EF_VALORBX, "@E 9,999,999.99"),12)
	If MV_PAR07 == 2
		@nLin,150 Psay TRA->(EF_PREFIXO + EF_TITULO + EF_PARCELA)
	EndIf
	@nLin,165 Psay PadR(dtoc(SEF->EF_DTALIN2),15)
	
	ntotQtd	+= 1
	nTotVlr	+= TRA->EF_VALOR
	nTotVlrbx += TRA->EF_VALORBX
	
	nlin++
	
	If MV_PAR05 == 1
		_cTxt := ""
		_cTxt := 	TRA->EF_BANCO+";"+;
		TRA->EF_AGENCIA+";"+;
		TRA->EF_CONTA+";"+;
		TRA->EF_NUM+";"+;
		SA1->A1_COD+";"+;
		SA1->A1_NOME+";"+;
		dtoc(SEF->EF_DATA)+";"+;
		dtoc(SEF->EF_VENCTO)+";"+;
		Transform(TRA->EF_VALOR, "@E 9,999,999.99")+";"+;
		Transform(TRA->EF_VALORBX, "@E 9,999,999.99")+";"+;
		Transform(TRA->EF_VALOR-TRA->EF_VALORBX, "@E 9,999,999.99")+;
		IIF(MV_PAR07 == 2, TRA->(EF_PREFIXO + EF_TITULO + EF_PARCELA), '')
		
		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
		FWrite(nHandle, _cTxt+cNL)
	EndIF
	TRA->(dbSkip())
EndDo

If nReg > 0
	nlin++
	@nLin,002 Psay "TOTAL "
	@nLin,012 Psay PadR(Transform(nTotQtd, "@E 9,999,999"),15)
	@nLin,115 Psay PadR(Transform(nTotVlr, "@E 999,999,999.99"),15)
	@nLin,128 Psay PadR(Transform(nTotVlrbx, "@E 999,999,999.99"),15)
	@nLin,141 Psay PadR(Transform(nTotVlr-nTotVlrbx, "@E 999,999,999.99"),15)
	
EndIf

TRA->(dbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

If MV_PAR05 == 1
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
aAdd(aRegs,{cPerg,"01","Data Entrada De ? "    ,"mv_ch01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Entrada Ate ? "   ,"mv_ch02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data Vencto De ? "     ,"mv_ch03","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Vencto Ate ? "    ,"mv_ch04","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Gera Planilha?"        ,"mv_ch05","N",01,0,0,"C","","MV_PAR05","Sim","","","Não","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Cheques Compensados?"  ,"mv_ch05","N",01,0,0,"C","","MV_PAR06","Sim","","","Não","","","Ambos","","","","","","","",""})

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
