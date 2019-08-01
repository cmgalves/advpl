#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH" 

User Function PMOMSR001() 
	Local oReport 

	If TRepInUse() //verifica se relatorios personalizaveis esta disponivel 
		//Pergunte("MTR025",.F.) 

		oReport := ReportDef() 
		oReport:PrintDialog()  
	EndIf 
Return      

/*Defini Layout do formulário*/
Static Function ReportDef() 
	Local oReport 
	Local oCabec 
	Local oDetalhe 

	oReport := TReport():New("PMOMSR001","Romaneio de cargas",{||Pergunta()},{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir o romaneioo  conforme os parametrossolicitados.") 

	oCabec := TRSection():New(oReport,"Cabec",nil) 
	oCabec:SetHeaderSection(.F.)
	TRCell():New(oCabec,"Coluna1",nil,nil,nil,50) 



	oDetalhe := TRSection():New(oCabec,"Detalhe",nil)  
	oDetalhe:SetHeaderSection(.F.)
	TRCell():New(oDetalhe,"Coluna1",nil,nil,nil,100) 
	TRCell():New(oDetalhe,"Coluna2",nil,nil,nil,50)   

	oNota :=  TRSection():New(oCabec,"Nota",nil)  
	oNota:SetHeaderSection(.F.)
	TRCell():New(oNota,"Coluna1",nil,nil,nil,100)                                                  


Return oReport   

/*Imprime infomarcao*/                                    
Static Function PrintReport(oReport) 
	Local oCabec   := oReport:Section(1) 
	Local oDetalhe := oReport:Section(1):Section(1) 
	Local oNota    := oReport:Section(1):Section(2) 
	Local nCont          
	Local cCod := ""
	Local aEndereco := {}   
	Local aEndEntrega := {}
	Local aTransp :={}      
	Local oFont12	:= TFont():New("Courier New", 09, 14,, .F.,,,,, .F., .F.)    
	Local oFont12a	:= TFont():New("Courier New", 12, 12,, .F.,,,, .T., .F.)
	Local oOldFont := oReport:oFontBody
	Local nCont1   :=0


	BeginSql Alias "TDAK"  
		SELECT  * FROM %Table:DAK% DAK 
		INNER JOIN %Table:DAI% DAI ON DAI.DAI_FILIAL = DAK.DAK_FILIAL AND
		DAI.DAI_COD    = DAK.DAK_COD    AND
		DAI.DAI_SEQCAR = DAK.DAK_SEQCAR AND 
		DAI.DAI_NFISCA     != ' ' 	  AND
		DAI.%notDel%
		WHERE DAK.DAK_FILIAL = %xFilial:DAK% AND 
		DAK.DAK_COD between %exp:MV_PAR01% AND %exp:MV_PAR02% and 
		DAK.DAK_MOTORI between %exp:MV_PAR03% and %exp:MV_PAR04% and
		DAK.%notDel%
		Order by DAK.DAK_COD asc                                                                  

	endSql          
	TCSetField("TDAK","DAK_DATA","D")      
	TCSetField("TDAK","DAK_DTACCA","D")      
	TCSetField("TDAK","DAK_DATENT","D")      

	Count to nCont
	oReport:SetMeter(nCont)
	TDAK->(dbGotop())


	While TDAK->(!Eof()) 

		If oReport:Cancel() 
			Exit 
		EndIf 
		if cCod != DAK->DAK_COD
			if oReport:nMeter >= 1  
				// oCabec:Finish() 
				oReport:EndPage()
			endif
			oReport:incMeter()
			cCod := DAK->DAK_COD
			oCabec:Init()  
			oCabec:Cell("Coluna1"):oFontBody := oFont12a    
			oCabec:Cell("Coluna1"):SetValue("Nº da Carga:"+allTrim(TDAK->DAK_COD))
			oCabec:PrintLine()
			oReport:SkipLine() 
			oCabec:Cell("Coluna1"):SetValue("Data de Expedição: "+dtoC(TDAK->DAK_DATA))
			oCabec:PrintLine()
			oReport:SkipLine() 
			oCabec:Cell("Coluna1"):SetValue("Cubagem: "+AllTrim(Transform(CalCubTotal(TDAK->DAK_COD),"@E 9999,999.999")))
			oCabec:PrintLine()
			oReport:SkipLine()  
			oCabec:Cell("Coluna1"):SetValue("Qtd. de pedidos: "+countPedido(TDAK->DAK_COD, TDAK->DAK_SEQCAR))
			oCabec:PrintLine()
			oReport:SkipLine() 
			oCabec:Cell("Coluna1"):SetValue("Placa do Caminhão: "+posicione("DA3",1,xFilial("DA3")+TDAK->DAK_CAMINH,"DA3_PLACA"))
			oCabec:PrintLine()
			oReport:SkipLine()  
			oCabec:Cell("Coluna1"):SetValue("Motorista: "+posicione("DA4",1,xFilial("DA4")+TDAK->DAK_MOTORI,"DA4_NOME"))
			oCabec:PrintLine()
			oReport:SkipLine()   
			oCabec:Cell("Coluna1"):SetValue("Data da Saída: "+dtoc(TDAK->DAK_DATENT))
			oCabec:PrintLine()  
			oReport:SkipLine()
			oCabec:Cell("Coluna1"):SetValue("Lacre:______________________________________")
			oCabec:PrintLine()  
			oReport:SkipLine()
			oReport:ThinLine() 
			oCabec:Finish()
		endif
		nCont1 := nCont1 + 1
		If nCont1 == 3
			oReport:EndPage(.F.)
			oReport:EvalBreak(.T.,.F.,oDetalhe)
			nCont1 := 0
		EndIf
		oDetalhe:init()
		aEndereco  := getEndereco("L")     
		aEndEntrega:= getEndereco("E")
		aTransp	   := getTrasnp()
		oDetalhe:Cell("Coluna1"):oFontBody := oFont12a    
		oDetalhe:Cell("Coluna2"):oFontBody := oFont12a    

		oDetalhe:Cell("Coluna1"):Setvalue(TDAK->DAI_CLIENTE+"-"+TDAK->DAI_LOJA+" "+SubStr(AllTrim(posicione("SA1",1,xFilial("SA1")+TDAK->DAI_CLIENTE+TDAK->DAI_LOJA,"A1_NREDUZ"))+"-"+AllTrim(posicione("SA1",1,xFilial("SA1")+TDAK->DAI_CLIENTE+TDAK->DAI_LOJA,"A1_NOME")),1,60))
		oDetalhe:Cell("Coluna2"):SetValue(aTransp[1]+"-"+AllTrim(aTransp[1])) 
		oDetalhe:PrintLine()
		oReport:SkipLine()
		oDetalhe:Cell("Coluna1"):Setvalue("End:"+aEndereco[1])
		oDetalhe:Cell("Coluna2"):SetValue("End:"+aTransp[2]) 
		oDetalhe:PrintLine()                                     
		oReport:SkipLine()
		oDetalhe:Cell("Coluna1"):Setvalue("Bairro:"+aEndereco[2])
		oDetalhe:Cell("Coluna2"):Setvalue("Bairro:"+aTransp[3])
		oDetalhe:PrintLine()
		oReport:SkipLine()
		oDetalhe:Cell("Coluna1"):Setvalue("Cidade:"+aEndereco[3]+" Estado:"+aEndereco[4])
		oDetalhe:Cell("Coluna2"):Setvalue("Cidade:"+aTransp[4]+" Estado:"+aTransp[5])
		oDetalhe:PrintLine()
		oReport:SkipLine()

		If Len(aEndEntrega)== 0
			oDetalhe:Cell("Coluna1"):Setvalue("Loc. Entrega: O Mesmo")
			oDetalhe:Cell("Coluna2"):Setvalue("Telefone:"+aTransp[7]+"-"+aTransp[8])
			oDetalhe:PrintLine()   
			oReport:SkipLine()
			oDetalhe:Cell("Coluna1"):Setvalue("")
			oDetalhe:Cell("Coluna2"):Setvalue("Nextel:"+aTransp[9])
			oDetalhe:PrintLine()
			oReport:SkipLine()
		else
			oDetalhe:Cell("Coluna1"):Setvalue("Loc. Entrega:")                  
			oDetalhe:Cell("Coluna2"):Setvalue("Telefone:"+aTransp[7]+"-"+aTransp[8])
			oDetalhe:PrintLine()                                                    
			oReport:SkipLine()
			oDetalhe:Cell("Coluna1"):Setvalue(aEndEntrega[1]+"-"+aEndEntrega[2])
			oDetalhe:Cell("Coluna2"):Setvalue("Nextel:"+aTransp[9])
			oDetalhe:PrintLine()
			oReport:SkipLine()
			oDetalhe:Cell("Coluna1"):Setvalue(aEndEntrega[3]+"-"+aEndEntrega[4])
			oDetalhe:Cell("Coluna2"):Setvalue("")
			oDetalhe:PrintLine()
			oReport:SkipLine()
		endif	
		oDetalhe:Finish()

		oReport:SkipLine()
		oReport:SkipLine()

		oNota:Cell("Coluna1"):oFontBody := oFont12    
		//oNota:Cell("Coluna1"):SetAlign("CENTER")
		oNota:init()    
		oNota:Cell("Coluna1"):Setvalue("NF: "+AllTrim(TDAK->DAI_NFISCA)+"/"+AllTrim(TDAK->DAI_SERIE)+Replicate(" ",10)+cValToChar(Posicione("SF2",2,xFilial("SF2")+TDAK->DAI_CLIENTE+TDAK->DAI_LOJA+TDAK->DAI_NFISCA+TDAK->DAI_SERIE,"F2_VOLUME1"))+" Volume(s)    Peso Bruto:"+Transform(Posicione("SF2",2,xFilial("SF2")+TDAK->DAI_CLIENTE+TDAK->DAI_LOJA+TDAK->DAI_NFISCA+TDAK->DAI_SERIE,"F2_PBRUTO"),"@E 999999.9999")+" Cubagem:"+AllTrim(TransForm(CalVol(TDAK->DAI_NFISCA,TDAK->DAI_SERIE),"@E 9999,999.999")))  
		oNota:PrintLine()
		oReport:SkipLine()                                              
		oNota:Cell("Coluna1"):Setvalue("Nosso Pedido: "+AllTrim(TDAK->DAI_PEDIDO))
		oNota:PrintLine()
		oReport:SkipLine()                                              
		oNota:Cell("Coluna1"):Setvalue("Chave:"+Posicione("SF2",2,xFilial("SF2")+TDAK->DAI_CLIENTE+TDAK->DAI_LOJA+TDAK->DAI_NFISCA+TDAK->DAI_SERIE,"F2_CHVNFE"))
		oNota:PrintLine()
		oReport:SkipLine()                                              
		oReport:SkipLine() 
		oNota:Cell("Coluna1"):Setvalue("Transportadora:_______________________________________________________________")
		oNota:PrintLine()


		oNota:finish()
		//oReport:oFontBody := oOldFont
		oReport:SkipLine()
		oReport:SkipLine()

		oReport:ThinLine() 



		TDAK->(DbSkip())
	End   
	oCabec:Finish()            
	TDAK->(dbCloseArea())
Return   

Static Function getEndereco(cTipo)
	Local aEndereco := {}

	if cTipo =="L"
		SA1->(dbSetOrder(1))
		if SA1->(dbSeek(xFilial("SA1")+TDAK->DAI_CLIENT+TDAK->DAI_LOJA))
			aadd(aEndereco,AllTrim(SA1->A1_END))
			aadd(aEndereco,AllTrim(SA1->A1_BAIRRO))
			aadd(aEndereco,AllTrim(SA1->A1_MUN))
			aadd(aEndereco,AllTrim(SA1->A1_EST))
			aadd(aEndereco,Transform(AllTrim(SA1->A1_CEP),"@R 99999-999"))
		endif                                                            
	else 
		SA1->(dbSetOrder(1))
		if SA1->(dbSeek(xFilial("SA1")+TDAK->DAI_CLIENT+TDAK->DAI_LOJA))	
			if !Empty(SA1->A1_ENDENT)
				aadd(aEndereco,AllTrim(SA1->A1_ENDENT))
				aadd(aEndereco,AllTrim(SA1->A1_BAIRROE))
				aadd(aEndereco,AllTrim(SA1->A1_MUNE))
				aadd(aEndereco,AllTrim(SA1->A1_ESTE))
				aadd(aEndereco,Transform(AllTrim(SA1->A1_CEPE),"@R 99999-999"))
			endif	
		endif                                                                  
	endif


return aEndereco

Static Function getTrasnp()
	Local aTransp := {}
	SF2->(dbSetOrder(1))
	if SF2->(dbSeek(xFilial("SF2")+TDAK->DAI_NFISCA+TDAK->DAI_SERIE+TDAK->DAI_CLIENT+TDAK->DAI_LOJA))
		SA4->(dbSetOrder(1))
		if SA4->(dbSeek(xFilial("SA4")+SF2->F2_REDESP)) .AND. !Empty(SF2->F2_REDESP)      
			if Empty(SA4->A4_ZZEND)
				aadd(aTransp, AllTrim(SA4->A4_NREDUZ))		
				aadd(aTransp, AllTrim(SA4->A4_END))		
				aadd(aTransp, AllTrim(SA4->A4_BAIRRO))		
				aadd(aTransp, AllTrim(SA4->A4_MUN))		
				aadd(aTransp, AllTrim(SA4->A4_EST))		
				aadd(aTransp, AllTrim(transform(SA4->A4_CEP,"@R 99999-999")))		
				aadd(aTransp, AllTrim(SA4->A4_DDD))		
				aadd(aTransp, AllTrim(transform(SA4->A4_TEL,"@R 9999-9999")))		
				aadd(aTransp, AllTrim(SA4->A4_ZZIDNEX))
				aadd(aTransp, AllTrim(SA4->A4_COD))
			else 
				aadd(aTransp, AllTrim(SA4->A4_NREDUZ))		
				aadd(aTransp, AllTrim(SA4->A4_ZZEND))		
				aadd(aTransp, AllTrim(SA4->A4_ZZBAI))		
				aadd(aTransp, AllTrim(SA4->A4_ZZMUN))		
				aadd(aTransp, AllTrim(SA4->A4_ZZEST))		
				aadd(aTransp, AllTrim(transform(SA4->A4_ZZCEP,"@R 99999-999")))		
				aadd(aTransp, AllTrim(SA4->A4_ZZDDD2))		
				aadd(aTransp, AllTrim(transform(SA4->A4_ZZTEL2 ,"@R 9999-9999")))		
				aadd(aTransp, AllTrim(SA4->A4_ZZIDNEX))
				aadd(aTransp, AllTrim(SA4->A4_COD))

			endif		
		else 
			aadd(aTransp, "")		
			aadd(aTransp, "")		
			aadd(aTransp, "")		
			aadd(aTransp, "")		
			aadd(aTransp, "")		
			aadd(aTransp, "")		
			aadd(aTransp, "")		
			aadd(aTransp, "")
			aadd(aTransp, "")

		endif
	endif
return aTransp 

/* Pergunta */
Static function Pergunta()
	Local aParamBox := {}

	AADD(aParamBox,{1,"Carga de  ",Space(TamSx3("DAK_COD")[1]),"","","DAK","",TamSx3("DAK_COD")[1],.F.}) 
	AADD(aParamBox,{1,"Carga ate ",Space(TamSx3("DAK_COD")[1]),"","","DAK","",TamSx3("DAK_COD")[1],.F.}) 
	AADD(aParamBox,{1,"Motorista ate ",Space(TamSx3("DAK_MOTORI")[1]),"","","DA4","",TamSx3("DAK_MOTORI")[1],.F.}) 
	AADD(aParamBox,{1,"Motorista ate ",Space(TamSx3("DAK_MOTORI")[1]),"","","DA4","",TamSx3("DAK_MOTORI")[1],.F.}) 
	ParamBox(aParamBox,"Infome os parâmetros",nil,/*bOk*/, /*aButtons*/, /*lCentered*/,/*nPosx*/, /*nPosy*/, /*oMainDlg*/, /*cLoad*/"PMOMSR001", /*lCanSave*/.T., /*lUserSave*/.T.) 
return        

Static function countPedido(cCarga, cSeqCar)
	Local cRet := ""

	BeginSql Alias "CDAI"
		SELECT COUNT(*) as QTDE FROM %TABLE:DAI% WHERE DAI_FILIAL=%XFILIAL:DAI% AND DAI_COD = %EXP:cCarga% AND DAI_SEQCAR=%EXP:cSeqCar% and %notDel%

	endSql
	cRet := cValToChar(CDAI->QTDE)
	CDAI->(dbCloseArea())
return cRet

Static Function CalVol(cNota,cSerie)       
	Local nCubagem := 0

	dbSelectArea("SC9")  
	SC9->(dbSetOrder(6))
	if SC9->(dbSeek(xFilial("SC9")+cSerie+cNota))
		While SC9->(!EOF()) .AND. SC9->C9_NFISCAL == cNota .and. SC9->C9_SERIENF == cSerie 
			nCubagem += U_MBCALCUB(SC9->C9_PRODUTO,SC9->C9_QTDLIB,.t.)
			SC9->(dbSkip())	
		endDo	

	endif

return nCubagem


Static Function CalCubTotal(cCarga)
	Local nCubTotal := 0   
	Local cQuery 	:= ""

	cQuery :="SELECT DAI_NFISCA, DAI_SERIE FROM "+RetSqlName("DAI")+ " WHERE DAI_COD = '"+cCarga+"' AND D_E_L_E_T_=''" 
	TcQuery cQuery New Alias 'TCUB' 

	While TCUB->(!EOF())
		nCubTotal += CalVol(TCUB->DAI_NFISCA,TCUB->DAI_SERIE) 

		TCUB->(dbSkip())
	endDO


	TCUB->(dbCloseArea())

return nCubTotal


