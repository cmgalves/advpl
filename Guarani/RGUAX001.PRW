#INCLUDE "XMLXFUN.CH"
#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF	CHR(13)+CHR(10)

/*/{Protheus.doc} RGUAX001
	(long_description)
	@type  Function
	@author user
	@since 16/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/

User Function RGUAX001
	private aIndexADC	:=	{}
	private bFiltraBrw	:=	{|| FilBrowse("ZB5",@aIndexADC,@cCondicao) }
	private _cMarca		:=	GetMark(,"ZB5","ZB5_OK")
	private aRotina		:=	{  { "Importar" ,"U_RGUAXI01" , 0 , 0},;//}//,; //"Ordem"
	{ "Remover Pedido" ,"U_RGUAXX01"  , 0 , 4}} //"Prep. Doc's"


	// if 2 == 2
	// 	return
	// endif

	dbselectarea('PA3')

	Processa({||Sincronizar(),"Sincronizando..."})

	cCondicao   := 'ZB5_FILIAL=="'+xFilial("ZB5")+'"'
	If MsgYesNo("Lista somente pedidos pendentes?")
		cCondicao 	+= ' .And. ZB5_IMPORT=="0" '
	EndIf

	aCores := {	{'ZB5->ZB5_IMPORT=="0" ','BR_AMARELO' },;
		{'ZB5->ZB5_IMPORT=="1" ','BR_VERDE' },;	//Pedido de Venda liberado
	{'ZB5->ZB5_IMPORT=="2" ','BR_VERMELHO' }}	//Pedido de Venda liberado

	Eval(bFiltraBrw)
	ZB5->(DbSetOrder(1))
	MarkBrow("ZB5","ZB5_OK",,/*aCampos*/,/*lInverte*/,_cMarca,"U_RFATXMA1()",/**/,/*cexpini*/,/*cexpfin*/,/*"Allwaystrue"*/,/*bparbloco*/,/*cexprfiltop*/,/**/,aCores,/**/)

EndFilBrw("ZB5",aIndexADC)


Return


