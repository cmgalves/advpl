#include 'protheus.ch'


user function M410STTS()
	local xaRet		:=	{}
	private xaAlias 	:= { {Alias()},{"PAC"},{"SA3"}}

	if cEmpAnt != '01'
		return
	endif

	U_ufAmbiente(xaAlias, "S")

	xaRet := TCSPEXEC("sp_Fat_Cabec_Pedidos", SC5->C5_NUM, 'OK')	

	xfBlqDesc()


	U_ufAmbiente(xaAlias, "R")

return



static function xfBlqDesc()
	local xnMaxDesc	:=	0
	local xcObs		:=	''
	local xcSts		:=	''

	dbSelectArea('PAC')
	PAC->(DbSetOrder(1)) //PAC_FILIAL, PAC_TABELA, PAC_CHAVE, R_E_C_N_O_, D_E_L_E_T_

	dbSelectArea('SA3')
	SA3->(DbSetOrder(1)) //PAC_FILIAL, PAC_TABELA, PAC_CHAVE, R_E_C_N_O_, D_E_L_E_T_

	PAC->(dbSeek(xFilial('PAC') + '16' + RIGHT(alltrim(SC5->C5_XCIDADE),2)))

	do while !PAC->(EOF()) .AND. RIGHT(alltrim(SC5->C5_XCIDADE),2) == alltrim(PAC->PAC_CHAVE)
		if SC5->C5_FRETEMB $ alltrim(PAC->PAC_TXT02)
			xnMaxDesc	:=	val(AllTrim(PAC->PAC_TXT03))
			exit
		endif
		PAC->(dbskip())
	enddo

	Reclock("SC5",.F.)

	if ALLTRIM(SC5->C5_VEND1) == '133'
		SC5->C5_ZZCDBLQ	:=	'04'
		SC5->C5_BLQ := '4'
		xcObs	:=	'Bloq Pedidos Gabi'
		xcSts	:=	'8'
	elseif ALLTRIM(SC5->C5_VEND1) == '315' .AND. C5_XRESULT < 12
		SC5->C5_ZZCDBLQ	:=	'04'
		SC5->C5_BLQ := '4'
		xcObs	:=	'Bloq Pedidos Gervasi'
		xcSts	:=	'8'
	elseif ALLTRIM(SC5->C5_TIPO) == 'B'
		SC5->C5_ZZCDBLQ	:=	'00'
		SC5->C5_BLQ := ' '
		SC5->C5_LIBEROK := 'S'
	else
		if SC5->C5_ZZTPOPE == '04'
			SC5->C5_ZZCDBLQ	:=	'03'
			SC5->C5_BLQ := '3'
			xcObs	:=	'Bloq Bonificacao'
			xcSts	:=	'B'
		else
			SA3->(dbSeek(xFilial('SA3') + SC5->C5_VEND1))

			if SC5->C5_XPERDES  >= xnMaxDesc .OR. SA3->A3_XDESCON < SC5->C5_XPERDES
				SC5->C5_ZZCDBLQ	:=	'04'
				SC5->C5_BLQ := '4'
				xcObs	:=	'Desconto Maior que Permitido'
				xcSts	:=	'8'
			else
				SC5->C5_ZZCDBLQ	:=	'00'
				SC5->C5_BLQ := ''
				xcObs	:=	'Abertura, Automatico Protheus'
				xcSts	:=	'0'
			endif
		endif
	endif
	SC5->C5_XCARGA := ''
	SC5->(MsUnlock())

	if xcSts $ '8|B|'
		xaRet := TCSPEXEC("sp_Inclui_Status_Pedido", SC5->C5_NUM, xcSts, 'Z', 'prtheu', xcObs, 'OK')
	elseif xcSts == '0'
		xaRet := TCSPEXEC("sp_Inclui_Status_Pedido", SC5->C5_NUM, xcSts, 'Z', 'prtheu', xcObs, 'OK')
	endif
	TCRefresh( 'PA3' )

return
