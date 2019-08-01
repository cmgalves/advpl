#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "COLORS.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMBFDESC  ºAutor  ³Cassiano G. Ribeiro º Data ³  27/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Faixas de Desconto.			                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-MB                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PMBFDESC(nOpc)
Local aArea			:= GetArea()
Local aAreaSZ2		:= SZ2->(GetArea())
Local cAlias 		:= ""
Local nOpcGD		:= IIF(INCLUI.OR.ALTERA,GD_INSERT+GD_DELETE+GD_UPDATE,0)//GD_INSERT+GD_DELETE+GD_UPDATE
Local lRet			:= .F.
Local oGetDados
Local bOk			:= {|| IIF(oGetDados:TudoOk(),lRet := GravaFaixa(oGetDados:aCols),),IIF(lRet,_oDlg:End(),	)}
Local bCancel		:= {|| _oDlg:End()}
Private bTOk		:= {|| ValidTipo(oGetDados:aCols)}
Private nSuperior   := C(055)           // Linha  Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Private nEsquerda   := C(108)           // Coluna Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Private nInferior   := C(055)           // Linha  Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Private nDireita    := C(440)           // Coluna Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
Private aHeader		:= {}
Private aCols		:= {}
Private _oDlg
Private oCodFaixa
Private oDescFaixa
Private cCodfaixa	:= IIF(INCLUI,CriaVar("Z2_COD",.T.),SZ2->Z2_COD)
Private cDescFaixa	:= IIF(INCLUI,CriaVar("Z2_DESCRI",.T.),SZ2->Z2_DESCRI)
//Private aAltera  	:= {}
Private aSize		:= MsAdvSize()
Private aInfo		:= {}
Private aObjects	:= {}
Private aPosObj		:= {}
Private nOpcx		:= nOpc
Private lGrava	:= .T.

RegToMemory( "SZ2",INCLUI, .F. )

If Inclui
	cCodFaixa := NextNumero("SZ2",1,"Z2_COD",.T.)//GetSX8Num("SZ2","SZ2->Z2_COD")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos que não farão parte do aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCpoNao		:= "Z2_COD;Z2_DESCRI"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader   := CriaHeader("SZ2", cCpoNao,.F., .T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCriaCols := A610CriaCols("SZ2", aHeader, xFilial("SZ2")+cCodFaixa, {|| SZ2->Z2_FILIAL+SZ2->Z2_COD==xFilial("SZ2")+cCodFaixa})
aCols     := AClone(aCriaCols[1])
If INCLUI
	aCols[1][aScan(aHeader,{|x| AllTrim(x[2])=="Z2_ITEM"})] := "001"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recupera as dimensoes da tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aObjects,{100,020,.T.,.F.,.F.})//Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera:linha fim coluna fim (.F.)
AADD(aObjects,{100,100,.T.,.T.,.F.})//Indica dimensoes x e y e indica que redimensiona x e y
aSize:=MsAdvSize()
aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj:=MsObjSize(aInfo,aObjects)
//ÚÄÄÄÄÄÄÄÄÄ¿
//³Cria Tela³
//ÀÄÄÄÄÄÄÄÄÄÙ
_oDlg := MSDialog():New(aSize[1], aSize[1], aSize[6],aSize[5], "Faixas de Desconto de Vendas" ,,,,,,,, oMainWnd, .T.)
_oDlg:bInit:= {|| dbSelectArea("SZ2"),oGetDados:Refresh() , EnchoiceBar(_oDlg,bOk,bCancel)}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria os componetes da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ C(020),C(015) SAY "Codigo:" OF _oDlg PIXEL SIZE 031,008
@ C(020),C(040) MsGet oCodFaixa Var cCodFaixa Valid .T. When .F. Size C(030),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(020),C(072) SAY "Descrição:" OF _oDlg PIXEL SIZE 031,008
@ C(020),C(100) MsGet oDescFaixa Var cDescFaixa Valid ValidDesc() When (INCLUI .OR. ALTERA) Size C(120),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

