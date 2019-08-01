#include 'protheus.ch'


user function MT410TOK()
	local xcItens	:=	''
	local xlRet		:=	.T.
	local codEmpresa := FWCodEmp()

	private xaAlias 	:= { {Alias()},{"DA0"},{"DA1"},{"PAC"},{"SA1"},{"SA3"},{"SB1"},{"SB5"},{"SX5"},{"SZ1"},{"SZ3"}}
	U_ufAmbiente(xaAlias, "S")


	If codEmpresa == '01'
		
		If aCols[n,GDFieldPos("C6_XCUSTOS")] == 0 .AND. M->C5_ZZTPOPE $ '01 04 09 12'
		claudio := !GDDeleted(n)
			alert('O Custo do Produto está zerado, favor atualizar todos os Itens abaixo para atualizar os valores')
			return .F.
		EndIf

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

	endif

	U_ufAmbiente(xaAlias, "R")

return xlRet
