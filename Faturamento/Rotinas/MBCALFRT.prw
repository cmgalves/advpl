#Include "RWMAKE.CH"

User Function MBCALFRT(nC6_ZPrcUni)
	Local aArea    		:= GetArea()
	Local aAreaSA1 		:= SA1->(GetArea())
	Local aAreaSZ1 		:= SZ1->(GetArea())
	Local aAreaSZ3 		:= SZ3->(GetArea())
   
    Local nPerFrete     := 0            
    Local nValFrete     := 0
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo de Frete = CIF                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If M->C5_TPFRETE == 'C'
		
		&& Porcetagem de frete			            
   	   	SZ1->(DbSetOrder(1)) && Z1_FILIAL+Z1_COD
	   	If SZ1->(DbSeek(xFilial("SZ1")+SA1->A1_ZZSITLL))       
	  		nPerFrete := SZ1->Z1_PERFRET       	
   		EndIf

		&& UF X % de Frete
			If nPerFrete == 0
				SX5->(dbSetOrder(1))
				If SX5->(dbSeek(xFilial("SX5")+"ZY"+SA1->A1_EST))
					nPerFrete := Val(X5Descri())				
				EndIf				
			EndIf
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo de Frete MB = REDESPACHO                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If M->C5_FRETEMB == '1'								
			&& Porcetagem de frete							
			SZ3->(DbSetOrder(1)) && Z3_FILIAL+Z3_TPFRETE+Z3_FRETEMB
			If SZ3->(DbSeek(xFilial("SZ3")+M->C5_TPFRETE+M->C5_FRETEMB))
				nPerFrete += SZ3->Z3_PERFRET				    
			EndIf
		EndIf 
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo de Frete = FOB                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo de Frete MB = REDESPACHO                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If M->C5_FRETEMB == '1' .AND. AllTrim(GetMv("MV_ZZFRELL")) == 'S'
					
			&& Porcetagem de frete			            
   		   	SZ1->(DbSetOrder(1)) && Z1_FILIAL+Z1_COD
       	   	If SZ1->(DbSeek(xFilial("SZ1")+SA1->A1_ZZSITLL))       
				nPerFrete := SZ1->Z1_PERFRET       	
	   	    EndIf

			If nPerFrete == 0
				&& Porcetagem de frete							
				SZ3->(DbSetOrder(1)) && Z3_FILIAL+Z3_TPFRETE+Z3_FRETEMB
				If SZ3->(DbSeek(xFilial("SZ3")+M->C5_TPFRETE+M->C5_FRETEMB))                                            
					nPerFrete := SZ3->Z3_PERFRET				    
				EndIf
			Endif
				
		EndIf 
			
	EndIf			
	
	nPerFrete := (100-nPerFrete) / 100
	nValFrete := nC6_ZPRCUNI / nPerFrete
					
Return(nValFrete)