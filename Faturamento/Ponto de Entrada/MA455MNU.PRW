#Include "Protheus.ch"
#Include "TopConn.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MTA455NL   ºAutor  ³Claudio Alves       º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada chamado no Início da rotina do PV          º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10-PMB.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA455MNU()

Aadd(aRotina, { "Corte Vertical", "U_xufCorte()", 0, 4, Nil } )

Return Nil



/*
==============================================
Função para cortar verticalmente
==============================================
*/

User Function xufCorte()

//Retorna tela com pedidos disponíveis
//Os pedidos devem estar liberados no estoque e no crédito
//ou seja, disponíveis para o faturamento.
//para tanto os campos C9_NFISCAL, C9_BLEST devem estar em branco e o Campo C9_BLCRED = '02'
/*
Segue a consulta de exemplo que traz os pedidos liberados
e com volumes maior que o limite da transportadora

Segue abaixo os Códigos de Bloqueio da Tabela SC9:


Campo: C9_BLCRED : Liberado 01 – Bloqueado p/ crédito 02 MV_BLQCRED = t 04 - Limite de Crédito Vencido 05 - Bloqueio Crédito por Estorno 06 – por risco 09 -  Rejeitado 10 - Já Faturado.
Campo: C9_BLEST: Liberado 02 - Bloqueio de Estoque 03 - Bloqueio Manual 10 - Já Faturado.

SELECT
C9_PEDIDO PEDIDO, C5_REDESP TRANSP,
MAX(A4_ZZQTDVL) VLTRANSP,
SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END) VOLUME,
SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END) / MAX(A4_ZZQTDVL) CARGAS,
'PD:' + C9_PEDIDO +' - TR: '+ C5_REDESP +' - VT:'+
RTRIM(CONVERT(VARCHAR(20), MAX(A4_ZZQTDVL))) +' - VL:'+
RTRIM(CONVERT(VARCHAR(20),SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END))) +' - QC '+
RTRIM(CONVERT(VARCHAR(20),SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END) / MAX(A4_ZZQTDVL))) TEXTO

FROM
SC9010 A INNER JOIN
SB5010 B ON
C9_PRODUTO = B5_COD INNER JOIN
SC5010 C ON
C9_PEDIDO = C5_NUM INNER JOIN
SA4010 D ON
C5_REDESP = A4_COD
WHERE
C9_BLEST = '02' AND
C9_BLCRED = '01' AND
C9_FILIAL = '01' AND
C5_FILIAL = '01' AND
B5_FILIAL = '01' AND
A4_FILIAL = '' AND
C9_NFISCAL = '' AND
A.D_E_L_E_T_ = '' AND
B.D_E_L_E_T_ = '' AND
C.D_E_L_E_T_ = '' AND
D.D_E_L_E_T_ = '' AND
A4_ZZQTDVL > 0
GROUP BY
C9_PEDIDO, C5_REDESP
HAVING
SUM(C9_QTDLIB/B5_QE1)>MAX(A4_ZZQTDVL)

*/

xsfRetPeds()

Return Nil

/*
==============================================
Valida o pedido selecionado para o corte
==============================================
*/
Static Function xsfRetPeds()
Local xaEnv		:=	{}
Local xaPeds	:=	{}
Local xcText	:=	''
Local xi		:=	0
Local xcTit		:=	'Pedidos para Corte'
Local xcR		:=	Char(13)+Char(10)

xaPeds	:=	xsfPedidos()

For xi := 1 to Len(xaPeds)
	xcText	+=	xaPeds[xi][2] + xcR
Next xi

If !Empty(xcText)
	If MsgYesNo(xcText,  xcTit)
		xsfDados(xaPeds)
		Alert('Finalizado')
	EndIf
Else
	Alert('Não há pedidos disponíveis')
EndIf


Return()


/*
==============================================
Valida o pedido selecionado para o corte
==============================================
*/
Static Function xsfPedidos()
Local xaEnv		:=	{}
Local xaRet		:=	{}
Local xnDist	:=	0

