//058779
#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuComis  ºAutor  ³INOVA               º Data ³  18/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Regras de Margem de Desconto.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PMB-P10                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function AtuComis(cMarg)

Local xcRegVend		:=	cMarg
Local xcMens		:=	''
Local xnComissao   	:=	5
Local xnPDesc    	:=	0
Local xcEstado		:=	""
Local xlRet      	:=	.T.
Local aRet       	:=	{}
Private xaFaixas  	:=	{}
Private xcQuery		:=	""
Private xcR			:=	Char(13) + Char(10)
Private xaAlias 	:= 	{ {Alias()},{"ZZ1"},{"SA3"},{"DA0"},{"DA1"}}

U_ufAmbiente(xaAlias, "S")



DA0->(dbSetOrder(1))

If DA0->(dbSeek(xFilial("DA0") + M->C5_TABELA))
	If DA0->DA0_ZZMARG == '1'
		dbSelectArea('SA1')
		dbGoTop()
		SA1->(dbSeek(xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJACLI))
		xcEstado := SA1->A1_EST
		If SA1->A1_COMIS > 0
			xnComissao := SA1->A1_COMIS
		Else
			SZ3->(DbSetOrder(1))
			If SZ3->(DbSeek(xFilial("SZ3") + Iif(M->C5_FRETEMB $ '1|2','C','F') + M->C5_FRETEMB))
				xnFrtRed := SZ3->Z3_PERFRET
				&& UF X % de Frete
			EndIf
			
			xnTotLista	:=	(M->C5_ZTOTPED + M->C5_ZTOTDES)
			xnPdesc		:=	Round((M->C5_ZTOTDES / (M->C5_ZTOTPED + M->C5_ZTOTDES)) * 100,2)
			
			cAliasZZ2	:= GetNextAlias()
			
			xcQuery := 			"SELECT "
			xcQuery += xcR + 	"	ZZ2_COD, ZZ2_SEQUEN, ZZ2_COMIS, ZZ2_BLOQUE  "
			xcQuery += xcR + 	"FROM  "
			xcQuery += xcR + 	"	" + RetSqlName('ZZ2') + " "
			xcQuery += xcR + 	"WHERE "
			xcQuery += xcR + 	"	D_E_L_E_T_ = '' AND "
			xcQuery += xcR + 	"	ZZ2_FILIAL = '" + xFilial('ZZ2') + "' AND "
			xcQuery += xcR + 	"	ZZ2_COD = '" + AllTrim(xcRegVend) + "' AND "
			xcQuery += xcR + 	"	ZZ2_VALDE <=  " + Transform(xnTotLista,"999999.99") + " AND "
			xcQuery += xcR + 	"	ZZ2_VALATE >  " + Transform(xnTotLista,"999999.99") + " AND "
			xcQuery += xcR + 	"	" + Transform(xnPdesc,"999999.99") + " >= ZZ2_PERCDE AND "
			xcQuery += xcR + 	"	" + Transform(xnPdesc,"999999.99") + " < ZZ2_PERCAT "
			
			//Gera um arquivo com a query acima.
			MemoWrite("Retorna Margem do Representante.SQL",xcQuery)
			
			if select("cAliasZZ2") > 0
				cAliasZZ2->(dbclosearea())
			endif
			
			//Gera o Arquivo de Trabalho
			TcQuery StrTran(xcQuery,xcR,"") New Alias cAliasZZ2
			
			dbSelectArea('cAliasZZ2')
			cAliasZZ2->(dbGoTop())
			
			Count to xcConta
			
			dbSelectArea('cAliasZZ2')
			cAliasZZ2->(dbGoTop())
			
			If xcConta == 1
				xnComissao		:=	cAliasZZ2->ZZ2_COMIS
				M->C5_COMIS1	:=	cAliasZZ2->ZZ2_COMIS
			ElseIf xcConta == 0
				xcMens	:=	"MARGEM NÃO CADASTRADA" + xcR + xcR + "INFORMA A LUCILENE BONETI"
				xcMens	+=	"TOTAL DO PEDIDO: ( R$ " + Alltrim(Str(xnTotLista))+ " )" + xcR
				xcMens	+=	"O DESCONTO CONCEDIDO: " + Alltrim(str(xnPdesc)) + "% - ( R$ " + Alltrim(Str(Round((xnTotLista*xnPdesc)/100,2)))+ " )" + xcR
				Alert(xcMens, "AVISO MB")
				xlRet	:=	.F.
				xnComissao		:=	4
				M->C5_COMIS1	:=	4
			ElseIf xcConta >= 2
				xcMens	:=	"ERRO NO CADASTRO DE MARGEM" + xcR + "MARGEM DUPLICADA PARA A FAIXA" + xcR
				While !(cAliasZZ2->(EOF()))
					xcMens	:=	"CODIGO MARGEM: " + AllTrim(cAliasZZ2->ZZ2_COD) + " SEQUENCIA: " + AllTrim(cAliasZZ2->ZZ2_SEQUEN) + xcR
					dbSelectArea("cAliasZZ2")
					cAliasZZ2->(dbSkip())
				Enddo
				Alert(xcMens, "AVISO MB")
				xlRet	:=	.F.
			EndIf
		EndIf
	Else
		xnComissao	:=	5
		If DA0->DA0_ZCOMIS <= 0
			MsgBox("CADASTRO DE TABELAS " + xcR + "COMISSÃO CADASTRADA ERRADA, TABELA: " + DA0->DA0_CODTAB + xcR + "CORRIGIR COMISSÃO DA TABELA","AVISO MB")
			xnComissao	:=	DA0->DA0_ZCOMIS
		ElseIf DA0->DA0_ZCOMIS <> M->C5_COMIS1
			MsgBox("CADASTRO DE TABELAS " + xcR + "COMISSÃO DA TABELA: " + DA0->DA0_CODTAB + xcR + "ESTÁ DIFERENTE DA COMISSÃO INFORMADA" + xcR + "SERÁ CORRIGIDO DE ACORDO COM A TABELA","AVISO MB")
			xnComissao	:=	DA0->DA0_ZCOMIS
		EndIf
	EndIf
Else
	IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
		MsgInfo("O PEDIDO DEVE TER TABELA DE PREÇO!","AVISO MB")
	ENDIF
EndIf  

If SA3->A3_TIPO == 'I'

 nComis1 := SA3->A3_COMIS
    _lRet := .T.

EndIf

aRet := {xlRet,xnComissao}

U_ufAmbiente(xaAlias, "R")                                                                                                                `
Return(aRet)

//*********************************************
Static Function ValFaixa(_nFaixaAtu)

Local _nVlrRet := 0

For nI := (_nFaixaAtu-1) to 1 Step -1
	If !xaFaixas[_nFaixaAtu] == xaFaixas[nI]
		_nVlrRet := xaFaixas[nI]
		Exit
	EndIf
Next


Return(_nVlrRet)

