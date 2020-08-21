#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Várias   ³ Autor ³ Claudio Alves        ³ Data ³ 12/03/2014 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funções de apoio para utilização geral                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Protheus em geral                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/***********************************************************************************/
// Funcao para salvar o ambiente
//Para salvar e restaurar o ambiente basta criar uma variável array
//como private e informar quais são as tabelas que deseja salvar/restaurar
//Conforme abaixo:
//private xaAlias := { {Alias()},{"SC7"}}

// Salva o ambiente atual e Restaura
//ufAmbiente(xaAlias, xcTipo), onde xaAlias é o array com as tabelas e o xcTipo indica se Salva(S) ou Restaura(R)


User Function ufAmbiente(aAlias, cTipo)
Local _ni
Local xaAlias	:= 	aAlias
Local xcTipo	:=	cTipo


Prepare Environment EMPRESA '01' FILIAL '01' 


DBSELECTAREA('PA1')

If xcTipo = "S"
	For _ni := 1 To Len(xaAlias)
		dbSelectArea(xaAlias[_ni,1])
		AADD(xaAlias[_ni],indexord())
		AADD(xaAlias[_ni],Recno())
	Next
	Return
ElseIf xcTipo = "R"
	For _ni := Len(xaAlias) To 1 Step -1
		dbSelectArea(xaAlias[_ni,1])
		dbSetOrder(xaAlias[_ni,2])
		dbGoTo(xaAlias[_ni,3])
	Next
	Return
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xufValComiºAutor  ³Microsiga           º Data ³  10/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Validação da Comissão                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xufValComi(xcVend, xcCli, xcLoj, xcTab, xnCom, xcEnt)
Local xlRet			:=	.T.
Local xcVendedor	:=	xcVend
Local xcCliente		:=	xcCli
Local xcLoja		:=	xcLoj
Local xcTabela		:=	xcTab
Local xcComissao	:=	xnCom
Local xcEntrada		:=	xcEnt
Private xcR			:=	Char(13) + Char(10)
Private xaAlias 	:= 	{ {Alias()},{"SC5"},{"SA3"},{"SA1"},{"DA0"},{"DA1"}}

U_ufAmbiente(xaAlias, "S")

If xcEntrada	==	'00'
	dbSelectArea('DA0')
	DA0->(dbSeek(xFilial('DA0') + xcTabela))
	If DA0->DA0_ZZMARG == '2' //Tabela promocional, prioriza a comissão na tabela
		If DA0->DA0_ZCOMIS == 0
			Alert("T A B E L A   P R O M O C I O N A L" + xcR + "NÃO TEM COMISSÃO INFORMADA" + xcR + "INFORME O COMERCIAL!","ATENÇÃO")
			xlRet	:=	.F.
			Return(xlRet)
		EndIf
		If M->C5_COMIS1 <> DA0->DA0_ZCOMIS
			Alert('TABELA PROMOCIONAL' + xcR + 'NÃO ALTERA COMISSÃO', 'ATENÇÃO')
			xlRet	:=	.F.
			Return(xlRet)
		EndIf
		
	EndIf
ElseIf xcEntrada == '01'
	dbSelectArea('DA0')
	DA0->(dbSeek(xFilial('DA0') + xcTabela))
	
	If DA0->DA0_ZZMARG == '2' .AND. xlRet//Tabela promocional, prioriza a comissão na tabela
		If M->C5_COMIS1 == DA0->DA0_ZCOMIS 
			xlRet := .F.
		EndIf
	EndIf
	
	dbSelectArea('SA1')
	SA1->(dbSeek(xFilial('SA1') + xcCliente + xcLoja ))
	
	If M->C5_COMIS1 == SA1->A1_COMIS .AND. xlRet
		xlRet := .F.
	EndIf
	
	
EndIf

//U_ufAmbiente(xaAlias, "R")
Return(xlRet)
