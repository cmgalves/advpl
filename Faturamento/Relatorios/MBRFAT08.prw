#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "FileIO.ch"                
                      
//Relatórios Faturamento:
//1. Pedidos x Vendedor

User Function MBRFAT08()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Pedidos x Vendedor"
Local cPict          := ""
Local imprime        := .T.

Private cTipoPV		:= GetMv("MV_ZZTPPV") //TIPOS DE PEDIDO QUE DETALHAM COMISSÃO - FUNCIONALIDADE APOS ENTRADA EM PRODUÇÃO DA TES INTELEGINETE MB
Private titulo         := "Pedidos x Vendedor"
Private Cabec1		 := "DATA       PEDIDO CLIENTE                                                 CIDADE                    DATA FAT                    N.F.            VALOR VEND    VALOR FAT        TP.FRETE"
Private Cabec2		 := "                                                                                                                                                  R$              R$"
Private nLin           := 80
Private nTipo        := 18
Private tamanho      := "G"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private nomeprog     := "MBRFAT08" // Coloque aqui o nome do programa para impressao no cabecalho
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MBRFAT08  "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MBRFAT08"	// Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		 := "SC5"

					   //000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999
					   //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
ValidPerg()

Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
//  wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,"","","",.F.,aOrd,,Tamanho)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo)
Private cNL     := Chr(13) + Chr(10)         // Caracteres p/ "Nova Linha"
Private cVend1	:= "      "
Private cFRETMB := ""
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
//		FWrite(nHandle, "DATA;PEDIDO;CLIENTE;CIDADE;DATA FAT;N.F.;VALOR"+cNL ) // Insere texto no arquivo
//	Endif
//EndIf


cQuery	:= "SELECT  " +CRLF
cQuery	+= "	a.C5_EMISSAO,  " +CRLF
cQuery	+= "	a.C5_ZZTPOPE,  " +CRLF
cQuery	+= "	a.C5_NUM,  " +CRLF
cQuery	+= "	a.C5_VEND1,  " +CRLF
cQuery	+= "	a.C5_COMIS1,  " +CRLF
cQuery	+= "	c.A3_NOME, " +CRLF
cQuery	+= "	a.C5_CLIENTE,  " +CRLF
cQuery	+= "	a.C5_LOJACLI,  " +CRLF
cQuery	+= "	a.C5_TPFRETE,  " +CRLF
cQuery	+= "	a.C5_FRETEMB,  " +CRLF
cQuery	+= "	b.A1_NOME,  " +CRLF
cQuery	+= "	b.A1_MUN,  " +CRLF
cQuery	+= "	b.A1_ZZSITLL,  " +CRLF   
cQuery	+= "	b.A1_EST,  " +CRLF   
cQuery	+= "	(SELECT TOP 1 g.D2_DOC " +CRLF
cQuery	+= "		FROM "+RETSQLNAME("SD2")+" as g " +CRLF
cQuery	+= "		WHERE  " +CRLF
cQuery	+= "			g.D2_PEDIDO = a.C5_NUM " +CRLF
cQuery	+= "			AND g.D2_EMISSAO between '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' " +CRLF
cQuery	+= "			AND g.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "	) C5_NOTA, " +CRLF
cQuery	+= "	(SELECT TOP 1 g.D2_SERIE " +CRLF
cQuery	+= "		FROM "+RETSQLNAME("SD2")+" as g " +CRLF
cQuery	+= "		WHERE  " +CRLF
cQuery	+= "			g.D2_PEDIDO = a.C5_NUM " +CRLF
cQuery	+= "			AND g.D2_EMISSAO between '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' " +CRLF
cQuery	+= "			AND g.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "	) C5_SERIE, " +CRLF
cQuery	+= "	a.C5_TPFRETE, " +CRLF
cQuery	+= "	a.C5_FRETEMB, " +CRLF

//este bloco deve ser replicado para clausula where
cQuery	+= "	(SELECT SUM(d.C6_VALOR) " +CRLF
cQuery	+= "		FROM "+RETSQLNAME("SC6")+" d LEFT JOIN" +CRLF
cQuery	+= "			"+RETSQLNAME("SF4")+" e ON   " +CRLF
cQuery	+= "			e.F4_CODIGO		=	d.C6_TES	and   " +CRLF
cQuery	+= "			e.D_E_L_E_T_	<> '*' " +CRLF
cQuery	+= "		WHERE " +CRLF
cQuery	+= "			d.C6_NUM = a.C5_NUM and " +CRLF
IF MV_PAR10 = 1
	cQuery	+= "		e.F4_DUPLIC		= 'S'  and " +CRLF
ELSEIF MV_PAR10 = 2
	cQuery	+= "		e.F4_DUPLIC		= 'N'  and " +CRLF
ENDIF
cQuery	+= "			d.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "	) C5_VALOR, " +CRLF
//fim do bloco

cQuery	+= "	(SELECT SUM(e.D2_TOTAL) " +CRLF
cQuery	+= "		FROM "+RETSQLNAME("SD2")+" e LEFT JOIN  " +CRLF
cQuery	+= "			"+RETSQLNAME("SF4")+" f ON  " +CRLF
cQuery	+= "			f.F4_CODIGO		=	e.D2_TES	and    " +CRLF
cQuery	+= "			f.D_E_L_E_T_	<> '*'  " +CRLF
cQuery	+= "		WHERE  " +CRLF
cQuery	+= "			e.D2_PEDIDO = a.C5_NUM and  " +CRLF
IF MV_PAR10 = 1
	cQuery	+= "		f.F4_DUPLIC		= 'S'  and " +CRLF
ELSEIF MV_PAR10 = 2
	cQuery	+= "		f.F4_DUPLIC		= 'N'  and " +CRLF
ENDIF
cQuery	+= "			e.D_E_L_E_T_ = '' and " +CRLF
cQuery	+= "			e.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' " +CRLF
cQuery	+= "	) D2_VALOR " +CRLF

cQuery	+= "FROM " +CRLF
cQuery	+= "	"+RETSQLNAME("SC5")+" a INNER JOIN " +CRLF
cQuery	+= "	"+RETSQLNAME("SA1")+" b ON " +CRLF
cQuery	+= "	b.A1_COD = a.C5_CLIENTE and " +CRLF
cQuery	+= "	b.A1_LOJA = a.C5_LOJACLI and  " +CRLF
cQuery	+= "	b.D_E_L_E_T_ = '' INNER JOIN " +CRLF
cQuery	+= "	"+RETSQLNAME("SA3")+" c ON " +CRLF
cQuery	+= "	c.A3_COD = a.C5_VEND1 and " +CRLF
cQuery	+= "	c.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "WHERE " +CRLF
cQuery	+= "	a.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "AND a.C5_EMISSAO between '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' " +CRLF
cQuery	+= "AND a.C5_VEND1 between '"+MV_PAR03+"' and '"+MV_PAR04+"' " +CRLF
cQuery	+= "AND a.C5_VEND2 between '"+MV_PAR05+"' and '"+MV_PAR06+"' " +CRLF
cQuery	+= "AND a.C5_VEND3 between '"+MV_PAR07+"' and '"+MV_PAR08+"' " +CRLF

cQuery	+= "AND	(SELECT SUM(d.C6_VALOR) " +CRLF
cQuery	+= "		FROM "+RETSQLNAME("SC6")+" d LEFT JOIN" +CRLF
cQuery	+= "			"+RETSQLNAME("SF4")+" e ON   " +CRLF
cQuery	+= "			e.F4_CODIGO		=	d.C6_TES	and   " +CRLF
cQuery	+= "			e.D_E_L_E_T_	<> '*' " +CRLF
cQuery	+= "		WHERE " +CRLF
cQuery	+= "			d.C6_NUM = a.C5_NUM and " +CRLF
IF MV_PAR10 = 1
	cQuery	+= "		e.F4_DUPLIC		= 'S'  and " +CRLF
ELSEIF MV_PAR10 = 2
	cQuery	+= "		e.F4_DUPLIC		= 'N'  and " +CRLF
ENDIF
cQuery	+= "			d.D_E_L_E_T_ = '' " +CRLF
cQuery	+= "	) > 0 " +CRLF

