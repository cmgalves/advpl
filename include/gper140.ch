#ifdef SPANISH
	#define STR0001 " Matricula "
	#define STR0002 " Centro de Costo "
	#define STR0003 "Documento de liquidacion final "
	#define STR0004 "Se imprimira de acuerdo con los parametros solicitados por"
	#define STR0005 "el usuario."
	#define STR0006 "A Rayas"
	#define STR0007 "Administracion"
	#define STR0008 "EMISION DOCUMENTO DE LIQUIDACION FINAL"
	#define STR0009 "Opcion no disponible para el Pais"
	#define STR0010 "1 - no optante "
	#define STR0011 "2 - optante - facturac. anual hasta R$ 1.200.000,00"
	#define STR0012 "3 - optante - facturacion anual superior a R$ 1.200.000,00"
	#define STR0013 "4 - no optante - productor rural pers. fisica  (CEI y FPAS 604)"
	#define STR0014 "5 - no optante  - Dictamen Prel. de no retenc. de C. Social"
	#define STR0015 "6 - optante - fact anual> R$1.200.000,00 - Dict Pre p/no retenc.C.Social"
	#define STR0016 "Opcion Simple"
	#define STR0017 "EMISION TERM. RESCIS. / EXONERAC."
	#define STR0018 "Termino de Rescis. / Exonerac."
	#define STR0019 "Recibo de Liquidacion"
#else
	#ifdef ENGLISH
		#define STR0001 " Registration"
		#define STR0002 " Cost Center     "
		#define STR0003 "Agreement Termination Terms"
		#define STR0004 "Will be printed according to parameters selected by the "
		#define STR0005 "User.   "
		#define STR0006 "Z.Form "
		#define STR0007 "Management   "
		#define STR0008 "ISSUANCE OF AGREEMENT TERMINATION TERMS"
		#define STR0009 "Option is not available for this Country"
		#define STR0010 "1 - not optant "
		#define STR0011 "2 - optant  - annual turnover up to R$ 1,200,000.00"
		#define STR0012 "3 - optant - annual turnover superior to   R$ 1,200,000.00"
		#define STR0013 "4 - not optant -  rural producer natural pers. (CEI and FPAS 604)"
		#define STR0014 "5 - not optant - Injunction not to collect Social Contrib. "
		#define STR0015 "6 - optant - ann. turn. > R$1,200,000.00 - Injuct. not to collec.Soc.Con"
		#define STR0016 "Simple option"
		#define STR0017 "TERMINATION / DISMISSAL TERM ISSUE"
		#define STR0018 "Termination/Dismissal Term"
		#define STR0019 "Payment Receipt"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", " Registo ", " Matricula " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", " centro de custo ", " Centro de Custo " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Termo de recis�o do contrato ", "Termo de Recis�o do Contrato " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Sera impresso de acordo com os par�metro s solicitados pelo", "Ser� impresso de acordo com os parametros solicitados pelo" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Utilizador.", "usu�rio." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administra��o" )
		#define STR0008 "EMISS�O TERMO RESCIS�O DO CONTRATO"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Op��o N�o Dispon�vel Para Este Pa�s", "Opcao nao disponivel para este Pais" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "1 - n�o optante", "1 - nao optante" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "2 - optante - facturamento anual at� � 1.200.000,00", "2 - optante - faturamento anual ate R$ 1.200.000,00" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "3 - optante - facturamento anual superior a � 1.200.000,00", "3 - optante - faturamento anual superior a R$ 1.200.000,00" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "4 - n�o optante - produtor rural pessoa f�sica (nif � fpas 604)", "4 - nao optante - produtor rural pessoa fisica (CEI e FPAS 604)" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "5 - N�o Optante - Liminar Para N�o Recolhimento Da C.social", "5 - nao optante - Liminar para nao recolhimento da C.Social" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "6 - optante - fact.anual > �1.200.000,00 - liminar p/n�o recolh.c.social", "6 - optante - fat.anual > R$1.200.000,00 - Liminar p/nao recolh.C.Social" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Op��o Simples", "Opcao Simples" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Emiss�o termo rescis�o / exonera��o", "EMISS�O TERMO RESCIS�O / EXONERA��O" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Termo de rescis�o / exonera��o", "Termo de Rescis�o / Exonera��o" )
		#define STR0019 "Recibo de Quita��o"
	#endif
#endif
