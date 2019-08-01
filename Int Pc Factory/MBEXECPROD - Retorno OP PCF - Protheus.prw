#include "protheus.ch"
#include "msobjects.ch"
#include "topconn.ch"
#include "rwmake.ch"
#INCLUDE "OLECONT.CH"
#include "tbiconn.ch"
#Include "Fileio.ch"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ MBEXECPROD ºAutor | Cláudio Alves   º Data ³  27/06/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para efetuar a integracao dos itens apontados nas   º±±
±±º          ³ Ordens de Produção(SD3) 								      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto   ³ - Integração com o PcFactory                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Apontamento zza reformulada em 04/02/2015 - Cláudio Alves

Ajuste do campo D3_ZZIDENT

Ajuste do campo D3_ZZIDENT

Origem          --- 	Job  ------ 	Manual
Saldo Antecipado 		10				20        //Sobra Saldo
Saldo Antecipado 		11				21        //Saldo Zero
Saldo Antecipado 		12				22        //Qtde maior que saldo
Saldo Antecipado 		13				23        //Sobra saldo 2
Produção Normal 		14				24        //
Produção Estouro 12		15				25        //
Produção e Refugo		16				26        //




Alterações feitas em 20151105:
No refugo era feito uma mov interna trasnformando o PI em Sucata e o saldo era tirado das peças boas. Em conversa com a Renata ela informou que
o saldo das peças boas ficava errado.

Foi alterado o programa para quando tiver um refugo, a rotina primeiro tenta produzir depois manda a quantidade para sucata.



*/

User Function MBEXECPROD()

Private xcRemet	:=	'totvs@plasticosmb.com.br'
Private xnER	:=	0


//Tabela OutInteg gravação no SD3 rotna automatica mata250

If Select("SX2")==0
	Prepare Environment Empresa '01' Filial '01'  TABLES "SD3"
	While !LockByName("INTPCF"+cEmpAnt,.T.,.T.,.T.)
		xnER++
		MsAguarde({|| Sleep(10000) }, "Integração Em Uso... tentativa "+ALLTRIM(STR(xnER)), "Aguarde, Rotina utilizada por outro usuário.")
	EndDo
	xsfProcD(1)
Else
	While !LockByName("INTPCF"+cEmpAnt,.T.,.T.,.T.)
		xnER++
		If MsgYesNo("Integração em uso, deseja esperar?","A V I S O")
			MsAguarde({|| Sleep(10000) }, "Integração Em Uso... tentativa "+ALLTRIM(STR(xnER)), "Aguarde, Rotina utilizada por outro usuário.")
		Else
			Return .F.
		EndIf
	EndDo
	Processa({||xsfProcD(2) },"Aguarde... Integração em Andamento !!!" )
EndIf

UnLockByName("INTPCF"+cEmpAnt,.T.,.T.,.T.)

Return()


Static Function xsfProcD(xOrig)
Local xcFiltroOP	:= GETMV('MB_DBUGPCF')  //'07022901002' //	GETMV('MB_DBUGPCF') ESTA É A MINHA OP //08029001002


Private xcR			:=	Char(13) + Char(10)	//Muda Linha
Private xdDia		:=	cTod('  /  /    ')	//Data do Apontamento
Private xcTpRef		:=	0					//Produção ou refugo 1 ou 2
Private xnSldAntec	:=	0  					//Saldo Antecipado
Private xnSldAntAp	:=	0  					//Saldo Antecipado já apontado no SD3
Private xnSldOP		:=	0					//Saldo Restante para atendimento da OP
Private xcMoti		:=	''					//Motivo do Refugo
Private xcRecs		:=	''					//Recurso utilizado
Private xcOper		:=	''					//Operação
Private xcId			:=	''					//Código do registro do PCF, ZZA
Private xaApont		:=	{}					//Array para
Private xcProd		:=	''					//Referência do Produto.
Private xnQtde		:=	0					//Qunatidade a Produzir
Private xnProd12	:=	0					//Quantidade para apontar no 12
Private xnMini		:=	0 					//Recno Mínimo
Private xnMaxi		:=	0					//Recno Máximo
Private xcOp		:=	''					//Número da OP
Private xcDoc		:=	''					//Numero do documento do SD3
Private xcNumSeq	:=	''					//Numero da sequencia do SD3
Private xcTmProd 	:=	AllTrim(GetMv("MB_TMPROD"))
Private xcTmEst 	:=	AllTrim(GetMv("MB_TMESTO"))
Private xcReqEst 	:=	AllTrim(GetMv("MB_REQEST"))
Private xlProduct	:=	.T.
Private xnOrigExe	:=	xOrig
Private xcTpProd	:=	''
Private xmLogErr	:=	''



