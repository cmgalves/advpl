#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function MBACDIRF()

Local cQRYSE2 := ""

cQRYSE2 := "SELECT SE2.E2_TITPAI, SE2.E2_CODRET "
cQRYSE2 += "FROM " + RETSQLNAME("SE2") + " SE2 "
cQRYSE2 += "WHERE SE2.E2_DIRF = '1' AND "
cQRYSE2 += "SE2.E2_EMISSAO >= '20110101' AND SE2.E2_EMISSAO <= '20111231' AND "
cQRYSE2 += "SE2.E2_TIPO != 'NF ' AND "
cQRYSE2 += "SE2.E2_TITPAI != '' AND "
cQRYSE2 += "SE2.D_E_L_E_T_ = ' '" 
	
TCQUERY cQRYSE2 NEW ALIAS "TRB"
DBSELECTAREA("TRB")
DBGOTOP()      

While TRB->(!EOF())
   DbSelectArea("SE2")
   DbSetOrder(1)
   DbGoTop()

   IF SE2->(DbSeek(xFilial("SE2")+TRB->E2_TITPAI))
      RecLock("SE2",.F.)
          SE2->E2_CODRET := TRB->E2_CODRET
		  SE2->E2_DIRF := "S"
      MsUnlock()
   EndIf
   TRB->(DbSkip())

EndDo

Return