#include "protheus.ch"


/*
Rotina para calcula as rotinas do pedido corretamente
pedido 110986
Parï¿½metros:
T = Tipo de Operaï¿½ï¿½o na C5
P = Produto na C6
Q = Quantidade na C6
V = Valor Unitï¿½rio C6
TAB = Alteraï¿½ï¿½o de tabela na linha
CADTAB = Cadastro de tabelas
OPER = Quando atualiza a operaï¿½ï¿½o na linha


*/

user function xfItemPed(_cPar, _cCont)
	Local 	aArea		:= 	 GetArea()
	private xcPar		:=	_cPar
	private xcConteudo	:=	_cCont
	private codVend		:=	''
	private codSuper	:=	''
	private codGeren	:=	''
	private codCliente	:=	''
	private lojaCliente	:=	''
	private xcTabela	:=	''
	private xcProduto	:=	''
	private xcFreteMB	:=	''
	private xcFrtTab	:=	''
	private xcCalcFrt	:=	''
	private xcSitll		:=	''
	private estadoUf	:=	''
	private aliqFrete	:=	0
	private aliqIcms	:=	0
	private aliqPis		:=	0
	private aliqCof		:=	0
	private xcTpFrete	:=	''
	private xnComis1	:=	0
	private xnComis2	:=	0
	private xnComis3	:=	0
	private xcTipoOper	:=	''
	private tabFora		:=	AllTrim(GetMv("MB_TABFORA"))
	private pricVari

	// private xaAlias 	:= { {Alias()},{"DA0"},{"DA1"},{"PAC"},{"SA1"},{"SA2"},{"SA3"},{"SB1"},,{"SB2"},{"SB5"},{"SX5"},{"SZ1"},{"SZ3"}}

	//U_ufAmbiente(xaAlias, "S")

//dbSelectArea('PA5')
	If FunName() == "MATA410" .And. (!ALTERA .And. !INCLUI)
		MsgInfo('Funcionalidade nao disponivel na visualizacao')
		Return(.F.)
	EndIf

	if M->C5_ZZTPOPE == 'T3'
		return
	endif

	if xcPar == 'T'
		xfTipo()
		return xcConteudo
	endif

	if xcPar == 'C'
		if !empty(alltrim(M->C5_CONDPAG))
			xfPrzMed()
		endif
		xfAtuCabec()
		xfCred()
		return xcConteudo
	endif

	if xcPar == 'CADTAB'
				xfCadTab()
		return xcConteudo
	endif

	if xcPar == 'TAB'
		xfTabela()
		return xcConteudo
	endif

	if xcPar $ 'COND|T|C|'
		if !Empty(AllTrim(M->C5_CONDPAG))
			xfPrzMed()
			return xcConteudo
		endif
	endif

	xfPedido()

	//U_ufAmbiente(xaAlias, "R")
	RestArea(aArea)
return xcTabela

static function xfCadTab()
	local xi := 0
	for xi := 1 to len(aCols)
		if aCols[xi,GDFieldPos("DA1_CODPRO")] == aCols[n,GDFieldPos("DA1_CODPRO")] .AND.;
				(n != xi)
			xcConteudo := ''
			alert('Produto Ja cadastrado!!!')
		else
			xcConteudo := aCols[n,GDFieldPos("DA1_CODPRO")]
		endif
	next xi
return

//Validaï¿½ï¿½o na digitaï¿½ï¿½o de Tabelas
static function xfTabela()
	local xlMuda	:=	.T.
	local xi 		:=	0
	local dataHoje	:=	dtos(date())

	DA0->(dbSeek(xFilial('DA0') + aCols[n,GDFieldPos("C6_ZTABELA")]))

	if dataHoje < DTOS(DA0->DA0_DATDE) .OR. dataHoje > DTOS(DA0->DA0_DATATE) .OR. DA0->DA0_ATIVO != '1'
		alert('Tabela: ' + alltrim(DA0->DA0_CODTAB) + ' nao esta disponivel!!!')
		xcConteudo := ''
		GetDRefresh()
		return
	endif

	aCols[n,GDFieldPos("C6_XFRTTAB")]  := xcFrtTab

	for xi := 1 to len(aCols)

		if xlMuda

			DA0->(dbSeek(xFilial('DA0') + aCols[xi,GDFieldPos("C6_ZTABELA")]))

			if (DA0->DA0_FRTINT != '5' .AND. DA0->DA0_FRTINT != M->C5_FRETEMB)
				xlMuda := .F.
				xcConteudo := ''
				alert('Conflito entre Tabelas e o Tipo de Frete!!!')
			else
				xcConteudo := aCols[n,GDFieldPos("C6_ZTABELA")]
			endif
		endif
	next xi

	GetDRefresh()

return

//Alteraï¿½ï¿½o importantes no cabec
static function xfTipo()
	local xi := 0

	for xi := 1 to len(aCols)
		aCols[xi,GDFieldPos("C6_QTDVEN")] := 0
	next xi

	GetDRefresh()

return



//verifica se hï¿½ dï¿½bitos
static function xfCred()

	SA1->(dbSeek(xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJACLI))

	pricVari := __cUserId


	if SA1->A1_ATR > 0 .AND. SA1->A1_RISCO != 'A' .AND. !(__cUserId $ '000098 | 000110')//Verifica o Crï¿½dito
		alert('Cliente possui debitos')
		M->C5_CLIENTE	:=	''
		M->C5_LOJACLI	:=	''
	endif

	if __cUserId $ '000098 - 000110' .AND. EMPTY(M->C5_CLIENTE)
		M->C5_TABELA	:=	'001'
		M->C5_CONDPAG	:=	'001'
		M->C5_FRETEMB	:=	'1'
		M->C5_TPFRETE	:=	'C'
	endif
return

//verifica se hï¿½ dï¿½bitos
static function valorVerba()
	local retProced	:=	{}

	retProced := TCSPEXEC("comercialVerbaClientes",  codCliente + lojaCliente, 'OK')

	if retProced[1] == 0
		aCols[n,GDFieldPos("C6_XVERBA")] := 0
	else
		aCols[n,GDFieldPos("C6_XVERBA")] := round(aCols[n,GDFieldPos("C6_VALOR")] * (retProced[1] / 100),2)
	endif


return

