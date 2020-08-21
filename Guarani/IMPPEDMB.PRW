#INCLUDE "XMLXFUN.CH"
#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"

User function MbGrn001()

nOpcao := Aviso("Seleção de Integrador", "Selecione a Informação que deseja trabalhar:", { "Pedidos", "Clientes" }, 1)

If nOpcao == 1
	Private aRotina :={}
	Private _aPergs := {}
	Private _aRet
	aCores := {	{'ZB5->ZB5_IMPORT=="0" ','BR_AMARELO' },;
				{'ZB5->ZB5_IMPORT=="1" ','BR_VERDE' },;	//Pedido de Venda liberado
				{'ZB5->ZB5_IMPORT=="2" ','BR_VERMELHO' }}	//Pedido de Venda liberado

	//P=Pendente;A=Aprovada;R=Reprovada

	Default cCli := ''
	Default clj  := ''

	cFiltro := ''

	aAdd(_aPergs,{2,"Status Pedido",1,{"Todos","0-Não Importados","1-Importados","2-Cancelados"},60,,.F.})
	aAdd(_aPergs,{1,"Recebimento De"  ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
	aAdd(_aPergs,{1,"Recebimento Até"  ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
		
	If ParamBox(_aPergs ,"Filtros para abertura",@_aRet,,,,,,,,.T.,.T.)    
		cFiltro := ''
	else
		Return()
	EndIf

	cCadastro := 'Painel de Pedidos MB - Guarani X ERP'
	aRotina := { { "Pesquisar"           ,  "AxPesqui"           , 0 , 1   },;
				{ "Visualizar Ped. Guarani"  ,  "U_VerPvGrn()"  , 0 , 2   },;
				{ "Visualizar Ped. Protheus" ,  "U_VerPvPrt()"  , 0 , 3   },;
				{ "Documentos"               ,  "MsDocument"    , 0 , 4,  }}
				
	mBrowse( 6, 1,22,75,"ZB5",,,,,,aCores,,,,,,,,cFiltro)

Else

	Private aRotina :={}
	Private _aPergs := {}
	Private _aRet
	aCores := {	{'ZA1->ZA1_STATUS=="0" ','BR_AMARELO' },;
				{'ZA1->ZA1_STATUS=="1" ','BR_VERDE' },;	//Pedido de Venda liberado
				{'ZA1->ZA1_STATUS=="2" ','BR_CINZA' }}	//Pedido de Venda liberado

	//P=Pendente;A=Aprovada;R=Reprovada

	Default cCli := ''
	Default clj  := ''

	cFiltro := ''

	aAdd(_aPergs,{2,"Status Clientes",1,{"Todos","0-Não Importados","1-Importados","2-Com Advertencia"},60,,.F.})
	aAdd(_aPergs,{1,"Recebimento De"  ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
	aAdd(_aPergs,{1,"Recebimento Até"  ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
		
	If ParamBox(_aPergs ,"Filtros para abertura",@_aRet,,,,,,,,.T.,.T.)    
		cFiltro := ''
	else
		Return()
	EndIf

	cCadastro := 'Painel de Clientes MB - Guarani X ERP'
	aRotina := { { "Pesquisar"           ,  "AxPesqui"           , 0 , 1   },;
				{ "Visualizar Cliente Guarani"  ,  "U_VerClGrn()"  , 0 , 2   },;
				{ "Visualizar Cliente Protheus" ,  "U_VerClPrt()"  , 0 , 3   },;
				{ "Documentos"               ,  "MsDocument"    , 0 , 4,  }}
				
	mBrowse( 6, 1,22,75,"ZA1",,,,,,aCores,,,,,,,,cFiltro)

EndIf

Return()

User Function ImpCliMb()

MsgRun("Preparando Ambiente","Importação de Clientes MB." , { || RPCSetEnv( '01', '01', ,,,, {}) } )

ArqTrab('clientes')

dbSelectArea("CLIENTEIMP")
dbSelectArea('ZA1')
While !CLIENTEIMP->(Eof())
	Conout('[INTCLIMB] Criando Novo Registro ZA1 - '+CLIENTEIMP->CODGUARANI )
	RecLock('ZA1',.T.)
	Replace ZA1->ZA1_FILIAL With xFilial('ZA1')
	Replace ZA1->ZA1_CODGRN With CLIENTEIMP->CODGUARANI
	Replace ZA1->ZA1_NOME With CLIENTEIMP->NOME
	Replace ZA1->ZA1_NREDUZ With CLIENTEIMP->FANTASIA
	Replace ZA1->ZA1_ENDERE With CLIENTEIMP->ENDERECO
	Replace ZA1->ZA1_NUMERO With CLIENTEIMP->NUMERO
	Replace ZA1->ZA1_COMPLE With CLIENTEIMP->COMPLEMENTO
	Replace ZA1->ZA1_EST With CLIENTEIMP->EST
	Replace ZA1->ZA1_CODMUN With CLIENTEIMP->CODMUN
	Replace ZA1->ZA1_CIDADE With CLIENTEIMP->CIDADE
	Replace ZA1->ZA1_PAIS With CLIENTEIMP->PAIS
	Replace ZA1->ZA1_CEP With CLIENTEIMP->CEP
	Replace ZA1->ZA1_PESSOA With CLIENTEIMP->PESSOA
	Replace ZA1->ZA1_TIPO With CLIENTEIMP->TIPOCLI
	Replace ZA1->ZA1_BAIRRO With CLIENTEIMP->BAIRRO
	Replace ZA1->ZA1_CGC With CLIENTEIMP->CGCCPF
	Replace ZA1->ZA1_INSCRI With CLIENTEIMP->INSCR
	Replace ZA1->ZA1_EMAIL With CLIENTEIMP->EMAIL
	Replace ZA1->ZA1_EMAIL2 With CLIENTEIMP->MAILSEC
	Replace ZA1->ZA1_MAILNF With CLIENTEIMP->MAILNF
	Replace ZA1->ZA1_DDD With CLIENTEIMP->DDD
	Replace ZA1->ZA1_TEL With AllTrim(CLIENTEIMP->TEL)
	Replace ZA1->ZA1_RC With AllTrim(CLIENTEIMP->CLI_REPRESENTANTE)
	Replace ZA1->ZA1_REGIAO With CLIENTEIMP->REGIAO
	Replace ZA1->ZA1_TRANSP With CLIENTEIMP->TRANSP
	Replace ZA1->ZA1_TABPRC With ""
	Replace ZA1->ZA1_OBS With CLIENTEIMP->OBSGERAL
	Replace ZA1->ZA1_PREDIO With CLIENTEIMP->PREDIO
	Replace ZA1->ZA1_REDE With CLIENTEIMP->REDE
	Replace ZA1->ZA1_LOJAS With AllTrim(STR(CLIENTEIMP->LOJAS))
	Replace ZA1->ZA1_FUNCS With AllTrim(Str(CLIENTEIMP->FUNCS))
	Replace ZA1->ZA1_DTREC With stod(SubStr(CLIENTEIMP->DTCAD,7,4)+SubStr(CLIENTEIMP->DTCAD,4,2)+SubStr(CLIENTEIMP->DTCAD,1,2))
	Replace ZA1->ZA1_STATUS With "0"
	MsUnlock('ZA1')
	cUpd := "UPDATE AND_CLIENTES SET CLI_IMPORTADO = 'S' WHERE CLI_CODIGOCLIENTE = '"+CLIENTEIMP->CODGUARANI+"'
	TCSQLEXEC(cUpd)
	IntCliMb()
	CLIENTEIMP->(DbSkip())
Enddo

Return()

Static Function IntCliMb()

//Processo de integração de clientes Guarani X ERP
//1 - Verifica se já existe o Cnpj:
dbSelectArea('SA1')
dbSetOrder(3)
If dbSeek(xFilial('SA1')+ZA1->ZA1_CGC)
	RecLock('ZA1',.F.)
	Replace ZA1->ZA1_STATUS With "1"
	Replace ZA1->ZA1_LOGIMP With "CLIENTE JA EXISTENTE NO CODIGO: "+SA1->A1_COD+'/'+SA1->A1_LOJA+'-'+SA1->A1_NOME
	Replace ZA1->ZA1_DTIMP With Date()
	Replace ZA1->ZA1_HRIMP With Time()
	MsUnlock('ZA1')

	dbSelectArea('SA3')
	dbSetOrder(1)
	dbSeek(xFilial('SA3')+ZA1->ZA1_RC)
	cMail := AllTrim(SA3->A3_EMAIL)
	cGeren := SA3->A3_GEREN
	cSuper := SA3->A3_SUPER
	If !Empty(cGeren)
		If DbSeek(xFilial('SA3')+cGeren)
			cMail += ';' + AllTrim(SA3->A3_EMAIL)
		EndIf
	EndIf
	If !Empty(cSuper)
		If DbSeek(xFilial('SA3')+cSuper)
			cMail += ';'+AllTrim(SA3->A3_EMAIL)
		EndIf
	EndIf
	
	cMail += ';wheber@gmail.com'

	cMsg := '<p align="center"><font face="arial" size="5">Recebimento de Cliente Existente Guarani</font></p>'
	cMsg += '<br><table width="100%" height="234" border="0">'
	cMsg += '<tbody>'
	cMsg += '<tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>RC</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+AllTrim(SA1->ZA1_RC)+' - '+RetField('SA3',1,xFilial('SA3')+ZA1->ZA1_RC,'A3_NOME')+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>CNPJ</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC"))+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Razão Social</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_NOME+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Nome Fantasia</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_NREDUZ+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Resumo Operação</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">Cliente já existente na base de dados. Favor entrar em contato com seu gestor.</font></td></tr>'
	cMsg += '<br>*Este é um e-mail gerado automaticamente, favor não reponder ao mesmo. Em caso de dúvidas, entre em contato com seu gestor.'
	U_MBEnvMail('Recepção de Cliente Existente Guarani [RC '+AllTrim(SA3->A3_COD)+'-'+AllTrim(SA3->A3_NOME)+'][Cliente '+AllTrim(SA1->A1_NREDUZ)+']',cMail,'',cmsg,'')
	Return()
EndIf

//Verifica se já existe "raiz" do cnpj. (Grupo)
cAliasGrp := GetNextAlias()
cQry := "SELECT ISNULL(MAX(A1_LOJA),0) LOJA "
cQry += "FROM "+RetSqlname('SA1')+" SA1 "
cQry += "WHERE SA1.A1_FILIAL = '"+xFilial('SA1')+"' "
cQry += "AND SUBSTRING(SA1.A1_CGC,1,8) = '"+SubStr(ZA1->ZA1_CGC,1,8)+"' "
cQry += "AND SA1.D_E_L_E_T_ = ' ' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),caliasGrp,.T.,.T.)

If Val((caliasGrp)->LOJA) > 0

Else

	cAliasCod := GetNextAlias()
	cQry := " SELECT MAX(A1_COD) CODIGO FROM "+RetSqlName('SA1')+" SA1 WHERE A1_FILIAL ='"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ' AND A1_COD < '02254 '"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliascod,.T.,.T.)
	cCodCli := Soma1((cAliasCod)->CODIGO)
	cLjcli := '01'

EndIf
	Conout('[INTCLIMB] Criando Novo Registro SA1 - '+CLIENTEIMP->CODGUARANI +' Codigo ERP:'+cCodCli+'/'+cLjcli)
	RecLock('SA1',.T.)
	Replace SA1->A1_FILIAL With xFilial('SA1')
	Replace SA1->A1_COD With cCodCli
	Replace SA1->A1_LOJA With cLjcli
	Replace SA1->A1_NOME With ZA1->ZA1_NOME
	Replace SA1->A1_NREDUZ With ZA1->ZA1_NREDUZ
	Replace SA1->A1_CGC With ZA1->ZA1_CGC
	Replace SA1->A1_TIPO with ZA1->ZA1_TIPO
	Replace SA1->A1_INSCR With ZA1->ZA1_INSCRI
	Replace SA1->A1_DDD With ZA1->ZA1_DDD
	Replace SA1->A1_TEL With ZA1->ZA1_TEL  
	Replace SA1->A1_PESSOA With ZA1->ZA1_PESSOA
	Replace SA1->A1_COMPLEM with ZA1->ZA1_COMPLE
	Replace SA1->A1_BAIRRO With ZA1->ZA1_BAIRRO
	Replace SA1->A1_COD_MUN With ZA1->ZA1_CODMUN
	Replace SA1->A1_EST With ZA1->ZA1_EST
	Replace SA1->A1_MUN With ZA1->ZA1_CIDADE
	Replace SA1->A1_PAIS With ZA1->ZA1_PAIS
	Replace SA1->A1_CEP with Replace(ZA1->ZA1_CEP,'-','')
	Replace SA1->A1_EMAIL With ZA1->ZA1_EMAIL
	Replace SA1->A1_ZZMAIL2 With ZA1->ZA1_EMAIL2
	Replace SA1->A1_VEND With ZA1->ZA1_RC
	Replace SA1->A1_TRANSP With ZA1->ZA1_TRANSP
	Replace SA1->A1_ZZTPBOL With '2'
	Replace SA1->A1_ZZTXBOL With '2'
	Replace SA1->A1_ZZOBS With ZA1->ZA1_OBS
	Replace SA1->A1_XCODGUA With ZA1->ZA1_CODGRN
	Replace SA1->A1_DTCAD With ZA1->ZA1_DTREC
	Replace SA1->A1_END With AllTrim(ZA1->ZA1_ENDERE)+', '+AllTrim(ZA1->ZA1_NUMERO)
	Replace SA1->A1_CODPAIS With "01058" //Padrão SX3
	Replace SA1->A1_MSBLQL With '2'
	MsUnlock('SA1')
	Conout('[INTCLIMB] Finalizado Novo Registro SA1 - '+CLIENTEIMP->CODGUARANI )
	RecLock('ZA1',.F.)
	Replace ZA1->ZA1_STATUS With "1"
	Replace ZA1->ZA1_CODERP With SA1->A1_COD+SA1->A1_LOJA
	Replace ZA1->ZA1_DTIMP With Date()
	Replace ZA1->ZA1_HRIMP With Time()
	Conout('[INTCLIMB] Alterado Registro ZA1 - Concluido! -  '+CLIENTEIMP->CODGUARANI )
	Msunlock('ZA1')
	
	dbSelectArea('SA3')
	dbSetOrder(1)
	dbSeek(xFilial('SA3')+SA1->A1_VEND)
	cMail := AllTrim(SA3->A3_EMAIL)
	cGeren := SA3->A3_GEREN
	cSuper := SA3->A3_SUPER
	If !Empty(cGeren)
		If DbSeek(xFilial('SA3')+cGeren)
			cMail += ';' + AllTrim(SA3->A3_EMAIL)
		EndIf
	EndIf
	If !Empty(cSuper)
		If DbSeek(xFilial('SA3')+cSuper)
			cMail += ';'+AllTrim(SA3->A3_EMAIL)
		EndIf
	EndIf
	
	cMail += ';wheber@gmail.com'
	cMsg := '<p align="center"><font face="arial" size="5">Recebimento de Cliente Guarani</font></p>'
	cMsg += '<br><table width="100%" height="234" border="0">'
	cMsg += '<tbody>'
	cMsg += '<tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>RC</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+AllTrim(SA1->A1_VEND)+' - '+RetField('SA3',1,xFilial('SA3')+SA1->A1_VEND,'A3_NOME')+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>CNPJ</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC"))+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Razão Social</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_NOME+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Nome Fantasia</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_NREDUZ+'</font></td></tr>'
	
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Estado</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_EST+'</font></td></tr>'

	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Cidade</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_MUN+'</font></td></tr>'

	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Código Gerado</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">'+SA1->A1_COD+'/'+SA1->A1_LOJA+'</font></td></tr>'
	cMsg += '<tr><td bgcolor="#000066" width="144"><font face="arial" color="#FFFFFF"><b>Resumo Operação</b></font></td>'
	cMsg += '<td bgcolor="#F0F0F0" width="508"><font face="arial">Cliente Cadastrado com Sucesso!</font></td></tr>'
	U_MBEnvMail('Inclusão de Clientes Guarani [RC '+AllTrim(SA3->A3_COD)+'-'+AllTrim(SA3->A3_NOME)+'][Cliente '+AllTrim(SA1->A1_NREDUZ)+']',cMail,'',cmsg,'')
Return()

User Function VerClGrn()
	cCadAnt := cCadastro
	cCadastro := "Cadastro Cliente Guarani - "+ZA1->ZA1_NOME
	FWMsgRun(, {|| AxVisual('ZA1',ZA1->(Recno()),2) }, "Processando", "Abrindo Cadastro...")
	cCadastro := cCadAnt
Return()

User Function VerClPrt()

If !Empty(ZA1->ZA1_CODERP)
	cCadAnt := cCadastro
	dbSelectArea('SA1')
	dbSetOrder(1)
	dbSeek(xFilial('SA1')+ZA1->ZA1_CODERP)
	cCadastro := 'Cadastro Efetivado Guarani - '+ SA1->A1_NOME
	FWMsgRun(, {|| AxVisual('SA1',SA1->(Recno()),2) }, "Processando", "Abrindo Cadastro "+SA1->A1_COD+SA1->A1_LOJA+'-'+SA1->A1_NOME  )
	cCadastro := cCadAnt
Else
	MsgAlert('Cadastro não efetivado.')
EndIf

Return()

User Function ImpPedMB()

local xcR :=	Char(13) + Char(10)

MsgRun("Preparando Ambiente","Importação de Pedidos MB" , { || RPCSetEnv( '01', '01', ,,,, {}) } )

FWMsgRun(, {|| GrIntGrn() }, "Processando", "Sincronizando Pedidos Guarani...")
 
Return()

Static Function GrIntGrn()

local xcR :=	Char(13) + Char(10)
ArqTrab('pedidos')

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
	ZB5->ZB5_CLIENT	:= Substr(PEDIDO->CODCLI,1,8)
	ZB5->ZB5_DTPED	:= CTOD(PEDIDO->HPC_DTPEDIDO)
	ZB5->ZB5_ORIGEM	:= PEDIDO->HPC_ORIGEMPEDIDO
	ZB5->ZB5_TPPED	:= PEDIDO->HPC_CODIGOTIPOPEDIDO
	ZB5->ZB5_FRMPGT	:= PEDIDO->HPC_FORMAPAGAMENTO
	ZB5->ZB5_PLANO	:= PEDIDO->HPC_PLANOPAGAMENTO
	ZB5->ZB5_COND	:= AllTrim(PEDIDO->CONDPG)
	ZB5->ZB5_VEND	:= StrZero(PEDIDO->HPC_REPRESENTANTE,3)
	ZB5->ZB5_TRANSP	:= PEDIDO->HPC_TRANSPORTADORA
	ZB5->ZB5_TABELA	:= PEDIDO->HPC_TABELAPRECO
	ZB5->ZB5_FRETMB := IF(ALLTRIM(PEDIDO->HPC_DESCRICAOFRETE)=="C",'2',IF(ALLTRIM(PEDIDO->HPC_DESCRICAOFRETE)=="F",'4',IF(ALLTRIM(PEDIDO->HPC_DESCRICAOFRETE)=="S",'3','1')))
	ZB5->ZB5_DTSINC	:= PEDIDO->HPC_DATASINCRONIZACAO
	ZB5->ZB5_DTIMP	:= DATE()
	ZB5->ZB5_HRIMP	:= TIME()
	ZB5->ZB5_OBS	:= PEDIDO->HPC_OBSERVACAOFAT
	ZB5->ZB5_PEDCLI	:= PEDIDO->HPC_ORDEMCOMRA
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

GrPvGrn()
Conout('[IMPPEDMB] - Pedido Incluído!')
Return()

Static Function GrPvGrn()

dbSelectArea('ZB5')

If ZB5->ZB5_IMPORT == '0' //Pedidos Não importados
        
    cNumPed := '120241' //GetSXeNum('SC5','C5_NUM')
    cNumVend := ZB5->ZB5_VEND//'444' ////ZB5->ZB5_VEND

    dbSelectArea('SA3')
    dbSetOrder(1)
    dbSeek(xFilial('SA3')+cNumVend)

    //Inicia Gravação SC5
    RecLock('SC5',.T.)
    Replace SC5->C5_FILIAL With xFilial('SC5')
    Replace SC5->C5_NUM With cNumPed
    Replace SC5->C5_TIPO With ZB5->ZB5_TPPED
    Replace SC5->C5_TPFRETE With If(ZB5->ZB5_FRETMB=='2','C','F')
    Replace SC5->C5_FRETEMB With ZB5->ZB5_FRETMB
    Replace SC5->C5_CLIENT With SubStr(ZB5->ZB5_CLIENT,1,6)
    Replace SC5->C5_CLIENTE With SC5->C5_CLIENT
    Replace SC5->C5_LOJACLI With SubStr(ZB5->ZB5_CLIENT,7,2)
    Replace SC5->C5_LOJAENT With SC5->C5_LOJACLI
    Replace SC5->C5_TRANSP With ZB5->ZB5_TRANSP
    Replace SC5->C5_VEND1 With cNumVend
    Replace SC5->C5_VEND2 With SA3->A3_SUPER
    Replace SC5->C5_VEND3 With SA3->A3_GEREN
    Replace SC5->C5_VEND4 With "001" 
    Replace SC5->C5_EMISSAO With ZB5->ZB5_DTSINC
    Replace SC5->C5_CONDPAG With ZB5->ZB5_COND
    Replace SC5->C5_MENNOTA With If(!Empty(ZB5->ZB5_PEDCLI),'ORDEM CLIENTE '+ZB5->ZB5_PEDCLI,'')
    Replace SC5->C5_XPEDEMP With 'V'+ZB5->ZB5_PEDEMP
    Replace SC5->C5_ZZOBPED With ZB5->ZB5_OBS
    Replace SC5->C5_MOEDA With 1
	Do CASE
		Case ZB5->ZB5_TPPED == 'C'
			cZZTpOp := '12'
		Case ZB5->ZB5_TPPED == 'B'
			cZZTpOp := '04'
		Case ZB5->ZB5_TPPED == 'E'
			cZZTpOp := '09'
		Case ZB5->ZB5_TPPED == 'N'
			cZZTpOp := '01'
		OTHERWISE
			cZZTpOp := '99'
	EndCase
	Replace SC5->C5_ZZTPOPE With cZZTpOp
	Replace SC5->C5_ZZNOMFC With SA1->A1_NOME
	Replace SC5->C5_ZZDTENT With Date()
	Replace SC5->C5_ZZTPBOL With SA1->A1_ZZTPBOL

    MsUnlock('SC5')
        
    //Inicia Gravação SC6

    _cItem := "01"
	nC5Calor   := 0
	nC5VlrBut  := 0
	nC5XCustos := 0
	nC5XvlDesc := 0
	nC5ZFrete  := 0
	nC5DespFx  := 0
	nC5XvlIcms := 0
 	nC5xVlPis  := 0
	nC5XVlCofi := 0
	nC5XIRCSLL := 0
	nC5XMGerro := 0
	nC5XMARKET := 0
	nC5xVerba  := 0
	nC5XManga  := 0
	nC5ZBasCom := 0
	nC5ZValCom := 0
	nC5xVlComG := 0
	nC5XlvComd := 0
	nC5PesBru  := 0
	nC5Peso    := 0
	nC5Volume  := 0		
	nC5ZZCuba  := 0	

    dbSelectArea('ZB6')
    DbSetOrder(1)
    DbGoTop()
    dbSeek(xFilial('ZB6')+ZB5->ZB5_PEDEMP)
    While !ZB6->(Eof()) .And. ZB6->ZB6_FILIAL+ZB6->ZB6_PEDEMP == xFilial('ZB6')+ZB5->ZB5_PEDEMP

        dbSelectArea('SB1')
        dbSetOrder(1)
        dbSeek(xFilial('SB1')+ZB6->ZB6_COD)
		
		dbSelectArea('DA0')
		dbSetOrder(1)
		dbSeek(xFilial('DA0') + ZB6->ZB6_TABELA)
		
		dbSelectArea('DA1')
		dbSetOrder(1)
		dbSeek(xFilial("DA1") + ZB6->ZB6_TABELA + ZB6->ZB6_COD)

        RecLock('SC6',.T.)
        Replace SC6->C6_FILIAL With xFilial('SC6')
        Replace SC6->C6_NUM With cNumPed
        Replace SC6->C6_ITEM with _cItem
        Replace SC6->C6_PRODUTO With ZB6->ZB6_COD
		Replace SC6->C6_XITEORI With ZB6->ZB6_COD
        Replace SC6->C6_DESCRI With SB1->B1_DESC
        Replace SC6->C6_PRUNIT With ZB6->ZB6_PRUNIT
        Replace SC6->C6_QTDVEN With ZB6->ZB6_QTDVEN
		Replace SC6->C6_XQTDORI With ZB6->ZB6_QTDVEN
        Replace SC6->C6_PRCVEN With ZB6->ZB6_PRCVEN
		Replace SC6->C6_ZPRCUNI With SC6->C6_PRCVEN
		Replace SC6->C6_PRUNIT With ZB6->ZB6_PRCVEN
        Replace SC6->C6_VALOR With SC6->C6_PRCVEN*SC6->C6_QTDVEN//ZB6->ZB6_VALOR
        Replace SC6->C6_ZTABELA With ZB6->ZB6_TABELA
		Replace SC6->C6_LOCAL With '10' //Fixo conforme analise nas procedures.
		Replace SC6->C6_CLI With SC5->C5_CLIENT
		Replace SC6->C6_LOJA With SC5->C5_LOJACLI
        Replace SC6->C6_UM With SB1->B1_UM
        Replace SC6->C6_SEGUM With SB1->B1_SEGUM
		Replace SC6->C6_ZZTPOPE With SC5->C5_ZZTPOPE
		Replace SC6->C6_ZTABELA With ZB6->ZB6_TABELA
		Replace SC6->C6_ZZCUBA With round(U_MBCALCUB(SC6->C6_PRODUTO,SC6->C6_QTDVEN,.T.),2)
		Replace SC6->C6_XPRCTAB With DA1->DA1_PRCVEN
		Replace SC6->C6_ZPRTAB With DA1->DA1_PRCVEN
		Replace SC6->C6_XVLDESC With ZB6->ZB6_VALDES*SC6->C6_QTDVEN
		Replace SC6->C6_XPERDES With ZB6->ZB6_DESCON
		Replace SC6->C6_ZBASCOM With ROUND(SC6->C6_ZPRCUNI * SC6->C6_QTDVEN, 2) 
		Replace SC6->C6_MSBLQL With '2'
		Replace SC6->C6_RATEIO With '2'
		Replace SC6->C6_TPOP With 'F'
	 	Replace SC6->C6_INTROT With '1'

		//Replace SC6->C6_TES With tesIntelig()
		MbItem()
		Replace SC6->C6_XVLRBRU	With round((SC6->C6_XPRCTAB*SC6->C6_QTDVEN) + (SC5->C5_XPERJUR*SC6->C6_VALOR), 2)
		Replace SC6->C6_XCUSTOS With ROUND(SB1->B1_ZZVLIND * SC6->C6_QTDVEN, 2)
		Replace SC6->C6_XDESPFX With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'001','PAC_VLR01')/100),2)
		Replace SC6->C6_XIRCSLL With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'002','PAC_VLR01')/100),2)
		Replace SC6->C6_XMANGA  With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'003','PAC_VLR01')/100),2)
		Replace SC6->C6_XMGERRO With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'004','PAC_VLR01')/100),2)
		Replace SC6->C6_XMARKET With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'005','PAC_VLR01')/100),2)
		Replace SC6->C6_XVLPIS  With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'008','PAC_VLR01')/100),2)
		Replace SC6->C6_XVLCOFI With Round(SC6->C6_VALOR*(RetField('PAC',1,xFilial('PAC')+'12'+'009','PAC_VLR01')/100),2)
		CalcIcms()
		Replace SC6->C6_XRESULT With ROUND(100 * (SC6->C6_VALOR - SC6->C6_XCUSTOS - SC6->C6_ZFRETE - SC6->C6_ZVALCOM - SC6->C6_XVLCOMG - SC6->C6_XVLCOMD - SC6->C6_XDESPFX - SC6->C6_XIRCSLL - SC6->C6_XMGERRO - SC6->C6_XMARKET - SC6->C6_XMANGA  - SC6->C6_XVERBA  - 	SC6->C6_XVLICMS - SC6->C6_XVLCOFI - SC6->C6_XVLPIS) / SC6->C6_VALOR, 2)
        MsUnlock('SC6')

		//Totalizadores
		nC5Calor   += SC6->C6_VALOR
		nC5VlrBut  += SC6->C6_XVLRBRU
		nC5XCustos += SC6->C6_XCUSTOS
		nC5XvlDesc += SC6->C6_XVLDESC
		nC5ZFrete  += SC6->C6_ZFRETE
		nC5DespFx  += SC6->C6_XDESPFX
		nC5XvlIcms += SC6->C6_XVLICMS
 		nC5xVlPis  += SC6->C6_XVLPIS
		nC5XVlCofi += SC6->C6_XVLCOFI
		nC5XIRCSLL += SC6->C6_XIRCSLL
		nC5XMGerro += SC6->C6_XMGERRO
		nC5XMARKET += SC6->C6_XMARKET
		nC5xVerba  += SC6->C6_XVERBA
		nC5XManga  += SC6->C6_XMANGA
		nC5ZBasCom += SC6->C6_ZBASCOM
		nC5ZValCom += SC6->C6_ZVALCOM
		nC5xVlComG += SC6->C6_XVLCOMG
		nC5XlvComd += SC6->C6_XVLCOMD
		nC5PesBru  += (SC6->C6_QTDVEN * SB1->B1_PESBRU )
		nC5Peso    += (SC6->C6_QTDVEN * SB1->B1_PESO )
		nC5Volume  += (SC6->C6_QTDVEN / SB1->B1_CONV) * If( Trim(SB1->B1_ZZADD) == '', 1, 2)
		nC5ZZCuba  += Round(SC6->C6_ZZCUBA,2)

        _cItem := Soma1(_cItem)
		Conout('[Incluido Item '+SC6->C6_PRODUTO+']')
        ZB6->(dbSkip())
    EndDo
        
    //Ajusta Registro ZB5
    Reclock('ZB5',.F.)
    Replace ZB5->ZB5_IMPORT With '1'
	Replace ZB5->ZB5_NUM With cNumPed
	Replace ZB5->ZB5_DTEFET With Date()
	Replace ZB5->ZB5_HREFET With Time()
    MsUnlock('ZB5')

	//Finaliza totalizadores SC5
	RecLock('SC5',.F.)
	Replace SC5->C5_ZTOTPED With nC5Calor
	Replace SC5->C5_XVLRBRU With nC5VlrBut
	Replace SC5->C5_XCUSTO  With nC5XCustos
	Replace SC5->C5_XVLDESC With nC5XvlDesc
	Replace SC5->C5_ZFRETE  With nC5ZFrete
	Replace SC5->C5_XDESPFX  With nC5DespFx
	Replace SC5->C5_XICMS   With nC5XvlIcms
 	Replace SC5->C5_XPIS    With nC5xVlPis
	Replace SC5->C5_XCOFINS With nC5XVlCofi
	Replace SC5->C5_XIRCSLL  With nC5XIRCSLL
	Replace SC5->C5_XMGERRO With nC5XMGerro
	Replace SC5->C5_XMARKET With nC5XMARKET
	Replace SC5->C5_XVERBA  With nC5xVerba
	Replace SC5->C5_XMANGA  With nC5XManga
	Replace SC5->C5_XBASCOM With nC5ZBasCom
	Replace SC5->C5_XVLCOMI With nC5ZValCom
	Replace SC5->C5_XVLCOMG With nC5xVlComG
	Replace SC5->C5_XVLCOMD	With nC5XlvComd
	Replace SC5->C5_PBRUTO With nC5PesBru
	Replace SC5->C5_PESOL   With nC5Peso
	Replace SC5->C5_VOLUME1 With nC5Volume
	Replace SC5->C5_ZZCUBA  With nC5ZZCuba
	MsUnlock('SC5')

