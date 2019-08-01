#Include "Rwmake.ch"

User Function RGUAA001

_nRec := SE4->(Recno())
DbSelectArea("SE4")
DbSetOrder(1)
DbGotop()
While !SE4->(Eof())
	_aParc := Condicao ( 1000, SE4->E4_CODIGO, Nil, DATE())
	_nDias := 0
	For _x:=1 to len(_aParc)
		_nDias += _aParc[_x,1] - Date()
	Next                      
	_nPrzMed := _nDias / Len(_aParc)
	_nParc	:= Len(_aParc)
	If _nPrzMed <= 999
		RecLock("SE4",.F.)
		SE4->E4_XPRZMED	:= _nPrzMed
		SE4->E4_XPARCEL := _nParc
		MsUnlock()
	EndIf
	SE4->(DbSkip())
EndDo
DbGoto(_nRec)

Return