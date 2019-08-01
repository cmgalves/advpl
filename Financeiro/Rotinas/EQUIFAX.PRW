#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FIMI001  º Autor ³ Paulo Bindo	     º Data ³  25/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado para exportar informacoes do cadastro de     º±±
±±º          ³ clientes e movimentacao financeira                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - SCI/Equifax                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function EQUIFAX
Private cPerg   := "GERTXT"
Private cString := "SE1"
Private oGeraTxt
SetPrvt("CPERG,NRESP,NHDL,CLIN,_SALIAS,_NTIT,_NSER,_NOMCLI")
SetPrvt("AREGS,I,J")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo Texto ")
@ 02,2 TO 090,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme as definições "
@ 18,018 Say " da empresa SCI/EQUIFAX,  com a seleção de registros do Cadastro  "
@ 26,018 Say " de Clientes (SA1) e as Movimentações Financeiras  SE1 / SE2      "
@ 70,098 BMPBUTTON TYPE 01 ACTION continua()
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeratxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
Activate Dialog oGeraTxt Centered
Return


Static Function continua()

Private cArqTxt := "C:\EQUIFAX\CLIFORCE.TXT"
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
endif

Processa({|| RunCont() },"Processando...","Selecionando Registros... ")
Return

Static Function RunCont
Local nTamLin, cLin, cCpo

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif


ProcRegua(lastRec())

cQUERY := "SELECT * FROM SE1010"
cQUERY := cQUERY + " WHERE E1_FILIAL = '"+ xFILIAL("SE1")+ "'"
cQUERY := cQUERY + " and E1_EMISSAO >= '"+ DTOS(mv_par02)+"' and E1_EMISSAO <= '"+ DTOS(mv_par01) + "'"
cQUERY := cQUERY + " and D_E_L_E_T_ <> '*'"
cQUERY := cQUERY + " ORDER BY E1_EMISSAO, E1_CLIENTE, E1_NUM "

TCQUERY cQuery New Alias "TR1"
TCSETFIELD("TR1","E1_EMISSAO","D")