cQuery	:=			"SELECT "
cQuery	+=	xcR +	"	MIN(R_E_C_N_O_) MINI, MAX(R_E_C_N_O_) MAXI, ZZA_OP OP, ZZA_PROD PROD,  "
cQuery	+=	xcR +	"	MAX(ZZA_DTAPON) DIA, SUM(ZZA_QTDADE - ZZA_ANTECI - ZZA_APT012) QTDE, ZZA_TIPOTR TIPO, "
cQuery	+=	xcR +	"	CASE WHEN ZZA_TIPOTR = 1 THEN ISNULL(MAX(SALDO),0) ELSE 0 END ANTEC, ZZA_OPERAC OPER,  "
cQuery	+=	xcR +	"	ZZA_RECURS RECS, MAX(ZZA_ID) ID, COUNT(*) REG_QTD, ZZA_STATUS STS "
cQuery	+=	xcR +	"FROM  "
cQuery	+=	xcR +	"	" + RetSqlName("ZZA") + " A LEFT JOIN "
cQuery	+=	xcR +	"	( "
cQuery	+=	xcR +	"	SELECT  "
cQuery	+=	xcR +	"		D3_OP, SUM(D3_QUANT) QTDE,  "
cQuery	+=	xcR +	"		SUM(D3_ZANTECI) ANTEC,  "
cQuery	+=	xcR +	"		SUM(D3_QUANT - D3_ZANTECI) SALDO "
cQuery	+=	xcR +	"	FROM  "
cQuery	+=	xcR +	"		" + RetSqlName("SD3") + "  "
cQuery	+=	xcR +	"	WHERE  "
cQuery	+=	xcR +	"		D3_TM = '013' AND "
cQuery	+=	xcR +	"		D3_QUANT - D3_ZANTECI > 0 AND "
cQuery	+=	xcR +	"		D3_FILIAL = '01' AND "
cQuery	+=	xcR +	"		D_E_L_E_T_ = '' "
cQuery	+=	xcR +	"	GROUP BY "
cQuery	+=	xcR +	"		D3_OP)B ON "
cQuery	+=	xcR +	"	ZZA_OP = D3_OP "
cQuery	+=	xcR +	"WHERE  "
cQuery	+=	xcR +	"	A.ZZA_FILIAL = '01' AND  "
cQuery	+=	xcR +	"	A.ZZA_INTEGR = '1' AND  "
If !Empty(xcFiltroOP) //!Empty(GETMV('MB_DBUGPCF'))  xcFiltroOP
	cQuery	+= xcR +	"	A.D_E_L_E_T_ = ' ' AND A.ZZA_OP = '" + ALLTRIM(xcFiltroOP) + "' "
Else
	cQuery	+=	xcR +	"	A.D_E_L_E_T_ = ' '  "
EndIf
cQuery	+=	xcR +	"GROUP BY "
cQuery	+=	xcR +	"	A.ZZA_OP, A.ZZA_PROD, A.ZZA_TIPOTR, A.ZZA_OPERAC, A.ZZA_RECURS, A.ZZA_STATUS "
cQuery	+=	xcR +	"HAVING "
cQuery	+=	xcR +	"	SUM(A.ZZA_QTDADE) > 0 "
cQuery	+=	xcR +	"ORDER BY  "
cQuery	+=	xcR +	"	1 "

MemoWrite("Apontamento Pordução a partir da ZZA.SQL",cQuery)

If select("TRB") > 0
	TRB->(dbclosearea())
endif

TcQuery StrTran(cQuery,xcR,"") New Alias TRB

dbSelectArea("TRB")
DbGotop()


