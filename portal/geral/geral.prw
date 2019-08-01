#Include "Protheus.ch"
#Include "Apwebex.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"



///*******************************
//   Monta a página
///*******************************
User Function MontaPag(_cFile, _cCodUser, _cNomUser, _cVendCod, _cMesPag)
	Local xcDir			:=	'\web\pp\portal\html\'
	Local xcFile		:=	_cFile
	Local lOk			:=	.F.
	Local xcRet			:=	""
	Local xcR			:=	Char(13)+Char(10)

	default _cVendCod := ''
	default _cMesPag := ''

	lOk := File(xcDir + xcFile)
	If lOk
		FT_FUse(xcDir+xcFile)
		FT_FGotop()
		While ( !FT_FEof() )
			xcRet += FT_FReadln() + xcR
			FT_FSkip()
		EndDo
		FT_FUse()
	EndIf
	xcRet	:=	replace(xcRet, '__xcCodUser', _cCodUser)
	xcRet	:=	replace(xcRet, '__xcNomUser', _cNomUser)
	xcRet	:=	replace(xcRet, '__cVendCod', _cVendCod)
	xcRet	:=	replace(xcRet, '__cMesCom', _cMesPag)
return xcRet