/*/{Protheus.doc} RFATXMA1
	(long_description)
	@type  Function
	@author user
	@since 16/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/

User Function RFATXMA1
	Local nRecno := Recno()
	dbSelectArea('ZB5')
	dbGotop()
	While !Eof()
		Reclock("ZB5",.F.)
		If Empty(ZB5->ZB5_OK)
			ZB5->ZB5_OK	:= _cMarca
		Else
			ZB5->ZB5_OK	:= ""
		EndIf
		MsUnlock()
		dbSkip()
	End
	dbGoto( nRecno )
Return

/*/{Protheus.doc} Sincronizar
	(long_description)
	@type  Function
	@author user
	@since 16/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function Sincronizar()
	local xcQuery		:=	''
	local xcR			:=	Char(13) + Char(10)
	local pedGuarani	:=	''

	arqTrab('pedidos')

	DbSelectArea("PEDIDO")
	DbGotop()
	ProcRegua(PEDIDO->(Recno()))
	While !PEDIDO->(Eof())
		IncProc("Pedido: "+PEDIDO->HPC_NUMPEDIDOEMP)
		pedGuarani := Padr(PEDIDO->HPC_NUMPEDIDOEMP,Tamsx3("ZB5_PEDEMP")[1])
		DbSelectArea("ZB5")
		DbSetOrder(1)
		If !DbSeek(xFilial("ZB5")+pedGuarani)
			RecLock("ZB5",.T.)
			ZB5->ZB5_IMPORT	:= '0'
			ZB5->ZB5_FILIAL	:= xFilial("ZB5")
			ZB5->ZB5_PEDEMP	:= pedGuarani
			ZB5->ZB5_PEDSFA	:= PEDIDO->HPC_NUMPEDIDOSFA
		Else
			RecLock("ZB5",.F.)
		EndIf
		ZB5->ZB5_SEQUEN	:= StrZero(PEDIDO->HPC_SEQUENCIAL,6)
		ZB5->ZB5_CLIENT	:= Substr(PEDIDO->CLIENTE,1,8)
		ZB5->ZB5_DTPED	:= CTOD(PEDIDO->HPC_DTPEDIDO)
		ZB5->ZB5_ORIGEM	:= PEDIDO->HPC_ORIGEMPEDIDO
		ZB5->ZB5_TPPED	:= PEDIDO->TIPOPED
		ZB5->ZB5_FRMPGT	:= PEDIDO->HPC_FORMAPAGAMENTO
		ZB5->ZB5_PLANO	:= PEDIDO->HPC_PLANOPAGAMENTO
		ZB5->ZB5_COND	:= PEDIDO->CONDPG
		ZB5->ZB5_VEND	:= StrZero(PEDIDO->HPC_REPRESENTANTE,3)
		ZB5->ZB5_TRANSP	:= PEDIDO->HPC_TRANSPORTADORA
		ZB5->ZB5_TABELA	:= PEDIDO->HPC_TABELAPRECO
		ZB5->ZB5_FRETMB := IF(ALLTRIM(PEDIDO->FRETEMB)=="C",'2',IF(ALLTRIM(PEDIDO->FRETEMB)=="F",'4',IF(ALLTRIM(PEDIDO->FRETEMB)=="S",'3','1')))
		ZB5->ZB5_DTSINC	:= PEDIDO->HPC_DATASINCRONIZACAO
		ZB5->ZB5_DTIMP	:= DATE()
		ZB5->ZB5_HRIMP	:= TIME()
		ZB5->ZB5_OBS	:= PEDIDO->OBSPED
		ZB5->ZB5_PEDCLI	:= PEDIDO->ORDEMCLI
		ZB5->(MsUnlock())

		_cItem := "01"

		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	HPI_SEQUENCIAL numSequen, "
		xcQuery += xcR + 	"	HPI_CODIGOPRODUTO codProd, HPI_DESCRICAOPRODUTO descProd, "
		xcQuery += xcR + 	"	HPI_QTDEVENDIDA qtdeVend, HPI_VALORVENDA vlrVenda, "
		xcQuery += xcR + 	"	HPI_VALORTOTAL vlrTotal, HPI_ALIQUOTAIPI aliqIpi, "
		xcQuery += xcR + 	"	HPI_VALORIPI vlrIpi, HPI_VALORST vlrSt, "
		xcQuery += xcR + 	"	HPI_CODIGOTABELA tabItens, HPI_VALORTABELA tabValor, HPI_NCM ncmProd, "
		xcQuery += xcR + 	"	HPI_DESCONTO desconto, HPI_VALORDESCONTO vlrDesc "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	AND_HISTPEDITENS ITENS "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	HPI_NUMPEDIDOEMP = '" + pedGuarani + "' "

		MemoWrite("\sql\Itens Nao Importados ainda.SQL",xcQuery)

		if select("ITENS") > 0
			ITENS->(dbclosearea())
		endif


		TcQuery StrTran(xcQuery,xcR,"") New Alias ITENS

		DbSelectArea("ITENS")
		DbGotop()
		While !ITENS->(Eof())
			DbSelectArea("ZB6")
			DbSetOrder(1)
			If DbSeek(xFilial("ZB6")+pedGuarani+StrZero(ITENS->numSequen,6))
				RecLock("ZB6",.F.)
			Else
				RecLock("ZB6",.T.)
				ZB6->ZB6_FILIAL	:= xFilial("ZB6")
				ZB6->ZB6_PEDEMP	:= pedGuarani
				ZB6->ZB6_SEQUEN	:= StrZero(ITENS->numSequen,6)
			EndIf
			ZB6->ZB6_ITEM	:= _cItem
			ZB6->ZB6_COD	:= ITENS->codProd
			ZB6->ZB6_DESCRI	:= ITENS->descProd
			ZB6->ZB6_QTDVEN	:= ITENS->qtdeVend
			ZB6->ZB6_PRCVEN	:= ITENS->vlrVenda
			ZB6->ZB6_TABELA	:= ITENS->tabItens
			ZB6->ZB6_PRUNIT	:= ITENS->tabValor
			ZB6->ZB6_VALOR	:= ITENS->vlrTotal
			ZB6->ZB6_IPI	:= ITENS->aliqIpi
			ZB6->ZB6_VALIPI	:= ITENS->vlrIpi
			ZB6->ZB6_VALST	:= ITENS->vlrSt
			ZB6->ZB6_NCM	:= ITENS->ncmProd
			ZB6->ZB6_DESCON	:= ITENS->desconto
			ZB6->ZB6_VALDES	:= ITENS->vlrDesc
			ZB6->(MsUnlock())

			_cItem := Soma1(_cItem)

			ITENS->(DbSkip())
		EndDo
		ITENS->(DbCloseArea())


		PEDIDO->(DbSkip())
	EndDo
	PEDIDO->(DbCloseArea())


	If MsgYesNo("Importar os clientes??")
		aUF := {}
		aadd(aUF,{"RO","11"})
		aadd(aUF,{"AC","12"})
		aadd(aUF,{"AM","13"})
		aadd(aUF,{"RR","14"})
		aadd(aUF,{"PA","15"})
		aadd(aUF,{"AP","16"})
		aadd(aUF,{"TO","17"})
		aadd(aUF,{"MA","21"})
		aadd(aUF,{"PI","22"})
		aadd(aUF,{"CE","23"})
		aadd(aUF,{"RN","24"})
		aadd(aUF,{"PB","25"})
		aadd(aUF,{"PE","26"})
		aadd(aUF,{"AL","27"})
		aadd(aUF,{"MG","31"})
		aadd(aUF,{"ES","32"})
		aadd(aUF,{"RJ","33"})
		aadd(aUF,{"SP","35"})
		aadd(aUF,{"PR","41"})
		aadd(aUF,{"SC","42"})
		aadd(aUF,{"RS","43"})
		aadd(aUF,{"MS","50"})
		aadd(aUF,{"MT","51"})
		aadd(aUF,{"GO","52"})
		aadd(aUF,{"DF","53"})
		aadd(aUF,{"SE","28"})
		aadd(aUF,{"BA","29"})
		aadd(aUF,{"EX","99"})


		xcQuery := xcR + 	"SELECT "
		xcQuery += xcR + 	"	CAST(CLI_CODIGOMUNICIPIO AS VARCHAR(7)) CODMUN, "
		xcQuery += xcR + 	"	CLI_SEQUENCIAL, CLI_CODIGOCLIENTE, RTRIM(CLI_RAZAOSOCIAL) CLI_RAZAOSOCIAL, "
		xcQuery += xcR + 	"	CLI_CGCCPF CGCCPF, CLI_INSCRESTADUAL INSCR, CLI_ENDERECO ENDERECO, "
		xcQuery += xcR + 	"	CLI_NUMERO NUMERO, CLI_COMPLEMENTO COMPLEMENTO, CLI_BAIRRO BAIRRO, "
		xcQuery += xcR + 	"	CLI_TELEFONE TELEFONE, CLI_FAX, CLI_CEP CEP, CLI_STATUS, "
		xcQuery += xcR + 	"	CLI_NOMEFANTASIA, CLI_DATACADASTRO, CLI_CODREGIAO, CLI_CONDICAOENTREGA, "
		xcQuery += xcR + 	"	CLI_CODRAMO, CLI_CODTABPRECO, CLI_ULTIMACOMPRA,CLI_ULTIMAVISITA, "
		xcQuery += xcR + 	"	CLI_OBSCREDITO, CLI_OBSGERAL, CLI_EMAIL, CLI_PRAZOMAXIMO, "
		xcQuery += xcR + 	"	CLI_CODIGOFORMAPGTO, CLI_FORMASPAGAMENTOS, CLI_DESCFIDELIDADE, "
		xcQuery += xcR + 	"	CLI_BLOQUEADO, CLI_ALTTABPRECO, CLI_CODIGOCONDPGTO, CLI_FINANCEIRO, "
		xcQuery += xcR + 	"	CLI_PRAZOMINIMOENT, CLI_PRAZOMAXIMOFAT, CLI_OBRIGARMULTIPLOEMB, "
		xcQuery += xcR + 	"	CLI_CLIENTEVIP, CLI_MOTIVOBLOQUEIO, CLI_TIPOPESSOA, CLI_TRANSPORTADORA, "
		xcQuery += xcR + 	"	CLI_DESCONTO, CLI_TRATARLIMITECRED, CLI_TOLERANCIALIMITECRED, "
		xcQuery += xcR + 	"	CLI_EMPRESAS, CLI_PRACA, CLI_LATITUDE, CLI_LONGITUDE, CLI_PESSOA, "
		xcQuery += xcR + 	"	CLI_ENDERECOENTREGA, CLI_NUMEROENTREGA, CLI_COMPLEMENTOENTREGA, "
		xcQuery += xcR + 	"	CLI_BAIRROENTREGA, CLI_CODMUNICIPIOENTREGA, CLI_CEPENTREGA, "
		xcQuery += xcR + 	"	CLI_ENDERECOCOBRANCA, CLI_NUMEROCOBRANCA, CLI_COMPLEMENTOCOBRANCA, "
		xcQuery += xcR + 	"	CLI_BAIRROCOBRANCA, CLI_CODMUNICIPIOCOBRANCA, CLI_CEPCOBRANCA, "
		xcQuery += xcR + 	"	CLI_EMAILSECUNDARIO, CLI_EMAILNF, CLI_CODIGOGRUPOCLIENTE, "
		xcQuery += xcR + 	"	CLI_PERCFRETE, CLI_EMPRESAPADRAO, CLI_PEDIDOMINIMO, "
		xcQuery += xcR + 	"	CLI_PARCELAMINIMA, CLI_IMPORTADO, CLI_REPRESENTANTE, "
		xcQuery += xcR + 	"	CLI_GUA_COD, CLI_FINANCEIROISENTO, CLI_DATAFUNDACAO, "
		xcQuery += xcR + 	"	CLI_SUFRAMA, CLI_NOMEREFERENCIA1, CLI_NOMEREFERENCIA2, "
		xcQuery += xcR + 	"	CLI_NOMEREFERENCIA3, CLI_FONEREFERENCIA1, CLI_FONEREFERENCIA2, "
		xcQuery += xcR + 	"	CLI_FONEREFERENCIA3, CLI_AREACOMERCIAL, CLI_FAIXAFATURAMENTO, "
		xcQuery += xcR + 	"	CLI_REFERENCIABANCARIA, CLI_PREDIOPROPRIO, "
		xcQuery += xcR + 	"	CLI_FINANCEIRO_APLICA_TABELA, CLI_POSSUIREDE, "
		xcQuery += xcR + 	"	CLI_NUMEROLOJAS, CLI_NUMEROCHECKOUTS, CLI_QTDEFUNCIONARIOS, "
		xcQuery += xcR + 	"	CLI_LIMITECREDBONIF, CLI_REGIMEESPECIAL, CLI_SIVISA_VALIDADE, "
		xcQuery += xcR + 	"	CLI_CRF_VALIDADE, CLI_SIVISA_REGISTRO, CLI_CRF_REGISTRO "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	AND_CLIENTES "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	NOT EXISTS "
		xcQuery += xcR + 	"	( "
		xcQuery += xcR + 	"	SELECT "
		xcQuery += xcR + 	"		A1_COD "
		xcQuery += xcR + 	"	FROM "
		xcQuery += xcR + 	"		SA1010 "
		xcQuery += xcR + 	"	WHERE "
		xcQuery += xcR + 	"		A1_FILIAL = '  ' AND "
		xcQuery += xcR + 	"		D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"		A1_CGC = REPLACE(REPLACE(REPLACE(CLI_CGCCPF,'.',''),'-',''),'/','') "
		xcQuery += xcR + 	"	) "

		MemoWrite("\sql\Clientes Não Importados ainda.SQL",xcQuery)

		if select("CLIENTES") > 0
			CLIENTES->(dbclosearea())
		endif

		TcQuery StrTran(xcQuery,xcR,"") New Alias CLIENTES

		DbSelectArea("CLIENTES")
		DbGotop()
		ProcRegua(CLIENTES->(Recno()))
		While !CLIENTES->(Eof())
			_cCgcCpf	:=	alltrim(STRTRAN(STRTRAN(STRTRAN(CLIENTES->CGCCPF,".",""),"-",""),"/",""))
			_cCodEst	:=	SUBSTR(CLIENTES->CODMUN,1,2)
			_cEst		:=	aUF[aScan(aUF,{|x| x[2] == _cCodEst}),1]
			_cCodMun	:=	SUBSTR(CLIENTES->CODMUN,3,5)
			DbSelectArea("SA1")
			DbSetOrder(3)
			If !DbSeek(xFilial("SA1")+Padr(_cCgcCpf,14))
				lMsErroAuto := .F.
				aVetor:= {}

				RecLock('SA1',.T.)
				SA1->A1_FILIAL := xFilial('SA1')
				SA1->A1_COD := U_numSa1()
				SA1->A1_LOJA    := '01'
				SA1->A1_NOME    := CLIENTES->CLI_RAZAOSOCIAL
				SA1->A1_PESSOA  := CLIENTES->CLI_PESSOA		
				SA1->A1_NREDUZ  := IF(EMPTY(CLIENTES->CLI_NOMEFANTASIA),CLIENTES->CLI_RAZAOSOCIAL,CLIENTES->CLI_NOMEFANTASIA)
				SA1->A1_END     := ALLTRIM(CLIENTES->ENDERECO)+", "+cvaltochar(CLIENTES->NUMERO)
				SA1->A1_TIPO    := 'R'    
				SA1->A1_EST     := _cEst
				SA1->A1_COD_MUN := _cCodMun
				SA1->A1_BAIRRO  := ALLTRIM(CLIENTES->BAIRRO)
				SA1->A1_CEP     := STRTRAN(CLIENTES->CEP,"-","")
				SA1->A1_COMPLEM := ALLTRIM(CLIENTES->COMPLEMENTO)
				SA1->A1_CGC     := _cCgccpf
				SA1->A1_INSCR   := IF(CLIENTES->CLI_PESSOA=='F','ISENTO',CLIENTES->INSCR)
				SA1->A1_EMAIL   := ALLTRIM(CLIENTES->CLI_EMAIL)
				SA1->A1_ZZMAIL2 := ALLTRIM(CLIENTES->CLI_EMAIL)
				SA1->A1_DDD    := Substr(ALLTRIM(CLIENTES->TELEFONE),2,2)
				SA1->A1_TEL     := Substr(ALLTRIM(CLIENTES->TELEFONE),5,10)
				SA1->A1_VEND    := CLIENTES->CLI_REPRESENTANTE
				SA1->A1_TRANSP  := CLIENTES->CLI_TRANSPORTADORA
				SA1->A1_ZZTPBOL := '2'
				SA1->A1_ZZTXBOL := '2'
				SA1->A1_CONTRIB := IF('ISEN'$CLIENTES->INSCR,'1','2')
				SA1->A1_SIMPNAC := IF('ISEN'$CLIENTES->INSCR,'1','2')
				SA1->A1_ZZSITLL := '001'
				SA1->A1_CALCSUF := 'N' 
				SA1->A1_TPESSOA := 'CI'
				SA1->A1_MSBLQL  := '2'
				MsUnlock('SA1')

				/*
				//aadd(aVetor,{"A1_LOJA"      ,'01'  ,Nil}) // Nome         C 40
				aadd(aVetor,{"A1_NOME"      ,CLIENTES->CLI_RAZAOSOCIAL  ,Nil}) // Nome         C 40
				aadd(aVetor,{"A1_PESSOA"    ,CLIENTES->CLI_PESSOA				    ,Nil}) // Tipo         C 01 //R Revendedor
				aadd(aVetor,{"A1_NREDUZ"    ,IF(EMPTY(CLIENTES->CLI_NOMEFANTASIA),CLIENTES->CLI_RAZAOSOCIAL,CLIENTES->CLI_NOMEFANTASIA)		 ,Nil}) // Nome reduz.  C 20
				aadd(aVetor,{"A1_END"       ,ALLTRIM(CLIENTES->ENDERECO)+", "+cvaltochar(CLIENTES->NUMERO)	 ,Nil}) // Endereco     C 40
				aadd(aVetor,{"A1_TIPO"      ,'R'    ,Nil}) // Tipo         C 01 //R Revendedor
				aadd(aVetor,{"A1_EST"       ,_cEst				    ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_COD_MUN"   ,_cCodMun	 ,Nil}) // Cidade       C 15
				aadd(aVetor,{"A1_BAIRRO"    ,ALLTRIM(CLIENTES->BAIRRO)	 ,Nil}) // Endereco     C 40
				aadd(aVetor,{"A1_CEP"       ,STRTRAN(CLIENTES->CEP,"-","")				    ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_COMPL"     ,ALLTRIM(CLIENTES->COMPLEMENTO) ,Nil}) // Endereco     C 40
				aadd(aVetor,{"A1_CGC"  	 	,_cCgccpf	,Nil}) // Tipo         C 01 //R Revendedor
				aadd(aVetor,{"A1_INSCR"  	 ,IF(CLIENTES->CLI_PESSOA=='F','ISENTO',CLIENTES->INSCR)	,Nil}) // Tipo         C 01 //R Revendedor
				aadd(aVetor,{"A1_EMAIL"     ,ALLTRIM(CLIENTES->CLI_EMAIL)    ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_ZZMAIL2"     ,ALLTRIM(CLIENTES->CLI_EMAIL)    ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_DDD"     	,'0'+Substr(ALLTRIM(CLIENTES->TELEFONE),2,2),Nil})  // Estado       C 02
				aadd(aVetor,{"A1_TEL"     	,Substr(ALLTRIM(CLIENTES->TELEFONE),5,10),Nil})  // Estado       C 02
				aadd(aVetor,{"A1_VEND"     ,CLIENTES->CLI_REPRESENTANTE    ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_TRANSP"    ,CLIENTES->CLI_TRANSPORTADORA    ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_ZZTPBOL"   ,'2'   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_ZZTXBOL"   ,'2'   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_CONTRIB"   ,IF('ISEN'$CLIENTES->INSCR,'1','2')   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_SIMPNAC"   ,IF('ISEN'$CLIENTES->INSCR,'1','2')   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_ZZSITLL"   ,'001'   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_CALCSUF"   ,'N'   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_TPESSOA"   ,'CI'   ,Nil})  // Estado       C 02
				aadd(aVetor,{"A1_MSBLQL"   ,'2'   ,Nil})  // Estado       C 02
				MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //Inclusao
				If lMsErroAuto
					MostraErro()
				Endif*/
			EndIf
			CLIENTES->(DbSkip())
		EndDo
		CLIENTES->(DbCloseArea())
	EndIf


