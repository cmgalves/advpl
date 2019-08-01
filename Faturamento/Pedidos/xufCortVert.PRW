#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"


User Function xufCortVert()

If !(__cUserID $ GetMV('MB_ALTMARG'))
	Alert('Usuário Sem Acesso', 'AVISO')
	Return
EndIf


/*/
+----------------------------------------------------------------+
|   Define Array contendo as Rotinas a executar do programa      +
|   ----------- Elementos contidos por dimensao ------------     +
|   1. Nome a aparecer no cabecalho                              +
|   2. Nome da Rotina associada                                  +
|   3. Usado pela rotina                                         +
|   4. Tipo de Transacao a ser efetuada                          +
|      1 - Pesquisa e Posiciona em um Banco de Dados             +
|      2 - Simplesmente Mostra os Campos                         +
|      3 - Inclui registros no Bancos de Dados                   +
|      4 - Altera o registro corrente                            +
|      5 - Remove o registro corrente do Banco de Dados          +
+----------------------------------------------------------------+
/*/
PRIVATE aRotina := { { "Pesquisar","AxPesqui", 0 , 1},;   //"Pesquisar"
{ "Visualizar","U_xsfCad", 0 , 2},;  //"Visualizar"
{ "Incluir","U_xsfCad", 0 , 3},;  //"Incluir"
{ "Alterar","U_xsfCad", 0 , 4} }  //"Alterar"

/*
+----------------------------------------------------------------+
|   Define o cabecalho da tela de atualizacoes                   |
+----------------------------------------------------------------+
*/
Private cCadastro := "Criterios de Rateio"  //"Criterios de Rateio
/*
+----------------------------------------------------------------+
|   Endereca funcao Mbrowse                                      |
+----------------------------------------------------------------+
*/
mBrowse( 6, 1,22,75,"ZZ2" )
Return
/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao     |xsfCad   | Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao  | Cadastro de Rateio Externo                                |
+------------+-----------------------------------------------------------+
| Sintaxe    | xsfCad(ExpC1,ExpN1,ExpN2)                                 |
+------------+-----------------------------------------------------------+
| Parametros | ExpC1 = Alias do arquivo                                  |
|            | ExpN1 = Numero do registro                                |
|            | ExpN2 = Numero da opcao selecionada                       |
+------------+-----------------------------------------------------------+
| Uso        | CTBA120                                                   |
+------------+-----------------------------------------------------------+
/*/
User Function xsfCad(cAlias,nReg,nOpc)
Local aSaveArea := GetArea()
Local aCampos := {}
Local aAltera := {}
Local cArq
Local xcMargem
Local xcDescMrg
Local nOpca := 0
Local oGetDb
Local oDlg
Local oFnt
Local oTpSald
Private aTela := {}
Private aGets := {}
Private aHeader := {}
Private nTotalD := 0
Private nTotalC := 0


/*
+----------------------------------------------------------------+
|   Monta aHeader para uso com MSGETDB                           |
+----------------------------------------------------------------+
*/
aCampos := xsfCabec(@aAltera)
/*
+----------------------------------------------------------------+
|   Cria arquivo Temporario para uso com MSGETDB                 |
+----------------------------------------------------------------+
*/
xsfCriaTab(aCampos,@cArq)
/*
+----------------------------------------------------------------+
|   Carrega dados para MSGETDB                                   |
+----------------------------------------------------------------+
*/
xsfCarrega(nOpc)

If nOpc == 3 // Inclusao
	xcMargem := CriaVar("ZZ2_COD") // Numero do Rateio
	xcDescMrg := CriaVar("ZZ2_NOME") // Descricao do Rateio
Else // Visualizacao / Alteracao / Exclusao
	xcMargem := ZZ2->ZZ2_COD
	xcDescMrg := ZZ2->ZZ2_NOME
