#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

User Function fxColab()
	local xaRet		:=	allUsers()
	local xi		:=	''
	local xaUsers	:=	{}
	local xlSeek	:=	.T.
	local xcChave	:=	''
	local xaCods	:=	{}

	for xi := 1 to len(xaRet)

		aadd(xaUsers,;
			alltrim(xaRet[xi][1][01])+'|'+;
			alltrim(xaRet[xi][1][02])+'|'+;
			alltrim(xaRet[xi][1][04])+'|'+;
			alltrim(xaRet[xi][1][12])+'|'+;
			alltrim(xaRet[xi][1][13])+'|'+;
			alltrim(xaRet[xi][1][14])+'|'+;
			iif(xaRet[xi][1][17],'B','L'))

	next xi

	dbselectarea('pac')
	pac->(dbsetorder(1))
	pac->(dbgotop())
	
	dbselectarea('pa1')
	pa1->(dbsetorder(1))
	pa1->(dbgotop())
	
	
	for xi := 1 to len(xaUsers)
	//for xi := 1 to 12
		
	
		xlSeek	:=	!(pac->(dbseek('  01' + subs(xaUsers[xi],4,3)))) //PAC_FILIAL, PAC_TABELA, PAC_CHAVE, R_E_C_N_O_, D_E_L_E_T_

		reclock('pac',xlSeek)
//		reclock('pac',.T.)
		pac->pac_tabela := '01'
		if xlSeek
			pac->pac_chave  := subs(xaUsers[xi],4,3)
		endif
		pac->pac_txt01	:=	xaUsers[xi]
		msunlock()
	
	next xi


Return

