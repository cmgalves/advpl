#include "protheus.ch"
#include "msobjects.ch"     
#include "topconn.ch"     
#include "rwmake.ch"
#INCLUDE "OLECONT.CH"
#include "tbiconn.ch"
#Include "Fileio.ch"   
#INCLUDE "COLORS.CH" 

User Function MBMARKESTO()
Local aCampos := {}
Local nRecno := Recno()
Private cString := "SF2"
cREQEST :=Alltrim(GetMv("MB_REQEST"))

	cPerg  := "MBMARKEST1"
	cOrdem := cPerg+"01"
	If ! ( SX1->(DbSeek(cOrdem)) )
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "01"
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_VALID   := ""
		SX1->X1_TAMANHO := 13
		SX1->X1_PERGUNT := "Da O.P. :"
		SX1->X1_VARIAVL := "mv_ch1"
		SX1->X1_TIPO    := "C"
		SX1->X1_GSC     := "G"
		SX1->X1_VAR01   := "mv_par01"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		SX1->X1_F3      := "SC2"
	Endif   

	cOrdem := cPerg+"02"
	If ! ( SX1->(DbSeek(cOrdem)) )
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "02"
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_VALID   := ""
		SX1->X1_TAMANHO := 13
		SX1->X1_PERGUNT := "Até a O.P. :"
		SX1->X1_VARIAVL := "mv_ch2"
		SX1->X1_TIPO    := "C"
		SX1->X1_GSC     := "G"
		SX1->X1_VAR01   := "mv_par02"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		SX1->X1_F3      := "SC2"
	Endif   

	cOrdem := cPerg+"03"	
	If ! ( SX1->(DbSeek(cOrdem)) )
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "03"
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_VALID   := ""
		SX1->X1_TAMANHO := 3
		SX1->X1_PERGUNT := "Da T.M.:"
		SX1->X1_VARIAVL := "mv_ch3"
		SX1->X1_TIPO    := "C"
		SX1->X1_GSC     := "G"
		SX1->X1_VAR01   := "mv_par03"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		SX1->X1_F3      := "SF5PCF"
	Endif  	
		
	cOrdem := cPerg+"04"	
	If ! ( SX1->(DbSeek(cOrdem)) )
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "04"
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_VALID   := ""
		SX1->X1_TAMANHO := 3
		SX1->X1_PERGUNT := "Até a T.M.:"
		SX1->X1_VARIAVL := "mv_ch4"
		SX1->X1_TIPO    := "C"
		SX1->X1_GSC     := "G"
		SX1->X1_VAR01   := "mv_par04"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		SX1->X1_F3      := "SF5PCF"
	Endif  	

	cOrdem := cPerg+"05"	
	If ! ( SX1->(DbSeek(cOrdem)) )
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "05"
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_VALID   := ""
		SX1->X1_TAMANHO := 8
		SX1->X1_PERGUNT := "Da Data:"
		SX1->X1_VARIAVL := "mv_ch5"
		SX1->X1_TIPO    := "D"
		SX1->X1_GSC     := "G"
		SX1->X1_VAR01   := "mv_par05"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		SX1->X1_F3      := ""
	Endif  	
		
	cOrdem := cPerg+"06"	
	If ! ( SX1->(DbSeek(cOrdem)) )
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "06"
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_VALID   := ""
		SX1->X1_TAMANHO := 8
		SX1->X1_PERGUNT := "Até a Data:"
		SX1->X1_VARIAVL := "mv_ch6"
		SX1->X1_TIPO    := "D"
		SX1->X1_GSC     := "G"
		SX1->X1_VAR01   := "mv_par06"
		SX1->X1_DEF01   := ""
		SX1->X1_DEF02   := ""
		SX1->X1_F3      := ""
	Endif  	


	
