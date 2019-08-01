#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
/*
Ponto de entrada para Ajustes:

01 - Dados adicionais dos produtos. xaProd	:=	xsfxaProd(ParamIxb[01])
02 - Volume separado por espécie. xaVol	:=	xsfVolum()

*/
User function PE01NFESEFAZ()
	local xcR				:=	Char(13) + Char(10)
	local xaRet  			:=	{}
	local xaProd			:=	ParamIxb[01] //a descrição complementar está na paramIxb[1][1][25]
	local xcMensCli			:=	ParamIxb[02]
	local _cMensFis			:=	ParamIxb[03]
	local _aDest			:=	ParamIxb[04]
	local _aNota			:=	ParamIxb[05]
	local xaInfoItem		:=	ParamIxb[06]
	local _aDupl			:=	ParamIxb[07]
	local _aTransp			:=	ParamIxb[08]
	local _aEntrega			:=	ParamIxb[09]
	local _aRetirada		:=	ParamIxb[10]
	local xaVeiculo			:=	ParamIxb[11]
	local _aReboque			:=	ParamIxb[12]
	local _aNfVincRur		:=	ParamIxb[13]
	local _aEspVol			:=	ParamIxb[14]
	local _aNfVinc			:=	ParamIxb[15]
	local _aDetPag			:=	ParamIxb[16]
	local _aObsCont			:=	ParamIxb[17]
	

	//private xcPlaca 	:=	''
	private _cMarca 	:=	''
	private cMensCli 	:=	''
	private _cMens		:=	''
	private aMenPad1	:=	{}
	private _cNomRed	:=	''
	private _cRegSp   	:=	''
	private cSuframa	:=	''
	private aPedCli		:=	{}
	private cPedCli		:=	''
	private aNumPed		:=	{}
	private cPedEmpr	:=	''
	
	_cMensFis	:=	xfMensFis(_aNota)
	_cMensFis	+= 	xcR + xcR + 'Nosso Pedido: ' + xaInfoItem[1][1]
	
	
	//Coloca a Placa do Veículo
	if !(empty(alltrim(SF2->F2_ZUFPLAC)))
		xaVeiculo		:=	{SF2->F2_ZZPLACA, SF2->F2_ZUFPLAC, ''}
	endif

//	aParam := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc,aDetPag,aObsCont}
	aParam:={xaProd,xcMensCli,_cMensFis,_aDest,_aNota,xaInfoItem,_aDupl,_aTransp,_aEntrega,_aRetirada,xaVeiculo,_aReboque,_aNfVincRur,_aEspVol,_aNfVinc,_aDetPag,_aObsCont}
	

Return(aParam)