While !TRB->(EOF())
	
	xnSldAntec	:=	TRB->ANTEC  //Saldo de antecipação vem da SD3
	xcOp		:=	TRB->OP
	xnQtde		:=	TRB->QTDE
	xcProd		:=	TRB->PROD
	xdDia		:= 	sTod(TRB->DIA)
	xcTpRef	 	:=	TRB->TIPO
	xcMoti	 	:=	"51"
	xcRecs	 	:=	TRB->RECS
	xcOper	 	:=	TRB->OPER
	xnMini		:=	TRB->MINI
	xnMaxi		:=	TRB->MAXI
	xcSts		:=	TRB->STS
	xnProd12	:=	0
	xnSldAntAp	:=	0
	
	If xnSldAntec > 0 //APONTAMENTO DE ANTECIPAÇÃO
		
		If xnSldAntec < xnQtde
			xnSldAntAp	:=	xnSldAntec
		Else
			xnSldAntAp	:=	xnQtde
		EndIf
		dbSelectArea('SD3')
		SD3->(dbSetOrder(1))
		SD3->(dbGoTop())
		SD3->(dbSeek(xFilial('SD3') + xcOp))
		
		While !SD3->(EOF())
			
			If SD3->D3_TM != "013"
				SD3->(dbSkip())
				Loop
			EndIf
			If SD3->D3_ESTORNO == "S"
				SD3->(dbSkip())
				Loop
			EndIf
			If SD3->D3_QUANT - SD3->D3_ZANTECI == 0
				SD3->(dbSkip())
				Loop
			EndIf
			If SD3->D3_COD != TRB->PROD
				SD3->(dbSkip())
				Loop
			EndIf
			If xnSldAntAp == 0
				SD3->(dbSkip())
				Loop
			EndIf
			RecLock('SD3',.F.)
			
			If xnSldAntec <= xnQtde
				If xnSldAntAp <= (SD3->D3_QUANT - SD3->D3_ZANTECI)  //Quantidade para apontar maior que o saldo antecipado.
					RecLock('SD3',.F.)
					SD3->D3_ZANTECI		:= 	SD3->D3_ZANTECI + xnSldAntAp
					SD3->D3_ZZIDINT		:= 	IIF(xnOrigExe=1,10,20)
					xcDoc				:=	SD3->D3_DOC
					xcNumSeq			:=	SD3->D3_NUMSEQ
					xnSldAntAp	:=	0
					SD3->(MsUnLock())
				Else  //	xnQtde > (SD3->D3_QUANT - SD3->D3_ZANTECI)
					RecLock('SD3',.F.)
					xnSldAntAp			-= SD3->(D3_QUANT - D3_ZANTECI)
					SD3->D3_ZANTECI		:= 	SD3->D3_QUANT
					SD3->D3_ZZIDINT		:= 	IIF(xnOrigExe=1,11,21)
					xcDoc				:=	SD3->D3_DOC
					xcNumSeq			:=	SD3->D3_NUMSEQ
					SD3->(MsUnLock())
				EndIf
				If xnSldAntAp <= 0
					xsfAtuZZA(xcOp, xnMini, xnMaxi, xnSldAntec, xcTpRef, 'A')
					xnQtde -= xnSldAntec
					Exit
				EndIf
			Else
				If xnSldAntAp <= (SD3->D3_QUANT - SD3->D3_ZANTECI)  //Quantidade para apontar maior que o saldo antecipado.
					RecLock('SD3',.F.)
					SD3->D3_ZANTECI		:= 	SD3->D3_ZANTECI + xnSldAntAp
					SD3->D3_ZZIDINT		:= 	IIF(xnOrigExe=1,12,22)
					xcDoc				:=	SD3->D3_DOC
					xcNumSeq			:=	SD3->D3_NUMSEQ
					xnSldAntAp	:=	0
					SD3->(MsUnLock())
				Else  //	xnQtde > (SD3->D3_QUANT - SD3->D3_ZANTECI)
					RecLock('SD3',.F.)
					xnSldAntAp	-= SD3->(D3_QUANT - D3_ZANTECI)
					xcDoc				:=	SD3->D3_DOC
					xcNumSeq			:=	SD3->D3_NUMSEQ
					SD3->D3_ZANTECI		:= 	SD3->D3_QUANT
					SD3->D3_ZZIDINT		:= 	IIF(xnOrigExe=1,13,23)
					SD3->(MsUnLock())
				EndIf
				If xnSldAntAp <= 0
					xsfAtuZZA(xcOp, xnMini, xnMaxi, xnQtde, xcTpRef, 'A')
					xnQtde := 0
				EndIf
			EndIf
			SD3->(MsUnLock())
			SD3->(dbSkip())
		EndDo
	EndIf
	If xnQtde <= 0
		TRB->(dbSkip())
		Loop
	EndIf
	If xcTpRef == 2 //Tipo 1 Apontamento de peças boas e tipo 2 apontamento de refugo.
		If xsfManual(xnQtde,"011","999","RE1","R",16,26)
			DbSelectArea("SC2")
			DbSetOrder(1)
			If DbSeek(xFilial("SC2")+xcOp,.f.)
				RecLock("SC2",.f.)
				Replace SC2->C2_ZZSTAT With "2"
				Replace SC2->C2_ZZDTENV With dDataBase
				Replace SC2->C2_ZZLOGPF With ''
				
				MsUnlock()
			Endif
			xsfAtuZZA(xcOp, xnMini, xnMaxi, xnQtde, xcTpRef, 'R')
		EndIf
		
	Else
		nQtdOP  	:=	Posicione("SC2",1,xFilial("SC2")+xcOp,"C2_QUANT")
		nQtdEnt 	:=	Posicione("SC2",1,xFilial("SC2")+xcOp,"C2_QUJE")
		xnSldOP		:=	nQtdOP - nQtdEnt
		If xnQtde > xnSldOP
			xnProd12 	:= xnQtde - xnSldOP
			xnQtde 		:= xnSldOP
		EndIf
		If xnQtde > 0
			xcTpProd	:=	'P'
			xsfProduct()  //VERIFICAR SALDO NA OP PARA PRODUZIR O TIPO 1
		EndIf
		If xnProd12 > 0
			If (xcSts $ "50 60 70") //Só vai fazer 12 depois que a op estiver baixada
				If xsfManual(xnProd12,"012","507","RE0","E",15,25)
					DbSelectArea("SC2")
					DbSetOrder(1)
					If DbSeek(xFilial("SC2")+xcOp,.f.)
						RecLock("SC2",.f.)
						Replace SC2->C2_ZZSTAT With "2"
						Replace SC2->C2_ZZDTENV With dDataBase
						SC2->(MsUnlock())
					Endif
					xsfAtuZZA(xcOp, xnMini, xnMaxi, xnProd12, xcTpRef, 'E')
				EndIf
			Else
				DbSelectArea("SC2")
				DbSetOrder(1)
				If DbSeek(xFilial("SC2")+TRB->OP,.f.)
					RecLock("SC2",.f.)
					Replace SC2->C2_ZZSTAT 	With "9"
					Replace SC2->C2_ZZDTENV With dDataBase
					Replace SC2->C2_ZZLOGPF With 'Erro 12 só com 50 60 70 OP = ' + xcOp  + ' '
					SC2->(MsUnlock())
				Endif
			EndIf
		EndIf
	Endif
	//Manda e-mail registro ja importado
	
	DbSelectArea("TRB")
	TRB->(DbSkip())
	IncProc()
Enddo

DbSelectArea("TRB")
DbCloseArea("TRB")

Return


Static Function xsfProduct()
xlProduct	:=	.F.
lMsErroAuto :=	.F.
xaApont		:=	{}
If xnQtde > 0  //Caso tenha saldo na OP, será feito a produção com o TM 011, caso contrário, apenas o TM 012
	
	Aadd(xaApont,{"D3_FILIAL"	,	xFilial("SD3")	,NIL})
	Aadd(xaApont,{"D3_TM"		,	xcTmProd		,NIL})
	Aadd(xaApont,{"D3_COD"		,	xcProd			,NIL})
	Aadd(xaApont,{"D3_OP"		,	xcOp 			,NIL})
	Aadd(xaApont,{"D3_QUANT"	,	xnQtde			,NIL})
	Aadd(xaApont,{"D3_ZZIDINT"	,	IIF(xnOrigExe=1,1,6)		,NIL})
	Aadd(xaApont,{"D3_PERDA"	,	0				,NIL})
	Aadd(xaApont,{"D3_PARCTOT"	,	"P"				,NIL})
	Aadd(xaApont,{"D3_CF"		,	"PR0"			,NIL})
	
	MsExecAuto({|x,y| mata250(x,y)},xaApont,3)
EndIf
If lMsErroAuto //Caso True, informa o erro na SC2
	
	cNomArqErro := NomeAutoLog()
	IF (nHandle := FOPEN(cNomArqErro)) >= 0
		// Pega o tamanho do arquivo
		nLength := FSEEK(nHandle, 0, FS_END)
		fSeek(nHandle,0,0)
		cString := FREADSTR(nHandle, nLength)
		FCLOSE(nHandle)
	Endif
	FERASE(cNomArqErro)
	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(xFilial("SC2")+xcOp,.f.)
		RecLock("SC2",.f.)
		Replace SC2->C2_ZZSTAT With "5"
		Replace SC2->C2_ZZDTENV With dDataBase
		Replace SC2->C2_ZZLOGPF With cString
		MsUnlock()
	Endif
