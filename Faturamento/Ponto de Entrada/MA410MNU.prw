#include 'protheus.ch'
#include 'parmtype.ch'

user function MA410MNU()

AAdd(aRotina,{ 'Impressão Pedido', 'U_MBRFAT01("DIRETO")', 0,0,0,Nil } )
aAdd(aRotina,{ 'Inutiliza Ref. Guarani' ,"U_DelRefGrn()",0,0,0 ,NIL} )

Return()


User Function DelRefGrn()

If Empty(SC5->C5_XPEDEMP)
    MsgAlert('Pedido '+SC5->C5_NUM+' sem referência Guarani.')
    Return()
EndIf

If SubStr(SC5->C5_XPEDEMP,1,1)=='*'
    MsgAlert('Pedido '+SC5->C5_NUM+' Com refrência já removida.')
    Return()
EndIf

If MsgYesNo('Confirma Excluir a referência Guarani do pedido '+SC5->C5_NUM+' ?')
    RecLock('SC5',.F.)
    Replace SC5->C5_XPEDEMP With '*'+AllTrim(SC5->C5_XPEDEMP)
    MsUnlock('SC5')
    MsgInfo('Referência Guarani removida!')
EndIf

Return()