//Atualiza os campos do cabeï¿½alho
static function xfAtuCabec()

	M->C5_XCOMCLI	:=	''
	M->C5_ZZNOMFC	:=	''
	M->C5_CONDPAG	:=	''
	M->C5_XCOMRPD	:=	0
	M->C5_XCOMRPA	:=	0

	SA1->(dbSeek(xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJACLI))
	SA3->(dbSeek(xFilial('SA3') + M->C5_VEND1))
	DA0->(dbSeek(xFilial('DA0') + M->C5_TABELA))

	//Tipos de frete
	do case
	case DA0->DA0_FRTINT == '1'
		xcFrtTab	:=	'Cif-RED'
	case DA0->DA0_FRTINT == '2'
		xcFrtTab	:=	'Cif-CLIENTE'
	case DA0->DA0_FRTINT == '3'
		xcFrtTab	:=	'FOB-RED'
	case DA0->DA0_FRTINT == '4'
		xcFrtTab	:=	'FOB-RETIRA'
	case DA0->DA0_FRTINT == '5'
		xcFrtTab	:=	'TODOS'
	end case

	pricVari := M->C5_DESC1

	if PAC->(dbSeek(xFilial('PAC') + '38' + ALLTRIM(SA3->A3_COD)))
		M->C5_DESC1		:=	PAC->PAC_VLR01
	else
		M->C5_DESC1		:=	SA1->A1_DESC
	endif

	M->C5_XCOMCLI	:=	SA1->A1_COMIS
	M->C5_ZZNOMFC	:=	xfNome()
	M->C5_CONDPAG	:=	SA1->A1_COND
	M->C5_XCIDADE	:=	ALLTRIM(SA1->A1_MUN) + ' - ' + SA1->A1_EST
	M->C5_XEST		:=	SA1->A1_EST
	M->C5_XCOMRPD	:=	SA3->A3_ZZPMIN
	M->C5_XCOMRPA	:=	SA3->A3_ZZPMAX
	M->C5_ZZDTENT	:=	dDataBase

	if __cUserId $ '000098 - 000110' .AND. EMPTY(M->C5_CLIENTE)
		M->C5_TABELA	:=	'001'
		M->C5_CONDPAG	:=	'001'
		M->C5_FRETEMB	:=	'1'
		M->C5_TPFRETE	:=	'C'
	endif

	aCols[1,GDFieldPos("C6_ZTABELA")] := M->C5_TABELA
	aCols[1,GDFieldPos("C6_ZZTPOPE")] := M->C5_ZZTPOPE
	aCols[1,GDFieldPos("C6_XCOMTAB")] := DA0->DA0_ZCOMIS
	aCols[1,GDFieldPos("C6_XFRTTAB")] := xcFrtTab

return

static function xfPrzMed()
	local xaParc	:=	{}
	local xnDias	:=	0
	local xnPraz	:=	0
	local xnPrzMed	:=	0
	local xnJuros	:=	0
	local xi		:=	1

	//01654501
	if 'CARTAO' $ UPPER(SE4->E4_DESCRI)
		RETURN
	endif

	xaParc := Condicao(1000, M->C5_CONDPAG, 0, dDataBase)

	for xi := 1 to len(xaParc)
		xnDias += xaParc[xi][2]
		xnPraz += (DateDiffDay(xaParc[xi][1], dDataBase)*xaParc[xi][2])
	next xi

	if xnDias > 0
		xnPrzMed := int(xnPraz/xnDias)

		if xnPrzMed >= 60
			xnJuros := 1.5
		endif
		if xnPrzMed >= 90
			xnJuros := 3
		endif
		pricVari := M->C5_XPRZMED

		M->C5_XPRZMED := xnPrzMed
		if DTOS(SA1->A1_DTCAD) > '20181231';
				.AND. SA1->A1_XCOBJUR != 'N';
				.AND. empty(alltrim(SA1->A1_GRPVEN))
			M->C5_XPERJUR := xnJuros
		else
			M->C5_XPERJUR := 0
		endif
	endif
return

static function xfNome()
	local xcNome	:=	''

	if M->C5_TIPO $ '|D|B|'
		SA2->(dbSeek(xFilial('SA2') + M->C5_CLIENTE + M->C5_LOJACLI))
		xcNome	:=	SA2->A2_NOME
	else
		SA1->(dbSeek(xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJACLI))
		xcNome	:=	SA1->A1_NOME
	endif

return xcNome

//inicia o processo de pedidos
static function xfPedido()
	local xcCondPag		:=	''
	local xi			:=	0
	local estadosIcm	:=	{'AC', 0.07, 'AL', 0.07, 'AM', 0.07, 'AP', 0.07, 'BA', 0.07, 'CE', 0.07, 'DF', 0.07, 'ES', 0.07, 'EX', 0.07, 'GO', 0.07, 'MA', 0.07, 'MG', 0.12, 'MS', 0.07, 'MT', 0.07, 'PA', 0.07, 'PB', 0.07, 'PE', 0.07, 'PI', 0.07, 'PR', 0.12, 'RJ', 0.12, 'RN', 0.07, 'RO', 0.07, 'RR', 0.07, 'RS', 0.12, 'SC', 0.12, 'SE', 0.07, 'SP', 0.18, 'TO', 0.07}

	//verifincar se o cabeï¿½alho estï¿½ preenchido
	pricVari := M->C5_TPFRETE

	if __cUserId $ '000098 - 000110' .AND. EMPTY(M->C5_CLIENTE)
		M->C5_CLIENTE	:=	'000123'
		M->C5_LOJACLI	:=	'01'
		M->C5_TABELA	:=	'001'
		M->C5_CONDPAG	:=	'001'
		M->C5_FRETEMB	:=	'1'
		M->C5_TPFRETE	:=	'C'
		M->C5_VEND1		:=	'777'
		M->C5_ZZOBPED	:=	'TESTE DE PEDIDO PARA DESENVOLVIMENTO'
	endif

	if !(xcPar $ 'C|T')
		if empty(M->C5_CLIENTE) .OR. empty(M->C5_LOJACLI) .OR. empty(M->C5_FRETEMB) .OR. empty(M->C5_ZCALFRT) .OR. empty(M->C5_TABELA) .OR. empty(M->C5_TPFRETE)
			alert('Preencher o pedido acima.')
			aCols[n,GDFieldPos("C6_PRODUTO")] := SPACE(15)
			Return xcTabela
		endif
	endif

	/*
	Atribuindo valores ï¿½s Variï¿½veis
	*/
	codCliente	:=	M->C5_CLIENTE
	lojaCliente	:=	M->C5_LOJACLI
	codVend		:=	AllTrim(M->C5_VEND1)
	codSuper	:=	AllTrim(M->C5_VEND2)
	codGeren	:=	AllTrim(M->C5_VEND3)
	xcCondPag	:=	M->C5_CONDPAG
	xcTipoOper	:=	M->C5_ZZTPOPE
	xcFreteMB	:=	M->C5_FRETEMB
	xcCalcFrt	:=	M->C5_ZCALFRT
	xcTabela	:=	aCols[n,GDFieldPos("C6_ZTABELA")]
	xcProduto	:=	aCols[n,GDFieldPos("C6_PRODUTO")]
	xcTpFrete	:=	iif(xcFreteMB $ '1|2','C','F')

	xfPosic() //posicionando as tabelas

	xcSitll 		:=	SA1->A1_ZZSITLL
	xnComis1		:=	SA1->A1_COMIS
	estadoUf		:=	SA1->A1_EST


	//Aliquotas
	for xi := 1 to len(estadosIcm)
		if estadoUf == estadosIcm[xi]
			aliqIcms := estadosIcm[xi + 1]
			aliqPis := 0.0165
			aliqCof := 0.076
		endif
		xi++
	next

	if xcPar == 'Q' .AND. M->C5_ZZMGDES == '1'
		xfValid() //Verifica as validaï¿½ï¿½es do pedido
	endif
	//xfComis() //pega o percentual da comissï¿½o apenas na alteraï¿½ï¿½o do produdo

	if xcPar == 'P' .or. xcPar == 'OPER'
		xfForaLin()
		xfForaTab()
		xfPontaEst()
	endif

	if xcPar $ 'P|Q|V'
		// xfComis()

		xfPreco() //calcula os preï¿½os iniciais

		xfCustos() // Calcula os custos do pedido

		//xfImpostos() // cï¿½lculo dos impostos

		xfResult() // cï¿½lculo dos resultados

		GetDRefresh()

		xfAtuVal()	//Atualizaï¿½ï¿½o dos valores no cabec

	endif

	If xcPar == "REFAZ"
		ProcRegua(0)
		For x = 1 To Len(aCols)
			IncProc('Atualizando item '+ Str(x))
			xfPreco() //calcula os preï¿½os iniciais
			xfCustos() // Calcula os custos do pedido
			xfResult() // cï¿½lculo dos resultados
			GetDRefresh()
		Next x
			XfAtuVal()
	EndIf