EndIf
/*
+----------------------------------------------------------------+
|   Monta Tela Modelo 2                                          |
+----------------------------------------------------------------+
*/
DEFINE MSDIALOG oDlg TITLE "CADASTRO DE MARGENS/FAIXAS DE VALORES E DESCONTOS - COMISSÃO" From 9,0 To 32,80 OF oMainWnd  //"Rateios Externos"
DEFINE FONT oFnt NAME "Arial" Size 10,15

@ 18, 007  SAY "Margem: " PIXEL //"Rateio: "
@ 18, 037 MSGET xcMargem Picture "9999" SIZE 020,08 When (nOpc == 3);
Valid Ctb120Rat(xcMargem) OF oDlg PIXEL

@ 18, 090 Say "Descricao: " PIXEL  //"Descricao: "
@ 18, 120 MSGET xcDescMrg Picture "@!"  SIZE 140,08 When (nOpc == 3 .Or. ;
nOpc == 4) Valid !Empty(xcDescMrg) OF oDlg PIXEL

/*
+----------------------------------------------------------------+
|   Chamada da MSGETDB                                           |
+----------------------------------------------------------------+
*/
oGetDB := MSGetDB():New(044, 005, 120, 315, Iif(nOpc==3,4,nOpc),"U_xufLinhOK", "U_xufTudoOK", "+ZZ2_SEQUEN",.t.,aAltera,,.t.,,"TMP")
/*
+----------------------------------------------------------------+
|   Validacao da janela                                          |
+----------------------------------------------------------------+
*/
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
{||nOpca:=1,if(U_xufTudoOK(),oDlg:End(),nOpca := 0)},;
{||nOpca:=2,oDlg:End()}) VALID nOpca != 0
IF nOpcA == 1 // Aceita operacao e grava dados
	Begin Transaction
	U_xufGrava(xcMargem,xcDescMrg,nOpc)
	End Transaction
ENDIF
dbSelectArea(cAlias)
/*
+----------------------------------------------------------------+
|   Apaga arquivo temporario gerado para MSGETDB                 |
+----------------------------------------------------------------+
*/
DbSelectArea( "TMP" )
DbCloseArea()
If Select("cArq") = 0
	FErase(cArq+GetDBExtension())
EndIf
dbSelectArea("ZZ2")
dbSetOrder(1)
Return nOpca
/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao     |CTB120RAT| Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao  | Verifica existencia do Rateio                             |
+------------+-----------------------------------------------------------+
| Sintaxe    | Ctb120Rat(ExpC1)                                          |
+------------+-----------------------------------------------------------+
| Parametros | ExpC1 = Numero do Rateio                                  |
+------------+-----------------------------------------------------------+
| Retorno    | .T./.F.                                                   |
+------------+-----------------------------------------------------------+
| Uso        | CTBA120                                                   |
+------------+-----------------------------------------------------------+
/*/
User Function Ctb120Rat(xcMargem)
Local aSaveArea:= GetArea()
Local lRet := .T.
Local nReg

If Empty(xcMargem)
	lRet := .F.
EndIf

RestArea(aSaveArea)
Return lRet

/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao     |xufGrava | Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao  | Grava resgistro digitados                                 |
+------------+-----------------------------------------------------------+
| Sintaxe    | xufGrava(ExpC1,ExpC2,ExpN1)                               |
+------------+-----------------------------------------------------------+
| Parametros | ExpC1 = Numero do Rateio                                  |
|            | ExpC2 = Descricao do Rateio                               |
|            | ExpN1 = Opcao do Menu (Inclusao / Alteracao etc)          |
|            | ExpC3 = Moeda do Rateio                                   |
|            | ExpC4 = Tipo de Saldo                                     |
+------------+-----------------------------------------------------------+
| Retorno    | Nenhum                                                    |
+------------+-----------------------------------------------------------+
| Uso        | CTBA120                                                   |
+------------+-----------------------------------------------------------+
/*/
User Function xufGrava(xcMargem,xcDescMrg,nOpc)
Local aSaveArea := GetArea()
dbSelectArea("TMP")
dbgotop()
While !Eof()
	If !TMP->ZZ2_FLAG // Item nao deletado na MSGETDB
		If nOpc == 3 .Or. nOpc == 4
			dbSelectArea("ZZ2")
			dbSetOrder(1)
			If !(dbSeek(xFilial()+xcMargem+TMP->ZZ2_SEQUEN))
				RecLock( "ZZ2", .t. )
				ZZ2->ZZ2_FILIAL := xFilial()
				ZZ2->ZZ2_COD 	:= xcMargem
				ZZ2->ZZ2_NOME 	:= xcDescMrg
			Else
				RecLock( "ZZ2", .f. )
				ZZ2->ZZ2_NOME 	:= xcDescMrg
			Endif
			For nCont := 1 To Len(aHeader)
				If (aHeader[nCont][10] != "V" )
					FieldPut(FieldPos(aHeader[nCont][2]),;
					TMP->(FieldGet(FieldPos(aHeader[nCont][2]))))
				EndIf
			Next nCont
			ZZ2->(MsUnLock())
		Elseif nOpc == 5 // Se for exclusao
			dbSelectArea("ZZ2")
			dbSetOrder(1)
			If dbSeek(xFilial()+xcMargem+TMP->ZZ2_SEQUEN)
				RecLock("ZZ2",.F.,.T.)
				dbDelete()
				ZZ2->(MsUnlOCK())
			EndIf
		EndIf
	Else // Item deletado na MSGETDB
		dbSelectArea("ZZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZ2")+xcMargem+TMP->ZZ2_SEQUEN)
			RecLock( "ZZ2", .f., .t. )
			DbDelete()
			MsUnlock()
		Endif
	EndIf
	dbSelectArea("TMP")
	dbSkip()
