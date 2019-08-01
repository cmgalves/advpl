#INCLUDE "PROTHEUS.CH"



User function MBRFAT03()

/*Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf*/

return

/*Static Function ReportDef()
Local oReport
Local oSection

oReport := TReport():New("MBRFAT03","Relatório de vendas x cotas dos vendedores",{||perg()},{|oReport| PrintReport(oReport)},"Este relatorio  ira imprimir as vendas x cotas dos vendedores da plastico MB")
*/
//oSection := TRSection():New(oReport,"",{"TSC5"})
  //	TRCell():New(oSection,"C5_VEND1","TSC5","Vendedor")
//	TRCell():New(oSection,"NOME",NIL,"Nome" ,/*Picture*/,TamSx3("A3_NOME")[1]	,/*lPixel*/,{|| posicione("SA3",xFilial("SA3")+TSC5->C5_VEND1,"A3_NOME") } )
  //	TRCell():New(oSection,"UF"  ,NIL,"Estado" ,/*Picture*/,TamSx3("A3_EST")[1]	,/*lPixel*/,{|| posicione("SA3",xFilial("SA3")+TSC5->C5_VEND1,"A3_EST") } )
   //	TRCell():New(oSection,"COTA",NIL)
//	TRCell():New(oSection,"VENDAS",NIL,"Vendas" ,/*Picture*/,nil,/*lPixel*/,{||  })
//	TRCell():New(oSection,"PORCENT",NIL,,"%VEND" ,/*Picture*/,nil,/*lPixel*/,{||  }))
//	TRCell():New(oSection,"FAT",NIL,,"Faturado" ,/*Picture*/,nil,/*lPixel*/,{||  }))
	
	
//Return oReport


static function printReport(oReport)
local oSection := oReport:section(1)
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
AADD(aParBox,{1,"Data de "			,	ctod("/ /")						,	"",				"",	""			,		"",	40,	.F.	})
AADD(aParBox,{1,"Data ate "			,	ctod("/ /")						,	"",				"",	""			,		"",	40,	.F.	})
ParamBox(aParBox,"Infome os parâmetros",nil,/*bOk*/, /*aButtons*/, /*lCentered*/,/*nPosx*/, /*nPosy*/, /*oMainDlg*/, /*cLoad*/"MBRFAT02", /*lCanSave*/.T., /*lUserSave*/.T.) 


Return

static function query()
local cSql   := "" 

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

