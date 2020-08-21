#Include "PROTHEUS.CH"
#Include "FONT.CH"
#Include "COLORS.CH"
#INCLUDE "FINA460.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWMVCDEF.CH"

Static lOpenCmc7
Static nJCDEntrad
Static nJCDTxJuro
Static nJCDTxPer
Static nJCDParcel
Static nJCDInterv
Static nJCDValMin
Static nJCDValMax
Static nJCDBanco
Static nJCDAgenci
Static nJCDNumCon
Static aPrefixo                              
STATIC __lDefTop	:= NIL
Static lGrvLiqSE5	:= ExistBlock("GRVLIQSE5")

Static cComiLiq 	:= SuperGetMv("MV_COMILIQ",,"2")
Static lComiLiq	:= ComisBx("LIQ") .AND. cComiLiq == "1"
Static lTpComis	:= GETMV("MV_TPCOMIS") == "O"

//Vari醰eis para integra玢o via mensagem 鷑ica
Static __aBaixados := {} 
Static __aNovosTit := {}
Static __cNroLiqui := ''
//Vari醰eis para integra玢o via mensagem 鷑ica

Static dLastPcc  := CTOD("22/06/2015")
Static lTxEdit := .F. //validar se a taxa foi editada

Static __oFINA4601
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    ?FINA460  ?Autor ?Mauricio Pequim Jr    ?Data ?21.01.98  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噭o ?Programa de Liquida噭o                                      潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
static function aFINA460(nPosArotina,xAutoCab,xAutoItens,xOpcAuto,xAutoFil,xNumLiq)

Local lPanelFin := IsPanelFin()
Local lFa460Rot := Existblock("FA460ROT")

SaveInter()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Alguns pontos de entrada foram incluidos para necessidades   ?
//?especificas na empresa 4K, pois devido ao alto volume de che-?
//?ques a liquidar existe a necessidade de alguns controles para?
//?lelos em relacao a manipulacao dos registros e log de usuari-?
//?os.                                               			 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

Private aPos   		:= {  15,  1, 70, 315 }
Private cCadastro	:= STR0001 //"Liquida噭o"
Private cLote
Private lAltera		:= .F.
Private lUsaGE		:= Upper(AllTrim(FunName())) == "ACAA710" 
Private	lhlplog 	:= .T.
Private lOpcAuto	:=(xOpcAuto<>Nil)
Private aAutoCab	:=If(xAutoCab<>Nil	,xAutoCab,{})
Private aAutoItens	:=If(xAutoItens<>Nil,xAutoItens,{})
Private nOpcAuto	:=If(xOpcAuto<>Nil	,xOpcAuto,0)
Private cAutoFil	:=If(xAutoFil<>Nil	,xAutoFil,"")
Private cNumLiqCan	:=If(xNumLiq<>Nil	,xNumLiq,"")

Private lOracle := "ORACLE" $ Upper(TcGetDB())
Private cMatApl := " NULL "
Private nCodSer := " NULL "
Private lMsgUnq	:= FWHasEai('FINA460',.T.,,.T.) .AND. FWHasEai('FINA040',,.T.,.T.)//indica se usa gera玢o de t韙ulo por mensagem unica. 

Default nPosArotina := 0

Private aRotina := MenuDef()  
Fa460MotBx("LIQ","LIQUIDACAO","ANSS")


HelpLog(.t.)
SetKey (VK_F12,{|a,b| AcessaPerg("AFI460",.T.)})

pergunte("AFI460",.F.)

If nPosArotina > 0
	dbSelectArea('SE1')
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
   If lOpcAuto
		If nOpcAuto==3
			A460Liquid("SE1",SE1->(Recno()),2)//Liquidacao
		ElseIf nOpcAuto==4
			A460Liquid("SE1",SE1->(Recno()),4)//Reliquidacao
		Elseif nOpcAuto==5
			FA460CAN("SE1",SE1->(Recno()),4)
		EndIf
   Else
	   SetKey (VK_F12,{|a,b| AcessaPerg("AFI460",.T.)})
		mBrowse( 6, 1,22,75,"SE1",,,,,, Fa040Legenda("SE1"))
	EndIF
Endif
If SuperGetMv("MV_CMC7FIN") == "S" .And. !lOpcAuto
	If nHdlCmC7 >= 0
		CMC7Fec(nHdlCmC7,SuperGetMv("MV_CMC7PRT"))
	Endif
Endif

RestInter()

Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矨460Liquid?Autor ?Mauricio Pequim Jr.   ?Data ?1.01.98  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Programa de Inclusao de Liquida噭o                         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso      ?FINA460                                                    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460Liquid(cAlias,nReg,nOpcx)

Local cChave	:= ""	
Local cMoeda	:= ""
Local cVar		:= ""
Local cMoeda460	:= ""
Local aMoedas	:= {}
Local TRB		:= ""
Local cVar1 	:= STR0063		//"01 EMISSAO   "
Local cIntervalo:= STR0063		//"01 EMISSAO   "
Local cSimb		:= ""
Local cCli460	:= ""
Local cOutrMoed := STR0136 //"2 - Nao Considera"
Local nTamTit	:= TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]+TamSX3("E1_TIPO")[1]
Local nTamChave	:= TamSX3("E1_FILIAL")[1]+TamSX3("E1_CLIENTE")[1]+TamSX3("E1_LOJA")[1]+nTamTit
local nTamHist	:= TamSX3("E1_HIST")[1]
Local nOpca    	:= 0
Local nCntFor	:= 0
Local nX 		:= 0
Local nT		:= 0
Local nTamNome	:= Len(FWFilialName())+5
Local nTimeOut  := SuperGetMv("MV_FATOUT",,900)*1000 	// Estabelece 15 minutos para que o usuarios selecione
Local nTimeMsg  := SuperGetMv("MV_MSGTIME",,120)*1000 	// Estabelece 02 minutos para exibir a mensagem para o usu醨io                                                       	
														// informando que a tela fechar?automaticamente em XX minutos
Local aIntervalo:= { STR0063, STR0064 }		//"01 EMISSAO   "###"02 VENCIMENTO"
Local aNrDoc	:= {}
Local aClients	:= {""}
Local aButtons	:= {}
Local aTamBco 	:= TamSx3("E1_BCOCHQ")
Local aTamAge 	:= TamSx3("E1_AGECHQ")
Local aTamCta 	:= TamSx3("E1_CTACHQ")
Local aTam    	:= TamSX3("E1_NUM")
Local aOutrMoed := {STR0135,STR0136} //"1 - Converte"###"2 - Nao Considera"
local nTamMoed	:= TamSX3("M2_MOEDA2")[2] 
Local aAltera 	:= {}
Local aAreaSe1	:= SE1->(GetArea())
Local cMvJurTipo	:= SuperGetMv("MV_JURTIPO",,"")  // calculo de Multa do Loja , se JURTIPO == L
Local lMulLoj		:= SuperGetMv("MV_LJINTFS", ,.F.) //Calcula multa conforme regra do loja, se integra玢o com financial estiver habilitada
Local aCampos 	:= {{"MARCA"   	,"C", 2,0},;
					{"FILIALX"	,"C",nTamNome,0},;  
					{"TITULO"	,"C",nTamTit+3,0},;
					{"MOEDAO"	,"N", 2,0},;			//Moeda do Titulo
					{"CTMOED"	,"N",10,nTamMoed},;			//Moeda do Titulo
					{"VALORI"	,"N",15,2},;			//Valor original do titulo 		
					{"ABATIM"	,"N",15,2},;
					{"BAIXADO"	,"N",15,2},;
					{"VALCVT"	,"N",15,2},;			//Valor convertido para a moeda escolhida
					{"JUROS"	,"N",15,2},;
					{"VLMULTA"	,"N",15,2},;
					{"DESCON"	,"N",15,2},;
					{"VALLIQ"	,"N",15,3},;
					{"EMISSAO"	,"D",08,0},;
					{"VENCTO"	,"D",08,0},;
					{"ACRESC"	,"N",15,2},;
					{"DECRESC"	,"N",15,2},;
					{"HISTOR"	,"C",nTamHist,0},;
					{"CHAVE"	,"C",nTamChave,0},;
					{"CHAVE2"	,"C",nTamChave,0},;
					{"BASEIMP"	,"N",15,2},;
					{"PIS"		,"N",15,2},;
					{"COFINS"	,"N",15,2},;
					{"CSLL"		,"N",15,2},;
					{"OUTRIMP"	,"N",15,2},;
					{"TITPAI"	,"C",nTamChave,0},;
					{"MULTALJ"	,"N",15,2},;
					{"BKPVLLIQ" ,"N",15,3},;
					{"BKPDESC"  ,"N",15,3}}						
					

Local aCpoBro	:= {{ "MARCA"  ,, " "    ,"  "},;
					{ "FILIALX",, SE2->(RetTitle("E1_FILIAL")),"@!"},; 	//Filial
					{ "TITULO" ,, STR0079,"@X"},;  					//"Nero Tulo"
					{ "MOEDAO" ,, STR0134,"@E 99"},;				//"Moeda"
					{ "CTMOED" ,, STR0139,"@E 9,999.9999"},;	 	//"Cotacao"
					{ "VALORI" ,, STR0080,"@E 9,999,999,999.99"},;  //"Vlr.Original"
					{ "ABATIM" ,, STR0082,"@E 9,999,999,999.99"},;  //"Vlr.Abatim."
					{ "BAIXADO",, STR0106,"@E 9,999,999,999.99"},;  //"Vlr.Baixado"
					{ "VALCVT" ,, STR0138,"@E 9,999,999,999.99"},;  //"Valor em "
					{ "JUROS"  ,, STR0081,"@E 9,999,999,999.99"},;  //"Vlr.Juros"
					{ "DESCON" ,, STR0083,"@E 9,999,999,999.99"},;  //"Vlr.Descon."
					{ "VALLIQ" ,, STR0084,"@E 9,999,999,999.99"},;  //"Vlr.Liquidar"
					{ "EMISSAO",, STR0085,"@X"},;  					//"Data Emiss苚"
					{ "VENCTO" ,, STR0086,"@X"},;                   //"Data Vencimento"
					{ "HISTOR" ,, STR0177,"@X"}}   					//Historico
					
Local lPanelFin	:= IsPanelFin()
Local lContinua	:= .T.
Local lA460Col	:= ExistBlock("A460COL") // Permite a altera玢o de aCols, aHeader
Local lF460NUM 	:= ExistBlock("F460NUM")
Local lF460Can	:= Existblock("F460CAN")
Local lF460Con	:= Existblock("F460CON")
Local lBaseImp	:= F040BSIMP(2)
Local oCbx
Local oCbx2
Local oTimer
Local oValorDe
Local oValorAte
Local oDlg
Local oDlg2
Local oFnt
Local oMark		
Local oNrDoc
local oClients
Local oValorMax
Local oValor	:= 0
Local oQtdTit	:= 0

//Gestao
Local lGestao	    := FWSizeFilial() > 2	// Indica se usa Gestao Corporativa
Local lSE1Access	:= Iif( lGestao, FWModeAccess("SE1",1) == "E", FWModeAccess("SE1",3) == "E")
Local cQuery		:= ""
Local aSelFil		:= {}
Local aTmpFil		:= {} 
Local cAliasSE1		:= ""
Local cIndexTrb		:= ""
Local lProcessou	:= .F. 
Local nTamLiq    	:= TamSX3("E1_NUMLIQ")[1]
Local oSize

Local oFilInt
Local aFilInt		:=  {"1=Sim","2=N鉶"} 

Private cLiquid		:= Space(nTamLiq)
Private cCliente 	:= Criavar ("E1_CLIENTE",.F.)
Private cLoja    	:= Criavar ("E1_LOJA",.F.)
Private cCliDE	 	:= Criavar ("E1_CLIENTE",.F.)
Private cLojaDE  	:= Criavar ("E1_LOJA",.F.)
Private cCliAte 	:= Criavar ("E1_CLIENTE",.F.)
Private cLojaAte 	:= Criavar ("E1_LOJA",.F.)
Private cNomeCli	:= CriaVar ("E1_NOMCLI")
Private cNatureza	:= Criavar ("E1_NATUREZ")
Private cTipo		:= Criavar ("E1_TIPO")
Private cCondicao	:= Space(3)			// numero de parcelas automaticas
Private cNumDe		:= CriaVar("E1_NUM")
Private cNumAte		:= CriaVar("E1_NUM")
Private cPrefDe		:= CriaVar("E1_PREFIXO")
Private cPrefAte	:= CriaVar("E1_PREFIXO")
Private cMarca		:= GetMark()
Private cParc460	:= F460Parc()		// controle de parcela (E1_PARCELA)
Private cNumRA		:= If(lUsaGE, Space(TamSx3("JA2_NUMRA")[1])," ")
Private cNomeAlu	:= If(lUsaGE, Space(TamSx3("JA2_NOME")[1])," ")
Private cNrDoc		:= If(lUsaGE, Space(TamSx3("E1_NRDOC")[1])," ")
Private cMotivo		:= If(lUsaGE, Space(TamSX3("E1_MOTNEG")[1])," ")
Private cCliCombo	:= If(lUsaGE, Space(TamSx3("E1_CLIENTE")[1])," ")
Private cChvRaNDoc  := ""
Private cTurma	 	:= ""
Private cCodDiario	:= ""    
Private nUsado2		:= 0
Private nIntervalo	:= 1
Private nMoeda		:= 1
Private nValor	 	:= 0
Private nQtdTit 	:= 0
Private nValorMax	:= 0				// valor maximo de liquidacao (digitado)
Private nValorDe	:= 0 			   	// valor inicial dos titulos
Private nValorAte	:= 9999999999.99 	// Valor final dos titulos
Private nValorLiq	:= 0				// valor da liquidacao ap mBrowse
Private nNroParc	:= 0				// numero de parcelas digitadas
Private nPosAtu		:= 0
Private nPosAnt		:= 9999
Private nColAnt		:= 9999
Private nValorAcr	:= 0				// valor da liquidacao ap mBrowse
Private nValorDcr	:= 0				// valor da liquidacao ap mBrowse
Private nValorTot	:= 0
Private nSaldoBx	:= 0
Private nIDAPLIC 	:= 0				//Integracao Protheus x RM Classis
Private nContrato   := 0
Private dData460I 	:= dDataBase
Private dData460F 	:= dDataBase
Private aHeader 	:= {}
Private aCols  		:= {}
Private aDiario 	:= {}
Private lInverte	:= .F.
Private lReliquida 	:= IIF(nOpcx == 2,.F.,.T.)
Private oDlgKco
Private oGet
Private oValorLiq
Private oValorAcr
Private oValorDcr
Private oValorTot
Private oNroParc
Private oCliAte
Private oLojaAte
Private CurLen
Private cFilMsg		:= "2" //Filtra movimentos de msg unica     

//Valida o tamanho do parametro MV_NUMLIQ para evitar conflitos em processo futuros
cLiquid := GetMv("MV_NUMLIQ",,.T.)
IF LEN(cLiquid) > nTamLiq
	HELP(" ",1,"PNUMLIQ" ,,"Verifique o tamanho do parametro MV_NUMLIQ, este n鉶 pode ser maior que tamanho do campo E1_NUMLIQ",1,0)
	Return
EndIF
cLiquid := If (Type("cLiquid") != "C",Space(nTamLiq),Soma1(cLiquid,nTamLiq))

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se data do movimento n刼 ?menor que data limite de ?
//?movimentacao no financeiro    								 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !DtMovFin(,,"2")
	Return
EndIf

// Parametros de negociacao
F460GetJCD()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Recupera o numero do lote contabil.							 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
LoteCont( "FIN" )
  
DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Inicializa array com as moedas existentes.					 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
aMoedas := FDescMoed()  
DbSelectArea(cAlias)
cAlias    := "SE1"
cCliente  := SE1->E1_CLIENTE
cCli460	  := cCliente
cLoja     := SE1->E1_LOJA
cCliDE 	  := SE1->E1_CLIENTE
cLojaDE   := SE1->E1_LOJA
cCliAte   := SE1->E1_CLIENTE
cLojaAte  := SE1->E1_LOJA
cNomeCli  := SE1->E1_NOMCLI
dData460I := SE1->E1_EMISSAO
dData460F := dDataBase
If Empty(cPrefAte)
	cPrefAte := Replicate("Z",TamSx3("E1_PREFIXO")[1])
Endif
If Empty(cNumAte)
	cNumAte := Replicate("Z",TamSx3("E1_NUM")[1])
Endif

If lUsaGE
	if !Empty(SE1->E1_NUMRA)
		cNumRA := SE1->E1_NUMRA
	else
		cNumRA := Posicione("JA2",5,xFilial("JA2")+SE1->E1_CLIENTE+SE1->E1_LOJA,"JA2_NUMRA")
	endif
Endif

//Gestao
If __lDefTop == NIL
	__lDefTop 	:= IfDefTopCTB() .and. !lUsaGE .and. !lOpcAuto // verificar se pode executar query (TOPCONN)
Endif

M->E1_TIPO := cTipo

If cMvJurTipo == "L" .Or. lMulLoj
	aAdd( aCpoBro , {"MULTALJ",,STR0208,"@E 9,999,999,999.99"} )
EndIf

