#include "Protheus.ch"

User Function SE3AUTO()

dbSelectArea("SA1")
dbSetOrder(1)
If !SA1->(MsSeek(xFilial("SA1")+"000001"))
	lOk := .F.
	ConOut("Cadastrar cliente: 000001")
EndIf

dbSelectArea("SA3")
dbSetOrder(1)
If !SA3->(MsSeek(xFilial("SA3")+"000001"))
	lOk := .F.
	ConOut("Cadastrar vendedor: 000001")
EndIf

aAdd(aAuto,{"E3_VEND","000001",Nil})
aAdd(aAuto,{"E3_NUM","321654",Nil})
aAdd(aAuto,{"E3_EMISSAO",CtoD("21/09/04"),Nil})
aAdd(aAuto,{"E3_SERIE","UNI",Nil})
aAdd(aAuto,{"E3_CODCLI","000001",Nil})
aAdd(aAuto,{"E3_LOJA","01",Nil})
aAdd(aAuto,{"E3_BASE",1000,Nil})
aAdd(aAuto,{"E3_PORC",10,Nil})
aAdd(aAuto,{"E3_DATA",CtoD("21/09/04"),Nil})
aAdd(aAuto,{"E3_PREFIXO","001",Nil})
aAdd(aAuto,{"E3_PARCELA","2",Nil})
aAdd(aAuto,{"E3_TIPO","DH",Nil})
aAdd(aAuto,{"E3_PEDIDO","654321",Nil})
aAdd(aAuto,{"E3_VENCTO",CtoD("21/09/04"),Nil})

Mata490(aAuto,3)
Return