#include "Protheus.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBVLD1   ºAutor  ³Cassiano G. Ribeiro º Data ³  01/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo C5_COMIS1.                              º±±
±±º          ³ Valida vendedor sem permissao de alteração de %comissao    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - PMB                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMBVLD1()
Local xlRet		:=	.T.
Local nPosProd  := 	GDFieldPos("C6_PRODUTO")

Private xcR		:=	Char(13) + Char(10)
Private xaAlias := 	{ {Alias()},{"SA3"},{"SA1"},{"DA0"},{"DA1"}}


//U_ufAmbiente(xaAlias, "S")

_MBCodImp	:= "00"

If M->C5_TIPO $ "N"
	SA3->(dbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1))
		
		If SA3->A3_ZZCATEG $ '2,4' .and. M->C5_COMIS1 <> SA3->A3_COMIS
			If !(__cUserId $ GETMV("MB_ALTCOMI"))
				IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
					Alert("C A D A S T R O    V E N D E D O R" + xcR + "NÃO PODE ALTERAR COMISSÃO!","ATENÇÃO")
				ENDIF
				_MBCodImp	:= "21"
				If __cUserId != "GetMV('MB_FULLPED')"
					xlRet := .F.
				EndIf
				M->C5_COMIS1 := SA3->A3_COMIS
			EndIf
			
		ElseIf SA3->A3_ZZCATEG == '1'
			SA1->(dbSetOrder(1))
			DA0->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
				If SA1->A1_COMIS > 0 .and. M->C5_COMIS1 <> SA1->A1_COMIS
					IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
						Alert("C A D A S T R O    V E N D E D O R" + xcR + "NÃO PODE ALTERAR COMISSÃO!","ATENÇÃO")
					ENDIF
					_MBCodImp	:= "21"
					If __cUserId != "GetMV('MB_FULLPED')"
						xlRet := .F.
					EndIf
					M->C5_COMIS1 := SA1->A1_COMIS
				ElseIf DA0->(dbSeek(xFilial("DA0")+M->C5_TABELA))
					If SA1->A1_COMIS <= 0 .AND. DA0->DA0_ZCOMIS > 0 .AND. M->C5_COMIS1 <> DA0->DA0_ZCOMIS
						IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
							Alert("C A D A S T R O    V E N D E D O R" + xcR + "NÃO PODE ALTERAR COMISSÃO!","ATENÇÃO")
						ENDIF
						_MBCodImp	:= "21"
						If __cUserId != "GetMV('MB_FULLPED')"
							xlRet := .F.
						EndIf
						M->C5_COMIS1 := DA0->DA0_ZCOMIS
					EndIf
				ElseIf SA3->A3_ZZALTCO == '2' .and. M->C5_COMIS1 <> SA3->A3_COMIS .and. SA1->A1_COMIS <= 0 .and. DA0->DA0_ZCOMIS <= 0
					IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
						Alert("C A D A S T R O    V E N D E D O R" + xcR + "NÃO PODE ALTERAR COMISSÃO!","ATENÇÃO")
					ENDIF
					_MBCodImp	:= "21"
					If __cUserId != "GetMV('MB_FULLPED')"
						xlRet := .F.
					EndIf
					M->C5_COMIS1 := SA3->A3_COMIS
				ElseIf SA3->A3_ZZALTCO == '1' .and. M->C5_COMIS1 <> SA3->A3_COMIS .and. SA1->A1_COMIS <= 0 .and. DA0->DA0_ZCOMIS <= 0
					If M->C5_COMIS1 < SA3->A3_ZZPMIN .or. M->C5_COMIS1 > SA3->A3_ZZPMAX
						IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
							Alert("C A D A S T R O    V E N D E D O R" + xcR + "COMISSÃO INFORMADA FORA DA FAIXA DO VENDEDOR!", "ATENÇÃO")
						ENDIF
						_MBCodImp	:= "22"
						If __cUserId != "GetMV('MB_FULLPED')"
							xlRet := .F.
						EndIf
						M->C5_COMIS1 := SA3->A3_COMIS
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
//U_ufAmbiente(xaAlias, "R")

Return (xlRet)

