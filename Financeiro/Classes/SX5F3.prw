#include "protheus.ch"                                           

//Nome       : SX5DESF3 - Descri��o do SX5 via F3
//Descri��o  : Consulta F3 para Retorno da Descri��o de Itens Cadastrados nas Tabelas Gen�ricas
//Nota       : Alternativa a Consulta Padr�o das Tabelas Gen�ricas que n�o retorna a Descri��o 
//Nota		 : O Campo de Pesquisa n�o est� funcionando - Estudar Bloco sendo Executando em bChange
//Ambiente   : Espec�ficos
//Autor      : Carlos Eduardo Niemeyer Rodrigues
//Dt Cria��o : 18/01/2009
//Revis. por : -
//Revis�o    : 0
//Dt Revis�o : -

User Function SX5DESF3(cTabela,lInclui,lAltera)
   Local lRet := .F.
   Local oDlgF3, Tb_Campos:={}, cOldArea:= Alias()
   Local bSetF3:= SetKey(VK_F3)
   Local oSeek,cSeek,oOrdem,cOrd,aOrdem:={},nOldInd:= SX5->( IndexOrd() )
   
   Private nRec                                                      
   Private lInverte := .F. 
   Private cMarca := GetMark()
   Private cFilSX5:= xFilial("SX5")

   Default cTabela:="01"
   Default lInclui:=.T.
   Default lAltera:=.T.

   Begin Sequence
      //evitar recursividade
      Set Key VK_F3 TO
      
      //bReturn:={||GDFieldPut("DESCRICAO",SX5->X5_DESCRI,n),oDlgF3:End()}                          
      bReturn:={|| oDlgF3:End()}
      
      cSeek := Space(45)
      
      //Chave para Busca
      aAdd(aOrdem,"X5_CHAVE") 
      
      //Colunas
      AADD(Tb_Campos,{"X5_CHAVE",,"Chave"})
      AADD(Tb_Campos,{"X5_DESCRI" ,,"Descricao"})

      dbSelectArea("SX5")
      SX5->( dbSetOrder(1) )
      SX5->( dbSetFilter({|| SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == cTabela },"SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == '" + cTAbela + "'"))
      SX5->( dbSeek( cFilSX5 ) )
      DEFINE MSDIALOG oDlgF3 TITLE "Selecione o Item Desejado" FROM 62,15 TO 310,460 OF oMainWnd PIXEL

         oMark:= MsSelect():New("SX5",,,TB_Campos,@lInverte,@cMarca,{10,12,80,186})
         oMark:baval:= {|| nRec:=SX5->(RecNo()), lRet:=.T., Eval(bReturn) }

         @ 091, 14 SAY "Pesquisar Por:" SIZE 42,7 OF oDlgF3 PIXEL
         @ 090, 59 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 119, 42 OF oDlgF3 PIXEL ON CHANGE (SEEKF3(oMARK,,oOrdem))
         @ 104, 14 SAY "Localizar:" SIZE 32, 7 OF oDlgF3 PIXEL
         @ 104, 58 MSGET oSeek VAR cSeek SIZE 120, 10 OF oDlgF3 PIXEL 
         oSeek:bChange := {|nChar|SX5->(SEEKF3(oMARK,RTrim(oSeek:oGet:Buffer)))} 
		 //oSeek:bChange := {|nChar|(cAlias)->(dbSeek(Eval(bSeek,nChar))), oMark:oBrowse:Refresh()}		 
	 	 
         DEFINE SBUTTON FROM 10,187 TYPE 1 ACTION (Eval(oMark:baval)) ENABLE OF oDlgF3 PIXEL
         DEFINE SBUTTON FROM 25,187 TYPE 2 ACTION (oDlgF3:End()) ENABLE OF oDlgF3 PIXEL
		 If lInclui         
		     DEFINE SBUTTON FROM 40,187 TYPE 4 ACTION (SX5IncF3(cTabela)) ENABLE OF oDlgF3 PIXEL
		 Endif
		 If lAltera .And. lInclui         
		     DEFINE SBUTTON FROM 55,187 TYPE 11 ACTION (SX5AltF3(cTabela)) ENABLE OF oDlgF3 PIXEL
		 Else
		 	 DEFINE SBUTTON FROM 40,187 TYPE 11 ACTION (SX5AltF3(cTabela)) ENABLE OF oDlgF3 PIXEL
		 Endif		 
	     
      ACTIVATE MSDIALOG oDlgF3
       
   END SEQUENCE
   
   /*
   SX5->( dbSetOrder(nOldInd) )
   SET FILTER TO
   dbSelectArea(cOldArea)
   
   IF !Empty(nRec)
      SX5->( dbGoTo(nRec) )
   Endif
   */
   
   dbSelectArea("SX5")
   If !Empty(nRec)
   		SX5->(dbGoto(nRec))
   Endif
   SetKey(VK_F3,bSetF3)

Return lRet                                                                 

//Fun��o que executa a inclus�o de Dados na Tabela SX5
Static Function SX5IncF3(cTabela)
Local aArea		:=GetArea()
Local aParam	:=Array(4)
Local cNovaChv	:=""
    
	//Localiza �ltima Chave e Adiciona 1
	dbSelectArea("SX5")
	dbSetOrder(1)
	SX5->(dbSetFilter({|| SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == cTabela },"SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == '" + cTAbela + "'"))
	SX5->(dbGoBottom())
	cNovaChv:=Soma1(AllTrim(SX5->X5_CHAVE))
    aParam[1]:={|| M->X5_TABELA:=cTabela, M->X5_CHAVE:=cNovaChv}
	
	//Abre tela padr�o para inclus�o no SX5, carregando vari�veis espec�ficas da tabela
	AxInclui("SX5",SX5->(RecNo()),,,,,,,,,aParam)      
	
	//Restaura Posi��o do Registro Anterior
	RestArea(aArea)
