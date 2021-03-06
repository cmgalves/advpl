#INCLUDE "MBMTR540.CH"
#INCLUDE "PROTHEUS.CH"

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR540  � Autor � Marco Bianchi            � Data � 23/05/06 ���
����������������������������������������������������������������������������Ĵ��           
���Descri��o � Relatorio de Comissoes.                                       ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR540(void)                                                 ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                      ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

User Function MBMtr540() 


local oReport
Private cAliasQry := GetNextAlias()

#IFDEF TOP
   Private cAlias    := cAliasQry
#ELSE
   Private cAlias    := "SE3"
#ENDIF

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()  
Else
	MBMtr540R3()
EndIf

Return
                                       

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data �23/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

local oReport
local oComissaoA
local oComissaoS
local oDetalhe
local oTotal
local cVend  		:= ""
local dVencto   	:= CTOD( "" ) 
local dBaixa    	:= CTOD( "" ) 
local nVlrTitulo	:= 0
local nBasePrt  	:= 0
local nComPrt   	:= 0
local nVlrFrt       := 0
local nVlrIPI       := 0
local nVlrICM       := 0
local cTipo     	:= ""
local cLiquid 
local aValLiq   	:= {}
local nI2       	:= 0
local aLiqProp  	:= {}
local nValIR    	:= 0
local nTotSemIR 	:= 0
local nAc1      	:= 0
local nAc2      	:= 0
local nAc3      	:= 0
local nDecPorc		:= TamSX3("E3_PORC")[2]
local nTamData  	:= Len(DTOC(MsDate()))
local CFRETEMB		:= ""

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("MBMTR540",STR0025,"MTR540P9R1", {|oReport| ReportPrint(oReport,cAliasQry,oComissaoA,oComissaoS,oDetalhe,oTotal)},STR0026)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

