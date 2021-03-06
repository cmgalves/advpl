#include "Protheus.ch"
#include "rwmake.ch"
#Include "Topconn.ch"
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � M460FIM  � Autor � Cassiano G. Ribeiro   � Data �15/06/2010���
���������������������������������������������������������������������������Ĵ��
���Descri��o � - Utilizado na Geracao da Nota Fiscal de Saida               ���
���          � - Ponto de entrada disparado na geracao da nota de saida.    ���
���          � Tem por objetivo abrir tela para que o usuario informe       ���
���          � os dados adicionais da nota: transportadora, redespacho,     ���
���          � placa, nome do motorista, peso liquido, peso bruto, volume   ���
���          � especie, marca, dt saida e Hr saida (estes campos serao      ���
���          � gravados no SF2). O calculo do peso liquido e calculado      ���
���          � automaticamente atraves da formula: D2_QUANT*B1_PESO         ���
���          � O programa tambem abrira uma tela mostrando as mensagens     ���
���          � padrao informados no produto, tes e pedido de vendas. Estas  ���
���          � mensagens poderao ser alteradas, ou inserida uma nova linha  ���
���          � por mensagem. Todas as mensagens informadas serao gravadas   ���
���          � no arquivo SZZ (mensagens por nota)                          ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
���������������������������������������������������������������������������Ĵ��
���Programador � Alteracao feita pelo Motivo ( Descricao abaixo)            ���
���������������������������������������������������������������������������Ĵ��
���            �                                                            ���
���            �                                                            ���
���            �                                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function M460FIM()
//�������������������������������Ŀ
//�Salva Areas de Trabalho        �
//���������������������������������
	local _aArea	:= GetArea()			// Inicializa array para capturar Area de Trabalho desconhecida
	local _aAreaSB1	:= SB1->(GetArea())	// Inicializa array para capturar Area de Trabalho SB1
	local _aAreaSF2 := SF2->(GetArea())	// Inicializa array para capturar Area de Trabalho SF2
	local _aAreaSD2	:= SD2->(GetArea())	// Inicializa array para capturar Area de Trabalho SD2
	local _aAreaSA1	:= SA1->(GetArea())	// Inicializa array para capturar Area de Trabalho SA1
	local _aAreaSA2	:= SA2->(GetArea())	// Inicializa array para capturar Area de Trabalho SA2
	local _aAreaSC5	:= SC5->(GetArea())	// Inicializa array para capturar Area de Trabalho SC5
	local _aAreaSF4	:= SF4->(GetArea())	// Inicializa array para capturar Area de Trabalho SF4
	local _aAreaSE1	:= SE1->(GetArea())	// Inicializa array para capturar Area de Trabalho SE1
	local _cNome    := ""
	local _cDoc     := SF2->F2_DOC
	local _cSerie   := SF2->F2_SERIE
	local volumeNota:= ''
	local _cTransp  := ""
	local _cCodRed  := ""
	local _cEspec   := "VOLUME"//CHUMBADO A PEDID DO SR. EMERSON - PLASTICOS MB.
	local _cNomeRed := space(30)
	local xcPlaca   := space(07)
	local xcEst   	:= space(02)
	local xcVeic	:= space(09)
	local _cMarca   := space(20)
	local _dDtSaida := dDataBase
	local _cHrSaida := Time()
	local numPedido	:=	''
	local tipoOpera	:=	''
	local pesoLiqui	:=	''
	local pesoBruto	:=	''
	local retornoProc	:=	{}
	local xcObs		:=	''

	private aCod      [8]			// Inicializa array com 8 elementos para os codigos das mensagens.
	private aMsg      [8]			// Inicializa array com 8 elementos para os textos das mensagens.
	private lMsg   	:= .t.
	private nVar   	:= 0
	private cMsg   	:= ""
	private cCod   	:= ""
	private cLin1  	:= ""
	private cLin2  	:= ""
	private _lFecha	:= .f.
	private _cMens  := ""
	private _cMens1 := space(03)
	private _cMens2 := space(03)

	aFill (aCod, space (003))		// Inicializa cada um dos 8 elementos do array com o tamanho para os codigos das mensagens.
	aFill (aMsg, space (500))		// Inicializa cada um dos 8 elementos do array com o tamanho para os textos das mensagens.

	if CEMPANT != '01'
		Return
	endif



