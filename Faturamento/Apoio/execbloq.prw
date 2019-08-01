#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"

//NUMERA��O AUTOM�TICA DO CLIENTE
User Function alcLimite()
    local ret := 0
    local alcLimite := SuperGetMV('MB_ALCLIMI', .F., .F.)
    local codUser := __cUserId
    
    if codUser $ alcLimite
        ret := M->A1_LC
    else
        If M->A1_LC > 3000
            alert('Limite at� R$ 3.000,00')
            ret := 0
        else
            ret := M->A1_LC
        endif
    endif

Return(ret)