If Pergunte(cPerg,.t.)
	cQueryA :="UPDATE SD3010 SET D3_OK = ' ' WHERE D_E_L_E_T_ <> '* '  "
	cQueryA +="AND D3_OP>='"+MV_PAR01+"' AND D3_OP <= '"+MV_PAR02+"' AND D3_TM>='"+MV_PAR03+"' AND D3_TM <= '"+MV_PAR04+"' AND D3_OK <> '  ' AND D3_EMISSAO>='"+DTOS(MV_PAR05)+"' AND D3_EMISSAO <= '"+DTOS(MV_PAR06)+"' AND D3_ESTORNO <> 'S'   ""
   	TCSQLExec(cQueryA) 
	TCREFRESH('SD3010')  	    

   cTpMv3:=Posicione("SF5",1,xFilial("SF5")+MV_PAR03,"F5_TIPO")
   cTpMv4:=Posicione("SF5",1,xFilial("SF5")+MV_PAR04,"F5_TIPO")   
   
	
   //If cTpMv3 == "P" .and. cTpMv4 =="P"
		aCpos:={"D3_OK","D3_OP","D3_COD","D3_DOC","D3_QUANT,D3_TM"}
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nI := 1 To Len(aCpos)
		   dbSeek(aCpos[nI])
		   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
		Next
		
		
		
		cMarca:=GetMark()
		cCadastro:="Movimentos de Produção"
		aRotina:={{"Estornar",'execblock("MBNLIBITEM",.F.,.F.)',0,10,0},{"Marca/Desm.",'execblock("MBMARCALL",.F.,.F.)',0,10,0}}
		
		cFiltro:="SD3->D3_OP>='"+MV_PAR01+"' .AND. D3_OP <= '"+MV_PAR02+"' .AND. SD3->D3_TM>='"+MV_PAR03+"' .AND. D3_TM <= '"+MV_PAR04+"' .AND. DTOS(SD3->D3_EMISSAO)>='"+DTOS(MV_PAR05)+"' .AND. DTOS(D3_EMISSAO) <= '"+DTOS(MV_PAR06)+"' .AND. SD3->D3_ESTORNO <> 'S' "
		cArqTRB := CriaTrab(Nil,.F.)
		cIndice := "D3_FILIAL+D3_OP+D3_DOC"                                    
		IndRegua("SD3",cArqTRB,cIndice,,cFiltro,"Selecionando Registros...")
		DbGotop()                                                                                                                                                                   
		MarkBrow("SD3","D3_OK",,,,cMarca,,,,,"u_MarcaPed()")
//	Else
  //	    Alert("Os Parâmetros de T.M. devem ser do tipo 'P' (Produção).")
	    
	//Endif
Endif

Return
// Grava marca no campo


User Function MarcaPed()  
 If IsMark("D3_OK",cMarca )
   RecLock("SD3",.F.)
   SD3->D3_OK := space(2)
   MsUnLock()
Else
//   If  SF2->F2_FIMP == "S"
      RecLock("SD3",.F.)
      SD3->D3_OK := cMarca
      MsUnLock()
//   Endif      
Endif           

Return .T.

                
User Function MBMARCALL()  

DbSelectArea("SD3")
DbGoTop()
While !EOF()
      If IsMark("D3_OK",cMarca )
	     RecLock("SD3",.F.)
	     SD3->D3_OK := space(2)

	     MsUnLock()
	  Else
	     RecLock("SD3",.F.)
    	 SD3->D3_OK := cMarca
	     MsUnLock()
      Endif           
      DbSkip()