oGetDados:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcGD,"Eval(bTOk)"/*cLinhaOk*/,"Eval(bTOk)"/*cTudoOk*/,;
													"+Z2_ITEM",/*aAltera*/,,200,/*cFieldOk*/,/*superdel*/,/*delok*/,_oDlg,aHeader,aCols)

_oDlg:lMaximized := .T.//Tela sempre maximizada

_oDlg:Activate()

RestArea(aArea)
RestArea(aAreaSZ2)
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Alexandre Conselvan    ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)// Resolucao 800x600
		nTam *= 1
	Else //Resolucao acima de 1024
	    nTam *= 1.03
	EndIf
Return Int(nTam)

Static Function ValidDesc()
Local lRet := .T.
	If (INCLUI .OR. ALTERA)
		If Empty(cDescFaixa)
			MSgInfo("Preencha a descrição da Faixa de desconto!")
			lGrava := .F.
		EndIf
	EndIf
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDTIPO ºAutor  ³Cassiano G. Ribeiro º Data ³  29/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da GetDados.                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMB-P10.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidTipo(aDados)
Local lRet 		:= .T.
Local aProd 	:= {}
Local aGrupo 	:= {}
Local nPosGrupo := 0
Local nPosProd	:= 0

If (INCLUI .OR. ALTERA)
	For nI := 1 to Len(aDados)
		If !aDados[nI,Len(aHeader)+1]
			If Empty(aDados[nI,GDFieldPos("Z2_TIPO")])
				MsgAlert("Campo: Tipo Desc é obrigratorio!")
				lRet := .F.
			ElseIf (Empty(aDados[nI,GDFieldPos("Z2_TIPO")]) .AND. Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .AND. ;
					Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])) .OR. (Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .AND.;
					Empty(aDados[nI,GDFieldPos("Z2_CODPROD")]))
				MsgAlert("Preencha os campos corretamente! Verifique: Tipo, Grupo e Produto.")
				lRet := .F.
			ElseIf !Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .OR. !Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])
			    If aDados[nI,GDFieldPos("Z2_TIPO")] == "P" .AND. (!Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .OR.;
			     Empty(aDados[nI,GDFieldPos("Z2_CODPROD")]))
			    	MsgAlert("Operação não permitida! Causa: Grupo preenchido, ou não há Produto informado.")
			    	lRet := .F.
			    ElseIf aDados[nI,GDFieldPos("Z2_TIPO")] == "G" .AND. (!Empty(aDados[nI,GDFieldPos("Z2_CODPROD")]) .OR.;
			     Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]))
			    	MsgAlert("Operação não permitida! Causa: Produto preenchido, ou não há Grupo informado.")
			    	lRet := .F.
			    EndIf
			EndIf
		  	
		  	If !Empty(aDados[nI,GDFieldPos("Z2_GRPROD")])
			  	nPosGrupo := aScan(aGrupo,{|x| x[1]== aDados[nI,GDFieldPos("Z2_GRPROD")]})
			  	If  nPosGrupo == 0
					AADD(aGrupo,{aDados[nI,GDFieldPos("Z2_GRPROD")]})
				Else
					MsgAlert("Duplicidade de Dados! O Grupo: já existe!")
					lRet := .F.
				EndIf
			EndIf
			
			If !Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])
				nPosProd := aScan(aProd,{|x| x[1]== aDados[nI,GDFieldPos("Z2_CODPROD")]})
			  	If  nPosProd == 0 .and. !Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])
					AADD(aProd,{aDados[nI,GDFieldPos("Z2_CODPROD")]})
				Else
					MsgAlert("Duplicidade de Dados! O Produto já existe!")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Next nI
EndIf

Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVAFAIXAºAutor  ³Cassiano G. Ribeiro º Data ³  27/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação do status iformado pelo usuário.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-MB                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaFaixa(aDados)
Local aArea		:= GetArea()
Local aAreasz2	:= SZ2->(GetArea())
Local nY 		:= 0
Local lRet 		:= .F.
Local lSeek		:= .F.
Local lContinua := .T.

