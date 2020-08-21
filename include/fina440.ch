#ifdef SPANISH
	#define STR0001 "Confirmar"
	#define STR0002 "Salir"
	#define STR0003 "Calculo de comisiones Off Line"
	#define STR0004 "El objetivo de este programa es ejecutar el calculo de las comisiones "
	#define STR0005 "de los vendedores, segun los parametros definidos por el usuario. "
	#define STR0006 "Seleccionando registros..."
	#define STR0007 "Borrando comisiones no pagadas "
	#define STR0008 "Calculando comisiones por la emision"
	#define STR0009 "Calculando comisiones por la baja."
	#define STR0010 "Titulo"
	#define STR0011 "Parametros"
	#define STR0012 "Visualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Confirm"
		#define STR0002 "Quit"
		#define STR0003 "Off-line calculation of commissions"
		#define STR0004 "The purpose of this program is to calculate the Sales Representative "
		#define STR0005 "commissions, according to the parameters defined by the User.     "
		#define STR0006 "Selecting Records..."
		#define STR0007 "Deleting unpaid commissions"
		#define STR0008 "Calculating Commissions by Issue Date"
		#define STR0009 "Calculating Commissions by Posting"
		#define STR0010 "Bill"
		#define STR0011 "Parameters"
		#define STR0012 "View"
	#else
		#define STR0001  "Confirma"
		Static STR0002 := "Abandona"
		Static STR0003 := "C�lculo de Comiss�es Off-Line"
		Static STR0004 := "Este programa tem como objetivo executar o c�lculo das comiss�es  "
		#define STR0005  "dos Vendedores conforme os par�metros definidos pelo usu�rio.     "
		Static STR0006 := "Selecionando Registros..."
		Static STR0007 := "Excluindo Comiss�es n�o pagas"
		Static STR0008 := "Calculando Comiss�es pela Emiss�o"
		Static STR0009 := "Calculando Comiss�es pela Baixa"
		Static STR0010 := "Titulo"
		#define STR0011  "Par�metros"
		#define STR0012  "Visualizar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Abandonar"
			STR0003 := "C�lculo De Comiss�es Off-line"
			STR0004 := "Este programa tem como objectivo executar o c�lculo das comiss�es  "
			STR0006 := "A Seleccionar Registos..."
			STR0007 := "A eliminar comiss�es n�o pagas"
			STR0008 := "A Calcular Comiss�es Pela Emiss�o"
			STR0009 := "A Calcular Comiss�es Pela Liquida��o"
			STR0010 := "T�tulo"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
