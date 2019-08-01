#Include "Protheus.ch"
#include "topconn.ch"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MBRFAT04  ºAutor  ³ Gerson 			 º Data ³ 13/07/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Ordem de Separacao de Carga.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MBRFAT04()

Local cPerg		:=	"FAT04"     

Private ENTER   := CHR(13)+CHR(10)
Private nCol1	:= 40    
Private nCol2	:= nCol1  + 200
Private nCol3	:= nCol2  + 200    
Private nCol4	:= nCol3  + 200        
Private nCol5	:= nCol4  + 200    
Private nCol6	:= nCol5  + 200    
Private nCol7	:= nCol6  + 200    
Private nCol8	:= nCol7  + 200    
Private nCol9	:= nCol8  + 200    
Private nCol10	:= nCol9  + 200    

ValidPerg(cPerg)

If	!Pergunte(cPerg,.t.)
	Return ( .t. )
EndIf                

Processa({||fExecImp() },"Aguarde... Imprimindo Relatório !!!" )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³fExecImp     º Autor ³ Gerson Rovere Schiavo º Data: 04/02/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³  Impressão do Relatório                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fExecImp(aReceita,aDespesa,aRecTot,aOutRec)

Local nPag		:= 1
Local cCarga	:= CriaVar("C9_CARGA")
Local cPedido	:= CriaVar("C9_PEDIDO")
Local cNotaF	:= CriaVar("C9_NFISCAL")
Local cSeqEnt	:= ""
Local nTotalVol := 0
Local nCubagem	:= 0
local nPesoBruto:= 0
Local cChave    := ""
Local nVolume   := 0
Local nQtde     := 0
Local cProduto  := ""
Local xcQuery	:=	""
Local xcR		:=	Char(13) + Char(10)

Private nLastKey	:= 0
Private nLin   		:= 9000
Private oPrint		:= TMSPrinter():New("Ordem de Separação")
Private nLimite 	:= 2500     //3395
Private lBrush		:= NIL         
Private oFont09a	:= TFont():New("Arial", 07, 07,, .F.,,,, .T., .F.)
Private oFont10b	:= TFont():New("Arial", 10, 09,, .T.,,,, .T., .F.)
Private oFont10a	:= TFont():New("Arial", 08, 08,, .F.,,,, .T., .F.)
Private oFont12		:= TFont():New("Arial", 09, 09,, .F.,,,, .T., .F.)
Private oFont12a	:= TFont():New("Arial", 09, 09,, .T.,,,, .T., .F.)
Private oFont13		:= TFont():New("Arial", 12, 12,, .F.,,,, .T., .F.)
Private oFont13a	:= TFont():New("Arial", 12, 12,, .T.,,,, .T., .F.)
Private oBrush		:= TBrush():New(, 4)      
Private lCont       :=.T. 
Private lCabec      := .T.

oPrint:SetPortrait()
             
************************************************************************************************************************       
************************************************************************************************************************       
//Selecao dos Registros para impressao do relatorio
************************************************************************************************************************       
************************************************************************************************************************       
xcQuery	:= 			"SELECT  "
xcQuery += xcR + 	"	C9_PEDIDO,C9_CLIENTE,C9_LOJA,C9_PRODUTO,  "
xcQuery += xcR + 	"    C9_CARGA,C9_SEQENT,C9_QTDLIB,C9_NFISCAL, "
xcQuery += xcR + 	"    B1_DESC,B1_UM,B1_CONV,B1_TIPCONV,B1_QE,B1_ZZADD,B1_PESBRU, "
xcQuery += xcR + 	"    C5_TRANSP,C5_NOTA,C5_REDESP,C5_ZZOBEXP,C5_ZZOBPED  "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SC9') + " A INNER JOIN  "
xcQuery += xcR + 	"	" + RetSqlName('SB1') + " B ON "
xcQuery += xcR + 	"	B1_COD = C9_PRODUTO INNER JOIN  "
xcQuery += xcR + 	"	" + RetSqlName('SC5') + " C ON "
xcQuery += xcR + 	"	C5_NUM = C9_PEDIDO AND  "
xcQuery += xcR + 	"	C5_CLIENTE = C9_CLIENTE AND  "
xcQuery += xcR + 	"	C5_LOJACLI = C9_LOJA  "
xcQuery += xcR + 	" WHERE  "
xcQuery += xcR + 	"	C9_FILIAL = '" + xFilial('SC9') + "' 	AND "
xcQuery += xcR + 	"	B1_FILIAL = '" + xFilial('SB1') + "' AND  "
xcQuery += xcR + 	"	C5_FILIAL = '" + xFilial('SC5') + "' AND  "
xcQuery += xcR + 	"	C9_CARGA  BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "
xcQuery += xcR + 	"	C9_PEDIDO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = ' ' AND "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = ' ' AND "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = ' ' "
xcQuery += xcR + 	" ORDER BY  "
xcQuery += xcR + 	"	C9_CARGA, C9_PEDIDO, C9_PRODUTO "

//Gera um arquivo com a query acima.
MemoWrite("MBRFAT04.sql",xcQuery)

if select('QRY') > 0
	QRY->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias QRY

              
QRY->(dbGotop())
                      
ProcRegua(RecCount())
While !QRY->(Eof())
    cObsPed	:= QRY->C5_ZZOBPED
    cObsExp	:= QRY->C5_ZZOBEXP
	cCarga	:= QRY->C9_CARGA
	cSeqEnt	:= QRY->C9_SEQENT
	cPedido	:= QRY->C9_PEDIDO
	cNotaF	:= QRY->C9_NFISCAL
                          
	While !QRY->(Eof()) .and. QRY->C9_CARGA == cCarga  .and. QRY->C9_PEDIDO == cPedido
	
		if cChave != QRY->C9_CARGA+QRY->C9_PEDIDO
			lCabec := .T.
			cChave := QRY->C9_CARGA+QRY->C9_PEDIDO 
		endif  	
	    
		if cProduto != QRY->C9_PRODUTO       // daniel
			cProduto := QRY->C9_PRODUTO
			nQtde := RetQtdeLib(QRY->C9_PEDIDO,QRY->C9_PRODUTO)
			dbSelectArea("SB5")
			dbSetOrder(1)
			dbSeek(xFilial("SB5")+QRY->C9_PRODUTO)
		
			IncProc("Produto: "+Alltrim(QRY->C9_PRODUTO))
		    
			if nLin >= 3100//2100
				oPrint:EndPage()   										// Encerra a pagina atual.
				fImpCab(@nPag,cCarga,cSeqEnt,cPedido,cNotaF)			// Chama o cabecalho.
			endIf

			oPrint:Say(nLin,nCol1 ,Transform(nQtde	,"@E 99,999,999")					,oFont10a)
			oPrint:Say(nLin,nCol2 ,QRY->B1_UM												,oFont10a)
			oPrint:Say(nLin,nCol3 ,QRY->B1_DESC												,oFont10a)
			oPrint:Say(nLin,nCol7 ,QRY->C9_PRODUTO											,oFont10a,,,,nil)
			oPrint:Say(nLin,nCol8 ,Transform(U_MBCALVOL(QRY->C9_PRODUTO, nQtde)	,"@E 99,999,999")		,oFont10a)
			oPrint:Say(nLin,nCol9 ,Transform(SB5->B5_ZZEMPMX,"@E 999,999,999")				,oFont10a,,,,nil)
			oPrint:Say(nLin,nCol10,"__________________________"								,oFont10a)
			
			nLin+= 70
	        
	        nPesoBruto += QRY->B1_PESBRU * nQtde
	    	nTotalVol+= U_MBCALVOL(QRY->C9_PRODUTO,nQtde,.t.)
	

	    	nCubagem += U_MBCALCUB(QRY->C9_PRODUTO,nQtde,.t.)
	
			if !EMPTY(QRY->B1_ZZADD) //Produtos que possuem TAMPA             
	
				dbSelectArea("SB1")
				dbSetOrder(1)
				if dbSeek(xFilial("SB1")+QRY->B1_ZZADD) //Codigo do Produto correspondente a Tampa
				                             
					
	    			dbSelectArea("SB5")
					dbSetOrder(1)
					dbSeek(xFilial("SB5")+QRY->B1_ZZADD)

					oPrint:Say(nLin,nCol1 ,Transform(nQtde	,"@E 99,999,999")					,oFont10a)
					oPrint:Say(nLin,nCol2 ,SB1->B1_UM													,oFont10a)
					oPrint:Say(nLin,nCol3 ,SB1->B1_DESC													,oFont10a)
					oPrint:Say(nLin,nCol7 ,SB1->B1_COD												,oFont10a,,,,nil)
					oPrint:Say(nLin,nCol8 ,Transform(U_MBCALVOL(QRY->C9_PRODUTO, nQtde)	,"@E 99,999,999")			,oFont10a)
					oPrint:Say(nLin,nCol9 ,Transform(SB5->B5_ZZEMPMX,"@E 999,999,999")				,oFont10a,,,,nil)
					oPrint:Say(nLin,nCol10,"__________________________"								,oFont10a)
					nLin+= 70
					

				EndIf
			EndIf
        EndIf
		QRY->(dbSkip())
    EndDo
    
	nLin+= 100
    
    If nLin >= 4100//3100
		oPrint:EndPage()   								// Encerra a pagina atual.
		fImpCab(@nPag,cCarga,cSeqEnt,cPedido,cNotaF)	// Chama o cabecalho.
	EndIf

	nLin += 50
	oPrint:Say(nLin,0020,Replicate("_",500) 						,oFont10a)
	nLin += 050
	oPrint:Say(nLin,nCol1 ,"TOTAL DE VOLUMES ====>"					,oFont10a)
	oPrint:Say(nLin,nCol4 ,Transform(nTotalVol	,"@E 99,999,999")	,oFont10a,,,,PAD_RIGHT)
	oPrint:Say(nLin,nCol5 ,"CUBAGEM ====>"							,oFont10a)
	oPrint:Say(nLin,nCol7 ,Transform(nCubagem	,"@E 9999,999.999")+" M3"	,oFont10a,,,,PAD_RIGHT)
	oPrint:Say(nLin,nCol9 ,"Peso Bruto ====>          "+Transform(nPesoBruto	,"@E 9999,999.999")	+" KG"	,oFont10a)
	nLin += 50                                                                                 
	oPrint:Say(nLin,0020,Replicate("_",500) 						,oFont10a)
	nLin += 050  
		                     
	
	if nLin >= 3100//2100
		oPrint:EndPage()   								// Encerra a pagina atual.
		fImpCab(@nPag,cCarga,cSeqEnt,cPedido,cNotaF)	// Chama o cabecalho.
	endIf     
	             
	nLin+= 120  
	oPrint:Say(nLin,nCol1 ,"OBSERVAÇÔES EXPEDIÇÃO: "+AllTrim(cObsExp)				,oFont13a)             
	nLin+=80
	oPrint:Say(nLin,nCol1 ,"OBSERVAÇÔES PEDIDO: "+AllTrim(cObsPed)				,oFont13a)             
	nLin+=80
	oPrint:Say(nLin,nCol4 ,"CARGA Nr. "+ cCarga + " DOCA:__________________________"				,oFont13a)             
	nLin+=130
	oPrint:Say(nLin,nCol1 ,"EU,___________________________________________________________________  RG:______________________________  DATA: _______/_______/______"	,oFont10a)             
	nLin+=70
	oPrint:Say(nLin,nCol1 ,"DECLARO TER CONFERIDO AS MERCADORIAS E ESTOU CIENTE QUE A MB NÃO SE RESPONSABILIZA POR EVENTUAIS FALTAS."						,oFont10a)             
	nLin+=70
	oPrint:Say(nLin,nCol1 ,"Usuário: "+cUserName		,oFont10a)             
	                                   
	nTotalVol:= 0
	nCubagem := 0   
	nPesoBruto :=0
	
    nLin:= 999999
