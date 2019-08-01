#include "protheus.ch"
#include "topconn.ch"
//Retorna tes inteligente
user function tesIntelig()
	local retProced	:=	{}
	local cTpOpe	:= 	""
	local cUF		:= 	""
	local cCSuf		:= 	""
	local cContrb	:= 	""
	local cTipoPV	:= 	""
	local cIE		:= 	""
	local cPessoa	:= 	""
	local cSuframa	:= 	""
	local cNCM		:= 	""
	local cGrTrib	:= 	""
	local cTPessoa	:= 	""
	local codProd	:= 	""
	local aDadosCfo	:=	{}
	// local nPosCfo	:=	0
	local M->C5_TIPO
	// local N


	cTipoPV		:= 	M->C5_TIPO
	cTpOpe		:=	aCols[n,GDFieldPos("C6_ZZTPOPE")]
	codProd		:=	aCols[n,GDFieldPos("C6_PRODUTO")]

	if empty(alltrim(cTpOpe)) .or. empty(alltrim(codProd))
		return aCols[n,GDFieldPos("C6_TES")]
	endif


	if ALLTRIM(cTipoPV) $ "N,C,I,P"
		SA1->(dbseek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
		SB1->(dbseek(xFilial("SB1")+codProd))

		cTpOpe		:= 	iif(cTpOpe $ "10 | PA", "01", cTpOpe)
		cUF			:= 	SA1->A1_EST
		cCSuf		:= 	SA1->A1_CALCSUF
		cContrb		:= 	SA1->A1_CONTRIB
		cIE			:= 	SA1->A1_INSCR
		cPessoa		:= 	SA1->A1_PESSOA
		cSuframa	:= 	SA1->A1_SUFRAMA
		cNCM		:= 	SB1->B1_POSIPI
		cGrTrib		:= 	SA1->A1_GRPTRIB
		cTPessoa	:= 	SA1->A1_TPESSOA
		xcSimpNac	:= 	SA1->A1_SIMPNAC
	else
		SA2->(dbseek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI))
		SB1->(dbseek(xFilial("SB1")+codProd))

		cUF			:= SA2->A2_EST
		cCSuf		:= ""
		cContrb		:= ""
		cIE			:= SA2->A2_INSCR
		cPessoa		:= SA2->A2_TIPO
		cSuframa	:= ""
		cNCM		:= SB1->B1_POSIPI
		cGrTrib		:= ""
		cTPessoa	:= SA2->A2_TPESSOA
		xcSimpNac	:= SA2->A2_SIMPNAC
	endif

	cIE := iif(empty(alltrim(cIE)),'N',iif(upper(alltrim(cIE))=='ISENTO', 'N', 'S'))
	cSuframa	:=	iif(empty(alltrim(cSuframa)),'N','S')

	retProced := TCSPEXEC("comercialTesInteligente", cTpOpe, cUF, cCSuf, cContrb, cTipoPV, cIE, cPessoa, cSuframa, cNCM, cGrTrib, cTPessoa, xcSimpNac, 'OK')

	retProced	:=	StrTokArr( retProced[1] , "|" )

	if retProced[2] == '0'
		U_UASKYPE('SEM TES INTELIGENTE ' + M->C5_CLIENTE + '-' + M->C5_LOJACLI + ' Tp:' + cTpOpe )
		// elseif retProced [2] == '1'
		// 	aCols[n,GDFieldPos("C6_TES")] := retProced [1]
		// 	GetDRefresh()
	elseif retProced [2] != '1'
		U_UASKYPE('MAIS DE UMA REGRA DE TES INTELIGENTE ' + M->C5_CLIENTE+'-'+M->C5_LOJACLI + ' Tp:' + cTpOpe )
	endif

	dbSelectArea("SF4")
	// nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF") })
	if SA1->A1_EST == 'EX'
		aCols[n,GDFieldPos("C6_CF")] := '7101'
	else
		MsSeek(xFilial("SF4")+retProced[1])
		AAdd(aDadosCfo,{"OPERNF","S"})
		AAdd(aDadosCfo,{"TPCLifOR",SA1->A1_TIPO})
		AAdd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
		AAdd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
		AAdd(aDadosCfo,{"CONTR"   ,SA1->A1_CONTRIB})
		aCols[n,GDFieldPos("C6_CF")] := MaFisCfo( ,SF4->F4_CF,aDadosCfo )
	endif
	// nPosCfo := 0
	// if nPosCfo > 0
	// 	aCols[n,GDFieldPos("C6_CF")] := Space(Len(aCols[n,GDFieldPos("C6_CF")]))
	// endifcalves	

	if MaFisFound("IT",n)
		MaFisAlt("IT_TES",retProced[1],n)
		MaFisRef("IT_TES","MT100",retProced[1])
	endif


return (retProced [1])

User Function MBCADTES()
	AxCadastro("SZ5","Cadastro de Regras de TES Inteligente Específico MB")
Return
