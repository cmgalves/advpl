#Include "PROTHEUS.CH"

User Function MBPV001()             

Private lPeds := .T.
Private aCliPed	 := {}
Private oCbCanal
Private nCbCanal := 1
Private oCbFlag
Private nCbFlag  := 1
Private oCbOper
Private nCbOper  := 1
Private oCbUnidade
Private nCbUnidade := 1
Private oCbTpPv
Private ncbTpPv := 1
Private oGetCli
Private cGetCli := Space(6)
Private oGetVend
Private cGetVend := Space(6)
Private oGroup1
Private oGroup2
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7          
Private oSaySub
Private cSaySub
Private oGetSub
Private cGetSub := Space(6)
Private oSButton1          
Private oCbLc 
Private nCbLc := 1     
Private oGetOrc
Private cGetOrc := Space(6)
Private oSayOrc
Private Titulo := TFont():New("Arial",,025,,.T.,,,,,.F.,.F.)
Private Legenda := TFont():New("Calibri",,020,,.F.,,,,,.F.,.F.)//TFont():New("Arial",,010,,.T.,,,,,.F.,.F.)
Private Legend2 := TFont():New("Calibri",,022,,.F.,,,,,.F.,.F.)//TFont():New("Arial",,010,,.T.,,,,,.F.,.F.)
Static oDlg                                                                                  
Private nTotal := 0
Private aOpera := {}  
Private _nPosOK 
Private _nPosObs    
Private _nPosSta   
Private _nPosFil    
Private _nPosPed    
Private _nPosCli   
Private _nPosLj    
Private _nPosNcli  
Private _nPosVlr    
Private _nPosEms    
Private _nPosVld    
Private _nPosDia   
Private _nPosPre   
Private _nPosVnd    
Private _nPosMKP    
Private _nPosDsc    
Private _nPosEmb    
Private _nPosPrz    
Private _nPosOrg    
Private _nPosSOR    
Private _nPosRsc   
Private _nPosVlc    
Private _nPosPlc    
Private _nPosFpg    
Private _nPosVip
Private _nPosSer    
Private aVenda := {}
Private aZC0 := {}
Private lFiltBlq := .T.

//Carrega Operadores.....
aAdd(aOpera,'Todos')
aAdd(aZC0,{'Todos',''})
/*dbSelectArea('ZC0')
dbSetOrder(1)
ZC0->(dbGoTop())
While !ZC0->(Eof())
	aAdd(aOpera, AllTrim(ZC0->ZC0_NOME) )
	aAdd(aZC0,{AllTrim(ZC0->ZC0_NOME),ZC0->ZC0_GRPADM})
	ZC0->(dbSkip())
EndDo  */
         
aFlags := {}
dbSelectArea('SX5')
dbSetOrder(1)
dbSeek(xFilial('SX5')+'Z0')
While !SX5->(Eof()) .And. X5_TABELA == 'Z0'
	aAdd(aFlags,AllTrim(X5_CHAVE)+'-'+AllTrim(X5_DESCRI))
	SX5->(dbSkip())
EndDo                                                                     
SetKey( VK_F2,	{ || FWMsgRun(, {|| PrtOrca() }, "Processando", "Consultando Or็amento" ) } )
SetKey( VK_F4,	{ || FWMsgRun(, {|| PosCln()  }, "Processando", "Consultando Posi็ใo Cliente" ) } )
SetKey( VK_F5,	{ || FWMsgRun(, {|| fApvPed() }, "Processando", "Gravando Libera็ใo do Pedido" ) } )
SetKey( VK_F6,	{ || FWMsgRun(, {|| fGrHist() }, "Processando", "Atualizando Hist๓rico..." ) } )
SetKey( VK_F7,	{ || FWMsgRun(, {|| fAtuBrw() }, "Processando", "Atualizando Informa็๕es..." ) } )

cShortK := "[F2]Or็amento   [F4]Posi็ใo Cliente   [F5]Grava Libera็ใo   [F6]Atualiza Hist๓rico [F7]Atualiza Tela" 

//Carrega Vetor de Canais de Venda.

aAdd(aVenda,'T-TODOS')
aAdd(aVenda,'0-RCs')

DEFINE MSDIALOG oDlg TITLE "Aprova็ใo de Pedidos MB" FROM 000, 000  TO 500, 750 COLORS 0, 16777215 PIXEL

    @ 000, 000 GROUP oGroup1 TO 053, 374 OF oDlg COLOR 0, 16777215 PIXEL
    @ 054, 001 GROUP oGroup2 TO 232, 372 PROMPT "Filtros" OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 075, 010 MSCOMBOBOX oCbFlag VAR nCbFlag ITEMS aFlags SIZE 092, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 067, 009 SAY oSay1 PROMPT "Status" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 067, 115 SAY oSay2 PROMPT "Operador" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 075, 113 MSCOMBOBOX oCbOper VAR nCbOper ITEMS aOpera SIZE 092, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 067, 209 SAY oSay3 PROMPT "Canal" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 075, 208 MSCOMBOBOX oCbCanal VAR nCbCanal ITEMS aVenda SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 067, 291 SAY oSay4 PROMPT "Origem" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 075, 290 MSCOMBOBOX oCbUnidade VAR nCbUnidade ITEMS {"Todas","Guarani","Digitacao Sistema" } SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 096, 010 SAY oSay5 PROMPT "Cliente" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 104, 010 MSGET oGetCli VAR cGetCli SIZE 060, 010 F3 "SA1" OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 096, 093 SAY oSay6 PROMPT "Vendedor" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 104, 093 MSGET oGetVend VAR cGetVend SIZE 060, 010 F3 "SA3" OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 096, 176 SAY oSayOrc PROMPT "Pedido" SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 104, 176 MSGET oGetOrc VAR cGetOrc SIZE 070, 010 F3 "SC5" OF oDlg COLORS 0, 16777215 PIXEL

	@ 096, 266 SAY oSayTpPv PROMPT "Tipo Pedido" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 104, 266 MSCOMBOBOX oCbTpPv VAR ncbTpPv ITEMS {"Todos"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 126, 010 SAY oSayLc PROMPT "Ver LC ?" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 134, 010 MSCOMBOBOX oCbLc VAR ncbLc ITEMS {"Nใo","Sim"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 126, 100 SAY oSayLc PROMPT "Sub Classifica็ใo" SIZE 120, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 134, 100 MSGET oGetSub VAR cGetSub SIZE 070, 010 F3 "Z9" OF oDlg COLORS 0, 16777215 PIXEL
    
   
    @ 019, 120 SAY oSay7 PROMPT "Aprova็ใo de Pedidos MB." SIZE 137, 027 OF oDlg FONT Titulo COLORS 8388736, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 235, 344 TYPE 01 OF oDlg ENABLE ACTION IsBrwLib()
    //@ 235, 010 BUTTON oBtnCon 		PROMPT "Pre Analise "	SIZE 058, 012 OF oDlg Action U_ISAPVSER(aZC0[oCboper:NAT][2]) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return()                                                                 

Static Function IsBrwLib()

Local aSize    := MsAdvSize( .F. )  
Local aAdvSize := MsAdvSize(.F.)

Private oMsNewCrd := nil
Private aCols := {}
Private aHeadCrd := {}
Private aAlterFields := {'OK','STATUS','ZL_SUBSTAT'}

dbSelectArea('ZC0')
dbSetOrder(1)
If !ZC0->(dbSeek(xFilial("ZC0")+RetCodUsr()))
	MsgInfo('Usuแrio nใo cadastrado como operador de Back-Office.')
	Return(.F.)
EndIf


aObjects := {} 
AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
AAdd( aObjects, { 100, 100 , .t., .t. } )
AAdd( aObjects, { 100, 50 , .t., .f. } ) 

aInfo        := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aInfoAdvSize := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }
aObjCoords	 := {}

AAdd( aObjCoords, { 100, 035 , .T., .F., .T. } )
AAdd( aObjCoords, { 100, 100 , .T., .T. } )
AAdd( aObjCoords, { 100, 050 , .T., .F. } )

aPosObj1 := MsObjSize( aInfo, aObjects) 
aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )

/*
_cBloq := "SVLTC"
aBloq := {}

aAdd(aBloq,'S-Sintegra Pedido')
aAdd(aBloq,'V-Validade Serasa')
aAdd(aBloq,'L-Limite de Cr้dito')
aAdd(aBloq,'T-Titulos em Aberto')
aAdd(aBloq,'C-Cliente Novo/Inativo')


lFiltBlq :=  f_Opcoes(    @_cBloq    ,;    //Variavel de Retorno
                 "Analise Bloqueios"     ,;    //Titulo da Coluna com as opcoes
                 @aBloq    ,;    //Opcoes de Escolha (Array de Opcoes)
                 @_cBloq    ,;    //String de Opcoes para Retorno
                 NIL         ,;    //Nao Utilizado
                 NIL         ,;    //Nao Utilizado
                 .F.         ,;    //Se a Selecao sera de apenas 1 Elemento por vez
                 1     ,;    //Tamanho da Chave
                 5    ,;    //No maximo de elementos na variavel de retorno
                 .T.         ,;    //Inclui Botoes para Selecao de Multiplos Itens
                 .F.         ,;    //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
                 NIL         ,;    //Qual o Campo para a Montagem do aOpcoes
                 .F.         ,;    //Nao Permite a Ordenacao
                 .F.         ,;    //Nao Permite a Pesquisa    
                 .F.         ,;    //Forca o Retorno Como Array
                 Nil          ;    //Consulta F3    
                )

aFiltro := {}
_cBlqOri := "SVLTC"
For i := 1 To Len(_cBloq)
	_cPosBlq := SubStr(_cBloq,i,1)
	If _cPosBlq == '*'
		_cFiltBlq := SubStr(_cBlqOri,i,1)
		Do Case
			Case _cFiltBlq == 'S'
				AAdd(aFiltro,'SINTEGRA PEDIDO')
			Case _cFiltBlq == 'V'
				aAdd(aFiltro,'VALIDADE SERASA')
			Case _cFiltBlq == 'L'
				aAdd(aFiltro,'LIMITE DE CREDITO')
			Case _cFiltBlq == 'T'
				aAdd(aFiltro,'TITULOS EM ABERTO')
			Case _cFiltBlq == 'C'
				aAdd(aFiltro,'CLIENTE INATIVO')
		EndCase
	EndIf
Next i*/