enddo

QRY->(dbCloseArea())

oPrint:EndPage()

Titulo := "Ordem de Separação"
Define MsDialog oDlga Title "Impressão do Relatório" From 0,0 To 250,430 Pixel
Define Font oBold Name "Arial" Size 0, -13 Bold
@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlga Size 30, 120 NoBorder When .F. Pixel
@ 003, 040 Say Titulo Font oBold Pixel
@ 014, 030 To 016, 400 Label '' Of oDlga  Pixel
@ 020, 040 Button "Configurar" 	Size 40,13 Pixel Of oDlga Action oPrint:Setup()
@ 020, 082 Button "Imprimir"   	Size 40,13 Pixel Of oDlga Action oPrint:Print()
@ 020, 124 Button "Visualizar" 	Size 40,13 Pixel Of oDlga Action (oPrint:Preview(), oDlga:End())
@ 020, 166 Button "Sair"       	Size 40,13 Pixel Of oDlga Action oDlga:End()
Activate MsDialog oDlga Centered

Ms_Flush()

Return       

            
*************************************************************************************************************************************
&& Funcao para impressão do Cabeçalho
*************************************************************************************************************************************
Static Function fImpCab(nPag,cCarga,cSeqEnt,cPedido,cNotaF)
    
Local nCol		:= 200   
Local cSeqCar 	:= ""
Local nCont 	:= 0
Local cCf 		:= ""
Default cCarga 	:= ""
Default cSeqEnt := ""