xaEnv	:=	{'RET_PEDIDOS_PARA_CORTE'}

xsfRetTrb(xaEnv)

Do While !(XTRB->(EOF()))
	aAdd(xaRet, {AllTrim(XTRB->PEDIDO),;
	AllTrim(XTRB->TEXTO), ;
	AllTrim(XTRB->VLTRANSP), ;
	AllTrim(XTRB->VOLUME)})
	XTRB->(dbSkip())
End Do

Return(xaRet)

/*
==============================================
Valida o pedido selecionado para o corte
==============================================
*/
Static Function xsfDados(xaPed)
Local xaEnv		:=	{}
Local xaDados	:=	{}
Local xaGrava	:=	{}
Local xaPedido	:=	xaPed
Local xi		:=	0
Local xa		:=	0
Local xb		:=	0
Local xc		:=	0
Local xv		:=	0
Local xcQtdVol	:=	0
Local xcTotVol	:=	0


For xi := 1 to Len(xaPedido)
	xaEnv	:=	{'RET_ITENS_PEDIDO', xaPedido[xi][1]}
	xcQtdVol	:=	0
	xcTotVol	:=	0
	xc 			:= 	1
	xa 			:= 	0
	xv 			:= 	2
	xcCorte		:=	''
	xaDados		:=	{}
	
	xsfRetTrb(xaEnv) //Traz os itens do pedido
	
	//Alimenta o Array com os pedidos prontos para o corte
	Do While!(XTRB->(EOF()))
		aAdd(xaDados, {XTRB->C9_FILIAL, ;		//01-Filial
		XTRB->C9_PEDIDO, ;		// 02 - Pedido
		XTRB->C9_ITEM, ;		// 03 - Item
		XTRB->C9_CLIENTE, ;		// 04 - Cliente
		XTRB->C9_LOJA, ;		// 05 - Loja
		XTRB->C9_PRODUTO, ;		// 06 - Produto
		XTRB->C9_QTDLIB, ;		// 07 - Qtde Liberada
		XTRB->B5_QE1, ;			// 08 - Quantidade por Volume
		XTRB->VOLUMES, ;		// 09 - Quantidade de Volumes
		XTRB->C9_DATALIB, ;		// 10 - Data da Libeação
		XTRB->C9_SEQUEN, ;		// 11 - Sequencia
		XTRB->C9_GRUPO, ;		// 12 - Grupo
		XTRB->C9_PRCVEN, ;		// 13 - Preço de Venda
		XTRB->C9_BLEST, ;		// 14 - Bloqueio de estoque
		XTRB->C9_BLCRED, ;		// 15 - Bloqueio de Crédito
		XTRB->C9_LOCAL, ;		// 16 - Local
		XTRB->C9_TPCARGA, ;		// 17 - Tipo de Carga
		XTRB->C9_QTDLIB2, ;		// 18 - Quantidade Liberada unidade 2
		XTRB->C9_POTENCI, ;		// 19 - Potencia
		XTRB->C9_RETOPER, ;		// 20 - Retorno de Operação
		XTRB->C9_TPOP, ;		// 21 - Tipo de Operação
		XTRB->C9_DATENT, ;		// 22 - Data de Entrega
		XTRB->C5_REDESP, ;		// 23 - Redespacho - Transportadora
		XTRB->A4_ZZQTDVL, ;		// 24 - Quantidade de Volumes permitido na transportadora
		XTRB->UTIL})			// 25 - Quantidade já utilizada
		xcTotVol	+=	XTRB->VOLUMES
		If xcQtdVol == 0
			xcQtdVol	:=	XTRB->A4_ZZQTDVL
		EndIf
		XTRB->(dbSkip())
	End Do
	
	xb	:=	Len(xaGrava)
	
	For xa := 1 To Len(xaDados)
		
		If xc > Len(xaDados)
			xaGrava[xa+xb][07]	+=	xaDados[xa][08]
			xaGrava[xa+xb][09]	+=	1
			xaGrava[xa+xb][18]	+=	ConvUM(xaDados[xa][06],xaDados[xa][08],0,2)
		Else
			aAdd(xaGrava, {xaDados[xa][01], ;
			xaDados[xa][02], ;
			xaDados[xa][03], ;
			xaDados[xa][04], ;
			xaDados[xa][05], ;
			xaDados[xa][06], ;
			xaDados[xa][08], ;
			xaDados[xa][08], ;
			1, ;
			xaDados[xa][10], ;
			StrZero(xv,2), ;
			xaDados[xa][12], ;
			xaDados[xa][13], ;
			xaDados[xa][14], ;
			xaDados[xa][15], ;
			xaDados[xa][16], ;
			xaDados[xa][17], ;
			ConvUM(xaDados[xa][06],xaDados[xa][08],0,2), ;
			xaDados[xa][19], ;
			xaDados[xa][20], ;
			xaDados[xa][21], ;
			xaDados[xa][22], ;
			xaDados[xa][23], ;
			xaDados[xa][24], ;
			xaDados[xa][25]})
			If xv > 2
				xb++
			EndIf
		EndIf
		
		xc++
		
		If xc > xcQtdVol
			xc := 1
			xv++
		EndIf
		
		If Len(xaDados) == xa
			xa := 0
		EndIf
		
		xcTotVol--
		
		If xcTotVol == 0
			Exit
		EndIf
	Next xa
	
