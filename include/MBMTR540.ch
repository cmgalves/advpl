#ifdef SPANISH
	#define STR0001 "Informe de comisiones "
	#define STR0002 "Emision del informe de comisiones."
	#define STR0003 "A Rayas"
	#define STR0004 "Administracion"
	#define STR0005 "INFORME DE COMISIONES  "
	#define STR0006 "(PAGO EN LA EMISION)"
	#define STR0007 "(PAGO EN LA CANCELACION)"
	#define STR0008 "INFORME DE COMISIONES "
	#define STR0009 "PRF NUMERO   CUOTA CODIGO                 SC  NOMBRE                               FCH.DE HOY  FECHA       FECHA       FECHA      NUMERO          VALOR           VALOR      %           VALOR    TIPO"
	#define STR0010 "    TITULO         CLIENTE                                                         COMISION    ORIGEN      BAJA        PGTO       PEDIDO         TITULO            BASE               COMISION   COMISION"
	#define STR0011 "ANULADO POR EL OPERADOR"
	#define STR0012 "Vendedor : "
	#define STR0013 "TOTAL DEL VENDEDOR --> "
	#define STR0014 "TOTAL  GENERAL    --> "
	#define STR0015 "TOTAL  DE IR      --> "
	#define STR0016 "Seleccionando registros..."
	#define STR0017 "                      "
	#define STR0018 "AJUSTE"
	#define STR0019 "ANALITICO"
	#define STR0020 "SINTETICO"
	#define STR0021 "CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
	#define STR0022 "                                                         TITULO             BASE                COMISION              IR          (-) IR"
	#define STR0023 "Detalhes : Titulos de origem da liquidação "
	#define STR0024 "Prefijo    Numero          Cuota   Tipo    Cliente   Tienda  Nombre                                     Valor Titulo      Fecha Liq.        Valor Liquidacion     Valor Base Liq."
	#define STR0025 "Informe de comisiones"
	#define STR0026 "Emision del informe de comisiones."
	#define STR0027 "Total Titulo"
	#define STR0028 "Total IR"
	#define STR0029 "Total (-) IR"
	#define STR0030 "Total Base"
	#define STR0031 "Total Comision"
	#define STR0032 "%"
	#define STR0033 "Vencto Origen"
	#define STR0034 "Fch.Baja"
	#define STR0035 "Vlr Titulo"
	#define STR0036 "Vlr Base"
	#define STR0037 "AJUSTE"
	#define STR0038 "Comision"
	#define STR0039 "Pedido"
	#define STR0040 "Tipo"
	#define STR0041 "por Vendedor"
	#define STR0042 "Titulos Origen de Liquidacion"
	#define STR0043 "Fecha Neta"
	#define STR0044 "Vlr.Neto"
	#define STR0045 "Vlr.Base Neta"
	#define STR0046 "Por Vendedor+Prefijo+Titulo+Cuota"
	#define STR0047 "Por Vendedor+Cliente+Tienda+Prefijo+Titulo+Cuota"
	#define STR0048 "Comisiones(Analitico)"
	#define STR0049 "Comisiones(Sintetico)"
	#define STR0050 "Vendedores"
	#define STR0051 "Comisiones s/ Liquidacion"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Commissions "
		#define STR0002 "Issue of Report of Commissions.   "
		#define STR0003 "Z.Form "
		#define STR0004 "Management"
		#define STR0005 "REPORT OF COMMISSIONS"
		#define STR0006 "(PAYM. PER ISSUE)"
		#define STR0007 "(PAYM. PER W.OFF)"
		#define STR0008 "REPORT OF COMMISSIONS"
		#define STR0009 "PRX BILL     INST. CUSTOMER               UN  NAME                                 COMMISSION  MATURITY    DATE OF     PAYMENT    ORDER           VALUE           BASE       %           VALUE    TYPE"
		#define STR0010 "    NUMBER         CODE                                                            BASE DATE   DATE        WRITE-OFF   DATE       NUMBER         OF BILL          VALUE               OF COMM.   OF COMM."
		#define STR0011 "CANCELLED BY THE OPERATOR  "
		#define STR0012 "Representative.: "
		#define STR0013 "TOTAL OF REPRES.  --> "
		#define STR0014 "GRAND TOTAL       --> "
		#define STR0015 "TOTAL IR          --> "
		#define STR0016 "Selecting Records..."
		#define STR0017 "TOTAL (-) IR      --> "
		#define STR0018 "ADJUSTMENT"
		#define STR0019 "DETAILED "
		#define STR0020 "SUMMARIZD"
		#define STR0021 "SALES REPR.CODE                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
		#define STR0022 "                                                         BILL               BASE                COMMISS.              IR          (-) IR"
		#define STR0023 "Details :  Bills of origin of liquidation "
		#define STR0024 "Prefix     Number          Inst    Type    Customer  Store   Name                                       Bill Amount       Liq. Date         Liquidation Amount    Base Liq. Amount"
		#define STR0025 "Commissions report    "
		#define STR0026 "Generation of commissions report. "
		#define STR0027 "Bill total  "
		#define STR0028 "IR total"
		#define STR0029 "Total (-) IR"
		#define STR0030 "Base total"
		#define STR0031 "Commiss. total"
		#define STR0032 "%"
		#define STR0033 "Origin due dt."
		#define STR0034 "Pstng.Dt"
		#define STR0035 "Bill amnt."
		#define STR0036 "Base amn"
		#define STR0037 "ADJ.  "
		#define STR0038 "Commiss."
		#define STR0039 "Order "
		#define STR0040 "Type"
		#define STR0041 "by sales rep"
		#define STR0042 "Liquidation origin bills    "
		#define STR0043 "Liq. date"
		#define STR0044 "Net amnt."
		#define STR0045 "Net base amnt"
		#define STR0046 "By Sales Rep.+Prefix+Bill+Installm."
		#define STR0047 "By Sales Rep.+Customer+Store+Prefix+Bill+Instal."
		#define STR0048 "Commissions (Detailed)"
		#define STR0049 "Commissions (Summari.)"
		#define STR0050 "Sales Representatives"
		#define STR0051 "Commissions w/o Settlement"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relatório de comissoes", "Relatorio de Comissöes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Emissão Do Relatório De Comissões.", "Emissao do relatorio de Comissoes." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Relatório de comissões ", "RELATORIO DE COMISSOES " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "(pgt Pela Emissão)", "(PGTO PELA EMISSAO)" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "(pgt Pela Baixa)", "(PGTO PELA BAIXA)" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Relatório De Comissoes", "RELATORIO DE COMISSOES" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Prf Número   Parc. Código  Do              Lj  Nome                                 Dt.base     Vencto      Data        Data       Número          Valor           Valor      %           Valor    Tipo", "PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     VENCTO      DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "    Título         Cliente                                                         Comissão    Origem      Liquidação       Pgt      Pedido         Título            Base               Comissão   Comissão", "    TITULO         CLIENTE                                                         COMISSAO    ORIGEM      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0012 "Vendedor : "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Total do vendedor --> ", "TOTAL DO VENDEDOR --> " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Total  crial      --> ", "TOTAL  GERAL      --> " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Total  de ir      --> ", "TOTAL  DE IR      --> " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Total (-) ir      --> ", "TOTAL (-) IR      --> " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ajuste", "AJUSTE" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Analítico", "ANALITICO" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Sintético", "SINTETICO" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Código Do Vendedor                                           Total            Total      %            Total           Total           Total", "CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "                                                         Título             Base                Comissão              Ir          (-) Ir", "                                                         TITULO             BASE                COMISSAO              IR          (-) IR" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Detalhes : títulos de origem da liquidação ", "Detalhes : Titulos de origem da liquidação " )
		#define STR0024 "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquidação      Valor Base Liq."
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Relatório de comissoes", "Relatorio de Comissöes" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Emissão Do Relatório De Comissões.", "Emissao do relatorio de Comissoes." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Total De Título", "Total Titulo" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Total Ir", "Total IR" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Total (-) Ir", "Total (-) IR" )
		#define STR0030 "Total Base"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Total Comissão", "Total Comissao" )
		#define STR0032 "%"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Vencto De Origem", "Vencto Origem" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Dt.levantamento", "Dt.Baixa" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Vlr De Título", "Vlr Titulo" )
		#define STR0036 "Vlr Base"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Ajuste", "AJUSTE" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Comissão", "Comissao" )
		#define STR0039 "Pedido"
		#define STR0040 "Tipo"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Por Vendedor", "por Vendedor" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Títulos Origem Da Liquidação", "Titulos Origem da Liquidacao" )
		#define STR0043 "Data Liq."
		#define STR0044 "Vlr. Liq."
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Vlr.base Liq.", "Vlr.Base Liq." )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Por Vendedor+prefixo+título+parcela", "Por Vendedor+Prefixo+Titulo+Parcela" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Por Vendedor+cliente+loja+prefixo+título+parcela", "Por Vendedor+Cliente+Loja+Prefixo+Titulo+Parcela" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Comissões (analítico)", "Comissoes (Analitico)" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Comissões (sintético)", "Comissoes (Sintetico)" )
		#define STR0050 "Vendedores"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Comissões s/ Liquidação", "Comissoes s/ Liquidacao" )
		#define STR0052 "Frete"
		#define STR0053 "IPI"
		#define STR0054 "ICMS ST"
	#endif
#endif