EndIf

Return()

Static Function CalcIcms()

Local cAliasICMS := GetNextAlias()
Local cQryIcm := ''
cQryIcm := "SELECT IsNull(PAC_VLR01/100,0) ALIQICM FROM PAC010 WHERE PAC_TABELA = '12' AND PAC_CHAVE IN ('010', '011', '012') AND R_E_C_D_E_L_ = 0 "
cQryIcm += "AND PAC_TXT02 LIKE '%"+SA1->A1_EST+"%' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryIcm),cAliasICMS,.T.,.T.)

If !(cAliasICMS)->(Eof())
	Replace SC6->C6_XVLICMS With Round(SC6->C6_VALOR*(cAliasIcms)->ALIQICM,2)
EndIf

(cAliasIcms)->(dbCloseArea())

Return()

static function arqTrab(xcTipo)
	local xcQuery		:=	''
	local xcR			:=	Char(13) + Char(10)

	If xcTipo == 'pedidos'
		conout('[IMPCLIMB] - Iniciando query para integracao.')
        xcQuery := "select HPC_CODCONDPGTO CONDPG,HPC_CODIGOCLIENTE CODCLI,* from AND_HISTPEDCAB "
        //xcQuery += xCr+ "where HPC_NUMPEDIDOEMP = '200625154444158'"
		//xcQuery += xCr+ "where HPC_NUMPEDIDOEMP = '200702115101501'"
		xcQuery += xCr+ "where HPC_NUMPEDIDOEMP = '200812103206067'"
		
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

	If xcTipo =="clientes"
		xcQuery := "SELECT * FROM (SELECT DISTINCT "
		xcQuery += xcR + 	"A.CLI_CODIGOCLIENTE AS CODGUARANI,
		xcQuery += xcR + 	"RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(A.CLI_RAZAOSOCIAL, '''', ''), '&', 'E'), '', ''), 'Á', 'A')) AS NOME,"
		xcQuery += xcR + 	"A.CLI_PESSOA AS PESSOA, "
		xcQuery += xcR + 	"RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A.CLI_NOMEFANTASIA, '`', ''), '''', ''), '&', 'E'), '', ''), 'Á', 'A')) AS FANTASIA, "
		xcQuery += xcR + 	"RTRIM(A.CLI_ENDERECO) AS ENDERECO, "
		xcQuery += xcR + 	"A.CLI_NUMERO AS NUMERO, "
		xcQuery += xcR +    "A.CLI_DATACADASTRO DTCAD, "
		xcQuery += xcR + 	"B.CC2_CODMUN AS CODMUN, "
		xcQuery += xcR + 	"B.CC2_MUN AS CIDADE, "
		xcQuery += xcR + 	"B.CC2_XNUMUF AS CODEST, "
		xcQuery += xcr +    "A.CLI_IMPORTADO AS IMPORTADO, "
		xcQuery += xcR + 	"B.CC2_EST AS EST, "
		xcQuery += xcr +    "A.CLI_EMAILSECUNDARIO AS MAILSEC, "
		xcQuery += xcr +    "A.CLI_EMAILNF AS MAILNF, "
		xcQuery += xcR + 	"CASE WHEN CC2_EST <> 'EX' THEN '105' ELSE '' END AS PAIS, CASE WHEN CC2_EST <> 'EX' THEN '1' ELSE '2' END AS PAISORIGEM, "
		xcQuery += xcR + 	"LEFT(A.CLI_BAIRRO, 30) AS BAIRRO, A.CLI_CEP AS CEP, "
		xcQuery += xcR + 	"LEFT(A.CLI_COMPLEMENTO, 50) AS COMPLEMENTO, "
		xcQuery += xcR + 	"RTRIM(CONVERT(VARCHAR(20), REPLACE(REPLACE(REPLACE(A.CLI_CGCCPF, '.', ''), '/', ''), '-', ''))) AS CGCCPF, "
		xcQuery += xcR + 	"CASE WHEN CLI_PESSOA = 'F' THEN 'ISENTO' ELSE CASE WHEN CLI_INSCRESTADUAL IN ('isento', 'isenta') THEN 'ISENTO' ELSE CLI_INSCRESTADUAL END END AS INSCR, "
		xcQuery += xcR + 	"CASE WHEN CLI_INSCRESTADUAL = '' THEN '1' ELSE '2' END AS CONTNAC, LEFT(RTRIM(A.CLI_EMAIL), 256) AS EMAIL, '0' + LEFT(REPLACE(REPLACE(A.CLI_TELEFONE, '(', ''), ')', ''), 2) AS DDD, "
		xcQuery += xcR + 	"RIGHT(REPLACE(REPLACE(REPLACE(A.CLI_TELEFONE, '(', ''), ')', ''), '-', ''), 9) AS TEL, A.CLI_REPRESENTANTE, A.CLI_REPRESENTANTE AS RC, A.CLI_CODREGIAO AS REGIAO, "
		xcQuery += xcR + 	"A.CLI_CODRAMO AS RAMO, CASE WHEN CLI_TIPOPESSOA = 'R' THEN 'R' WHEN CLI_TIPOPESSOA = 'C' THEN 'F' WHEN CLI_TIPOPESSOA = 'F' THEN 'F' ELSE 'R' END AS TIPOCLI, "
		xcQuery += xcR + 	"LEFT(RTRIM(A.CLI_TRANSPORTADORA), 6) AS TRANSP, A.CLI_OBSGERAL AS OBSGERAL, A.CLI_PREDIOPROPRIO AS PREDIO, A.CLI_POSSUIREDE AS REDE, A.CLI_NUMEROLOJAS AS LOJAS, " 
		xcQuery += xcR + 	"A.CLI_NUMEROCHECKOUTS AS XCOUTS, A.CLI_QTDEFUNCIONARIOS AS FUNCS "
		xcQuery += xcR + 	"FROM         dbo.AND_CLIENTES AS A LEFT OUTER JOIN "
		xcQuery += xcR + 	"dbo.CC2010 AS B ON B.CC2_CODMUN = SUBSTRING(RTRIM(CONVERT(VARCHAR(10), A.CLI_CODIGOMUNICIPIO)), 3, 5) AND B.CC2_XNUMUF = SUBSTRING(RTRIM(CONVERT(VARCHAR(10), "
		xcQuery += xcR + 	"A.CLI_CODIGOMUNICIPIO)), 1, 2) AND B.D_E_L_E_T_ = ' ' AND B.CC2_FILIAL = '  ' "
		xcQuery += xcr +    " ) AS RESULT "
        xcQuery += xcr +    " WHERE RC IN('444','888') AND IMPORTADO = 'N' "

		MemoWrite("\sql\GUARANI ImportaClientes.SQL",xcQuery)

		if select("CLIENTEIMP") > 0
			CLIENTEIMP->(dbclosearea())
		endif

		TcQuery StrTran(xcQuery,xcR,"") New Alias CLIENTEIMP

	EndIf

