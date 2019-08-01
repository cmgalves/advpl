#include "protheus.ch"
#include "msobjects.ch"
#include "topconn.ch"
#include "rwmake.ch"
#INCLUDE "OLECONT.CH"
#include "tbiconn.ch"
#Include "Fileio.ch"
#INCLUDE "COLORS.CH"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
±±ºPrograma  ³ MBGERAREQ ºAutor  ³ Adriano Góes       º Data ³  17/03/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     ³ GERA REQUISIÇÕES PENDETES DE ESTOURO DE PRODUÇÃO              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
*/

User Function MBGERAREQ()

Private cPerg   := "MBGERAREQ2"
Private aLista	:= {}

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	If !Pergunte (cPerg, .T.)
		Return
	EndIf
EndIf
Processa( {|| MBGERAREL() },"Selecionando Registros... Aguarde !" )
Return


Static Function MBGERAREL()

Titulo := "Relatório de Requisições de estouro não geradas"
Define MsDialog oDlga Title "Relatório de Requisições de estouro não geradas" From 0,0 To 080,300 Pixel
Define Font oBold Name "Arial" Size 0,-13 Bold
@ 010,005 Button "Gera Requisições"      	Size 43,13 Pixel Of oDlga Action Processa( { ||Excel1() } )
//@ 010,055 Button "Imprimir"		      	Size 43,13 Pixel Of oDlga Action Processa( { ||ImpRelATF1() } )
@ 010,105 Button "Sair"     				  	Size 43,13 Pixel Of oDlga Action oDlga:End()
Activate MsDialog oDlga Centered

Ms_Flush()

Return



Static Function Excel1(aLista)
Local dDataDe := mv_par01
Local dDataAte := mv_par02
Local cFileErr := "MBGERAREQ"+Dtos(dDataBase)+StrTran(Time(),":","")+".txt"
Local lErro := .F.
aHeader	:= {}
aCols		:= {}
aAux		:= {}
                  
nHdl := FCreate( cFileErr )

aAdd(aHeader, {" "					, "" , "@!", 01 , 0,".f.",,,})
aAdd(aHeader, {" Relatório de Posição Analítica Ativo -  Período: "+dtoc(mv_par01)+" a "+dtoc(mv_par02)	, "" , "@!", 100 , 0,".f.",,,})
aAdd(aHeader, {" "					, "" , "@!", 01 , 0,".f.",,,})
aAdd(aHeader, {" "					, "" , "@!", 01 , 0,".f.",,,})

aAdd(aAux,"COD PRODUTO")
aAdd(aAux,"QUANTIDADE")
aAdd(aAux,"OP ")
aAdd(aAux,"DATA ")


Aadd(aAux,.F.)
Aadd(aCols,aAux)

aModuloReSet := SetModulo( "SIGAPCP", "PCP" )



cQuery := "SELECT D3_COD,D3_QUANT,D3_NUMSEQ,D3_OP,D3_EMISSAO,D3_IDENT,D3_ZZIDINT,D3_DOC "
cQuery += "FROM "+RetSqlName("SD3")+" "
cQuery += "WHERE D3_TM = '012' AND D3_EMISSAO >='"+DTOS(MV_PAR01)+"' AND D3_EMISSAO <='"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ <> '*' AND D3_OP >= '"+MV_PAR03+"' AND D3_OP <= '"+MV_PAR04+"' "
cQuery += " ORDER BY D3_COD,D3_OP  "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRY', .F., .T.)
QRY->(dbGoTop())
Count To nTotal

ProcRegua(nTotal)

QRY->(dbGoTop())

aItens:={}