Next xi

xsfGeraCrt(xaGrava)
xsfGravaC9(xaGrava)

Return()


/*
=================================================
Grava o Sc9 com os dados dos pedidos para o corte
A sequencia vai ser o fator de quebra
=================================================
*/
Static Function xsfGravaC9(xaGrava)
Local	xaDados		:=	xaGrava
Local	xi   		:=	0
Local 	xlAcha		:=	.T.
Local	xaPedi		:=	{}
Private xaAlias 	:= 	{ {Alias()},{'SC9'}}

//U_ufAmbiente(xaAlias, "S")

dbSelectArea('SC9')
SC9->(dbSetOrder(1)) //C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
SC9->(dbGoTop())


For  xi := 1 to Len(xaDados)
	
	xlAcha	:=	!(SC9->(dbSeek(xaDados[xi][01]+xaDados[xi][02]+xaDados[xi][03]+xaDados[xi][11]+xaDados[xi][06])))
	RecLock('SC9', xlAcha)
	
	SC9->C9_FILIAL	:=	xaDados[xi][01] 			// 01 - Filial
	SC9->C9_PEDIDO	:=	xaDados[xi][02] 			// 02 - Pedido
	SC9->C9_ITEM	:=	xaDados[xi][03]				// 03 - Item
	SC9->C9_CLIENTE	:=	xaDados[xi][04]				// 04 - Cliente
	SC9->C9_LOJA	:=	xaDados[xi][05]				// 05 - Loja
	SC9->C9_PRODUTO	:=	xaDados[xi][06]				// 06 - Produto
	SC9->C9_QTDLIB	:=	xaDados[xi][07]				// 07 - Qtde Liberada
	SC9->C9_DATALIB	:=	sTod(xaDados[xi][10])		// 10 - Data da Libeação
	SC9->C9_SEQUEN	:=	xaDados[xi][11]				// 11 - Sequencia
	SC9->C9_GRUPO	:=	xaDados[xi][12]				// 12 - Grupo
	SC9->C9_PRCVEN	:=	xaDados[xi][13]				// 13 - Preço de Venda
	SC9->C9_BLEST	:=	xaDados[xi][14]				// 14 - Bloqueio
	SC9->C9_BLCRED	:=	xaDados[xi][15]				// 15 - Bloqueio
	SC9->C9_LOCAL	:=	xaDados[xi][16]				// 16 - Local
	SC9->C9_TPCARGA	:=	xaDados[xi][17]				// 17 - Tipo de Carga
	SC9->C9_QTDLIB2	:=	xaDados[xi][18]				// 18 - Quantidade Liberada unidade 2
	SC9->C9_POTENCI	:=	xaDados[xi][19]				// 19 - Potencia
	SC9->C9_RETOPER	:=	xaDados[xi][20]				// 20 - Retorno de Operação
	SC9->C9_TPOP	:=	xaDados[xi][21]				// 21 - Tipo de Operação
	SC9->C9_DATENT	:=	sTod(xaDados[xi][22])		// 22 - Data de Entrega
	
	If aScan(xaPedi, {|xcPedi|xcPedi[1] == xaDados[xi][02]}) == 0
		aAdd(xaPedi, {xaDados[xi][02]})
	EndIf
	
