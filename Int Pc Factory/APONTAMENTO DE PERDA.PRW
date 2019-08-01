  /*		 		ElseIf TRB->TRB_TRANSA == 2 .AND. TRB->TRB_QTDADE >0

			   	cFilial := TRB_FILIAL
			   	cOp     := TRB_OP//"03099301001  "//TREC->IDOutProdEv
				 	cOper   := TRB_OPERAC//"02"
				 	cProd   := TRB_PROD//"MSA01010065000 "//TREC->WODetCode
				 	cRecurso:= TRB_RECURS//"14A"//TREC->ResourceCode
				 	dDtApont:= STOD(DTOS(TRB_DTAPON))//"20120711"//TREC->DtTimeStamp
				 	dDataIni:= TRB_DATINI//"20120711"//TREC->ShiftDTStart    //Verificar Regra
				 	dDataFim:= TRB_DATFIM//"20120711"//TREC->ShiftDTEnd   
				 	nHoraIni:= TRB_HORINI//"14:00"//TREC->ShiftDTStart    //Verificar Regra
				 	nHoraFim:= TRB_HORFIM//"14:10"//TREC->ShiftDTFim
				 	cTempo  := nHoraFim-nHoraIni                                                 
				 	nQtdOri := TRB_QTDADE//10//alltrim(str(TREC->Qty))
				 	//cOperado:= "000001"TREC->UserCode
					
					nCountP := 1
					dDataFec   := GetMV("MV_ULMES")	
					If dDataFec >= dDataBase
						Help ( " ", 1, "FECHTO" )
						Return Nil
					EndIf

					Private aHeader[0]	
					Private aCols	:= {}

					nUsado :=0


					aCab :={ {"BC_OP"      , cOP      ,Nil},;
							 {"BC_PRODUTO" , cProd    ,Nil } ,;
							 {"BC_OPERAC"  , cOper    ,Nil } ,;
							 {"BC_RECURSO" , cRecurso ,Nil } }				 	 

	
					cOP			:= cOp//SH6->H6_OP
					cProduto	:= cProd//SH6->H6_PRODUTO
					cOperacao	:= cOper//SH6->H6_OPERAC
					cRecurso	:= cRecurso//SH6->H6_RECURSO
					
					SX3->(dbSetOrder(1))
					SX3->(dbSeek("SBC"))
					Do While SX3->(!Eof()) .and. (SX3->X3_ARQUIVO == "SBC")
						If	X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. AllTrim(SX3->X3_CAMPO) <> "BC_OP" .and. AllTrim(SX3->X3_CAMPO) <> "BC_OPERAC" .and. AllTrim(SX3->X3_CAMPO) <> "BC_RECURSO" .and. AllTrim(SX3->X3_CAMPO) <> "BC_NUMSEQ" .and. AllTrim(SX3->X3_CAMPO) <> "BC_SEQSD3"
							nUsado++
							cValid := Rtrim(SX3->X3_valid)
							AADD(aHeader,{TRIM(X3Titulo()), SX3->X3_campo, SX3->X3_picture,SX3->X3_tamanho, SX3->X3_decimal, cValid,SX3->X3_usado, SX3->X3_tipo, SX3->X3_arquivo, SX3->X3_context })
						EndIf
						SX3->(dbSkip())
					Enddo
					nAuxiliar := nUsado+1
					
					aCols := Array(nCountP,nUsado+1)
			
					For nW := 1 to nCountP
	
		
						dbSelectArea("SX3")
						dbSeek( "SBC" )
						nUsado:=0
						While !EOF() .And. (x3_arquivo == "SBC")
							IF X3USO(x3_usado) .AND. cNivel >= x3_nivel  .And. !(AllTrim(x3_campo)$"BC_OP") .And. !(AllTrim(x3_campo)$"BC_OPERAC") .And. !(AllTrim(x3_campo)$"BC_RECURSO") .And. !(AllTrim(x3_campo)$"BC_NUMSEQ")  .And. !(AllTrim(x3_campo) == "BC_SEQSD3")
								nUsado++
								IF x3_tipo == "C"
									aCOLS[nW][nUsado] := SPACE(x3_tamanho)
								ELSEIF x3_tipo == "N"
									aCOLS[nW][nUsado] := 0
								ELSEIF x3_tipo == "D"
									aCOLS[nW][nUsado] := CTOD("  /  /  ")
								ELSEIF x3_tipo == "M"
									aCOLS[nW][nUsado] := ""
								ELSE
									aCOLS[nW][nUsado] := .F.
								Endif
								If x3_context == "V"
									aCols[nW][nUsado] := CriaVar(alltrim(x3_campo))
								Endif
							Endif
							dbSkip()
						EndDo
						

						aItens:= {{"BC_PRODUTO" ,cProd,NIL},;
									 {"BC_TIPO"    ,'R' ,Nil},;
									 {"BC_MOTIVO"  , 'FH',Nil},;
									 {"BC_CODDEST" ,cprod ,Nil},;
									 {"BC_LOCAL"   , '04',Nil},; //B1_ZZREFUG
									 {"BC_QTDDEST" ,nQtdOri ,Nil},;
									 {"BC_DATA"    ,dDtApont ,Nil},;
									 {"BC_QUANT"   ,nQtdOri ,Nil}} 


						aCOLS[nW][nAuxiliar] := .F.	
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_PRODUTO" } )]		:= cProd//SH6->H6_PRODUTO
						SB1->(dbSetOrder(1))
						If SB1->(dbSeek( xFilial("SB1") + cProd ))
							aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCORIG" } )]	:= SB1->B1_LOCPAD
						Endif	
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_TIPO" } )]		:= "R"
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_MOTIVO" } )] 		:= "FH"
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_DESCRI" } )] 		:= "Teste"
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_QUANT" } )] 		:= nQtdOri//nQtdPerda //SH6->H6_QTDPERD / nCountP
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_CODDEST" } )] 	:= cProd//SH6->H6_PRODUTO
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCAL" } )] 		:= "04"
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_QTDDEST" } )] 	:= nQtdOri//nQtdPerda //SH6->H6_QTDPERD
						aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_DATA" } )] 		:= dDtApont//SH6->H6_DTAPONT
				//		aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOTECTL" } )] 	:= SH6->H6_LOTECTL
				//		aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_DTVALID" } )] 	:= SH6->H6_DTVALID		&&CTOD("31/12/2010")
				//		aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCALIZ" } )] 	:= cLocaliz				&& ORIGEM  - Endereco com Ariette
				 //		aCOLS[nW][Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCDEST" } )] 	:= '99.B3'				&& DESTINO - Endereco com Ariette
					
					Next nW

					aCab   :={}
					aItens :={}
					
					Aadd(aCab, {"BC_OP"      , cOP      ,Nil } )
					Aadd(aCab, {"BC_PRODUTO" , cProduto ,Nil } )
					Aadd(aCab, {"BC_OPERAC"  , cOperacao,Nil } )
					Aadd(aCab, {"BC_RECURSO" , cRecurso ,Nil } )
	
					For nCont := 1 to Len(aCols)          
						If aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_QUANT" } )] > 0 && Andre Lopes - Retirar quantidades com Zero.
							Aadd(aItens, {	{"BC_PRODUTO" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_PRODUTO" } )],Nil},;
											{"BC_TIPO"    , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_TIPO" } )]   ,Nil},;
											{"BC_MOTIVO"  , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_MOTIVO" } )] ,Nil},;
											{"BC_DESCRI"  , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_DESCRI" } )] ,Nil},;
											{"BC_QUANT"   , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_QUANT" } )]  ,Nil},;
											{"BC_CODDEST" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_CODDEST" } )],Nil},;
											{"BC_LOCAL"   , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCAL" } )]  ,Nil},;
											{"BC_QTDDEST" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_QTDDEST" } )],Nil},;
											{"BC_DATA"    , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_DATA" } )]   ,Nil},;
											{"BC_LOTECTL" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOTECTL" } )],Nil},;
											{"BC_DTVALID" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_DTVALID" } )],Nil},;
											{"BC_LOCALIZ" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCALIZ" } )],Nil},;
											{"BC_LOCDEST" , aCols[nCont,Ascan( aHeader, { |x| Alltrim(x[2]) == "BC_LOCDEST" } )],Nil}} )
						Endif
					Next
	
											
					lMsErroAuto := .F.
					MsExecAuto({|x,y|MATA685(x,y)},aCab,aItens)
					
					If lMsErroAuto
						
	
	            	cNomArqErro := NomeAutoLog()
	   				IF (nHandle := FOPEN(cNomArqErro)) >= 0
							// Pega o tamanho do arquivo
		   		   	nLength := FSEEK(nHandle, 0, FS_END)                                                    
		   				fSeek(nHandle,0,0)
						   cString := FREADSTR(nHandle, nLength)
	   					FCLOSE(nHandle)                     
	   				Endif 
	   				//ALERT(cString)
	   				FERASE(cNomArqErro)
		   	      DbSelectArea("SC2")  
			         DbSetOrder(1)
			         If DbSeek(xFilial("SC2")+TRB->TRB_OP,.f.)
				  	      RecLock("SC2",.f.)
				    		Replace SC2->C2_ZZSTAT With "3"
				    		Replace SC2->C2_ZZDTENV With dDataBase
				    		Replace SC2->C2_ZZLOGPF With cString
				    		MsUnlock()
			    		Endif      			                     
			    	   U_EnvMail(5)
	  				Else
						Reclock("TRB",.F.)
						Replace TRB_STATUS with "2"
						MsUnLock()
		   	      DbSelectArea("SC2")  
			         DbSetOrder(1)
			         If DbSeek(xFilial("SC2")+TRB->TRB_OP,.f.)
				  	      RecLock("SC2",.f.)
				    		Replace SC2->C2_ZZSTAT With "1"
				    		Replace SC2->C2_ZZDTENV With dDataBase
				    		MsUnlock()
			    		Endif
				 
			      Endif
		 		Endif		*/