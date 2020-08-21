#include "Protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mt410Ace  ºAutor  ³Claudio Alves       º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada chamado no Início da rotina do PV          º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function Mt410Ace()
local lContinua :=	.T.
local nOpc  	:=	PARAMIXB [1]
local xm		:=	0

if CEMPANT != '01'
	Return .T.
endif

if SC5->C5_ZZTPOPE $ '|07|02|T3|'
	return .T.
endif

if GetMV('MB_ALTPED') == 'N'
	if nOpc == 1 .AND. SC5->C5_TIPO = 'N'
		if !(__cUserID $ GetMv('MB_EXCLPED'))
			Alert('USUÁRIO SEM ACESSO PARA EXCLUIR PEDIDO', 'ALERTA MB')
			lContinua := .F.
		endif
	elseif nOpc == 4 .AND. SC5->C5_TIPO = 'N' .AND. Empty(AllTrim(Dtos(SC5->C5_ZDTRETO))) // Alterar
		if  DTOC(SC5->C5_ZDTDIGI)!="  /  /    " .OR. DTOC(SC5->C5_ZDLBCAD)!="  /  /    " .OR. DTOC(SC5->C5_ZLIBREG)!="  /  /    " .OR. DTOC(SC5->C5_ZZLIBCR)!="  /  /    "
			Alert('O PEDIDO ESTÁ EM PROCESSO DE LIBERAÇÃO, NÃO PODERÁ SER ALTERADO', 'ALERTA MB')
			lContinua := .F.
		endif
	endif
endif

if __cUserId $ '000098 | 000110 | 000124 | 000011 | 000046 '
	lContinua := .T.
endif

Return(lContinua)