nLin := 12

If nPag != 1
	oPrint:EndPage()
EndIf

oPrint:StartPage()

oPrint:Say(nLin,0020,Replicate("_",500) 							,oFont10a)
nLin += 050
oPrint:Say(nLin,10,'Data Emissão/Entrega:'+DTOC(POSICIONE("SC5",1,xFilial("SC5")+cPedido,"C5_EMISSAO"))+"  -  "+DTOC(POSICIONE("SC6",1,xFilial("SC6")+cPedido,"C6_ENTREG"))  ,oFont10a,,,,nil)
oPrint:Say(nLin,2000,'User Print:'+AllTrim(cUserName)  ,oFont10a,,,,nil)
oPrint:Say(nLin,nLimite/2,'ORDEM DE SEPARAÇÃO NR. '+cPedido	,oFont13a,,,,PAD_CENTER)
nLin += 50
oPrint:Say(nLin,nLimite/2,'CARGA:'+cCarga+"/Sequência:"+cSeqEnt,oFont13a,,,,PAD_CENTER)
nLin += 050
oPrint:Say(nLin,10,'DIGITADOR:'+Embaralha(POSICIONE("SC5",1,xFilial("SC5")+cPedido,"C5_USERLGI"),1) +"   /   Faturista:"+RetFaturista(cPedido) ,oFont10a,,,,NIL)
If !Empty(cNotaF)
	//nLin += 50
	oPrint:Say(nLin,nLimite/2,'NOTA FISCAL NR. '+cNotaF			 	,oFont13a,,,,PAD_CENTER)
	nLin += 50
	cSeqCar := Posicione("SF2",1,xFilial("SF2")+cNotaf,"F2_SEQCAR")
	cCarga  := Posicione("SF2",1,xFilial("SF2")+cNotaf,"F2_CARGA")
	cSeqEnt := Posicione("SF2",1,xFilial("SF2")+cNotaf,"F2_SEQENT")

	nLin += 50
	oPrint:Say(nLin,nLimite/2,'ROTA:'+Posicione	("DAK",1,xFilial("DAK")+cCarga+cSeqCar,"DAK_ROTEIR")+"  SETOR:"+Posicione("DAI",1,xFilial("DAI")+cCarga+cSeqCar+cSeqEnt+cPedido,"DAI_ROTA")		 	,oFont13a,,,,PAD_CENTER) 
EndIf
oPrint:Say(nLin,2000,"Página : "+StrZero(nPag,3)					,oFont10a,,,,nil)
nLin += 50