Return

static function arqTrab(xcTipo)
	local xcQuery		:=	''
	local xcR			:=	Char(13) + Char(10)

	If xcTipo == 'pedidos'
		/*
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	guaraniIntegraPedidosProtheus "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "*/

		MemoWrite("\sql\Pedidos Nao Importados ainda.SQL",xcQuery)

		if select("PEDIDO") > 0
			PEDIDO->(dbclosearea())
		endif

		TcQuery StrTran(xcQuery,xcR,"") New Alias PEDIDO
	EndIf

	If xcTipo == 'impPedidos'

		xcQuery := xcR + 	"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	guaraniIntegraPedidosCabec "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	ZB5_OK = '" + _cMarca + "' "

		MemoWrite("\sql\GUARANI guaraniIntegraPedidosCabec.SQL",xcQuery)

		if select("ZB5I") > 0
			ZB5I->(dbclosearea())
		endif

		TcQuery StrTran(xcQuery,xcR,"") New Alias ZB5I

	EndIf
return


/*/{Protheus.doc} RGUAXI01
	(long_description)
	@type  Function
	@author user
	@since 18/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/

User Function RGUAXI01

	_nRecOri := ZB5->(Recno())

	arqTrab('impPedidos')


	DbSelectArea("ZB5I")
	DbGotop()
	While !ZB5I->(Eof())
		DbSelectArea("ZB5")
		DbGoto(ZB5I->R_E_C_N_O_)
		Processa({||Importar(),"Processando pedido: "+ZB5I->ZB5_PEDEMP})
		ZB5I->(DbSkip())
	EndDo
	ZB5I->(DbCloseArea())
	ZB5->(DbGoto(_nRecOri))



Return

/*/{Protheus.doc} Importar
	(long_description)
	@type  Function
	@author user
	@since 16/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/