cQuery	+= "ORDER BY " +CRLF
cQuery	+= "	a.C5_VEND1,a.C5_EMISSAO " +CRLF

TcQuery cQuery New Alias "TRA"
//MemoWrite("C:\mbrfat08.txt",cquery)
TCSETFIELD( "TRA","C5_EMISSAO","D")

dbSelectArea("TRA")
SetRegua(RecCount())
TRA->(dbGoTop())
If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

If !TRA->(EOF())
	
	cQuery2	:= "SELECT SUM(CT_VALOR) CT_VALOR " +CRLF
	cQuery2	+= "FROM "+RETSQLNAME("SCT")+" " +CRLF
	cQuery2	+= "WHERE " +CRLF
	cQuery2	+= "	CT_VEND = '"+MV_PAR03+"' " +CRLF
	cQuery2	+= "AND CT_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' " +CRLF
	cQuery2	+= "AND D_E_L_E_T_ = '' " +CRLF
	TcQuery ChangeQuery(cQuery2) New Alias "TRB"

	nMeta	:= TRB->CT_VALOR//0//meta de venda
	
	TRB->(DBCLOSEAREA())
	@nLin,002 Psay TRA->C5_VEND1 + " - " +ALLTRIM(TRA->A3_NOME)
	@nLin,085 Psay "Meta: "+PadR(Transform(nMeta, "@E 999,999,999.99"),14)
	nLin ++
	nLin ++
//	If MV_PAR09 == 1
//		_cTxt := TRA->C5_VEND1 + " - " +ALLTRIM(TRA->A3_NOME)+";"+";"+";"+Transform(nMeta, "@E 999,999,999.99")
//		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
// 		FWrite(nHandle, _cTxt+cNL)
// 	endif
	cVend1	:= TRA->C5_VEND1
	
Endif
ntotQtd		:= 0
nTotVend	:= 0
nTotFat		:= 0
nTotGer		:= 0
nTotGerF	:= 0
nTotCanc	:= 0
nTotFrt		:= 0
nTotBsC		:= 0
nTotCom		:= 0
nTGFrt		:= 0
nTGBsC		:= 0
nTGCom		:= 0
While !TRA->(EOF())
	If lAbortPrint           é 
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If !cVend1 = TRA->C5_VEND1
		//Imprime Totais
		@nLin,001 Psay "TOTAL DO VENDEDOR : "
		@nLin,135 Psay PadR(Transform(nTotVend, "@E 999,999,999.99"),14)
		@nLin,151 Psay PadR(Transform(nTotFat, "@E 999,999,999.99"),14)
		IF MV_PAR09 = 1 .and. (alltrim(TRA->C5_ZZTPOPE) $ cTipoPV .or. empty(alltrim(TRA->C5_ZZTPOPE)))
			nLin++
			@nLin,055 Psay "Tot.Vlr.Frete: "+Transform(nTotFrt, "@E 999,999,999.99")
			@nLin,091 Psay "Tot.Bs.Comissao: "+Transform(nTotBsC, "@E 999,999,999.99")
			@nLin,135 Psay "Tot.Comissao: "+Transform(nTotCom, "@E 999,999,999.99")		
			nTGFrt		+= nTotFrt
			nTGBsC		+= nTotBsC
			nTGCom		+= nTotCom
			
			nTotFrt		:= 0
			nTotBsC		:= 0
			nTotCom		:= 0
		ENDIF
		                                       
		ntotQtd		:= 0
		nTotVend	:= 0
		nTotFat		:= 0
		
		nTotCanc	+= MBPVDEL(cVend1)
		
		nLin ++
		nLin ++
		cQuery2	:= "SELECT SUM(CT_VALOR) CT_VALOR " +CRLF
		cQuery2	+= "FROM "+RETSQLNAME("SCT")+" " +CRLF
		cQuery2	+= "WHERE " +CRLF
		cQuery2	+= "	CT_VEND = '"+TRA->C5_VEND1+"' " +CRLF
		cQuery2	+= "AND CT_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " +CRLF
		cQuery2	+= "AND D_E_L_E_T_ = '' " +CRLF
		TcQuery ChangeQuery(cQuery2) New Alias "TRB"

		nMeta	:= TRB->CT_VALOR//meta de venda
	
		TRB->(DBCLOSEAREA())
		
		@nLin,002 Psay Replicate("_",220)
		nLin++
		@nLin,001 Psay TRA->C5_VEND1 + " - " +ALLTRIM(TRA->A3_NOME) 
		@nLin,085 Psay PadR(Transform(nMeta, "@E 999,999,999.99"),14)
		nLin ++
