#include "Protheus.ch"
#include "Topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DADOSAD   ºAutor  ³Microsiga           º Data ³  10/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Dados adicionais para realizar o calculo do lucro liquido   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
oMsPorc := MsNewGetDados():New(	013,;							&& 01 nTop    - Distancia entre a MsGetDados e o extremidade superior do objeto que a contém.
								001,;							&& 02 nLeft   - Distancia entre a MsGetDados e o extremidade esquerda do objeto que a contém.
								130,;					    	&& 03 nBottom - Distancia entre a MsGetDados e o extremidade inferior do objeto que a contém.
								252,;					    	&& 04 nRight  - Distancia entre a MsGetDados e o extremidade direita do objeto que a contém.
								GD_INSERT+GD_DELETE+GD_UPDATE,;	&& 05
								Nil,;					        && 06 cLinhaOk - Função executada para validar o contexto da linha atual do aItens.
								"Allwaystrue()",;				&& 07 cTudoOk  - Função executada para validar o contexto geral da MsGetDados (todo aItens).
								"",;							&& 08
								aAltera,;						&& 09
								Nil,;                        	&& 10 freeze
								999,;							&& 11 nMax - Número máximo de linhas permitidas. Valor padrão 99.
								Nil,;							&& 12 fieldok
								Nil,;							&& 13 superdel
								Nil,;							&& 14 delok
								oDlg,; 	     					&& 15 oWnd - Objeto no qual a MsGetDados será criada.
								aHPorc,;  						&& 16 Cabeçalho da GetDados
								@aIPorc)						&& 17 Itens da GetDados

Activate MsDialog oDlg On Init EnchoiceBar(oDlg, bOk, bCancel,,aButtons) Centered


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Car_Array ºAutor  ³Microsiga           º Data ³  10/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os campos da grid.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaDadosºAutor  ³Microsiga           º Data ³  10/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava Dados na tabela SZ1                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaDadosºAutor  ³Microsiga           º Data ³  10/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava Dados na tabela SZ1                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
