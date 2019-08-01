#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGUAC001  º Autor ³ Lucas Flóridi Leme º Data ³  29/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela de cadastro de regra de comissao para ser utilizada   º±±
±±º          ³ na tabela de preços e exportada para o guarani             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11 Injecom/Uninjet                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGUAC001


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Regras de Comissao - Guarani"
Private aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "&Visual","U_RGUACF01(3)", 0 , 2},;
{ "&Incluir","U_RGUACF01(1)", 0 , 3},;
{ "&Copia","U_RGUACF01(5)", 0 , 4 },;
{ "&Altera","U_RGUACF01(2)", 0 , 4 },;
{ "&Exclui","U_RGUACF01(4)", 0 , 5 },;
{"Imprimir","U_RFATCR14(6)",0,5} }
///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//³ Opcoes de acesso para a Modelo 3 ³
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZB1"
Private cOpcao
/*
PRIVATE aCores := {{	 'ZB1->ZB1_STATUS == "A"' , 'BR_VERDE' },; 	//Atendimento em aberto
{ 'ZB1->ZB1_STATUS == "L"' , 'BR_AZUL'},;						//Atendimento Efetivado
{ 'ZB1->ZB1_STATUS == "E"' , 'BR_AMARELO'},;						//Atendimento Efetivado
{ 'ZB1->ZB1_STATUS == "C"' , 'BR_MARRON' }}	      				//Atendimento Cancelado
//			{ 'ZB1->ZB1_STATUS == "E"' , 'BR_VERMELHO' }}	      				//Atendimento liberado
*/

dbSelectArea(cString)
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,)//aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RASSC001  ºAutor  ³Microsiga           º Data ³  05/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RGUACF01(_nOpcao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 3                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
//Private _dEntrega

If _nOpcao == 1
	nOpcx    := 3
	cOpcao:="INCLUIR"
ElseIf _nOpcao == 2
	nOpcx    := 3
	cOpcao:="ALTERAR"
ElseIf _nOpcao == 3
	cOpcao:="VISUALIZAR"
ElseIf _nOpcao == 4
	cOpcao:="EXCLUIR"
ElseIf _nOpcao == 5
	nOpcx    := 3
	cOpcao:="COPIA"
EndIf
Do Case
	Case cOpcao=="INCLUIR"		; nOpcE:=3 ; nOpcG:=3
	Case cOpcao=="COPIA"		; nOpcE:=3 ; nOpcG:=3
	Case cOpcao=="ALTERAR"		; nOpcE:=3 ; nOpcG:=3
	Case cOpcao=="VISUALIZAR"	; nOpcE:=2 ; nOpcG:=2
	Case cOpcao=="EXCLUIR"		; nOpcE:=2 ; nOpcG:=2
EndCase
///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//³ Cria variaveis M->????? da Enchoice ³
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
RegToMemory("ZB1",(cOpcao=="INCLUIR"))
///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//³ Cria aHeader e aCols da GetDados ³
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nUsado:=0
dbSelectArea("SX3")
DbSetOrder(1)
dbSeek("ZB2")
aHeader:={}
While !Eof().And.(x3_arquivo=="ZB2")
	If Alltrim(x3_campo)$"ZB2_CLASSI/ZB2_CODPRB/ZB2_NUMSER"
		dbSkip()
		Loop
	Endif
	If X3USO(x3_usado).And.cNivel>=x3_nivel
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End

cAliasEnchoice:="ZB1"
bcampo := {|nfield|field(nfield)}
If cOpcao=="INCLUIR"
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		If Alltrim(aHeader[_ni,2]) == "ZB2_ITEM"
			aCols[1,_ni]:="01"
		Else
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		EndIf
	Next
