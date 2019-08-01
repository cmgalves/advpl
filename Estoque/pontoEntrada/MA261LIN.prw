User Function MA261LIN( )
    Local lRet  :=  .T.
    local codOrig   :=  ''
    local codDest   :=  ''
    local itensFora := AllTrim(GetMv("MB_ITEFORA")) //itens que estão fora da regra
    Local nLinha := PARAMIXB[1]  // numero da linha do aCols// 'Validações Adicionais do Usuario

    codOrig := acols[nLinha][1]
    codDest := acols[nLinha][6]

    if (codOrig != codDest) .and.  ((left(codOrig,3) !=  'ETQ' .or. left(codDest, 3) != 'ETQ')) //liberar apenas para etq destino
        lRet := .f.
        alert('Produtos Diferentes')
        acols[nLinha][1] := ''
        acols[nLinha][6] := ''
    endif

    // if alltrim(codOrig) $ itensFora .AND.  UPPER(LEFT(codDest, 3)) != 'ETQ'//liberar apenas para etq destino
    //         lRet := .f.
    //         alert('Só pode Transferir Etiquetas para outros Modelos de Etiquetas')
    // endif
        
    if da261Data != date()
        lRet := .f.
        alert('Data Incorreta')
        da261Data := date()
    endif
    GetDRefresh()
Return lRet