If nOpcx == 5 .and. !MsgYESNO("Deseja confirmar a exclusão desta(s) faixa(s) de desconto?")
	lContinua := .F.
EndIf

Begin Transaction
	For nY := 1 to Len(aDados)
		SZ2->(dbSetOrder(5))
		lSeek := SZ2->(dbSeek(xFilial("SZ2")+cCodFaixa+aDados[nY,1]))
		
		If !(aDados[nY][Len(aHeader)+1] == .T. )//Caso a linha nao esteja deletada
			If Inclui .or. Altera
				If INCLUI
					ConfirmSX8()
					RecLock("SZ2",.T.)
				Else
					RecLock("SZ2",!lSeek)
				EndIf
				SZ2->Z2_FILIAL  := xFilial("SZ2")
				SZ2->Z2_COD		:= cCodFaixa
				SZ2->Z2_DESCRI  := cDescFaixa
				For nX := 1 to Len(aHeader)
					If aHeader[nY][10] <> "V"
						SZ2->(FieldPut(FieldPos(aHeader[nX][2]),aDados[nY][nX]))
					EndIf
				Next nX
				SZ2->(MsUnLock())
				lRet := .T.
			ElseIf nOpcx == 5//Exclusão
				If lSeek .and. lContinua
					RecLock("SZ2",.F.)
						dbDelete()
					SZ2->(MsUnlock())
					lRet := .T.
				EndIf
			EndIf
		Else//Exclui linha deletada do objeto GetDados
			If lSeek
				RecLock("SZ2",.F.)
					dbDelete()
				SZ2->(MsUnlock())
				lRet := .T.
			EndIf
		EndIf
	Next nY
End Transaction

If !lRet .and. (Inclui .or. Altera)
	MsgAlert("Os Dados não foram gravados!","ATENÇÃO")
	If INCLUI
		RollBackSX8()
	EndIf
EndIf

_oDlg:End()

RestArea(aArea)
RestArea(aAreaSZ2)
Return (lRet)
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  A610CriaHe  ³ Autor ³Marcelo Iuspa      ³ Data ³ 08/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Generica para criacao de aHeader                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := A610CriaHeader(ExpC1,ExpC2,ExpL1,ExpL2)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpC2 = Lista com campos nao exibidos (NoFields)			  ³±±
±±³          ³ ExpL1 = Se .T. monta somente o titulo no aHeader           ³±±
±±³          ³         Se .F. monta aHeader normal                        ³±±
±±³          ³ ExpL2 = Se .T. criara' campos especificos do WALK-THRU     ³±±
±±³          ³         desde que ExpL1 seja .F. (aHeader normal)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = aHeader                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geral                                                      ³±±
±±³          ³(MATA610,MATA630,MATA635,MATA093,MATA636,MATA098,MATA099,   ³±±
±±³          ³ MATA272,MATA551,MATA552,FATA140,AACA180A,AACA450...)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaHeader(cAlias, cSkip, lOnlyFields, lWalkThru)
Local aRet      := {}
Local OldAlias	:= Alias()
Local aSavSX3 	:= {SX3->(IndexOrd()), SX3->(RecNo())}

Default cSkip       := ""
Default lOnlyFields := .F.
Default lWalkThru   := .F.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
Do While SX3->(!Eof()) .And. (x3_arquivo == cAlias)
	If X3USO(x3_usado) .And. cNivel >= x3_nivel
    	If AllTrim(x3_campo) $ cSkip
        	SX3->(dbSkip())
            Loop
        EndIf
        If lOnlyFields
        	Aadd(aRet, Trim(x3_campo))
        Else
        	Aadd(aRet,{ Trim(X3Titulo()), Trim(x3_campo), x3_picture, x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_f3, x3_context})
        EndIf
     EndIf
     SX3->(dbSkip())
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Walk-Thru        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lOnlyFields .And. lWalkThru
	ADHeadRec(cAlias,aRet)
EndIf
dbSetOrder(aSavSX3[1])
dbGoto(aSavSX3[2])
dbSelectArea(OldAlias)
Return(aRet)