ElseIf cOpcao=="COPIA"
	dbselectarea(cAliasEnchoice)
	for i:= 1 to fcount()
		incproc()
		if "FILIAL" $ FIELDNAME(i)
			Fieldput(i,xfilial(cAliasEnchoice))
		else
			M->&(EVAL(bcampo,i)) := (cAliasEnchoice)->&(EVAL(bcampo,i))
		endif
	next i
	M->ZB1_REGRA		:= GetSxeNum("ZB1","ZB1_REGRA")
	aCols:={}
	dbSelectArea("ZB2")
	dbSetOrder(1)
	dbSeek(xFilial("ZB2")+ZB1->ZB1_REGRA)
	While !eof().and.ZB2->ZB2_FILIAL == xFilial("ZB2") .and. ZB2->ZB2_REGRA ==ZB1->ZB1_REGRA
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo
Else
	aCols:={}
	dbSelectArea("ZB2")
	dbSetOrder(1)
	dbSeek(xFilial("ZB2")+M->ZB1_REGRA)
	While !eof().and.ZB2->ZB2_FILIAL == xFilial("ZB2") .and. ZB2->ZB2_REGRA ==M->ZB1_REGRA
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo
Endif
If Len(aCols)>0
	nSizeHeader := 250           //tamanho do header, qdo maior, menor será o multiline
	///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//³ Executa a Modelo 3 ³
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cTitulo:="Orçamento de venda"
	cAliasEnchoice:="ZB1"
	cAliasGetD:="ZB2"
	cLinOk := "ExecBlock('RGUACL01',.F.,.F.)"
	cTudOk := "ExecBlock('RGUACT01',.F.,.F.)"
	//	cLinOk:="AllwaysTrue()"
	//	cTudOk:="AllwaysTrue()"
	cFieldOk:="AllwaysTrue()"
	//	aCpoEnchoice:={"ZB1_CODCLI","ZB1_LOJA"} //Campos do cabeçalho
	aButtons:= {}
	//	aadd(aButtons,{"CGETFILE_9",{|| U_RFATCA01(2)},"Calc.Total" })
	_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,        ,cLinOk,cTudOk ,nOpcE,nOpcG,cFieldOk,        ,       ,            ,       ,aButtons,      ,nSizeHeader)
	// Function Modelo3(cTitulo,cAlias1		 ,cAlias2	,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aButtons,aCordW,nSizeHeader)
	///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//³ Executar processamento ³
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If _lRet                               
		Begin Transaction
		If cOpcao == "INCLUIR" .or. cOpcao == "COPIA"
			dbselectarea(cAliasEnchoice)
			Reclock(cAliasEnchoice,.T.)
			for i:= 1 to fcount()
				incproc()
				if "FILIAL" $ FIELDNAME(i)
					Fieldput(i,xfilial(cAliasEnchoice))
				else
					Fieldput(i,M->&(EVAL(bcampo,i)))
				endif
			next i
			Msunlock()
			ConfirmSx8()
			For _l := 1 To Len(aCols)
				If !aCols[_l,Len(aHeader)+1]
					RecLock("ZB2",.T.)
					ZB2->ZB2_FILIAL	:= xFilial("ZB2")
					ZB2->ZB2_REGRA	:= M->ZB1_REGRA
					For _x := 1 To Len(aHeader)
						_cCampo := Alltrim(aHeader[_x,2])
						ZB2->&_cCampo	:= aCols[_l,_x]
					Next
					MsUnlock()
				EndIf
			Next _l
		ElseIf cOpcao == "ALTERAR"
			DbSelectArea("ZB1")
			DbSetOrder(1)
			DbSeek(xFilial("ZB1")+M->ZB1_REGRA)
			dbselectarea(cAliasEnchoice)
			Reclock(cAliasEnchoice,.F.)
			for i:= 1 to fcount()
				incproc()
				if "FILIAL" $ FIELDNAME(i)
					Fieldput(i,xfilial(cAliasEnchoice))
				else
					Fieldput(i,M->&(EVAL(bcampo,i)))
				endif
			next i
			Msunlock()
			
			
			For _l := 1 To Len(aCols)
				If aCols[_l,Len(aHeader)+1]
					DbSelectArea("ZB2")
					DbSetOrder(1)
					If DbSeek(xFilial("ZB2")+M->ZB1_REGRA + GdFieldGet("ZB2_ITEM",_l))
						RecLock("ZB2",.F.)
						Delete
						MsUnlock()
					EndIf
				Else
					DbSelectArea("ZB2")
					DbSetOrder(1)
					If DbSeek(xFilial("ZB2")+M->ZB1_REGRA + GDFieldGet("ZB2_ITEM",_l))
						
						DbSelectArea("ZB2")
						RecLock("ZB2",.F.)
						ZB2->ZB2_FILIAL	:= xFilial("ZB2")
						ZB2->ZB2_REGRA	:= M->ZB1_REGRA
						For _x := 1 To Len(aHeader)
							_cCampo := Alltrim(aHeader[_x,2])
							ZB2->&_cCampo	:= aCols[_l,_x]
						Next
						MsUnLock()
					Else
						RecLock("ZB2",.T.)
						ZB2->ZB2_FILIAL	:= xFilial("ZB2")
						ZB2->ZB2_REGRA	:= M->ZB1_REGRA
						For _x := 1 To Len(aHeader)
							_cCampo := Alltrim(aHeader[_x,2])
							ZB2->&_cCampo	:= aCols[_l,_x]
						Next
						MsUnLock()
					EndIf
				EndIf
			Next _l
		ElseIf cOpcao == "EXCLUIR"
			DbSelectArea("ZB1")
			DbSetOrder(1)
			If DbSeek(xFilial("ZB1")+M->ZB1_REGRA)
				RecLock("ZB1",.F.)
				Delete
				MsUnlock()
			EndIf
			
			DbSelectArea("ZB2")
			DbSetOrder(1)
			If DbSeek(xFilial("ZB2")+M->ZB1_REGRA)
				While !Eof() .and. ZB2->(ZB2_FILIAL+ZB2_REGRA) == xFilial("ZB2")+M->ZB1_REGRA
					RecLock("ZB2",.F.)
					Delete
					MsUnlock()
					DbSelectArea("ZB2")
					DbSkip()
				EndDo
			EndIf
		EndIf            
		End Transaction
	Else
		RollBackSx8()
	Endif
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RASSC001  ºAutor  ³Microsiga           º Data ³  05/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de todo o chamado                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RGUACT01()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RASSC001  ºAutor  ³Microsiga           º Data ³  05/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de todo o chamado                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RGUACL01()
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RASSC001  ºAutor  ³Microsiga           º Data ³  05/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de todo o chamado                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RGUACP01()

