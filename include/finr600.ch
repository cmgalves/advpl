#ifdef SPANISH
	#define STR0001 "El  objetivo  de  este programa es imprimir los "
	#define STR0002 "talones de pago del banco seleccionado,segun layout "
	#define STR0003 "configurado previamente."
	#define STR0004 "Impresion del talon en "
	#define STR0005 "A Rayas"
	#define STR0006 "Administracion"
	#define STR0007 "ANULADO POR EL OPERADOR"
	#define STR0008 "Antes de iniciar la impresion, compruebe que el formulario continuo esta ajustado."
	#define STR0009 "La prueba se imprimira en la columna de lugar de pagos."
	#define STR0010 "Haga clic en el boton impresora para la prueba de posicion."
	#define STR0011 "�Formulario colocado correctamente?"
	#define STR0012 "Antes de iniciar la impresion, compruebe que el formulario continuo este "
	#define STR0013 "ajustado. La prueba se imprimira en la columna de lugar de pagos. "
	#define STR0014 "�Formulario colocado correctamente?"
	#define STR0015 "Confirmar"
	#define STR0016 "Reescribir"
	#define STR0017 "Salir"
	#define STR0018 "Fact. por Cobrar"
	#define STR0019 "Mensajes"
	#define STR0020 "Linea 1"
	#define STR0021 "Linea 2"
	#define STR0022 "Linea 3"
	#define STR0023 "�Graba? "
	#define STR0024 "�Graba? "
	#define STR0025 "�Bordero Generico?"
	#define STR0026 "Existen otros mensajes configurados para el talon, �confirma sustitucion?"
#else
	#ifdef ENGLISH
		#define STR0001 "This program has the purpose of printing Dockets "
		#define STR0002 "of the selected Bank, according to lay-out "
		#define STR0003 "previously configured.      "
		#define STR0004 "Printing the Docket in "
		#define STR0005 "Z.Form "
		#define STR0006 "Management   "
		#define STR0007 "CANCELLED BY THE OPERATOR  "
		#define STR0008 "Before starting to print, check whether the continuous form paper is adjusted ."
		#define STR0009 "The test will be printed in the payment place column. "
		#define STR0010 "Click on the printer button for positioning test.       "
		#define STR0011 "Form correctly positioned ?          "
		#define STR0012 "Before starting to print, check whether the continuous form paper"
		#define STR0013 "is adjusted. The test shall be printed in the payment locality "
		#define STR0014 "column. Form correctly positioned?          "
		#define STR0015 "OK"
		#define STR0016 "Retype"
		#define STR0017 "Quit"
		#define STR0018 "Invoices Receivable"
		#define STR0019 "Messages "
		#define STR0020 "Line  1"
		#define STR0021 "Line  2"
		#define STR0022 "Line  3"
		#define STR0023 "About recording ?"
		#define STR0024 "About recording ?"
		#define STR0025 "Generic Bordero?"
		#define STR0026 "There are other messages configurated for this docket. OK to substitute ?"
	#else
		Static STR0001 := "Este  programa  tem como objetivo imprimir os"
		Static STR0002 := "Boletos do banco selecionado, conforme layout"
		Static STR0003 := "previamente configurado."
		Static STR0004 := "Impressao do Boleto em "
		Static STR0005 := "Zebrado"
		Static STR0006 := "Administracao"
		Static STR0007 := "CANCELADO PELO OPERADOR"
		#define STR0008  "Antes de iniciar a impress�o, verifique se o formul�rio continuo est� ajustado."
		#define STR0009  "O teste ser� impresso na coluna de local de pagamento."
		#define STR0010  "Clique no bot�o impressora para teste de posicionamento."
		Static STR0011 := "Formul�rio posicionado corretamente ?"
		Static STR0012 := "Antes de iniciar a impressao, verifique se o formul�rio continuo "
		Static STR0013 := "est� ajustado. O teste ser� impresso na coluna de local de paga- "
		Static STR0014 := "mento. Formul�rio posicionado corretamente ?"
		#define STR0015  "Confirma"
		#define STR0016  "Redigita"
		Static STR0017 := "Abandona"
		Static STR0018 := "Faturas a Receber"
		#define STR0019  "Mensagens"
		#define STR0020  "Linha 1"
		#define STR0021  "Linha 2"
		#define STR0022  "Linha 3"
		Static STR0023 := "Quanto a grava��o ? "
		Static STR0024 := "Quanto a grava��o ?"
		Static STR0025 := "Bordero Gen�rico ?"
		Static STR0026 := "Existem outras mensagens configuradas para o boleto, confirma substitui��o ?"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Este  programa  tem como objectivo imprimir os"
			STR0002 := "Recibos do banco seleccionado, conforme visualiza��o"
			STR0003 := "Previamente configurado."
			STR0004 := "Impress�o do recibo em "
			STR0005 := "C�digo de barras"
			STR0006 := "Administra��o"
			STR0007 := "Cancelado Pelo Operador"
			STR0011 := "Formul�rio posicionado correctamente ?"
			STR0012 := "Antes de iniciar a impress�o, verifique se o formul�rio cont�nuo "
			STR0013 := "Est� ajustado. o teste ser� impresso na coluna de local de paga- "
			STR0014 := "Mento. formul�rio posicionado correctamente ?"
			STR0017 := "Abandonar"
			STR0018 := "Facturas A Receber"
			STR0023 := "Quanto � grava��o ? "
			STR0024 := "Quanto a Grava��o ?"
			STR0025 := "Borderaux gen�rico ?"
			STR0026 := "Existem outras mensagens configuradas para o recibo, confirma substitui��o ?"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Este  programa  tem como objectivo imprimir os"
			STR0002 := "Recibos do banco seleccionado, conforme visualiza��o"
			STR0003 := "Previamente configurado."
			STR0004 := "Impress�o do recibo em "
			STR0005 := "C�digo de barras"
			STR0006 := "Administra��o"
			STR0007 := "Cancelado Pelo Operador"
			STR0011 := "Formul�rio posicionado correctamente ?"
			STR0012 := "Antes de iniciar a impress�o, verifique se o formul�rio cont�nuo "
			STR0013 := "Est� ajustado. o teste ser� impresso na coluna de local de paga- "
			STR0014 := "Mento. formul�rio posicionado correctamente ?"
			STR0017 := "Abandonar"
			STR0018 := "Facturas A Receber"
			STR0023 := "Quanto � grava��o ? "
			STR0024 := "Quanto a Grava��o ?"
			STR0025 := "Borderaux gen�rico ?"
			STR0026 := "Existem outras mensagens configuradas para o recibo, confirma substitui��o ?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF