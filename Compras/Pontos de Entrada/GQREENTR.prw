#INCLUDE "Protheus.ch"  
#Include "rwmake.ch"


User Function GQREENTR()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as Variaveis       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea    :=_aAreaSF4 :=_aAreaSD1 :=_aAreaSB1 :=_aAreaSZZ :={}
Local _cMarca   :=space(20)
Local _cPlaca   :=space(08)
Local _cEspecie :=space(10)
Local _cNumero  :=space(10)
Local _cTransp  :=space(06)
Local _nVolume  := 0
Local _nPBruto  := 0
Local _nPLiqui  := 0
//
//PERSONALIZAÇÃO NFE 2.0
//
Private _cCampo1 := Space(10)
Private _cCampo2 := Space(8)
Private _cCampo3 := Space(30)
Private _cCampo4 := Space(2)
Private _cCampo5 := Space(8)
Private _cCampo6 := Space(3)

Private oCampo1
Private oCampo2
Private oCampo3
Private oCampo4
Private oCampo5
Private oCampo6
//
//FIM PERSONALIZAÇÃO NFE 2.0
//
Private aCod [8]
Private aMsg [8]
Private nVar
aFill (aCod, space (003))		// Inicializa cada um dos 8 elementos do array com o tamanho para os codigos das mensagens.
aFill (aMsg, space (500))		// Inicializa cada um dos 8 elementos do array com o tamanho para os textos das mensagens.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SALVA A AREA DE TRABALHO      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArea  := GetArea ()
_aAreaSF4 := SF4 -> (GetArea ())
_aAreaSD1 := SD1 -> (GetArea ())
_aAreaSB1 := SB1 -> (GetArea ())
_aAreaSZZ := SZZ -> (GetArea ())

If SF1->F1_FORMUL == "S"

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³SALVA AS AREAS DE TRABALHO     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   _cDoc    := SF1->F1_DOC
   _cSerie  := SF1->F1_SERIE
   _cMarca  := space(10)
   _cPlaca  := space(08)
   _cEspecie:= space(10)
   _cNumero := space(10)
   _cTransp := space(6)
   _nVolume := _nPBruto := _nPLiqui := 0

   @ 095,080 To 480,465 Dialog JANELANF Title OemToAnsi("Complementacao de Dados da Nota Fiscal de Entrada")
   @ 020,010 Say OemToAnsi("Marca")
   @ 020,090 Say OemToAnsi("Volumes")
   @ 040,010 Say OemToAnsi("Especie")
   @ 040,090 Say OemToAnsi("Transp.")
   @ 060,010 Say OemToAnsi("P. Bruto")
   @ 060,090 Say OemToAnsi("P. Liquido")
   @ 080,010 Say OemToAnsi("Placa")
   
   //PERSONALIZAÇÃO NFE 2.0
   @ 100,010 Say OemToAnsi('Numero DI')// PIXEL COLORS CLR_HBLUE OF oTela 
   @ 100,090 Say OemToAnsi('Data de Reg.')// PIXEL COLORS CLR_HBLUE OF oTela 
   @ 120,010 Say OemToAnsi('Local Des.') //PIXEL COLORS CLR_HBLUE OF oTela 
   @ 120,090 Say OemToAnsi('UF Desemb.') //PIXEL COLORS CLR_HBLUE OF oTela 
   @ 140,010 Say OemToAnsi('Data Dese.')// PIXEL COLORS CLR_HBLUE OF oTela 
//   @ 140,090 Say OemToAnsi('Pais')// PIXEL COLORS CLR_HBLUE OF oTela 
   //FIM PERSONALIZAÇÃO NFE 2.0
   
   @ 020,040 Get _cMarca   Picture "@!"             SIZE 20,10 Pixel
   @ 020,120 Get _nVolume  Picture "99999"          SIZE 20,10 Pixel
   @ 040,040 Get _cEspecie Picture "@!"             SIZE 40,10 Pixel
   @ 040,120 Get _cTransp  Picture "@!" F3 "SA4"    SIZE 20,10
   @ 060,040 Get _nPBruto  Picture "@E 999,999.999" SIZE 40,10 Pixel
   @ 060,120 Get _nPLiqui  Picture "@E 999,999.999" SIZE 40,10 Pixel
   @ 080,040 Get _cPlaca   Picture "@!"             SIZE 40,10 Pixel
   
   //PERSONALIZAÇÃO NFE 2.0
   @ 100,040 Get _cCampo1 	Picture "@!"			SIZE 40,10  PIXEL Valid !empty(_cCampo1) 
   @ 100,120 Get _cCampo2 	Picture "@R 99/99/9999"	SIZE 40,10  PIXEL Valid DataValida(ctod(_cCampo2)) 
   @ 120,040 Get _cCampo3 	Picture "@!"			SIZE 40,10  PIXEL Valid !empty(_cCampo3) 
   @ 120,120 Get _cCampo4 	Picture "@!"			SIZE 20,10  PIXEL //F3("12") //Valid EXISTCPO("SX5","12"+_cCampo4) 
   @ 140,040 Get _cCampo5 	Picture "@R 99/99/9999"	SIZE 40,10  PIXEL Valid DataValida(ctod(_cCampo5))  
