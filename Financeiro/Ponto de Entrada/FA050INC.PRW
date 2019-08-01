#include "protheus.ch"
#include "topconn.ch"   

User Function FA050INC()


cNat:=subst(M->E2_NATUREZ,1,7)
cNatPis:=""
cNatIRRF:=""
cNatCOF:=""
cNatCSLL:=""
cNatINSS:=""
cNatISSQN:=""
//DEF.DAD, CFD.MOI, CFI.MAN, CFI.FER, DEF.MOF, DEF.TPF
DbSelectArea("SED")
SED->(DbGoTop())
SED->(DbSetOrder(1))
SED->(DbSeek(xFilial("SED")+cNat,.t.))
While cNat == SUBST(ED_CODIGO,1,7)
      If "PIS RET" $ (ED_DESCRIC)
         cNatPis:=SED->ED_CODIGO
      Endif
      If "IRRF RET" $ (ED_DESCRIC)
         cNatIRRF:=SED->ED_CODIGO
      Endif
      If "COFINS RET" $ (ED_DESCRIC)
         cNatCOF:=SED->ED_CODIGO
      Endif
      If "CSLL RET" $ (ED_DESCRIC)
         cNatCSLL:=SED->ED_CODIGO
      Endif
      If "INSS RET" $ (ED_DESCRIC)
         cNatINSS:=SED->ED_CODIGO
      Endif
      If "ISSQN RET" $ (ED_DESCRIC)
         cNatISSQN:=SED->ED_CODIGO
      Endif                              
      
      DbSelectArea("SED")
      DbSkip()
Enddo

PUTMV("MV_PISNAT",  cNatPIS       )      
PUTMV("MV_INSS",'"'+cNatINSS  +'"') 
PUTMV("MV_COFINS",  cNatCOF       ) 
PUTMV("MV_CSLL",    cNatCSLL      )      
PUTMV("MV_IRF",'"'+ cNatIRRF  +'"')      
PUTMV("MV_ISS",'"'+ cNatISSQN +'"')      

Return .T.