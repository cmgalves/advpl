#include 'protheus.ch'


user function MT410TOK()
	local xcItens		:=	''
	local xlRet			:=	.T.
	local codEmpresa	:=	FWCodEmp()
	local xnCount		:=	0
	local n				:=  0
	local xi			:=  0

	For n := 1 to len(aCols)
		if codEmpresa == '01'
			if aCols[n,GDFieldPos("C6_XQTDORI")] < aCols[n,GDFieldPos("C6_QTDVEN")] .AND. aCols[n,GDFieldPos("C6_XQTDCRT")] == 0
				aCols[n,GDFieldPos("C6_XITEORI")] := aCols[n,GDFieldPos("C6_PRODUTO")]
				aCols[n,GDFieldPos("C6_XQTDORI")] := aCols[n,GDFieldPos("C6_QTDVEN")]
			endif

			if aCols[n,GDFieldPos("C6_XCUSTOS")] == 0 .AND. M->C5_ZZTPOPE $ '01/04/09/12' .AND. !(GDDeleted(n))
				alert('O Custo do Produto esta zerado, favor atualizar todos os Itens abaixo para atualizar os valores')
				return .F.
			endif

			DA0->(dbSeek(xFilial("DA0") + aCols[n,GDFieldPos("C6_ZTABELA")]))
			if DA0->DA0_ZZMARG == '4'
				DA1->(dbSeek(xFilial("DA1") + aCols[n,GDFieldPos("C6_ZTABELA")] + aCols[n,GDFieldPos("C6_PRODUTO")]))
				while !(DA1->(EOF())) .AND. alltrim(aCols[n,GDFieldPos("C6_ZTABELA")]) == alltrim(DA1->DA1_CODTAB)
					if !((aCols[n,Len(aHeader)+1]))
						if 	aScan(aCols,{|x|alltrim(x[GDFieldPos("C6_PRODUTO")])==alltrim(DA1->DA1_CODPRO) .AND. alltrim(x[GDFieldPos("C6_ZTABELA")])==alltrim(DA1->DA1_CODTAB)}) <= 0
							xcItens +=  iif(empty(alltrim(xcItens)), alltrim(DA1->DA1_CODPRO),' - '+alltrim(DA1->DA1_CODPRO))
						endif
					endif
					DA1->(dbSkip())
				enddo
			endif

			if !empty(alltrim(xcItens))
				alert('Feirinha, falta(m) o(s) Item(ns): ' + xcItens)
				xlRet	:=	.F.
			endif
			if xlRet
				for xi := 0 to len(aCols)
					if M->C5_ZZTPOPE != aCols[n,GDFieldPos("C6_ZZTPOPE")] .AND. !GDDeleted(n)
						xnCount ++
					endif
				next xi
				if xnCount > 0
					if !(MsgNoYes( "TIPOS DE OPERACOES DifERENTES, DESEJA CONTINUAR???", 'OBSERVE OS TIPOS DE OPERACAO' ))
						xlRet := .f.
					endif
				endif
			endif
		endif
	Next
return xlRet