//		If MV_PAR09 == 1
//			_cTxt := TRA->C5_VEND1 + " - " +ALLTRIM(TRA->A3_NOME)+";"+";"+";"+Transform(nMeta, "@E 999,999,999.99")
//			FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
// 			FWrite(nHandle, _cTxt+cNL)
// 		endif
		cVend1	:= TRA->C5_VEND1
	Endif
             
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	SF2->(dbseek(xFilial("SF2")+TRA->C5_NOTA+TRA->C5_SERIE+TRA->C5_CLIENTE+TRA->C5_LOJACLI))
	
	@nLin,001 Psay DTOC(TRA->C5_EMISSAO)
	@nLin,012 Psay TRA->C5_NUM
	@nLin,019 Psay SubStr(TRA->A1_NOME,1,50)
	@nLin,075 Psay TRA->A1_MUN
	@nLin,101 Psay DTOC(SF2->F2_EMISSAO)
	@nLin,122 Psay ALLTRIM(TRA->C5_NOTA)+"-"+ALLTRIM(TRA->C5_SERIE)
	@nLin,135 Psay PadR(Transform(TRA->C5_VALOR, "@E 999,999,999.99"),14)
	@nLin,151 Psay PadR(Transform(TRA->D2_VALOR, "@E 999,999,999.99"),14)
	Do CASE 
		Case TRA->C5_FRETEMB == "1"
			 cFRETMB := "RED"      
 		Case TRA->C5_FRETEMB == "2"
			 cFRETMB := "CLIENTE"
 		Case TRA->C5_FRETEMB == "3"
 			 cFRETMB := "GRATIS"
 		OTHERWISE
		      cFRETMB := " "                                                                                                        
	EndCase
	@nLin,175 Psay TRA->C5_TPFRETE +"-"+ cFRETMB
	IF MV_PAR09 = 1 .and. (alltrim(TRA->C5_ZZTPOPE) $ cTipoPV .or. empty(alltrim(TRA->C5_ZZTPOPE)))
		nLin++
		nPerFrt	:= MBPerFrt()/100
		nVlrFrt	:= TRA->C5_VALOR*nPerFrt
		nBsCom	:= TRA->C5_VALOR-nVlrFrt
		nVlrCom	:= nBsCom*TRA->C5_COMIS1/100
		@nLin,019 Psay "Porc.Frete: "+Transform(nPerFrt, "@E 999.99") 
		@nLin,055 Psay "Vlr.Frete: "+Transform(nVlrFrt, "@E 999,999,999.99")
		@nLin,091 Psay "Bs.Comissao: "+Transform(nBsCom, "@E 999,999,999.99")
		@nLin,122 Psay Transform(TRA->C5_COMIS1, "@E 999.99")+"%"
		@nLin,135 Psay "Valor: "+Transform(nVlrCom, "@E 999,999,999.99")		
		nTotFrt	+= nVlrFrt
		nTotBsC += nBsCom
		nTotCom += nVlrCom
	ENDIF
	ntotQtd		+= 1
	nTotVend	+= TRA->C5_VALOR
	nTotFat		+= TRA->D2_VALOR
	nTotGer 	+= TRA->C5_VALOR
	nTotGerF 	+= TRA->D2_VALOR
	nlin ++
	
//	If MV_PAR09 == 1
//		_cTxt := ""
//  		_cTxt := 	DTOC(TRA->C5_EMISSAO)+";"+;
//					TRA->C5_NUM+";"+;
//					TRA->A1_NOME+";"+;
//					TRA->A1_MUN+";"+;
//					DTOC(SF2->F2_EMISSAO)+";"+;
//					ALLTRIM(TRA->C5_NOTA)+"-"+ALLTRIM(TRA->C5_SERIE)+";"+;
//					Transform(TRA->C5_VALOR, "@E 999,999,999.99")


