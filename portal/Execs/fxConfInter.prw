#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

User Function fxConfInter()
	local xi		:=	''
	local xcChamado	:=	httpPost->cChamaDet
	local xcInter	:=	strZero(val(httpPost->cNumInter)-1,2,0)
	local xcDetail	:=	httpPost->cDetail
	local xcStatus	:=	httpPost->cOpt
	local xcTpResp	:=	httpPost->cTpResp
	local xcUsr		:=	HttpSession->cUsr
	local xcChave	:=	xfilial('pa1') + xcChamado + xcInter
	local xaData	:=	{}
	
	dbselectarea('pa1')
	pa1->(dbsetorder(1)) //PA1_FILIAL, PA1_CODIGO, PA1_INTERA, R_E_C_N_O_, D_E_L_E_T_
	pa1->(dbseek( xcChave ))
	
	aadd(xaData, ;
		{PA1->PA1_FILIAL, PA1->PA1_CODIGO, PA1->PA1_INTERA, PA1->PA1_CUSTO, ;
		PA1->PA1_TECNIC, PA1->PA1_AREA, PA1->PA1_RESUMO, PA1->PA1_DETALH, ;
		PA1->PA1_DATA, PA1->PA1_HORA, PA1->PA1_STATUS, PA1->PA1_SOLICI, ;
		PA1->PA1_IMPACT, PA1->PA1_LOGMAI, PA1->PA1_RESPON})

	reclock('pa1', .t.)
	PA1_CODIGO	:=	xcChamado
	PA1_INTERA	:=	soma1(xcInter,2)
	PA1_CUSTO	:=	xaData[01][04]
	PA1_TECNIC	:=	xaData[01][05]
	PA1_AREA	:=	xaData[01][06]
	PA1_RESUMO	:=	xaData[01][07]
	PA1_DETALH	:=	xcDetail
	PA1_DATA	:=	xaData[01][09]
	PA1_HORA	:=	xaData[01][10]
	PA1_STATUS	:=	xcStatus
	PA1_SOLICI	:=	xaData[01][12]
	PA1_IMPACT	:=	xaData[01][13]
	PA1_LOGMAI	:=	xaData[01][14]
	PA1_RESPON	:=	xcUsr
	pa1->(msunlock())

Return