Enddo      
      


         
User Function MBNLIBITEM()        

      cOp1:=MV_PAR01
      cOp2:=MV_PAR02
      dData1:=MV_PAR05
      dData2:=MV_PAR06    

        aArea:=GetArea()


		cQuery := "SELECT * FROM "+RetSqlName("SD3")+" WHERE D_E_L_E_T_ <> '* '  "
		cQuery += "AND D3_OP>='"+MV_PAR01+"' AND D3_OP <= '"+MV_PAR02+"' AND D3_TM>='"+MV_PAR03+"' AND D3_TM <= '"+MV_PAR04+"' AND D3_OK <> '  ' AND D3_EMISSAO>='"+DTOS(MV_PAR05)+"' AND D3_EMISSAO <= '"+DTOS(MV_PAR06)+"' AND D3_ESTORNO <> 'S'   "
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TREC")
		dbSelectArea("TREC") 
		While !EOF()     
					    cTipF5:=Posicione("SF5",1,xFilial("SF5")+TREC->D3_TM,"F5_TIPO")

                        If cTipF5 == "P"
		
					        aAPONT	:=	{	{	"D3_FILIAL"	,xFilial("SD3")	,NIL},;
							  			{	"D3_TM"			,TREC->D3_TM	,NIL},;
							  	  		{	"D3_COD"		,TREC->D3_COD	,NIL},;   
							  	  		{	"D3_DOC"		,TREC->D3_DOC	,NIL},;   						  	  		
							  	  		{	"D3_NUMSEQ"		,TREC->D3_NUMSEQ	,NIL},;   						  	  		 
					 			  	  	{	"D3_OP"			,TREC->D3_OP	,NIL},;
										{	"D3_EMISSAO"	,STOD(TREC->D3_EMISSAO)	,NIL},;
						 				{	"D3_QUANT"		,TREC->D3_QUANT		,NIL},; 
								 		{	"D3_CF"			,TREC->D3_CF		,NIL}}
									
			
						    lMsErroAuto := .f.
										
							
							MsExecAuto({|x,y| mata250(x,y)},aApont,5)
										                                          
								
							If lMsErroAuto
			   	        	    cNomArqErro := NomeAutoLog()
			   					IF (nHandle := FOPEN(cNomArqErro)) >= 0
									// Pega o tamanho do arquivo
				   	   				nLength := FSEEK(nHandle, 0, FS_END)                                                    
				   					fSeek(nHandle,0,0)
								   	cString := FREADSTR(nHandle, nLength)
				   					FCLOSE(nHandle)                     
			   					Endif 
		 		   				ALERT(cString)
			   					FERASE(cNomArqErro)
			 	    	   
						    Endif
		                Else 
							aApont:={  {"D3_NUMSEQ", TREC->D3_NUMSEQ ,NIL},;
									   {"INDEX",4,NIL}}
								
	
						
				  					lMsErroAuto := .f.
								    MSExecAuto({|x,y| mata240(x,y)},aApont,5) //Estorno   									                                          
										
									If lMsErroAuto
					   	        	    cNomArqErro := NomeAutoLog()
				   						IF (nHandle := FOPEN(cNomArqErro)) >= 0
											// Pega o tamanho do arquivo
						   	   				nLength := FSEEK(nHandle, 0, FS_END)                                                    
						   					fSeek(nHandle,0,0)
										   	cString := FREADSTR(nHandle, nLength)
						   					FCLOSE(nHandle)                     
		   								Endif 
	 		   							ALERT(cString)
					   					FERASE(cNomArqErro)
						
								    Endif
				    //estornar requisições 504
                        Endif
				 		
						DbSelectArea("TREC")
						DbSkip()
		Enddo		
	
		DbSelectArea("TREC")
	    DbCloseArea("TREC")
            
   			//estornar requisições 504      
/*            RestArea(aArea)
			cQuery := "SELECT * FROM "+RetSqlName("SD3")+" WHERE D_E_L_E_T_ <> '* '  "
			cQuery += "AND D3_OP>='"+cOp1+"' AND D3_OP <= '"+cOp2+"' AND D3_TM = '"+cReqEst+"' AND D3_EMISSAO>='"+DTOS(dData1)+"' AND D3_EMISSAO <= '"+DTOS(dData2)+"' AND D3_ESTORNO <> 'S'   "
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TREC")
			dbSelectArea("TREC") 
			While !EOF()     
         
                                                                  
						aApont:={  {"D3_NUMSEQ", TREC->D3_NUMSEQ ,NIL},;
								   {"INDEX",4,NIL}}
								
	
						
						lMsErroAuto := .f.
					    MSExecAuto({|x,y| mata240(x,y)},aApont,5) //Estorno   									                                          
							
						If lMsErroAuto
		   	        	    cNomArqErro := NomeAutoLog()
		   					IF (nHandle := FOPEN(cNomArqErro)) >= 0
								// Pega o tamanho do arquivo
			   	   				nLength := FSEEK(nHandle, 0, FS_END)                                                    
			   					fSeek(nHandle,0,0)
							   	cString := FREADSTR(nHandle, nLength)
			   					FCLOSE(nHandle)                     
		   					Endif 
	 		   				ALERT(cString)
		   					FERASE(cNomArqErro)
						
					    Endif
				    //estornar requisições 504

			 		
					DbSelectArea("TREC")
					DbSkip()
		 Enddo		
         DbSelectArea("TREC")
         DbCloseArea("TREC")*/



         


		 Alert ("Apontamentos Estornados!")
Return



