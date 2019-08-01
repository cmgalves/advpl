#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  ºAutor  ³Cassiano G. Ribeiro º Data ³  06/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para execução de validação dos pedidos    º±±
±±º          ³ a serem faturados. Utilizado para inclusao do tratamento deº±±
±±º          ³ restrição de volumes.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-MB                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460MARK()
Local aArea		:=	GetArea()
Local aAreaSB1	:=	SB1->(GetArea())
Local aAreaSC5	:=	SC5->(GetArea())
Local aAreaSC9	:=	SC9->(GetArea())
Local aAreaSC6	:=	SC6->(GetArea())
Local cAlias	:=	""
Local _cPedAnt  :=	"" 
Local xlRet		:=	.T.

Private _nCalc		:= 0
Private lRestricao	:= .F.
Private nRestricao	:= 0

Public __aQuebraIt	:= {}



If UPPER(ALLTRIM(FUNNAME()))$ "MATA460A|MATA460B"




xlRet	:=	xsfNotas()


	

EndIf 





If UPPER(ALLTRIM(FUNNAME())) == "MATA460A"//Faturamento Padrao - Modulo de Faturamento	
/*	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajusta SC9 caso necessario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustSC9()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para alimentar array com itens a serem quebrados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC9")
	SC9->(dbGoTop())
	While SC9->(!EOF())
		If (ParamIXB[2] == .F. .And. SC9->C9_OK == ParamIXB[1]) .Or. (ParamIXB[2] == .T. .And. SC9->C9_OK <> ParamIXB[1])
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(xFilial("SC5")+SC9->C9_PEDIDO+SC9->C9_CLIENTE+SC9->C9_LOJA))
				If !Empty(SC5->C5_REDESP)
					SA4->(dbSetOrder(1))
					If SA4->(dbSeek(xFilial("SA4")+SC5->C5_REDESP))
						lRestricao := (SA4->A4_ZZRESTR=='1')
						nRestricao := SA4->A4_ZZQTDVL
						If lRestricao .and. nRestricao <> 0
							If _cPedAnt <> SC9->C9_PEDIDO .and. !Empty(_cPedAnt)
								_nCalc := 0
							EndIf
							SB1->(dbSetOrder(1))
							If SB1->(dbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
								_nCalc  += ((cAlias)->C9_QTDLIB / SB1->B1_ZZVOL) * SB1->B1_QE
								_cPedAnt := SC9->C9_PEDIDO
							EndIf
							If _nCalc == nRestricao
								AADD(__aQuebraIt,{SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_SEQUEN})
								_nCalc := 0
								_cPedAnt := SC9->C9_PEDIDO
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		SC9->(dbSkip())
	EndDo
RestArea(aAreaSC9)*/

ElseIf UPPER(ALLTRIM(FUNNAME())) == "MATA460B"//Faturamento por Carga - Modulo de OMS

