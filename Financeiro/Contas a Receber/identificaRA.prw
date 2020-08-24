#Include "Protheus.ch"
#Include "Topconn.ch"

/*
Programa para alteração do título RA não identificado
Assim que identificar o título, esta rotina pode ser utilizada para
Trocar o Cliente não identificado para o cliente correto.
*/

User Function xfIdentRA()

	Local xoDlg, xoCliente, xoLoja, xoNomCli, xoMarkF
	Local xaSize     	:= 	FWGetDialogSize( oMainWnd )
	Local xcCabecalho	:= 	"Selecionar Títulos para Classicifar"
	Local xlOK       	:= 	.F.
	Local xlInvert   	:= 	.F.
	Local xaCpos  	:= 	{}
	Local xcArqOP
	Private xaAlias 	:= 	{ {Alias()},{"SE1"},{"SA1"},{"SE5"}}
	Private xcQuery	:=	""
	Private xcR		:=	Char(13) + Char(10)
	Private xaCores	:=	{}
	Private xaStrut 	:=	{}
	Private xnTotNao	:=	0
	Private xnTotSim	:=	0
	Private xnTotal	:=	0
	Private xcCliente	:=	CriaVar("A1_COD")
	Private xcLoja	:=	CriaVar("A1_LOJA")
	Private xcNomCli	:=	CriaVar("A1_NOME")
	Private xcMarca	:= 	""



	Aadd( xaCpos,	{"OK"		,"",	""					} )
	Aadd( xaCpos,	{"FIL"		,"",	"Filial"			} )
	Aadd( xaCpos,	{"CLI"		,"",	"Cód Cliente"		} )
	Aadd( xaCpos,	{"LOJ"		,"",	"Loja"				} )
	Aadd( xaCpos,	{"NCL"		,"",	"Nome Cliente"	} )
	Aadd( xaCpos,	{"PRF"		,"",	"Prefixo"			} )
	Aadd( xaCpos,	{"TIT"		,"",	"Título"			} )
	Aadd( xaCpos,	{"PRC"		,"",	"Parcela"			} )
	Aadd( xaCpos,	{"NAT"		,"",	"Natureza"			} )
	Aadd( xaCpos,	{"BCO"		,"",	"Banco"			} )
	Aadd( xaCpos,	{"AGE"		,"",	"Agência"			} )
	Aadd( xaCpos,	{"CTA"		,"",	"Conta"			} )
	Aadd( xaCpos,	{"VLR"		,"",	"Valor"			} )
	Aadd( xaCpos,	{"SLD"		,"",	"Saldo"			} )
	Aadd( xaCpos,	{"EMS"		,"",	"Data Emissão"	} )
	Aadd( xaCpos,	{"VNR"		,"",	"Data Vencimento"	} )
	Aadd( xaCpos,	{"USR"		,"",	"Usuário"			} )
	Aadd( xaCpos,	{"LEG"		,"",	"Legenda"			} )


//Marck Browse Linha.

	Aadd( xaStrut , { "OK"	,	"C"	, 02 , 0 } )
	Aadd( xaStrut , { "FIL" ,	"C"	, 02 , 0 } )
	Aadd( xaStrut , { "CLI" ,	"C"	, 06 , 0 } )
	Aadd( xaStrut , { "LOJ"	,	"C"	, 02 , 0 } )
	Aadd( xaStrut , { "NCL"	,	"C"	, 35 , 0 } )
	Aadd( xaStrut , { "PRF"	,	"C"	, 03 , 0 } )
	Aadd( xaStrut , { "TIT"	,	"C"	, 09 , 0 } )
	Aadd( xaStrut , { "PRC"	,	"C"	, 02 , 0 } )
	Aadd( xaStrut , { "NAT"	,	"C"	, 10 , 0 } )
	Aadd( xaStrut , { "BCO"	,	"C"	, 03 , 0 } )
	Aadd( xaStrut , { "AGE"	,	"C"	, 05 , 0 } )
	Aadd( xaStrut , { "CTA"	,	"C"	, 10 , 0 } )
	Aadd( xaStrut , { "VLR"	,	"N"	, 14 , 0 } )
	Aadd( xaStrut , { "SLD"	,	"N"	, 14 , 2 } )
	Aadd( xaStrut , { "EMS"	,	"D"	, 08 , 2 } )
	Aadd( xaStrut , { "VNR"	,	"D"	, 08 , 0 } )
	Aadd( xaStrut , { "LEG"	,	"C"	, 01 , 0 } )
	Aadd( xaStrut , { "USR"	,	"C"	, 20 , 0 } )
	Aadd( xaStrut , { "REC"	,	"N"	, 14 , 0 } )

	xcArqOP := CriaTrab(xaStrut)

	If select("XTIT") > 0
		XTIT->(dbclosearea())
	EndIf

	dbUseArea(.T.,,xcArqOP,"XTIT",.F.,.F.)

