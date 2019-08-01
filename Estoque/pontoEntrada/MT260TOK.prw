#INCLUDE "RWMAKE.CH"
User Function MT260TOK
    Local lRet:= .T.
    local itensFora := AllTrim(GetMv("MB_ITEFORA")) //itens que estão fora da regra


// //DEMIS260 - CCODORIG - CCODDEST
// if (cCodOrig != cCodDest .or. dEmis260 != date()) .and.  !(alltrim(cCodOrig) $ itensFora .and. dEmis260 == date()))
//     lRet := .f.
//     alert('Produtos Diferentes')
// endif

    if (cCodOrig != cCodDest) .and.  (left(cCodOrig,3) !=  'ETQ' .or. left(cCodDest, 3) != 'ETQ')
        lRet := .f.
        alert('Produtos Diferentes')
        cCodOrig := ''
        cCodDest := ''
    endif
    if dEmis260 != date()
        lRet := .f.
        alert('Data Incorreta')
        dEmis260 := date()
    endif


Return lRet