oPrint:Say(nLin,2000,"Emissao: "+DtoC(dDatabase)+ "   Hora:"+Time()					,oFont10a,,,,nil)
nLin += 50                                                                                               
if lCont
	nCont:= getMv("MV_ZZRELCA")   
	nCont++
	PutMv("MV_ZZRELCA",nCont)
	lCont:=.F.
else
   nCont := getMv("MV_ZZRELCA")

endif	

oPrint:Say(nLin,2000,"Qtde Impressão: "+cValToChar(nCont)					,oFont10a,,,,nil)

nLin += 50 
oPrint:Say(nLin,0020,Replicate("_",500) 							,oFont10a)
nLin += 050  
if lCabec 
dbSelectArea("SA1")
dbSetOrder(1)
dbseek(xFilial("SA1")+QRY->C9_CLIENTE+QRY->C9_LOJA)

//Dados do Cliente
oPrint:Say(nLin,nCol1 ,"CLIENTE..: "+QRY->C9_CLIENTE+" - "+Alltrim(SA1->A1_NOME)+Space(10)+iif(SA1->A1_PESSOA ="F","(Física)","(Jurídica)")+Space(10)+"F: "+SA1->A1_TEL ,oFont10a)
nLin+= 50
oPrint:Say(nLin,nCol1 ,"ENDEREÇO.: "+SA1->A1_END  					,oFont10a)
oPrint:Say(nLin,nCol5 ,"CEP: "+SA1->A1_CEP  						,oFont10a)
nLin+= 50
oPrint:Say(nLin,nCol1,"BAIRRO...: "+Sa1->A1_BAIRRO					,oFont10a)
oPrint:Say(nLin,nCol4,"CIDADE: "+SA1->A1_MUN						,oFont10a)
oPrint:Say(nLin,nCol7,"UF: "+SA1->A1_EST							,oFont10a)
nLin+= 50
if Empty(SA1->A1_ENDENT)
	oPrint:Say(nLin,nCol1 ,"ENTREGA..: O Mesmo"						,oFont10a)
	nLin+= 50
else
	oPrint:Say(nLin,nCol1 ,"ENTREGA..: "							,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1 ,"ENDEREÇO.: "+SA1->A1_ENDENT				,oFont10a)
	oPrint:Say(nLin,nCol5 ,"CEP: "+SA1->A1_CEPE 					,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"BAIRRO...: "+SA1->A1_BAIRROE				,oFont10a)
	oPrint:Say(nLin,nCol4,"CIDADE: "+SA1->A1_MUNE					,oFont10a)
	oPrint:Say(nLin,nCol7,"UF: "+SA1->A1_ESTE						,oFont10a)
	nLin+= 50   
endif 
oPrint:Say(nLin,nCol1,"CNPJ.....: "+SA1->A1_CGC						,oFont10a)
oPrint:Say(nLin,nCol3,"I.E: "+SA1->A1_INSCR							,oFont10a)
nLin+= 50
cCf := Posicione("SD2",8,xFilial("SD2")+QRY->C9_PEDIDO,"D2_CF")
if !Empty(cCf)
	oPrint:Say(nLin,nCol1,"OP.FISCAL: "	+cCf+"-"+tabela("13",cCf)			,oFont10a)
endif	
nLin +=50
oPrint:Say(nLin,nCol1,"Observação:"/*+AllTrim(SA1->A1_ZZOBS)*/					,oFont10a)  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

nLin += 50                                                                                 
oPrint:Say(nLin,0020,Replicate("_",500) 							,oFont10a)
nLin += 050  

dbSelectArea("SA4")
dbSetOrder(1)
dbseek(xFilial("SA4")+QRY->C5_REDESP)