Return


//checa os produtos fora de linha
static function xfForaLin()

	if SB1->B1_ZFORLIN == '1' .and. !(rtrim(xcTabela) $ tabFora)
		alert('Produto fora de linha')
		aCols[n,GDFieldPos("C6_PRODUTO")] := SPACE(15)
	endif

return

static function xfForaTab()
	if aCols[n,GDFieldPos("C6_ZTABELA")] != '999'
		if !(DA1->(dbSeek(xFilial("DA1") + aCols[n,GDFieldPos("C6_ZTABELA")] + aCols[n,GDFieldPos("C6_PRODUTO")])))
			alert('Produto fora da Tabela')
			aCols[n,GDFieldPos("C6_PRODUTO")] := SPACE(15)
		endif
	endif
return

//checa os produtos ponta de estoque
static function xfPontaEst()

	if SB1->B1_ZFORLIN == '4' .and. !(rtrim(xcTabela) $ tabFora)
		if SB2->(B2_QATU-B2_RESERVA) < aCols[n,GDFieldPos("C6_QTDVEN")]

			alert('Produto Ponta de Estoque sem Saldo')
			aCols[n,GDFieldPos("C6_PRODUTO")] := SPACE(15)
		endif
	endif

return






//Validaï¿½ï¿½o dos itens do pedido
static function xfValid()

	DA0->(dbSeek(xFilial("DA0") + aCols[n,GDFieldPos("C6_ZTABELA")]))
	if DA0->DA0_ZZMARG == '4'
		DA1->(dbSeek(xFilial("DA1") + aCols[n,GDFieldPos("C6_ZTABELA")] + aCols[n,GDFieldPos("C6_PRODUTO")]))
		if !(int(aCols[n,GDFieldPos("C6_QTDVEN")] / DA1->DA1_ZQTLOT)) == (aCols[n,GDFieldPos("C6_QTDVEN")] / DA1->DA1_ZQTLOT)
			alert('Quantidade deve ser multiplo de: ' + alltrim(str(DA1->DA1_ZQTLOT)))
			aCols[n,GDFieldPos("C6_QTDVEN")] := 0
		endif
	else
		if !(int(aCols[n,GDFieldPos("C6_QTDVEN")] / SB1->B1_CONV)) == (aCols[n,GDFieldPos("C6_QTDVEN")] / SB1->B1_CONV)
			alert('Quantidade deve ser multiplo de: ' + alltrim(str(SB1->B1_CONV)))
			aCols[n,GDFieldPos("C6_QTDVEN")] := 0
		endif

	endif

	GetDRefresh()

return()