Else
	If xnQtde > 0
		cQuery	:=			"SELECT "
		cQuery	+=	xcR +	"	R_E_C_N_O_, D3_DOC, D3_NUMSEQ "
		cQuery	+=	xcR +	"FROM  "
		cQuery	+=	xcR +	"	" + RetSqlName("SD3") + " A "
		cQuery	+=	xcR +	"WHERE  "
		cQuery	+=	xcR +	"	D3_FILIAL = '01' AND  "
		cQuery	+=	xcR +	"	D3_QUANT = " + Transform(xnQtde	,"@E 99999999")  + " AND  "
		cQuery	+=	xcR +	"	D3_OP = '" + xcOp + "' AND  "
		cQuery	+=	xcR +	"	D_E_L_E_T_ = '  ' "
		cQuery	+=	xcR +	"ORDER BY  "
		cQuery	+=	xcR +	"	1 "
		
		If select("XD3") > 0
			XD3->(dbclosearea())
		endif
		
		TcQuery StrTran(cQuery,xcR,"") New Alias XD3
		
		dbSelectArea("XD3")
		DbGotop()
		
		While !XD3->(EOF())
			xcDoc		:=	XD3->D3_DOC
			xcNumSeq	:=	XD3->D3_NUMSEQ
			XD3->(dbSkip())
		EndDo
		DbSelectArea("SC2")
		DbSetOrder(1)
		If DbSeek(xFilial("SC2")+xcOp,.f.)
			RecLock("SC2",.f.)
			Replace SC2->C2_ZZSTAT With "2"
			Replace SC2->C2_ZZDTENV With dDataBase
			Replace SC2->C2_ZZLOGPF With ''
			MsUnlock()
		Endif
		xsfAtuZZA(xcOp, xnMini, xnMaxi, xnQtde, xcTpRef, xcTpProd)
		xlProduct	:=	.T.
	EndIf
Endif

Return(xlProduct)


Static Function xsfAtuZZA(xcOp, xnMini, xnMaxi, xnQuant01, xcTpRef, xcOrig)
Local xnMin		:=	xnMini
Local xnMax		:=	xnMaxi
Local xnQuant	:=	xnQuant01
Local xcOrdem	:=	xcOp
Local xcTp		:=	xcTpRef
Local xcOrigem	:=	xcOrig

DbSelectArea("ZZA")
DbSetOrder(3)
DbSeek(xFilial('ZZA') + xcOrdem,.F.)

Do While !ZZA->(EOF()) .AND. ZZA->ZZA_OP == xcOrdem .AND. xnQuant > 0
	
	If ZZA->(Recno()) < xnMini
		ZZA->(dbSkip())
		Loop
	EndIf
	If ZZA->(Recno()) > xnMaxi
		ZZA->(dbSkip())
		Loop
	EndIf
	
	If ZZA->ZZA_TIPOTR != xcTp
		ZZA->(dbSkip())
		Loop
	EndIf
	
	If ZZA->ZZA_INTEGR == 2
		ZZA->(dbSkip())
		Loop
	EndIf
	
	If ZZA->ZZA_QTDADE - ZZA->ZZA_APT012 = 0
		ZZA->(dbSkip())
		Loop
	EndIf
	
	RecLock("ZZA",.f.)
	
	If xnQuant <= ZZA->ZZA_QTDADE - ZZA->ZZA_APT012
		ZZA->ZZA_APT012 	:=	ZZA->ZZA_APT012 + xnQuant
		ZZA->ZZA_DOC 		:=	xcDoc
		ZZA->ZZA_NUMSEQ 	:=	xcNumSeq
		xnQuant	:=	0
	Else
		xnQuant	-=  (ZZA->ZZA_QTDADE - ZZA->ZZA_APT012)
		ZZA->ZZA_APT012 	:=	ZZA->ZZA_QTDADE
		ZZA->ZZA_DOC 		:=	xcDoc
		ZZA->ZZA_NUMSEQ 	:=	xcNumSeq
	EndIf
	
	If ZZA->ZZA_APT012 >= ZZA->ZZA_QTDADE
		ZZA->ZZA_INTEGR 	:=	2
	EndIf
	
	ZZA->(MsUnLock())
	ZZA->(dbSkip())
	
EndDo

Return()


Static Function xsfManual(xxnQtd,xxcTmEst, xxcTmMP,xxcTmCF,xxcTipo,xxJob,xxMan)
Local xlEstRet	:=	.T.
Local xaAponta	:=	{}
Local xlProdPI	:=	.T.
Local xcDocEx	:=	'' //xsfNumDoc()
Local xmLogErr	:=	''
Local xnQtdPrd	:=	xxnQtd
Local xcTmMan	:=	xxcTmEst
Local xcTmMP	:=	xxcTmMP
Local xcTmCF	:=	xxcTmCF
Local xcTprod	:=	xxcTipo
Local xnJob		:=	xxJob
Local xnMan		:=	xxMan

Private xnCusTrf	:=	0