//Dados da Transportadora           
oPrint:Say(nLin,nCol1,"TRANSPORTADORA..: "+Alltrim(SA4->A4_COD)+"-"+SA4->A4_NOME				,oFont10a)
nLin+= 50
oPrint:Say(nLin,nCol1 ,"NOME FANTASIA..: "+SA4->A4_NREDUZ			,oFont10a)
nLin+= 50
if Empty(SA4->A4_ZZEND)
	oPrint:Say(nLin,nCol1 ,"ENDEREÇO.......: "+Alltrim(SA4->A4_END)+"   BAIRRO: "+Alltrim(SA4->A4_BAIRRO)				,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"CIDADE: "+Alltrim(SA4->A4_MUN)+ "   UF: "+Alltrim(SA4->A4_EST)+"    FONE: "+AllTrim(SA4->A4_DDD)+"-"+AllTrim(SA4->A4_TEL),oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"NEXTEL:  "+SA4->A4_ZZIDNEX+"  VOLUME MÁX:"+cValTochar(SA4->A4_ZZQTDVL)	,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"OBSERVAÇÃO:"+AllTrim(SA4->A4_ZZOBS)	,oFont10a)  
else 
	oPrint:Say(nLin,nCol1 ,"ENDEREÇO.......: "+Alltrim(SA4->A4_ZZEND)+"   BAIRRO: "+Alltrim(SA4->A4_ZZBAI)				,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"CIDADE: "+Alltrim(SA4->A4_ZZMUN)+ "   UF: "+Alltrim(SA4->A4_ZZEST)+"    FONE: "+AllTrim(SA4->A4_DDD)+"-"+AllTrim(SA4->A4_TEL)	,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"NEXTEL:  "+SA4->A4_ZZIDNEX +"  VOLUME MÁX:"+cValToChar(SA4->A4_ZZQTDVL)	,oFont10a)
	nLin+= 50
	oPrint:Say(nLin,nCol1,"OBSERVAÇÃO:"+AllTrim(SA4->A4_ZZOBS)			,oFont10a)  
endif	
nLin +=50

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		lCabec := .F.

endif 				
nLin += 70                                                                                 
oPrint:Say(nLin,0020,Replicate("_",500) 			,oFont13)
nLin += 050  

oPrint:Say(nLin,nCol1 ,"QTD."						,oFont10a)
oPrint:Say(nLin,nCol2 ,"UNI"						,oFont10a)
oPrint:Say(nLin,nCol3 ,"DESCRIÇÃO DA MERCADORIA"		,oFont10a)
oPrint:Say(nLin,nCol7 ,"REF."						,oFont10a)
oPrint:Say(nLin,nCol8 ,"VOLUMES"					,oFont10a)
oPrint:Say(nLin,nCol9 ,"EMP. MÁXIMO"				,oFont10a)
oPrint:Say(nLin,nCol10,"CONFERENTE"				,oFont10a)

nLin += 030                     
oPrint:Say(nLin,0020,Replicate("_",500) 							,oFont10a)
nLin += 055

nPag ++

Return

      


**********************************************************************************************************
**********************************************************************************************************
Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs   := {}
Local i, j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := Padr(cPerg, Len(X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Carga De  :","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Carga Até :","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Pedido De :","","","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
aAdd(aRegs,{cPerg,"04","Pedido Até:","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})   

For i := 1 to Len(aRegs)
	If 	!dbSeek( cPerg + aRegs[i,2] )
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock("SX1")
	Endif
Next

dbSelectArea(_sAlias)

Return 
Static Function RetFaturista(cPedido)
Local cNota  	:= Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_NOTA")
Local cSerie 	:= Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_SERIE")
Local cUserNome := Embaralha(Posicione("SF2",1,xFilial("SF2")+cNota+cSerie,"F2_USERLGI"),1)

Return cUserNome   
/*Funcao criada por Daniel para pegar o total de qtde quando e liberamento parcia de qtde*/
Static Function RetQtdeLib(cPedido,cProduto)
Local nQtdeLib :=  0
Local cQuery   := ""

cQuery := "SELECT C9_QTDLIB FROM "+RetSqlName("SC9")+" WHERE C9_PEDIDO = '"+cPedido+"' AND C9_PRODUTO = '"+cProduto+"' AND D_E_L_E_T_=''"
TcQuery cQuery New Alias 'TQTD'    

While TQTD->(!EOF())

nQtdeLib+=TQTD->C9_QTDLIB

TQTD->(dbSkip())
endDo

TQTD->(dbCloseArea())
return nQtdeLib
