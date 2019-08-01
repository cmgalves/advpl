#include "RWMAKE.CH"

User Function MBVldEdit(_cUsuario,_cA3_ZZCATEG)

Local lRet := .F.

If _cA3_ZZCATEG $ '123' .or. Alltrim(SubStr(_cUsuario,7,15)) $ GETMV("MV_USERLIB")
	lRet := .T.
EndIf

Return(lRet)