xcQuery :=  		"SELECT "
xcQuery += xcR + 	"	'" + xcOp + "' 'OP', C2_PRODUTO 'PI', E.B1_UM UM_PI, E.B1_SEGUM SUM_PI,   "
xcQuery += xcR + 	"	E.B1_TIPO TIPO_PI, C2_LOCAL ARM_PI, C2_QUANT QTDE_PI,   "
xcQuery += xcR + 	"	G1_COMP MP, F.B1_UM UM_MP, F.B1_SEGUM SUM_MP, F.B1_TIPO TIPO_MP,   "
xcQuery += xcR + 	"	CASE WHEN F.B1_TIPO = 'MO' THEN '01' ELSE '97' END ARM_MP,   "
xcQuery += xcR + 	"	G1_QUANT FATOR_SG1, E.B1_QB QTDE_BASE,   " + Transform(xnQtdPrd	,"@E 99999") + " QTDE_PROD,   "
xcQuery += xcR + 	"	(  " + Transform(xnQtdPrd	,"@E 99999") + " / CASE WHEN E.B1_QB = 0 THEN 1 ELSE E.B1_QB END) * G1_QUANT QTDE_MP,  "
xcQuery += xcR + 	"	ISNULL(C.B2_QATU,0) SLD, ISNULL(C.B2_CM1,0) CST_MP, ISNULL(G.B2_CM1,0) CST_PI,  "
xcQuery += xcR + 	"	CASE   "
xcQuery += xcR + 	"	WHEN LEFT(G1_COMP,3) = 'MOD'    "
xcQuery += xcR + 	"	THEN (  " + Transform(xnQtdPrd	,"@E 99999") + " / CASE WHEN E.B1_QB = 0 THEN 1 ELSE E.B1_QB END) * G1_QUANT  "
xcQuery += xcR + 	"	ELSE ISNULL(C.B2_QATU,0) - (  " + Transform(xnQtdPrd	,"@E 99999") + " / CASE WHEN E.B1_QB = 0 THEN 1 ELSE E.B1_QB END) * G1_QUANT  "
xcQuery += xcR + 	"	END DISP  "
xcQuery += xcR + 	"FROM   "
xcQuery += xcR + 	"	SC2010 A INNER JOIN   "
xcQuery += xcR + 	"	SG1010 B ON "
xcQuery += xcR + 	"	C2_PRODUTO = G1_COD LEFT JOIN  "
xcQuery += xcR + 	"	SB2010 C ON "
xcQuery += xcR + 	"	G1_COMP = C.B2_COD AND  "
xcQuery += xcR + 	"	C.B2_LOCAL = CASE WHEN LEFT(C.B2_COD,3) = 'MOD' THEN '01' ELSE '97' END INNER JOIN  "
xcQuery += xcR + 	"	SB1010 E ON "
xcQuery += xcR + 	"	C2_PRODUTO = E.B1_COD INNER JOIN	  "
xcQuery += xcR + 	"	SB1010 F ON "
xcQuery += xcR + 	"	G1_COMP = F.B1_COD AND "
xcQuery += xcR + 	"	C.B2_FILIAL = '01' AND  "
xcQuery += xcR + 	"	C.D_E_L_E_T_ = '' LEFT JOIN  "
xcQuery += xcR + 	"	SB2010 G ON "
xcQuery += xcR + 	"	C2_PRODUTO = G.B2_COD AND  "
xcQuery += xcR + 	"	C2_LOCAL = G.B2_LOCAL AND "
xcQuery += xcR + 	"	G.B2_FILIAL = '01' AND  "
xcQuery += xcR + 	"	G.D_E_L_E_T_ = ''  "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	C2_FILIAL = '01' AND  "
xcQuery += xcR + 	"	G1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	E.B1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	F.B1_FILIAL = '01' AND  "
xcQuery += xcR + 	"	A.D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"	B.D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"	E.D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"	F.D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"	C2_NUM+C2_ITEM+C2_SEQUEN = '" + xcOp + "'  "
xcQuery += xcR + 	"ORDER BY  "
xcQuery += xcR + 	"	3 "

MemoWrite("Apontamento Manual zza.SQL",xcQuery)

If select("XEST") > 0
	XEST->(dbclosearea())
EndIf

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XEST


dbSelectArea('XEST')
XEST->(dbGoTop())


xcDocEx		:=	xsfNumDoc()
xcNumSeq	:=	ProxNum() //Pega o próximo registro para salvar na BC e D3Getmv("MV_DOCSEQ")

SB1->(dbSeek(xFilial('SB1') + xcProd ))
xcLocaPad	:=	SB1->B1_LOCPAD
xcUnidade	:=	SB1->B1_UM
xcConta		:=	SB1->B1_CONTA
xcGrupo		:=	SB1->B1_GRUPO
xcSegum		:=	SB1->B1_SEGUM

xnCusTrf	:=	0

