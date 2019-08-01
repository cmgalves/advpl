#include "Protheus.ch"
#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SF2520E   � Autor � ARM Campinas          � Data � dd/mm/aa ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �P.E. na exclus�o de NF:									  ���
���          �   - Deleta Mensagens NF (SZZ)    						  ���
�������������������������������������������������������������������������Ĵ��
���Uso       �SigaFat                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SF2520E()

	//��������������������������������������������������������������Ŀ
	//� Salva areas abertas                                          �
	//����������������������������������������������������������������
	local _aArea    :=	GetArea()
	local _aAreaSZZ :=	SZZ -> (GetArea ())
	local _aAreaSC5 :=	SC5 -> (GetArea ())
	local _cMotCan 	:=	Space(50)   
	local xcObs 	:=	''
	local numPedido	:=	''   

	if CEMPANT != '01'
		RestArea (_aAreaSC5)
		RestArea (_aAreaSZZ)
		RestArea (_aArea)
		Return
	endif

	dbSelectArea("SZZ")
	dbSetOrder(1)
	dbSeek (xFilial ("SZZ") + "S" + SF2 -> F2_DOC + SF2 -> F2_SERIE + SF2 -> F2_CLIENTE + SF2 -> F2_LOJA)
	If Found()
		While !eof() .and. SZZ -> ZZ_FILIAL  == xFilial("SZZ");
		.and. SZZ -> ZZ_TIPODOC == "S";
		.and. SF2 -> F2_DOC     == SZZ -> ZZ_DOC ;
		.and. SF2 -> F2_SERIE   == SZZ->ZZ_SERIE ;
		.and. SF2 -> F2_CLIENTE == SZZ -> ZZ_CLIFOR ;
		.and. SF2 -> F2_LOJA    == SZZ -> ZZ_LOJA 
			RecLock("SZZ",.F.)
			dbDelete() 
			MsUnlock()
			dbSkip()
		End
	EndIf

	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("CANCELAMENTO NF") FROM 09,10 To 14,70 OF oMainWnd
	@ 011,030 SAY   OemToAnsi("Motivo")  SIZE 080,009 OF oDlg FONT oFont20 PIXEL
	@ 011,110 MSGET  _cMotCan	 		 SIZE 120,009 PICTURE "@!S20" OF oDlg FONT oFont20 PIXEL VALID !Empty(_cMotCan) 
	@ 026,200 BmpButton Type 1 ACTION Close(oDlg)

	ACTIVATE MSDIALOG oDlg CENTERED               

	If RecLock(" SF2",.F.)
		SF2->F2_ZMOTCAN := _cMotCan
		msUnLock()
	Endif

	/*
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek (xFilial ("SD2") +  SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	*/
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek (xFilial ("SC5") +  SF2->F2_XPEDIDO)

	If RecLock("SC5",.F.)
		SC5->C5_TRANSP	:=	''
		SC5->C5_XCARGA	:=	''
		SC5->C5_ZDATFAT	:=	SF2->F2_EMISSAO
		SC5->(msUnLock())
	Endif


	xcObs := 'Nota Excluida'
	numPedido	:=	SF2->F2_XPEDIDO
	retornoProc	:=	TCSPEXEC("sp_Inclui_Status_Pedido", numPedido, '5', 'Z', 'prtheu', xcObs, 'OK')

	TCRefresh( 'PA3' )


	//��������������������������������������������������������������Ŀ
	//� Restaura Areas Abertas                                       �
	//����������������������������������������������������������������
	RestArea (_aAreaSZZ)
	RestArea (_aArea)

Return .T.