dbSelectArea("DA1")
dbSetOrder(1)

If dbSeek(xFilial("DA1")+M->ZB1_TAB)
	aCols:={}
	While !eof().and.DA1->DA1_FILIAL == xFilial("DA1") .and. DA1->DA1_CODTAB==M->ZB1_TAB
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+DA1->DA1_CODPRO)
		If DA1->DA1_CODPRO < '0101' .or. DA1->DA1_CODPRO > '5099' .or. SB1->B1_MSBLQL == "1"
			DbSelectArea("DA1")
			DbSkip()
			Loop
		EndIf
		
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			If Alltrim(aHeader[_ni,2]) == "ZB2_ITEM"
				aCols[Len(aCols),_ni]:= DA1->DA1_ITEM
			ElseIf Alltrim(aHeader[_ni,2]) == "ZB2_PROD"
				aCols[Len(aCols),_ni]:= DA1->DA1_CODPRO
			ElseIf Alltrim(aHeader[_ni,2]) == "ZB2_DESCRI"
				aCols[Len(aCols),_ni]:= Posicione("SB1",1,xFilial("SB1")+DA1->DA1_CODPRO,"B1_DESC")
			ElseIf Alltrim(aHeader[_ni,2]) == "ZB2_PRCTAB"
				aCols[Len(aCols),_ni]:= DA1->DA1_PRCVEN
			ElseIf Alltrim(aHeader[_ni,2]) == "ZB2_DESC"
				If SB1->B1_LINHA == "1"
					aCols[Len(aCols),_ni]:= M->ZB1_DESC1
				ElseIf SB1->B1_LINHA == "2"
					aCols[Len(aCols),_ni]:= M->ZB1_DESC2
				Else
					aCols[Len(aCols),_ni]:= Criavar("ZB2_DESC")
				EndIf
			ElseIf Alltrim(aHeader[_ni,2]) == "ZB2_PRCVEN"
				If SB1->B1_LINHA == "1"
					aCols[Len(aCols),_ni]:= A410Arred(DA1->DA1_PRCVEN * (1-(M->ZB1_DESC1/100)),"ZB2_PRCVEN")
				ElseIf SB1->B1_LINHA == "2"
					aCols[Len(aCols),_ni]:= A410Arred(DA1->DA1_PRCVEN * (1-(M->ZB1_DESC2/100)),"ZB2_PRCVEN")
				Else
					aCols[Len(aCols),_ni]:= CriaVar("ZB2_PRCVEN")
				EndIf
			Else
				aCols[Len(aCols),_ni]:=CriaVar(aHeader[_ni,2]) //FieldGet(FieldPos(aHeader[_ni,2]))
			EndIf
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		DbSelectArea("DA1")
		dbSkip()
	EndDo
EndIf
MsgAlert("Produtos preenchidos!")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RASSC001  ºAutor  ³Microsiga           º Data ³  06/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RGUACE01()

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+M->ZB1_CODCLI+M->ZB1_LOJA)
M->ZB1_NOMCLI	:= A1_NOME
M->ZB1_TEL		:= StrZero(Val(A1_DDD),3)+A1_TEL
M->ZB1_CEL		:= StrZero(Val(A1_DDD),3)+A1_CELULAR
M->ZB1_END		:= Alltrim(A1_END) + " - " + Alltrim(A1_BAIRRO) + " - " + Alltrim(A1_MUN) + " - " + A1_EST
M->ZB1_CEP		:= A1_CEP
M->ZB1_ZONA		:= A1_ZONA
M->ZB1_EMAIL		:= A1_EMAIL

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATC014  ºAutor  ³Microsiga           º Data ³  07/23/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATCR14()
Private oFont0:= TFont():New( "Courier New",,18,,.t.,,,,,.f. )
Private oFont1:= TFont():New( "Courier New",,14,,.f.,,,,,.f. )
Private oFont2:= TFont():New( "Courier New",,14,,.t.,,,,,.f. )
Private oPrn:=TMSPrinter():New()
nLin:=100
oPrn:SetLandscape()
oPrn:StartPage()
_cCodUsr := RetCodUsr()
oPrn:Say(nLin,1000,"Pedido Mix - " + ZB1->ZB1_REGRA,oFont0,100,,,2)//modificado por... data + hora		pagina 1/P

