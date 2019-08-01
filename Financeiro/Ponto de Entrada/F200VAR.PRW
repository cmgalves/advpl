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
	Local aArea			:= GetArea()
	Local aAreaSE1		:= SE1->(GetArea())
	Local aAreaSE5		:= SE5->(GetArea())
	Local aAreaSEA		:= SEA->(GetArea()) 
	Local	cNatDOCTED:=GETMV("MB_NATDOCT") 
	Local	cCtaDOCTED:=GETMV("MB_CTADOCT")
					
	SE1->(DbSetOrder(16)) && E1_FILIAL+E1_IDCNAB
	If SE1->(DbSeek(xFilial("SE1")+PARAMIXB[01,01]))
	   /*	IF SE1->E1_NUM = '000007509'
			alert()
		endif */
		
		If SE1->E1_ZZTXBOL > 0 .AND. nValRec > 0 
		
			SEA->(DbSetOrder(1)) && EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
			If SEA->(DbSeek(xFilial("SEA")+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA)))
	
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
						//SE5->E5_NATUREZ		:= "0701010101"  
					 	//SE5->E5_NATUREZ		:= "01.08009"  
					 	SE5->E5_NATUREZ		:= cNatDOCTED
					 	SE5->E5_TIPODOC   	:= ""
						SE5->E5_CREDITO		:= cCtaDOCTED
						SE5->E5_CCC			:= ""
						SE5->E5_DTDISPO		:= dDatabase
						//SE5->E5_DTDISPO		:= PARAMIXB[01,13]
						SE5->E5_RATEIO		:= 'N'
						SE5->E5_FILORIG		:= xFilial("SE5")				
					SE5->(MsUnlock())

					&& Atualiza saldo bancario				
					AtuSalBco( SEA->EA_PORTADO, SEA->EA_AGEDEP, SEA->EA_NUMCON, PARAMIXB[01,13], SE1->E1_ZZTXBOL	, "+" )
										                                                                                                           
					nValRec -= SE1->E1_ZZTXBOL  
	
					If nValRec < SE1->E1_SALDO
						If (( SE1->E1_SALDO - nValRec ) < 1) .AND. (nDescont <> SE1->E1_SALDO - nValRec)
							nDescont +=SE1->E1_SALDO - nValRec
						Endif
					Endif
					//Tratamento para juros
					If nValRec > SE1->E1_SALDO	
						If ( nValRec - SE1->E1_SALDO) < 1  .AND. (nJuros <> nValRec - SE1->E1_SALDO)
							nJuros += nValRec - SE1->E1_SALDO
						Endif
					Endif

	            End Transaction                                                                                               
	            
			EndIf		
				
		EndIf
		
	EndIf	            
	
	SEA->(RestArea(aAreaSEA))
	SE5->(RestArea(aAreaSE5))
	SE1->(RestArea(aAreaSE1))
	RestArea(aArea)		
Return