While !EOF()
	cQuery := "SELECT D3_COD"
	cQuery += " FROM "+RetSqlName("SD3")
	cQuery += " WHERE"
	cQuery += " SUBSTRING(D3_COD,1,3) <> 'MOD' AND"
	cQuery += " D3_TM <> '012' AND"
	cQuery += " D3_NUMSEQ = '"+QRY->D3_NUMSEQ+"' AND"
	cQuery += " D_E_L_E_T_ <> '*'"
	              
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRY2', .F., .T.)
	QRY2->(dbGoTop())
	Count To nTotal
	dDataC2:=stod(" ")
	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(xFilial("SC2")+QRY->D3_OP,.F.)
		RecLock("SC2",.f.)
		dDataC2:=C2_DATRF
		Replace C2_DATRF With stod(" ")
		MsUnlock()
	Endif
	
	If nTotal == 0               
		//Apaga requisicoes realizadas por execucoes anteriores dessa rotina
		U_MBESTREQ(QRY->D3_OP,dDataDe,dDataAte)
		//
		DbSelectArea("SD4")
		DbSetOrder(2)
		DbSeek(xFilial("SD4")+QRY->D3_OP,.F.)
		While !EOF() .AND. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+QRY->D3_OP 
			If Subst(D4_COD,1,3) <> "MOD"
				nQtdEst:=0
				DbSelectArea("SG1")
				DbSetOrder(1)
				If DbSeek(xFilial("SG1")+QRY->D3_COD+SD4->D4_COD,.F.)
					nQtdEst:=SG1->G1_QUANT
				Endif
				
				//					             cOpx	 :=alltrim(cOpx)+space(13-len(alltrim(cOpx)))
				//						         cComp	 :=SD4->D4_COD
				nQuant :=nQTdEst*QRY->D3_QUANT
				//					         nQtdPr :=(nQuant/cQtdSC2)*nQtd
				cLocReq:=SD4->D4_LOCAL
				
				
				aApont:= {{"D3_TM","504",NIL},;
				{"D3_OP", QRY->D3_OP ,NIL},;
				{"D3_LOCAL",cLocReq,NIL},;	  //pegar do SD4
				{"D3_COD",SD4->D4_COD,NIL},;
				{"D3_CF","RE1" ,NIL},;
				{"D3_DOC", QRY->D3_DOC ,NIL},;
				{"D3_EMISSAO",stod(QRY->D3_EMISSAO),NIL},;
				{"D3_QUANT",nQuant,NIL}}
				
				
				/*
				{"D3_IDENT",QRY->D3_IDENT,NIL},;
				{"D3_NUMSEQ",QRY->D3_NUMSEQ,NIL},;
				{"D3_ZZIDINT"		,QRY->D3_ZZIDINT		,NIL},;
				
				*/
				
				lMsErroAuto := .f.
				MSExecAuto({|x,y| mata240(x,y)},aApont,3) //Inclusao
				If lMsErroAuto
					cNomArqErro := NomeAutoLog()
					IF (nHandle := FOPEN(cNomArqErro)) >= 0
						// Pega o tamanho do arquivo
						nLength := FSEEK(nHandle, 0, FS_END)
						fSeek(nHandle,0,0)   
						cString := "OP: "+QRY->D3_OP+Chr(13)+Chr(10) 
						cString += "MP: "+SD4->D4_COD+Chr(13)+Chr(10) 
						cString += FREADSTR(nHandle, nLength)+Chr(13)+Chr(10)+Replicate("*",100)+Chr(13)+Chr(10)
						lErro := .T.
						FWrite( nHdl,  cString, Len( cString ) )
						//Alert(cString)
						//ALERT(QRY->D3_OP+" "+SD4->D4_COD)
						FCLOSE(nHandle)
					Endif
					
					FERASE(cNomArqErro)
					
				Else
					RecLock("SD3",.F.)
					SD3->D3_USUARIO := "MBGERAREQ"
					MsUnlock()
				Endif
				
			Endif
			DbSelectArea("SD4")
			DbSkip()
		Enddo
		
		
		//	aAdd(aItens,chr(160)+QRY->D3_COD)
		//	aAdd(aItens,QRY->D3_QUANT)
		//aAdd(aItens,chr(160)+QRY->D3_OP)
		//aAdd(aItens,stod(QRY->D3_EMISSAO))
	Endif
	cQuery := "SELECT D3_COD "
	cQuery += "FROM "+RetSqlName("SD3")+" "
	cQuery += "WHERE D3_NUMSEQ = '"+QRY->D3_NUMSEQ+"' AND D_E_L_E_T_ <> '*' AND D3_COD = 'MOD10204'  "
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRY3', .F., .T.)
	QRY3->(dbGoTop())
	Count To nTotal
	If nTotal == 0
		nQtdEst:=0
		DbSelectArea("SG1")
		DbSetOrder(1)
		If DbSeek(xFilial("SG1")+QRY->D3_COD+"MOD10204",.F.)
			nQtdEst:=SG1->G1_QUANT
		Endif
		
		
		nQuant :=nQTdEst*QRY->D3_QUANT
		cLocReq:="01"//SD4->D4_LOCAL
		aApont:= {{"D3_TM","504",NIL},;
		{"D3_OP", QRY->D3_OP ,NIL},;
		{"D3_LOCAL",cLocReq,NIL},;	  //pegar do SD4
		{"D3_COD","MOD10204",NIL},;
		{"D3_CF","RE1" ,NIL},;
		{"D3_DOC", QRY->D3_DOC ,NIL},;
		{"D3_EMISSAO",stod(QRY->D3_EMISSAO),NIL},;
		{"D3_QUANT",nQuant,NIL}}
		
		
		lMsErroAuto := .f.
		MSExecAuto({|x,y| mata240(x,y)},aApont,3) //Inclusao
		If lMsErroAuto
			cNomArqErro := NomeAutoLog()
			IF (nHandle := FOPEN(cNomArqErro)) >= 0
				// Pega o tamanho do arquivo
				nLength := FSEEK(nHandle, 0, FS_END)
				fSeek(nHandle,0,0)
				cString := FREADSTR(nHandle, nLength)
				Alert(cString)
				FCLOSE(nHandle)
			Endif
			
			FERASE(cNomArqErro)
			
		Endif
		
	Endif
	
	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(xFilial("SC2")+QRY->D3_OP,.F.)
		RecLock("SC2",.f.)
		Replace C2_DATRF With dDataC2
		MsUnlock()
	Endif
	
	DbSelectArea("QRY2")
	DbCloseArea("QRY2")
	DbSelectArea("QRY3")
	DbCloseArea("QRY3")
	
	DbSelectarea("QRY")
	DbSkip()
	IncProc()
