#INCLUDE "RWMAKE.CH"

//////////////////////////////////////
User Function fOpenXLS(cArqTrb)
//////////////////////////////////////

Local cDirDocs   := MsDocPath()
Local cPath		 := AllTrim(GetTempPath())
Local oExcelApp

FErase(cPath+cArqTrb)

CpyS2T( "\SYSTEM\"+cArqTrb , cPath, .T. )

If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()                                         
oExcelApp:WorkBooks:Open( cPath+cArqTrb ) // Abre uma planilha
oExcelApp:SetVisible(.T.)                                           

Return()

