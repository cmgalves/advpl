#include "protheus.ch"
#include "topconn.ch"

//Função para sugerir o valor do cheque. Será sugerido o saldo do título, quando o cheque não estiver cadastrado no sistema.
//Caso o cheque esteja cadastrado no sistema, será preenchido o valor do mesmo.

User Function MBVlrCh()
Local aArea		:=	GetArea()
Local nPBco		:=	GDFieldPos("EF_BANCO")
Local nPAge		:=	GDFieldPos("EF_AGENCIA")
Local nPCC		:=	GDFieldPos("EF_CONTA")
Local nPNum		:=	GDFieldPos("EF_NUM")
Local nValor	:=	0

nValor	:= Posicione("SEF",1,xFilial("SEF")+aCols[n,nPBco]+aCols[n,nPAge]+aCols[n,nPCC]+aCols[n,nPNum],"EF_VALOR")
If nValor = 0
	nValor	:= SE1->E1_SALDO - U_MBSomaCH()
Endif

RestArea(aArea)
Return (nValor)

//Função utilizada para sugerir o valor da baixa do cheque.
User Function MBSldCh()
Local aArea		:= GetArea()
Local nSaldo	:= 0
Local nValor	:= 0
Local Cquery	:= ""
Local nPBco		:=	GDFieldPos("EF_BANCO")
Local nPAge		:=	GDFieldPos("EF_AGENCIA")
Local nPCC		:=	GDFieldPos("EF_CONTA")
Local nPNum		:=	GDFieldPos("EF_NUM")
Local nPVlr		:=	GDFieldPos("EF_VALOR")
Local nPVlrBx	:=	GDFieldPos("EF_VALORBX")
Local nRet		:= SE1->E1_SALDO
Local nSomaCh	:= U_MBSomaCH()
//Local nSomaCh	:= 0

cQuery	:= ""
cQuery	+= "SELECT SUM(a.EF_VALORBX) VALOR"+CRLF
cQuery	+= "FROM SEF010 a"+CRLF
cQuery	+= "WHERE "+CRLF
cQuery	+= "	a.EF_FILIAL		=	'"+xFilial("SEF")	+"' "+CRLF
cQuery	+= "AND a.EF_BANCO		=	'"+aCols[n,nPBco]	+"' "+CRLF
cQuery	+= "AND a.EF_AGENCIA	=	'"+aCols[n,nPAge]	+"' "+CRLF
cQuery	+= "AND	a.EF_CONTA		=	'"+aCols[n,nPCC]	+"' "+CRLF
cQuery	+= "AND a.EF_NUM		=	'"+aCols[n,nPNum]	+"' "+CRLF
cQuery	+= "AND a.D_E_L_E_T_	<> '*' "				+CRLF

TcQuery ChangeQuery(cQuery) New Alias "TRA"

nValor	:= U_MBVlrCh()
nSaldo	:= nValor - TRA->VALOR
nRet	:= nRet - nSomaCh
If nSaldo = 0 .and. SEF->(dbseek(xFilial("SEF")+aCols[n,nPBco]+aCols[n,nPAge]+aCols[n,nPCC]+aCols[n,nPNum]))
	Alert("Cheque sem saldo! Digite outro cheque.")
	nRet	:= 0
ElseIf nSaldo > 0 .AND. nSaldo <= nRet
	nRet	:= nSaldo
ElseIf nSaldo > nRet
	Alert('Sobrou saldo no cheque:'+Str(nSaldo-nRet))    //lógica errada, não pode pegar do SE1->E1_SALDO pois pode haver mais de um cheque na tela
Else
	nRet	:=SE1->E1_SALDO-nSomaCh
EndIf

TRA->(dbCloseArea())
RestArea(aArea)
Return (nRet)
                                                                         

//Função para retornar a quantidade de cheques cadastrados para o título.
User Function MBSomaCH()
Local nRet	:= 0
Local nSld	:= SE1->E1_SALDO
Local nPVlrBx	:=	GDFieldPos("EF_VALORBX")
Local nPChcad	:=	GDFieldPos("EF_CHCAD")

For i:=1 to Len(aCols)
	If ! aCols[i,nPChcad] = "Sim"
		nRet	+= aCols[i,nPVlrBx]
	Endif
Next 1

nRet	-= aCols[n,nPVlrBx] //Subtrai do valor informado o valor sugerido para o cheque atual.

Return nRet

//Adicionar Gatilho nos campos EF_BANCO, EF_AGENCIA, EF_CONTA
User Function MBEmisCh(cParam)
Local nPBco		:=	GDFieldPos("EF_BANCO")
Local nPAge		:=	GDFieldPos("EF_AGENCIA")
Local nPCC		:=	GDFieldPos("EF_CONTA")
Local nPEmis	:=	GDFieldPos("EF_EMITENT")
Local nPCNPJ	:=	GDFieldPos("EF_CPFCNPJ")
Local nPTel		:=	GDFieldPos("EF_TEL")
Local nPData	:=	GDFieldPos("EF_DATA")
Local nPVencto	:=	GDFieldPos("EF_VENCTO")

//aCols[n,nPEmis]		:= ""
//aCols[n,nPCNPJ]		:= ""
//aCols[n,nPTel]		:= ""
//aCols[n,nPData]		:= dDataBase
//aCols[n,nPVencto]	:= dDataBase

If SEF->(dbSeek(xFilial("SEF")+aCols[n,nPBco]+aCols[n,nPAge]+aCols[n,nPCC]))
	aCols[n,nPEmis]	:= SEF->EF_EMITENT
	aCols[n,nPCNPJ]	:= SEF->EF_CPFCNPJ
	aCols[n,nPTel]	:= SEF->EF_TEL
	aCols[n,nPData]	:= SEF->EF_DATA
	aCols[n,nPVencto]	:= SEF->EF_VENCTO
Else
	i:=1
	While i < Len(aCols) 
		If 	aCols[i,nPBco] 	= aCols[n,nPBco] .and. ;
			aCols[i,nPAge] 	= aCols[n,nPAge] .and. ;
			aCols[i,nPCC] 	= aCols[n,nPCC]
			
			aCols[n,nPEmis]		:= aCols[i,nPEmis]
			aCols[n,nPCNPJ]		:= aCols[i,nPCNPJ]
			aCols[n,nPTel]		:= aCols[i,nPTel]
			aCols[n,nPData]		:= aCols[i,nPData]
			aCols[n,nPVencto]	:= aCols[i,nPVencto]
			
			i := Len(aCols)
			
		Endif
		i++
	EndDo
EndIf
Return cParam