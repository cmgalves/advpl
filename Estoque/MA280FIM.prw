#include "rwmake.ch"

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//  Função:    MA280FIM  						         Módulo: SIGAEST          //
//                                                                                //
//  Autor:     Rodrigo O. T. Caetano  					 Data: 17/12/2007         //
//                                                                                //
//  Descrição: Ponto de Entrada no final do Fechamento de Estoque para gerar o    //
//             Saldo Inicial de Mãos-de-obras zerados                             //
//                                                                                //
//  Uso:       plasticos MB												          //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////



///////////////////////
User Function CanIncMOD
///////////////////////
//Rotina para ser executada pelo menu

Private oLeTxt                           //Janela de Dialogo
Private _dDataFec := GetMV("MV_ULMES")   //Data do Fechamento de Estoque

@ 200, 001 To 377, 380 Dialog oLeTxt Title "Geração de Saldos Iniciais para MODs"
@ 002, 004 To 040, 187 Title OemToAnsi("Comentário : ")

@ 009, 020 Say "Esta rotina tem como objetivo gerar Saldos Iniciais  "
@ 019, 020 Say "para Mãos-de-Obras                               "
@ 029, 020 Say "Data do Fechamento de Estoque: "
@ 029, 100 Get _dDataFec  Size 20,10

@ 044, 004 To 060, 187
@ 065, 004 To 085, 187 Title OemToAnsi("Opções : ")

@ 70, 145 BmpButton Type 01 Action Close(oLeTxt)

Activate Dialog oLeTxt Centered

If MsgBox("Tem certeza que deseja gerar saldos iniciais para MODs em "+DToC(_dDataFec)+"?", "Confirma?", "YesNo")
	Processa({|| GeraSB9()}, "Geração de Saldos Iniciais para MODs")
EndIf

Return

///////////////////////
Static Function GeraSB9
///////////////////////

DbSelectArea("SB9")
DbSetOrder(1)  //B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)

DbSelectArea("SB1")
DbSetOrder(1)  //B1_FILIAL+B1_COD
DbSeek(xFilial("SB1")+"MOD",.F.)
Do While Left(SB1->B1_COD,3) == "MOD" .And. SB1->B1_FILIAL == xFilial("SB1") .And. SB1->(!Eof())

	If SB1->B1_TIPO # "MO"
		DbSelectArea("SB1")
		DbSkip()
		Loop
	EndIf

	DbSelectArea("SB9")
	DbSeek(xFilial("SB9")+SB1->B1_COD+SB1->B1_LOCPAD+DToS(_dDataFec),.F.)
	If Found()
		RecLock("SB9",.F.)
		SB9->B9_QINI  := 0
		SB9->B9_VINI1 := 0
	Else
		RecLock("SB9",.T.)
		SB9->B9_FILIAL  := xFilial("SB9")
		SB9->B9_COD     := SB1->B1_COD
		SB9->B9_LOCAL   := SB1->B1_LOCPAD
		SB9->B9_DATA    := _dDataFec
	EndIf
	MsUnLock()

	DbSelectArea("SB1")
	DbSkip()

EndDo

Alert("Processamento Finalizado!")

Return