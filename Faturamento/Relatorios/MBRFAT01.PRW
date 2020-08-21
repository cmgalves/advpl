#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MBRFAT01 ³ Autor ³ Marco Bianchi         ³ Data ³ 10/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT-R4                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³21/06/10  ³ Mary Hergert  ³- Removida a impressao da comissao          ³±±
±±³          ³               ³- Inserida a impressao do nro. volumes      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MBRFAT01(xcNumPed)
Private xcPed	:=	xcNumPed
Private xcPedido:=	SC5->C5_NUM
Default xcPed	:=	''


Static oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 10/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

//Local oReport
Local oPreNota
Local nValImp  	:= 0
Local nUltLib  	:= 0
Local aCabPed	:= {}
Local aItemPed  := {}
Local nItem 	:= 0
Local nTamData  := Len(DTOC(MsDate()))

Private aCodImps:= {}
Private nI		:= 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MBRFAT01","Emissao da Confirmacao do Pedido","MTR730", {|oReport| ReportPrint(oReport,oPreNota,@nItem,aItemPed,aCabPed)},"Emissao da confirmacao dos pedidos de venda, de acordo com" + " " + "intervalo informado na opcao Parametros.")	// "Emissao da Confirmacao do Pedido"###"Emissao da confirmacao dos pedidos de venda, de acordo com"###"intervalo informado na opcaoo Parametros."
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

	Pergunte(oReport:uParam,.F.)

	If xcPed == 'DIRETO'
	dbSelectArea("SX1")
	dbSetOrder(1)
	SX1->(dbSeek(oReport:uParam))
		Do While !SX1->(EOF()) .AND. ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(oReport:uParam)
	    RecLock("SX1",.F.)
			SX1->X1_CNT01	:=	xcPedido
		MsUnLock()
		SX1->(dbSkip())
		EndDo
	EndIf

	If FunName() == 'MATA410'
		MV_PAR01 := SC5->C5_NUM
		MV_PAR02 := SC5->C5_NUM
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao dos itens do Pedido de Vendas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPreNota := TRSection():New(oReport,"Itens do Pedido de Venda",{"SC5","SC6"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Emissao da Confirmacao do Pedido"
oPreNota:SetTotalInLine(.F.)

TRCell():New(oPreNota,"AITEM01",/*Tabela*/,"IT"					 ,PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| aItemPed[nItem][01] 																	})	// "IT"
TRCell():New(oPreNota,"AITEM01",/*Tabela*/,"Tab"					 ,PesqPict("SC6","C6_ZTABELA"		),TamSx3("C6_ZTABELA"		)[1],/*lPixel*/,{|| aItemPed[nItem][22] 																	})	// "IT"
TRCell():New(oPreNota,"AITEM02",/*Tabela*/,RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| aItemPed[nItem][02] 																	})	// Codigo do Produto
TRCell():New(oPreNota,"AITEM03",/*Tabela*/,RetTitle("C6_DESCRI"	),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03])						})	// Descricao do Produto
TRCell():New(oPreNota,"AITEM04",/*Tabela*/,"TES"					 ,PesqPict("SC6","C6_TES"		),TamSx3("C6_TES"		)[1],/*lPixel*/,{|| aItemPed[nItem][04] 																	})	// "TES"
TRCell():New(oPreNota,"AITEM05",/*Tabela*/,"CF"					 ,PesqPict("SC6","C6_CF"		),TamSx3("C6_CF"		)[1],/*lPixel*/,{|| aItemPed[nItem][05] 																	})	// "CF"
TRCell():New(oPreNota,"AITEM06",/*Tabela*/,"UM"					 ,PesqPict("SC6","C6_UM"		),TamSx3("C6_UM"		)[1],/*lPixel*/,{|| aItemPed[nItem][06] 																	})	// "UM"
TRCell():New(oPreNota,"AITEM07",/*Tabela*/,"Quant."					 ,PesqPictQt("C6_QTDVEN"	    ),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| aItemPed[nItem][07] 																	})	// "Quant."
TRCell():New(oPreNota,"AITEM08",/*Tabela*/,RetTitle("C6_PRCVEN"	),PesqPict("SC6","C6_PRCVEN"	),TamSx3("C6_PRCVEN"	)[1],/*lPixel*/,{|| aItemPed[nItem][08] 																	})	// Preco Unitario
	If cPaisLoc == "BRA"
	TRCell():New(oPreNota,"NALIQIPI",/*Tabela*/	,"IPI","@e 99.99"				,5,/*lPixel*/,{|| MaFisRet(nItem,"IT_ALIQIPI") 																											})	// "IPI"
	Else
	TRCell():New(oPreNota,"NVALIMP"	,/*Tabela*/	,"IPI",Tm(nValImp,10,2)	,5,/*lPixel*/,{|| Tm(nValImp,10,2) 																														})	// "IPI"
	EndIf
TRCell():New(oPreNota,"AITEM13",/*Tabela*/,"Vl.Tot.C/IPI"						,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| aItemPed[nItem][13]+nValImp 														})	// "Vl.Tot.C/IPI"
TRCell():New(oPreNota,"AITEM14",/*Tabela*/,RetTitle("C6_ENTREG"	)	,PesqPict("SC6","C6_ENTREG"		),nTamData					,/*lPixel*/,{|| aItemPed[nItem][14] 																},,,,,,.F.)	// Data de Entrega
TRCell():New(oPreNota,"AITEM15",/*Tabela*/,RetTitle("C6_DESCONT")	,PesqPict("SC6","C6_DESCONT"	),TamSx3("C6_DESCONT"	)[1],/*lPixel*/,{|| aItemPed[nItem][21] 																})	// % Desconto
TRCell():New(oPreNota,"AITEM16",/*Tabela*/,"Loc."						,PesqPict("SC6","C6_LOCAL"		),TamSx3("C6_LOCAL"		)[1],/*lPixel*/,{|| aItemPed[nItem][16] 																})	// "Loc."
TRCell():New(oPreNota,"AITEM17",/*Tabela*/,"Qtd.a Fat."						,PesqPictQt("C6_QTDLIB"		    ),TamSx3("C6_QTDLIB"	)[1],/*lPixel*/,{|| aItemPed[nItem][17] 												  				})	// "Qtd.a Fat."
TRCell():New(oPreNota,"NSALDO" ,/*Tabela*/,"Saldo"						,PesqPictQt("C6_QTDLIB"		    ),TamSx3("C6_QTDLIB"	)[1],/*lPixel*/,{|| aItemPed[nItem][07]-aItemPed[nItem][17]+aItemPed[nItem][18]-aItemPed[nItem][19]	})	// "Saldo"
TRCell():New(oPreNota,"NULTLIB",/*Tabela*/,"Ult.Fat."						,PesqPictQt("D2_QUANT",10	    ),TamSx3("D2_QUANT"		)[1],/*lPixel*/,{|| nUltLib 																			})	// "Ult.Fat."
TRCell():New(oPreNota,"NCM",/*Tabela*/	   ,"NCM"						,PesqPictQt("C6_ZZNCM"	    )	 ,TamSx3("C6_ZZNCM"		)[1],/*lPixel*/,{|| aItemPed[nItem][20]																})	// "NCM."

