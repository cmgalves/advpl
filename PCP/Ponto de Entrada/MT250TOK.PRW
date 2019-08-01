#include "Protheus.ch"
#include "rwmake.ch"
#Include "Topconn.ch"

User Function MT250TOK()
	Local xcQuery	:=	""
	Local xcR		:=	Char(13) + Char(10)
	Local xlConf	:=	.T.

	if M->D3_TM == '013'
		Return xlConf
	Elseif !(__cUserID $ GetMV("MB_APT1013")) .AND. M->D3_TM == '013'
		MsgBox('USUÁRIO SEM ACESSO PARA ANTECIPAÇÕES', 'AVISO MB')
		Return !xlConf
	endif

	xcQuery	:= 			"SELECT  SUM(SLD) SAL FROM ( "
	xcQuery += xcR + 	"SELECT  "
	xcQuery += xcR + 	"	D3_TM MOV, D3_OP NOP, "
	xcQuery += xcR + 	"	D3_COD REF, D3_QUANT QTD, D3_ZANTECI ANT,  "
	xcQuery += xcR + 	"	D3_QUANT - D3_ZANTECI SLD "
	xcQuery += xcR + 	"FROM  "
	xcQuery += xcR + 	"	" + RetSqlName('SD3') + " "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	D3_FILIAL = '" + xFilial('SD3') + "' AND "
	xcQuery += xcR + 	"	D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	D3_TM IN ('013') AND "
	xcQuery += xcR + 	"	D3_ESTORNO <> 'S' AND "
	xcQuery += xcR + 	"	D3_EMISSAO >= '20141201'AND "
	xcQuery += xcR + 	"	D3_QUANT - D3_ZANTECI > 0 AND	 "
	xcQuery += xcR + 	"	D3_USUARIO IN ('', 'Claudemir', 'Denilson', 'Clayton', 'PCP02') AND "
	xcQuery += xcR + 	"	D3_LOCAL = '" + AllTrim(M->D3_LOCAL) + "' AND "
	xcQuery += xcR + 	"	D3_OP = '" + AllTrim(M->D3_OP) + "' )XA "

	//Gera um arquivo com a query acima.
	MemoWrite("Confirma Antecipação.SQL",xcQuery)

	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif

	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

	dbSelectArea('XTRB')
	XTRB->(dbGoTop())

	if XTRB->SAL > 0
		Alert('EXISTE ANTECIPAÇÃO PARA ESTA OP' + xcR + 'QUANTIDADE: ' + Transform(XTRB->SAL,'@E 99,999.99'), 'AVISO MB')
		xlConf	:=	.F.
	endif

Return xlConf