DEFINE MSDIALOG oDlg FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE "Aprova็ใo de Credito" OF oMainWnd PIXEL

@ 000,010 Say "Status: "+ oCbFlag:AITEMS[oCbFlag:nAt] OF oDlg FONT Legenda PIXEL
If oCbOper:nAt == 1
	@ 010,010 Say "Operador: "+oCbOper:AITEMS[oCbOper:nAt] OF oDlg FONT Legenda PIXEL
Else
	@ 010,010 Say "Operador: "+oCbOper:AITEMS[oCbOper:nAt]+" Grupo: "+aZC0[oCboper:NAT][2] OF oDlg FONT Legenda PIXEL
EndIf
@ 020,010 Say "Canal: "+oCbCanal:AITEMS[oCbCanal:Nat] OF oDlg FONT Legenda PIXEL
@ 030,010 Say "Origem: "+oCbUnidade:AITEMS[oCbUnidade:Nat] OF oDlg FONT Legenda PIXEL

@ aPosObj1[3][1],010 BUTTON "Pos.Cliente"     Size 40,12 ACTION (PosClN())     OF oDlg Pixel
@ AposObj1[3][1],052 Button "Or็amento"       Size 40,12 Action (PrtOrca())    Of oDlg Pixel
//@ aPosObj1[3][1],094 Button "Hist๓rico"       Size 40,12 Action (BrwHist())    Of Odlg Pixel
@ aPosObj1[3][1],094 Button "Hist๓rico"       Size 40,12 Action (f200Hist())    Of Odlg Pixel

@ aPOsObj1[3][1],136 Button "Obs.Pedido"      Size 40,12 Action (U_IsObsPed(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil],oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed])) Of oDlg Pixel
@ aPosObj1[3][1],178 Button "Alt.Cliente"     Size 40,12 Action (Altcli())     Of oDlg Pixel
@ aPosObj1[3][1],220 Button "Alt.Lim.Cred"    Size 40,12 Action (AltLmtCli())  Of oDlg Pixel
@ aPosObj1[3][1],262 Button "Atual. Serasa"   Size 40,12 Action (U_ISALTSRS(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosCli],oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosLj])) Of oDlg Pixel
@ aPosObj1[3][1],304 Button "Documentos"      Size 40,12 Action (ZlViewDoc())  Of oDlg Pixel
@ aPosObj1[3][1],346 Button "Grava Libera็ใo" Size 40,12 Action ( fApvPed())   Of oDlg Pixel
@ aPosObj1[3][1],388 Button "Grava Hist."     Size 40,12 Action ( fGrHist())   Of oDlg Pixel
@ aPosObj1[3][1],430 Button "Or็amento PDF"   Size 40,12 Action ( U_IsRPed70(.F.,oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil],oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed]))   Of oDlg Pixel
@ aPosObj1[3][1],472 Button "Cockpit Pedido"  Size 40,12 Action (U_ISCRD400(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil],oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed]))   Of oDlg Pixel
@ aPosObj1[3][1],514 Button "Fechar"          Size 40,12 Action (oDlg:End())   Of oDlg Pixel

@ aPosObj1[3][1]+15,430 Button "Respons. RCA"   Size 40,12 Action ( RespRCA(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil],oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed]))   Of oDlg Pixel

cLinOk  := "U_200VFlag()"
cTudoOk := "AllwaysTrue()"   
cChange := "AllwaysTrue()"
cAltLn  := "AllWaysTrue()"
cVldDel := "AllwaysFalse()"

//FWMsgRun(, {|| CR200Ped() }, "Processando", "Consultando Pedidos para anแlise...")
Processa({||CR200Ped()})

oMsNewCrd := MsNewGetDados():New( aPosObj1[2,1],aPosObj1[2,2],aPosObj1[2,3],aPosObj1[2,4], GD_UPDATE, cLinOK, cTudoOk, "", aAlterFields,, 999, cChange, "", cVldDel, oDlg, aHeadCrd, aCols)

@ aPosObj1[3][1]+15,10 Say "Total: "+AllTrim( Str( Len(aCols) ) )+" Pedidos. R$ "+Transform(nTotal,"@E 99,999,999.99") Of Odlg Font Legend2 Pixel
@ aPosObj1[3][1]+35,10 Say cShortK Of Odlg Font Legenda Pixel

ACTIVATE MSDIALOG oDlg

Return()           

Static Function fAtuBrw()

	//FWMsgRun(, {|| CR200Ped() }, "Processando", "Consultando Pedidos para anแlise...")
	Processa({||CR200Ped()})
	oMsNewCrd:Acols := aCols
	FWMsgRun(, {|| oMsNewCrd:ForceRefresh() }, "Processando", "Atualizando Informa็๕es...")

Return()

Static Function fGrHist()
    
    If !Empty(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosOk])
    	MsgInfo('Nใo ้ possํvel gerar hist๓rico para pedido com Movimenta็ใo de Flag Registrada.')
    	Return()
    EndIf
	
	If ZC0->ZC0_SUBSTA == 'S'
		F200Grv(.F.)//Atualiza apenas Linha
		oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSOR] := oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosObs]
	Else
		MsgInfo('Operador sem acesso para registro de hist๓rico sem Classifica็ใo Interna.')
	EndIf

Return()


Static Function fApvPed()

If oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSOR] == oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosObs]
	MsgInfo('Pedido sem altera็ใo de hist๓rico. Nใo serแ executada nenhuma opera็ใo.')
	Return()
EndIf

If Empty(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosOK]) .And. Empty( oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSta] )
	MsgInfo('ษ necessแrio Classificar todo pedido para registro de hist๓rico.')
	Return()
EndIf
	
dbSelectArea("SL1")
dbSetOrder(1)
dbSeek(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil] + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed])

If !Empty(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSta])
	U_IsPedMail(Tabela("Z9",oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSta],.f.))  
EndIf

If oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosOK] == "A"
	U_IsPedMail("Pedido Antecipado")  
EndIf

If oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosOK] == "E"
	U_IsPedMail("Pedido em Espera")  
EndIf

If oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosOK] == "9"
	U_PedFlag9()
EndIf

F200Grv(.F.)//Atualiza apenas Linha
oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSOR] := oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosObs]
oMsNewCrd:aCols[oMsNewCrd:NAT][Len(oMsNewCrd:aHeader)+1] := .T.

Return()                            


Static Function MBPV01PED()                

Local _n
Local n
Local _cArq
Local _cPicture		:= ""
Local vResult
Local _nSalClib
Local _nPedClib
Local _Metrb
Local nConLin   	:= 0
Local _nTmpSaldo	:= 0
Local aGet      	:= {"","","",""}
Local nlin      	:= 3

Private aParam    	:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07}
Private aArea 	  	:= GetArea()
Private aAlias	 	:= {}
Private aFerase   	:= {}
Private aSavAhead 	:= If(Type("aHeadCrd") == "A",aHeadCrd,{})
Private aSavAcol  	:= If(Type("aCols") == "A"	,aCols	,{})
Private cCadastro 	:= "Analise da Situacao do Cliente"
Private cCgc	  	:= " "
Private cMoeda    	:= " " + GETMV("MV_SIMB" + GETMV("MV_MCUSTO"))
Private nSavN     	:= If(Type("aCols") == "A",n,{})
Private _nMCOMPRA 	:= 0
Private _nMSALDO  	:= 0
Private _GRUPO    	:= ""
Private _Cod      	:= ""
Private _Loja     	:= ""
Private _NOME     	:= ""
Private _CGC      	:= ""
Private _TEL      	:= ""
Private _VENCLC   	:= CtoD("  /  /  ")
Private _cCred    	:= 0
Private _PRICOM   	:= CTOD("")
Private _ULTCOM   	:= CTOD("")
Private _RISCO   	:= " "
Private _DTULCHQ 	:= CTOD("")
Private _DTULTIT 	:= CTOD("")
Private oDlg
Private _nRegSa1  	:= Recno()
Private _aLimCli  	:= {}
Private _aMsalCli 	:= {}
Private _aMsalAux	:= {}
Private _aMcomCli 	:= {}
Private _aPcomCli 	:= {}
Private _aUcomCli 	:= {}
Private _aSalCli  	:= {}
Private _aTitCli  	:= {}
Private _aDTitCli 	:= {}
Private _aChDevCli	:= {}
Private _aDtChCli 	:= {}
Private _aMatrCli 	:= {}
Private _aRisCli  	:= {}
Private _aMedAtCli	:= {}
Private _aSDupmCli	:= {}
Private _aItems 	:= {}
Private _nItems
Private _dData 		:= CTOD("")
Private _nMComCli 	:= 0
Private _nMSalCli 	:= 0
Private _nMSalCliAux:= 0
Private nCasas 		:= GetMv("MV_CENT")
Private _NUMPED 	:= 0
Private _VALNPED 	:= 0
Private _TOTVPED 	:= 0
Private _TOTVPED2 	:= 0
Private _bNUMPED 	:= 0
Private _bVALNPED 	:= 0
Private _bTOTVPED 	:= 0
Private _bTOTVPED2 	:= 0
Private _cNUMPED 	:= 0
Private _cVALNPED 	:= 0
Private _cTOTVPED 	:= 0
Private _cTOTVPED2 	:= 0
Private lFiltSer  	:= .F.
Private _cAlias     := GetNextAlias()                                         
Private oVip        := LoadBitmap( GetResources(), "FWSTD_MNU_CUT")
Private oStd        := LoadBitmap( GetResources(), "FWSTD_PNL_BDR")//FWSTD_PNL_BDR
Private oCrdVip     := LoadBitmap( GetResources(), "FWSTD_MNU_CUT" )
//BUDGETY
//COMPTITL_MDI
//COMPTITL
Private nValor      := 0


