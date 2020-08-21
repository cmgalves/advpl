#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RptDef.ch"


#DEFINE HMARGEM   050
#DEFINE VMARGEM   050

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2


User Function xfBolBB()
	local aSize     	:= 	FWGetDialogSize( oMainWnd )
	local cCabecalho	:= 	"SELECIONAR TÍTULOS A PAGAR PARA LIBERAR O PAGAMENTO"
	local lOK       	:= 	.F.
	local xcNumDe   	:= 	Space(9)
	local xcNumTe   	:= 	Space(9)
	local lInvert   	:= 	.F.
	local aCampos 		:= {{"OK","",""},{"TIPO","","Tipo"},{"PREFIXO","","Prefixo"},{"NUM","","Título"},{"PARCELA","","Parcela"},{"CLIENTE","","Cliente"},{"LOJA","","Loja"},{"NOMCLI","","Nome"},{"NATUREZ","","Natureza"},{"EMISSAO","","Emissao"},{"VENCTO","","Vencimento"},{"VENCREA","","Venc Real"},{"VALOR","","Valor Título"},{"SDACRES","","Acrescimo"},{"SDDECRE","","Desconto"},{"SALDO","","Saldo"},{"PEDIDO","","Pedido"},{"NUMBCO","","Nosso Numero"}}
	private cArqOP
	Private xaAlias 	:= { {Alias()},{"SE2"}}
	Private xcQuery		:=	""
	Private xcR			:=	Char(13) + Char(10)
	Private aCores		:=	{}
	private cMarca    	:= 	""
	private oDlg, oObserv, oMarkF


//Marck Browse Linha.
	aStrut := {}

	Aadd( aStrut , { "OK"   	, "C" , 02 , 0 } )
	Aadd( aStrut , { "TIPO"		, "C" , 02 , 0 } )
	Aadd( aStrut , { "PREFIXO"	, "C" , 03 , 0 } )
	Aadd( aStrut , { "NUM"  	, "C" , 09 , 0 } )
	Aadd( aStrut , { "PARCELA"	, "C" , 02 , 0 } )
	Aadd( aStrut , { "CLIENTE"  , "C" , 06 , 0 } )
	Aadd( aStrut , { "LOJA"		, "C" , 02 , 0 } )
	Aadd( aStrut , { "NOMCLI"	, "C" , 60 , 0 } )
	Aadd( aStrut , { "NATUREZ"  , "C" , 12 , 0 } )
	Aadd( aStrut , { "EMISSAO" 	, "D" , 08 , 0 } )
	Aadd( aStrut , { "VENCTO"  	, "D" , 08 , 0 } )
	Aadd( aStrut , { "VENCREA"  , "D" , 08 , 0 } )
	Aadd( aStrut , { "VALOR" 	, "N" , 12 , 2 } )
	Aadd( aStrut , { "SDACRES" 	, "N" , 12 , 2 } )
	Aadd( aStrut , { "SDDECRE"  , "N" , 12 , 2 } )
	Aadd( aStrut , { "SALDO" 	, "N" , 12 , 2 } )
	Aadd( aStrut , { "PEDIDO"	, "C" , 06 , 0 } )
	Aadd( aStrut , { "NUMBCO" 	, "C" , 15 , 0 } )
	Aadd( aStrut , { "LEG" 		, "N" , 01 , 0 } )


	cArqOP := CriaTrab(aStrut)

	if select("XTIT") > 0
		XTIT->(dbclosearea())
	endif

	dbUseArea(.T.,,cArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco
	cMarca := XTIT->(GetMark())
	Processa( { || xfBuscaTit() })

	Aadd(aCores, {'XTIT->LEG == 0 ',"BR_VERDE"	})	//RISCO C
	Aadd(aCores, {'XTIT->LEG == 1 ',"BR_VERMELHO"	})	//"Risco não Preenchido



	DbSelectArea( "XTIT" )
	XTIT->( DbGoTop() )



	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)

	PRIVATE aButtons :=	{}
	Aadd(aButtons, {"Legend", {|| MBLegen()} , "Legend...", "Legenda      "		, {|| .T.}} )
// ******************** Interface com usuario
	Define MsDialog oDlg Title cCabecalho From aSize[1], aSize[2] To aSize[3], aSize[4] Pixel


	oMarkF := MsSelect():New( "XTIT","OK",,aCampos,@lInvert,@cMarca ,{34,05,(oDlg:nHeight/2)-120,(oDlg:nWidth/2)-05},,,,,aCores)
	oMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock(),XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }
	oMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif( XTIT->OK == cMarca, ' ', cMarca), MsUnLock()) })), XTIT->(DbGoTo(nRec)), oMarkF:oBrowse:Refresh() }

	@ (oDlg:nHeight/2)-88, 005 SAY oSay1 PROMPT "Titulo De"  SIZE 60, 15 OF oDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (oDlg:nHeight/2)-80, 005 MSGET  oObserv VAR xcNumDe	 SIZE 60,015  OF oDlg FONT oFont20 PIXEL

	@ (oDlg:nHeight/2)-88, 91 SAY oSay1 PROMPT "Titulo Ate"  SIZE 60, 15 OF oDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (oDlg:nHeight/2)-80, 91 MSGET  oObserv VAR xcNumTe	 SIZE 60,015  OF oDlg FONT oFont20 PIXEL

	@ (oDlg:nHeight/2)-80, 250 BUTTON "Filtrar" SIZE 060, 017 PIXEL OF oDlg ACTION (xfBuscar(xcNumDe, xcNumTe))

	Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,{|| Processa( {||impBolet(cMarca)})},{|| lOK := .F., oDlg:End()},,@aButtons) Centered
	// ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOK:=.T., Alert(                },{||           , oDlg:End()},,@aButtons)


Return()