//_lFecha := .f.


//���������������������������������������������������������Ŀ
//� Posiciona SD2 - itens da nota fiscal                    �
//�����������������������������������������������������������
	dbSelectArea("SD2")
	dbSetOrder(3)                 //filial,doc,serie,cliente,loja,cod
	dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE)


	dbSelectArea("SF4")
	dbSeek(xFilial("SF4")+SD2->D2_TES)

	dbSelectArea("SC5")
	dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)

	numPedido 	:=	SC5->C5_NUM
	tipoOpera 	:=	SC5->C5_ZZTPOPE
	pesoLiqui 	:=	SC5->C5_PESOL
	pesoBruto 	:=	SC5->C5_PBRUTO
	volumeNota	:=	SC5->C5_VOLUME1
//000094766
	if SF2->F2_TIPO == "D" .OR. SF2->F2_TIPO == "B" //nf de devolucao/remessa->fornecedor
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		_cNome := SubStr(SA2->A2_NOME,1,30)
	else
		dbSelectArea("SA1")
		dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		_cNome := SubStr(SA1->A1_NOME,1,30)
	endif

//����������������������������������������������������������������������������Ŀ
//�Calcula Peso Liquido da Nota de Saida a partir do peso cadastrado no produto�
//������������������������������������������������������������������������������


	dbSelectArea("SF2")

	_cDoc      := SF2->F2_DOC
	_cSerie    := SF2->F2_SERIE
	_cTransp   := SC5->C5_TRANSP
	_cCodRed   := SC5->C5_REDESP
	_cNomeRed	:=	space(30)
	xcVeic		:=	space(09)
	_cMarca		:=	space(20)
	_cMens		:=	""
	_cMens1		:=	space(03)
	_cMens2		:=	space(03)
	_dDtSaida	:=	dDataBase //Ctod("  /  /  ")
	_cHrSaida	:=	Time() //""