AjustaSX1()
Pergunte("MTR540P9R1",.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oComissaoA := TRSection():New(oReport,STR0050,{"SE3","SA3"},{STR0046,STR0047},/*Campos do SX3*/,/*Campos do SIX*/)
oComissaoA:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//� Analitico                                                              �
//��������������������������������������������������������������������������
TRCell():New(oComissaoA,"E3_VEND" ,"SE3",/*Titulo*/,/*Picture*/                ,/*Tamanho*/         ,/*lPixel*/  ,{|| cVend })
TRCell():New(oComissaoA,"A3_NOME" ,"SA3",/*Titulo*/,/*Picture*/                ,/*Tamanho*/         ,/*lPixel*/  ,{|| SA3->A3_NOME })

// Titulos da Comissao
oDetalhe := TRSection():New(oComissaoA,STR0048,{"SE3","SA3"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oDetalhe:SetTotalInLine(.F.)
oDetalhe:SetHeaderBreak(.T.)
TRCell():New(oDetalhe,"E3_PREFIXO" 	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_NUM"		,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,{|| E3_NUM })
TRCell():New(oDetalhe,"E3_PARCELA" 	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_CODCLI"	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"A1_NREDUZ"	,cAlias,/*Titulo*/,/*Picture*/               ,30			,/*lPixel*/,{|| Substr(SA1->A1_NREDUZ,1,30) })
TRCell():New(oDetalhe,"A1_NOME"		,cAlias,/*Titulo*/,/*Picture*/               ,30			,/*lPixel*/,{|| Substr(SA1->A1_NOME,1,30)  })
TRCell():New(oDetalhe,"E3_EMISSAO"	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oDetalhe,"DVENCTO"		,"    ",STR0033   ,/*Picture*/               ,nTamData  ,/*lPixel*/,{|| dVencto })
TRCell():New(oDetalhe,"E3_PEDIDO"	,cAlias,'Pedido',/*Picture*/           ,nTamData  ,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oDetalhe,"DBAIXA"		,"    ",STR0034   ,/*Picture*/               ,nTamData  ,/*lPixel*/,{|| dBaixa })

//TRCell():New(oDetalhe,"PERDES"	,cAlias,'% Desc'   ,/*Picture*/               ,8  ,/*lPixel*/,/*{|| code-block de impressao }*/)


TRCell():New(oDetalhe,"E3_ZZFRETE"	,cAlias,STR0052   ,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_ZVALIPI"	,cAlias,STR0053   ,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_ZICMRET"	,cAlias,STR0054   ,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oDetalhe,"NVLRTITULO"	,"    ",STR0035   ,PesqPict('SE3','E3_COMIS'),TamSx3("E3_COMIS"	)[1],/*lPixel*/,{|| 5,5 }) //nVlrTitulo })
TRCell():New(oDetalhe,"NBASEPRT"		,"    ",STR0036   ,PesqPict('SE3','E3_BASE') ,TamSx3("E3_BASE"	)[1],/*lPixel*/,{|| nBasePrt })
If cPaisLoc<>"BRA"
	TRCell():New(oDetalhe,"E3_PORC"	,cAlias,STR0032,tm(SE3->E3_PORC,6,nDecPorc)  ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
Else
	TRCell():New(oDetalhe,"E3_PORC"	,cAlias,STR0032,tm(SE3->E3_PORC,6)           ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
Endif
TRCell():New(oDetalhe,"NCOMPRT"		,"   ",STR0038,PesqPict('SE3','E3_COMIS')   ,TamSx3("E3_COMIS")[1]	,/*lPixel*/,{|| nComPrt })
TRCell():New(oDetalhe,"E3_BAIEMI"	,cAlias,STR0040,/*Picture*/                   ,/*Tamanho*/  ,/*lPixel*/,{|| Substr(cTipo,1,1) })
//TRCell():New(oDetalhe,"AJUSTE"		,"   ",STR0037,/*Picture*/                   ,/*Tamanho*/  ,/*lPixel*/,{|| ""})
TRCell():New(oDetalhe,"CFRETEMB"	,cAlias,"TP FRETE"   ,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)

// Titulos de Liquidacao
oLiquida := TRSection():New(oDetalhe,/*STR0051*/,{"SE1","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oLiquida:SetTotalInLine(.F.)
TRCell():New(oLiquida,"E1_NUMLIQ" 	,"   ",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,{|| cLiquid })
TRCell():New(oLiquida,"E1_PREFIXO"	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_NUM"	    ,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_PARCELA" 	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_TIPO"   	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_CLIENTE"	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_LOJA"		,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oLiquida,"A1_NREDUZ"	,"SA1",/*Titulo*/ ,/*Picture*/                ,TamSX3("A1_NREDUZ")[1],/*lPixel*/,{|| Substr(SA1->A1_NREDUZ,1,30) })
TRCell():New(oLiquida,"A1_NOME"		,"SA1",/*Titulo*/ ,/*Picture*/                ,TamSX3("A1_NOME")[1],/*lPixel*/,{|| Substr(SA1->A1_NOME,1,30) })

TRCell():New(oLiquida,"E1_VALOR"		,"SE1",/*Titulo*/ ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"NVALLIQ1"		,"   ",STR0043    ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,{|| aValLiq[nI2,1] })
TRCell():New(oLiquida,"NVALLIQ2"		,"   ",STR0044    ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,{|| aValLiq[nI2,2] })
TRCell():New(oLiquida,"NLIQPROP"		,"   ",STR0045    ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,{|| aLiqProp[nI2] })

//-- Secao Totalizadora do Valor do IR e Total (-) IR
oTotal := TRSection():New(oReport,"",{},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oTotal,"TOTALIR"     ,"   ",STR0028,"@E 99,999,999.99",12         ,/*lPixel*/,{|| nValIR })
TRCell():New(oTotal,"TOTSEMIR"    ,"   ",STR0029,"@E 99,999,999.99",12         ,/*lPixel*/,{|| nTotSemIR })

//������������������������������������������������������������������������Ŀ
//� Sintetico                                                              �
//��������������������������������������������������������������������������
oComissaoS := TRSection():New(oReport,STR0049,{"SE3","SA3"},{STR0046,STR0047},/*Campos do SX3*/,/*Campos do SIX*/)
oComissaoS:SetTotalInLine(.F.)

TRCell():New(oComissaoS,"E3_VEND" ,"SE3",/*Titulo*/,/*Picture*/                	,/*Tamanho*/          	,/*lPixel*/	,{|| cVend })
TRCell():New(oComissaoS,"A3_NOME" ,"SA3",/*Titulo*/,/*Picture*/					,/*Tamanho*/          	,/*lPixel*/	,{|| SA3->A3_NOME })
TRCell():New(oComissaoS,"TOTALTIT",""		,STR0027   ,PesqPict('SE3','E3_BASE') 	,TamSx3("E3_BASE")[1] 	,/*lPixel*/	,{|| nAc3 })
TRCell():New(oComissaoS,"E3_BASE" ,cAlias,STR0030   ,PesqPict('SE3','E3_BASE') 	,TamSx3("E3_BASE")[1] 	,/*lPixel*/	,{|| nAc1 })
TRCell():New(oComissaoS,"E3_PORC" ,cAlias,STR0032   ,PesqPict('SE3','E3_PORC') 	,TamSx3("E3_PORC")[1] 	,/*lPixel*/	,{|| (nAc2*100) / nAc1})
TRCell():New(oComissaoS,"E3_COMIS",cAlias,STR0031   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{|| nAc2 })
TRCell():New(oComissaoS,"VALIR"   ,""   	,STR0028   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{||nValIR })
TRCell():New(oComissaoS,"TOTSEMIR",""   	,STR0029   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{||nTotSemIR})

//������������������������������������������������������������������������Ŀ
//� Impressao do Cabecalho no topo da pagina                               �
//��������������������������������������������������������������������������
oReport:Section(1):SetHeaderPage()
oReport:Section(3):SetHeaderPage()
oReport:Section(1):Setedit(.T.)
oReport:Section(1):Section(1):Setedit(.T.)
oReport:Section(1):Section(1):Section(1):Setedit(.T.)
oReport:Section(2):Setedit(.F.)
//������������������������������������������������������������������������Ŀ
//� Alinhamento a direita dos campos de valores                            �
//��������������������������������������������������������������������������
//Analitico
oDetalhe:Cell("NVLRTITULO"):SetHeaderAlign("RIGHT")
oDetalhe:Cell("NBASEPRT"):SetHeaderAlign("RIGHT")
oDetalhe:Cell("NCOMPRT"):SetHeaderAlign("RIGHT")
//Sintetico
oComissaoS:Cell("TOTALTIT"):SetHeaderAlign("RIGHT")
oComissaoS:Cell("E3_BASE" ):SetHeaderAlign("RIGHT")
oComissaoS:Cell("E3_COMIS"):SetHeaderAlign("RIGHT")
oComissaoS:Cell("VALIR"   ):SetHeaderAlign("RIGHT")
oComissaoS:Cell("TOTSEMIR"):SetHeaderAlign("RIGHT")

//IR
oTotal:Cell("TOTALIR"):SetHeaderAlign("RIGHT")
oTotal:Cell("TOTSEMIR"):SetHeaderAlign("RIGHT")

Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Eduardo Riera          � Data �04.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQry,oComissaoA,oComissaoS,oDetalhe,oTotal)

local lQuery   := .F.
local dEmissao := CTOD( "" ) 
local nTotLiq  := 0
local aLiquid  := {}
local ny 
local cWhere   := ""
local cNomArq, cFilialSE1, cFilialSE3
local nI       := 0
local cOrder   := ""
local nDecs
local nTotPorc := 0

#IFNDEF TOP
	local cCondicao := ""
#ENDIF

local cDocLiq   := ""
local cTitulo   := ""                                     
local cAjuste   := ""
local nTotBase	:= 0
local nTotComis	:= 0
local nSection	:= 0
local nOrdem	:= 0

If oReport:Section(1):GetOrder() == 1		// Ordem: por Titulo
	nOrdem := 1
Else										// Ordem: por Cliente
	nOrdem := 2
EndIf	

If mv_par10 == 1	// Analitico
	oReport:Section(3):Disable()
	nSection := 1   
	
	If mv_par12 == 1
		oReport:Section(1):section(1):Cell("A1_NOME"):Disable()
		oReport:Section(1):section(1):Section(1):Cell("A1_NOME"):Disable()
	Else
		oReport:Section(1):section(1):Cell("A1_NREDUZ"):Disable()
		oReport:Section(1):section(1):Section(1):Cell("A1_NREDUZ"):Disable()
	EndIf
	oReport:Section(1):Cell("E3_VEND"):SetBlock({|| cVend })	
	oReport:Section(1):Section(1):Cell("DVENCTO" ):SetBlock({|| dVencto })	
	oReport:Section(1):Section(1):Cell("DBAIXA" ):SetBlock({|| dBaixa })	
	oReport:Section(1):Section(1):Cell("NVLRTITULO" ):SetBlock({|| nVlrTitulo })	
	oReport:Section(1):Section(1):Cell("NBASEPRT" ):SetBlock({|| nBasePrt })	
	oReport:Section(1):Section(1):Cell("NCOMPRT" ):SetBlock({|| nComPrt })	
	oReport:Section(1):Section(1):Cell("E3_BAIEMI" ):SetBlock({|| Substr(cTipo,1,1) })	
	oReport:Section(1):Section(1):Cell("CFRETEMB" ):SetBlock({|| CFRETEMB })
//	oReport:Section(1):Section(1):Cell("AJUSTE" ):SetBlock({|| IIf( (cAjuste == "S" .And. MV_PAR06 == 1),"AJUSTE","" ) })	
	oReport:Section(1):Section(1):Section(1):Cell("E1_NUMLIQ" ):SetBlock({|| cLiquid  })	
	oReport:Section(1):Section(1):Section(1):Cell("NVALLIQ1" ):SetBlock({|| aValLiq[nI2,1] })	
	oReport:Section(1):Section(1):Section(1):Cell("NVALLIQ2" ):SetBlock({|| aValLiq[nI2,2] })	
	oReport:Section(1):Section(1):Section(1):Cell("NLIQPROP" ):SetBlock({|| aLiqProp[nI2] })	
	oReport:Section(2):Cell("TOTALIR" ):SetBlock({|| nValIR })	
	oReport:Section(2):Cell("TOTSEMIR" ):SetBlock({|| nTotSemIR })	

    bVOrig := { || cDocLiq := SE1->E1_NUMLIQ, nVlrTitulo := Iif(cTitulo <> (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA .And. Empty(cDocLiq), nVlrTitulo, 0 ) }
    
	TRFunction():New(oDetalhe:Cell("NVLRTITULO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,bVOrig,.T./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("NBASEPRT")  ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("NCOMPRT")   ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("E3_PORC")   ,/* cID */,"ONPRINT",/*oBreak*/,/*cTitle*/,/*cPicture*/,{|| nTotPorc},.T./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,.F.)	

	
	If mv_par08 > 0
		TRFunction():New(oTotal:Cell("TOTALIR") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oTotal:Cell("TOTSEMIR") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	EndIf	                                                                    

	cVend		:= ""
	dVencto 	:= ctod("  /  /  ")
	dBaixa 		:= ctod("  /  /  ")
	nVlrTitulo 	:= 0
	nBasePrt 	:= 0
	nComPrt 	:= 0
	cTipo 		:= ""
	cLiquid  	:= ""
	nValIR		:= 0
	nTotSemIR 	:= 0
	CFRETEMB	:= ""
	
	
Else				// Sintetico

	TRFunction():New(oComissaoS:Cell("TOTALTIT"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_BASE"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_PORC"),/* cID */,"MAX",/*oBreak*/,/*cTitle*/,/*cPicture*/,{||nTotPorc},.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_COMIS"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("VALIR"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("TOTSEMIR"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

	oReport:Section(1):Disable()
	oReport:Section(1):Section(1):Disable()
	oReport:Section(1):Section(1):Section(1):Disable()
	nSection := 3
	
	oReport:Section(3):Cell("E3_VEND" ):SetBlock({|| cVend })		
	oReport:Section(3):Cell("TOTALTIT" ):SetBlock({|| nAc3 })		
	oReport:Section(3):Cell("E3_BASE" ):SetBlock({|| nAc1 })		
	oReport:Section(3):Cell("E3_PORC" ):SetBlock({|| (nAc2*100) / nAc1 })		
	oReport:Section(3):Cell("E3_COMIS" ):SetBlock({||nAc2 })		
	oReport:Section(3):Cell("VALIR" ):SetBlock({|| nValIR })	
	oReport:Section(3):Cell("TOTSEMIR" ):SetBlock({|| nTotSemIR })	

	cVend		:= ""
	nAc1		:= 0
	nAc2		:= 0
	nAc3		:= 0
	nValIR		:= 0
	nTotSemIR	:= 0
	CFRETEMB	:= ""
	
EndIf

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������

#IFDEF TOP

	// Indexa de acordo com ordem escolhida oelo cliente
	dbSelectArea("SE3")
	If nOrdem == 1		// Ordem: por Titulo
		dbSetOrder(2)   
		cOrder := "%E3_FILIAL,E3_VEND,E3_PREFIXO,E3_NUM,E3_PARCELA%"
	Else										// Ordem: por Cliente
		dbSetOrder(3)
		cOrder := "%E3_FILIAL,E3_VEND,E3_CODCLI,E3_LOJA,E3_PREFIXO,E3_NUM,E3_PARCELA%"
	EndIf	

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	lQuery := .T.                 
	
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)	
	
	oReport:Section(nSection):BeginQuery()
	cWhere :="%"             
	If mv_par01 == 1
		cWhere += "AND E3_BAIEMI <> 'B'"  //Baseado pela emissao da NF
	Elseif mv_par01 == 2
		cWhere += "AND E3_BAIEMI =  'B'"  //Baseado pela baixa do titulo
	EndIf
	If mv_par05 == 1 		//Comissoes a pagar
		cWhere += "AND E3_DATA = '" + Dtos(Ctod("")) + "'"
	ElseIf mv_par05 == 2 //Comissoes pagas
		cWhere += "AND E3_DATA <> '" + Dtos(Ctod("")) + "'"
	Endif
	cWhere +="%"
	
	BeginSql Alias cAliasQry
		SELECT 
			E3_FILIAL, E3_BASE, E3_COMIS, E3_VEND, E3_PORC, 
			A3_NOME, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO,
			E3_CODCLI, E3_LOJA, E3_AJUSTE, E3_BAIEMI, E3_EMISSAO,
			E3_DATA, E3_PEDIDO, E3_ZZFRETE, E3_ZVALIPI, E3_ZICMRET,
			ISNULL(C5_XPERDES, 0) PERDES,
			CASE
				WHEN C5_FRETEMB = '1' THEN 'CIF-RED'
				WHEN C5_FRETEMB = '2' THEN 'CIF-CLIENTE'
				WHEN C5_FRETEMB = '3' THEN 'FOB-RED'
				WHEN C5_FRETEMB = '4' THEN 'FOB-RETIRA'
			ELSE 'SEM-FRETE' END TIPOFRETE 
			
		FROM 
			%table:SE3% SE3 LEFT JOIN 
			%table:SA3% SA3 ON 
			A3_FILIAL = %xFilial:SA3% AND 
			A3_COD = E3_VEND AND 
			SA3.%NotDel% LEFT JOIN 
			%table:SC5% SC5 ON 
			C5_FILIAL = %xFilial:SC5% AND 
			E3_PEDIDO = C5_NUM AND 
			SC5.%NotDel%
		WHERE 
			E3_FILIAL = %xFilial:SE3% AND
			E3_EMISSAO >= %Exp:Dtos(mv_par02)% AND 
			E3_EMISSAO <= %Exp:Dtos(mv_par03)% AND 
			SE3.%notdel%
			%Exp:cWhere%
		ORDER BY 
			%Exp:cOrder%
	EndSql
	
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(nSection):EndQuery({MV_PAR04})


#ELSE
   
	//����������������������������������������������������������������������������������������������������Ŀ
	//�Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX �
	//������������������������������������������������������������������������������������������������������
	MakeAdvplExpr("MTR540P9R1") 

	// Indexa de acordo com ordem escolhida oelo cliente
	dbSelectArea("SE3")
	If nOrdem == 1		// Ordem: por Titulo
		dbSetOrder(2)   
		cOrder := "E3_FILIAL+E3_VEND+E3_PREFIXO+E3_NUM+E3_PARCELA"
	Else										// Ordem: por Cliente
		dbSetOrder(3)
		cOrder := "E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA"
	EndIf	
	
	DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
	DbSetOrder(3)			// Por Vendedor, Cliente, Loja, Prefixo, Numero
	cFilialSE3 := xFilial()
	cNomArq    := CriaTrab("",.F.)
	
	cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
	
	If !Empty(mv_par04)
		cCondicao +=  " .AND. "+MV_PAR04
	EndIf
	
	cCondicao += " .AND. DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
	cCondicao += " .AND. DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'"	
	                                 
	If mv_par01 == 1
		cCondicao += " .AND. SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
	Elseif mv_par01 == 2
		cCondicao += " .AND. SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
	Endif	
		
	If mv_par05 == 1 		// Comissoes a pagar
		cCondicao += " .AND. Dtos(SE3->E3_DATA)== '"+Dtos(Ctod(""))+"'"
	ElseIf mv_par05 == 2 // Comissoes pagas
		cCondicao += " .AND. Dtos(SE3->E3_DATA)!= '"+Dtos(Ctod(""))+"'"
	Endif
	
	oReport:Section(nSection):SetFilter(cCondicao,cOrder)      // abre tela de imprimindo...
	
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������
TRPosition():New(oReport:Section(nSection),"SA3",1,{|| xFilial("SA3")+cVend })
If mv_par10 == 1
   TRPosition():New(oReport:Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA })
   TRPosition():New(oReport:Section(1):Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA })
EndIf   


//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
If mv_par10 == 2 .Or. mv_par10 == 1 
	nTotBase	:= 0
	nTotComis	:= 0
EndIf

dbSelectArea(cAlias)
dbGoTop()
nDecs     := GetMv("MV_CENT"+(IIF(mv_par07 > 1 , STR(mv_par07,1),"")))

oReport:SetMeter(SE3->(LastRec()))
dbSelectArea(cAlias)
While !oReport:Cancel() .And. !&(cAlias)->(Eof())
	
	cVend := &(cAlias)->(E3_VEND)
	nAc1 := 0
	nAc2 := 0
	nAc3 := 0
	
	oReport:Section(nSection):Init()
	If mv_par10 == 1
		oReport:Section(nSection):PrintLine()
	EndIf	

	
	While !Eof() .And. xFilial("SE3") == (cAlias)->E3_FILIAL .And. (cAlias)->E3_VEND == cVend
		nBasePrt   := 0
		nComPrt    := 0
		nVlrTitulo := 0
		If mv_par10 == 1 
			nTotBase	:= 0
			nTotComis	:= 0
		EndIf		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM)+&(cAlias)->(E3_PARCELA)+&(cAlias)->(E3_TIPO))
		nVlrTitulo:= Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR07,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dEmissao  := SE1->E1_EMISSAO
		cLiquid   := ""
		cDocLiq   := SE1->E1_NUMLIQ
		
		If mv_par10 == 1
			dVencto   := SE1->E1_VENCTO
			aLiquid	  := {}
			aValLiq	  := {}
			aLiqProp  := {}
			nTotLiq	  := 0
			If mv_par11 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
				cLiquid := SE1->E1_NUMLIQ
				cDocLiq := SE1->E1_NUMLIQ
				// Obtem os registros que deram origem ao titulo gerado pela liquidacao
				Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
				For ny := 1 to Len(aValLiq)
					nTotLiq += aValLiq[ny,2]
				Next
				For ny := 1 to Len(aValLiq)
					aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
				Next
			Endif
			
		EndIf
		
		If Eof()
			dbSelectArea("SF2")
			dbSetorder(1)
			dbSeek(xFilial()+(cAlias)->E3_NUM+(cAlias)->E3_PREFIXO)
			nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par07,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			dEmissao   := SF2->F2_EMISSAO
			
			If mv_par10 == 1
				dVencto    := CTOD( "" )
				dBaixa     := CTOD( "" )  	
			EndIf
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM))
				While ( !Eof() .And. (cAlias)->E3_PREFIXO == SE1->E1_PREFIXO .And.;
					(cAlias)->E3_NUM == SE1->E1_NUM .And.;
					(cAlias)->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == (cAlias)->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == (cAlias)->E3_CODCLI .And. ;
						SE1->E1_LOJA == (cAlias)->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR07,SE1->E1_EMISSAO,nDecs+1),nDecs)
						
						If mv_par10 == 1
							dVencto    := CTOD( "" )
							dBaixa     := CTOD( "" )
						EndIf

						If Empty(dEmissao)
							dEmissao := SE1->E1_EMISSAO
						EndIf
						
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif
		
		If Empty(dEmissao)
			dEmissao := NIL
		EndIf
		
		nBasePrt:=	Round(xMoeda((cAlias)->E3_BASE ,1,MV_PAR07,dEmissao,nDecs+1),nDecs)
		nComPrt :=	Round(xMoeda((cAlias)->E3_COMIS,1,MV_PAR07,dEmissao,nDecs+1),nDecs)
		
		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif
		
		CFRETEMB	:=	(cAlias)->TIPOFRETE
		
		If mv_par10 == 1
			cAjuste := (cAlias)->E3_AJUSTE
			cTipo   := (cAlias)->E3_BAIEMI
			dbSelectArea(cAlias)
			oReport:Section(1):Section(1):Init()
			oReport:Section(1):Section(1):PrintLine()
			oReport:IncMeter()
			
			If mv_par11 == 1
				For nI := 1 To Len(aLiquid)
					nI2 := nI
					SE1->(MsGoto(aLiquid[nI]))
				    oReport:Section(1):SetHeaderBreak(.T.)
					oReport:Section(1):Section(1):Section(1):Init()
					oReport:Section(1):Section(1):Section(1):PrintLine()
				Next
				oReport:Section(1):Section(1):Section(1):Finish()
			Endif			
			
		EndIf
		
		nAc1 += nBasePrt
		nAc2 += nComPrt
		If cTitulo <> (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA  .And. Empty(cDocLiq)
			nAc3   += nVlrTitulo
			cTitulo:= (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA
			cDocLiq:= ""
		EndIf
		
		
		dbSelectArea(cAlias)
		dbSkip()
	EndDo
	
	If mv_par10 == 1
		nTotBase 	+= nAc1
		nTotComis 	+= nAc2
		//nTotPorc	:= (nTotComis / nTotBase)*100
		oReport:Section(1):Section(1):SetTotalText("Total do Vendedor " + cVend)
		oReport:Section(1):Section(1):Finish()
	EndIf
	
	nValIR    := 0
	nTotSemIR := 0
	If mv_par08 > 0 .And. (nAc2 * mv_par08 / 100) > GetMV("MV_VLRETIR") //IR
		nValIR    := nAc2 * (MV_PAR08/100)
		nTotSemIR := nAc2 - (nAc2 * (MV_PAR08/100))
	Else
		nTotSemIR := nAc2
	EndIf
	
	If mv_par10 == 2
		nTotBase 	+= nAc1
		nTotComis 	+= nAc2
		//nTotPorc	:= (nTotComis / nTotBase) * 100
		oReport:Section(nSection):Init()				
		oReport:Section(nSection):PrintLine()
	EndIf	
	oReport:Section(nSection):Finish()
	
	If mv_par10 == 1 .And. mv_par08 > 0
		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	EndIf
	
	If mv_par09 == 1
	   oReport:Section(nSection):SetPageBreak(.T.)
	EndIf
	
	If mv_par10 == 2
		oReport:IncMeter()
	EndIf
	
EndDo

oReport:Section(nSection):SetPageBreak(.T.)

#IFNDEF TOP
   RetIndex("SE3")
#ENDIF
   


Return


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR540R3� Autor � Claudinei M. Benzi       � Data � 13.04.92 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Comissoes.                                       ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR540(void)                                                 ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                      ���
�����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������� 
����������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Programad.�ALTERACAO                                      ���
����������������������������������������������������������������������������Ĵ��
���05.02.03�XXXXXX�Eduardo Ju�Inclusao de Queries para filtros em TOPCONNECT.���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

Static Function MBMtr540R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
local wnrel
local titulo    := STR0001  //"Relatorio de Comissoes"
local cDesc1    := STR0002  //"Emissao do relatorio de Comissoes."
local tamanho   := "G"
local limite    := 220
local cString   := "SE3"
local cAliasAnt := Alias()
local cOrdemAnt := IndexOrd()
local nRegAnt   := Recno()
local cDescVend := " "

Private aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:= "MBMTR540"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "MTR540"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1()
Pergunte("MTR540",.F.)
//���������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                          �
//� mv_par01        	// Pela <E>missao,<B>aixa ou <A>mbos      �
//� mv_par02        	// A partir da data                       �
//� mv_par03        	// Ate a Data                             �
//� mv_par04 	    	// Do Vendedor                            �
//� mv_par05	     	// Ao Vendedor                            �
//� mv_par06	     	// Quais (a Pagar/Pagas/Ambas)            �
//� mv_par07	     	// Incluir Devolucao ?                    �
//� mv_par08	     	// Qual moeda                             �
//� mv_par09	     	// Comissao Zerada ?                      �
//� mv_par10	     	// Abate IR Comiss                        �
//� mv_par11	     	// Quebra pag.p/Vendedor                  �
//� mv_par12	     	// Tipo de Relatorio (Analitico/Sintetico)�
//� mv_par13	     	// Imprime detalhes origem                �
//� mv_par14         // Nome cliente							  �
//�����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := "MBMTR540"
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,"","",.F.,"",.F.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey ==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C540Imp(@lEnd,wnRel,cString)},Titulo)

//��������������������������������������������������������������Ŀ
//� Retorna para area anterior, indice anterior e registro ant.  �
//����������������������������������������������������������������
DbSelectArea(caliasAnt)
DbSetOrder(cOrdemAnt)
DbGoto(nRegAnt)
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C540IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR540			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function C540Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
local CbCont,cabec1,cabec2
local tamanho  := "G"
local limite   := 220
local nomeprog := "MBMTR540"
local imprime  := .T.
local cPict    := ""
local cTexto,j :=0,nTipo:=0
local cCodAnt,nCol:=0
local nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAc3:=0,nAg3:=0,nAc4:=0,nAg4:=0,lFirstV:=.T.
local nTregs,nMult,nAnt,nAtu,nCnt,cSav20,cSav7
local lContinua:= .T.
local cNFiscal :=""
local aCampos  :={}
local lImpDev  := .F.
local cBase    := ""
local cNomArq, cCondicao, cFilialSE1, cFilialSE3, cChave, cFiltroUsu
local nDecs    := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))
local nBasePrt :=0, nComPrt:=0 
local aStru    := SE3->(dbStruct()), ni
local nDecPorc := TamSX3("E3_PORC")[2]

local cDocLiq   := ""
local cTitulo  := "" 
local dEmissao := CTOD( "" ) 
local nTotLiq  := 0
local aLiquid  := {}
local aValLiq  := {}
local aLiqProp := {}
local ny
local aColuna := IIF(cPaisLoc <> "MEX",{15,19,42,46,83,95,107,119,130,137,153,169,176,195,203,213},{28,35,58,62,99,111,123,135,146,153,169,185,192,211,219})
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

nTipo := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
If mv_par12 == 1
	If mv_par01 == 1
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi(STR0008)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif

	cabec1:=OemToAnsi(STR0009)	//"PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     DATA        DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO"
	cabec2:=OemToAnsi(STR0010)	//"    TITULO         CLIENTE                                                         COMISSAO    VENCTO      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO"
									// XXX XXXXXXxxxxxx X XXXXXXxxxxxxxxxxxxxx   XX  012345678901234567890123456789012345 XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx XXXXXX 12345678901,23  12345678901,23  99.99  12345678901,23     X       AJUSTE
									// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
									// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	If cPaisLoc == "MEX"
		Cabec1 := Substr(Cabec1,1,10) + Space(16) + Substr(Cabec1,11)
		Cabec2 := Substr(Cabec2,1,10) + Space(16) + Substr(Cabec2,11)
	EndIf								
Else
	If mv_par01 == 1
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi(STR0008)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif
	cabec1:=OemToAnsi(STR0021) //"CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
	cabec2:=OemToAnsi(STR0022) //"                                                         TITULO             BASE                COMISSAO              IR          (-) IR"
                                //"XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 123456789012,23  123456789012,23  99.99  123456789012,23 123456789012,23 123456789012,23
                                //"0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
                                //"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
EndIf

//��������������������������������������������������������������Ŀ
//� Monta condicao para filtro do arquivo de trabalho            �
//����������������������������������������������������������������

DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
DbSetOrder(2)			// Por Vendedor
cFilialSE3 := xFilial()
cNomArq :=CriaTrab("",.F.)

cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
cCondicao += ".And.SE3->E3_VEND>='" + mv_par04 + "'"
cCondicao += ".And.SE3->E3_VEND<='" + mv_par05 + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'" 

If mv_par01 == 1
	cCondicao += ".And.SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
Elseif mv_par01 == 2
	cCondicao += " .And.SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
Endif 

If mv_par06 == 1 		// Comissoes a pagar
	cCondicao += ".And.Dtos(SE3->E3_DATA)=='"+Dtos(Ctod(""))+"'"
ElseIf mv_par06 == 2 // Comissoes pagas
	cCondicao += ".And.Dtos(SE3->E3_DATA)!='"+Dtos(Ctod(""))+"'"
Endif

If mv_par09 == 1 		// Nao Inclui Comissoes Zeradas
   cCondicao += ".And.SE3->E3_COMIS<>0"
EndIf

//��������������������������������������������������������������Ŀ
//� Cria expressao de filtro do usuario                          �
//����������������������������������������������������������������
If ( ! Empty(aReturn[7]) )
	cFiltroUsu := &("{ || " + aReturn[7] +  " }")
Else
	cFiltroUsu := { || .t. }
Endif

nAg1 := nAg2 := nAg3 := nAg4 := 0

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cOrder := SqlOrder(SE3->(IndexKey()))
		
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE3")
		cQuery += " WHERE E3_FILIAL = '" + xFilial("SE3") + "' AND "
	  	cQuery += "	E3_VEND >= '"  + mv_par04 + "' AND E3_VEND <= '"  + mv_par05 + "' AND " 
		cQuery += "	E3_EMISSAO >= '" + Dtos(mv_par02) + "' AND E3_EMISSAO <= '"  + Dtos(mv_par03) + "' AND " 
		
		If mv_par01 == 1
			cQuery += "E3_BAIEMI <> 'B' AND "  //Baseado pela emissao da NF
		Elseif mv_par01 == 2
			cQuery += "E3_BAIEMI =  'B' AND "  //Baseado pela baixa do titulo  
		EndIf	
		
		If mv_par06 == 1 		//Comissoes a pagar
			cQuery += "E3_DATA = '" + Dtos(Ctod("")) + "' AND "
		ElseIf mv_par06 == 2 //Comissoes pagas
  			cQuery += "E3_DATA <> '" + Dtos(Ctod("")) + "' AND "
		Endif 
		
		If mv_par09 == 1 		//Nao Inclui Comissoes Zeradas
   		cQuery+= "E3_COMIS <> 0 AND "
		EndIf  
		
		cQuery += "D_E_L_E_T_ <> '*' "   

		cQuery += " ORDER BY "+ cOrder

		cQuery := ChangeQuery(cQuery)
											
		dbSelectArea("SE3")
		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE3', .F., .T.)
			
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE3', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next 
	Else
	
#ENDIF	
		//��������������������������������������������������������������Ŀ
		//� Cria arquivo de trabalho                                     �
		//����������������������������������������������������������������
		cChave := IndexKey()
		cNomArq :=CriaTrab("",.F.)
		IndRegua("SE3",cNomArq,cChave,,cCondicao, OemToAnsi(STR0016)) //"Selecionando Registros..."
		nIndex := RetIndex("SE3")
		DbSelectArea("SE3") 
		#IFNDEF TOP
			DbSetIndex(cNomArq+OrdBagExT())
		#ENDIF
		DbSetOrder(nIndex+1)

#IFDEF TOP
	EndIf
#ENDIF	

SetRegua(RecCount())		// Total de Elementos da regua 
DbGotop()
While !Eof()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0011)  //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	//��������������������������������������������������������������Ŀ
	//� Processa condicao do filtro do usuario                       �
	//����������������������������������������������������������������
	If ! Eval(cFiltroUsu)
		Dbskip()
		Loop
	Endif
	
	nAc1 := nAc2 := nAc3 := nAc4 := 0
	lFirstV:= .T.
	cVend  := SE3->E3_VEND
	
	While !Eof() .AND. SE3->E3_VEND == cVend
		IncRegua()
		cDocLiq:= ""
		//��������������������������������������������������������������Ŀ
		//� Processa condicao do filtro do usuario                       �
		//����������������������������������������������������������������
		If ! Eval(cFiltroUsu)
			Dbskip()
			Loop
		Endif  
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		//��������������������������������������������������������������Ŀ
		//� Seleciona o Codigo do Vendedor e Imprime o seu Nome          �
		//����������������������������������������������������������������
		IF lFirstV
			dbSelectArea("SA3")
			dbSeek(xFilial()+SE3->E3_VEND)
			If mv_par12 == 1
				cDescVend := SE3->E3_VEND + " " + A3_NOME 
				@li, 00 PSAY OemToAnsi(STR0012) + cDescVend //"Vendedor : "
				li+=2
			Else
				@li, 00 PSAY SE3->E3_VEND
				@li, 07 PSAY A3_NOME 
			EndIf
			dbSelectArea("SE3")
			lFirstV := .F.
		EndIF
		
		If mv_par12 == 1
			@li, 00 PSAY SE3->E3_PREFIXO
			@li, 04 PSAY SE3->E3_NUM
			@li, aColuna[1] PSAY SE3->E3_PARCELA
			@li, aColuna[2] PSAY SE3->E3_CODCLI
			@li, aColuna[3] PSAY SE3->E3_LOJA
		
			dbSelectArea("SA1")
			dbSeek(xFilial()+SE3->E3_CODCLI+SE3->E3_LOJA)
			@li, aColuna[4] PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
		
			dbSelectArea("SE3")
			@li, aColuna[5] PSAY SE3->E3_EMISSAO
		EndIf
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
		nVlrTitulo := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dVencto    := SE1->E1_VENCTO  
		dEmissao   := SE1->E1_EMISSAO 
		aLiquid	  := {}
		aValLiq		:= {}
		aLiqProp	  	:= {}
		nTotLiq		:= 0
		If mv_par13 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
			cLiquid := SE1->E1_NUMLIQ			
			cDocLiq := SE1->E1_NUMLIQ
			// Obtem os registros que deram origem ao titulo gerado pela liquidacao
			Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
			For ny := 1 to Len(aValLiq)
				nTotLiq += aValLiq[ny,2]
			Next
			For ny := 1 to Len(aValLiq)
				aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
			Next
		Endif
		/*
		Nas comissoes geradas por baixa pego a data da emissao da comissao que eh igual a data da baixa do titulo.
		Isto somente dara diferenca nas baixas parciais
		*/	 
		
		If SE3->E3_BAIEMI == "B"
			dBaixa     := SE3->E3_EMISSAO
    	Else
			dBaixa     := SE1->E1_BAIXA
		Endif

		If Eof()
			dbSelectArea("SF2")
			dbSetorder(1)
			dbSeek(xFilial()+SE3->E3_NUM+SE3->E3_PREFIXO) 
			nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			
			dVencto    := " "
			dBaixa     := " "
			
			dEmissao   := SF2->F2_EMISSAO 
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+SE3->E3_PREFIXO+SE3->E3_NUM)
				While ( !Eof() .And. SE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
						SE3->E3_NUM == SE1->E1_NUM .And.;
						SE3->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == SE3->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == SE3->E3_CODCLI .And. ;
						SE1->E1_LOJA == SE3->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
						dVencto    := " "
						dBaixa     := " "
						If Empty(dEmissao)
							dEmissao := SE1->E1_EMISSAO
						EndIf
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif


		If Empty(dEmissao)
			dEmissao := NIL
		EndIf
		
		//Preciso destes valores para pasar como parametro na funcao TM(), e como 
		//usando a xmoeda direto na impressao afetaria a performance (deveria executar
		//duas vezes, uma para imprimir e outra para pasar para a picture), elas devem]
		//ser inicializadas aqui. Bruno.

		nBasePrt:=	Round(xMoeda(SE3->E3_BASE ,1,MV_PAR08,dEmissao,nDecs+1),nDecs)
		nComPrt :=	Round(xMoeda(SE3->E3_COMIS,1,MV_PAR08,dEmissao,nDecs+1),nDecs)

		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif	
		
		dbSelectArea("SE3")
		
		If mv_par12 == 1
			@ li,aColuna[6]  PSAY dVencto
			@ li,aColuna[7]  PSAY dBaixa
//			@ li,aColuna[8]  PSAY PERDES
			@ li,aColuna[9]  PSAY SE3->E3_PEDIDO	Picture "@!"
			@ li,aColuna[10] PSAY nVlrTitulo		Picture tm(nVlrTitulo,14,nDecs)
			@ li,aColuna[11] PSAY nBasePrt 			Picture tm(nBasePrt,14,nDecs)
			If cPaisLoc<>"BRA"
				@ li,aColuna[12] PSAY SE3->E3_PORC		Picture tm(SE3->E3_PORC,6,nDecPorc)
			Else
				@ li,aColuna[12] PSAY SE3->E3_PORC		Picture tm(SE3->E3_PORC,6)
			Endif
			@ li,aColuna[13] PSAY nComPrt			Picture tm(nComPrt,14,nDecs)
			@ li,aColuna[14] PSAY SE3->E3_BAIEMI

			If ( SE3->E3_AJUSTE == "S" .And. MV_PAR07==1)
				@ li,aColuna[15] PSAY STR0018 //"AJUSTE "
			EndIf
			

			cFRETMB	:=	(cAlias)->TIPOFRETE
			
			@ li,aColuna[16] PSAY POSICIONE("SC5",1,XFILIAL("SC5")+SE3->E3_PEDIDO,"SC5->C5_TPFRETE")+"-"+ cFRETMB
//			@nLin,160 Psay TRA->C5_TPFRETE +"-"+ cFRETMB
		
			li++
			// Imprime titulos que deram origem ao titulo gerado por liquidacao
			If mv_par13 == 1
				For nI := 1 To Len(aLiquid)
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					EndIF
					If nI == 1
						@ ++li, 0 PSAY __PrtThinLine()
						@ ++li, 0 PSAY STR0023 +SE1->E1_NUMLIQ // "Detalhes : Titulos de origem da liquida��o "
						@ ++li,10 PSAY STR0024 // "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida��o      Valor Base Liq."
//         Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida��o      Valor Base Liq.
//         XXX        XXXXXXXXXXXX    XXX     XXXX    XXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999999999999     99/99/9999          999999999999999      999999999999999 
   					@ ++li, 0 PSAY __PrtThinLine()
						li++
					Endif
					cDocLiq  := SE1->E1_NUMLIQ
					SE1->(MsGoto(aLiquid[nI]))
					SA1->(MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
					@li,  10 PSAY SE1->E1_PREFIXO
					@li,  21 PSAY SE1->E1_NUM
					@li,  37 PSAY SE1->E1_PARCELA
					@li,  45 PSAY SE1->E1_TIPO
					@li,  53 PSAY SE1->E1_CLIENTE
					@li,  64 PSAY SE1->E1_LOJA
					@li,  71 PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
					@li, 111 PSAY SE1->E1_VALOR PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					@li, 132 PSAY aValLiq[nI,1] 
					@li, 151 PSAY aValLiq[nI,2] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					@li, 172 PSAY aLiqProp[nI] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					li++
				Next
				// Imprime o separador da ultima linha
				If Len(aLiquid) >= 1
					@ li++, 0 PSAY __PrtThinLine()
				Endif
			Endif	
		EndIf
		nAc1 += nBasePrt
		nAc2 += nComPrt
		If cTitulo <> SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO+SE3->E3_VEND+SE3->E3_CODCLI+SE3->E3_LOJA  .And. Empty(cDocLiq)
			nAc3   += nVlrTitulo
			cTitulo:= SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO+SE3->E3_VEND+SE3->E3_CODCLI+SE3->E3_LOJA
			cDocLiq:= ""
		EndIf
		
		dbSelectArea("SE3")
		dbSkip()
	EndDo
	
	If mv_par12 == 1
		li++
	
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li, 00  PSAY OemToAnsi(STR0013)+cDescVend  //"TOTAL DO VENDEDOR --> "
		@ li,aColuna[10]-1  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,aColuna[11]-1  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
	
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, aColuna[12] PSAY (nAc2/nAc1)*100   PicTure "999.99"
			Else
				@ li, aColuna[12] PSAY NoRound((nAc2/nAc1)*100)   PicTure "999.99"
			Endif
		Endif
	
		@ li, aColuna[13]-1  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		li++
	
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			nAc4 += (nAc2 * mv_par10 / 100)				
			@ li, aColuna[13]-1  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi(STR0017)  //"TOTAL (-) IR      --> "
			@ li, aColuna[13]-1 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
			li ++
		EndIf
	
		@ li, 00  PSAY __PrtThinLine()

		If mv_par11 == 1  // Quebra pagina por vendedor (padrao)
			li := 60  
		Else
		   li+= 2
		Endif
	Else
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li,048  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,065  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, 081 PSAY (nAc2/nAc1)*100   PicTure "999.99"
			Else
				@ li, 081 PSAY NoRound((nAc2/nAc1)*100)   PicTure "999.99"
			Endif
		Endif
		@ li, 089  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			nAc4 += (nAc2 * mv_par10 / 100)
			@ li, 105  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			@ li, 121 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
		EndIf
		li ++
	EndIf
	
	dbSelectArea("SE3")
	nAg1 += nAc1
	nAg2 += nAc2
 	nAg3 += nAc3
 	nAg4 += nAc4
EndDo

If (nAg1+nAg2+nAg3+nAg4) != 0
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif

	If mv_par12 == 1
		@li,  00 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
		@li, aColuna[10]-1 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li, aColuna[11]-1 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li, aColuna[12] PSAY (nAg2/nAg1)*100 Picture "999.99"
		Else
			@li, aColuna[12] PSAY NoRound((nAg2/nAg1)*100) Picture "999.99"
		Endif
		@li, aColuna[13]-1 PSAY nAg2 Picture tm(nAg2,15,nDecs)
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
			li ++
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			@ li, 175  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi(STR0017)  //"TOTAL (-) IR       --> "
			@ li, 175  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	Else
		@li,000  PSAY __PrtThinLine()
		li ++
		@li,000 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
		@li,048 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li,065 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li,081 PSAY (nAg2/nAg1)*100 Picture "999.99"
		Else
			@li,081 PSAY NoRound((nAg2/nAg1)*100) Picture "999.99"
		Endif
		@li,089 PSAY nAg2 Picture tm(nAg2,15,nDecs)
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
			@ li,105  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			@ li,121  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	EndIf
	roda(cbcont,cbtxt,"G")
EndIF
    
#IFDEF TOP
	If TcSrvType() != "AS/400"
  		dbSelectArea("SE3")
		DbCloseArea()
		chkfile("SE3")
	Else	
#ENDIF
		fErase(cNomArq+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

//��������������������������������������������������������������Ŀ
//� Restaura a integridade dos dados                             �
//����������������������������������������������������������������
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
dbClearFilter()

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Ana Paula N. Silva  � Data �  20/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATR540                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()
local aHelpPor := {}
local aHelpEng := {}
local aHelpSpa := {}
local aAreaSX1 := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)

DbSeek(PadR("MTR540",Len(SX1->X1_GRUPO)) + "09")
RecLock("SX1",.F.)
Replace X1_PRESEL With 1
Replace X1_DEF01 With "N�o"
Replace X1_DEFSPA1 With "No"
Replace X1_DEFENG1 With "No" 

Replace X1_DEF02 With " "
Replace X1_DEFSPA2 With " "
Replace X1_DEFENG2 With " " 

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
AADD(aHelpPor,'Indica que n�o ser� impresso')
AADD(aHelpPor,'comiss�es zeradas.')
AADD(aHelpSpa,'Indica que no se imprimir�n') 
AADD(aHelpSpa,'comisiones en cero.')
AADD(aHelpEng,'Indicates the system will not')
AADD(aHelpEng,'print commissions zeroed.')
                                                             

PutSX1Help("P.MTR54009.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
AADD(aHelpPor,'Informe os c�digos dos vendedores dos ')
AADD(aHelpPor,'quais se deseja emitir a rela��o de ')
AADD(aHelpPor,'comiss�es.')
AADD(aHelpPor,'Tecla [F3] dispon�vel para consultar ')
AADD(aHelpPor,'o Cadastro de Vendedores.')
AADD(aHelpEng,'Informe os c�digos dos vendedores dos ')
AADD(aHelpPor,'quais se deseja emitir a rela��o de ')
AADD(aHelpPor,'comiss�es.')
AADD(aHelpEng,'Tecla [F3] dispon�vel para consultar ')
AADD(aHelpEng,'o Cadastro de Vendedores.')
AADD(aHelpSpa,'Informe os c�digos dos vendedores dos ')
AADD(aHelpPor,'quais se deseja emitir a rela��o de ')
AADD(aHelpPor,'comiss�es.')
AADD(aHelpSpa,'Tecla [F3] dispon�vel para consultar ')
AADD(aHelpSpa,'o Cadastro de Vendedores.')
PutSX1Help("P.MTR540P9R104.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
AADD(aHelpPor,'Informe se saltar� por vendedor.')
AADD(aHelpSpa,'Informe se saltar� por vendedor.') 
AADD(aHelpEng,'Informe se saltar� por vendedor.')
PutSX1Help("P.MTR540P9R109.",aHelpPor,aHelpEng,aHelpSpa)
      
SX1->(MsUnLock())
RestArea(aAreaSX1)

Return