Static Function impBolet(cMarca)
	local xlOpc		:=	.T.
	local ctaMaisUm :=	0

	&& Atributos para Seleçço dos Dados a Imprimir
	private cAlias
	private cCpoMark
	private cIndexName
	private cIndexKey
	private cFilter
	private lFiltrado

	&& Atributos dos Dados para o Relatçrio
	private cBanco
	private aCampos
	private aDadosEmp
	private aDadosSel
	private aDadosTit
	private aDadosBanco
	private aDadosSac
	private cNossoNum
	private cCodBarra
	private cLinhaDig
	private aFrases
	private cProtesto

	&& Atributos para Geraçço do Relatçrio
	private oReport
	// private aLogoBco
	private lMostraPrg
	private cGrpPerg
	private aPergs
	private cTamanho
	private ctitulo
	private cDesc1
	private cDesc2
	private cDesc3
	private wnrel
	private areturn
	private nLastKey
	private nModelo


	default lPrgOnInit :=	.F.
	default cCodBanco  :=	"001" && Banco do Brasil
	default cFiltro    :=	""
	default nModelo    :=	1

	lMostraPrg  :=	lPrgOnInit && Indica se irç abrir as Perguntas na Inicializaçço
	cBanco	  	:=	cCodBanco && Informa o Cçdigo do Banco a ser gerado o Boleto
	cNossoNum	:=	""
	cCodBarra   :=	""
	cLinhaDig	:=	""
	aCampos	  	:=	{}
	aDadosSel   :=	{}
	aDadosEmp   :=	{}
	aDadosTit   :=	{}
	aDadosBanco :=	{}
	aDadosSac   :=	{}
	aFrases	  	:=	{}
	aPergs	  	:=	{}
	cTamanho 	:=	"M"
	ctitulo  	:=	"Impressao de Boleto com Codigo de Barras"
	cDesc1   	:=	"Este programa destina-se a impressao do Boleto Bancario com Codigo de Barras."
	cDesc2   	:=	"Serç impresso somente os tçtulos transferidos para Cobrança Simples."
	cDesc3   	:=	"Especifico para o Banco do Brasil."
	cAlias  	:=	"SE1"
	cCpoMark	:=	"E1_OK"
	wnrel    	:=	"BOLETO"
	nModelo	  	:=	nModelo
	// aLogoBco	:=	{"System\Bitmaps\LOGOBB.BMP"}
	areturn  	:=	{"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey 	:=	0

	oReport:=TMSPrinter():new("BOL BB")
	oReport:StartPage()
	oReport:SetPaperSize(9)
	oReport:SetPortrait()
	oReport:Setup()

	SE1->(dbSetOrder(1))

	While !(XTIT->(EOF()))
		if alltrim(XTIT->OK) != cMarca
			XTIT->(dbSkip())
			Loop
		endif
		if SE1->(dbSeek( xFilial("SE1") + XTIT->PREFIXO + XTIT->NUM + XTIT->PARCELA ))
			ctaMaisUm++
			// if ctaMaisUm == 0
			xfMontaRel()
			// endif
		else
			XTIT->(dbSkip())
			Loop
		endif
		oReport:EndPage()
		oReport:StartPage()
		XTIT->(dbSkip())
	Enddo

	oReport:EndPage()
	oReport:Preview()
	// alert(ctaMaisUm)
	XTIT->(dbGoTop())
	oMarkF:oBrowse:Refresh()

Return xlOpc




static function xfMontaRel()
	local nTaxa := 0

	aAdd(aDadosEmp,SM0->M0_NOMECOM) 															&& [1]Nome da Empresa
	aAdd(aDadosEmp,SM0->M0_ENDCOB) 																&& [2]Endereço
	aAdd(aDadosEmp,alltrim(SM0->M0_BAIRCOB)+", "+alltrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB) 	&& [3]Complemento
	aAdd(aDadosEmp,"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)) 				&& [4]CEP
	aAdd(aDadosEmp,"PABX/FAX: "+SM0->M0_TEL) 													&& [5]Telefones
	aAdd(aDadosEmp,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))  					&& [6]CNPJ
	aAdd(aDadosEmp,"I.E.: "+Transform(SM0->M0_INSC,"@R 999.999.999.999")) 						&& [7]I.E

	dbGoTop()


	// Do While SE1->(!EOF()) .AND. SE1->E1_NUM == numTit //&& Percorre o Arquivo do SE1 Ativo que estç filtrado


	SA1->(dbSetOrder(1))
	SA1->(dbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA  ))

	dbSelectArea("SA6")
	dbSetOrder(1)
	dbSeek(xFilial("SA6")+mv_par17+mv_par18+mv_par19,.T.)

	dbSelectArea("SEE")
	dbSetOrder(1)
	dbSeek(xFilial("SEE")+mv_par17+mv_par18+mv_par19+MV_PAR20,.T.)

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

	aDadosBanco := {}
	aAdd(aDadosBanco,SA6->A6_COD)													&& [1]Numero do Banco
	aAdd(aDadosBanco,SA6->A6_NREDUZ)												&& [2]Nome do Banco
	aAdd(aDadosBanco,subStr(SA6->A6_AGENCIA, 1, 5))								&& [3]Agçncia
	aAdd(aDadosBanco,subStr(SA6->A6_NUMCON,1,Len(alltrim(SA6->A6_NUMCON))-2)) 	&& [4]Conta Corrente
	aAdd(aDadosBanco,subStr(SA6->A6_NUMCON,Len(alltrim(SA6->A6_NUMCON)),1))		&& [5]Dçgito da conta corrente
	aAdd(aDadosBanco,"17-019") 													&& [6]Codigo da Carteira Completo
	aAdd(aDadosBanco,alltrim(SEE->EE_ZZCART))										&& [7]Carteira - Campo Pers. no SEE
	aAdd(aDadosBanco,alltrim(SEE->EE_CODEMP)) 									&& [8]Convçnio do Banco
	aAdd(aDadosBanco,Len(alltrim(SEE->EE_CODEMP))) 								&& [9]Nç de Dçgitos do Convçnio do Banco
	aAdd(aDadosBanco,SEE->EE_FAXATU) 												&& [10]Nç Seq. Interno para Uso com o Boleto
	aAdd(aDadosBanco,"")

	aDadosSac:={}
	if Empty(SA1->A1_ENDCOB)
		aAdd(aDadosSac,alltrim(SA1->A1_NOME))   		    		            && [1]Razço Social
		aAdd(aDadosSac,alltrim(SA1->A1_COD)+"-"+SA1->A1_LOJA)		    		&& [2]Cçdigo
		aAdd(aDadosSac,alltrim(SA1->A1_END)+"-"+alltrim(SA1->A1_BAIRRO)) 		&& [3]Endereço
		aAdd(aDadosSac,alltrim(SA1->A1_MUN))							    	&& [4]Cidade
		aAdd(aDadosSac,SA1->A1_EST)											&& [5]Estado
		aAdd(aDadosSac,SA1->A1_CEP) 											&& [6]CEP
		aAdd(aDadosSac,SA1->A1_CGC) 									    	&& [7]CNPJ
		aAdd(aDadosSac,SA1->A1_PESSOA)								    	&& [8]PESSOA
	else
		aAdd(aDadosSac,alltrim(SA1->A1_NOME))		    		                && [1]Razço Social
		aAdd(aDadosSac,alltrim(SA1->A1_COD)+"-"+SA1->A1_LOJA)		    		&& [2]Cçdigo
		aAdd(aDadosSac,alltrim(SA1->A1_ENDCOB)+"-"+alltrim(SA1->A1_BAIRROC)) 	&& [3]Endereço
		aAdd(aDadosSac,alltrim(SA1->A1_MUNC))							    	&& [4]Cidade
		aAdd(aDadosSac,SA1->A1_ESTC)											&& [5]Estado
		aAdd(aDadosSac,SA1->A1_CEPC) 											&& [6]CEP
		aAdd(aDadosSac,SA1->A1_CGC) 									    	&& [7]CNPJ
		aAdd(aDadosSac,SA1->A1_PESSOA)								    	&& [8]PESSOA
	endif

	aDadosTit:={}
	aAdd(aDadosTit,alltrim(SE1->E1_NUM)+alltrim(SE1->E1_PARCELA))				&& [1] Nçmero do tçtulo
	aAdd(aDadosTit,SE1->E1_EMISSAO)											&& [2] Data da emissço do tçtulo
	aAdd(aDadosTit,dDataBase)													&& [3] Data da emissço do boleto
	aAdd(aDadosTit,SE1->E1_VENCTO)                 							&& [4] Data do vencimento
	aAdd(aDadosTit,((SE1->E1_SALDO + nTaxa) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)))&& [5] Valor do tçtulo
	aAdd(aDadosTit,SE1->E1_PREFIXO )     										&& [6] Prefixo do Tçtulo
	aAdd(aDadosTit,"DM")	      												&& [7] Tipo do Titulo Espçcie de Docto Padrao (DM=DUPLICATA MERCANTIL, DS=DUPLICATA DE SERVIçO, RC=RECIBO)

	aFrases := {}

	aAdd(aFrases,'Juros de R$ '+AllTrim(Transform(Round(((SE1->E1_SALDO + nTaxa) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)) * GetMV('MB_TXJUROS'),2),"999,999,999.99")) + ' ao dia')
	aAdd(aFrases,'Multa de R$ '+AllTrim(Transform(Round(((SE1->E1_SALDO + nTaxa) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)) * GetMV('MB_TXMULTA'),2),"999,999,999.99")) + ' apçs vencimento')
	aAdd(aFrases,'Negativação após 07 dias do vencimento')

	aAdd(aFrases,"PARCELA N.: " + SE1->E1_PARCELA )

	NossoNro(SE1->E1_NUMBCO)

	CodBarra()

	PrintRel()

