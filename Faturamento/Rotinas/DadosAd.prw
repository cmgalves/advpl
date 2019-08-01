#include "Protheus.ch"
#include "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DADOSAD   �Autor  �Microsiga           � Data �  10/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Dados adicionais para realizar o calculo do lucro liquido   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DadosAd()
Local aAltera  := {"Z1_ESTADO","Z1_ICMS","Z1_SITTRIB","Z1_PERFRET"}
Local aButtons := {}
Local cTitulo  := "Porcentagem de Frete"
Local bOk      := {|| GravaDados(oMsPorc:Acols)}
Local bCancel  := {|| oDlg:end()}

Private oDlg,oMsPorc        
Private aHPorc := {}
Private aIPorc := {}

aHPorc := Car_Array()
aIPorc := LoadDados()

DEFINE MSDIALOG oDlg  TITLE cTitulo FROM 000,000 to 262,500 PIXEL
oMsPorc := MsNewGetDados():New(	013,;							&& 01 nTop    - Distancia entre a MsGetDados e o extremidade superior do objeto que a cont�m.
								001,;							&& 02 nLeft   - Distancia entre a MsGetDados e o extremidade esquerda do objeto que a cont�m.
								130,;					    	&& 03 nBottom - Distancia entre a MsGetDados e o extremidade inferior do objeto que a cont�m.
								252,;					    	&& 04 nRight  - Distancia entre a MsGetDados e o extremidade direita do objeto que a cont�m.
								GD_INSERT+GD_DELETE+GD_UPDATE,;	&& 05
								Nil,;					        && 06 cLinhaOk - Fun��o executada para validar o contexto da linha atual do aItens.
								"Allwaystrue()",;				&& 07 cTudoOk  - Fun��o executada para validar o contexto geral da MsGetDados (todo aItens).
								"",;							&& 08
								aAltera,;						&& 09
								Nil,;                        	&& 10 freeze
								999,;							&& 11 nMax - N�mero m�ximo de linhas permitidas. Valor padr�o 99.
								Nil,;							&& 12 fieldok
								Nil,;							&& 13 superdel
								Nil,;							&& 14 delok
								oDlg,; 	     					&& 15 oWnd - Objeto no qual a MsGetDados ser� criada.
								aHPorc,;  						&& 16 Cabe�alho da GetDados
								@aIPorc)						&& 17 Itens da GetDados

Activate MsDialog oDlg On Init EnchoiceBar(oDlg, bOk, bCancel,,aButtons) Centered


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Car_Array �Autor  �Microsiga           � Data �  10/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega os campos da grid.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Car_Array()
Local cListaCpo := ""
Local aRet      := {}

cListaCpo := "Z1_ESTADO,Z1_ICMS,Z1_SITTRIB,Z1_PERFRET,"

DbSelectArea("SX3") 
SX3->(DbGoTop())
SX3->(DbSeek("SZ1"))

While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SZ1"
      If X3Uso(SX3->X3_USADO) .And. Upper(Alltrim(SX3->X3_CAMPO)) $ cListaCpo
         Aadd(aRet, {Alltrim(SX3->X3_TITULO)	,;
         				SX3->X3_CAMPO			,;
          				SX3->X3_PICTURE			,;
          				SX3->X3_TAMANHO			,;
          				SX3->X3_DECIMAL			,;
          				SX3->X3_VLDUSER			,;
          				SX3->X3_USADO			,;
          				SX3->X3_TIPO			,;
          				SX3->X3_F3				,;
          				SX3->X3_CONTEXT			,;
          				""})
      Endif
      SX3->(DbSkip())
Enddo

Return(aRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaDados�Autor  �Microsiga           � Data �  10/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Dados na tabela SZ1                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaDados(aDados)
Local nY     := 0
Local lOpcao := .T.

	For nY := 1 To Len(aDados)
		If aDados[nY][5] == .F.
			SZ1->(DbSetOrder(1))
			If SZ1->(DbSeek(xFilial("SZ1")+aDados[nY][1]))
				lOpcao := .F.		
			Else
				lOpcao := .T.
			EndIf

			RecLock("SZ1",lOpcao)
				SZ1->Z1_FILIAL  := xFilial("SZ1")
				SZ1->Z1_ESTADO  := aDados[nY][1]
				SZ1->Z1_ICMS    := aDados[nY][2]
				SZ1->Z1_PERFRET := aDados[nY][3]
				SZ1->Z1_SITTRIB := aDados[nY][4]
			SZ1->(MsUnLock())
		EndIf	
	Next nY	
      
oDlg:end()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaDados�Autor  �Microsiga           � Data �  10/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Dados na tabela SZ1                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LoadDados()
Local nY      := 0
Local aTemp   := {}

SZ1->(DbGoTop())
SZ1->(DbSetOrder(1))  

If SZ1->(EOF())
	//aAdd(aTemp, {"",0,"1",0,.F.})
    aAdd(aTemp , Array(Len(aHPorc)+1) )
	aTemp[Len(aTemp), Len(aHPorc[1]) ] := .F.
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_ESTADO"		})] := ""
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_ICMS"    	})] := 0
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_SITTRIB"    })] := ""
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_PERFRET"    })] := 0

EndIf
//Z1_ESTADO,Z1_ICMS,Z1_SITTRIB,Z1_PERFRET,
While !SZ1->(EOF())
    aAdd(aTemp , Array(Len(aHPorc)+1) )
	aTemp[Len(aTemp), Len(aTemp[1]) ] := .F.
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_ESTADO"		})] := SZ1->Z1_ESTADO
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_ICMS"    	})] := SZ1->Z1_ICMS
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_SITTRIB"    })] := SZ1->Z1_SITTRIB
	aTemp[Len(aTemp),Ascan(aHPorc,{|x| AllTrim(x[2]) == "Z1_PERFRET"    })] := SZ1->Z1_PERFRET
	//aAdd(aTemp, {SZ1->Z1_ESTADO,SZ1->Z1_ICMS,SZ1->Z1_PERFRET,SZ1->Z1_SITTRIB,.f.})
	SZ1->(DbSkip())
	
EndDo

Return(aTemp)