return

//Retorna tes inteligente
Static function tesIntelig()
	local retProced	:=	{}
	local cTpOpe	:= 	""
	local cUF		:= 	""
	local cCSuf		:= 	""
	local cContrb	:= 	""
	local cTipoPV	:= 	""
	local cIE		:= 	""
	local cPessoa	:= 	""
	local cSuframa	:= 	""
	local cNCM		:= 	""
	local cGrTrib	:= 	""
	local cTPessoa	:= 	""
	local codProd	:= 	""
	local aDadosCfo	:=	{}
	// local nPosCfo	:=	0
	//local SC5->C5_TIPO
	local N := 1

	If FunName() != "MAT410"
		dbSelectArea('SC5')
		dbSetOrder(1)
		dbSeek('01120924')
		dbSelectArea('SC6')
		dbSetOrder(1)
		dbSeek('01120924')
		cTipoPV		:= 	SC5->C5_TIPO
		cTpOpe		:=	SC6->C6_ZZTPOPE
		codProd		:=	SC6->C6_PRODUTO
	Else
		cTipoPV		:= 	M->C5_TIPO
		cTpOpe		:=	aCols[n,GDFieldPos("C6_ZZTPOPE")]
		codProd		:=	aCols[n,GDFieldPos("C6_PRODUTO")]
	EndIf

	/*if empty(alltrim(cTpOpe)) .or. empty(alltrim(codProd)) .OR. 1==1
		return SC6->C6_TES
	endif*/

	dbSelect


	if ALLTRIM(cTipoPV) $ "N,C,I,P"
		SA1->(dbseek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		SB1->(dbseek(xFilial("SB1")+codProd))

		cTpOpe		:= 	iif(cTpOpe $ "10 | PA", "01", cTpOpe)
		cUF			:= 	SA1->A1_EST
		cCSuf		:= 	SA1->A1_CALCSUF
		cContrb		:= 	SA1->A1_CONTRIB
		cIE			:= 	SA1->A1_INSCR
		cPessoa		:= 	SA1->A1_PESSOA
		cSuframa	:= 	SA1->A1_SUFRAMA
		cNCM		:= 	SB1->B1_POSIPI
		cGrTrib		:= 	SA1->A1_GRPTRIB
		cTPessoa	:= 	SA1->A1_TPESSOA
		xcSimpNac	:= 	SA1->A1_SIMPNAC
	else
		SA2->(dbseek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		SB1->(dbseek(xFilial("SB1")+codProd))

		cUF			:= SA2->A2_EST
		cCSuf		:= ""
		cContrb		:= ""
		cIE			:= SA2->A2_INSCR
		cPessoa		:= SA2->A2_TIPO
		cSuframa	:= ""
		cNCM		:= SB1->B1_POSIPI
		cGrTrib		:= ""
		cTPessoa	:= SA2->A2_TPESSOA
		xcSimpNac	:= SA2->A2_SIMPNAC
	endif

	cIE := iif(empty(alltrim(cIE)),'N',iif(upper(alltrim(cIE))=='ISENTO', 'N', 'S'))
	cSuframa	:=	iif(empty(alltrim(cSuframa)),'N','S')

	retProced := TCSPEXEC("comercialTesInteligente", cTpOpe, cUF, cCSuf, cContrb, cTipoPV, cIE, cPessoa, cSuframa, cNCM, cGrTrib, cTPessoa, xcSimpNac, 'OK')

	retProced	:=	StrTokArr( retProced[1] , "|" )

	if retProced[2] == '0'
		U_UASKYPE('SEM TES INTELIGENTE ' + M->C5_CLIENTE + '-' + M->C5_LOJACLI + ' Tp:' + cTpOpe )
		// elseif retProced [2] == '1'
		// 	aCols[n,GDFieldPos("C6_TES")] := retProced [1]
		// 	GetDRefresh()
	elseif retProced [2] != '1'
		U_UASKYPE('MAIS DE UMA REGRA DE TES INTELIGENTE ' + M->C5_CLIENTE+'-'+M->C5_LOJACLI + ' Tp:' + cTpOpe )
	endif

	dbSelectArea("SF4")
	// nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF") })
	if SA1->A1_EST == 'EX'
		//aCols[n,GDFieldPos("C6_CF")] := '7101'
		Replace SC6->C6_CF With '7101'
	else
		MsSeek(xFilial("SF4")+retProced[1])
		AAdd(aDadosCfo,{"OPERNF","S"})
		AAdd(aDadosCfo,{"TPCLifOR",SA1->A1_TIPO})
		AAdd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
		AAdd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
		AAdd(aDadosCfo,{"CONTR"   ,SA1->A1_CONTRIB})
		//aCols[n,GDFieldPos("C6_CF")] := MaFisCfo( ,SF4->F4_CF,aDadosCfo )
		Replace SC6->C6_CF With MaFisCfo( ,SF4->F4_CF,aDadosCfo )
	endif
	// nPosCfo := 0
	// if nPosCfo > 0
	// 	aCols[n,GDFieldPos("C6_CF")] := Space(Len(aCols[n,GDFieldPos("C6_CF")]))
	// endifcalves	
	
	if MaFisFound("IT",n)
		MaFisAlt("IT_TES",retProced[1],n)
		MaFisRef("IT_TES","MT100",retProced[1])
	endif


return (retProced [1])


static function MbItem()

	local xnDesc		:=	SC5->C5_ZZDESCO
	local xnPercJur		:=	SC5->C5_XPERJUR
	local xnValJur		:=	0
	local vlrTotal		:=	0
	local vlrTabela		:=	0
	local vlrFrete		:=	0
	local vlrBruto		:=	0
	local xnQtdeProd	:=	0
	local percDescon	:=	0
	local vlrDescon		:=	0
	local freteCli		:=	1
	local freteRep		:=	1
	local xcCliente		:=	SC5->C5_CLIENTE
	local xcLoja		:=	SC5->C5_LOJACLI
	local xcFreteMB		:=	SC5->C5_FRETEMB
	local xcVend1		:=	SC5->C5_VEND1
	local xcVend2		:=	SC5->C5_VEND2
	local xcVend3		:=	SC5->C5_VEND3
	local retSaldo		:=	{}
	local percComis		:=	{}
	local buscaTES		:=	{}
	Local xcTabela      := 	SC6->C6_ZTABELA
	Local xcProduto		:=	SC6->C6_PRODUTO

	DA0->(dbSeek(xFilial('DA0') + xcTabela))
	DA1->(dbSeek(xFilial("DA1") + xcTabela + xcProduto))

	//SC6->C6_XPRCTAB :=	DA1->DA1_PRCVEN
	//SC6->C6_XEMISSA	:=	SC5->C5_EMISSAO
	//SC6->C6_ZZNCM	:=	SB1->B1_POSIPI
	xcSitll 		:=	SA1->A1_ZZSITLL
	xnComis1		:=	SA1->A1_COMIS
	estadoUf		:=	SA1->A1_EST

	//xfFrete() //Aliquota do frete

	aliqFrete := val(TCSPEXEC("sp_pedidoCalculoFrete",  xcProduto, xcTabela, xcCliente, xcLoja, xcFreteMB, xcVend1, 'TABELAS')[1])

	freteRep := aliqFrete
	// ajuste da aliquota do frete em relação
	aliqFrete	:=	iif((xcFreteMB $ '1|3' .or. SA1->A1_EST == 'SP'), aliqFrete - 4, aliqFrete)
	aliqFrete	:=	iif(estadoUf $ 'ES|RJ|', 0, aliqFrete)
	aliqFrete	:=	iif(aliqFrete < 0, 0, aliqFrete)

	freteCli := aliqFrete

	//Calculo do Frete para compor o valor dos descontos
	xnQtdeProd	:=	SC6->C6_QTDVEN


	vlrTabela	:=	ROUND(DA1->DA1_PRCVEN, 2)
	xcTipoOper := If(Empty(SC6->C6_ZZTPOPE), SC5->C5_ZZTPOPE, SC6->C6_ZZTPOPE )
	buscaTES := TCSPEXEC("sp_pedidoBuscaTES",  xcCliente, xcLoja, xcTipoOper, SC5->C5_TIPO, xcProduto, 'TES')
	buscaTES := StrTokArr(buscaTES[1], '|')

	if buscaTES[1] == 'XYZ'
		//alert('TES INTELIGENTE - SEM CADASTRO')
		//Tratar TES com Erro..
	endif

	SC6->C6_TES		:=	buscaTES[1]
	SC6->C6_CF		:=	buscaTES[2]
	SC6->C6_CLASFIS	:=	buscaTES[3]

	vlrDescon	:=	vlrTabela - ROUND((vlrTabela * xnDesc) / 100, 2)

	vlrTotal	:=	round(vlrDescon * xnQtdeProd, 2)
	vlrFrete	:=	ROUND(vlrDescon * (freteRep/100) * xnQtdeProd, 2)
	vlrBruto	:=	vlrTabela * xnQtdeProd


//	SC6->C6_VALOR	:=	vlrTotal
	if xnQtdeProd > 0 .and. xcTabela == '709'
		retSaldo := TCSPEXEC("spComercialTabelaLimite709", xcTabela, xcProduto, 0)
		if xnQtdeProd > retSaldo[1]
			alert('Qtde Maior que saldo na Tabela: ' + alltrim(str(retSaldo[1])))
			xnQtdeProd := retSaldo[1]
		endif
	endif

	xnValJur	:=	vlrTotal *  (xnPercJur / 100)

	//calculo do frete a partir da informacao no cabec do pedido

	SC6->C6_QTDLIB	:=	xnQtdeProd

	vlrDescon	:=	vlrBruto - round(vlrDescon * xnQtdeProd, 2)
	percDescon	:=	round((vlrDescon / vlrBruto) * 100,2)

	SC6->C6_XFRTINC :=	DA0->DA0_XFRTIN
	SC6->C6_ZPERFRT :=	freteRep  //-- ((100 - freteRep)/100))
	SC6->C6_ZFRETE 	:=	vlrFrete
	//SC6->C6_XVLRBRU	:=	round(vlrBruto + xnValJur, 2)
//	SC6->C6_XVALJUR	:=	xnValJur
	SC6->C6_XPERJUR	:=	xnPercJur
	//SC6->C6_ZBASCOM	:=	vlrBruto - vlrFrete - vlrDescon

	//Calculando o preco unitario
	//SC6->C6_ZPRCUNI := Round(SC6->C6_ZBASCOM / SC6->C6_QTDVEN,2)

	percComis := TCSPEXEC("sp_pedidoCalculoComissao",  xcProduto, xcTabela, percDescon, xcCliente, xcLoja, xcFreteMB, xcVend1, xcVend2, xcVend3, 'COMISSAO')
	percComis := StrTokArr(percComis[1], '|')
	
	codVend		:=	AllTrim(M->C5_VEND1)
	codSuper	:=	AllTrim(M->C5_VEND2)
	codGeren	:=	AllTrim(M->C5_VEND3)

	SC6->C6_COMIS1	:=	val(percComis[1])
	SC6->C6_COMIS2	:=	val(percComis[2])
	SC6->C6_COMIS3	:=	val(percComis[3])
	SC6->C6_XTIPCOM	:=	percComis[4]
	SC6->C6_ZVALCOM	:=	Round(SC6->C6_ZBASCOM * SC6->C6_COMIS1 / 100,2 )
	SC6->C6_XVLCOMG	:=	Round(SC6->C6_VALOR   * SC6->C6_COMIS2 / 100,2 )
	SC6->C6_XVLCOMD	:=	Round(SC6->C6_VALOR   * SC6->C6_COMIS3 / 100,2 )
	SC6->C6_XGRPVAR	:=	SB1->B1_XGRPVAR

	//Tratamento para comissão...
	

	
Return()


User Function VerPvGrn()

   
Local cLinok 	:= ".T."
Local cTudook 	:= "Allwaystrue"
Local nOpce 	:= 2 	//define modo de alteração para a enchoice
Local nOpcg 	:= 2 	//define modo de alteração para o grid
Local cFieldok 	:= "Allwaystrue"
Local lRet 		:= .T.
Local cMensagem := ""
Local lVirtual  := .T. 	//Mostra campos virtuais se houver
Local nFreeze	:= 0
Local nAlturaEnc:= 300	//Altura da Enchoice
Private cAlias1 	 := "ZB5"
Private cAlias2 	 := "ZB6"
Private cCadastro	 := "Pedido Integracão Guarani"	
Private aCols 		 := {}
Private aHeader 	 := {}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
//SetKey(VK_F8, { || VerPosProd() } )
aButton := {}
Aadd(aButton , { 'BITMAP', { || VerCliPos() }, OemtoAnsi('Posicao Cliente')})
//Aadd(aButton , { 'BITMAP', { || VerPosProd() }, OemtoAnsi('Posicao Produto')})
//Aadd(aButton,  { 'BitMap', { || VerDoc() },'Documentos' })
RegToMemory("ZB5",.F.)
RegToMemory("ZB6",.F.)
DefineCabec()
DefineaCols(3)
Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,nOpcg,cFieldok,lVirtual,,aAltenchoice,nFreeze,aButton,,nAlturaEnc)
aCols := {}
SetKey(VK_F8, { || Nil } )

Return()

Static function DefineaCols(nOpc)
Local nQtdcpo 	:= 0
Local i			:= 0
Local nCols 	:= 0
nQtdcpo 		:= len(aHeader)
aCols			:= {}

dbselectarea(cAlias2)
dbsetorder(1)
If nOpc == 0

	dbseek(xfilial(cAlias2)+ZB5->ZB5_NUM)
	while .not. eof() .and. (cAlias2)->C6_FILIAL == xfilial(cAlias2) .And. (cAlias2)->C6_NUM==ZB5->ZB5_NUM
		aAdd(aCols,array(nQtdcpo+1))
		nCols++
		for i:= 1 to nQtdcpo
			if aHeader[i,10] != "V"
				aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
			else
				aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
			endif
		next i
		aCols[nCols,nQtdcpo+1] := .F.
		dbselectarea(cAlias2)
		dbskip()
	enddo

Else

	dbseek(xfilial(cAlias2)+(cAlias1)->ZB5_PEDEMP)
	while .not. eof() .and. (cAlias2)->ZB6_FILIAL == xfilial(cAlias2) .And. (cAlias2)->ZB6_PEDEMP==(cAlias1)->ZB5_PEDEMP
	aAdd(aCols,array(nQtdcpo+1))
    nCols++
    for i:= 1 to nQtdcpo
    	if aHeader[i,10] != "V"
            aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
        else
            aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
        endif
    next i
    aCols[nCols,nQtdcpo+1] := .F.
    dbselectarea(cAlias2)
    dbskip()
enddo
EndIf
Return

Static Function DefineCabec()
    Local aSC6		:= {}//{"C6_ITEM","C6_ITEMPC","C6_NUMPCOM","C6_PRODUTO","C6_DESCRI","C6_ENTREG","C6_ZZENTFA","C6_QTDVEN","C6_UNSVEN","C6_QTDLIB","C6_PRCVEN","C6_PRUNIT","C6_VALOR","C6_VALDESC","C6_DESCONT","C6_TES","C6_CF","C6_IDENTB6","C6_CONTRAT","C6_ITEMCON","C6_LOTECTL","C6_NUMLOTE","C6_ENTREG","C6_ITEMED","C6_BLQ"}
    Local aZZK := {}
    Local nUsado
    aHeader		:= {}
    aCpoEnchoice:= {}
 
    nUsado:=0
    
    //Monta a enchoice
    DbSelectArea("SX3")
    SX3->(DbSetOrder(1))
    dbseek(cAlias1)
    while SX3->(!eof()) .AND. X3_ARQUIVO == cAlias1
        IF X3USO(X3_USADO) .AND. CNIVEL >= X3_NIVEL
            AADD(ACPOENCHOICE,X3_CAMPO)
            aAdd(aAltEnchoice,X3_CAMPO)
        endif
        dbskip()
    enddo

    //Monta a enchoice
    DbSelectArea("SX3")
    SX3->(DbSetOrder(1))
    dbseek(cAlias2)
    while SX3->(!eof()) .AND. X3_ARQUIVO == cAlias2
        IF X3USO(X3_USADO) .AND. CNIVEL >= X3_NIVEL //.And. X3_CAMPO !='ZZK_PROTOC'
            aAdd(aZZK, X3_CAMPO)
        endif
        dbskip()
    enddo
    //Monta o aHeader do grid conforme os campos definidos no array aSC6 (apenas os campos que deseja)
    //Caso contrário, se quiser todos os campos é necessário trocar o "For" por While, para que este faça a leitura de toda a tabela
    DbSelectArea("SX3")
    SX3->(DbSetOrder(2))
    aHeader:={}
    For nX := 1 to Len(aZZK)
        If SX3->(DbSeek(aZZK[nX]))
            If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
                nUsado:=nUsado+1
                Aadd(aHeader, {TRIM(X3_TITULO), X3_CAMPO , X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO  , X3_TIPO   , X3_ARQUIVO, X3_CONTEXT})
            Endif
        Endif
    Next nX

Return


User Function VerPvPRT()

   
Local cLinok 	:= ".T."
Local cTudook 	:= "Allwaystrue"
Local nOpce 	:= 2 	//define modo de alteração para a enchoice
Local nOpcg 	:= 2 	//define modo de alteração para o grid
Local cFieldok 	:= "Allwaystrue"
Local lRet 		:= .T.
Local cMensagem := ""
Local lVirtual  := .T. 	//Mostra campos virtuais se houver
Local nFreeze	:= 0
Local nAlturaEnc:= 300	//Altura da Enchoice
Private cAlias1 	 := "SC5"
Private cAlias2 	 := "SC6"
Private cCadastro	 := "Pedido Protheus"	
Private aCols 		 := {}
Private aHeader 	 := {}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
//SetKey(VK_F8, { || VerPosProd() } )
aButton := {}

If Empty(ZB5->ZB5_NUM)
	MsgInfo('Pedido não importado.')
	Return(.f.)
Else
	dbSelectArea('SC5')
	dbSetOrder(1)
	dbSeek(ZB5->ZB5_FILIAL+ZB5->ZB5_NUM)
EndIf
Aadd(aButton , { 'BITMAP', { || VerCliPos() }, OemtoAnsi('Posicao Cliente')})
//Aadd(aButton , { 'BITMAP', { || VerPosProd() }, OemtoAnsi('Posicao Produto')})
//Aadd(aButton,  { 'BitMap', { || VerDoc() },'Documentos' })
RegToMemory("SC5",.F.)
RegToMemory("SC6",.F.)
DefineCabec()
DefineaCols(0)
Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,nOpcg,cFieldok,lVirtual,,aAltenchoice,nFreeze,aButton,,nAlturaEnc)
aCols := {}
SetKey(VK_F8, { || Nil } )

Return() 