return


static function nossoNro(cNossNroOld)

	local cBase		:= ""
	local cDV		:= ""
	local cNossoNro	:= ""

	local cBanco	:= alltrim(aDadosBanco[1])
	local cAgencia	:= alltrim(aDadosBanco[3])
	local cConta	:= alltrim(aDadosBanco[4]) && Sem Dçgito Verificador (DAC)
	local cCarteira := alltrim(aDadosBanco[7])
	local cConvenio	:= alltrim(aDadosBanco[8])
	local nDigConv	:= aDadosBanco[9]
	local cCodSeq	:= alltrim(aDadosBanco[10])

	&& cNossNroOld := "" && Dellano - Força o calculo

	if !Empty(cNossNroOld)
		cNossoNro:= cNossNroOld
	else
		&& Banco do Brasil
		if cBanco == "001"
			if cCarteira == "18" && Cobrança Simples - Boleto Impresso na Empresa
				cBase	   := alltrim(cConvenio)+alltrim(cCodSeq) && Convçnio + Nç Seq.
				if nDigConv == 4 && Dçgitos do Convçnio de 4 Dçgitos
					&& Convenio deve ter 4 Dçgitos e Nç Seq. 7 Dçgitos = 11 Dçgitos
					cDV	   := U_xfMod11(cBase,9,2,cBanco) && 12 Dçgitos no Total com Dçgito Verif.
				elseif nDigConv == 6 && Dçgitos do Convçnio de 6 Dçgitos
					&& Convenio deve ter 6 Dçgitos e Nç Seq. 5 Dçgitos = 11 Dçgitos
					cDV	   := U_xfMod11(cBase,9,2,cBanco) && 12 Dçgitos no Total com Dçgito Verif.
				elseif nDigConv == 7 && Convçnio de 7 Dçgitos
					&& Convenio deve ter 7 Dçgitos e Nç Seq. 10 Dçgitos  = 17 Dçgitos
					cDV	   := "" && 17 Dçgitos no Total Sem DV
				else
					cDV	   := "" && Sem DV
				endif

				cNossoNro  := cBase + cDV && Grava o Nosso Nçmero Completo

				&& Atualiza o Numero Sequencial do Cadastro de Parçmetros Banco
				GrvNumSeq(Soma1(alltrim(cCodSeq)))

			elseif cCarteira == "17"

				if nDigConv == 7
					cBase := alltrim(cConvenio)+right(alltrim(cCodSeq),10) && Convçnio + Nç Seq.
					cDV	  := ""
				elseif nDigConv == 6 && Dçgitos do Convçnio de 6 Dçgitos
					&& Convenio deve ter 6 Dçgitos e Nç Seq. 5 Dçgitos = 11 Dçgitos
					cBase := alltrim(cConvenio)+right(alltrim(cCodSeq),5) && Convçnio + Nç Seq.
					cDV	  := U_xfMod11(cBase,9,2,cBanco) && 12 Dçgitos no Total com Dçgito Verif.
				endif

				cNossoNro  := cBase + cDV && Grava o Nosso Nçmero Completo

				&& Atualiza o Numero Sequencial do Cadastro de Parçmetros Banco
				GrvNumSeq(Soma1(alltrim(cCodSeq)))

			elseif cCarteira == "11" && Boleto Impresso no Banco, bem como geraçço do Nosso Nçmero.

				cNossoNro := "00000000000000000"
			endif

			&& Caixa Econçmica Federal
		elseif cBanco == "104"
			if cCarteira == "12" && Cobrança Simples - Boleto Impresso na Empresa
				cBase	  := "9"+subStr(cCodSeq,4,9)
				cDV		  := U_xfMod11(cBase,7,2,cBanco)
				cNossoNro := cBase + cDV

				&& Atualiza o Numero Sequencial do Cadastro de Parçmetros Banco
				GrvNumSeq(strZero(val(cCodSeq)+1,12))

			elseif cCarteira == "14" && Cobrança sem Registro - Boleto Impresso na Empresa
				cBase	  := "82"+subStr(cCodSeq,5,8)
				cDV		  := U_xfMod11(cBase,7,2,cBanco)
				cNossoNro := cBase + cDV

				&& Atualiza o Numero Sequencial do Cadastro de Parçmetros Banco
				GrvNumSeq(strZero(val(cCodSeq)+1,12))
			endif

			&& Bradesco ou Safra
		elseif cBanco == "237" .or. cBanco == "422"
			if cCarteira == "19" && Cobrança sem Registro
				cBase	  := alltrim(cCodSeq) && 11 Dçgitos Sequenciais
				cDV	   	  := U_xfMod11(cCarteira+cBase,2,7,cBanco) && 12 Dçgitos no Total com Dçgito Verif. - Modulo 11 sobre Carteira + Nosso Nro
				cNossoNro := cBase + cDV && Grava o Nosso Nçmero Completo

			elseif cCarteira == "09"
				cBase	  := subStr(dtos(SE1->E1_EMISSAO),3,2) +alltrim(cCodSeq)
				cDV	   	  := U_xfMod11(cCarteira+cBase,2,7,"422")
				cNossoNro := cCarteira + cBase + cDV
				cDV	   	  := U_xfMod11(cNossoNro,2,7,"237")
				cNossoNro := cNossoNro + cDV
			endif

			&& Atualiza o Numero Sequencial do Cadastro de Parçmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))

			&& Banco Itaç ou Votorantim
		elseif cBanco == "341" .or. cBanco == "655"
			cBase	  := cCarteira+alltrim(cCodSeq) && 3 Dçgitos da Carteira + 8 Dçgitos Sequenciais = 11 Dçgitos

			if cCarteira == "126" .Or. cCarteira == "131" .Or. cCarteira == "145" .Or. ;
					cCarteira == "150" .Or. cCarteira == "168" && Carteiras Escriturais e na Modalidade Direta

				cDV:= U_xfMod10(cBase,2,1,"Divisor") && 12 Dçgitos no Total com Dçgito Verif. - Somente Carteira e Num. Seq.
			else
				cDV:= U_xfMod10(cAgencia+cConta+cBase,2,1,"Divisor") && 12 Dçgitos no Total com Dçgito Verif. - Agencia+CC sem DAC+Carteira+Num. Seq
			endif
			cNossoNro := cBase + cDV && Grava o Nosso Nçmero Completo

			&& Atualiza o Numero Sequencial do Cadastro de Parçmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))
		endif
	endif

	If !Empty(Alltrim(cNossoNro))
		cNossoNum:= Alltrim(cNossoNro)
	Else
		cNossoNum:= RetNossoNro()
	Endif

	GrvNossNum()

return (cNossoNum)

Static Function GrvNumSeq(cCodSeq)
	dbSelectArea("SEE")
	RecLock("SEE")
	SEE->EE_FAXATU:= cCodSeq
	MsUnLock()
return