Next xi

//U_ufAmbiente(xaAlias, "R")

/*
Limpa os pedidos liberados originais, esses pedidos não serão
aproveitados porque tem limites de 100 e mais de 100 itens no pedido
*/

xsfLimpPed(xaPedi)

Return Nil

/*
==============================================
Valida o pedido selecionado para o corte
==============================================
*/
Static Function xsfLimpPed(xaPedi)
Local xaPed		:=	xaPedi
Local xi   		:=	0
Local xcQuery 	:=	''
Local xcR		:=	Char(13)+Char(10)

For xi := 1 to Len(xaPed)
	
	xcQuery += "UPDATE SC9010 SET D_E_L_E_T_ = '*' WHERE C9_PEDIDO = '"+xaPed[xi][01]+"' AND D_E_L_E_T_ = '' AND C9_SEQUEN = '01'" + xcR
	
Next xi

TCSQLExec(xcQuery)

Return Nil


/*
==============================================
Valida o pedido selecionado para o corte
==============================================
*/
User Function xufPedLib()
Local xaEnv	:=	{}
Local xlRet	:=	.T.

xaEnv	:=	{'RET_PEDIDO_CORTE', MV_PAR01}

xsfRetTrb(xaEnv)

Do While!(XTRB->(EOF()))
	If XTRB->EST != '02' .OR. XTRB->CRD != '01'
		xlRet := .F.
	EndIf
	XTRB->(dbSkip())
End Do

If !xlRet
	Alert('Pedido: ' + MV_PAR01 + ' ainda não está liberado')
EndIf

Return xlRet


/*
==============================================
Função para Montar a tabela de trabalho
==============================================
*/
Static Function xsfRetTrb(xaEntra)
Local xaVar		:=	{}
Local xcQuery 	:=	''
Local xcR		:=	Char(13)+Char(10)

xaVar	:=	xaEntra