Static Function Importar()
	local cQry2		:=	""
	local xcR			:=	Char(13) + Char(10)
	local codTabela		:=	''
	local ordemCli		:=	''

	PRIVATE lMsErroAuto := .F.
	BEGIN TRANSACTION
		aCabecalho:={}

		If !empty(alltrim(ZB5I->PEDIDO))
			Alert("Pedido "+Alltrim(ZB5I->ZB5_PEDEMP)+" jA importado no pedido de venda " + ZB5I->PEDIDO + "!!!")
			DisarmTransaction()
			Return
		EndIf
		ordemCli := ZB5I->ORDEMCLI

		aCabecalho  := {{'C5_FILIAL',xFilial("SC5"),NIL},;
			{'C5_TIPO',"N",NIL},;
			{'C5_CLIENTE',ZB5I->A1_COD,NIL},;
			{'C5_LOJACLI',ZB5I->A1_LOJA,NIL},;
			{'C5_CLIENT',ZB5I->A1_COD,NIL},;
			{'C5_LOJAENT',ZB5I->A1_LOJA,NIL},;
			{'C5_ZZNOMFC',ZB5I->A1_NOME,NIL},;
			{'C5_ZZTPOPE',ZB5I->TPOPER,NIL},;
			{'C5_FRETEMB',ZB5I->ZB5_FRETMB,NIL},;
			{'C5_VEND1'	 ,ZB5I->RC,NIL},;
			{'C5_VEND2'	 ,ZB5I->SUP,NIL},;
			{'C5_VEND3'	 ,ZB5I->GER,NIL},;
			{'C5_EMISSAO',DDATABASE,NIL},;
			{'C5_CONDPAG',ZB5I->ZB5_COND,NIL},;
			{'C5_TPCARGA',"1",NIL},; // Indica que utiliza carga p/ OMS
		{'C5_TABELA',ZB5I->ZB5_TABELA,NIL},;
			{'C5_MOEDA',1,NIL},;
			{'C5_ZZOBPED',ZB5I->ZB5_OBS,NIL},;
			{'C5_MENNOTA','O.C. ' + ordemCli,NIL},;
			{'C5_REDESP',ZB5I->ZB5_TRANSP,NIL},;
			{'C5_XPEDEMP',ZB5I->ZB5_PEDEMP,NIL}}		// Linha (Tabela B ou R)

		cQry2 := "SELECT ZB6_ITEM, ZB6_COD, ZB6_TABELA, ZB6_QTDVEN, ZB6_PRCVEN " + xcR
		cQry2 += "FROM " + RetSqlName("ZB6") + " ZB6 " + xcR
		cQry2 += "WHERE ZB6.D_E_L_E_T_ = ' ' " + xcR
		cQry2 += "AND ZB6_PEDEMP='" + ZB5I->ZB5_PEDEMP + "' "

		TCQUERY CQRY2 NEW ALIAS 'ZB6I'

		DBSELECTAREA('ZB6I')
		DBGOTOP()
		ProcRegua(ZB6I->(RecCount()))

		aItens:={}
		numItem:="00"
		While !ZB6I->(EOF())
			IncProc("Processando item " + ZB6I->ZB6_COD)
			aLinha:={}
			numItem	:=	SOMA1(numItem,2)

			if empty(alltrim(ZB6I->ZB6_TABELA))
				codTabela := ZB5I->ZB5_TABELA
			else
				codTabela := ZB6I->ZB6_TABELA
			endif
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+ZB6I->ZB6_COD)

			dbselectar("SF4")
			dbsetorder(1)
			dbseek(xfilial()+SB1->B1_TS)

			dbselectar("DA0")
			dbsetorder(1)
			dbseek(xfilial("DA0")+codTabela)

			dbselectar("DA1")
			dbsetorder(1)
			dbseek(xfilial("DA1")+codTabela+SB1->B1_COD)

			AADD(aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
			AADD(aLinha,{'C6_ITEM',ZB6I->ZB6_ITEM,NIL})
			AADD(aLinha,{'C6_ZTABELA',codTabela,NIL})
			AADD(aLinha,{'C6_PRODUTO',SB1->B1_COD,NIL})
			AADD(aLinha,{'C6_XITEORI',SB1->B1_COD,NIL})
			AADD(aLinha,{'C6_DESCRI',SB1->B1_DESC,NIL})
			AADD(aLinha,{'C6_QTDVEN',ZB6I->ZB6_QTDVEN,NIL})
			AADD(aLinha,{'C6_XQTDORI',ZB6I->ZB6_QTDVEN,NIL})
			AADD(aLinha,{'C6_ZPRCUNI',ZB6I->ZB6_PRCVEN,NIL})
			AADD(aLinha,{'C6_ITEMPC',ZB6I->ZB6_ITEM,NIL})
			AADD(aLinha,{'C6_NUMPCOM',ordemCli,NIL})

			AADD(aItens,aLinha)
			ZB6I->(dbskip())
		Enddo
		ZB6I->(DbCloseArea())

		If Len(aItens) == 0
			Alert("Sem Itens")
		EndIf
		If Len(aItens) > 0 .and. Len(aCabecalho) > 0
			msExecAuto({|x,y,z|Mata410(x,y,z)},aCabecalho,aItens,3)
			If lmsErroAuto
				lErroimp:=.t.
				MOSTRAERRO()
				LMSERROAUTO:=.F.
			Else
				CONFIRMSX8()
				Reclock("ZB5",.F.)
				ZB5->ZB5_IMPORT := '1' //pedido importado
				ZB5->ZB5_OK 	:= '' //Limpa a marca
				ZB5->ZB5_NUM	:= SC5->C5_NUM
				MsUnlock()
			Endif
		EndIf
	END TRANSACTION
Return

/*/{Protheus.doc} RGUAXX01
	(long_description)
	@type  Function
	@author user
	@since 16/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function RGUAXX01
	If !MsgYesNo("Tem certeza que deseja remover este pedido da lista???")
		Return
	EndIf

	Reclock("ZB5",.F.)
	ZB5->ZB5_IMPORT	:= "2" //Cancelado
	MsUnlock()
	MsgInfo("Pedido retirado com sucesso!!!")
Return