static function grvNossNum()
	dbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO := cNossoNum
	SE1->E1_ZZBLT := .T. && Indica que o Boleto foi impresso - Campo Personalizado
	MsUnlock()
return

static function retNossoNro()

	local cBanco	:= aDadosBanco[1]
	local nDigConv	:= aDadosBanco[9]
	local cNossoNro := cNossoNum

	&& Banco do Brasil
	if cBanco == "001" .and. Empty(cNossoNro)
		if nDigConv == 6 && Dçgitos do Convçnio de 6 Dçgitos
			cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)
		elseif nDigConv == 7 && Dçgitos do Convçnio de 7 Dçgitos
			cNossoNro:= cNossoNro
		else
			cNossoNro:= cNossoNro
		endif

		&& Bradesco
	elseif cBanco == "237" .and. Empty(cNossoNro)
		cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)

		&& Safra
	elseif cBanco == "422" .and. Empty(cNossoNro)
		cNossoNro:= left(cNossoNro,4) + "/" + subStr(cNossoNro,5,Len(allTrim(cNossoNro))-5) + "-" + Right(cNossoNro,1)

		&& Banco Itaç ou Votorantim
	elseif (cBanco == "341" .or. cBanco == "655") .and. Empty(cNossoNro)
		cNossoNro:= left(cNossoNro,3) + "/" + subStr(cNossoNro,4,Len(cNossoNro)-4) + "-" + Right(cNossoNro,1)

	else
		cNossoNro:= cNossoNro
	endif

return (cNossoNro)


static function CodBarra()
	local cBanco	  := aDadosBanco[1]
	local cAgencia    := aDadosBanco[3]
	local cConta      := aDadosBanco[4] && Sem DAC
	local cCarteira   := aDadosBanco[7]
	local nDigConv	  := aDadosBanco[9]
	local cVencto	  := DTOS(aDadosTit[4]) && Converte para AAAAMMDD
	local cMoeda	  := "9" && Cçdigo da Moeda no Banco - 9 = Real
	local cNNumSemDV  := ""
	local cCampoLivre := ""
	local cFator	  := ""
	local cDigBarra	  := ""
	local cParte1	  := ""
	local cDig1		  := ""
	local cParte2	  := ""
	local cDig2		  := ""
	local cParte3	  := ""
	local cDig3		  := ""
	local cParte4	  := ""
	local cParte5	  := ""

	&& Ajusta a Agencia para 4 Dçgitos
	cAgencia:=left(cAgencia,4)

	&& Define o Nosso Nçmero sem DV e Parte do Campo Livre
	&& Variçvel para Cada Banco e cada Tipo de Convçnio
	if cBanco == "001" && Banco do Brasil
		if nDigConv == 4 && Dçgitos do Convçnio de 4 Dçgitos (Com DV)
			cNNumSemDV  := left(cNossoNum,11)
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira	&& 11 + 4 + 8 + 2 = 25

		elseif nDigConv == 6 && Dçgitos do Convçnio de 6 Dçgitos (Com DV)
			cNNumSemDV  := left(cNossoNum,11)
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira && 11 + 4 + 8 + 2 = 25

		elseif nDigConv == 7 && Dçgitos do Convçnio de 7 Dçgitos (Sem DV) - Faixa Acima de 1.000.000 - Somente para Carteiras 16 e 18
			cNNumSemDV  := cNossoNum
			cCampoLivre := "000000"+cNNumSemDV+"21" && 6 + 17 + 2 = 25

		else
			cNNumSemDV:= cNossoNum
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira && 11 + 4 + 8 + 2 = 25
		endif

		&& Banco Bradesco
	elseif cBanco == "237"
		cNNumSemDV  := left(cNossoNum,11)
		cCampoLivre := cAgencia+cCarteira+cNNumSemDV+strZero(val(cConta),7)+"0" && 4 + 2 + 11 + 7 + 1 = 25

		&& Banco Safra
	elseif cBanco == "422"
		cNNumSemDV  := left(cNossoNum,13)
		cCampoLivre := cAgencia+cNNumSemDV+strZero(val(cConta),7) +"0" && 4 + 2 + 11 + 7 + 1 = 25

		&& Banco Itaç ou Votorantim
	elseif cBanco == "341" .or. cBanco == "655"
		cNNumSemDV  := left(cNossoNum,11)
		cCampoLivre := cNNumSemDV+Right(cNossoNum,1)+cAgencia+strZero(val(cConta),5)+U_xfMod10(cAgencia+cConta,2,1,"Divisor")+"000"	&& 11 + 1 + 4 + 5 + 1 + 3 = 25

	else && Para outros Bancos - Estudar as Especificaççes de Outros Bancos
		cNNumSemDV:= cNossoNum
		cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira && 11 + 4 + 8 + 2 = 25
	endif

	&& Define o Fator de Vencimento com o Valor do Tçtulo

	&& Banco do Brasil
	&& Regra: Deduzir do Vencto a Data Base de 03/07/2000 e Acrescer a 1000
	cFator := Str(1000+(STOD(cVencto)-STOD("20000703")),4) && Fator = 4 Dçgitos
	cFator += strZero(aDadosTit[5]*100,10) && Valor = 10 Dçgitos

	cCampoLivre := cBanco+cMoeda+cFator+cCampoLivre

	&& Dçgito Verificador do Campo Livre
	cDigBarra   := U_xfMod11(cCampoLivre,2,9,cBanco,2)

	&& Composiçço Final do Cçdigo de Barra
	cCodBarra := subStr(cCampoLivre,1,4)+cDigBarra+subStr(cCampoLivre,5,Len(cCampoLivre))

	&& Composiçço da Linha Digitável
	cParte1 := cBanco

	cParte1  := cParte1 + cMoeda
	cParte1  := cParte1 + subStr(cCodBarra,20,5) && Posiçço 20 a 24 do Cçd. de Barras
	cDig1    := U_xfMod10(cParte1,2,1) && xfMod10, alternando com bases de 2 e 1 - DAC
	cParte2  := subStr(cCodBarra,25,10) && Posiçço 25 a 34 do Cçd. de Barras
	cDig2    := U_xfMod10(cParte2,2,1) && xfMod10, alternando com bases de 2 e 1 - DAC
	cParte3  := subStr(cCodBarra,35,10) && Posiçço 35 a 44 do Cçd. de Barras
	cDig3    := U_xfMod10(cParte3,2,1) && xfMod10, alternando com bases de 2 e 1 - DAC
	cParte4  := cDigBarra && DV do Cçd. de Barra Em xfMod11 Calculado Previamente
	cParte5  := cFator && Fator de Vencto + Valor

	&& Montagem Final da Linha Digitçvel
	cLinhaDig := 	subStr(cParte1,1,5)+"."+subStr(cparte1,6,4)+cDig1+" "+;
		subStr(cParte2,1,5)+"."+subStr(cparte2,6,5)+cDig2+" "+;
		subStr(cParte3,1,5)+"."+subStr(cparte3,6,5)+cDig3+" "+;
		cParte4+" "+;
		cParte5

return


