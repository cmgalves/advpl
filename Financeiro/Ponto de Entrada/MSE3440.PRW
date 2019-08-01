

/*
revisões
20140226 --> Ajuste das notas de faturamento e exclusões.
20151028 --> Cálculo de comissão para representante exportação + dolar.
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSE3440   ºAutor  ³ Cláudio & Victor   º Data ³  02/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para o cálculo da comissão na rotina de   º±±
±±º          ³ recalculo da comissão.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - FINA440.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSE3440()
//Variaveis locais do sistema
Local aArea    	:=	GetArea()
Local aAreaSF1 	:=	GetArea('SF1')
Local aAreaSF2 	:=	GetArea('SF2')
Local aAreaSE5 	:=	GetArea('SE5')
Local aAreaSA3 	:=	GetArea('SA3')
Local xnVlrTit	:=	0
Local xcPara	:=	'ti@plasticosmb.com.br'
Local xcMensag	:=	''
Local xcR		:=	Char(13) + Char(10)

//Variaveis Privates do sistema
Private nValorBco 	:=	0
Private nValDesc	:=	0
Private	cTpDocE5	:=	''

if empty(alltrim(SE1->E1_VEND1))
	return
endif

//CONSIDERA O VALOR
dbSelectArea('SA3')
SA3->(dbSetOrder(1))

xcMensag	+= 'Neste recálculo da comissão, o Vendedor: ' + SE1->E1_VEND1 + xcR

If SA3->(DBSEEK(xFilial('SA3') + SE1->E1_VEND1))
	If SA3->A3_ZZEXPOR == '1'
		xnVlrTit	:=	SE1->E1_VALOR + SE1->E1_SDACRES - SE1->E1_SDDECRE
	Else
		xnVlrTit	:=	SE1->E1_VALOR
	EndIf
Else
	  	xcMensag += 'Não foi encontrado no cadastro de vendedores, tabela SA3' + xcR
	  	xcMensag += 'Verifique.' + xcR
	  	xcMensag += 'Este email foi enviado no cálculo do título: ' + SE3->(E3_NUM+E3_SERIE+E3_CODCLI+E3_LOJA) + xcR + xcR + xcR
	  	xcMensag += 'Atenciosamente.' + xcR
//	  	NGSendMail(,xcPara,"ti@plasticosmb.com.br",,'Recálculo da Comissão - MSE3440',,xcMensag,,'controle@plasticosmb.com.br',,,,)
EndIF

IF Upper(SE3->E3_BAIEMI) == 'B'
	
	PegaValor()  //abaixo foi trocado o camopo se1->e1_valor por xnVlrTit
	SE3->E3_ZZFRETE	:= Round((SE1->E1_ZFRETE  * (nValorBco / xnVlrTit)),2)//Calcula o Frete Proporcional em caso de baixa parcial
	SE3->E3_ZVALIPI	:= Round((SE1->E1_ZVALIPI * (nValorBco / xnVlrTit)),2)//Calcula o IPI Proporcional em caso de baixa parcial
	SE3->E3_ZICMRET	:= Round((SE1->E1_ZICMRET * (nValorBco / xnVlrTit)),2)//Calcula o ICMSST Proporcional em caso de baixa parcial
	SE3->E3_BASE	:= Round(((SE1->E1_BASCOM1 * (nValorBco / xnVlrTit) - SE3->E3_ZZFRETE - nValDesc)), 2  )
	SE3->E3_PORC	:= SE1->E1_COMIS1
	SE3->E3_COMIS	:= Round( (SE3->E3_BASE * (SE3->E3_PORC/100)), 2  ) //ROUND(((SE3->E3_BASE * SE3->E3_PORC) / 100), 2)
ELSE
	If SE3->E3_ORIGEM == 'F'
		SF2->(DbSetOrder(2))
		If SF2->(DbSeek(xFilial("SF2")+SE3->E3_CODCLI+SE3->E3_LOJA+SE3->E3_NUM+SE3->E3_PREFIXO))
			SE3->E3_ZZFRETE	:=	SF2->F2_ZFRETE
			SE3->E3_ZVALIPI	:=	SF2->F2_VALIPI
			SE3->E3_ZICMRET	:=	SF2->F2_ICMSRET
			SE3->E3_BASE	:=	SF2->(F2_VALMERC - F2_ZFRETE)
		Else
			SE3->E3_ZZFRETE	:=	99
			SE3->E3_ZVALIPI	:=	99
			SE3->E3_ZICMRET	:=	99
			SE3->E3_BASE	:=	99
		EndIf
	Else
		SF1->(DbSetOrder(1))
		If SF1->(DbSeek(xFilial("SF1")+SE3->E3_NUM+SE3->E3_SERIE+SE3->E3_CODCLI+SE3->E3_LOJA+'D'))
			SE3->E3_ZZFRETE	:=	SF1->F1_ZFRETE * (-1)
			SE3->E3_ZVALIPI	:=	SF1->F1_VALIPI * (-1)
			SE3->E3_ZICMRET	:=	SF1->F1_ICMSRET * (-1)
			SE3->E3_BASE	:=	SF1->(F1_VALMERC - F1_ZFRETE) * (-1)
		Else //Caso Não encontre o faturamento, gravar os valores abaixo para análise
			SE3->E3_ZZFRETE	:=	99 * (-1)
			SE3->E3_ZVALIPI	:=	99 * (-1)
			SE3->E3_ZICMRET	:=	99 * (-1)
			SE3->E3_BASE	:=	99 * (-1)
		EndIf
	EndIf
	SE3->E3_COMIS	:= 	ROUND((((SE3->E3_BASE) * SE3->E3_PORC) / 100), 2)
ENDIF

RestArea(aAreaSA3)
RestArea(aAreaSE5)
RestArea(aAreaSF1)
RestArea(aAreaSF2)
RestArea(aArea)
Return


Static Function PegaValor()
Local cQuery   := ""
Local nNumParc := 0

cQuery := "SELECT "
cQuery += "	(E5_VALOR - E5_VLJUROS - E5_VLMULTA - E5_VLCORRE + E5_VLDESCO) E5_VALOR, "
cQuery += "	E5_TIPODOC, E5_VLDESCO  "
cQuery += "FROM "
cQuery += "	" + RetSqlName("SE5") + " "
cQuery += "WHERE "
cQuery += "	E5_FILIAL = '" + xFilial("SE1") + "' AND "
cQuery += "	E5_PREFIXO = '" + SE3->E3_PREFIXO + "' AND "
cQuery += "	E5_NUMERO = '" + SE3->E3_NUM + "' AND "
cQuery += "	E5_PARCELA = '" + SE3->E3_PARCELA + "' AND "
cQuery += "	E5_TIPO = '" + SE3->E3_TIPO + "' AND "
cQuery += "	E5_CLIFOR = '" + SE3->E3_CODCLI + "' AND "
cQuery += "	E5_LOJA = '" + SE3->E3_LOJA + "' AND "
cQuery += "	E5_SEQ = '" + SE3->E3_SEQ + "' AND "
cQuery += "	E5_TIPODOC NOT IN ('JR', 'MT', 'DC') AND "
cQuery += "	E5_VALOR > 0 AND "
cQuery += "	D_E_L_E_T_ = ' ' "

TcQuery cQuery New Alias "TMP1"

If TMP1->(!Eof())
	nValorBco 	:=	TMP1->E5_VALOR
	cTpDocE5	:=	TMP1->E5_TIPODOC
	nValDesc	:=	TMP1->E5_VLDESCO
EndIf

TMP1->(DbCloseArea())

Return (nValorBco)