Enddo
RestArea(aSaveArea)
Return

/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao     |xufTudoOK| Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao  | Valida MSGETDB -> Tudo OK                                 |
+------------+-----------------------------------------------------------+
| Sintaxe    | xufTudoOK(ExpC1)                                          |
+------------+-----------------------------------------------------------+
| Parametros | Nenhum                                                    |
+------------+-----------------------------------------------------------+
| Retorno    | Nenhum                                                    |
+------------+-----------------------------------------------------------+
| Uso        | CTBA120                                                   |
+------------+-----------------------------------------------------------+
/*/
User Function xufTudoOK()
Local aSaveArea := GetArea()
Local lRet  := .T.
Local nTotalD := 0
Local nTotalC := 0
dbSelectArea("TMP")
dbGotop()
While !Eof()
	dbSkip()
EndDo
RestArea(aSaveArea)
Return lRet
/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao     |xufLinhOK| Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao  | Valida MSGETDB -> LinhaOK                                 |
+------------+-----------------------------------------------------------+
| Sintaxe    | xufLinhOK(ExpC1)                                          |
+------------+-----------------------------------------------------------+
| Parametros | Nenhum                                                    |
+------------+-----------------------------------------------------------+
| Retorno    | Nenhum                                                    |
+------------+-----------------------------------------------------------+
| Uso        | CTBA120                                                   |
+------------+-----------------------------------------------------------+
/*/
User Function xufLinhOK()
Local lRet := .T.
Local nCont