static function printRel()

	local oFont8   :=	TFont():new("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont10  :=	TFont():new("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont11c :=	TFont():new("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont21  :=	TFont():new("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont15n :=	TFont():new("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	local aBitmap  :=	{"System\Bitmaps\LOGOBB.BMP"}
	local cString  :=	""
	local nI 	   :=	0
	local nRow1	   :=	0
	local nRow2	   :=	0
	local nRow3	   :=	0
	local nHPage   :=	0
	local nVPage   :=	0

	nHPage := oReport:nHorzRes()
	nHPage *= (300/oReport:nLogPixelX())
	nHPage -= HMARGEM

	nVPage := oReport:nVertRes()
	nVPage *= (300/oReport:nLogPixelY())
	nVPage -= VMARGEM


	nRow1 := 0

	oReport:line(nRow1+0150,500,nRow1+0070, 500) && Linha Vertical
	oReport:line(nRow1+0150,710,nRow1+0070, 710) && Linha Vertical
	oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) && Logotipo do Banco
	oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) && Logotipo do Banco
	oReport:say(nRow1+0075,513,aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
	oReport:say(nRow1+0084,1900,"Comprovante de Entrega",oFont10)
	oReport:line(nRow1+0150,100,nRow1+0150,2300)
	oReport:say(nRow1+0150,100 ,"Cedente",oFont8)
	oReport:say(nRow1+0200,100 ,aDadosEmp[1],oFont10)				&& Nome + CNPJ da Empresa

	oReport:say(nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	oReport:say(nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

	oReport:say(nRow1+0150,1510,"Nro.Documento",oFont8)
	oReport:say(nRow1+0200,1510,aDadosTit[6]+aDadosTit[1],oFont10) && Prefixo+Numero+Parcela

	oReport:say(nRow1+0250,100 ,"Sacado",oFont8)
	oReport:say(nRow1+0300,100 ,SubStr(aDadosSac[1],1,56),oFont10) && Nome do Cliente

	oReport:say(nRow1+0250,1060,"Vencimento",oFont8)
	oReport:say(nRow1+0300,1060,strZero(Day(aDadosTit[4]),2) +"/"+ strZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oReport:say(nRow1+0250,1510,"Valor do Documento",oFont8)
	oReport:say(nRow1+0300,1550,Transform(aDadosTit[5],"@E 99,999,999.99"),oFont10)

	oReport:say(nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
	oReport:say(nRow1+0450,0100,"com as caracterçsticas acima.",oFont10)
	oReport:say(nRow1+0350,1060,"Data",oFont8)
	oReport:say(nRow1+0350,1410,"Assinatura",oFont8)
	oReport:say(nRow1+0450,1060,"Data",oFont8)
	oReport:say(nRow1+0450,1410,"Entregador",oFont8)

	oReport:line(nRow1+0250, 100,nRow1+0250,1900 ) && Linha Horizontal
	oReport:line(nRow1+0350, 100,nRow1+0350,1900 ) && Linha Horizontal
	oReport:line(nRow1+0450,1050,nRow1+0450,1900 ) && Linha Horizontal
	oReport:line(nRow1+0550, 100,nRow1+0550,2300 ) && Linha Horizontal

	oReport:line(nRow1+0550,1050,nRow1+0150,1050 ) && Linha Vertical
	oReport:line(nRow1+0550,1400,nRow1+0350,1400 ) && Linha Vertical
	oReport:line(nRow1+0350,1500,nRow1+0150,1500 ) && Linha Vertical
	oReport:line(nRow1+0550,1900,nRow1+0150,1900 ) && Linha Vertical

	oReport:say(nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
	oReport:say(nRow1+0205,1910,"(  )Ausente"                                   ,oFont8)
	oReport:say(nRow1+0245,1910,"(  )Não existe núm indicado"                  	,oFont8)
	oReport:say(nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
	oReport:say(nRow1+0325,1910,"(  )Não procurado"                             ,oFont8)
	oReport:say(nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
	oReport:say(nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
	oReport:say(nRow1+0445,1910,"(  )Falecido"                                  ,oFont8)
	oReport:say(nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/

	nRow2 := 0

	&& Pontilhado Separador
	For nI := 100 to 2300 step 50
		oReport:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI

	oReport:sayBitMap(nRow2+0635,94,aBitMap[1],0400,0072)

	oReport:line(nRow2+0710,100,nRow2+0710,2300) && Linha Horizontal
	oReport:line(nRow2+0710,500,nRow2+0630, 500) && Linha Vertical
	oReport:line(nRow2+0710,710,nRow2+0630, 710) && Linha Vertical

	oReport:say(nRow2+0635,513,aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
	oReport:say(nRow2+0644,1755,"RECIBO DO SACADO",oFont10)		&& Descriçço da Seçço

	oReport:line(nRow2+0810,100,nRow2+0810,2300 ) && Linha Horizontal
	oReport:line(nRow2+0910,100,nRow2+0910,2300 ) && Linha Horizontal
	oReport:line(nRow2+0980,100,nRow2+0980,2300 ) && Linha Horizontal
	oReport:line(nRow2+1050,100,nRow2+1050,2300 ) && Linha Horizontal

	oReport:line(nRow2+0910,500,nRow2+1050,500)   && Linha Vertical
	oReport:line(nRow2+0980,750,nRow2+1050,750)	 && Linha Vertical
	oReport:line(nRow2+0910,1000,nRow2+1050,1000) && Linha Vertical
	oReport:line(nRow2+0910,1300,nRow2+0980,1300) && Linha Vertical
	oReport:line(nRow2+0910,1480,nRow2+1050,1480) && Linha Vertical

	oReport:say(nRow2+0710,100 ,"local de Pagamento",oFont8)
	oReport:say(nRow2+0750,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)

	oReport:say(nRow2+0710,1810,"Vencimento",oFont8)
	cString	:= strZero(Day(aDadosTit[4]),2) +"/"+ strZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oReport:say(nRow2+0750,nCol,cString,oFont11c)

	oReport:say(nRow2+0810,100 ,"Cedente",oFont8)

	oReport:say(nRow2+0850,100 ,aDadosEmp[1],oFont10)				&& Nome da Empresa

	oReport:say(nRow2+0810,1810,"Agçncia/Cçdigo Cedente",oFont8)
	cString := alltrim(Subs(aDadosBanco[3],1,4))
	cString += if(empty(Subs(aDadosBanco[3],5,1)),"","-"+Subs(aDadosBanco[3],5,1))+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	nCol := 1810+(374-(len(cString)*22))+40
	oReport:say(nRow2+0850,nCol,cString,oFont11c)

	oReport:say(nRow2+0910,100 ,"Data do Documento",oFont8)
	oReport:say(nRow2+0940,100, strZero(Day(aDadosTit[2]),2) +"/"+ strZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

	oReport:say(nRow2+0910,505 ,"Nro.Documento",oFont8)
	oReport:say(nRow2+0940,605 ,aDadosTit[6]+aDadosTit[1],oFont10) && Prefixo+Numero+Parcela

	oReport:say(nRow2+0910,1005,"Espçcie Doc.",oFont8)
	oReport:say(nRow2+0940,1050,aDadosTit[7],oFont10) && Tipo do Titulo

	oReport:say(nRow2+0910,1305,"Aceite",oFont8)
	oReport:say(nRow2+0940,1400,"N",oFont10)

	oReport:say(nRow2+0910,1485,"Data do Processamento",oFont8)
	oReport:say(nRow2+0940,1550,strZero(Day(aDadosTit[3]),2) +"/"+ strZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) && Data de impressao

	oReport:say(nRow2+0910,1810,"Nosso Nçmero",oFont8)
	cString:= RetNossoNro() && Retorna o Nosso Nçmero Formatado
	nCol := 1850+(374-(len(cString)*22))
	oReport:say(nRow2+0940,nCol,cString,oFont11c)

	oReport:say(nRow2+0980,100 ,"Uso do Banco",oFont8)

	oReport:say(nRow2+0980,505 ,"Carteira",oFont8)
	oReport:say(nRow2+1010,555 ,aDadosBanco[7],oFont10)

	oReport:say(nRow2+0980,755 ,"Espçcie",oFont8)
	oReport:say(nRow2+1010,805 ,"R$",oFont10)

	oReport:say(nRow2+0980,1005,"Quantidade",oFont8)
	oReport:say(nRow2+0980,1485,"Valor",oFont8)

	oReport:say(nRow2+0980,1810,"Valor do Documento",oFont8)
	cString:= Transform(aDadosTit[5],"@E 99,999,999.99")
	nCol := 1810+(374-(len(cString)*22))
	oReport:say(nRow2+1010,nCol,cString,oFont11c)

	oReport:say(nRow2+1050, 100,"Instruççes (Todas informaççes deste bloqueto sço de exclusiva responsabilidade do cedente)",oFont8)
	If !Empty(aFrases)
		oReport:say(nRow2+1150, 100,aFrases[1],oFont10)
		oReport:say(nRow2+1200, 100,aFrases[2],oFont10)
		oReport:say(nRow2+1250, 100,aFrases[3],oFont10)
		oReport:say(nRow2+1300, 100,aFrases[4],oFont10)
	EndIf
	oReport:say(nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
	oReport:say(nRow2+1120,1810,"(-)Outras Deduççes",oFont8)
	oReport:say(nRow2+1190,1810,"(+)Mora/Multa",oFont8)
	oReport:say(nRow2+1260,1810,"(+)Outros Acrçscimos",oFont8)
	oReport:say(nRow2+1330,1810,"(=)Valor Cobrado",oFont8)

	oReport:say(nRow2+1400,100 ,"Sacado",oFont8)
	oReport:say(nRow2+1430,400 ,aDadosSac[1]+" ("+aDadosSac[2]+")",oFont10)
	oReport:say(nRow2+1483,400 ,aDadosSac[3],oFont10)
	oReport:say(nRow2+1536,400 ,aDadosSac[4]+" - "+aDadosSac[5] + " - " + aDadosSac[6],oFont10) && Cidade+Estado+CEP


	oReport:say(nRow2+1605, 100,"Sacador/Avalista " + aDadosBanco[11],oFont8)
	oReport:say(nRow2+1645,1810,"Autenticaçço Mecçnica",oFont8)

	oReport:line(nRow2+0710,1800,nRow2+1400,1800)
	oReport:line(nRow2+1120,1800,nRow2+1120,2300)
	oReport:line(nRow2+1190,1800,nRow2+1190,2300)
	oReport:line(nRow2+1260,1800,nRow2+1260,2300)
	oReport:line(nRow2+1330,1800,nRow2+1330,2300)
	oReport:line(nRow2+1400, 100,nRow2+1400,2300)
	oReport:line(nRow2+1640, 100,nRow2+1640,2300)

		/******************/
		/* TERCEIRA PARTE */
		/******************/

	nRow3 := 0

	&& Pontilhado Separador
	For nI := 100 to 2300 step 50
		oReport:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI

	oReport:line(nRow3+2000,100,nRow3+2000,2300) && Linha Horizontal
	oReport:line(nRow3+2000,500,nRow3+1920,0500) && Linha Vertical
	oReport:line(nRow3+2000,710,nRow3+1920,0710) && Linha Vertical

	oReport:sayBitMap(nRow1+1925,94,aBitMap[1],0400,0072) 	   && Logotipo do Banco
	oReport:say(nRow3+1925,513,aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
	oReport:say(nRow3+1934,755,cLinhaDig,oFont15n)		   && Linha Digitavel do Codigo de Barras

	oReport:line(nRow3+2100,100,nRow3+2100,2300) && Linha Horizontal
	oReport:line(nRow3+2200,100,nRow3+2200,2300) && Linha Horizontal
	oReport:line(nRow3+2270,100,nRow3+2270,2300) && Linha Horizontal
	oReport:line(nRow3+2340,100,nRow3+2340,2300) && Linha Horizontal

	oReport:line(nRow3+2200, 500,nRow3+2340, 500) && Linha Vertical
	oReport:line(nRow3+2270, 750,nRow3+2340, 750) && Linha Vertical
	oReport:line(nRow3+2200,1000,nRow3+2340,1000) && Linha Vertical
	oReport:line(nRow3+2200,1300,nRow3+2270,1300) && Linha Vertical
	oReport:line(nRow3+2200,1480,nRow3+2340,1480) && Linha Vertical

	oReport:say(nRow3+2000, 100,"local de Pagamento",oFont8)
	oReport:say(nRow3+2055, 100,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)

	oReport:say(nRow3+2000,1810,"Vencimento",oFont8)
	cString  := strZero(Day(aDadosTit[4]),2) +"/"+ strZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oReport:say(nRow3+2040,nCol,cString,oFont11c)

	oReport:say(nRow3+2100, 100,"Cedente",oFont8)

	oReport:say(nRow3+2140,100 ,aDadosEmp[1],oFont10)				&& Nome da Empresa

	oReport:say(nRow3+2100,1810,"Agçncia/Cçdigo Cedente",oFont8)
	cString  := alltrim(Subs(aDadosBanco[3],1,4))
	cString  += if(empty(Subs(aDadosBanco[3],5,1)),"","-"+Subs(aDadosBanco[3],5,1))+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	nCol 	 := 1810+(374-(len(cString)*22))+40
	oReport:say(nRow3+2140,nCol,cString ,oFont11c)

	oReport:say(nRow3+2200, 100,"Data do Documento",oFont8)
	oReport:say(nRow3+2230, 100, strZero(Day(aDadosTit[2]),2) +"/"+ strZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

	oReport:say(nRow3+2200, 505,"Nro.Documento",oFont8)
	oReport:say(nRow3+2230, 605,aDadosTit[6]+aDadosTit[1],oFont10) && Prefixo+Numero+Parcela

	oReport:say(nRow3+2200,1005,"Espçcie Doc.",oFont8)
	oReport:say(nRow3+2230,1050,aDadosTit[7],oFont10) && Tipo do Titulo

	oReport:say(nRow3+2200,1305,"Aceite",oFont8)
	oReport:say(nRow3+2230,1400,"N",oFont10)

	oReport:say(nRow3+2200,1485,"Data do Processamento",oFont8)
	oReport:say(nRow3+2230,1550,strZero(Day(aDadosTit[3]),2) +"/"+ strZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) && Data impressao

	oReport:say(nRow3+2200,1810,"Nosso Nçmero",oFont8)
	cString  := RetNossoNro() && Retorna o Nosso Nçmero Formatado
	nCol 	 := 1850+(374-(len(cString)*22))
	oReport:say(nRow3+2230,nCol,cString,oFont11c)

	oReport:say(nRow3+2270, 100,"Uso do Banco",oFont8)

	oReport:say(nRow3+2270, 505,"Carteira",oFont8)
	oReport:say(nRow3+2300, 555,aDadosBanco[7],oFont10)

	oReport:say(nRow3+2270, 755,"Espçcie",oFont8)
	oReport:say(nRow3+2300, 805,"R$",oFont10)

	oReport:say(nRow3+2270,1005,"Quantidade",oFont8)
	oReport:say(nRow3+2270,1485,"Valor",oFont8)

	oReport:say(nRow3+2270,1810,"Valor do Documento",oFont8)
	cString  := Transform(aDadosTit[5],"@E 99,999,999.99")
	nCol 	 := 1810+(374-(len(cString)*22))
	oReport:say(nRow3+2300,nCol,cString,oFont11c)

	oReport:say(nRow3+2340, 100,"Instruççes (Todas informaççes deste bloqueto sço de exclusiva responsabilidade do cedente)",oFont8)
	If !Empty(aFrases)
		oReport:say(nRow2+2440, 100,aFrases[1],oFont10)
		oReport:say(nRow2+2490, 100,aFrases[2],oFont10)
		oReport:say(nRow2+2540, 100,aFrases[3],oFont10)
		oReport:say(nRow2+2590, 100,aFrases[4],oFont10)
	EndIf
	oReport:say(nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
	oReport:say(nRow3+2410,1810,"(-)Outras Deduççes",oFont8)
	oReport:say(nRow3+2480,1810,"(+)Mora/Multa",oFont8)
	oReport:say(nRow3+2550,1810,"(+)Outros Acrçscimos",oFont8)
	oReport:say(nRow3+2620,1810,"(=)Valor Cobrado",oFont8)

	oReport:say(nRow3+2690, 100,"Sacado",oFont8)
	oReport:say(nRow3+2700, 400,aDadosSac[1]+" ("+aDadosSac[2]+")",oFont10)

	oReport:say(nRow3+2753, 400,aDadosSac[3],oFont10)
	oReport:say(nRow3+2806, 400,aDadosSac[4]+" - "+aDadosSac[5]+" - "+aDadosSac[6],oFont10) && Cidade+Estado+CEP

	oReport:say(nRow3+2868, 100,"Sacador/Avalista " + aDadosBanco[11],oFont8)
	oReport:say(nRow3+2908,1810,"Autenticação Mecânica",oFont8)

	oReport:line(nRow3+2000,1800,nRow3+2690,1800) && Linha Vertical
	oReport:line(nRow3+2410,1800,nRow3+2410,2300) && Linha Horizontal
	oReport:line(nRow3+2480,1800,nRow3+2480,2300) && Linha Horizontal
	oReport:line(nRow3+2550,1800,nRow3+2550,2300) && Linha Horizontal
	oReport:line(nRow3+2620,1800,nRow3+2620,2300) && Linha Horizontal
	oReport:line(nRow3+2690, 100,nRow3+2690,2300) && Linha Horizontal

	oReport:line(nRow3+2905, 100,nRow3+2905,2300) && Linha Horizontal

	oReport:say(nRow3+3060,1800,"FICHA DE COMPENSAÇÃO",oFont10)

	MSBAR3("INT25",24.7,1.1,cCodBarra,oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)

return

	&& #########################################################################
	&& FUNççES AUXILIARES
	&& #########################################################################

	&& Funçço de xfMod10 para retorno do dçgito verificador de Partes da Linha Digitçvel
	&& Baseada no Cçlculo do Banco do Brasil e na Funçço xfMod11
User Function xfMod10(cStr,nMultIni,nMultFim,cTipo)

	local nCont	  := 0
	local nSoma	  := 0
	local nRes	  := 0
	local cChar   := ""
	local nMult   := nMultIni
	local cRet	  := ""

	default nMultIni:= 2
	default nMultFim:= 1
	default cTipo   := "Dezena" && Tipo de Subtraçço Final "Dezena" ou "Divisor"

	&& Prepara a String
	cStr := alltrim(cStr)

	&& Percorre da Direita para a Esquerda
	For nCont := Len(cStr) to 1 Step -1
		&& Avalia se o Item ç um nçmero
		cChar := subStr(cStr,nCont,1)
		if isAlpha( cChar )
			Help(" ", 1, "ONLYNUM")
			return .f.
		End

		&& Calcula a multiplicaçço e se for maior que 9 soma os 2 algarismos para sempre retornar 1 dçgito
		nRes:= val(cChar) * nMult
		if nRes > 9
			nRes:= val(left(Str(nRes,2),1)) + val(Right(Str(nRes,2),1))
		endif

		&& Acumula a Soma da Multiplicaçço dos Elementos pelo Multiplicador
		nSoma += nRes

		&& Redefine o Novo Multiplicador
		nMult:= IIf(nMult==nMultfim,nMultIni,If(nMultIni>nMultfim,--nMult,++nMult))
	Next

	&& Calcula a Dezena imediatamente posterior a Soma Calculada
	nDezena := alltrim(Str(nSoma,12))
	nDezena := val(alltrim(Str(val(subStr(nDezena,1,1))+1,12))+"0")

	&& Calcula o Resto da Divisço
	nRest := Mod(nSoma,10)

	&& Calcula o DV Final
	if cTipo == "Dezena"
		cRet  := Right(Str(nDezena - nRest),1)
	elseif cTipo == "Divisor"
		if nRest == 0
			cRet := "0"
		else
			cRet := Right(Str(10 - nRest),1)
		endif
	endif

return (cRet)

	&& Funçço de xfMod11 do Padrço do Sistema (Fonte SM1M150) modificada para retorno do dçgito verificador de diversos bancos
	&& Uso de Exemplo:  Alert(U_xfMod11("28398200001",9,2,"001"))
User Function xfMod11(cStr,nMultIni,nMultFim,cBanco,nTipo)

	local nCont	  := 0
	local nSoma	  := 0
	local cChar   := ""
	local nMult   := nMultIni
	local cRet	  := ""

	default nMultIni:= 9
	default nMultFim:= 2
	default nTipo   := 1 && 1=Nosso Nçmero / 2=Codigo de Barras

	&& Prepara a String
	cStr := alltrim(cStr)

	&& Percorre da Direita para a Esquerda
	For nCont := Len(cStr) to 1 Step -1
		&& Avalia se o Item ç um nçmero
		cChar := subStr(cStr,nCont,1)
		if isAlpha( cChar )
			Help(" ", 1, "ONLYNUM")
			return .f.
		End

		&& Acumula a Soma da Multiplicaçço dos Elementos pelo Multiplicador
		nSoma += val(cChar) * nMult

		&& Redefine o Novo Multiplicador
		nMult:= IIf(nMult==nMultfim,nMultIni,If(nMultIni>nMultfim,--nMult,++nMult))
	Next

	&& Calcula o Resto da Divisço
	nRest := Mod(nSoma,11)

	&& Define Como serç o Resultado do Dçgito Verificador

	&& Se for Banco do Brasil
	if cBanco == "001"
		if nTipo == 1 && Para Nosso Nçmero
			if nRest < 10
				cRet:= Str(nRest,1)
			elseif nRest == 10
				cRet:= "X"
			endif

		elseif nTipo == 2 && Para Cçdigo de Barras
			nRest:= 11 - nRest
			if nRest == 0 .Or. nRest == 10 .Or. nRest == 11
				cRet:= "1"
			else
				cRet:= Str(nRest,1)
			endif
		endif

		&& Se for Bradesco
	elseif cBanco == "237" .or. (cBanco == "422" .and. nTipo == 2)
		&&if nRest == 0
		&&	cRet := "0"
		&&elseif nRest == 1 && 11 - 1 = 10 => P
		&&	cRet := "P"
		&&else
		nRest := 11-nRest
		cRet  := Str(nRest,1)
		&&endif

		&& Se for Safra
	elseif cBanco == "422" .and. nTipo == 1
		if nRest == 0
			cRet := "1"
		elseif nRest == 1 && 11 - 1 = 10 => P
			cRet := "0"
		else
			nRest := 11-nRest
			cRet  := Str(nRest,1)
		endif

		&& Se for Itau ou Votorantim
	elseif cBanco == "341" .or. cBanco == "655"
		nRest := 11-nRest
		nRest := Iif (nRest == 0 .Or. nRest == 1 .Or. nRest == 10 .Or. nRest == 11, 1 , nRest)
		cRet  := Str(nRest,1)

		&& Se for Caixa Econçmica Federal
	elseif cBanco == "104"
		nRest := 11-nRest
		nRest := Iif (nRest > 9, 0 , nRest)
		cRet  := Str(nRest,1)

		&& Se Banco nço Especificado ou nço constar tratamento para o banco - Considera o Cçlculo Padrço
	else
		nRest := IIf(nRest==0 .or. nRest==1, 0 , 11-nRest)
		cRet  := Str(nRest,1)

	endif

return cRet





Static function xfBuscar(xTitDe, xTitTe)
	local titDe :=	xTitDe
	local titTe :=	xTitTe

	default titDe	:=	""
	default titTe	:=	""

	if titDe > titTe .AND. !empty(titTe)
		Alert('Filtro incorreto')
		return
	endif




	cQuery 	:= 		 "SELECT "
	cQuery  += xcR + "	* "
	cQuery 	+= xcR + "FROM "
	cQuery 	+= xcR + "	vw_boletoReceber "

	if empty(titDe) .and. empty(titTe)
		cQuery 	+= xcR + "WHERE "
		cQuery 	+= xcR + "	E1_EMISSAO >= CONVERT(VARCHAR(08), GETDATE()-4, 112) AND "
		cQuery 	+= xcR + "	E1_NUMBCO = '' "
	elseif empty(titTe)
		titDe := Right('000000000' + alltrim(titDe), 9)
		cQuery 	+= xcR + "WHERE "
		cQuery 	+= xcR + "	E1_NUM = '" + titDe + "' "
	elseif !empty(titDe) .and. !empty(titTe)
		titDe := Right('000000000' + alltrim(titDe), 9)
		titTe := Right('000000000' + alltrim(titTe), 9)
		cQuery 	+= xcR + "WHERE "
		cQuery 	+= xcR + "	E1_NUM between '" + titDe + "' and '" + titTe + "' "
	endif

	cQuery 	+= xcR + "ORDER BY "
	cQuery 	+= xcR + "	1,2,3,4 "

	MemoWrite("C:\erp\sql\Boletos_filtro.SQL",cQuery)


	if select("XTT") > 0
		XTT->(dbclosearea())
	endif

	TcQuery StrTran(cQuery,xcR,"") New Alias XTT


	While !(XTIT->(EOF()))
		RecLock("XTIT",.F.,.T.)
		XTIT->(dbDelete())
		XTIT->(MsUnlOCK())

		XTIT->(dbSkip())
	Enddo


	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		dbSelectArea("XTIT")
		RecLock("XTIT",.T.)
		XTIT->OK   			:=	iif(empty(XTT->E1_NUMBCO), cMarca, '')
		XTIT->TIPO   		:=	XTT->E1_TIPO
		XTIT->PREFIXO   	:=	XTT->E1_PREFIXO
		XTIT->NUM  			:=	XTT->E1_NUM
		XTIT->PARCELA   	:=	XTT->E1_PARCELA
		XTIT->CLIENTE 		:=	XTT->E1_CLIENTE
		XTIT->LOJA 			:=	XTT->E1_LOJA
		XTIT->NOMCLI 		:=	XTT->E1_NOMCLI
		XTIT->NATUREZ   	:=	XTT->E1_NATUREZ
		XTIT->EMISSAO 		:=	STOD(XTT->E1_EMISSAO)
		XTIT->VENCTO 		:=	STOD(XTT->E1_VENCTO)
		XTIT->VENCREA 		:=	STOD(XTT->E1_VENCREA)
		XTIT->VALOR 		:=	XTT->E1_VALOR
		XTIT->SDACRES 		:=	XTT->E1_SDACRES
		XTIT->SDDECRE 		:=	XTT->E1_SDDECRE
		XTIT->SALDO 		:=	XTT->E1_SALDO
		XTIT->PEDIDO  		:=	XTT->E1_PEDIDO
		XTIT->NUMBCO   		:=	XTT->E1_NUMBCO
		XTIT->LEG  			:=	XTT->LEG

		dbSelectArea("XTT")
		XTT->(dbSkip())
	Enddo

	XTT->(dbCloseArea())
	XTIT->(dbGoTop())
	oMarkF:oBrowse:Refresh()
Return


Static function xfBuscaTit()

	cQuery 	:= 		 "SELECT "
	cQuery  += xcR + "	* "
	cQuery 	+= xcR + "FROM "
	cQuery 	+= xcR + "	vw_boletoReceber "
	cQuery 	+= xcR + "WHERE "
	cQuery 	+= xcR + "	E1_EMISSAO >= CONVERT(VARCHAR(08), GETDATE()-4, 112) AND "
	cQuery 	+= xcR + "	E1_NUMBCO = '' "
	cQuery 	+= xcR + "ORDER BY "
	cQuery 	+= xcR + "	1,2,3,4 "


	MemoWrite("C:\erp\sql\Boletos_inicial.SQL",cQuery)

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif

//Gera o Arquivo de Trabalho
	TcQuery StrTran(cQuery,xcR,"") New Alias XTT


	XTT->(dbGoTop())
	While !(XTT->(EOF()))



		dbSelectArea("XTIT")
		RecLock("XTIT",.T.)
		XTIT->OK   			:=	iif(empty(XTT->E1_NUMBCO), cMarca, '')
		XTIT->TIPO   		:=	XTT->E1_TIPO
		XTIT->PREFIXO   	:=	XTT->E1_PREFIXO
		XTIT->NUM  			:=	XTT->E1_NUM
		XTIT->PARCELA   	:=	XTT->E1_PARCELA
		XTIT->CLIENTE 		:=	XTT->E1_CLIENTE
		XTIT->LOJA 			:=	XTT->E1_LOJA
		XTIT->NOMCLI 		:=	XTT->E1_NOMCLI
		XTIT->NATUREZ   	:=	XTT->E1_NATUREZ
		XTIT->EMISSAO 		:=	STOD(XTT->E1_EMISSAO)
		XTIT->VENCTO 		:=	STOD(XTT->E1_VENCTO)
		XTIT->VENCREA 		:=	STOD(XTT->E1_VENCREA)
		XTIT->VALOR 		:=	XTT->E1_VALOR
		XTIT->SDACRES 		:=	XTT->E1_SDACRES
		XTIT->SDDECRE 		:=	XTT->E1_SDDECRE
		XTIT->SALDO 		:=	XTT->E1_SALDO
		XTIT->PEDIDO  		:=	XTT->E1_PEDIDO
		XTIT->NUMBCO   		:=	XTT->E1_NUMBCO
		XTIT->LEG  			:=	XTT->LEG

		dbSelectArea("XTT")
		XTT->(dbSkip())
	Enddo

	XTT->(dbCloseArea())
	XTIT->(dbGoTop())
Return

Static Function MBLegen()
	local aCores := {}

	Aadd(aCores, {"BR_VERMELHO"	,"Emitido"})
	Aadd(aCores, {"BR_VERDE"   	,"Emitir" })

	BrwLegenda("IMPRESSAO DE BOLETOS","LEGENDAS",aCores)//"Prepara‡„o dos Documentos de Sa¡da"/"Legenda"

Return(.T.)