While !EOF()
	
	
	posData:=SE1->E1_EMISSAO
	//	posReg:=recno()
	posCliSE1:=SE1->E1_CLIENTE
	
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+posCliSE1)
	_NOMCLI := SubStr(SE1->E1_NOMCLI,1,20)
	If SA1->A1_PESSOA #"J"
		dbSkip()
		Loop
	EndIf
	
	
	dbSelectArea("TR1")
	incproc()
	nTamLin := 1
	cLin    := Space(nTamLin)+cEOL
	_NTIT   := SE1->E1_NUM
	_NSER   := SE1->E1_PREFIXO
	
	dbselectarea("SA1")
	dbsetorder(1)
	dbseek(xfilial()+PosCliSE1)
	posCliSA1:=SA1->A1_COD
	posRegSA1:=recno()
	
	set century on
	// composicao da linha atraves de campo
	
	cCpo := PADR("J",01)   					// 1 TIPO DO REGISTRO
	cLin := Stuff(cLin,001,02,cCpo)
	cCpo := PADR(SA1->A1_CGC,14)			// 2 CNPJ
	cLin := Stuff(cLin,002,0,cCpo)
	cCpo := PADR(SA1->A1_NOME,55)			// 3 RAZAO SOCIAL
	cLin := Stuff(cLin,016,0,cCpo)
	cCpo := PADR(SA1->A1_NREDUZ,55)   		// 4 FANTASIA
	cLin := Stuff(cLin,071,0,cCpo)
	cCpo := PADR("M",1)		   				// 5 TIPO DE ENDERECO
	cLin := Stuff(cLin,126,0,cCpo)
	cCpo := PADR(SA1->A1_END,70)			// 6 ENDERECO
	cLin := Stuff(cLin,127,0,cCpo)
	cCpo := PADR(SA1->A1_MUN,30)			// 7 CIDADE
	cLin := Stuff(cLin,197,0,cCpo)
	cCpo := PADR(SA1->A1_EST,2)				// 8 UF
	cLin := Stuff(cLin,227,0,cCpo)
	cCpo := PADR(SA1->A1_CEP,08)			// 9 CEP
	cLin := Stuff(cLin,229,0,cCpo)
	// cCpo := PADR(SA1->A1_DDD,04)			// 10 DD
	cCpo := PADR(space(4),04)
	cLin := Stuff(cLin,237,0,cCpo)
	// cCpo := PADR(SA1->A1_TEL,10)			// 11 TELEFONE
	cCpo := PADR(space(10),10)
	cLin := Stuff(cLin,241,0,cCpo)
	//cCpo := PADR(SA1->A1_DDD,04)			// 12 DD FAX
	cCpo := PADR(space(4),04)
	cLin := Stuff(cLin,251,0,cCpo)
	//cCpo := PADR(SA1->A1_FAX,10)			// 13 FAX
	cCpo := PADR(space(10),10)
	cLin := Stuff(cLin,255,0,cCpo)
	cCpo := PADR(SA1->A1_EMAIL,50)			// 14 EMAIL
	cLin := Stuff(cLin,265,0,cCpo)
	cCpo := PADR(SUBST(DTOC(SA1->A1_PRICOM),4,2)+SUBST(DTOC(SA1->A1_PRICOM),7,4),6) // 15 DT PRIMEIRA FATURA
	cLin := Stuff(cLin,315,0,cCpo)
	cCpo := PADR(SE1->E1_NUM,12)			// 16 NF.NOTA FISCAL/DUPLICATA
	cLin := Stuff(cLin,321,0,cCpo)
	if SE1->E1_TIPO="NF"	  				// 17 TIPO DE DOCUMENTO(D/N/F/B/C/0)
		cCpo := PADR("F",1)
	elseif SE1->E1_TIPO="AB-" .or. SE1->E1_TIPO="NDC" .or. SE1->E1_TIPO="NCC"
		cCpo := PADR("O",1)
	elseif SE1->E1_TIPO="CH"
		cCpo := PADR("C",1)
	elseif SE1->E1_TIPO="DP"
		cCpo := PADR("D",1)
	elseif SE1->E1_TIPO="DP"
		cCpo := PADR("D",1)
	Endif
	cLin := Stuff(cLin,333,0,cCpo)
	cCpo := PADR("R$  ",04)	   								// 18 MOEDA
	cLin := Stuff(cLin,334,0,cCpo)
	
	cCpo := PADR(ltrim(STR(int(SE1->E1_VALOR))),11)			// 19 VALOR INTEIRO
	cLin := Stuff(cLin,338,0,cCpo)
	
	cPar1:= ltrim(str(SE1->E1_VALOR-int(SE1->E1_VALOR),11,2))
	cPar := subs(cpar1,3,2)
	cCpo := PADR(cPar,2)								   // 20 CENTAVOS
	cLin := Stuff(cLin,349,0,cCpo)
	
	
	cCpo := PADR(ltrim(STR(int(SE1->E1_VALLIQ))),11)		// 21 VALOR INTEIRO PAGO
	cLin := Stuff(cLin,351,0,cCpo)
	
	cPar1:= ltrim(str(SE1->E1_VALliq-int(SE1->E1_VALliq),11,2))
	cPar := subs(cpar1,3,2)
	cCpo := PADR(cPar,2)
	cLin := Stuff(cLin,362,0,cCpo)								// 22 CENTAVOS PAGO
	
	if SE1->E1_BAIXA < SE1->E1_VENCTO
		cPart:=subs(dtoc(SE1->E1_EMISSAO),1,2)+subs(dtoc(SE1->E1_EMISSAO),4,2)+subs(dtoc(SE1->E1_EMISSAO),7,4)
		cCpo := PADR(cPart,8	) 									// 23 DATA VENDA
		cLin := Stuff(cLin,364,0,cCpo)
	Else
		cCpo:= padr(space(08),8)
		cLin := Stuff(cLin,364,0,cCpo)
	Endif
	cPart:=subs(dtoc(SE1->E1_VENCTO),1,2)+subs(dtoc(SE1->E1_VENCTO),4,2)+subs(dtoc(SE1->E1_VENCTO),7,4)
	cCpo := PADR(cPart,8)							   			// 24 DATA DE VENCIMENTO
	cLin := Stuff(cLin,372,0,cCpo)
	cPart:=subs(dtoc(SE1->E1_BAIXA),1,2)+subs(dtoc(SE1->E1_BAIXA),4,2)+subs(dtoc(SE1->E1_BAIXA),7,4)
	cCpo := PADR(cPart,8)										// 25 DATA DE PAGAMENTO
	cLin := Stuff(cLin,380,0,cCpo)
	if len(clin)>388
		clin:=subs(clin,1,388)
	endif
	set century off
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)    				 //Gravacao do arquivo
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
			Exit
		Endif
	Endif
	dbSelectArea("TR1")
	dbSkip()
	
Enddo
dbCloseArea()
msgalert("O arquivo CLIFORCE foi Gerado no Seu Disco Local! ","Querido Usuario")
fClose(nHdl)
Close(oGeraTxt)
Return