User Function xufAntecip()
	Local xcQuery	:=	""

	Private xcR		:=	Char(13) + Char(10)
	Private oDlg2
	Private xlConf	:=	.T.
	Private xnQtde	:=	0
	Private xnConv	:=	0
	Private xnTotAtc	:=	0
	Private xnTotAtv	:=	0

	if M->D3_TM == '013'
		Return xlConf
	endif

	xcQuery += xcR + 	"SELECT  "
	xcQuery += xcR + 	"	D3_TM MOV, D3_OP NOP, D3_LOCAL LCL, "
	xcQuery += xcR + 	"	D3_COD REF, D3_QUANT QTD, D3_QUANT / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV end QTV, "
	xcQuery += xcR + 	"	D3_ZANTECI ANT, D3_ZANTECI / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV end  ANV,  "
	xcQuery += xcR + 	"	D3_QUANT - D3_ZANTECI SLD, (D3_QUANT - D3_ZANTECI) / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV end SLV, B1_CONV CNV "
	xcQuery += xcR + 	"FROM  "
	xcQuery += xcR + 	"	" + RetSqlName('SD3') + " A INNER JOIN "
	xcQuery += xcR + 	"	" + RetSqlName('SB1') + " B ON "
	xcQuery += xcR + 	"	D3_COD = B1_COD "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	D3_FILIAL = '" + xFilial('SD3') + "' AND "
	xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	B1_FILIAL = '" + xFilial('SD3') + "' AND "
	xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
	xcQuery += xcR + 	"	D3_TM IN ('013') AND "
	xcQuery += xcR + 	"	D3_ESTORNO <> 'S' AND "
	xcQuery += xcR + 	"	D3_EMISSAO >= '20141201'AND "
	xcQuery += xcR + 	"	D3_QUANT - D3_ZANTECI > 0 AND	 "
	xcQuery += xcR + 	"	D3_USUARIO IN ('', 'Claudemir', 'Denilson', 'Clayton', 'PCP02') AND "
	if __cUserID $ GetMV('MB_ANTECIP')
		xcQuery += xcR + 	"	D3_TIPO IN ('PI', 'PA') AND "
	Else
		xcQuery += xcR + 	"	D3_TIPO = 'PA' AND "
	endif
	xcQuery += xcR + 	"	D3_OP = '" + AllTrim(M->D3_OP) + "' "

	//Gera um arquivo com a query acima.
	MemoWrite("Aponta Antecipação.SQL",xcQuery)

	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif

	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

	dbSelectArea('XTRB')
	XTRB->(dbGoTop())

	xnConv := Iif(XTRB->CNV == 0, 1, XTRB->CNV)

	While !XTRB->(EOF())
		xnTotAtc	+=	XTRB->SLD
		xnTotAtv	+=	XTRB->SLV
		XTRB->(dbSkip())
	endDo

	if xnTotAtv <= 0
		Return .T.
	endif

	@ 200, 010 To 295,580 Dialog oDlg2 Title OemToAnsi ("APONTAMENTO OP")
	@ 010, 010 Say OemToAnsi ('SALDO ANTECIPADO - VOLUMES: ' + Transform(xnTotAtv,'@E 99,999.99'))
	@ 020, 010 Say OemToAnsi ("QTDE VOLUME?")
	@ 020, 055 Get xnQtde PICTURE "@E 99,999.99" Valid xsfVal() SIZE 040, 040
	@ 010, 235 BMPBUTTON TYPE 01 ACTION xsfAponta(xnQtde * xnConv)
	@ 024, 235 BMPBUTTON TYPE 02 ACTION xsfCancel()

	Activate Dialog oDlg2

Return xlConf

Static Function xsfVal()
	xlVal	:=	.T.
	if xnQtde > xnTotAtv
		Alert('VALOR INFORMADO MAIOR QUE O SALDO ANTECIPADO'+xcR+'CORRIJA O VALOR' , 'AVISO MB')
		xlVal := .F.
	endif
Return xlVal

Static Function xsfAponta(xQdt)
	Local xnQuant	:=	xQdt

	dbSelectArea('XTRB')
	XTRB->(dbGoTop())


	dbSelectArea('SD3')
	SD3->(dbSetOrder(1))
	SD3->(dbGoTop())
	SD3->(dbSeek(xFilial('SD3') + XTRB->(NOP + REF + LCL)))

	While !SD3->(EOF())
		if SD3->D3_COD != XTRB->REF
			SD3->(dbSkip())
			Loop
		endif
		if SD3->D3_TM != "013"
			SD3->(dbSkip())
			Loop
		endif
		if SD3->D3_ESTORNO == "S"
			SD3->(dbSkip())
			Loop
		endif
		RecLock('SD3',.F.)
		if SD3->(D3_QUANT - D3_ZANTECI) < xnQuant
			SD3->D3_ZANTECI	:= SD3->D3_QUANT
			xnQuant	:=	xnQuant - SD3->(D3_QUANT - D3_ZANTECI)
		Else
			SD3->D3_ZANTECI	:= SD3->D3_ZANTECI + xnQuant
			Exit
		endif
		SD3->(MsUnLock())
		SD3->(dbSkip())
	endDo


	M->D3_QTSEGUM := 0

	xlConf	:=	.T.
	Close (oDlg2)