//posiciona as tabelas para iniciar os trabalhos
static function xfAtuVal()
	local xi		:=	0
	local xnBaseCom	:=	0
	local xnResult	:=	0
	local xnQtdFer	:=	0

	pricVari := M->C5_COMIS1
	pricVari := M->C5_COMIS2
	pricVari := M->C5_COMIS3

	M->C5_ZTOTPED	:=	0
	M->C5_XFRETE	:=	0
	M->C5_XVLCOMI	:=	0
	M->C5_XVLCOMG	:=	0
	M->C5_XVLCOMD	:=	0
	M->C5_COMIS1	:=	0
	M->C5_COMIS2	:=	0
	M->C5_COMIS3	:=	0
	M->C5_XVLDESC	:=	0
	M->C5_XPERDES	:=	0
	M->C5_XCUSTO	:=	0
	M->C5_XICMS		:=	0
	M->C5_XPIS		:=	0
	M->C5_XCOFINS	:=	0
	M->C5_XDESPFX	:=	0
	M->C5_XIRCSLL	:=	0
	M->C5_XMGERRO	:=	0
	M->C5_XMANGA	:=	0
	M->C5_XVERBA	:=	0
	M->C5_XMARKET	:=	0
	M->C5_XRESULT	:=	0
	M->C5_PBRUTO 	:=	0
	M->C5_PESOL 	:=	0
	M->C5_ZZCUBA 	:=	0
	M->C5_VOLUME1	:=	0
	M->C5_XVLRBRU	:=	0
	M->C5_XBASCOM	:=	0
	M->C5_XCIDADE	:=	''
	M->C5_XEST		:=	''
	M->C5_XBONIFI	:=	0
	M->C5_XPERCBN	:=	0

	for xi := 1 to len(aCols)
		if !aCols[xi][Len(aCols[xi])]
			M->C5_ZTOTPED	+=	aCols[xi,GDFieldPos("C6_VALOR")]
			M->C5_XVLRBRU	+=	aCols[xi,GDFieldPos("C6_XVLRBRU")]
			M->C5_XCUSTO	+=	aCols[xi,GDFieldPos("C6_XCUSTOS")]
			M->C5_XVLDESC	+=	aCols[xi,GDFieldPos("C6_XVLDESC")]
			M->C5_XFRETE	+=	aCols[xi,GDFieldPos("C6_ZFRETE")]
			M->C5_XDESPFX	+=	aCols[xi,GDFieldPos("C6_XDESPFX")]
			M->C5_XICMS		+=	aCols[xi,GDFieldPos("C6_XVLICMS")]
			M->C5_XPIS		+=	aCols[xi,GDFieldPos("C6_XVLPIS")]
			M->C5_XCOFINS	+=	aCols[xi,GDFieldPos("C6_XVLCOFI")]
			M->C5_XIRCSLL	+=	aCols[xi,GDFieldPos("C6_XIRCSLL")]
			M->C5_XMGERRO	+=	aCols[xi,GDFieldPos("C6_XMGERRO")]
			M->C5_XMARKET	+=	aCols[xi,GDFieldPos("C6_XMARKET")]
			M->C5_XVERBA	+=	aCols[xi,GDFieldPos("C6_XVERBA")]
			M->C5_XMANGA	+=	aCols[xi,GDFieldPos("C6_XMANGA")]
			M->C5_XBASCOM	+=	aCols[xi,GDFieldPos("C6_ZBASCOM")]
			M->C5_XVLCOMI	+=	aCols[xi,GDFieldPos("C6_ZVALCOM")]
			M->C5_XVLCOMG	+=	aCols[xi,GDFieldPos("C6_XVLCOMG")]
			M->C5_XVLCOMD	+=	aCols[xi,GDFieldPos("C6_XVLCOMD")]
			xnBaseCom		+=	aCols[xi,GDFieldPos("C6_ZBASCOM")]

			SB1->(DbSeek(xFilial("SB1") + aCols[xi,GDFieldPos("C6_PRODUTO")]))

			M->C5_PBRUTO 	+=	round(aCols[xi,GDFieldPos("C6_QTDVEN")] * SB1->B1_PESBRU,2)
			M->C5_PESOL 	+=	round(aCols[xi,GDFieldPos("C6_QTDVEN")] * SB1->B1_PESO,2)
			M->C5_VOLUME1 	+=	round((aCols[xi,GDFieldPos("C6_QTDVEN")] / SB1->B1_CONV) * (iif(!Empty(SB1->B1_ZZADD),2,1)),0)

			SB5->(DbSeek(xFilial("SB5") + aCols[xi,GDFieldPos("C6_PRODUTO")]))

			M->C5_ZZCUBA 	+=	round(U_MBCALCUB(aCols[xi,GDFieldPos("C6_PRODUTO")],aCols[xi,GDFieldPos("C6_QTDVEN")],.T.),2)

			if xcTipoOper $ '01 04 09 12'
				if aCols[xi,GDFieldPos("C6_PRODUTO")] == aCols[n,GDFieldPos("C6_PRODUTO")] .AND. xi <> n

					if aCols[xi,GDFieldPos("C6_ZZTPOPE")] == aCols[n,GDFieldPos("C6_ZZTPOPE")]

						alert('Produto ja informado')
						aCols[n,GDFieldPos("C6_PRODUTO")]	:=	SPACE(15)
						aCols[n,GDFieldPos("C6_QTDVEN")]	:=	0
						aCols[n,GDFieldPos("C6_PRCVEN")]	:=	0

					endif
				endif
			endif

			DA0->(dbSeek(xFilial("DA0") + aCols[xi,GDFieldPos("C6_ZTABELA")]))

			if DA0->DA0_ZZMARG == '4'

				DA1->(dbSeek(xFilial("DA1") + aCols[xi,GDFieldPos("C6_ZTABELA")] + aCols[xi,GDFieldPos("C6_PRODUTO")]))
				if DA1->DA1_ZQTLOT != 0 .AND. xnQtdFer == 0
					xnQtdFer	:=	aCols[xi,GDFieldPos("C6_QTDVEN")]
				endif
				if aCols[n,GDFieldPos("C6_ZTABELA")] == aCols[xi,GDFieldPos("C6_ZTABELA")]
					if aCols[n,GDFieldPos("C6_QTDVEN")] != aCols[xi,GDFieldPos("C6_QTDVEN")] .AND. aCols[n,GDFieldPos("C6_QTDVEN")] > 0
						if DA1->DA1_ZQTLOT == 0
							if aCols[n,GDFieldPos("C6_QTDVEN")] < xnQtdFer * 1.5
								alert('Nao e permitido quantidades diferentes para Feirinha')
								aCols[n,GDFieldPos("C6_PRODUTO")]	:=	SPACE(15)
								aCols[n,GDFieldPos("C6_QTDVEN")]	:=	0
							endif
						else
							alert('NAo e permitido quantidades diferentes para Feirinha')
							aCols[n,GDFieldPos("C6_PRODUTO")]	:=	SPACE(15)
							aCols[n,GDFieldPos("C6_QTDVEN")]	:=	0
						endif
					endif
				endif

			endif

		endif
	next xi

	If M->C5_ZZTPOPE $ "01 | 09 | 12 "
		if M->C5_XPERCBN == 0
			M->C5_XPERCBN	:=	TCSPEXEC("comercialDescBonif", codCliente+lojaCliente, 0)[1]
		endif
		M->C5_XBONIFI	+=	ROUND((M->C5_XPERCBN * M->C5_ZTOTPED) / 100, 2)
	EndIf


	xnResult	:=	M->C5_ZTOTPED - ;
		(M->C5_XFRETE + ;
		M->C5_XVLCOMI + ;
		M->C5_XVLCOMG + ;
		M->C5_XVLCOMD + ;
		M->C5_XCUSTO + ;
		M->C5_XICMS	 + ;
		M->C5_XPIS	 + ;
		M->C5_XCOFINS + ;
		M->C5_XDESPFX + ;
		M->C5_XIRCSLL + ;
		M->C5_XVERBA + ;
		M->C5_XMANGA + ;
		M->C5_XMGERRO + ;
		M->C5_XMARKET)

	if M->C5_ZTOTPED > 0
		M->C5_XRESULT	:=	ROUND((xnResult / M->C5_ZTOTPED) * 100, 2)
	endif

	if M->C5_XVLRBRU > 0
		M->C5_XPERDES 	:=	ROUND((M->C5_XVLDESC / M->C5_XVLRBRU) * 100,2)
	endif

	M->C5_XCIDADE	:=	alltrim(SA1->A1_MUN) + ' - ' + SA1->A1_EST
	M->C5_XEST		:=	SA1->A1_EST

	if xnBaseCom > 0
		M->C5_COMIS1 := ROUND((M->C5_XVLCOMI / xnBaseCom) * 100,2)
	endif
	pricVari := M->C5_ZZPFRT

	M->C5_ZZPFRT := aCols[n,GDFieldPos("C6_ZPERFRT")]

	GetDRefresh()

return

//calcula o percentual de comissï¿½o
static function xfComis()
	local xlEntrou	:=	.T.
	local grpVar	:=	''


	//INDICE DA PAC PAC_FILIAL, PAC_TABELA, PAC_CHAVE, R_E_C_N_O_, D_E_L_E_T_
	if PAC->(dbSeek(xFilial('PAC') + '32' + codVend))
		xnComis1 :=	PAC->PAC_VLR01
		xlEntrou := .F.
	endIf

	if PAC->(dbSeek(xFilial('PAC') + '32' + codSuper))
		xnComis2 :=	PAC->PAC_VLR01
	endIf

	if PAC->(dbSeek(xFilial('PAC') + '32' + codGeren))
		xnComis3 :=	PAC->PAC_VLR01
	endIf

	SB1->(DbSeek(xFilial("SB1") + aCols[n,GDFieldPos("C6_PRODUTO")]))
	grpVar := SB1->B1_XGRPVAR

	if PAC->(dbSeek(xFilial('PAC') + '33' + grpVar))
		xnComis1 += PAC->PAC_VLR01
	endIf
	if xlEntrou
		SA1->(dbSeek(xFilial('SA1') + codCliente + lojaCliente ))
		xnComis1 := SA1->A1_COMIS
		if xnComis1 == 0
			SA3->(dbSeek(xFilial('SA3') + codVend))
			if SA3->A3_ZZPMIN == SA3->A3_ZZPMAX
				xnComis1 := SA3->A3_ZZPMIN
			endif
		endif
		if xnComis1 == 0
			DA0->(dbSeek(xFilial('DA0') + xcTabela))
			xnComis1 := DA0->DA0_ZCOMIS
		endif
	endif
	GetDRefresh()