Enddo
//Jogar no aCols os dados
//			J:=1
//			While J < len(aItens)
//			aAux2	:={}
//			For I = j to j+len(aHeader)-1
//			Aadd(aAux2,aItens[I])

//	Next
//		Aadd(aAux2,.F.)
//	Aadd(aCols,aAux2)
//J:=J+len(aHeader)
//			Enddo

//Chamar a Rotina
//	DlgToExcel({{"GETDADOS","",aHeader,aCols}})

If lErro
	If !lIsDir("C:\MBGERAREQ")
		MontaDir("C:\MBGERAREQ")
	Endif  
	FClose( nHdl )
	__CopyFile( cFileErr , "C:\MBGERAREQ\"+cFileErr )
Else
	FClose( nHdl )
EndIf

Ferase(cFileErr)

DbCloseArea("QRY")
oDlga:End()
ReSetModulo( aModuloReSet )

Return

Static Function ValidPerg(cPerg)
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,len(x1_grupo))
aAdd(aRegs,	{cPerg,	"01", "Data De?					 "  , "", "", "mv_ch1", "D", 08, 2, 0, "G", ""	, "MV_PAR01", "","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,	{cPerg,	"02", "Data Até?			 	 "  , "", "", "mv_ch2", "D", 08, 2, 0, "G", ""	, "MV_PAR02", "","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,	{cPerg,	"03", "OP De?			 		 "  , "", "", "mv_ch3", "C", 11, 0, 0, "G", ""	, "MV_PAR03", "","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,	{cPerg,	"04", "OP Até?			 		 "  , "", "", "mv_ch4", "C", 11, 0, 0, "G", ""	, "MV_PAR04", "","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return

