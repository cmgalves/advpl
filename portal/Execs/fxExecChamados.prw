#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

User Function fxIncChamado()
	local xi		:=	''
	local xcChamado	:=	''
	local xcInter	:=	'00'
	local xcDetail	:=	httpPost->cDetail
	local xcResumo	:=	httpPost->cResumos
	local xcArea	:=	httpPost->cOptArea
	local xcImpacto	:=	httpPost->cOptImp
	local xcTec		:=	httpPost->cTec
	local xcStatus	:=	'001'
	local xcUsr		:=	HttpSession->cUsr
	
	
	reclock('pa1', .t.)
	PA1_CODIGO	:=	xsfChamado()
	PA1_INTERA	:=	'00'
	PA1_DETALH	:=	xcDetail
	PA1_RESUMO	:=	xcResumo
	PA1_DATA	:=	dDataBase
	PA1_HORA	:=	time()
	PA1_STATUS	:=	'001'
	PA1_SOLICI	:=	xcUsr
	PA1_LOGMAI	:=	'A'
	PA1_RESPON	:=	xcUsr
	PA1_AREA	:=	xcArea
	PA1_TECNIC	:=	xcTec
	PA1_IMPACT	:=	xcImpacto
	pa1->(msunlock())

Return



static function xsfChamado()
	local xaResult := {}

	xaResult := TCSPEXEC("sp_Ret_NUm_Chamado", '  ')
return xaResult[1]