// ******************** Monta query para selecao de dados no banco

	Processa( { || xsfProc() })


	Aadd(xaCores, {'XTIT->LEG == "A" ',"BR_PRETO"	})																												//COMISSÃO INCORRETA
	Aadd(xaCores, {'XTIT->LEG == "B" ',"BR_PINK"	})																												//COMISSÃO INCORRETA

	DbSelectArea( "XTIT" )
	XTIT->( DbGoTop() )

	xcMarca := XTIT->(GetMark())

	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)



	PRIVATE aButtons :=	{}
	Aadd(aButtons, {"Titulo", {|| xsfTransf()	}, "Titulo...", "Transfere Título  "	, {|| .T.}} )
	Aadd(aButtons, {"Legend", {|| HALegen()	}, "Legend...", "Legenda           "	, {|| .T.}} )


	Define MsDialog xoDlg Title xcCabecalho From xaSize[1], xaSize[2] To xaSize[3], xaSize[4] Pixel


	xoMarkF:= MsSelect():New("XTIT","OK",,xaCpos,@xlInvert,@xcMarca,{05,05,(xoDlg:nHeight/2)-120,(xoDlg:nWidth/2)-05},,,,,xaCores)
	xoMarkF:oBrowse:blDbLClick := {|| nRec := XTIT->(Recno()), RecLock("XTIT", .F.), XTIT->OK := Iif(xsfMarc(XTIT->(Recno())),Iif( XTIT->OK == xcMarca, ' ', xcMarca),''), MsUnLock(),XTIT->(DbGoTo(nRec)), xoMarkF:oBrowse:Refresh() }
	xoMarkF:oBrowse:bAllMark   := {|| nRec := XTIT->(Recno()), XTIT->(DbEval( {|| (RecLock("XTIT", .F.), XTIT->OK := Iif(xsfMarc(),Iif( XTIT->OK == xcMarca, ' ', xcMarca),''), MsUnLock()) })), XTIT->(DbGoTo(nRec)), xoMarkF:oBrowse:Refresh() }

	@ (xoDlg:nHeight/2)-90, 500 SAY oSay1 PROMPT "Total Não Identificado:  "  SIZE 150, 010 OF xoDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-90, 600 SAY oSay1 PROMPT Padl(Transform(xnTotNao,"@E 999,999,999.99"),15)  SIZE 150, 010 OF xoDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-78, 500 SAY oSay1 PROMPT "Total Identificado:      "  SIZE 150, 010 OF xoDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-78, 600 SAY oSay1 PROMPT Padl(Transform(xnTotSim,"@E 999,999,999.99"),15)  SIZE 150, 010 OF xoDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-66, 500 SAY oSay1 PROMPT "Total Geral:             "   SIZE 150, 010 OF xoDlg COLORS 0, 16777215 FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-66, 600 SAY oSay1 PROMPT Padl(Transform(xnTotal,"@E 999,999,999.99"),15	)  SIZE 150, 010 OF xoDlg COLORS 0, 16777215 FONT oFont20 PIXEL

	@ (xoDlg:nHeight/2)-90, 005 SAY oSay1 PROMPT "Selecione o Cliente"  SIZE 150, 010 OF xoDlg COLORS 150, 16777215 FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-78, 005 MSGET  xoCliente	VAR xcCliente	SIZE 040,010 PICTURE "@!S06" OF xoDlg F3 "SA101" VALID !Vazio() .and. EXISTCPO("SA1",xcCliente)  FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-66, 005 MSGET  xoLoja		VAR xcLoja		SIZE 020,010 PICTURE "@!S02" OF xoDlg FONT oFont20 PIXEL
	@ (xoDlg:nHeight/2)-54, 005 MSGET  xoNomCli	VAR xcNomCli	SIZE 200,010 PICTURE "@!S35" OF xoDlg FONT oFont20 PIXEL

	ACTIVATE MSDIALOG xoDlg ON INIT (EnchoiceBar(xoDlg,{||xlOK:=.T., Alert('ESCOLHA SUA OPÇÃO EM AÇÕES RELACIONADAS','ALERTA MB'),IIF(MSGYESNO('DESEJA SAIR?','ALERTA MB'),xoDlg:End(),.T.)},{||xoDlg:End()},,@aButtons))

