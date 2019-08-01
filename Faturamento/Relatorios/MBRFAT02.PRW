#INCLUDE "PROTHEUS.CH"



User function MBRFAT02()
Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

return

Static Function ReportDef()
Local oReport
Local oSection

oReport := TReport():New("MBRFAT02","Relatório de Pedidos",{||perg()},{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir os faturamentos da plastico MB")

oSection := TRSection():New(oReport,"",{"TSC5"})
	TRCell():New(oSection,"C5_VEND1","TSC5","Vendedor")
	TRCell():New(oSection,"NOME",NIL,"Nome" ,/*Picture*/,TamSx3("C6_VALOR")[1]	,/*lPixel*/,{|| posicione("SA3",xFilial("SA3")+TSC5->C5_VEND1,"A3_NOME") } )
oSection1 := TRSection():New(oSection,"",{"TSC5"})
	TRCell():New(oSection1,"C5_EMISSAO","TSC5")
	TRCell():New(oSection1,"C5_NUM"		,"TSC5")
	TRCell():New(oSection1,"C5_CLIENTE","TSC5")
	TRCell():New(oSection1,"C5_LOJACLI","TSC5")
	TRCell():New(oSection1,"NOME"		,NIL,"Nome"				,/*Picture*/,TamSx3("A1_NOME")[1]	,/*lPixel*/,{|| posicione("SA1",1,xFilial("SA1")+TSC5->C5_CLIENTE+TSC5->C5_LOJACLI,"A1_NOME") }) 
	TRCell():New(oSection1,"CIDADE"		,NIL,"Cidade/Sp"		,/*Picture*/,TamSx3("A1_BAIRRO")[1]	,/*lPixel*/,{|| AllTrim(posicione("SA1",1,xFilial("SA1")+TSC5->C5_CLIENTE+TSC5->C5_LOJACLI,"A1_MUN"))+"/"+posicione("SA1",1,xFilial("SA1")+TSC5->C5_CLIENTE+TSC5->C5_LOJACLI,"A1_EST") }) 
	TRCell():New(oSection1,"EMISSAO"	,NIL,"Dat. Fat"		    ,/*Picture*/,TamSx3("F2_EMISSAO")[1]	,/*lPixel*/,{|| posicione("SF2",1,xFilial("SF2")+TSC5->C5_NOTA,"F2_EMISSAO") }) 
	TRCell():New(oSection1,"C5_NOTA"    ,"TSC5")
	TRCell():New(oSection1,"VALOR"	    ,NIL,"Valor"		    ,/*Picture*/,TamSx3("C6_VALOR")[1]	,/*lPixel*/,{|| queryTotal(TSC5->C5_NUM) }) 
	
oBreak := TRBreak():New(oSection,oSection:Cell("C5_VEND1"),"Total Vendedores") 
TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM",oBreak)

Return oReport


static function printReport(oReport)
local oSection := oReport:section(1)
local oSection1 := oReport:section(1):section(1)
local cVend := ""   
Local lFinish := .F.

query()

while TSC5->(!EOF())
	If oReport:Cancel() 
  		Exit 
 	EndIf 
 	if cVend !=TSC5->C5_VEND1
 		if lFinish
 			oSection:finish()
 			oSection1:finish()
 		endif
 		oSection:init()
 		cVend :=TSC5->C5_VEND1
 		oSection:printLine()
 		lFinish := .T.
 	endIf                                                                        
    oSection1:init()
    oSection1:printLine()


TSC5->(dbSkip())
endDo

if lFinish
	oSection:finish()
	oSection1:finish()
endif
TSC5->(dbCloseArea())

return 


static function Perg()
Local aParBox :={}
AADD(aParBox,{1,"Vendedor de "		,	Space(TamSx3("A3_COD")[1])		,	"",				"",	""			,		"",	40,	.F.	})
AADD(aParBox,{1,"Vendedor ate "		,	Space(TamSx3("A3_COD")[1])		,	"",				"",	""			,		"",	40,	.F.	})
AADD(aParBox,{1,"Data de "			,	ctod("/ /")						,	"",				"",	""			,		"",	40,	.F.	})
AADD(aParBox,{1,"Data ate "			,	ctod("/ /")						,	"",				"",	""			,		"",	40,	.F.	})
AADD(aParBox,{2,"Pedidos"			,	"3"								,{"1=Faturados","2=Não faturados","3=Ambos"}	  ,50		,""		  ,.F.})
ParamBox(aParBox,"Infome os parâmetros",nil,/*bOk*/, /*aButtons*/, /*lCentered*/,/*nPosx*/, /*nPosy*/, /*oMainDlg*/, /*cLoad*/"MBRFAT02", /*lCanSave*/.T., /*lUserSave*/.T.) 


Return

static function query()
local cSql   := "" 
local cOpc   := iif(type("MV_PAR05")=="N",cValtoChar(MV_PAR05),MV_PAR05)

if cOpc == "1"
	cSql := "% AND C5_NOTA != ''  %"
else 
	cSql := "% AND C5_NOTA = ''  %"
endif	



BeginSql Alias "TSC5"
	COLUMN C5_EMISSAO AS DATE
	SELECT  C5_EMISSAO ,
			C5_NUM, 
			C5_CLIENTE , 
			C5_LOJACLI, 
			C5_NOTA,
			C5_VEND1
	FROM %TABLE:SC5%
	WHERE C5_FILIAL = %xFilial:SC5% AND 
	      C5_EMISSAO BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04% AND 
	      C5_VEND1 BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%  AND 
	      %NOTDEL% %EXP:cSQL%
    ORDER BY C5_VEND1 ASC
endSql

return 

static function queryTotal(cPedido)
local nRet := 0

BeginSql Alias "TSC6"
	SELECT SUM(C6_VALOR) AS VALOR FROM %TABLE:SC6% 	WHERE C6_FILIAL = %XFILIAL:SC6% AND C6_NUM=%EXP:CPEDIDO% AND %NOTDEL%
endSql
nRet := TSC6->VALOR
TSC6->(dbCloseArea())	


return nRet