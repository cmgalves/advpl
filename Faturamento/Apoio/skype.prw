#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} UASKYPE
Comando Skype

@author		Eurai Rapelli
@since 		12/04/2015

@Link		http://tdn.totvs.com/display/tec/ShellExecute
/*/
User Function UASKYPE(xcTxt)
local oDlg		:= Nil
local oChat		:= Nil
local oFechar	:= Nil
local oMsgBar01	:= Nil 
local oMsgItem01:= Nil
local oPnlItens	:= Nil
local cGet01	:= Space(100)
local oSay01	:= Nil
Private oFont12a	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)

cGet01 := 'fiscal3.mb'
CopytoClipboard ( xcTxt )

xcTxt += ' ------  Enviar Mensagem via Skype'

oDlg		:= MSDialog():New( 000,000,250,400,"Skype",,,.F.,,,,,,.T.,,,.T. )

oMsgBar01	:= TMsgBar():New(oDlg, "Cláudio Alves", .F.,.F.,.F.,.F.,RGB(116,116,116),,oFont12a,.F.)
oMsgItem01	:= TMsgItem():New( oMsgBar01,'www.plasticosmb.com.br', 100,oFont12a,CLR_WHITE,,.T., {|| ShellExecute('OPEN','www.plasticosmb.com.br','','', 3 ) } )   


oPnlItens		:= TPanel():NEW( 000, 000, "", oDlg, , .T., , CLR_BLUE, , 000, 000, .T., .T.)
oPnlItens:Align	:= CONTROL_ALIGN_ALLCLIENT

oSay01 	:= TSay():New( 010,005,{|| xcTxt },oPnlItens,,,.F.,.F.,.F.,.T.,,,550,008)
//oGet01 	:= TGet():New( 010,005,bSETGET(xcTxt),oPnlItens,150,010,"",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

// oLigar 	:= TButton():New( 030, 050, "Ligar"			, oPnlItens, { || ShellExecute( "Open", "skype:"+AllTrim(cGet01)+"?call", "NULL", "C:\", 1 ) }, 040, 030, , , .F., .T., .F., , .F., , , .F. )
oChat	:= TButton():New( 030, 050, "Chat"			, oPnlItens, {|| ShellExecute( "Open", "skype:"+AllTrim(cGet01)+"?chat", "NULL", "C:\", 1 ) }, 040, 030, , , .F., .T., .F., , .F., , , .F. )
oFechar	:= TButton():New( 030, 100, "Fechar"		, oPnlItens, {|| oDlg:End() }, 040, 030, , , .F., .T., .F., , .F., , , .F. )



oDlg:Activate(,,,.T.)  

Return( Nil )