//��������������������������������������������������������������Ŀ
//�Se necessario alterar as informacoes abaixo                   �
//����������������������������������������������������������������

	@ 150,10 to 420,580 DIALOG JanelaNF TITLE "Digite as Informa��es Necess�rias"

	@ 012,010 SAY "NOTA FISCAL: "+SF2->F2_DOC	size 80,10
	@ 012,100 SAY "CLIENTE: "+_cNome            size 120,10
	@ 032,010 SAY "Cod. Transp.: "
	@ 032,115 SAY "Redesp: "
	@ 029,205 SAY "Ve�culo: "
	@ 052,010 SAY "Peso Liquido: "
	@ 052,115 SAY "Peso Bruto: "
	@ 072,010 SAY "Volume: "
	@ 072,115 SAY "Especie: "
	@ 072,205 SAY "Marca: "
	@ 092,010 SAY "Data Saida: "
	@ 092,115 SAY "Hora: "
	@ 032,050 GET _cTransp  	PICTURE "@!" Valid .t. F3 "SA4" size 40,10
	@ 032,150 GET _cCodRed  	PICTURE "@!" Valid .t. F3 "SA4" size 40,10
	@ 032,230 GET xcVeic		PICTURE "@!" Valid .t. F3 "DA3"	size 40,10
	@ 052,050 GET pesoLiqui 	PICTURE "@E 99,999.99" when .f. size 40,10
	@ 052,150 GET pesoBruto  	PICTURE "@E 99,999.99" when .f. size 40,10
	@ 072,050 GET volumeNota 	PICTURE "@E 99999"     			size 40,10
	@ 072,150 GET _cEspec                          when .f. size 40,10
	@ 072,230 GET _cMarca   	PICTURE "@!15"         			size 40,10
	@ 092,050 GET _dDtSaida 	PICTURE "99/99/99"     when .f. size 40,10
	@ 092,150 GET _cHrSaida 	PICTURE "99:99:99"     when .f. size 40,10

	@ 112,230 BMPBUTTON TYPE 1 ACTION Close(JanelaNF)
	ACTIVATE DIALOG JanelaNF CENTERED

	dbSelectArea("SC5")
	if SC5->(!Eof())
		RecLock("SC5",.f.)
		SC5->C5_TRANSP  := 	_cTransp
		SC5->C5_REDESP  :=	_cCodRed
		SC5->C5_VEICULO :=	xcVeic
		SC5->C5_ZDATFAT	:=	SF2->F2_EMISSAO
		MsUnLock()
	endif

	dbSelectArea("DA3")
	DA3->(dbSetOrder(1)) //DA3_FILIAL, DA3_COD, R_E_C_N_O_, D_E_L_E_T_
	If DA3->(dbSeek(xFilial('DA3') + xcVeic))
		xcPlaca := DA3->DA3_PLACA
		xcEst := DA3->DA3_ESTPLA
	Else
		xcPlaca := left(alltrim(xcVeic),7)
		xcEst := right(alltrim(xcVeic),2)
	EndIf
	



	dbSelectArea("SF2")
	RecLock("SF2",.f.)
	SF2->F2_TRANSP  := _cTransp
	SF2->F2_REDESP  := _cCodRed
	SF2->F2_VOLUME1 := volumeNota
	SF2->F2_ESPECI1 := _cEspec
	SF2->F2_ZZMARCA := _cMarca
	SF2->F2_VEICUL1 := xcVeic
	SF2->F2_ZZPLACA := xcPlaca	//left(alltrim(_cPlaca),7)
	SF2->F2_ZUFPLAC := xcEst	//right(alltrim(_cPlaca),2)
	SF2->F2_ZZDTSAI := _dDtSaida
	SF2->F2_ZZHRSAI := _cHrSaida
	SF2->F2_ZZTPOPE := tipoOpera
	SF2->F2_XPEDIDO := numPedido
	MsUnLock()

	xcObs := 'Pedido Faturado'
	retornoProc := TCSPEXEC("sp_Inclui_Status_Pedido", numPedido, '7', 'Z', 'prtheu', xcObs, 'OK')

	TCRefresh( 'PA3' )
	


	CarregaMsg()					// Recupera as mensagens informadas no TES / Produto / Pedido.
	CadMen()						// Informacao das Mensagens.

	descVerba()
	
//Chamada para rotina respons�vel por enviar as informa��es ao SFA - AutoVen referente ao faturamento do Pedido
//Alert("teste")

	RestArea(_aAreaSF2)
	RestArea(_aAreaSD2)
	RestArea(_aAreaSA1)
	RestArea(_aAreaSA2)
	RestArea(_aAreaSC5)
	RestArea(_aAreaSB1)
	RestArea(_aAreaSF4)
	RestArea(_aAreaSE1)
	RestArea(_aArea)

Return



static function descVerba()
	local chaveNota 	:=	''
	local xvezes 		:=	0
	local retProced		:=	{}
	local numRec		:=	0
	chaveNota = SF2->(F2_SERIE + F2_DOC)
	dbSelectArea("SE1")
	numRec := SE1->(RECNO())
	SE1->(dbSetOrder(1)) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	If SE1->(dbSeek(xFilial('SE1') + chaveNota ))


	retProced := TCSPEXEC("comercialVerbaClientesCalc",  SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_DOC, 0)

//comercialVerbaClientesCalc '007796', '04', '000093652', 0
		While !(SE1->(EOF())) .and. xvezes == 0
			If SE1->E1_CLIENTE != SF2->F2_CLIENTE
				SE1->(dbSkip())
				LOOP
			EndIf
			If retProced[1] == 0
				SE1->(dbSkip())
				LOOP
			EndIf

			RecLock("SE1",.f.)
				SE1->E1_DECRESC  := retProced[1]
				SE1->E1_SDDECRE  := retProced[1]
				SE1->E1_ZZDCCOD  := '06'
				SE1->E1_ZZDCDES  := 'VERBA COMERCIAL'
			MsUnLock()			
			
			xvezes++
			
			SE1->(dbSkip())
		end
	
	EndIf
	
	SE1->(dbGoTo(numRec))