TRFunction():New(oPreNota:Cell("AITEM07"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,PesqPict("SC6","C6_QTDVEN",20),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oPreNota:Cell("AITEM13"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao dos Impostos                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oImpostos := TRSection():New(oReport,"Impostos",{"SC5","SC6","SD1","SB1","SD2","SA1","SA2","SA4","SE4","SA3","SX3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Emissao da Confirmacao do Pedido"
oImpostos:SetTotalInLine(.F.)
	If cPaisLoc == "BRA"
	TRCell():New(oImpostos,"NF_BASEICM"	,/*Tabela*/,"Base Icms",PesqPict("SF2","F2_BASEICM"),TamSx3("F2_BASEICM"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_BASEICM") 	})	// "Base Icms"
	TRCell():New(oImpostos,"NF_VALICM"	,/*Tabela*/,"Valor Icms",PesqPict("SF2","F2_VALICM") ,TamSx3("F2_VALICM"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_VALICM"	) 	})	// "Valor Icms"
	TRCell():New(oImpostos,"NF_BASEIPI"	,/*Tabela*/,"Base Ipi",PesqPict("SF2","F2_BASEIPI"),TamSx3("F2_BASEIPI"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_BASEIPI") 	})	// "Base Ipi"
	TRCell():New(oImpostos,"NF_VALIPI"	,/*Tabela*/,"Valor Ipi",PesqPict("SF2","F2_VALIPI") ,TamSx3("F2_VALIPI"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_VALIPI"	) 	})	// "Valor Ipi"
	TRCell():New(oImpostos,"NF_BASESOL"	,/*Tabela*/,"Base Retido",PesqPict("SF2","F2_BRICMS") ,TamSx3("F2_BRICMS"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_BASESOL") 	})	// "Base Retido"
	TRCell():New(oImpostos,"NF_VALSOL"	,/*Tabela*/,"Valor Retido",PesqPict("SF2","F2_ICMSRET"),TamSx3("F2_ICMSRET"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_VALSOL"	) 	})	// "Valor Retido"
	TRCell():New(oImpostos,"NF_TOTAL"	,/*Tabela*/,"Valor Total",PesqPict("SF2","F2_VALBRUT"),TamSx3("F2_VALBRUT"	    	)[1],/*lPixel*/,{|| MaFisRet(,"NF_TOTAL"	) 	})	// "Valor Total"
	TRCell():New(oImpostos,"NF_BASEISS"	,/*Tabela*/,"Base Iss",PesqPict("SF2","F2_BASEISS"),TamSx3("F2_BASEISS"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_BASEISS") 	})	// "Base Iss"
	TRCell():New(oImpostos,"NF_VALISS"	,/*Tabela*/,"Valor Iss",PesqPict("SF2","F2_VALISS") ,TamSx3("F2_VALISS"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_VALISS"	) 	})	// "Valor Iss"
	Else
	TRCell():New(oImpostos,"aCodImps2"	,/*Tabela*/,"Imposto",/*Picture*/			,13,/*lPixel*/,{|| aCodImps[nI][2] 		})	// "Imposto"
	TRCell():New(oImpostos,"aCodImps3"	,/*Tabela*/,"Base","@E 99,999,999.99"	,13,/*lPixel*/,{|| aCodImps[nI][3] 		})	// "Base"
	TRCell():New(oImpostos,"aCodImps4"	,/*Tabela*/,"Aliquota","@E 99,999,999.99"	,13,/*lPixel*/,{|| aCodImps[nI][4] 		})	// "Aliquota"
	TRCell():New(oImpostos,"aCodImps5"	,/*Tabela*/,"Valor","@E 99,999,999.99"	,13,/*lPixel*/,{|| aCodImps[nI][5]			})	// "Valor"
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Troca descricao do total dos itens                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):SetTotalText("T O T A I S ")	// "T O T A I S "

TRPosition():New(oPreNota,"SC6",1,{|| xFilial("SC5") + aCabPed[07]+aItemPed[nItem][01]})
TRPosition():New(oPreNota,"SC5",1,{|| xFilial("SC6") + aCabPed[07]+aItemPed[nItem][01]})

oReport:Section(2):SetEdit(.F.)
oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alinhamento a direita as colunas de valor                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPreNota:Cell("AITEM07"):SetHeaderAlign("RIGHT")
oPreNota:Cell("AITEM08"):SetHeaderAlign("RIGHT")
	If cPaisLoc == "BRA"
	oPreNota:Cell("NALIQIPI"):SetHeaderAlign("RIGHT")
	//oPreNota:Cell("NALIQICM"):SetHeaderAlign("RIGHT")
	//oPreNota:Cell("NALIQISS"):SetHeaderAlign("RIGHT")

	oImpostos:Cell("NF_BASEICM"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_VALICM"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_BASEIPI"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_VALIPI"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_BASESOL"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_VALSOL"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_TOTAL"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_BASEISS"):SetHeaderAlign("RIGHT")
	oImpostos:Cell("NF_VALISS"):SetHeaderAlign("RIGHT")

	Else
	oPreNota:Cell("NVALIMP"):SetHeaderAlign("RIGHT")	

	oImpostos:Cell("aCodImps2"):SetHeaderAlign("RIGHT")	
	oImpostos:Cell("aCodImps3"):SetHeaderAlign("RIGHT")	
	oImpostos:Cell("aCodImps4"):SetHeaderAlign("RIGHT")	
	oImpostos:Cell("aCodImps5"):SetHeaderAlign("RIGHT")	
	EndIf
oPreNota:Cell("AITEM13"):SetHeaderAlign("RIGHT")	
oPreNota:Cell("AITEM17"):SetHeaderAlign("RIGHT")	
oPreNota:Cell("NSALDO"):SetHeaderAlign("RIGHT")	
oPreNota:Cell("NULTLIB"):SetHeaderAlign("RIGHT")	
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 10/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,oPreNota,nItem,aItemPed,aCabPed)

Local lQuery    := .F.
	#IFNDEF TOP
	Local cCondicao := ""
	#ENDIF

Local aPedCli    := {}
Local aC5Rodape  := {}
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})
Local aFisGet    := Nil
Local aFisGetSC5 := Nil
Local cKey 	     := ""
Local cAliasSC5  := "SC5"
Local cAliasSC6  := "SC6"
Local cQryAd     := ""
Local cPedido    := ""
Local cCliEnt	 := ""
Local cNfOri     := Nil
Local cSeriOri   := Nil
Local nDesconto  := 0
Local nPesLiq    := 0
Local nRecnoSD1  := Nil
Local nG		 := 0
Local nFrete	 := 0
Local nSeguro	 := 0
Local nFretAut	 := 0
Local nDespesa	 := 0
Local nDescCab	 := 0
Local nPDesCab	 := 0
Local nY         := 0
Local nValMerc   := 0
Local nPrcLista  := 0
Local nAcresFin  := 0

FisGetInit(@aFisGet,@aFisGetSC5)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		If TcSrvType() <> "AS/400"
	
		cQryAd := "%"
			For nY := 1 To Len(aFisGet)
			cQryAd += ","+aFisGet[nY][2]
			Next nY
			For nY := 1 To Len(aFisGetSC5)
			cQryAd += ","+aFisGetSC5[nY][2]
			Next nY
		cQryAd += "%"
	
		cAliasSC5:= cAliasSC6:= GetNextAlias()
		lQuery    := .T.
		
		oReport:Section(1):BeginQuery()
			BeginSql Alias cAliasSC5
		SELECT SC5.R_E_C_N_O_ SC5REC,SC6.R_E_C_N_O_ SC6REC,
		SC5.C5_FILIAL,SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPO,
		SC5.C5_TIPOCLI,SC5.C5_TRANSP,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_DESC1,
		SC5.C5_DESC2,SC5.C5_DESC3,SC5.C5_DESC4,SC5.C5_MENNOTA,SC5.C5_EMISSAO,
		SC5.C5_CONDPAG,SC5.C5_FRETE,SC5.C5_DESPESA,SC5.C5_FRETAUT,SC5.C5_TPFRETE,SC5.C5_SEGURO,SC5.C5_TABELA,
		SC5.C5_VOLUME1,SC5.C5_ESPECI1,SC5.C5_MOEDA,SC5.C5_REAJUST,SC5.C5_BANCO,
		SC5.C5_ACRSFIN,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_VEND3,SC5.C5_VEND4,SC5.C5_VEND5,C5_ZZOBPED,C5_ZZOBEXP,
		SC5.C5_COMIS1,SC5.C5_COMIS2,SC5.C5_COMIS3,SC5.C5_COMIS4,SC5.C5_COMIS5,SC5.C5_PDESCAB,SC5.C5_DESCONT,C5_INCISS, C5_ZZCUBA, C5_ZZDTENT,
		SC5.C5_CLIENT,SC5.C5_REDESP,SC5.C5_FRETEMB,C5_ZZPLLM,
		SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_PEDCLI,SC6.C6_PRODUTO,SC6.C6_ZTABELA,
		SC6.C6_TES,SC6.C6_CF,SC6.C6_QTDVEN,SC6.C6_PRUNIT,SC6.C6_VALDESC,
		SC6.C6_VALOR,SC6.C6_ITEM,SC6.C6_DESCRI,SC6.C6_UM,
		SC6.C6_PRCVEN,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_CLI,
		SC6.C6_LOJA,SC6.C6_ENTREG,SC6.C6_DESCONT,SC6.C6_LOCAL,SC6.C6_XPERDES,
		SC6.C6_QTDEMP,SC6.C6_QTDLIB,SC6.C6_QTDENT,SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI
		%Exp:cQryAd%
		FROM %Table:SC5% SC5, %Table:SC6% SC6
		WHERE
		SC5.C5_FILIAL = %xFilial:SC5% AND
		SC5.C5_NUM >= %Exp:mv_par01% AND
		SC5.C5_NUM <= %Exp:mv_par02% AND
		SC5.%notdel% AND
		SC6.C6_FILIAL = %xFilial:SC6% AND
		SC6.C6_NUM   = SC5.C5_NUM AND
		SC6.%notdel%
		ORDER BY SC5.C5_NUM    
			EndSql
			oReport:section(1):endQuery()

		Else
		#ENDIF
		cAliasSC5 := "SC5"
		dbSelectArea(cAliasSC5)
		cKey := IndexKey()
		cCondicao := 'C5_FILIAL == "'+xFilial("SC5")+'" .And. (C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'")'
		oReport:Section(1):SetFilter(cCondicao,"",,cAliasSC5)
		oReport:SetMeter(RecCount())		// Total de Elementos da regua
		DbGoTop()

		#IFDEF TOP
		Endif
	#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !oReport:Cancel() .And. !((cAliasSC5)->(Eof())) .and. xFilial("SC5")==(cAliasSC5)->C5_FILIAL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa a validacao dos filtros do usuario           	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasSC5)

		cCliEnt := IIf(!Empty((cAliasSC5)->(FieldGet(FieldPos("C5_CLIENT")))),(cAliasSC5)->C5_CLIENT,(cAliasSC5)->C5_CLIENTE)
		aCabPed := {}

		MaFisIni(cCliEnt,;						// 1-Codigo Cliente/Fornecedor
		(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
		If((cAliasSC5)->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			(cAliasSC5)->C5_TIPO,;				// 4-Tipo da NF
			(cAliasSC5)->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
			aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
			,;						   			// 7-Tipo de complemento
			,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;								// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")							// 10-Nome da rotina que esta utilizando a funcao
			//Na argentina o calculo de impostos depende da serie.
			If cPaisLoc == 'ARG'
				SA1->(DbSetOrder(1))
				SA1->(MsSeek(xFilial()+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI))
				MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
			Endif

			nFrete		:= (cAliasSC5)->C5_FRETE
			nSeguro		:= (cAliasSC5)->C5_SEGURO
			nFretAut	:= (cAliasSC5)->C5_FRETAUT
			nDespesa	:= (cAliasSC5)->C5_DESPESA
			nDescCab	:= (cAliasSC5)->C5_DESCONT
			nPDesCab	:= (cAliasSC5)->C5_PDESCAB

			aItemPed:= {}
			aCabPed := {	(cAliasSC5)->C5_TIPO	,;  //01
			(cAliasSC5)->C5_CLIENTE				,;  //02
			(cAliasSC5)->C5_LOJACLI				,;  //03
			(cAliasSC5)->C5_TRANSP				,;  //04
			(cAliasSC5)->C5_CONDPAG				,;  //05
			(cAliasSC5)->C5_EMISSAO				,;  //06
			(cAliasSC5)->C5_NUM					,;  //07
			(cAliasSC5)->C5_VEND1				,;  //08
			(cAliasSC5)->C5_VEND2				,;  //09
			(cAliasSC5)->C5_VEND3				,;  //10
			(cAliasSC5)->C5_VEND4				,;  //11
			(cAliasSC5)->C5_VEND5				,;  //12
			(cAliasSC5)->C5_COMIS1				,;  //13
			(cAliasSC5)->C5_COMIS2				,;  //14
			(cAliasSC5)->C5_COMIS3				,;  //15
			(cAliasSC5)->C5_COMIS4				,;  //16
			(cAliasSC5)->C5_COMIS5				,;  //17
			(cAliasSC5)->C5_FRETE				,;  //18
			(cAliasSC5)->C5_TPFRETE				,;  //19
			(cAliasSC5)->C5_SEGURO				,;  //20
			(cAliasSC5)->C5_TABELA				,;  //21
			(cAliasSC5)->C5_VOLUME1				,;  //22
			(cAliasSC5)->C5_ESPECI1				,;  //23
			(cAliasSC5)->C5_MOEDA				,;  //24
			(cAliasSC5)->C5_REAJUST				,;  //25
			(cAliasSC5)->C5_BANCO				,;  //26
			(cAliasSC5)->C5_ACRSFIN				,;  //27
			(cAliasSC5)->C5_REDESP			    ,;  //28
			(cAliasSC5)->C5_NUM			        ,;  //29
			(cAliasSC5)->C5_FRETEMB				,;  //30
			(cAliasSC5)->C5_ZZDTENT				,;  //31
			(cAliasSC5)->C5_ZZOBPED				,;  //32
			(cAliasSC5)->C5_ZZOBEXP				,;  //33
			(cAliasSC5)->C5_ZZPLLM				,;  //34
			Round((SC5->C5_ZTOTDES / (SC5->C5_ZTOTPED + SC5->C5_ZTOTDES)) * 100,2); //35 Desconto Médio do pedido.
			}


			nPesBru	:= 0
			nPesLiq	:= 0
			aPedCli	:= {}
			If !lQuery
				dbSelectArea(cAliasSC6)
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+(cAliasSC5)->C5_NUM)
			EndIf
			cPedido    := (cAliasSC5)->C5_NUM
			aC5Rodape  := {}
			aadd(aC5Rodape,;
				{(cAliasSC5)->C5_PBRUTO,;
				(cAliasSC5)->C5_PESOL,;
				(cAliasSC5)->C5_DESC1,;
				(cAliasSC5)->C5_DESC2,;
				(cAliasSC5)->C5_DESC3,;
				(cAliasSC5)->C5_DESC4,;
				(cAliasSC5)->C5_MENNOTA,;
				(cAliasSC5)->C5_VOLUME1,;
				(cAliasSC5)->C5_ZZCUBA})

			aPedCli := Mtr730Cli(cPedido)

			dbSelectArea(cAliasSC5)
			For nY := 1 to Len(aFisGetSC5)
				If !Empty(&(aFisGetSC5[ny][2]))
					If aFisGetSC5[ny][1] == "NF_SUFRAMA"
						MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
					Else
						MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
					Endif
				EndIf
			Next nY

			While !oReport:Cancel() .And. !((cAliasSC6)->(Eof())) .And. xFilial("SC6")==(cAliasSC6)->C6_FILIAL .And.;
					(cAliasSC6)->C6_NUM == cPedido


				cNfOri     := Nil
				cSeriOri   := Nil
				nRecnoSD1  := Nil
				nDesconto  := 0

				If !Empty((cAliasSC6)->C6_NFORI)
					dbSelectArea("SD1")
					dbSetOrder(1)
					dbSeek(xFilial("SC6")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+;
						(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI)
					cNfOri     := (cAliasSC6)->C6_NFORI
					cSeriOri   := (cAliasSC6)->C6_SERIORI
					nRecnoSD1  := SD1->(RECNO())
				EndIf
				dbSelectArea(cAliasSC6)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o preco de lista                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nValMerc  := (cAliasSC6)->C6_VALOR
				nPrcLista := (cAliasSC6)->C6_PRUNIT
				If ( nPrcLista == 0 )
					nPrcLista := NoRound(nValMerc/(cAliasSC6)->C6_QTDVEN,TamSX3("C6_PRCVEN")[2])
				EndIf
				nAcresFin := A410Arred((cAliasSC6)->C6_PRCVEN*(cAliasSC5)->C5_ACRSFIN/100,"D2_PRCVEN")
				nValMerc  += A410Arred((cAliasSC6)->C6_QTDVEN*nAcresFin,"D2_TOTAL")
				nDesconto := a410Arred(nPrcLista*(cAliasSC6)->C6_QTDVEN,"D2_DESCON")-nValMerc
				nDesconto := IIf(nDesconto==0,(cAliasSC6)->C6_VALDESC,nDesconto)
				nDesconto := Max(0,nDesconto)
				nPrcLista += nAcresFin
				If cPaisLoc=="BRA"
					nValMerc  += nDesconto
				EndIf

				MaFisAdd((cAliasSC6)->C6_PRODUTO	,;	// 1-Codigo do Produto ( Obrigatorio )
				(cAliasSC6)->C6_TES				,;	// 2-Codigo do TES ( Opcional )
				(cAliasSC6)->C6_QTDVEN			,;	// 3-Quantidade ( Obrigatorio )
				nPrcLista						,;	// 4-Preco Unitario ( Obrigatorio )
				nDesconto						,;	// 5-Valor do Desconto ( Opcional )
				cNfOri							,;	// 6-Numero da NF Original ( Devolucao/Benef )
				cSeriOri						,;	// 7-Serie da NF Original ( Devolucao/Benef )
				nRecnoSD1						,;	// 8-RecNo da NF Original no arq SD1/SD2
				0								,;	// 9-Valor do Frete do Item ( Opcional )
				0								,;	// 10-Valor da Despesa do item ( Opcional )
				0								,;	// 11-Valor do Seguro do item ( Opcional )
				0								,;	// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc						,;	// 13-Valor da Mercadoria ( Obrigatorio )
				0								,;	// 14-Valor da Embalagem ( Opiconal )
				0								,;	// 15-RecNo do SB1
				0								)	// 16-RecNo do SF4



				aadd(aItemPed,	{	(cAliasSC6)->C6_ITEM	,;  //01
				(cAliasSC6)->C6_PRODUTO					,;  //02
				(cAliasSC6)->C6_DESCRI					,;  //03
				(cAliasSC6)->C6_TES						,;  //04
				(cAliasSC6)->C6_CF						,;  //05
				(cAliasSC6)->C6_UM						,;  //06
				(cAliasSC6)->C6_QTDVEN					,;  //07
				(cAliasSC6)->C6_PRCVEN					,;  //08
				(cAliasSC6)->C6_NOTA					,;  //09
				(cAliasSC6)->C6_SERIE					,;  //10
				(cAliasSC6)->C6_CLI						,;  //11
				(cAliasSC6)->C6_LOJA					,;  //12
				(cAliasSC6)->C6_VALOR					,;  //13
				(cAliasSC6)->C6_ENTREG					,;  //14
				(cAliasSC6)->C6_DESCONT					,;  //15
				(cAliasSC6)->C6_LOCAL					,;  //16
				(cAliasSC6)->C6_QTDEMP					,;  //17
				(cAliasSC6)->C6_QTDLIB					,;  //18
				(cAliasSC6)->C6_QTDENT					,;  //19
				POSICIONE("SB1",1,XFILIAL("SB1")+(cAliasSC6)->C6_PRODUTO,"B1_POSIPI"),;  //20
				(cAliasSC6)->C6_XPERDES					,;  //21
				(cAliasSC6)->C6_ZTABELA					,;  //22
				})

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Forca os valores de impostos que foram informados no SC6.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasSC6)
				For nY := 1 to Len(aFisGet)
					If !Empty(&(aFisGet[ny][2]))
						MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
					EndIf
				Next nY

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calculo do ISS                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SF4->(dbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")+(cAliasSC6)->C6_TES))
				If ( (cAliasSC5)->C5_INCISS == "N" .And. (cAliasSC5)->C5_TIPO == "N")
					If ( SF4->F4_ISS=="S" )
						nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
						nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
						MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
						MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Altera peso para calcular frete              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO))
				MaFisAlt("IT_PESO",(cAliasSC6)->C6_QTDVEN*SB1->B1_PESO,Len(aItemPed))
				MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
				MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))

				If !lQuery
					dbSelectArea(cAliasSC6)
				EndIf

				(cAliasSC6)->(dbSkip())
			EndDo
			MaFisAlt("NF_FRETE"   ,nFrete)
			MaFisAlt("NF_SEGURO"  ,nSeguro)
			MaFisAlt("NF_AUTONOMO",nFretAut)
			MaFisAlt("NF_DESPESA" ,nDespesa)

			If nDescCab > 0
				MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nDescCab+MaFisRet(,"NF_DESCONTO")))
			EndIf
			If nPDesCab > 0
				MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*nPDesCab/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
			EndIf

			ImpCabecR4(aPedCli,oReport,aCabPed)

			oReport:Section(1):Init()
			nItem := 0
			For nG := 1 To Len(aItemPed)
				nItem += 1
				If oReport:Row() > 1500
					oReport:Section(1):Finish()
					ImpRodapR4(nPesLiq,nPesBru,aC5Rodape,aCabPed,.F.,oReport)
					oReport:EndPage(.T.)
					oReport:Section(1):Init()
					ImpCabecR4(aPedCli,oReport,aCabPed)
				Endif
				ImpItemR4(nItem,@nPesLiq,@nPesBru,oReport,oPreNota,aCabPed,aItemPed)
			Next
			oReport:Section(1):Finish()
			ImpRodapR4(nPesLiq,nPesBru,aC5Rodape,aCabPed,.T.,oReport)
			oReport:EndPage(.T.)		// Finaliza pagina de impressao (zeras as linhas e colunas)

			MaFisEnd()

			If !lQuery
				dbSelectArea(cAliasSC5)
				dbSkip()
			Endif
			oReport:IncMeter()

		EndDo


		Return


/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ImpCabecR4³ Autor ³ Marco Bianchi         ³ Data ³ 11/07/06 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ MBRFAT01                                                   ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabecR4(aPedCli,oReport,aCabPed)

	Local nPed		:= 0
	Local i         := 0
	Local cMoeda	:= ""
	Local cPedCli   := ""
	Local cPictCgc  := ""
	Local oBox
	Local nPrinLin  := 0
	Local nInicio   := 60
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  array acabped                                              ³
//³  -------------                                              ³
//³  01 C5_TIPO           10 C5_VEND3     	19 C5_TPFRETE       ³
//³  02 C5_CLIENTE        11 C5_VEND4     	20 C5_SEGURO        ³
//³  03 C5_LOJACLI        12 C5_VEND5     	21 C5_TABELA        ³
//³  04 C5_TRANSP         13 C5_COMIS1    	22 C5_VOLUME1       ³
//³  05 C5_CONDPAG        14 C5_COMIS2    	23 C5_ESPECI1       ³
//³  06 C5_EMISSAO        15 C5_COMIS3    	24 C5_MOEDA         ³
//³  07 C5_NUM            16 C5_COMIS4    	25 C5_REAJUST       ³
//³  08 C5_VEND1          17 C5_COMIS5    	26 C5_BANCO         ³
//³  09 C5_VEND2          18 C5_FRETE     	27 C5_ACRSFIN       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !(aCabPed[1]$"DB")   //C5_TIPO
		dbSelectArea("SA1")
		dbSeek(xFilial("SA1")+aCabped[2]+aCabped[3])  //C5_CLIENTE + C5_LOJACLI
		cPictCgc := PesqPict("SA1","A1_CGC")
	Else
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+aCabPed[2]+aCabPed[3])  // C5_CLIENTE + C5_LOJACLI
		cPictCgc := PesqPict("SA2","A2_CGC")
	Endif

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+aCabPed[4])	   				// C5_TRANSP
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+aCabPed[5])	  				// C5_CONDPAG
	aSort(aPedCli)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa impressao do cabecalho                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:HideHeader()			// Nao imprime cabecalho padrao do Protheus
	oReport:SkipLine()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha as caixas do cabecalho                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Box(nInicio,10,240,750,oBox)
	oReport:Box(nInicio,750,240,1800,oBox)
	oReport:Box(nInicio,1800,240,3000,oBox)

	IF !(aCabPed[1]$"DB")		//C5_TIPO
		nPrinLin := nInicio
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Informacoes do Quadro 1: Dados da Empresa                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:PrintText("",nPrinLin,10)
		oReport:PrintText(SM0->M0_NOME,nPrinLin,20)
		nPrinLin += 30
		oReport:PrintText(SM0->M0_ENDCOB,nPrinLin,20)
		nPrinLin += 30
		oReport:PrintText("TEL: "+SM0->M0_TEL,nPrinLin,20)	// "TEL: "
		nPrinLin += 30
		oReport:PrintText(Iif(cPaisLoc=="BRA","CGC: ",Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")+;	// "CGC: "
		Transform(SM0->M0_CGC,cPictCgc)+ " " +Subs(SM0->M0_CIDCOB,1,15),nPrinLin,20)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Informacoes do Quadro 2: Dados do Cliente                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPrinLin := nInicio
		oReport:PrintText(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME,nPrinLin,760)
		nPrinLin += 30
		//oReport:PrintText(IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT # SA1->A1_END,SA1->A1_ENDENT, SA1->A1_END ),nPrinLin,760)
		oReport:PrintText(AllTrim(SA1->A1_END),nPrinLin,760)
		oReport:PrintText("TELEFONE: "+SA1->A1_DDD+" - "+SA1->A1_TEL,nPrinLin,1300)  // Inclusão do Telefone nos dados do Cliente
		nPrinLin += 30
	/*oReport:PrintText(IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE # SA1->A1_CEP,SA1->A1_CEPE, SA1->A1_CEP )+" "+;
		IF( !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE # SA1->A1_MUN,AllTrim(SA1->A1_MUNE), AllTrim(SA1->A1_MUN) )+" - "+;
				IF( !Empty(SA1->A1_ESTE) .And. SA1->A1_ESTE # SA1->A1_EST,SA1->A1_ESTE, SA1->A1_EST ),nPrinLin,760)*/
	oReport:PrintText(AllTrim(SA1->A1_CEP)+" "+AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST,nPrinLin,760)
	nPrinLin += 30 
	oReport:PrintText("BAIRRO: "+SA1->A1_BAIRRO,nPrinLin,760)
	nPrinLin += 30   
	oReport:PrintText("E-MAIL: "+SA1->A1_EMAIL,nPrinLin,760) 
	nPrinLin += 30
	
	oReport:PrintText(subs(transform(SA1->A1_CGC,PicPesFJ(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1),nPrinLin,760)
				If cPaisLoc == "BRA"
		oReport:PrintText("IE: "+SA1->A1_INSCR,nPrinLin,1050)		// "IE: "
				EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacoes do Quadro 3: Dados do Pedido                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	nPrinLin := nInicio
	oReport:PrintText("Confirmação do Pedido ",nPrinLin,1810)												// "CONFIRMACAO DO PEDIDO"
	nPrinLin += 30
	oReport:PrintText("DATA ENTREGA: "+DtoC(aCabPed[31]),nPrinLin,1810)					// "DATA DE ENTREGA: "  GUILHERME (23/07/10)
	nPrinLin += 30
	oReport:PrintText("Emissão: "+DTOC(aCabPed[6]),nPrinLin,1810)								// "EMISSAO: "
	nPrinLin += 30
	oReport:PrintText("Pedido N.: "+aCabPed[7],nPrinLin,1810)									// "PEDIDO N. "	
	If !Empty(SC5->C5_XPEDEMP) .And. FunName() == 'MATA410'
		nPrinLin += 30
		oReport:PrintText("Pedido Guarani: "+SC5->C5_XPEDEMP,nPrinLin,1810)									// "PEDIDO N. "	
	EndIF
	SC5->(dbSetOrder(1))
				If SC5->(dbSeek(xFilial("SC5")+aCabPed[7]))
					If !Empty(SC5->C5_NOTA)
			nPrinLin += 30
			oReport:PrintText("DATA FAT.: "+DTOC(Posicione("SF2",1,xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE,"F2_EMISSAO")),nPrinLin,1810)				// "DATA FAT.: "
					EndIf
				EndIf
	nPrinLin := nInicio
	oReport:PrintText("DADOS DA ENTREGA",nPrinLin,2500)         							// Dados da Entrega
	nPrinLin +=30
	oReport:PrintText("TELEFONE: "+AllTrim(SA1->A1_ZZDDD3)+" "+AllTrim(SA1->A1_ZZTEL3)+;
						" NEXTEL: "+AllTrim(SA1->A1_ZZIDNX2),nPrinLin,2500)				// Telefone - Nextel
	nPrinLin +=30
				If Empty(SA1->A1_ENDENT)
		oReport:PrintText("END.: O MESMO",nPrinLin,2500)									// Endereco de Entrega
				Else
		oReport:PrintText("END.: "+AllTrim(SA1->A1_ENDENT),nPrinLin,2500)
		nPrinLin +=30
		oReport:PrintText("CEP.: "+AllTrim(SA1->A1_CEPE)+" - BAIRRO: "+AllTrim(SA1->A1_BAIRROE),nPrinLin,2500)
		nPrinLin +=30
		oReport:PrintText("CIDADE: "+AllTrim(SA1->A1_MUNE)+" - "+SA1->A1_ESTE,nPrinLin,2500)
				EndIf
			Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacoes do Quadro 1: Dados da Empresa                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nPrinLin := nInicio
   
	oReport:PrintText(SM0->M0_NOME,nPrinLin,20)
	nPrinLin += 30
	oReport:PrintText(SM0->M0_ENDCOB,nPrinLin,20)
	nPrinLin += 30
	oReport:PrintText("TEL: "+SM0->M0_TEL,nPrinLin,20)																// "TEL: "
	nPrinLin += 30
	oReport:PrintText(Iif(cPaisLoc=="BRA","CGC: ",Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")+;	// "CGC: "
						Transform(SM0->M0_CGC,cPictCgc)+ " " +Subs(SM0->M0_CIDCOB,1,15),nPrinLin,20)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacoes do Quadro 2: Dados do Cliente                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrinLin := nInicio
	oReport:PrintText(SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME,nPrinLin,760)	
	nPrinLin += 30
	oReport:PrintText(SA2->A2_END,nPrinLin,760)
	nPrinLin += 30
	oReport:PrintText(SA2->A2_CEP + " " + SA2->A2_MUN + " " + SA2->A2_EST,nPrinLin,760)
	nPrinLin += 30
	oReport:PrintText(subs(transform(SA2->A2_CGC,PicPesFJ(RetPessoa(SA2->A2_CGC))),1,at("%",transform(SA2->A2_CGC,PicPes(RetPessoa(SA2->A2_CGC))))-1),nPrinLin,760)
	nPrinLin += 30
				If cPaisLoc == "BRA"
		oReport:PrintText("IE: "+SA2->A2_INSCR,nPrinLin,1050)		// "IE: "
				Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacoes do Quadro 3: Dados do Pedido                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrinLin := nInicio
	oReport:PrintText("Confirmação do Pedido: ",nPrinLin,1810)							// "CONFIRMACAO DO PEDIDO"
	nPrinLin += 60
	oReport:PrintText("Emissão: "+DTOC(aCabPed[6]),nPrinLin,1810)		// "EMISSAO: "
	nPrinLin += 30
	oReport:PrintText("Pedido N.: "+aCabPed[7],nPrinLin,1810)			// "PEDIDO N. "

			Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pedidos do Cliente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SkipLine(6)
			If Len(aPedCli) > 0
	oReport:PrintText("PEDIDO(S) DO CLIENTE: ",oReport:Row(),20)
	cPedCli:=""
				For nPed := 1 To Len(aPedCli)
		cPedCli += aPedCli[nPed]+Space(02)
					If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
			oReport:PrintText(cPedCli,oReport:Row(),350)                   
			cPedCli:=""
 		   oReport:SkipLine(2)
					Endif
				Next
	oReport:Line(oReport:Row(),10,oReport:Row()+5,3000)
			Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transportadora de Redespacho - Especifico MB                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SkipLine()
SA4->(dbSetOrder(1))
			If SA4->(dbseek(xFilial("SA4")+aCabPed[28]))
				If Empty(SA4->A4_ZZEND)
	oReport:PrintText("REDESPACHO: "	+ AllTrim(SA4->A4_NOME);
										+ "End.: "+Alltrim(SA4->A4_END)+" - "+Alltrim(SA4->A4_BAIRRO)+" - "+Alltrim(SA4->A4_MUN);
										+ " - "+AllTrim(SA4->A4_EST);
										+ "Fone: "+AllTrim(SA4->A4_DDD)+"-"+AllTrim(SA4->A4_TEL)+"- NexTel: "+AllTrim(SA4->A4_ZZIDNEX),;
										oReport:Row(),20)
				Else
	oReport:PrintText("REDESPACHO: "	+ AllTrim(SA4->A4_NOME);
										+ "End.: "+Alltrim(SA4->A4_ZZEND)+" - "+Alltrim(SA4->A4_ZZBAI)+" - "+Alltrim(SA4->A4_ZZMUN);
										+ " - "+AllTrim(SA4->A4_ZZEST);
										+ "Fone: "+AllTrim(SA4->A4_DDD)+"-"+AllTrim(SA4->A4_TEL)+"- NexTel: "+AllTrim(SA4->A4_ZZIDNEX),;
										oReport:Row(),20)
				EndIf
			EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vendedores                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SkipLine()
			For i := 8 to 8
	dbSelectArea("SA3")
	dbSetOrder(1)
				If dbSeek(xFilial("SA3")+aCabPed[i])														// C5_VENDi
					If i == 8
			oReport:PrintText("VEndedor: ",oReport:Row(),20)										// "VENDEDOR.: "
					EndIf
		oReport:PrintText(aCabPed[i] + " - "+SA3->A3_NOME + "COMISSAO: "+AllTrim(STR(aCabPed[13])),oReport:Row(),300)
		oReport:SkipLine()
				EndIf
			Next
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Condicao de Pagto, Frete e Seguro                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:PrintText("Cond de pagto: "+aCabPed[5]+" - "+SE4->E4_DESCRI,oReport:Row(),20)			// "COND.PGTO: "		//C5_CONDPAG
oReport:PrintText(Alltrim("Frete: "),oReport:Row(),1000)									// "FRETE...: "
oReport:PrintText(Transform(aCabPed[18],"@EZ 999,999,999.99"),oReport:Row(),1050)		// C5_FRETE
oReport:PrintText(IIF(aCabPed[30]=="1","CIF-RED",IIF(aCabPed[30]=="2","CIF-CLIENTE",IIF(aCabPed[30]=="3","FOB-RED",IIF(aCabPed[30]=="4","FOB-RETIRA","FRETE ERRADO")))),oReport:Row(),1300)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca perfil do cliente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If !(aCabPed[1]$"DB")   //C5_TIPO
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+aCabped[2]+aCabped[3])  //C5_CLIENTE + C5_LOJACLI
// ORIGINAL 	oReport:PrintText("PERFIL:"+IIF(SA1->A1_ZZPERFI=='A',"Atacadista","Varejista"),oReport:Row(),2000)	// PERFIL - ATACADO OU VAREJO
	dbSelectArea("PAC")
	dbSetOrder(1)
				if PAC->( dbSeek( xFilial("PAC")+'28'+SA1->A1_ZZPERFI ) )
					oReport:PrintText("PERFIL: "+RTRIM(PAC->PAC_TXT01),oReport:Row(),2000)	// PERFIL - ATACADO OU VAREJO
				else
					oReport:PrintText("PERFIL:  SEM CADASTRO",oReport:Row(),2000)	// PERFIL - ATACADO OU VAREJO

				EndIf
			EndIf

oReport:PrintText("Desc. Médio: " + AllTrim(Transform(aCabPed[35],"@E 999,999,999.99")),oReport:Row(),2400)	// C5_TPFRETE

oReport:SkipLine()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabela, Volume e Especie                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:PrintText("TABELA...: "+aCabPed[21],oReport:Row(),20)								// "TABELA...: "	// C5_TABELA
oReport:SkipLine()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reajuste, Moeda, Banco e Acrescimo Financeiro               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMoeda:=Strzero(aCabPed[24],1,0)																// C5_MOEDA
oReport:PrintText("REAJUSTE.: "+aCabPed[25]+"   Moeda : " +IIF(cMoeda < "2","1",cMoeda),oReport:Row(),20)	// "REAJUSTE.: "###"   Moeda : " 	//C5_REAJUST
oReport:PrintText("BANCO: " + aCabPed[26]+" "+Posicione("SA6",1,xFilial("SA6")+aCabPed[26],"A6_NOME"),oReport:Row(),1000)		// "BANCO: "		//C5_BANCO
oReport:PrintText("ACRES.FIN.: " + Str(aCabPed[27],6,2),oReport:Row(),2000)							// "ACRES.FIN.: "	//C5_ACRSFIN
oReport:PrintText("PTS_: " + AllTrim(STR(aCabPed[34]/*SC5->C5_ZZPLLM*/)),oReport:Row(),2500)  // "PTS: "
oReport:SkipLine()
oReport:Line(oReport:Row(),10,oReport:Row()+5,3000)

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItemR4³ Autor ³ Marco Bianchi         ³ Data ³ 11/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MBRFAT01                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpItemR4(nItem,nPesLiq,nPesBru,oReport,oPreNota,aCabPed,aItemPed)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  array aitemped                                             ³
//³  --------------                                             ³
//³  01 c6_item           08 c6_prcven         15 c6_descont    ³
//³  02 c6_produto        09 c6_nota           16 c6_local      ³
//³  03 c6_descri         10 c6_serie          17 c6_qtdemp     ³
//³  04 c6_tes            11 c6_cli            18 c6_qtdlib     ³
//³  05 c6_cf             12 c6_loja           19 c6_qtdent     ³
//³  06 c6_um             13 c6_valor                           ³
//³  07 c6_qtdven         14 c6_entreg                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cChaveD2	:= ""
Local nDecs	    := MsDecimais(Max(1,aCabPed[24]))  //C5_MOEDA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser                   ³
//³ utilizadas em outras funcoes nao precisando declara-las                ³
//³ como private.                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc <> "BRA"
	oReport:Section(1):Cell("NVALIMP"):SetBlock({|| nValImp})
	Else
	oReport:Section(1):Cell("AITEM13"):SetBlock({|| aItemPed[nItem][13]+nValImp})
	EndIf
oReport:Section(1):Cell("NULTLIB"):SetBlock({|| nUltLib})
nValImp := 0
nUltLib := 0
	If cPaisLoc == "BRA"
		If aCabPed[1] == "P"
		nValImp := 0
		Else
		nValImp	:=	MaFisRet(nItem,"IT_VALIPI")
		Endif
	Else
	nValImp	:=	MaRetIncIV(nItem,"2")
	Endif

dbSelectArea("SB1")
dbSeek(xFilial("SB1")+aItemPed[nItem][2])  //C6_PRODUTO

//c6_nota c6_serie c6_cli c6_loja c6_produto
cChaveD2 := xFilial("SD2")+aItemPed[nItem][09]+aItemPed[nItem][10]+aItemPed[nItem][11]+aItemPed[nItem][12]+aItemPed[nItem][02]
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(cChaveD2)
	While !Eof() .and. cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
	nUltLib := D2_QUANT
	dbSkip()
	EndDo

oReport:Section(1):PrintLine()

nPesLiq	+= SB1->B1_PESO * aItemPed[nItem][07]		//C6_QTDVEN
nPesBru += SB1->B1_PESBRU * aItemPed[nItem][07]	//C6_QTDVEN

Return (Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpRodapR4³ Autor ³ Marco Bianchi         ³ Data ³ 11/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MBRFAT01                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodapR4(nPesLiq,nPesBru,aC5Rodape,aCabPed,lFinal,oReport)

Local I     := 0
DEFAULT lFinal := .F.

	If lFinal

	oReport:SkipLine()
	oReport:Line(oReport:Row(),10,oReport:Row(),3000)

		If cPaisLoc == 'BRA'
		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
		Else
		aCodImps	:=	{}
		aCodImps := MaFisRet(,"NF_IMPOSTOS") //Descricao / /Aliquota / Valor / Base
		oReport:Section(2):Init()
			For I:=1 To Len(aCodImps)// Vetor com os impostos
			nI := I
			oReport:Section(2):PrintLine()
			Next
		oReport:Section(2):Finish()
		EndIf
	EndIf

oReport:SkipLine()
oReport:PrintText("PESO BRUTO ------>"+STR(If(aC5Rodape[1][1] > 0,aC5Rodape[1][1],nPesBru))+" Kg",1880,30)					// "PESO BRUTO ------>"
oReport:PrintText("PESO LIQUIDO ---->"+STR(If(aC5Rodape[1][2] > 0,aC5Rodape[1][2],nPesLiq))+" Kg",1910,30)					// "PESO LIQUIDO ---->"
//Usuario que incluiu o pedido
dbSelectArea("SC5")
dbSetOrder(1)
SC5->( dbSeek( xFilial("SC5")+aCabPed[7] ) )
oReport:PrintText('DIGITADOR: '+FWLeUserlg("C5_USERLGI",1);
                   +" - "+DtoC(aCabPed[6])+" - Status:"+IIF(Empty(SC5->C5_ZZCDBLQ),"00 - "+Posicione("SX5",1,XFILIAL("SX5")+"ZX"+"00","X5_DESCRI"),SC5->C5_ZZCDBLQ+" - "+Posicione("SX5",1,XFILIAL("SX5")+"ZX"+SC5->C5_ZZCDBLQ,"X5_DESCRI")),1910,2000)															// "DIGITADOR DO PEDIDO ---->"
//Private cX5Descri:=DescTab(cTabela) //Posicione("SX5",1,XFILIAL("SX5")+"ZX"+SC5->C5_ZZCDBLQ,"X5_DESCRI")
oReport:PrintText("VOLUMES --------->"+STR(If(aC5Rodape[1][8] > 0,aC5Rodape[1][8],0))+" Vl",1940,30)						// "VOLUMES --------->"
oReport:PrintText("CUBAGEM --------->"+STR(If(aC5Rodape[1][9] > 0,aC5Rodape[1][9],0))+" M³",1970,30)			// "CUBAGEM --------->"

oReport:PrintText("DESCONTOS: ",2090,30)																				// "DESCONTOS: "
oReport:PrintText(Transform(aC5Rodape[1][3],"99.99"),2090,200)
oReport:PrintText(Transform(aC5Rodape[1][4],"99.99"),2090,300)
oReport:PrintText(Transform(aC5Rodape[1][5],"99.99"),2090,400)
oReport:PrintText(Transform(aC5Rodape[1][6],"99.99"),2090,500)
	If !(aCabPed[1]$"DB")   //C5_TIPO
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+aCabped[2]+aCabped[3])  //C5_CLIENTE + C5_LOJACLI
	EndIf
oReport:PrintText("MENSAGEM PARA NOTA FISCAL: "+AllTrim(aC5Rodape[1][7]);
				  + " - "+AllTrim(SA1->A1_ZZOBS);
				  + " - "+AllTrim(aCabPed[32]);
				  + " - "+AllTrim(aCabPed[33]);
				  ,2150,30)													// "MENSAGEM PARA NOTA FISCAL: "
Return(NIL)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ C730Imp  ³ Autor ³ Eduardo J. Zanardo    ³ Data ³26.12.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C730Imp(lEnd,wnrel,cString,nomeprog,Titulo)

Local aPedCli    := {}
Local aStruSC5   := {}
Local aStruSC6   := {}
Local aC5Rodape  := {}
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})
Local aFisGet    := Nil
Local aFisGetSC5 := Nil

Local li         := 100 // Contador de Linhas
Local lImp       := .F. // Indica se algo foi impresso
Local lRodape    := .F.

Local cbCont     := 0   // Numero de Registros Processados
Local cbText     := ""  // Mensagem do Rodape
Local cKey 	     := ""
Local cFilter    := ""
Local cAliasSC5  := "SC5"
Local cAliasSC6  := "SC6"
Local cIndex     := CriaTrab(nil,.f.)
Local cQuery     := ""
Local cQryAd     := ""
Local cName      := ""
Local cPedido    := ""
Local cCliEnt	 := ""
Local cNfOri     := Nil
Local cSeriOri   := Nil

Local nItem      := 0
Local nTotQtd    := 0
Local nTotVal    := 0
Local nDesconto  := 0
Local nPesLiq    := 0
Local nSC5       := 0
Local nSC6       := 0
Local nX         := 0
Local nRecnoSD1  := Nil
Local nG		 := 0
Local nFrete	 := 0
Local nSeguro	 := 0
Local nFretAut	 := 0
Local nDespesa	 := 0
Local nDescCab	 := 0
Local nPDesCab	 := 0
Local nY         := 0
Local nValMerc   := 0
Local nPrcLista  := 0
Local nAcresFin  := 0

Private aItemPed := {}
Private aCabPed	 := {}

FisGetInit(@aFisGet,@aFisGetSC5)

	#IFDEF TOP
		If TcSrvType() <> "AS/400"
		cAliasSC5:= "C730Imp"
		cAliasSC6:= "C730Imp"
		lQuery    := .T.
		aStruSC5  := SC5->(dbStruct())		
		aStruSC6  := SC6->(dbStruct())		
		cQuery := "SELECT SC5.R_E_C_N_O_ SC5REC,SC6.R_E_C_N_O_ SC6REC,"
		cQuery += "SC5.C5_FILIAL,SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPO,"
		cQuery += "SC5.C5_TIPOCLI,SC5.C5_TRANSP,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_DESC1,"
		cQuery += "SC5.C5_DESC2,SC5.C5_DESC3,SC5.C5_DESC4,SC5.C5_MENNOTA,SC5.C5_EMISSAO,"
		cQuery += "SC5.C5_CONDPAG,SC5.C5_FRETE,SC5.C5_DESPESA,SC5.C5_FRETAUT,SC5.C5_TPFRETE,SC5.C5_SEGURO,SC5.C5_TABELA,"
		cQuery += "SC5.C5_VOLUME1,SC5.C5_ESPECI1,SC5.C5_MOEDA,SC5.C5_REAJUST,SC5.C5_BANCO,"
		cQuery += "SC5.C5_ACRSFIN,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_VEND3,SC5.C5_VEND4,SC5.C5_VEND5,"
		cQuery += "SC5.C5_COMIS1,SC5.C5_COMIS2,SC5.C5_COMIS3,SC5.C5_COMIS4,SC5.C5_COMIS5,SC5.C5_PDESCAB,SC5.C5_DESCONT,C5_INCISS,"
			If SC5->(FieldPos("C5_CLIENT"))>0
			cQuery += "SC5.C5_CLIENT,"			
			Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esta rotina foi escrita para adicionar no select os campos         ³
		//³usados no filtro do usuario quando houver, a rotina acrecenta      ³
		//³somente os campos que forem adicionados ao filtro testando         ³
		//³se os mesmo já existem no select ou se forem definidos novamente   ³
		//³pelo o usuario no filtro                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			If !Empty(aReturn[7])
				For nX := 1 To SC5->(FCount())
				cName := SC5->(FieldName(nX))
					If AllTrim( cName ) $ aReturn[7]
						If aStruSC5[nX,2] <> "M"
							If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += cName +","
							Endif
						EndIf
					EndIf
				Next nX
			Endif
			For nY := 1 To Len(aFisGet)
			cQryAd += aFisGet[nY][2]+","
			Next nY
			For nY := 1 To Len(aFisGetSC5)
			cQryAd += aFisGetSC5[nY][2]+","
			Next nY
		cQuery += cQryAd
		cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_PEDCLI,SC6.C6_PRODUTO,"
		cQuery += "SC6.C6_TES,SC6.C6_CF,SC6.C6_QTDVEN,SC6.C6_PRUNIT,SC6.C6_VALDESC,"
		cQuery += "SC6.C6_VALOR,SC6.C6_ITEM,SC6.C6_DESCRI,SC6.C6_UM, "
		cQuery += "SC6.C6_PRCVEN,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_CLI,"
		cQuery += "SC6.C6_LOJA,SC6.C6_ENTREG,SC6.C6_DESCONT,SC6.C6_LOCAL,"
		cQuery += "SC6.C6_QTDEMP,SC6.C6_QTDLIB,SC6.C6_QTDENT,SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI "
		cQuery += "FROM "
		cQuery += RetSqlName("SC5") + " SC5 ,"
		cQuery += RetSqlName("SC6") + " SC6 "		
		cQuery += "WHERE "
		cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "		
		cQuery += "SC5.C5_NUM >= '"+mv_par01+"' AND "
		cQuery += "SC5.C5_NUM <= '"+mv_par02+"' AND "
		cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "		
		cQuery += "SC6.C6_NUM   = SC5.C5_NUM AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SC5.C5_NUM"

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC5,.T.,.T.)

			For nSC5 := 1 To Len(aStruSC5)
				If aStruSC5[nSC5][2] <> "C" .and.  FieldPos(aStruSC5[nSC5][1]) > 0
				TcSetField(cAliasSC5,aStruSC5[nSC5][1],aStruSC5[nSC5][2],aStruSC5[nSC5][3],aStruSC5[nSC5][4])
				EndIf
			Next nSC5
			For nSC6 := 1 To Len(aStruSC6)
				If aStruSC6[nSC6][2] <> "C" .and. FieldPos(aStruSC6[nSC6][1]) > 0
				TcSetField(cAliasSC6,aStruSC6[nSC6][1],aStruSC6[nSC6][2],aStruSC6[nSC6][3],aStruSC6[nSC6][4])
				EndIf
			Next nSC6
		Else
		#ENDIF
	cAliasSC5 := cString
	dbSelectArea(cAliasSC5)
	cKey := IndexKey()	
	cFilter := dbFilter()
	cFilter += If( Empty( cFilter ),""," .And. " )
	cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. (C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'")'
	IndRegua(cAliasSC5,cIndex,cKey,,cFilter,"Selecionando Registros...")		//"Selecionando Registros..."
		#IFNDEF TOP
		DbSetIndex(cIndex+OrdBagExt())
		#ENDIF
	SetRegua(RecCount())		// Total de Elementos da regua
	DbGoTop()
		#IFDEF TOP
		Endif
	#ENDIF

	While !((cAliasSC5)->(Eof())) .and. xFilial("SC5")==(cAliasSC5)->C5_FILIAL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a validacao dos filtros do usuario           	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasSC5)
	lFiltro := IIf((!Empty(aReturn[7]).And.!&(aReturn[7])),.F.,.T.)

		If lFiltro

		cCliEnt   := IIf(!Empty((cAliasSC5)->(FieldGet(FieldPos("C5_CLIENT")))),(cAliasSC5)->C5_CLIENT,(cAliasSC5)->C5_CLIENTE)

		aCabPed := {}

		MaFisIni(cCliEnt,;							// 1-Codigo Cliente/Fornecedor
			(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
			If((cAliasSC5)->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			(cAliasSC5)->C5_TIPO,;				// 4-Tipo da NF
			(cAliasSC5)->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
			aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
			,;						   			// 7-Tipo de complemento
			,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")							// 10-Nome da rotina que esta utilizando a funcao
		//Na argentina o calculo de impostos depende da serie.
				If cPaisLoc == 'ARG'
			SA1->(DbSetOrder(1))
			SA1->(MsSeek(xFilial()+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI))
			MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
				Endif

		nFrete		:= (cAliasSC5)->C5_FRETE
		nSeguro		:= (cAliasSC5)->C5_SEGURO
		nFretAut	:= (cAliasSC5)->C5_FRETAUT
		nDespesa	:= (cAliasSC5)->C5_DESPESA
		nDescCab	:= (cAliasSC5)->C5_DESCONT
		nPDesCab	:= (cAliasSC5)->C5_PDESCAB

		aItemPed:= {}
		aCabPed := {	(cAliasSC5)->C5_TIPO,;
			(cAliasSC5)->C5_CLIENTE,;
			(cAliasSC5)->C5_LOJACLI,;
			(cAliasSC5)->C5_TRANSP,;
			(cAliasSC5)->C5_CONDPAG,;
			(cAliasSC5)->C5_EMISSAO,;
			(cAliasSC5)->C5_NUM,;
			(cAliasSC5)->C5_VEND1,;
			(cAliasSC5)->C5_VEND2,;
			(cAliasSC5)->C5_VEND3,;
			(cAliasSC5)->C5_VEND4,;
			(cAliasSC5)->C5_VEND5,;
			(cAliasSC5)->C5_COMIS1,;
			/*(cAliasSC5)->C5_COMIS2*/,;
			/*(cAliasSC5)->C5_COMIS3*/,;
			/*(cAliasSC5)->C5_COMIS4*/,;
			/*(cAliasSC5)->C5_COMIS5*/,;
			(cAliasSC5)->C5_FRETE,;
			(cAliasSC5)->C5_TPFRETE,;
			(cAliasSC5)->C5_SEGURO,;
			(cAliasSC5)->C5_TABELA,;
			(cAliasSC5)->C5_VOLUME1,;
			(cAliasSC5)->C5_ESPECI1,;
			(cAliasSC5)->C5_MOEDA,;
			(cAliasSC5)->C5_REAJUST,;
			(cAliasSC5)->C5_BANCO,;
			(cAliasSC5)->C5_ACRSFIN;
			}
		nTotQtd:=0
		nTotVal:=0
		nPesBru:=0
		nPesLiq:=0
		aPedCli:= {}
				If !lQuery
			dbSelectArea(cAliasSC6)
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+(cAliasSC5)->C5_NUM)
				EndIf
		cPedido    := (cAliasSC5)->C5_NUM
		aC5Rodape  := {}
		aadd(aC5Rodape,{(cAliasSC5)->C5_PBRUTO,(cAliasSC5)->C5_PESOL,(cAliasSC5)->C5_DESC1,(cAliasSC5)->C5_DESC2,;
			(cAliasSC5)->C5_DESC3,(cAliasSC5)->C5_DESC4,(cAliasSC5)->C5_MENNOTA})

		aPedCli := Mtr730Cli(cPedido)


		dbSelectArea(cAliasSC5)
				For nY := 1 to Len(aFisGetSC5)
					If !Empty(&(aFisGetSC5[ny][2]))
						If aFisGetSC5[ny][1] == "NF_SUFRAMA"
					MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)		
						Else
					MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
						Endif
					EndIf
				Next nY


				While !((cAliasSC6)->(Eof())) .And. xFilial("SC6")==(cAliasSC6)->C6_FILIAL .And.;
				(cAliasSC6)->C6_NUM == cPedido

			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0

						If !Empty((cAliasSC6)->C6_NFORI)
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+;
					(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI)
				cNfOri     := (cAliasSC6)->C6_NFORI
				cSeriOri   := (cAliasSC6)->C6_SERIORI
				nRecnoSD1  := SD1->(RECNO())
					EndIf

			dbSelectArea(cAliasSC6)

					If lEnd
				@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR" //"CANCELADO PELO OPERADOR"
				Exit
					EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o preco de lista                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValMerc  := (cAliasSC6)->C6_VALOR
			nPrcLista := (cAliasSC6)->C6_PRUNIT
					If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/(cAliasSC6)->C6_QTDVEN,TamSX3("C6_PRCVEN")[2])
					EndIf
			nAcresFin := A410Arred((cAliasSC6)->C6_PRCVEN*(cAliasSC5)->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred((cAliasSC6)->C6_QTDVEN*nAcresFin,"D2_TOTAL")		
			nDesconto := a410Arred(nPrcLista*(cAliasSC6)->C6_QTDVEN,"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,(cAliasSC6)->C6_VALDESC,nDesconto)
			nDesconto := Max(0,nDesconto)
			nPrcLista += nAcresFin
					If cPaisLoc=="BRA"
				nValMerc  += nDesconto
					EndIf
						
			MaFisAdd((cAliasSC6)->C6_PRODUTO,; 	  // 1-Codigo do Produto ( Obrigatorio )
				(cAliasSC6)->C6_TES,;			  // 2-Codigo do TES ( Opcional )
				(cAliasSC6)->C6_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  // 4-Preco Unitario ( Obrigatorio )
				nDesconto,;       // 5-Valor do Desconto ( Opcional )
				cNfOri,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
				cSeriOri,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
				nRecnoSD1,;			          // 8-RecNo da NF Original no arq SD1/SD2
				0,;							  // 9-Valor do Frete do Item ( Opcional )
				0,;							  // 10-Valor da Despesa do item ( Opcional )
				0,;            				  // 11-Valor do Seguro do item ( Opcional )
				0,;							  // 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;// 13-Valor da Mercadoria ( Obrigatorio )
				0,;							  // 14-Valor da Embalagem ( Opiconal )
				0,;		     				  // 15-RecNo do SB1
				0) 							  // 16-RecNo do SF4

			aadd(aItemPed,	{	(cAliasSC6)->C6_ITEM,;
				(cAliasSC6)->C6_PRODUTO,;
				(cAliasSC6)->C6_DESCRI,;
				(cAliasSC6)->C6_TES,;
				(cAliasSC6)->C6_CF,;
				(cAliasSC6)->C6_UM,;
				(cAliasSC6)->C6_QTDVEN,;
				(cAliasSC6)->C6_PRCVEN,;
				(cAliasSC6)->C6_NOTA,;
				(cAliasSC6)->C6_SERIE,;
				(cAliasSC6)->C6_CLI,;
				(cAliasSC6)->C6_LOJA,;
				(cAliasSC6)->C6_VALOR,;
				(cAliasSC6)->C6_ENTREG,;
				(cAliasSC6)->C6_DESCONT,;
				(cAliasSC6)->C6_LOCAL,;
				(cAliasSC6)->C6_QTDEMP,;
				(cAliasSC6)->C6_QTDLIB,;
				(cAliasSC6)->C6_QTDENT,;
				})							
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Forca os valores de impostos que foram informados no SC6.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSC6)
					For nY := 1 to Len(aFisGet)
						If !Empty(&(aFisGet[ny][2]))
					MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
						EndIf
					Next nY

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calculo do ISS                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+(cAliasSC6)->C6_TES))
					If ( (cAliasSC5)->C5_INCISS == "N" .And. (cAliasSC5)->C5_TIPO == "N")
						If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
						EndIf
					EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Altera peso para calcular frete              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO))			
			MaFisAlt("IT_PESO",(cAliasSC6)->C6_QTDVEN*SB1->B1_PESO,Len(aItemPed))
			MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
			MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
			
					If !lQuery
				dbSelectArea(cAliasSC6)
					EndIf

			(cAliasSC6)->(dbSkip())
				EndDo
		
		MaFisAlt("NF_FRETE"   ,nFrete)
		MaFisAlt("NF_SEGURO"  ,nSeguro)
		MaFisAlt("NF_AUTONOMO",nFretAut)
		MaFisAlt("NF_DESPESA" ,nDespesa)

				If nDescCab > 0
			MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nDescCab+MaFisRet(,"NF_DESCONTO")))
				EndIf
				If nPDesCab > 0
			MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*nPDesCab/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
				EndIf

		nItem := 0
				For nG := 1 To Len(aItemPed)
			nItem += 1
					IF li > 45
						IF lRodape
					ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,,cAliasSC6)
						Endif
				li := 0
				lRodape := ImpCabec(@li,aPedCli,cAliasSC5)
					Endif
			ImpItem(nItem,@nPesLiq,@li,@nTotQtd,@nTotVal,@nPesBru,cAliasSC6,cAliasSC5)
			li++
				Next

				IF lRodape
			ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,.T.,cAliasSC6)
			lRodape:=.F.
				Endif

		MaFisEnd()

				If !lQuery
			IncRegua()
			dbSelectArea(cAliasSC5)
			dbSkip()
				Endif

			Else
		dbSelectArea(cAliasSC5)
		dbSkip()
			EndIf

		EndDo

		If lQuery
	dbSelectArea(cAliasSC5)
	dbCloseArea()
		Endif

Set Device To Screen
Set Printer To

RetIndex("SC5")
dbSelectArea("SC5")
dbClearFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
dbClearFilter()
dbSetOrder(1)
dbGotop()

		If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
		Endif
MS_FLUSH()
Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MBRFAT01                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpItem(nItem,nPesLiq,li,nTotQtd,nTotVal,nPesBru,cAliasSC6,cAliasSC5)
/*
01 c6_item
02 c6_produto
03 c6_descri
04 c6_tes
05 c6_cf
06 c6_um
07 c6_qtdven
08 c6_prcven
09 c6_nota
10 c6_serie
11 c6_cli
12 c6_loja
13 c6_valor
14 c6_entreg
15 c6_descont
16 c6_local
17 c6_qtdemp
18 c6_qtdlib
19 c6_qtdent
*/
	Local nUltLib  := 0
	Local cChaveD2 := ""
	Local nDecs	:=	MsDecimais(Max(1,aCabPed[24]))  //C5_MOEDA
	Local nValImp	:=0
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+aItemPed[nItem][2])  //C6_PRODUTO

	@li,000 psay aItemPed[nItem][01]	//C6_ITEM
	@li,003 psay aItemPed[nItem][02]	//C6_PRODUTO
	@li,019 psay SUBS(IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03]),1,30)		//C6_DESCRI
	@li,050 psay aItemPed[nItem][04]	//C6_TES
	@li,054 psay aItemPed[nItem][05]	//C6_CF
	@li,059 psay aItemPed[nItem][06]	//C6_UM
	@li,061 psay aItemPed[nItem][07] Picture PesqPictQt("C6_QTDVEN")	//C6_QTDVEN
	@li,076 psay aItemPed[nItem][08] Picture PesqPict("SC6","C6_PRCVEN",12)	//C6_PRCVEN
	If cPaisLoc == "BRA"
		If aCabPed[1] == "P"
			nValImp := 0
		Else
			nValImp	:=	MaFisRet(nItem,"IT_VALIPI")
		Endif
		@li,089 psay MaFisRet(nItem,"IT_ALIQIPI") Picture "@e 99.99"
	Else
		nValImp	:=	MaRetIncIV(nItem,"2")
		@li,089 psay  nValImp	Picture Tm(nValImp,10,nDecs)
	Endif


	If ( cPaisLoc=="BRA" )
		@li,095 psay MaFisRet(nItem,"IT_ALIQICM") Picture "@e 99.99" //Aliq de ICMS
		@li,101 psay MaFisRet(nItem,"IT_ALIQISS") Picture "@e 99.99" //Aliq de ISS
	EndIf
//c6_nota c6_serie c6_cli c6_loja c6_produto
	cChaveD2 := xFilial("SD2")+aItemPed[nItem][09]+aItemPed[nItem][10]+aItemPed[nItem][11]+aItemPed[nItem][12]+aItemPed[nItem][02]
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(cChaveD2)
	While !Eof() .and. cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
		nUltLib := D2_QUANT
		dbSkip()
	EndDo

	@li,106   psay aItemPed[nItem][13]+nValImp Picture PesqPict("SC6","C6_VALOR",16,nDecs)		//C6_VALOR
	@li,123   psay aItemPed[nItem][14]		//C6_ENTREG
	@li,133   psay aItemPed[nItem][15]    Picture "99.9"  //C6_DESCONT
	@li,139   psay aItemPed[nItem][16]		//C6_LOCAL
	@li,141   psay aItemPed[nItem][17] Picture PesqPictQt("C6_QTDLIB")		//C6_QTDEMP
//C6_QTDVEN C6_QTDEMP C6_QTDLIB C6_QTDENT
	@li,155   psay aItemPed[nItem][07] - aItemPed[nItem][17] + aItemPed[nItem][18] - aItemPed[nItem][19] Picture PesqPictQt("C6_QTDLIB")
	@li,169   psay nUltLib Picture PesqPictQt("D2_QUANT")

	nTotQtd += aItemPed[nItem][07]						//C6_QTDVEN
	nTotVal += aItemPed[nItem][13]+nValImp				//C6_VALOR
	nPesLiq	+= SB1->B1_PESO * aItemPed[nItem][07]		//C6_QTDVEN
	nPesBru += SB1->B1_PESBRU * aItemPed[nItem][07]	//C6_QTDVEN
Return (Nil)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MBRFAT01                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape(nPesLiq,nTotQtd,nTotVal,li,nPesBru,aC5Rodape,cAliasSC5,lFinal,cAliasSC6)
	Local aCodImps	:=	{}
	Local I     := 0

	DEFAULT lFinal := .F.

	@ li,000 psay Replicate("-",limite-37)
	li++
	@ li,000 psay "Totais: "	//" T O T A I S "
	@ li,061 psay nTotQtd    Picture PesqPict("SC6","C6_QTDVEN",20)
	@ li,105 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
	If lFinal
		li++
		@ li,000 psay Replicate("-",limite-37)
		If cPaisLoc == 'BRA'
			li++
			@ li,000 psay "Impostos: "
			@ li,026 PSay "Base ICMS"
			@ li,046 PSay "Valor Icms"
			@ li,067 PSay "Base IPI"
			@ li,087 PSay "Valor IPI"
			@ li,107 PSay "Base Retido"
			@ li,128 PSay "Valor Retido"
			@ li,149 PSay "Valor Total"
			li++
			@ li,022 PSay Transform(MaFisRet(,"NF_BASEICM"),PesqPict("SF2","F2_BASEICM"))
			@ li,042 PSay Transform(MaFisRet(,"NF_VALICM") ,PesqPict("SF2","F2_VALICM") )
			@ li,062 PSay Transform(MaFisRet(,"NF_BASEIPI"),PesqPict("SF2","F2_BASEIPI"))
			@ li,083 PSay Transform(MaFisRet(,"NF_VALIPI") ,PesqPict("SF2","F2_VALIPI") )
			@ li,105 PSay Transform(MaFisRet(,"NF_BASESOL"),PesqPict("SF2","F2_ICMSRET"))
			@ li,127 PSay Transform(MaFisRet(,"NF_VALSOL") ,PesqPict("SF2","F2_VALBRUT"))
			@ li,147 PSay Transform(MaFisRet(,"NF_TOTAL")  ,PesqPict("SF2","F2_VALBRUT"))
			li++
			@ li,026 psay "Base ISS"
			@ li,046 PSay "Valor ISS"
			li++
			@ li,022 PSay Transform(MaFisRet(,"NF_BASEISS"),PesqPict("SF2","F2_BASEISS"))
			@ li,042 PSay Transform(MaFisRet(,"NF_VALISS") ,PesqPict("SF2","F2_VALISS") )
		Else

			aCodImps := MaFisRet(,"NF_IMPOSTOS") //Descricao / /Aliquota / Valor / Base
			li++
			@ li,000 psay "Impostos: "
			@ li,025 PSay "Imposto                                 Base      Aliquota         Valor" //"Imposto                                 Base      Aliquota         Valor"
			li++
			@ li,025 PSay           "------------------------------ ------------- ------------- -------------"
			li++
			For I:=1 To Len(aCodImps)// Vetor com os impostos
				@ li,25 PSay aCodImps[I][2]
				@ li,57 PSay aCodImps[I][3] Picture TM(aCodImps[I][4],12,MsDecimais(1))
				@ li,71 PSay aCodImps[I][4] Picture TM(aCodImps[I][4],12,MsDecimais(1))
				@ li,85 PSay aCodImps[I][5] Picture TM(aCodImps[I][4],12,MsDecimais(1))
				li++
			Next

		Endif
	Endif

	@ 51,005 psay "PESO BRUTO ------>"+STR(If(aC5Rodape[1][1] > 0,aC5Rodape[1][1],nPesBru))	//"PESO BRUTO ------>"
	@ 52,005 psay "PESO LIQUIDO ---->"+STR(If(aC5Rodape[1][2] > 0,aC5Rodape[1][2] ,nPesLiq))	//"PESO LIQUIDO ---->"
	@ 53,005 psay "VOLUMES --------->"	//"VOLUMES --------->"
	@ 54,005 psay "SEPARADO POR ---->"	//"SEPARADO POR ---->"
	@ 55,005 psay "CONFERIDO POR --->"	//"CONFERIDO POR --->"
	@ 56,005 psay "D A T A --------->"	//"D A T A --------->"

	@ 58,000 psay "DESCONTOS: "	//"DESCONTOS: "
	@ 58,011 psay aC5Rodape[1][3] Picture "99.99"
	@ 58,019 psay aC5Rodape[1][4] picture "99.99"
	@ 58,027 psay aC5Rodape[1][5] picture "99.99"
	@ 58,035 psay aC5Rodape[1][6] picture "99.99"

	@ 60,000 psay "MENSAGEM PARA NOTA FISCAL: "+AllTrim(aC5Rodape[1][7])			//"MENSAGEM PARA NOTA FISCAL: "
	@ 61,000 psay ""

	li := 80

Return( NIL )

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MBRFAT01                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(li,aPedCli,cAliasSC5)

	Local cHeader	:= ""
	Local nPed		:= 0
	Local i         := 0
	Local cMoeda	:= ""
	Local cPedCli   := ""
	Local cPictCgc  := ""
	If cPaisLoc == "BRA"
		cHeader := "It Codigo          Desc. do Material              TES CF   UM        Quant.  Valor Unit. IPI   ICMS   ISS     Vl.Tot.C/IPI Entrega   Desc Loc.    Qtd.a Fat         Saldo      Ult.Fat."	// "It Codigo          Desc. do Material              TES CF   UM        Quant.  Valor Unit. IPI   ICMS   ISS     Vl.Tot.C/IPI Entrega   Desc Loc.    Qtd.a Fat         Saldo      Ult.Fat.
		//          		   0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
		//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	Else
		cHeader := "It Codigo          Desc de Material               TES CF   UM        Quant.  Valor Unit.        Imp.Inc.       Valor Total Entrega   Desc Loc.      Ctd.Ent         Saldo     Ult.Entr."	//
		//        			   0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
		//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	Endif

/* array acabped
01 C5_TIPO
02 C5_CLIENTE
03 C5_LOJACLI
04 C5_TRANSP
05 C5_CONDPAG
06 C5_EMISSAO
07 C5_NUM
08 C5_VEND1
09 C5_VEND2
10 C5_VEND3
11 C5_VEND4
12 C5_VEND5
13 C5_COMIS1
14 C5_COMIS2
15 C5_COMIS3
16 C5_COMIS4
17 C5_COMIS5
18 C5_FRETE
19 C5_TPFRETE
20 C5_SEGURO
21 C5_TABELA
22 C5_VOLUME1
23 C5_ESPECI1
24 C5_MOEDA
25 C5_REAJUST
26 C5_BANCO
27 C5_ACRSFIN
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	IF !(aCabPed[1]$"DB")   //C5_TIPO
		dbSelectArea("SA1")
		dbSeek(xFilial("SA1")+aCabped[2]+aCabped[3])  //C5_CLIENTE + C5_LOJACLI
		cPictCgc := PesqPict("SA1","A1_CGC")
	Else
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+aCabPed[2]+aCabPed[3])  //C5_CLIENTE + C5_LOJACLI
		cPictCgc := PesqPict("SA2","A2_CGC")
	Endif

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+aCabPed[4])		//C5_TRANSP
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+aCabPed[5])		//C5_CONDPAG

	aSort(aPedCli)
	@ 00,000 psay AvalImp(limite)
	@ 01,000 psay Replicate("-",limite-37)
	@ 02,000 psay SM0->M0_NOME
	IF !(aCabPed[1]$"DB")		//C5_TIPO
		@ 02,041 psay "| "+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)
		@ 02,100 psay "| CONFIRMACAO DO PEDIDO "		//"| CONFIRMACAO DO PEDIDO "
		@ 03,000 psay SM0->M0_ENDCOB
		@ 03,041 psay "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT # SA1->A1_END,SA1->A1_ENDENT, SA1->A1_END )
		@ 03,100 psay "|"
		@ 04,000 psay "TEL: "+SM0->M0_TEL			//"TEL: "
		@ 04,041 psay "| "
		@ 04,043 psay IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE # SA1->A1_CEP,SA1->A1_CEPE, SA1->A1_CEP )
		@ 04,053 psay IF( !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE # SA1->A1_MUN,SA1->A1_MUNE, SA1->A1_MUN )
		@ 04,077 psay IF( !Empty(SA1->A1_ESTE) .And. SA1->A1_ESTE # SA1->A1_EST,SA1->A1_ESTE, SA1->A1_EST )
		@ 04,100 psay "| EMISSAO: "		//"| EMISSAO: "
		@ 04,111 psay aCabPed[6]	//C5_EMISSAO
		@ 05,000 psay Iif(cPaisLoc=="BRA","CGC: ",Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
		@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
		@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
		@ 05,041 psay "|"
		@ 05,043 psay subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
		If cPaisLoc == "BRA"
			@ 05,062 psay "IE: "+SA1->A1_INSCR			//"IE: "
		Endif
		@ 05,100 psay "| PEDIDO N. "+aCabPed[7]			//"| PEDIDO N. "	//C5_NUM
	Else
		@ 02,041 psay "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
		@ 02,100 psay "| CONFIRMACAO DO PEDIDO "	//"| CONFIRMACAO DO PEDIDO "
		@ 03,000 psay SM0->M0_ENDCOB
		@ 03,041 psay "| "+ SA2->A2_END
		@ 03,100 psay "|"
		@ 04,000 psay "TEL: "+SM0->M0_TEL			//"TEL: "
		@ 04,041 psay "| "+SA2->A2_CEP
		@ 04,053 psay SA2->A2_MUN
		@ 04,077 psay SA2->A2_EST
		@ 04,100 psay "| EMISSAO: "		//"| EMISSAO: "
		@ 04,111 psay aCabPed[6]	//C5_EMISSAO
		@ 05,000 psay Iif(cPaisLoc=="BRA","CGC: ",Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
		@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
		@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
		@ 05,041 psay "|"
		@ 05,043 psay SA2->A2_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
		If cPaisLoc == "BRA"
			@ 05,062 psay "IE: "+SA2->A2_INSCR			//"IE: "
		Endif
		@ 05,100 psay "| PEDIDO N. "+aCabPed[7]			//"| PEDIDO N. "	//C5_NUM
	Endif
	li:= 6
	If Len(aPedCli) > 0
		@ li,000 psay Replicate("-",limite-37)
		li++
		@ li,000 psay "PEDIDO(S) DO CLIENTE:"
		cPedCli:=""
		For nPed := 1 To Len(aPedCli)
			cPedCli += aPedCli[nPed]+Space(02)
			If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
				@ li,23 psay cPedCli
				cPedCli:=""
				li++
			Endif
		Next
	Endif
	@ li,000 psay Replicate("-",limite-37)
	li++
	@ li,000 psay "TRANSP...: "+aCabPed[4]+" - "+SA4->A4_NOME			//"TRANSP...: "		//C5_TRANSP
	li++

	For i := 8 to 12
		dbSelectArea("SA3")
		dbSetOrder(1)
		If dbSeek(xFilial("SA3")+aCabPed[i])	//C5_VENDi
			If i == 8
				@ li,000 psay "VENDEDOR.: "		//"VENDEDOR.: "
			EndIf
			@ li,013 psay aCabPed[i] + " - "+SA3->A3_NOME	//C5_VENDi
			li++
		EndIf
	Next

	@ li,000 psay "COND.PGTO: "+aCabPed[5]+" - "+SE4->E4_DESCRI			//"COND.PGTO: "		//C5_CONDPAG
	@ li,065 psay "FRETE...: "		//"FRETE...: "
	@ li,075 psay aCabPed[18] Picture "@EZ 999,999,999.99"		//C5_FRETE
	@ li,090 psay IIF(aCabPed[19]="C","(CIF)","(FOB)")		//C5_TPFRETE
	@ li,100 psay "SEGURO: "		//"SEGURO: "
	@ li,108 psay aCabPed[20] Picture "@EZ 999,999,999.99"		//C5_SEGURO
	li++
	@ li,000 psay "TABELA...: "+aCabPed[21]		//"TABELA...: "		//C5_TABELA
	@ li,065 psay "VOLUMES.: "		//"VOLUMES.: "
	@ li,075 psay aCabPed[22]    Picture "@EZ 999,999"		//C5_VOLUME1s
	li++
	cMoeda:=Strzero(aCabPed[24],1,0)		//C5_MOEDA
	@ li,000 psay "REAJUSTE.: "+aCabPed[25]+" Moeda: " +IIF(cMoeda < "2","1",cMoeda)		//"REAJUSTE.: "###"   Moeda : " 	//C5_REAJUST
	@ li,065 psay "Banco: " + aCabPed[26]					//"BANCO: "		//C5_BANCO
	@ li,100 psay "Acresc Fin.: "+Str(aCabPed[27],6,2)		//"ACRES.FIN.: "	//C5_ACRSFIN
	li++
	@ li,000 psay Replicate("-",limite-37)
	li++
	@ li,000 psay cHeader
	li++
	@ li,000 psay Replicate("-",limite-37)
	li++

Return( .T. )

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³Mtr730Cli ³ Autor ³ Henry Fila            ³ Data ³ 26.08.02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Função que retorna os pedidos do cliente                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ Mtr730Cli(cPedido)                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1: Numero do pedido                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MBRFAT01                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Mtr730Cli(cPedido)

	Local aPedidos := {}
	Local aArea    := GetArea()
	Local aAreaSC6 := SC6->(GetArea())

	SC6->(dbSetOrder(1))
	SC6->(MsSeek(xFilial("SC6")+cPedido))

	While !(SC6->(Eof())) .And. xFilial("SC6")==SC6->C6_FILIAL .And.;
			SC6->C6_NUM == cPedido

		If !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedidos,SC6->C6_PEDCLI) = 0
			Aadd(aPedidos, SC6->C6_PEDCLI )
		Endif

		SC6->(dbSkip())
	Enddo

	RestArea(aAreaSC6)
	RestArea(aArea)

Return(aPedidos)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³FisGetInit³ Autor ³Eduardo Riera          ³ Data ³17.11.2005³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Inicializa as variaveis utilizadas no Programa              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FisGetInit(aFisGet,aFisGetSC5)

	Local cValid      := ""
	Local cReferencia := ""
	Local nPosIni     := 0
	Local nLen        := 0

	If aFisGet == Nil
		aFisGet	:= {}
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC6")
		While !Eof().And.X3_ARQUIVO=="SC6"
			cValid := UPPER(X3_VALID+X3_VLDUSER)
			If 'MAFISGET("'$cValid
				nPosIni 	:= AT('MAFISGET("',cValid)+10
				nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia := Substr(cValid,nPosIni,nLen)
				aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf
			If 'MAFISREF("'$cValid
				nPosIni		:= AT('MAFISREF("',cValid) + 10
				cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
				aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf
			dbSkip()
		EndDo
		aSort(aFisGet,,,{|x,y| x[3]<y[3]})
	EndIf

	If aFisGetSC5 == Nil
		aFisGetSC5	:= {}
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC5")
		While !Eof().And.X3_ARQUIVO=="SC5"
			cValid := UPPER(X3_VALID+X3_VLDUSER)
			If 'MAFISGET("'$cValid
				nPosIni 	:= AT('MAFISGET("',cValid)+10
				nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia := Substr(cValid,nPosIni,nLen)
				aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf
			If 'MAFISREF("'$cValid
				nPosIni		:= AT('MAFISREF("',cValid) + 10
				cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
				aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf
			dbSkip()
		EndDo
		aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
	EndIf
	MaFisEnd()
Return(.T.)