Do While !XEST->(EOF())
	If XEST->DISP < 0
		xlEstRet	:=	.F.
	End If
	
	If xlProdPI
		Aadd(xaAponta, {xFilial('SD3'), ;   //01	SD3->D3_FILIAL	:=	xaAponta[xi][01]	Filial
		xcTmMan,;                           //02	SD3->D3_TM    	:=	xaAponta[xi][02]	Tm PI
		XEST->PI,;                          //03	SD3->D3_COD  	:=	xaAponta[xi][03]	PI - Cod
		XEST->OP,;                          //04	SD3->D3_OP  	:=	xaAponta[xi][04]	Numero OP
		xnQtdPrd,;                          //05	SD3->D3_QUANT	:=	xaAponta[xi][05]	Quantidade da PI
		XEST->ARM_PI,;                      //06	SD3->D3_LOCAL	:=	xaAponta[xi][06]	Local PI
		xcDocEx,;                           //07	SD3->D3_DOC		:=	xaAponta[xi][07]	Documento
		dDataBase,;                         //08	SD3->D3_EMISSAO	:=	xaAponta[xi][08]	Data Emissao
		dDataBase,;                         //09	SD3->D3_DTVALID	:=	xaAponta[xi][09]	Data VAlidade
		XEST->UM_PI,;                       //10	SD3->D3_UM     	:=	xaAponta[xi][10]	Unidade de Medida
		"PR0",;                             //11	SD3->D3_CF    	:=	xaAponta[xi][11]	CF
		xcConta,;                           //12	SD3->D3_CONTA	:=	xaAponta[xi][12]	Conta contábil
		xcGrupo,;                           //13	SD3->D3_GRUPO	:=	xaAponta[xi][13]	Grupo
		XEST->CST_PI * xnQtdPrd,;           //14	SD3->D3_CUSTO1  :=	xaAponta[xi][14]	Custo
		xcNumSeq,;                          //15	SD3->D3_NUMSEQ	:=	xaAponta[xi][15]	Numseq
		xcNumSeq,;                          //16	SD3->D3_IDENT	:=	xaAponta[xi][16]	Ident
		XEST->SUM_PI,;                      //17	SD3->D3_SEGUM   :=	xaAponta[xi][17]	Segunda Unidade de Medida
		ConvUM(XEST->PI,xnQtdPrd,0,2),;     //18	SD3->D3_QTSEGUM :=	xaAponta[xi][18]	Qtde Segunda Unidade de Medida
		XEST->TIPO_PI,;                     //19	SD3->D3_TIPO	:=	xaAponta[xi][19]	TIPO
		cUserName,;                         //20	SD3->D3_USUARIO	:=	xaAponta[xi][20]	Usuário
		"R0",;                              //21	SD3->D3_CHAVE	:=	xaAponta[xi][21]	Chave
		IIF(xnOrigExe == 1,xnJob,xnMan)})   //22	SD3->D3_ZZIDINT	:=	xaAponta[xi][22]	Origem
		xlProdPI	:=	.F.
		
	EndIf
	
	Aadd(xaAponta, {xFilial('SD3'), ;   //01	SD3->D3_FILIAL	:=	xaAponta[xi][01]	Filial
	xcTmMP,;                            //02	SD3->D3_TM    	:=	xaAponta[xi][02]	Tm MP
	XEST->MP,;                          //03	SD3->D3_COD  	:=	xaAponta[xi][03]	Matéria Prima - Cod
	XEST->OP,;                          //04	SD3->D3_OP  	:=	xaAponta[xi][04]	Numero OP
	XEST->QTDE_MP,; 					//05	SD3->D3_QUANT	:=	xaAponta[xi][05]	Quantidade da Matéria Prima //" + Transform(xnProd12	,"@E 99999") + "
	XEST->ARM_MP,;                      //06	SD3->D3_LOCAL	:=	xaAponta[xi][06]	Local MP
	xcDocEx,;                           //07	SD3->D3_DOC		:=	xaAponta[xi][07]	Documento
	dDataBase,;                         //08	SD3->D3_EMISSAO	:=	xaAponta[xi][08]	Data Emissao
	dDataBase,;                         //09	SD3->D3_DTVALID	:=	xaAponta[xi][09]	Data VAlidade
	XEST->UM_MP,;                       //10	SD3->D3_UM     	:=	xaAponta[xi][10]	Unidade de Medida
	xcTmCF,;                            //11	SD3->D3_CF    	:=	xaAponta[xi][11]	CF
	xcConta,;                           //12	SD3->D3_CONTA	:=	xaAponta[xi][12]	Conta contábil
	xcGrupo,;                           //13	SD3->D3_GRUPO	:=	xaAponta[xi][13]	Grupo
	XEST->CST_MP * XEST->QTDE_MP,;      //14	SD3->D3_CUSTO1  :=	xaAponta[xi][14]	Custo
	xcNumSeq,;                          //15	SD3->D3_NUMSEQ	:=	xaAponta[xi][15]	Numseq
	xcNumSeq,;                          //16	SD3->D3_IDENT	:=	xaAponta[xi][16]	Ident
	XEST->SUM_MP,;                      //17	SD3->D3_SEGUM   :=	xaAponta[xi][17]	Segunda Unidade de Medida
	ConvUM(XEST->MP,XEST->QTDE_MP,0,2),;//18	SD3->D3_QTSEGUM :=	xaAponta[xi][18]	Qtde Segunda Unidade de Medida
	XEST->TIPO_MP,;                     //19	SD3->D3_TIPO	:=	xaAponta[xi][19]	TIPO
	cUserName,;                         //20	SD3->D3_USUARIO	:=	xaAponta[xi][20]	Usuário
	"E0",;                              //21	SD3->D3_CHAVE	:=	xaAponta[xi][21]	Chave
	IIF(xnOrigExe == 1,xnJob,xnMan)})   //22	SD3->D3_ZZIDINT	:=	xaAponta[xi][22]	Origem
	
	xnCusTrf	+=	XEST->CST_MP * XEST->QTDE_MP
	xmLogErr	+=	'OP : ' + XEST->OP + ' RE0: ' + XEST->MP + ' ARM: ' + XEST->ARM_MP + ' QTDE: ' + Transform(XEST->QTDE_MP	,"@E 999,999.9999") + ' SALDO: ' + Transform(XEST->SLD	,"@E 999,999,999,999,999,999.9999") + xcR
	XEST->(DBSKIP())
	
EndDo


If xlEstRet
	
	For xi	:=	1 to Len(xaAponta)
		RecLock('SD3',.T.) //APONTA A ENTRADA DO REFUGO NO ARMAZEM DE REFUGO - 04
		SD3->D3_FILIAL	:=	xaAponta[xi][01]
		SD3->D3_TM    	:=	xaAponta[xi][02]
		SD3->D3_COD  	:=	xaAponta[xi][03]
		SD3->D3_OP  	:=	xaAponta[xi][04]
		SD3->D3_QUANT	:=	xaAponta[xi][05]
		SD3->D3_LOCAL	:=	xaAponta[xi][06]
		SD3->D3_DOC		:=	xaAponta[xi][07]
		SD3->D3_EMISSAO	:=	xaAponta[xi][08]
		SD3->D3_DTVALID	:=	xaAponta[xi][09]
		SD3->D3_UM     	:=	xaAponta[xi][10]
		SD3->D3_CF    	:=	xaAponta[xi][11]
		SD3->D3_CONTA	:=	xaAponta[xi][12]
		SD3->D3_GRUPO	:=	xaAponta[xi][13]
		SD3->D3_CUSTO1  :=	IIF(xi == 1, xnCusTrf, xaAponta[xi][14])
		SD3->D3_NUMSEQ	:=	xaAponta[xi][15]
		SD3->D3_IDENT	:=	xaAponta[xi][16]
		SD3->D3_SEGUM   :=	xaAponta[xi][17]
		SD3->D3_QTSEGUM :=	xaAponta[xi][18]
		SD3->D3_TIPO	:=	xaAponta[xi][19]
		SD3->D3_USUARIO	:=	xaAponta[xi][20]
		SD3->D3_CHAVE	:=	xaAponta[xi][21]
		SD3->D3_ZZIDINT	:=	xaAponta[xi][22]
		
		
		SD3->(MsUnLock())
		DbSelectArea("SB2")
		DbSeek(xFilial("SB2")+xaAponta[xi][03]+xaAponta[xi][06])
		
		// Posiciona no saldo do Refugo na SB2
		
		If Found()
			RecLock("SB2",.f.)
			Replace B2_QATU     with SB2->B2_QATU  + IIF(xi == 1, SD3->D3_QUANT, -SD3->D3_QUANT)
			Replace B2_VATU1    with SB2->B2_VATU1 + IIF(xi == 1, SD3->D3_CUSTO1, -SD3->D3_CUSTO1)
			MsUnlock()
		Else
			RecLock("SB2",.t.)
			Replace B2_FILIAL   with xFilial("SB2")
			Replace B2_COD      with SD3->D3_COD
			Replace B2_LOCAL    with SD3->D3_LOCAL
			Replace B2_QATU     with SD3->D3_QUANT
			Replace B2_VATU1    with SD3->D3_CUSTO1
			Replace B2_CM1      with SB2->B2_VATU1 / SB2->B2_QATU
			MsUnlock()
		Endif
		
	Next xi
	
