#include "Protheus.ch"
#include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mt410Ace  �Autor  �Claudio Alves       � Data �  05/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada chamado no In�cio da rotina do PV          ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			Alert('USU�RIO SEM ACESSO PARA EXCLUIR PEDIDO', 'ALERTA MB')
			lContinua := .F.
		endif
	elseif nOpc == 4 .AND. SC5->C5_TIPO = 'N' .AND. Empty(AllTrim(Dtos(SC5->C5_ZDTRETO))) // Alterar
		if  DTOC(SC5->C5_ZDTDIGI)!="  /  /    " .OR. DTOC(SC5->C5_ZDLBCAD)!="  /  /    " .OR. DTOC(SC5->C5_ZLIBREG)!="  /  /    " .OR. DTOC(SC5->C5_ZZLIBCR)!="  /  /    "
			Alert('O PEDIDO EST� EM PROCESSO DE LIBERA��O, N�O PODER� SER ALTERADO', 'ALERTA MB')
			lContinua := .F.
		endif
	endif
endif

if __cUserId $ '000098 | 000110 | 000124 | 000011 | 000046 '
	lContinua := .T.
endif

Return(lContinua)