Return Nil

//Fun��o que executa a edi��o de Dados no SX5
Static Function SX5AltF3(cTabela)
	SX5Mnt("SX5",SX5->(RecNo()),3,cTabela)
Return Nil 

//Fun��o da Rotina de Manuten��o (Visualiza��o, Altera��o e Exclus�o) do SX5 - Tabela Gen�rica
Static Function SX5Mnt(cAlias,nReg,nOpc,cTabela)
Local   aArea	 :=GetArea()
Local 	aCab	 :={}
Local 	aRoda	 :={}
Local 	aReg	 :={}
Local 	aGrid	 :={44,5,50,300}
Local 	cLinhaOk :="AllwaysTrue()"
Local 	cTudoOk	 :="AllwaysTrue()"
Local 	lRetMod2
Local 	nColuna	 :=0
Local   cCadastro:="Cadastro de Tabela Gen�rica"

Private aCols	:={}
Private aHeader	:={}
Private cX5Tabela:=If(SX5->X5_TABELA=="00",LEFT(SX5->X5_CHAVE,2),SX5->X5_TABELA)
Private cX5Descri:=DescTab(cTabela) //Posicione("SX5",1,XFILIAL("SX5")+"00"+AllTrim(cTabela),"X5_DESCRI")
//Private cX5Descri:="TABELA DE GRUPOS DE PERGUNTAS" //Devido ao Filtro Inicial foi necess�rio adicionar manualmente a descri��o

aAdd(aCab,{"cX5Tabela",{15,10},"Tabela","@!",,,.F.})
aAdd(aCab,{"cX5Descri",{15,80},"Descricao","@!",,,.F.})

aAdd(aHeader,{"Chave","X5_CHAVE","@!",5,0,"AllwaysTrue()","","C","","R"})
aAdd(aHeader,{"Descricao","X5_DESCRI","@!",40,0,"AllwaysTrue()","","C","","R"})

SX5->(dbSeek(xFilial(cAlias)+cTabela))

While SX5->(!Eof()) .and. SX5->X5_TABELA==cTabela
	aAdd(aCols,Array(Len(aHeader)+1))
	aCols[Len(aCols),1]:=SX5->X5_CHAVE
	aCols[Len(aCols),2]:=SX5->X5_DESCRI
	aCols[Len(aCols),3]:=.F.
	aadd(aReg,Recno())
	SX5->(dbSkip())
End

lRetMod2:=Modelo2(cCadastro,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)

If lRetMod2
	If nOpc == 3 //Se for altera��o
		For nLinha:=1 to Len(aCols)
			If nLinha<=Len(aReg) //Se for menor ou igual pode ser uma altera��o ou exclus�o
				SX5->(dbGoto(aReg[nLinha]))
				RecLock(cAlias,.F.)
				if aCols[nLinha,Len(aHeader)+1] //Se a linha estiver marcada como exclu�da
					//if VldExcGPer(aCols[nLinha,1]) //Verifica se a Chave n�o est� associada a outros cadastros - PEND�NCIA - PERMITIR ADI��O DE VALIDA��ES
						SX5->(DbDelete())
						MsUnlock()
					//Endif
				Endif
			Else //Caso contr�rio � uma inclus�o
				if !aCols[nLinha,Len(aHeader)+1] //Se a linha n�o estiver marcada como exclu�da
					RecLock(cAlias,.T.)
				EndIf				
			Endif
			
			if !aCols[nLinha,Len(aHeader)+1] //Se a linha n�o estiver marcada como exclu�da
				//Altera ou Inclui				 
				SX5->X5_TABELA=cTabela
				For nCol:=1 To Len(aHeader)
					FieldPut(FieldPos(aHeader[nCol,2]),aCols[nLinha,nCol])
				Next nCol				 
				MsUnlock()
			Endif
		Next nLinha		
	ElseIf nOpc == 4 //Se for exclus�o
		For nLinha:=1 to Len(aReg)
			if aCols[nLinha,Len(aHeader)+1] //Se a linha estiver marcada como exclu�da
				if VldExcGPer(aCols[nLinha,1]) //Verifica se o Grupo n�o est� associado a outros cadastros.
					SX5->(dbGoto(aReg[nLinha]))
					RecLock(cAlias,.F.)
					SX5->(DbDelete())
					MsUnlock()
				Endif
			Endif
		Next nLinha
	Endif
Endif

RestArea(aArea)

Return  

//Retorna a Descri��o da Tabela
Static Function DescTab(cTabela)      
Local aArea:=GetArea()
Local cDesc:=""

	dbcloseArea("SX5")
	dbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSetFilter({|| SX5->X5_FILIAL == xFilial("SX5")},"SX5->X5_FILIAL == xFilial('SX5')"))
	SX5->(dbSeek(xFilial("SX5")+"00"+cTabela))
	cDesc:=SX5->X5_DESCRI	
	
	//Restaura Posi��o Anterior
	dbSelectArea("SX5")
	SX5->(dbSetFilter({|| SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == cTabela },"SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == '" + cTAbela + "'"))
	RestArea(aArea)
	
Return (cDesc)