Else
	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(xFilial("SC2")+TRB->OP,.f.)
		RecLock("SC2",.f.)
		Replace SC2->C2_ZZSTAT 	With "9"
		Replace SC2->C2_ZZDTENV With dDataBase
		Replace SC2->C2_ZZLOGPF With xmLogErr
		SC2->(MsUnlock())
	Endif
	Return xlEstRet
EndIf

If xcTprod	==	"R"
	xsfRefugo(xcOp, xcOper, xcProd, xcRecs, xdDia, xnQtde, xcMoti)
EndIf

Return xlEstRet

Static Function xsfRefugo(_cOp, _cOper, _cProd, _cRecurso, _dDtApont, _nQtdProd, _cMotRef)
Local xlRef		:=	.F.
Local xcOp		:=	_cOp
Local xcOper	:=	_cOper
Local xcProd	:=	_cProd
Local xcRecurso	:=	_cRecurso
Local xdDtApont	:=	_dDtApont
Local xnQtdProd	:=	_nQtdProd
Local xcMotRef	:=	_cMotRef
Local xcLocPad	:=	''
Local xcUnidade	:=	''
Local xcConta	:=	''
Local xcGrupo	:=	''
Local xcSegum	:=	''
Local xcB1Tipo	:=	''
Local xnSldB2	:=	0
Local xnCmB2	:=	0
Local xnPesoRef	:=	0
Local xcLocRef 	:= 	AllTrim(GetMv("MB_LOCREF"))
Local xcRefRef 	:= 	AllTrim(GetMv("MB_ITEMREF")) + REPLICATE(" ",15-LEN(AllTrim(GetMv("MB_ITEMREF"))))//Referência do Refugo
Local xcQuery	:=	""
Local xcR		:=	Char(13) + Char(10)
Local xcSeqbc	:=	''
Local xcSeqd3	:=	''

Private xaAlias 	:= { {Alias()},{"SB1"},{"SB2"},{"SD3"},{"SBC"}}

U_ufAmbiente(xaAlias, "S")

//Posiciona o Cadastro de Produtos para pegar os dados da Referência e o Local Padrão
dbSelectArea('SB1')
dbsetOrder(1)
SB1->(dbSeek(xFilial('SB1') + xcProd ))
xnPesoRef	:=	SB1->B1_PESO

If xnPesoRef = 0
	Return(xlRef)
EndIf
xcLocaPad	:=	SB1->B1_LOCPAD
xcUnidade	:=	SB1->B1_UM
xcConta		:=	SB1->B1_CONTA
xcGrupo		:=	SB1->B1_GRUPO
xcSegum		:=	SB1->B1_SEGUM
xcB1Tipo	:=	SB1->B1_TIPO


dbSelectArea('SB2')
dbsetOrder(1)
SB2->(dbSeek(xFilial('SB2') + xcProd + xcLocaPad))

xnSldB2	:=	SB2->B2_QATU
xnCmB2	:=	SB2->B2_CM1


xcDoc		:=	xsfNumDoc()
xcSeqbc		:=	ProxNum() //Pega o próximo registro para salvar na BC e D3Getmv("MV_DOCSEQ")
xcSeqd3		:=	ProxNum() //Pega o próximo registro para salvar na BC e D3Getmv("MV_DOCSEQ")
//Atualiza a Tabela SBC, inclui a Perda



RecLock('SBC',.T.)
SBC->BC_FILIAL	:=	xFilial('SBC')
SBC->BC_PRODUTO	:=	xcProd
SBC->BC_LOCORIG	:=	xcLocaPad
SBC->BC_TIPO	:=	'R'
SBC->BC_MOTIVO	:=	xcMotRef
SBC->BC_QUANT	:=	xnQtdProd
SBC->BC_CODDEST	:=	xcRefRef
SBC->BC_LOCAL	:=	xcLocRef //Local Destino
SBC->BC_QTDDEST	:=	xnQtdProd * xnPesoRef
SBC->BC_DATA	:=	xdDtApont
SBC->BC_RECURSO	:=	xcRecurso
SBC->BC_OPERAC	:=	xcOper
SBC->BC_NUMSEQ	:=	xcSeqbc
SBC->BC_SEQSD3	:=	xcSeqd3

SBC->(MsUnLock())