Return()


Static Function xsfMarc(xnPosic)
	Local xnRec	:=	xnPosic
	Local xlRet	:=	.T.

	dbSelectArea('XTIT')
	dbGoTop()

	While !XTIT->(EOF())

		If XTIT->(Recno()) == xnRec
			If XTIT->LEG == 'B'
				MsgStop('TÍTULO JÁ TRANSFERIDO')
				xlRet	:=	.F.
				Exit
			EndIf
		Else
			If !Empty(AllTrim(XTIT->OK))
				MsgStop('VOCÊ JÁ SELECIONOU UM TÍTULO')
				xlRet	:=	.F.
				Exit
			EndIf
		EndIf


		XTIT->(dbSkip())

	EndDo

	XTIT->(dbGoto(xnRec))
Return xlRet


//Função para montar o Mark Browse.

Static Function xsfProc()
	
	xcQuery := 		"SELECT "
	xcQuery += xcR + 	"	E1_FILIAL FIL, E1_CLIENTE CLI, E1_LOJA LOJ, E1_NOMCLI NCL, "
	xcQuery += xcR + 	"	E1_PREFIXO PRF, E1_NUM TIT, E1_PARCELA PRC, "
	xcQuery += xcR + 	"	E1_NATUREZ NAT, E1_PORTADO BCO, E1_AGEDEP AGE, "
	xcQuery += xcR + 	"	E1_CONTA CTA, E1_VALOR VLR, E1_SALDO SLD, "
	xcQuery += xcR + 	"	E1_EMISSAO EMS, E1_VENCREA VNR, "
	xcQuery += xcR + 	"	CASE "
	xcQuery += xcR + 	"	WHEN E1_CLIENTE = '999998' THEN 'A' "
	xcQuery += xcR + 	"	ELSE 'B' "
	xcQuery += xcR + 	"	END LEG, E1_USERLGI USR, E1_LA CTB, R_E_C_N_O_ REC "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	" + RetSqlName('SE1') + " "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	E1_FILIAL <> '' AND "
	xcQuery += xcR + 	"	D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	E1_TIPO = 'RA' AND "
	xcQuery += xcR + 	"	E1_SALDO > 0 "
	xcQuery += xcR + 	"ORDER BY "
	xcQuery += xcR + 	"	16,1,2,3 "
	

	MemoWrite("\system\sql\Títulos RA Clientes não identificados.SQL",xcQuery)


	If Select('XTT') > 0
		DbSelectArea('XTT')
		DbCloseArea()
	EndIf

	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	XTT->(dbGoTop())

	xnTotNao	:=	0
	xnTotSim	:=	0
	xnTotal	:=	0

	While !(XTT->(EOF()))
	
	
		dbSelectArea("XTIT")
		RecLock("XTIT",.T.)

		XTIT->FIL	:= XTT->FIL
		XTIT->CLI	:= XTT->CLI
		XTIT->LOJ	:= XTT->LOJ
		XTIT->NCL	:= XTT->NCL
		XTIT->PRF	:= XTT->PRF
		XTIT->TIT	:= XTT->TIT
		XTIT->PRC	:= XTT->PRC
		XTIT->NAT	:= XTT->NAT
		XTIT->BCO	:= XTT->BCO
		XTIT->AGE 	:= XTT->AGE
		XTIT->CTA 	:= XTT->CTA
		XTIT->VLR 	:= XTT->VLR
		XTIT->SLD 	:= XTT->SLD
		XTIT->EMS 	:= STOD(XTT->EMS)
		XTIT->VNR 	:= STOD(XTT->VNR)
		XTIT->LEG	:= XTT->LEG
		XTIT->REC	:= XTT->REC

		dbSelectArea('SE1')
		SE1->(dbGoTo(XTT->REC))

		XTIT->USR 	:= FWLEUSERLG("SE1->E1_USERLGI",1)
		
		XTIT->(MsUnLock())
	
		If XTT->LEG == 'A'
			xnTotNao	+=	XTT->SLD
		Else
			xnTotSim	+=	XTT->SLD
		EndIf
		xnTotal	+=	XTT->SLD

		dbSelectArea("XTT")
		XTT->(dbSkip())
	Enddo

	XTT->(dbCloseArea())
	XTIT->(dbGoTop())
