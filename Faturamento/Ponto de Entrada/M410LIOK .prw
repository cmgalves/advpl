#include 'protheus.ch'

user function M410LIOK()
	local codPro	:=	aCols[n,GDFieldPos("C6_PRODUTO")]
	local qtdOrig	:=	0
	local numPedido	:=	M->C5_NUM
	local zztpope	:=	M->C5_ZZTPOPE
	local UsrPerm 	:=	superGetMV('MB_USRCORT', .T., '000011 | 000012 | 000013 | 000046 | 000098 |000110 | 000182')


// dbSelectArea('PA6')
	// if __cUserId $ UsrPerm
	// 	return .T.
	// endif

	// if !(zztpope $ '01 04 09 12')
	// 	return .T.
	// endif

	dbSelectArea('DA1')
	DA1->(DbSetOrder(1))
	DA1->(dbSeek(xFilial("DA1") + aCols[n,GDFieldPos("C6_ZTABELA")] + aCols[n,GDFieldPos("C6_PRODUTO")]))

	qtdOrig := TCSPEXEC("sp_cortePedidoPontoEntrada",  numPedido, codPro, 0)[1]


	if altera
		if GDDeleted(n)
			Help(NIL, NIL, "CORTE INDEVIDO", NIL, "Nao EH permitido apagar o item do pedido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Faca o corte acessando o portal da MB"})
			return .F.
		elseif aCols[n,GDFieldPos("C6_QTDVEN")] < qtdOrig
			Help(NIL, NIL, "CORTE INDEVIDO", NIL, "Nao EH permitido diminuir a quantidade do item do pedido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Faca o corte acessando o portal da MB"})
			return .F.
		elseif aCols[n,GDFieldPos("C6_QTDVEN")] <> qtdOrig .AND. aCols[n,GDFieldPos("C6_XQTDCRT")] > 0
			Help(NIL, NIL, "ALTERACAO INDEVIDA", NIL, "Nao pode alterar a Quantidade depois de ter corte no item", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Faca o corte acessando o portal da MB"})
			return .F.
		endif
	endif

return .T.



//calcula o desconto do pedido.
// user  function calcDesco()
// 	local vlrDescon := 0

// 	dbSelectArea('DA1')
// 	DA1->(DbSetOrder(1))
// 	DA1->(dbSeek(xFilial("DA1") + aCols[n,GDFieldPos("C6_ZTABELA")] + aCols[n,GDFieldPos("C6_PRODUTO")]))

// 	retFrete := val(TCSPEXEC("sp_pedidoItensRegras",  DA1->DA1_CODPRO, DA1->DA1_CODTAB, 0, M->C5_CLIENTE, M->C5_LOJACLI, M->C5_FRETEMB, M->C5_VEND1, 'TABELAS')[1])

// 	if DA0->DA0_XFRTIN == 'N'
// 		precoVen := round(DA1->DA1_PRCVEN / ((100 - retFrete) / 100), 2)
// 	else
// 		precoVen := roun(DA1->DA1_PRCVEN, 2)
// 	endif


// 	vlrDescon := aCols[n,GDFieldPos("C6_ZPRCUNI")]
// 	vlrDescon := precoVen - vlrDescon

// 	aCols[n,GDFieldPos("C6_XPERDES")] := ROUND((vlrDescon / precoVen) * 100, 2)


// Return return_var