MV_PAR01	:= dDatabase - 3600
MV_PAR02	:= dDatabase
MV_PAR03	:= dDatabase - 3600
mv_PAR04	:= dDatabase + 720
MV_PAR06	:= "   "
MV_PAR07	:= "ZZZ"
ntotal := 0

/*
If ZC0->ZC0_FSERAS == "S"
	If MsgYesNo('Analisa somente bloqueios do Serasa ?')
		lFiltSer := .T.
	EndIf
EndIf
*/
_aCamp	:= {}
aCols	:= {}

ProcRegua(0)

If Select("TRLP") > 0
	LjMsgRun('Apagando Arquivo Temporแrio..')
	TRLP->(dbCloseArea())
EndIf

aHeadCrd := {}

AADD(aHeadCrd, {"Sit"				  ,"OK"		    	,"@!"			,1	,0,".T.",,"C",""} )
AADD(aHeadCrd, {"Status"			  ,"STATUS"	    	,""				,40	,0,"U_200VldSt()",,"C",""} )
AADD(aHeadCrd, {"Classif."            ,"ZL_SUBSTAT"     ,""             ,6  ,0,".T.",,"C", "Z9" } )
AADD(aHeadCrd, {"Pedido"			  ,"Pedido"		    ,""				,6  ,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Valor Real"		  ,"ValorReal"   	,"@E 999,999.99",10	,2,".F.",,"N",""} )
aAdd(aHeadCrd, {"Vip"                 ,"VIP"            ,"@BMP"         ,1, ,0,".F.",," ",""} )
aAdd(aHeadCrd, {"Credito"             ,"VIPCRED"        ,"@BMP"         ,1, ,0,".F.",," ",""} )
AADD(aHeadCrd, {"Cliente"			  ,"Cliente"		,""				,6  ,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Lj"				  ,"Loja"			,""				,2  ,0,".F.",,"C",""} )
AaDD(aHeadCrd, {"Nome Cliente"        ,"NOMECLI"        ,""             ,30 ,0,".F.",,"C",""} )
aAdd(aHeadCrd, {"Bloqueios"           ,"BLOQUEIO"       ,""             ,20 ,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Desconto"			  ,"DESC"			,"@E 999.9%"	,20	,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Prazo / Pagamento"	  ,"PRAZO"		    ,""  			,60	,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Emissao"			  ,"Emissao"		,""  			,8	,0,".F.",,"D",""} )
AADD(aHeadCrd, {"Vendedor"			  ,"Vendedor"		,""				,6	,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Origem"		 	  ,"ORIGEM"		    ,""  			,30	,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Status Origem"		  ,"StatusOrig"	    ,""  			,40	,0,".F.",,"C",""} )
AADD(aHeadCrd, {"Risco"				  ,"Risco"		    ,""				,1 	,0,".F.",,"C",""} )


_nPosOK 	:= aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "OK" })
_nPosObs    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "STATUS" })  
_nPosSta    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "ZL_SUBSTAT" })   
_nPosPed    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "PEDIDO" })
_nPosCli    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "CLIENTE" })
_nPosLj     := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "LOJA" }) 
_nPosNcli   := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "NOMECLI" }) 
_nPosVlr    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "VALORREAL" })
_nPosEms    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "EMISSAO" }) 
_nPosVnd    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "VENDEDOR" })
_nPosDsc    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "DESC" })
_nPosPrz    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "PRAZO" })
_nPosOrg    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "ORIGEM" })
_nPosSOR    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "STATUSORIG" })
_nPosRsc    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "RISCO" })
_nPosFpg    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "FORMAPG" })
_nPosVip    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "VIP" })
_nPosBlq    := aScan(aHeadCrd	,{|y| Upper(Alltrim( y[2] )) == "BLOQUEIO" })


_cQuery := " SELECT C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_ZZNOMFC, C5_CONDPAG, C5_TABELA, C5_VEND1,C5_FRETEMB,C5_ZZOBPED, C5_ZZOBEXP,C5_ZZDTENT,C5_ZZOBSRG,C5_ZZOBCAD,C5_XPEDEMP, C5_XEST, C5_XCIDADE,*
_cQuery += "FROM ERPPROD..SC5010 SC5 "
_cQuery += "WHERE C5_FILIAL = '01' " 
_cQuery += "AND SC5.C5_XPEDEMP !=   '  ' AND SUBSTRING(SC5.C5_XPEDEMP,1,1) NOT IN('.','*')  "
_cQuery += "AND SC5.C5_NOTA =  '      '  AND SC5.D_E_L_E_T_ = ' ' "

If !Empty(cGetVend)
	_cQuery += " AND SC5.C5_VEND1 = '" + cGetVend + "'"
EndIf                       

If !Empty(cGetCli)
	_cQuery += " AND SC5.C5_CLIENTE = '" + cGetCli + "'"
EndIf

If !Empty(cGetOrc)
	_cQuery += " AND SC5.C5_NUM = '" + cGetOrc + "'"
EndIf

If oCbOper:NAT > 1
	If !Empty(aZC0[oCboper:NAT][2])
		If aZC0[oCboper:NAT][2] == '999999'
			_cQuery += " AND A1_UCLASCL = 'V' "	
		Else
			_cQuery += " AND ( A3_UTABLE5 = '      ' Or A3_UTABLE5 = '"+aZC0[oCboper:NAT][2]+"' ) "
		EndIf
	EndIf             
EndIf                                                                    

If oCbCanal:NAT > 1
	If SubStr(oCbCanal:AITEMS[oCbCanal:NAT],1,1) =='7'
		_cQuery += " AND A3_TIPVEND IN('7','9') "
	Else
		_cQuery += " AND A3_TIPVEND ='"+SubStr(oCbCanal:AITEMS[oCbCanal:NAT],1,1)+"' "
	EndIf
EndIf

If oCbUnidade:NAT > 1
	If oCbUnidade:NAT == 2
		_cQuery += " AND L1_FILIAL ='03' "	
	ElseIf oCbUnidade:NAT == 3
		_cQuery += " AND L1_FILIAL IN('94','93') "
	EndIf
EndIf

_cQuery += " AND L1_CLIENTE = A1_COD "
_cQuery += " AND L1_LOJA = A1_LOJA "
_cQuery += " AND L2_NUM = L1_NUM "
_cQuery += " AND L2_FILIAL = L1_FILIAL "
_cQuery += " AND SL1.D_E_L_E_T_ <> '*' "
_cQuery += " AND SA3.D_E_L_E_T_ <> '*' "
_cQuery += " AND SE4.D_E_L_E_T_ <> '*' "
_cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
_cQuery += " AND SL2.D_E_L_E_T_ <> '*' "
 
_cQuery += " GROUP BY L1_FILIAL,L1_NUM,L1_CLIENTE,L1_LOJA,A1_NOME,L1_UDTORIG,L1_DTLIM,L1_FLAG,L1_VEND,L1_UFORMA,L1_UPRAZO,L1_FORMPG,L1_CONDPG,E4_DESCRI,A1_RISCO,A1_LC,A1_VENCLC, A1_UDTSERA, E4_COND,A1_METR,A1_GRUPO,A1_COD,A1_LOJA,A1_NOME,A1_CGC,A1_TEL,A1_VENCLC,A1_UCRED, l1_PDV,L1_NUMORIG,A3_UTABLE5, A1_UCLASCL"

_cQuery += " ORDER BY A1_UCLASCL DESC, L1_CLIENTE, L1_LOJA, L1_NUMORIG, L1_FILIAL "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),(_cAlias),.T.,.T.)

ProcRegua(0)

_cOrcto := Space(6)
nvalor := 0
n 	:= 0

If !lFiltBlq
	MsgAlert('Nใo Serใo Filtrados Status de Bloqueios','Libera็ใo de Pedidos')
EndIf