While .T.

	nValTot	:= 0
	nOpca   := 0
	lProcessou	:= .F. 
	
	If nOpcx == 6
		cCadastro := STR0074		// "Reliquida噭o"
	Endif

  	If !lOpcAuto
		//Tela de parametros da rotina
		If lPanelFin  //Chamado pelo Painel Financeiro			
			dbSelectArea(cAlias)
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
				
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//?Observacao Importante quanto as coordenadas calculadas abaixo: ?
			//?-------------------------------------------------------------- ?		
			//?a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ?
			//?painel, sendo assim este deve ser dividido por 2 antes da sub- ?
			//?tracao e redivisao por 2 para a centralizacao. 					 ?	
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁		
			nEspLarg := (((DlgWidthPanel(oPanelDados)/2) - 276) /2)-4
			nEspLin  := 0				
		Else   
			nEspLarg := 0 
		   	nEspLin  := 3  	
			DEFINE MSDIALOG oDlg FROM 85,0 TO 420,560 TITLE cCadastro PIXEL
		Endif     

		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT    			
		
		@ 004+nEspLin, 007+nEspLarg TO 145+nEspLin, 276+nEspLarg OF oPanel PIXEL
		
		If !lUsaGE
			@ 010+nEspLin, 014+nEspLarg SAY STR0070	SIZE 40, 7 OF oPanel PIXEL   //"Cliente De"
			@ 010+nEspLin, 070+nEspLarg SAY STR0072	SIZE 20, 7 OF oPanel PIXEL   //"Loja De"
			@ 010+nEspLin, 104+nEspLarg SAY STR0071	SIZE 40, 7 OF oPanel PIXEL   //"Cliente Ate"
			@ 010+nEspLin, 160+nEspLarg SAY STR0073	SIZE 20, 7 OF oPanel PIXEL   //"Loja Ate"
			@ 010+nEspLin, 194+nEspLarg SAY STR0013	SIZE 40, 7 OF oPanel PIXEL   //"Gerar p/ Cliente"
			@ 010+nEspLin, 250+nEspLarg SAY STR0014	SIZE 40, 7 OF oPanel PIXEL   //"Loja"
		
		Else
			@ 010+nEspLin, 014+nEspLarg SAY STR0149 SIZE 40, 7 OF oPanel PIXEL COLOR CLR_HBLUE  //"Numero do Ra"
			@ 010+nEspLin, 105+nEspLarg SAY STR0193 SIZE 40, 7 OF oPanel PIXEL COLOR CLR_HBLUE //"Curso / Per韔do"
			@ 010+nEspLin, 195+nEspLarg SAY STR0020 SIZE 40, 7 OF oPanel PIXEL COLOR CLR_HBLUE //"Cliente"
		EndIf
	
		@ 029+nEspLin, 014+nEspLarg SAY STR0015	SIZE 40, 7 OF oPanel PIXEL   //"Valor Maximo"
	
		@ 029+nEspLin, 104+nEspLarg SAY STR0107	SIZE 50, 7 OF oPanel PIXEL   //"Titulos no valor de"
		@ 029+nEspLin, 194+nEspLarg SAY STR0108	SIZE 40, 7 OF oPanel PIXEL   //"Ate o valor de"
	
		@ 048+nEspLin, 014+nEspLarg SAY STR0065 	SIZE 40, 7 OF oPanel PIXEL  	//"Intervalo por"
		@ 048+nEspLin, 104+nEspLarg SAY STR0066 	SIZE 40, 7 OF oPanel PIXEL   //"Data de"
		@ 048+nEspLin, 194+nEspLarg SAY STR0067 	SIZE 40, 7 OF oPanel PIXEL   //"Ate"
	
		@ 072+nEspLin, 014+nEspLarg SAY STR0161	SIZE 40, 7 OF oPanel PIXEL    //"Pref De"
		@ 072+nEspLin, 045+nEspLarg SAY STR0067 	SIZE 40, 7 OF oPanel PIXEL   //"Ate"
		@ 072+nEspLin, 104+nEspLarg SAY STR0162 	SIZE 40, 7 OF oPanel PIXEL    //"Titulo de"
		@ 072+nEspLin, 194+nEspLarg SAY STR0067 	SIZE 40, 7 OF oPanel PIXEL   //"Ate"
	
		@ 091+nEspLin, 014+nEspLarg SAY STR0016	SIZE 40, 7 OF oPanel PIXEL   //"Moeda"
		@ 091+nEspLin, 104+nEspLarg SAY STR0137	SIZE 40, 7 OF oPanel PIXEL    //"Outras Moedas"


		IF ! lUsaGE

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//矷ntegracao Protheus X RM Classis Net (RM Sistemas)?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			if GetNewPar("MV_RMCLASS", .F.)
				@ 019+nEspLin, 014+nEspLarg MSGET cCliDe  F3 "SA1" Valid F460VldCmp(@cCliDe,@cLojaDe,@cCliAte,@cLojaAte,@cCli460,@cLoja) SIZE 52, 08 OF oPanel PIXEL hasbutton 
				@ 019+nEspLin, 070+nEspLarg MSGET cLojaDe 		   Valid F460VldCmp(@cCliDe,@cLojaDe,@cCliAte,@cLojaAte,@cCli460,@cLoja) SIZE 20, 08 OF oPanel PIXEL hasbutton
			
				@ 019+nEspLin, 104+nEspLarg MSGET oCliAte	VAR cCliAte		F3 "SA1" SIZE 52, 08 OF oPanel PIXEL hasbutton When .F.
				@ 019+nEspLin, 160+nEspLarg MSGET oLojaAte	VAR cLojaAte	SIZE 20, 08 OF oPanel PIXEL hasbutton When .F.
			
				@ 019+nEspLin, 194+nEspLarg MSGET cCli460 F3 "SA1" Valid a460Cli(cCli460)    	SIZE 52, 08 OF oPanel PIXEL hasbutton When .F.
				@ 019+nEspLin, 250+nEspLarg MSGET cLoja			   Valid a460Cli(cCli460,cLoja)	SIZE 20, 08 OF oPanel PIXEL hasbutton When .F.
			else
				@ 019+nEspLin, 014+nEspLarg MSGET cCliDe	F3 "SA1" SIZE 52, 08 OF oPanel PIXEL hasbutton 
				@ 019+nEspLin, 070+nEspLarg MSGET cLojaDe	SIZE 20, 08 OF oPanel PIXEL hasbutton
			
				@ 019+nEspLin, 104+nEspLarg MSGET oCliAte	VAR cCliAte		F3 "SA1" SIZE 52, 08 OF oPanel PIXEL hasbutton
				@ 019+nEspLin, 160+nEspLarg MSGET oLojaAte	VAR cLojaAte	SIZE 20, 08 OF oPanel PIXEL hasbutton
			
				@ 019+nEspLin, 194+nEspLarg MSGET cCli460	F3 "SA1" Valid a460Cli(cCli460)			SIZE 52, 08 OF oPanel PIXEL hasbutton
				@ 019+nEspLin, 250+nEspLarg MSGET cLoja				Valid a460Cli(cCli460,cLoja)	SIZE 20, 08 OF oPanel PIXEL hasbutton
			endif
				
		Else
			
			@ 019+nEspLin, 014+nEspLarg MSGET cNumRA		F3 "JA2" SIZE 72, 08 OF oPanel PIXEL VALID FIN460ACUR(cNumRa,@oNrDoc,@cNrDoc,@aNrDoc,@oClients,@cCliCombo,@aClients) hasbutton
			
			@ 019+nEspLin, 104+nEspLarg COMBOBOX oNrDoc VAR cNrDoc ITEMS aNrDoc SIZE 80,54 OF oPanel PIXEL VALID FIN460ACli(cNumRa,cNrDoc,@oClients,@cCliCombo,@aClients)
			
			@ 019+nEspLin, 194+nEspLarg COMBOBOX oClients VAR cCliCombo ITEMS aClients SIZE 80,54 OF oPanel PIXEL
			
			if !empty(cNumRA)
				if !empty(SE1->E1_NRDOC)
					cNrDoc := SubStr(SE1->E1_NRDOC,1,TamSx3("JBE_CODCUR")[1])+" "+SubStr(SE1->E1_NRDOC,TamSx3("JBE_CODCUR")[1]+1,TamSx3("JBE_PERLET")[1])
					cCliCombo := SE1->E1_CLIENTE+" - "+SE1->E1_NOMCLI
				endif
				FIN460ACUR(cNumRa,@oNrDoc,@cNrDoc,@aNrDoc,@oClients,@cCliCombo,@aClients)
			endif
	
		EndIf   
		
		@ 037+nEspLin, 014+nEspLarg MSGET oValorMax VAR nValorMax	Picture "@E 9,999,999,999.99" SIZE 60, 08 OF oPanel PIXEL hasbutton
		@ 037+nEspLin, 104+nEspLarg MSGET oValorDe  VAR nValorDe	Picture "@E 9,999,999,999.99"	SIZE 60, 08 OF oPanel PIXEL hasbutton
		@ 037+nEspLin, 194+nEspLarg MSGET oValorAte VAR nValorAte  Picture "@E 9,999,999,999.99" SIZE 60, 08 OF oPanel PIXEL hasbutton
	
		@ 056+nEspLin, 014+nEspLarg MSCOMBOBOX oCbx1 VAR cIntervalo ITEMS aIntervalo SIZE 60, 54 OF oPanel PIXEL
		@ 056+nEspLin, 104+nEspLarg MSGET dData460I				Valid !Empty(dData460I) SIZE 52, 08 OF oPanel PIXEL hasbutton
		@ 056+nEspLin, 194+nEspLarg MSGET dData460F	Valid !Empty(dData460F) .and. ;
			dData460F >= dData460I 	.and. ;
			If(val(substr(cIntervalo,1,2))=1,dData460F <= dDataBase,.T.)	;
			SIZE 52, 08 OF oPanel PIXEL hasbutton
	
		@ 080+nEspLin, 014+nEspLarg MSGET cPrefDe	SIZE 20, 08 OF oPanel PIXEL hasbutton
		@ 080+nEspLin, 045+nEspLarg MSGET cPrefAte	VALID cPrefAte >= cPrefDe SIZE 20, 08 OF oPanel PIXEL hasbutton
		@ 080+nEspLin, 104+nEspLarg MSGET cNumDe	SIZE 52, 08 OF oPanel PIXEL hasbutton
		@ 080+nEspLin, 194+nEspLarg MSGET cNumAte	VALID cNumAte >= cNumDe SIZE 52, 08 OF oPanel PIXEL hasbutton
		             
		@ 099+nEspLin, 014+nEspLarg MSCOMBOBOX oCbx  VAR cMoeda460	ITEMS aMoedas	 SIZE 60, 54 OF oPanel PIXEL
		@ 099+nEspLin, 104+nEspLarg MSCOMBOBOX oCbx2 VAR cOutrMoed	ITEMS aOutrMoed SIZE 60, 54 OF oPanel PIXEL

		//639.04 Base Impostos diferenciada
		If lBaseImp
			@ 091+nEspLin, 194+nEspLarg SAY "Natureza Liquida玢o"	SIZE 80,7 PIXEL Of oPanel  COLOR CLR_HBLUE //"Natureza  "
			@ 099+nEspLin, 194+nEspLarg MSGET cNatureza		F3 "SED" Valid A460NATUR(cNatureza) SIZE 60,8 hasbutton PIXEL Of oPanel
		Endif	

		If lMsgUnq 
			@ 115+nEspLin, 014+nEspLarg SAY STR0213 SIZE 100, 7 OF oPanel PIXEL //"Filtra Integra玢o"
			@ 123+nEspLin, 014+nEspLarg MSCOMBOBOX oFilInt VAR cFilMsg ITEMS aFilInt SIZE 60,54 OF oPanel PIXEL
		EndIf	

		If lPanelFin  //Chamado pelo Painel Financeiro			
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{||cVar:=cMoeda460,cVar1:=cIntervalo,cCliente:=cCli460,cTipo:=M->E1_TIPO,;
			IF(Fa460OK1(),(If(A460YesNo(),(nOpca:=1,oDlg:End()),nOpca:=0)),nOpca:=2)},;		
			{||oDlg:End(),nOpca:=0})	
		
	   Else	
			DEFINE SBUTTON FROM 150, 214 TYPE 1 ACTION ;
				(cVar:=cMoeda460,cVar1:=cIntervalo,cCliente:=cCli460,cTipo:=M->E1_TIPO,IF(Fa460OK1(),(If(A460YesNo(),(nOpca:=1,oDlg:End()),nOpca:=0)),nOpca:=2)) ENABLE OF oPanel
			DEFINE SBUTTON FROM 150, 249 TYPE 2 ACTION {||oDlg:End(),nOpca:=0} ENABLE OF oPanel
		
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
		
		IF ! Empty(cNumRa)
			JA2->(dbSetOrder(1))
			JA2->(MsSeek(xFilial("JA2")+cNumRA))
			cNomeAlu := Alltrim( JA2->JA2_NOME )
			cCliDe   := Substr(cCliCombo,1,TamSx3("E1_CLIENTE")[1])
			cLojaDe  := Posicione("SA1",1,xFilial("SA1")+cCliDe,"A1_LOJA")
			cCliAte  := cCliDe
			cLojaAte := cLojaDe
			cCliente := cCliDe
			cLoja    := cLojaDe
		EndIF
		If nOpca == 0
			If Existblock("FA460OUT")
				Execblock("FA460OUT",.F.,.F.)
			Endif
			Exit
		EndIf
		If nOpca == 2
			Loop
		EndIf
		nMoeda := Val(Substr(cVar,1,2))
	Else
	  	If (nT := aScan(aAutoCab,{|x| UPPER(Alltrim(x[1]))=='CCONDICAO'})) > 0
			cCondicao :=	aAutoCab[nT,2]
	 	EndIf	
	  	If (nT := aScan(aAutoCab,{|x| UPPER(Alltrim(x[1]))=='CCLIENTE'})) > 0
			cCliente :=	aAutoCab[nT,2]
	 	EndIf	
	  	If (nT := aScan(aAutoCab,{|x| UPPER(Alltrim(x[1]))=='CLOJA'})) > 0
			cLoja :=	aAutoCab[nT,2]
	 	EndIf	
	  	If (nT := aScan(aAutoCab,{|x| UPPER(Alltrim(x[1]))=='E1_TIPO'})) > 0
			M->E1_TIPO :=	aAutoCab[nT,2]
			cTipo:=M->E1_TIPO
	 	EndIf	
	  	If (nT := aScan(aAutoCab,{|x| UPPER(Alltrim(x[1]))=='CNATUREZA'})) > 0
			cNatureza := aAutoCab[nT,2]
	 	EndIf
	  	If (nT := aScan(aAutoCab,{|x| UPPER(Alltrim(x[1]))=='NMOEDA'})) > 0
			nMoeda := aAutoCab[nT,2]
	 	EndIf	
	EndIf
	cSimb := Pad(SuperGetmv("MV_SIMB"+Alltrim(STR(nMoeda))),4)
	nIntervalo := Val(Substr(cVar1,1,2))
	nChoice := 	Val(Substr(cOutrMoed,1,1))
	
	//Coloco o simbolo da moeda para qual vou gerar os titulos
	//no titulo das colunas
	For nX := 8 to 11
		aCpoBro [nX,3] += 	cSimb
	Next	

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ?
	//?                                                                 ?
	//?A fun噭o SomaAbat reabre o SE1 com outro nome pela ChkFile para  ?
	//?efeito de performance. Se o alias auxiliar para a SumAbat() n刼  ?
	//?estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ?
	//?pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	SomaAbat("","","","R")

	//Trata numero da liquidacao
	SE1->(dbSetOrder(15))
                         
	// Verifica na memoria se esta sendo usado por outro usuario e
	// verifica se ja existe liquidacao com o mesmo numero
	While (!Empty(cLiquid) .and. SE1->(MsSeek(xFilial("SE1")+cLiquid)))
		cLiquid := Soma1(cLiquid)	// busca o proximo numero disponivel 
	Enddo

	//Gestao
	//Selecao de filiais
	If __lDefTop .and. lSE1Access .and. mv_par06 == 1 .And. Len( aSelFil ) <= 0 
		aSelFil := AdmGetFil(.F.,.T.,"SE1")
		If Len( aSelFil ) <= 0
			Exit
		EndIf	
	Else
		aSelFil := { cFilAnt }	 
	EndIf

	DbSelectArea ("SE1")
	DbSetOrder(1)

	//Seleciona Contas a Receber (SE1)
	If __lDefTop
		cAliasSE1	:= "TRBSE1"
		cQuery 		:= a460ChecF(nChoice,aSelFil,aTmpFil)
		cQuery 		:= ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE1, .F., .T.)
		dbSelectArea(cAliasSE1)		
	Else
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Cria indice condicional									     ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If !lOpcAuto
			cAliasSE1	:= "SE1"
			cAlias		:= "SE1"
			cIndex		:= CriaTrab(nil,.f.)
			cChave		:= IndexKey()
			IndRegua("SE1",cIndex,cChave,,a460ChecF(nChoice,aSelFil,aTmpFil),STR0019)  //"Selecionando Registros..."
			nIndex := RetIndex("SE1")
			DbSelectArea(cAlias)
			
			DbSetOrder(nIndex+1)
			MsSeek(xFilial("SE1"))
			(cAlias)->(DbGoTop())   
		Else 
			cAlias		:= "SE1"
			cAliasSE1	:= "SE1"
			DbSelectArea(cAlias)
			SE1->(dbSetOrder(1))
			DbSeek(xFilial("SE1")+ "CEC" + "FIN000005 " + "" + "NF ")
		Endif   
	Endif
	
	If (cAliasSE1)->(Eof()) .and. (cAliasSE1)->(Bof())
		Help(" ",1,"RECNO")
		//Gestao
		If !lOpcAuto 
			If __lDefTop
				If Select(cAliasSe1) > 0
					DbSelectArea(cAliasSe1)
					DbCloseArea()
				Endif
				//Apaga a tabela temporaria das filiais
				For nX := 1 TO Len(aTmpFil)
					CtbTmpErase(aTmpFil[nX])
				Next
				dbSelectArea("SE1")
				dbSetOrder(1)
			Else
				DbSelectArea("SE1")
				RetIndex("SE1")
				Set Filter to
				DbGoTop()
				FErase(cIndex+OrdBagExt())
			Endif
			FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			Loop
		Else
			Exit
		EndIF
	Endif

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Ponto de entrada para manipulacao do numero de             ?
	//?liquidacao. Deve retornar um novo nro de liquidacao        ?
	//?e ja deve gravar no parametro MV_NUMLIQ para nao causar    ?
	//?duplicidade na numeracao. O ponto deve ser executado nesse ?
	//?ponto para nao perder a numeracao desnecessariamente caso  ?
	//?nao haja titulos a serem selecionados.                     ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	IF ( lF460Num )
		While .T.
			cLiquid := ExecBlock("F460NUM",.F.,.F.,{cLiquid})
			If !Empty(cLiquid) .and. !MayIUseCode("E1_NUMLIQ"+xFilial("SE1")+cLiquid)		//verifica se esta na memoria, sendo usado
				// busca o proximo numero disponivel
				Help(" ",1,"A460LIQ")
			Else
				Exit
			EndIf
		Enddo
		
		//Caso nao seja um numero de liquidacao valido, retorno ao inicio.
		If Empty(cLiquid) .or. Type("cLiquid") != "C"
			Help(	" ",1,"NONUMLIQ",,STR0182,1,0)  //"N鷐ero da Liquidacao vazio ou invalido. Verifique o par鈓etro MV_NUMLIQ"
			If !lOpcAuto 
				If __lDefTop
					If Select(cAliasSe1) > 0
						DbSelectArea(cAliasSe1)
						DbCloseArea()
					Endif
					//Apaga a tabela temporaria das filiais
					For nX := 1 TO Len(aTmpFil)
						CtbTmpErase(aTmpFil[nX])
					Next
					dbSelectArea("SE1")
					dbSetOrder(1)
				Else
					DbSelectArea("SE1")
					RetIndex("SE1")
					Set Filter to
					DbGoTop()
					FErase(cIndex+OrdBagExt())
				Endif
				FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
				Loop
			Else
				Exit
			EndIF
		Endif
	Endif
	
	//**************************************
	// Avalia se o codigo esta sendo usado *
	//**************************************
	While .T.
		If MayIUseCode("E1_NUMLIQ"+xFilial("SE1")+cLiquid)
			Exit
		Else
			cLiquid := Soma1(cLiquid,nTamLiq)
		EndIf
	EndDo


	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Cria Arquivo Temporario						 ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	TRB := Fa460Gerarq(aCampos,@cIndexTrb)

	nOpca		:= 0
	nValor  	:= 0	// Valor total dos titulos,mostrado no rodape do browse
	nValCruz	:= 0	// Acumula Valor original na moeda nacional
	nJuros		:= 0
	nDesc		:= 0
	nAbatim		:= 0
	nQtdTit 	:= 0	// Quantidade de titulos,mostrado no rodape do browse
	lContinua	:= .T.
	cAlias		:= "TRB"
	lProcessou	:= .T.
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//?Carrega Registros do Arquivo Temporario       ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	Fa460Repl(TRB,cAliasSE1)

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Monta MarkBrowse para selecionar os titulos p/ liquidacao    ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	nOpca := 0
	dbSelectArea("TRB")
	If nValorMax > 0
		DBEVAL({ |a| FA460DBEVA(nValorMax,@nQtdTit)})
	Endif

	DbSelectArea("TRB")
	DbGoTop()

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Faz o calculo automatico de dimensoes de objetos     ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If !lOpcAuto
		aSize := MSADVSIZE()
		
		//Tela de selecao de titulos a serem liquidados
		DEFINE MSDIALOG oDlgKco TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
		oDlgKco:lMaximized := .T.
		oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlgKco) },oDlgKco) // Ativa timer
		oTimer:Activate()
		
		oSize := FwDefSize():New(.T.,,,oDlgKco)
		
		oSize:AddObject("MASTER",100,015,.T.,.T.)
		oSize:AddObject("MARKBW",100,085,.T.,.T.)

		oSize:lLateral := .F.				
		oSize:lProp := .T.
	
		oSize:Process()
			
		oPanel := TPanel():New(oSize:GetDimension("MASTER","LININI"),;
								oSize:GetDimension("MASTER","COLINI"),'',oDlgKco,, .T., .T.,,,oSize:GetDimension("MASTER","XSIZE"),;
																								oSize:GetDimension("MASTER","YSIZE"),.T.,.T. )
		//oPanel:Align := CONTROL_ALIGN_TOP
		
		//Coluna 1
		@ 003, 005 Say STR0053				FONT oDlgKco:oFont		PIXEL Of oPanel  //"Nro. Liquida噭o "
		@ 003, 060 Say cLiquid Picture "@!"	FONT oFnt COLOR CLR_HBLUE	PIXEL Of oPanel
	
		If !lUsaGE
			@ 012 , 005 Say STR0020 	+ cCliente				FONT oDlgKco:oFont PIXEL Of oPanel  //"Cliente  "
			@ 012 , 060 Say STR0021									FONT oDlgKco:oFont PIXEL Of oPanel //"Loja  "
			@ 010 , 080 MSGET cLoja F3 "SA1LJ"/*"SA1"*/ SIZE 015,008	FONT oDlgKco:oFont PIXEL Of oPanel HASBUTTON //READONLY
	
			@ 030 , 005 Say STR0022 	+ AllTrim(Str(nMoeda,2,0))	FONT oDlgKco:oFont PIXEL Of oPanel  //"Moeda  "
		Else
			@ 012 , 005 Say STR0156 + cNumRA						FONT oDlgKco:oFont PIXEL Of oPanel  //"RA: "
			@ 012 , 060 Say STR0157 + cNomeAlu					FONT oDlgKco:oFont PIXEL Of oPanel SIZE 12,0.6 //"Nome: "
		EndIf
	
		@ 021 , 005 Say STR0023 + Dtoc(dData460I)					FONT oDlgKco:oFont PIXEL Of oPanel  //"Emiss鉶 de  "
		@ 021 , 080 Say STR0024 + Dtoc(dData460F)					FONT oDlgKco:oFont PIXEL Of oPanel //"at?
	
	
		//Coluna 2
		@ 003, 200 Say STR0025 		SIZE 50,8 FONT oDlgKco:oFont PIXEL Of oPanel  //"Valor Digitado "
		@ 003, 280 Say oValorMax	VAR nValorMax	Picture "@E 999,999,999.99" FONT oDlgKco:oFont PIXEL Of oPanel
		@ 012, 200 Say STR0026		SIZE 50,8 FONT oDlgKco:oFont PIXEL Of oPanel  //"Valor Selecionado "
		@ 012, 280 Say oValor		VAR nValor		Picture "@E 999,999,999.99" FONT oDlgKco:oFont PIXEL Of oPanel
		@ 021, 200 Say STR0027		SIZE 50,8 FONT oDlgKco:oFont PIXEL Of oPanel  //"Qtde Titulos "
		@ 021, 280 Say oQtdTit		VAR nQtdTit  	Picture "99999"  				 FONT oDlgKco:oFont PIXEL Of oPanel
	
		oMark 		:= MsSelect():New("TRB","MARCA","",aCpoBro,.F.,@cMarca,{oSize:GetDimension("MARKBW","LININI"),;
																			oSize:GetDimension("MARKBW","COLINI"),;
																			oSize:GetDimension("MARKBW","LINEND"),;
																			oSize:GetDimension("MARKBW","COLEND")},F460TrbArea(),F460TrbArea())
		
		oMark:bMark := {||A460Exibe(cMarca,oValor,oQtdTit)}
		oMark:bAval	:= {||Fa460bAval(cMarca,oValor,oQtdTit,oMark)}
		oMark:oBrowse:lhasMark := .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || A460Inverte(cMarca,oValor,oQtdTit,.T.,oMark)}
		//oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			
		If lPanelFin  //Chamado pelo Painel Financeiro			
			aButtons := {}		
			AADD(aButtons,{"S4WB009N",{||Agenda()						 }												,STR0091})
			AADD(aButtons,{"S4WB005N",{||Fa460Visu()				    },OemToAnsi(STR0167)+" "+OemToAnsi(STR0168)})
			AADD(aButtons,{"NOTE"    ,{||Fa460Edit(oValor,oQtdTit)} 											,STR0094}) 
			AADD(aButtons,{"PESQUISA",{||Fa460Pesq(oMark)			 }											   ,STR0095})	
			
			ACTIVATE MSDIALOG oDlgKco ON INIT FaMyBar(oDlgKco,;
			{|| nOpca := 1,oDlgKco:End()},;
			{|| nOpca := 2,oDlgKco:End()},aButtons);
			VALID (oTimer:End(),.T.)
			
		
	   	Else	
			ACTIVATE MSDIALOG oDlgKco ON INIT Fa460Bar(oDlgKco,{|| nOpca := IIf( FA460LiqOk(), 1, 0 ), IIf( nOpca == 1, oDlgKco:End(), NIL ) },;
				{|| nOpca := 2,oDlgKco:End()},oMark,oValor,oQtdTit) VALID (oTimer:End(),.T.)
		Endif		

		If nOpca == 2 .or. nOpca == 0
			FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			If Existblock("F460SAID")
				Execblock("F460SAID",.F.,.F.)
			EndIf
	

		
			Exit
		EndIf
	Else
	   	//Marca todos os titulos do arquivo temporario
		DbSelectArea("TRB")
		DbGoTop()
		While !Eof()
			SE1->(MSSeek(TRB->CHAVE))
			If SE1->(MsRLock()) .and. SE1->E1_SALDO > 0
				RecLock("TRB")
				Replace MARCA With cMarca
				TRB->(MsUnlock())
				nValor += TRB->VALLIQ
				nQtdTit++
			Endif
			TRB->(dbSkip())
		Enddo  
		TRB->(dbGoTop())
	EndIF
	
	DbSelectArea("TRB")
	If Existblock("F460GRV")
		Execblock("F460GRV",.F.,.F.)
	Endif	

	If nValor == 0
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Efetuar a liquida噭o qdo um Titulo NCC deduzir at?zero seu  ?
		//?Titulo original correspondente (Argentina).                  ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪Lucas哪?
		If cPaisLoc == "ARG"
			a460Grava({},{})
		EndIf

		Exit

	EndIf
	nUsado2 := 0
	cMoeda := AllTrim(Str(nMoeda,2))
	Aadd(aHeader,{STR0069,"E1_PREFIXO","!!!",;   //"PREFIXO "
				3,0,"AllWaysTrue()","?,"C","SE1" } )
	Aadd(aHeader,{STR0163,"E1_TIPO","@!",;   //"TIPO" 
				3,0,"FA460TIPO()","?,"C","SE1" } )
	Aadd(aHeader,{STR0029,"E1_BCOCHQ","@!",;   //"BCO. "
			aTamBco[1],0,"AllWaysTrue()","?,"C","SE1" } )
	Aadd(aHeader,{STR0030,"E1_AGECHQ","@!",;   //"AGENCIA"
			aTamAge[1],0,"AllwaysTrue()","?,"C","SE1" } )
	Aadd(aHeader,{STR0031,"E1_CTACHQ","@!",;   //"CONTA"
			aTamCta[1],0,"a460CtaChq()","?,"C","SE1" } )
	Aadd(aHeader,{STR0032,"E1_NUM","@!",;   	//"NRO. CHEQUE"
			aTam[1],0,"a460NumChq()","?,"C","SE1" } )
	Aadd(aHeader,{STR0033,"E1_VENCTO"," ",;   //"DATA BOA"
				8,0,"a460DataOK()","?,"D","SE1" } )
	Aadd(aHeader,{STR0141,"E1_EMITCHQ","@!S40",;   //"Nome do Emitente"
				40,0,"a460Emit()","?,"C","SE1" } )
	Aadd(aHeader,{STR0034,"E1_VLCRUZ","@E 9999,999,999.99",;   //"VALOR"
				14,2,"A460Valor()","?,"N","SE1" } )
	Aadd(aHeader,{STR0116,"E1_ACRESC","@E 999,999.99",;   //"ACRESCIIMOS"
				10,2,"A460Valor()","?,"N","SE1" } )
	Aadd(aHeader,{STR0117,"E1_DECRESC","@E 999,999.99",;   //"DECRESCIMOS"
				10,2,"A460Valor()","?,"N","SE1" } )
	Aadd(aHeader,{STR0118,"E1_VALOR","@E 9999,999,999.99",;   //"VALOR TOTAL"
				14,2,"AllwaysTrue()","?,"N","SE1" } )

	If lA460Col
		ExecBlock("A460COL", .F., .F. )
	Endif
                                 
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Monta array com os campos alteraveis na getdados. O ultimo campo sera?
	//?apenas para mostrar o valor final do cheque (valor+acres-Decres)     ?
	//?na posicao 10 do aheader.                                            ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nCntFor := 1 to Len(aHeader)
		If nCntFor != 12
			Aadd(aAltera,aHeader[nCntFor,2])
		Endif
	Next nCntFor

	nUsado2 := Len(aHeader)
	aCols := Array( 1 , (nUsado2+1) )
	aCols[1,nUsado2+1] := .F.
	For nCntFor := 1 To nUsado2
		aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
	Next nCntFor
	nOpca := 0

	If lOpcAuto
      //Preenche aCols
		dbSelectArea("SE4")
		dbSetOrder(1)
		If dbSeek(xFilial("SE4")+cCondicao)
			If SE4->E4_TIPO != "9"
				If (a460Cond(cCondicao,nUsado2))
				a460Cond(cCondicao,nUsado2)
				nOpcA:=1
				EndIf
			EndIf
		EndIf
	Else
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Faz o calculo automatico de dimensoes de objetos     ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		aSize := MSADVSIZE()
		
		//Tela de digitacao dos dados dos titulos a serem gerados pela liquidacao
		DEFINE MSDIALOG oDlg2 TITLE cCadastro PIXEL FROM aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
			oDlg2:lMaximized := .T.
	
		oPanel2 := TPanel():New(0,0,'',oDlg2,, .T., .T.,, ,200,70,.T.,.T. )
		oPanel2:Align := CONTROL_ALIGN_TOP
	
		@ 003 , 002 SAY STR0053	             			FONT oDlg2:oFont 				PIXEL Of oPanel2	//"Nro. Liquida噭o "
		@ 003 , 060 SAY cLiquid	Picture "@!"			FONT oFnt COLOR CLR_HBLUE	PIXEL Of oPanel2
		@ 003 , 200 SAY STR0023	+ Dtoc(dData460I) 	FONT oDlg2:oFont				PIXEL Of oPanel2	//"Emiss刼 de  "
		@ 003 , 275	SAY STR0024	+ Dtoc(dData460F)			FONT oDlg2:oFont			PIXEL Of oPanel2	//"at? "
	
		@ 012 , 002 SAY STR0020	+ cCliente				FONT oDlg2:oFont	PIXEL Of oPanel2	//"Cliente  "
		@ 012 , 060 SAY STR0021								FONT oDlg2:oFont  PIXEL Of oPanel2	//"Loja  "
		@ 010 , 080 MSGET cLoja F3 "SA1LJ"/*"SA1"*/ SIZE 015,008	FONT oDlg2:oFont  			PIXEL Of oPanel2	/*READONLY*/  hasbutton
		@ 012 , 200	SAY STR0036				SIZE 25,8	FONT oDlg2:oFont	PIXEL Of oPanel2  //"Valor  "
		@ 012 , 260 SAY nValor Picture "@E 999,999,999.99" FONT oDlg2:oFont PIXEL Of oPanel2
	
		//Linha Separador
		@ 025, 000	To 075, aSize[6]-20 PIXEL Of oPanel2
		
		@ 028 , 002	SAY STR0037	SIZE 40,8 FONT oDlg2:oFont PIXEL Of oPanel2  //"Condicao  "
		@ 041 , 002 SAY STR0068	SIZE 40,8 FONT oDlg2:oFont PIXEL Of oPanel2  //"Tipo"
		@ 054 , 002	SAY STR0038	SIZE 40,8 FONT oDlg2:oFont PIXEL Of oPanel2  //"Natureza  "
	
		@ 028,  060 MSGET cCondicao		F3 "SE4" Picture "!!!" SIZE 10,8 FONT oDlg2:oFont;
			Valid IIf( Empty(cCondicao) , .T. , ;
			(ExistCpo("SE4",cCondicao) .and. SE4->E4_TIPO != "9")) .and. ;
			A460Cond(cCondicao,nUsado2) hasbutton PIXEL Of oPanel2
	
		@ 041, 060 MSGET M->E1_TIPO	 		F3 "05";
			Picture "!!!" SIZE 10,8 FONT oDlg2:oFont ;
			Valid Empty(M->E1_TIPO) .or. FA460Tipo(@M->E1_TIPO) hasbutton PIXEL Of oPanel2
	
		@ 054, 060 MSGET cNatureza		F3 "SED" Valid A460NATUR(cNatureza) SIZE 40,8 FONT oDlg2:oFont hasbutton PIXEL Of oPanel2 WHEN !lBaseImp
	
		@ 028 , 200 SAY STR0040	SIZE 35,8 FONT oDlg2:oFont  PIXEL Of oPanel2 //"Qtde Parcelas  "
		@ 028 , 280	SAY oNroParc 	VAR nNroParc 	Picture "999" FONT oDlg2:oFont PIXEL Of oPanel2
		@ 036 , 200	SAY STR0039	SIZE 35,8 FONT oDlg2:oFont  PIXEL Of oPanel2 //"Valor Total  "
		@ 036 , 280 SAY oValorLiq	VAR nValorLiq	Picture "@E 999,999,999.99" SIZE 50,8 FONT oDlg2:oFont PIXEL Of oPanel2
		@ 044 , 200	SAY STR0119	SIZE 35,8 FONT oDlg2:oFont  PIXEL Of oPanel2 //"Acrescimos"
		@ 044 , 280 SAY oValorAcr	VAR nValorAcr	Picture "@E 999,999,999.99" SIZE 50,8 FONT oDlg2:oFont PIXEL Of oPanel2 
		@ 052 , 200	SAY STR0120	SIZE 35,8 FONT oDlg2:oFont  PIXEL Of oPanel2 //"Decrescimos"
		@ 052 , 280	SAY oValorDcr	VAR nValorDcr	Picture "@E 999,999,999.99" SIZE 50,8 FONT oDlg2:oFont PIXEL Of oPanel2 
		@ 060 , 200	SAY STR0121	SIZE 35,8 FONT oDlg2:oFont  PIXEL Of oPanel2 //"Total Geral"
		@ 060 , 280	SAY oValorTot	VAR nValorTot	Picture "@E 999,999,999.99" SIZE 50,8 FONT oDlg2:oFont PIXEL Of oPanel2 
	
		oGet:= MsGetDados():New(90,1,172,312,nOpcx,"A460OK","A460TudoOK","",.T.,if(lUsaGE,{"E1_BCOCHQ","E1_AGECHQ","E1_CTACHQ","E1_NUM","E1_VENCTO","E1_EMITCHQ","E1_VLCRUZ","E1_ACRESC","E1_DECRESC"},aAltera),,,1000)
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		SetKey(14, { || F460ParNeg() })

		aButtons := {}		
		If(!lUsaGE,NIL,AADD(aButtons,{"PLNPROP", { || F460ParNeg() }, STR0144})) /* Parametros de Negociacao)*/		

		If ExistBlock( "F460BOT" )
			aButtons := aClone(ExecBlock( "F460BOT", .F., .F.,{aButtons} ))
		EndIf
	
		If lPanelFin  //Chamado pelo Painel Financeiro					
			
			ACTIVATE MSDIALOG oDlg2 ON INIT FaMyBar(oDlg2,;
			{||cTipo:=M->E1_TIPO,nOpca:=1,if(oGet:TudoOk(),oDlg2:End(),nOpca:=0)},;
			{||oDlg2:End()},aButtons)
		
	   Else	
			ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||cTipo:=M->E1_TIPO,nOpca:=1,if(oGet:TudoOk(),oDlg2:End(),nOpca:=0)},{||oDlg2:End()},.F.,aButtons)	// Parametros de Negociacao
		Endif
		
		SetKey(14,NIL)
	EndIf            
	
	If ( nOpcA == 1 .And. !Empty(aCols))
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//?Atualiza Parametro de Ultimo Numero de Liquidacao       ?
		//?Somente se nao existir o ponto de entrada, pois o mesmo ?
		//?ja atualiza o parametro                                 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		If !lF460Num     
			If GetMv("MV_NUMLIQ") < cLiquid
				PutMv("MV_NUMLIQ",cLiquid)
			Endif
    	Endif
		a460Grava(aHeader,aCols)
	EndIf

	If nOpca != 1		// cancelamento da operacao
		If lF460Can
			Execblock("F460CAN",.F.,.F.)		// P.E para log cancelamento
		Elseif lF460CON
			Execblock("F460CON",.F.,.F.)		// P.E para log confirmacao
		Endif
	Endif		
	
	Exit

Enddo

DbSelectArea("SE1")
// Destrava os registros.
If __lDefTop 
	If lProcessou .and. Select(cAliasSe1) > 0
		(cAliasSE1)->(DBGoTop())
		SE1->(MsUnlockALL())
		
		DbSelectArea(cAliasSe1)
		DbCloseArea()
		DbSelectArea("SE1")		
	Endif	
Else
	dbGoTop()
	If lProcessou
		While SE1->(!EOF())
			SE1->(MsUnlock())
			dbSkip()
		Enddo
	Endif
	//Retira o Filtro
	RetIndex("SE1")
	Set Filter to
	DbGoTop()
Endif

//Gestao
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	dbSelectArea("SE1")
Endif

FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
RELEASE FONT oFnt
cCadastro := STR0001  // "Liquida噭o"
SE1->(RestArea(aAreaSe1))

If lPanelFin  //Chamado pelo Painel Financeiro						
	dbSelectarea(FinWindow:cAliasFile)
	FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)	
Endif

FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矨460Cli   ?Autor ?Mauricio Pequim Jr.   ?Data ?2.01.98  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Verifica dados do Cliente                                  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ?A460Cli (cCliente,cLoja)                                   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso      ?FINA460                                                    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460Cli ( cCliente, cLoja )
Local cAlias
cAlias:=Alias()
dbSelectArea("SA1")
dbSetOrder(1)
cLoja:=Iif(cLoja == Nil,"",cLoja)
If !(MsSeek(xFilial("SA1")+cCliente+cLoja))
	Return .f.
EndIf
cNomeCli := A1_NREDUZ
dbSelectArea(cAlias)
Return ( .T. )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460OK    ?Autor ?Mauricio Pequim Jr    ?Data ?22/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砎alida Linha do Getdados   								  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460OK()												  	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460OK()
Local lRet := .T.
Local nCont
Local cAtual := aCols[n,3]+aCols[n,4]+aCols[n,5]+aCols[n,6]
Local lOk := .F.
Local nCont2
Local lRetPE

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se o linha foi deletada, liberando a movimentacao   ?
//?para as outras linhas										 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If aCols[n,nUsado2+1]
	Return .T.
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se o Valor do cheque = 0                            ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If aCols[n,9] = 0
	Return .F.
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se n刼 existem campos em branco, descartando o      ?
//?campo prefixo e o nome do emissor do cheque (7)              ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
For nCont2 := 2 to 9
	If Empty (aCols[n,nCont2] )
		If !lOk .and. lUsaGE .and.  n == 1 .and. Str(nCont2,1) $ "3456" .and.;	
			 Empty(aCols[1,3]) .and. Empty(aCols[1,4]) .and. Empty(aCols[1,5]) .and. Empty(aCols[1,6]) .and.; 
			 MsgYesNo(STR0155)	// Aprimeira parcela sera gravada como pagamento em dinheiro, confirma?
				lOk := .T.
		EndIf
		if ! lOk .AND. ( SuperGetMv("MV_PAISLOC") <> "PTG")
			Help(" ",1,"A460VAZIOS")
			Return .F.
		else
			Return .T.
		EndIf
	EndIf
Next nCont2

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se data n刼 ?menor que database                    ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !aCols[n,nUsado2+1]
	If aCols[n,7] < dDataBase
		Help(" ",1,"A460DTCHEQ")
		Return .F.
	EndIf
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Ponto de entrada para validacao da linha pelo usuario.       ?
//?Este ponto permite que se desligue a validacao de numero de  ?
//?cheque, permitindo a inclus鉶 de titulos na liquidacao com   ?
//?Pref+Num+Tipo iguais mas parcelas diferentes					  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If Existblock("FA460LOK")
	lRetPE := Execblock("FA460LOK",.F.,.F.)
	If ValType(lRetPE) == "L"
		Return lRetPE
	Endif
Else
	If !aCols[n,nUsado2+1]
		For nCont := 1 to Len (aCols)
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//?Verifica se Cheque ja existe							     ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If !aCols[nCont,nUsado2+1]
				If aCols[nCont,3]+aCols[nCont,4]+aCols[nCont,5]+aCols[nCont,6] == cAtual .And. nCont <> n
					Help(" ",1,"A460EXISTE")
					Return .F.
				EndIf
			EndIf
		Next nCont
	EndIf
Endif
                                            
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Ponto de entrada para validacao da linha pelo usuario.       ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If Existblock("A460VALLIN")
	lRetPE := Execblock("A460VALLIN",.F.,.F.)
	If ValType(lRetPE) == "L"
		Return lRetPE
	Endif
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se Cheque nao excedeu o valor total da liquida噭o   ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
A460VALOR(.F.)
Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460TudoOK?Autor ?Mauricio Pequim Jr    ?Data ?22/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砎alida Toda a Getdados   									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460TudoOK()												  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460TudoOK()
Local lRet := .T.
Local nCont
Local nCont2
Local lOk := .F.
Local aArea := GetARea()

If Empty(cNatureza)
	Help(" ",1,"A460VAZIOS")
	Return .F.
EndIf

If Empty(cLoja)
	lRet	:= .F.
	Aviso(STR0051,STR0196,{STR0197}) //"Aten玢o" ## "O campo 'Loja' est?em branco. Favor informar a loja do cliente selecionado." ## "OK"
Endif

dbselectarea("SA1")
dbSetOrder(1)
If lRet .and. !(MsSeek(xFilial("SA1")+cCliente+cLoja))
	lRet	:= .F.
	Aviso(STR0051,STR0198,{STR0197}) //"Aten玢o" ## "O cliente informado n鉶 foi encontrado na base de dados. Favor Verifique C骴igo e Loja deste cliente." ## "OK"	
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se n刼 existem campos em branco ou zerados          ?
//?(somente possivel no calculo automatico de parcelas ).       ?
//?Descartando o campo prefixo (1) e o emissor do cheque (7)    ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lRet
	For nCont := 1 to Len (aCols)
		For nCont2 := 2 to 9
			If nCont2 != 8 .and. Empty (aCols[nCont,nCont2] ) .and. !( aCols[nCont,nUsado2+1] )
				If !lOk .and. lUsaGE .and.  nCont == 1 .and. Str(nCont2,1) $ "3456" .and.;
					Empty(aCols[1,3]) .and. Empty(aCols[1,4]) .and. Empty(aCols[1,5]) .and. Empty(aCols[1,6]) .and.;
					MsgYesNo(STR0155)	// Aprimeira parcela sera gravada como pagamento em dinheiro, confirma?
					lOk := .T.
				EndIf
				if ! lOk .AND.( SuperGetMv("MV_PAISLOC") <> "PTG")
					Help(" ",1,"A460VAZIOS")
					Return .F.
				EndIf
			EndIf
		Next nCont2
	Next nCont
Endif	
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se data n刼 ?menor que database ou que a data      ?
//?da linha acima												 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lRet
	For nCont := 1 to Len (aCols)
		If ! (aCols[nCont,nUsado2+1])
			If aCols[nCont,7] < dDataBase
				Help(" ",1,"A460DTCHEQ")
				Return .F.
			EndIf
		EndIf
	Next nCont
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Verifica se Cheques nao excederam o valor total da liquida噭o?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	A460Valor(.F.)
	If ( nValorLiq + nValorAcr - nValorDcr ) > nValor
		MsgInfo(STR0202,STR0051)
	EndIf
	If ExistBlock("F460TOK")
		lRet := ExecBlock("F460TOK",.f.,.f.)
	Endif
Endif

RestARea(aArea)
	
Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460NumChq?Autor ?Mauricio Pequim Jr    ?Data ?22/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砃umera cheques automaticamente se parcelamento automatico	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460NumChq()														  	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460																	  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460NumChq()

Local nCont := 0
Local cBco	:= 0
Local cAge	:= 0
Local cNCon	:= 0
Local cNChq	:= 0
Local lInicial := .F.
Local cPrefixo := space(03)
Local cTipoTit := space(03)
Local nTamNum := TamSX3( "E1_NUM" )[ 1 ]

cParc460 := F460Parc()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica existencia de titulo com mesmo numero				 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !(A460VerNum(aCols[n,1],M->E1_NUM,aCols[n,2]))
	Help(" ",1,"A460EXISTE",,M->E1_NUM,3,1)
	Return .f.
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Se parcelamento automatico e se primeira linha do aCols		 ?
//?numera cheque automaticamente								 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
aCols[n,6] :=  M->E1_NUM

If ( !Empty (cCondicao) .or. lUsaGE ) .and. n == 1 .and. Len(aCols) > 1 .and. Empty (aCols[2,6])
	lInicial := .T.

	cBco := aCols[1,3]
	cAge := aCols[1,4]
	cNcon := aCols[1,5]
	cNChq := aCols[n,6]
	cPrefixo := aCols[1,1]
	cTipoTit := aCols[1,2]
	For nCont := 2 to Len (aCols)
		cNChq := Pad( Soma1( AllTrim( cNChq ) ) , nTamNum )
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Verifica existencia de titulo com mesmo numero      		 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		IF !(A460VerNum(cPrefixo,cNChq,aCols[nCont,2]))
			Help(" ",1,"A460EXISTE",,cNChq,3,1)
			oGet:oBrowse:Refresh()
			oGet:Refresh()
			Return .f.
		EndIf
		aCols[nCont,1] := cPrefixo
		aCols[nCont,3] := cBco
		aCols[nCont,4] := cAge
		aCols[nCont,5] := cNCon
		aCols[nCont,6] := cNChq
	Next nCont
EndIf

If lInicial
	n := 1
EndIf

oGet:oBrowse:Refresh()
oGet:Refresh()
Return .T.


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460Emit  ?Autor ?Mauricio Pequim Jr    ?Data ?05/08/03 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砇epassa Nome do Emitente para as demais parcelas se parcela 潮?
北?         砿ento autom醫ico.                                        	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460Emit()  												  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460Emit()

Local nCont := 0
Local lInicial := .F.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Se parcelamento automatico e se primeira linha do aCols		 ?
//?numera cheque automaticamente								 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
aCols[n,8] :=  M->E1_EMITCHQ

If ( !Empty (cCondicao) .Or. lUsaGE ) .and. n = 1 .and. Len(aCols) > 1 .and. Empty (aCols[2,8])
	lInicial := .T.

   cEmiten460:= aCols[1,8]

	For nCont := 2 to Len (aCols)
		aCols[nCont,8] := cEmiten460
	Next nCont
EndIf

If lInicial
	n := 1
EndIf

oGet:oBrowse:Refresh()
oGet:Refresh()
Return .T.



/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460CtaChq?Autor ?Mauricio Pequim Jr    ?Data ?05/08/03 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砇epassa Nome do Emitente para as demais parcelas se parcela 潮?
北?         砿ento autom醫ico quando Bco/Age/Cta iguais		       	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460CtaChq()  										  	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460CtaChq()

Local nPos := 0
Local nPosAtu := 0
Local cBco,cAge,cNCon

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Se parcelamento automatico e se primeira linha do aCols		 ?
	//?numera cheque automaticamente								 ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aCols[n,5] :=  M->E1_CTACHQ
	
	nPosAtu := n
	cBco := aCols[n,3]
	cAge := aCols[n,4]
	cNcon := aCols[n,5]
	nPos := aScan(aCols, {|e| e[3]+e[4]+e[5] == cBco+cAge+cNcon})
	If nPos > 0 .and. !Empty(aCols[nPos,8])
		aCols[nPosAtu,8] := aCols[nPos,8]		
	Endif
	n := nPosAtu	

oGet:oBrowse:Refresh()
oGet:Refresh()
Return .T.
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460DataOK?Autor ?Mauricio Pequim Jr    ?Data ?22/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砎alida Data na Getdados   								  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460DataOK()											  	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460DataOK()

Local lRet := .T.
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se data n刼 ?menor que database                    ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If m->e1_vencto < dDataBase
	Help(" ",1,"A460DTCHEQ")
	lRet := .F.
EndIf
Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460Valor ?Autor ?Mauricio Pequim Jr    ?Data ?22/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砈oma os Valores das Liquida噊es							  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460Valor()											  	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function a460Valor(lValida)

Local lRet := .T. 
Local nVlLiq := 0
Local nVlAcr := 0
Local nVlDcr := 0
Local cVar
Local nCont

lValida := IIF(lValida == NIL, .T.,lValida)

If lValida
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//?Caso o valor do decrescimo seja maior que o valor a   ?
	//?da parcela, ou se tente digitar valor de acrescimo e  ?
	//?decrescimo para a mesma parcela, retorna .F.          ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	cVar := ReadVar()	
	DO CASE
		Case Alltrim(cVar) == "M->E1_VLCRUZ"
			nVlLiq	:= M->E1_VLCRUZ
			nVlAcr	:= aCols[n,10]
			nVlDcr	:= aCols[n,11]
		Case Alltrim(cVar) == "M->E1_ACRESC"
			nVlLiq	:= aCols[n,9]
			nVlAcr	:= M->E1_ACRESC
			nVlDcr	:= aCols[n,11]
		Case Alltrim(cVar) == "M->E1_DECRESC"
			nVlLiq	:= aCols[n,9]
			nVlAcr	:= aCols[n,10]
			nVlDcr	:= M->E1_DECRESC
	ENDCASE
	If nVlLiq < nVlDcr .or. (nVlAcr > 0 .and. nVlDcr > 0)
		Return .F.
	Endif
	aCols[n,9] := nVlLiq
	aCols[n,10] := nVlAcr
	aCols[n,11] := nVlDcr
Endif

nValorLiq := 0
nNroParc  := 0
nValorAcr := 0
nValorDcr := 0
nValorTot := 0

For nCont := 1 to Len(aCols)
	//Valor total (Valor Parcela + Acresc - Decresc) - Apenas informativo
	aCols[nCont,12] := aCols[nCont,9]+aCols[nCont,10]-aCols[nCont,11]
	If !aCols[nCont,nUsado2+1]    // Soma apenas os ativos
		nValorLiq  += aCols[nCont,9]
		nValorAcr  += aCols[nCont,10]
		nValorDcr  += aCols[nCont,11]				
		nValorTot  += aCols[nCont,12]
		nNroParc	:= nNroParc + 1 
	EndIf
Next nCont

If !lOpcAuto
	oValorLiq:Refresh()
	oValorAcr:Refresh()
	oValorDcr:Refresh()
	oValorTot:Refresh()
	oNroParc:Refresh()
EndIf

Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨460ChecF ?Autor ?Mauricio Pequim Jr.   ?Data ?22/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Sele噭o para a cria噭o do indice condicional	              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460												      潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460ChecF(nChoice,aSelFil,aTmpFil)

Local cFiltro := ""
Local aTam    := TamSX3("E1_VALOR")
Local nTamLiq := TamSx3('E1_NUMLIQ')[1]
Local nTamNum := TamSx3('E1_NUM')[1]
Local l460Fil := ExistBlock("FA460FIL")
Local lIntGem := HasTemplate('LOT')
Local nTamCtr := 0
Local cTmpSE1Fil := ""

//PCREQ-3782 - Bloqueio por situa玢o de cobran鏰
Local cLstCart := FN022LSTCB(1,'0006')	//Lista das situacoes de cobranca (Carteira)
Local cLstNoBlq := FN022LSTCB(6,'0006')	//Lista das situacoes de cobranca (N鉶 bloqueadas para determinado processo)

//Gestao
If __lDefTop == NIL
	__lDefTop 	:= IfDefTopCTB() .and. !lUsaGE .and. !lOpcAuto // verificar se pode executar query (TOPCONN)
Endif

cNumDe  := Pad(cNumDe ,nTamNum)
cNumAte := Pad(cNumAte,nTamNum)

If lIntGEM
	nTamCtr := TamSx3('E1_NCONTR')[1] 
Endif

If ExistBlock("FA460OWN")
	cFiltro := ExecBlock("FA460OWN",.F.,.F.)
Else
	If !lOpcAuto 
	
		If __lDefTop

			cFiltro := "SELECT "
			cFiltro += "R_E_C_N_O_ RECNO "
			cFiltro += " FROM "+	RetSqlName("SE1") + " SE1 "
			cFiltro += " WHERE "
			//Gestao
			If mv_par06 == 1
				cFiltro += "E1_FILIAL " + GetRngFil( aSelFil, "SE1", .T., @cTmpSE1Fil ) + " AND "
				aAdd(aTmpFil, cTmpSE1Fil)
		    Else
		    	cFiltro += "E1_FILIAL =  '" + xFilial("SE1") + "' AND "
			Endif
		
			cFiltro += " E1_CLIENTE BETWEEN '"+ cCliDe   + "' AND '" + cCliAte  + "' AND "
			cFiltro += " E1_LOJA BETWEEN '"   + cLojaDe  + "' AND '" + cLojaAte + "' AND "
			cFiltro += " E1_PREFIXO BETWEEN '"+ cPrefDe  + "' AND '" + cPrefAte + "' AND "
			cFiltro += " E1_NUM BETWEEN '"    + cNumDe   + "' AND '" + cNumAte  + "' AND "

			If nIntervalo = 1
				cFiltro += "E1_EMISSAO BETWEEN '" + DTOS(dData460I) + "' AND '" + DTOS(dData460F) + "' AND "
			Else
				cFiltro += "E1_VENCTO BETWEEN '"  + DTOS(dData460I) + "' AND '" + DTOS(dData460F) + "' AND "
			EndIf
			
			If nChoice = 2 //Nao converte outras moedas
				cFiltro += "E1_MOEDA = " + Alltrim(Str(nMoeda,2)) + " AND "
			Endif
			
			If mv_par04 = 1
				cFiltro += " E1_SITUACA IN "+FormatIn(cLstCart,'|')+" AND "	
			Else	
				//PCREQ-3782 - Bloqueio por situa玢o de cobran鏰
				cFiltro += " E1_SITUACA IN "+FormatIn(cLstNoBlq,'|')+" AND "
			Endif
			
			If cPaisLoc == "BRA"
				If cFilMsg == "1"
					cFiltro	+= " E1_IDLAN > 0 AND "  
				Else
					cFiltro	+= " E1_IDLAN = 0 AND "
				EndIf
			EndIf
			
			cFiltro += "E1_SALDO > 0 AND "
			cFiltro += "E1_VALOR >= " + AllTrim(Str(nValorDe ,aTam[1],aTam[2])) + " AND "
			cFiltro += "E1_VALOR <= " + AllTrim(Str(nValorAte,aTam[1],aTam[2])) + " AND "
			cFiltro += "E1_EMISSAO <= '" + DtoS( dDataBase ) + "' AND "
			
			cFiltro += "E1_TIPO NOT IN " + F460NotIN()  + " AND "

			If !lReliquida 	//Liquida titulos n苚 liquidados anteriormente
				cFiltro += " E1_NUMLIQ = '" + Space(nTamLiq) +"' AND "
			ElseIf lReliquida		// Reliquida嘺o
				cFiltro += " E1_NUMLIQ <> '" + Space(nTamLiq) +"' AND "
			Endif

			//Template GEM - nao podem ser liquidados/reliquidados os titulos do GEM pelo financeiro.
			If lIntGem
				cFiltro += " E1_NCONTR = '" + Space(nTamCtr) +"' AND "
			EndIf

			cFiltro += " D_E_L_E_T_ = ' ' "			

		Else 

			cFiltro := 'E1_FILIAL=="'+xFilial("SE1")+'" .And. '
			cFiltro += 'E1_CLIENTE>="'+cCliDe+'".And.'
			cFiltro += 'E1_LOJA>="'+cLojaDe+'".And.'
			cFiltro += 'E1_CLIENTE<= "'+cCliAte+'".And.'
			cFiltro += 'E1_LOJA<="'+cLojaAte+'".And.'
			cFiltro += 'E1_PREFIXO>="'+cPrefDe+'".And.'
			cFiltro += 'E1_PREFIXO<="'+cPrefAte+'".And.'
			cFiltro += 'E1_NUM>="'+Pad(cNumDe,Len(E1_NUM))+'".And.'
			cFiltro += 'E1_NUM<="'+Pad(cNumAte,Len(E1_NUM))+'".And.'
			cFiltro += 'DTOS(E1_EMISSAO)<="'+DTOS(dDataBase)+'".And.'

			If nIntervalo == 1
				cFiltro += 'DTOS(E1_EMISSAO)>="'+DTOS(dData460I)+'".And.'
				cFiltro += 'DTOS(E1_EMISSAO)<="'+DTOS(dData460F)+'".And.'
			Else
				cFiltro += 'DTOS(E1_VENCTO)>="'+DTOS(dData460I)+'".And.'
				cFiltro += 'DTOS(E1_VENCTO)<="'+DTOS(dData460F)+'".And.'
			EndIf
			
			If nChoice == 2 //Nao converte outras moedas
				cFiltro += 'StrZero(E1_MOEDA,2)=="'+StrZero(nMoeda,2)+'".And.'
			Endif
			
			If mv_par04 == 1
				cFiltro += 'E1_SITUACA $ "'+cLstCart+'" .And.'
			Else
				//PCREQ-3782 - Bloqueio por situa玢o de cobran鏰
				cFiltro += 'E1_SITUACA $ "'+cLstNoBlq+'" .And.'
			Endif
			
			cFiltro += 'E1_SALDO>0.And.'
		cFiltro += 'E1_ORIGEM != "FINA677" .And.'
			cFiltro += 'E1_VALOR >= ' + AllTrim(Str(nValorDe,aTam[1],aTam[2]))  + ' .And.'
			cFiltro += 'E1_VALOR <= ' + AllTrim(Str(nValorAte,aTam[1],aTam[2])) + ' .And.'
			
			cFiltro += '!(E1_TIPO$MVABATIM).And.'
			
			If !lReliquida 	//Liquida titulos n苚 liquidados anteriormente
				cFiltro += 'Empty(E1_NUMLIQ).And.'
			ElseIf lReliquida		// Reliquida嘺o
				cFiltro += '!Empty(E1_NUMLIQ).And.'
			Endif
			//Template GEM - nao podem ser liquidados/reliquidados os titulos do GEM pelo financeiro.
			If HasTemplate("LOT")
				cFiltro += 'Empty(E1_NCONTR).And.'
			EndIf
		
			cFiltro += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+'")'
			IF lUsaGE
				If Empty(cNrDoc) .or. cNrDOC == STR0153	//"Outros T韙ulos"
					cNrDoc := Space(TamSx3("E1_NRDOC")[1])
					cFiltro += '.And. E1_NRDOC == "'+cNrDoc+'"'
				Else
					cNrDoc := Substr(cNrDoc,1,TamSx3("JBE_CODCUR")[1])+;
					Substr(cNrDoc,TamSx3("JBE_CODCUR")[1]+2,TamSx3("JBE_PERLET")[1])
					cFiltro += '.And. SubStr(E1_NRDOC,1,'+alltrim(Str(TamSx3("JBE_CODCUR")[1]+TamSx3("JBE_PERLET")[1]))+') == "'+cNrDoc+'"'
				EndIF
				
				If !Empty(cNumRA)
					cFiltro += '.And. E1_NUMRA == "'+cNumRA+'"'
				EndIf
			EndIf
		Endif
	Else 
		cFiltro:=cAutoFil
	EndIf
	
	If l460Fil
	   cFiltro += ExecBlock("FA460FIL",.F.,.F.)
	Endif
Endif
	
Return cFiltro


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲A460DBEVA?Autor ?Mauricio Pequim Jr	?Data ?18/12/00 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Trata o dbeval para marcar e desmarcar item				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?FA460DBEVA()												  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460DbEva(nValorMax,nQtdTit)

If TRB->(MsRLock()) // Se conseguir travar o registro
	If nValor < nValorMax .And. (VALLIQ+nValor) <= nValorMax
		nValor += VALLIQ
		TRB->MARCA := cMarca
		nQtdTit++
	Else
		TRB->MARCA := " "
	EndIf
Endif
Return Nil
            

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o    矨460Grava ?Autor ?Mauricio Pequim Jr.   ?Data ?26.01.98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Programa de Atualizacao do SE1                             潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ?a460Grava (aHeader,aCols)                             	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?aHeader e Acols                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?Generico                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460Grava(aHeader,aCols)

Local cArquivo , nTotal := 0 , nHdlPrv := 0
Local nCntFor		:= 0
Local nSe1Rec		:= 0
Local lHeadProva	:= .F.
Local lPadrao		:= .F.
Local cPadrao
Local lContabiliza	:= .F.
Local lDigita		:= .T.
Local lAglutina		:= .T.
Local lf460Val		:= ExistBlock("F460VAL")
Local lf460SE1		:= ExistBlock("F460SE1")
Local aComplem		:= {}
Local nValForte		:= 0
Local nMCusto		:= Val(SuperGetMV("MV_MCUSTO"))
Local nMvCusto		:= nMCusto
Local nTotBaixar	:= nValorLiq
Local lF460NCC		:= ExistBlock("F460NCC")
Local lGeraNCC		:= .T.
Local nTitBxd		:= nQtdTit
Local lBxAbatim		:= .F.
Local nx
Local aCaixaFin		:= xCxFina()
Local i				:= 0
Local lAcreDecre	:= .F.
Local nValorTotal	:= 0     
Local nValPadrao	:= 0
Local aFlagCTB		:= {}
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local aAlt 			:= {}
Local cChaveTit		:= ""
Local cChaveFK7		:= ""
Local nQtdBaixas := 3
Local aTitSE5 := {}

//Rastreamento
Local lRastro		:= FVerRstFin()
Local aRastroOri	:= {}
Local aRastroDes	:= {}
Local nValProces	:= nValorLiq

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emiss鉶(default))
Local lPccBxCr		:= FPccBxCr()
Local aPccBxCr		:= {0,0,0,0}		//Pcc aqui
Local cPccBxCr		:= ""
Local nPropPcc		:= 1
Local nPis			:= 0
Local nCofins		:= 0
Local nCsll			:= 0
Local nTotPis		:= 0
Local nTotCofins	:= 0
Local nTotCsll		:= 0
Local nTotLiq		:= 0
//Controla IRPJ na baixa
Local lIrPjBxCr		:= FIrPjBxCr()
Local aDadosIR		:= Array(3)
Local cIrBxCr		:= ""
Local nPropIR		:= 1
Local nIrrf			:= 0
Local nTotIr		:= 0   

//639.04 Base Impostos diferenciada
Local lBaseImp		:= F040BSIMP(2)
Local nTotBase		:= 0
Local nBaseImp		:= 0
Local lAtuSldNat	:= .T.
Local nTamSeq		:= TamSX3("E5_SEQ")[1]
Local cSequencia	:= StrZero(0,nTamSeq)

//Controle de abatimento
Local lTitpaiSE1	:= .T.
Local nOrdTitPai	:= 0
Local bWhile		:= {|| !EOF() .And. E1_FILIAL+	E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA == LEFT(TRB->CHAVE2,LEN(TRB->CHAVE2)-3)}
Local cPeriodoLet	:= ''
Local cProdClass	:= ''
Local cTpDoc		:= ''
Local aPcc			:= {}
Local aBaixas		:= {}
Local cBanco		:= ''
Local cAgencia		:= ''
Local cConta		:= ''
Local cContrato		:= ''


//Reestrutura玢o SE5
Local oModelBxR	:= NIL
Local oSubFK1	//Movimentos de baixa a receber
Local oSubFK6	//Valores complementares (juros, multas, acr閟cimos e etc.)
Local oSubFK7	//Controle de documentos
Local lRet		:= .T.
Local cLog		:= ""
Local cCamposE5	:= ""
Local cChaveTit	:= ""
Local cChaveFK1	:= ""
Local cChaveFK7	:= ""
Local cIdDoc		:= ""
Local nPipe		:= 0
Local nVlrCtOr	:= 0

Local __aRelBx	:={} //Array com os titulos baixados para impressao do Recibo
Local __aRelNovos:={} //Array com os Novos Titulos gerados para impressao do Recibo
Local lLOJRREC  := ExistFunc("LOJRREC")              // Relatorio de impressao de Recibo
Local lULOJRREC := ExistFunc("U_LOJRRecibo")         // Relatorio de impressao de Recibo (RDMAKE)
Local lIMPLJRE  := SuperGetMV( "MV_IMPLJRE",.F., .F.)
Local aAreaSe1  := {}
Local aAreaSe5  := {}
Local aAreaRec  := {} 
Local cCcusto	:= ""
//Reestrutura玢o SE5

PRIVATE __LACO
If Type("lMsErroAuto")=="U"
	PRIVATE lMsErroAuto := .F.
Endif

aFill(aDadosIR,0)

//verifica se existem os capos de valores de acrescimo e decrescimo no SE5
lAcreDecre := .T.

nSaldoBx := 0

// Zerar variaveis para contabilizar os impostos da lei 10925.
VALOR  := 0
VALOR5 := 0
VALOR6 := 0
VALOR7 := 0                   
//EECXFIN
//Correcao Monetaria
nCm := 0

// Inicia controle de transacao
Begin Transaction

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Baixa dos titulos utilizados na liquida噭o			?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
DbSelectArea("TRB")
dbGotop()

__aBaixados := {}
__aRelBx	:= {}

While !Eof()

	DbSelectArea("TRB")
	If TRB->MARCA == cMarca
		DbSelectArea("SE1")
		DbSetOrder(2)
		If MsSeek(TRB->CHAVE2)   // Filial+Cliente+Loja+Prefixo+Num+Parcela+Tipo
			nSE1Rec := Recno()
			cCcusto := SE1->E1_CCUSTO
		Endif			
		If SE1->E1_CLIENTE+SE1->E1_LOJA < cCliDe+cLojaDe .And. ;
			SE1->E1_CLIENTE+SE1->E1_LOJA > cCliAte+cLojaAte
			DbSelectArea("TRB")
			DbSkip()
			Loop
		Endif

		aAdd(__aBaixados, {SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO })
		aadd(__aRelBx, {	SE1->E1_NUM				,;	//01-Nro do Titulo
				       	SE1->E1_PREFIXO			,;	//02-Prefixo
				       	SE1->E1_PARCELA			,;	//03-Parcela
				       	SE1->E1_TIPO 			,;	//04-Tipo
				       	SE1->E1_CLIENTE			,;	//5-Cliente
				       	SE1->E1_LOJA			,;	//6-Loja
				       	Dtos(SE1->E1_EMISSAO)	,;	//7-Emissao
				       	Dtos(SE1->E1_VENCTO)	,;	//8-Vencimento
				       	SE1->E1_VLCRUZ			,;	//9-Valor Original
				       	SE1->E1_SALDO			,;	//10-Saldo
				       	SE1->E1_MULTA			,;	//11Multa
				       	SE1->E1_JUROS			,;	//12Juros
				       	SE1->E1_DESCONT			,;	//13Desconto
				       	SE1->E1_VALOR			})	//14Valor Recebido	
		__cNroLiqui := cLiquid
		
		If GetNewPar("MV_RMCLASS", .F.) .And. (Empty(cPeriodoLet) .Or. Empty(cProdClass))
			cPeriodoLet := SE1->E1_PERLET
			cProdClass	:= SE1->E1_PRODUTO
		EndIf

		If FWHasEAI('FINA460',.T.,,.T.)
			cBanco 		:= SE1->E1_PORTADO
			cAgencia 	:= SE1->E1_AGEDEP
			cConta 		:= SE1->E1_CONTA
			cContrato 	:= SE1->E1_CONTRAT
		EndIf
		
		lBxAbatim := .F.
		aBaixas := {}

		If TRB->MULTALJ > 0
			nQtdBaixas := 4
		Else
			nQtdBaixas := 3
		EndIf

		If TRB->VALLIQ >= nTotBaixar
			RecLock("TRB")
			Replace TRB->VALLIQ	with nTotBaixar
			MsUnlock()
			nSaldoBx	:= Round(NoRound(xMoeda(TRB->VALLIQ,nMoeda,TRB->MOEDAO,,3,,TRB->CTMOED),3),2)
			nValBx		:= Round(NoRound(xMoeda(TRB->(VALLIQ-JUROS-MULTALJ+DESCON),nMoeda,TRB->MOEDAO,,3,,TRB->CTMOED),3),2)

			//Correcao Monetaria
			nCm := 0
			If TRB->MOEDAO > 1 .and. nMoeda == 1
				nCm := FA460CORR(nValBx,.T.)
			Endif

			nValPadrao	:= nValBx
			nAbatim 	:= TRB->ABATIM
			nSaldoE1	:=	SE1->E1_SALDO - nValBx
			If Str(nSaldoE1,17,2) == STR(nAbatim,17,2)
				nValBx += nAbatim
				nSaldoE1 -= nAbatim
				nValPadrao := nValBx
			Endif

			//Corrige eventuais problemas de arredondamento da moeda
			If ABS(nSaldoE1) <= 0.009
				nSaldoE1 := 0
			Endif

			nTotBaixar := 0
			nTitBxd--

			//Tratamento PCC na Baixa CR - pcc aqui
			//Proporcionalizo o valor baixado do principal com o valor do tiutlo.
			//Em seguida proporcionaliza os impostos calculados na emissao e 
			//que serao repassados as parcelas geradas da fatura
			If lPccBxCr .or. lBaseImp
				nPropPcc		:= nValPadrao/SE1->E1_VALOR
				If dDataBase < dLastPcc
					aPccBxCr[1]	+= SE1->E1_PIS * nPropPcc
					aPccBxCr[2]	+=	SE1->E1_COFINS * nPropPcc
					aPccBxCr[3]	+= SE1->E1_CSLL * nPropPcc
				Else
					aPcc	:= newMinPcc(dDataBase, nValPadrao,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE+SE1->E1_LOJA)
					aPccBxCr[1]	+= aPcc[2]
					aPccBxCr[2]	+= aPcc[3]
					aPccBxCr[3]	+= aPcc[4]
				EndIf
				nTotLiq		+= nValPadrao
				
				//639.04 Base Impostos diferenciada
				If SE1->(E1_PIS+E1_COFINS+E1_CSLL)+TRB->OUTRIMP > 0
					aPccBxCr[4] += If (	lBaseImp .and. SE1->E1_BASEIRF > 0 ,SE1->E1_BASEIRF, SE1->E1_VALOR) * nPropPcc
				Endif

			Endif
			//Tratamento IR na Baixa CR - pcc aqui
			//Proporcionalizo o valor baixado do principal com o valor do tiutlo.
			//Em seguida proporcionaliza os impostos calculados na emissao e 
			//que serao repassados as parcelas geradas da fatura
			If lIrPjBxCr .or. lBaseImp
				nPropIr		:= nValPadrao/SE1->E1_VALOR
				aDadosIR[1]	+= SE1->E1_IRRF * nPropIR
				nTotLiq		+= nValPadrao
				
				//639.04 Base Impostos diferenciada
				If SE1->E1_IRRF+TRB->OUTRIMP > 0
					aDadosIR[2] += If (	lBaseImp .and. SE1->E1_BASEIRF > 0 ,SE1->E1_BASEIRF, SE1->E1_VALOR) * nPropIR
				Endif

			Endif

		ElseIf TRB->VALLIQ < nTotBaixar
			nSaldoBx	:= Round(NoRound(xMoeda(TRB->VALLIQ,nMoeda,TRB->MOEDAO,,3,,TRB->CTMOED),3),2)
			nValBx	:= Round(NoRound(xMoeda(TRB->(VALLIQ-JUROS-MULTALJ+DESCON),nMoeda,TRB->MOEDAO,,3,,TRB->CTMOED),3),2)
			nValPadrao := nValBx
			nAbatim  := TRB->ABATIM
			nSaldoE1	:=	SE1->E1_SALDO - nValBx
			If Str(nSaldoE1,17,2) == STR(nAbatim,17,2)
				nValBx += nAbatim
				nSaldoE1 -= nAbatim
			Endif

			//Corrige eventuais problemas de arredondamento da moeda
			If ABS(nSaldoE1) <= 0.009
				nSaldoE1 := 0
			Endif

			//Correcao Monetaria
			nCm := 0
			If TRB->MOEDAO > 1  .and. nMoeda == 1
				nCm := 	FA460CORR(nValBx,.T.)
			Endif

			nTotBaixar -= TRB->VALLIQ
			nTitBxd--

			//Tratamento PCC na Baixa CR - pcc aqui
			//Proporcionalizo o valor baixado do principal com o valor do tiutlo.
			//Em seguida proporcionaliza os impostos calculados na emissao e 
			//que serao repassados as parcelas geradas da fatura
			If lPccBxCr .or. lBaseImp
				nPropPcc		:= nValPadrao/SE1->E1_VALOR
				If dDataBase < dLastPcc
					aPccBxCr[1]	+= SE1->E1_PIS * nPropPcc
					aPccBxCr[2]	+=	SE1->E1_COFINS * nPropPcc
					aPccBxCr[3]	+= SE1->E1_CSLL * nPropPcc
				Else
					aPcc	:= newMinPcc(dDataBase, nValPadrao,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE+SE1->E1_LOJA)
					aPccBxCr[1]	+= aPcc[2]
					aPccBxCr[2]	+= aPcc[3]
					aPccBxCr[3]	+= aPcc[4]
				EndIf
				nTotLiq		+= nValPadrao

				//639.04 Base Impostos diferenciada
				If (lPccBxCr .and. SE1->(E1_PIS+E1_COFINS+E1_CSLL) > 0) .or. ;
					(lBaseImp .and. TRB->(PIS+COFINS+CSLL+OUTRIMP) > 0)
					aPccBxCr[4] += If (	lBaseImp .and. SE1->E1_BASEIRF > 0 ,SE1->E1_BASEIRF, SE1->E1_VALOR) * nPropPcc
				Endif

			Endif
			//Tratamento IR na Baixa CR
			//Proporcionalizo o valor baixado do principal com o valor do tiutlo.
			//Em seguida proporcionaliza os impostos calculados na emissao e 
			//que serao repassados as parcelas geradas da fatura
			If lIrPjBxCr .or. lBaseImp
				nPropIr		:= nValPadrao/SE1->E1_VALOR
				aDadosIR[1]	+= SE1->E1_IRRF * nPropIR
				nTotLiq		+= nValPadrao			
				
				//639.04 Base Impostos diferenciada
				If SE1->E1_IRRF+TRB->OUTRIMP > 0
					aDadosIR[2] += If (	lBaseImp .and. SE1->E1_BASEIRF > 0 ,SE1->E1_BASEIRF, SE1->E1_VALOR) * nPropIR
				Endif

			Endif

		Endif
		// Guarda valor do titulo p/ contabilizacao atraves da variavel VALOR
		nValorTotal := SE1->E1_VLCRUZ
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//?Baixa titulos no SE1, procurando por abatimentos e  ?
		//?se for o caso, gera NCC para o cliente quando valor ?
		//?dos cheques for maior que o dos titulos selecionados?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		If SE1->E1_MOEDA > 1
			If nSaldoE1 <= 0.01
				nSaldoBx := SE1->E1_SALDO
				nCm	:= Iif(Iif(TRB->CTMOED != RecMoeda(dDataBase,SE1->E1_MOEDA), TRB->CTMOED, RecMoeda(dDataBase,SE1->E1_MOEDA)) == If(Empty(SE1->E1_TXMOEDA), RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA), SE1->E1_TXMOEDA), 0, nCm)
				nSaldoE1 := 0
			EndIf
		EndIf
		
		DbSelectArea("SE1")
		If MsSeek(TRB->CHAVE2)
			nSE1Rec := Recno()
			If !Empty(SE1->E1_NUMLIQ) .and. lReliquida
				cStatus := "R"
			ElseIf nSaldoE1 > 0
				cStatus := "A"
			Else
				cStatus := "B"
			Endif
			RecLock("SE1",.F.)
			Replace E1_VALLIQ	With nSaldoBx
			Replace E1_SALDO	With nSaldoE1
			Replace E1_BAIXA	With Iif(dDataBase>=E1_BAIXA,dDataBase,E1_BAIXA)
			Replace E1_MOVIMEN	With dDataBase
			Replace E1_OK		With Iif(E1_OK == cMarca,"  ",cMarca)
			Replace E1_STATUS	With cStatus
			Replace E1_TIPOLIQ	With cTipo
			Replace E1_SDACRES	With 0
			Replace E1_SDDECRE	With 0
			Replace E1_JUROS	With TRB->JUROS
			Replace E1_DESCONT	With TRB->DESCON
			
			If nMoeda <> 1
				Replace E1_CORREC	With Round(NoRound(xMoeda(nCM,1,nMoeda,dDataBase,8),3),2) * If(TRB->CTMOED != RecMoeda(dDataBase,SE1->E1_MOEDA), TRB->CTMOED, RecMoeda(dDataBase,SE1->E1_MOEDA))
			Else
				Replace E1_CORREC	With Round(NoRound(nCM,3),2)
			EndIf
			
			Replace E1_MULTA With TRB->MULTALJ
			If lUsaGE
				Replace E1_HIST	with cLiquid
				Replace E1_MOTNEG	with cMotivo
				If nSaldoBx > E1_VALOR
					Replace E1_MULTA With TRB->MULTALJ + Min(nSaldoBx-E1_VALOR,E1_VLMULTA)
					If nSaldoBX > E1_VALOR+E1_MULTA
						Replace E1_JUROS With (nSaldoBx-(E1_VALOR+E1_MULTA))
					EndIf
				EndIf
			EndIf

			MsUnlock()
	
			If lAtuSldNat
				AtuSldNat(SE1->E1_NATUREZ, SE1->E1_VENCREA, SE1->E1_MOEDA, "2", "R", SE1->E1_VALOR,SE1->E1_VLCRUZ, "-",,FunName(),"SE1", SE1->(Recno()),0)
			Endif

			//Rastreamento - Geradores
			If lRastro
				aadd(aRastroOri,{	SE1->E1_FILIAL,;
										SE1->E1_PREFIXO,;
										SE1->E1_NUM,;
										SE1->E1_PARCELA,;
										SE1->E1_TIPO,;
										SE1->E1_CLIENTE,;
										SE1->E1_LOJA,;
										SE1->E1_VALLIQ } )
			Endif			
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			//|Fun玢o Espec韋ica do Modulo Sigapls para atualizar Status de Guias Compradas |
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?					
			PL090TITCP(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,"1")
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//矷ntegracao Protheus X RM Classis Net (RM Sistemas)?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			if GetNewPar("MV_RMCLASS", .F.) .and. !Empty(SE1->E1_NUMRA)
				cNumRA 		:= SE1->E1_NUMRA 				 	//Pega o numero do RA do aluno para alimentar o campo E1_NUMRA com a inclusao do novo titulo
				If cPaisLoc == "BRA"
					nIDAPLIC 	:= SE1->E1_IDAPLIC 					//Pega o numero do IDENTIFICADOR DA MATRIZ APLICADA para alimentar o campo E1_IDAPLIC com a inclusao do novo titulo
				EndIf
				cTurma 		:= SE1->E1_TURMA 					//Pega a Turma do Aluno para alimentar o campo E1_TURMA com a inclusao do novo titulo
			endif		

			If mv_par05 == 1  // Exclui cheque amarrado ao titulo liquidado
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//砎erifica se existe um cheque gerado para este TITULO			?
				//硃ois se tiver, dever?ser cancelado                          ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				Fa460ExcSef(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO)
			Endif
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//?Baixar titulos de abatimento se for baixa total				 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF nSaldoE1 == 0 .and. ( TRB->ABATIM > 0 .or. (lBaseImp .and. TRB->(PIS+COFINS+CSLL+OUTRIMP) > 0) )
				dbSelectArea("__SE1")
				dbSetOrder(2)
				__SE1->(MsSeek(LEFT(TRB->CHAVE2,LEN(TRB->CHAVE2)-3))) 	// Filial+Cliente+Loja+Prefixo+Num+Parcela     
				If lTitpaiSE1
			 		If (nOrdTitPai:= OrdTitpai()) > 0
  						DbSetOrder(nOrdTitPai)
						If	DbSeek(xFilial("SE1",__SE1->E1_FILORIG)+TRB->TITPAI)    
	  						bWhile  := {|| !Eof() .And. Alltrim(__SE1->E1_TITPAI) == Alltrim(TRB->TITPAI)}  
  						Else
  							dbSetOrder(2)
	 						__SE1->(MsSeek(LEFT(TRB->CHAVE2,LEN(TRB->CHAVE2)-3))) 	// Filial+Cliente+Loja+Prefixo+Num+Parcela   
	 					EndIf
 	   					Endif
  					Endif

				While Eval(bWhile)  

					IF E1_TIPO $ MVABATIM
						RecLock("__SE1")
						Replace E1_SALDO	  With 0
						Replace E1_BAIXA	With Iif(dDataBase>=E1_BAIXA,dDataBase,E1_BAIXA)
						Replace E1_MOVIMEN  With dDataBase
						Replace E1_STATUS   With "B"
						MsUnlock()
					EndIF
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//?Carrega variavies para contabilizacao dos    ?
					//?abatimentos (impostos da lei 10925).         ?		
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If E1_TIPO == MVPIABT
						VALOR5 := E1_VALOR			
					ElseIf E1_TIPO == MVCFABT
						VALOR6 := E1_VALOR
					ElseIf E1_TIPO == MVCSABT
						VALOR7 := E1_VALOR						
					Endif		
					
					If lAtuSldNat
						AtuSldNat(SE1->E1_NATUREZ, SE1->E1_VENCREA, SE1->E1_MOEDA, "2", "R", SE1->E1_VALOR,SE1->E1_VLCRUZ, "+",,FunName(),"SE1", SE1->(Recno()),0)
					Endif
			
					dbSkip()
				EndDO
			Endif
			dbSelectArea("SE1")
			DbSetOrder(1)
			dbGoto(nSE1Rec)
			/*
			Atualiza o status do titulo no SERASA */
			If cPaisLoc == "BRA"
				If SE1->E1_SALDO <= 0
					cChaveTit := xFilial("SE1") + "|" +;
								SE1->E1_PREFIXO + "|" +;
								SE1->E1_NUM		+ "|" +;
								SE1->E1_PARCELA + "|" +;
								SE1->E1_TIPO	+ "|" +;
								SE1->E1_CLIENTE + "|" +;
								SE1->E1_LOJA
					cChaveFK7 := FINGRVFK7("SE1",cChaveTit)
					F770BxRen("2","LIQ",cChaveFK7)
				Endif
			Endif
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			//?Caso tenha processado todos os titulos marcados e     ?
			//?exista residuo (valor dos cheques > valor dos titulos)?
			//?Grava-se uma NCC para o Cliente                       ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			If ExistBlock("F460GerNCC")
				lGeraNCC := ExecBlock("F460GerNCC",.F.,.F.)
			Endif
			If Round(nTotBaixar,2) > 0 .and. nTitBxd == 0 .and. Empty(cNumRa) .And. lGeraNCC
				A460VerPc(1,.T.,cLiquid)
				RecLock("SE1",.T.)
				Replace E1_FILIAL	With xFilial("SE1")
				Replace E1_PREFIXO	With "LIQ"
				Replace E1_NUM		With cLiquid
				Replace E1_PARCELA	With cParc460
				Replace E1_TIPO		With MV_CRNEG
				Replace E1_EMISSAO	With dDataBase
				Replace E1_VENCTO	With dDataBase
				Replace E1_VENCREA	With DataValida(dDataBase)
				Replace E1_SALDO	With nTotBaixar
				Replace E1_VALOR	With nTotBaixar
				Replace E1_VLCRUZ	With Round(NoRound(xMoeda(nTotBaixar,nMoeda,1,,3),3),2)
				Replace E1_MOEDA	With nMoeda
				Replace E1_CLIENTE	With cCliente
				Replace E1_LOJA		With cLoja
				Replace E1_NOMCLI	With cNomeCli
				Replace E1_NUMLIQ	With cLiquid
				Replace E1_STATUS	With "A"
				Replace E1_SITUACA	With "0"
				Replace E1_VENCORI	With dDataBase
				Replace E1_EMIS1	With dDataBase
				Replace E1_NATUREZ	With cNatureza
				Replace E1_FILORIG	With cFilAnt
				Replace E1_MULTNAT	With "2"
				Replace E1_ORIGEM 	With "FINA460"

	            If lUsaGE
					SE1->E1_NUMRA := cNumRA
					SE1->E1_NRDOC := cNrDoc
				EndIf
				
				If cFilMsg == "1" .And. cPaisLoc == "BRA"
					Replace E1_IDLAN With 2
				EndIf
				
				//Integracao Protheus x Classis
				If GetNewPar("MV_RMCLASS",.F.) 
					SE1->E1_NUMRA 	:= cNumRa
					If cPaisLoc == "BRA"
						SE1->E1_IDAPLIC := nIdAplic
					EndIf
					SE1->E1_TURMA := cTurma
				Endif

				MsUnLock()
						
				If lF460NCC
					ExecBlock("F460NCC",.F.,.F.,{nSE1Rec})
				Endif

				//Rastreamento - Geradores
				If lRastro
					aadd(aRastroOri,{	SE1->E1_FILIAL,;
											SE1->E1_PREFIXO,;
											SE1->E1_NUM,;
											SE1->E1_PARCELA,;
											SE1->E1_TIPO,;
											SE1->E1_CLIENTE,;
											SE1->E1_LOJA,;
											SE1->E1_VALLIQ } )
				Endif			

				If mv_par01 == 1
					lPadrao	:= VerPadrao("500")		//Emiss刼 de Contas a Receber
					If !lHeadProva .and. lPadrao .and. mv_par01 == 1
						nHdlPrv := HeadProva( cLote,;
						                      "FINA460",;
						                      Substr( cUsuario, 7, 6 ),;
						                      @cArquivo )

						lHeadProva := .T.
					EndIf
					If lPadrao
						nTotal += DetProva( nHdlPrv,;
						                    "500",;
						                    "FINA460",;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )
						If UsaSeqCor()
							AADD(aDiario,{"SE1",SE1->(recno()),cCodDiario,"E1_NODIA","E1_DIACTB"}) 
						endif
					EndIf
					If nTotal > 0 .AND. !lUsaFlag .OR.(SE1->E1_TIPO $ MV_CRNEG)
						RecLock("SE1")
						SE1->E1_LA := "S"
					Endif					
				Endif	
				dbGoto(nSE1Rec)
			Endif
		EndIf
		SE1->(DbSetOrder(1))

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Atualiza o Cadastro de Clientes 							 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dbSelectArea("SE1")
		dbSetOrder(2)
		dbGoto(nSE1Rec)
		dbSelectArea("SA1")
		If MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			//Atualiza "Saldo Duplicatas" do Cliente utilizando mesmo conceito do nValPadrao
			//utilizado na rotina de baixas a receber(FINA070/FINXATU) 
			nValClient := nValPadrao
			IF SE1->E1_MOEDA > 1
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//?Caso a Moeda seja > 1, converte o valor para atualiza噭o do  ?
				//?cadastro do Cliente a partir do valor da moeda estrangeira   ?
				//?convertida p/ moeda 1 na Data de Emiss刼 do tulo, pois pode?
				//?ser efetuada uma baixa informando taxa contratada.           ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				nValClient:=Round(NoRound(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,3),3),2)
			Endif

			AtuSalDup("-",nValClient,1,SE1->E1_TIPO,,SE1->E1_EMISSAO)

			RecLock("SA1")
			IF (SE1->E1_BAIXA-SE1->E1_VENCREA) > SA1->A1_MATR
				Replace A1_MATR With (SE1->E1_BAIXA-SE1->E1_VENCREA)
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//?Atualiza Atraso M俤io.  Revisao em 07/12/95				     ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
         Replace A1_NROPAG With A1_NROPAG+1  //Numero de Duplicatas
			If (SE1->E1_BAIXA - SE1->E1_VENCREA) > 0
				SA1->A1_PAGATR	:= A1_PAGATR+SE1->E1_VALLIQ   // Pagamentos Atrasados
				SA1->A1_ATR		:= IIF(A1_ATR==0,0,IIF(A1_ATR < SE1->E1_VALLIQ,0,A1_ATR - SE1->E1_VALLIQ))
				SA1->A1_METR	:=	(A1_METR * (A1_NROPAG-1) + (SE1->E1_BAIXA - SE1->E1_VENCREA)) / (A1_NROPAG)
			Endif
			SA1->(MsUnlock())	// Destrava SA1 apos alteracoes...
		EndIf
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSelectArea("SE1")
		dbGoto(nSE1Rec)
		lContabiliza := Iif(mv_par01 == 1,.T.,.F.)
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//?PONTO DE ENTRADA F460SE1                                      ?
		//?Neste ponto de entrada dever?se retornar um array com os da- ?
		//?dos de campo e conteo  com dados dos titulos geradores a    ?
		//?serem gravados de forma complementar nos titulos gerados ap ?
		//?a liquidacao.  									              ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		If lf460SE1
			aComplem :=	ExecBlock("F460SE1",.f.,.f.,aComplem)
		EndIf

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//?Verifica se a contabiliza噭o ser?feita neste momen-?
		//?Este programa utiliza os proprios lancamentos padro-?
		//?nizados da emiss刼 / baixa de titulos a receber     ?
		//?521 em diante, dependendo da carteira               ?
		//?500 (Emiss刼 de Tulos a Receber)                  ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		cPadrao := fa070pad()
		lPadrao:= VerPadrao(cPadrao)
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Localiza a sequencia da baixa ( CP,BA,VL,V2)    			 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		aTipoDoc := {"CP","BA","VL","V2","LJ"}
		
		SE5->(dbSetOrder(2))
		For nx:= 1 to len(aTipoDoc)
			SE5->(MsSeek(xFilial("SE5") + aTipoDoc[nx] + SE1->E1_PREFIXO + SE1->E1_NUM + ;
			SE1->E1_PARCELA + SE1->E1_TIPO))
			While !SE5->(Eof())								.And.;
					SE5->E5_FILIAL  == xFilial("SE1")	.And.;
					SE5->E5_TIPODOC == aTipoDoc[nx]    	.And.;
					SE5->E5_PREFIXO == SE1->E1_PREFIXO 	.And.;
					SE5->E5_NUMERO  == SE1->E1_NUM		.And.;
					SE5->E5_PARCELA == SE1->E1_PARCELA 	.And.;
					SE5->E5_TIPO	== SE1->E1_TIPO     .And.;
					SE5->E5_CLIFOR  == SE1->E1_CLIENTE 	.And.;
					SE5->E5_LOJA    == SE1->E1_LOJA
				
				If PadL(AllTrim(cSequencia),nTamSeq,"0") < PadL(AllTrim(SE5->E5_SEQ),nTamSeq,"0")
					cSequencia := SE5->E5_SEQ
				Endif
					
				SE5->(dbSkip())
			EndDo
		Next nx
		If Len(AllTrim(cSequencia)) < nTamSeq
			cSequencia := PadL(AllTrim(cSequencia),nTamSeq,"0")
		Endif
		cSequencia := Soma1(cSequencia,nTamSeq)

		//Define os campos que n鉶 existem nas FKs e que ser鉶 gravados apenas na E5, para que a grava玢o da E5 continue igual
		cCamposE5 += "{{'E5_DTDIGIT', dDataBase}"
		cCamposE5 += ",{'E5_TIPO', SE1->E1_TIPO}"                            
		cCamposE5 += ",{'E5_PREFIXO', SE1->E1_PREFIXO}"
		cCamposE5 += ",{'E5_NUMERO', SE1->E1_NUM}"
		cCamposE5 += ",{'E5_PARCELA', SE1->E1_PARCELA}"
		cCamposE5 += ",{'E5_CLIFOR', SE1->E1_CLIENTE}"
		cCamposE5 += ",{'E5_LOJA', SE1->E1_LOJA}"                            
		cCamposE5 += ",{'E5_BENEF', SE1->E1_NOMCLI}"
		cCamposE5 += ",{'E5_DTDISPO', dDataBase}"
		
		If nMoeda > 1
			cCamposE5 += ",{'E5_VLJUROS'," + Str(TRB->JUROS) +"}"
		Else
			cCamposE5 += ",{'E5_VLJUROS'," + Str(Round(NoRound(xMoeda(TRB->JUROS,nMoeda,1,,3),3),2)) +"}"
		EndIf
		
		cCamposE5 += ",{'E5_VLDESCO'," + Str(Round(NoRound(xMoeda(TRB->DESCON,nMoeda,1,,3),3),2)) +"}"

		If nMoeda == 1
			cCamposE5 += ",{'E5_VLCORRE'," + Str(Round(NoRound(nCm,3),2)) +"}"
		EndIf

		cCamposE5 += ",{'E5_VLMULTA'," + Str(Round(NoRound(xMoeda(TRB->MULTALJ,nMoeda,1,,3),3),2)) +"}"

		If lAcreDecre
			cCamposE5 += ",{'E5_VLACRES'," + Str(Round(NoRound(xMoeda(TRB->ACRESC,nMoeda,1,,3),3),2)) +"}"
			cCamposE5 += ",{'E5_VLDECRE'," + Str(Round(NoRound(xMoeda(TRB->DECRESC,nMoeda,1,,3),3),2)) +"}"
		EndIf				                            

		cCamposE5 += "}"

		If ((xMoeda(TRB->VALLIQ,nMoeda,SE1->E1_MOEDA,,3)) - nSaldoBx) > 0.01
			nSaldoBX := TRB->VALLIQ
		EndIf

	
	 	oModelBxR	:= FWLoadModel("FINM010")
	 	oModelBxR:SetOperation( MODEL_OPERATION_INSERT ) //Inclusao
		oModelBxR:Activate()	
		oModelBxR:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou n鉶
		oModelBxR:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que ser鉶 gravados indepentes de FK5
		oModelBxR:SetValue( "MASTER", "NOVOPROC", .T. ) //Informa que a inclus鉶 ser?feita com um novo n鷐ero de processo
		
		oSubFK1	:= oModelBxR:GetModel("FK1DETAIL")
		oSubFK6	:= oModelBxR:GetModel("FK6DETAIL")
		
		cChaveTit	:= xFilial("SE1") + "|" +  SE1->E1_PREFIXO + "|" + SE1->E1_NUM + "|" + SE1->E1_PARCELA + "|" + SE1->E1_TIPO + "|" + SE1->E1_CLIENTE + "|" + SE1->E1_LOJA
		cChaveFK7	:= FINGRVFK7("SE1", cChaveTit)
		cChaveFk1	:= FWUUIDV4()
		
		//Dados do Processo - Define a chave da FK5 no IDORIG
		oFKA := oModelBxR:GetModel("FKADETAIL")
		If !oFKA:IsEmpty()
			oFKA:AddLine()
		Endif
		oFKA:SetValue( "FKA_IDORIG", cChaveFk1 )
		oFKA:SetValue( "FKA_TABORI", "FK1" )
	 			
		//Dados da baixa a receber
		oSubFK1:SetValue("FK1_RECPAG","R")
		oSubFK1:SetValue("FK1_HISTOR",STR0105)
		oSubFK1:SetValue("FK1_DATA",dDataBase)
		oSubFK1:SetValue("FK1_TPDOC","BA")
		oSubFK1:SetValue("FK1_MOTBX","LIQ")
		oSubFK1:SetValue("FK1_SEQ",cSequencia)

		If nMoeda <> 1
			oSubFK1:SetValue("FK1_VALOR",Round(NoRound(TRB->VALLIQ,3),2))
		Else
			oSubFK1:SetValue("FK1_VALOR",Round(NoRound(xMoeda(TRB->VALLIQ,nMoeda,1,,3),3),2))
		EndIf
		
		oSubFK1:SetValue("FK1_VLMOE2",nSaldoBX)
		oSubFK1:SetValue("FK1_DOC",cLiquid)
		oSubFK1:SetValue("FK1_NATURE",SE1->E1_NATUREZ)
		oSubFK1:SetValue("FK1_FILORI",SE1->E1_FILORIG)
		oSubFK1:SetValue("FK1_SITCOB",SE1->E1_SITUACA)
		oSubFK1:SetValue("FK1_MOEDA",StrZero(nMoeda,TamSX3("FK1_MOEDA")[1]))
		oSubFK1:SetValue("FK1_LA",IIf(lContabiliza .And. lPadrao,'S',''))
		oSubFK1:SetValue("FK1_IDDOC",cChaveFK7)					

		For i := 1 To nQtdBaixas
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//?Atualiza a Movimenta噭o Banc爎ia	   				         ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If i== 1
				cCpoTp  :="TRB->DESCON"
				cTpDoc  :="DC"
				cHistMov:= STR0103 //"Desconto s/Receb.Titulo"
			Elseif i==2
				cCpoTp  := "TRB->JUROS"
				cTpDoc  := "JR"
				cHistMov:= STR0104 //"Juros s/Receb.Titulo"
			Elseif i==3
				If nMoeda <> 1
					nCM := 0
				EndIf
				cCpoTp  := "nCm"
				cTpDoc  := "CM"
				cHistMov:= STR0199 //"Correcao Monet s/Receb.Titulo"
				If xMoeda(1,SE1->E1_MOEDA,nMoeda,,3) == TRB->CTMOED
					If ((xMoeda(&cCpoTp,nMoeda,SE1->E1_MOEDA,,3)) - nSaldoBx) > 0.01 //@@ validar cota玢o contratada
						nSaldoBX := &cCpoTp
					EndIf
				Else
					nVlrCtOr:=&cCpoTp / TRB->CTMOED //declarar esta variavel
					If ((xMoeda(nVlrCtOr,nMoeda,SE1->E1_MOEDA,,3)) - nSaldoBx) > 0.01 //@@ validar cota玢o contratada
						nSaldoBX := &cCpoTp
					EndIf
				Endif
			Elseif i==4
				cCpoTp  := "TRB->MULTALJ"
				cTpDoc  := "MT"
				cHistMov:= STR0209 //"Correcao Monet s/Receb.Titulo"
			Endif
			
			If i == 1
				//Descontos + Descrescimo (o valor de decrescimo e desconto ja vem somado)
				nValOp := Round(NoRound(xMoeda(TRB->DESCON,nMoeda,1,,3),3),2)
			ElseIf i == 2				
				//Juros + Acrescimo
				nValOp := Round(NoRound(xMoeda(TRB->JUROS,nMoeda,1,,3),3),2)// + IIf(lAcreDecre,Round(NoRound(xMoeda(TRB->ACRESC,nMoeda,1,,3),3),2),0)					
			ElseIf i == 3
				//Correcao monetaria
				nValOp := Round(NoRound(xMoeda(nCm,nMoeda,1,,3),3),2)
			ElseIf i == 4
				//Multa do loja
				nValOp := Round(NoRound(xMoeda(TRB->MULTALJ,nMoeda,1,,3),3),2)
			EndIf

			If nValOp <> 0
			
				If !oSubFK6:IsEmpty()
					//Inclui a quantidade de linhas necess醨ias
					oSubFK6:AddLine()	
					//Vai para linha criada
					oSubFK6:GoLine( oSubFK6:Length() )	
				Endif	
				oSubFK6:SetValue( "FK6_FILIAL"	, FWxFilial("FK6") )
		    	oSubFK6:SetValue( 'FK6_IDFK6'	, GetSxEnum('FK6','FK6_IDFK6') )
		    	oSubFK6:SetValue( 'FK6_TABORI'	, 'FK1' )
		    	oSubFK6:SetValue( 'FK6_TPDOC'	, cTpDoc )
		    	oSubFK6:SetValue( 'FK6_VALCAL'	, nValOp )  
		    	oSubFK6:SetValue( 'FK6_VALMOV'	, nValOp  )
		    	oSubFK6:SetValue( 'FK6_RECPAG'	, "R" )
		    	oSubFK6:SetValue( 'FK6_HISTOR'	, cHistMov )
				oSubFK6:SetValue( 'FK6_IDORIG'	, cChaveFk1 )	
				
			Endif				
			
			If UsaSeqCor()
				AADD(aDiario,{"SE5",SE5->(recno()),cCodDiario,"E5_NODIA","E5_DIACTB"}) 
			endif
			
		Next i
		
		VALOR       := nValorTotal
		nValorTotal := 0
		
		If oModelBxR:VldData()
			oModelBxR:CommitData()
			
			If lGrvLiqSE5
				aTitSE5 := aclone(FIM010RSE5())
			EndIF

			nRecSE5 := oModelBxR:GetValue("MASTER","E5_RECNO")
          	SE5->(dbGoTo(nRecSE5))
 			If lUsaFlag .And. lContabiliza .And. lPadrao // Armazena em aFlagCTB para atualizar no modulo Contabil
				aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
			EndIf


			oModelBxR:DeActivate()
			cCamposE5 := ''
		Else
			cLog := cValToChar(oModelBxR:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelBxR:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelBxR:GetErrorMessage()[6])               
			Help( ,,"M010VALID",,cLog, 1, 0 )              
		EndIf
		oModelBxR:DeActivate()
		oModelBxR:Destroy()
		oModelBxR:= nil
		oSubFK1 := nil
		oSubFK6 := nil
		
		If lTpComis .and. lComiLiq 
		
			If !MV_CRNEG $ SE1->E1_TIPO .And. !MV_CPNEG $ SE1->E1_TIPO
				aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})
				Fa440CalcB(aBaixas,.F.,.F.,"FINA460","+",,,.T.,SE1->(Recno()) )
			Endif				

		Endif
		
		If mv_par01 == 1   // Contabiliza On Line
			cAliasAnt := Alias()
			DbSelectArea("SA1")
			DbSetOrder(1)
			MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			dbSelectArea(cAliasAnt)
			If !lHeadProva .and. lPadrao
				nHdlPrv := HeadProva( cLote,;
				                      "FINA460",;
				                      Substr( cUsuario, 7, 6 ),;
				                      @cArquivo )

				lHeadProva := .T.
			EndIf

			If lPadrao
				nTotal += DetProva( nHdlPrv,;
				                    cPadrao,;
				                    "FINA460",;
				                    cLote,;
				                    /*nLinha*/,;
				                    /*lExecuta*/,;
				                    /*cCriterio*/,;
				                    /*lRateio*/,;
				                    /*cChaveBusca*/,;
				                    /*aCT5*/,;
				                    /*lPosiciona*/,;
				                    @aFlagCTB,;
				                    /*aTabRecOri*/,;
				                    /*aDadosProva*/ )

			EndIf
		EndIf
		MsUnlock()			
		     
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪??
		//砤tualiza situacao do aluno com a baixa do t韙ulo?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪??
        if lUsaGE
			SE1->(dbGoto(nSE1Rec))
			ACFina070()
		endif	

		
        //numbor			
		aAlt := {}
		aadd( aAlt,{ STR0204,'','','',STR0205 + Alltrim(cLiquid) })   
		//chamada da Fun玢o que cria o Hist髍ico de Cobran鏰
		FinaCONC(aAlt)	
 

	EndIf

	DbSelectArea("TRB")
	DbSkip()
	If nTotBaixar <= 0
		Exit
	Endif
End

//Chamada para o ponto de enteda GRVLIQSE5
If lGrvLiqSe5
	Execblock("GRVLIQSE5",.F.,.F.,aTitSE5)
EndIf

//Volta o status para evitar erro no vlr da corr monet caso seja feita + de uma liquida玢o sem sair da rotina
lTxEdit := .F.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Criacao dos titulos gerados pela liquidacao         ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

cPadrao	:= "500"
lPadrao	:= VerPadrao("500")		//Emiss刼 de Contas a Receber
nTotLiq	:= 0

//PCC Baixa CR
//Necessario somar o total da fatura antes da geracao da fatura
//para proporcionalizar o valor do PCC
If lPccBxCR .or. lBaseImp .or. lIrPjBxCr
	For nCntFor:=1 To Len(aCols)
		If !(aCols[nCntFor,nUsado2+1]) // .F. == Ativo  .T. == Deletado				
			nTotLiq += aCols[nCntFor,9]	
		Endif
	Next						
Endif	

__aNovosTit := {}  
__aRelNovos	:= {}
For nCntFor := 1 To Len(aCols)
	__LACO := nCntFor
	If !(aCols[nCntFor,nUsado2+1])
		cParc460 := F460Parc()

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//?Busca parcela disponivel para titulo                ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

		A460VerPc(nCntFor,.F.)

		//Impostos PCC com calculo para o Cliente/Natureza
		cPccBxCr	:= F460NatImp()	
	
		//PCC Baixa CR
		//Tratamento da proporcionalizacao dos impostos PCC
		//para posterior gravacao na parcela gerada
		If lPccBxCR .or. lBaseImp
			nPropPcc		:= aCols[nCntFor,9] / nTotLiq
			nPis			:= Round(NoRound(aPccBxCr[1] * nPropPcc,3),2)
			nCofins		:= Round(NoRound(aPccBxCr[2] * nPropPcc,3),2)						
			nCsll			:= Round(NoRound(aPccBxCr[3] * nPropPcc,3),2)
			nBaseImp		:= Round(NoRound(aPccBxCr[4] * nPropPcc,3),2)
			nTotPis		+= nPis
			nTotCofins	+= nCofins
			nTotCsll		+= nCsll
			nTotBase		+= nBaseImp
			
			//Acerto de eventuais problemas de arredondamento
			If aPccBxCr[1] - nTotPis <= 0.01
				nPis		+= aPccBxCr[1] - nTotPis
			Endif

			If aPccBxCr[2] - nTotCofins <= 0.01
				nCofins	+= aPccBxCr[2] - nTotCofins
			Endif

			If aPccBxCr[3] - nTotCsll <= 0.01
				nCSll		+= aPccBxCr[3] - nTotCsll
			Endif

			If aPccBxCr[4] - nTotBase <= 0.01
				nBaseImp	+= aPccBxCr[4] - nTotBase
			Endif
        
		Endif
		//IR Baixa CR
		//Tratamento da proporcionalizacao dos impostos IR
		//para posterior gravacao na parcela gerada
		If lIrPjBxCr .or. lBaseImp
			nPropIr		:= aCols[nCntFor,9] / nTotLiq
			nIrrf		:= Round(NoRound(aDadosIR[1] * nPropIr,3),2)
			nBaseImp		:= Round(NoRound(aDadosIR[2] * nPropIr,3),2)
			nTotIr   		+= nIrrf
			nTotBase		:= nBaseImp
			
			//Acerto de eventuais problemas de arredondamento
			If aDadosIR[1] - nTotIr <= 0.01
				nIrrf		+= aDadosIR[1] - nTotIr
			Endif

			If aDadosIR[2] - nTotBase <= 0.01
				nBaseImp	+= aDadosIR[2] - nTotBase 
			Endif
        
		Endif

		DbSelectArea("SE1")
		DbSetOrder(1) 
		
		If lUsaGE .and. Empty(aCols[nCntFor,6])
			cNumTitulo			:= GetSX8Num("SE1","E1_NUM")
			ConfirmSX8()
			cTipo   			:= SuperGetMV("MV_SIMB1")
		Else
			cNumTitulo	   		:= aCols[nCntFor,6]		// nro. do cheque
			cTipo			   	:= aCols[nCntFor,2]		// Tipo
		Endif

		aTit := {}
		AADD(aTit , {"E1_FILIAL"	, xFilial("SE1")										, NIL})						
		AADD(aTit , {"E1_PREFIXO"	, aCols[nCntFor,1]										, NIL})
		AADD(aTit , {"E1_NUM"    	, cNumTitulo											, NIL})
		AADD(aTit , {"E1_PARCELA"	, cParc460					 							, NIL})
		AADD(aTit , {"E1_TIPO"		, cTipo													, NIL})
		AADD(aTit , {"E1_NATUREZ"	, cNatureza												, NIL})
		AADD(aTit , {"E1_SITUACA"	, "0"													, NIL})
		AADD(aTit , {"E1_VENCTO"	, aCols[nCntFor,7]										, NIL})
		AADD(aTit , {"E1_VENCREA"	, DataValida(aCols[nCntFor,7],.T.)						, NIL})
		AADD(aTit , {"E1_VENCORI"	, aCols[nCntFor,7]										, NIL})
		AADD(aTit , {"E1_EMISSAO"	, dDataBase												, NIL})
		AADD(aTit , {"E1_EMIS1"		, dDataBase												, NIL})
		AADD(aTit , {"E1_CLIENTE"	, cCliente												, NIL})
		AADD(aTit , {"E1_LOJA"		, cLoja													, NIL})
		AADD(aTit , {"E1_NOMCLI"	, cNomeCli												, NIL})
		AADD(aTit , {"E1_MOEDA"		, nMoeda			 									, NIL})
		AADD(aTit , {"E1_VALOR"		, aCols[nCntFor,9]										, NIL})
		AADD(aTit , {"E1_SALDO"		, aCols[nCntFor,9]										, NIL})
		AADD(aTit , {"E1_VLCRUZ"	, xMoeda(aCols[nCntFor,9],nMoeda,1,dDataBase)			, NIL})
		AADD(aTit , {"E1_STATUS"	,"A"													, NIL})
		AADD(aTit , {"E1_FLUXO"		,"S"													, NIL})
		AADD(aTit , {"E1_OCORREN"	,"01"													, NIL})
		AADD(aTit , {"E1_ORIGEM"	,"FINA460"												, NIL})
		AADD(aTit , {"E1_NUMLIQ"	,cLiquid												, NIL})
		AADD(aTit , {"E1_FILORIG"	,cFilAnt												, NIL})
		AADD(aTit , {"E1_EMITCHQ"	,aCols[nCntFor,8]										, NIL})			
		AADD(aTit , {"E1_ACRESC"	,aCols[nCntFor,10]										, NIL})		// acrescimo
		AADD(aTit , {"E1_DECRESC"	,aCols[nCntFor,11]										, NIL})		// decrescimo
		AADD(aTit , {"E1_SDACRES"	,aCols[nCntFor,10]										, NIL})		// acrescimo
		AADD(aTit , {"E1_SDDECRE"	,aCols[nCntFor,11]										, NIL})		// decrescimo
		AADD(aTit , {"E1_MULTNAT"	,"2"													, NIL})
		AADD(aTit , {"E1_CCUSTO"	,cCcusto												, NIL})
		/*	N鉶 realiza grava玢o dos VENDEDORES para o t韙ulo da liquida玢o,
		pois o c醠culo de comiss鉶(FINA440) ?veito via rastreamento
		dos t韙ulos que foram liquidados.

		AADD(aTit , {"E1_VEND1"		,""														, NIL})*/

		aAdd( __aNovosTit, {aCols[nCntFor,1], cNumTitulo, cParc460, cTipo} )  
		
		aAdd(__aRelNovos, {	xFilial("SE1")										,;	//01-Filial 
							cNumTitulo											,;	//02-Nro do Titulo
				       		aCols[nCntFor,1]									,;	//03-Prefixo
				       		cParc460											,;	//04-Parcela
				       		cTipo		 										,;	//05-Tipo
				       		cCliente											,;	//06-Cliente
				       		cLoja												,;	//07-Loja
				       		Dtos(dDataBase)										,;	//08-Emissao
				       		Dtos(DataValida(aCols[nCntFor,7],.T.))				,;	//09-Vencimento
				       		xMoeda(aCols[nCntFor,9],nMoeda,1,dDataBase)			,;	//10-Valor Original
				       		aCols[nCntFor,9]									,;	//11-Saldo
				       		0													,;	//12-Multa
				       		0													,;	//13-Juros
				       		0													,;	//14-Desconto
				       		aCols[nCntFor,9]									,;	//15-Valor Recebido
				       		aCols[nCntFor,6]									,;	//16-Numero do cheque
				       		aCols[nCntFor,3] 									,;	//17-Banco
				       		aCols[nCntFor,4] 									,;	//18-Agencia
				       		aCols[nCntFor,5] 									,;	//19-Conta
				       		aCols[nCntFor,6] 									,;	//20-nro. do cheque
				       		aCols[nCntFor,9] 									})	//21-valor do cheque			

		IF lUsaGE
			AADD(aTit , {"E1_VALJUR"	, (aCols[nCntFor,9] * (nJCDTxPer/100))				, NIL})
			AADD(aTit , {"E1_HIST"		, cLiquid											, NIL})
			AADD(aTit , {"E1_VLMULTA"	, (aCols[nCntFor,9] * (nJCDTxJuro/100))				, NIL})
			AADD(aTit , {"E1_NUMRA"		, cNumRA											, NIL})
			AADD(aTit , {"E1_NRDOC"		, cNrDoc											, NIL})
		Else
			AADD(aTit , {"E1_BCOCHQ"	,aCols[nCntFor,3]									, NIL})
			AADD(aTit , {"E1_AGECHQ"	,aCols[nCntFor,4]									, NIL})
			AADD(aTit , {"E1_CTACHQ"	,aCols[nCntFor,5]									, NIL})
		EndIF

		If cFilMsg == "1" .And. cPaisLoc == "BRA"
			AADD(aTit , {"E1_IDLAN ", 2	, NIL})
		EndIf

		If GetNewPar("MV_RMCLASS", .F.) //Integracao Protheus X RM Classis Net (RM Sistemas)
			aAdd(aTit , {'E1_NUMRA'		, cNumRA		, Nil})
			IF cPaisLoc == "BRA"
				aAdd(aTit , {'E1_IDAPLIC'	, nIDAPLIC		, Nil})
			EndIf
			aAdd(aTit , {'E1_TURMA'		, cTurma		, Nil})
			aAdd(aTit , {'E1_PERLET'	, cPeriodoLet	, Nil})
			aAdd(aTit , {'E1_PRODUTO'	, cProdClass	, Nil})
			aAdd(aTit , {'E1_PORTADO'	, cBanco		, Nil})
			aAdd(aTit , {'E1_AGEDEP'	, cAgencia		, Nil})
			aAdd(aTit , {'E1_CONTA'		, cConta		, Nil})
			aAdd(aTit , {'E1_CONTRAT'	, cContrato		, Nil})
		EndIf

		If lPccBxCr
			If "PIS" $ cPccBxCr .and. nPis > 0
				AADD(aTit , {"E1_PIS"   ,  nPis		, NIL})
			Endif
			If "COF" $ cPccBxCr .and. nCofins > 0							
				AADD(aTit , {"E1_COFINS",  nCofins	, NIL}) 
			Endif
			If "CSL" $ cPccBxCr .and. nCsll > 0
				AADD(aTit , {"E1_CSLL"  ,  nCsll	, NIL})
			Endif
		Else
			If lBaseImp .and. aPccBxCr[1] > 0 
				AADD(aTit , {"E1_BASEPIS"  ,  ABS(nValPadrao) 	, NIL})
			Endif
		Endif						

		//639.04 Base Impostos diferenciada
		If lBaseImp .and. aPccBxCr[4] > 0
			AADD(aTit , {"E1_BASEIRF"  ,  ABS(nBaseImp) 	, NIL})
		Endif  
		If lIrPjBxCr
			If "IRRF" $ cIrBxCr .and. nIrrf > 0
				AADD(aTit , {"E1_IRRF"   ,  nIrrf			, NIL})
			Endif						
		Endif						

		//639.04 Base Impostos diferenciada
		If lBaseImp .and. aDadosIR[2] > 0
			AADD(aTit , {"E1_BASEIRF"  ,  ABS(nBaseImp) 	, NIL})
		Endif

		MSExecAuto({|x, y| FINA040(x, y)}, aTit, 3)

		//Verifica se a gravacao ocorreu normalmente
		If lMsErroAuto
			MOSTRAERRO() 
			DisarmTransaction()
			Exit
		Endif


		If lUsaFlag .AND. lPadrao .AND. MV_PAR01 == 1 // Armazena em aFlagCTB para atualizar no modulo Contabil
			aAdd( aFlagCTB, {"E1_LA", "S", "SE1", SE1->( Recno() ), 0, 0, 0} )
		Else
			RecLock("SE1",.F.)
				SE1->E1_LA := Iif(lPadrao .and. mv_par01==1,"S","")
			MsUnLock()
		EndIf
        
		nValorTotal+= SE1->E1_VLCRUZ
		
		//Rastreamento - Gerados
		If lRastro
			aadd(aRastroDes,{	SE1->E1_FILIAL,;
									SE1->E1_PREFIXO,;
									SE1->E1_NUM,;
									SE1->E1_PARCELA,;
									SE1->E1_TIPO,;
									SE1->E1_CLIENTE,;
									SE1->E1_LOJA,;
									SE1->E1_VALOR } )
		Endif			
		
		If Alltrim(aCols[nCntFor,2]) == Alltrim(MVCHEQUE) .And.;
			SuperGetMv("MV_GRSEFLQ",,.F.)  // Indica se deve gravar SEF na liquidacao
			// Se o cheque nao existir no cadastro
			If SEF->(!MsSeek(xFilial("SEF")+"R"+aCols[nCntFor,3]+aCols[nCntFor,4]+aCols[nCntFor,5]+aCols[nCntFor,6]+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
				RecLock("SEF",.T.)
		  		SEF->EF_FILIAL		:= xFilial("SEF")
		  		SEF->EF_BANCO		:= aCols[nCntFor,3] // Banco
		  		SEF->EF_AGENCIA		:= aCols[nCntFor,4] // Agencia
		  		SEF->EF_CONTA		:= aCols[nCntFor,5] // Conta
		  		SEF->EF_NUM			:= aCols[nCntFor,6] // nro. do cheque
		  		SEF->EF_VALOR		:= aCols[nCntFor,9] // valor do cheque			
		  		SEF->EF_VALORBX		:= aCols[nCntFor,9] // valor do cheque		
		  		SEF->EF_CPFCNPJ		:= Posicione("SA1",1,xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_CGC")	
		  		SEF->EF_EMITENT		:= aCols[nCntFor,8] // Emitente
		  		SEF->EF_DATA		:= dDataBase
		  		SEF->EF_VENCTO		:= aCols[nCntFor,7] // data de vencimento
		  		SEF->EF_HIST		:= STR0169 // "Chq. gerado pela liquidacao"
				SEF->EF_CLIENTE		:= SE1->E1_CLIENTE
				SEF->EF_LOJACLI		:= SE1->E1_LOJA
		  		SEF->EF_PREFIXO		:= SE1->E1_PREFIXO
				SEF->EF_TITULO		:= SE1->E1_NUM
				SEF->EF_PARCELA		:= SE1->E1_PARCELA
				SEF->EF_TIPO		:= SE1->E1_TIPO
				SEF->EF_CART		:= "R"
				SEF->EF_ORIGEM		:= "FINA460"
				// Grava o identificador de que o cheque ja foi utilizado na baixa, devido as
				// baixas parciais, pois nas baixas futuras esses cheques nao podem mais serem utilizados
				// na geracao do movimento bancario
				If GetMv("MV_SLDBXCR") <> "C"
					SEF->EF_USADOBX := "S"
				Endif	
				// Ponto de Entrada que permite grava玢o de campos do usu醨io
					If ExistBlock( "F460GRVSEF" )
						ExecBlock( "F460GRVSEF" )
					
 					EndIf
 						
				MsUnlock()
			Endif
		Endif

		If lUsaGE .and. Empty(aCols[nCntFor,5]) .and. GetNewPar( "MV_ACNEGOC", .T. ) == .T. // T韙ulo pago em dinheiro ?baixado automaticamente

			aTit := {}
			AADD(aTit , {"E5_FILIAL",xFilial("SE5"), NIL})
			AADD(aTit , {"E5_TIPODOC","VL", NIL})
			AADD(aTit , {"E5_VALOR",SE1->E1_VALOR, NIL})
			AADD(aTit , {"E5_BANCO",aCaixaFin[1], NIL})
			AADD(aTit , {"E5_AGENCIA",aCaixaFin[2], NIL})
			AADD(aTit , {"E5_CONTA",aCaixaFin[3], NIL})
			AADD(aTit , {"E5_DATA",dDataBase, NIL})
			AADD(aTit , {"E5_DTDIGIT",dDataBase, NIL})
			AADD(aTit , {"E5_DTDISPO",SE1->E1_EMISSAO, NIL})
			AADD(aTit , {"E5_PREFIXO",SE1->E1_PREFIXO, NIL})
			AADD(aTit , {"E5_NUMERO",SE1->E1_NUM, NIL})
			AADD(aTit , {"E5_PARCELA",SE1->E1_PARCELA, NIL})
			AADD(aTit , {"E5_TIPO",SE1->E1_TIPO, NIL})
			AADD(aTit , {"E5_SEQ",PadL("1",nTamSeq,"0"), NIL})
			AADD(aTit , {"E5_NATUREZ",SE1->E1_NATUREZ, NIL})
			AADD(aTit , {"E5_CLIFOR",SE1->E1_CLIENTE, NIL})
			AADD(aTit , {"E5_LOJA",SE1->E1_LOJA, NIL})
			AADD(aTit , {"E5_RECPAG","R", NIL})
			AADD(aTit , {"E5_MOTBX","NOR", NIL})
		
			//3 = Baixa de titulo
			MSExecAuto({|x, y| FINA070(x, y)}, aTit, 3)
			
			If  lMsErroAuto
				MOSTRAERRO() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
			                 // deve ser liberado a funcao mostraerro para ajudar na analise

				DisarmTransaction()
				Exit
			EndIf

		EndIF

		If lf460Val
			ExecBlock("F460VAL",.f.,.f.,aComplem)
		EndIf


		If mv_par01 == 1  // Contabiliza On Line
			If !lHeadProva .and. lPadrao
				nHdlPrv := HeadProva( cLote,;
				                      "FINA460",;
				                      Substr( cUsuario, 7, 6 ),;
				                      @cArquivo )

				lHeadProva := .T.
			EndIf

			If lPadrao
				nTotal += DetProva( nHdlPrv,;
				                    cPadrao,;
				                    "FINA460",;
				                    cLote,;
				                    /*nLinha*/,;
				                    /*lExecuta*/,;
				                    /*cCriterio*/,;
				                    /*lRateio*/,;
				                    /*cChaveBusca*/,;
				                    /*aCT5*/,;
				                    /*lPosiciona*/,;
				                    @aFlagCTB,;
				                    /*aTabRecOri*/,;
				                    /*aDadosProva*/ ) 
				If UsaSeqCor()
					AADD(aDiario,{"SE1",SE1->(recno()),cCodDiario,"E1_NODIA","E1_DIACTB"}) 
				Endif 
			EndIf
		EndIf
	EndIf
Next nCntFor

//Integra玢o via Mensagem 趎ica
If cFilMsg == "1" .and. FWHasEAI('FINA460',.T.,,.T.)
	FwIntegDef( 'FINA460', , , , 'FINA460' )
EndIf

VALOR := 0

VALOR := nValorTotal

If mv_par01 == 1 .And. lPadrao 

	//Desposiciono SE1 para nao duplicar
	nSe1Rec := SE1->(RECNO())
	SE1->(dbGoBottom())
	SE1->(dbSkip())

	//Contabilizo totalizador - VALOR
	nTotal += DetProva( nHdlPrv,;
	                    cPadrao,;
	                    "FINA460",;
	                    cLote,;
	                    /*nLinha*/,;
	                    /*lExecuta*/,;
	                    /*cCriterio*/,;
	                    /*lRateio*/,;
	                    /*cChaveBusca*/,;
	                    /*aCT5*/,;
	                    /*lPosiciona*/,;
	                    @aFlagCTB,;
	                    /*aTabRecOri*/,;
	                    /*aDadosProva*/ )

	//Reposiciono SE1
	SE1->(DBGOTO(nSe1Rec))

EndIF

// Finaliza controle de transacao
End Transaction

If nTotal > 0
	RodaProva(  nHdlPrv,;
				nTotal)
				
	lDigita	:=IIF(mv_par02==1,.T.,.F.)
	lAglutina:=IIF(mv_par03==1,.T.,.F.)

	cA100Incl( cArquivo,;
	           nHdlPrv,;
	           3,;
	           cLote,;
	           lDigita,;
	           lAglutina,;
	           /*cOnLine*/,;
	           /*dData*/,;
	           /*dReproc*/,;
	           @aFlagCTB,;
	           /*aDadosProva*/,;
	           aDiario )
	aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento


EndIf

VALOR := 0

If Existblock("F460CTB")		// ponto apos a contabilizacao
	Execblock("F460CTB",.F.,.F.)
Endif

//Gravacao do rastreamento
If lRastro
	FINRSTGRV(2,"SE1",aRastroOri,aRastroDes,nValProces) 
Endif 

//Faz a impressao do Recibo de pagamento
If lImpLjRe .And. (lLojrRec .Or. lULOJRREC) 
    If Len(__aRelBx) > 0
        aAreaSe1 := SE1->(GetArea())
        aAreaSe5 := SE5->(GetArea())
        aAreaRec := GetArea()
        
        If lULOJRREC
            //Fonte n鉶 ser?mais padrao mas sim um RDMake padr鉶.
            U_LOJRRecibo("", "", __aRelBx, Nil, __aRelNovos)
        Else
            LOJRREC("", "", __aRelBx, Nil, __aRelNovos)
        EndIf
        
        RestArea(aAreaSe1)
        RestArea(aAreaSe5)
        RestArea(aAreaRec)
    EndIf
EndIf

Return .T.

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o	 矨460YesNo	?Autor ?Mauricio Pequim Jr.   ?Data ?25/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Exibe mensagem de OK para dados digitados da fatura		  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460YesNo()					   						      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
static function A460YesNo(nOpcao)
DEFAULT nOpcao := 1
Return (MsgYesNo(IIF(nOpcao == 1, STR0050,STR0159),STR0051))  //"Confirma Dados?"###"Aten噭o" //"Confirma Cancelamento?"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o	 矨460Exibe	?Autor ?Pilar S. Albaladejo   ?Data ?07/11/95 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Exibe Totais de titulos selecionados						  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460Exibe()											  	  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
static function A460Exibe(cAlias,cMarca,oValor,oQtdTit)
DbSelectArea(cAlias)
If (cAlias)->MARCA == cMarca
	nValor 	+= (cAlias)->VALLIQ 
	nQtdTit++
Else
	nValor 	-= (cAlias)->VALLIQ 
	nQtdTit--
EndIf

nValor := IIf (nValor < 0, 0, nValor)
nQtdTit:= Iif (nQtdTit < 0, 0 ,nQtdTit)
oValor:Refresh()
oQtdTit:Refresh()
Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460Invert ?Autor ?Wagner Xavier		    ?Data ?09/05/97潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Marca / Desmarca titulos					  	         		潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460													    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460Inverte(cMarca,oValor,oQtdTit,lTodos,oMark)
Local nReg		:= TRB->(Recno())
Local nDescBol	:= 0
Local nDesconto	:= 0
Local lFini055	:= IsInCallStack("FINI055")
Local nBValLiq	:= 0

DEFAULT lTodos  := .T.

DbSelectArea("TRB")
If lTodos
	DbGoTop()
Endif
While !lTodos .Or. !Eof()
	SE1->(MSSeek(TRB->CHAVE))

	If !lFini055 .And. cFilMsg == "1"
		If !(FA070Integ(.F.))
			Exit
		Endif
	Endif
	
	If SE1->(MsRLock()) .and. SE1->E1_SALDO > 0

		If cFilMsg == "1" .and. FWHasEAI("FINI070A",.T.,,.T.) .And. FWHasEai("FINA070",.T.,,.T.) .And. ;
		(AllTrim(SE1->E1_ORIGEM) $ 'L|S|T' .Or. Iif(cPaisLoc=="BRA", SE1->E1_IDLAN > 0,.F.) )
			nDescBol := SE1->E1_VLBOLSA + SE1->E1_DESCONT
		EndIf	
		
		If TRB->MARCA == cMarca
			nValor -= TRB->VALLIQ
			nQtdTit--
			nBValLiq	:= TRB->BKPVLLIQ //RESTAURA OS VALORES LIQUIDO E DESCONTO
			nDesconto := TRB->BKPDESC
			RecLock("TRB")
				Replace MARCA With Space(02)
				Replace VALLIQ With nBValLiq 
				Replace DESCON With nDesconto 
			TRB->(MsUnlock())
			SE1->(MsUnlock()) //Destravo para que outro detrminal possa utilizar o documento
		Else
			nBValLiq:= TRB->VALLIQ
			nDesconto := TRB->DESCON		
			RecLock("TRB")
				Replace MARCA With cMarca  
				Replace VALLIQ With Round(NoRound(xMoeda(nBValLiq-nDescBol,SE1->E1_MOEDA,nMoeda,,3),3),2)
				Replace DESCON With Round(NoRound(xMoeda(nDesconto+nDescBol,SE1->E1_MOEDA,nMoeda,,3),3),2) 
			TRB->(MsUnlock())
			nValor += TRB->VALLIQ
			nQtdTit++
		EndIf
	Endif
	If lTodos
		TRB->(dbSkip())
	Else
		Exit
	Endif
End
DbGoTo(nReg)
nValor := IIf (nValor < 0, 0, nValor)
nQtdTit := IIF (nQtdTit < 0, 0 , nQtdTit)
oQtdTit:Refresh()
oValor:Refresh()
Return(NIL)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o	 矨460Cond 	?Autor ?Mauricio Pequim Jr.   ?Data ?25/01/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Faz calculos da Liquidacao de parcelas automaticas 		  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?A460Cond(cCondicao)										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
static function A460Cond(cCondicao,nUsado2)
  
Local nW:=0
Local nValParc		:= 0
Local nDifer		:= 0
Local aTamBco := TamSx3("E1_BCOCHQ")
Local aTamAge := TamSx3("E1_AGECHQ")
Local aTamCta := TamSx3("E1_CTACHQ")
Local aTamTit := TamSx3("E1_NUM")
Local nHeader
Local nTmpValue := nValor
Local nTmpParc := nJCDParcel
Local nCount := 0
Local nCond
Local lRet:=.T.
Local lFA460Con:= ExistBlock("FA460Con")

SE4->( dbSetOrder( 1 ) )
SE4->( MsSeek( xFilial("SE4") + cCondicao ) )

If SE4->E4_TIPO == "9"
	Return .F.	
ElseIf SE4->E4_TIPO == "A"
	// As condicoes de pagamento do tipo A s鉶 exclusivas dos modulos SIGAVEI e SIGAOFI.
	Alert(STR0186)
	Return .F.	
Endif

If Empty(cCondicao)
	IF lUsaGE
		If ! Empty(nJCDEntrad)
			aParcelas := {{dDataBase,nJCDEntrad}}
			nCount ++
			nTmpValue -= nJCDEntrad
			nTmpParc --
			nTmpParc := Max(nTmpParc,1)
		Else
			aParcelas := {}
		EndIf
		While nTmpValue > 0 .And. nTmpParc > 0
			nCount ++
			aadd(aParcelas,{dDataBase+((nCount-1)*nJCDInterv), Min(Min(Max((nValor-nJCDEntrad) /nTmpParc,nJCDValMin),nJCDValMax),nTmpValue)} )
			nTmpValue -= aParcelas[nCount][2]
		End
		If !Empty(aParcelas)
			if aParcelas[nCount][2] < nJCDValMin .and. nCount >= 2
				aParcelas[nCount-1][2] += aParcelas[nCount][2]
				adel(aParcelas,nCount)
				aSize( aParcelas, len( aParcelas ) - 1 )
			EndIf
		Else
			aParcelas := {{dDataBase,nValor}}
		Endif
	Else
		aParcelas := {{dDataBase,nValor}}
	EndIf
Else	
	aParcelas := Condicao (nValor,cCondicao,,dDataBase)
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Corrige possiveis diferencas entre o valor selecionado e o ?
	//?apurado ap a divisao das parcelas						   	?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nCond := 1 to Len (aParcelas)
		nValParc += aParcelas [ nCond, 2]
	Next
	If nValParc != nValor
		nDifer := round(nValor - nValParc,2)
		aParcelas [ Len(aParcelas), 2 ] += nDifer
	EndIf
Endif	

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Passa para aCols{} as datas e Valores de parcela apurados  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lUsaGe .and. Empty(cTipo) .and. Len(aCols) > 0
	cTipo := aCols[1,2]
Endif

aCols:= Array(len(aParcelas),(nUsado2+1))
cPais := SuperGetMv("MV_PAISLOC")
For nCond := 1 to Len (aParcelas)
  	If lUsaGE .and. Len(aPrefixo) > __NEG
  		aCols[nCond,1] := aPrefixo[__NEG]
  	ElseIf ExistIni("E1_PREFIXO")
     	aCols[nCond,1] := InitPad(SX3->X3_RELACAO)
  	Else
		aCols[nCond,1] := space(3)
   EndIf
   If lOpcauto
	   aCols[nCond,1]:=Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_PREFIXO" }))>0 , aAutoItens[nCond,nW,2] , aCols[nCond,1])//Prefixo
   EndIf
	IF lUsaGE
		aCols[nCond,3] := nJCDBanco								// Banco
		aCols[nCond,4] := nJCDAgenci							// Agencia
		aCols[nCond,5] := nJCDNumCon   							// Conta
	Else
		If lOpcauto                                   
			aCols[nCond,3] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_BCOCHQ" }))>0 , aAutoItens[nCond,nW,2] , Space(aTamBco[1])) // Banco
			aCols[nCond,4] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_AGECHQ" }))>0 , aAutoItens[nCond,nW,2] , Space(aTamAge[1]))	// Agencia
			aCols[nCond,5] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_CTACHQ" }))>0 , aAutoItens[nCond,nW,2] , Space(aTamCta[1]))	// Conta		
		Else
			aCols[nCond,3] := Space(aTamBco[1])			// Banco
			aCols[nCond,4] := Space(aTamAge[1])			// Agencia
			aCols[nCond,5] := Space(aTamCta[1])			// Conta
		EndIf
	EndIf                            
	
	aCols[nCond,2] := cTipo
	If lOpcauto
		aCols[nCond,6] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_NUM" }))>0 , aAutoItens[nCond,nW,2] , Space(aTamTit[1]))	// nRO.cHEQUE
		aCols[nCond,7] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_VENCTO" }))>0 , aAutoItens[nCond,nW,2] , aParcelas[nCond,1])	// data
		aCols[nCond,8] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_EMITCHQ" }))>0 , aAutoItens[nCond,nW,2] , space(40))	// Nome do emitente
		aCols[nCond,9] := Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_VLCRUZ" }))>0 , aAutoItens[nCond,nW,2] , aParcelas [nCond,2])	// valor da parcela
		aCols[nCond,10]:= Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_ACRESC" }))>0 , aAutoItens[nCond,nW,2] , 0)		// acrescimo        
		iF aCols[nCond,10] > 0 //Se existe Acrecimo desconsidera Decrescimo
			aCols[nCond,11]:=  0		// decrescimo      		
			aCols[nCond,12]:=aCols[nCond,9]+aCols[nCond,10]	// valor do cheque
		Else
			aCols[nCond,11]:= Iif((nW:=aScan(aAutoItens[nCond],{|x| Alltrim(x[1])=="E1_DECRESC" }))>0 , aAutoItens[nCond,nW,2] , 0)		// decrescimo      				
			aCols[nCond,12]:=aCols[nCond,9]-aCols[nCond,11]	// valor do cheque
		EndIf
	Else 
		aCols[nCond,6] := Space(aTamTit[1])		// nRO.cHEQUE
		aCols[nCond,7] := aParcelas[nCond,1]	// data
		aCols[nCond,8] := space(40)				// Nome do emitente
		aCols[nCond,9] := aParcelas [nCond,2]	// valor da parcela
		aCols[nCond,10] := 0							// acrescimo        
		aCols[nCond,11] := 0               		 // decrescimo      		
		aCols[nCond,12] :=aParcelas [nCond,2]	// valor do cheque 			
	EndIf
	// Iniciar colunas adicionadas pelo usuario
	If nUsado2 > 12 // Tamanho do aHeader
		For nHeader := 13 to nUsado2
			aCols[nCond,nHeader] := CriaVar(aHeader[nHeader,2],.T.)
		Next
	Endif
	aCols[nCond,nUsado2+1] := .F.										// controle de delecao
Next nCond
nValorLiq	:= 0
nNroParc	:= 0

If SuperGetMv("MV_CMC7FIN") == "S" .And. !lOpcAuto
	// Abre porta para CMC7
	If lOpenCmc7 == Nil
		OpenCMC7()
		lOpenCmc7 := .T.
	Endif	
	If ExistBlock("A460PARC")
		ExecBlock("A460PARC", .F., .F. )
	Else
		F460CMC7()
	Endif
Endif
If !lOpcAuto
	oGet:ForceRefresh()
EndIf
A460Valor(.F.)
If lFA460Con
	lRet:= ExecBlock("FA460con", .F., .F.,{aCols,aHeader})
Endif
Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?FA460CAN   ?Autor ?Mauricio Pequim Jr.	 ?Data ?02/02/98  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Cancelamento de Liquida噭o                 					潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?FA280CAN()													潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 													潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function FA460CAN(cAlias,cCampo,nOpcx,aCamposSE1,lAutoGem)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Define Variaveis 														  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

Local lPanelFin 	:= IsPanelFin()
Local cArquivo		:= ""
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local nOpcT			:= 0
Local nTitulos		:= 0
Local nParcelas		:= 0
Local cIndex		:= ""
Local cNewLiq       := ""
Local cTitulo 		:= STR0062  //"Cancel. Liquida噭o"
Local cDadosSE1		:= ""
Local cDadosSe5		:= ""
Local lHeadProva 	:= .F.
Local lPadraoE1		:= VerPadrao("505")  // Exclusao de conta a receber
Local cPadrao    	:= ""
Local lContabilizou := .F.
Local lDigita 		:= .T.
Local lAglutina		:= .T.
Local lCtBaixa		:= .F.
Local lFin460e1 	:= ExistBlock("FIN460E1")
Local lAcreDecre 	:= .F.
Local nAcresc 		:= 0
Local nDecresc	 	:= 0   
Local oDlg4         := nil                     
Local nGemMulta		:= 0
Local lRastro		:= FVerRstFin()
Local aAlt   		:= {}
Local cChaveTit		:= ""
Local cChaveFK7		:= ""
Local lClcMultLj	:= ( SuperGetMv("MV_JURTIPO",,"") == "L" ) .Or. ( SuperGetMv("MV_LJINTFS", ,.F.) )
Local nSe1Multa		:= 0
Local aBaixas		:= {}

//Tratamento para o template GEM - exclusao de renegociacao
Local lOpcAuto2 	:= IIf (Type("lOpcAuto") == "U",.F.,lOpcAuto)  

Local aFlagCTB		:= {}
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

//639.04 Base Impostos diferenciada
Local _aTit			:= {}
Local lContinua		:= .T.
Local nRecSE1		:= 0
Local lAtuSldNat	:= .T.   

//Controle de abatimento
Local lTitpaiSE1	:= .T.
Local nOrdTitPai	:= 0
Local bWhile 		:= {||  !Eof() .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)}

//Gestao
Local cFilialAtu	:= ""
Local nMoedaCus		:= 0
Local aDadosSE5		:= {}

//Resstruturacao SE5
Local aAreaAnt		:= {}
Local oModelEst		:= nil 
Local cLog			:= ""
Local aValOrig		:= {}

Local dBXAnterior := CToD('')

Local aTitPai := {}
Local nI			:= 0
Local lExistFJU := Findstatic function("FinGrvEx")

// Variavel lAutoGem -> referente ?rotina de exclusao de uma renegociacao do template GEM
DEFAULT lAutoGem	:= .F.

Private cLiqCan 	:= CriaVar("E1_NUM" , .F.) 
Private aDiario		:= {}
Private cCodDiario	:= ""  
Private lMsErroAuto := IIf (Type("lMsErroAuto") == "U",.F.,lMsErroAuto)
	
// Zerar variaveis para contabilizar os impostos da lei 10925.
VALOR5 := 0
VALOR6 := 0
VALOR7 := 0                   

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se data do movimento n刼 ?menor que data limite de ?
//?movimentacao no financeiro    										  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !DtMovFin(,,"2")
	If lPanelFin  //Chamado pelo Painel Financeiro						
		dbSelectarea(FinWindow:cAliasFile)
		FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)	
	Endif
	Return
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica o numero do Lote 											  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DbSelectArea("SX5")
MsSeek(cFilial+"09FIN")

Private cLote := Substr(X5_DESCRI,1,4)

If lOpcAuto2
	cLiqCan:=cNumLiqCan
Else
	If Empty(SE1->E1_NUMLIQ)
		cLiqCan := GetMV("MV_NUMLIQ")
	Else
		cLiqCan := SE1->E1_NUMLIQ
	EndIf
EndIf

nValor		:= 0
nValRec		:= 0
nTitulos	:= 0
nParcelas	:= 0
nOpcT		:= 0

//verifica se existem os capos de valores de acrescimo e decrescimo no SE5
lAcreDecre := .T.

If !lAutoGem
	If !lOpcAuto2
		If lPanelFin  //Chamado pelo Painel Financeiro			
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg4 OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//?Observacao Importante quanto as coordenadas calculadas abaixo: ?
			//?-------------------------------------------------------------- ?		
			//?a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ?
			//?painel, sendo assim este deve ser dividido por 2 antes da sub- ?
			//?tracao e redivisao por 2 para a centralizacao. 					 ?	
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁		
			nEspLarg := (((DlgWidthPanel(oPanelDados)/2) - 114) /2)-4
			nEspLin  := 0				
			
		Else   
		  	nEspLarg := 0 
		  	nEspLin  := 3  
			DEFINE MSDIALOG oDlg4 FROM	20,1 TO 160,340 TITLE cTitulo PIXEL
		Endif       
	EndIf 
Else
	cLiqCan	 := SE1->E1_NUMLIQ 
	nOpct	 := 1  
 	nEspLarg := 0 
  	nEspLin  := 3  
EndIf     

If !lOpcAuto2
	oPanel := TPanel():New(0,0,'',oDlg4,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT   
		
	@ 006+nEspLin, 011+nEspLarg TO 036+nEspLin, 125+nEspLarg OF oPanel PIXEL                                                                            
	
	@ 011+nEspLin, 014+nEspLarg SAY STR0058 SIZE 49, 07 OF oPanel PIXEL //"Nro. Liquida噭o"
	@ 021+nEspLin, 014+nEspLarg MSGET cLiqCan Valid !Empty(cLiqCan) 	SIZE 49, 11 OF oPanel PIXEL hasbutton
	
	If !lAutoGem
		If lPanelFin  //Chamado pelo Painel Financeiro			
			// define dimen玢o da dialog
			oDlg4:nWidth := aDim[4]-aDim[2]

			ACTIVATE MSDIALOG oDlg4 ON INIT ( FaMyBar(oDlg4,;
			{||nOpct:=1,If(A460Yesno(2),oDlg4:End(),nOpct:=0)},;
			{||oDlg4:End()}),oDlg4:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1]))
		Else
			DEFINE SBUTTON FROM 10, 133 TYPE 1 ACTION (nOpct:=1,If(A460Yesno(2) .AND. Fa460OK2(),oDlg4:End(),nOpct:=0)) ENABLE OF oPanel
			DEFINE SBUTTON FROM 23, 133 TYPE 2 ACTION oDlg4:End() ENABLE OF oPanel
			ACTIVATE MSDIALOG oDlg4 CENTERED
		Endif
	EndIf		   
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Salva a Area atual do SE1                                 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
DbSelectArea("SE1")
nOrdemSe1 	:= IndexOrd()
nRegSE1 	:= Recno()
nRecSe5	:= SE5->(Recno())

// Inicia controle de transacao
Begin Transaction

If Existblock("F460CANC")
	nOpct := Execblock("F460CANC" ,.F.,.F.,{nOpct})
Endif

If nOpct == 1 .Or. lOpcAuto2

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ?
	//?                                                                 ?
	//?A fun噭o SomaAbat reabre o SE1 com outro nome pela ChkFile para  ?
	//?efeito de performance. Se o alias auxiliar para a SumAbat() n刼  ?
	//?estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ?
	//?pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	SomaAbat("","","","R")

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//?Seleciona os registros a serem processados no cancelamento?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	If A460Filtra(cLiqCan)
		dbSelectArea("TRB")
		DbGoTop()		
		DbSelectArea("SE1")
		DbGoTop()
		While TRB->(!Eof())
    
			cFilialAtu := cFilAnt
       		SE1->(dbGoto(TRB->CHAVE))
			
			DbSelectArea("SE1")

			cFilOrig  := SE1->E1_FILORIG
			cDadosSe1 := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+ SE1->E1_TIPO
			cDadosSe5 := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+ SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA

			If __lDefTop
				aDadosSE5 := {SE1->E1_FILORIG,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA}
			Endif
			aAreaAnt := GetArea()
			//Movimento dos titulos geradores de liquidacao
	 		If  (lAutoGem .AND. (SE1->E1_NUMLIQ<>cLiqCan)) .OR. ((Empty(SE1->E1_NUMLIQ) .And.;
				 !(SE1->E1_TIPO $ MV_CRNEG)) .or. ;
				  SE1->E1_STATUS == "R" )
				  
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//?Se for um titulo que gerou a liquidacao, desfaz o processo?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				nTotAbat := 0
				nJuros	:= 0
				nDescont := 0
				nGemMulta:=0

				//Gestao
				cFilAnt := cFilOrig
				
				dbSelectArea("SE1")
				nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA,,,SE1->E1_TIPO)

				//Gestao
				cFilAnt := cFilialAtu 

				dbSelectArea("SE5")
				SE5->(dbSetOrder(7))
             
				If SE5->( MsSeek(xFilial("SE5")+cDadosSE5)) 
                
	                // 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪
	                // Ponto de entrada para tratamento do titulo gerado pela  
					// liquidacao antes do cancelamento.                       
	   				// 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪
					IF ExistBlock("F460E5")
	      				ExecBlock("F460E5", .F., .F.,{cDadosSE5})
					Endif   

					While !Eof() .and. xFilial("SE5") == SE5->E5_FILIAL .and. ;
						SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cDadosSE5

						If SE5->E5_SITUACA == "C" .or. cLiqCan != Alltrim(E5_DOCUMEN) .or. ;
							SE5->E5_MOTBX != "LIQ" .or. !(SE5->E5_TIPODOC $ "DC#JR#BA#MT#CM")

							If SE5->E5_TIPODOC == 'VL' .and. E5_SITUACA <> 'C'
								dBXAnterior := SE5->E5_DATA
							EndIf

							dbSKip()
							Loop
						EndIf
						aBaixas := {}

						// Verifica movimentacao de AVP
						FAVPValTit( "SE1", SE5->( RecNo() ) )

						If SE5->E5_TIPODOC == "DC"
							nDescont := SE5->E5_VALOR
							RecLock("SE5")
								Replace E5_SITUACA with "C"
							SE5->(MSUNLOCK())
						ElseIf  SE5->E5_TIPODOC == "JR"
							nJuros 	:= SE5->E5_VALOR
							RecLock("SE5")
								Replace E5_SITUACA with "C"
							SE5->(MSUNLOCK())
						ElseIf  SE5->E5_TIPODOC == "MT"
							nGemMulta:= SE5->E5_VALOR
							RecLock("SE5")
								Replace E5_SITUACA with "C"
							SE5->(MSUNLOCK())
						Elseif SE5->E5_TIPODOC == "BA"
									
							nValRec  := SE5->E5_VALOR
							nValorM2 := SE5->E5_VLMOED2
							nRecSE5  := SE5->( recno() )
							lCtBaixa := If("S"$SE5->E5_LA,.T.,lCtBaixa)
							If lAcreDecre
								nAcresc := SE5->E5_VLACRES
								nDecresc := SE5->E5_VLDECRE
							Endif
							
							
							oModelEst := FWLoadModel("FINM010") //Recarrega o Model de baixa para pegar o campo do relacionamento (SE5->E5_IDORIG)
							oModelEst:SetOperation( 4 ) //Altera玢o
							oModelEst:Activate()
							oModelEst:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita grava玢o SE5
							//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK2
							//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK2
							//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK2
							oModelEst:SetValue( "MASTER", "E5_OPERACAO", 1 )
							oModelEst:SetValue( "MASTER", "HISTMOV"    , STR0062) 
							
							//Posiciona a FKA com base no IDORIG da SE5 posicionada
		             		oFKA := oModelEst:GetModel( "FKADETAIL" )
							oFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )			

							
							
							If oModelEst:VldData()
								oModelEst:CommitData()
								
							Else
								cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
								cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
								cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
					        
								Help(,,"M010VALID",,cLog,1,0)
									
							EndIf
							oModelEst:DeActivate()
							oModelEst:Destroy()
							oModelEst:= nil
						EndIf
					
						If lTpComis  .and. lComiLiq 
							If !MV_CRNEG $ SE1->E1_TIPO .And. !MV_CPNEG $ SE1->E1_TIPO
								aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})
								Fa440DeleB(aBaixas,.F.,.F.,"FINA460")			   			
							Endif				
						Endif	
					
						If UsaSeqCor() 
							AADD(aDiario,{"SE5",SE5->(recno()),cCodDiario,"E5_NODIA","E5_DIACTB"}) 
			   			EndIf
						dbSkip()
					End
				Endif

				SE5->( dbGoTo( nRecSE5 ) )

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//砎erifica se foi utilizada taxa contratada para moeda > 1          ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If SE1->E1_MOEDA > 1 .and. Round(NoRound(xMoeda(nValRec,1,SE1->E1_MOEDA,SE5->E5_DATA,3),3),2) != SE5->E5_VLMOED2
					nTxMoeda := SE5->E5_VALOR / SE5->E5_VLMOED2
				Else
					nTxMoeda := RecMoeda(SE5->E5_DATA,SE1->E1_MOEDA)
				Endif

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//矯aso moeda == 1 a funcao RecMoeda iguala nTxMoeda = 0. Iguala-se   ?
				//硁TxMoeda = 1 p/ evitar problema c/ calculos de abatimento e outros.?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				nTxMoeda := IIF(nTxMoeda == 0 , 1 , nTxMoeda)
				DbSelectArea("SE1")
				DbSetOrder(1)
				If MsSeek(xFilial("SE1",cFilOrig)+cDadosSE1)
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//矴era backup dos valores da baixa (para cancelamento baixa parcial)?
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					nSe1ValLiq  := SE1->E1_VALLIQ
					nSe1Descont := SE1->E1_DESCONT
					nSe1Juros   := SE1->E1_JUROS
					nSe1Multa   := SE1->E1_MULTA
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//矴rava novos valores do cancelamento da baixa parcial              ?
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					RecLock("SE1")
					SE1->E1_VALLIQ  := nValRec
					SE1->E1_DESCONT := nDescont
					SE1->E1_JUROS   := nJuros
					SE1->E1_MULTA   := nGemMulta
					MsUnlock()
				Endif
				//adiciona no array os titulos pai
				If lExistFJU
					aAdd(aTitPai,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->(Recno())})
				EndIf

				DbSetOrder(1)

				If SE1->E1_MOEDA > 1				
		            nTotAbat := nTotAbat * NoRound(nTxMoeda,5)
				Endif
	   		
				ABATIMENTO 		 := nTotAbat

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矴era lan嘺mento contabil de estorno                               ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				cPadrao:="527"    //cancelamento de baixa
				lPadrao:=VerPadrao(cPadrao)
				DbSelectArea("SA1")
				DbSetOrder(1)
				MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				DbSelectArea("SE1")
				If !lHeadProva .and. lPadrao
					nHdlPrv := HeadProva( cLote,;
					                      "FINA460",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					lHeadProva := .T.
				EndIf
				If lPadrao .and. lCtBaixa
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA460",;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
					If UsaSeqCor()
						AADD(aDiario,{"SE1",SE1->(recno()),cCodDiario,"E1_NODIA","E1_DIACTB"}) 
					Endif 
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//矴rava valores anteriores da contabilizacao do canc da baixa parcial?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				RecLock("SE1")
				SE1->E1_VALLIQ  := nSE1ValLiq
				SE1->E1_DESCONT := nSe1Descont
				//Retorna os valores de juros e multa quando calculados pelo loja
				If lClcMultLj .And. nSe1Juros >= nJuros 
					SE1->E1_JUROS -= nJuros
				Else
					SE1->E1_JUROS := nJuros
				EndIf
				If lClcMultLj .And. nSe1Multa >= nGemMulta
					SE1->E1_MULTA -= nGemMulta
				Else
					SE1->E1_MULTA := nGemMulta
				EndIf
				MsUnlock()
				DbSetOrder(1)

				nSalvRec := Recno()
				                                                                                                                     
				If lAtuSldNat
					AtuSldNat(SE1->E1_NATUREZ, SE1->E1_VENCREA, SE1->E1_MOEDA, "2", "R", SE1->E1_VALOR,SE1->E1_VLCRUZ, "+",,FunName(),"SE1", SE1->(Recno()),0)
				Endif
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//砎erifica se h?abatimentos para voltar a carteira                 ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If nTotAbat > 0 .and. SE1->E1_SALDO == 0 
					SE1->(DbSetOrder(2))
					If MsSeek(xFilial("SE1",cFilOrig)+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
						cTitAnt := (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)     
				  		If lTitpaiSE1    
					 		If (nOrdTitPai:= OrdTitpai()) > 0
								SE1->(DbSetOrder(nOrdTitPai))
								If	DbSeek(xFilial("SE1",cFilOrig)+cDadosSe5)    
	  								bWhile  := {|| !Eof() .And. Alltrim(SE1->E1_TITPAI) == Alltrim(cDadosSe5)}  
	  							Else
	  								SE1->(DbSetOrder(2))
	 	   				  		Endif
	  						Endif
  						Endif

						While Eval(bWhile) 
							If !(SE1->E1_TIPO $ MVABATIM)
								dbSkip()
								Loop
							Endif
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//砎olta tulo para carteira                                       ?
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							Reclock("SE1", .F.)
							SE1->E1_BAIXA   := Ctod(" /  /  ")
							SE1->E1_SALDO	 := SE1->E1_VALOR
							SE1->E1_DESCONT := 0
							SE1->E1_JUROS   := 0
							SE1->E1_MULTA   := 0
							SE1->E1_CORREC  := 0
							SE1->E1_VARURV  := 0
							SE1->E1_VALLIQ  := 0
							SE1->E1_LOTE    := Space(Len(E1_LOTE))
							SE1->E1_DATABOR := Ctod(" /  /  ")
							SE1->E1_STATUS  := "A"
							msUnLock()
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//?Carrega variaveis para contabilizacao dos    ?
							//?abatimentos (impostos da lei 10925).         ?		
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If SE1->E1_TIPO == MVPIABT
								VALOR5 := SE1->E1_VALOR			
							ElseIf SE1->E1_TIPO == MVCFABT
								VALOR6 := SE1->E1_VALOR
							ElseIf SE1->E1_TIPO == MVCSABT
								VALOR7 := SE1->E1_VALOR						
							Endif			
							If lAtuSldNat
								AtuSldNat(SE1->E1_NATUREZ, SE1->E1_VENCREA, SE1->E1_MOEDA, "2", "R", SE1->E1_VALOR,SE1->E1_VLCRUZ, "-",,FunName(),"SE1", SE1->(Recno()),0)
							Endif
							dbSkip()
						End
					Endif
					SE1->(DbSetOrder(1))
				Endif
				dbGoTo( nSalvRec )

				If lAutoGem .and. HasTemplate("LOT")
					nValor := SE1->E1_SALDO+(nValRec-nJuros+nDescont-nGemMulta+IIF(SE1->E1_SALDO==0,nTotAbat,0))
				Else
					IF SE1->E1_MOEDA == 1
						nValor := SE1->E1_SALDO+(nValRec-nJuros+nDescont+IIF(SE1->E1_SALDO==0,nTotAbat,0))
					Else
						nValor := SE1->E1_SALDO+((nValRec-nJuros+nDescont+IIF(SE1->E1_SALDO==0,nTotAbat,0)) / NoRound(nTxMoeda,5))
						//Corrige possiveis erros de arredondamento
						If ABS(Round(SE1->E1_VALOR - nValor,2)) == 0.01         
							nValor := SE1->E1_VALOR
						Endif
					Endif   
				EndIf

				RecLock("SE1",.F.)
				SE1->E1_SALDO			:= nValor
				SE1->E1_BAIXA			:= dBXAnterior		// Restaura a data da baixa anteior, se houver.  				
				SE1->E1_SALDO		:= nValor
				SE1->E1_MOVIMEN		:= dDataBase
				SE1->E1_TIPOLIQ		:= Space(3)
				
				If lAcreDecre
					SE1->E1_SDACRES	:= Round(NoRound(xMoeda(nAcresc,1,SE1->E1_MOEDA,SE5->E5_DATA,3,nTxMoeda),3),2)
					SE1->E1_SDDECRE	:= Round(NoRound(xMoeda(nDecresc,1,SE1->E1_MOEDA,SE5->E5_DATA,3,nTxMoeda),3),2)
				Else
					SE1->E1_SDACRES	:= SE1->E1_ACRESC 
					SE1->E1_SDDECRE	:= SE1->E1_DECRESC		
				Endif
				
				SE1->E1_STATUS	  := "A"

				//639.04 Base Impostos diferenciada
				//O caso abaixo ocorrer?quando
				//Controlo base de impostos
				//Calculo do PCC - CR na emissao
				//Titulo Gerador da liquidacao eh retentor
				//Natureza da liquidacao calcula PCC
				If STR(SE1->E1_SALDO,17,2) > STR(SE1->E1_VALOR,17,2)
					SE1->E1_SALDO := SE1->E1_VALOR
				Endif

				IF STR(SE1->E1_SALDO,17,2) == STR(SE1->E1_VALOR,17,2)
					SE1->E1_VALLIQ	:= 0				
					SE1->E1_BAIXA	  := Ctod("//")
				Endif
				MsUnlock()

				///numbor			
				aAlt := {}
				aadd( aAlt,{ STR0206,'','','',STR0207 +  Alltrim(Transform(SE1->E1_VALOR,PesqPict("SE1","E1_VALOR"))) })   
				///chamada da Fun玢o que cria o Hist髍ico de Cobran鏰
				FinaCONC(aAlt)							
				
								/*
				Atualiza o status do titulo no SERASA */
				If cPaisLoc == "BRA"
					cChaveTit := xFilial("SE1") + "|" +;
								SE1->E1_PREFIXO + "|" +;
								SE1->E1_NUM		+ "|" +;
								SE1->E1_PARCELA + "|" +;
								SE1->E1_TIPO	+ "|" +;
								SE1->E1_CLIENTE + "|" +;
								SE1->E1_LOJA
					cChaveFK7 := FINGRVFK7("SE1",cChaveTit)
					F770BxRen("3","",cChaveFK7)
			
				Endif				
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//|Fun玢o Espec韋ica do Modulo Sigapls para atualizar Status de Guias Compradas |
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?			
				PL090TITCP(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,"5")
							
				// Cancelamento do rastreamento(FI7/FI8)
				If lRastro
					FINRSTDEL("SE1",cDadosSe5,aDadosSE5)
				Endif

				dbSelectArea("SA1")
				dbSetOrder(1)
				If MsSeek(xFilial("SA1",cFilOrig)+SE1->E1_CLIENTE+SE1->E1_LOJA)
					If !(SE1->E1_TIPO $ MV_CRNEG+"/"+MVRECANT)
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
						//?Posiciona no registro do cliente e Estorna Atraso Medio.    ?
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
						dbSelectArea("SA1")
						dbSetOrder(1)
						RecLock("SA1",.F.)
						SA1->A1_NROPAG := SA1->A1_NROPAG-1  //Numero de Duplicatas
						If ( SE1->E1_BAIXA - SE1->E1_VENCREA) > 0
							SA1->A1_PAGATR := IiF(SA1->A1_PAGATR ==0,0,SA1->A1_PAGATR-SE1->E1_VALLIQ)   // Pagamentos Atrasados
							SA1->A1_ATR    := SA1->A1_ATR + SE1->E1_VALLIQ
							SA1->A1_METR   :=  (SA1->A1_METR * (SA1->A1_NROPAG+1) - (SE1->E1_BAIXA - SE1->E1_VENCREA)) / SA1->A1_NROPAG
						EndIF
						AtuSalDup("+",SE1->E1_VALOR,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
					Endif
				Endif
            
			//Titulos Gerados pela Liquidacao
			ElseIf (SE1->E1_NUMLIQ = cLiqCan 	.or. ;
					SE1->E1_TIPO $ MV_CRNEG)	.and.;
					SE1->E1_STATUS != "R"
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//?Se for uma parcela da liquidacao contabiliza o    ?
				//?cancelamento e deleta.                            ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				cPadrao := "505"
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//?Posiciona o SE1 pois o arquivo de trabalgo pode ser resul-?
				//?tado de uma Query.                                        ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				DbSelectArea("SE1")
				DbSetOrder(1)
				MsSeek(xFilial("SE1")+cDadosSE1)

				lContabilizou := Iif(SubStr(SE1->E1_LA,1,1)=="S",.T.,.F.)
				IF !(SE1->E1_TIPO $ MV_CRNEG)
					DbSelectArea("SA1")
					DbSetOrder(1)
					If MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
						AtuSalDup("-",SE1->E1_VALOR,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
					Endif
					DbSelectArea("SE1")
				Endif
				If !lHeadProva .and. lPadraoE1
					nHdlPrv := HeadProva( cLote,;
					                      "FINA460",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					lHeadProva := .T.
				EndIf
				If lPadraoE1 .and. lContabilizou
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA460",;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )

				EndIf

				If lFin460e1
					Execblock("FIN460E1",.F.,.F.)
				Endif
            
				DbSelectArea("SE1")
				Fa460ExcSef(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO)
				
				nRecSE1 := SE1->(Recno())
				If lExistFJU
					For ni := 1 to Len(aTitPai)
						FinGrvEx("R",aTitPai[nI][1], aTitPai[nI][2],aTitPai[nI][3],aTitPai[nI][4],aTitPai[nI][5],aTitPai[nI][6],aTitPai[nI][7],aTitPai[nI][8])	
					Next ni
				Endif	

				SE1->(dbGoto(nRecSE1))
				SE1->(DbSetOrder(1))
				_aTit := {}
				AADD(_aTit , {"E1_PREFIXO"	,SE1->E1_PREFIXO	,NIL})
				AADD(_aTit , {"E1_NUM"		,SE1->E1_NUM		,NIL})
				AADD(_aTit , {"E1_PARCELA"	,SE1->E1_PARCELA	,NIL})
				AADD(_aTit , {"E1_TIPO"  	,SE1->E1_TIPO		,NIL})
				AADD(_aTit , {"E1_CLIENTE"	,SE1->E1_CLIENTE	,NIL})
				AADD(_aTit , {"E1_LOJA"  	,SE1->E1_LOJA		,NIL})

				MSExecAuto({|x, y| FINA040(x, y)}, _aTit, 5)

				//Em caso de falha na exclusao dos titulos o processo ser?parado.
				If lMsErroAuto
					MOSTRAERRO()
					DisarmTransaction()
					lContinua := .F.
					Exit
				EndiF

			EndIf

     		TRB->(dbSkip())

		Enddo

		//Caso a exclusao tenha ocorrido sem problemas
		If lContinua	
			If nTotal > 0
				RodaProva(  nHdlPrv,;
							nTotal)
	
				lDigita		:= IIf( mv_par02 == 1, .T., .F. )
				lAglutina	:= IIf( mv_par03 == 1, .T., .F. )
	
				cA100Incl( cArquivo,;
				           nHdlPrv,;
				           3,;
				           cLote,;
				           lDigita,;
				           lAglutina,;
				           /*cOnLine*/,;
				           /*dData*/,;
				           /*dReproc*/,;
				           @aFlagCTB,;
				           /*aDadosProva*/,;
				           aDiario )
				aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
			EndIf
	
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			//?Volta Ultimo Numero do Parametro de Liquidacao          ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			cNewLiq := GetMV("MV_NUMLIQ")
			If Type("cNewLiq") != "C"
				cNewLiq := Space(TamSx3("E1_NUMLIQ")[1])
			Endif
			If cNewLiq == cLiqCan
				PutMv("MV_NUMLIQ",Tira1(SUBSTR(cNewLiq,1,6)))
			EndIf
		EndIf
	EndIf
	__cNroLiqui := cLiqCan
	//Integra玢o via Mensagem 趎ica
	If cPaisLoc == "BRA"
		If SE1->E1_IDLAN > 0 .AND. FWHasEAI('FINA460',.T.,,.T.)
			aValOrig := F460ChgVar() //Altera as vari醰eis INCLUI, ALTERA
			FwIntegDef( 'FINA460', , , , 'FINA460' )
			F460RetVar(aValOrig)
		EndIf
	EndIf
			
EndIf

// Finaliza controle de transacao
End Transaction

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Restaura a area do SE1                                    ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

If Select("SE1") > 0
	DbSelectArea("SE1")
	DbCloseArea()
Endif

DbSelectArea("SE1")
RetIndex("SE1")
Set Filter to

DbSelectArea("SE1")
DbSetOrder(nOrdemSE1)
DbGoToP()
fErase (cIndex+OrdBagExt())
cIndex := ""

If lPanelFin  //Chamado pelo Painel Financeiro						
	dbSelectarea(FinWindow:cAliasFile)
	FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)	
Endif

Return (.T.)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460FCan   ?Autor ?Mauricio Pequim Jr    ?Data ?02/02/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Sele噭o para a cria噭o do indice condicional no CANCELAMENTO 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460														潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460FCan()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Devera selecionar todos os registros que atendam a seguinte condi噭o : 	?
//媚哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?2. Ou titulos que tenham originado a liquidacao selecionada 						?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
Local cFiltro
cFiltro := 'E1_FILIAL = "'+xFilial("SE1")+'"  .And. '
cFiltro += 'E1_NUMLIQ = "'+cLiqCan+'" '

Return cFiltro

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460Filtra ?Autor ?Jeremias Luna         ?Data ?12.05.00 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Calcula Parcelas, Nro.Titulos e valor da Liquida. a cancelar 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460													    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460Filtra(cLiqCan)

Local lRetOk := .T.
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Variaveis para a funcao da barra de status do processamento     ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
A460CalCan(cLiqCan, @lRetOK)

Return(lRetOk)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460CalCan ?Autor ?Mauricio Pequim Jr    ?Data ?02/02/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Calcula Parcelas, Nro.Titulos e valor da Liquida. a cancelar 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460													    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460CalCan(cLiqCan,lRetOk)

Local cQuery	:= ""
Local nTamLiq	:= TamSx3("E5_DOCUMEN")[1]
Local aCampos	:= {}
Local cChave	:= ""  
Local lFilOrig	:= .F.
Local cLstCart := FN022LSTCB(1)	//Lista das situacoes de cobranca (Carteira)

DEFAULT lRetOk := .T.

//Gestao
If __lDefTop == NIL
	__lDefTop 	:= IfDefTopCTB() .and. !lUsaGE .and. !lOpcAuto // verificar se pode executar query (TOPCONN)
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Cria indice condicional separando os titulos que deram origem a ?
//?liquidacao e os titulos que foram gerados					        ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
dbSelectArea("SE1")
DbSetOrder(1)
cIndex := CriaTrab(nil,.f.)
cChave := "E1_FILIAL+E1_NUMLIQ"

If __lDefTop

	//Gestao
	lFilOrig := .F.
	cQuery := "SELECT E5_FILORIG "
	cQuery += "FROM "+RetSqlName("SE5")+" WHERE"
	cQuery += " E5_FILIAL = '"  + xFilial("SE5")        + "' AND"
	cQuery += " E5_DOCUMEN = '" + PADR(cLiqCan,nTamLiq) + "' AND"	
	cQuery += " E5_RECPAG = 'R' AND"
	cQuery += " E5_SITUACA <> 'C' AND" 
	cQuery += " E5_TIPODOC = 'BA' AND"		
	cQuery += " E5_MOTBX = 'LIQ' AND" 
	cQuery += " D_E_L_E_T_ = ' '"	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	DbSelectArea("TRB")
	If !(Bof()) .and. !(Eof())
		lFilOrig := !(Empty(TRB->E5_FILORIG))
		DbSelectArea("TRB")
		DbCloseArea()
		cQuery := "SELECT SE1.R_E_C_N_O_ CHAVE "
		cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
		cQuery +=         RetSqlName("SE5")+" SE5 WHERE"
		cQuery += " E5_FILIAL = '" + xFilial("SE5") + "' AND"
		If lFilOrig
			cQuery += " E1_FILORIG = E5_FILORIG AND"
		Else
			cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND"		
   		Endif
		cQuery += " E5_PREFIXO = E1_PREFIXO AND"
		cQuery += " E5_NUMERO  = E1_NUM AND"
		cQuery += " E5_PARCELA = E1_PARCELA AND"
		cQuery += " E5_TIPO    = E1_TIPO AND"
		cQuery += " E5_CLIFOR  = E1_CLIENTE AND"
		cQuery += " E5_LOJA    = E1_LOJA AND"
		cQuery += " E5_RECPAG  = 'R' AND"
		cQuery += " E5_SITUACA <>'C' AND"
		cQuery += " E5_TIPODOC = 'BA' AND"	
		cQuery += " E5_DOCUMEN = '" + PADR(cLiqCan,nTamLiq) + "' AND"
		cQuery += " E5_MOTBX = 'LIQ' AND"
		cQuery += " SE1.D_E_L_E_T_ = ' ' AND"
		cQuery += " SE5.D_E_L_E_T_ = ' ' "
		cQuery += " UNION ALL "
		cQuery += " SELECT SE1.R_E_C_N_O_ CHAVE FROM " +RetSqlName("SE1")+" SE1 WHERE"
		cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND "
		cQuery += " E1_NUMLIQ = '" + cLiqCan + "' AND "
		cQuery += " SE1.D_E_L_E_T_ = ' '"		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
		DbSelectArea("TRB")
	Endif

Else
	AADD(aCampos, {"CHAVE","N",15,0})
	
	If __oFINA4601 <> Nil
		__oFINA4601:Delete()
		__oFINA4601	:= Nil
	Endif	

	//Cria o Objeto do FwTemporaryTable
	__oFINA4601 := FwTemporaryTable():New("TRB")

	//Cria a estrutura do alias temporario
	__oFINA4601:SetFields(aCampos)

	//Adiciona o indicie na tabela temporaria
	__oFINA4601:AddIndex("1",{"CHAVE"})
	
	//Criando a Tabela Temporaria
	__oFINA4601:Create()

	cIndex := CriaTrab(nil,.f.)
	IndRegua("TRB",cIndex,"CHAVE",,,STR0019)  //"Selecionando Registros..."

	If Select("SE1") == 0
		ChkFile("SE1",.F.,"SE1")
	Else
		dbSelectArea("SE1")
	Endif
	
	DbSetOrder(1)
	cIndex := CriaTrab(Nil,.F.)
	IndRegua("SE1",cIndex,cChave,,,STR0019)  //"Selecionando Registros..."
	//Acho os titulos da liquidacao no SE1 (Gerados/Cheques)
	nIndex := RetIndex("SE1","SE1")
	                         
	#IFNDEF TOP
		DbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	
	DbSetOrder(nIndex+1)
	If MsSeek(xFilial("SE1")+cLiqCan)
		While xFilial("SE1")+cLiqCan == SE1->(E1_FILIAL+E1_NUMLIQ)
			RecLock("TRB",.T.)
			Replace CHAVE with SE1->(RECNO())
			MsUnlock()
			dbSelectArea("SE1")
			dbSkip()
		End
	Endif
	//Acho os titulos da liquidacao (Geradores)
	dbSelectArea("SE5")
	dbSetOrder(10) //Filial+Documen
	If MsSeek(xFilial("SE5")+cLiqCan)
		While xFilial("SE5")+cLiqCan == SE5->E5_FILIAL+Substr(SE5->E5_DOCUMEN,1,6)
			If SE5->E5_MOTBX == "LIQ" .and. SE5->E5_SITUACA != "C" .and. SE5->E5_TIPODOC == "BA"
				dbSelectArea("SE1")
				(dbSetOrder(1))
				If MsSeek(xFilial("SE1")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
					RecLock("TRB",.T.)
					Replace CHAVE with SE1->(RECNO())
					MsUnlock()
				Endif
			Endif
			dbSelectArea("SE5")
			dbSkip()
		Enddo
	Endif
	dbSelectArea("TRB")	
	DbGoTop()
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Certifica se foram encontrados registros na condi噭o selecionada		?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
If Bof() .and. Eof()
	Help(" ",1,"RECNO")
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//?Restaura os indices do SE1 e deleta o arquivo de trabalho			?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	If Select("SE1") > 0
		DbSelectArea("SE1")
		DbCloseArea()
	Endif

	DbSelectArea("SE1")
	RetIndex("SE1")
	DBClearFilter()
	fErase(cIndex+OrdBagExt())
	cIndex := ""
	DbSetOrder(1)
	DbGoTop()
	lRetOk:= .F.
EndIf

If lRetOk

	While TRB->(!Eof())
		dbSelectArea("TRB")
     	SE1->(dbGoto(TRB->CHAVE))
     	TRB->(dbSkip())
		DbSelectArea("SE1")
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//?Caso tenha ocorrido a baixa de alguma parcela da liquida噭o , nao  ?
		//?sera possivel a opera噭o de cancelamento.						   ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If SE1->E1_NUMLIQ == cLiqCan .And. ;
				STR(SE1->E1_SALDO,17,2) != STR(SE1->E1_VALOR,17,2)

			Help(" ",1,"LIQJABX")   // Nao aceita se ja houve baixa em liquidacao
			lRetOk := .F.
			Exit
		EndIf
		If SE1->E1_NUMLIQ == cLiqCan .and. !(SE1->E1_SITUACA $ cLstCart) .and. ;
				(!Empty(SE1->E1_BCOCHQ) .and. SE1->E1_STATUS != "R" )
			Help(" ",1,"TITINCOB")
			lRetOk := .F.
			Exit
		EndIf
	EndDo
Endif
Return lRetOk

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460natur  ?Autor ?Mauricio Pequim Jr    ?Data ?17/03/98 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Validacao da Natureza                                        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460													    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460Natur(cNatureza)
Local lRet := .T.
//294 - Natureza sintetica/Analitica
Local lNatSa     := FNatSAIsOn()

DbSelectArea("SED")
If !(MsSeek(xFilial("SED")+cNatureza)) .or. Empty (cNatureza)
	Help(" ",1,"E2_NATUREZ")
	lRet := .F.
EndIf

//294 - Natureza sintetica/Analitica
If lRet .and. lNatSA .and. !FinVldNat( .F., cNatureza, 1 )
	lRet := .F.
Endif

Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460VerNum ?Autor ?Julio Wittwer         ?Data ?03.11.99 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Consiste nero de Cheque na Liquida噭o                      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460	(A460NumChq)      								    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460VerNum(cPrefixo,cTit,cTipo)

Local cAlias 		:= Alias()
Local nOrdem		:= IndexOrd()
Local nRegistro		:= Recno()
Local lRet 			:= .T.
Local cKeyChq

cParc460 := F460Parc()
cPrefixo := Iif(cPrefixo==nil,space(03),cPrefixo)
cKeyChq :=	xFilial("SE1")+cPrefixo+cTit+cTipo

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//?Verifica se o titulo ja existe no SE1                            ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DbSelectArea("SE1")
DbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cTit+cParc460+cTipo)
	While !Eof() .and. xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM+E1_TIPO) == cKeyChq
		If SE1->(E1_BCOCHQ+E1_AGECHQ+E1_CTACHQ) == aCols[n,3]+aCols[n,4]+aCols[n,5]
			lRet := .F.
			Exit
		Endif
		dbSkip()
	End
EndIf
DbSelectArea(cAlias)
DbSetOrder(nOrdem)
DbGoTo(nRegistro)

Return(lRet)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ?A460VerPc  ?Autor ?Mauricio Pequim Jr    ?Data ?17.04.00 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Consiste nero de parcela na Liquida噭o                     潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Fina460	                  									潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function A460VerPc(nContad,lNcc,cLiquid)

Local aAmbSE1   := {SE1->(recno()),SE1->(Indexord())}
Local cOldAlias := Alias()

cParc460 := GetMV("MV_1DUP")

lNcc := IIF (lNcc == NIL, .F., lNcc)

//Verifico se existe o titulo no arquivo nao filtrado
//Este alias e aberto pela SomaAbat() sempre
DbSelectArea("__SE1")
DbSetOrder(1)
 
cOldAlias := Alias()
 
If cParc460 == "N"
	cParc460 := StrZero(1,TamSx3("E1_PARCELA")[1])
EndIf 

If lNcc
	While .T.
		If MsSeek(xFilial("SE1")+"LIQ"+cLiquid+cParc460+MV_CRNEG)
			cParc460 := Soma1(cParc460)
		Else			
			Exit				
		EndIf
	End
Else
	While .T.
		If MsSeek(xFilial("SE1")+Padr(aCols[nContad,1],TamSX3("E1_PREFIXO")[1])+Padr(aCols[nContad,6],TamSX3("E1_NUM")[1])+Padr(cParc460,TamSX3("E1_PARCELA")[1])+Padr(aCols[nContad,2],TamSX3("E1_TIPO")[1]))
			cParc460 := Soma1(cParc460)
		Else			
			Exit				
		EndIf
	End
Endif

DbSetOrder(aAmbSE1[2])
DbGoTo(aAmbSE1[1])
DbSelectArea(cOldAlias)
Return .T.

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o	 矲A460Tipo ?Autor ?Mauricio Pequim Jr    ?Data ?03/12/99 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Checa o Tipo do titulo informado 						  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?FA460Tipo() 												  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function FA460Tipo(cTipo)
Local lRetorna := .T.
Local nI := 1
Local lTipo := (cTipo == NIL)

cTipo := IIF(cTipo == NIL, M->E1_TIPO, cTipo)

DbSelectArea("SX5")
If !MsSeek(cFilial+"05"+cTipo)
	Help(" ",1,"E1_TIPO")
	lRetorna := .F.
Else
	If cTipo $ MVPAGANT+"/"+MV_CPNEG
		Help(" ",1,"E1_TIPO")
		lRetorna := .F.
	ElseIf cTipo $ MVRECANT+"/"+MVTAXA+"/"+MV_CRNEG .or. cTipo $ MVABATIM
		Help(" ",1,"TIPODOC")
		lRetorna := .F.
	EndIf
EndIf

If lRetorna .and. !lTipo
	For nI := 1 to Len(aCols)
		aCols[nI,2] := cTipo
	Next
	oGet:ForceRefresh()
Endif

Return lRetorna


/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲A460GerAr?Autor ?Mauricio Pequim Jr    ?Data ?18/12/00 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Gera arquivo de trabalho									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?FA460GerAr()												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Gerarq(aCampos,cIndexTrb)

Local TRB	 := ""	

Default cIndexTrb := ""

If ( Select ( "TRB" ) <> 0 )
	FWCLOSETEMP("TRB")	
End

TRB := FWOPENTEMP("TRB",aCampos)	

cIndex := CriaTrab(nil,.f.)
IndRegua("TRB",cIndex,"CHAVE",,,STR0019)  //"Selecionando Registros..."

Return TRB

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲A460Repl ?Autor ?Mauricio Pequim Jr    ?Data ?20/02/97 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Grava registros no arquivo temporario					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?FA460Repl() 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Repl(TRB,cAliasSE1)

Local nAbat		:= 0
Local nJuros	:= 0
Local nDescon	:= 0
Local nValBxd	:= 0
Local lF460DES	:= ExistBlock("F460DES")
Local lF460JUR	:= ExistBlock("F460JUR")
Local nMulta	:= 0
Local cMvJurTipo := SuperGetMv("MV_JURTIPO",,"")  // calculo de Multa do Loja , se JURTIPO == L
Local lMulLoj    := SuperGetMv("MV_LJINTFS", ,.F.) //Calcula multa conforme regra do loja, se integra玢o com financial estiver habilitada

//639.04 Base Impostos diferenciada
Local lBaseImp		:= F040BSIMP(2)
Local nTotAbImp		:= 0
Local cNatImpPcc	:= ""
Local lAbateIss 	:= .F.
Local aAreaSE1 		:= {}

//Gestao
Local cFilAtu 	:= cFilAnt
Local cNomeFil 	:= ""
Local cFilTit  	:= ""

DEFAULT cAliasSE1 := "SE1"

//Gestao
If __lDefTop == NIL
	__lDefTop 	:= IfDefTopCTB() .and. !lUsaGE .and. !lOpcAuto // verificar se pode executar query (TOPCONN)
Endif

dbSelectArea(cAliasSE1)

If !__lDefTop
	dbGotop()
Endif

While !(cAliasSE1)->(Eof())
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//?Posiciono no SE1 original para uso das rotinas de calculo de juros,   ?
	//?abatimento e desconto. Principalmente por conta de FA070JUROS() e     ?
	//?FA070DESCF() se utilizarem do SE1 para os calculos.                   ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	dbSelectArea("SE1")

	If __lDefTop
		SE1->(DbGoTo((cAliasSE1)->RECNO))
	Endif
	
    If cFilTit != SE1->E1_FILORIG
		cNomeFil := FWFilialName(,SE1->E1_FILORIG)
		cFilTit  := SE1->E1_FILORIG
		If __lDefTop
			cFilAnt := cFilTit
		Endif
	Endif

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//?Mexico - Manejo de Anticipo                               ?
	//?Validacao para nao selecionar os titulos das notas        ?
	//?de adiantamento e os titulos do tipo RA gerados pela      ?
	//?rotina recebimentos diversos.                             ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	If cPaisLoc == "MEX" .And.;
		X3Usado("ED_OPERADT") .And.;
		Upper(Alltrim(SE1->E1_ORIGEM)) $ "FINA087A|MATA467N" .And.;
		GetAdvFVal("SED","ED_OPERADT",xFilial("SED")+SE1->E1_NATUREZ,1,"") == "1"
	
		(cAliasSE1)->(dbSkip())
		Loop
		
	EndIf		
	
	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))
	lAbateIss := (SA1->A1_RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.)) 

	nTotAbImp 	:= 0       
	aAreaSE1	:= SE1->(GetArea())
	nAbat  	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDatabase,@nTotAbImp) 
	SE1->(RestArea(aAreaSE1))
	
	//Impostos PCC com calculo para o Cliente/Natureza
	cNatImpPcc	:= F460NatImp()	

	//639.04 Base Impostos diferenciada
	If lBaseImp .and. !Empty(cNatImpPcc)
		nAbat	 -= nTotAbImp
	Endif   

	If lF460JUR
		nJuros := ExecBlock("F460JUR",.F.,.F.)
	Else
		nJuros := FA070JUROS(SE1->E1_MOEDA,SE1->E1_SALDO)
	Endif
	If lF460DES
		nDescon := ExecBlock("F460DES",.F.,.F.)
	Else
		nDescon := FaDescFin("SE1",dDataBase,SE1->E1_VALOR,SE1->E1_MOEDA)
	Endif
	If cMvJurTipo == "L" .Or. lMulLoj
		//*谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//*?Calcula o valor da Multa  :funcao LojxRMul :fonte Lojxrec          ?
		//*滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		nMulta := LojxRMul(,,,SE1->E1_SALDO,SE1->E1_ACRESC,SE1->E1_VENCREA,dDataBase,,SE1->E1_MULTA,,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,"SE1",.T.)
	EndIf
	nValBxd := SE1->E1_VALOR - SE1->E1_SALDO

	RecLock("TRB",.T.)
	Replace FILIALX		With cNomeFil
	Replace	TITULO		With SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" + SE1->E1_PARCELA + "-" + SE1->E1_TIPO
	Replace	EMISSAO		With SE1->E1_EMISSAO
	Replace	VENCTO		With SE1->E1_VENCREA
	Replace	VALORI		With SE1->E1_VALOR
	Replace VALCVT		With Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,,3),3),2)
	Replace	VALLIQ		With Round(NoRound(xMoeda(SE1->E1_VALOR - nAbat - nValBxd - nDescon + Round(NoRound(nJuros,3),2)+ Round(NoRound(nMulta,3),2)+ SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,3,IIF(SE1->E1_TXMOEDA > 0, SE1->E1_TXMOEDA, Nil)),3),2)
	Replace	BKPVLLIQ	With Round(NoRound(xMoeda(SE1->E1_VALOR - nAbat - nValBxd - nDescon + Round(NoRound(nJuros,3),2)+ Round(NoRound(nMulta,3),2)+ SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,3,IIF(SE1->E1_TXMOEDA > 0, SE1->E1_TXMOEDA, Nil)),3),2)
	Replace	JUROS		With Round(NoRound(xMoeda(nJuros+SE1->E1_SDACRES,SE1->E1_MOEDA,nMoeda,,3),3),2)
	Replace	DESCON		With Round(NoRound(xMoeda(nDescon+SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,3),3),2)
	Replace	BKPDESC		With Round(NoRound(xMoeda(nDescon+SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,3),3),2)
	Replace	ABATIM		With nAbat
	Replace	MULTALJ 	With Round(NoRound(xMoeda(nMulta,SE1->E1_MOEDA,nMoeda,,3),3),2)
	Replace	BAIXADO		With nValBxd
	Replace	MARCA 		With " "
	Replace MOEDAO  	With SE1->E1_MOEDA
	Replace	HISTOR		With SE1->E1_HIST
	Replace	ACRESC		With SE1->E1_SDACRES
	Replace	DECRESC		With SE1->E1_SDDECRE
	Replace	CHAVE 		With SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	Replace	CHAVE2 		With SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	Replace CTMOED		With RecMoeda(dDataBase, SE1->E1_MOEDA)  
	Replace	TITPAI		With SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA

	//639.04 Base Impostos diferenciada
	If lBaseImp 

		Replace OUTRIMP	With	If (nTotAbImp > 0, SE1->(E1_IRRF+E1_INSS)+(If(lAbateIss,SE1->E1_ISS,0)), 0)			

		If SE1->(E1_PIS+E1_CSLL+E1_COFINS) > 0
			Replace BASEIMP	With If (SE1->E1_BASEPIS > 0 , 	SE1->E1_BASEPIS, SE1->E1_VALOR )
			Replace PIS		With If (nTotAbImp > 0, SE1->E1_PIS, 0)
			Replace COFINS	With If (nTotAbImp > 0, SE1->E1_COFINS, 0)
			Replace CSLL	With If (nTotAbImp > 0, SE1->E1_CSLL, 0)
		Endif
	Endif
		
	dbselectArea(cAliasSE1)
	dbSkip()
End

cFilAnt  := cFilAtu

Return


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460Bar	?Autor ?Mauricio Pequim Jr	  ?Data ?8.12.00潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Mostra a EnchoiceBar na tela - WINDOWS 					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Bar(oDlg,bOk,bCancel,oMark,oValor,oQtdTit)

Local oBar, bSet15, bSet24, lOk
Local aButtons		:= {}
Local lVolta 		:= .F.
Local lRet 			:= .T.
Local lFA460BAD:= ExistBlock("FA460BAD")

//Ponto de entraba para habilitar/desabilitar o botao de edicao
If ExistBlock("FA460BUT")
 	lRet:=Execblock("FA460BUT",.F.,.F.,)
EndIf	

If lRet
	AADD( aButtons, {"NOTE"		    , {|| Fa460Edit( oValor, oQtdTit ) }, STR0165 } )
EndIf

AADD(aButtons, {"PESQUISA"		, {|| Fa460Pesq( oMark ) }, STR0166 } )
	
If ExistBlock("FA460BAD")
   	aButtons := 	ExecBlock("FA460BAD", .F., .F.,{aButtons})
Endif
EnchoiceBar( oDlg, {|| ( lLoop := lVolta, lOk := Eval( bOk ) ) }, {|| ( lLoop := .F., Eval( bCancel ), ButtonOff( bSet15, bSet24, .T. ) ) },, aButtons,,,,, .F. )

Return nil

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460Edit ?Autor ?Mauricio Pequim Jr    ?Data ?8.12.00  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Mostra a EnchoiceBar na tela - WINDOWS 					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Edit(oValor,oQtdTit)

Local cTitulo
Local nOpca 	:= 0  
Local nLin  	:= 0
Local lFI460JUR := ExistBlock("FI460JUR")
Local lF460EDIT := ExistBlock("F460EDIT")
Local lF460VLDE := ExistBlock("F460VLDE")

SE1->(MSSeek(TRB->CHAVE))
If SE1->(MsRLock())	
	cTitulo := STR0096  //"Altera Valores"
	nOldJur:= TRB->JUROS
	nOldDes:= TRB->DESCON
	nOldVlq:= TRB->VALLIQ
	nValOri:= TRB->VALORI
	nValBxd:= TRB->BAIXADO
	If lUsaGE
		nValJur:= TRB->VLMULTA
		nMora  := TRB->VLMULTA - TRB->JUROS 
	ELSE
		nValJur:= TRB->JUROS
		nMora := 0
	EndIF
	nValDes:= TRB->DESCON
	nValLiq:= TRB->VALLIQ
	nValAbt:= TRB->ABATIM
	nMoedaTit := TRB->MOEDAO
	nValCvt:= TRB->VALCVT
	nCotMoed := TRB->CTMOED
	nOldCotMoe := TRB->CTMOED
	
	SE1->(dbSetOrder(1))
	SE1->(MsSeek(TRB->CHAVE))
	
	//Se o titulo nao estiver marcado, marco
	If TRB->MARCA != cMarca
		RecLock("TRB")
		TRB->MARCA := cMarca
		MsUnlock()
		nValor += nValLiq
		nQtdTit++
	Endif
	
	DEFINE MSDIALOG oDlga FROM	69,70 TO iif(lUsaGE,290,270),331 TITLE cTitulo PIXEL
	
	@ 0.5, 2 TO iif(lUsaGE,98,87), 128 OF oDlga  PIXEL
	
	@ 8, 68	MSGET nValOri Picture "@E 9999,999,999.99" When .F. SIZE 54, 08 OF oDlga PIXEL hasbutton 
	@ 8, 9 SAY STR0097  SIZE 54, 7 OF oDlga PIXEL  //"Vlr.Original"
	
	@ 19, 68	MSGET nValAbt Picture "@E 9999,999,999.99" When .F. SIZE 54, 08 OF oDlga PIXEL hasbutton 
	@ 19, 9 SAY STR0100  SIZE 54, 7 OF oDlga PIXEL  //"Abatimento"
	
	@ 30, 68	MSGET nValBxd Picture "@E 9999,999,999.99" When .F. SIZE 54, 08 OF oDlga PIXEL hasbutton 
	@ 30, 9 SAY  STR0106  SIZE 54, 7 OF oDlga PIXEL  //"Vlr.Baixado"
	
	@ 41, 68	MSGET nCotMoed Picture "@E 9,999.9999" When TRB->MOEDAO != nMoeda Valid Fa460CTM(@nValJur,@nValDes,@nValLiq,@nValCvt,nCotMoed,@nOldCotMoe);
			SIZE 54, 08 OF oDlga PIXEL hasbutton 
	@ 41, 9 SAY STR0140 SIZE 54, 7 OF oDlga PIXEL //"Cotacao da Moeda (R$)"
	
	@ 52, 68	MSGET nValJur Picture "@E 9999,999,999.99" Valid IIF(lF460EDIT,(Fa460Val(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,,nMoedaTit,nValCvt,nCotMoed).AND.ExecBlock("F460EDIT",.F.,.F.,nValJur)),Fa460Val(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,,nMoedaTit,nValCvt,nCotMoed));
			SIZE 54, 08 OF oDlga PIXEL hasbutton 
		
	If lUsaGE
		@ 52, 9 SAY STR0098  SIZE 54, 7 OF oDlga PIXEL  //"Juros"
		@ 63, 68	MSGET nMora Picture "@E 9999,999,999.99" Valid Fa460Val(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,,nMoedaTit,nValCvt,nCotMoed);
		SIZE 54, 08 OF oDlga PIXEL hasbutton 
		@ 63, 9 SAY STR0152  SIZE 54, 7 OF oDlga PIXEL  //"Mora"
		nLin := 74
	Else
		@ 52, 9 SAY STR0098  SIZE 54, 7 OF oDlga PIXEL  //"Juros"
		nLin := 63
	EndIf
	
	@ nLin++, 68	MSGET nValDes Picture "@E 9999,999,999.99" Valid ;
			Iif( lF460VLDE, ( Fa460Val(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,,nMoedaTit,nValCvt,nCotMoed) .And. ExecBlock("F460VLDE",.F.,.F.,nValDes) ), ;
		 	( Fa460Val(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,,nMoedaTit,nValCvt,nCotMoed) ) ) ;
			SIZE 54, 08 OF oDlga PIXEL hasbutton 
			
	@ nLin, 9 SAY STR0099  SIZE 54, 7 OF oDlga PIXEL  //"Desconto"

	nLin += 10

	@ nLin++, 68	MSGET nValLiq Picture "@E 9999,999,999.99" Valid Fa460Val(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,.T.,nMoedaTit,nValCvt,nCotMoed) SIZE 54, 08 OF oDlga PIXEL hasbutton 
	@ nLin, 9 SAY STR0101  SIZE 54, 7 OF oDlga PIXEL  //"Vlr.Liquidar"
	
	DEFINE SBUTTON FROM iif(lUsaGE,98,88), 71 TYPE 1 ENABLE ACTION (nOpca:=1,If(Fa460ValOK(nValOri,nValBxd,nValJur+nMora,nValDes,nValAbt,@nValLiq,nOldVlq,nMoedaTit,nValCvt,nCotMoed),;
											oDlga:End(),nOpca:=0)) OF oDlga
	DEFINE SBUTTON FROM iif(lUsaGE,98,88), 99 TYPE 2 ENABLE ACTION (oDlga:End()) OF oDlga
	
	ACTIVATE MSDIALOG oDlga CENTERED
	
	If nOpca == 1
		nValor += nValliq - nOldVlq
		lTxEdit := .T. //contola a taxa a ser usada na corre玢o monet醨ia
	Endif
	oValor:Refresh()
	oQtdTit:Refresh()
	
	If(lFI460JUR)
		nRet := ExecBlock("FI460JUR",.F.,.F.,{nValJur})
		If ValType(nRet) == "N"
			nValJur := nRet
		EndIf
	EndIf
	
	If lUsaGE .and. nValJur+nMora == TRB->JUROS
		TRB->(RecLock("TRB",.F.))
		TRB->VLMULTA := nValJur
		TRB->(MSUnLock())
	EndIF	
Else
	IW_MsgBox(STR0160,STR0051,"STOP")	//"Este titulo est?sendo utilizado em outro terminal, n鉶 pode ser utilizado na Liquida玢o"###"Aten玢o"
	lRet := .F.
Endif	

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460Val	?Autor ?Mauricio Pequim Jr.   ?Data ?8.12.00  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Valida o valor digitado 									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Val( nValOri,nValBxd,nValJur,nValDes,nValAbt,nValLiq,lValLiq,nMoedaTit,nValCvt,nCotMoed)

Local nAbtCvt := Round(NoRound(xMoeda(nValAbt,nMoedaTit,nMoeda,,3,nCotMoed),3),2)
Local nBxdCvt := Round(NoRound(xMoeda(nValBxd,nMoedaTit,nMoeda,,3,nCotMoed),3),2)
Local nTotCvt := Round(NoRound(xMoeda(SE1->E1_VALOR-nValAbt-nValBxd,nMoedaTit,nMoeda,,3,nCotMoed),3),2)
Local nTotal  := nValCvt - nAbtCvt - nBxdCvt + nValJur - nValDes
Local nSldCvt := Round(NoRound(xMoeda(SE1->E1_SALDO,nMoedaTit,nMoeda,,3,nCotMoed),3),2)

lValLiq := IIF(lValliq == NIL, .F.,lValLiq)

If nValLiq <= 0 .or. nTotal <= 0
	Return .F.
Else
	dbSelectArea("SE1")
	dbSetOrder(1)
	If	MsSeek(TRB->CHAVE)
		If STR(nTotCvt,17,2) < STR(nTotal-nValJur+nValDes,17,2)
			Help(" ",1,"FA460VAL")
			dbSelectArea("TRB")
			Return .F.
		Endif
		If lValLiq
			If STR(nSldCvt,17,2) < STR(nValliq + nAbtCvt + nValDes - nValJur,17,2)
				Help(" ",1,"FA460VAL")
				dbSelectArea("TRB")
				Return .F.
			Endif                      
		Endif
	Else		
		Help(" ",1,"TITNOXADO")
		dbSelectArea("TRB")
		Return .F.
	EndIf
	dbSelectArea("TRB")
	If !lValLiq
		nValLiq := nValCvt - nAbtCvt - nBxdCvt + nValJur - nValDes
	Endif
EndIF
Return .T.

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460ValOK?Autor ?Mauricio Pequim Jr    ?Data ?8.12.00  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Verifica na confirmacao da tela, a validacao do valor - WIN潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460ValOK(nValOri,nValBxd,nValJur,nValDes,nValAbt,nValLiq,nOldVlq,nMoedaTit,nValCvt,nCotMoed)

Local nAbtCvt := Round(NoRound(xMoeda(nValAbt,nMoedaTit,nMoeda,,3,nCotMoed),3),2)
Local nBxdCvt := Round(NoRound(xMoeda(nValBxd,nMoedaTit,nMoeda,,3,nCotMoed),3),2)
Local nTotCvt := Round(NoRound(xMoeda(SE1->E1_VALOR-nValAbt-nValBxd,nMoedaTit,nMoeda,,3,nCotMoed),3),2)
Local nTotal  := nValCvt - nAbtCvt - nBxdCvt + nValJur - nValDes

If nValLiq <= 0 .or. nTotal <= 0
	Return .F.
Else
	dbSelectArea("SE1")
	dbSetOrder(1)
	If	MsSeek(TRB->CHAVE)
		If STR(nTotCvt,17,2) < STR(nTotal-nValJur+nValDes,17,2)
			Help(" ",1,"FA460VAL")
			dbSelectArea("TRB")
			Return .F.
		Endif
	Else		
		Help(" ",1,"TITNOXADO")
		dbSelectArea("TRB")
		Return .F.
	EndIf
	dbSelectArea("TRB")
EndIF
dbSelectArea("TRB")

RecLock("TRB",.F.)
TRB->JUROS	:= nValJur
TRB->DESCON	:= nValDes
TRB->VALLIQ := nValLiq
TRB->CTMOED := nCotMoed
TRB->VALCVT := nValCvt

MsUnlock()
Return .T.

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460Pesq ?Autor ?Mauricio Pequim Jr	  ?Data ?8.12.00潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?tela de pesquisa - WINDOWS 								  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Pesq(oMark)

Local cCampo := Space(25)

DEFINE MSDIALOG oDlgb FROM	69,70 TO 160,331 TITLE STR0002 PIXEL  //"Pesquisar"
@ 1, 2 TO 22, 128 OF oDlgb  PIXEL
@ 7, 68	MSGET cCampo Picture "@!" SIZE 54, 10 OF oDlgb PIXEL hasbutton
@ 8, 9 SAY STR0102  SIZE 54, 7 OF oDlgb PIXEL  //"Pesquisa"
DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca:=1,Fa460Acha(cCampo,oMark),;
								oDlgb:End(),nOpca:=0) OF oDlgb
DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (oDlgb:End()) OF oDlgb
ACTIVATE MSDIALOG oDlgb
Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460Acha ?Autor ?Mauricio Pequim Jr	?Data ?8.12.00  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Funcao que realiza a pesquisa - WINDOWS					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Acha(cCampo,oMark)

dbSelectArea("TRB")
MsSeek(xFilial("SE1")+cCampo,.T.)
oMark:oBrowse:Refresh(.T.)

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460OK1	?Autor ?Mauricio Pequim Jr	?Data ?7.07.01  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Funcao que realiza a validacao do usuario na primeira tela 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460OK1()
Local lRet := .T.

//639.04 Base Impostos diferenciada
Local lBaseImp		:= F040BSIMP(2)

If ExistBlock("F460OK1")
	lRet := ExecBlock("F460OK1",.f.,.f.)
Endif

// Se Portugal, pega cod. Diario
If UsaSeqCor() .AND. lRet
	lRet := Fa460OK2()
Endif

If lRet
	If cCliAte < cCliDe
		IW_MsgBox( STR0184, STR0051, "STOP" )	// "O c骴igo <Cliente Ate> deve ser maior ou igual ao c骴igo <Cliente De>."###"Aten玢o"
		oCliAte:SetFocus()
		lRet := .F.
	ElseIf cCliAte == cCliDe .And. cLojaAte < cLojaDe
		IW_MsgBox( STR0185, STR0051, "STOP" )	// "O c骴igo <Loja Ate> deve ser maior ou igual ao c骴igo <Loja De>."###"Aten玢o"
		oLojaAte:SetFocus()
		lRet := .F.
	EndIf
EndIf

//639.04 Base Impostos diferenciada
If lRet .and. lBaseImp
	lRet := A460NATUR(cNatureza)
Endif

if lUsaGE .and. lRet
	//Verifica se campos obrigatorios foram informados
	if empty(cNumRA)
		MsgAlert(STR0194+STR0149, STR0051) //"?obrigat髍io o preenchimento do campo: "###"Numero do Ra"###"Aten玢o"
		lRet := .F.
	elseif empty(cNrDoc)
		MsgAlert(STR0194+STR0193, STR0051) //"?obrigat髍io o preenchimento do campo: "###"Curso / Per韔do"###"Aten玢o"
		lRet := .F.
	elseif empty(cCliCombo)
		MsgAlert(STR0194+STR0020, STR0051) //"?obrigat髍io o preenchimento do campo: "###"Cliente"###"Aten玢o"
		lRet := .F.
	endif
endif

Return lRet


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460OK2	?Autor ?Erica Casale      	?Data ?6.06.08  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Funcao que solicita cod. diario para Portugal              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460OK2()

lRetOK2 := .T.


If UsaSeqCor()
	cCodDiario := CTBAVerDia() 
Endif


Return lRetOK2
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北砅rograma  ?F460CMC7 ?Autor ?Mauricio Pequim Jr    ?Data ?28/08/02 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Programa destinado a efetuar a leitura de cheques a partir 潮?
北?         ?do equipamento CMC7 e alimentar a rotina de liquidacao.    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function F460CMC7()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Declaracao de Variaveis                                             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
Local lContinua		:= .T.			// Flag da leitura quando for por dispositivo serial
Local nNumCH		:= 1			// Numeral do cheque (qual cheque esta sendo lido. Se primeiro, segundo etc)
Local aCMC7			:= {}			// Array que guardara os dados do cheque vindos da leitora
Local dVenc460		:= dDataBase    // Data inicial do cheque
Local nValChq460	:= 0			// Valor inicial do cheque
Local nCont			:= 0            // Variavel de looping do aHeader
Local cEmiten460	:= Space(40)	// Nome do emitente do cheque 
Local aCmc7Tc 		:= {}			// Armazena o retorno da funcao F460Cmc7Tc
Local nX				:= 2            // Variavel para comparar com o tamanho do aCols
Local lContLeit	:= .T.			// Verifica se a leitura (teclado) acabou ou nao 
Local nPosFili		:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_PREFIXO" })	// Captura no aHeader o campo da filial
Local nPosTipo		:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_TIPO" })		// Captura no aHeader o campo do tipo de operacao
Local nPosBanco	:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_BCOCHQ" })		// Captura no aHeader o campo do banco
Local nPosAgen		:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_AGECHQ" })		// Captura no aHeader o campo da agencia
Local nPosConta	:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_CTACHQ" }) 	// Captura no aHeader o campo da conta
Local nPosCheque	:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_NUM" })		// Captura no aHeader o campo do nro. do cheque	
Local nPosValor	:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_VLCRUZ" }) 	// Captura no aHeader o campo do valor do cheque
Local nPosEmit		:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_EMITCHQ"})		// Captura no aHeader o campo do emitente do cheque
Local nPosVencto	:= aScan(aHeader,{|z| Alltrim(Upper(z[2]))=="E1_VENCTO"})		// Captura no aHeader o campo do emitente do cheque
Local lCond 		:= .T.	
Local lFa460Cmc7	:= ExistBlock("FA460CMC7")
Local cDescCond   := ""
Local aAuxCond    := {}
Local nQtdCond      
Private lUsaCmC7           := .T.                                     // Necessario para funcionamento das funcoes de leitura

SE4->(DbSetOrder(1) )
If SE4->(DBSeek( xFilial("SE4")+Alltrim(cCondicao) ))
	cDescCond    := SE4->E4_COND
    aAuxCond    := STRTOKARR(cDescCond, ',')         
                
    	If SE4->E4_TIPO == "1" // Tratamento para as condi珲es de tipo 1 ao 7
        	nQtdCond   :=len(aAuxCond)
        ElseIf SE4->E4_TIPO == "2"
            nQtdCond	:= Val(Substr(SE4->E4_CODIGO,2,1))
        ElseIf SE4->E4_TIPO == "5"
            nQtdCond   := Val(aAuxCond[2])
        ElseIf SE4->E4_TIPO $ "3467"
            nQtdCond   := Val(aAuxCond[1])
        EndIf
EndIf

If IW_MsgBox(STR0122,STR0001,"YESNO")  //"Deseja utilizar a leitora de cheques?"###"Liquida玢o"
	If nHdlCMC7 < 0
		lContinua := .F. 		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矻eitura do cheque utilizando leitor via teclado.?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		While lContLeit
		   	If Len( aCols ) >= 1 .AND. Empty( aCols[1,nPosBanco] ) 
				aCmc7Tc		:= F460Cmc7Tc()   
				If Len( aCmc7Tc ) > 0
		    		If !Empty( aCols[1,nPosValor] ) 
		    			nValChq460 := aCols[1,nPosValor]
		    		Endif	
		    		F460GetChq(aCmC7Tc,@dVenc460,@nValChq460,@cEmiten460)
					aCols[1,nPosFili]		:= Pad(cFilAnt,Len(SE1->E1_PREFIXO))			// Prefixo
					aCols[1,nPosTipo]		:= cTipo		   	// Tipo
					aCols[1,nPosBanco]	:= aCmc7Tc[1]		// Banco
					aCols[1,nPosAgen]		:= aCmc7Tc[3]		// Agencia
					aCols[1,nPosConta]	:= aCmc7Tc[4]		// Conta
					aCols[1,nPosCheque]	:= Pad(aCmc7Tc[2],Len(SE1->E1_NUM))		// Cheque
					aCols[1,nPosValor]	:= nValChq460		// Valor      
					aCols[1,nPosEmit]		:= cEmiten460		// Emitente 
					aCols[1,nPosVencto]  := dVenc460			// Vencimento
					If lFa460Cmc7
						aCols := ExecBlock("FA460CMC7", .F., .F., {aCols} )
					Endif
				Endif
			Endif

			If IW_MsgBox(STR0125,STR0001,"YESNO")	//"Deseja incluir mais cheques?"###"Liquida玢o"
				aCmc7Tc	:= F460Cmc7Tc()

				If Len( aCmc7Tc ) > 0
					If aScan(aCols,{|x| AllTrim(x[3])+AllTrim(x[4])+AllTrim(x[5])+AllTrim(x[6])== ;
						AllTrim(aCmc7Tc[1])+AllTrim(aCmc7Tc[2])+AllTrim(aCmc7Tc[3])+AllTrim(aCmc7Tc[4]) }) = 0 
						If nX <= Len( aCols )
							If !Empty( aCols[nX,nPosValor] )
		    					nValChq460 := aCols[nX,nPosValor]
		    				Endif
		    			Endif	
						F460GetChq(aCmC7Tc,@dVenc460,@nValChq460,@cEmiten460)
						If Empty( cCondicao ) .OR. Len( aCols ) = 1 .OR. nX > Len( aCols ) .OR. !lCond
							Aadd( aCols, { Pad(cFilAnt,Len(SE1->E1_PREFIXO)), cTipo, aCmc7Tc[1], aCmc7Tc[3], aCmc7Tc[4], Pad(aCmc7Tc[2],Len(SE1->E1_NUM)), dVenc460, cEmiten460, nValChq460, 0, 0, nValChq460} )
							If nUsado2 > 12 // Tamanho do aHeader
								For nCont := 13 to nUsado2
									AADD(aCols[Len(aCols)],CriaVar(aHeader[nCont,2],.T.))
								Next
							Endif
							AADD(aCols[Len(aCols)],.F.)	// controle de delecao
							lCond := .F.
						Elseif lCond  				
							aCols[nX,nPosFili]		:= Pad(cFilAnt,Len(SE1->E1_PREFIXO))		// Prefixo
							aCols[nX,nPosTipo]		:= cTipo		   	// Tipo
							aCols[nX,nPosBanco]		:= aCmc7Tc[1]		// Banco
							aCols[nX,nPosAgen]		:= aCmc7Tc[3]		// Agencia
							aCols[nX,nPosConta]		:= aCmc7Tc[4]		// Conta
							aCols[nX,nPosCheque]		:= Pad(aCmc7Tc[2],Len(SE1->E1_NUM))		// Cheque   
							aCols[nX,nPosValor]		:= nValChq460		// Valor
							aCols[nX,nPosEmit]		:= cEmiten460		// Emitente 
							If aCols[1,nPosVencto] <> dVenc460			// Vencimento
								aCols[nX,nPosVencto] := dVenc460
							Else
								aCols[1,nPosVencto] := dVenc460	
							EndIf
							nX++  	
						Endif			
						If lFa460Cmc7
							aCols := ExecBlock("FA460CMC7", .F., .F., {aCols} )
						Endif
					Else
						IW_MsgBox(STR0124,STR0051,"STOP")	//""Cheque j?Inclu韉o ! Ser?Desprezado.""###"Aten玢o"	
					Endif
				Endif		
			Else
				lContLeit := .F.					
			Endif	
			Loop
		End	
	Endif                              
	
	While lContinua
		aCmc7 := {}
		aCmc7 := LjLeCmc7(nNumCH)
		If Len(aCmc7) > 0
			dVenc460		:= dDataBase
			nValChq460	:= 0
			IF F460GetChq(aCmC7,@dVenc460,@nValChq460,@cEmiten460)
				If nNumCH == 1  // Se for o primeiro
					aCols[1,1] := Pad(cFilAnt,Len(SE1->E1_PREFIXO))		//Prefixo
					aCols[1,2] := cTipo			//Tipo
					aCols[1,3] := aCmc7[1]		//Banco
					aCols[1,4] := aCmc7[3]		//Agencia
					aCols[1,5] := aCmc7[4]		//Conta
					aCols[1,6] := Pad(aCmc7[2],Len(SE1->E1_NUM))		//Cheque
					aCols[1,7] := dVenc460		//Vencimento
					aCols[1,8] := cEmiten460	//Emitente
					aCols[1,9] := nValChq460	//Valor
					aCols[1,10] := 0				//Acrescimo
					aCols[1,11] := 0				//Decrescimo
					aCols[1,12] := nValChq460	//Valor
					If nUsado2 > 12 // Tamanho do aHeader
						For nCont := 13 to nUsado2
							aCols[1,nCont] := CriaVar(aHeader[nCont,2],.T.)
						Next
					Endif
					aCols[1,nUsado2+1] := .F.	// controle de delecao
					nNumCH++
					If lFa460Cmc7
						aCols := ExecBlock("FA460CMC7", .F., .F., {aCols} )
					Endif
				Else
					//Pesquisa se cheque ja foi lido anteriormente (Banco/Agencia/Conta/Nro.Cheque)
					If aScan(aCols,{|x| AllTrim(x[3])+AllTrim(x[4])+AllTrim(x[5])+AllTrim(x[6])== ;
							AllTrim(aCmc7[1])+AllTrim(aCmc7[3])+AllTrim(aCmc7[4])+AllTrim(aCmc7[2]) }) = 0
						Aadd(aCols,{Pad(cFilAnt,Len(SE1->E1_PREFIXO)),cTipo,aCmc7[1],aCmc7[3],aCmc7[4],Pad(aCmc7[2],Len(SE1->E1_NUM)),dVenc460,cEmiten460,nValChq460,0,0,nValChq460})
						If nUsado2 > 12 // Tamanho do aHeader
							For nCont := 13 to nUsado2
								AADD(aCols[Len(aCols)],CriaVar(aHeader[nCont,2],.T.))
							Next
						Endif
						AADD(aCols[Len(aCols)],.F.)	// controle de delecao
						nNumCH++
						If lFa460Cmc7
							aCols := ExecBlock("FA460CMC7", .F., .F., {aCols} )
						Endif
					Else
						IW_MsgBox(STR0124,STR0051,"STOP") //"Cheque j?Inclu韉o ! Ser?Desprezado."###"Aten玢o"
					Endif
				EndIf
			Endif
			If !IW_MsgBox(STR0125,STR0001,"YESNO") //"Deseja incluir mais cheques?"###"Liquida玢o"
				Exit
			EndIf
		Else
			IF IW_Msgbox(STR0126,STR0051,"YESNO")  //"Encerra leitura de Cheques ?"###"Aten玢o"
				Exit
			Endif
		Endif
	End
Endif
n:= Len(aCols)
Return 


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲460GetChq?Autor ?Mauricio Pequim Jr    ?Data ?28/08/02 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矱ntrada de dados do cheque   								  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?F460GetChq(ExpA1,ExpD1,ExpN1)							  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?ExpA1=Array contendo dados do cheque (vindos da leitora)	  潮?
北?         ?ExpD1=Data de vencto do cheque                             潮?
北?         ?ExpC3=Valor do Cheque                                      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function F460GetChq(aCmC7,dVenc460,nValChq460,cEmiten460)

Local lCorrige := .F.
Local lRet := .F.
Local nOpca := 0
Local oBanco
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Criacao da Interface                                                ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
While .T.
	nOpca := 0
	DEFINE MSDIALOG oMkwdlg FROM	070,116 TO 344,380 TITLE STR0127 PIXEL  //"Dados do cheque"
	@ 010,010 SAY STR0128     	Size 25,08 OF oMkwdlg PIXEL	//"Banco"
	@ 025,010 SAY STR0129   	Size 25,08 OF oMkwdlg PIXEL	//"Ag阯cia"
	@ 040,010 SAY STR0130     	Size 25,08 OF oMkwdlg PIXEL	//"Conta"
	@ 055,010 SAY STR0131    	Size 25,08 OF oMkwdlg PIXEL	//"Cheque"
	@ 070,010 SAY STR0132		Size 35,08 OF oMkwdlg PIXEL	//"Vencimento"
	@ 085,010 SAY STR0133		Size 25,08 OF oMkwdlg PIXEL	//"Valor"
	@ 100,010 SAY STR0142		Size 25,08 OF oMkwdlg PIXEL	//"Emitente"
	@ 010,050 MSGET oBanco VAR aCmc7[1] WHEN lCorrige	Size 70,10 OF oMkwdlg PIXEL hasbutton
	@ 025,050 MSGET aCmc7[3] WHEN lCorrige	Size 70,08 OF oMkwdlg PIXEL hasbutton
	@ 040,050 MSGET aCmc7[4] WHEN lCorrige	Size 70,08 OF oMkwdlg PIXEL hasbutton
	@ 055,050 MSGET aCmc7[2] WHEN lCorrige	Size 70,08 OF oMkwdlg PIXEL hasbutton
	@ 070,050 MSGET dVenc460					Size 70,08 OF oMkwdlg PIXEL hasbutton
	@ 085,050 MSGET nValChq460 Valid nValChq460 > 0 Picture "@E 99,999,999.99" Size 70,08  OF oMkwdlg PIXEL hasbutton
	@ 100,050 MSGET cEmiten460 Picture "@!S40" Size 70,08  OF oMkwdlg PIXEL hasbutton
		
	DEFINE SBUTTON FROM 122, 035 TYPE 1 ACTION (nOpca:=1,oMkwdlg:End())ENABLE OF oMkwdlg PIXEL
	DEFINE SBUTTON FROM 122, 065 TYPE 2 ACTION (nOpca:=2,oMkwdlg:End())ENABLE OF oMkwdlg PIXEL
	DEFINE SBUTTON FROM 122, 095 TYPE 5 ACTION (nOpca:=3,	;
																aCmc7[1] := PADR(aCmc7[1],3," "),;
																aCmc7[3] := PADR(aCmc7[3],4," "),;
																aCmc7[4] := PADR(aCmc7[4],8," "),;
																aCmc7[2] := PADR(aCmc7[2],6," "),;
																lCorrige := .T.,;
																oBanco:SetFocus()) ENABLE OF oMkwdlg PIXEL
	
	ACTIVATE MSDIALOG oMkwdlg CENTERED
	
	If nOpca == 1  // Confirma Dados do Cheque
	   lRet := .T.
		lCorrige := .F.
	ElseIf nOpca == 2 	// Finaliza inclusao de cheques
		lRet := .F.
		lCorrige := .F.
	Endif	
	Exit	
End	
Return(lRet)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460CTM	?Autor ?Mauricio Pequim Jr.   ?Data ?2.12.02  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ?Converte os valores para nova cotacao da moeda			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460CTM(nValJur,nValDes,nValLiq,nValCvt,nCotMoed,nOldCotMoe)

nValJur := Round(NoRound((nValJur * nCotMoed)/nOldCotMoe,3),2)
nValDes := Round(NoRound((nValDes * nCotMoed)/nOldCotMoe,3),2)
nValLiq := Round(NoRound((nValLiq * nCotMoed)/nOldCotMoe,3),2)
nValCvt := Round(NoRound((nValCvt * nCotMoed)/nOldCotMoe,3),2)                  
nOldCotMoe := nCotMoed

Return .T.


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲460PARNEG篈utor  ?Edney S. de Souza  ?Data ? 09/01/02   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Altera玢o dos parametros de negociacao                     罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?AP6                                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

static function F460ParNeg()
Local oNegWindow, oNegEntrad, oNegTxJuro, oNegTxPer, oNegParcel, oNegInterv, oNegValMin, oNegValMax, oNegMotivo
Local cCondicao:=Space(3)


// Parametros de Negociacao
IF lUsaGE
	
	DEFINE MSDIALOG oNegWindow TITLE STR0144 FROM 10,15 TO 395,280 OF GetWndDefault() PIXEL

	@ 010,05 SAY STR0158 SIZE 40,10 PIXEL OF oNegWindow //"Motivo "
	@ 010,50 MSGET oNegMotivo VAR cMotivo SIZE 80,10 PIXEL OF oNegWindow F3 "FU" Valid Vazio() .or. ExistCpo( "SX5", "FU" + cMotivo ) hasbutton
	@ 025,05 SAY STR0145 SIZE 40,10 PIXEL OF oNegWindow //"Entrada"
	@ 025,50 MSGET oNegEntrad VAR nJCDEntrad SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("SE1","E1_SALDO") RIGHT VALID nJCDEntrad >= 0 hasbutton
	@ 040,05 SAY STR0098 SIZE 40,10 PIXEL OF oNegWindow //"Juros"
	@ 040,50 MSGET oNegTxJuro VAR nJCDTXJURO SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_TXJURO") RIGHT WHEN cNivel >= NivelSx3("JCD_TXJURO") VALID nJCDTXJURO >= 0 hasbutton
	@ 055,05 SAY STR0152 SIZE 40,10 PIXEL OF oNegWindow //"% Mora"
	@ 055,50 MSGET oNegTxPer  VAR nJCDTXPER  SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_TXPER") RIGHT WHEN cNivel >= NivelSx3("JCD_TXPER") VALID nJCDTXPER >= 0 hasbutton
	@ 070,05 SAY STR0040 SIZE 40,10 PIXEL OF oNegWindow //"Qtd. Parcelas"
	@ 070,50 MSGET oNegParcel VAR nJCDPARCEL SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_PARCEL") RIGHT WHEN cNivel >= NivelSx3("JCD_PARCEL") VALID nJCDPARCEL >= 1 hasbutton
	@ 085,05 SAY STR0146 SIZE 40,10 PIXEL OF oNegWindow //"Intervalo"
	@ 085,50 MSGET oNegInterv VAR nJCDINTERV SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_INTERV") RIGHT WHEN cNivel >= NivelSx3("JCD_INTERV") VALID nJCDINTERV >= 1 hasbutton
	@ 100,05 SAY STR0147 SIZE 40,10 PIXEL OF oNegWindow //"Valor M韓imo"
	@ 100,50 MSGET oNegValMin VAR nJCDValMin SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_VALMIN") RIGHT WHEN cNivel >= NivelSx3("JCD_VALMIN") VALID nJCDVALMIN > 0 hasbutton
	@ 115,05 SAY STR0148 SIZE 40,10 PIXEL OF oNegWindow //"Valos M醲imo"
	@ 115,50 MSGET oNegValMax VAR nJCDValMax SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_VALMAX") RIGHT WHEN cNivel >= NivelSx3("JCD_VALMAX") VALID nJCDVALMAX >= nJCDVALMIN hasbutton
	@ 130,05 SAY Capital(STR0029) SIZE 40,10 PIXEL OF oNegWindow
	@ 130,50 MSGET oNegBanco VAR nJCDBanco SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_BANCO") RIGHT WHEN cNivel >= NivelSx3("JCD_BANCO") F3 "SA6" hasbutton
	@ 145,05 SAY Capital(STR0030) SIZE 40,10 PIXEL OF oNegWindow
	@ 145,50 MSGET oNegAgenci VAR nJCDAgenci SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_AGENCI") RIGHT WHEN cNivel >= NivelSx3("JCD_AGENCI") hasbutton
	@ 160,05 SAY Capital(STR0031) SIZE 40,10 PIXEL OF oNegWindow
	@ 160,50 MSGET oNegAgenci VAR nJCDNumCon SIZE 80,10 PIXEL OF oNegWindow Picture PesqPict("JCD","JCD_NUMCON") RIGHT WHEN cNivel >= NivelSx3("JCD_NUMCON") hasbutton
	
	DEFINE SBUTTON FROM 180,041 TYPE 1 ACTION (A460Cond(cCondicao, nUsado2),oNegWindow:End()) ENABLE PIXEL OF oNegWindow
	
	DEFINE SBUTTON FROM 180,071 TYPE 2 ACTION oNegWindow:End() ENABLE PIXEL OF oNegWindow
	
	DEFINE SBUTTON FROM 180,101 TYPE 5 ACTION F460GetJCD()     ENABLE PIXEL OF oNegWindow
	
	ACTIVATE DIALOG oNegWindow CENTERED
EndIf

Return NIL

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲460GetJCD篈utor  ?Edney S. Souza     ?Data ? 10/01/02   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Restaura os parametros do JCD gravados                     罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?AP6                                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

static function F460GetJCD()

IF lUsaGE
	JCD->(dBGoBottom())
	nJCDEntrad := 0
	nJCDTxJuro := JCD->JCD_TXJURO
	nJCDTxPer  := JCD->JCD_TXPER
	nJCDParcel := JCD->JCD_PARCEL
	nJCDInterv := JCD->JCD_INTERV
	nJCDValMin := JCD->JCD_VALMIN
	nJCDValMax := JCD->JCD_VALMAX
	nJCDBanco  := JCD->JCD_BANCO
	nJCDAgenci := JCD->JCD_AGENCI
	nJCDNumCon := JCD->JCD_NUMCON
Else
	nJCDEntrad := 0
	nJCDTxJuro := 0
	nJCDTxPer := 0
	nJCDParcel := 0
	nJCDInterv := 0
	nJCDValMin := 0
	nJCDValMax := 0
	nJCDBanco  := Space(TamSx3("E1_BCOCHQ")[1])
	nJCDAgenci := Space(TamSx3("E1_AGECHQ")[1])
	nJCDNumCon := Space(TamSx3("E1_CTACHQ")[1])
Endif

Return NIL

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  砃IVELSX3  篈utor  ?Edney S. Souza     ?Data ? 10/01/02   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Retorna o n韛el de um campo no SX3                         罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?AP6                                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

static function NivelSX3(cField)
Local nOrdem := SX3->(IndexOrd())
Local nRecno := SX3->(Recno())
Local nNivel := 0
SX3->(DbSetOrder(2))
IF SX3->(MsSeek(cField))
	nNivel := SX3->X3_NIVEL
EndIf
SX3->(DbSetOrder(nOrdem))
SX3->(DbGoto(nRecno))
Return nNivel

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲460PARC  篈utor  矱dney S. Souza      ?Data ? 06/03/02   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Retorna a Parcela do T韙ulo                                罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?AP6                                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

static function F460PARC()
IF lUsaGE
	cParc460 := SuperGetMV("MV_1DUP")
Else
	cParc460 := CriaVar("E1_PARCELA",.F.)
EndIf
Return cParc460


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲INA460   篈utor  矱dney S. Souza      ?Data ? 06/06/02   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Ajusta o ComboBox de Cursos disponiveis de acordo com o RA 罕?
北?         ?escolhido                                                  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?Gestao Educacional                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

static function FIN460ACUR(cNumRa,oNrDoc,cNrDoc,aNrDoc,oClients,cCliCombo,aClients)
Local aTmpDoc 	:= {}
Local lDif 		:= .F.
Local lExitTit 	:= .F.
Local cQuery 	:= ""
Local lRet  	:= .T.

//Primeiro verifica se existe titulo para este aluno
cQuery := "SELECT COUNT(E1_NUM) QTD"
cQuery += "  FROM " + RetSQLName("SE1")
cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"'"
cQuery += "  AND E1_NUMRA = '"+cNumRa+"'"
cQuery += "  AND D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '_460TITALU', .F., .T.)

lExitTit := _460TITALU->QTD > 0
_460TITALU->( dbCloseArea() )

if lExitTit
	JBE->(dbSetOrder(1))
	JBE->(MsSeek(xFilial("JBE")+cNumRA))
	WHILE xFilial("JBE") == xFilial("JBE") .and. JBE->JBE_NUMRA == cNumRa .and. ! JBE->(EOF())
		aadd(aTmpDoc,JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_TURMA+" - "+Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_DESC"))
		If Len(aNrDoc) >= Len(aTmpDoc)
			If ! aNrDoc[Len(aTmpDoc)] == aTmpDoc[Len(aTmpDoc)]
				lDif := .T.
			EndIf
		EndIf
		JBE->(dbSkip())
	END
	aadd(aTmpDoc,STR0153)	//"Outros T韙ulos"
	If ! Len(aNrDoc) == Len(aTmpDoc) .or. lDif
		aNrDoc := aClone(aTmpDoc)
		oNrDoc:SetItems(aNrDoc)
		oNrDoc:Refresh()
	EndIf
	
	//Ajusta o ComboBox de Clientes disponiveis de acordo com o RA e Curso (NrDoc) escolhido
	FIN460ACli(cNumRa,cNrDoc,@oClients,@cCliCombo,@aClients)
else
	MsgAlert(STR0195) //"N鉶 existem t韙ulos para este aluno."
	lRet := .F.
endif

Return lRet


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o	 矲a460bAval ?Autor ?Mauricio Pequim Jr.  ?Data ?02/04/03 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 矪loco de marcacoo       			          				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ?Fa460bAval()		  										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460bAval(cMarca,oValor,oQtdTit,oMark)
Local lRet 		:= .T.
Local aArea 	:= GetArea()
Local aAreaTRB  := TRB->(GetArea())
Local aAreaSE1 	:= SE1->(GetArea())
Local cCliente	:= ''
Local cLoja		:= ''
Local cNumRa	:= ''
Local cPerLet	:= ''
Local cTurma	:= ''
Local cIDAPLIC	:= ''
Local nRecAux	:= 0
Local nRecTRB	:= 0  

dbSelectArea("TRB")
dbSelectArea("SE1")

//Posiciona na SE1
SE1->(MsSeek(TRB->CHAVE))

cCliente	:= SE1->E1_CLIENTE
cLoja		:= SE1->E1_LOJA
If GetNewPar("MV_RMCLASS",.F.)
	cNumRa		:= SE1->E1_NUMRA
	cPerLet		:= SE1->E1_PERLET
	cTurma		:= SE1->E1_TURMA
	If cPaisLoc == "BRA"
		cIDAPLIC	:= SE1->E1_IDAPLIC
	EndIf
Endif

nRecAux		:= SE1->(Recno())
nRecTRB		:= TRB->(Recno())

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//矷ntegracao Protheus x CorporeRM (GDP Educacional)?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
if GetNewPar('MV_RMBIBLI',.F.) .and. alltrim(upper(SE1->E1_ORIGEM)) == 'L'
	Aviso(STR0188,STR0189,{STR0190}) //"N鉶 ?permitido liquidar/renegociar t韙ulos nativos do RM Biblios"
	Return .F.
elseif GetNewPar('MV_RMCLASS',.F.)

	//Valida玢o para integra玢o do Protheus x RM Classis via mensagem 鷑ica
	//A valida玢o na verdade ocorre antes da chamda da integdef, durante a sele玢o dos t韙ulos para liquida玢o
	TRB->(DbGoTop())
	While !TRB->(Eof())
		If TRB->MARCA == cMarca
			If SE1->(DbSeek(TRB->CHAVE))
				If (Empty(cNumRa) .And. Empty(cPerLet) .And. Empty(cTurma) .And. Empty(cIDAPLIC)) .And.;
					(!Empty(SE1->E1_NUMRA) .And. !Empty(SE1->E1_PERLET) .And. !Empty(SE1->E1_TURMA) .And. Iif(cPaisLoc=="BRA", !Empty(SE1->E1_IDAPLIC),.F.))
					Aviso('Integra玢o Protheus x RM Classis','N鉶 ?permitido selecionar t韙ulos oriundos da integra玢o com t韙ulos distintos',{'Ok'})
					lRet := .F.
				EndIf

				If SE1->(E1_CLIENTE+E1_LOJA) != cCliente+cLoja
					Aviso('Integra玢o Protheus x RM Classis','N鉶 ?permitido selecionar t韙ulos de clientes diferentes',{'Ok'})
					lRet := .F.
				EndIf

				If SE1->E1_NUMRA != cNumRa
					Aviso('Integra玢o Protheus x RM Classis','?permitido renegociar apenas t韙ulos que perten鏰m a um mesmo n鷐ero de RA',{'Ok'})
					lRet := .F.				
				EndIf

				If SE1->E1_PERLET != cPerLet
					Aviso('Integra玢o Protheus x RM Classis','?permitido renegociar apenas t韙ulos que perten鏰m a um mesmo Per韔do Letivo',{'Ok'})
					lRet := .F.				
				EndIf

				If SE1->E1_TURMA != cTurma
					Aviso('Integra玢o Protheus x RM Classis','?permitido renegociar apenas t韙ulos que perten鏰m a uma mesma Turma',{'Ok'})
					lRet := .F.								
				EndIf

				If Iif(cPaisLoc == "BRA", SE1->E1_IDAPLIC != cIDAPLIC, .F. )
					Aviso('Integra玢o Protheus x RM Classis','?permitido renegociar apenas t韙ulos que perten鏰m a uma mesma Matriz Aplicada',{'Ok'})
					lRet := .F.								
				EndIf				
			EndIf
		EndIf
		TRB->(dbSkip())
	EndDo
	
	SE1->(DbGoTo(nRecAux))
	TRB->(DbGoTo(nRecTRB))
	
	If !lRet
		Return .F.
	EndIf
EndIf

// Verifica se o registro nao esta sendo utilizado em outro terminal
If SE1->(MsRLock()) .and. SE1->E1_SALDO > 0
	A460Inverte(cMarca,oValor,oQtdTit,.F.,oMark) // Marca o registro e trava
	lRet := .T.
Else
	IW_MsgBox(STR0160,STR0051,"STOP")	//"Este titulo est?sendo utilizado em outro terminal, n鉶 pode ser utilizado na Liquida玢o"###"Aten玢o"
	lRet := .F.
Endif	

RestArea(aAreaSE1)
RestArea(aAreaTRB)
RestArea(aArea)
Return lRet

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矲a460Visu ?Autor ?Cristiano Denardi     ?Data ?2.02.05  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砎isualiza Titulo a partir da tela de Bordero		  		  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 ?FINA460	 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function Fa460Visu()

Local 	aArea 		:= GetArea()
Private cCadastro 	:= OemToAnsi( STR0168 )

lAltera := .F.

DbSelectArea("SE1")
DbSetOrder(1)
If MsSeek(Left(TRB->CHAVE,2)+Left(TRB->TITULO,TamSX3("E2_PREFIXO")[1])+SubStr(TRB->TITULO,5,TamSX3("E2_NUM")[1])+;
			SubStr(TRB->TITULO,15,TamSX3("E2_PARCELA")[1])+Right(TRB->TITULO,TamSX3("E2_TIPO")[1]))
	AxVisual( "SE1", SE1->( Recno() ), 2 )
		
Endif

RestArea( aArea )
Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噭o	 矲a460ExcSef?Autor ?Claudio Donizete Souza?Data ?4.09.05  潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噭o 矱xclui cheques do SEF atrelados ao titulo liquidado		   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?Uso		 ?FINA060	 												   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
static function Fa460ExcSef(cPrefixo,cNum,cParcela,cTipo)
Local aArea := GetArea()

SEF->(dbSetOrder(7) )
If SEF->(MsSeek(xFilial("SEF")+"R"+cPrefixo+cNum+cParcela+cTipo))
	While SEF->(!Eof()) .And. ;
			xFilial("SEF")+"R"+cPrefixo+cNum+cParcela+cTipo==;
			SEF->(EF_FILIAL+EF_CART+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO)
		Reclock("SEF")
		SEF->(dbDelete())
		MsUnlock()
		FkCommit()
		SEF->(dbSkip())
	End
Endif
RestArea(aArea)

Return Nil 

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矲460Confir篈utor  矼auro Sano          ?Data ? 27/03/06   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Funcao para a validar o c骴igo capturado pelo leitor de    罕?
北?         ?CMC7.                                                      罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篜arametr  ?ExpC1 = Contem a string lida do cheque, antes do tratamento罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篟etorno   ?ExpL1 = Confirma se os dados lidos sao validos             罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?FINA460                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

static function F460Confirma( cCmc7 )
Local lRet := .F.		// Retorno da validacao da string

Default cCmc7	:= ""	//Codigo do CMC7

If SubStr(cCmc7,1,1) <> "<"
	cCmc7	:= SubStr(Alltrim(cCmc7),2,Len(Alltrim(cCmc7)) - 1)
EndIf

If Empty( cCmc7 ) // Caso nao leia nada
	MsgAlert( STR0178 )		// "Passe o cheque novamente no leitor." 
Elseif ( "?" $ cCmc7 ) .OR. Len( AllTrim( cCmc7 ) ) <> 34 // Se encontrar o caracter de erro (?) ou tamnaho menor que o correto (34)
	MsgAlert( STR0179 + " " + STR0178 )		// "Erro na leitura." ### "Passe o cheque novamente no leitor."  
Else
	lRet := .T.
Endif	

Return ( lRet )	    

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矲460Cmc7Tc篈utor  矼auro Sano          ?Data ? 27/03/06   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Funcao para a captura do c骴igo CMC7 pelo leitor via       罕?
北?         ?teclado.                                                   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篟etorno   ?ExpA1 = Array contendo os dados lidos do cheque:           罕?
北?         ?[1] - Banco | [2] - Agencia | [3] - Conta | [4] - Cheque   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?FINA460                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
static function F460Cmc7Tc()
Local cCmc7 	:= Space(35)	// Recebera o conteudo lido do cheque 
Local oCmc7						// Objeto do get do CMC7
Local oDlg						// Monta a tela de captura do codigo  
Local aCmc7Tc	:= {}			// Armazena os dados do cheque; retorno da funcao
Local nOpcx 	:= 0

DEFINE MSDIALOG oDlg TITLE STR0180 FROM 200 , 001 TO 300 , 300 OF oMainWnd PIXEL	// "Leitura do c骴igo do cheque"
@ 010 , 018 Say STR0181 SIZE 050 , 050 OF oDlg PIXEL								// "Passe o cheque:"
@ 018 , 018 MSGET oCmc7 VAR cCmc7 PICTURE "@!" SIZE 120,009 OF oDlg PIXEL

DEFINE SBUTTON FROM 35 , 080 TYPE 1 ACTION (Iif (F460Confirma(@cCmc7), (oDlg:End(), nOpcx := 1), oCmc7:SetFocus()) )  ENABLE OF oDlg
DEFINE SBUTTON FROM 35 , 110 TYPE 2 ACTION oDlg:End()  ENABLE OF oDlg


ACTIVATE MSDIALOG oDlg CENTERED	

If nOpcx == 1  //Confirmou cheque

	If ExistBlock("F460CMTC")
		aCmc7Tc := ExecBlock("F460CMTC",.F.,.F.,cCmC7)
	Else
		Aadd( aCmc7Tc, SubStr(cCmc7, 2, 3) )	//Banco
		Aadd( aCmc7Tc, SubStr(cCmc7, 14, 6) )	//Cheque
		Aadd( aCmc7Tc, SubStr(cCmc7, 5, 4) )	//Agencia  
		Aadd( aCmc7Tc, SubStr(cCmc7, 25, 8) )	//Conta
	Endif	

Endif	
//<34161168<0010002995>651020209808C
//<23728016<0010002185>777500568207C
//C<35612683<0180100215>800060056009C
Return( aCmc7Tc )

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北砅rograma  矼enuDef   ?Autor ?Ana Paula N. Silva     ?Data ?7/11/06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Utilizacao de menu Funcional                               潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砇etorno   矨rray com opcoes da rotina.                                 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros砅arametros do array a Rotina:                               潮?
北?         ?. Nome a aparecer no cabecalho                             潮?
北?         ?. Nome da Rotina associada                                 潮?
北?         ?. Reservado                                                潮?
北?         ?. Tipo de Transa噭o a ser efetuada:                        潮?
北?         ?	1 - Pesquisa e Posiciona em um Banco de Dados     潮?
北?         ?   2 - Simplesmente Mostra os Campos                       潮?
北?         ?   3 - Inclui registros no Bancos de Dados                 潮?
北?         ?   4 - Altera o registro corrente                          潮?
北?         ?   5 - Remove o registro corrente do Banco de Dados        潮?
北?         ?. Nivel de acesso                                          潮?
北?         ?. Habilita Menu Funcional                                  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?  DATA   ?Programador   矼anutencao efetuada                         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?         ?              ?                                           潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function MenuDef()
Local aRotina := {}
Private lUsaGE		:= Upper(AllTrim(FunName())) == "ACAA710"
IF lUsaGE
	nJCDTxJuro := 0
	nJCDTxPer := 0
	If aPrefixo == NIL
		aPrefixo	:= ACPrefixo()
	EndIf
	aRotina := {	{ STR0002 ,"AxPesqui"  , 0 , 1,,.F. },;	          //"Pesquisar"
							{ STR0003 ,"A460Liquid", 0 , 3 },;        //"Liquidar"
							{ STR0076 ,"A460Liquid", 0 , 3 },;        //"Reliquidar"
							{ STR0150 ,"AC520BRW", 0 , 6 },;          //"Posicao &Financeira"
							{ STR0183 ,"FINA280(3)", 0,  3 },;        //"Faturar"
							{ STR0052 ,"FA460Can"  , 0 , 6 },;        //"Cancelar"
							{ STR0200 ,"CTBC662"  , 0 , 7 },;        //"Tracker Cont醔il"
							{ STR0154 ,"FA040Legenda", 0 , 6, ,.F.} } //"Le&genda"
Else
	aRotina := {	{ STR0002 ,"AxPesqui"  , 0 , 1 ,,.F.},;	     //"Pesquisar"
							{ STR0003 ,"A460Liquid", 0 , 3 },;   // "Liquidar"
							{ STR0076 ,"A460Liquid", 0 , 3 },;   // "Reliquidar"
							{ STR0052 ,"FA460Can"  , 0 , 6 },;//"Cancelar"
							{ STR0200 ,"CTBC662"  , 0 , 7 },;        //"Tracker Cont醔il"
							{ STR0154 ,"FA040Legenda", 0 , 6, ,.F.} } //"Le&genda"}  	 
EndIf
	
If ExistBlock("FA460ROT")
	aRotina := Execblock("FA460ROT",.F.,.F.,aRotina)		//adiciona alguma rotina em aRotina
Endif

Return(aRotina)


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矲inA460T   ?Autor ?Marcelo Celi Marques ?Data ?27.03.08 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Chamada semi-automatica utilizado pelo gestor financeiro   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso      ?FINA460                                                    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function FinA460T(aParam)	

	ReCreateBrow("SE1",FinWindow)      	
	cRotinaExec := "FINA460"
	FinA460(aParam[1])
	ReCreateBrow("SE1",FinWindow)      	

	dbSelectArea("SE1")
	
	INCLUI := .F.
	ALTERA := .F.

Return .T.	


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矲A460MotBX篈utor  矼arcelo Celi Marques?Data ? 22/01/09   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Funcao criar automaticamente o motivo de baixa LIQ na      罕?
北?         ?tabela Mot baixas                                          罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?FINA460                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/                    
static function Fa460MotBx(cMot,cNomMot, cConfMot)
	Local aMotbx := ReadMotBx()
	Local nHdlMot, I, cFile := "SIGAADV.MOT"
	
	If ExistBlock("FILEMOT")
		cFile := ExecBlock("FILEMOT",.F.,.F.,{cFile})
	Endif
	
	If Ascan(aMotbx, {|x| Substr(x,1,3) == Upper(cMot)}) < 1
		nHdlMot := FOPEN(cFile,FO_READWRITE)
		If nHdlMot <0
			HELP(" ",1,"SIGAADV.MOT")
			Final("SIGAADV.MOT")
		Endif
		
		nTamArq:=FSEEK(nHdlMot,0,2)	// VerIfica tamanho do arquivo
		FSEEK(nHdlMot,0,0)			// Volta para inicio do arquivo

		For I:= 0 to  nTamArq step 19 // Processo para ir para o final do arquivo	
			xBuffer:=Space(19)
			FREAD(nHdlMot,@xBuffer,19)
	    Next		
		
		fWrite(nHdlMot,cMot+cNomMot+cConfMot+chr(13)+chr(10))	
		fClose(nHdlMot)		
	EndIf	
Return


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矲460VldCmp ?Autor ?Alberto Deviciente   ?Data ?6.Ago.08 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 矲az validacao do campo "CLIENTE DE"                         潮?
北?         矨tualiza campo "CLIENTE ATE" c/ o mesmo cod. do "CLIENTE DE"潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso      矲INA460 - Integracao Protheus X RM Classis Net (RM Sistemas)潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
static function F460VldCmp( cCliDe, cLojaDe, cCliAte, cLojaAte, cCli460, cLoja )
cCliAte := cCliDe
cLojaAte := cLojaDe
cCli460 := cCliDe
cLoja := cLojaDe
Return .T.

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲N460ValIn篈utor  矯esar A. Bianchi    ?Data ? 07/15/09   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     砇ealiza as validacoes da negociacao de titulos nativos do RM罕?
北?         矯lassisNet                                                  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       矲INA460 - Integracao Protheus X RM Classis Net (CorporeRM)  罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/
static function Fn460ValIn(nOpca)
Local lRet := .T.

Return lRet

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矲A460LiqOk篈utor  ?Totvs              ?Data ? 04/11/09   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Funcao para validar selecao de titulos para liquidacao     罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?FINA460                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/                    
static function FA460LiqOk()
Local lRet	:= .T.
Local aArea := GetArea()
	                       
If Empty(cLoja)
	lRet	:= .F.
	Aviso(STR0051,STR0196,{STR0197}) //"Aten玢o" ## "O campo 'Loja' est?em branco. Favor informar a loja do cliente selecionado." ## "OK"
Endif

dbselectarea("SA1")
dbSetOrder(1)
If lRet .and. !(MsSeek(xFilial("SA1")+cCliente+cLoja))
	lRet	:= .F.
	Aviso(STR0051,STR0198,{STR0197}) //"Aten玢o" ## "O cliente informado n鉶 foi encontrado na base de dados. Favor Verifique C骴igo e Loja deste cliente." ## "OK"	
Endif
	
// Ponto de Entrada para validacao ao confirmar selecao de titulos 
// para liquidacao
If lRet .And. ExistBlock( "F460LQOK" )
	lRet := ExecBlock( "F460LQOK" )
EndIf

RestArea(aArea)

Return lRet

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矲460NATPCC篈utor  ?Totvs              ?Data ? 08/12/09   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Funcao para verifica o calculo de impostos para a 		  罕?
北?         ?natureza dos titulos a serem gerados                       罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?FINA460                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/ 
static function F460NATIMP()

//639.04 Base Impostos diferenciada
Local lBaseImp	:= F040BSIMP(2)
Local cImpPcc	:= ""

cNatureza := If(Type("cNatureza") != "C", "",cNatureza)

If lBaseImp .and. !Empty(cNatureza) .and. !Empty(cCliente)

	//Posiciona Cadastro de Naturezas
	SED->(dbSetOrder(1))
	SED->(MsSeek(xFilial("SED")+cNatureza))

	//Posiciona Cadastro de Clientes		
	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1")+cCliente+cLoja))

	//Verifico se a combinacao Cliente x Natureza calcula CSLL
	If (SED->ED_CALCCSL == "S" .and. SA1->A1_RECCSLL $ "S#P")
		cImpPcc += "CSL#"
	Endif

	//Verifico se a combinacao Cliente x Natureza calcula COFINS	
	If	(SED->ED_CALCCOF == "S" .and. SA1->A1_RECCOFI $ "S#P")
		cImpPcc += "COF#"
	Endif
			
	//Verifico se a combinacao Cliente x Natureza calcula PIS
	If	(SED->ED_CALCPIS == "S" .and. SA1->A1_RECPIS $ "S#P") 
		cImpPcc += "PIS#"
	Endif

	If SED->ED_CALCIRF$"1S" .And. If(cPaisLoc == "BRA", SA1->A1_RECIRRF $ "1", .T.)
		cImpPcc += "IRF#"
	Endif
	If SED->ED_CALCINS$"1S"
		cImpPcc += "INS#"
	Endif
	If SED->ED_CALCISS$"1S" .AND. SA1->A1_RECISS $ "1"
		cImpPcc += "ISS#"
	Endif

Endif	

Return (cImpPcc)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲IN460ACli篈utor  矨lberto Deviciente  ?Data ?05/Jan/10   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矨justa o ComboBox de Clientes disponiveis de acordo com o RA罕?
北?         砮 Curso (NrDoc) escolhido.                                  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?Gestao Educacional                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
static function FIN460ACli(cNumRa,cNrDoc,oClients,cCliCombo,aClients)
Local aTmpCli := {}
Local cQuery  := ""
Local lMSSQL := "MSSQL"$TCGetDB()
Local lMySQL := "MYSQL"$TCGetDB()

if !Empty(cNumRa)
	cQuery := "SELECT DISTINCT E1_CLIENTE, E1_NOMCLI"
	cQuery += "  FROM " + RetSQLNAme("SE1")
	cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"'"
	cQuery += "   AND E1_NUMRA  = '"+cNumRa+"'"
	if cNrDoc == STR0153 //"Outros T韙ulos"
		cQuery += "   AND E1_NRDOC  = '"+Space(TamSx3("E1_NRDOC")[1])+"'"
	else
		if lMSSQL .or. lMySQL
			cQuery += " AND Substring(E1_NRDOC,1,"+alltrim(Str(TamSx3("JBE_CODCUR")[1]+TamSx3("JBE_PERLET")[1]))+") = '"+Substr(cNrDoc,1,TamSx3("JBE_CODCUR")[1])+Substr(cNrDoc,TamSx3("JBE_CODCUR")[1]+2,TamSx3("JBE_PERLET")[1])+"'"
		else
			cQuery += " AND Substr(E1_NRDOC,1,"+alltrim(Str(TamSx3("JBE_CODCUR")[1]+TamSx3("JBE_PERLET")[1]))+") = '"+Substr(cNrDoc,1,TamSx3("JBE_CODCUR")[1])+Substr(cNrDoc,TamSx3("JBE_CODCUR")[1]+2,TamSx3("JBE_PERLET")[1])+"'"
		endif
	endif
	cQuery += "   AND D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), '_460CLI', .F., .T.)
	
	if _460CLI->( !EoF() )
		while _460CLI->( !EoF() )
			aadd(aTmpCli,_460CLI->E1_CLIENTE+" - "+_460CLI->E1_NOMCLI)
			_460CLI->( dbSkip() )
		end
	else
		aadd(aTmpCli,"")
	endif
	
	_460CLI->( dbCloseArea() )
else
	aadd(aTmpCli,"")
endif

if cChvRaNDoc <> cNumRa+cNrDoc
	cChvRaNDoc := cNumRa+cNrDoc
	aClients := aClone(aTmpCli)
	oClients:SetItems(aClients)
	oClients:Refresh()
endif

Return .T.



/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 砯a460Corr ?Autor ?Mauricio Pequim Jr    ?Data ?11/01/12 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矯alcula a corre噭o monet爎ia.								  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砯a460Corr()												  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?Uso		 矴en俽ico													  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
static function fa460Corr(nValorBx,lRetMoeda1)

Local nCorrecao := 0
Local nValAtual := 0
Local nValEmiss := 0
Local nRecMoed  := RecMoeda( dDataBase , SE1->E1_MOEDA )
Local nTxMoeda	:= If(SE1->E1_TXMOEDA > 0, SE1->E1_TXMOEDA,Iif(lTxEdit,TRB->CTMOED,nRecMoed))

Default lRetMoeda1 := .F.

IF Int(SE1->E1_VLCRUZ) == Int(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)))
	If Int(SE1->E1_VLCRUZ) == Int(xMoeda(nValorBx,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)))
		nValEmiss := SE1->E1_VLCRUZ
	Else
		nValEmiss := xMoeda(nValorBx,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
	EndIf	
Else
	If !Empty(SE1->E1_TXMDCOR)
		nValEmiss := xMoeda(nValorBx,SE1->E1_MOEDA,1,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_EMISSAO,SE1->E1_DTVARIA),8,SE1->E1_TXMDCOR)
	Else
		nValEmiss := xMoeda(nValorBx,SE1->E1_MOEDA,1,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_EMISSAO,SE1->E1_DTVARIA),8,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_TXMOEDA,0))
	EndIf
EndIF

nValAtual := xMoeda( nValorBx , SE1->E1_MOEDA , 1 , dDataBase , 8 , If( SE1->E1_TXMOEDA <= 0 .And. nTxMoeda != nRecMoed , IIF( lTxEdit .And. nRecMoed <> nTxMoeda .And. nRecMoed <> TRB->CTMOED , TRB->CTMOED , nRecMoed ) , IIF( lTxEdit , TRB->CTMOED , nTxMoeda ) ) )

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//?Verifica atraves do parametro MV_CALCCM se sera calculada a cor-?
//?recao monetaria.                                                ?
//?Caso o parametro nao exista, sera assumido "S"					?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
If GetMv("MV_CALCCM") == "S"
	nCorrecao := nValAtual - nValEmiss
Else
	nCorrecao := 0
Endif

If !lRetMoeda1
	//Converto para a moeda do titulo (necessario para a gravacao correta do SE5)
	nCorrecao := xMoeda(nCorrecao,1,nMoeda,,8)
EndIf

Return (nCorrecao)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ?F460NotIn    ?Autor ?Mauricio Pequim Jr    ?Data ?19/07/13 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Monta a express鉶 do NOT IN da query da liquidacao			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?FINA460                                                        潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
static function F460NotIN(lMarkAbt)

Local cTipos := MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM
			
cTipos	:=	StrTran(cTipos,',','/')
cTipos	:=	StrTran(cTipos,';','/')
cTipos	:=	StrTran(cTipos,'|','/')
cTipos	:=	StrTran(cTipos,'\','/')

cTipos := Formatin(cTipos,"/")

Return cTipos


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ?F460TrbArea  ?Autor ?Mauricio Pequim Jr    ?Data ?19/07/13 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?Determina os limites dos dados a serem apresentados na tela de 潮?
北?         ?selecao de titulos para a liquidacao (Codebase)                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?FINA460                                                        潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
static function F460TrbArea()

Local cRetorno := ""

//Gestao
If __lDefTop == NIL
	__lDefTop 	:= IfDefTopCTB() .and. !lUsaGE .and. !lOpcAuto // verificar se pode executar query (TOPCONN)
Endif

If !__lDefTop
	cRetorno := "xFilial('SE1')"
Endif

Return cRetorno

//-------------------------------------------------------------------
/*/{Protheus.doc} F460GetTit
Fun玢o que verifica retorna os vetores com os t韙ulos baixados e com 
os novos t韙ulos gerados, para uso na mensagem 鷑ica FinancialTrading
		
@return aBaixados - Vetor com os t韙ulos baixados
@return aNovos - Vetor com os novos t韙ulos gerados
@return cNroLiqui - Vari醰el com o n鷐ero da liquida玢o 

@author Pedro Pereira Lima
@version P12
@since	02/04/2014											
/*/
//-------------------------------------------------------------------
static function F460GetTit ()
Local aBaixados	:= {}
Local aNovos	:= {}
Local cLiquida	:= ''

aBaixados := aClone(__aBaixados) 
aNovos := aClone(__aNovosTit)
cLiquida := __cNroLiqui 
	
Return {aBaixados, aNovos, cLiquida} 

//-------------------------------------------------------------------
/*/{Protheus.doc} IntegDef
Integra玢o via mensagem 鷑ica

@author Pedro Pereira Lima
@version P12
@since	02/04/2014											
/*/
//-------------------------------------------------------------------
static function IntegDef( cXml, nType, cTypeMsg )  
Local aReturn := {}

aReturn := FINI460( cXml, nType, cTypeMsg )

Return aReturn

//-------------------------------------------------------------------
/*/{Protheus.doc} F460ChgVar
Altera o valor das vari醰eis INCLUI, ALTERA e EXCLUI, retornando um array
contendo os valores originais

@author Pedro Pereira Lima
@version P12
@since	04/01/2015											
/*/
//-------------------------------------------------------------------
static function F460ChgVar()
Local aRet := {,}

If Type("INCLUI") <> "U"
	aRet[1] := INCLUI
	If INCLUI
		INCLUI := .F.
	EndIf
EndIf

If Type("ALTERA") <> "U"
	aRet[2] := ALTERA
	If ALTERA
		ALTERA := .F.
	EndIf
EndIf

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} F460RetVar
Retorna os valores originais das vari醰eis INCLUI, ALTERA e EXCLUI

@author Pedro Pereira Lima
@version P12
@since	04/01/2015											
/*/
//-------------------------------------------------------------------
static function F460RetVar(aValOrig)
Default aValOrig := {}

If !Empty(aValOrig)
	
	If ValType(aValOrig[1]) == "L"
		INCLUI := aValOrig[1]
	EndIf

	If ValType(aValOrig[2]) == "L"
		ALTERA := aValOrig[2]
	EndIf

EndIf

Return