return

//Calcula a comissï¿½o nos itens do pedidos
//Regras e Excessoes das comissoes
static function xfCalcCom()
	local retDesc := .F.

	//Verifica se tem exceï¿½ï¿½es para Rep + Tabela + Produto
	PAC->(dbSeek(xFilial('PAC') + '21'))

	do while !PAC->(EOF()) .AND. alltrim(PAC->PAC_TABELA) == '21'

		if aCols[n,GDFieldPos("C6_ZTABELA")] != PAC->PAC_CHAVE
			PAC->(dbskip())
			loop
		endif

		if alltrim(M->C5_VEND1) != alltrim(PAC->PAC_TXT01)
			PAC->(dbskip())
			loop
		endif

		if alltrim(aCols[n,GDFieldPos("C6_PRODUTO")]) != alltrim(PAC->PAC_TXT02)
			PAC->(dbskip())
			loop
		endif

		if date() < PAC->PAC_DATA01 .OR. date() > PAC->PAC_DATA02
			PAC->(dbskip())
			loop
		endif

		xnComis1	:=	PAC->PAC_VLR01

		PAC->(dbskip())
	end do

	//regras de comissao em relacao ao estado e
	if xnComis1 == 0
		PAC->(dbSeek(xFilial('PAC') + '16' + SA1->A1_EST))
		do while !PAC->(EOF()) ;
				.AND. alltrim(PAC->PAC_CHAVE) == estadoUf ;
				.AND. alltrim(PAC->PAC_TABELA) == '16'

			if M->C5_FRETEMB $ alltrim(PAC->PAC_TXT02)
				if PAC->PAC_VLR01 >= aCols[n,GDFieldPos("C6_XPERDES")]
					retDesc := .T.
					if xnComis1 < PAC->PAC_VLR02
						SA3->(dbSeek(xFilial('SA3') + M->C5_VEND1))
						if SA3->A3_ZZPMIN > PAC->PAC_VLR02
							xnComis1 := SA3->A3_ZZPMIN
						elseif SA3->A3_ZZPMAX < PAC->PAC_VLR02
							xnComis1 := SA3->A3_ZZPMAX
						else
							xnComis1 := PAC->PAC_VLR02
						endif

					endif
				endif
			endif

			PAC->(dbskip())
		end do
	endif


	if DA1->DA1_XREGRA == '007' .AND. DA1->DA1_CODTAB == '002' .AND. aCols[n,GDFieldPos("C6_QTDVEN")] > 0
		refPromocao()
	endif

	if codCliente + lojaCliente == '01671401'
		aCols[n,GDFieldPos("C6_COMIS1")] := 0
		aCols[n,GDFieldPos("C6_COMIS2")] := 0
		aCols[n,GDFieldPos("C6_COMIS3")] := 0
	else
		aCols[n,GDFieldPos("C6_COMIS1")] := xnComis1
		aCols[n,GDFieldPos("C6_COMIS2")] := xnComis2
		aCols[n,GDFieldPos("C6_COMIS3")] := xnComis3
	endif

return


/*/
	retorna a comissï¿½o para produtos promocionais,
	caso o desconto esteja dentro do padrï¿½o,
	10% de comissï¿½o, caso contrï¿½rio, segue a regra existente

	A tabela 16 retorna o mï¿½ximo de desconto de acordo com o frete
/*/
static function refPromocao()
	local retProced	:=	{}

	dbSelectArea('ZB1')
	ZB1->(DbSetOrder(1))
	ZB1->(DbSeek(xFilial("ZB1") + DA1->DA1_XREGRA))

	retProced := TCSPEXEC("comercialPedidoMaxDesc",  '16', estadoUf, xcFreteMB, 0)

	if retProced[1] > aCols[n,GDFieldPos("C6_XPERDES")]
		xnComis1 := ZB1->ZB1_COMIS
	endif

return

//posiciona as tabelas para iniciar os trabalhos
static function xfPosic()

	dbSelectArea('SA1')
	SA1->(DbSetOrder(1))

	dbSelectArea('AOB')
	AOB->(DbSetOrder(2))

	dbSelectArea('SA2')
	SA2->(DbSetOrder(1))

	dbSelectArea('SA3')
	SA3->(DbSetOrder(1))

	dbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + xcProduto))

	dbSelectArea('SB2')
	SB2->(DbSetOrder(1))
	SB2->(DbSeek(xFilial("SB2")+xcProduto+"10"))

	dbSelectArea('SB5')
	SB5->(DbSetOrder(1))
	SB5->(DbSeek(xFilial("SB5") + xcProduto))

	dbSelectArea('DA0')
	DA0->(DbSetOrder(1))

	dbSelectArea('DA1')
	DA1->(DbSetOrder(1))
	DA1->(dbSeek(xFilial("DA1") + xcTabela + xcProduto))

	dbSelectArea('SX5')
	SX5->(dbSetOrder(1))

	dbSelectArea('SZ1')
	SZ1->(DbSetOrder(1))

	dbSelectArea('PAC')
	PAC->(DbSetOrder(1)) //PAC_FILIAL, PAC_TABELA, PAC_CHAVE, R_E_C_N_O_, D_E_L_E_T_

	dbSelectArea('SE4')
	SE4->(DbSetOrder(1)) //E4_FILIAL, E4_CODIGO, R_E_C_N_O_, D_E_L_E_T_
	SE4->(dbSeek(xFilial("DA1") + M->C5_CONDPAG))


return

