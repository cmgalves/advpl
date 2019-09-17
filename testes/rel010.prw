#INCLUDE 'protheus.ch'
#INCLUDE 'topconn.ch'

User Function ImpGTRel01()
	Private oReport := Nil
	Private oSecCab := Nil
	Private cPerg   := PadR("RCOMR01", Len(SX1->X1_GRUPO))
	
	PutSx1(cPerg,"01","Código de?"  ,'','',"mv_ch1","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Código ate?" ,'','',"mv_ch2","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
	
	ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	oReport := TReport():New("RCOMR01","Cadastro de Produtos",cPerg,{|oReport| PrintReport(oReport)},"Impressão de cadastro de produtos em TReport simples.")
	oReport:SetLandscape(.T.)
	
	oSecCab := TRSection():New( oReport , "Produtos", {"QRY"} )
	
	TRCell():New( oSecCab, "B1_COD"     , "QRY")
	TRCell():New( oSecCab, "B1_DESC"    , "QRY")
	TRCell():New( oSecCab, "B1_TIPO"    , "QRY")
	TRCell():New( oSecCab, "B1_UM"      , "QRY")
	
	TRFunction():New(oSecCab:Cell("B1_COD"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)
Return

Static Function PrintReport(oReport)
	Local cQuery := Nil
	cQuery += " SELECT " + CRLF
	cQuery += "     SB1.B1_COD " + CRLF
	cQuery += "    ,SB1.B1_DESC " + CRLF
	cQuery += "    ,SB1.B1_TIPO " + CRLF
	cQuery += "    ,SB1.B1_UM " + CRLF
	cQuery += "  FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial ("SB1") + "' " + CRLF
	cQuery += "   AND SB1.B1_COD    BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF
	cQuery += "   AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery := ChangeQuery(cQuery)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbCloseArea())
	EndIF
	
	TcQuery cQuery New Alias "QRY"
	
	oSecCab:BeginQuery()
	oSecCab:EndQuery({{"QRY"},cQuery}))
	oSecCab:Print()
Return