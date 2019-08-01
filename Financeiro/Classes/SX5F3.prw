#include "protheus.ch"                                           

//Nome       : SX5DESF3 - Descrição do SX5 via F3
//Descrição  : Consulta F3 para Retorno da Descrição de Itens Cadastrados nas Tabelas Genéricas
//Nota       : Alternativa a Consulta Padrão das Tabelas Genéricas que não retorna a Descrição 
//Nota		 : O Campo de Pesquisa não está funcionando - Estudar Bloco sendo Executando em bChange
//Ambiente   : Específicos
//Autor      : Carlos Eduardo Niemeyer Rodrigues
//Dt Criação : 18/01/2009
//Revis. por : -
//Revisão    : 0
//Dt Revisão : -

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

//Função que executa a inclusão de Dados na Tabela SX5
Static Function SX5IncF3(cTabela)
Local aArea		:=GetArea()
Local aParam	:=Array(4)
Local cNovaChv	:=""
    
	//Localiza Última Chave e Adiciona 1
	dbSelectArea("SX5")
	dbSetOrder(1)
	SX5->(dbSetFilter({|| SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == cTabela },"SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == '" + cTAbela + "'"))
	SX5->(dbGoBottom())
	cNovaChv:=Soma1(AllTrim(SX5->X5_CHAVE))
    aParam[1]:={|| M->X5_TABELA:=cTabela, M->X5_CHAVE:=cNovaChv}
	
	//Abre tela padrão para inclusão no SX5, carregando variáveis específicas da tabela
	AxInclui("SX5",SX5->(RecNo()),,,,,,,,,aParam)      
	
	//Restaura Posição do Registro Anterior
	RestArea(aArea)
Return Nil

//Função que executa a edição de Dados no SX5
Static Function SX5AltF3(cTabela)
	SX5Mnt("SX5",SX5->(RecNo()),3,cTabela)
Return Nil 

//Função da Rotina de Manutenção (Visualização, Alteração e Exclusão) do SX5 - Tabela Genérica
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
Local   cCadastro:="Cadastro de Tabela Genérica"

Private aCols	:={}
Private aHeader	:={}
Private cX5Tabela:=If(SX5->X5_TABELA=="00",LEFT(SX5->X5_CHAVE,2),SX5->X5_TABELA)
Private cX5Descri:=DescTab(cTabela) //Posicione("SX5",1,XFILIAL("SX5")+"00"+AllTrim(cTabela),"X5_DESCRI")
//Private cX5Descri:="TABELA DE GRUPOS DE PERGUNTAS" //Devido ao Filtro Inicial foi necessário adicionar manualmente a descrição

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
	If nOpc == 3 //Se for alteração
		For nLinha:=1 to Len(aCols)
			If nLinha<=Len(aReg) //Se for menor ou igual pode ser uma alteração ou exclusão
				SX5->(dbGoto(aReg[nLinha]))
				RecLock(cAlias,.F.)
				if aCols[nLinha,Len(aHeader)+1] //Se a linha estiver marcada como excluída
					//if VldExcGPer(aCols[nLinha,1]) //Verifica se a Chave não está associada a outros cadastros - PENDÊNCIA - PERMITIR ADIÇÃO DE VALIDAÇÕES
						SX5->(DbDelete())
						MsUnlock()
					//Endif
				Endif
			Else //Caso contrário é uma inclusão
				if !aCols[nLinha,Len(aHeader)+1] //Se a linha não estiver marcada como excluída
					RecLock(cAlias,.T.)
				EndIf				
			Endif
			
			if !aCols[nLinha,Len(aHeader)+1] //Se a linha não estiver marcada como excluída
				//Altera ou Inclui				 
				SX5->X5_TABELA=cTabela
				For nCol:=1 To Len(aHeader)
					FieldPut(FieldPos(aHeader[nCol,2]),aCols[nLinha,nCol])
				Next nCol				 
				MsUnlock()
			Endif
		Next nLinha		
	ElseIf nOpc == 4 //Se for exclusão
		For nLinha:=1 to Len(aReg)
			if aCols[nLinha,Len(aHeader)+1] //Se a linha estiver marcada como excluída
				if VldExcGPer(aCols[nLinha,1]) //Verifica se o Grupo não está associado a outros cadastros.
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

//Retorna a Descrição da Tabela
Static Function DescTab(cTabela)      
Local aArea:=GetArea()
Local cDesc:=""

	dbcloseArea("SX5")
	dbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSetFilter({|| SX5->X5_FILIAL == xFilial("SX5")},"SX5->X5_FILIAL == xFilial('SX5')"))
	SX5->(dbSeek(xFilial("SX5")+"00"+cTabela))
	cDesc:=SX5->X5_DESCRI	
	
	//Restaura Posição Anterior
	dbSelectArea("SX5")
	SX5->(dbSetFilter({|| SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == cTabela },"SX5->X5_FILIAL == cFilSX5 .AND. SX5->X5_TABELA == '" + cTAbela + "'"))
	RestArea(aArea)
	
Return (cDesc)