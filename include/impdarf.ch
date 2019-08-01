#ifdef SPANISH
	#define STR0001 "¿Impresion  Ok?"
	#define STR0002 "MINISTERIO DE HACIENDA"
	#define STR0003 "FISCO DE BRASIL"
	#define STR0004 "Documento de Recaudacion de Ingresos Federales"
	#define STR0005 "DARF"
	#define STR0006 "NOMBRE/TELEFONO"
	#define STR0007 "ATENCION"
	#define STR0008 "   Se prohibe la recaudacion de tributos y contribuciones administrados por la "
	#define STR0009 "Secretaria Federal de Ingresos cuyo valor sea inferior a R$ 10,00. Si ocurre esta"
	#define STR0010 "situacion agregue ese valor al tributo/contribucion del mismo codigo de periodos"
	#define STR0011 "subsecuentes hasta que el total sea igual o superior a R$10,00."
	#define STR0012 "String no utilizada"
	#define STR0013 "PERIODO DE COMPUTO"
	#define STR0014 "NUMERO DE CPF O CGC"
	#define STR0015 "CODIGO DEL INGRESO"
	#define STR0016 "NUMERO DE REFERENCIA"
	#define STR0017 "FCH.DE VENCIMIENTO"
	#define STR0018 "VALOR PRINCIPAL"
	#define STR0019 "VALOR DE MULTA"
	#define STR0020 "VALOR DE INTERES O"
	#define STR0021 "CARGAS DL - 1025/69"
	#define STR0022 "VALOR TOTAL"
	#define STR0023 "AUTENTICACION BANCARIA"
	#define STR0024 "(Solo en las copias 1a y 2a)"
	#define STR0025 "C.Costo : "
	#define STR0026 "RNPJ/CEI Tomador : "
#else
	#ifdef ENGLISH
		#define STR0001 "Is Print Ok?"
		#define STR0002 "MINISTRY OF FINANCE"
		#define STR0003 "BRAZILIAN FEDERAL REVENUE SECRETARIAT"
		#define STR0004 "Federal Revenues Collection Document"
		#define STR0005 "DARF"
		#define STR0006 "NAME/TELEPHONE"
		#define STR0007 "ATTENTION"
		#define STR0008 "   It is prohibited to collect taxes and assessments managed by "
		#define STR0009 "Federal Revenue Secretariat which value is lower than R$ 10,00.In case this "
		#define STR0010 "situation happens add this value to the tax/assessment with the same code of subsequent"
		#define STR0011 "periods until the total is equal or superior to R$10,00."
		#define STR0012 "String not used"
		#define STR0013 "CALCULATION PERIOD"
		#define STR0014 "CPF OU CGC NUMBER"
		#define STR0015 "REVENUE CODE"
		#define STR0016 "REFERENCE NUMBER"
		#define STR0017 "DUE DATE"
		#define STR0018 "MAIN VALUE"
		#define STR0019 "FINE VALUE"
		#define STR0020 "INTERESTS VALUE AND/OR"
		#define STR0021 "DL - 1025/69 CHARGES"
		#define STR0022 "TOTAL VALUE"
		#define STR0023 "BANK AUTHENTICATION"
		#define STR0024 "(Only in 1st and 2nd copies)"
		#define STR0025 "Cost Center: "
		#define STR0026 "CNPJ/CEI Acquirer: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Impressão Ok?", "Impressäo Ok?" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Ministerio da fazenda", "MINISTÉRIO DA FAZENDA" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Secretaria Da Receita Federal Do Brasil", "SECRETARIA DA RECEITA FEDERAL DO BRASIL" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Documento de arrecadação de receitas federais", "Documento De Arrecadação De Receitas Federais" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Darf", "DARF" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Nome/telefone", "NOME/TELEFONE" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Atenção", "ATENÇÃO" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "   e  vedado  o  recolhimento  de  tributos  e  contribuições administrados pela ", "   É  vedado  o  recolhimento  de  tributos  e  contribuições administrados pela " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Secretaria da receita federal cujo valor seja inferior a r$ 10,00.ocorrendo tal ", "Secretaria da Receita Federal cujo valor seja inferior a R$ 10,00.Ocorrendo tal " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Situação adicione esse valor  ao  tributo/contribuição de mesmo código  de períodos", "situação adicione esse valor  ao  tributo/contribuição de mesmo código de períodos" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Subsequentes ate que o total seja igual ou superior a r$10,00.", "subsequentes até que o total seja igual ou superior a R$10,00." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "String não utilizada", "String nao utilizada" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Período de apuramento", "PERIODO DE APURAÇÃO" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Número Do Cpf Ou Cgc", "NUMERO DO CPF OU CGC" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Código da receita", "CÓDIGO DA RECEITA" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Nr de referência", "NÚMERO DE REFERENCIA" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Data De Vencimento", "DATA DE VENCIMENTO" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Valor Principal", "VALOR PRINCIPAL" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Valor Da Multa", "VALOR DA MULTA" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Valor Dos Juros E/ou", "VALOR DOS JUROS E/OU" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Encargos dl - 1025/69", "ENCARGOS DL - 1025/69" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Valor Total", "VALOR TOTAL" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Autenticação bancária", "AUTENTICAÇÃO BANCÁRIA" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "(somente nas 1a e 2a vias)", "(Somente nas 1a e 2a vias)" )
		#define STR0025 "C.Custo : "
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "NC/CEI Tomador : ", "CNPJ/CEI Tomador : " )
	#endif
#endif
