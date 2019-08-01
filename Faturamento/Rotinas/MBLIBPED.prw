#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MBLIBPED  �Autor  �Claudio Alves       � Data �  19/03/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Libera��o de Pedidos                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �SIGAFIN                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MBLIBPED()

If PswRet()[1][1] $ " 000009 | 000012 | 000013 "
//If PswRet()[1][2]$GetMV("MV_USERLIB")
	FATA210() // LIBERA��O DE REGRAS
//EndIf

	MATA440()	// LIBERA��O DO PEDIDO
	MATA455()	// LIBERA��O DO ESTOQUE

EndIf
If PswRet()[1][1] $ " 000009 | 000000 | 000012 | 000013 "

	U_MBLibCred()	// LIBERA��O DO CR�DITO
	
EndIf

Return