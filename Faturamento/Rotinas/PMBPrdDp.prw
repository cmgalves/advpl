#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/09/00
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PRO_DUP  � Autor � Marcos                � Data � 22.11.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � CHECAR SE UM DETERMINADO PRODUTO JA FOI DIGITADO NO PEDIDO ���
���          � ATUALIZAR A DATA DA ENTREGA COM A DO 1@ ITEM DO PV         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DIGITACAO DO PEDIDO DE VENDA                               ���
�������������������������������������������������������������������������Ĵ��
���ALTERACOES�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Pro_Dup()
Local xnPosProd  := 	GDFieldPos("C6_PRODUTO")

SetPrvt("NI,NJ,lReturn,NQtdPro,NQtdPO,nProduto,cCOD")
SetPrvt("ACOLS")

nI       := 0
nJ       := 0
nQtdPro  := 0
NQtdPO   := 1
nProduto := 0
cCOD     := ""
IF Len(aCols) > 1
	FOR nI := 1 to LEN(aHeader)
		If Trim(aHeader[nI][2]) == "C6_PRODUTO"
			nPRODUTO := nI
			cCOD     := ACOLS[N][nI]
		Endif
	NEXT
	FOR nJ := 1 TO LEN(ACOLS)
		If aCols[nJ][nProduto] == M->C6_PRODUTO .and. !aCols[nJ][Len(aCols[nJ])]
			nQtdPro := nQtdPro + 1
		EndIf
	Next
	If nQtdPro > 1 //.AND. LEFT(M->C6_PRODUTO,1) $ "67" //.AND. M->C5_DEP_COM != "3"
		IF !Alltrim(FUNNAME())$"MBINCPED | MBJOBSFA"
			MsgStop("Produto ja Digitado em Item Anterior")
		ENDIF
		M->C6_PRODUTO := ""
		M->C6_DESCRI := ""
		nQtdPro  := 0
	EndIf
EndIf

If aCols[n,xnPosProd] == '1'
	MsgStop("Produto Fora de Linha")
	M->C6_PRODUTO := ""
	M->C6_DESCRI := ""
EndIf


Return (M->C6_PRODUTO)
