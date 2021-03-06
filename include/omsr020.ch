#ifdef SPANISH
	#define STR0001 "Lista de cargas"
	#define STR0002 "Este informe imprime la lista de cargas de acuerdo"
	#define STR0003 "con los parametros informados por el usuario"
	#define STR0004 "SECUENCIA PEDIDO CLIENTE   NOMBRE                                   PESO    VOLUMEN"
	#define STR0005 "ENTREGA                                                                          M3"
	#define STR0006 "CARGA   : "
	#define STR0007 "VEHICULO: "
	#define STR0008 "CONDUCTOR  : "
	#define STR0009 "PESO    :"
	#define STR0010 "VOLUMEN M3: "
	#define STR0011 "PTOS ENTREGA : "
	#define STR0012 "VALOR : "
	#define STR0013 "FECHA   :"
	#define STR0014 " A LAS "
	#define STR0015 "ITEM PRODUCTO        DESCRIPCION                         CTD 1aUM       CTD 2aUM             VALOR          PESO          VOLUMEN"
	#define STR0016 "Seleccionando Registros..."
	#define STR0017 "Factura Num.: "
	#define STR0018 " Num: "
	#define STR0019 "Por Pedidos"
	#define STR0020 "Por Productos"
	#define STR0021 "PRODUCTO          DESCRIPCION                         CTD 1aUM      CTD 2aUM       PESO      VOLUMEN         VALOR"
	#define STR0022 "PRODUCTO           DESCRIPCION                    LOTE       SUBLOTE      CTD 1aUM      CTD 2aUM       PESO      VOLUMEN         VALOR    "
	#define STR0023 "ITEM PRODUCTO          DESCRIPCION                     LOTE       SUBLOTE     CTD. 1aUM      CTD. 2aUM          VALOR           PESO       VOLUMEN"
	#define STR0024 "Total General"
	#define STR0025 "Total --->"
	#define STR0026 "Carga"
	#define STR0027 "Pedido/Item"
	#define STR0028 "Producto"
	#define STR0029 "Item de Carga"
	#define STR0030 "Item de liberacion Pedido de venta"
	#define STR0031 "Peso"
	#define STR0032 "Volum."
	#define STR0033 "Item del documento salida"
	#define STR0034 "TOTAL DE ITEM"
	#define STR0035 "Total Producto"
	#define STR0036 "Total de Carga"
	#define STR0037 "Sec."
