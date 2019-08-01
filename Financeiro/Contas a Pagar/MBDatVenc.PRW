#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MBDATVENCº Autor ³CLAUDIO ALVES       º Data ³  23/01/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Altera a data do financeiro, contas a pagar.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MBDATVENC()
Private xcPerg01	:= "ALTDTFIN01"
Private xcTitInd	:=	''
Private xcR			:=	Char(13) + Char(10)

ValidPerg()


Pergunte(xcPerg01,.T.)

xcTitInd	:=	MV_PAR01

dbSelectArea('SE3')
dbSetOrder(1)
SE2->(dbSeek(xFilial('SE2') + xcTitInd))


If MsgBox('Deseja Altrerar a data? ' + xcR + 'de  : ' + dToc(MV_PAR05) + xcR + 'para: ' + dToc(MV_PAR06)  , 'ATENÇÃO!!!!!', 'YesNo')

RecLock('SE2', .F.)

	SE2->E2_VENCREA := MV_PAR06

SE2->(MsUnLock())
EndIf


Return()



Static Function ValidPerg

_aArea := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)
xcPerg01 := PadR(xcPerg01,Len(SX1->X1_GRUPO))

xaReg01:={}
aAdd(xaReg01,{xcPerg01,"01","Titulo?            "   ,"mv_ch01","C",14,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","SE2TIT"	})
aAdd(xaReg01,{xcPerg01,"02","Fornecedor         "   ,"mv_ch02","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""		})
aAdd(xaReg01,{xcPerg01,"03","Loja               "   ,"mv_ch03","C",02,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","",""		})
aAdd(xaReg01,{xcPerg01,"04","Nome do Fornecedor "   ,"mv_ch04","C",35,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","",""		})
aAdd(xaReg01,{xcPerg01,"05","Vencimento Real    "   ,"mv_ch05","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","",""		})
aAdd(xaReg01,{xcPerg01,"06","Vencimento Novo    "   ,"mv_ch06","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""		})


For i := 1 To Len(xaReg01)
	If !DbSeek(xcPerg01+xaReg01[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := xaReg01[i,01]
		SX1->X1_ORDEM   := xaReg01[i,02]
		SX1->X1_PERGUNT := xaReg01[i,03]
		SX1->X1_VARIAVL := xaReg01[i,04]
		SX1->X1_TIPO    := xaReg01[i,05]
		SX1->X1_TAMANHO := xaReg01[i,06]
		SX1->X1_DECIMAL := xaReg01[i,07]
		SX1->X1_PRESEL  := xaReg01[i,08]
		SX1->X1_GSC     := xaReg01[i,09]
		SX1->X1_VALID   := xaReg01[i,10]
		SX1->X1_VAR01   := xaReg01[i,11]
		SX1->X1_DEF01   := xaReg01[i,12]
		SX1->X1_CNT01   := xaReg01[i,13]
		SX1->X1_VAR02   := xaReg01[i,14]
		SX1->X1_DEF02   := xaReg01[i,15]
		SX1->X1_CNT02   := xaReg01[i,16]
		SX1->X1_VAR03   := xaReg01[i,17]
		SX1->X1_DEF03   := xaReg01[i,18]
		SX1->X1_CNT03   := xaReg01[i,19]
		SX1->X1_VAR04   := xaReg01[i,20]
		SX1->X1_DEF04   := xaReg01[i,21]
		SX1->X1_CNT04   := xaReg01[i,22]
		SX1->X1_VAR05   := xaReg01[i,23]
		SX1->X1_DEF05   := xaReg01[i,24]
		SX1->X1_CNT05   := xaReg01[i,25]
		SX1->X1_F3      := xaReg01[i,26]
		MsUnlock()
		DbCommit()
	EndIf
Next

Return