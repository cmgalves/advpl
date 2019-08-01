#Include "Protheus.ch"
#Include "Tbiconn.ch"

User Function TESTEvar
	Local xcDir		:=	'\web\pp\intranet2\html\'
	Local xcFile		:=	'opfat040.htm'


	// PREPARANDO AMBIENTE
prepare environment Empresa '99' Filial '01'

DBSELECTAREA('SE2')
SE2->(DBSETORDER(1))
SE2->(DBSEEK(XFILIAL('SE2') + '01EMP000006   1 '))

xcDir	:=	'oi'
xcFile	:=	'tudo bem'


reset environment

return
