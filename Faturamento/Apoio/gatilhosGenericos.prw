//058779
#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"

//NUMERAÇÃO AUTOMÁTICA DO CLIENTE
user function fxGatilho()
    local xcCampo       :=  SX7->X7_CAMPO
    local xcSeque       :=  SX7->X7_SEQUENC
    local xcContra      :=  SX7->X7_CDOMIN
    local xcClientes    :=  M->DA0_XCLIGR
    local xaCods        :=  {}
    local xlAchou       :=  .T.

    if xcCampo == 'DA1_PRCVEN' .AND. xcSeque == '001'




        if empty(xcClientes)
            M->DA0_XCLIGR   :=  ';' + M->DA0_XCLIEN
        else
            xaCods  := StrTokArr(M->DA0_XCLIGR, ';')
            for xi := 1 to len(xaCods)
                if xaCods[xi] == M->DA0_XCLIEN
                    adel(xaCods[xi])
                    xlAchou :=  .F.
                endif
            next
            if xlAchou
                aadd(xaCods, M->DA0_XCLIEN)
                asort(xaCods)
                for xi := 1 to len(xaCods)
                    M->DA0_XCLIGR   :=  ';' + xaCods[xi]
                next
            endif
        endif

    endif





Return()

