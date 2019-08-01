#DEFINE CLR_LARANJA RGB(255,128,0  )
#DEFINE CLR_BRANCA  RGB(255,255,255)

#include "protheus.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RptDef.ch"  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Cobranca º Autor ³ Fabio Abinajm      º Data ³  21/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta a impressão da carta de cobrança em PDF, para envio  º±±
±±º          ³ por e-mail.                                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro CR - MC-Bauchemie.                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

	--> Parâmetros	
		Filial
		Codigo Cliente
		Codigo da Loja				
		E-mail de Cobrança
		Array com os dados
		Primeira Carta ? --> lPrim		
		Data de Cartorio	

	--> aDados
			Titulo                 
			Emissão               
			Vencimento
			Valor
			Valor Corrigido
			Dias de Atraso				
/*/






Static Function CobCarta(cFil,cCli,cLoja,cMail,aDados,lPrim,dCart)

Local a
Local cMun    := ""
Local cCodMun := ""

Local aArea    := GetArea()
Local aAreaSM0 := SM0->(GetArea())

//Parâmetros do Relatório.
Local lAdjustToLegacy := .T. 
Local lDisableSetup   := .T.

Local cFile           := "carta_" + DtoS(dDataBase) + "_" + cFil + cCli + cLoja + "_" + If(lPrim,"1","2") + ".pdf"
Local cDir            := "\"//AllTrim(MsDocPath())

Local cArq            := ""
Local cBorda          := "-1"

//Cria as fontes que serão usadas no relatório.
//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] ) --> oObjeto

Local oFont11TNS := TFont():New( "Times New Roman",/*2*/,11,/*4*/,.T.,/*6*/,/*7*/,/*8*/,/*9*/,.T.,.T.) //Times New Roman - 11 - Negrito e Sublinhado.
Local oFont11TN  := TFont():New( "Times New Roman",/*2*/,11,/*4*/,.T.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Times New Roman - 11 - Negrito.
Local oFont11T   := TFont():New( "Times New Roman",/*2*/,11,/*4*/,.F.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Times New Roman - 11.

Local oFont11AN  := TFont():New( "Arial",/*2*/,11,/*4*/,.T.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Arial - 11 - Negrito.
Local oFont11A   := TFont():New( "Arial",/*2*/,11,/*4*/,.F.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Arial - 11.

Local oFont12TN  := TFont():New( "Times New Roman",/*2*/,12,/*4*/,.T.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Times New Roman - 12 - Negrito.
Local oFont12T   := TFont():New( "Times New Roman",/*2*/,12,/*4*/,.F.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Times New Roman - 12.

Local oFont12A   := TFont():New( "Arial",/*2*/,12,/*4*/,.F.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Arial - 12.
Local oFont20TN  := TFont():New( "Times New Roman",/*2*/,20,/*4*/,.T.,/*6*/,/*7*/,/*8*/,/*9*/,.F.,.F.) //Times New Roman - 20 - Negrito.

Local oBrush     := TBrush():New(,CLR_LARANJA)

//Variáveis usadas para as posições do relatório.
Local nLin    := 001
Local nPulLin := 040  
Local nPixelX := 0
Local nPixelY := 0

Local nHPage  := 0
Local nVPage  := 0

Local aCol    := Array(8)

Default lPrim := .T.
Default dCart := StoD("") 

//Cria o diretório que será usado para gravar o arquivo.
MakeDir("C:\TOTVS")

//Caso o arquivo já exista exclui.
If File("C:\TOTVS\" + cFile)
	While FErase("C:\TOTVS\" + cFile) == -1
		Alert("Favor fechar o arquivo PDF para que possa ser gerado novamente!" + chr(13) + "C:\TOTVS\" + cFile)
		
		Sleep(1000)
	EndDo		
EndIf

//FWMsPrinter(): New ( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] ) --> oPrinter
oPrn := FWMSPrinter():New(cFile, IMP_PDF, lAdjustToLegacy,"\",lDisableSetup,,,,.F.,.F.,.F.,.F.)// Ordem obrigátoria de configuração do relatório

oPrn:lInJob   := .T. 
oPrn:cPathPDF := "C:\TOTVS\" // Caso seja utilizada impressão em IMP_PDF
oPrn:cPrinter := "PDF"

oPrn:SetResolution(78) 
oPrn:SetPortrait()

oPrn:SetPaperSize(DMPAPER_A4)
oPrn:SetMargin(100,100,100,100) // nEsquerda, nSuperior, nDireita, nInferior

nPixelX := oPrn:nLogPixelX()
nPixelY := oPrn:nLogPixelY()

oPrn:StartPage()

nHPage := oPrn:nHorzRes()
nVPage := oPrn:nVertRes()

nHPage := oPrn:nHorzRes()
nHPage *= (300/nPixelX)
nHPage -= 30

nVPage := oPrn:nVertRes()
nVPage *= (300/nPixelY)
nVPage -= 30


//FWMsPrinter(): SayBitmap ( < nRow>, < nCol>, < cBitmap>, [ nWidth], [ nHeight] ) -->
oPrn:SayBitmap(nLin,001, GetSrvProfString("Startpath","") + "logo.bmp",380,200) //nLin

//FWMsPrinter(): Line ( < nTop>, < nLeft>, < nBottom>, < nRight>, [ nColor], [ cPixel] ) -->
nLin += nPulLin * 6

oPrn:Line(nLin,001,nLin,nHPage)

nLin += nPulLin * 2

//FWMsPrinter(): Say ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nClrText], [ nAngle] ) -->
oPrn:Say(nLin,(nHPage/2)-400,"Carta de Cobrança",oFont20TN)


nLin += nPulLin * 2

cCodMun := AllTrim(Posicione("SM0", 1, SM0->M0_CODIGO + cFil, "M0_CODMUN"))
cCodMun := If( Len(cCodMun) >= 7, SubStr(cCodMun,3,5), cCodMun)

cMun := AllTrim(Posicione("CC2", 3, xFilial("CC2") + cCodMun, "CC2_MUN"))

oPrn:Say(nLin,nHPage-1000,cMun + ", " + AllTrim(Str(Day(Date()))) + " de " + MesExtenso(Month(Date())) + " de " + AllTrim(Str(Year(Date()))),oFont11T)

nLin += nPulLin*2


oPrn:Say(nLin,001,"À",oFont11TN)

nLin += nPulLin

oPrn:Say(nLin,001,Posicione("SA1", 1, xFilial("SA1")+cCli+cLoja, "A1_NOME"),oFont11TN)


nLin += nPulLin*5


oPrn:Say(nLin,001,"Prezados Senhores,",oFont12A)

nLin += nPulLin*3

//FWMsPrinter(): Say ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nClrText], [ nAngle] ) -->
oPrn:Say(nLin,0001,"Verificamos que o (os) título (os) de sua empresa ",oFont11T)
oPrn:Say(nLin,0640,"está (ão) vencido (s) há mais de "                 ,oFont11TN ,,CLR_LARANJA)
oPrn:Say(nLin,1070,if(lPrim,"2","4") + " dias. "                       ,oFont11TNS,,CLR_LARANJA)
oPrn:Say(nLin,1170,"Sendo assim, solicitamos o pagamento imediato do (os) título (os) "    ,oFont11T)

nLin += nPulLin

oPrn:Say(nLin,001,"mencionado (os) abaixo:"       ,oFont11T)


nLin += nPulLin*5

//FWMsPrinter(): Box ( < nRow>, < nCol>, < nBottom>, < nRight>, [ cPixel] ) --> 
oPrn:Box( nLin,001,nLin+(nPulLin*6),nHPage,cBorda)

//FillRect ( < aRect>, [ oBrush] ) --> NIL
//{linha inicial, coluna inicial, linha final, coluna final}
//Cor Laranja do cabeçalho dos itens.
oPrn:FillRect({nLin+1,002,(nLin-1)+(nPulLin),nHPage-1},oBrush)

//Valores das colunas
aCol[1] := 0001
aCol[2] := 0300
aCol[3] := 0550
aCol[4] := 0850
aCol[5] := 1150
aCol[6] := 1600
aCol[7] := 2000
aCol[8] := 2450

oPrn:Line(nLin,001     ,nLin          ,nHPage-1,,cBorda) //Linha Horizontal de cima - É reciada devido a cor laranja que está sobrepondo a linha.
oPrn:Line(nLin,nHPage-1,nLin + nPulLin,nHPage-1,,cBorda) //Linha Vertical da Ultima Coluna de cima - É reciada devido a cor laranja que está sobrepondo a linha. 

oPrn:Line(nLin,aCol[1],nLin+(nPulLin*6),aCol[1],,cBorda)
oPrn:Line(nLin,aCol[2],nLin+(nPulLin*6),aCol[2],,cBorda)
oPrn:Line(nLin,aCol[3],nLin+(nPulLin*6),aCol[3],,cBorda)
oPrn:Line(nLin,aCol[4],nLin+(nPulLin*6),aCol[4],,cBorda)
oPrn:Line(nLin,aCol[5],nLin+(nPulLin*6),aCol[5],,cBorda)
oPrn:Line(nLin,aCol[6],nLin+(nPulLin*6),aCol[6],,cBorda)
oPrn:Line(nLin,aCol[7],nLin+(nPulLin*6),aCol[7],,cBorda)

For a:=1 to 5
	oPrn:Line(nLin + 1 + (nPulLin*a),aCol[1],nLin + 1 + (nPulLin*a),nHPage-1,,cBorda)
Next a	

nLin += nPulLin

oPrn:Say(nLin - 10,aCol[1] + 100,"NFE"               ,oFont11AN,,CLR_BRANCA)
oPrn:Say(nLin - 10,aCol[2] + 022,"DESCRIÇÃO"         ,oFont11AN,,CLR_BRANCA)
oPrn:Say(nLin - 10,aCol[3] + 080,"EMISSÃO"           ,oFont11AN,,CLR_BRANCA)
oPrn:Say(nLin - 10,aCol[4] + 050,"VENCIMENTO"        ,oFont11AN,,CLR_BRANCA)
oPrn:Say(nLin - 10,aCol[5] + 030,"VALOR DO DOCUMENTO",oFont11AN,,CLR_BRANCA)
oPrn:Say(nLin - 10,aCol[6] + 045,"VALOR CORRIGIDO"   ,oFont11AN,,CLR_BRANCA)
oPrn:Say(nLin - 10,aCol[7] + 045,"DIAS DE ATRASO"    ,oFont11AN,,CLR_BRANCA)


For a:=1 to Len(aDados)

	nLin += nPulLin
	
	oPrn:Say(nLin - 10,aCol[1] + 15,aDados[a][1]                                                  ,oFont11A)
	oPrn:Say(nLin - 10,aCol[2] + 05,""                                                            ,oFont11A)
	oPrn:Say(nLin - 10,aCol[3] + 15,DtoC(aDados[a][2])                                            ,oFont11A)
	oPrn:Say(nLin - 10,aCol[4] + 15,DtoC(aDados[a][3])                                            ,oFont11A)
	oPrn:Say(nLin - 10,aCol[5] + 15,"R$ " + AllTrim(TransForm(aDados[a][4],"@E 9,999,999,999.99")),oFont11A)
	oPrn:Say(nLin - 10,aCol[6] + 15,"R$ " + AllTrim(TransForm(aDados[a][4],"@E 9,999,999,999.99")),oFont11A)
	oPrn:Say(nLin - 10,aCol[7] + 22,AllTrim(Str(aDados[a][6]))                                    ,oFont11A)		

Next a

nLin += nPulLin * (7 - Len(aDados))
nLin += nPulLin * 3

If !lPrim

	oPrn:Say(nLin,aCol[2] + 120,"Informamos que se o (os) título (os) não estiver (em) quitado (os) até a data abaixo, esta cobrança",oFont12TN,,CLR_LARANJA)
	
	nLin += nPulLin
	
	oPrn:Say(nLin,aCol[3] + 160,"será automaticamente direcionada ao Cartório.",oFont12TN,,CLR_LARANJA)
 
 	nLin += nPulLin * 2
 	
 	oPrn:Say(nLin,aCol[4] + 070,DtoC(dCart),oFont12TN,,CLR_LARANJA)

	nLin += nPulLin * 3
EndIf


oPrn:Say(nLin,230,"Se o (os) título (os) já estiver (em) sido (os) pago (s), pedimos a gentileza de nos enviar por e-mail o comprovante de pagamento.",oFont12T)

nLin += nPulLin  * 3

oPrn:Say(nLin,525,"Agradecemos a atenção e nos colocamos à disposição para maiores esclarecimentos.",oFont12T)

nLin += nPulLin*3

oPrn:SayBitmap(nLin+10,380         ,GetSrvProfString("Startpath","") + "ass_sup.bmp",177,080)
oPrn:SayBitmap(nLin+10,aCol[6] - 25,GetSrvProfString("Startpath","") + "ass_ger.bmp",225,091)

nLin += nPulLin*2

oPrn:Line(nLin-10,300          ,nLin-10,600)
oPrn:Line(nLin-10,aCol[6] - 090,nLin-10,aCol[6] + 230)

nLin += nPulLin

oPrn:Say(nLin,390       ,"Érica Santos"  ,oFont12T)
oPrn:Say(nLin,aCol[6]-20,"Rafael Capella",oFont12T)

nLin += nPulLin

oPrn:Say(nLin,400       ,"Tesouraria"         ,oFont12T)
oPrn:Say(nLin,aCol[6]-50,"Gerência Financeira",oFont12T)

nLin += nPulLin * 6


oPrn:Say(nLin,aCol[4]-210,AllTrim(SM0->M0_NOMECOM),oFont11A)

nLin += nPulLin

oPrn:Say(nLin,aCol[4]-400,AllTrim(SM0->M0_ENDCOB) + " - " + cMun + " - " + SM0->M0_ESTCOB + " CEP: " + SM0->M0_CEPCOB,oFont11A)

nLin += nPulLin

oPrn:Say(nLin,aCol[4]-170,"Fone: " + AllTrim(SM0->M0_TEL) + " / " + " Fax: " + AllTrim(SM0->M0_FAX),oFont11A)

nLin += nPulLin

oPrn:Say(nLin,aCol[4]-070,"www.mc-bauchemie.com.br"     ,oFont11A)

nLin += nPulLin

oPrn:Say(nLin,aCol[4]-115,"cobranca@mc-bauchemie.com.br",oFont11A)

oPrn:EndPage()
oPrn:Print()
	
//oPrn:Preview()
/*
FreeObj(oPrn)
oPrn := Nil
*/

//Caso o arquivo não exista dá erro.
If File("C:\TOTVS\" + cFile)

	While File(MsDocPath() + "\" + cFile)
		FErase(MsDocPath() + "\" + cFile)
		
		Sleep(1000)
	EndDo		

	__CopyFile("C:\TOTVS\" + cFile,MsDocPath() + "\" + cFile)
	
	If File(MsDocPath() + "\" + cFile) 
		cArq := MsDocPath() + "\" + cFile
		
	Else
		Alert("Erro na cópia do relatório!")	
	EndIf	

Else
	Alert("Carta de cobrança não gerada, favor verificar!")

EndIf

RestArea(aAreaSM0)
RestArea(aArea)

Return cArq