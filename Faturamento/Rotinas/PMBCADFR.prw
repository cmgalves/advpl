#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PMBCADFR � Autor � Cassiano G. Ribeiro� Data �  01/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Porcentagem de Frete.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PMBCADFR()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ3"

dbSelectArea("SZ3")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Porcentagem de Frete",cVldExc,cVldAlt)

Return