static function xfMensFis(_xaNota)
	local xcRet		:=	''
	local xaNota	:= 	{}

	xaNota	:=	_xaNota

	//xcPlaca := SF2->F2_ZZPLACA
	//_cMarca := SF2->F2_ZZMARCA

	if xaNota[4] == '1'
		dbSelectArea("SZZ")
		dbSeek(xFilial("SZZ")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		Do While !Eof() .and. SZZ->ZZ_TIPODOC == "S"  .and.;
				SZZ->ZZ_DOC      == SF2->F2_DOC   .and.;
				SZZ->ZZ_SERIE   == SF2->F2_SERIE .and.;
				SZZ->ZZ_CLIFOR  == SF2->F2_CLIENTE .and.;
				SZZ->ZZ_LOJA 	   == SF2->F2_LOJA
		
			If Ascan(aMenPad1,SZZ->ZZ_CODMENS+SZZ->ZZ_SEQMENS) == 0
				_cMens  := AllTrim(SZZ->ZZ_TXTMENS)
				If !Empty(_cMens)
					PutMsg(_cMens,@cMensCli)
				EndIf
			EndIf
			SZZ->(dbSkip())
		EndDo
		SZZ->(dbCloseArea())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA4 Para Buscar o Redespacho                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea ("SA4")
		If dbSeek (xFilial ("SA4") + SF2->F2_REDESP)
//		_cNomRed := "REDESPACHO: FROTA MB" - 
			_cNomRed := "REDESPACHO: "+AllTrim(SA4->A4_NOME)+" - "+AllTrim(SA4->A4_END)+" - "+AllTrim(SA4->A4_BAIRRO)+" - "+AllTrim(SA4->A4_MUN)+" / "+AllTrim(SA4->A4_EST)+" - "+AllTrim(SA4->A4_COMPLEM)
			PutMsg(_cNomRed,@cMensCli)
		EndIf
		SA4->(dbCloseArea())
	
		If !Empty(_cRegSp)
			PutMsg(_cRegSp,@cMensCli)
		EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inserido nos dados adicionais a inscricao no SUFRAMA do cliente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cSuframa)
			cSuframa := "Insc.Suframa Cliente: " + cSuframa
			PutMsg(cSuframa,@cMensCli)
		Endif

	// Numero do pedido do cliente
		If Len(aPedCli) > 0
			If Len(aPedCli) > 1
				cPedCli := "Seus Pedidos: "
			Else
				cPedCli := "Seu Pedido: "
			Endif
		Endif
		For nX := 1 to Len(aPedCli)
			cPedCli := cPedCli + AllTrim(aPedCli[nX])
			If nX < Len(aPedCli)
				cPedCli := cPedCli + "-"
			Endif
		Next
		PutMsg(cPedCli,@cMensCli)

	// Numero do pedido da empresa
		If Len(aNumPed) > 0
			If Len(aNumPed) > 1
				cPedEmpr := "Nossos Pedidos: "
			Else
				cPedEmpr := "Nosso Pedido: "
			Endif
		Endif
		For nX := 1 to Len(aNumPed)
			cPedEmpr := cPedEmpr + AllTrim(aNumPed[nX])
			If nX < Len(aNumPed)
				cPedEmpr := cPedEmpr + "-"
			Endif
		Next
		PutMsg(cPedEmpr,@cMensCli)
	
	Else
		dbSelectArea("SZZ")
		dbSeek(xFilial("SZZ")+"E"+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		While !Eof() .and. SZZ->ZZ_TIPODOC == "E"  .and.;
				SZZ->ZZ_DOC     == SF1->F1_DOC   .and.;
				SZZ->ZZ_SERIE   == SF1->F1_SERIE .and.;
				SZZ->ZZ_CLIFOR  == SF1->F1_FORNECE .and.;
				SZZ->ZZ_LOJA 	== SF1->F1_LOJA
			If Ascan(aMenPad1,SZZ->ZZ_CODMENS+SZZ->ZZ_SEQMENS) == 0
				_cMens  := AllTrim(SZZ->ZZ_TXTMENS)
				If !Empty(_cMens)
					PutMsg(_cMens,@cMensCli)
				EndIf
			EndIf
			dbSkip()
		End
		SZZ->(dbCloseArea())
	EndIf
	xcRet	:=	cMensCli
return xcRet



Static Function PutMsg(cTexto,cVar)

	If !Empty(cTexto) .AND. !( Upper(AllTrim(cTexto)) $ cMensCli+cVar )
		cVar += IIF(!Empty(cVar),"; ","")
		cVar += cTexto
	EndIf

Return

//
//PERSONALIZAÇÃO ESPECÍFICA PLASTICOS MB
//
Static Function GetNfImp()
	_aRet := {}

	IF SB1->B1_VLR_IPI > 0
		nQtdIPI := SD1->D1_QUANT
		nVlrIPI := SB1->B1_VLR_IPI
	ELSE
		nQtdIPI := 0
		nVlrIPI := 0
	ENDIF

	IF SB1->B1_VLR_PIS > 0
		nQtdPIS := SD1->D1_QUANT
		nVlrPIS := SB1->B1_VLR_PIS
	ELSE
		nQtdPIS := 0
		nVlrPIS := 0
	ENDIF

	IF SB1->B1_VLR_COF > 0
		nQtdCOF := SD1->D1_QUANT
		nVlrCOF := SB1->B1_VLR_COF
	ELSE
		nQtdCOF := 0
		nVlrCOF := 0
	ENDIF
	aadd(_aRet,{"I04","NCM",SB1->B1_POSIPI})// WN_TEC NCM.
	aadd(_aRet,{"I15","vFrete",SD1->D1_VALFRE})// WN_FRETE Valor do frete.
	aadd(_aRet,{"I16","vSeg",SD1->D1_SEGURO})// WN_SEGURO Valor do seguro.
	aadd(_aRet,{"I19","nDI",SF1->F1_ZZDINUM})// W6_DI_NUM Nº DI/DA.
	aadd(_aRet,{"I20","dDI",SF1->F1_ZZDTREG})// W6_DTREG_D Data do registro da DI/DA.
	aadd(_aRet,{"I21","xLocDesemb",SF1->F1_ZZlocal})// W6_localN local desembaraço.
	aadd(_aRet,{"I22","UFDesemb",SF1->F1_ZZUFDES})// W6_UFDESEM Estado desembaraço.
	aadd(_aRet,{"I23","dDesemb",SF1->F1_ZZDTDES})// W6_DT_DESE Data desembaraço.
	aadd(_aRet,{"I24","cExportador",SF1->F1_FORNECE+SF1->F1_LOJA})// WN_FORNECE Código Exportador
	aadd(_aRet,{"I26","nAdicao",val(SD1->D1_ZZADICA)})// WN_ADICAO Adição
	aadd(_aRet,{"I27","nSeqAdi",val(SD1->D1_ZZSEQAD)})// WN_SEQ_ADI Seqüência do item dentro da adição
	aadd(_aRet,{"I28","cFabricante",SF1->F1_FORNECE+SF1->F1_LOJA})// W8_FABR Código Fabricante
	aadd(_aRet,{"I29","vDescDI",SD1->D1_ZZDESCA})// WN_DESCONI Valor do desconto do item da DI - adição
	aadd(_aRet,{"N14","pRedBC",SD1->D1_ZZPRDBC})// WN_PREDICM Percentual de redução de base de ICMS
	aadd(_aRet,{"O11","qUnid",nQtdIPI})// WN_QTUIPI Qtde na unidade padrão para tributação
	aadd(_aRet,{"O12","vUnid",SD1->D1_ZZALIPI})// WN_ALUIPI Valor por unidade tributável
	aadd(_aRet,{"P02","vBC",SD1->D1_ZZBCII})// WN_CIF Valor C.I.F
	aadd(_aRet,{"P03","vDespAdu",SD1->D1_ZZDSPAD})// WN_DESPADU Valor das despesas aduaneiras
	aadd(_aRet,{"P04","vII",SD1->D1_ZZII})// WN_IIVAL Valor do II
	aadd(_aRet,{"P05","vIOF",SD1->D1_ZZVLIOF})// WN_VLRIOF Valor do IOF
	aadd(_aRet,{"Q10","qBCProd",nQtdPIS})// WN_QTUPIS Qtde na unidade padrão para tributação
	aadd(_aRet,{"Q11","vAliqProd",SD1->D1_ZZVLPIS})// WN_VLUPIS Valor por unidade tributável
	aadd(_aRet,{"S09","qBCProd",nQtdCof})// WN_QTUCOF Qtde na unidade padrão para tributação
	aadd(_aRet,{"S10","vAliqProd",SD1->D1_ZZVLCOF})// WN_VLUCOF Valor por unidade tributável
	aadd(_aRet,{"XXX","Emaildesp",""})// Y5_EMAIL E-mail do despachante



Return _aRet