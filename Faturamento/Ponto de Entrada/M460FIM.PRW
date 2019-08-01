#include "Protheus.ch"
#include "rwmake.ch"
#Include "Topconn.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ M460FIM  ³ Autor ³ Cassiano G. Ribeiro   º Data ³15/06/2010º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ - Utilizado na Geracao da Nota Fiscal de Saida               ³±±
±±º          ³ - Ponto de entrada disparado na geracao da nota de saida.    º±±
±±º          ³ Tem por objetivo abrir tela para que o usuario informe       º±±
±±º          ³ os dados adicionais da nota: transportadora, redespacho,     º±±
±±º          ³ placa, nome do motorista, peso liquido, peso bruto, volume   º±±
±±º          ³ especie, marca, dt saida e Hr saida (estes campos serao      º±±
±±º          ³ gravados no SF2). O calculo do peso liquido e calculado      º±±
±±º          ³ automaticamente atraves da formula: D2_QUANT*B1_PESO         º±±
±±º          ³ O programa tambem abrira uma tela mostrando as mensagens     º±±
±±º          ³ padrao informados no produto, tes e pedido de vendas. Estas  º±±
±±º          ³ mensagens poderao ser alteradas, ou inserida uma nova linha  º±±
±±º          ³ por mensagem. Todas as mensagens informadas serao gravadas   º±±
±±º          ³ no arquivo SZZ (mensagens por nota)                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Alteracao feita pelo Motivo ( Descricao abaixo)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³                                                            ³±±
±±³            ³                                                            ³±±
±±³            ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M460FIM()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva Areas de Trabalho        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona SD2 - itens da nota fiscal                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula Peso Liquido da Nota de Saida a partir do peso cadastrado no produto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se necessario alterar as informacoes abaixo                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 150,10 to 420,580 DIALOG JanelaNF TITLE "Digite as Informações Necessárias"

	@ 012,010 SAY "NOTA FISCAL: "+SF2->F2_DOC	size 80,10
	@ 012,100 SAY "CLIENTE: "+_cNome            size 120,10
	@ 032,010 SAY "Cod. Transp.: "
	@ 032,115 SAY "Redesp: "
	@ 029,205 SAY "Veículo: "
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
	
//Chamada para rotina responsável por enviar as informações ao SFA - AutoVen referente ao faturamento do Pedido
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FIM DA ROTINA M460FIM          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ CADMEN   ³ Autor ³ ARM Campinas          º Data ³ dd/mm/aa º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ MSG      ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Direcionar / Edi‡Æo de Mensagens       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Alteracao feita pelo Motivo ( Descricao abaixo)            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidMsg (cVar)

	nVar := Val (cVar)
	lMsg := .T.
	ChkMsg (nVar)

Return (lMsg)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ CHKMSG   ³ Autor ³ ARM Campinas          º Data ³ dd/mm/aa º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Verifica‡Æo se existe a mensagem       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ EDMEN    ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Editar as Mensagens N.F. de Entrada    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ MONTAMSG ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Concatenar Mensagens.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaMsg ()

	aMsg [nVar] := alltrim (cLin1) + " " + alltrim (cLin2)	//
	Close (oDlg2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ LIMPAMSG ³ Autor ³ ARM Campinas          º Data ³ dd/mm/aa º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Limpar Mensagens.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LimpaMsg ()

	aMsg [nVar] := space (500)
	Close (oDlg2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ GRAVMEN  ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³CARREGAMSG³ Autor ³ ARM Campinas          º Data ³ dd/mm/aa º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Recuperar as mensagens informados no   ³±±
±±³            ³ TES, nos Produtos e nos Pedidos de Venda.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FIM DO PROGRAMA                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