Do Case
	
	Case xaVar[1] == 'RET_PEDIDOS_PARA_CORTE'
		
		xcQuery += xcR + 	"SELECT  "
		xcQuery += xcR + 	"	C9_PEDIDO PEDIDO, C5_REDESP TRANSP,  "
		xcQuery += xcR + 	"	MAX(A4_ZZQTDVL) VLTRANSP,  "
		xcQuery += xcR + 	"	SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END) VOLUME,  "
		xcQuery += xcR + 	"	SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END) / MAX(A4_ZZQTDVL) CARGAS,  "
		xcQuery += xcR + 	"	'PD:' + C9_PEDIDO +' - TR: '+ C5_REDESP +' - VT:'+  "
		xcQuery += xcR + 	"	RTRIM(CONVERT(VARCHAR(20), MAX(A4_ZZQTDVL))) +' - VL:'+  "
		xcQuery += xcR + 	"	RTRIM(CONVERT(VARCHAR(20),SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END))) +' - QC '+  "
		xcQuery += xcR + 	"	RTRIM(CONVERT(VARCHAR(20),SUM(C9_QTDLIB / CASE WHEN B5_QE1 = 0 THEN 1 ELSE B5_QE1 END) / MAX(A4_ZZQTDVL))) TEXTO  "
		xcQuery += xcR + 	"FROM  "
		xcQuery += xcR + 	"	SC9010 A INNER JOIN "
		xcQuery += xcR + 	"	SB5010 B ON "
		xcQuery += xcR + 	"	C9_PRODUTO = B5_COD INNER JOIN "
		xcQuery += xcR + 	"	SC5010 C ON "
		xcQuery += xcR + 	"	C9_PEDIDO = C5_NUM INNER JOIN "
		xcQuery += xcR + 	"	SA4010 D ON "
		xcQuery += xcR + 	"	C5_REDESP = A4_COD "
		xcQuery += xcR + 	"WHERE  "
		xcQuery += xcR + 	"	C9_BLEST = '02' AND "
		xcQuery += xcR + 	"	C9_BLCRED = '01' AND "
		xcQuery += xcR + 	"	C9_FILIAL = '01' AND "
		xcQuery += xcR + 	"	C5_FILIAL = '01' AND "
		xcQuery += xcR + 	"	B5_FILIAL = '01' AND "
		xcQuery += xcR + 	"	A4_FILIAL = '' AND "
		xcQuery += xcR + 	"	C9_NFISCAL = '' AND "
		xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	D.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	A4_ZZQTDVL > 0 AND "
		xcQuery += xcR + 	"	A4_ZZRESTR = '1'  " //C9_DATALIB >= '20170601' "
		xcQuery += xcR + 	"GROUP BY "
		xcQuery += xcR + 	"	C9_PEDIDO, C9_SEQUEN, C5_REDESP "
		xcQuery += xcR + 	"HAVING "
		xcQuery += xcR + 	"	SUM(C9_QTDLIB/B5_QE1)>MAX(A4_ZZQTDVL) "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1 "
		
		MemoWrite("\system\sql\MA455MNU RET_PEDIDOS_PARA_CORTE.SQL",xcQuery)
		
	Case xaVar[1] == 'RET_PEDIDO_CORTE'
		
		xcQuery += xcR + 	"SELECT  "
		xcQuery += xcR + 	"	C9_PEDIDO PED, C9_BLEST EST, C9_BLCRED CRD "
		xcQuery += xcR + 	"FROM  "
		xcQuery += xcR + 	"	SC9010 A INNER JOIN "
		xcQuery += xcR + 	"	SC5010 B ON "
		xcQuery += xcR + 	"	C9_PEDIDO = C5_NUM INNER JOIN "
		xcQuery += xcR + 	"	SA4010 C ON "
		xcQuery += xcR + 	"	C5_REDESP = A4_COD "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	A4_ZZQTDVL > 0 AND "
		xcQuery += xcR + 	"	C9_PEDIDO = '" + xaVar[2] + "' AND "
		xcQuery += xcR + 	"	C9_NFISCAL = '' "
		xcQuery += xcR + 	"GROUP BY "
		xcQuery += xcR + 	"	C9_PEDIDO, C9_BLEST, C9_BLCRED "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1,2 "
		
		MemoWrite("\system\sql\MA455MNU RET_PEDIDO_CORTE.SQL",xcQuery)
		
	Case xaVar[1] == 'RET_ITENS_PEDIDO'
		
		xcQuery += xcR + 	"SELECT "
		xcQuery += xcR + 	"	C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_CLIENTE, C9_LOJA, C9_PRODUTO, "
		xcQuery += xcR + 	"	C9_QTDLIB, B5_QE1, C9_QTDLIB/B5_QE1 VOLUMES, C9_DATALIB, C9_SEQUEN, "
		xcQuery += xcR + 	"	C9_GRUPO, C9_PRCVEN, C9_BLEST, C9_BLCRED, C9_LOCAL, C9_TPCARGA, C9_QTDLIB2, "
		xcQuery += xcR + 	"	C9_POTENCI, C9_RETOPER, C9_TPOP, C9_DATENT, C5_REDESP, A4_ZZQTDVL, "
		xcQuery += xcR + 	"	0 UTIL "
		xcQuery += xcR + 	"FROM "
		xcQuery += xcR + 	"	SC9010 A INNER JOIN "
		xcQuery += xcR + 	"	SB5010 B ON "
		xcQuery += xcR + 	"	C9_PRODUTO = B5_COD INNER JOIN "
		xcQuery += xcR + 	"	SC5010 C ON "
		xcQuery += xcR + 	"	C9_PEDIDO = C5_NUM INNER JOIN "
		xcQuery += xcR + 	"	SA4010 D ON "
		xcQuery += xcR + 	"	C5_REDESP = A4_COD "
		xcQuery += xcR + 	"WHERE "
		xcQuery += xcR + 	"	C9_PEDIDO = '" + xaVar[2] + "' AND "
		xcQuery += xcR + 	"	C9_NFISCAL = '' AND "
		xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	D.D_E_L_E_T_ = '' AND "
		xcQuery += xcR + 	"	C9_FILIAL = '01' AND "
		xcQuery += xcR + 	"	C5_FILIAL = '01' AND "
		xcQuery += xcR + 	"	A4_FILIAL = '  ' AND "
		xcQuery += xcR + 	"	B5_FILIAL = '01' AND "
		xcQuery += xcR + 	"	A4_ZZQTDVL > 0 AND "
		xcQuery += xcR + 	"	A4_ZZRESTR = '1' "
		xcQuery += xcR + 	"ORDER BY "
		xcQuery += xcR + 	"	1, 2, 3 "
		
		MemoWrite("\system\sql\MA455MNU RET_ITENS_PEDIDO.SQL",xcQuery)
		