WHILE !(_cAlias)->(EOF())

	IncProc('Verificando pedido ' + (_cAlias)->L1_FILIAL+(_cAlias)->L1_NUM+' '+AllTrim((_cAlias)->A1_NOME) )

	If lFiltSer
		If !BlqSerasa( (_cAlias)->(L1_FILIAL),(_cAlias)->(L1_NUM) )
			(_cAlias)->(DbSkip())
			Loop
		EndIf
	EndIf
	
	//Valida็ใo para visualiza็ใo apenas de pedidos cx aberta / cx fechada
	If oCBtpPv:NAT > 1
		If oCBtpPv:NAT == 2
			If !VerCx((_cAlias)->L1_FILIAL, (_cAlias)->L1_NUM)
				(_cAlias)->(dbSkip())
				Loop
			EndIf
		Else
			If VerCx((_cAlias)->L1_FILIAL, (_cAlias)->L1_NUM)
				(_cAlias)->(dbSkip())
				Loop
			EndIf
		EndIf
	EndIf

	//----------------- bloco para filtrar pedidos de acordo com os bloqueios selecionados ------------
	If lFiltBlq
		lAdd := .T.
		_cBloq := RetBlq((_cAlias)->(L1_FILIAL),(_cAlias)->(L1_NUM))
		For _filt := 1 To Len(aFiltro)
			If aFiltro[_Filt] $ _cBloq .And. lAdd
				lAdd := .F.
			EndIf
		Next _filt 
		If !lAdd
			(_cAlias)->(dbSkip())
			Loop
		EndIf
	EndIf
	//----------------------------------------------------------------------------------------------
	_Status := "." + Space(98) + "."
	_cOrig  := "."



	dbSelectArea("SZL")
	dbSetOrder(1)
	IF dbSeek((_cAlias)->(L1_FILIAL+L1_NUM))
		WHILE !SZL->(EOF()) .AND. (_cAlias)->(L1_NUM) == SZL->ZL_NUM
			If SZL->ZL_OBS $ ' /X/A'
				SZL->(DbSkip())
				Loop
			EndIf     
			_Status := IIF (Empty(ZL_OBS),"." + Space(199) + ".",ZL_OBS)
			_cOrig  := DtoC(ZL_DATA) + " " + ZL_HORA + " " + ZL_RESPONS 
			_cSubSt := SZL->ZL_SUBSTAT
			SZL->(dbSkip())
		END
	EndIf
	
	If !Empty(cGetSub)
		If cGetSub != _cSubSt
			(_cAlias)->(dbSkip())
			Loop
		EndIf
	EndIf
	
	dbSelectArea(_cAlias)
	
	If !Empty(cGetSub) .And. Empty(_cSubSt)
		(_cAlias)->(dbSkip())
		Loop
	EndIf

	AADD(aCols,Array(Len(aHeadCrd) + 1))

	nLin := Len(aCols)
	n    := Len(aCols)
		
	If oCbLc:Nat == 1
		aLc := {0,0,0,0}
	Else
		aLc := _VerLc((_cAlias)->L1_FILIAL,(_cAlias)->L1_NUM)
	EndIf
	
	dbSelectArea('SL1')
	dbSetOrder(1)
	dbSeek( (_cAlias)->(L1_FILIAL)+(_cAlias)->(L1_NUM))
	 
	aCols[nLin,Len(aHeadCrd)+1]	:= .F.
	aCols[nLin,_nPosOK]  := " "
	aCols[nLin,_nPosObs] := _Status
	aCols[nLin,_nPosSta] := _cSubSt
	aCols[nLin,_nPOsFil] := (_cAlias)->L1_FILIAL
	aCols[nLin,_nPosPed] := (_cAlias)->L1_NUM
	aCols[nLin,_nPosCli] := (_cAlias)->L1_CLIENTE
	aCols[nLin,_nPosLj]  := (_cAlias)->L1_LOJA
	aCols[nLin,_nPosnCli]:= (_cAlias)->A1_NOME
	aCols[nLin,_nPosVlr] := (_cAlias)->VLRLIQ
	aCols[nLin,_nPosEms] := STOD((_cAlias)->L1_UDTORIG)
	aCols[nLin,_nPosVld] := STOD((_cAlias)->L1_DTLIM)
	aCols[nLin,_nPosDia] := " " 
	aCols[nLin,_nPosPre] := (_cAlias)->L1_NUMORIG  
	aCols[nLin,_nPosVnd] := (_cAlias)->L1_VEND
	aCols[nLin,_nPosMkp] := aLc[4]
	aCols[nLin,_nPosDsc] := ( aLc[3] / ((_cAlias)->VLRLIQ / 2) ) * 100 
	aCols[nLin,_nPosEmb] := If(Val(SL1->L1_FILIAL) > 90,(SL1->L1_ISSEMB / 2) * 100,If(SL1->L1_ISSEMB == 2,100,35))
	aCols[nLin,_nPosVip] := If((_cAlias)->VIP $ "V/A", oVip, oStd)//oVip
	aCols[nLin,_nPosVcr] := If((_cAlias)->VIP $ "C/A", oCrdVip, oStd)//oVip
	aCols[nLin,_nPosBlq] := RetBlq((_cAlias)->(L1_FILIAL),(_cAlias)->(L1_NUM))
	aCols[nLin,_nPosGrp] := (_cAlias)->GRPADM
	aCols[nLin,_nPosVpr] := fVlrPre( (_cAlias)->L1_NUMORIG )
	aCols[nLin,_nPosSer] := STOD((_cAlias)->A1_UDTSERA)
	
	cCondp1 		:= ''
	
	IF AllTrim( (_cAlias)->L1_CONDPG ) == 'CN'
		cCndPk	:= U_TrCondPkt( AllTrim( (_cAlias)->L1_UPRAZO ),'')
		cCondp1 := cCndPk
	ELSE
		cCondp1 := (_cAlias)->E4_DESCRI
	EndIf
	
	aCols[nLin,_nPosPrz]	:= cCondp1
	aCols[nLin,_nPosOrg]	:= _cOrig
	aCols[nLin,_nPosSOR]	:= _Status

	If (_cAlias)->A1_RISCO == " "
		aCols[nLin,_nPOsRSC] := "."
	Else
		aCols[nLin,_nPosRsc] := (_cAlias)->A1_RISCO
	EndIf                       
	
	aCols[nLin,_nPosPlc] := (_cAlias)->A1_LC
	aCols[nLin,_nPosvlc] := STOD((_cAlias)->A1_VENCLC)	
	aCols[nLIN,_nPosFpg] := cCondp1	

	nTotal	+= (_cAlias)->VLRLIQ

	dbSelectArea(_cAlias)

    (_cAlias)->(dbSkip())

EndDo
(_cAlias)->(dbCloseArea())
                                                                              
Return()              

User Function 200VldSt()

Local lRet := .T.

Local lAlt := .T.//oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil]+oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosObs] != oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil]+oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSor]

If lAlt
	FWMsgRun(, {|| oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosSta] := Space(6) }, "Processando", "Atualizando Informa็๕es..." ) 
	oMsNewCrd:Refresh()
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ _VerLc   บAutor  ณ                    บ Data ณ  07/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _VerLc(_cFilp,_cNumP)

Local _nLc		:= 0
Local _nCust 	:= 0
Local _nCusto 	:= 0
Local _nVend 	:= 0
Local _nDescf	:= 0
Local _aArea 	:= GetArea()

dbSelectArea('SL1')
dbSetOrder(1)
dbSeek(_cFilP+_cNumP)

dbSelectArea('SL2')
dbSetOrder(1)
dbSeek(_cFilP + _cNumP)
While !SL2->(Eof()) .And. SL2->L2_FILIAL + SL2->L2_NUM == _cFilP + _cNumP



	    If SL1->L1_UDTORIG < CTOD("18/05/20")
	
	        _nCusto:=U_IsCstAnt(SL2->L2_PRODUTO,SL2->L2_FILIAL) * SL2->L2_QUANT
	        If _nCusto==0
	           _nCusto		:=  U_RetCusto(SL2->L2_PRODUTO,SL2->L2_FILIAL) * SL2->L2_QUANT
	        EndIf
	    Else
	     	_nCusto := U_RetCusto(SL2->L2_PRODUTO,SL2->L2_FILIAL) * SL2->L2_QUANT
	    EndIf    
		
     
	//_nCusto := U_RetCusto(SL2->L2_PRODUTO,SL2->L2_FILIAL) * SL2->L2_QUANT
	
	If Retfield('SB1',1,xFilial('SB1') + SL2->L2_PRODUTO,'B1_GRUPO') == "014 " .And. Retfield('SB1',1,xFilial('SB1') + SL2->L2_PRODUTO,'B1_PROC') == "018103" .And. Val(_cFilP) <= 10

           If SL1->L1_UDTORIG < CTOD("18/05/20")
               _nCusto:=U_IsCtAntZ(SL2->L2_PRODUTO)* SL2->L2_QUANT
               If _nCusto==0
		          _nCusto := CustZ(SL2->L2_PRODUTO)*SL2->L2_QUANT
		       EndIf    
	       //nCusto:= TrCustoZ(SL1->L1_NUM,TRO->L2_PRODUTO,SL1->L1_FILIAL,cFilCust,SL1->L1_NUMORIG)
	        Else
               _nCusto := CustZ(SL2->L2_PRODUTO)*SL2->L2_QUANT	        
            EndIf   

		//_nCusto := CustZ(SL2->L2_PRODUTO)
		
	EndIf   
	                                               
    _nCust := _nCust + _nCusto
	_nVend += SL2->L2_VLRITEM

	SL2->(DbSkip())

EndDo

_nLc := ((((_nVend-_nDescf) / _nCust)-1) * 100)

Return({_nCust,_nVend,_nDescf,_nLc})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PosCln()