Return .T.

Static Function xsfCancel()

	xlConf	:=	.F.
	Close (oDlg2)
	//__Quit()
Return .T.

User Function xufAntPro()

	if __cUserID $ GetMV("MB_APT1013")
		if M->D3_TM == "013"
			if MsgBox('CONFIRMA SE O LANÇAMENTO É ANTECIPAÇÃO!!!', 'AVISO MB', 'YESNO')
				Return .T.
			Else
				M->D3_TM := '   '
			endif
			//		Alert('CONFIRMA SE O LANÇAMENTO É ANTECIPAÇÃO!!!', 'AVISO MB')
		Elseif M->D3_TM == "010"
			if MsgBox('CONFIRMA SE O LANÇAMENTO É PRODUÇÃO!!!', 'AVISO MB', 'YESNO')
				Return .T.
			Else
				M->D3_TM := '   '
			endif
			//		Alert('CONFIRMA SE O LANÇAMENTO É PRODUÇÃO!!!', 'AVISO MB')
		endif
	Elseif !(__cUserID $ GetMV("MB_APT1013")) .AND. M->D3_TM == "013"
		MsgBox('USUÁRIO SEM ACESSO PARA ANTECIPAÇÕES', 'AVISO MB')
		Return .F.
	endif


Return .T.






user function xfApontaPA(tip)
	local xnQtde		:=	0
	local xnRet			:=	0
	local xcTip			:=	tip
	local xcTipoProd	:=	''
	local xnFator		:=	0
	local xnMDFator		:=	''
	local xcTm			:=	''
	local xnQtdeRet		:=	0

	xnQtdeRet := M->D3_QUANT
	
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	SB1->(dbSeek(xFilial('SB1') + M->D3_COD))
	
	xnFator 	:=	SB1->B1_CONV
	xnMDFator	:=	SB1->B1_TIPCONV
	xcTipoProd	:=	SB1->B1_TIPO
	xcTm		:=	M->D3_TM
	if xcTip == 'p'
		xnRet := M->D3_QUANT
	elseif xcTip == 's'
		if xnMDFator == 'D'
			xnRet := M->D3_QUANT / iif(xnFator == 0, 1, xnFator)
		else
			xnRet := M->D3_QUANT * iif(xnFator == 0, 1, xnFator)
		endif
	endif
	


	if FUNNAME() == 'MATA250' .AND. xcTipoProd == 'PA'
		if __cUserID $ GetMV("MB_APT1013")
			dbSelectArea('SC2')
			SC2->(dbSetOrder(1))
			SC2->(dbGoTop())
			SC2->(dbSeek(xFilial('SC2') + M->D3_OP))
			if xcTip = 's'
				if xnMDFator == 'D'
					xnQtde := (SC2->C2_QUANT - SC2->C2_QUJE) / iif(xnFator == 0, 1, xnFator)
				else
					xnQtde := (SC2->C2_QUANT - SC2->C2_QUJE) * iif(xnFator == 0, 1, xnFator)
				endif
				if xnQtde > 0 
					if xnQtde < M->D3_QTSEGUM
						alert('Qtde apontada maior que saldo de OP')
						xnQtdeRet	:=	0
					else
						if xcTm == '013' .AND. xnQtde == M->D3_QTSEGUM
							alert('Antecipação, não pode encerrar a OP')
							xnQtdeRet	:=	0
						endif
					endif
				endif
			else
				xnQtde := SC2->C2_QUANT - SC2->C2_QUJE
				if xnQtde > 0 
					if xnQtde < M->D3_QUANT
						alert('Qtde apontada maior que saldo de OP')
						xnQtdeRet	:=	0
					else
						if xcTm == '013' .AND. xnQtde == M->D3_QUANT
							alert('Antecipação, não pode encerrar a OP')
							xnQtdeRet	:=	0
						endif
					endif
				endif
			endif
		endif
	endif

Return xnQtdeRet

