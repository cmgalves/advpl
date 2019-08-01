#INCLUDE "PROTHEUS.CH"

User Function FA470CTA
Local _aArea := GetArea()
Local _aRet := AClone(PARAMIXB)

_cBco 	:= AllTrim(_aRet[1])
_cAg	:= AllTrim(_aRet[2])
_cCta	:= AllTrim(cValToChar(Val(_aRet[3])))

dbSelectArea("SA6")
SA6->(dbSetOrder(1))
SA6->(dbGoTop())
SA6->(dbSeek(xFilial("SA6")+_cBco+_cAg))
While SA6->(!Eof())
	IF _cBco $ SA6->A6_COD .AND. ;
	   _cAg  $ SA6->A6_AGENCIA .AND. ;
	   _cCta $ SA6->A6_NUMCON
		Return({AllTrim(SA6->A6_COD),AllTrim(SA6->A6_AGENCIA),AllTrim(SA6->A6_NUMCON)})
	EndIf
	SA6->(dbSkip())
EndDo

RestArea(_aArea)

Return(_aRet)