Local nPosOri := oMsNewCrd:NAT
Local aArea := GetArea()

dbSelectArea('SA1')
dbSetOrder(1)
If dbSeek(xFilial('SA1') + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosCli] + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosLj])
	U_ISCLIPOS()  
Else
	MsgInfo('Cliente Nใo Encontrado')
EndIf
RestArea(aArea)

oMsNewCrd:Goto(nPosOri)
oMsNewCrd:OBROWSE:SetFocus()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuCred(_cClient,_cLoja)

Local aArea   := GetArea()
Local lAlt    := .F.
Local _nNewCr := 0
Local _nLmt   := 0

_nLmt	:= 0
_nNewCr	:= 0
lAlt 	:= .F.
	
dbSelectArea('SA1')
dbSetOrder(1)
dbSeek(xFilial('SA1') + _cClient + _cLoja)
_nPedCli  := _fPedCli()
_nSalCred := U_RetSalCred(SA1->A1_COD,SA1->A1_LOJA)[2]
_nLmt :=  SA1->A1_LC - ( _nSalCred + _nPedCli )
	
If _nLmt < 0
	_nLmt 	:= _nLmt * -1
	_nNewCr := SA1->A1_LC + _nLmt
	lAlt 	:= .T.
EndIf
	             
If lAlt .And. _nNewCr > 0
	f200UpdC(_nNewCr)
EndIf

RestArea(aArea)

Return()
                                                                  

User Function 200VFlag()

Local lRet := .T.

If !( oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosoK] $ ZC0->ZC0_FLAGEN ) .And. !Empty(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosoK])
	MsgInfo('Flag nใo permitido para envio. Verificar acesso com seu superior.')
	lRet := .F.
EndIf

Return(lRet)                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Custz     บAutor  ณ Microsiga         บ Data ณ  08/16/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Custz(_cProd)

Local _nCusto	:= 0
Local aArea 	:= GetArea()
Local _cQuery 	:= "SELECT B1_UPRC * 1.1 CUSTO FROM SB1020 WHERE B1_FILIAL = '  ' AND B1_COD = '" + _cProd + "' AND D_E_L_E_T_ =' ' "     

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"CBZ",.T.,.T.)

_nCusto := CBZ->CUSTO

CBZ->(dbCloseArea())

RestArea(aArea)

Return(_nCusto)                                                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function prtorca()

Local aArea := GetArea()
Local nPosOri := oMsNewCrd:NAT
dbSelectArea("SL1")
dbSetOrder(1)
dbSeek(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil]+oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed])

U_ORCA(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil])

RestArea(aArea)

oMsNewCrd:Goto(nPosOri)
oMsNewCrd:OBROWSE:SetFocus()

Return()                                                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BrwHist()

Private aHist := {}

_QUERY := " SELECT ZL_DATA,ZL_HORA,ZL_RESPONS,ZL_STATUS,ZL_OBS "
_QUERY += " FROM " + RetSqlName("SZL") + " "
_QUERY += " WHERE ZL_FILIAL = '" + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil] + "' "
_QUERY += " AND ZL_NUM ='" + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed] + "' "

_QUERY += " AND D_E_L_E_T_<>'*' "
_QUERY += " ORDER BY ZL_DATA,ZL_HORA "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_Query),"TRH",.T.,.T.)

While !Eof()
	aAdd(aHist,{dToc( Stod(TRH->ZL_DATA) ),TRH->ZL_HORA, TRH->ZL_RESPONS,TRH->ZL_STATUS,TRH->ZL_OBS})
	TRH->(dbSkip())
EndDo

dbCloseArea("TRH")

If Len(aHist) < 1
	MsgInfo("NรO EXISTE HISTำRICO PARA O ORวAMENTO.")
	Return .F.
EndIf

	//@ 200,001 TO 465,700 DIALOG oDlg8 TITLE OemToAnsi("Hist๓rico do Or็amento " + aCols[N,4]) of Odlg Pixel
	DEFINE MSDIALOG oDlg8 TITLE "Hist๓rico do Or็amento" FROM 200, 000  TO 500, 750 COLORS 0, 16777215 PIXEL

	@ 002,002 ListBox oListBox Var cVar Fields Header "Data","Hora","Responsแvel","Status","Obs." Size 370, 120 Pixel

	oListBox:SetArray (aHist)
	oListBox:bLine := {||{ aHist [oListBox:nAt, 1],aHist [oListBox:nAt, 2],aHist [oListBox:nAt, 3],aHist [oListBox:nAt, 4],aHist [oListBox:nAt, 5] } }

	//@ 123,312 BmpButton Type 1 Action(oDlg8))
	DEFINE SBUTTON oSButton1 FROM 123, 312 TYPE 01 OF oDlg8 ENABLE ACTION (Odlg8:End())

Activate Dialog oDlg8 Center

//dbSelectArea("TRLP")

Return()         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltCli()

Private aArea	:= GetArea()
Private cTitOri	:= "Atualiza Cliente"
//Private aMemos	:= {{"A1_CODMARC","A1_VM_MARC"},{"A1_OBS","A1_VM_OBS"}}

dbSelectArea('SA1')
dbSetOrder(1)
SA1->(dbSeek(xFilial('SA1') + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosCli] + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosLj]))

cCadastro	:= "Altera็ใo do Cliente: " + SA1->A1_COD + '/' + SA1->A1_LOJA + " - " + SA1->A1_NOME
Privat Altera  := .T.
Private Inclui := .F.
//aRAnt 		:= aRotina
//aRotina		:= {	{ "Pesquisar"  	,"AxPesqui"       ,0,1 },;  //"Pesquisar"
//					{ "Visualizar" 	,"AxVisual"       ,0,2 },; //"Visualizar"
//					{ "Incluir"  	,"AxInclui"       ,0,3 },;  //"Incluir"
//					{ "Alterar"  	,"AxAltera"       ,0,4 }}   //"Alterar"

AxAltera("SA1",SA1->(RECNO()),4)

//aRotina 	:= aRAnt
//Altera		:= .F.
//cCadastro 	:= cTitOri

RestArea(aArea)
Return                                                                                                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltLmtCli()

Private aArea := GetArea()

dbSelectArea('SA1')
dbSetOrder(1)
dbSeek(xFilial('SA1') + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosCli] + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosLj])

U_IsAltLc()

RestArea(aArea)

Return()
            
Static Function ZlViewDoc()

Local nPOsOri := oMsNewCrd:NAT
Local aArea := GetArea()
dbSelectArea('SL1')
dbSetOrder(1)
dbSeek(oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil]+oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed])

U_ISMSDOC()

RestArea(aArea)
oMsNewCrd:Goto(nPosOri)
oMsNewCrd:OBROWSE:SetFocus()

Return()  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ _GravaNW บAutor  ณ Microsiga          บ Data ณ  09/16/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function F200Grv(lTodos)

Local _nFilial	:= ""
Local _numOrc	:= ""
Local _aAr		:= {}                                           
Local cFlag     := SubStr(oCbFlag:AITEMS[oCbFlag:Nat],1,1)
Local lAtuLin   := .F.
Local cFlagLib  := ZC0->ZC0_FLAGEN
Local cLib      := ''
Default lTodos  := .T.

vQtds	:= 0
vEntrou	:= "N"
vAchou	:= "N"
vPesqF5	:= ""

If ltodos
	nIni := 1 
	nFim := Len(oMsNewCrd:aCols)
Else
	nIni := oMsNewCrd:NAT
	nFim := oMsNewCrd:NAT
EndIf                           

