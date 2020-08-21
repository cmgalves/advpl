#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"

//checa Centro de Custo e Depto
User Function chKCC()
    local ret := 0
 
    
    if substring(M->RA_CC,1,1)='1' and M->RA_DEPTO<> '000000015'
         alert('Centro de Custo Industrial e Depto Administrativo - Acertar')
         ret := 0
    Endif
    if substring(M->RA_CC,1,1)!='1' and M->RA_DEPTO= '000000015'
         alert('Centro de Custo Administrativo e Depto Industrial - Acertar')
         ret := 0
    Endif   
   
Return(ret)