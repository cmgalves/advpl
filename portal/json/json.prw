#Include "Protheus.ch"
#Include "Apwebex.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"


///*******************************
//	Filtra os representantes na comissão
//	'/pp/portal/b_fjFilRep.apw'
///*******************************
Webuser function fjFilRep()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''


xaParam	:=	{'fjFilRep', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjXml01.apw'
///*******************************
Webuser function fjXml01()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xcRetJson	:=	fxJson()

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetJson

web EXTENDED end

return xcHtml


static function fxJson()
	local xcRet	:=	''
	local xcDir			:=	'\web\pp\xml\'
	local xaDir			:=	{}
	
	xaDir := directory(xcDir + "*.XML")

	xcRet	:=	'['
	for xi := 1 to len(xaDir)
	
	
	
	next xi
	xcRet	+=  ']'



/*
	xcHtml	:=	'['

	XTRB->(dbGoTop())
	While !(XTRB->(EOF()))
		xcHtml	+=	alltrim(XTRB->json)
		XTRB->(dbSkip())
		if !(XTRB->(EOF()))
			xcHtml	+= ','
		endif
	Enddo

	xcHtml	+=  ']'
	*/
	
return xcRet

///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjPedPts.apw'
///*******************************
Webuser function fjPedPts()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''

xcPar	:=	alltrim(httpGet->xcPar)


xaParam	:=	{'fjPedPontos', xcPar, ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna os custos calculados
//	mês a mês
///*******************************
Webuser function fjAdmLb()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjAdmLb', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna informações sobre as comissões
//	
///*******************************
Webuser function fjcomiss()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar01		:=	''
local xcPar02		:=	''

xcPar01	:=	alltrim(httpGet->xcPar01)
xcPar02	:=	alltrim(httpGet->xcPar02)

xaParam	:=	{'fjcomiss', xcPar01, xcPar02}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna o código do equipamentos para cadastro.
//	'/pp/portal/b_fjTicCod.apw'
///*******************************
Webuser function fjRepPed()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''


xcPar	:=	StrTokArr(httpGet->xcPar, '|')

xaParam	:=	{'fjRepPed', xcPar, ''}

//

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna o código do equipamentos para cadastro.
//	'/pp/portal/b_fjTicCod.apw'
///*******************************
Webuser function fjTicCod()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''


xaParam	:=	{'fjTicCod', httpGet->xcTipo, ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna os tipos de equipamentos para cadastro.
//	'/pp/portal/b_fjTicTip.apw'
///*******************************
Webuser function fjTicTip()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''


xaParam	:=	{'fjTicTip', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista de municipios
//	'/pp/portal/b_fjCliMun.apw'
///*******************************
Webuser function fjCliMun()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''


xaParam	:=	{'fjCliMun', Upper(httpGet->term), ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna lista de motivos de bloqueio de clientes
//	'/pp/portal/b_fjMotiv.apw'
///*******************************
Webuser function fjMotiv()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''


xaParam	:=	{'fjMotiv', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista dos Saldos em estoque mensal
//	'/pp/portal/b_fjInativ.apw'
///*******************************
Webuser function fjInativ()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''

xcPar	:=	httpGet->xcPar

xaParam	:=	{'fjInativ', xcPar, ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista dos Saldos em estoque mensal
//	'/pp/portal/b_fjInaNot.apw'
///*******************************
Webuser function fjInaNot()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcPar			:=	''

xcPar	:=	httpGet->xcPar

xaParam	:=	{'fjInaNot', xcPar, ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna lista dos Saldos em estoque mensal
//	'/pp/portal/b_fjPedCli.apw'
///*******************************
Webuser function fjPedCli()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjPedCli', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista dos Saldos em estoque mensal
//	'/pp/portal/b_fjPcpEst.apw'
///*******************************
Webuser function fjPcpEst()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjPcpEst', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna os custos calculados
//	mês a mês
///*******************************
Webuser function fjAdmFec()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjAdmFec', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna os custos calculados
//	mês a mês
///*******************************
Webuser function fjAdmCus()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjAdmCus', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjFiltMg.apw'
///*******************************
Webuser function fjFiltMg()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjFiltMg', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjMargens.apw'
///*******************************
Webuser function fjMargens()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xaPar			:=	''

xaPar	:=	StrTokArr(httpGet->xcPar, '|')

xaParam	:=	{'fjMargens', xaPar, ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjCoefMg.apw'
///*******************************
Webuser function fjCoefMg()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjCoefMg', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjPedAlt.apw'
///*******************************
Webuser function fjPedAlt()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fxAlteraPed', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjPedRep.apw'
///*******************************
Webuser function fjPedRep()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcSup			:=	''


xaParam	:=	{'fjPedRep', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna Detalhes do pedido selecionado
//	'/pp/portal/b_fjPedDet.apw'
///*******************************
Webuser function fjPedDet()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcSup			:=	''


xaParam	:=	{'fjPedDet', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna os objetivos dos Ger
//	'/pp/portal/b_fjPedObj.apw'
///*******************************
Webuser function fjPedObj()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcSup			:=	''


xaParam	:=	{'fjPedObj', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna os objetivos dos Ger
//	'/pp/portal/b_fjPedObj.apw'
///*******************************
Webuser function fjFolCad()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}
local xcSup			:=	''


xaParam	:=	{'fjFolCad', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




///*******************************
//	Retorna lista  dos pedidos
//	'/pp/portal/b_fjStatus.apw'
///*******************************
Webuser function fjStatus()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fjStatus', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml


///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjRotas.apw'
///*******************************
Webuser function fjRotas()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fxRotas', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna lista dos pedidos do protheus
//	'/pp/portal/b_fjCadRot.apw'
///*******************************
Webuser function fjCadRot()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fxCadRot', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml

///*******************************
//	Retorna os pedido po Rotas
//
///*******************************
Webuser function fjRotPed()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}


xaParam	:=	{'fxRotPed', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

PrepEnvPor()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml



///*******************************
//	Retorna lista de chamados - ListaChamados
//	'/pp/portal/b_fjChamado.apw'
///*******************************
Webuser function fjChamado()
local xcHtml		:=	''
local xcRetSql		:=	''
local xaParam		:=	{}

PrepEnvPor()

xaParam	:=	{'ListaChamados', '', ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




///*******************************
//   Json com as tabelas basicas do sistema - ListaTabelas
//	'/pp/portal/b_fjTabelas.apw'
//   02 - Tabela de Status de Chamados
//   03 - Tabela de Tecnicos
//   04 - Tabelas de Areas de Atendimento
//   05 - Tabela de Impactos dos Chamados
///*******************************

Webuser function fjTabelas()
local xcHtml	:=	''
local xcRetSql	:=	''
local xaParam	:=	{}

PrepEnvPor()

xaParam	:=	{'ListaTabelas', alltrim(httpPost->xcCodUser), ''}

xcRetSql	:=	U_fxMontaSql(xaParam)

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml





/*
Tela dos Clientes Ativos
*/
Webuser function fjClirep()
local xcHtml	:=	''
local xcRetSql		:=	''

PrepEnvPor()

xcRetSql	:=	fxRetHtm()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




static function fxRetHtm()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)

	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	* "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	json_Cadsatro_Representantes "

//Gera um arquivo com a query acima.
	MemoWrite("\system\sql\json_Cadsatro_Representantes.SQL",xcQuery)

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif


//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	xcHtml	:=	'['

	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		xcHtml	+=	alltrim(XTT->json)
		XTT->(dbSkip())
		if !(XTT->(EOF()))
			xcHtml	+= ','
		endif
	Enddo

	xcHtml	+=  ']'

	XTT->(dbCloseArea())


return xcHtml


/*
Tela de Integração com o Guarani
*/
Webuser function fjIntGuarani()
local xcHtml	:=	''
local xcRetSql		:=	''

PrepEnvPor()

xcRetSql	:=	fxRetGuar()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




static function fxRetGuar()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)
	local xaFiles := {}

	xaFiles := Directory("\web\pp\guarani\out\*.*", "D")
	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	* "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	json_Cadsatro_Representantes "

//Gera um arquivo com a query acima.
	MemoWrite("\system\sql\json_Cadsatro_Representantes.SQL",xcQuery)

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif


//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	xcHtml	:=	'['

	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		xcHtml	+=	alltrim(XTT->json)
		XTT->(dbSkip())
		if !(XTT->(EOF()))
			xcHtml	+= ','
		endif
	Enddo

	xcHtml	+=  ']'

	XTT->(dbCloseArea())


return xcHtml


/*
Cadastro de Colaboradores
*/
Webuser function fjColab()
local xcHtml	:=	''
local xcRetSql		:=	''

PrepEnvPor()

xcRetSql	:=	fxRetClb()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




static function fxRetClb()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)

	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	* "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	json_Cadsatro_Colaboradores "

//Gera um arquivo com a query acima.
	MemoWrite("\system\sql\json_Cadsatro_Colaboradores.SQL",xcQuery)

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif


//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	xcHtml	:=	'['

	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		xcHtml	+=	alltrim(XTT->json)
		XTT->(dbSkip())
		if !(XTT->(EOF()))
			xcHtml	+= ','
		endif
	Enddo

	xcHtml	+=  ']'

	XTT->(dbCloseArea())


return xcHtml



/*
Controle de Chamados, Detalhes
*/
Webuser function fjChmDet()
local xcHtml	:=	''
local xcRetSql		:=	''

PrepEnvPor()

if !(type("HttpSession->cUsr") == 'C')
	web EXTENDED init xcHtml
	xcHtml += RedirPage('b_fxLogin.apw')
	web EXTENDED end
endif
xcRetSql	:=	fxRetDet()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




static function fxRetDet()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)
	local xcChamad		:=	httpGet->xcChamad
	default xcChamad	:=	'000000'
	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	* "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	json_Chamados_Detalhes "
	if xcChamad != '000000'
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	PA1_CODIGO = " + xcChamad + " "
	endif

//Gera um arquivo com a query acima.
	MemoWrite("\system\sql\json_Chamados_Detalhes.SQL",xcQuery)

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif


//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	xcHtml	:=	'['

	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		xcHtml	+=	alltrim(XTT->json)
		XTT->(dbSkip())
		if !(XTT->(EOF()))
			xcHtml	+= ','
		endif
	Enddo

	xcHtml	+=  ']'

	XTT->(dbCloseArea())


return xcHtml





/*
Json com cadastro de produtos para o catálogo
*/

Webuser function fjCatalogo()
local xcHtml	:=	''
local xcRetSql		:=	''


PrepEnvPor()

xcRetSql	:=	fxCatalogo()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




static function fxCatalogo()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)

	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	* "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	CUBOMB..vw_Produtos_Catalogos "
	xcQuery += xcR + 	"ORDER BY "
	xcQuery += xcR + 	"	1 "

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif

//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	xcHtml	:=	'['

	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		xcHtml	+=	alltrim(XTT->json)
		XTT->(dbSkip())
		if !(XTT->(EOF()))
			xcHtml	+= ','
		endif
	Enddo
	xcHtml	+=  ']'

	XTT->(dbCloseArea())

return xcHtml



/*
Json com cadastro de produtos para o catálogo
*/

Webuser function fjPermis()
local xcHtml	:=	''
local xcRetSql		:=	''


PrepEnvPor()

xcRetSql	:=	fxPermis()

web EXTENDED init xcHtml

xcHtml	:=	xcRetSql

web EXTENDED end

return xcHtml




static function fxPermis()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)

	xcQuery := 			"SELECT "
	xcQuery += xcR + 	"	* "
	xcQuery += xcR + 	"FROM "
	xcQuery += xcR + 	"	CUBOMB..vw_Produtos_Catalogos "
	xcQuery += xcR + 	"ORDER BY "
	xcQuery += xcR + 	"	1 "

	if select("XTT") > 0
		XTT->(dbclosearea())
	endif

//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTT

	xcHtml	:=	'['

	XTT->(dbGoTop())
	While !(XTT->(EOF()))
		xcHtml	+=	alltrim(XTT->json)
		XTT->(dbSkip())
		if !(XTT->(EOF()))
			xcHtml	+= ','
		endif
	Enddo
	xcHtml	+=  ']'

	XTT->(dbCloseArea())

return xcHtml