#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"


/*
Tela dos Clientes Ativos
*/
user function fxMontaSql(_aParam)
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)
	local xaParam		:=	_aParam
	local xcHtml		:=	''
	local xcCodUsr		:=	''

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' 


	//USER 'Administrador' PASSWORD '' TABLES 'SE1,SA1,SE2' MODULO ‘FAT’/*******COMANDOS *********/RESET ENVIRONMENT

	//
	xcCodUsr	:=	iif(type('HttpSession->xcCodUser')=='C',HttpSession->xcCodUser,'')
	do case
		case xaParam[1] == 'fjFilRep'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Financeiro_Comissao_Filtro_Vend "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	2 "

		MemoWrite("\sql\json_Financeiro_Comissao_Filtro_Vend.SQL",xcQuery)

		case xaParam[1] == 'fjPedPontos'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Pedidos_Alteracao_Pontos "
		xcQuery += xcR + 	"WHERE " 
		xcQuery += xcR + 	"	pedido = '" + xaParam[2] + "' "

		MemoWrite("\sql\json_Pedidos_Alteracao_Pontos.SQL",xcQuery)

		case xaParam[1] == 'fjAdmLb'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Cadastro_Produto "
		xcQuery += xcR + 	"WHERE " 
		xcQuery += xcR + 	"	tipo = 'PA' "

		MemoWrite("\sql\json_Cadastro_Produto.SQL",xcQuery)

		case xaParam[1] == 'fjcomiss'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Financeiro_Comissao "
		xcQuery += xcR + 	"WHERE " 
		xcQuery += xcR + 	"	VEND = '" + xaParam[2] + "' AND "
		xcQuery += xcR + 	"	EMIS <= '" + xaParam[3] + "' "

		MemoWrite("\sql\json_Financeiro_Comissao.SQL",xcQuery)

		case xaParam[1] == 'fjRepPed'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	TOP 3261 * " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Representantes_Pedidos "
		xcQuery += xcR + 	"WHERE " 
		for xi := 1 to len(xaParam[2])
			if xi == 1
				if left(xaParam[2][xi],1) == 'S'
					if left(xaParam[2][xi],4) $ '|STODOS'
						xcQuery += xcR + 	"	SUPERVISOR <> '" + subs(xaParam[2][xi], 2, 3) + "' "
					else
						xcQuery += xcR + 	"	SUPERVISOR = '" + subs(xaParam[2][xi], 2, 3) + "' "
					endif
				elseif left(xaParam[2][xi],1) == 'V'  
					xcQuery += xcR + 	"	VENDEDOR = '" + subs(xaParam[2][xi], 2, 3) + "' "
				elseif left(xaParam[2][xi],1) == 'P'  
					xcQuery += xcR + 	"	PRODUTO = '" + alltrim(subs(xaParam[2][xi], 2, 23)) + "' "
				elseif left(xaParam[2][xi],1) == 'C'  
					xcQuery += xcR + 	"	CLI = '" + alltrim(subs(xaParam[2][xi], 2, 8)) + "' "
				elseif left(xaParam[2][xi],1) == 'G'  
					xcQuery += xcR + 	"	GRP = '" + alltrim(subs(xaParam[2][xi], 2, 6)) + "' "
				endif
			else
				if left(xaParam[2][xi],1) == 'S'  
					if left(xaParam[2][xi],4) $ '|STODOS'
						xcQuery += xcR + 	"	AND SUPERVISOR <> '" + subs(xaParam[2][xi], 2, 3) + "' "
					else
						xcQuery += xcR + 	"	AND SUPERVISOR = '" + subs(xaParam[2][xi], 2, 3) + "' "
					endif
				elseif left(xaParam[2][xi],1) == 'V'  
					xcQuery += xcR + 	"	AND VENDEDOR = '" + subs(xaParam[2][xi], 2, 3) + "' "
				elseif left(xaParam[2][xi],1) == 'P'  
					xcQuery += xcR + 	"	AND PRODUTO = '" + alltrim(subs(xaParam[2][xi], 2, 23)) + "' "
				elseif left(xaParam[2][xi],1) == 'C'  
					xcQuery += xcR + 	"	AND CLI = '" + alltrim(subs(xaParam[2][xi], 2, 8)) + "' "
				elseif left(xaParam[2][xi],1) == 'G'  
					xcQuery += xcR + 	"	AND GRP = '" + alltrim(subs(xaParam[2][xi], 2, 6)) + "' "
				endif
			endif
		next xi

		xcQuery += xcR + 	"ORDER BY " 
		xcQuery += xcR + 	"	1 DESC " 
		
		MemoWrite("\sql\json_Representantes_Pedidos.SQL",xcQuery)
		
		case xaParam[1] == 'fjTicCod'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Tic_Codigo_Equipamentos "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	tipo = '" + xaParam[2] + "' "

		MemoWrite("\sql\json_Tic_Codigo_Equipamentos.SQL",xcQuery)

		case xaParam[1] == 'fjTicTip'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Tic_Tipos_Equipamentos "

		MemoWrite("\sql\json_Tic_Tipos_Equipamentos.SQL",xcQuery)

		case xaParam[1] == 'fjCliMun'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Pedidos_Cadastro_Cli_Munic "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	mun LIKE '%" + xaParam[2] + "%' "

		MemoWrite("\sql\json_Pedidos_Cadastro_Cli_Munic.SQL",xcQuery)

		case xaParam[1] == 'fjMotiv'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Comercial_Clientes_Inativos_Motivos "

		MemoWrite("\sql\json_Comercial_Clientes_Inativos_Motivos.SQL",xcQuery)

		case xaParam[1] == 'fjInativ'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Comercial_Clientes_Inativos "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	est = '" + xaParam[2] + "' "

		MemoWrite("\sql\json_Comercial_Clientes_Inativos.SQL",xcQuery)

		case xaParam[1] == 'fjInaNot'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Comercial_Clientes_Inativos_Anotacao "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	LTRIM(RTRIM(chave)) = '" + AllTrim(xaParam[2]) + "' "

		MemoWrite("\sql\json_Comercial_Clientes_Inativos_Anotacao.SQL",xcQuery)

		case xaParam[1] == 'fjPedCli'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Pedidos_Cadastro_Cli "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	2 "

		MemoWrite("\sql\json_Pedidos_Cadastro_Cli.SQL",xcQuery)

		case xaParam[1] == 'fjPcpEst'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Pcp_Analise_Estoque "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "

		MemoWrite("\sql\json_Pcp_Analise_Estoque.SQL",xcQuery)

		case xaParam[1] == 'fjAdmCus'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Adm_Custos "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "

		MemoWrite("\sql\json_Adm_Custos.SQL",xcQuery)

		case xaParam[1] == 'fjAdmFec'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Adm_Fechamento "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "

		MemoWrite("\sql\json_Adm_Fechamento.SQL",xcQuery)

		case xaParam[1] == 'fjFiltMg'
		xcQuery := 			"SELECT  "
		xcQuery += xcR + 	"	* " 
		xcQuery += xcR + 	"FROM " 
		xcQuery += xcR + 	"	json_Adm_Margem_Filtros "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "

		MemoWrite("\sql\json_Adm_Margem_Filtros.SQL",xcQuery)

		case xaParam[1] == 'fjMargens'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Adm_Margem_Rep_Super "
		xcQuery += xcR + 	"WHERE "
		if xaParam[2][1] != '001'
			xcQuery += xcR + 	"	RC = '" + xaParam[2][1] + "' AND "
		endif
		xcQuery += xcR + 	"	MESANO BETWEEN '" + xaParam[2][2] + "' AND '" + xaParam[2][3] + "' "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	5 "

		MemoWrite("\sql\json_Adm_Margem_Rep_Super.SQL",xcQuery)

		case xaParam[1] == 'fjCoefMg'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Apoio_Coeficiente_Margem "

		MemoWrite("\sql\json_Apoio_Coeficiente_Margem.SQL",xcQuery)

		case xaParam[1] == 'ListaChamados'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Chamados "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	xcuser like '%" + xaParam[2] + "%' "

		MemoWrite("\sql\json_chamados.SQL",xcQuery)

		case xaParam[1] == 'ListaTabelas'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Tabelas "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	json like '%" + alltrim(httpGet->xcCodUsr) + "%' AND "
		xcQuery += xcR + 	"	json like '%" + alltrim(httpGet->xcTpFunc) + "%'  "

		MemoWrite("\sql\json_Lista_de_Tabelas.SQL",xcQuery)

		case xaParam[1] == 'fxAlteraPed'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Pedidos_Alteracao "

		MemoWrite("\sql\json_Pedidos_Alteracao.SQL",xcQuery)

		case xaParam[1] == 'fxRotas'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Rotas "

		MemoWrite("\sql\json_Rotas.SQL",xcQuery)

		case xaParam[1] == 'fxCadRot'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Rotas_Lista "

		MemoWrite("\sql\json_Rotas_Lista.SQL",xcQuery)

		case xaParam[1] == 'fxRotPed'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Rotas_Pedidos "

		MemoWrite("\sql\json_Rotas_Pedidos.SQL",xcQuery)

		case xaParam[1] == 'fjStatus'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Pedidos_Alteracao_Status "

		MemoWrite("\sql\json_Pedidos_Alteracao_Status.SQL",xcQuery)

		case xaParam[1] == 'fjPedRep'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Pedidos_Supervisor "

		MemoWrite("\sql\json_Pedidos_Supervisor.SQL",xcQuery)

		case xaParam[1] == 'fjPedDet'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Pedidos_Supervisor_Detalhes "

		MemoWrite("\sql\json_Pedidos_Supervisor_Detalhes.SQL",xcQuery)

		case xaParam[1] == 'fjPedObj'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Pedidos_Supervisor_Objetivos "

		MemoWrite("\sql\json_Pedidos_Supervisor_Objetivos.SQL",xcQuery)

		case xaParam[1] == 'fjFolCad'
		xcQuery := 			"SELECT "
		xcQuery += xcR + 	"	* "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	json_Folha_Cadastro_Funcionarios "

		MemoWrite("\sql\json_Folha_Cadastro_Funcionarios.SQL",xcQuery)

	endcase //


	//trecho comum do programa
	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif


	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

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

	XTRB->(dbCloseArea())


return xcHtml