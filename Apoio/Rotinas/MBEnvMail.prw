#INCLUDE "Ap5Mail.ch"

//#INCLUDE "rwmake.ch"
//#INCLUDE "TopConn.ch"
//#include "tbiconn.ch"
//#include "tbicode.ch"

//User Function ENVIAEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)
User Function MBEnvMail(cTitulo,cDestina,cCco,cMensagem,Path)
Local _cServer	:=	GetMV("MV_RELSERV")
Local _cUser	:=	GetMV("MV_RELACNT")
Local _cPass	:=	GetMV("MV_RELPSW")
Local lResult		:= .F.
Local cSmtpError	:= ""
Local lAutentica    := GetMV("MV_RELAUTH") 

Local cDestin           := cDestina
Local cTitulo           := cTitulo
Local cMensagem         := cMensagem
Local cAttachment       :=  Path



// Conecta com o Servidor SMTP
CONNECT SMTP ; 
			SERVER _cServer ;   
   			ACCOUNT _cUser ;
			PASSWORD _cPass ;
			RESULT lResult
			
If lResult

	// Verifica se o E-mail necessita de Autenticacao
	if lAutentica    
		MailAuth(_cUser,_cPass)
	endif
	SEND MAIL;
		FROM        _cUser;
		TO          cDestin;
		SUBJECT     cTitulo;
		BODY        cMensagem;
		ATTACHMENT	cAttachment;
		RESULT      lResult

	If lResult
		//MsgStop( "Envio OK" )
	Else  
		GET MAIL ERROR cSmtpError
		MsgSTop( "Erro de envio : " + cSmtpError)
	Endif    
	// Desconecta do Servidor   
	DISCONNECT SMTP SERVER
Else
	_cErro := MailGetErr()
   GET MAIL ERROR cSmtpError
   conout("Erro de conexão /Envio de Email: " + cSmtpError)
Endif

Return