//   @ 140,120 Get _cCampo6 	Picture "@!"			SIZE 40,10  PIXEL 
   //FIM PERSONALIZAÇÃO NFE 2.0

   @ 160,120 BmpButton Type 1 Action Close(JANELANF)
   Activate Dialog JANELANF CENTERED

   dbSelectArea("SF1")
   dbSeek(xFilial("SF1") + _cDoc + _cSerie)

   RecLock("SF1",.F.)
	   SF1->F1_ESPECI1  := _cEspecie
	   SF1->F1_PBRUTO   := _nPBruto   
	   SF1->F1_PLIQUI   := _nPLiqui
	   SF1->F1_ZZMARCA  := _cMarca
	   SF1->F1_VOLUME1  := _nVolume
	   SF1->F1_TRANSP   := _cTransp
	   SF1->F1_ZZPLACA  := _cPlaca
       //PERSONALIZAÇÃO NFE 2.0
		SF1->F1_ZZDINUM := _cCampo1
		SF1->F1_ZZDTREG := ctod(SUBSTR(_cCampo2,1,2)+"/"+SUBSTR(_cCampo2,3,2)+"/"+SUBSTR(_cCampo2,5,4))
		SF1->F1_ZZLOCAL := _cCampo3
		SF1->F1_ZZUFDES := _cCampo4
		SF1->F1_ZZDTDES := ctod(SUBSTR(_cCampo5,1,2)+"/"+SUBSTR(_cCampo5,3,2)+"/"+SUBSTR(_cCampo5,5,4))

       //FIM PERSONALIZAÇÃO NFE 2.0
   MsUnlock()
   
EndIf
CarregaMsg ()					// Recupera as mensagens informadas no TES / Produto / Pedido.
CadMen ()						// Informacao das Mensagens.

RestArea (_aAreaSB1)
RestArea (_aAreaSD1)
RestArea (_aAreaSF4)
RestArea (_aAreaSZZ)
RestArea (_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³ CADMEN   ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Grava‡ao de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CadMen ()

// Declaracao de variaveis:

@ 127, 015 To 182, 605 Dialog oDlg1 Title OemToAnsi ("Digitacao das mensagems da Nota Fiscal de Entrada")
@ 005, 010 Get aCod [1] Picture "@!"  F3 "SM4" Valid ValidMsg ("1")
@ 005, 040 Get aCod [2] Picture "@!"  F3 "SM4" Valid ValidMsg ("2")
@ 005, 070 Get aCod [3] Picture "@!"  F3 "SM4" Valid ValidMsg ("3")
@ 005, 100 Get aCod [4] Picture "@!"  F3 "SM4" Valid ValidMsg ("4")
@ 005, 130 Get aCod [5] Picture "@!"  F3 "SM4" Valid ValidMsg ("5")
@ 005, 160 Get aCod [6] Picture "@!"  F3 "SM4" Valid ValidMsg ("6")
@ 005, 190 Get aCod [7] Picture "@!"  F3 "SM4" Valid ValidMsg ("7")
@ 005, 220 Get aCod [8] Picture "@!"  F3 "SM4" Valid ValidMsg ("8")

@ 01,260 BMPBUTTON TYPE 11 ACTION Edmen (nVar)
@ 15,260 BMPBUTTON TYPE  1 ACTION GravMen ()
Activate Dialog oDlg1

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³ MSG      ³ Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Direcionar / Edi‡ao de Mensagens       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Alteracao feita pelo Motivo ( Descricao abaixo)            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidMsg (cVar)

nVar := Val (cVar)
lMsg := .T.
ChkMsg (nVar)

Return (lMsg)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³ CHKMSG   ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Verifica‡ao se existe a mensagem       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ChkMsg (nVar)

If !Empty (aCod [nVar])
	If Empty (Formula (aCod [nVar]))
		MsgBox ("Mensagem nao cadastrada, ou com conteudo vazio." + chr (13) + "Verifique o Cadastro de Mensagens.", "Atencao !!!", "STOP")
		lMsg := .F.
	EndIf
EndIf
Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ EDMEN    ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Editar as Mensagens N.F. de Entrada    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Edmen (nVar)

If ! empty (aCod [nVar])

	if empty (aMsg [nVar])
		cCod  := aCod [nVar]
		cMsg  := Formula (cCod) + Space (500 - Len (Formula (cCod)))

		cLin1 := Substr (cMsg, 001, 250)
		cLin2 := Substr (cMsg, 251, 250)
	else
		cLin1 := PadR (Substr (aMsg [nVar], 001, 250), 250, " ")
		cLin2 := PadR (Substr (aMsg [nVar], 251, 250), 250, " ")
	endif

	@ 200, 010 To 295,580 Dialog oDlg2 Title OemToAnsi ("Edicao de Mensagens")
	@ 010, 002 Say OemToAnsi ("Lin1")
	@ 024, 002 Say OemToAnsi ("Lin2")
	@ 010, 015 Get cLin1 Valid .T. SIZE 210, 040
	@ 024, 015 Get cLin2 Valid .T. SIZE 210, 040
	@ 010, 235 BMPBUTTON TYPE 01 ACTION MontaMsg ()
	@ 024, 235 BMPBUTTON TYPE 02 ACTION LimpaMsg ()
	Activate Dialog oDlg2

Else

	MsgStop ("Codigo da mensagem esta em branco.")

Endif

Return (Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³ MONTAMSG ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Concatenar Mensagens.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaMsg ()

aMsg [nVar] := alltrim (cLin1) + alltrim (cLin2)
Close (oDlg2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³ LIMPAMSG ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Limpar Mensagens.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LimpaMsg ()

aMsg [nVar] := space (500)
Close (oDlg2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³ GRAVMEN  ³ Autor ³ ARM Campinas          º Data ³dd/mm/aa  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GravMen ()

Local _nLinGrv :=  nK := _nX := _nSeq := 0
Local _cTexto := space (500)

For nK := 1 To 8

	if ! empty (aCod [nK])

		_cTexto		:= Alltrim (Formula (aCod [nK]))

		if ! Empty (aMsg [nK])
			_cTexto		:= Alltrim (aMsg [nK])
		Endif

		_nLinGrv := MlCount (_cTexto, 250)

		dbSelectArea ("SZZ")

		for _nX := 1 to _nLinGrv

			_nSeq := _nSeq + 1

			RecLock ("SZZ", .T.)

			SZZ -> ZZ_FILIAL 	:= xFilial("SZZ") 
			SZZ -> ZZ_TIPODOC	:= "E"		// Nota Fiscal de Entrada
			SZZ -> ZZ_DOC		:= SF1 -> F1_DOC
			SZZ -> ZZ_SERIE		:= SF1 -> F1_SERIE
			SZZ -> ZZ_CLIFOR	:= SF1 -> F1_FORNECE
			SZZ -> ZZ_LOJA		:= SF1 -> F1_LOJA
			SZZ -> ZZ_SEQMENS	:= StrZero (_nSeq, 2)
			SZZ -> ZZ_CODMENS	:= aCod [nK]
			SZZ -> ZZ_TXTMENS  := MemoLine (_cTexto, 240, _nX)

			MsUnlock ()
		Next
	Endif
Next

Close (oDlg1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao      ³CARREGAMSG³ Autor ³ ARM Campinas          º Data ³  dd/mm/aaº±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Funcao Utilizado p/ Recuperar e Permitir a edicao de       ³±±
±±³            ³ mensagens informadas no TES, nos Produtos e no Pedido.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Nota Fiscal Generica - Microsiga.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CarregaMsg ()

Local _nCont := 1		// Variavel para controlar o limite de mensagens a ser exibida na tela de selecao.

SD1 -> (dbSetOrder (1))                  
SD1 -> (dbSeek (xFilial ("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))

While SD1->(! eof ()) .and. SD1 -> D1_FILIAL  == SF1 -> F1_FILIAL ;
			   .and. SD1 -> D1_DOC     == SF1 -> F1_DOC;
			   .and. SD1 -> D1_SERIE   == SF1 -> F1_SERIE;
			   .and. SD1 -> D1_FORNECE == SF1 -> F1_FORNECE;				
			   .and. SD1 -> D1_LOJA    == SF1 -> F1_LOJA
				
	SF4 -> (dbSeek (xFilial ("SF4") + SD1 -> D1_TES))
	_nTem := aScan (aCod, SF4 -> F4_ZZMEN1)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4 -> F4_ZZMEN1
			_nCont := _nCont + 1
		endif
	endif

	_nTem := aScan (aCod, SF4 -> F4_ZZMEN2)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4 -> F4_ZZMEN2
			_nCont := _nCont + 1
		endif
	endif

	_nTem := aScan (aCod, SF4 -> F4_ZZMEN3)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4 -> F4_ZZMEN3
			_nCont := _nCont + 1
		endif
	endif

	SD1 -> (dbSkip ())
Enddo

Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FIM DO PROGRAMA                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