For _n := nIni To nFim

	_lMail  := .F.
	lAtuLin := oMsNewCrd:aCols[_n][_nPosObs] != oMsNewCrd:aCols[_n][_nPosSor]
	cLib    := oMsNewCrd:aCols[_n][_nPosOk]
	lDel    := oMsNewCrd:aCols[_n][Len(oMsNewCrd:aHeader)+1]
	
	If !(cLib $ ZC0->ZC0_FLAGEN)
		MsgInfo('Voc๊ nใo possui permissใo para enviar pedidos ao Flag '+cLib)
		Return()
	EndIf

	If lDel .Or. !lAtuLin
		If !lTodos
			MsgInfo('Pedido '+SL1->L1_NUM+' Sem altera็ใo ou jแ atualizado. Nใo haverแ movimenta็ใo','Aprova็ใo de Pedidos')
		EndIf
		Loop             
	EndIf
	
	_nFilial := oMsNewCrd:aCols[_n][_nPosFil]
	_numOrc	 := oMsNewCrd:aCols[_n][_nPosPed]
	
	dbSelectArea("SL1")
	dbSetOrder(1)
	dbSeek(_nFilial + _numOrc)
	
	If SL1->L1_USINTEG != "1" .And. GetMv('MV_VLDSINT') .And. cFlag == "1" .And. !Empty(cLib)
		MsgInfo('Pedido ' + SL1->L1_NUM + '/' + SL1->L1_FILIAL + ' Nใo pode ser movimentado enquanto nใo for liberado por informa็๕es do Sintegra','Valida็ใo do Pedido')
		Loop
	EndIf 
	
	If cFlag == '1'
		MsgInfo('Flag Nใo Implementado')
		Return()	
		
	ElseIf cFlag $ 'A/2/5/N/6/7/8'
		
			Do Case
				Case Empty(cLib) //Apenas Altera็ใo de Status (Nใo Modifica Flag)
					LogZl()
					If !lTodos
						MsgInfo('Atualizado Hist๓rico do pedido '+SL1->L1_NUM+' sem movimenta็ใo de Flag.','Aprova็ใo de Pedidos')
					EndIf
				Case cLib $ 'A/E/N/L'
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cLib
					MsUnLock('SL1')
					LogZl()						
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag '+cLib,'Aprova็ใo de Pedidos')
					EndIf
				Case cLib == '6'
					
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cLib
					MsUnLock('SL1')
					LogZl()
					AtuPeds()
					AtuCred(SL1->L1_CLIENTE,SL1->L1_LOJA)
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag 6','Aprova็ใo de Pedidos')
					EndIf
					 				
				Case cLib == '1'      
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cLib
					MsUnLock('SL1')
					LogZl()						
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag '+cLib,'Aprova็ใo de Pedidos')
					EndIf		
				//'A/2/5/N/6/7/8'
				Case cLib $ 'E/L/7/6/8'
					
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cLib
					MsUnLock('SL1')
					LogZl()						
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag '+cLib,'Aprova็ใo de Pedidos')
					EndIf
				
			   	Case cLib == '9'
					
					If !( '9' $ cFlagLib )
						MsgInfo("Usuario nao permitido para utilizar Flag 9 no orcamento ","ATENCAO")
						Loop
					Else
						If MsgYesNo('Confirma Cancelamento do Pedido ' + SL1->L1_FILIAL + '/' + SL1->L1_NUM + ' ?')
							U_PedFlag9()
						EndIf
						Loop
					EndIf
			End Case
			
	ElseIf cFlag == '3'
	
		Do Case
			Case cLib == '6'
				If Filtro() //Se passou pelo filtro, vai para o 6
		
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cLib
					MsUnLock('SL1')
					LogZl()
					RecLock('SZL',.T.)
					Replace ZL_FILIAL 	With oMsNewCrd:aCols[_n][_nPosFil]
					Replace ZL_NUM 		With oMsNewCrd:aCols[_n][_nPosPed]
					Replace ZL_CLIENTE 	With oMsNewCrd:aCols[_n][_nPosCli]
					Replace ZL_LOJA 	With oMsNewCrd:aCols[_n][_nPosLj]
					Replace ZL_VEND 	With oMsNewCrd:aCols[_n][_nPosVnd]
					Replace ZL_SUBSTAT  With oMsNewCrd:aCols[_n][_nPosSta]
					Replace SZL->ZL_DATA 	With Date()
					Replace SZL->ZL_HORA 	With Time()
					Replace SZL->ZL_RESPONS With "AUTOMATICO"
					Replace SZL->ZL_STATUS 	With "A"
					Replace SZL->ZL_STATAPV With "6"
					Replace SZL->ZL_OBS 	With "PEDIDO APROVADO PELO FILTRO AUTOMATICO"
					Replace SZL->ZL_SEQUENC With "000000"
					MsUnLock('SZL')
					
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag 6','Aprova็ใo de Pedidos')
					EndIf 
		
				Else
					
					cFlagCrd := If(SubStr(SL1->L1_NUM,1,1)== 'N','N','2')
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cFlagCrd
					MsUnLock('SL1')
					LogZl()
					//AtuCred(SL1->L1_CLIENTE,SL1->L1_LOJA)
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag '+cFlagCRD,'Aprova็ใo de Pedidos')
					EndIf
		
				Endif
				
			Case cLib == '9'
					
				If !( '9' $ cFlagLib )
					MsgInfo("Usuario nao permitido para utilizar Flag 9 no orcamento ","ATENCAO")
					Loop
				Else
					If MsgYesNo('Confirma Cancelamento do Pedido ' + SL1->L1_FILIAL + '/' + SL1->L1_NUM + ' ?')
						U_PedFlag9()
					EndIf
					Loop
				EndIf
				
			Case cLib == '1'      
				RecLock('SL1',.F.)
				Replace SL1->L1_FLAG With cLib
				MsUnLock('SL1')
				LogZl()						
				If !lTodos
					MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag '+cLib,'Aprova็ใo de Pedidos')
				EndIf
				
			Case cLib $ 'A/E/N/L/7/6'
					RecLock('SL1',.F.)
					Replace SL1->L1_FLAG With cLib
					MsUnLock('SL1')
					LogZl()						
					If !lTodos
						MsgInfo('Pedido '+SL1->L1_NUM+' Enviado para o Flag '+cLib,'Aprova็ใo de Pedidos')
					EndIf
					
			Case Empty(cLib) //Apenas Altera็ใo de Status (Nใo Modifica Flag)
				LogZl()
				If !lTodos
					MsgInfo('Atualizado Hist๓rico do pedido '+SL1->L1_NUM+' sem movimenta็ใo de Flag.','Aprova็ใo de Pedidos')
				EndIf		
				
			EndCase
	
	EndIf
	

	Next _n
	
RETURN()                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LogZl()

Local cId		:= ""
Local _cQuery
Local _cAlias   := GetNextAlias()
Local cStatAnt 	:= ""
Local dDataAnt 	:= Date()
Local cHoraAnt 	:= "     "
Local cUsrAnt  	:= ""
Local cStatus 	:= SubStr(oCbFlag:AITEMS[oCbFlag:Nat],1,1)
Local dDataAnt	:= Date()
Local cHoraAnt 	:= Left(Time(),5)
Local cUsrAnt 	:= cUserName

_cQuery := "SELECT MAX(ZL_SEQUENC) IDZL FROM " + RetSqlName('SZL') + " SZL  "
_cQuery += "WHERE ZL_FILIAL = '" + oMsNewCrd:aCols[_n][_nPosFil] + "' AND ZL_NUM = '" + oMsNewCrd:aCols[_n][_nPosPed] + "' "
_cQuery += "AND SZL.D_E_L_E_T_ = ' '"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRZ",.T.,.T.)

cSeq	:= TRZ->IDZL
cId		:= SOMA1( cSeq , 6 )


TRZ->(dbCloseArea())

dbSelectArea('SZL')
dbSetOrder(5) //Filial+Pedido+Sequencia

If dbSeek(oMsNewCrd:aCols[_n][_nPosFil] + oMsNewCrd:aCols[_n][_nPosPed] + cSeq) //Posiciona o ultimo registro do pedido
	
	cStatus		:= SubStr(oCbFlag:AITEMS[oCbFlag:NAT],1,1)
	dDataAnt	:= SZL->ZL_DATA
	cHoraAnt	:= SZL->ZL_HORA
	cUsrAnt  	:= SZL->ZL_RESPONS
	
EndIf

RecLock("SZL",.T.)
	Replace ZL_FILIAL 	With oMsNewCrd:aCols[_n][_nPosFil]
	Replace ZL_NUM 		With oMsNewCrd:aCols[_n][_nPosPed]
	Replace ZL_CLIENTE 	With oMsNewCrd:aCols[_n][_nPosCli]
	Replace ZL_LOJA 	With oMsNewCrd:aCols[_n][_nPosLj]
	Replace ZL_VEND 	With oMsNewCrd:aCols[_n][_nPosVnd]
	Replace ZL_SUBSTAT  With oMsNewCrd:aCols[_n][_nPosSta]
	Replace ZL_DATA 	With Date()
	Replace ZL_HORA 	With Left(Time(),5)
	Replace ZL_RESPONS 	With ZC0->ZC0_NOME
	Replace ZL_STATUS 	With cStatus
	Replace ZL_OBS 		With oMsNewCrd:aCols[_n][_nPosObs]
	Replace ZL_DATAANT 	With dDataAnt
	Replace ZL_HORAANT	With cHoraAnt
	Replace ZL_USRANT  	With cUsrAnt
	Replace ZL_STATAPV 	With SL1->L1_FLAG
	Replace ZL_SEQUENC 	With cId
MsUnLock('SZL')

Return()                                               

Static Function GravaLogZL(cFlag,cLog)

aArea := GetArea()

dbSelectArea("SZL")

RECLOCK("SZL",.T.)
	Replace ZL_FILIAL 	With oMsNewCrd:aCols[_n][_nPosFil]
	Replace ZL_NUM 		With oMsNewCrd:aCols[_n][_nPosPed]
	Replace ZL_CLIENTE 	With oMsNewCrd:aCols[_n][_nPosCli]
	Replace ZL_LOJA 	With oMsNewCrd:aCols[_n][_nPosLj]
	Replace ZL_VEND 	With oMsNewCrd:aCols[_n][_nPosVnd]
	Replace ZL_DATA 	With dDataBase
	Replace ZL_HORA		With Left(Time(),5)
	Replace ZL_RESPONS	With ZC0->ZC0_NOME
	Replace ZL_STATUS   With SubStr(oCbFlag:AITEMS[oCbFlag:Nat],1,1)
	Replace ZL_OBS 		With oMsNewCrd:aCols[_n][_nPosObs]
MSUNLOCK("SZL")

RESTAREA(aArea)

Return()

Static Function RetBlq(_cFil,_cPed)

Local cQuery := ""
Local _cAlias := GetNextAlias()
Local aArea := GetArea()
Local cRet := ""
cQuery := "SELECT TRIM(SUBSTR(ZL_OBS,12)) BLOQUEIO "
cQuery += "FROM "+RetSqlName('SZL')+" SZL "
cQuery += " WHERE ZL_FILIAL = '"+_cFil+"' "
cQuery += " AND ZL_NUM = '"+_cPed+"' "
cQuery += " AND SZL.D_E_L_E_T_ = ' ' "
cQuery += "AND ZL_STATUS ='A' AND ZL_RESPONS = 'AUTOMATICO' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