Return lRet
/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao     |xsfCriaTab|Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao  | Cria Arquivo Temporario para MSGETDB                      |
+------------+-----------------------------------------------------------+
| Sintaxe    | xsfCriaTab(ExpA1,ExpC1)                                   |
+------------+-----------------------------------------------------------+
| Parametros | ExpA1 = Matriz com campos a serem criados                 |
|            | ExpC1 = Nome do arquivo temporario                        |
+------------+-----------------------------------------------------------+
| Retorno    | Nenhum                                                    |
+------------+-----------------------------------------------------------+
| Uso        | CTBA120                                                   |
+------------+-----------------------------------------------------------+
/*/
Static Function xsfCriaTab(aCampos,cArq)
Local cChave
Local aSaveArea := GetArea()
cChave := "ZZ2_SEQUEN"
cArq := CriaTrab(aCampos,.t.)
dbUseArea(.t.,,cArq,"TMP",.f.,.f.)
RestArea(aSaveArea)
Return
/*/
+------------+----------+-------+-----------------------+------+----------+
| Funcao     |xsfCabec  | Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+----------+-------+-----------------------+------+----------+
| Descricao  | Montar aHeader para arquivo temporario da MSGETDB          |
+------------+------------------------------------------------------------+
| Sintaxe    | xsfCabec(ExpA1)                                            |
+------------+------------------------------------------------------------+
| Parametros | ExpA1 = Matriz com campos que podem ser alterados          |
+------------+------------------------------------------------------------+
| Retorno    | ExpA1 = Matriz com campos a serem criados no arq temporario|
+------------+------------------------------------------------------------+
| Uso        | CTBA120                                                    |
+------------+------------------------------------------------------------+
/*/
Static Function xsfCabec(aAltera)
Local aSaveArea:= GetArea()
Local aFora := {"ZZ2_COD","ZZ2_NOME"}
Local aCampos := {}
Local nCriter := 0
PRIVATE nUsado := 0
// Montagem da matriz aHeader
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZZ2")
While !EOF() .And. (x3_arquivo == "ZZ2")
	If Alltrim(x3_campo) == "ZZ2_SEQUEN" .Or. ;
		x3Uso(x3_usado) .and. cNivel >= x3_nivel
		If Ascan(aFora,Trim(X3_CAMPO)) <= 0
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, "TMP", x3_context } )
			If Alltrim(x3_campo) <> "ZZ2_SEQUEN"
				Aadd(aAltera,Trim(X3_CAMPO))
			EndIf
		EndIF
	EndIF
	aAdd( aCampos, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL } )
	dbSkip()
EndDO
Aadd(aCampos,{"ZZ2_FLAG","L",1,0})
RestArea(aSaveArea)
Return aCampos
/*/
+------------+----------+-------+-----------------------+------+----------+
| Funcao     |xsfCarrega| Autor | Pilar S. Albaladejo   | Data | 24/07/00 |
+------------+----------+-------+-----------------------+------+----------+
| Descricao  | Carrega dados para MSGETDB                                 |
+------------+------------------------------------------------------------+
| Sintaxe    | xsfCarrega(ExpN1)                                          |
+------------+------------------------------------------------------------+
| Parametros | ExpN1 = Opcao do Menu -> Inclusao / Alteracao etc          |
+------------+------------------------------------------------------------+
| Retorno    | Nenhum                                                     |
+------------+------------------------------------------------------------+
| Uso        | CTBA120                                                    |
+------------+------------------------------------------------------------+
/*/
Static Function xsfCarrega(nOpc)
Local aSaveArea:= GetArea()
Local cAlias := "ZZ2"
Local nPos
If nOpc != 3 // Visualizacao / Alteracao / Exclusao
	xcMargem := ZZ2->ZZ2_COD
	dbSelectArea("ZZ2")
	dbSetOrder(1)
	If dbSeek(xFilial()+xcMargem)
		While !Eof() .And. ZZ2->ZZ2_FILIAL == xFilial() .And.;
			ZZ2->ZZ2_COD == xcMargem
			dbSelectArea("TMP")
			dbAppend()
			For nCont := 1 To Len(aHeader)
				nPos := FieldPos(aHeader[nCont][2])
				If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
					FieldPut(nPos,(cAlias)->(FieldGet(FieldPos(aHeader[nCont][2]))))
				EndIf
			Next nCont
			TMP->ZZ2_FLAG := .F.
			dbSelectArea("ZZ2")
			dbSkip()
		EndDo
	EndIf
Else
	dbSelectArea("TMP")
	dbAppend()
	For nCont := 1 To Len(aHeader)
		If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
			nPos := FieldPos(aHeader[nCont][2])
			FieldPut(nPos,CriaVar(aHeader[nCont][2],.T.))
		EndIf
	Next nCont
	TMP->ZZ2_FLAG := .F.
	TMP->ZZ2_SEQUEN:= "001"
EndIf
dbSelectArea("TMP")
dbGoTop()
RestArea(aSaveArea)
Return
