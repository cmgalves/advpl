#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "COLORS.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBFDESC  �Autor  �Cassiano G. Ribeiro � Data �  27/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Faixas de Desconto.			                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10-MB                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//�������������������������������������Ŀ
//�Campos que n�o far�o parte do aHeader�
//���������������������������������������
Private cCpoNao		:= "Z2_COD;Z2_DESCRI"
//�������������Ŀ
//�Monta aHeader�
//���������������
aHeader   := CriaHeader("SZ2", cCpoNao,.F., .T.)
//�����������Ŀ
//�Monta aCols�
//�������������
Private aCriaCols := A610CriaCols("SZ2", aHeader, xFilial("SZ2")+cCodFaixa, {|| SZ2->Z2_FILIAL+SZ2->Z2_COD==xFilial("SZ2")+cCodFaixa})
aCols     := AClone(aCriaCols[1])
If INCLUI
	aCols[1][aScan(aHeader,{|x| AllTrim(x[2])=="Z2_ITEM"})] := "001"
EndIf
//�����������������������������Ŀ
//�Recupera as dimensoes da tela�
//�������������������������������
AADD(aObjects,{100,020,.T.,.F.,.F.})//Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera:linha fim coluna fim (.F.)
AADD(aObjects,{100,100,.T.,.T.,.F.})//Indica dimensoes x e y e indica que redimensiona x e y
aSize:=MsAdvSize()
aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj:=MsObjSize(aInfo,aObjects)
//���������Ŀ
//�Cria Tela�
//�����������
_oDlg := MSDialog():New(aSize[1], aSize[1], aSize[6],aSize[5], "Faixas de Desconto de Vendas" ,,,,,,,, oMainWnd, .T.)
_oDlg:bInit:= {|| dbSelectArea("SZ2"),oGetDados:Refresh() , EnchoiceBar(_oDlg,bOk,bCancel)}
//��������������������������Ŀ
//�Cria os componetes da Tela�
//����������������������������
@ C(020),C(015) SAY "Codigo:" OF _oDlg PIXEL SIZE 031,008
@ C(020),C(040) MsGet oCodFaixa Var cCodFaixa Valid .T. When .F. Size C(030),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(020),C(072) SAY "Descri��o:" OF _oDlg PIXEL SIZE 031,008
@ C(020),C(100) MsGet oDescFaixa Var cDescFaixa Valid ValidDesc() When (INCLUI .OR. ALTERA) Size C(120),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

oGetDados:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcGD,"Eval(bTOk)"/*cLinhaOk*/,"Eval(bTOk)"/*cTudoOk*/,;
													"+Z2_ITEM",/*aAltera*/,,200,/*cFieldOk*/,/*superdel*/,/*delok*/,_oDlg,aHeader,aCols)

_oDlg:lMaximized := .T.//Tela sempre maximizada

_oDlg:Activate()

RestArea(aArea)
RestArea(aAreaSZ2)
Return
/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Alexandre Conselvan    � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
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
			MSgInfo("Preencha a descri��o da Faixa de desconto!")
			lGrava := .F.
		EndIf
	EndIf
Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDTIPO �Autor  �Cassiano G. Ribeiro � Data �  29/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da GetDados.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PMB-P10.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				MsgAlert("Campo: Tipo Desc � obrigratorio!")
				lRet := .F.
			ElseIf (Empty(aDados[nI,GDFieldPos("Z2_TIPO")]) .AND. Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .AND. ;
					Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])) .OR. (Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .AND.;
					Empty(aDados[nI,GDFieldPos("Z2_CODPROD")]))
				MsgAlert("Preencha os campos corretamente! Verifique: Tipo, Grupo e Produto.")
				lRet := .F.
			ElseIf !Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .OR. !Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])
			    If aDados[nI,GDFieldPos("Z2_TIPO")] == "P" .AND. (!Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]) .OR.;
			     Empty(aDados[nI,GDFieldPos("Z2_CODPROD")]))
			    	MsgAlert("Opera��o n�o permitida! Causa: Grupo preenchido, ou n�o h� Produto informado.")
			    	lRet := .F.
			    ElseIf aDados[nI,GDFieldPos("Z2_TIPO")] == "G" .AND. (!Empty(aDados[nI,GDFieldPos("Z2_CODPROD")]) .OR.;
			     Empty(aDados[nI,GDFieldPos("Z2_GRPROD")]))
			    	MsgAlert("Opera��o n�o permitida! Causa: Produto preenchido, ou n�o h� Grupo informado.")
			    	lRet := .F.
			    EndIf
			EndIf
		  	
		  	If !Empty(aDados[nI,GDFieldPos("Z2_GRPROD")])
			  	nPosGrupo := aScan(aGrupo,{|x| x[1]== aDados[nI,GDFieldPos("Z2_GRPROD")]})
			  	If  nPosGrupo == 0
					AADD(aGrupo,{aDados[nI,GDFieldPos("Z2_GRPROD")]})
				Else
					MsgAlert("Duplicidade de Dados! O Grupo: j� existe!")
					lRet := .F.
				EndIf
			EndIf
			
			If !Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])
				nPosProd := aScan(aProd,{|x| x[1]== aDados[nI,GDFieldPos("Z2_CODPROD")]})
			  	If  nPosProd == 0 .and. !Empty(aDados[nI,GDFieldPos("Z2_CODPROD")])
					AADD(aProd,{aDados[nI,GDFieldPos("Z2_CODPROD")]})
				Else
					MsgAlert("Duplicidade de Dados! O Produto j� existe!")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Next nI
EndIf

Return (lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GRAVAFAIXA�Autor  �Cassiano G. Ribeiro � Data �  27/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava��o do status iformado pelo usu�rio.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10-MB                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaFaixa(aDados)
Local aArea		:= GetArea()
Local aAreasz2	:= SZ2->(GetArea())
Local nY 		:= 0
Local lRet 		:= .F.
Local lSeek		:= .F.
Local lContinua := .T.

If nOpcx == 5 .and. !MsgYESNO("Deseja confirmar a exclus�o desta(s) faixa(s) de desconto?")
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
			ElseIf nOpcx == 5//Exclus�o
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
	MsgAlert("Os Dados n�o foram gravados!","ATEN��O")
	If INCLUI
		RollBackSX8()
	EndIf
EndIf

_oDlg:End()

RestArea(aArea)
RestArea(aAreaSZ2)
Return (lRet)
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �  A610CriaHe  � Autor �Marcelo Iuspa      � Data � 08/07/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Generica para criacao de aHeader                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := A610CriaHeader(ExpC1,ExpC2,ExpL1,ExpL2)           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do Arquivo                                   ���
���          � ExpC2 = Lista com campos nao exibidos (NoFields)			  ���
���          � ExpL1 = Se .T. monta somente o titulo no aHeader           ���
���          �         Se .F. monta aHeader normal                        ���
���          � ExpL2 = Se .T. criara' campos especificos do WALK-THRU     ���
���          �         desde que ExpL1 seja .F. (aHeader normal)          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 = aHeader                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Geral                                                      ���
���          �(MATA610,MATA630,MATA635,MATA093,MATA636,MATA098,MATA099,   ���
���          � MATA272,MATA551,MATA552,FATA140,AACA180A,AACA450...)       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//������������������Ŀ
//� Walk-Thru        �
//��������������������
If !lOnlyFields .And. lWalkThru
	ADHeadRec(cAlias,aRet)
EndIf
dbSetOrder(aSavSX3[1])
dbGoto(aSavSX3[2])
dbSelectArea(OldAlias)
Return(aRet)