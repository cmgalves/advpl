#Include "rwmake.ch"
#Include "topconn.ch"
#Include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EXESTREQ �Autor  � Joaquim Novaes Jr  � Data �  04/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza estorno de requisicoes geradas a partir da rotina  ���
���          � MBGERAREQ.PRW                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MBESTREQ(cOp,dDatade,dDataAte)

Default cOp := ""
Default dDataDe := Ctod('01/01/14')
Default dDataAte := Ctod('31/03/14')

Processa({||MBESTRE1(cOp,dDataDe,dDataAte)},"Estornando requisicoes indevidas...")

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MBESTRE1 �Autor  � Joaquim Novaes     � Data �  04/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de estorno.                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MBESTRE1(cOp,dDataDe,dDataAte)
Local cQuery := ""
Local dDataOP := Ctod('')

SC2->(dbSetOrder(1))

cQuery := "SELECT *"+Chr(13)+Chr(10)
cQuery += " FROM "+RetSqlName("SD3")+" SD3"+Chr(13)+Chr(10)
cQuery += " WHERE"+Chr(13)+Chr(10)
cQuery += " D3_EMISSAO >= '"+Dtos(dDatade)+"' AND"+Chr(13)+Chr(10)
cQuery += " D3_EMISSAO <= '"+Dtos(dDataAte)+"' AND"+Chr(13)+Chr(10)
If !Empty(cOp)
	cQuery += " D3_OP = '"+cOp+"' AND"+Chr(13)+Chr(10)
EndIf
cQuery += " D3_TM = '504' AND"+Chr(13)+Chr(10)
cQuery += " SUBSTRING(D3_COD,1,3) <> 'MOD' AND"+Chr(13)+Chr(10)
cQuery += " D3_ESTORNO = '' AND"+Chr(13)+Chr(10)
cQuery += " D3_USUARIO = 'MBGERAREQ' AND"
cQuery += " D3_NUMSEQ NOT IN ("+Chr(13)+Chr(10)
cQuery += " 	SELECT D3_NUMSEQ"+Chr(13)+Chr(10)
cQuery += " 	FROM "+RetSqlName("SD3")+" SD3AUX"+Chr(13)+Chr(10)
cQuery += " 	WHERE"+Chr(13)+Chr(10)
cQuery += " 	SD3AUX.D3_FILIAL = SD3.D3_FILIAL AND"+Chr(13)+Chr(10)
cQuery += " 	SD3AUX.D3_OP = SD3.D3_OP AND"+Chr(13)+Chr(10)
cQuery += " 	SD3AUX.D3_NUMSEQ = SD3.D3_NUMSEQ AND"+Chr(13)+Chr(10)
cQuery += " 	SD3AUX.D3_TM = '012' AND"+Chr(13)+Chr(10)
cQuery += " 	SD3AUX.D_E_L_E_T_ = ''"+Chr(13)+Chr(10)
cQuery += " ) AND"+Chr(13)+Chr(10)
cQuery += " SD3.D_E_L_E_T_ = ''"+Chr(13)+Chr(10)
cQuery += " ORDER BY D3_EMISSAO DESC"
TcQuery cQuery New Alias "QREQ"
Count To nTotal
ProcRegua(nTotal)

QREQ->(dbGoTop())
While !QREQ->(EOF())

	IncProc()
	
	SC2->(dbSeek(xFilial("SC2")+AllTrim(QREQ->D3_OP)))
	aAreaSC2 := SC2->(GetARea())
	dDataOp := 	SC2->C2_DATRF
	RecLock("SC2",.F.)      
	SC2->C2_DATRF := Ctod('')
	MsUnlock()
	
	lMsErroAuto := .F.
	aProd:={}
	
	aAdd(aProd, {"D3_NUMSEQ" , QREQ->D3_NUMSEQ   , Nil})
	aAdd(aProd, {"INDEX"     , 4        , Nil})
	
	MSExecAuto({|x,y| MATA240(x,y)}, aProd, 5) //5-Estorno
	
	If lMsErroAuto
		MostraErro()
	Endif
	
	RestArea(aAreaSC2)
	RecLock("SC2",.F.)      
	SC2->C2_DATRF := dDataOp
	MsUnlock()
	
	QREQ->(dbskip())
Enddo

QREQ->(dbCloseArea())

Return