//		FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
// 		FWrite(nHandle, _cTxt+cNL)
// 		IF MV_PAR10 == 1
//			_cTxt := ""
//  			_cTxt := 	"Porc.Frete: "+Transform(nPerFrt, "@E 999.99") +";"+;
//						"Vlr.Frete: "+Transform(nVlrFrt, "@E 999,999,999.99")+";"+;
//						"Bs.Comissao: "+Transform(nBsCom, "@E 999,999,999.99")+";"+;
//						Transform(TRA->C5_COMIS1, "@E 999.99")+"%"+";"+;
//						"Valor: "+Transform(nVlrCom, "@E 999,999,999.99")		

//			FSeek(nHandle, 0, FS_END) //Posiciona no fim do arquivo
// 			FWrite(nHandle, _cTxt+cNL)
 		
// 		ENDIF
// 	EndIF
 	
	
	
   	TRA->(dbSkip())
EndDo

@nLin,001 Psay "TOTAL DO VENDEDOR : "
@nLin,135 Psay PadR(Transform(nTotVend, "@E 999,999,999.99"),14)
@nLin,151 Psay PadR(Transform(nTotFat, "@E 999,999,999.99"),14)
		IF MV_PAR09 = 1 .and. (alltrim(TRA->C5_ZZTPOPE) $ cTipoPV .or. empty(alltrim(TRA->C5_ZZTPOPE)))
			nLin++
			@nLin,055 Psay "Tot.Vlr.Frete: "+Transform(nTotFrt, "@E 999,999,999.99")
			@nLin,091 Psay "Tot.Bs.Comissao: "+Transform(nTotBsC, "@E 999,999,999.99")
			@nLin,135 Psay "Tot.Comissao: "+Transform(nTotCom, "@E 999,999,999.99")		
			nTGFrt		+= nTotFrt
			nTGBsC		+= nTotBsC
			nTGCom		+= nTotCom
		ENDIF
nLin ++
nLin ++

nTotCanc	+= MBPVDEL(cVend1)

nLin ++
nLin ++
nLin ++
nLin ++
@nLin,000 Psay Replicate("_",220)
nLin++
@nLin,002 Psay "TOTAL DO RELATÓRIO VENDIDOS"
@nLin,135 Psay PadR(Transform(nTotGer, "@E 999,999,999.99"),14)

nLin++
@nLin,002 Psay "TOTAL DO RELATÓRIO FATURADO"
@nLin,135 Psay PadR(Transform(nTotGerF, "@E 999,999,999.99"),14)

nLin++
@nLin,002 Psay "TOTAL DO RELATÓRIO CANCELADOS"
@nLin,135 Psay PadR(Transform(nTotCanc, "@E 999,999,999.99"),14)
IF MV_PAR09 = 1 .and. (alltrim(TRA->C5_ZZTPOPE) $ cTipoPV .or. empty(alltrim(TRA->C5_ZZTPOPE)))
	nLin++
	@nLin,055 Psay "Tot.Geral Frete: "+Transform(nTGFrt, "@E 999,999,999.99")
	@nLin,091 Psay "Tot.Geral Bs.Comissao: "+Transform(nTGBsC, "@E 999,999,999.99")
	@nLin,135 Psay "Tot. Geral Comissao: "+Transform(nTGCom, "@E 999,999,999.99")
ENDIF

TRA->(DBCLOSEAREA())

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
aAdd(aRegs,{cPerg,"01","Data Emissao De ?    ","mv_ch01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Emissao Ate ?   ","mv_ch02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Vendedor De ?        ","mv_ch03","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"04","Vendedor Ate ?       ","mv_ch04","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"05","Supervisor Reg. De ? ","mv_ch05","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"06","Supervisor Reg. Ate ?","mv_ch06","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"07","Supervisor Nac. De ? ","mv_ch07","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"08","Supervisor Nac. Ate ?","mv_ch08","C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"09","Detalha Comissão?"    ,"mv_ch09","N",01,0,0,"C","","MV_PAR09","Sim","","","Não","","","","","","","","","","",""})
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

