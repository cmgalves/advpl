#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
#Include "Rwmake.ch"



User Function RGUAA002
	Processa({||AtuNew(),"Atualizando imagens..."})
Return

//Atualiza todos os itens que tem imagens
static function AtuNew()
	local xaFiles := {} // O array receberá os nomes dos arquivos e do diretório	
	local xaSizes := {} // O array receberá os tamanhos dos arquivos e do diretorio
	local xi := 0
	local xcCod := ''
	local xcSeq := ''
	local xmFile, xnRead, imgBuffer

	setaTodos()


	DbSelectArea("PA9")
	DbSetOrder(1)
	DbGotop()

	
	
	ADir("\_fotos\*.*", xaFiles, xaSizes)
 
  // Exibe dados dos arquivos

	For xi := 1 to Len( xaFiles )
		imgBuffer := ''
		xcCod := left(xaFiles[xi], at('_', xaFiles[xi])-1)
		xcSeq := substring(xaFiles[xi], at('_', xaFiles[xi])+1, 1)
		xmFile := Fopen('\_fotos\' + xaFiles[xi],0)
		fSeek(xmFile,0)
		imgBuffer := space(xaSizes[xi])
		xnRead := fRead(xmFile,@imgBuffer,xaSizes[xi])
		fClose(xmFile)
		
		If PA9->(dbSeek(xFilial('PA9') + padr(xcCod, 15) + xcSeq))
			Reclock("PA9",.F.)
				PA9->PA9_BITMAP	:= xaFiles[xi]
				PA9->PA9_MBMP	:= imgBuffer
				PA9->PA9_RANKIN	:= 1
			MsUnlock()
		else
			Reclock("PA9",.T.)
				PA9->PA9_COD	:= xcCod
				PA9->PA9_SEQUEN	:= xcSeq
				PA9->PA9_BITMAP	:= xaFiles[xi]
				PA9->PA9_RANKIN	:= 1
				PA9->PA9_MBMP	:= imgBuffer
			MsUnlock()
		EndIf
		
	Next xi
 
Return

//Verifica os itens que não foram atualizados
static function setaTodos
	Local xcQuery 	:=	''
	xcQuery += "UPDATE PA9010 SET PA9_RANKIN = 0 "
	TCSQLExec(xcQuery)
return

