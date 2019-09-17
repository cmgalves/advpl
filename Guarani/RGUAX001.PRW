#INCLUDE "XMLXFUN.CH"
#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#define CRLF	CHR(13)+CHR(10)

User Function RGUAX001
	Private aIndexADC	:=	{}
	Private bFiltraBrw	:=	{|| FilBrowse("ZB5",@aIndexADC,@cCondicao) }
	PRIVATE _cMarca		:=	GetMark(,"ZB5","ZB5_OK")
	PRIVATE aRotina		:=	{  { "Importar" ,"U_RGUAXI01" , 0 , 0},;//}//,; //"Ordem"
	{ "Remover Pedido" ,"U_RGUAXX01"  , 0 , 4}} //"Prep. Doc's"


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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATX001  �Autor  �Microsiga           � Data �  04/13/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATX001  �Autor  �Microsiga           � Data �  04/13/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Sincroniza os pedidos do SFA_fortaleza para a tabela ZC5   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11 Fortaleza                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

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

		MemoWrite("\sql\Itens N�o Importados ainda.SQL",xcQuery)

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
		arqTrab('clientes') //Executa a fun��o para retornar o arquivo de trabalho

		DbSelectArea("CLIENTES")
		DbGotop()
		ProcRegua(CLIENTES->(Recno()))
		While !CLIENTES->(Eof())
			lMsErroAuto := .F.

			aVetor:= {}
			aadd(aVetor,{"A1_LOJA"      ,'01'  									,Nil}) // Nome         C 40
			aadd(aVetor,{"A1_NOME"      ,ALLTRIM(CLIENTES->NOME)				,Nil}) // Nome         C 40
			aadd(aVetor,{"A1_PESSOA"    ,CLIENTES->PESSOA						,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_NREDUZ"    ,IF(EMPTY(CLIENTES->FANTASIA),CLIENTES->NOME,CLIENTES->FANTASIA)	,Nil}) // Nome reduz.  C 20
			aadd(aVetor,{"A1_END"       ,ALLTRIM(CLIENTES->ENDERECO)+", "+cvaltochar(CLIENTES->NUMERO)		,Nil}) // Endereco     C 40
			aadd(aVetor,{"A1_TIPO"      ,'R'    								,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_EST"       ,CLIENTES->EST							,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_COD_MUN"   ,CLIENTES->CODMUN						,Nil}) // Cidade       C 15
			aadd(aVetor,{"A1_BAIRRO"    ,ALLTRIM(CLIENTES->BAIRRO)				,Nil}) // Endereco     C 40
			aadd(aVetor,{"A1_CEP"       ,STRTRAN(CLIENTES->CEP,"-","")			,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_COMPL"     ,ALLTRIM(CLIENTES->COMPLEMENTO)			,Nil}) // Endereco     C 40
			aadd(aVetor,{"A1_CGC"  	 	,CLIENTES->CGCCPF						,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_INSCR"  	,CLIENTES->INSCR						,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_EMAIL"     ,CLIENTES->EMAIL    					,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_ZZMAIL2"   ,CLIENTES->EMAIL    					,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_DDD"     	,CLIENTES->DDD							,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TEL"     	,CLIENTES->TEL							,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_VEND"     	,ALLTRIM(CLIENTES->CLI_REPRESENTANTE)	,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TRANSP"    ,CLIENTES->TRANSP						,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_ZZTPBOL"   ,'2'									,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_ZZTXBOL"   ,'2'									,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_CONTRIB"   ,CLIENTES->CONTNAC						,Nil})  // se � simples nacional ou contribuinte
			aadd(aVetor,{"A1_SIMPNAC"   ,CLIENTES->CONTNAC						,Nil})  // se � simples nacional ou contribuinte
			aadd(aVetor,{"A1_ZZSITLL"   ,'001'									,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_ZZOBS"		,CLIENTES->OBSGERAL						,Nil})  // Observações do guarany
			aadd(aVetor,{"A1_CALCSUF"   ,'N'									,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TPESSOA"   ,'CI'									,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_MSBLQL"	,'2'									,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_REGIAO"	,CLIENTES->REGIAO						,Nil})  // Região do cliente
			aadd(aVetor,{"A1_ZZPERFI"	,CLIENTES->RAMO							,Nil})  // Ramo de atividades       C 02
			aadd(aVetor,{"A1_XCODGUA"	,CLIENTES->CODGUARANI					,Nil})  // Ramo de atividades       C 02
			aadd(aVetor,{"A1_XPREDIO"	,CLIENTES->PREDIO						,Nil})  // Ramo de atividades       C 02
			aadd(aVetor,{"A1_XREDE"		,CLIENTES->REDE							,Nil})  // Ramo de atividades       C 02
			aadd(aVetor,{"A1_XQTLOJA"	,CLIENTES->LOJAS						,Nil})  // Ramo de atividades       C 02
			aadd(aVetor,{"A1_XCHOUTS"	,CLIENTES->XCOUTS						,Nil})  // Ramo de atividades       C 02
			aadd(aVetor,{"A1_XQTFUNC"	,CLIENTES->FUNCS						,Nil})  // Ramo de atividades       C 02
			MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //Inclusao

			If lMsErroAuto
				MostraErro()
			else
				TCSPEXEC("guaraniIncluiReferenciasClientes")
			Endif

			CLIENTES->(DbSkip())
		EndDo
		CLIENTES->(DbCloseArea())
	EndIf

Return

static function arqTrab(xcTipo)
	local xcQuery		:=	''
	local xcR			:=	Char(13) + Char(10)

	If xcTipo == 'clientes'
		xcQuery := xcR + 	"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	guaraniIntegraClientesProtheus "


		MemoWrite("\sql\Clientes N�o Importados ainda.SQL",xcQuery)

		if select("CLIENTES") > 0
			CLIENTES->(dbclosearea())
		endif

		TcQuery StrTran(xcQuery,xcR,"") New Alias CLIENTES

	EndIf


	If xcTipo == 'pedidos'


		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	guaraniIntegraPedidosProtheus "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "


		MemoWrite("\sql\Pedidos N�o Importados ainda.SQL",xcQuery)

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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMX001  �Autor  �Microsiga           � Data �  08/15/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATX001  �Autor  �Microsiga           � Data �  04/13/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Importar()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)
	local codTabela		:=	''
	local ordemCli		:=	''

	PRIVATE lMsErroAuto := .F.
	BEGIN TRANSACTION
		aCabecalho:={}

		If !empty(alltrim(ZB5I->PEDIDO))
			Alert("Pedido "+Alltrim(ZB5I->ZB5_PEDEMP)+" j� importado no pedido de venda "+ZB5I->PEDIDO+"!!!")
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

		cQry2 := "SELECT ZB6_ITEM, ZB6_COD, ZB6_TABELA, ZB6_QTDVEN, ZB6_PRCVEN "
		cQry2 += "FROM " + RetSqlName("ZB6") + " ZB6 "
		cQry2 += "WHERE ZB6.D_E_L_E_T_ = ' ' "
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
			AADD(aLinha,{'C6_DESCRI',SB1->B1_DESC,NIL})
			AADD(aLinha,{'C6_QTDVEN',ZB6I->ZB6_QTDVEN,NIL})
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATX001  �Autor  �Microsiga           � Data �  05/18/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RGUAXX01
	If !MsgYesNo("Tem certeza que deseja remover este pedido da lista???")
		Return
	EndIf

	Reclock("ZB5",.F.)
	ZB5->ZB5_IMPORT	:= "2" //Cancelado
	MsUnlock()
	MsgInfo("Pedido retirado com sucesso!!!")
Return