RecLock('SD3',.T.) //APONTA A ENTRADA DO REFUGO NO ARMAZEM DE REFUGO - 04
SD3->D3_FILIAL	:=	xFilial("SD3")
SD3->D3_TM    	:=	"499"
SD3->D3_COD  	:=	xcRefRef
SD3->D3_QUANT	:=	xnQtdProd * xnPesoRef
SD3->D3_LOCAL	:=	xcLocRef
SD3->D3_DOC		:=	xcDoc
SD3->D3_EMISSAO	:=	xdDtApont
SD3->D3_DTVALID	:=	dDataBase
SD3->D3_UM     	:=	xcUnidade
SD3->D3_CF    	:=	'DE4'
SD3->D3_CONTA	:=	xcConta
SD3->D3_GRUPO	:=	xcGrupo
SD3->D3_CUSTO1  :=	xnCusTrf //xnCmB2 * xnQtdProd
SD3->D3_NUMSEQ	:=	xcSeqd3
SD3->D3_IDENT	:=	xcSeqd3
SD3->D3_SEGUM   :=	xcSegum
SD3->D3_QTSEGUM :=	ConvUM(xcProd,xnQtdProd,0,2)
SD3->D3_TIPO	:=	"SU"
SD3->D3_USUARIO	:=	'CONV PI EM SUC'
SD3->D3_CHAVE	:=	"E0"
SD3->D3_ZZIDINT	:=	IIF(xnOrigExe = 1,16,26)
SD3->D3_OBS		:=	xcOp
SD3->D3_OBSERVA	:=	IIF(xnOrigExe = 1,'TRANSF REFUGO AUTO','TRANSF REFUGO MANU')


SD3->(MsUnLock())
DbSelectArea("SB2")
DbSeek(xFilial("SB2")+xcRefRef+xcLocRef)
xnSldB2	:=	SB2->B2_QATU

xnCmB2	:=	SB2->B2_CM1

If Found()
	RecLock("SB2",.f.)
	Replace B2_QATU     with SB2->B2_QATU  + SD3->D3_QUANT
	Replace B2_VATU1    with SB2->B2_VATU1 + SD3->D3_CUSTO1
	MsUnlock()
Else
	RecLock("SB2",.t.)
	Replace B2_FILIAL   with xFilial("SB2")
	Replace B2_COD      with SD3->D3_COD
	Replace B2_LOCAL    with SD3->D3_LOCAL
	Replace B2_QATU     with SD3->D3_QUANT
	Replace B2_VATU1    with SD3->D3_CUSTO1
	Replace B2_CM1      with SB2->B2_VATU1 / SB2->B2_QATU
	MsUnlock()
Endif


RecLock('SD3',.T.) //APONTA A SAÍDA DO REFUGO NO ARMAZEM DE PI - 02
SD3->D3_FILIAL	:=	xFilial("SD3")
SD3->D3_TM    	:=	"999"
SD3->D3_COD  	:=	xcProd
SD3->D3_QUANT	:=	xnQtdProd
SD3->D3_LOCAL	:=	xcLocaPad
SD3->D3_DOC		:=	xcDoc
SD3->D3_EMISSAO	:=	xdDtApont
SD3->D3_DTVALID	:=	dDataBase
SD3->D3_UM     	:=	xcUnidade
SD3->D3_CF    	:=	'RE4'
SD3->D3_CONTA	:=	xcConta
SD3->D3_GRUPO	:=	xcGrupo
SD3->D3_CUSTO1  :=	xnCusTrf //xnCmB2 * xnQtdProd
SD3->D3_NUMSEQ	:=	xcSeqd3
SD3->D3_IDENT	:=	xcSeqd3
SD3->D3_SEGUM   :=	xcSegum
SD3->D3_QTSEGUM :=	ConvUM(xcProd,xnQtdProd,0,2)
SD3->D3_TIPO	:=	xcB1Tipo
SD3->D3_USUARIO	:=	'CONV PI EM SUC'
SD3->D3_CHAVE	:=	"E0"
SD3->D3_ZZIDINT	:=	IIF(xnOrigExe = 1,16,26)
SD3->D3_OBS		:=	xcOp
SD3->D3_OBSERVA	:=	IIF(xnOrigExe = 1,'TRANSF REFUGO AUTO','TRANSF REFUGO MANU')
SD3->(MsUnLock())


DbSelectArea("SB2")
DbSeek(xFilial("SB2")+xcProd+xcLocaPad)

// Posiciona no Produto Acabado

If Found()
	RecLock("SB2",.f.)
	Replace B2_QATU     with SB2->B2_QATU  - SD3->D3_QUANT
	Replace B2_VATU1    with SB2->B2_VATU1 - SD3->D3_CUSTO1
	MsUnlock()
Else
	RecLock("SB2",.t.)
	Replace B2_FILIAL   with xFilial("SB2")
	Replace B2_COD      with SD3->D3_COD
	Replace B2_LOCAL    with SD3->D3_LOCAL
	Replace B2_QATU     with SD3->D3_QUANT
	Replace B2_VATU1    with SD3->D3_CUSTO1
	Replace B2_CM1      with SB2->B2_VATU1 / SB2->B2_QATU
	MsUnlock()
Endif


xlRef	:=	.T.

U_ufAmbiente(xaAlias, "R")

Return xlRef


Static Function xsfNumDoc()
Local xcProxDoc	:=	''
xcQuery :=  	"SELECT "
xcQuery += xcR + 	"	MAX(D3_DOC) DOC  "
xcQuery += xcR + 	"FROM  "
xcQuery += xcR + 	"	" + RetSqlName('SD3') + "  "
xcQuery += xcR + 	"WHERE  "
xcQuery += xcR + 	"	D_E_L_E_T_ = '' AND  "
xcQuery += xcR + 	"	D3_FILIAL = '" + xFilial('SD3') + "' "

if select("XTRB") > 0
	XTRB->(dbclosearea())
endif

//Gera o Arquivo de Trabalho
TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB


dbSelectArea('XTRB')
XTRB->(dbGoTop())


xcProxDoc	:=	Soma1(XTRB->DOC,9)
Return xcProxDoc

