#Include "Protheus.ch"
#include "topconn.ch"

/**
* Funcao		:	MBCALCUB
* Autor		:	Deivid A. C. de Lima
* Data			: 	19/07/10
* Descricao	:	Função de cálculo de cubagem
* Parâmetros	:	cProduto - Código do produto
* 					nQuant   - Quantidade de venda
* 					lTampa   - Utiliza tampa
* 					lVolume  - Quantidade informada em volumes
* Retorno		: 	Numérico - Cubagem
*/     

User Function MBCALCUB(cProduto,nQuant,lTampa,lVolume)
	local aAreaSB1  := SB1->(GetArea())
	local aAreaSB5  := SB5->(GetArea())
	local nRet      := 0
	local nCubUn    := 0
	local nCubInc   := 0
	local nFilasInt := 0
	local nFilas    := 0
	local nEmpil    := 0

	Default lTampa  := .f.
	Default lVolume := .f.

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+cProduto))

	SB5->(dbSetOrder(1))
	SB5->(dbSeek(xFilial("SB5")+cProduto))

	nCubUn  := SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ALTURLC
	nCubInc := SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ZZEMPAL
	nQuant  := IIF(lVolume,nQuant,U_MBCALVOL(cProduto,nQuant))

	If SB5->B5_ZZUTEMP == "S"
		nFilasInt := Int(nQuant/SB5->B5_ZZEMPMX)
		nFilas := nFilasInt + IIF((nQuant/SB5->B5_ZZEMPMX) - nFilasInt > 0, 1, 0)

		nEmpil := nQuant - nFilas

		nRet := (nFilas * nCubUn) + (nEmpil * nCubInc)
	Else
		nRet := nQuant * nCubUn
	Endif

	If lTampa .and. !Empty(SB1->B1_ZZADD)
		nRet += U_MBCALCUB(SB1->B1_ZZADD,nQuant,.t.,.t.)
	Endif

	RestArea(aAreaSB1)
	RestArea(aAreaSB5)

Return(nRet)

/**
* Funcao		:	MBCALVOL
* Autor		:	Deivid A. C. de Lima
* Data			: 	21/07/10
* Descricao	:	Função de cálculo de volumes
* Parâmetros	:	cProduto - Código do produto
* 					nQuant   - Quantidade de venda
* 					lTampa   - Utiliza tampa
* Retorno		: 	Numérico - Volume
*/     

User Function MBCALVOL(cProduto,nQuant,lTampa)
	local aArea   := SB1->(GetArea())
	local nQtdOri := nQuant
	local nRet    := 0

	Default lTampa := .f.

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+cProduto))

	nRet := nQuant / SB1->B1_CONV

	If lTampa .and. !Empty(SB1->B1_ZZADD)
		nRet *= 2
	Endif

	RestArea(aArea)

Return(nRet)