STATIC FUNCTION MBPVDEL(cVend1)
cQuery3	:= "SELECT  " +CRLF
cQuery3	+= "	a.C5_EMISSAO,  " +CRLF
cQuery3	+= "	a.C5_NUM,  " +CRLF
cQuery3	+= "	a.C5_VEND1,  " +CRLF
cQuery3	+= "	c.A3_NOME, " +CRLF
cQuery3	+= "	a.C5_CLIENTE,  " +CRLF
cQuery3	+= "	a.C5_LOJACLI,  " +CRLF
cQuery3	+= "	b.A1_NOME,  " +CRLF
cQuery3	+= "	b.A1_MUN,  " +CRLF
cQuery3	+= "	a.C5_NOTA,  " +CRLF
cQuery3	+= "	a.C5_SERIE, " +CRLF
cQuery3	+= "	(SELECT SUM(d.C6_VALOR) " +CRLF
cQuery3	+= "		FROM "+RETSQLNAME("SC6")+" d LEFT JOIN " +CRLF
cQuery3	+= "			"+RETSQLNAME("SF4")+" e ON   " +CRLF
cQuery3	+= "			e.F4_CODIGO		=	d.C6_TES	and   " +CRLF
cQuery3	+= "			e.D_E_L_E_T_	<> '*' " +CRLF
cQuery3	+= "		WHERE " +CRLF
cQuery3	+= "			d.C6_NUM = a.C5_NUM and " +CRLF
IF MV_PAR10 = 1
	cQuery3	+= "		e.F4_DUPLIC		= 'S'  and " +CRLF
ELSEIF MV_PAR10 = 2
	cQuery3	+= "		e.F4_DUPLIC		= 'N'  and " +CRLF
ENDIF
cQuery3	+= "			d.D_E_L_E_T_ = '*' " +CRLF
cQuery3	+= "	) C5_VALOR " +CRLF
cQuery3	+= "FROM " +CRLF
cQuery3	+= "	"+RETSQLNAME("SC5")+" a INNER JOIN " +CRLF
cQuery3	+= "	"+RETSQLNAME("SA1")+" b ON " +CRLF
cQuery3	+= "	b.A1_COD = a.C5_CLIENTE and " +CRLF
cQuery3	+= "	b.A1_LOJA = a.C5_LOJACLI and  " +CRLF
cQuery3	+= "	b.D_E_L_E_T_ = '' INNER JOIN " +CRLF
cQuery3	+= "	"+RETSQLNAME("SA3")+" c ON " +CRLF
cQuery3	+= "	c.A3_COD = a.C5_VEND1 and " +CRLF
cQuery3	+= "	c.D_E_L_E_T_ = '' " +CRLF

cQuery3	+= "WHERE " +CRLF
cQuery3	+= "	a.D_E_L_E_T_ = '*' " +CRLF
cQuery3	+= "AND a.C5_EMISSAO between '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' " +CRLF
cQuery3	+= "AND a.C5_VEND1 = '"+cVend1+"' "+CRLF
cQuery3	+= "AND a.C5_VEND2 between '"+MV_PAR05+"' and '"+MV_PAR06+"' " +CRLF
cQuery3	+= "AND a.C5_VEND3 between '"+MV_PAR07+"' and '"+MV_PAR08+"' " +CRLF

cQuery3	+= "AND	(SELECT SUM(d.C6_VALOR) " +CRLF
cQuery3	+= "		FROM "+RETSQLNAME("SC6")+" d LEFT JOIN " +CRLF
cQuery3	+= "			"+RETSQLNAME("SF4")+" e ON   " +CRLF
cQuery3	+= "			e.F4_CODIGO		=	d.C6_TES	and   " +CRLF
cQuery3	+= "			e.D_E_L_E_T_	<> '*' " +CRLF
cQuery3	+= "		WHERE " +CRLF
cQuery3	+= "			d.C6_NUM = a.C5_NUM and " +CRLF
IF MV_PAR10 = 1
	cQuery3	+= "		e.F4_DUPLIC		= 'S'  and " +CRLF
