#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200VAR   ºAutor  ³ Paulo Romualdo     º Data ³  16/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O ponto de entrada F200VAR do CNAB a receber sera executadoº±±
±±º          ³ apos carregar os dados do arquivo de recepcao bancaria e   º±±
±±º          ³ sera utilizado para alterar os dados recebidos.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
User Function F200VAR()
	local	aArea		:=	GetArea()
	local	aAreaSE1	:=	SE1->(GetArea())
	local	aAreaSE5	:=	SE5->(GetArea())
	local	aAreaSEA	:=	SEA->(GetArea())
	local	aAreaPAC	:=	PAC->(GetArea())
	local	xnValSolBx	:=	0
	local	cNatDOCTED	:=	GETMV("MB_NATDOCT")
	local	cCtaDOCTED	:=	GETMV("MB_CTADOCT")
	local	xcOcorren	:=	''

	if !ExisteSx6("MB_SOLICBX")
		CriarSX6("MB_SOLICBX", "N", "Valor baixa solicitada",2.17 )
	endif

	xnValSolBx	:=	superGetMV("MB_SOLICBX", ,2.17)
	xcOcorren	:=	allTrim(PARAMIXB[01,14])

/*
			//?????????????????
			//?o array aValores ir? permitir ?
			//?que qualquer exce??o ou neces-?
			//?sidade seja tratado no ponto  ?
			//?de entrada em PARAMIXB        ?
			//?????????????????
			// Estrutura de aValores
			//	Numero do T?ulo	- 		01
			//	data da Baixa		- 	02
			// Tipo do T?ulo		- 	03
			// Nosso Numero		- 		04
			// Valor da Despesa	- 		05
			// Valor do Desconto	- 	06
			// Valor do Abatiment- 		07
			// Valor Recebido    - 		08
			// Juros					09
			// Multa					10
			// Valor do Credito	- 		11
			// Data Credito		- 		12
			// Ocorrencia			- 	13
			// Linha Inteira		- 	14

*/


	SE1->(DbSetOrder(16)) && E1_FILIAL+E1_IDCNAB
	if SE1->(DbSeek(xFilial("SE1") + PARAMIXB[01,01]))

		if SE1->E1_ZZTXBOL > 0 .AND. nValRec > 0

			SEA->(DbSetOrder(1)) && EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
			if SEA->(DbSeek(xFilial("SEA")+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA)))

				Begin Transaction

					&& Movimentacao bancaria a receber
					Reclock("SE5",.T.)
					SE5->E5_FILIAL		:= xFilial("SE5")
					SE5->E5_BANCO 		:= SEA->EA_PORTADO
					SE5->E5_AGENCIA		:= SEA->EA_AGEDEP
					SE5->E5_CONTA		:= SEA->EA_NUMCON
					SE5->E5_VALOR		:= SE1->E1_ZZTXBOL
					SE5->E5_RECPAG		:= "R"
					SE5->E5_HISTOR		:= "Taxa de boleto - " + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
					SE5->E5_DTDIGIT		:= dDatabase
					SE5->E5_DATA		:= dDatabase
					SE5->E5_NATUREZ		:= cNatDOCTED
					SE5->E5_TIPODOC   	:= ""
					SE5->E5_CREDITO		:= cCtaDOCTED
					SE5->E5_CCC			:= ""
					SE5->E5_DTDISPO		:= dDatabase
					SE5->E5_RATEIO		:= 'N'
					SE5->E5_FILORIG		:= xFilial("SE5")
					SE5->(MsUnlock())

					&& Atualiza saldo bancario
					AtuSalBco( SEA->EA_PORTADO, SEA->EA_AGEDEP, SEA->EA_NUMCON, PARAMIXB[01,13], SE1->E1_ZZTXBOL	, "+" )

					nValRec -= SE1->E1_ZZTXBOL

					if nValRec < SE1->E1_SALDO
						if (( SE1->E1_SALDO - nValRec ) < 1) .AND. (nDescont <> SE1->E1_SALDO - nValRec)
							nDescont +=SE1->E1_SALDO - nValRec
						endif
					endif
					//Tratamento para juros
					if nValRec > SE1->E1_SALDO
						if ( nValRec - SE1->E1_SALDO) < 1  .AND. (nJuros <> nValRec - SE1->E1_SALDO)
							nJuros += nValRec - SE1->E1_SALDO
						endif
					endif

				end Transaction

			endif

		endif

		if PAC->(dbSeek(xFilial('PAC') + '46' + xcOcorren))
			Reclock("SE1",.F.)
			//Altera o Histórico do Título
			if Empty(SE1->E1_HIST)
				SE1->E1_HIST	:=	allTrim(PAC->PAC_TXT01)
			else
				SE1->E1_HIST	:=	allTrim(SE1->E1_HIST) + ' - ' + allTrim(PAC->PAC_TXT01)
			endif

			if PAC->PAC_VLR01 > 0
				SE1->E1_ACRESC	+=	PAC->PAC_VLR01
				SE1->E1_SDACRES	+=	PAC->PAC_VLR01
			endif

			if PAC->PAC_VLR02 > 0
				SE1->E1_DECRESC	+=	PAC->PAC_VLR02
				SE1->E1_SDDECRE	+=	PAC->PAC_VLR02
			endif

			if alltrim(PAC->PAC_TXT02) == '0'
				SE1->E1_SITUACA := allTrim(PAC->PAC_TXT02)
				SE1->E1_PORTADO := ''
				SE1->E1_AGEDEP := ''
				SE1->E1_CONTA := ''
				SE1->E1_NUMBCO := ''
				SE1->E1_IDCNAB := ''
				SE1->E1_NUMBOR := ''
			endif

			SE1->(MsUnlock())
		endif
	endif

	SEA->(RestArea(aAreaSEA))
	SE5->(RestArea(aAreaSE5))
	SE1->(RestArea(aAreaSE1))
	PAC->(RestArea(aAreaPAC))
	RestArea(aArea)
Return