return

//�������������������������������Ŀ
//�FIM DA ROTINA M460FIM          �
//���������������������������������

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � CADMEN   � Autor � ARM Campinas          � Data � dd/mm/aa ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Grava��o de Mensagens N.F. de Entrada  ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Static Function CadMen ()

// Declaracao de variaveis:
	_lFecha := .t.
	@ 127, 015 To 182, 605 Dialog oDlg1 Title OemToAnsi ("Digitacao das mensagems da Nota Fiscal de Entrada")
	@ 005, 010 Get aCod [1] Picture "@!"  F3 "SM4" Valid ValidMsg ("1")
	@ 005, 040 Get aCod [2] Picture "@!"  F3 "SM4" Valid ValidMsg ("2")
	@ 005, 070 Get aCod [3] Picture "@!"  F3 "SM4" Valid ValidMsg ("3")
	@ 005, 100 Get aCod [4] Picture "@!"  F3 "SM4" Valid ValidMsg ("4")
	@ 005, 130 Get aCod [5] Picture "@!"  F3 "SM4" Valid ValidMsg ("5")
	@ 005, 160 Get aCod [6] Picture "@!"  F3 "SM4" Valid ValidMsg ("6")
	@ 005, 190 Get aCod [7] Picture "@!"  F3 "SM4" Valid ValidMsg ("7")
	@ 005, 220 Get aCod [8] Picture "@!"  F3 "SM4" Valid ValidMsg ("8")

	@ 01,260 BMPBUTTON TYPE 11 ACTION Edmen (nVar)
	@ 15,260 BMPBUTTON TYPE  1 ACTION GravMen ()
	Activate Dialog oDlg1

Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � MSG      � Autor � ARM Campinas          � Data �dd/mm/aa  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Direcionar / Edi��o de Mensagens       ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
���������������������������������������������������������������������������Ĵ��
���Programador � Alteracao feita pelo Motivo ( Descricao abaixo)            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Static Function ValidMsg (cVar)

	nVar := Val (cVar)
	lMsg := .T.
	ChkMsg (nVar)

Return (lMsg)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � CHKMSG   � Autor � ARM Campinas          � Data � dd/mm/aa ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Verifica��o se existe a mensagem       ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Static Function ChkMsg (nVar)

	if !Empty (aCod [nVar])
		if Empty (formula (aCod [nVar]))
			MsgBox ("Mensagem nao cadastrada, ou com conteudo vazio." + chr (13) + "Verifique o Cadastro de Mensagens.", "Atencao !!!", "STOP")
			lMsg := .F.
		endif
	endif
Return (.T.)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � EDMEN    � Autor � ARM Campinas          � Data �dd/mm/aa  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Editar as Mensagens N.F. de Entrada    ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Static Function Edmen (nVar)

	if ! empty (aCod [nVar])
	
		if empty (aMsg [nVar])
			cCod  := aCod [nVar]
			cMsg  := formula (cCod) + Space (500 - Len (formula (cCod)))
		
			cLin1 := Substr (cMsg, 001, 250)
			cLin2 := Substr (cMsg, 251, 250)
		else
			cLin1 := PadR (Substr (aMsg [nVar], 001, 250), 250, " ")
			cLin2 := PadR (Substr (aMsg [nVar], 251, 250), 250, " ")
		endif
	
		@ 200, 010 To 295,580 Dialog oDlg2 Title OemToAnsi ("Edicao de Mensagens")
		@ 010, 002 Say OemToAnsi ("Lin1")
		@ 024, 002 Say OemToAnsi ("Lin2")
		@ 010, 015 Get cLin1 Valid .T. SIZE 210, 040
		@ 024, 015 Get cLin2 Valid .T. SIZE 210, 040
		@ 010, 235 BMPBUTTON TYPE 01 ACTION MontaMsg ()
		@ 024, 235 BMPBUTTON TYPE 02 ACTION LimpaMsg ()
		Activate Dialog oDlg2
	
	else
	
		MsgStop ("Codigo da mensagem esta em branco.")
	
	endif