//calculando os preï¿½os do item de pedido
static function xfPreco()
	local xnDesc		:=	M->C5_ZZDESCO
	local xnPercJur		:=	M->C5_XPERJUR
	local xnValJur		:=	0
	local vlrTotal		:=	0
	local vlrTabela		:=	0
	local vlrFrete		:=	0
	local vlrBruto		:=	0
	local xnQtdeProd	:=	0
	local percDescon	:=	0
	local vlrDescon		:=	0
	local freteCli		:=	1
	local freteRep		:=	1
	local xcCliente		:=	M->C5_CLIENTE
	local xcLoja		:=	M->C5_LOJACLI
	local xcFreteMB		:=	M->C5_FRETEMB
	local xcVend1		:=	M->C5_VEND1
	local xcVend2		:=	M->C5_VEND2
	local xcVend3		:=	M->C5_VEND3
	local retSaldo		:=	{}
	local percComis		:=	{}
	local buscaTES		:=	{}


	DA0->(dbSeek(xFilial('DA0') + xcTabela))
	DA1->(dbSeek(xFilial("DA1") + xcTabela + xcProduto))


	aCols[n,GDFieldPos("C6_XPRCTAB")]	:=	DA1->DA1_PRCVEN
	aCols[n,GDFieldPos("C6_XEMISSA")]	:=	M->C5_EMISSAO
	aCols[n,GDFieldPos("C6_ZZNCM")]		:=	SB1->B1_POSIPI

	//xfFrete() //Aliquota do frete

	aliqFrete := val(TCSPEXEC("sp_pedidoCalculoFrete",  xcProduto, xcTabela, xcCliente, xcLoja, xcFreteMB, xcVend1, 'TABELAS')[1])

	freteRep := aliqFrete
	// ajuste da aliquota do frete em relação
	aliqFrete	:=	iif((xcFreteMB $ '1|3' .or. SA1->A1_EST == 'SP'), aliqFrete - 4, aliqFrete)
	aliqFrete	:=	iif(estadoUf $ 'ES|RJ|', 0, aliqFrete)
	aliqFrete	:=	iif(aliqFrete < 0, 0, aliqFrete)

	freteCli := aliqFrete


	//Calculo do Frete para compor o valor dos descontos
	xnQtdeProd	:=	aCols[n,GDFieldPos("C6_QTDVEN")]

	if DA0->DA0_XFRTIN == 'S'
		vlrTabela	:=	ROUND(DA1->DA1_PRCVEN, 2)
	else
		vlrTabela	:=	ROUND(DA1->DA1_PRCVEN/((100 - freteCli)/100), 2)
	endif


	if xcPar == 'P'

		xcTipoOper := iif(empty(aCols[n,GDFieldPos("C6_ZZTPOPE")]), M->C5_ZZTPOPE, aCols[n,GDFieldPos("C6_ZZTPOPE")])

		buscaTES := TCSPEXEC("sp_pedidoBuscaTES",  xcCliente, xcLoja, xcTipoOper, M->C5_TIPO, xcProduto, 'TES')
		buscaTES := StrTokArr(buscaTES[1], '|')

		if buscaTES[1] == 'XYZ'
			alert('TES INTELIGENTE - SEM CADASTRO')
			return
		endif

		aCols[n,GDFieldPos("C6_TES")]		:=	buscaTES[1]
		aCols[n,GDFieldPos("C6_CF")]		:=	buscaTES[2]
		aCols[n,GDFieldPos("C6_CLASFIS")]	:=	buscaTES[3]
	endif

	if xcPar == 'Q'

		vlrDescon	:=	vlrTabela - ROUND((vlrTabela * xnDesc) / 100, 2)

		vlrTotal	:=	round(vlrDescon * xnQtdeProd, 2)
		vlrFrete	:=	ROUND(vlrDescon * (freteRep/100) * xnQtdeProd, 2)
		vlrBruto	:=	vlrTabela * xnQtdeProd

		//Valor do pedido de acordo com a digitacao
		if !(M->C5_TIPO $ 'I | P ')
			aCols[n,GDFieldPos("C6_VALOR")]	:=	vlrTotal
		else
			aCols[n,GDFieldPos("C6_VALOR")]	:=	vlrTotal
		endif

		if xnQtdeProd > 0 .and. xcTabela == '709'
			retSaldo := TCSPEXEC("spComercialTabelaLimite709", xcTabela, xcProduto, 0)
			if xnQtdeProd > retSaldo[1]
				alert('Qtde Maior que saldo na Tabela: ' + alltrim(str(retSaldo[1])))
				xnQtdeProd := retSaldo[1]
			endif

		endif

		xnValJur	:=	vlrTotal *  (xnPercJur / 100)

		//calculo do frete a partir da informacao no cabec do pedido
		aCols[n,GDFieldPos("C6_ZPRCUNI")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_PRCVEN")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_PRUNIT")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_QTDLIB")]	:=	xnQtdeProd


		vlrDescon	:=	vlrBruto - round(vlrDescon * xnQtdeProd, 2)
		percDescon	:=	round((vlrDescon / vlrBruto) * 100,2)

		aCols[n,GDFieldPos("C6_XVLDESC")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_XPERDES")]	:=	percDescon
		aCols[n,GDFieldPos("C6_XFRTINC")] 	:=	DA0->DA0_XFRTIN
		aCols[n,GDFieldPos("C6_ZPERFRT")]  	:=	freteRep  //-- ((100 - freteRep)/100))
		aCols[n,GDFieldPos("C6_ZFRETE")] 	:=	vlrFrete
		aCols[n,GDFieldPos("C6_XVLRBRU")]	:=	round(vlrBruto + xnValJur, 2)
		aCols[n,GDFieldPos("C6_XVALJUR")]	:=	xnValJur
		aCols[n,GDFieldPos("C6_XPERJUR")]	:=	xnPercJur
		aCols[n,GDFieldPos("C6_ZBASCOM")]	:=	vlrBruto - vlrFrete - vlrDescon

		//Calculando o preco unitario
		aCols[n,GDFieldPos("C6_ZPRCUNI")] := round(aCols[n,GDFieldPos("C6_ZBASCOM")] / aCols[n,GDFieldPos("C6_QTDVEN")],2)


		percComis := TCSPEXEC("sp_pedidoCalculoComissao",  xcProduto, xcTabela, percDescon, xcCliente, xcLoja, xcFreteMB, xcVend1, xcVend2, xcVend3, 'COMISSAO')
		percComis := StrTokArr(percComis[1], '|')

		aCols[n,GDFieldPos("C6_COMIS1")]	:=	val(percComis[1])
		aCols[n,GDFieldPos("C6_COMIS2")]	:=	val(percComis[2])
		aCols[n,GDFieldPos("C6_COMIS3")]	:=	val(percComis[3])
		aCols[n,GDFieldPos("C6_XTIPCOM")]	:=	percComis[4]
		aCols[n,GDFieldPos("C6_ZVALCOM")]	:=	round(aCols[n,GDFieldPos("C6_ZBASCOM")] * (aCols[n,GDFieldPos("C6_COMIS1")]) / 100,2)
		aCols[n,GDFieldPos("C6_XVLCOMG")]	:=	round(aCols[n,GDFieldPos("C6_VALOR")] * (aCols[n,GDFieldPos("C6_COMIS2")]) / 100,2)
		aCols[n,GDFieldPos("C6_XVLCOMD")]	:=	round(aCols[n,GDFieldPos("C6_VALOR")] * (aCols[n,GDFieldPos("C6_COMIS3")]) / 100,2)
		aCols[n,GDFieldPos("C6_XGRPVAR")]	:=	SB1->B1_XGRPVAR
		GetDRefresh()
		//	elseif xcPar == 'Q'
	endif

	if xcPar == 'V'

		vlrDescon	:=	aCols[n,GDFieldPos("C6_ZPRCUNI")]

		vlrTotal	:=	round(vlrDescon * xnQtdeProd, 2)
		vlrFrete	:=	ROUND(vlrDescon * (freteRep/100) * xnQtdeProd, 2)
		vlrBruto	:=	vlrTabela * xnQtdeProd

		//Valor do pedido de acordo com a digitacao
		if !(M->C5_TIPO $ 'I | P ')
			aCols[n,GDFieldPos("C6_VALOR")]	:=	vlrTotal
		else
			aCols[n,GDFieldPos("C6_VALOR")]	:=	vlrTotal
		endif

		if xnQtdeProd > 0 .and. xcTabela == '709'
			retSaldo := TCSPEXEC("spComercialTabelaLimite709", xcTabela, xcProduto, 0)
			if xnQtdeProd > retSaldo[1]
				alert('Qtde Maior que saldo na Tabela: ' + alltrim(str(retSaldo[1])))
				xnQtdeProd := retSaldo[1]
			endif

		endif

		xnValJur	:=	vlrTotal *  (xnPercJur / 100)

		// ajuste da aliquota do frete em relação
		aliqFrete	:=	iif((xcFreteMB $ '1|3' .or. SA1->A1_EST == 'SP'), aliqFrete - 4, aliqFrete)
		aliqFrete	:=	iif(estadoUf $ 'ES|RJ|', 0, aliqFrete)
		aliqFrete	:=	iif(aliqFrete < 0, 0, aliqFrete)

		//calculo do frete a partir da informacao no cabec do pedido
		aCols[n,GDFieldPos("C6_ZPRCUNI")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_PRCVEN")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_PRUNIT")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_QTDLIB")]	:=	xnQtdeProd


		vlrDescon	:=	vlrBruto - round(vlrDescon * xnQtdeProd, 2)
		vlrDescon	:=	iif(vlrDescon<0,0,vlrDescon)
		percDescon	:=	round((vlrDescon / vlrBruto) * 100,2)
		percDescon	:=	iif(percDescon<0,0,percDescon)

		aCols[n,GDFieldPos("C6_XVLDESC")]	:=	vlrDescon
		aCols[n,GDFieldPos("C6_XPERDES")]	:=	percDescon
		aCols[n,GDFieldPos("C6_XFRTINC")] 	:=	DA0->DA0_XFRTIN
		aCols[n,GDFieldPos("C6_ZPERFRT")]  	:=	aliqFrete
		aCols[n,GDFieldPos("C6_ZFRETE")] 	:=	vlrFrete
		aCols[n,GDFieldPos("C6_XVLRBRU")]	:=	round(vlrBruto + xnValJur, 2)
		aCols[n,GDFieldPos("C6_XVALJUR")]	:=	xnValJur
		aCols[n,GDFieldPos("C6_XPERJUR")]	:=	xnPercJur
		aCols[n,GDFieldPos("C6_ZBASCOM")]	:=	vlrBruto - vlrFrete - vlrDescon

		//Calculando o preco unitario
		aCols[n,GDFieldPos("C6_ZPRCUNI")] := round(aCols[n,GDFieldPos("C6_ZBASCOM")] / aCols[n,GDFieldPos("C6_QTDVEN")],2)


		percComis := TCSPEXEC("sp_pedidoCalculoComissao",  xcProduto, xcTabela, percDescon, xcCliente, xcLoja, xcFreteMB, xcVend1, xcVend2, xcVend3, 'COMISSAO')
		percComis := StrTokArr(percComis[1], '|')

		aCols[n,GDFieldPos("C6_COMIS1")]	:=	val(percComis[1])
		aCols[n,GDFieldPos("C6_COMIS2")]	:=	val(percComis[2])
		aCols[n,GDFieldPos("C6_COMIS3")]	:=	val(percComis[3])
		aCols[n,GDFieldPos("C6_XTIPCOM")]	:=	percComis[4]
		aCols[n,GDFieldPos("C6_ZVALCOM")]	:=	round(aCols[n,GDFieldPos("C6_ZBASCOM")] * (aCols[n,GDFieldPos("C6_COMIS1")]) / 100,2)
		aCols[n,GDFieldPos("C6_XVLCOMG")]	:=	round(aCols[n,GDFieldPos("C6_VALOR")] * (aCols[n,GDFieldPos("C6_COMIS2")]) / 100,2)
		aCols[n,GDFieldPos("C6_XVLCOMD")]	:=	round(aCols[n,GDFieldPos("C6_VALOR")] * (aCols[n,GDFieldPos("C6_COMIS3")]) / 100,2)
		aCols[n,GDFieldPos("C6_XGRPVAR")]	:=	SB1->B1_XGRPVAR
		GetDRefresh()
		//	elseif xcPar == 'Q'
	endif

	do case
	case DA0->DA0_ZZMARG == '4'
		if aCols[n,GDFieldPos("C6_PRCVEN")] <>  DA1->DA1_PRCVEN
			alert('Tabela tipo Feirinha, Nao Pode alterar o preco')
			aCols[n,GDFieldPos("C6_QTDVEN")] := 0
			aCols[n,GDFieldPos("C6_PRCVEN")] :=  DA1->DA1_PRCVEN
			aCols[n,GDFieldPos("C6_ZPRCUNI")]:=  DA1->DA1_PRCVEN
		endif
	case DA0->DA0_ZZMARG == '3'
		if aCols[n,GDFieldPos("C6_PRCVEN")] <>  DA1->DA1_PRCVEN
			alert('Tabela fixa, Nao Pode alterar o preco')
			aCols[n,GDFieldPos("C6_QTDVEN")] := 0
			aCols[n,GDFieldPos("C6_PRCVEN")] :=  DA1->DA1_PRCVEN
			aCols[n,GDFieldPos("C6_ZPRCUNI")]:=  DA1->DA1_PRCVEN
		endif
	case DA0->DA0_ZZMARG == '2'
		if aCols[n,GDFieldPos("C6_PRCVEN")] <  DA1->DA1_PRCVEN
			alert('Tabela Promocional, O preco deve ser igual ou maior')
			aCols[n,GDFieldPos("C6_QTDVEN")] := 0
			aCols[n,GDFieldPos("C6_PRCVEN")] :=  DA1->DA1_PRCVEN
			aCols[n,GDFieldPos("C6_ZPRCUNI")]:=  DA1->DA1_PRCVEN
		endif

	end case


	if aCols[n,GDFieldPos("C6_ZPRCUNI")] / DA1->DA1_PRCVEN > 1.5
		alert('Produto com mais de 50% de aumento')
		aCols[n,GDFieldPos("C6_ZPRCUNI")] := 0
	endif
return

//calculando o resultado do pedido
static function xfResult()

	aCols[n,GDFieldPos("C6_XRESULT")] := 	round(aCols[n,GDFieldPos("C6_VALOR")]   - ; //Total do Pedido
	aCols[n,GDFieldPos("C6_XCUSTOS")] - ; //Custo de produtos
	aCols[n,GDFieldPos("C6_ZFRETE")] -  ; //Valor do Frete
	aCols[n,GDFieldPos("C6_ZVALCOM")] - ; //Valor da comissï¿½o
	aCols[n,GDFieldPos("C6_XVLCOMG")] - ; //Valor da comissï¿½o Gerencia
	aCols[n,GDFieldPos("C6_XVLCOMD")] - ; //Valor da comissï¿½o Diretoria
	aCols[n,GDFieldPos("C6_XDESPFX")] - ; //Despesas Fixas
	aCols[n,GDFieldPos("C6_XIRCSLL")] - ; //Ir e Csll sobre o total
	aCols[n,GDFieldPos("C6_XMGERRO")] - ; //Marketing
	aCols[n,GDFieldPos("C6_XMARKET")] - ; //Margem de erro
	aCols[n,GDFieldPos("C6_XMANGA")]  - ; //Manga
	aCols[n,GDFieldPos("C6_XVERBA")]  - ; //Verba
	aCols[n,GDFieldPos("C6_XVLICMS")] - ; //Valor de ICMS
	aCols[n,GDFieldPos("C6_XVLCOFI")] - ; //Valor de Cofins
	aCols[n,GDFieldPos("C6_XVLPIS")],2) 	  //Valor do PIS

	aCols[n,GDFieldPos("C6_XRESULT")] := round((aCols[n,GDFieldPos("C6_XRESULT")] / aCols[n,GDFieldPos("C6_VALOR")]) * 100,2)

	if M->C5_ZZMGDES == '2'
		aCols[n,GDFieldPos("C6_local")] := '11'
	else
		aCols[n,GDFieldPos("C6_local")] := SB1->B1_LOCPAD
	endif
return

//funï¿½ï¿½o para calcular as margens obtidas pelo pedido.
static function xfCustos()
	if aCols[n,GDFieldPos("C6_QTDVEN")] > 0

		//Calculo da comissï¿½o
		aCols[n,GDFieldPos("C6_XCUSTOS")] := round(aCols[n,GDFieldPos("C6_QTDVEN")] * SB1->B1_ZZVLIND,2)

		//Calculo da DEspesas fixas
		aCols[n,GDFieldPos("C6_XDESPFX")] := round(aCols[n,GDFieldPos("C6_VALOR")] * (Posicione('PAC', 1, xFilial('PAC') + '12001', 'PAC_VLR01') / 100),2)

		//Calculo da Ir CSLL
		aCols[n,GDFieldPos("C6_XIRCSLL")] := round(aCols[n,GDFieldPos("C6_VALOR")] * (Posicione('PAC', 1, xFilial('PAC') + '12002', 'PAC_VLR01') / 100),2)

		//Calculo da Manga
		aCols[n,GDFieldPos("C6_XMANGA")] := round(aCols[n,GDFieldPos("C6_VALOR")] * (Posicione('PAC', 1, xFilial('PAC') + '12003', 'PAC_VLR01') / 100),2)

		//Calculo da Margem de erro
		aCols[n,GDFieldPos("C6_XMGERRO")] := round(aCols[n,GDFieldPos("C6_VALOR")] * (Posicione('PAC', 1, xFilial('PAC') + '12004', 'PAC_VLR01') / 100),2)

		//Calculo da Marketing
		aCols[n,GDFieldPos("C6_XMARKET")] := round(aCols[n,GDFieldPos("C6_VALOR")] * (Posicione('PAC', 1, xFilial('PAC') + '12005', 'PAC_VLR01') / 100),2)

		//Calculo da Marketing
		aCols[n,GDFieldPos("C6_XVLCOFI")] := round(aCols[n,GDFieldPos("C6_VALOR")] * aliqCof, 2)

		//Calculo da Marketing
		aCols[n,GDFieldPos("C6_XVLPIS")] := round(aCols[n,GDFieldPos("C6_VALOR")] * aliqPis, 2)

		//Calculo da Marketing
		aCols[n,GDFieldPos("C6_XVLICMS")] := round(aCols[n,GDFieldPos("C6_VALOR")] * aliqIcms, 2)

		valorVerba()
	endif

	//Calculo da comissï¿½o
	GetDRefresh()

return()



//calculo de frete
static function xfFrete()
	local xlContinua	:=	.T.

	aliqFrete := 0

	// if DA0->DA0_XFRTIN == 'N' .AND. DA0->DA0_XFRETE > 0
	if DA0->DA0_XFRETE > 0
		aliqFrete := DA0->DA0_XFRETE
		xlContinua := .F.
	endif

	if xlContinua
		PAC->(dbSeek(xFilial("PAC")+"19"))

		while !PAC->(EOF()) .and. PAC->PAC_TABELA == '19'

			if codCliente + lojaCliente == LEFT(alltrim(PAC->PAC_TXT01),8)

				do case
				case xcFreteMB == '1'
					aliqFrete := PAC->PAC_VLR01 + 4
				case xcFreteMB == '2'
					aliqFrete := PAC->PAC_VLR01
				case xcFreteMB == '3'
					aliqFrete := 4
				case xcFreteMB == '4'
					aliqFrete := 0
				endcase

			endif

			PAC->(dbSkip())
		end

		if PAC->(dbSeek(xFilial("PAC")+"20" + codVend)) .AND.  aliqFrete == 0 .AND. xcFreteMB == '2'
			if estadoUf $ PAC->PAC_TXT01
				aliqFrete := PAC->PAC_VLR01
			endif
		elseif PAC->(dbSeek(xFilial("PAC")+"17" + xcFreteMB)) .AND.  aliqFrete == 0

			aliqFrete := PAC->PAC_VLR01

			if PAC->(dbSeek(xFilial("PAC") + "18" + codVend)) .AND. xcFreteMB == '2'

				aliqFrete := PAC->PAC_VLR01

			elseif PAC->(dbSeek(xFilial("PAC") + "08" + estadoUf)) .AND. xcFreteMB $ '1|2'

				aliqFrete += PAC->PAC_VLR02

			endif

		endif

	endif

	GetDRefresh()

return

User Function CalcPeso(nPvalor)

return 0

//cubagem

static function xfCubagem(xcProd, xnQuant, xlTampa, xlVolume)
	local xnRet      := 0
	local xnCubUn    := 0
	local xnCubInc   := 0
	local xnFilas    := 0
	local xnEmpil    := 0

	Default xlTampa  := .f.
	Default xlVolume := .f.

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + xcProd))

	SB5->(dbSetOrder(1))
	SB5->(dbSeek(xFilial("SB5") + xcProd))

	xnCubUn  := SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ALTURLC
	xnCubInc := SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ZZEMPAL
	xnQuant  := (xnQuant / iif(SB1->B1_CONV==0,1,SB1->B1_CONV))

	if SB5->B5_ZZUTEMP == "S"
		xnFilas := Int(xnQuant/SB5->B5_ZZEMPMX)
		xnFilas += Iif((xnQuant/SB5->B5_ZZEMPMX) - xnFilas > 0, 1, 0)

		xnEmpil := xnQuant - xnFilas

		xnRet := (xnFilas * xnCubUn) + (xnEmpil * xnCubInc)
	else
		xnRet := xnQuant * xnCubUn
	endif

	if xlTampa .and. !Empty(SB1->B1_ZZADD)
		xnRet += xfCubagem(SB1->B1_ZZADD, xnQuant, .t., .t.)
	endif

Return(xnRet)

