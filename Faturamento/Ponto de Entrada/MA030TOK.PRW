#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

user function MA030TOK()
	local xlRet	 	:= .T.
	local xnRet		:=	0
	local xcSufr	:=	SuperGetMV('MB_ESTSUFR', .F., .F.)
	local xcR		:=	Char(13) + Char(10)
	
	if M->A1_EST $ xcSufr
		xnRet := Aviso( "AVISO -- ESTADOS SUFRAMA", ;
			'O Estado: ' + M->A1_EST + ' faz parto do SUFRAMA.' + xcR + ;
			'Deseja Continuar?', { "Sim", "Não"}, ;
			3, "CUIDADO!!!! IMPORTANTE.",, '', .F., 50000 )
		If xnRet == 1
			xlRet := .T.
		elseif xnRet == 2
			xlRet := .F.
		endif
	endif

	if altera	
		if 	SA1->A1_VEND <> M->A1_VEND .OR. ;
			SA1->A1_TAB1 <> M->A1_TAB1 .OR. ;
			SA1->A1_TAB2 <> M->A1_TAB2 .OR. ;
			SA1->A1_TAB3 <> M->A1_TAB3 .OR. ;
			SA1->A1_TAB4 <> M->A1_TAB4 .OR. ;
			SA1->A1_TABELA <> M->A1_TABELA .OR. ;
			SA1->A1_XTAB6 <> M->A1_XTAB6 .OR. ;
			SA1->A1_XTAB7 <> M->A1_XTAB7 .OR. ;
			SA1->A1_XTAB8 <> M->A1_XTAB8 .OR. ;
			SA1->A1_XTAB9 <> M->A1_XTAB9 .OR. ;
			SA1->A1_XPRXMEN <> M->A1_XPRXMEN

			Reclock("SA1",.F.)
				SA1->A1_VEND := M->A1_VEND
				SA1->A1_TAB1 := M->A1_TAB1
				SA1->A1_TAB2 := M->A1_TAB2
				SA1->A1_TAB3 := M->A1_TAB3
				SA1->A1_TAB4 := M->A1_TAB4
				SA1->A1_TABELA := M->A1_TABELA
				SA1->A1_XTAB6 := M->A1_XTAB6
				SA1->A1_XTAB7 := M->A1_XTAB7
				SA1->A1_XTAB8 := M->A1_XTAB8
				SA1->A1_XTAB9 := M->A1_XTAB9
				SA1->A1_XPRXMEN := M->A1_XPRXMEN
			SA1->(MsUnlock())


			expClientes()
		EndIf
	EndIf

return xlRet


//função para pegar os dados do SQL
static function expClientes()
	local xcQuery		:=	""
	local xcR			:=	Char(13) + Char(10)
	
	xcQuery := 			"SELECT  "
	xcQuery += xcR + 	"	* " 
	xcQuery += xcR + 	"FROM " 
	xcQuery += xcR + 	"	guaraniExportaClientes "
	xcQuery += xcR + 	"WHERE "
	xcQuery += xcR + 	"	FILTRO LIKE '%"+ALLTRIM(M->A1_VEND)+"%' "

	//trecho comum do programa
	if select("XTRB") > 0
		XTRB->(dbclosearea())
	endif


	//Gera o Arquivo de Trabalho
	TcQuery StrTran(xcQuery,xcR,"") New Alias XTRB


	geraFile()
return


//função para gerar o arquivo
static Function geraFile()
local cDir		:=	"\expGuarani\"
local cArq		:=	"CLIENTES.txt"
local nHandle	:=	FCreate(cDir+cArq)

If nHandle < 0
	MsgAlert("Erro durante criação do arquivo.")
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	XTRB->(dbGoTop())
	While !(XTRB->(EOF()))
		FWrite(nHandle, XTRB->CLIENTES + CRLF)
		XTRB->(dbSkip())
	Enddo

	XTRB->(dbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FClose(nHandle)
EndIf
mandaFile()
Return



static function mandaFile()	
	 
	local cServidor	:=	'3.214.102.43'
	local nPortFtp	:=	21 // Porta Padrão FTP
	local cUsuftp	:=	'mbftp'
	local cSenhaftp	:=	''
	local xcDirDest	:=	''
	
	cSenhaftp := 'FTPpl25ticos'
	xcDirDest := 'out/' + ALLTRIM(M->A1_VEND)


	FTPDisconnect()

	If FTPConnect( cServidor, nPortFtp, cUsuftp, cSenhaFTP, .t. )// Conecta FTP
		If FTPDirChange(xcDirDest) //Seleciona Diretorio no FTP
			If !FTPUPLOAD( '\expGuarani\clientes.txt', 'CLIENTES.TXT' )
				Alert( 'Problemas ao copiar arquivo!' )
			EndIf
		EndIf
	EndIf
	
	FTPDisconnect()
Return NIL