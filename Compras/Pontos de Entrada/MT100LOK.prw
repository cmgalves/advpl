User Function MT100LOK()
Local xlExecuta 	:= 	.T.
Local xcTesEnt	:=	''
Local xcTesSai	:=	''
Local xnpDoc	:=	GDFieldPos("D1_DOC")
Local xnpNfori	:=	GDFieldPos("D1_NFORI")
Local xnpSerOri :=	GDFieldPos("D1_SERIORI")
Local xnpIteOri :=	GDFieldPos("D1_ITEMORI")
Local xnpRefer	:=	GDFieldPos("D1_COD")
Local xnpTes	:=	GDFieldPos("D1_TES")
Local xnpTipo	:=	GDFieldPos("D1_TIPO")
Local xcForne	:=	CA100FOR
Local xcLoja	:=	CLOJA

Private xcR			:=	Char(13) + Char(10)
Private aAlias 		:= 	{ {Alias()},{"SD2"},{"SF4"}}

If !GetMV('MB_MT100OK')
	Return (xlExecuta)
EndIf

If Empty(aCols[n,xnpNfori]) .OR. aCols[n,xnpNfori] == '000000000' .OR. Empty(AllTrim(aCols[n,xnpIteOri]))
	Return (xlExecuta)
EndIf

//U_ufAmbiente(aAlias, "S")

dbSelectArea('SD2')
dbSetOrder(3) //D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_
SD2->(dbSeek(xFilial('SD2')+aCols[n,xnpNfori]+aCols[n,xnpSerOri]+xcForne+xcLoja+aCols[n,xnpRefer]))

dbSelectArea('SF4')
dbSetOrder(1)
SF4->(dbSeek(xFilial('SF4') + SD2->D2_TES))

xcTesEnt	:=	SF4->F4_TESDV
xcTesSai	:=	aCols[n,xnpTes]

Do Case
	Case Empty(AllTrim(xcTesEnt))
		Alert('TES DE DEVOLUÇÃO EM BRANCO' + xcR + 'CORRIJA O TES: ' + SD2->D2_TES,'AVISO MB')
		xlExecuta	:=	.F.
	Case AllTrim(xcTesEnt) != AllTrim(xcTesSai)
		Alert('TES DE DEVOLUÇÃO INCORRETA' + xcR + 'O CORRETO É: ' + xcTesEnt  + xcR + 'OU CORRIJA O TES: ' + SD2->D2_TES,'AVISO MB')
		xlExecuta	:=	.F.
	OtherWise
		xlExecuta	:=	.T.
EndCase



//U_ufAmbiente(aAlias, "R")

Return (xlExecuta)