ELSEIF MV_PAR10 = 2
	cQuery3	+= "		e.F4_DUPLIC		= 'N'  and " +CRLF
ENDIF
cQuery3	+= "			d.D_E_L_E_T_ = '*' " +CRLF
cQuery3	+= "	) > 0  " +CRLF

cQuery3	+= "ORDER BY " +CRLF
cQuery3	+= "	a.C5_VEND1,a.C5_EMISSAO " +CRLF

TcQuery ChangeQuery(cQuery3) New Alias "TRC"

TCSETFIELD( "TRC","C5_EMISSAO","D")
nTPVDel	:= 0
nLin++
nLin++

If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif
@nLin,001 Psay "PEDIDOS CANCELADOS"
nLin ++
TRC->(DBGOTOP())
While !TRC->(EOF())
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,001 Psay DTOC(TRC->C5_EMISSAO)
	@nLin,012 Psay TRC->C5_NUM
	@nLin,019 Psay SubStr(TRC->A1_NOME,1,50)
	@nLin,075 Psay TRC->A1_MUN
	@nLin,135 Psay PadR(Transform(TRC->C5_VALOR, "@E 999,999,999.99"),14)
	nLin++
	nTPVDel	+= TRC->C5_VALOR
	TRC->(DBSKIP())
ENDDO
nLin ++
@nLin,001 Psay "TOTAL DO VENDEDOR"
@nLin,135 Psay PadR(Transform(nTPVDel, "@E 999,999,999.99"),14)
TRC->(DBCLOSEAREA())
RETURN (nTPVDel)

//ROTINA PARA RETORNAR O PERCENTUAL DE FRETE DO PEDIDO.
//A FUNÇÃO FOI RETIRADA DO FONTE MSE3440.PRW
Static Function MBPerFrt()
Local nPerFrete	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Frete = CIF                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If TRA->C5_TPFRETE == 'C'
			
	&& Porcetagem de frete			            
   	SZ1->(DbSetOrder(1)) && Z1_FILIAL+Z1_COD
   	If SZ1->(DbSeek(xFilial("SZ1")+TRA->A1_ZZSITLL))       
   		nPerFrete := SZ1->Z1_PERFRET       	
	EndIf

	&& UF X % de Frete
	If nPerFrete == 0
		SX5->(dbSetOrder(1))
		If SX5->(dbSeek(xFilial("SX5")+"ZY"+TRA->A1_EST))
			nPerFrete := Val(X5Descri())				
		EndIf				
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo de Frete MB = REDESPACHO                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If TRA->C5_FRETEMB == '1'								
		&& Porcetagem de frete							
 		SZ3->(DbSetOrder(1)) && Z3_FILIAL+Z3_TPFRETE+Z3_FRETEMB
		If SZ3->(DbSeek(xFilial("SZ3")+TRA->C5_TPFRETE+TRA->C5_FRETEMB))
			nPerFrete += SZ3->Z3_PERFRET				    
		 EndIf
	EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Frete = FOB                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
Else
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo de Frete MB = REDESPACHO                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	If TRA->C5_FRETEMB == '1' .AND. AllTrim(GetMv("MV_ZZFRELL")) == 'S'
					
		&& Porcetagem de frete			            
      	SZ1->(DbSetOrder(1)) && Z1_FILIAL+Z1_COD
	   	If SZ1->(DbSeek(xFilial("SZ1")+TRA->A1_ZZSITLL))       
   			nPerFrete := SZ1->Z1_PERFRET       	
   		EndIf

		If nPerFrete == 0
			&& Porcetagem de frete							
	 		SZ3->(DbSetOrder(1)) && Z3_FILIAL+Z3_TPFRETE+Z3_FRETEMB
			If SZ3->(DbSeek(xFilial("SZ3")+TRA->C5_TPFRETE+TRA->C5_FRETEMB))
				nPerFrete := SZ3->Z3_PERFRET				    
			 EndIf
		Endif
				
	EndIf 
			
EndIf			
Return(nPerFrete)