Return



Static Function xsfTransf()
	Local xlSelec		:=	.T.
	
	dbSelectArea("XTIT")
	XTIT->(dbGoTop())

	If Empty(AllTrim(xcCliente)) .OR. Empty(AllTrim(xcLoja)) .OR. Empty(AllTrim(xcNomCli))
		Alert('CLIENTE DESTINO, INCORRETO', 'ALERTA HIDROALL')
		Return
	EndIf

	dbSelectArea('SA1')
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())
	SA1->(dbSeek(xFilial('SA1') + xcCliente + xcLoja))

	If SA1->A1_MSBLQL = '1'
		Alert('CLIENTE BLOQUEADO', 'ALERTA HIDROALL')
		Return
	EndIf


	While !(XTIT->(EOF()))
		If XTIT->OK != xcMarca
			XTIT->(dbSkip())
			Loop
		Endif
		
		RecLock('XTIT',.F.)
		XTIT->CLI	:=	xcCliente
		XTIT->LOJ	:=	xcLoja
		XTIT->NCL	:=	xcNomCli
		XTIT->LEG	:=	'B'
		XTIT->OK	:=	''
		XTIT->(MsUnLock())

		xsfPrecTit(' ') 	//Transfere o Título para o cliente correto
		// xsfContab() 		//CHAMA A CONTABILIZAÇÃO
		// xsfPrecTit('S') 	//Salva a Contabilização
		xsfProc() 			//REPROCESSA A TELA
		xlSelec := .F.
		Exit
	Enddo
	If xlSelec
		Alert('NÃO FOI SELECIONADO NENHUM TÍTULO', 'ALERTA HIDROALL')
	EndIf
	
	XTIT->(dbGoTop())
	
Return



Static Function xsfPrecTit(xcTip)
	Local xcTipo	:=	xcTip

	dbSelectArea('SE1')
	SE1->(dbGoTo(XTIT->REC))
		
	dbSelectArea('SE5')
	SE5->(dbSetOrder(7))
	SE5->(dbGoTop())
	SE5->(dbSeek(SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA)))

	RecLock('SE5',.F.)
	SE5->E5_LA			:=	xcTipo
	SE5->E5_CLIFOR	:=	xcCliente
	SE5->E5_LOJA		:=	xcLoja
	SE5->E5_HISTOR	:=	"IDENTIFICACAO CLIENTE - " + AllTrim(xcNomCli)
	SE5->(MsUnLock())

	RecLock('SE1',.F.)
	SE1->E1_LA			:=	xcTipo
	SE1->E1_CLIENTE	:=	xcCliente
	SE1->E1_LOJA		:=	xcLoja
	SE1->E1_NOMCLI	:=	xcNomCli
	SE1->E1_HIST		:=	"IDENTIFICACAO CLIENTE - " + AllTrim(xcNomCli)
	SE1->(MsUnLock())

Return()



//Função para as Lgendas

Static Function HALegen()
	Local xaCores := {}

	Aadd(xaCores, {"BR_PRETO"  	,"Cliente Não Identificado"})
	Aadd(xaCores, {"BR_PINK" 	,"RA Aguardando Compensação" })

	BrwLegenda("IDENTIFICAÇÃO DE RA","LEGENDAS",xaCores)//"Prepara‡„o dos Documentos de Sa¡da"/"Legenda"

Return(.T.)