/*Private aAreaDAK := DAK->(GetArea())

	DbSelectArea("DAK")
	DAK->(dbGoTop())
	While DAK->(!EOF())
		If (ParamIXB[2] == .F. .And. DAK->DAK_OK == ParamIXB[1]) .Or. (ParamIXB[2] == .T. .And. DAK->DAK_OK <> ParamIXB[1])
			cAlias := GetNextAlias()
			BeginSql Alias cAlias
				SELECT *
				  FROM %TABLE:DAI010% DAI, %TABLE:SC9010% C9
				 WHERE DAI.DAI_FILIAL = %XFILIAL:DAI%
				   AND C9.C9_FILIAL = %XFILIAL:SC9%
				   AND DAI.DAI_FILIAL = C9.C9_FILIAL
				   AND DAI.DAI_COD = C9.C9_CARGA
				   AND DAI.DAI_SEQCAR = C9.C9_SEQCAR
				   AND DAI.DAI_PEDIDO = C9.C9_PEDIDO
				   AND DAI.DAI_COD = %EXP:DAK->DAK_COD%	
				 ORDER BY C9.C9_CLIENTE, C9.C9_LOJA, C9.C9_PEDIDO, C9.C9_ITEM
			EndSql
			Count to nCnt
			If nCnt > 0
				(cAlias)->(dbGoTop())
				While (cAlias)->(!Eof())
					SC5->(dbSetOrder(1))
					If SC5->(dbSeek(xFilial("SC5")+(cAlias)->C9_PEDIDO+(cAlias)->C9_CLIENTE+(cAlias)->C9_LOJA))
						If !Empty(SC5->C5_REDESP)
							SA4->(dbSetOrder(1))
							If SA4->(dbSeek(xFilial("SA4")+SC5->C5_REDESP))
								lRestricao := (SA4->A4_ZZRESTR=='1')
								nRestricao := SA4->A4_ZZQTDVL
								If lRestricao .and. nRestricao <> 0
									If _cPedAnt <> (cAlias)->C9_PEDIDO .and. !Empty(_cPedAnt)
										_nCalc := 0
									EndIf
									SB1->(dbSetOrder(1))
									If SB1->(dbSeek(xFilial("SB1")+(cAlias)->C9_PRODUTO))
										_nCalc  += ((cAlias)->C9_QTDLIB / SB1->B1_ZZVOL ) * SB1->B1_QE
										_cPedAnt := (cAlias)->C9_PEDIDO
									EndIf
									If _nCalc == nRestricao
										AADD(__aQuebraIt,{(cAlias)->C9_PEDIDO + (cAlias)->C9_ITEM + (cAlias)->C9_SEQUEN})
										_nCalc := 0
										_cPedAnt := (cAlias)->C9_PEDIDO
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					(cAlias)->(dbSkip())
				EndDo
				(cAlias)->(dbCloseArea())
			EndIf
		EndIf
		DAK->(dbSkip())
	EndDo
RestArea(aAreaDAK)*/
EndIf
RestArea(aAreaSC5)
RestArea(aAreaSB1)
RestArea(aArea)
Return (xlRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTSC9  ºAutor  ³Cassiano G. Ribeiro º Data ³  11/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta SC9 caso haja restricao de volumes.                 º±±
±±º          ³ MATA460A                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustSC9()
Local aAreaSC9 	:= SC9->(GetArea())
Local aPedidos	:= {}//Pedidos Marcados
Private _nCalc	:= 0
Private nQtdAnte:= 0
Private nQuebra	:= 0
Private nQtdLib1:= 0
Private nQtdLib2:= 0
Private nAux	:= 0
Private cItemAlt:= ""
Private aQtNewIt:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Guarda os pedidos marcados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC9")
SC9->(dbGoTop())
While SC9->(!EOF())
	If (ParamIXB[2] == .F. .And. SC9->C9_OK == ParamIXB[1]) .Or. (ParamIXB[2] == .T. .And. SC9->C9_OK <> ParamIXB[1])
		AADD(aPedidos,{SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA})
	EndIf
	SC9->(dbSkip())
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta SC9 caso necessario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to Len(aPedidos)
	U_MontSC9(aPedidos[nI,1],.T.)
Next nI
RestArea(aAreaSC9)
Return


Static Function xsfNotas()
Local xcNomUser	:=	''
Local xcQuery	:=	""
Local xcR		:=	Char(13) + Char(10)

xcQuery += xcR + 	"	SELECT  "
xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA, SUM(E1_SALDO) E1_SALDO  "
xcQuery += xcR + 	"	FROM  "
xcQuery += xcR + 	"		 SE1010 F  "
xcQuery += xcR + 	"	WHERE  "
xcQuery += xcR + 	"		F.D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"		E1_TIPO NOT IN ('RA ', 'NCC') AND   "
xcQuery += xcR + 	"		E1_CLIENTE = '" + SC9->C9_CLIENTE + "' AND "
xcQuery += xcR + 	"		E1_LOJA = '" + SC9->C9_LOJA + "' AND "
xcQuery += xcR + 	"		E1_FILIAL = '01'  AND  "
xcQuery += xcR + 	"		CONVERT(DATETIME,E1_VENCREA,103) - GETDATE() < -1  "
xcQuery += xcR + 	"	GROUP BY  "
xcQuery += xcR + 	"		E1_CLIENTE, E1_LOJA  "

//Gera um arquivo com a query acima.
MemoWrite("M460MARK BLOQUEIA NOTA.SQL",xcQuery)

if select("XTT") > 0
	XTT->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTT


XTT->(dbGoTop())

//If XTT->E1_SALDO > '0'
 //	MsgStop('Cliente com pendências financeiras. Favor procurar a Patrícia no Depto. Financeiro A')
   //	Return .F.
//Else
//	MsgStop('Cliente com pendências financeiras. Favor procurar a Patrícia no Depto. Financeiro')
//	Return .F.

//EndIf

XTT->(dbCloseArea())

Return .T.