Return (Nil)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � MONTAMSG � Autor � ARM Campinas          � Data �dd/mm/aa  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Concatenar Mensagens.                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function MontaMsg ()

	aMsg [nVar] := alltrim (cLin1) + " " + alltrim (cLin2)	//
	Close (oDlg2)

Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � LIMPAMSG � Autor � ARM Campinas          � Data � dd/mm/aa ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Limpar Mensagens.                      ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function LimpaMsg ()

	aMsg [nVar] := space (500)
	Close (oDlg2)

Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � GRAVMEN  � Autor � ARM Campinas          � Data �dd/mm/aa  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Grava��o de Mensagens N.F. de Entrada  ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Static Function GravMen ()

	local _nLinGrv :=  nK := _nX := _nSeq := 0
	local _cTexto  := space (500)

	for nK := 1 To 8
	
		if ! empty (aCod [nK])
			_cTexto	:= Alltrim (formula (aCod [nK]))
		
			if ! Empty (aMsg [nK])
				_cTexto	:= Alltrim (aMsg [nK])
			endif
		
			_nLinGrv := MlCount (_cTexto, 250)
		
			dbSelectArea ("SZZ")
		
			for _nX := 1 to _nLinGrv
				_nSeq := _nSeq + 1
			
				RecLock ("SZZ", .T.)
			
				SZZ -> ZZ_FILIAL	:= xFilial("SZZ")
				SZZ -> ZZ_TIPODOC	:= "S"		// Nota Fiscal de Saida
				SZZ -> ZZ_DOC		:= SF2 -> F2_DOC
				SZZ -> ZZ_SERIE		:= SF2 -> F2_SERIE
				SZZ -> ZZ_CLifor	:= SF2 -> F2_CLIENTE
				SZZ -> ZZ_LOJA		:= SF2 -> F2_LOJA
				SZZ -> ZZ_SEQMENS	:= StrZero (_nSeq, 2)
				SZZ -> ZZ_CODMENS	:= aCod [nK]
				SZZ -> ZZ_TXTMENS  := MemoLine (_cTexto, 250, _nX)
			
				MsUnlock ()
			next
		endif
	next
	if _lFecha
		Close (oDlg1)
	endif

Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      �CARREGAMSG� Autor � ARM Campinas          � Data � dd/mm/aa ���
���������������������������������������������������������������������������Ĵ��
���Descri��o   � Funcao Utilizado p/ Recuperar as mensagens informados no   ���
���            � TES, nos Produtos e nos Pedidos de Venda.                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � AP7                                                        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Static Function CarregaMsg ()

	local _nCont    :=	1		// Variavel para controlar o limite de mensagens a ser exibida na tela de selecao.
	local _aNfori   :=	{}
	local _cTotal	:=	""
	local _cEmissao :=	""
	local _cChave   :=	space(11)
	local _cQtdLib  :=	_cUnid  := _cSCMen := ""
	local xi		:=	0

	SC5 -> (dbSetOrder (1))

	dbSelectArea("SD2")
	dbSetOrder (3)
	dbSeek (xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

	While !Eof () .and. SD2->D2_FILIAL == SF2->F2_FILIAL .and.;
			SD2->D2_DOC    == SF2->F2_DOC .and.;
			SD2->D2_SERIE  == SF2->F2_SERIE .and.;
			SD2->D2_CLIENTE == SF2->F2_CLIENTE .and.;
			SD2->D2_LOJA   == SF2->F2_LOJA
	
	// Recupera Mensagem Padrao no Pedido de Venda.
		SC5 -> (dbSeek (xFilial ("SC5") + SD2 -> D2_PEDIDO))
		_nTem := aScan (aCod, SC5 -> C5_MENPAD)
			if _nTem == 0
			if _nCont <= 8
				aCod [_nCont] := SC5 -> C5_MENPAD
				_nCont := _nCont + 1
			endif
		endif
	
	// Recupera Mensagem Padrao no TES (3 mensagens).
		SF4 -> (dbSeek (xFilial ("SF4") + SD2 -> D2_TES))
		_nTem := aScan (aCod, SF4 -> F4_ZZMEN1)
		if _nTem == 0
			if _nCont <= 8
				aCod [_nCont] := SF4 -> F4_ZZMEN1
				_nCont := _nCont + 1
			endif
		endif
	
		_nTem := aScan (aCod, SF4 -> F4_ZZMEN2)
		if _nTem == 0
			if _nCont <= 8
				aCod [_nCont] := SF4 -> F4_ZZMEN2
				_nCont := _nCont + 1
			endif
		endif
	
		_nTem := aScan (aCod, SF4 -> F4_ZZMEN3)
		if _nTem == 0
			if _nCont <= 8
				aCod [_nCont] := SF4 -> F4_ZZMEN3
				_nCont := _nCont + 1
			endif
		endif
	
	
		if !Empty(SD2->D2_NforI)
			_cQtdLib := _cUnid := _cSCMen := ""
		
		//Posiciona no SC6 - Pedido Venda para buscar o conteudo do campo
		//C6_RKMEN (nome produto+num cliente PS), especifico do Cliente - RMK
			dbSelectArea("SC6")
			dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			if Found()
				_cUnid   := SC6->C6_UM
				_cSCMen := ""  //espaco para mensagem do item ou complemento da descricao
			endif
		
		//Posiciona no SC9 - Pedido Liberados para verificar a Qtd liberada
		//do Produto, que devera ser informada na mensagem de retorno de benefic.
		
			dbSelectArea("SC9")
			dbSeek(xFilial("SC9")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
			if Found()
				While !eof() .and. SC9->C9_PEDIDO==SD2->D2_PEDIDO ;
						.and. SC9->C9_ITEM == SD2->D2_ITEMPV
				
						if SC9->C9_NFISCAL+SC9->C9_SERIENF == SD2->D2_DOC+SD2->D2_SERIE
						_cQtdLib := Transform(SC9->C9_QTDLIB,'@E 99,999.99')
					endif
				
					dbSkip()
				end
			endif
		
		//Posiciona no SF1/SD1 - NF Entrada - dados da nota fiscal original
			dbSelectArea("SF1")
			dbSeek(xFilial("SF1")+SD2->D2_NforI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA)
		
			_cTotal   := Transform(SD2->D2_TOTAL,"@E 999,999,999.99")
			_cEmissao := SubStr(DtoS(SF1->F1_EMISSAO),7,2)+'/'+;
				SubStr(DtoS(SF1->F1_EMISSAO),5,2)+'/'+;
				SubStr(DtoS(SF1->F1_EMISSAO),1,4)
		
		//Adiciona em Array dados referente a NF
			_cChave := SD2->D2_NforI+SD2->D2_SERIORI+SD2->D2_ITEMORI
			nP  := ASCAN(_aNfori,{|X|Substr(X[1],1,11)==_cChave} )
		
			if nP == 0
				AADD(_aNfori,{ SD2->D2_NforI   ,;            //1a. NF Original
				SD2->D2_SERIORI ,;            //2a. Serie NF Original
				SD2->D2_ITEMORI ,;            //3a. Item NF Original
				_cTotal         ,;            //4a. Total
				_cEmissao       ,;            //5a. Data Emissao NF Original
				_cSCMen        ,;             //6a. Mensagem - SC6
				_cQtdLib        ,;            //7a. Qtd Liberada - SC9
				_cUnid  } )                   //8a. Unidade Medida - SC6
			endif
		
			dbSelectArea("SD2")
		
		endif
		SD2 -> (dbSkip ())
	enddo

	if Len(_aNfori) >= 1
	
		for xi := 1 To LEn (_aNfori)
			_cMens := _cMens+if(!Empty(_aNfori[xi,6]),_aNfori[xi,6]+" - ","")+;
				"referente s/ NF "+_aNfori[xi,1]+" de "+_aNfori[xi,5]+;
				" no valor de R$"+_aNfori[xi,4]+" ("+_aNfori[xi,7]+;
				" "+_aNfori[xi,8]+"), "

		next
	endif

Return
//�������������������������������Ŀ
//�FIM DO PROGRAMA                �
//���������������������������������
