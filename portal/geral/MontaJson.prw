#Include "Protheus.ch"
#Include "Apwebex.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"



Webuser function fxJson()
local xcHtml	:=	''
local xaRetProc	:=	{}


xaRetProc	:=	TCSPEXEC("montaJson", 'a')


web EXTENDED init xcHtml
xcHtml += '[{"titulo":"JSON x XML",'
xcHtml += '"resumo":"o duelo de dois modelos de representação de informações",'
xcHtml += '"ano":2012,'
xcHtml += '"genero":"teste"},{"titulo":"JSON James",'
xcHtml += '"resumo":"a história de uma lenda do velho oeste",'
xcHtml += '"ano":2012,'
xcHtml += '"genero":"western"}]'
xcHtml	:=	xaRetProc[1]
web EXTENDED end

return xcHtml