EndCase


If Select('XTRB') > 0
	DbSelectArea('XTRB')
	DbCloseArea()
EndIf

TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB

XTRB->(dbGoTop())


Return Nil

Static Function xsfGeraCrt(xaGrava)
Local xcCorte1	:=	''
Local xaDados	:=	xaGrava
Local xaPedi	:=	{}

For xd	:=	1 to Len(xaDados)
	
	xcCorte1	+=	xaDados[xd][01] + '; '
	xcCorte1	+=	xaDados[xd][02] + '; '
	xcCorte1	+=	xaDados[xd][03] + '; '
	xcCorte1	+=	xaDados[xd][04] + '; '
	xcCorte1	+=	xaDados[xd][05] + '; '
	xcCorte1	+=	AllTrim(xaDados[xd][06]) + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][07])) + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][08])) + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][09])) + '; '
	xcCorte1	+=	xaDados[xd][10] + '; '
	xcCorte1	+=	xaDados[xd][11] + '; '
	xcCorte1	+=	xaDados[xd][12] + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][13])) + '; '
	xcCorte1	+=	xaDados[xd][14] + '; '
	xcCorte1	+=	xaDados[xd][15] + '; '
	xcCorte1	+=	xaDados[xd][16] + '; '
	xcCorte1	+=	xaDados[xd][17] + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][18])) + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][19])) + '; '
	xcCorte1	+=	xaDados[xd][20] + '; '
	xcCorte1	+=	xaDados[xd][21] + '; '
	xcCorte1	+=	xaDados[xd][22] + '; '
	xcCorte1	+=	xaDados[xd][23] + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][24])) + '; '
	xcCorte1	+=	AllTrim(Str(xaDados[xd][25])) + '; ' + Char(13) + Char(10)
	
	//aScan( aInfo, { |xxcc| xxcc == 'Eurai Rapelli' } )
	If aScan(xaPedi, {|xi|xi[1] == xaDados[xd][02]}) == 0
		aAdd(xaPedi, {xaDados[xd][02]})
	EndIf
	
	
Next xd
MemoWrite("\system\sql\Corte\corte.txt",xcCorte1)

Return Nil