#else
	#ifdef ENGLISH
		#define STR0001 "Loads List"
		#define STR0002 "This report will present a list of loads according"
		#define STR0003 "to the parameters selected by the user"
		#define STR0004 "SEQUENCE  ORDER  CUSTOMER  NAME                                     WEIGHT   VOLUME"
		#define STR0005 "DELIVERY                                                                      M3"
		#define STR0006 "LOAD    : "
		#define STR0007 "VEHICLE : "
		#define STR0008 "DRIVER  : "
		#define STR0009 "WEIGHT  :"
		#define STR0010 "VOLUME M3 : "
		#define STR0011 "DELIVERY PTS : "
		#define STR0012 "VALUE : "
		#define STR0013 "DATE    :"
		#define STR0014 " AT "
		#define STR0015 "ITEM PRODUCT         DESCRIPTION                         QUANTITY             VALUE            WEIGHT            VOLUME"
		#define STR0016 "Selecting Records..."
		#define STR0017 "Invoice Nr. : "
		#define STR0018 " Nr.  : "
		#define STR0019 "Per Orders"
		#define STR0020 "Per Products"
		#define STR0021 "PRODUCTS          DESCRIPTION                         AMOUNT          WEIGHT   VOLUME           VALUE"
		#define STR0022 "PRODUCT           DESCRIPT.                      LOT        SUBLOT       QTY1stUM      QTY2ndUM      WGHT       VOLUME          VALUE    "
		#define STR0023 "ITEM PRODUCT          DESCRIPT.                       LOT        SUBLOT      QTY.1stUM      QTY.2ndUM          VALUE           WGHT         VOLUME"
		#define STR0024 "Grand Total"
		#define STR0025 "Total --->"
		#define STR0026 "Cargo"
		#define STR0027 "Order/Item"
		#define STR0028 "Product"
		#define STR0029 "Cargo Item"
		#define STR0030 "Release item of Sales order"
		#define STR0031 "Weight"
		#define STR0032 "Volume"
		#define STR0033 "Outflow document item"
		#define STR0034 "ITEM TOTAL"
		#define STR0035 "Product Total"
		#define STR0036 "Cargo Total"
		#define STR0037 "Seq."
	#else
		#define STR0001  "Listagem de cargas"
		Static STR0002 := "Este relatorio ira imprimir a listagem de cargas de acordo"
		Static STR0003 := "com os parametros informados pelo usuario"
		Static STR0004 := "SEQUENCIA PEDIDO CLIENTE   NOME                                     PESO     VOLUME"
		Static STR0005 := "ENTREGA                                                                          M3"
		Static STR0006 := "CARGA   : "
		Static STR0007 := "VEICULO : "
		Static STR0008 := "MOTORISTA : "
		Static STR0009 := "PESO    :"
		Static STR0010 := "VOLUME M3 : "
		Static STR0011 := "PTOS ENTREGA : "
		Static STR0012 := "VALOR : "
		Static STR0013 := "DATA    :"
		Static STR0014 := " AS "
		Static STR0015 := "ITEM PRODUTO         DESCRICAO                           QTD 1aUM       QTD 2aUM             VALOR          PESO          VOLUME"
		Static STR0016 := "Selecionando Registros..."
		Static STR0017 := "Nota Fiscal : "
		Static STR0018 := " Nro : "
		#define STR0019  "Por Pedidos"
		#define STR0020  "Por Produtos"
		Static STR0021 := "PRODUTO           DESCRICAO                           QTD 1aUM      QTD 2aUM       PESO      VOLUME          VALOR"
		Static STR0022 := "PRODUTO           DESCRICAO                      LOTE       SUBLOTE      QTD 1aUM      QTD 2aUM       PESO      VOLUME          VALOR    "
		Static STR0023 := "ITEM PRODUTO          DESCRICAO                       LOTE       SUBLOTE     QTD. 1aUM      QTD. 2aUM          VALOR           PESO         VOLUME"
		Static STR0024 := "Total Geral"
		#define STR0025  "Total --->"
		#define STR0026  "Carga"
		Static STR0027 := "Pedido/Item"
		#define STR0028  "Produto"
		Static STR0029 := "Item da Carga"
		Static STR0030 := "Item da libera��o do Pedido de venda"
		#define STR0031  "Peso"
		#define STR0032  "Volume"
		#define STR0033  "Item do documento de sa�da"
		Static STR0034 := "TOTAL DO ITEM"
		Static STR0035 := "Total Produto"
		Static STR0036 := "Total da Carga"
		#define STR0037  "Seq."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Este relat�rio ir� imprimir a listagem de cargas de acordo"
			STR0003 := "Com os par�metro s informados pelo utilizador"
			STR0004 := "Sequ�ncia Pedido Cliente   Nome                                     Peso     Volume"
			STR0005 := "Entrega                                                                          M3"
			STR0006 := "Carga   : "
			STR0007 := "Veiculo : "
			STR0008 := "Condutor : "
			STR0009 := "Peso    :"
			STR0010 := "Volume m3 : "
			STR0011 := "Ptos entrega : "
			STR0012 := "Valor : "
			STR0013 := "Data    :"
			STR0014 := " as "
			STR0015 := "Item Artigo        Descri��o                           Qtd 1aum       Qtd 2aum             Valor          Peso          Volume"
			STR0016 := "A Seleccionar Registos..."
			STR0017 := "Factura : "
			STR0018 := " nro : "
			STR0021 := "Artigo           Descri��o                           Qtd 1aum      Qtd 2aum       Peso      Volume          Valor"
			STR0022 := "Produto           descri��o                      lote       sublote      qtd 1aum      qtd 2aum       peso      volume          valor    "
			STR0023 := "Item Produto          Descri��o                       Lote       Sublote     Qtd. 1aum      Qtd. 2aum          Valor           Peso         Volume"
			STR0024 := "Total Crial"
			STR0027 := "Pedido/item"
			STR0029 := "Item Da Carga"
			STR0030 := "Item da autoriza��o  do pedido de venda"
			STR0034 := "Total Do Elemento"
			STR0035 := "Total De Artigo"
			STR0036 := "Total Da Carga"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