If !(_cAlias)->(Eof())
	cRet := (_cAlias)->BLOQUEIO
EndIf
(_cAlias)->(dbCloseArea())
Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuPeds()

If lPeds .And. GetMv('MV_ATUAPV')

	_nIdx := aScan( aCliPed, {|x| Trim(x[1]) + Trim(x[2]) == Trim(oMsNewCrd:aCols[_n][_nPosCli] + oMsNewCrd:aCols[_n][_nPosLj] ) } )

	If _nIdx > 0
		aCliped[_nIdx][3] += oMsNewCrd:aCols[_n][_nPosVlr]
		aCliPed[_nIdx][4] += ' - '+ oMsNewCrd:aCols[_n][_nPosFil] + '/' + oMsNewCrd:aCols[_n][_nPosPed]
	Else
		aAdd(aCliPed,{oMsNewCrd:aCols[_n][_nPosCli],oMsNewCrd:aCols[_n][_nPosLj],oMsNewCrd:aCols[_n][_nPosVlr],oMsNewCrd:aCols[_n][_nPosFil] + '/' + oMsNewCrd:aCols[_n][_nPosPed]})
	EndIf

	lPeds := .F.

EndIf

Return()                                                                                                                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAPROVA   บAutor  ณMicrosiga           บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fVerIt(_cFilk,_cPedk)

Local _lRet	:= .F.        
Local _aArea 	:= GetArea()
Local _cQuery 	:= ""
Local _cAlias   := GetNextAlias()

_cQuery += "SELECT COUNT(*) ITENS "
_cQuery += "FROM " + RetSqlName('SL2') + " SL2 ,SB1010 SB1 "
_cQuery += "Where L2_filial = '" + _cFilk + "' "
_cQuery += "And B1_filial = '  ' " "
_cQuery += "And L2_num = '" + _cPedk + "' "
_cQuery += "And L2_produto = b1_cod "
_cQuery += "AND SB1.B1_PROC != '018103' "
_cQuery += "And Sl2.d_e_l_e_t_ = ' ' "
_cQuery += "And Sb1.d_e_l_e_t_ = ' ' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

dbSelectArea('TRX')

(_cAlias)->(dbGoTop())

_lRet := (_cAlias)->(ITENS) == 0

(_cAlias)->(dbCloseArea())

RestArea(_aArea)

Return(_lRet)                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FAPROVA  บ Autor ณ Microsiga          บ Data ณ  09/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BlqSerasa(_cFil,_cPed)

Local aArea	:= GetArea()
Local lRet 	:= .F.

dbSelectArea('SZL')
dbSetOrder(5)//Filial+Numero+Sequencia

If dbSeek(_cFil + _cPed + '000000')
	If SZL->ZL_STATUS == "A" .And. AllTrim(SZL->ZL_OBS) == "BLOQUEIOS: *VALIDADE SERASA"
		lRet := .T.
	EndIf
EndIf       

RestArea(aArea)

Return(lRet)                        

Static Function _fPedCli()

Local _nVlrPed	:= 0
Local cQuery	:= "SELECT "
Local aArea 	:= GetArea()
Local _cAlias   := GetNextAlias()

cQuery += "SUM(CASE WHEN L1_FILIAL IN('02','30') THEN L1_VLRLIQ*2 ELSE 0 END) PEDLOJA, "
cQuery += "SUM(CASE WHEN L1_FILIAL IN('03','93','94','31') AND L1_FLAG IN('2','3','5','6','7','8') AND L1_TIPO !='V' AND L1_DOC = '      ' AND L1_SERIE = '   '  THEN L1_VLRLIQ * 2 ELSE 0 END)PEDEXT " //alterado Marcio Silva FL 07
cQuery += "FROM " + RetSqlName('SL1') + " SL1 "
cQuery += "WHERE L1_FILIAL IN('02','93','03','94','30','31') " 
cQuery += "AND L1_CLIENTE = '" + SA1->A1_COD + "' AND L1_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += "AND L1_TIPO != 'V' AND L1_DOC = '      ' AND L1_SERIE = '   ' "
cQuery += "AND L1_NROPCLI NOT LIKE '*%' "
cQuery += "AND SL1.D_E_L_E_T_ = ' ' "
dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .T.)

If !(_cAlias)->(Eof())
	_nVlrPed := (_cAlias)->PEDLOJA + (_cAlias)->PEDEXT
EndIf

(_cAlias)->(dbCloseArea())
RestArea(aArea)

Return(_nVlrPed)                           

Static Function f200UpdC(nLimitN)

Local oFont1 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
Local oGetcli
Local cGetcli := SA1->A1_NOME
Local oGetLmAtu
Local cGetLmAtu := SA1->A1_LC
Local oGetLmSug
Local cGetLmSug := nLimitN
Local oGroup1
Local oSayCli
Local oSayLAtu
Local oSayLmSug
Local oSayPerg
Local oSButton1
Local oSButton2
Static oDlgLmt

DEFINE MSDIALOG oDlgLmt TITLE "Aprova็ใo de Cr้dito" FROM 000, 000  TO 255, 550 COLORS 0, 16777215 PIXEL

    @ 021, 002 GROUP oGroup1 TO 108, 273 PROMPT "Informa็๕es do Cliente" OF oDlgLmt COLOR 0, 16777215 PIXEL
    @ 006, 066 SAY oSayPerg PROMPT "Atualiza็ใo de Limite de Cr้dito" SIZE 134, 009 OF oDlgLmt FONT oFont1 COLORS 8388736, 16777215 PIXEL
    @ 037, 004 SAY oSayCli PROMPT "Cliente:" SIZE 025, 007 OF oDlgLmt COLORS 0, 16777215 PIXEL
    @ 037, 045 MSGET oGetcli VAR cGetcli SIZE 214, 010 OF oDlgLmt COLORS 0, 16777215 READONLY PIXEL
    @ 056, 004 SAY oSayLAtu PROMPT "Limite Atual:" SIZE 032, 007 OF oDlgLmt COLORS 0, 16777215 PIXEL
    @ 053, 045 MSGET oGetLmAtu VAR cGetLmAtu SIZE 060, 010 OF oDlgLmt  PICTURE "@E 99,999,999.99" COLORS 0, 16777215 READONLY PIXEL
    @ 071, 004 SAY oSayLmSug PROMPT "Limite Sugerido:" SIZE 040, 007 OF oDlgLmt COLORS 0, 16777215 PIXEL
    @ 068, 045 MSGET oGetLmSug VAR cGetLmSug SIZE 060, 010 OF oDlgLmt  PICTURE "@E 99,999,999.99" COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 111, 244 TYPE 01 OF oDlgLmt ENABLE ACTION (f200GrvL(cGetLmSug),oDlgLmt:End()) 
    DEFINE SBUTTON oSButton2 FROM 111, 216 TYPE 02 OF oDlgLmt ENABLE Action oDlgLmt:End() 

  ACTIVATE MSDIALOG oDlgLmt CENTERED

Return()                   

Static Function f200GrvL(nNewCr)                      

cMotivo := "alterado limite (Automแtico) por aprova็ใo de pedido."

U_CREDALT(SA1->A1_COD,SA1->A1_LOJA,nNewCr,cMotivo)

Return()

Static Function fVlrPre(cNumPre)
	
	Local aArea := GetArea()
	Local cSql := ""
	Local _cAlias := GetNextAlias()
	
	cSql := "SELECT SUM((L2_PRCTAB*L2_QUANT)*2) VLRPRE "
	cSql += "FROM "+RetSqlName('SL2')+' SL2 '
	cSql += "WHERE L2_FILIAL = '05' AND L2_NUM ='"+cNumPre+"' "
	cSql += "AND SL2.D_E_L_E_T_ = ' '"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),(_cAlias),.T.,.T.)
	dbSelectArea(_cAlias)
	nVlrPre := If(!(_cAlias)->(Eof()),(_cAlias)->(VLRPRE),0)
	(_cAlias)->(dbCloseArea())
	RestArea(aArea)
	
Return(nVlrPre)

Static Function Filtro()

Local lAprov	:= .T.
Local cLog 		:= ""
Local aCred 	:= U_RetSalCred(SL1->L1_CLIENTE,SL1->L1_LOJA)
Local aTit		:= U_TitCli(SL1->L1_CLIENTE,SL1->L1_LOJA)

//Valida o Sintegra
If SL1->L1_USINTEG != "1"
	lAprov := .F.
	cLog += "*SINTEGRA PEDIDO "
EndIf

//Valida Data do Serasa
If SA1->A1_UDTSERA < Date()
	lAprov	:= .F.
	cLog 	+= "*VALIDADE SERASA "
EndIf

//Valida Saldo do Limite de Cr้dito
If ( aCred[1] - ( aCred[2] + aCred[3] ) ) < 0
	lAprov 	:= .F.
	cLog	+= "*LIMITE DE CREDITO "
EndIf

//Valida Tํtulos em Aberto
If aTit[2]
	lAprov	:= .F.
	cLog 	+= "*TITULOS EM ABERTO "
EndIf

//Valida Compra nos ultimos 06 Meses
If SA1->A1_ULTCOM < ( Date() - 180 )
	lAprov	:= .F.
	cLog	+= "*CLIENTE INATIVO "
EndIf