oPrn:Say(nLin+=100,0030,"Cliente ",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin,300,": " + ZB1->ZB1_NOME,oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin+=50,0030,"Data",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin,300,": " + Dtoc(ZB1->ZB1_EMISS),oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin+=50,0030,"Valor",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin,300,": " + Transform(ZB1->ZB1_VALOR,"@E 9,999,999.99"),oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
If _cCodUsr $ "000002/000001/000000/000009"
	oPrn:Say(nLin+=50,0030,"Custo",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin,300,": " + Transform(ZB1->ZB1_CUSTO,"@E 9,999,999.99"),oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin+=50,0030,"Margem R$",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin,300,": " + Transform(ZB1->ZB1_VALMARG,"@E 9,999,999.99"),oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin+=50,0030,"Margem %",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin,300,": " + Transform(ZB1->ZB1_INDICE,"@E 9999.99%"),oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
EndIf

oPrn:Say(nLin+=100,nCol1:=0030,"Produto",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin,nCol2:=1300,"Qtde",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin,nCol3:=1550,"PrcVenda",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
oPrn:Say(nLin,nCol4:=1850,"Total",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
If _cCodUsr $ "000002/000001/000000/000009"
	oPrn:Say(nLin,nCol5:=2100,"Custo Médio",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin,nCol6:=2400,"Custo Total",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin,nCol7:=2700,"Margem R$",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
	oPrn:Say(nLin,nCol8:=3000,"Margem %",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
EndIf
nLin+=50
DbSelectArea("ZB2")
DbSetOrder(1)
If DbSeek(xFilial("ZB2")+ZB1->ZB1_REGRA)
	While !Eof() .and. ZB1->ZB1_REGRA == ZB2->ZB2_REGRA
		oPrn:Say(nLin,nCol1,ZB2->ZB2_DESCRI,oFont2,100,,,3)//modificado por... data + hora		pagina 1/P
		oPrn:Say(nLin,nCol2,Transform(ZB2->ZB2_QTDVEN,"@E 9,999,999.99"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
		oPrn:Say(nLin,nCol3,Transform(ZB2->ZB2_PRCVEN,"@E 9,999,999.99"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
		oPrn:Say(nLin,nCol4,Transform(ZB2->ZB2_VALOR,"@E 9,999,999.99"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
		If _cCodUsr $ "000002/000001/000000/000009"
			oPrn:Say(nLin,nCol5:=2100,Transform(ZB2->ZB2_CUSTSTD,"@E 999,999.99"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
			oPrn:Say(nLin,nCol6:=2400,Transform(ZB2->ZB2_CUSTO,"@E 9,999,999.99"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
			oPrn:Say(nLin,nCol7:=2700,Transform(ZB2->ZB2_VALMARG,"@E 9,999,999.99"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
			oPrn:Say(nLin,nCol8:=3000,Transform(ZB2->ZB2_INDICE,"@E 999,999.99%"),oFont2,100,,,1)//modificado por... data + hora		pagina 1/P
		EndIf
		nLin+=50
		If nLin > 2300
			oPrn:EndPage()
			oPrn:StartPage()
			nLin:=100
			oPrn:Say(nLin,nCol1,"Produto",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
			oPrn:Say(nLin,nCol2,"Qtde",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
			oPrn:Say(nLin,nCol3,"PrcVenda",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
			oPrn:Say(nLin,nCol4,"Total",oFont1,100,,,3)//modificado por... data + hora		pagina 1/P
			If RetCodUsr() $ "000002/000001/000000/000009"
				oPrn:Say(nLin,nCol5,"Custo Médio",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
				oPrn:Say(nLin,nCol6,"Custo Total",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
				oPrn:Say(nLin,nCol7,"Margem R$",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
				oPrn:Say(nLin,nCol8,"Margem %",oFont1,100,,,1)//modificado por... data + hora		pagina 1/P
			EndIf
			nLin+=50
		EndIf
		DbSelectArea("ZB2")
		DbSkip()
	EndDo
EndIf
oPrn:EndPage()
oPrn:Preview()

Return