If !lAprov
	RecLock('SZL',.T.)
		Replace SZL->ZL_FILIAL 	With aCols[_n,3]
		Replace SZL->ZL_NUM 	With aCols[_n,4]
		Replace SZL->ZL_CLIENTE With SL1->L1_CLIENTE
		Replace SZL->ZL_LOJA 	With SL1->L1_LOJA
		Replace SZL->ZL_VEND 	With SL1->L1_VEND
		Replace SZL->ZL_DATA 	With Date()
		Replace SZL->ZL_HORA 	With PadR(Time(),5)
		Replace SZL->ZL_RESPONS With "AUTOMATICO"
		Replace SZL->ZL_STATUS 	With "A"
		Replace SZL->ZL_OBS 	With "BLOQUEIOS: " + cLog
		Replace SZL->ZL_SEQUENC With "000000"
	MsUnLock('SZL')
EndIf

Return(lAprov)

Static Function f200Hist()

Local nPosOri := oMsNewCrd:NAT

Local aArea := GetArea()
Private oButton1
Private oFolder1

Static oDlgHistor

DEFINE MSDIALOG oDlgHistor TITLE "Hist๓rico Pedido" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

    @ 003, 001 FOLDER oFolder1 SIZE 494, 230 OF oDlgHistor ITEMS "Hist๓rico","Bloqueios" COLORS 0, 16777215 PIXEL
    fWHistor()
    @ 235, 456 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 OF oDlgHistor ACTION oDlgHistor:End() PIXEL
    fWBloq()

  ACTIVATE MSDIALOG oDlgHistor CENTERED
    
oMsNewCrd:Goto(nPosOri)
oMsNewCrd:OBROWSE:SetFocus()
RestArea(aArea)

Return

//------------------------------------------------ 
Static Function fWHistor()
//------------------------------------------------ 
Local oWHistor
Local aWHistor := {}
Local aHist := {}
Local cQuery := ""
Local _cAlias := GetNextAlias()
cQuery := " SELECT ZL_DATA,ZL_HORA,ZL_RESPONS,ZL_STATUS,ZL_STATAPV,ZL_OBS "
cQuery += " FROM " + RetSqlName("SZL") + " "
cQuery += " WHERE ZL_FILIAL = '" + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil] + "' "
cQuery += " AND ZL_NUM ='" + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed] + "' "
cQuery += " AND D_E_L_E_T_<>'*' "
cQuery += " ORDER BY ZL_DATA,ZL_HORA "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(_cAlias),.T.,.T.)

While !(_cAlias)->(Eof())
	If (_cAlias)->ZL_STATUS == '3' .And. (_cAlias)->ZL_STATAPV != ' '
		aAdd(aWHistor,{dToc( Stod((_cAlias)->ZL_DATA) ),(_cAlias)->ZL_HORA, (_cAlias)->ZL_RESPONS,(_cAlias)->ZL_STATUS,(_cAlias)->ZL_OBS})
	ElseIf (_cAlias)->ZL_STATUS != '3'
		aAdd(aWHistor,{dToc( Stod((_cAlias)->ZL_DATA) ),(_cAlias)->ZL_HORA, (_cAlias)->ZL_RESPONS,(_cAlias)->ZL_STATUS,(_cAlias)->ZL_OBS})
	EndIf
	(_cAlias)->(dbSkip())
EndDo

(_cAlias)->(dbCloseArea())

If Len(awHistor) < 1
	MsgInfo("NรO EXISTE HISTำRICO PARA O ORวAMENTO.")
	Return .F.
EndIf


    // Insert items here
    //Aadd(aWHistor,{"Data","Hora","Responsavel","Status","Observa็ใo"})
    //Aadd(aWHistor,{"Data","Hora","Responsavel","Status","Observa็ใo"})

    @ 003, 001 LISTBOX oWHistor Fields HEADER "Data","Hora","Responsavel","Status","Observa็ใo" SIZE 485, 208 OF oFolder1:aDialogs[1] PIXEL ColSizes 50,50
    oWHistor:SetArray(aWHistor)
    oWHistor:bLine := {|| {;
      aWHistor[oWHistor:nAt,1],;
      aWHistor[oWHistor:nAt,2],;
      aWHistor[oWHistor:nAt,3],;
      aWHistor[oWHistor:nAt,4],;
      aWHistor[oWHistor:nAt,5];
    }}
    // DoubleClick event
    //oWHistor:bLDblClick := {|| aWHistor[oWHistor:nAt,1] := !aWHistor[oWHistor:nAt,1],;
      //oWHistor:DrawSelect()}

Return

//------------------------------------------------
Static Function fWBloq()
//------------------------------------------------ 
Local oWBloq
Local aWBloq := {}

Local aHist := {}
Local cQuery := ""
Local _cAlias := GetNextAlias()
cQuery := " SELECT ZL_DATA,ZL_HORA,ZL_RESPONS,ZL_STATUS,ZL_STATAPV,ZL_OBS "
cQuery += " FROM " + RetSqlName("SZL") + " "
cQuery += " WHERE ZL_FILIAL = '" + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosFil] + "' "
cQuery += " AND ZL_NUM ='" + oMsNewCrd:aCols[oMsNewCrd:NAT][_nPosPed] + "' "
cQuery += " AND D_E_L_E_T_<>'*' "
cQuery += " ORDER BY ZL_DATA,ZL_HORA "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(_cAlias),.T.,.T.)

While !(_cAlias)->(Eof())
	If (_cAlias)->ZL_STATUS == '3' .And. (_cAlias)->ZL_STATAPV == ' '
		aAdd(aWBloq,{dToc( Stod((_cAlias)->ZL_DATA) ),(_cAlias)->ZL_HORA, (_cAlias)->ZL_OBS})
	EndIf
	(_cAlias)->(dbSkip())
EndDo

(_cAlias)->(dbCloseArea())

If Len(aWBloq) < 1
	aAdd(aWBloq,{'','', ''})
	//MsgInfo("NรO EXISTE HISTำRICO PARA O ORวAMENTO.")
	//Return .F.
EndIf
	
    @ 003, 001 LISTBOX oWBloq Fields HEADER "Data","Hora","Observa็ใo" SIZE 485, 208 OF oFolder1:aDialogs[2] PIXEL ColSizes 50,50
    oWBloq:SetArray(aWBloq)
    oWBloq:bLine := {|| {;
      aWBloq[oWBloq:nAt,1],;
      aWBloq[oWBloq:nAt,2],;
      aWBloq[oWBloq:nAt,3];
    }}
    // DoubleClick event
    //oWBloq:bLDblClick := {|| aWBloq[oWBloq:nAt,1] := !aWBloq[oWBloq:nAt,1],;
      //oWBloq:DrawSelect()}

Return()

Static Function RespRCA(_cFilPv, _cNumPv)

Local nPosOri := oMsNewCrd:NAT

dbSelectArea('SL1')
dbSetOrder(1)
dbSeek(_cFilPv+_cNumPv)

dbSelectArea('SA3')
dbSetOrder(1)
dbSeek(xFilial('SA3')+SL1->L1_VEND)

dbSelectArea('SA1')
dbSetOrder(1)
dbSeek(xFilial('SA1')+SL1->L1_CLIENTE+SL1->L1_LOJA)

If Empty(SL1->L1_NUMFAB)
	If MsgYesNo('Confirma incluir como responsabilidade ?'+Chr(13)+Chr(10)+;
							'Pedido/Cliente: '+SL1->L1_FILIAL+'/'+SL1->L1_NUM+'-'+SubStr(SA1->A1_NOME,1,30)+chr(13)+Chr(10)+;
							'Vendedor: '+SA3->A3_COD+' - '+SubStr(SA3->A3_NOME,1,30))
		RecLock('SL1',.F.)
		Replace SL1->L1_NUMFAB With cUserName+'-'+dtoc(Date())+'-'+Time()
		MsUnLock('SL1')
	EndIf
Else
	If MsgYesNo('Confirma excluir como responsabilidade ?'+Chr(13)+Chr(10)+;
							'Pedido/Cliente: '+SL1->L1_FILIAL+'/'+SL1->L1_NUM+'-'+SubStr(SA1->A1_NOME,1,30)+chr(13)+Chr(10)+;
							'Vendedor: '+SA3->A3_COD+' - '+SubStr(SA3->A3_NOME,1,30))
		RecLock('SL1',.F.)
		Replace SL1->L1_NUMFAB With ' '
		MsUnLock('SL1')
	EndIf
EndIf

Alert('Retorna o foco')
oMsNewCrd:Goto(nPosOri)
oMsNewCrd:OBROWSE:SetFocus()

Return()

Static Function VerCx(_cFilPv, _cNumPv)

Local lRet := .T.
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea := GetArea()

cQuery := "    SELECT COUNT(L2_PRODUTO) ITENS "
cQuery += "    FROM SL2010 SL2, "+RetSqlName('SB1')+" SB1 "
cQuery += "    WHERE L2_FILIAL = '"+_cFilPv+"' "
cQuery += "    AND B1_FILIAL = '  ' "
cQuery += "    AND L2_PRODUTO = B1_COD "
cQuery += "    AND L2_NUM = '"+_cNumPv+"' "
cQuery += "		 AND SL2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "    AND MOD(L2_QUANT,B1_EMBCX) != 0"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAlias),.T.,.T.)

If !(cAlias)->(Eof())
	lRet := If( (cAlias)->ITENS > 0, .T., .F. )
EndIF
(cAlias)->(dbCloseArea())
RestArea(aArea)

Return(lRet)
